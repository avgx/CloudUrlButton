//
//  File.swift
//
//
//  Created by Alexey Govorovsky on 21.12.2023.
//

import SwiftUI
import Get

class LoadData {
    //    public static func loadURL(url: URL) async throws -> Result<String, Error> {
    //        //TODO: need to ensure that this is called only once
    //        print(#function)
    //        do {
    //            let actualURL = try await checkUrlRedirect(url: url)
    //            let http = APIClient(baseURL: actualURL)
    //            let r = try await http.send(about()).value
    //            print(r.resultObject?.branchName ?? "-")
    //            return .success(r.resultObject?.branchName ?? "-")
    //        } catch {
    //            return .failure(error)
    //        }
    //    }
    
    public static func loadAbout(url: URL) async throws -> (URL, String) {
        
        let actualURL = try await checkUrlRedirect(url: url)
        let http = APIClient(baseURL: actualURL)
        let r = try await http.send(about())
        let value = r.value
        return (actualURL, value.resultObject?.branchName ?? "-")
        
    }
    
        private static func checkUrlRedirect(url: URL) async throws -> URL {
            let (_, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse,
                  let actualURL = response.url
            else { return url }
            return actualURL
        }
    
    private static func about() -> Request<CloudObjectResponse<About>> {
        return Request(path: "/api/v1/about", method: .get, id: "about")
    }
}
