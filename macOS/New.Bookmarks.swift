import AppKit
import Combine
import Archivable

extension New {
    private static let width = CGFloat(230)
    static let padding = CGFloat(6)
    static let horizontal = CGFloat(20)
    static let top = CGFloat(20)
    static let bottom = CGFloat(40)
    static let delta = CGFloat(60)
    static let margin = CGFloat(20)
    static let url = 60
    
    final class Bookmarks: Collection<New.Bookmarks.Cell> {
        required init?(coder: NSCoder) { nil }
        init(id: UUID) {
            super.init()
            translatesAutoresizingMaskIntoConstraints = false
            documentView!.layer!.backgroundColor = NSColor.unemphasizedSelectedTextBackgroundColor.cgColor
            documentView!.layer!.cornerRadius = 12
            
            
        }
    }
}
