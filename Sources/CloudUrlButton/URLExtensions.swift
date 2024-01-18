//
//  SwiftUIView.swift
//  
//
//  Created by Alexey Govorovsky on 21.12.2023.
//

import Foundation

extension URL {
    func pretty() -> String {
        guard var builder = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return self.absoluteString
        }
        
        builder.scheme = nil
        
        guard let url1 = builder.url else {
            return self.absoluteString
        }
        let srv = url1.hasDirectoryPath ? url1 : url1.appendingPathComponent("/")
        return String(srv.absoluteString.dropFirst(2).dropLast())
    }
}

extension String {
    public func asURL() -> URL? {
        let text = self.lowercased()
        let fixedRes = text.starts(with: "http://") || text.starts(with: "https://") ? text : "http://\(text)"
        guard let fixedURL = URL(string: fixedRes) else { return nil }
        return fixedURL
    }
}
