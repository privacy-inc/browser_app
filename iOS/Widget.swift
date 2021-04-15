import Foundation
import WidgetKit
import Sleuth

final class Widget {
    func update(_ pages: [Page]) {
        let history = pages.prefix(10).map(\.shared)
        if history != Share.history {
            Share.history = history
            WidgetCenter.shared.reloadTimelines(ofKind: "History")
        }
    }
}
