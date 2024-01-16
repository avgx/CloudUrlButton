// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import Get

public struct CloudUrlButton: View {
    
    public init() {
        
    }
    
    /// sample: https://axxoncloud-test1.axxoncloud.com/
    @AppStorage("cloud_url")
    var url: URL = CloudUrlKey.defaultValue.wrappedValue
    
    @State 
    var changeUrl: Bool = false
        
    public var body: some View {
        Button(action: {
            changeUrl.toggle()
        }) {
            Row(typeOfRow: .button, url: $url)
                .frame(height: 24)
                .frame(maxWidth: .infinity)
        }
        .sheet(isPresented: $changeUrl, content: {
            CloudUrlDialog(url: $url)
        })
    }
}

#Preview {
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
