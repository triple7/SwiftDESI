//
//  DESIEndpoint.swift
//  SwiftDESI
//
//  Created by Yuma decaux on 25/1/2026.
//

import Foundation

public struct DESIEndpoint: Codable, Identifiable {
    public let url: URL
    public var id: String { url.absoluteString }

    // MARK: - Initializers
    public init(_ url: URL) {
        self.url = url
    }

    // MARK: - Base builders
    public static func spectroRedux(
        release: DESIRelease,
        product: DESISpectroProduct,
        layout: DESISpectroLayout
    ) -> DESIEndpoint {
        DESIEndpoint(
            release.baseURL
                .appendingPathComponent("spectro")
                .appendingPathComponent("redux")
                .appendingPathComponent(product.rawValue)
                .appendingPathComponent(layout.rawValue)
        )
    }

    public static func surveyCatalogs(
        release: DESIRelease
    ) -> DESIEndpoint {
        DESIEndpoint(
            release.baseURL
                .appendingPathComponent("survey")
                .appendingPathComponent("catalogs")
        )
    }

    public static func targets(
        release: DESIRelease
    ) -> DESIEndpoint {
        DESIEndpoint(
            release.baseURL
                .appendingPathComponent("target")
        )
    }

    public static func vac(
        release: DESIRelease
    ) -> DESIEndpoint {
        DESIEndpoint(
            release.baseURL
                .appendingPathComponent("vac")
        )
    }
}


public extension DESIEndpoint {

    func zCatalog(version: String = "v1") -> DESIEndpoint {
        DESIEndpoint(
            url
                .appendingPathComponent("zcatalog")
                .appendingPathComponent(version)
        )
    }

    func healpix() -> DESIEndpoint {
        DESIEndpoint(url.appendingPathComponent("healpix"))
    }

    func tiles() -> DESIEndpoint {
        DESIEndpoint(url.appendingPathComponent("tiles"))
    }
}


