//
//  AppHeaderView.swift
//  Maply
//
//  Created by Wilder Moreno on 25/04/26.
//

import SwiftUI

struct AppHeaderView: View {
    let subtitle: String
    let title: String
    let showsFilterButton: Bool
    var filterAction: (() -> Void)? = nil
    
    var body: some View {
        ZStack(alignment: .bottom) {
            AppColors.darkSurface
                .ignoresSafeArea(edges: .top)
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .top) {
                    Spacer()
                    
                    if showsFilterButton {
                        Button {
                            filterAction?()
                        } label: {
                            Text("Filtrar")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 9)
                                .background(
                                    RoundedRectangle(cornerRadius: 13, style: .continuous)
                                        .fill(Color.white.opacity(0.10))
                                )
                        }
                        .padding(.top, 6)
                    }
                }
                VStack(alignment: .leading, spacing: 6) {
                    Text(subtitle)
                        .font(.system(size: 17, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.78))

                    Text(title)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }
            }
            .padding(.horizontal, 22)
            .padding(.top, 58)
            .padding(.bottom, 18)
        }
        .frame(height: 165)
    }
}

#Preview {
    AppHeaderView(
        subtitle: "Bienvenido a Maply",
        title: "Wilder",
        showsFilterButton: true
    )
}
