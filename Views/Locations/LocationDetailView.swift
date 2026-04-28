//
//  LocationDetailView.swift
//  Maply
//
//  Created by Wilder Moreno on 26/04/26.
//

import SwiftUI
import MapKit

struct LocationDetailView: View {
    let location: SavedLocationItem
    @State private var cameraPosition: MapCameraPosition
    
    init(location: SavedLocationItem) {
        self.location = location
        
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: location.latitude,
                longitude: location.longitude
            ),
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )
        
        _cameraPosition = State(initialValue: .region(region))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerCard
                miniMapCard
                infoCard
                coordinatesCard
            }
            .padding(16)
            .padding(.bottom, 24)
        }
        .background(AppColors.pageBackground)
        .navigationTitle("Detalle")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let previewLocation = SavedLocationItem(
        name: "Work Café",
        address: "Av. Providencia 1234",
        latitude: -8.1095,
        longitude: -79.0282,
        colorHex: "teal"
    )
    
    NavigationStack {
        LocationDetailView(location: previewLocation)
    }
}

private extension LocationDetailView {
    var headerCard: some View {
        VStack(spacing: 16) {
            Image(systemName: "mappin.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .foregroundStyle(colorForHex(location.colorHex), colorForHex(location.colorHex).opacity(0.18))
            
            Text(location.name)
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundStyle(AppColors.primaryText)
            
            Text(location.address)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundStyle(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(AppColors.cardBackground.opacity(0.96))
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(AppColors.dividerColor, lineWidth: 1)
                )
        )
    }
    
    var miniMapCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Ubicación en el mapa")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(AppColors.primaryText)
            
            Map(position: $cameraPosition) {
                Annotation(location.name, coordinate: location.coordinate) {
                    Image(systemName: "mappin.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
                        .foregroundStyle(colorForHex(location.colorHex), colorForHex(location.colorHex).opacity(0.18))
                }
            }
            .mapStyle(.standard)
            .frame(height: 220)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(AppColors.cardBackground.opacity(0.96))
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(AppColors.dividerColor, lineWidth: 1)
                )
        )
    }
    
    var infoCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Información")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(AppColors.primaryText)
            
            detailRow(title: "Nombre", value: location.name)
            detailRow(title: "Dirección", value: location.address)
            detailRow(title: "Color", value: location.colorHex.capitalized)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(AppColors.cardBackground.opacity(0.96))
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(AppColors.dividerColor, lineWidth: 1)
                )
        )
    }
    
    var coordinatesCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Coordenadas")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(AppColors.primaryText)
            
            detailRow(
                title: "Latitud",
                value: String(format: "%.6f", location.latitude)
            )
            
            detailRow(
                title: "Longitud",
                value: String(format: "%.6f", location.longitude)
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(AppColors.cardBackground.opacity(0.96))
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(AppColors.dividerColor, lineWidth: 1)
                )
        )
    }
    
    func detailRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundStyle(AppColors.secondaryText)
            
            Text(value)
                .font(.system(size: 17, weight: .medium, design: .rounded))
                .foregroundStyle(AppColors.primaryText.opacity(0.95))
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
}
