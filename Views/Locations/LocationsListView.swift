//
//  LocationsListView.swift
//  Maply
//
//  Created by Wilder Moreno on 19/04/26.
//

import SwiftUI

struct LocationsListView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Ubicaciones guardadas") {
                    Label("Casa", systemImage: "mappin.and.ellipse")
                    Label("Trabajo", systemImage: "mappin.and.ellipse")
                    Label("Universidad", systemImage: "mappin.and.ellipse")
                }
            }
            .navigationTitle("Ubicaciones")
        }
    }
}

#Preview {
    LocationsListView()
}
