//
//  MapHomeView.swift
//  Maply
//
//  Created by Wilder Moreno on 19/04/26.
//

import SwiftUI

struct MapHomeView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                
                Image(systemName: "map.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90, height: 90)
                    .foregroundStyle(.blue)
                
                Text("Mapa")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                
                Text("Aquí mostraremos el mapa y la ubicación actual del usuario.")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Mapa")
            .background(Color(.systemGroupedBackground))
        }
    }
}

#Preview {
    MapHomeView()
}
