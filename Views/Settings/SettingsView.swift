//
//  SettingsView.swift
//  Maply
//
//  Created by Wilder Moreno on 19/04/26.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var authViewModel: AuthViewModel
    
    @AppStorage("selectedTheme") private var selectedThemeRawValue: String = ThemeOption.system.rawValue
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = true
    
    @State private var isShowingLogoutConfirmation = false
    @State private var activePopup: SettingsPopupType?
    
    private enum SettingsPopupType {
        case theme
        case help
        case terms
    }
    
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
                
                if activePopup != nil {
                    settingsPopupOverlay
                }
            }
            .ignoresSafeArea(edges: .top)
            .navigationBarHidden(true)
            .alert("Cerrar sesión", isPresented: $isShowingLogoutConfirmation) {
                Button("Cancelar", role: .cancel) { }
                Button("Cerrar sesión", role: .destructive) {
                    authViewModel.logout()
                }
            } message: {
                Text("¿Deseas cerrar tu sesión en Maply?")
            }
        }
    }
}

#Preview {
    SettingsView(authViewModel: AuthViewModel())
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
                    .foregroundStyle(AppColors.primaryText)
                
                Text(authViewModel.email.isEmpty ? "user@maply.com" : authViewModel.email)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(AppColors.secondaryText)
            }
            
            Spacer()
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(AppColors.cardBackground.opacity(0.96))
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(AppColors.dividerColor, lineWidth: 1)
                )
        )
    }
    
    var preferencesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Preferencias")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(AppColors.primaryText)
            
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
                .foregroundStyle(AppColors.primaryText)
            
            VStack(spacing: 10) {
                actionRow(
                    icon: "questionmark.circle.fill",
                    iconColor: AppColors.primaryGreen,
                    title: "Ayuda"
                ) {
                    activePopup = .help
                }
                
                actionRow(
                    icon: "doc.text.fill",
                    iconColor: AppColors.primaryBlue,
                    title: "Términos y condiciones"
                ) {
                    activePopup = .terms
                }
            }
        }
    }
    
    var themeRow: some View {
        Button {
            activePopup = .theme
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
                        .foregroundStyle(AppColors.primaryText.opacity(0.95))
                    
                    Text(selectedTheme.title)
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(AppColors.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(AppColors.mutedText)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(AppColors.cardBackground.opacity(0.96))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(AppColors.dividerColor, lineWidth: 1)
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
                .foregroundStyle(AppColors.primaryText.opacity(0.95))
            
            Spacer()
            
            Toggle("", isOn: $notificationsEnabled)
                .labelsHidden()
                .tint(AppColors.primaryBlue)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(AppColors.cardBackground.opacity(0.96))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(AppColors.dividerColor, lineWidth: 1)
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
                .foregroundStyle(AppColors.primaryText.opacity(0.95))
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(AppColors.mutedText)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(AppColors.cardBackground.opacity(0.96))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(AppColors.dividerColor, lineWidth: 1)
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
                    .foregroundStyle(AppColors.primaryText.opacity(0.95))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(AppColors.mutedText)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(AppColors.cardBackground.opacity(0.96))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(AppColors.dividerColor, lineWidth: 1)
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
    var settingsPopupOverlay: some View {
        ZStack {
            Color.black.opacity(0.35)
                .ignoresSafeArea()
                .onTapGesture {
                    activePopup = nil
                }
            
            VStack(spacing: 18) {
                popupHeader
                popupContent
                
                if activePopup == .theme {
                    themeOptionsContent
                }
                
                popupCloseButton
            }
            .padding(20)
            .frame(width: 340)
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(AppColors.pageBackground)
                    .shadow(color: .black.opacity(0.18), radius: 20, x: 0, y: 10)
            )
            .padding(.horizontal, 24)
        }
    }
    
    var popupHeader: some View {
        HStack {
            Text(popupTitle)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(AppColors.primaryText)
            
            Spacer()
            
            Button {
                activePopup = nil
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(AppColors.mutedText)
                    .frame(width: 34, height: 34)
                    .background(
                        Circle()
                            .fill(AppColors.cardBackground)
                    )
            }
            .buttonStyle(.plain)
        }
    }
    
    @ViewBuilder
    var popupContent: some View {
        switch activePopup {
        case .help:
            popupTextCard(
                title: "Centro de ayuda",
                text: "Para guardar una ubicación, ve a la pestaña Mapa y presiona “Guardar ubicación”. También puedes deslizar una ubicación para eliminarla o tocarla para ver su detalle."
            )
        case .terms:
            popupTextCard(
                title: "Términos y condiciones",
                text: "Maply es una aplicación desarrollada con fines académicos como proyecto final del curso de desarrollo móvil nativo para iOS. La información se almacena localmente en el dispositivo y no se utiliza con fines comerciales."
            )
        case .theme:
            popupTextCard(
                title: "Selecciona el tema visual",
                text: "El cambio se aplicará a toda la aplicación y quedará guardado para los próximos inicios."
            )
        case .none:
            EmptyView()
        }
    }
    
    func popupTextCard(title: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(AppColors.primaryText.opacity(0.95))
            
            Text(text)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(AppColors.secondaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(AppColors.cardBackground.opacity(0.96))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(AppColors.dividerColor, lineWidth: 1)
                )
        )
    }
    
    var themeOptionsContent: some View {
        VStack(spacing: 12) {
            ForEach(ThemeOption.allCases) { theme in
                Button {
                    selectedThemeRawValue = theme.rawValue
                    activePopup = nil
                } label: {
                    HStack {
                        Text(theme.title)
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .foregroundStyle(AppColors.primaryText.opacity(0.95))
                        
                        Spacer()
                        
                        if selectedTheme == theme {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 22))
                                .foregroundStyle(AppColors.primaryBlue)
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
                                        selectedTheme == theme
                                        ? AppColors.primaryBlue.opacity(0.35)
                                        : AppColors.dividerColor,
                                        lineWidth: 1
                                    )
                            )
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    var popupCloseButton: some View {
        Button {
            activePopup = nil
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
        .padding(.top, 4)
    }
    
    var popupTitle: String {
        switch activePopup {
        case .theme:
            return "Tema"
        case .help:
            return "Ayuda"
        case .terms:
            return "Términos"
        case .none:
            return ""
        }
    }
}
