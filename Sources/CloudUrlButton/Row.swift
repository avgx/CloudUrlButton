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
    
    let typeOfRow: RowType
    
    let url: URL
    
    let loadAbout: (URL) async throws -> (URL, String)
    
    @State
    private var iconName: String = "icloud"
    
    @State
    var text: String = "loading..."
    
    public init(typeOfRow: RowType, url: URL, loadAbout: @escaping (URL) async throws -> (URL, String)) {
        self.typeOfRow = typeOfRow
        self.url = url
        self.loadAbout = loadAbout
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: iconName)
                //.loadIsOk(url: $url, iconName: $iconName)
            VStack(alignment: .leading) {
                switch typeOfRow {
                case .button:
                    Text(url.pretty())
                        .font(.headline)
                        .minimumScaleFactor(0.3)
                        .scaledToFill()
                    Text(text)
                        //.loadAbout(url: $url, text: $text)
                        .font(.subheadline)
                        .minimumScaleFactor(0.3)
                        .scaledToFill()
                case .list:
                    Text(url.pretty())
                        .font(.headline)
                        .lineLimit(1)
                        .minimumScaleFactor(0.3)
                    Text(text)
                        //.loadAbout(url: $url, text: $text)
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
            do {
                let s = try await loadAbout(url)
                self.text = s.1
                iconName = "icloud"
            } catch {
                self.text = error.localizedDescription
                iconName = "icloud.slash"
            }        
        }
        
    }
    
}

#Preview {
    Group {
        Row(typeOfRow: .button,
            url: URL(string: "https://axxoncloud-test1.axxoncloud.com/")!,
            loadAbout: { x in
                return (x, "1.2.3.4")
            })
        //        Row(typeOfRow: .list, url: URL(string: "https://axxoncloud-test.axxoncloud.com/")!)
        //        Row(typeOfRow: .list, url: URL(string: "https://temp-uri.org")!)
    }
}
