//
//  LocationsListView.swift
//  Maply
//
//  Created by Wilder Moreno on 19/04/26.
//

import SwiftUI

struct LocationsListView: View {
    
    private let darkColor = Color(red: 41/255, green: 45/255, blue: 50/255)      // #292D32
    private let bluePrimary = Color(red: 87/255, green: 193/255, blue: 235/255)  // #57C1EB
    private let tealPrimary = Color(red: 77/255, green: 175/255, blue: 173/255)  // #4DAFAD
    private let greenPrimary = Color(red: 69/255, green: 198/255, blue: 123/255) // #45C67B
    private let pageBackground = Color(red: 242/255, green: 244/255, blue: 246/255)
    
    var body: some View {
        /*
        NavigationStack {
            List {
                Section("Ubicaciones guardadas") {
                    Label("Casa", systemImage: "mappin.and.ellipse")
                    Label("Trabajo", systemImage: "mappin.and.ellipse")
                    Label("Universidad", systemImage: "mappin.and.ellipse")
                }
            }
            .navigationTitle("Ubicaciones")
            .padding(.bottom, 95)
        }
        
        */
        
        ZStack(alignment: .top) {
            pageBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerSection
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        sectionTitle
                        
                        VStack(spacing: 12) {
                            locationCard(
                                iconColor: tealPrimary,
                                title: "Work Café",
                                subtitle: "Av. Providencia 1234",
                                category: "Favorito"
                            )

                            locationCard(
                                iconColor: greenPrimary,
                                title: "Costanera Center",
                                subtitle: "Av. Andrés Bello 2425",
                                category: "Trabajo"
                            )

                            locationCard(
                                iconColor: greenPrimary,
                                title: "Parque Bicentenario",
                                subtitle: "Av. Bicentenario 4000",
                                category: "Reciente"
                            )

                            locationCard(
                                iconColor: bluePrimary,
                                title: "Casa",
                                subtitle: "Calle Principal 123",
                                category: "Guardado"
                            )
                        }
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
    LocationsListView()
}


private extension LocationsListView {
    var headerSection: some View {
        ZStack(alignment: .bottomLeading) {
            darkColor
                .ignoresSafeArea(edges: .top)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Tus lugares")
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.78))

                Text("Ubicaciones")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 22)
            .padding(.top, 52)
            .padding(.bottom, 18)
        }
        .frame(height: 145)
    }
    
    
    var sectionTitle: some View {
        HStack {
            Text("Ubicaciones guardadas")
                .font(.system(size: 21, weight: .bold, design: .rounded))
                .foregroundStyle(Color.black.opacity(0.88))

            Spacer()

            Image(systemName: "slider.horizontal.3")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Color.gray.opacity(0.8))
        }
    }
    
    
    func locationCard(iconColor: Color, title: String, subtitle: String, category: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: "mappin.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 38, height: 38)
                .foregroundStyle(iconColor, iconColor.opacity(0.18))
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(title)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.black.opacity(0.82))

                    Spacer()

                    Text(category)
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            Capsule()
                                .fill(iconColor.opacity(0.9))
                        )
                }

                Text(subtitle)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.gray.opacity(0.95))
            }
            
            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.gray.opacity(0.7))

        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white.opacity(0.88))
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(Color.black.opacity(0.04), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
        )
    }
}
