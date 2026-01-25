//
//  TraversalOptions.swift
//  SwiftDESI
//
//  Created by Yuma decaux on 25/1/2026.
//


public struct TraversalOptions {

    public let maxDepth: Int
    public let strategy: TraversalStrategy
    public let shouldEnterDirectory: (DESIEndpoint) -> Bool

    public init(
        maxDepth: Int = Int.max,
        strategy: TraversalStrategy = .depthFirst,
        shouldEnterDirectory: @escaping (DESIEndpoint) -> Bool = { _ in true }
    ) {
        self.maxDepth = maxDepth
        self.strategy = strategy
        self.shouldEnterDirectory = shouldEnterDirectory
    }
}
