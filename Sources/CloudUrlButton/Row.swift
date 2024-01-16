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
    
    @Binding
    var url: URL
    
    @State
    private var iconName: String = "icloud"
    
    @State
    var text: String = "loading..."
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: iconName)
                .loadIsOk(url: $url, iconName: $iconName)
            VStack(alignment: .leading) {
                switch typeOfRow {
                case .button:
                    Text(url.pretty())
                        .font(.headline)
                        .minimumScaleFactor(0.3)
                        .scaledToFill()
                    Text(text)
                        .loadAbout(url: $url, text: $text)
                        .font(.subheadline)
                        .minimumScaleFactor(0.3)
                        .scaledToFill()
                case .list:
                    Text(url.pretty())
                        .font(.headline)
                        .lineLimit(1)
                        .minimumScaleFactor(0.3)
                    Text(text)
                        .loadAbout(url: $url, text: $text)
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
        
    }
    
}

#Preview {
    Group {
        //        Row(typeOfRow: .button, url: URL(string: "https://axxoncloud-test1.axxoncloud.com/")!)
        //        Row(typeOfRow: .list, url: URL(string: "https://axxoncloud-test.axxoncloud.com/")!)
        //        Row(typeOfRow: .list, url: URL(string: "https://temp-uri.org")!)
    }
}
