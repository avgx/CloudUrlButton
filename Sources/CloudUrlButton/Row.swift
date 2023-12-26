//
//  SwiftUIView.swift
//  
//
//  Created by Alexey Govorovsky on 21.12.2023.
//

import SwiftUI

enum RowType {
    case buttton
    case list
}

struct Row: View {
    var url: URL
    let typeOfRow: RowType
    
    private var iconName: String {
        return isOK ? "icloud" : "icloud.slash"
    }
    
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
    
    private var isOK: Bool {
        switch branchNameOrError {
        case .success(_):
            return true
        case .failure(_):
            return false
        }
    }
    
    init(url: URL, typeOfRow: RowType) {
        self.url = url
        self.typeOfRow = typeOfRow
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: iconName)
            VStack(alignment: .leading) {
                switch typeOfRow {
                case .buttton:
                    Text(url.pretty())
                        .font(.headline)
                        .minimumScaleFactor(0.3)
                        .scaledToFill()
                    Text(aboutStr)
                        .font(.subheadline)
                        .minimumScaleFactor(0.3)
                        .scaledToFill()
                case .list:
                    Text(url.pretty())
                        .font(.headline)
                        .minimumScaleFactor(0.3)
                }
            }
            Spacer()
            if typeOfRow == .buttton {
                Image(systemName: "chevron.down")
            }
        }
        .task {
            await loadAbout(url: url)
        }
        .onChange(of: url, perform: { newUrl in
            Task {
                await loadAbout(url: newUrl)
            }
        })
    }
}

#Preview {
    Group {
        Row(url: URL(string: "https://axxoncloud-test1.axxoncloud.com/")!, typeOfRow: .list)
        Row(url: URL(string: "https://axxoncloud-test.axxoncloud.com/")!, typeOfRow: .buttton)
    }
}
