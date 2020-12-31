import Foundation
import Combine
import Sleuth

struct Session {
    var typing = false
    let browser = Browser()
    let pages = CurrentValueSubject<[Page], Never>([])
    let blocked = CurrentValueSubject<Set<String>, Never>([])
    let type = PassthroughSubject<Void, Never>()
    let resign = PassthroughSubject<Void, Never>()
    let text = PassthroughSubject<String, Never>()
    
    func load() {
        guard pages.value.isEmpty else { return }
        var sub: AnyCancellable?
        sub = FileManager.pages.receive(on: DispatchQueue.main).sink {
            sub?.cancel()
            guard $0 != self.pages.value else { return }
            self.pages.value = $0
            print($0.count)
        }
    }
}
