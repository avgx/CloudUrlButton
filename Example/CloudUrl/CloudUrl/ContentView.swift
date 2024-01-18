//
//  ContentView.swift
//  CloudUrl
//
//  Created by Артём Черныш on 11.01.24.
//

import SwiftUI
import CloudUrlButton

struct ContentView: View {
    
    func load(_ url: URL) async throws -> (URL, String) {
        //return "123"
        return try await LoadData.loadAbout(url: url)
    }
    
    var body: some View {
        Group {
            VStack {
                Text("Select cloud url button:")
                CloudUrlButton(loadAbout: load)
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    .buttonBorderShape(.roundedRectangle)
                    .tint(Color.orange)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

