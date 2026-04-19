//
//  MainTabView.swift
//  Maply
//
//  Created by Wilder Moreno on 19/04/26.
//

import SwiftUI

struct MainTabView: View {
    
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        TabView {
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

        }
    }
}

#Preview {
    MainTabView(isLoggedIn: .constant(true))
}
