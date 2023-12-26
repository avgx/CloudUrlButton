// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import Get

struct CloudUrlButton: View {
    
    /// sample: https://axxoncloud-test1.axxoncloud.com/
    @AppStorage("cloud_url")
    var url: URL = CloudUrlKey.defaultValue.wrappedValue
    
    @State 
    var changeUrl: Bool = false
        
    var body: some View {
        Button(action: {
            changeUrl.toggle()
        }) {
            Row(url: url, typeOfRow: .buttton)
            .frame(height: 24)
            .frame(maxWidth: .infinity)
        }
        .sheet(isPresented: $changeUrl, content: {
            CloudUrlDialog()
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
