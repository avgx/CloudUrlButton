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
    
    @Binding
    private var isButtonDisabled: Bool
    
    @State
    private var aboutStr: String = ""
    
    @State
    private var textChanging = false
    
    public init(text: Binding<String>, loadAbout: @escaping (URL) async throws -> (URL, String), isButtonDisabled: Binding<Bool>) {
        self.loadAbout = loadAbout
        self._text = text
        self._isButtonDisabled = isButtonDisabled
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
                    isButtonDisabled = text.asURL() == nil
                }
            Text(aboutStr)
                .font(.subheadline)
                .minimumScaleFactor(0.3)
                .frame(maxWidth: .infinity)
                .scaledToFill()
//                .overlay(
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
//                )
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
    UrlTextField(text: Binding<String>.constant("test"), loadAbout: { x in return (x, "123") }, isButtonDisabled: Binding<Bool>.constant(true))
}
