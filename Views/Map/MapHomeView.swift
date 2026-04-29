//
//  MapHomeView.swift
//  Maply
//
//  Created by Wilder Moreno on 19/04/26.
//

import SwiftUI
import MapKit
import SwiftData

struct MapHomeView: View {
    
    @StateObject private var locationManager = LocationManager()
    
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \SavedLocationItem.createdAt, order: .reverse)
    private var savedLocations: [SavedLocationItem]
    
    @State private var isShowingSaveLocationSheet = false
    @State private var locationName = ""
    @State private var locationAddress = ""
    @State private var isResolvingAddress = false
    @State private var geocodingErrorMessage = ""
    @State private var searchTask: Task<Void, Never>?
    @State private var addressSuggestions: [AddressSuggestion] = []
    @State private var isSearchingSuggestions = false
    @State private var isSelectingSuggestion = false
    
    @State private var isShowingDeleteConfirmation = false
    @State private var locationToDelete: SavedLocationItem?
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack(alignment: .top) {
                    AppColors.pageBackground
                        .ignoresSafeArea(edges: .top)
                    
                    VStack(spacing: 0) {
                        headerSection
                        mapSection
                        locationCardSection()
                    }
                    
                    if isShowingSaveLocationSheet {
                        saveLocationPopup
                    }
                }
                .ignoresSafeArea(edges: .top)
                .navigationBarHidden(true)
            }
            .onAppear {
                locationManager.refreshAuthorizationStatus()
                locationManager.requestWhenInUseAuthorizationIfNeeded()
                locationManager.startUpdatingLocationIfAuthorized()
            }
            .alert("Eliminar ubicación", isPresented: $isShowingDeleteConfirmation, presenting: locationToDelete) { location in
                Button("Cancelar", role: .cancel) { }
                
                Button("Eliminar", role: .destructive) {
                    deleteLocation(location)
                    locationToDelete = nil
                }
            } message: { location in
                Text("¿Deseas eliminar \"\(location.name)\"? Esta acción no se puede deshacer.")
            }
        }
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 90)
        }
    }
}

#Preview {
    MapHomeView()
}


private extension MapHomeView {
    var headerSection: some View {
        AppHeaderView(
            subtitle: "Bienvenido a Maply",
            title: "Wilder",
            showsFilterButton: false
        )
    }
    
    var mapSection: some View {
        ZStack {
            if locationManager.isLocationAuthorized {
                authorizedMapSection
            } else {
                locationPermissionStateView
            }
        }
        .frame(height: 272)
        .clipped()
    }
    
    var authorizedMapSection: some View {
        Map(position: $locationManager.cameraPosition) {
            UserAnnotation()
            
            ForEach(savedLocations) { location in
                Annotation(location.name, coordinate: location.coordinate) {
                    mapPinView(color: colorForHex(location.colorHex))
                }
            }
        }
        .mapStyle(.standard)
        .overlay(alignment: .bottomTrailing) {
            locationPointButton
                .padding(.trailing, 22)
                .padding(.bottom, 32)
        }
    }
    
