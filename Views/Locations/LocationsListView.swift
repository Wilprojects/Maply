//
//  LocationsListView.swift
//  Maply
//
//  Created by Wilder Moreno on 19/04/26.
//

import SwiftUI
import SwiftData

struct LocationsListView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \SavedLocationItem.createdAt, order: .reverse)
    private var savedLocations: [SavedLocationItem]
    
    @State private var isShowingDeleteConfirmation = false
    @State private var locationToDelete: SavedLocationItem?
    
    @State private var isShowingFilterPopup = false
    @State private var selectedFilter: LocationFilter = .all
    
    private var filteredLocations: [SavedLocationItem] {
        switch selectedFilter {
        case .all:
            return savedLocations
        case .blue:
            return savedLocations.filter { $0.colorHex == "blue" }
        case .green:
            return savedLocations.filter { $0.colorHex == "green" }
        case .teal:
            return savedLocations.filter { $0.colorHex == "teal" }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                AppColors.pageBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerSection
                    
                    VStack(spacing: 18) {
                        sectionTitle
                        
                        if filteredLocations.isEmpty {
                            emptyStateView
                        } else {
                            locationsList
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }
                if isShowingFilterPopup {
                    filterPopupOverlay
                }
            }
            .ignoresSafeArea(edges: .top)
            .navigationBarHidden(true)
            .alert("Eliminar ubicación", isPresented: $isShowingDeleteConfirmation, presenting: locationToDelete) { location in
                Button("Cancelar", role: .cancel) { }
                
                Button("Eliminar", role: .destructive) {
                    deleteLocation(location)
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
    LocationsListView()
}

private extension LocationsListView {
    enum LocationFilter {
        case all
        case blue
        case green
        case teal
    }
    
    var headerSection: some View {
        AppHeaderView(
            subtitle: "Tus lugares",
            title: "Ubicaciones",
            showsFilterButton: false
        )
    }
    
    var sectionTitle: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Ubicaciones guardadas")
                    .font(.system(size: 21, weight: .bold, design: .rounded))
                    .foregroundStyle(AppColors.primaryText)
                
                Text(filterTitle)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(AppColors.secondaryText)
            }
            
            Spacer()
            
            Button {
                withAnimation(.spring(duration: 0.28)) {
                    isShowingFilterPopup = true
                }
            } label: {
                Image(systemName: selectedFilter == .all ? "slider.horizontal.3" : "line.3.horizontal.decrease.circle.fill")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(selectedFilter == .all ? AppColors.mutedText : AppColors.primaryBlue)
                    .frame(width: 38, height: 38)
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
    
    var filterPopupOverlay: some View {
        ZStack {
            Color.black.opacity(0.28)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring(duration: 0.25)) {
                        isShowingFilterPopup = false
                    }
                }
            
            VStack(spacing: 18) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Filtrar ubicaciones")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundStyle(AppColors.primaryText)
                        
                        Text("Selecciona cómo deseas ver tus lugares guardados")
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundStyle(AppColors.secondaryText)
                    }
                    
                    Spacer()
                    
                    Button {
                        withAnimation(.spring(duration: 0.25)) {
                            isShowingFilterPopup = false
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(AppColors.primaryText.opacity(0.75))
                            .frame(width: 34, height: 34)
                            .background(
                                Circle()
                                    .fill(AppColors.cardBackground.opacity(0.96))
                                    .overlay(
                                        Circle()
                                            .stroke(AppColors.dividerColor, lineWidth: 1)
                                    )
                            )
                    }
                    .buttonStyle(.plain)
                }
                
                VStack(spacing: 10) {
                    filterOptionButton(title: "Todas", filter: .all, color: AppColors.primaryBlue)
                    filterOptionButton(title: "Azules", filter: .blue, color: AppColors.primaryBlue)
                    filterOptionButton(title: "Verdes", filter: .green, color: AppColors.primaryGreen)
                    filterOptionButton(title: "Teal", filter: .teal, color: AppColors.primaryTeal)
                }
                
                Button {
                    withAnimation(.spring(duration: 0.25)) {
                        isShowingFilterPopup = false
                    }
                } label: {
                    Text("Cerrar")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(AppColors.darkSurface)
                        )
                }
                .buttonStyle(.plain)
            }
            .padding(20)
            .frame(width: 340)
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(AppColors.pageBackground)
                    .shadow(color: .black.opacity(0.18), radius: 20, x: 0, y: 10)
            )
            .padding(.horizontal, 24)
            .transition(.scale(scale: 0.96).combined(with: .opacity))
        }
    }
    
    func filterOptionButton(title: String, filter: LocationFilter, color: Color) -> some View {
        let isSelected = selectedFilter == filter
        
        return Button {
            selectedFilter = filter
            
            withAnimation(.spring(duration: 0.25)) {
                isShowingFilterPopup = false
            }
        } label: {
            HStack(spacing: 12) {
                Circle()
                    .fill(isSelected ? color : AppColors.mutedText.opacity(0.22))
                    .frame(width: 12, height: 12)
                
                Text(title)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundStyle(AppColors.primaryText)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(color)
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 54)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(AppColors.cardBackground.opacity(0.96))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(
                                isSelected ? color.opacity(0.35) : AppColors.dividerColor,
                                lineWidth: 1
                            )
                    )
            )
        }
        .buttonStyle(.plain)
    }
    
    var filterTitle: String {
        switch selectedFilter {
        case .all:
            return "Mostrando todas"
        case .blue:
            return "Filtro: azules"
        case .green:
            return "Filtro: verdes"
        case .teal:
            return "Filtro: teal"
        }
    }
    
    var emptyStateView: some View {
        VStack(spacing: 14) {
            Image(systemName: "mappin.slash")
                .font(.system(size: 34, weight: .semibold))
                .foregroundStyle(AppColors.secondaryText.opacity(0.8))
            
            Text("No hay ubicaciones")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(AppColors.primaryText.opacity(0.95))
            
            Text("No hay resultados para el filtro seleccionado.")
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 50)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(AppColors.cardBackground.opacity(0.96))
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(AppColors.dividerColor, lineWidth: 1)
                )
        )
    }
    
    var locationsList: some View {
        List {
            ForEach(filteredLocations) { location in
                locationCard(location: location)
                    .listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0))
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color.clear)
    }
    
    func locationCard(location: SavedLocationItem) -> some View {
        NavigationLink {
            LocationDetailView(location: location)
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "mappin.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 38, height: 38)
                    .foregroundStyle(colorForHex(location.colorHex), colorForHex(location.colorHex).opacity(0.18))
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(location.name)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(AppColors.primaryText.opacity(0.95))
                        .lineLimit(1)
                    
                    Text(location.address)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(AppColors.secondaryText)
                        .lineLimit(1)
                }
                
                Spacer()
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(AppColors.cardBackground.opacity(0.96))
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(AppColors.dividerColor, lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
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
    
    func confirmDeleteLocation(_ location: SavedLocationItem) {
        locationToDelete = location
        isShowingDeleteConfirmation = true
    }
    
    func deleteLocation(_ location: SavedLocationItem) {
        modelContext.delete(location)
        locationToDelete = nil
    }
}
