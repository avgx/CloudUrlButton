// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import Get

struct CloudUrlButton: View {
    
    /// sample: https://axxoncloud-test1.axxoncloud.com/
    @AppStorage("cloud_url")
    var url: URL = CloudUrlKey.defaultValue.wrappedValue
    
    /// take string from /resultObject/branchName
    /// or show error if cloud is not available
    @State var branchNameOrError: Result<String, Error> = .success("TODO: load from /api/v1/about") 
    @State var changeUrl: Bool = false
    
    var aboutStr: String {
        switch branchNameOrError {
        case .success(let s):
            return s
        case .failure(let e):
            return e.localizedDescription
        }
    }
    var isOK: Bool {
        switch branchNameOrError {
        case .success(_):
            return true
        case .failure(_):
            return false
        }
    }
    
    var body: some View {
        Button(action: { changeUrl.toggle() }) {
            Row(title: url.pretty(), subtitle: aboutStr, isOK: isOK)
            .frame(height: 24)
            .frame(maxWidth: .infinity)
        }
        .sheet(isPresented: $changeUrl, content: {
            CloudUrlDialog()
                .environment(\.cloudUrl, $url)
        })
        .task {
            await loadAbout()
        }
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
