//
//  EnvironmentValues.swift
//  
//
//  Created by Alexey Govorovsky on 21.12.2023.
//

import SwiftUI

struct CloudUrlKey: EnvironmentKey {
    static var defaultValue: Binding<URL> = Binding.constant(URL(string: "https://axxoncloud-test1.axxoncloud.com/")!)
}

extension EnvironmentValues {
    var cloudUrl: Binding<URL> {
        get { self[CloudUrlKey.self] }
        set { self[CloudUrlKey.self] = newValue }
    }
}
