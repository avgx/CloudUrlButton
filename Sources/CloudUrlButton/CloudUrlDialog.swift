//
//  SwiftUIView.swift
//  
//
//  Created by Alexey Govorovsky on 21.12.2023.
//

import SwiftUI

struct CloudUrlDialog: View {
    
    @Environment(\.cloudUrl) private var url: Binding<URL>
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                content
            }
        } else {
            // Fallback on earlier versions
            NavigationView {
                content
            }
            .navigationViewStyle(.stack)
        }
    }
    
    @ViewBuilder
    var content: some View {
        List {
            Text("TODO:")
            Text("CRUD for cloud urls")
            Text("Can't become empty. Don't delete if only 1 url in a list")
            Text("need to load cloud version")
            Text("Current url is:")
            Text("[\(url.wrappedValue.pretty())](\(url.wrappedValue.pretty()))")
        }
        .navigationTitle("Select cloud")
        .toolbar(content: {
            EditButton()
        })
    }
}

#Preview {
    CloudUrlDialog()
}
