import WebKit
import Sleuth

@available(macOS 11.3, *) extension Webview: WKDownloadDelegate {
    func download(_: WKDownload, decideDestinationUsing: URLResponse, suggestedFilename: String, completionHandler: @escaping (URL?) -> Void) {
        let url = URL.temporal(suggestedFilename)
        print(url)
        
        NSSavePanel
            .save(name: suggestedFilename) {
                completionHandler($0)
                if let url = $0 {
                    NSWorkspace.shared.activateFileViewerSelecting([url])
                }
            }
    }
    
    func download(_ download: WKDownload, didFailWithError error: Error, resumeData: Data?) {
        print(error.localizedDescription)
    }
    
    func downloadDidFinish(_ download: WKDownload) {
        print("finish")
    }
}
