//
//  DESISpectroProduct.swift
//  SwiftDESI
//
//  Created by Yuma decaux on 25/1/2026.
//


public enum DESISpectroProduct: String, Codable, Identifiable, CaseIterable {
    case iron
    case fuji
    case guadalupe

    public var id: String { rawValue }
}
