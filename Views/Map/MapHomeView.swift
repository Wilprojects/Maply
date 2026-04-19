//
//  MapHomeView.swift
//  Maply
//
//  Created by Wilder Moreno on 19/04/26.
//

import SwiftUI

struct MapHomeView: View {
    
    private let headerColor = Color(red: 41/255, green: 45/255, blue: 50/255)   // #292D32
    private let bluePrimary = Color(red: 87/255, green: 193/255, blue: 235/255) // #57C1EB
    private let tealPrimary = Color(red: 77/255, green: 175/255, blue: 173/255) // #4DAFAD
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
        .navigationBarHidden(true)
    }
}

#Preview {
    MapHomeView()
}

private extension MapHomeView {
    var headerSection: some View {
        ZStack(alignment: .bottom) {
            headerColor
                .ignoresSafeArea(edges: .top)
            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    Spacer()
                    
                    Button {
                    }label: {
                        Text("Filtrar")
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(Color.white.opacity(0.12))
                            )
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Bienvenido a Maply")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.78))

                    Text("Santiago")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 56)
            .padding(.bottom, 18)
        }
        .frame(height: 150)
    }
    
    
    var mapSection: some View {
        ZStack {
            mapBackground
            
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
            
            decorativePins
            
            centralPin
            
        }
        .frame(height: 310)
        .clipped()
    }
    
    
    var locationCardSection: some View {
        VStack(spacing: 14) {
            HStack {
                Text("Mi Ubicación")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.black.opacity(0.88))
                
                Spacer()
                
                HStack(spacing: 6) {
                    Circle().fill(Color.gray.opacity(0.55)).frame(width: 6, height: 6)
                    Circle().fill(Color.gray.opacity(0.55)).frame(width: 6, height: 6)
                    Circle().fill(Color.gray.opacity(0.55)).frame(width: 6, height: 6)
                }
            }
            
            VStack(spacing: 12) {
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
            
            saveButtonRow
        }
        .padding(.horizontal, 16)
        .padding(.top, 18)
        .padding(.bottom, 14)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(pageBackground)
                .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: -3)
        )
        .offset(y: -18)
        .padding(.bottom, -18)
        
    }
    
    
    var mapBackground: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 245/255, green: 246/255, blue: 248/255),
                    Color(red: 229/255, green: 236/255, blue: 232/255)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            
            GeometryReader { proxy in
                let width = proxy.size.width
                let height = proxy.size.height

                ZStack {
                    ForEach(0..<10, id: \.self) { index in
                        Path { path in
                            let y = CGFloat(index) * (height / 9)
                            path.move(to: CGPoint(x: 0, y: y))
                            path.addCurve(
                                to: CGPoint(x: width, y: y + 10),
                                control1: CGPoint(x: width * 0.25, y: y - 18),
                                control2: CGPoint(x: width * 0.75, y: y + 28)
                            )
                        }
                        .stroke(Color.white.opacity(0.9), lineWidth: 6)
                    }

                    ForEach(0..<8, id: \.self) { index in
                        Path { path in
                            let x = CGFloat(index) * (width / 7)
                            path.move(to: CGPoint(x: x, y: 0))
                            path.addCurve(
                                to: CGPoint(x: x + 20, y: height),
                                control1: CGPoint(x: x - 30, y: height * 0.25),
                                control2: CGPoint(x: x + 50, y: height * 0.75)
                            )
                        }
                        .stroke(Color.white.opacity(0.78), lineWidth: 5)
                    }

                    Path { path in
                        path.move(to: CGPoint(x: width * 0.55, y: 0))
                        path.addCurve(
                            to: CGPoint(x: width * 0.60, y: height),
                            control1: CGPoint(x: width * 0.48, y: height * 0.25),
                            control2: CGPoint(x: width * 0.68, y: height * 0.75)
                        )
                    }
                    .stroke(bluePrimary.opacity(0.28), lineWidth: 18)

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
                        roundedPatch(x: width * 0.25, y: height * 0.18, w: 110, h: 52)
                        roundedPatch(x: width * 0.76, y: height * 0.20, w: 94, h: 48)
                        roundedPatch(x: width * 0.18, y: height * 0.73, w: 120, h: 56)
                        roundedPatch(x: width * 0.82, y: height * 0.72, w: 86, h: 52)
                    }
                    .foregroundStyle(greenPrimary.opacity(0.15))
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
                .offset(x: 38, y: -86)
            miniPin(color: greenPrimary)
                .offset(x: 148, y: -40)

            miniPin(color: greenPrimary)
                .offset(x: 82, y: 88)

            miniPin(color: greenPrimary)
                .offset(x: -145, y: 34)
        }
    }
    
    func miniPin(color: Color) -> some View {
        Image(systemName: "mappin.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 42, height: 42)
            .foregroundStyle(color, color.opacity(0.18))
            .shadow(color: .black.opacity(0.14), radius: 5, x: 0, y: 3)
    }
    
    var centralPin: some View {
        ZStack {
            Circle()
                .fill(bluePrimary.opacity(0.18))
                .frame(width: 132, height: 132)
            
            Circle()
                .fill(bluePrimary.opacity(0.12))
                .frame(width: 88, height: 88)
            
            VStack(spacing: 0) {
                Image(systemName: "mappin.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 72, height: 72)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [bluePrimary, Color.blue],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(color: .black.opacity(0.16), radius: 10, x: 0, y: 6)
            }
        }
    }
    
    
    func locationRow(iconColor: Color, title: String, subtitle: String, showsMic: Bool = false)-> some View {
        HStack(spacing: 12) {
            Image(systemName: "mappin.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 34, height: 34)
                .foregroundStyle(iconColor, iconColor.opacity(0.18))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.black.opacity(0.78))
                HStack(spacing: 4) {
                    Text(subtitle)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.gray.opacity(0.95))
                    
                    if showsMic {
                        Image(systemName: "mic.fill")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(Color.gray.opacity(0.75))
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.gray.opacity(0.7))
                
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(0.86))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.black.opacity(0.04), lineWidth: 1)
                )
        )
    }
    
    
    var saveButtonRow: some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.white.opacity(0.92))
                    .frame(width: 72, height: 58)
                
                Image(systemName: "mappin.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 34, height: 34)
                    .foregroundStyle(bluePrimary, bluePrimary.opacity(0.18))
            }
            
            Button {
            }label: {
                HStack {
                    Spacer()
                    
                    Text("Guardar ubicación")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.white.opacity(0.95))
                        .padding(.horizontal, 10)
                }
                .frame(height: 58)
                .background(
                    LinearGradient(
                        colors: [Color(red: 0.26, green: 0.55, blue: 0.95), bluePrimary],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                .shadow(color: bluePrimary.opacity(0.24), radius: 10, x: 0, y: 6)
            }
        }
    }
    
}
