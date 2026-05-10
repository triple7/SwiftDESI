//
//  DesiObj.swift
//  SwiftDESI
//
//  Created by Yuma decaux on 10/5/2026.
//


import Foundation
import simd

public struct DesiObj: Equatable {
    public var x: Double
    public var y: Double
    public var z: Double
    public var redshift: Float
    public var objClass: UInt8 // Matches the raw value of DesiObjClass
}
