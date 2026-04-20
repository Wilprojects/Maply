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
    
    private let darkColor = Color(red: 41/255, green: 45/255, blue: 50/255)   // #292D32
    private let bluePrimary = Color(red: 87/255, green: 193/255, blue: 235/255) // #57C1EB
    private let tealPrimary = Color(red: 77/255, green: 175/255, blue: 173/255) // #4DAFAD
    private let pageBackground = Color(red: 242/255, green: 244/255, blue: 246/255)
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .map:
                    MapHomeView()
                case .locations:
                    LocationsListView()
                case .settings:
                    SettingsView(isLoggedIn: $isLoggedIn)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(pageBackground)
            .ignoresSafeArea()
            
            customTabBar
        }
        
        /*TabView {
            MapHomeView()
                .tabItem {
                    Label("Mapa", systemImage: "map")
                }
            
            LocationsListView()
                .tabItem {
                    Label("Ubicaciones", systemImage: "list.bullet")
                }
            
            SettingsView(isLoggedIn: $isLoggedIn)
                .tabItem {
                    Label("Ajustes", systemImage: "gearshape")
                }

        }*/
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
                    activeColor: bluePrimary
                )
                
                verticalDivider
                
                tabItemView(
                    tab: .locations,
                    icon: "bookmark.fill",
                    title: "Ubicaciones",
                    activeColor: tealPrimary
                )
                
                verticalDivider

                tabItemView(
                    tab: .settings,
                    icon: "gearshape.fill",
                    title: "Ajustes",
                    activeColor: Color.gray.opacity(0.9)
                )
            }
            .frame(height: 86)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 0, style: .continuous)
                    .fill(darkColor)
                    .shadow(color: .black.opacity(0.12), radius: 10, x: 0, y: -4)
            )
            
            Rectangle()
                .fill(Color.black.opacity(0.72))
                .frame(width: 135, height: 5)
                .clipShape(Capsule())
                .padding(.top, 8)
                .padding(.bottom, 8)
                .frame(maxWidth: .infinity)
                .background(darkColor)
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    
    var verticalDivider: some View {
        Rectangle()
            .fill(Color.white.opacity(0.16))
            .frame(width: 1, height: 34)
            .padding(.top, 10)
    }
    
    
    func tabItemView(tab: AppTab, icon: String, title: String, activeColor: Color) -> some View {
        let isSelected = selectedTab == tab
        
        return Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedTab = tab
            }
        }label: {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 23, weight: .semibold))
                    .foregroundStyle(isSelected ? activeColor : Color.white.opacity(0.78))

                Text(title)
                    .font(.system(size: 14, weight: isSelected ? .semibold : .medium, design: .rounded))
                    .foregroundStyle(isSelected ? Color.white : Color.white.opacity(0.78))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 86)
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
