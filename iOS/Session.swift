import UIKit
import Combine
import Sleuth

struct Session {
    var archive = Archive.new
    var tab = Sleuth.Tab()
    var section: Section
    var toast: Toast.Message?
    var modal: Modal?
    let search = PassthroughSubject<Void, Never>()
    let load = PassthroughSubject<(UUID, Page.Access), Never>()
    let find = PassthroughSubject<(UUID, String), Never>()
    let reload = PassthroughSubject<UUID, Never>()
    let stop = PassthroughSubject<UUID, Never>()
    let forward = PassthroughSubject<UUID, Never>()
    let back = PassthroughSubject<UUID, Never>()
    let print = PassthroughSubject<UUID, Never>()
    let pdf = PassthroughSubject<UUID, Never>()
    
    init() {
        section = .tab(tab
                        .ids
                        .first!)
    }
}
