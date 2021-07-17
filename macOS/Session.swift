import Foundation
import Combine
import Sleuth

struct Session {
    let tab = Tab()
    let plus = PassthroughSubject<Void, Never>()
    let close = PassthroughSubject<UUID, Never>()
    let current: CurrentValueSubject<UUID, Never>
    let search = PassthroughSubject<UUID, Never>()
    
    
    
    
    
    let load = PassthroughSubject<(id: UUID, access: Page.Access), Never>()
    let open = PassthroughSubject<(url: URL, change: Bool), Never>()
    let reload = PassthroughSubject<UUID, Never>()
    let stop = PassthroughSubject<UUID, Never>()
    let forward = PassthroughSubject<UUID, Never>()
    let back = PassthroughSubject<UUID, Never>()
    let print = PassthroughSubject<UUID, Never>()
    let pdf = PassthroughSubject<UUID, Never>()
    let webarchive = PassthroughSubject<UUID, Never>()
    let snapshot = PassthroughSubject<UUID, Never>()
    let actualSize = PassthroughSubject<UUID, Never>()
    let zoomIn = PassthroughSubject<UUID, Never>()
    let zoomOut = PassthroughSubject<UUID, Never>()
    
    init() {
        current = .init(tab
                            .items
                            .value
                            .ids
                            .first!)
    }
}
