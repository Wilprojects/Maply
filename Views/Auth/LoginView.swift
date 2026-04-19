//
//  LoginView.swift
//  Maply
//
//  Created by Wilder Moreno on 18/04/26.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Spacer()
                    
                    VStack(spacing: 16) {
                        Image("maply_icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 8)
                        
                        Text("Maply")
                            .font(.system(size: 44, weight: .bold, design: .rounded))
                            .foregroundStyle(Color(.label))
                        
                        Text("Accede para continuar.")
                            .font(.title3)
                            .foregroundStyle(Color(.secondaryLabel))
                    }
                    
                    VStack(spacing: 16) {
                        VStack(spacing: 0) {
                            HStack(spacing: 12) {
                                Image(systemName: "envelope")
                                    .foregroundStyle(.gray)
                                TextField("Correo electrónico", text: $viewModel.email)
                                    .keyboardType(.emailAddress)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                            }
                            .padding()
                            
                            Divider()
                            
                            HStack(spacing: 12) {
                                Image(systemName: "lock")
                                    .foregroundStyle(.gray)
                                
                                Group {
                                    if viewModel.isPasswordVisible {
                                        TextField("Contraseña", text: $viewModel.password)
                                    } else {
                                        SecureField("Contraseña", text: $viewModel.password)
                                    }
                                }
                                
                                Button(viewModel.isPasswordVisible ? "Ocultar" : "Mostrar") {
                                    viewModel.isPasswordVisible.toggle()
                                }
                                .font(.subheadline)
                                .foregroundStyle(.blue)
                                
                            }
                            .padding()
                        }
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(Color.black.opacity(0.05), lineWidth: 1)
                        )
                        
                        if !viewModel.errorMessage.isEmpty {
                            Text(viewModel.errorMessage)
                                .font(.footnote)
                                .foregroundStyle(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        Button {
                            viewModel.login()
                        }label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color(red: 0.33, green: 0.76, blue: 0.92),
                                                Color(red: 0.27, green: 0.56, blue: 0.96)
                                            ],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(height: 56)
                                
                                if viewModel.isLoading {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Text("Iniciar sesión")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                }
                            }
                        }
                        .disabled(!viewModel.isFormValid || viewModel.isLoading)
                        .opacity((!viewModel.isFormValid || viewModel.isLoading) ? 0.7 : 1)
                        
                        Button("¿Olvidaste tu contraseña?") {
                        }
                        .font(.subheadline)
                        .foregroundStyle(.blue)
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                    
                    Text("Al continuar, aceptas nuestros Términos y Condiciones y Política de Privacidad.")
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color(.secondaryLabel))
                        .padding(.horizontal, 32)
                        .padding(.bottom, 24)
                    
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    LoginView()
}
