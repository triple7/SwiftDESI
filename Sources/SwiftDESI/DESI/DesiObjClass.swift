//
//  DesiObjClass.swift
//  SwiftDESI
//
//  Created by Yuma decaux on 10/5/2026.
//


import Foundation
import simd

public enum DesiObjClass: UInt8, Codable, CustomStringConvertible {
    case galaxySer = 0
    case elgRex = 1
    case star = 2
    case qso = 3
    case galaxyRex = 4
    case lrgDev = 5
    case elgPsf = 6
    case galaxyDev = 7
    case galaxyExp = 8
    case lrgRex = 9
    case lrgSer = 10
    case galaxyPsf = 11
    case elgExp = 12
    case galaxyGeneric = 13
    case lrgExp = 14
    case elgDev = 15
    case lrgPsf = 16
    case galaxyGpsf = 17
    case elgSer = 18
    case galaxyGgal = 19
    case galaxyDup = 20
    case unknown = 255

    public var description: String {
        switch self {
        case .galaxySer: return "Sersic-profile Galaxy (General)"
        case .elgRex: return "Emission Line Galaxy (Round Exponential)"
        case .star: return "Milky Way Star"
        case .qso: return "Quasar (Active Supermassive Black Hole)"
        case .lrgDev: return "Luminous Red Galaxy (Elliptical Profile)"
        // ... add descriptions for the others as needed
        default: return "Unknown/Other DESI Object"
        }
    }
}
