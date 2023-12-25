//
//  SwiftUIView.swift
//
//
//  Created by Alexey Govorovsky on 21.12.2023.
//

import SwiftUI

struct CloudUrlDialog: View {
        
    @AppStorage("cloud_url")
    var actualUrl: URL = CloudUrlKey.defaultValue.wrappedValue
    
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
                            
                            Button(action: {
                                actualUrl = cloud
                                isShowingSheet.toggle()
                            }, label: {
                                Image(systemName: "pencil")
                            })
                        }
                    if actualUrl == cloud {
                        Image(systemName: "checkmark")
                    }
                }
            }
            .onDelete(perform: { indexSet in
                clouds.remove(atOffsets: indexSet)
            })
        }
        .sheet(isPresented: $isShowingSheet) {
            Text("Cloud name")
                .font(.system(size: 36))
                .bold()
            TextField("Cloud name", text: Binding<String> (
                get: {
                    actualUrl.absoluteString
                },
                set: { newValue in
                    guard let newUrl = URL(string: newValue),
                          let index = clouds.firstIndex(of: actualUrl)
                    else { return }
                    actualUrl = newUrl
                    clouds[index] = actualUrl
                }))
            Spacer()
        }
        .onAppear {
            if clouds.count == 0 {
                clouds.append(actualUrl)
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
        actualUrl = cloud
    }
    
    private func editCloudAction() {
        editMode = .active
    }
    
    private func removeCloud(cloud: URL) {
        guard let index = clouds.firstIndex(of: cloud)
        else { return }
        clouds.remove(at: index)
    }
    
    private func addCloudAction() {
        guard let lastUrl = URL(string: "https://")
        else { return }
        clouds.append(lastUrl)
        actualUrl = lastUrl
        isShowingSheet.toggle()
    }
}

#Preview {
    CloudUrlDialog()
}


