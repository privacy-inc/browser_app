import Foundation
import Combine
import Sleuth

struct Session {
    var page: Page? {
        didSet {
            guard let page = page else {
                search = ""
                return
            }
            save.send(page)
        }
    }
    
    var modal: Modal?
    var forwards = false
    var loading = false
    var progress = Double()
    var search = ""
    var pages = [Page]()
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
    let history = PassthroughSubject<Void, Never>()
}
