//
//  AboutURL.swift
//
//
//  Created by Артём Черныш on 29.12.23.
//

import SwiftUI

struct AboutURL: View {
    /// take string from /resultObject/branchName
    /// or show error if cloud is not available
    @State
    var branchNameOrError: Result<String, Error> = .success("TODO: load from /api/v1/about")
    
    private var aboutStr: String {
        switch branchNameOrError {
        case .success(let s):
            return s
        case .failure(let e):
            return e.localizedDescription
        }
    }
    
    let url: URL
    
    var body: some View {
        Text(aboutStr)
            .task {
                Task {
                    branchNameOrError = try await LoadData.loadAbout(url: url)
                }
            }
            .onChange(of: url, perform: { newUrl in
                print(url, newUrl)
                Task {
                    branchNameOrError = try await LoadData.loadAbout(url: newUrl)
                }
            })
        }
    }

#Preview {
    Group {
        AboutURL(url: URL(string: "https://axxoncloud-test1.axxoncloud.com/")!)
        AboutURL(url: URL(string: "test.com")!)
    }
}