    var locationPermissionStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: permissionStateIconName)
                .font(.system(size: 38, weight: .semibold))
                .foregroundStyle(permissionStateColor)
                .frame(width: 72, height: 72)
                .background(
                    Circle()
                        .fill(permissionStateColor.opacity(0.14))
                )
            
            VStack(spacing: 8) {
                Text(permissionStateTitle)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(AppColors.primaryText)
                
                Text(locationManager.locationErrorMessage)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            if locationManager.canRequestLocationPermission {
                Button {
                    locationManager.requestWhenInUseAuthorizationIfNeeded()
                } label: {
                    Text("Permitir ubicación")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(height: 46)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(AppColors.primaryBlue)
                        )
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 24)
            }
            
            if locationManager.shouldShowOpenSettings {
                Button {
                    openAppSettings()
                } label: {
                    Text("Abrir Ajustes")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(height: 46)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(AppColors.primaryTeal)
                        )
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 24)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(permissionBackgroundGradient)
    }
    
    var permissionBackgroundGradient: LinearGradient {
        LinearGradient(
            colors: [
                AppColors.inputBackground,
                AppColors.cardBackground
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    var permissionStateTitle: String {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            return "Permiso pendiente"
        case .denied:
            return "Ubicación denegada"
        case .restricted:
            return "Ubicación restringida"
        default:
            return "Ubicación no disponible"
        }
    }
    
    var permissionStateIconName: String {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            return "location.circle.fill"
        case .denied:
            return "location.slash.circle.fill"
        case .restricted:
            return "exclamationmark.shield.fill"
        default:
            return "location.slash.circle.fill"
        }
    }
    
    var permissionStateColor: Color {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            return AppColors.primaryBlue
        case .denied, .restricted:
            return .red
        default:
            return AppColors.primaryBlue
        }
    }
    
    func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
    
    func locationCardSection() -> some View {
        VStack(spacing: 14) {
            headerRow
            
            List {
                ForEach(savedLocations) { location in
                    locationRow(location: location)
                        .listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            
            saveLocationSection
        }
        .padding(.horizontal, 16)
        .padding(.top, 18)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(AppColors.pageBackground)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: -2)
        )
        .offset(y: -18)
    }
    
    func prepareSaveLocationForm() {
        locationName = ""
        locationAddress = ""
        geocodingErrorMessage = ""
        addressSuggestions = []
        searchTask?.cancel()
        isShowingSaveLocationSheet = true
        
        guard let location = locationManager.currentLocation else {
            geocodingErrorMessage = "No se pudo obtener tu ubicación actual."
            return
        }
        
        isResolvingAddress = true
        
        Task {
            do {
                let place = try await GeoapifyGeocodingService.shared.reverseGeocode(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude
                )

                await MainActor.run {
                    if locationName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        locationName = place.suggestedName
                    }
                    
                    locationAddress = place.suggestedAddress
                    isResolvingAddress = false
                }
            } catch {
                await MainActor.run {
                    geocodingErrorMessage = error.localizedDescription
                    isResolvingAddress = false
                }
            }
        }
    }
    
    
    func searchAddressSuggestions(for query: String) {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        searchTask?.cancel()
        
        guard !trimmedQuery.isEmpty else {
            addressSuggestions = []
            isSearchingSuggestions = false
            return
        }
        
        isSearchingSuggestions = true
        geocodingErrorMessage = ""
        
        let currentLatitude = locationManager.currentLocation?.coordinate.latitude
        let currentLongitude = locationManager.currentLocation?.coordinate.longitude
        
        searchTask = Task {
            do {
                try await Task.sleep(nanoseconds: 350_000_000)
                
                guard !Task.isCancelled else { return }
                
                let suggestions = try await GeoapifyGeocodingService.shared.autocomplete(
                    text: trimmedQuery,
                    biasLatitude: currentLatitude,
                    biasLongitude: currentLongitude
                )
                
                guard !Task.isCancelled else { return }
                
                await MainActor.run {
                    addressSuggestions = suggestions
                    isSearchingSuggestions = false
                }
            } catch is CancellationError {
                return
            } catch {
                await MainActor.run {
                    addressSuggestions = []
                    isSearchingSuggestions = false
                    geocodingErrorMessage = "No se pudieron obtener sugerencias."
                }
            }
        }
    }
    
    
    func selectSuggestion(_ suggestion: AddressSuggestion) {
        isSelectingSuggestion = true
        
        if locationName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            locationName == "Nueva ubicación" {
            locationName = suggestion.name
        }
        
        locationAddress = suggestion.address
        addressSuggestions = []
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isSelectingSuggestion = false
        }
    }
}


private extension MapHomeView {
    var locationPointButton: some View {
        Button {
            locationManager.recenterOnUser()
        } label: {
            Image(systemName: "location.north.fill")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.red, AppColors.mutedText.opacity(0.2))
                .frame(width: 66, height: 66)
                .background(AppColors.cardBackground)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 6)
        }
    }
    
    func mapPinView(color: Color) -> some View {
        Image(systemName: "mappin.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 34, height: 34)
            .foregroundStyle(color, color.opacity(0.18))
            .shadow(color: .black.opacity(0.14), radius: 4, x: 0, y: 2)
    }
}

private extension MapHomeView {
    func locationRow(location: SavedLocationItem) -> some View {
        NavigationLink {
            LocationDetailView(location: location)
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "mappin.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 34, height: 34)
                    .foregroundStyle(colorForHex(location.colorHex), colorForHex(location.colorHex).opacity(0.18))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(location.name)
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundStyle(AppColors.primaryText.opacity(0.95))
                        .lineLimit(1)
                    
                    Text(location.address)
                        .font(.system(size: 13.5, weight: .medium, design: .rounded))
                        .foregroundStyle(AppColors.secondaryText)
                        .lineLimit(1)
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 13)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(AppColors.cardBackground.opacity(0.96))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(AppColors.dividerColor, lineWidth: 1)
                )
        )
        .buttonStyle(.plain)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                confirmDeleteLocation(location)
            } label: {
                Label("Eliminar", systemImage: "trash")
            }
        }
    }
    
    var headerRow: some View {
        HStack {
            Text("Mi Ubicación")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(AppColors.primaryText)
            
            Spacer()
            
            HStack(spacing: 6) {
                Circle().fill(AppColors.mutedText.opacity(0.55)).frame(width: 6, height: 6)
                Circle().fill(AppColors.mutedText.opacity(0.55)).frame(width: 6, height: 6)
                Circle().fill(AppColors.mutedText.opacity(0.55)).frame(width: 6, height: 6)
            }
        }
    }
    
    var saveLocationSection: some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(AppColors.cardBackground.opacity(0.96))
                    .frame(width: 60, height: 52)
                
                Image(systemName: "mappin.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(AppColors.primaryBlue, AppColors.primaryBlue.opacity(0.18))
            }
            
            Button {
                prepareSaveLocationForm()
            } label: {
                HStack {
                    Spacer()
                    
                    Text("Guardar ubicación")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white.opacity(0.96))
                        .padding(.trailing, 16)
                }
                .frame(height: 52)
                .background(
                    LinearGradient(
                        colors: [AppColors.primaryTeal, AppColors.primaryBlue],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: AppColors.primaryBlue.opacity(0.22), radius: 8, x: 0, y: 5)
            }
        }
        .padding(.bottom, 6)
    }
    
    func saveCurrentLocation(name: String, address: String) {
        guard let location = locationManager.currentLocation else { return }
        
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedAddress = address.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty, !trimmedAddress.isEmpty else { return }
        
        let newLocation = SavedLocationItem(
            name: trimmedName,
            address: trimmedAddress,
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            colorHex: "blue"
        )
        
        modelContext.insert(newLocation)
        
        let notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        if notificationsEnabled {
            Task {
                await NotificationManager.shared.scheduleLocationSavedNotification(
                    name: trimmedName,
                    address: trimmedAddress
                )
            }
        }
    }
    
    func colorForHex(_ colorHex: String) -> Color {
        switch colorHex {
        case "teal":
            return AppColors.primaryTeal
        case "green":
            return AppColors.primaryGreen
        case "blue":
            return AppColors.primaryBlue
        default:
            return AppColors.primaryBlue
        }
    }
    
    func deleteLocation(_ location: SavedLocationItem) {
        modelContext.delete(location)
        locationToDelete = nil
    }
    
    func confirmDeleteLocation(_ location: SavedLocationItem) {
        locationToDelete = location
        isShowingDeleteConfirmation = true
    }
}


