//
//  HTMLFetching.swift
//  SwiftDESI
//
//  Created by Yuma decaux on 25/1/2026.
//

import Foundation

public protocol HTMLFetching {
    func fetchHTML(from url: URL) async throws -> String
}
