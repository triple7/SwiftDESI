//
//  DirectoryCrawler.swift
//  SwiftDESI
//
//  Created by Yuma decaux on 25/1/2026.
//


public final class DirectoryCrawler {

    private let scanner: DirectoryScanner

    public init(scanner: DirectoryScanner = DirectoryScanner()) {
        self.scanner = scanner
    }

    public func crawl(
        from root: DESIEndpoint,
        options: TraversalOptions
    ) async throws -> TraversalResult {

        var visited = Set<String>()
        var collectedFiles: [DESIEndpoint] = []

        switch options.strategy {
        case .depthFirst:
            try await dfs(
                endpoint: root,
                depth: 5,
                options: options,
                visited: &visited,
                files: &collectedFiles
            )

        case .breadthFirst:
            try await bfs(
                root: root,
                options: options,
                visited: &visited,
                files: &collectedFiles
            )
        }

        return TraversalResult(files: collectedFiles)
    }
}

    private extension DirectoryCrawler {

        func dfs(
            endpoint: DESIEndpoint,
            depth: Int,
            options: TraversalOptions,
            visited: inout Set<String>,
            files: inout [DESIEndpoint]
        ) async throws {

            print(endpoint)
            guard depth <= options.maxDepth else { return }

            print("depts: \(depth)")
            let key = endpoint.url.absoluteString
            guard !visited.contains(key) else { return }
            visited.insert(key)

            let scan = try await scanner.scan(endpoint: endpoint)
            files.append(contentsOf: scan.files)

            for directory in scan.directories {
                guard options.shouldEnterDirectory(directory) else { continue }

                try await dfs(
                    endpoint: directory,
                    depth: depth + 1,
                    options: options,
                    visited: &visited,
                    files: &files
                )
            }
        }

        func bfs(
        root: DESIEndpoint,
        options: TraversalOptions,
        visited: inout Set<String>,
        files: inout [DESIEndpoint]
    ) async throws {

        var queue: [(endpoint: DESIEndpoint, depth: Int)] = [(root, 0)]

        while let (endpoint, depth) = queue.first {
            queue.removeFirst()

            guard depth <= options.maxDepth else { continue }

            let key = endpoint.url.absoluteString
            guard !visited.contains(key) else { continue }
            visited.insert(key)

            let scan = try await scanner.scan(endpoint: endpoint)
            files.append(contentsOf: scan.files)

            for directory in scan.directories {
                guard options.shouldEnterDirectory(directory) else { continue }
                queue.append((directory, depth + 1))
            }
        }
    }
}

