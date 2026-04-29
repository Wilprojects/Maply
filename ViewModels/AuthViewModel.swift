//
//  AuthViewModel.swift
//  Maply
//
//  Created by Wilder Moreno on 18/04/26.
//

import Foundation
import SwiftUI
import Combine

final class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isPasswordVisible: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLoggedIn: Bool = false
    
    var trimmedEmail: String {
        email.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var trimmedPassword: String {
        password.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isFormValid: Bool {
        !trimmedEmail.isEmpty && !trimmedPassword.isEmpty
    }
    
    var shouldShowEmailError: Bool {
        !errorMessage.isEmpty && trimmedEmail.isEmpty
    }
    
    var shouldShowPasswordError: Bool {
        !errorMessage.isEmpty && trimmedPassword.isEmpty
    }
    
    init() {
        restoreSession()
    }
    
    func login() {
        errorMessage = ""
        
        guard !trimmedEmail.isEmpty else {
            errorMessage = "Ingresa tu correo electrónico."
            return
        }
        
        guard !trimmedPassword.isEmpty else {
            errorMessage = "Ingresa tu contraseña."
            return
        }
        
        guard isValidEmail(trimmedEmail) else {
            errorMessage = "Ingresa un correo válido."
            return
        }
        
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.isLoading = false
            
            if self.trimmedEmail.lowercased() == "wilder@maply.com" && self.trimmedPassword == "123456" {
                let fakeToken = UUID().uuidString
                
                let tokenSaved = KeychainService.shared.save(fakeToken, forKey: KeychainKeys.authToken)
                let emailSaved = KeychainService.shared.save(self.trimmedEmail, forKey: KeychainKeys.userEmail)
                
                if tokenSaved && emailSaved {
                    self.errorMessage = ""
                    self.isLoggedIn = true
                } else {
                    self.errorMessage = "No se pudo guardar la sesión de forma segura."
                }
            } else {
                self.errorMessage = "Correo o contraseña incorrectos."
            }
        }
    }
    
    func logout() {
        KeychainService.shared.delete(forKey: KeychainKeys.authToken)
        KeychainService.shared.delete(forKey: KeychainKeys.userEmail)
        
        email = ""
        password = ""
        errorMessage = ""
        isLoggedIn = false
    }
    
    func restoreSession() {
        if let token = KeychainService.shared.read(forKey: KeychainKeys.authToken),
           !token.isEmpty {
            email = KeychainService.shared.read(forKey: KeychainKeys.userEmail) ?? ""
            isLoggedIn = true
        }
    }
    
    func clearErrorOnInput() {
        if !errorMessage.isEmpty {
            errorMessage = ""
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let regex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return email.range(of: regex, options: .regularExpression) != nil
    }
}
