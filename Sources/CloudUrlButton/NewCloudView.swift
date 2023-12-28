//
//  NewCloudView.swift
//
//
//  Created by Артём Черныш on 27.12.23.
//

import SwiftUI

struct NewCloudView: View {
    @Binding
    var clouds: [URL]
    
    @Binding
    var url: URL
    
    @State
    var index: Int?
    
    @State
    private var text: String = ""
    
    @State
    private var isButtonDisabled: Bool = true
    
    var body: some View {
        VStack {
            TextField("Cloud name", text: $text)
                .onChange(of: text, perform: { _ in
                     isButtonDisabled = didDismissSheet()
                })
            Button(action: {
                guard let newUrl = URL(string: text)
                else { return }
                if let index {
                    if url == clouds[index] {
                        url = newUrl
                    }
                    clouds[index] = newUrl
                } else {
                    clouds.append(newUrl)
                }
            }, label: {
                Text("Save")
            })
            .disabled(isButtonDisabled)
        }
        .onAppear {
            if let index {
                text = clouds[index].absoluteString
            }
        }
        .navigationTitle(index == nil ? "Add new cloud" : "Update cloud")
    }
        
    private func didDismissSheet() -> Bool {
        guard let newUrl = URL(string: text)
        else { return false }
        return checkCreationOfURL(url: newUrl)
    }

    private func checkCreationOfURL(url: URL) -> Bool {
        for index in 0..<clouds.count {
            if url == clouds[index] {
                return true
            }
        }
        return false
    }

}
