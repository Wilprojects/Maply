//
//  PrivacyView.swift
//  Maply
//
//  Created by Wilder Moreno on 26/04/26.
//

import SwiftUI
import CoreLocation

struct PrivacyView: View {
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                statusCard
                explanationCard
                actionsCard
            }
            .padding(16)
            .padding(.bottom, 24)
        }
        .background(AppColors.pageBackground)
        .navigationTitle("Privacidad")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if locationManager.isLocationAuthorized {
                locationManager.startUpdatingLocation()
            }
        }
    }
}

#Preview {
    NavigationStack {
        PrivacyView()
    }
}

private extension PrivacyView {
    var statusCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Permiso de ubicación")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Color.black.opacity(0.85))
            
            HStack(spacing: 12) {
                Image(systemName: iconNameForStatus)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(iconColorForStatus)
                    .frame(width: 44, height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(iconColorForStatus.opacity(0.14))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(locationManager.authorizationStatusText)
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.black.opacity(0.82))
                    
                    Text(statusDescription)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(AppColors.secondaryText)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(AppColors.cardBackground.opacity(0.92))
        )
    }
    
    var explanationCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Uso de la ubicación")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Color.black.opacity(0.85))
            
            Text("Maply utiliza tu ubicación para centrar el mapa en tu posición actual, mostrar tu ubicación en pantalla y permitirte guardar lugares cercanos en el dispositivo.")
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(Color.black.opacity(0.78))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(AppColors.cardBackground.opacity(0.92))
        )
    }
    
    var actionsCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Acciones")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Color.black.opacity(0.85))
            
            if locationManager.canRequestLocationPermission {
                Button {
                    locationManager.requestWhenInUseAuthorization()
                } label: {
                    actionButtonLabel(
                        title: "Solicitar permiso",
                        icon: "location.fill",
                        color: AppColors.primaryBlue
                    )
                }
                .buttonStyle(.plain)
            }
            
            if locationManager.shouldShowOpenSettings {
                Button {
                    openAppSettings()
                } label: {
                    actionButtonLabel(
                        title: "Abrir Ajustes del sistema",
                        icon: "gearshape.fill",
                        color: AppColors.primaryTeal
                    )
                }
                .buttonStyle(.plain)
            }
            
            if locationManager.isLocationAuthorized {
                Button {
                    locationManager.startUpdatingLocation()
                } label: {
                    actionButtonLabel(
                        title: "Actualizar ubicación",
                        icon: "arrow.clockwise",
                        color: AppColors.primaryGreen
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(AppColors.cardBackground.opacity(0.92))
        )
    }
    
    func actionButtonLabel(title: String, icon: String, color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 38, height: 38)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(color)
                )
            
            Text(title)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.black.opacity(0.82))
            
            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(0.8))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.black.opacity(0.04), lineWidth: 1)
                )
        )
    }
    
    var iconNameForStatus: String {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            return "questionmark.circle.fill"
        case .restricted:
            return "exclamationmark.shield.fill"
        case .denied:
            return "location.slash.fill"
        case .authorizedWhenInUse, .authorizedAlways:
            return "location.fill"
        @unknown default:
            return "questionmark.circle.fill"
        }
    }
    
    var iconColorForStatus: Color {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            return AppColors.primaryBlue
        case .restricted, .denied:
            return .red
        case .authorizedWhenInUse, .authorizedAlways:
            return AppColors.primaryGreen
        @unknown default:
            return AppColors.primaryBlue
        }
    }
    
    var statusDescription: String {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            return "La app todavía no ha solicitado acceso a tu ubicación."
        case .restricted:
            return "El acceso está restringido por el sistema o control parental."
        case .denied:
            return "Has denegado el acceso. Puedes cambiarlo desde Ajustes."
        case .authorizedWhenInUse:
            return "La app puede usar tu ubicación mientras está abierta."
        case .authorizedAlways:
            return "La app tiene acceso a tu ubicación incluso fuera de uso."
        @unknown default:
            return "Estado no reconocido por la aplicación."
        }
    }
    
    func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}
