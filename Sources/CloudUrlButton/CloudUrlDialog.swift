//
//  SwiftUIView.swift
//
//
//  Created by Alexey Govorovsky on 21.12.2023.
//

import SwiftUI

struct CloudUrlDialog: View {
    
    @Environment(\.cloudUrl)
    private var url: Binding<URL>
    
    @AppStorage("actual_cloud_index")
    private var actualCloudIndex: Int = 0
    
    @AppStorage("cloud")
    private var clouds: [URL?] = []
    
    @State
    private var editMode: EditMode = .inactive
    
    @FocusState
    private var focus: Int?
    
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
                if editMode == .active {
                    createTextField(cloud: cloud, index: index)
                } else {
                    createText(cloud: cloud, index: index)
                }
            }
            .onDelete(perform: { _ in })
        }
        .onAppear {
            if clouds.count == 0 {
                clouds.append(url.wrappedValue)
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                EditButton()
            }
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    addCloudAction()
                }, label: {
                    Image(systemName: "plus")
                })
            }
            
        })
        .navigationTitle("Select cloud")
        .environment(\.editMode, $editMode)
    }
    
    private func createTextField(cloud: URL?, index: Int) -> some View {
        HStack {
            TextField("Cloud name", text: Binding<String> (
                get: {
                    cloud?.absoluteString ?? ""
                },
                set: { newValue in
                    guard let newUrl = URL(string: newValue)
                    else {
                        clouds[index] = URL(string: "")
                        return
                    }
                    clouds[index] = newUrl
                }))
            .focused($focus, equals: index)
            .onTapGesture {
                tapCloudAction(index: index)
            }
            .swipeActions {
                Button(action: {
                    deleteCloudAction(index: index)
                }, label: {
                    Image(systemName: "trash")
                })
                .tint(.red)
                
                Button(action: {
                    editCloudAction(index: index)
                }, label: {
                    Image(systemName: "pencil")
                })
            }
            if actualCloudIndex == index {
                Image(systemName: "checkmark")
            }
        }
    }
    
    private func createText(cloud: URL?, index: Int) -> some View {
        HStack {
            Text(cloud?.pretty() ?? "")
                .onTapGesture {
                    tapCloudAction(index: index)
                }
                .swipeActions {
                    Button(action: {
                        deleteCloudAction(index: index)
                    }, label: {
                        Image(systemName: "trash")
                    })
                    .tint(.red)
                    
                    Button(action: {
                        editCloudAction(index: index)
                    }, label: {
                        Image(systemName: "pencil")
                    })
                }
            if actualCloudIndex == index {
                Image(systemName: "checkmark")
            }
        }
    }
    
    private func tapCloudAction(index: Int) {
        actualCloudIndex = index
    }
    
    private func deleteCloudAction(index: Int) {
        if actualCloudIndex == index && clouds.count > 1 {
            actualCloudIndex = 0
            clouds.remove(at: index)
        } else if clouds.count > 1 {
            clouds.remove(at: index)
        }
    }
    
    private func editCloudAction(index: Int) {
        editMode = .active
        focus = index
    }
    
    private func addCloudAction() {
        if let lastCloud = clouds.last,
           lastCloud?.absoluteString.count != nil {
            clouds.append(URL(string: ""))
        }
        editMode = .active
        focus = clouds.count - 1
    }
}

#Preview {
    CloudUrlDialog()
}


