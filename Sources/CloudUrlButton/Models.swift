//
//  File.swift
//  
//
//  Created by Alexey Govorovsky on 21.12.2023.
//

import Foundation

struct CloudObjectResponse<T: Codable> : Codable {
    public let result: String
    public let statusCode: Int
    public let messageKey: String?
    public let messageDescription: String?
    public let countInPage: Int?
    public let totalCount: Int?
    
    public let resultObject: T?    
}

struct About : Codable {
    public let planKey: String?
    public let buildNumber: String
    public let branchName: String
    public let revisionNumber: String?
}

class Clouds: ObservableObject {
    @Published
    var cloud: [String]
    
    @Published
    var actualCloudIndex: Int
    
    init() {
        cloud = [""]
        actualCloudIndex = 0
    }
    
    init(cloud: [String], actualCloudIndex: Int) {
        self.cloud = cloud
        self.actualCloudIndex = actualCloudIndex
    }
    
    func loadClouds(cloud: [String], actualCloudIndex: Int) async {
        self.cloud = cloud
        self.actualCloudIndex = actualCloudIndex
    }
}
