import UIKit
import Combine
import Sleuth

struct Session {
    var archive = Archive.new
    var tab = Sleuth.Tab()
    var section: Section
    var search = PassthroughSubject<Void, Never>()
    var load = PassthroughSubject<UUID, Never>()
    private var state = [UUID : State]()
    
    init() {
        section = tab
            .items
            .first
            .map(\.id)
            .map(Section.tab)
            ?? .tabs(nil)
    }
    
    subscript(_ id: UUID) -> State {
        get {
            state[id] ?? .new
        }
        set {
            state[id] = newValue
        }
    }
    
    mutating func remove(_ id: UUID) {
        state.removeValue(forKey: id)
    }
    
    mutating func clear() {
        state = [:]
    }
}
