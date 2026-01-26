//
//  DirectoryScanner.swift
//  SwiftDESI
//
//  Created by Yuma decaux on 25/1/2026.
//


public struct DirectoryScanner {

    private let fetcher: HTMLFetching

    public init(fetcher: HTMLFetching = URLSessionHTMLFetcher()) {
        self.fetcher = fetcher
    }

    public func scan(endpoint: DESIEndpoint) async throws -> DirectoryScanResult {

        let html = try await fetcher.fetchHTML(from: endpoint.url)
        print(html)
        let entries = DirectoryListingParser.parse(html: html)

        var directories: [DESIEndpoint] = []
        var files: [DESIEndpoint] = []

        for entry in entries {
            let childURL = endpoint.url.appendingPathComponent(entry.name)

            let childEndpoint = DESIEndpoint(childURL)

            switch entry.type {
            case .directory:
                directories.append(childEndpoint)
            case .file:
                files.append(childEndpoint)
            }
        }

        return DirectoryScanResult(
            directories: directories,
            files: files
        )
    }
}
