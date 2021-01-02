import SwiftUI

@main struct GameWidgets: WidgetBundle {
    @WidgetBundleBuilder var body: some Widget {
        History()
        Search()
    }
}
