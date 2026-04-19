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
        NavigationStack {
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
        }
    }
}

#Preview {
    SettingsView(isLoggedIn: .constant(true))
}
