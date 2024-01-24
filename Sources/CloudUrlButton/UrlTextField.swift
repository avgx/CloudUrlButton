//
//  SwiftUIView.swift
//  
//
//  Created by Артём Черныш on 19.01.24.
//

import SwiftUI

struct UrlTextField: View {
    let loadAbout: (URL) async throws -> (URL, String)
    
    @Binding
    var text: String
    
    @State
    private var aboutStr: String = ""
    
    @State
    private var textChanging = false
    
    public init(text: Binding<String>, loadAbout: @escaping (URL) async throws -> (URL, String)) {
        self.loadAbout = loadAbout
        self._text = text
    }
    
    var body: some View {
        VStack {
            TextField("URL", text: $text)
                .keyboardType(.URL)
                .autocorrectionDisabled()
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.secondary.opacity(0.2))
                )
                .onChange(of: text) { newValue in
                    aboutStr = ""
                    textChanging = true
                }
                .onSubmit {
                    print(text)
                    textChanging = false
                }
            Text(aboutStr)
                .font(.subheadline)
                .minimumScaleFactor(0.3)
                .frame(maxWidth: .infinity)
                .scaledToFill()
        }
        .onChange(of: textChanging) { changing in
            if !changing, let url = text.asURL() {
                Task {
                    do {
                        let s = try await loadAbout(url)
                        await MainActor.run {
                            self.text = s.0.absoluteString
                            self.aboutStr = s.1
                        }
                    } catch {
                        await MainActor.run {
                            self.aboutStr = error.localizedDescription
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    UrlTextField(text: Binding<String>.constant("test"), loadAbout: { x in return (x, "123") })
}