private extension MapHomeView {
    var saveLocationPopup: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    searchTask?.cancel()
                    addressSuggestions = []
                    isShowingSaveLocationSheet = false
                }
            
            VStack(spacing: 20) {
                Text("Nueva ubicación")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(AppColors.primaryText)
                
                VStack(spacing: 12) {
                    TextField("Nombre de la ubicación", text: $locationName)
                        .padding()
                        .foregroundStyle(AppColors.primaryText)
                        .tint(AppColors.primaryBlue)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.inputBackground)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(AppColors.dividerColor, lineWidth: 1)
                        )
                    
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("Dirección o referencia", text: $locationAddress)
                            .padding()
                            .foregroundStyle(AppColors.primaryText)
                            .tint(AppColors.primaryBlue)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(AppColors.inputBackground)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(AppColors.dividerColor, lineWidth: 1)
                            )
                            .onChange(of: locationAddress) { _, newValue in
                                guard !isSelectingSuggestion else { return }
                                searchAddressSuggestions(for: newValue)
                            }
                        
                        if isResolvingAddress {
                            HStack(spacing: 8) {
                                ProgressView()
                                    .scaleEffect(0.9)
                                
                                Text("Obteniendo dirección desde Geoapify...")
                                    .font(.system(size: 13, weight: .medium, design: .rounded))
                                    .foregroundStyle(AppColors.secondaryText)
                            }
                        }
                        
                        if isSearchingSuggestions {
                            HStack(spacing: 8) {
                                ProgressView()
                                    .scaleEffect(0.85)
                                
                                Text("Buscando sugerencias...")
                                    .font(.system(size: 13, weight: .medium, design: .rounded))
                                    .foregroundStyle(AppColors.secondaryText)
                            }
                        }
                        
                        if !addressSuggestions.isEmpty {
                            VStack(spacing: 8) {
                                ForEach(addressSuggestions) { suggestion in
                                    Button {
                                        selectSuggestion(suggestion)
                                    } label: {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(suggestion.name)
                                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                                .foregroundStyle(AppColors.primaryText)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            Text(suggestion.address)
                                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                                .foregroundStyle(AppColors.secondaryText)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .lineLimit(2)
                                        }
                                        .padding(12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                .fill(AppColors.cardBackground.opacity(0.96))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                        .stroke(AppColors.dividerColor, lineWidth: 1)
                                                )
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        
                        if !geocodingErrorMessage.isEmpty {
                            Text(geocodingErrorMessage)
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .foregroundStyle(.red)
                        }
                    }
                }
                
                HStack(spacing: 12) {
                    Button {
                        searchTask?.cancel()
                        addressSuggestions = []
                        isShowingSaveLocationSheet = false
                    } label: {
                        Text("Cancelar")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundStyle(AppColors.primaryText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(AppColors.cardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(AppColors.dividerColor, lineWidth: 1)
                                    )
                            )
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        saveCurrentLocation(name: locationName, address: locationAddress)
                        isShowingSaveLocationSheet = false
                    } label: {
                        Text("Guardar")
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(AppColors.primaryBlue)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                    .disabled(
                        locationName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                        locationAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                        isResolvingAddress
                    )
                    .opacity(
                        locationName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                        locationAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                        isResolvingAddress ? 0.6 : 1
                    )
                }
            }
            .padding(20)
            .frame(width: 320)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.pageBackground)
            )
            .shadow(radius: 20)
        }
    }
}
