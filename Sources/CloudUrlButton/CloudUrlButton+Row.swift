//
//  SwiftUIView.swift
//  
//
//  Created by Alexey Govorovsky on 21.12.2023.
//

import SwiftUI

extension CloudUrlButton {
    struct Row: View {
        let title: String
        let subtitle: String
        let isOK: Bool
        
        var iconName: String {
            return isOK ? "icloud" : "icloud.slash"
        }
        
        var body: some View {
            HStack(spacing: 8) {
                Image(systemName: iconName)
                //.frame(width: 40, height: 40)
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                        .minimumScaleFactor(0.3)
                        .scaledToFill()
                    Text(subtitle)
                        .font(.subheadline)
                        .minimumScaleFactor(0.3)
                        //.lineLimit(3)
                        .scaledToFill()
                }
                //.border(.red)
                Spacer()
                Image(systemName: "chevron.down")
            }
        }
    }
    
}

let someError: String = String(
    URLError(.cannotFindHost)
        .localizedDescription
        .split(separator: "(")
        .first ?? "-"
)

#Preview {
    Group {
        CloudUrlButton.Row(title: "cloud ok", subtitle: "good", isOK: true)
        
        CloudUrlButton.Row(title: "cloud not ok", subtitle: someError, isOK: false)
    }
}
