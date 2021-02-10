import Foundation
import Combine
import Sleuth

struct Session {
    var page: Page? {
        didSet {
            guard let page = page else {
                error = nil
                return
            }
            save.send(page)
        }
    }
    
    var error: String?
    var modal: Modal?
    var typing = false
    var backwards = false
    var forwards = false
    var loading = false
    var progress = Double()
    let purchases = Purchases()
    let browse = PassthroughSubject<URL, Never>()
    let text = PassthroughSubject<String, Never>()
    let find = PassthroughSubject<String, Never>()
    let save = PassthroughSubject<Page, Never>()
    let type = PassthroughSubject<Void, Never>()
    let previous = PassthroughSubject<Void, Never>()
    let next = PassthroughSubject<Void, Never>()
    let reload = PassthroughSubject<Void, Never>()
    let stop = PassthroughSubject<Void, Never>()
    let print = PassthroughSubject<Void, Never>()
    let pdf = PassthroughSubject<Void, Never>()
    let dismiss = PassthroughSubject<Void, Never>()
    let forget = PassthroughSubject<Void, Never>()
    let update = PassthroughSubject<Void, Never>()
    let unerror = PassthroughSubject<Void, Never>()
}
