import AppKit

extension NSSavePanel {
    class func save(data: Data, name: String, type: String?) {
        let panel = Self()
        panel.nameFieldStringValue = name
        type
            .map {
                panel.allowedFileTypes = [$0]
            }
        panel.begin {
            if $0 == .OK, let url = panel.url {
                try? data.write(to: url, options: .atomic)
                NSWorkspace.shared.activateFileViewerSelecting([url])
            }
        }
    }
    
    class func save(name: String, success: @escaping (URL?) -> Void) {
        let panel = Self()
        panel.nameFieldStringValue = name
        panel.begin {
            if $0 == .OK, let url = panel.url {
                success(url)
            } else {
                success(nil)
            }
        }
    }
}
