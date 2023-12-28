//
//  SwiftUIView.swift
//
//
//  Created by Alexey Govorovsky on 21.12.2023.
//

import SwiftUI

struct CloudUrlDialog: View {
        
    @Binding
    var url: URL
    
    @AppStorage("cloud")
    private var clouds: [URL] = []
    
    @State
    private var editMode: EditMode = .inactive
    
    @State
    private var isShowingSheet = false
    
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
                    Row(url: cloud, typeOfRow: .list)
                        .onTapGesture {
                            tapCloudAction(cloud: cloud)
                        }
                        .swipeActions {
                            Button(action: {
                                removeCloud(cloud: cloud)
                            }, label: {
                                Image(systemName: "trash")
                            })
                            .tint(.red)
                            
                            NavigationLink {
                                NewCloudView(clouds: $clouds, url: $url, index: clouds.firstIndex(of: cloud))
                            } label: {
                                Image(systemName: "pencil")
                            }
                        }
                    if url == cloud {
                        Image(systemName: "checkmark")
                    }
                }
            }
            .onDelete(perform: { indexSet in
                clouds.remove(atOffsets: indexSet)
            })
        }
        .sheet(isPresented: $isShowingSheet) {
            NavigationView {
                NewCloudView(clouds: $clouds, url: $url, index: nil)
            }
        }
        .onAppear {
            if clouds.count == 0 {
                clouds.append(url)
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
    
    private func tapCloudAction(cloud: URL) {
        url = cloud
    }
    
    private func editCloudAction() {
        editMode = .active
    }
    
    private func removeCloud(cloud: URL) {
        guard let index = clouds.firstIndex(of: cloud)
        else { return }
        if url == cloud && clouds.count > 1 {
            if index == 0 {
                url = clouds[index + 1]
            } else {
                url = clouds[index - 1]
            }
            clouds.remove(at: index)
        } else if clouds.count > 1 {
            clouds.remove(at: index)
        }
    }
    
    private func addCloudAction() {
        isShowingSheet.toggle()
    }
}

