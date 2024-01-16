//
//  SwiftUIView.swift
//
//
//  Created by Alexey Govorovsky on 21.12.2023.
//

import SwiftUI

extension URL : Identifiable {
    public var id: String { self.absoluteString }
}
extension String: Identifiable {
    public var id: String { self }
}

struct CloudUrlDialog: View {
        
    @Environment(\.dismiss)
    private var dismiss
    
    @Binding
    var url: URL
    
    @AppStorage("cloud")
    private var clouds: [URL] = []
    
    @State
    private var editMode: EditMode = .inactive
    
    @State 
    private var editValue: URL? = nil
    
    @State
    private var isNew: Bool = false
    
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
        List {
            ForEach(Array(clouds.enumerated()), id: \.offset) { index, cloud in
                HStack {
                    Row(typeOfRow: .list, url: $clouds[index])
                        .onTapGesture {
                            if editMode == .active {
                                editValue = cloud
                            } else {
                                url = cloud
                                dismiss()
                            }
                        }
                        .swipeActions {
                            if cloud != url {
                                Button(action: {
                                    removeCloud(cloud)
                                }, label: {
                                    Image(systemName: "trash")
                                })
                                .tint(.red)
                            }
                            
                            Button(action: {
                                editValue = cloud
                            }, label: {
                                Image(systemName: "pencil")
                            })
                            
                        }
                    if url == cloud {
                        Image(systemName: "checkmark")
                    }
                }
                .id(cloud)
            }
            .onDelete(perform: { indexSet in
                clouds.remove(atOffsets: indexSet)
            })
        }
        .sheet(isPresented: $isNew, onDismiss: {
            print("onDismiss")
        }) { 
            NewCloudView(value: nil, action: addOrChange)
        }
        .sheet(item: $editValue, onDismiss: {
            print("onDismiss")
            print(editValue?.absoluteString)
            editValue = nil
        }) { item in
            NewCloudView(value: item, action: addOrChange)
        }
        .onAppear {
            validate()
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                EditButton()
            }
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    isNew.toggle()
                }, label: {
                    Image(systemName: "plus")
                })
            }
            
        })
        .navigationTitle("Select cloud")
        .environment(\.editMode, $editMode)
    }
    
    private func removeCloud(_ x: URL) {
        clouds = clouds.filter({ $0 != x })
    }
    
    private func addOrChange(old: URL?, res: URL) {
        print("\(#function) \(old?.absoluteString) -> \(res.absoluteString)")
        
        if let old,
           let i = clouds.firstIndex(of: old) {
            //edit
            if clouds[i] == url {
                url = res
            }
            clouds[i] = res
        } else {
            //add
            clouds.append(res)
        }
        validate()
    }
    
    /// the validation
    private func validate() {
         print(clouds)
        clouds = Array(Set(clouds)).sorted(by: { a, b in a.absoluteString < b.absoluteString })
        if clouds.count == 0 {
            clouds.append(url)
        }
    }
}



