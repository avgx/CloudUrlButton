// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
//import Get

public struct CloudUrlButton: View {
    
    /// from https://swiftwithmajid.com/2022/02/02/microapps-architecture-in-swift-dependency-injection/
    let loadAbout: (URL) async throws -> (URL, String)
    public init(loadAbout: @escaping (URL) async throws -> (URL, String)) {
        self.loadAbout = loadAbout
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
            Row(typeOfRow: .button, url: url, loadAbout: loadAbout)
                .frame(height: 24)
                .frame(maxWidth: .infinity)
        }
        .sheet(isPresented: $changeUrl, content: {
            CloudUrlDialog(url: $url, loadAbout: loadAbout)
        })
    }
}

#Preview {
    Group {
        VStack {
            Text("Select cloud url button:")
            CloudUrlButton(
                loadAbout: { x in
                    print("test loading \(x.absoluteString)")
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    print("test loaded \(x.absoluteString)")
                    return (x, "v1.2.3.4")
                }
            )
            .buttonStyle(.bordered)
            .controlSize(.large)
            .buttonBorderShape(.roundedRectangle)
            .tint(Color.orange)
        }
    }
    .padding()
    
}
