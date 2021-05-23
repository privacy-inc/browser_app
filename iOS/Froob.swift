import SwiftUI

struct Froob: View {
    @Binding var session: Session
    
    var body: some View {
        Message(
            title: "Privacy\nPlus",
            message: """
By purchasing Privacy Plus you support research and development at Privacy Inc and for Privacy Browser.

Privacy Plus is an In-App Purchase, it is non-consumable, meaning it is a 1 time only purchase and you can use it both on iOS and macOS.
""") {
                session.modal = .store
            }
    }
}
