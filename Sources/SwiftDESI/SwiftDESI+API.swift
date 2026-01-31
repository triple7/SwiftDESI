

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

    public static func traverseDr1ZCatalogs() async throws -> [DESIEndpoint] {
        func isPrimaryZCatalog(_ endpoint: DESIEndpoint) -> Bool {
            let name = endpoint.url.lastPathComponent.lowercased()

            return
                name == "zall-pix-iron.fits" ||
                name == "zall-tilecumulative-iron.fits"
        }

        let crawler = DirectoryCrawler()

        // zcatalog lives under spectro/redux/<prod>/zcatalog
        // layout is required by spectroRedux but not actually used by zcatalog,
        // so we pass a canonical one (tiles is fine)
        let zcatalogRoot = DESIEndpoint(
            DESIRelease.dr1.baseURL
                .appendingPathComponent("spectro")
                .appendingPathComponent("redux")
                .appendingPathComponent("iron")
                .appendingPathComponent("zcatalog")
                .appendingPathComponent("v1")
        )

        print("Trying: \(zcatalogRoot)")
        let result = try await crawler.crawl(
            from: zcatalogRoot,
            options: TraversalOptions(
                maxDepth: 5,
                strategy: .depthFirst
            ) { endpoint in
                // Hard boundary: never leave zcatalog
                endpoint.url.path.lowercased().contains("/zcatalog/")
            }
        )

        let zcatalogFiles = result.files.filter { endpoint in
            let name = endpoint.url.lastPathComponent.lowercased()
            let base = name.replacingOccurrences(of: ".gz", with: "")

            return
                (base.hasPrefix("zall") && base.hasSuffix(".fits")) ||
                (base.hasPrefix("zpix") && base.hasSuffix(".fits")) ||
                (base.hasPrefix("ztile") && base.hasSuffix(".fits")) ||
                (base.hasPrefix("zmtl") && base.hasSuffix(".fits"))   // optional
        }

        return zcatalogFiles.filter{isPrimaryZCatalog($0)}
    }


}
