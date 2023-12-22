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
    
    @FocusState
    private var focus: Int?
    
    @State
    private var isEditedForIndex: Int?
    
    @EnvironmentObject
    var clouds: Clouds
    
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
            ForEach(Array(clouds.cloud.enumerated()), id: \.offset) { index, cloud in
                if isEditedForIndex == index {
                    TextField("Cloud name", text: Binding<String> (
                        get: {
                            cloud
                        },
                        set: { newValue in
                            clouds.cloud[index] = newValue
                        }))
                    .focused($focus, equals: index)
                    .disabled(!(isEditedForIndex == index))
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
                } else {
                    Text(cloud)
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
                }
            }
            .onDelete(perform: { _ in })
            Text("Actual cloud: \n\(clouds.cloud[clouds.actualCloudIndex])")
        }
        .navigationTitle("Select cloud")
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                EditButton()
            }
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    addCloudAction()
                }, label: {
                    Text("Add")
                })
            }
            
        })
    }
    
    private func tapCloudAction(index: Int) {
        if isEditedForIndex == nil {
            clouds.actualCloudIndex = index
        } else if isEditedForIndex != index {
            isEditedForIndex = nil
        }
    }
    
    private func deleteCloudAction(index: Int) {
        if clouds.cloud.count > 1 &&
            index != clouds.cloud.count - 1 {
            clouds.cloud.remove(at: index)
        } else if clouds.cloud.count > 1 {
            clouds.actualCloudIndex = 0
            clouds.cloud.remove(at: index)
        }
    }
    
    private func editCloudAction(index: Int) {
        clouds.actualCloudIndex = index
        isEditedForIndex = index
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
            focus = index
        }
    }
    
    private func addCloudAction() {
        clouds.cloud.append("")
        isEditedForIndex = clouds.cloud.count - 1
        focus = clouds.cloud.count - 1
    }
}

#Preview {
    CloudUrlDialog()
        .environmentObject(Clouds(cloud: [
            "CLOUD1",
            "CLOUD2",
            "CLOUD3",
            "CLOUD4",
            "CLOUD5"
        ], actualCloudIndex: 1))
}


