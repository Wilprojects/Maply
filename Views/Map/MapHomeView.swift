//
//  MapHomeView.swift
//  Maply
//
//  Created by Wilder Moreno on 19/04/26.
//

import SwiftUI

struct MapHomeView: View {
    private let darkColor = Color(red: 41/255, green: 45/255, blue: 50/255)      // #292D32
    private let bluePrimary = Color(red: 87/255, green: 193/255, blue: 235/255)  // #57C1EB
    private let tealPrimary = Color(red: 77/255, green: 175/255, blue: 173/255)  // #4DAFAD
    private let greenPrimary = Color(red: 69/255, green: 198/255, blue: 123/255) // #45C67B
    private let pageBackground = Color(red: 242/255, green: 244/255, blue: 246/255)

    var body: some View {
        ZStack(alignment: .top) {
            pageBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                headerSection
                mapSection
                locationCardSection
            }
        }
        .padding(.bottom, 102)
        .ignoresSafeArea(edges: .top)
        .navigationBarHidden(true)
    }
}

#Preview {
    MapHomeView()
}

private extension MapHomeView {
    var headerSection: some View {
        ZStack(alignment: .bottom) {
            darkColor
                .ignoresSafeArea(edges: .top)
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Spacer()
                    
                    Button {
                    }label: {
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
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Bienvenido a Maply")
                        .font(.system(size: 17, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.78))

                    Text("Santiago")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }
            }
            .padding(.horizontal, 22)
            .padding(.top, 52)
            .padding(.bottom, 26)
        }
        .frame(height: 150)
    }
    
    var mapSection: some View {
        ZStack {
            mapBackground
            decorativePins
            centralPin
            locationPoint
        }
        .frame(height: 272)
        .clipped()
    }
    
    
    var locationCardSection: some View {
        VStack(spacing: 14) {
            HStack {
                Text("Mi Ubicación")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.black.opacity(0.92))

                Spacer()

                HStack(spacing: 6) {
                    Circle().fill(Color.gray.opacity(0.55)).frame(width: 6, height: 6)
                    Circle().fill(Color.gray.opacity(0.55)).frame(width: 6, height: 6)
                    Circle().fill(Color.gray.opacity(0.55)).frame(width: 6, height: 6)
                }
            }
            
            VStack(spacing: 10) {
                locationRow(
                    iconColor: tealPrimary,
                    title: "Work Café",
                    subtitle: "Av. Providencia 1234"
                )
                
                locationRow(
                    iconColor: greenPrimary,
                    title: "Costanera Center",
                    subtitle: "Av. Andrés Bello 2425"
                )
                
                locationRow(
                    iconColor: greenPrimary,
                    title: "Parque Bicentenario",
                    subtitle: "Av. Bicentenario 4000",
                    showsMic: true
                )
                
            }
            
            saveLocationSection
        }
        .padding(.horizontal, 16)
        .padding(.top, 18)
        .padding(.bottom, 14)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(pageBackground)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: -2)
        )
        .offset(y: -18)
        .padding(.bottom, -18)
        
    }
    
}

private extension MapHomeView {
    var locationPoint: some View{
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button {
                } label: {
                    Image(systemName: "location.north.fill")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.red, .gray.opacity(0.2))
                        .frame(width: 66, height: 66)
                        .background(.white)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 6)
                }
                .padding(.trailing, 22)
                .padding(.bottom, 32)
                
            }
            
        }
    }
}

