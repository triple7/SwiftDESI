import Foundation
import FITS
import FITSKit
import SwiftQValue

extension SwiftDESI {

    private static func getFitsMetaData(fits: FitsFile) -> [String: QValue] {
        print("getFitsMetaData: HDU count \(fits.HDUs.count)")
        for hdu in fits.HDUs {
            print("HDU: \n \(hdu.description)")
            for header in hdu.headerUnit {
                print("\(header.keyword): \(header.value)")
            }
        }
        
        // get the metadata from the hdu primary header unit
        var metadata = [String:QValue]()
        for hdu in fits.HDUs {
            for unit in  hdu.headerUnit {
                metadata[unit.keyword.rawValue] = QValue(value: (unit.value != nil) ? unit.value!.toString : "")
            }
        }
        return metadata
    }

    private static func getFitsDataFromLocalFile(name: String) throws -> Data {
        let documentsURL = try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )

        let fileURL = documentsURL
            .appendingPathComponent("DESI")
            .appendingPathComponent(name)

        print(fileURL.absoluteString)
        return try Data(contentsOf: fileURL, options: .mappedIfSafe)
    }

    
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

    public static func parseFitsFile(from name: String)  {
        do {
            let data = try SwiftDESI.getFitsDataFromLocalFile(name: name)
            print("Got data")
            let fits = FitsFile.read( data)!
            let metadata = getFitsMetaData(fits: fits)
            for key in metadata.keys {
                print("key: \(key)")
            }
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }

}
