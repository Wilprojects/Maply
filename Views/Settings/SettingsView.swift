//
//  SettingsView.swift
//  Maply
//
//  Created by Wilder Moreno on 19/04/26.
//

import SwiftUI

struct SettingsView: View {
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        
        ZStack(alignment: .top) {
            AppColors.pageBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerSection
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        profileCard

                        settingsGroup(
                            title: "Preferencias",
                            rows: [
                                settingRowData(icon: "sun.max.fill", iconColor: .orange, title: "Modo claro"),
                                settingRowData(icon: "bell.fill", iconColor: AppColors.primaryBlue, title: "Notificaciones"),
                                settingRowData(icon: "lock.fill", iconColor: AppColors.primaryTeal, title: "Privacidad")
                            ]
                        )

                        settingsGroup(
                            title: "Soporte",
                            rows: [
                                settingRowData(icon: "questionmark.circle.fill", iconColor: AppColors.primaryGreen, title: "Ayuda"),
                                settingRowData(icon: "doc.text.fill", iconColor: AppColors.primaryBlue, title: "Términos y condiciones")
                            ]
                        )

                        logoutButton
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    .padding(.bottom, 24)
                }
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarHidden(true)
    }
}

#Preview {
    SettingsView(isLoggedIn: .constant(true))
}


private extension SettingsView {
    struct SettingRowData: Identifiable {
        let id = UUID()
        let icon: String
        let iconColor: Color
        let title: String
    }
    
    func settingRowData(icon: String, iconColor: Color, title: String) -> SettingRowData {
        SettingRowData(icon: icon, iconColor: iconColor, title: title)
    }
    
    var headerSection: some View {
        
        AppHeaderView(
            subtitle: "Tu cuenta",
            title: "Ajustes",
            showsFilterButton: false
        )
    }
    
    
    var profileCard: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AppColors.primaryBlue, AppColors.primaryTeal],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)

                Image(systemName: "person.fill")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Wilder")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.black.opacity(0.85))

                Text("user@maply.com")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(AppColors.secondaryText)
            }

            Spacer()
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(AppColors.cardBackground.opacity(0.88))
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(Color.black.opacity(0.04), lineWidth: 1)
                )
        )
    }
    
    
    func settingsGroup(title: String, rows: [SettingRowData]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Color.black.opacity(0.86))

            VStack(spacing: 10) {
                ForEach(rows) { row in
                    settingRow(row)
                }
            }
        }
    }
    
    func settingRow(_ row: SettingRowData) -> some View {
        HStack(spacing: 14) {
            Image(systemName: row.icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 38, height: 38)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(row.iconColor)
                )

            Text(row.title)
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.black.opacity(0.82))

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color.gray.opacity(0.7))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(AppColors.cardBackground.opacity(0.88))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.black.opacity(0.04), lineWidth: 1)
                )
        )
    }
    
    
    var logoutButton: some View {
        Button(role: .destructive) {
            isLoggedIn = false
        } label: {
            HStack {
                Spacer()

                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 17, weight: .bold))

                Text("Cerrar sesión")
                    .font(.system(size: 18, weight: .bold, design: .rounded))

                Spacer()
            }
            .foregroundStyle(.white)
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.red.opacity(0.88))
            )
            .shadow(color: .red.opacity(0.18), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}
