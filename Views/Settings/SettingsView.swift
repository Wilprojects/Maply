//
//  SettingsView.swift
//  Maply
//
//  Created by Wilder Moreno on 19/04/26.
//

import SwiftUI

struct SettingsView: View {
    @Binding var isLoggedIn: Bool
    
    @AppStorage("selectedTheme") private var selectedThemeRawValue: String = ThemeOption.system.rawValue
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = true
    
    @State private var isShowingThemeSheet = false
    @State private var isShowingHelpSheet = false
    @State private var isShowingTermsSheet = false
    @State private var isShowingLogoutConfirmation = false
    
    private var selectedTheme: ThemeOption {
        ThemeOption(rawValue: selectedThemeRawValue) ?? .system
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                AppColors.pageBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerSection
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 18) {
                            profileCard
                            
                            preferencesSection
                            supportSection
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
            .sheet(isPresented: $isShowingThemeSheet) {
                themeSelectionSheet
            }
            .sheet(isPresented: $isShowingHelpSheet) {
                infoSheet(
                    title: "Ayuda",
                    content: "Para guardar una ubicación, ve a la pestaña Mapa y presiona “Guardar ubicación”. También puedes ver el detalle de cada lugar desde la lista de ubicaciones."
                )
            }
            .sheet(isPresented: $isShowingTermsSheet) {
                infoSheet(
                    title: "Términos y condiciones",
                    content: "Esta aplicación fue desarrollada con fines académicos como proyecto final del curso de desarrollo móvil nativo para iOS. No recopila información con fines comerciales."
                )
            }
            .alert("Cerrar sesión", isPresented: $isShowingLogoutConfirmation) {
                Button("Cancelar", role: .cancel) { }
                Button("Cerrar sesión", role: .destructive) {
                    isLoggedIn = false
                }
            } message: {
                Text("¿Deseas cerrar tu sesión en Maply?")
            }
        }
    }
}

#Preview {
    SettingsView(isLoggedIn: .constant(true))
}

private extension SettingsView {
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
    
    var preferencesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Preferencias")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Color.black.opacity(0.86))
            
            VStack(spacing: 10) {
                themeRow
                
                notificationToggleRow
                
                NavigationLink {
                    PrivacyView()
                } label: {
                    settingsNavigationRow(
                        icon: "lock.fill",
                        iconColor: AppColors.primaryTeal,
                        title: "Privacidad"
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    var supportSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Soporte")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Color.black.opacity(0.86))
            
            VStack(spacing: 10) {
                actionRow(
                    icon: "questionmark.circle.fill",
                    iconColor: AppColors.primaryGreen,
                    title: "Ayuda"
                ) {
                    isShowingHelpSheet = true
                }
                
                actionRow(
                    icon: "doc.text.fill",
                    iconColor: AppColors.primaryBlue,
                    title: "Términos y condiciones"
                ) {
                    isShowingTermsSheet = true
                }
            }
        }
    }
    
    var themeRow: some View {
        Button {
            isShowingThemeSheet = true
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 38, height: 38)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.orange)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Tema")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color.black.opacity(0.82))
                    
                    Text(selectedTheme.title)
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(AppColors.secondaryText)
                }
                
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
        .buttonStyle(.plain)
    }
    
    var notificationToggleRow: some View {
        HStack(spacing: 14) {
            Image(systemName: "bell.fill")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 38, height: 38)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(AppColors.primaryBlue)
                )
            
            Text("Notificaciones")
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.black.opacity(0.82))
            
            Spacer()
            
            Toggle("", isOn: $notificationsEnabled)
                .labelsHidden()
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
    
    func settingsNavigationRow(icon: String, iconColor: Color, title: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 38, height: 38)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(iconColor)
                )
            
            Text(title)
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
    
    func actionRow(icon: String, iconColor: Color, title: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 38, height: 38)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(iconColor)
                    )
                
                Text(title)
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
        .buttonStyle(.plain)
    }
    
    var logoutButton: some View {
        Button(role: .destructive) {
            isShowingLogoutConfirmation = true
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

private extension SettingsView {
    var themeSelectionSheet: some View {
        NavigationStack {
            VStack(spacing: 18) {
                ForEach(ThemeOption.allCases) { theme in
                    Button {
                        selectedThemeRawValue = theme.rawValue
                    } label: {
                        HStack {
                            Text(theme.title)
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundStyle(Color.black.opacity(0.85))
                            
                            Spacer()
                            
                            if selectedTheme == theme {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(AppColors.primaryBlue)
                                    .font(.system(size: 22))
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(AppColors.cardBackground.opacity(0.9))
                        )
                    }
                    .buttonStyle(.plain)
                }
                
                Spacer()
            }
            .padding(20)
            .background(AppColors.pageBackground)
            .navigationTitle("Seleccionar tema")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cerrar") { isShowingThemeSheet = false }
                }
            }
        }
        .presentationDetents([.medium])
    }
    
    func infoSheet(title: String, content: String) -> some View {
        NavigationStack {
            ScrollView {
                Text(content)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.black.opacity(0.82))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
            }
            .background(AppColors.pageBackground)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
        .presentationDetents([.medium, .large])
    }
}
