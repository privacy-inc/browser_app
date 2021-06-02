import Foundation
import Combine
import Sleuth

struct Session {
    let decimal = NumberFormatter()
    let tab = CurrentValueSubject<Tab, Never>(.init())
    let load = PassthroughSubject<(id: UUID, access: Page.Access), Never>()
    let find = PassthroughSubject<(id: UUID, query: String), Never>()
    let search = PassthroughSubject<UUID, Never>()
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
        decimal.numberStyle = .decimal
    }
}
