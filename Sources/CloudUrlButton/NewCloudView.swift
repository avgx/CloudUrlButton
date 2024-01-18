//
//  NewCloudView.swift
//
//
//  Created by Артём Черныш on 27.12.23.
//

import SwiftUI

struct NewCloudView: View {
    let value: URL?
    let action: (URL?, URL) -> Void
    let loadAbout: (URL) async throws -> (URL, String)
    
    @Environment(\.dismiss)
    private var dismiss
    
    @State
    private var text: String = ""
    @State
    private var textChanging = false
    
    @State
    private var aboutStr: String = ""
    
    @State
    private var isButtonDisabled: Bool = true
    
    public init(value: URL?, action: @escaping (URL?, URL) -> Void, loadAbout: @escaping (URL) async throws -> (URL, String)) {
         print("NewCloudView \(value?.absoluteString)")
        self.value = value
        self.action = action
        self.loadAbout = loadAbout
        self._text = State(initialValue: value?.pretty() ?? "")
    }
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                content
            }
        } else {
            // Fallback on earlier versions
            NavigationView {
                content
            }
            .navigationViewStyle(.stack)
        }
    }
    
    @ViewBuilder
    var content: some View {
        VStack {
            TextField("URL", text: $text)
                .keyboardType(.URL)
                .autocorrectionDisabled()
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.secondary.opacity(0.2))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
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
            
            Button(action: {
                Task {
                    guard let resUrl = text.asURL() else {
                        isButtonDisabled = true
                        return
                    }
                    action(value, resUrl)
                    dismiss()
                }
            }, label: {
                Text("Save")
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity)
            .disabled(isButtonDisabled)
        }
        .padding()
        .onAppear {
            isButtonDisabled = URL(string: text) == nil
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
        .navigationTitle(value == nil ? "Add new" : "Update")
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                }
            }
        })
    }
    
    
}

#Preview {
    Group {
        NewCloudView(value: nil, action: { old, res in print("\(old?.absoluteString) -> \(res.absoluteString)") }, loadAbout: { x in return (x, "123") })
        
        NewCloudView(value: URL(string: "http://temp-uri.org"), action: { old, res in print("\(old?.absoluteString) -> \(res.absoluteString)") }, loadAbout: { x in return (x, "123") })
    }
    .padding()
    
}
