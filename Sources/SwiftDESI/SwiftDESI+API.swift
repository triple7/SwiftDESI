

extension SwiftDESI {
    
    public static func traverseDr1RelevantCatalogs() async throws -> [DESIEndpoint] {
        let crawler = DirectoryCrawler()

        let options = TraversalOptions { endpoint in
            let path = endpoint.url.path.lowercased()

            // Allow cumulative tiles
            if path.contains("/tiles/cumulative") {
                return true
            }

            // Explicitly block pernight
            if path.contains("/tiles/pernight") {
                return false
            }

            return true
        }

        let result = try await crawler.crawl(
            from: DESIEndpoint.spectroRedux(
                release: .dr1,
                product: .iron,
                layout: .tiles
            ),
            options: options
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
