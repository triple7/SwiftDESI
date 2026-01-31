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

        // Throttle directory fetches to avoid NW timestamp overflow
        try await Task.sleep(nanoseconds: 5_000_000_000)

        let html = try await fetcher.fetchHTML(from: endpoint.url)
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
