//
//  HomeView.swift
//  Maply
//
//  Created by Wilder Moreno on 18/04/26.
//

import SwiftUI

struct HomeView: View {
    
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 24) {
                Spacer()
                
                Image(systemName: "map.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90, height: 90)
                    .foregroundStyle(.blue)
                
                Text("Bienvenido a Maply")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                
                Text("Esta será la pantalla principal de la app.")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                Button {
                    isLoggedIn = false
                } label: {
                    Text("Cerrar sesión")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(.blue)
                        )
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
            .navigationTitle("Inicio")
            .background(Color(.systemGroupedBackground))
        
        }
    }
}

#Preview {
    HomeView(isLoggedIn: .constant(true))
}
