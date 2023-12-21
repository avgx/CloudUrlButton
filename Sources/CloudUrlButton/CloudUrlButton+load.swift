//
//  File.swift
//  
//
//  Created by Alexey Govorovsky on 21.12.2023.
//

import SwiftUI
import Get

extension CloudUrlButton {
    func loadAbout() async {
        //TODO: need to ensure that this is called only once
        print(#function)
        do {
            let http = APIClient(baseURL: url)
            
            let r = try await http.send(about()).value
            print(r.resultObject?.branchName ?? "-")
            
            self.branchNameOrError = .success(r.resultObject?.branchName ?? "-")
        } catch {
            self.branchNameOrError = .failure(error)
        }
    }
    
    public func about() -> Request<CloudObjectResponse<About>> {
        return Request(path: "/api/v1/about", method: .get, id: "about")
    }
}
