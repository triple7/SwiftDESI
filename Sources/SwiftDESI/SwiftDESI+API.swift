

extension SwiftDESI {
    
    public static func traverseDr1SpectraFits() async throws -> [DESIEndpoint] {
        let crawler = DirectoryCrawler()

        let result = try await crawler.crawl(
            from: DESIEndpoint.spectroRedux(release: .dr1, product: .iron),
            options: TraversalOptions()
        )

        let fitsFiles = result.files.filter {
            $0.url.lastPathComponent.lowercased().hasSuffix(".fits")
        }
        return fitsFiles
    }
    
}
