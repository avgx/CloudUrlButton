//
//  File.swift
//  
//
//  Created by Alexey Govorovsky on 21.12.2023.
//

import SwiftUI
import Get

extension Row {
    
    func loadAbout(newUrl: URL) async {
        print(#function)
        await loadAboutURL(url: newUrl)
    }
    
    func loadAbout() async {
        print(#function)
        await loadAboutURL(url: url)
    }
    
    private func loadAboutURL(url: URL) async {
        //TODO: need to ensure that this is called only once
        
        do {
            let http = APIClient(baseURL: url)
            
            let r = try await http.send(about()).value
            print(r.resultObject?.branchName ?? "-")
            
            branchNameOrError = .success(r.resultObject?.branchName ?? "-")
        } catch {
            branchNameOrError = .failure(error)
        }
    }
    
    public func about() -> Request<CloudObjectResponse<About>> {
        return Request(path: "/api/v1/about", method: .get, id: "about")
    }
}
