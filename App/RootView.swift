//
//  RootView.swift
//  Maply
//
//  Created by Wilder Moreno on 18/04/26.
//

import SwiftUI

struct RootView: View {
    
    @State private var isLoggedIn: Bool = false
    
    var body: some View {
        Group {
            if isLoggedIn {
                HomeView(isLoggedIn: $isLoggedIn)
            } else {
                LoginView(isLoggedIn: $isLoggedIn)
            }
        }
    }
}

#Preview {
    RootView()
}
