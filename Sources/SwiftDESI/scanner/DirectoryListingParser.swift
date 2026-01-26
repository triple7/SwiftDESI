//
//  DirectoryListingParser.swift
//  SwiftDESI
//
//  Created by Yuma decaux on 25/1/2026.
//

import Foundation

public struct DirectoryListingParser {
    
    public static func parse(html: String) -> [DirectoryEntry] {
        var entries: [DirectoryEntry] = []

        let hrefToken = "href=\""
        var searchRange = html.startIndex..<html.endIndex

        while let hrefRange = html.range(of: hrefToken, range: searchRange) {
            let afterHrefStart = hrefRange.upperBound

            guard let endQuote = html[afterHrefStart...].firstIndex(of: "\"") else {
                break
            }

            let href = String(html[afterHrefStart..<endQuote])

            // Advance search range
            searchRange = endQuote..<html.endIndex

            // Ignore parent directory and empty links
            guard href != "../", !href.isEmpty else {
                continue
            }

            let isDirectory = href.hasSuffix("/")
            let name = href.trimmingCharacters(in: CharacterSet(charactersIn: "/"))

            entries.append(
                DirectoryEntry(
                    name: name,
                    type: isDirectory ? .directory : .file
                )
            )
        }

        print("Found \(entries.count)")
        return entries
    }

}
