//
//  SwiftUIView.swift
//
//
//  Created by Alexey Govorovsky on 21.12.2023.
//

import SwiftUI

struct Row: View {
    enum RowType {
        case button
        case list
    }
    
    let url: URL
    let typeOfRow: RowType
    
    private var iconName: String {
        return isOK ? "icloud" : "icloud.slash"
    }
    
    private var isOK: Bool {
        switch branchNameOrError {
        case .success(_):
            return true
        case .failure(_):
            return false
        }
    }
    
    @State
    var branchNameOrError: Result<String, Error> = .success("TODO: load from /api/v1/about")
    
    init(url: URL, typeOfRow: RowType) {
        self.url = url
        self.typeOfRow = typeOfRow
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: iconName)
            VStack(alignment: .leading) {
                switch typeOfRow {
                case .button:
                    Text(url.pretty())
                        .font(.headline)
                        .minimumScaleFactor(0.3)
                        .scaledToFill()
                    AboutURL(url: url)
                        .font(.subheadline)
                        .minimumScaleFactor(0.3)
                        .scaledToFill()
                case .list:
                    Text(url.pretty())
                        .font(.headline)
                        .lineLimit(1)
                        .minimumScaleFactor(0.3)
                    AboutURL(url: url)
                        .font(.subheadline)
                        .lineLimit(1)
                        .minimumScaleFactor(0.3)
                }
            }
            Spacer()
            if typeOfRow == .button {
                Image(systemName: "chevron.down")
            }
        }
        .task {
            Task {
                branchNameOrError = try await LoadData.loadAbout(url: url)
            }
        }
    }
    
}

#Preview {
    Group {
        Row(url: URL(string: "https://axxoncloud-test1.axxoncloud.com/")!, typeOfRow: .button)
        Row(url: URL(string: "https://axxoncloud-test.axxoncloud.com/")!, typeOfRow: .list)
        Row(url: URL(string: "https://temp-uri.org")!, typeOfRow: .list)
    }
}
