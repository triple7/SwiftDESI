//
//  DESIRelease.swift
//  SwiftDESI
//
//  Created by Yuma decaux on 25/1/2026.
//

import Foundation

public enum DESIRelease: String, Codable, Identifiable, CaseIterable {
    case edr
    case dr1
    case dr2

    public var id: String { rawValue }

    public var baseURL: URL {
        URL(string: "https://data.desi.lbl.gov/public/\(rawValue)")!
    }
}
