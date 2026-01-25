//
//  URLSessionHTMLFetcher.swift
//  SwiftDESI
//
//  Created by Yuma decaux on 25/1/2026.
//

import Foundation

public struct URLSessionHTMLFetcher: HTMLFetching {

    public init() {}

    public func fetchHTML(from url: URL) async throws -> String {
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let html = String(data: data, encoding: .utf8) else {
            throw URLError(.cannotDecodeContentData)
        }
        return html
    }
}
