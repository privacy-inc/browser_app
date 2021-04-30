import Foundation
import Combine

struct Session {
    var modal: Modal?
    var forwards = false
    var loading = false
    var progress = Double()
    var search = ""
    var section = Section.history
    let purchases = Purchases()
    let text = PassthroughSubject<String, Never>()
    let find = PassthroughSubject<String, Never>()
    let type = PassthroughSubject<Void, Never>()
    let previous = PassthroughSubject<Void, Never>()
    let next = PassthroughSubject<Void, Never>()
    let reload = PassthroughSubject<Void, Never>()
    let stop = PassthroughSubject<Void, Never>()
    let print = PassthroughSubject<Void, Never>()
    let pdf = PassthroughSubject<Void, Never>()
    let dismiss = PassthroughSubject<Void, Never>()
}
