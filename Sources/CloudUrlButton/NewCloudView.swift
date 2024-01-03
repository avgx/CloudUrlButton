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
    
    @Environment(\.dismiss)
    private var dismiss
    
    @State
    private var text: String = ""
    
    @State
    private var isButtonDisabled: Bool = true
    
    @State
    private var aboutText: String = ""
    
    public init(value: URL?, action: @escaping (URL?, URL) -> Void) {
         print("NewCloudView \(value?.absoluteString)")
        self.value = value
        self.action = action
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
                .padding()
                .border(Color(UIColor.secondaryLabel))
                .onSubmit {
                     print(text)
                    isButtonDisabled = URL(string: text) == nil
                }
            if isButtonDisabled == false,
               let fixedUrl = makeFixedURL() {
                AboutURL(url: fixedUrl)
                    .font(.subheadline)
                    .minimumScaleFactor(0.3)
                    .frame(maxWidth: .infinity)
            }
            Button(action: {
                guard let resUrl = makeFixedURL()
                else { return }
                action(value, resUrl)
                dismiss()
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
        .navigationTitle(value == nil ? "Add new" : "Update")
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                }
            }
        })
    }
    
    private func makeFixedURL() -> URL? {
        let fixedRes = text.starts(with: "http://") ? text : "http://\(text)"
        return URL(string: fixedRes)
    }
}

#Preview {
    Group {
        NewCloudView(value: nil, action: { old, res in print("\(old?.absoluteString) -> \(res.absoluteString)") })
        
        NewCloudView(value: URL(string: "http://temp-uri.org"), action: { old, res in print("\(old?.absoluteString) -> \(res.absoluteString)") })
    }
    .padding()
    
}
