//
//  MainTabView.swift
//  Maply
//
//  Created by Wilder Moreno on 19/04/26.
//

import SwiftUI

struct MainTabView: View {
    
    @Binding var isLoggedIn: Bool
    @State private var selectedTab: AppTab = .map
    
    var body: some View {
        ZStack(alignment: .bottom) {
            currentScreen
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(AppColors.pageBackground)
                .ignoresSafeArea(edges: .top)
            
            customTabBar
        }
        .background(AppColors.pageBackground)
        .ignoresSafeArea(edges: .bottom)
    }
    
    @ViewBuilder
    var currentScreen: some View {
        switch selectedTab {
        case .map:
            MapHomeView()
        case .locations:
            LocationsListView()
        case .settings:
            SettingsView(isLoggedIn: $isLoggedIn)
        }
    }
}

#Preview {
    MainTabView(isLoggedIn: .constant(true))
}


private extension MainTabView {
    var customTabBar: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                tabItemView(
                    tab: .map,
                    icon: "mappin.circle.fill",
                    title: "Mapa",
                    activeColor: AppColors.primaryBlue
                )
                
                verticalDivider
                
                tabItemView(
                    tab: .locations,
                    icon: "bookmark.fill",
                    title: "Ubicaciones",
                    activeColor: AppColors.primaryTeal
                )
                
                verticalDivider
                
                tabItemView(
                    tab: .settings,
                    icon: "gearshape.fill",
                    title: "Ajustes",
                    activeColor: AppColors.primaryGreen
                )
            }
            .frame(height: 76)
            .padding(.horizontal, 10)
            .background(
                AppColors.darkSurface
                    .shadow(color: .black.opacity(0.10), radius: 8, x: 0, y: -3)
            )
            
            ZStack {
                AppColors.darkSurface
                
                Rectangle()
                    .fill(Color.black.opacity(0.72))
                    .frame(width: 134, height: 5)
                    .clipShape(Capsule())
            }
            .frame(height: 20)
        }
        .frame(maxWidth: .infinity)
        .background(AppColors.darkSurface)
    }
    
    
    var verticalDivider: some View {
        Rectangle()
            .fill(Color.white.opacity(0.14))
            .frame(width: 1, height: 30)
    }
    

    
    func tabItemView(tab: AppTab, icon: String, title: String, activeColor: Color) -> some View {
        let isSelected = selectedTab == tab
        
        return Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedTab = tab
            }
        } label: {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(isSelected ? activeColor : Color.white.opacity(0.78))

                Text(title)
                    .font(.system(size: 12, weight: isSelected ? .semibold : .medium, design: .rounded))
                    .foregroundStyle(Color.white.opacity(isSelected ? 1.0 : 0.78))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 76)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
    
}

enum AppTab {
    case map
    case locations
    case settings
}