private extension MapHomeView {
    var mapBackground: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 244/255, green: 245/255, blue: 246/255),
                    Color(red: 232/255, green: 237/255, blue: 234/255)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            
            GeometryReader { proxy in
                let width = proxy.size.width
                let height = proxy.size.height
                
                ZStack {
                    ForEach(0..<9, id: \.self) { index in
                        Path { path in
                            let y = CGFloat(index) * (height / 8.2)
                            path.move(to: CGPoint(x: 0, y: y))
                            path.addCurve(
                                to: CGPoint(x: width, y: y + 8),
                                control1: CGPoint(x: width * 0.22, y: y - 14),
                                control2: CGPoint(x: width * 0.74, y: y + 24)
                            )
                        }
                        .stroke(Color.white.opacity(0.92), lineWidth: 5.5)
                    }
                    
                    ForEach(0..<8, id: \.self) { index in
                        Path { path in
                            let x = CGFloat(index) * (width / 7)
                            path.move(to: CGPoint(x: x, y: 0))
                            path.addCurve(
                                to: CGPoint(x: x + 18, y: height),
                                control1: CGPoint(x: x - 18, y: height * 0.22),
                                control2: CGPoint(x: x + 35, y: height * 0.78)
                            )
                        }
                        .stroke(Color.white.opacity(0.78), lineWidth: 4.6)
                    }
                    
                    Path { path in
                       path.move(to: CGPoint(x: width * 0.53, y: 0))
                       path.addCurve(
                           to: CGPoint(x: width * 0.58, y: height),
                           control1: CGPoint(x: width * 0.48, y: height * 0.25),
                           control2: CGPoint(x: width * 0.67, y: height * 0.75)
                       )
                   }
                   .stroke(bluePrimary.opacity(0.22), lineWidth: 16)
                    
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: height * 0.42))
                        path.addCurve(
                            to: CGPoint(x: width, y: height * 0.25),
                            control1: CGPoint(x: width * 0.28, y: height * 0.18),
                            control2: CGPoint(x: width * 0.72, y: height * 0.52)
                        )
                    }
                    .stroke(Color(red: 0.93, green: 0.76, blue: 0.43).opacity(0.35), lineWidth: 8)
                    
                    Group {
                        roundedPatch(x: width * 0.30, y: height * 0.20, w: 110, h: 52)
                        roundedPatch(x: width * 0.75, y: height * 0.18, w: 92, h: 48)
                        roundedPatch(x: width * 0.18, y: height * 0.70, w: 110, h: 52)
                        roundedPatch(x: width * 0.82, y: height * 0.74, w: 82, h: 48)
                    }
                    .foregroundStyle(greenPrimary.opacity(0.12))
                    
                }
                
            }
        }
    }
    
    func roundedPatch(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 14, style: .continuous)
            .frame(width: w, height: h)
            .position(x: x, y: y)
    }
    
    var decorativePins: some View {
        ZStack {
            miniPin(color: tealPrimary)
                .offset(x: 30, y: -88)

            miniPin(color: greenPrimary)
                .offset(x: 142, y: -44)

            miniPin(color: tealPrimary)
                .offset(x: 86, y: 76)

            miniPin(color: greenPrimary)
                .offset(x: -142, y: 22)
        }
    }
    
    func miniPin(color: Color) -> some View {
        Image(systemName: "mappin.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 40, height: 40)
            .foregroundStyle(color, color.opacity(0.18))
            .shadow(color: .black.opacity(0.10), radius: 4, x: 0, y: 2)
    }
    
    var centralPin: some View {
        ZStack {
            Circle()
                .fill(bluePrimary.opacity(0.18))
                .frame(width: 118, height: 118)

            Circle()
                .fill(bluePrimary.opacity(0.10))
                .frame(width: 76, height: 76)

            Image(systemName: "mappin.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 68, height: 68)
                .foregroundStyle(
                    LinearGradient(
                        colors: [bluePrimary, Color.blue],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: .black.opacity(0.16), radius: 10, x: 0, y: 6)
        }
        .offset(y: -2)
    }
}


private extension MapHomeView {
    func locationRow(iconColor: Color, title: String, subtitle: String, showsMic: Bool = false ) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "mappin.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 34, height: 34)
                .foregroundStyle(iconColor, iconColor.opacity(0.18))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.black.opacity(0.80))
                
                HStack(spacing: 4) {
                    Text(subtitle)
                        .font(.system(size: 13.5, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.gray.opacity(0.95))

                    if showsMic {
                        Image(systemName: "mic.fill")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(Color.gray.opacity(0.75))
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.gray.opacity(0.70))
            
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 13)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(0.84))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.black.opacity(0.04), lineWidth: 1)
                )
        )
    }
    
    
    var saveLocationSection: some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.white.opacity(0.90))
                    .frame(width: 60, height: 52)

                Image(systemName: "mappin.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(bluePrimary, bluePrimary.opacity(0.18))
            }

            Button {
            } label: {
                HStack {
                    Spacer()

                    Text("Guardar ubicación")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white.opacity(0.96))
                        .padding(.trailing, 16)
                }
                .frame(height: 52)
                .background(
                    LinearGradient(
                        colors: [Color(red: 0.26, green: 0.55, blue: 0.95), bluePrimary],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: bluePrimary.opacity(0.22), radius: 8, x: 0, y: 5)
            }
        }
    }
}
