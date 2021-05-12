import UIKit
import Combine
import Sleuth

struct Session {
    var archive = Archive.new
    var tab = Sleuth.Tab()
    var section: Section
    var snapsshots = [UUID : UIImage]()
    var search = PassthroughSubject<Void, Never>()
    
    init() {
        section = tab
            .items
            .first
            .map(\.id)
            .map(Section.tab)
            ?? .tabs
    }
}
