//
//  File.swift
//  
//
//  Created by Alexey Govorovsky on 21.12.2023.
//

import SwiftUI
import Get

class LoadData {
    public static func loadAbout(url: URL) async throws -> Result<String, Error> {
        //TODO: need to ensure that this is called only once
        print(#function)
        do {
            let http = APIClient(baseURL: url)
            let r = try await http.send(about()).value
            print(r.resultObject?.branchName ?? "-")
            return .success(r.resultObject?.branchName ?? "-")
        } catch {
            return .failure(error)
        }
    }
    
    private static func about() -> Request<CloudObjectResponse<About>> {
        return Request(path: "/api/v1/about", method: .get, id: "about")
    }
}
