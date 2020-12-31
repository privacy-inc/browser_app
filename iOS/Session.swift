import Foundation
import Combine
import Sleuth

struct Session {
    var page: Page? {
        didSet {
            guard let page = page else { return }
            save.send(page)
        }
    }
    
    var error: String?
    var pages = [Page]()
    var blocked = Set<String>()
    var typing = false
    var backwards = false
    var forwards = false
    var loading = false
    var progress = Double()
    let save = PassthroughSubject<Page, Never>()
    let browse = PassthroughSubject<URL, Never>()
    let text = PassthroughSubject<String, Never>()
    let type = PassthroughSubject<Void, Never>()
    let resign = PassthroughSubject<Void, Never>()
    let previous = PassthroughSubject<Void, Never>()
    let next = PassthroughSubject<Void, Never>()
    let reload = PassthroughSubject<Void, Never>()
    let stop = PassthroughSubject<Void, Never>()
}
