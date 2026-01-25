//
//  CatalogTraversable.swift
//  SwiftDESI
//
//  Created by Yuma decaux on 25/1/2026.
//

import Foundation

protocol CatalogTraversable {
    func listContents(at endpoint: DESIEndpoint) async throws -> [DESIEndpoint]
    func download(_ endpoint: DESIEndpoint) async throws -> URL
}
