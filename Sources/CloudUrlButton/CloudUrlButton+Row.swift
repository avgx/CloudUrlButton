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
        
        var body: some View {
            HStack(spacing: 8) {
                Image(systemName: "cloud")
                //.frame(width: 40, height: 40)
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                        .minimumScaleFactor(0.3)
                        .scaledToFill()
                    Text(subtitle)
                        .font(.subheadline)
                        .minimumScaleFactor(0.3)
                        .scaledToFill()
                }
                //.border(.red)
                Spacer()
                Image(systemName: "chevron.down")
            }
        }
    }
    
}

#Preview {
    CloudUrlButton.Row(title: "aaa", subtitle: "bbb")
}
