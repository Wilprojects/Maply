//
//  AuthViewModel.swift
//  Maply
//
//  Created by Wilder Moreno on 18/04/26.
//

import Foundation
import Combine

final class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isPasswordVisible: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLoggedIn: Bool = false
    
    var isFormValid: Bool {
        !email.trimmingCharacters(in: .whitespaces).isEmpty &&
        !password.trimmingCharacters(in: .whitespaces).isEmpty
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

            if self.email == "user@maply.com" && self.password == "123456" {
                self.isLoggedIn = true
            } else {
                self.errorMessage = "Credenciales inválidas."
            }
        }
    }
}
