

extension SwiftDESI {
    
    public static func traverseDr1RelevantCatalogs() async throws -> [DESIEndpoint] {
        let crawler = DirectoryCrawler()

        let result = try await crawler.crawl(
            from: DESIEndpoint.spectroRedux(
                release: .dr1,
                product: .iron,
                layout: .tiles
            ),
            options: TraversalOptions()
        )

        let relevantFiles = result.files.filter { endpoint in
            let name = endpoint.url.lastPathComponent.lowercased()
            let base = name.replacingOccurrences(of: ".gz", with: "")

            // Redshift catalogs (primary)
            if base.hasPrefix("zall") && base.hasSuffix(".fits") {
                return true
            }

            // Healpix / tile redshift catalogs (depending on release)
            if base.hasPrefix("zpix") && base.hasSuffix(".fits") {
                return true
            }

            if base.hasPrefix("ztile") && base.hasSuffix(".fits") {
                return true
            }

            // Optional redshift metadata
            if base.hasPrefix("zmtl") && base.hasSuffix(".fits") {
                return true
            }

            return false
        }

        return relevantFiles
    }

}
