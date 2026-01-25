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

        let lines = html.split(separator: "\n")

        for line in lines {
            guard let hrefRange = line.range(of: "href=\"") else { continue }

            let afterHref = line[hrefRange.upperBound...]
            guard let endQuote = afterHref.firstIndex(of: "\"") else { continue }

            let href = String(afterHref[..<endQuote])

            // Ignore parent directory and junk
            guard href != "../", !href.isEmpty else { continue }

            let isDirectory = href.hasSuffix("/")

            let name = href.trimmingCharacters(in: CharacterSet(charactersIn: "/"))

            entries.append(
                DirectoryEntry(
                    name: name,
                    type: isDirectory ? .directory : .file
                )
            )
        }

        return entries
    }
}
