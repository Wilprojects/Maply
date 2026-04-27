//
//  RootView.swift
//  Maply
//
//  Created by Wilder Moreno on 18/04/26.
//

import SwiftUI

struct RootView: View {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        Group {
            if authViewModel.isLoggedIn {
                MainTabView(authViewModel: authViewModel)
            } else {
                LoginView(isLoggedIn: $authViewModel.isLoggedIn)
            }
        }
    }
}

#Preview {
    RootView()
}
