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
                AppColors.pageBackground
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
                            .foregroundStyle(AppColors.primaryText)
                        
                        Text("Accede para continuar.")
                            .font(.title3)
                            .foregroundStyle(AppColors.secondaryText)
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
                        .foregroundStyle(AppColors.primaryBlue)
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                    
                    Text("Al continuar, aceptas nuestros Términos y Condiciones y Política de Privacidad.")
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(AppColors.secondaryText)
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
                    .foregroundStyle(AppColors.mutedText)
                
                TextField("Correo electrónico", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .foregroundStyle(AppColors.primaryText)
                    .tint(AppColors.primaryBlue)
                    .accessibilityIdentifier("login_email_textfield")
                    .onChange(of: viewModel.email) { _, _ in
                        viewModel.clearErrorOnInput()
                    }
            }
            .padding()
            
            Divider()
                .overlay(AppColors.dividerColor)
            
            HStack(spacing: 12) {
                Image(systemName: "lock")
                    .foregroundStyle(AppColors.mutedText)
                
                Group {
                    if viewModel.isPasswordVisible {
                        TextField("Contraseña", text: $viewModel.password)
                            .accessibilityIdentifier("login_password_textfield")
                    } else {
                        SecureField("Contraseña", text: $viewModel.password)
                            .accessibilityIdentifier("login_password_textfield")
                    }
                }
                .foregroundStyle(AppColors.primaryText)
                .tint(AppColors.primaryBlue)
                .onChange(of: viewModel.password) { _, _ in
                    viewModel.clearErrorOnInput()
                }
                
                Button(viewModel.isPasswordVisible ? "Ocultar" : "Mostrar") {
                    viewModel.isPasswordVisible.toggle()
                }
                .font(.subheadline)
                .foregroundStyle(AppColors.primaryBlue)
            }
            .padding()
        }
        .background(AppColors.inputBackground)
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
                .fill(Color.red.opacity(0.10))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.red.opacity(0.20), lineWidth: 1)
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
                                AppColors.primaryTeal,
                                AppColors.primaryBlue
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
        .buttonStyle(.plain)
        .disabled(!viewModel.isFormValid || viewModel.isLoading)
        .opacity((!viewModel.isFormValid || viewModel.isLoading) ? 0.7 : 1)
        .accessibilityIdentifier("login_submit_button")
    }
    
    var credentialsBorderColor: Color {
        if viewModel.shouldShowEmailError || viewModel.shouldShowPasswordError {
            return Color.red.opacity(0.7)
        } else if !viewModel.errorMessage.isEmpty {
            return Color.red.opacity(0.45)
        } else {
            return AppColors.dividerColor
        }
    }
}
