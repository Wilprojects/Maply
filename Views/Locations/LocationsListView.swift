//
//  LocationsListView.swift
//  Maply
//
//  Created by Wilder Moreno on 19/04/26.
//

import SwiftUI

struct LocationsListView: View {
    
    var body: some View {
        
        ZStack(alignment: .top) {
            AppColors.pageBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerSection
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        sectionTitle
                        
                        VStack(spacing: 12) {
                            locationCard(
                                iconColor: AppColors.primaryTeal,
                                title: "Work Café",
                                subtitle: "Av. Providencia 1234",
                                category: "Favorito"
                            )

                            locationCard(
                                iconColor: AppColors.primaryGreen,
                                title: "Costanera Center",
                                subtitle: "Av. Andrés Bello 2425",
                                category: "Trabajo"
                            )

                            locationCard(
                                iconColor: AppColors.primaryGreen,
                                title: "Parque Bicentenario",
                                subtitle: "Av. Bicentenario 4000",
                                category: "Reciente"
                            )

                            locationCard(
                                iconColor: AppColors.primaryBlue,
                                title: "Casa",
                                subtitle: "Calle Principal 123",
                                category: "Guardado"
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    .padding(.bottom, 24)
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
        AppHeaderView(
            subtitle: "Tus lugares",
            title: "Ubicaciones",
            showsFilterButton: false
        )
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
                    .foregroundStyle(AppColors.secondaryText.opacity(0.95))
            }
            
            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.gray.opacity(0.7))

        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(AppColors.cardBackground.opacity(0.88))
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(Color.black.opacity(0.04), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
        )
    }
}
