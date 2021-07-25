import Foundation
import Combine
import Sleuth

struct Session {
    var archive = Archive.new
    var tab = Sleuth.Tab()
    var items: [Sleuth.Tab.Item]
    var section: Section
    var toast: Toast.Message?
    var modal: Modal?
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
        items = tab
            .items
            .value
        section = .tab(items
                        .ids
                        .first!)
    }
}
