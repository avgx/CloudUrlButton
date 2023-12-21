// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import Get

struct CloudUrlButton: View {
    
//    @AppStorage("cloud_url")
//    var cloudUrl: URL = URL(string: "https://axxoncloud-test1.axxoncloud.com/")!
//    
    //@State
    @AppStorage("cloud_url")
    var url: URL = CloudUrlKey.defaultValue.wrappedValue
    //URL(string: "https://axxoncloud-test1.axxoncloud.com/")!
    
    /// take string from /resultObject/branchName
    @State var branchName: String = "TODO: load from /api/v1/about"
    @State var changeUrl: Bool = false
    
    var body: some View {
        Button(action: { changeUrl.toggle() }) {
            Row(title: url.pretty(), subtitle: branchName)
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

extension CloudUrlButton {
    func loadAbout() async {
        //TODO: need to ensure that this is called only once
        print(#function)
        do {
            let http = APIClient(baseURL: url)
            
            let r = try await http.send(about()).value
            //self.about = .success(r.resultObject?.branchName ?? "-")
            print(r.resultObject?.branchName ?? "-")
            
            self.branchName = r.resultObject?.branchName ?? "-"
        } catch {
            self.branchName = error.localizedDescription
        }
    }
    
    public func about() -> Request<CloudObjectResponse<About>> {
        return Request(path: "/api/v1/about", method: .get, id: "about")
    }
}

struct CloudUrlKey: EnvironmentKey {
    static var defaultValue: Binding<URL> = Binding.constant(URL(string: "https://axxoncloud-test1.axxoncloud.com/")!)
}

extension EnvironmentValues {
    var cloudUrl: Binding<URL> {
        get { self[CloudUrlKey.self] }
        set { self[CloudUrlKey.self] = newValue }
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
