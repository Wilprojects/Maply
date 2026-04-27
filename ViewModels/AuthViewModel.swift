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
    
    var isFormValid: Bool {
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    init() {
        restoreSession()
    }
    
    func login() {
        errorMessage = ""
        
        guard isFormValid else {
            errorMessage = "Completa correo y contraseña."
            return
        }
        
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.isLoading = false
            
            if self.email == "demo@maply.com" && self.password == "123456" {
                let fakeToken = UUID().uuidString
                
                let tokenSaved = KeychainService.shared.save(fakeToken, forKey: KeychainKeys.authToken)
                let emailSaved = KeychainService.shared.save(self.email, forKey: KeychainKeys.userEmail)
                
                if tokenSaved && emailSaved {
                    self.isLoggedIn = true
                } else {
                    self.errorMessage = "No se pudo guardar la sesión de forma segura."
                }
            } else {
                self.errorMessage = "Credenciales inválidas."
            }
        }
    }
    
    func logout() {
        KeychainService.shared.delete(forKey: KeychainKeys.authToken)
        KeychainService.shared.delete(forKey: KeychainKeys.userEmail)
        
        email = ""
        password = ""
        isLoggedIn = false
    }
    
    func restoreSession() {
        if let token = KeychainService.shared.read(forKey: KeychainKeys.authToken),
           !token.isEmpty {
            email = KeychainService.shared.read(forKey: KeychainKeys.userEmail) ?? ""
            isLoggedIn = true
        }
    }
}
