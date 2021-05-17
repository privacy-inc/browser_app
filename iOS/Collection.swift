import SwiftUI

struct Collection: View {
    @Binding var session: Session
    let modal: Session.Modal
    
    var body: some View {
        List {
            
        }
        .listStyle(GroupedListStyle())
    }
}
