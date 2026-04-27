//
//  LoginView.swift
//  Maply
//
//  Created by Wilder Moreno on 18/04/26.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
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
                        credentialsCard
                        
                        if !viewModel.errorMessage.isEmpty {
                            errorMessageView
                        }
                        
                        loginButton
                        
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
    LoginView(viewModel: AuthViewModel())
}

private extension LoginView {
    var credentialsCard: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Image(systemName: "envelope")
                    .foregroundStyle(.gray)
                
                TextField("Correo electrónico", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .onChange(of: viewModel.email) { _, _ in
                        viewModel.clearErrorOnInput()
                    }
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
                .onChange(of: viewModel.password) { _, _ in
                    viewModel.clearErrorOnInput()
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
                .stroke(credentialsBorderColor, lineWidth: 1)
        )
    }
    
    var errorMessageView: some View {
        HStack(spacing: 10) {
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundStyle(.red)
            
            Text(viewModel.errorMessage)
                .font(.footnote)
                .foregroundStyle(.red)
            
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.red.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.red.opacity(0.15), lineWidth: 1)
        )
    }
    
    var loginButton: some View {
        Button {
            viewModel.login()
        } label: {
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
                
                HStack(spacing: 10) {
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    }
                    
                    Text(viewModel.isLoading ? "Ingresando..." : "Iniciar sesión")
                        .font(.headline)
                        .foregroundStyle(.white)
                }
            }
        }
        .disabled(!viewModel.isFormValid || viewModel.isLoading)
        .opacity((!viewModel.isFormValid || viewModel.isLoading) ? 0.7 : 1)
    }
    
    var credentialsBorderColor: Color {
        if viewModel.shouldShowEmailError || viewModel.shouldShowPasswordError {
            return Color.red.opacity(0.7)
        } else if !viewModel.errorMessage.isEmpty {
            return Color.red.opacity(0.45)
        } else {
            return Color.black.opacity(0.05)
        }
    }
}
