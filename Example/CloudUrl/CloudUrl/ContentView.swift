//
//  ContentView.swift
//  CloudUrl
//
//  Created by Артём Черныш on 11.01.24.
//

import SwiftUI
import CloudUrlButton

struct ContentView: View {
    var body: some View {
        Group {
            VStack {
                Text("Select cloud url button:")
                CloudUrlButton()
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

