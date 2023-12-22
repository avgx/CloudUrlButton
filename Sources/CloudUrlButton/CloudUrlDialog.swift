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
    private var isEdited: Bool = false
    
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

    @EnvironmentObject
    var clouds: Clouds

    @ViewBuilder
    var content: some View {
        List {
            ForEach(Array(clouds.cloud.enumerated()), id: \.offset) { index, cloud in
                TextField("Cloud name", text: Binding<String> (
                    get: {
                        cloud
                    },
                    set: { newValue in
                        clouds.cloud[index] = newValue
                    }))
                .focused($focus, equals: index)
                .disabled(!isEdited)
                .onTapGesture {
                    clouds.actualCloudIndex = index
                }
                .swipeActions {
                    Button(action: {
                        if clouds.cloud.count > 1 &&
                            index != clouds.cloud.count - 1 {
                            clouds.cloud.remove(at: index)
                        } else if clouds.cloud.count > 1 {
                            clouds.actualCloudIndex = 0
                            clouds.cloud.remove(at: index)
                        }
                    }, label: {
                        Image(systemName: "trash")
                    })
                    .tint(.red)
                }
            }
            Text("Actual cloud: \n\(clouds.cloud[clouds.actualCloudIndex])")
        }
        .navigationTitle("Select cloud")
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    isEdited.toggle()
                }, label: {
                    if isEdited {
                        Text("Done")
                            .bold()
                    } else {
                        Text("Edit")
                    }
                })
            }
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    if !isEdited {
                        isEdited.toggle()
                    }
                    clouds.cloud.append("")
                    focus = clouds.cloud.count - 1
                }, label: {
                    Text("Add")
                })
            }
        })
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


