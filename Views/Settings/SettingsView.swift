//
//  SettingsView.swift
//  Maply
//
//  Created by Wilder Moreno on 19/04/26.
//

import SwiftUI

struct SettingsView: View {
    @Binding var isLoggedIn: Bool
    
    private let darkColor = Color(red: 41/255, green: 45/255, blue: 50/255)      // #292D32
    private let bluePrimary = Color(red: 87/255, green: 193/255, blue: 235/255)  // #57C1EB
    private let tealPrimary = Color(red: 77/255, green: 175/255, blue: 173/255)  // #4DAFAD
    private let greenPrimary = Color(red: 69/255, green: 198/255, blue: 123/255) // #45C67B
    private let pageBackground = Color(red: 242/255, green: 244/255, blue: 246/255)
    
    var body: some View {
        /*NavigationStack {
            List {
                Section("Cuenta") {
                    Label("user@maply.com", systemImage: "person.circle")
                }
                
                Section("Preferencias") {
                    Label("Tema claro", systemImage: "sun.max")
                    Label("Notificaciones", systemImage: "bell")
                }
                
                Section {
                    Button(role: .destructive) {
                        isLoggedIn = false
                    } label: {
                        Label("Cerrar sesión", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                }
            }
            .navigationTitle("Ajustes")
            .padding(.bottom, 95)
        } */
        
        ZStack(alignment: .top) {
            pageBackground
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
                                settingRowData(icon: "bell.fill", iconColor: bluePrimary, title: "Notificaciones"),
                                settingRowData(icon: "lock.fill", iconColor: tealPrimary, title: "Privacidad")
                            ]
                        )

                        settingsGroup(
                            title: "Soporte",
                            rows: [
                                settingRowData(icon: "questionmark.circle.fill", iconColor: greenPrimary, title: "Ayuda"),
                                settingRowData(icon: "doc.text.fill", iconColor: bluePrimary, title: "Términos y condiciones")
                            ]
                        )

                        logoutButton
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
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
        ZStack(alignment: .bottomLeading) {
            darkColor
                .ignoresSafeArea(edges: .top)

            VStack(alignment: .leading, spacing: 8) {
                Text("Tu cuenta")
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.78))

                Text("Ajustes")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 22)
            .padding(.top, 52)
            .padding(.bottom, 18)
        }
        .frame(height: 145)
    }
    
    
    var profileCard: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [bluePrimary, tealPrimary],
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

                Text("demo@maply.com")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.gray.opacity(0.95))
            }

            Spacer()
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white.opacity(0.88))
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
                .fill(Color.white.opacity(0.88))
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
