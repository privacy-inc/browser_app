import Foundation
import Combine
import Sleuth

struct Session {
    var page: Page? {
        didSet {
            page.map(save.send)
        }
    }
    
    var error: String?
    var typing = false
    var backwards = false
    var forwards = false
    var progress = Double()
    let browse = PassthroughSubject<URL, Never>()
    let text = PassthroughSubject<String, Never>()
    let find = PassthroughSubject<String, Never>()
    let type = PassthroughSubject<Void, Never>()
    let resign = PassthroughSubject<Void, Never>()
    let previous = PassthroughSubject<Void, Never>()
    let next = PassthroughSubject<Void, Never>()
    let reload = PassthroughSubject<Void, Never>()
    let stop = PassthroughSubject<Void, Never>()
    let print = PassthroughSubject<Void, Never>()
    let pdf = PassthroughSubject<Void, Never>()
    let dismiss = PassthroughSubject<Void, Never>()
    let forget = PassthroughSubject<Void, Never>()
    private var subscription: AnyCancellable?
    private let save = PassthroughSubject<Page, Never>()
    
    init() {
        subscription = save.debounce(for: .seconds(2), scheduler: DispatchQueue.global(qos: .utility)).sink {
            FileManager.save($0)
            Share.chart.append(.init())
        }
    }
}
