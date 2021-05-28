import Foundation
import Combine
import Sleuth

struct Session {
    var archive = Archive.new
    var tabs = tab.items.value
    var section: Section
    var toast: Toast.Message?
    var modal: Modal?
    let purchases = Purchases()
    let decimal = NumberFormatter()
    let search = PassthroughSubject<Void, Never>()
    let load = PassthroughSubject<(id: UUID, access: Page.Access), Never>()
    let find = PassthroughSubject<(id: UUID, query: String), Never>()
    let reload = PassthroughSubject<UUID, Never>()
    let stop = PassthroughSubject<UUID, Never>()
    let forward = PassthroughSubject<UUID, Never>()
    let back = PassthroughSubject<UUID, Never>()
    let print = PassthroughSubject<UUID, Never>()
    let pdf = PassthroughSubject<UUID, Never>()
    let webarchive = PassthroughSubject<UUID, Never>()
    let snapshot = PassthroughSubject<UUID, Never>()
    let newTab = PassthroughSubject<URL, Never>()
    
    init() {
        section = .tab(tabs
                        .ids
                        .first!)
        decimal.numberStyle = .decimal
    }
}
