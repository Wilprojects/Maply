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
                        locationCardSection(availableHeight: geometry.size.height)
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
    
    func locationCardSection(availableHeight: CGFloat) -> some View {
        let headerHeight: CGFloat = 165
        let mapHeight: CGFloat = 272
        let overlap: CGFloat = 18
        
        let cardHeight = max(
            availableHeight - headerHeight - mapHeight + overlap,
            320
        )
        
        return VStack(spacing: 14) {
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
            .padding(.top, 2)
            
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
                .padding(.top, 4)
        }
        .padding(.horizontal, 16)
        .padding(.top, 18)
        .padding(.bottom, 18)
        .frame(maxWidth: .infinity)
        .frame(height: cardHeight, alignment: .top)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(AppColors.pageBackground)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: -2)
        )
        .offset(y: -18)
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
                locationName = ""
                locationAddress = ""
                isShowingSaveLocationSheet = true
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
                }
                
                HStack(spacing: 12) {
                    Button {
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
                        locationName.trimmingCharacters(in: .whitespaces).isEmpty ||
                        locationAddress.trimmingCharacters(in: .whitespaces).isEmpty
                    )
                    .opacity(
                        locationName.isEmpty || locationAddress.isEmpty ? 0.6 : 1
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
