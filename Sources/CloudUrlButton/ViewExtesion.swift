////
////  ViewExtension.swift
////
////
////  Created by Артём Черныш on 16.01.24.
////
//
//import SwiftUI
//
//extension View {
//    func loadAbout(url: Binding<URL>, text: Binding<String>) -> some View {
//        
//        return self
//            .onAppear {
//                Task {
//                    text.wrappedValue = try await LoadData.loadAbout(url: url.wrappedValue)
//                }
//            }
//            .onChange(of: url.wrappedValue, perform: { newUrl in
//                Task {
//                    text.wrappedValue = try await LoadData.loadAbout(url: url.wrappedValue)
//                }
//            })
//    }
//    
//    func loadIsOk(url: Binding<URL>, iconName: Binding<String>) -> some View {
//        return self
//            .onAppear {
//                Task {
//                    iconName.wrappedValue = await loadDataIsOK(url: url.wrappedValue)
//                }
//            }
//            .onChange(of: url.wrappedValue, perform: { value in
//                Task {
//                    iconName.wrappedValue = await loadDataIsOK(url: url.wrappedValue)
//                }
//            })
//        
//    }
//    
//    private func loadDataIsOK(url: URL) async -> String {
//        do {
//            let result = try await LoadData.loadURL(url: url)
//            switch result {
//            case .success(_):
//                return "icloud"
//            case .failure(_):
//                return "icloud.slash"
//            }
//        } catch {
//            return "icloud.slash"
//        }
//    }
//}
