import Foundation
import Combine
import Sleuth

final class Browser {
    let page = CurrentValueSubject<Page?, Never>(nil)
    let error = CurrentValueSubject<String?, Never>(nil)
    let backwards = CurrentValueSubject<Bool, Never>(false)
    let forwards = CurrentValueSubject<Bool, Never>(false)
    let progress = CurrentValueSubject<Double, Never>(0)
    let blocked = CurrentValueSubject<Set<String>, Never>([])
    let navigate = PassthroughSubject<URL, Never>()
    let backward = PassthroughSubject<Void, Never>()
    let forward = PassthroughSubject<Void, Never>()
    let reload = PassthroughSubject<Void, Never>()
    let save = PassthroughSubject<Void, Never>()
    private var subs = Set<AnyCancellable>()
    private let dispatch = DispatchQueue(label: "", qos: .utility)

    init() {
        save.combineLatest(page).debounce(for: .seconds(1), scheduler: dispatch).sink {
            $0.1.map(FileManager.default.save)
        }.store(in: &subs)
    }
    
    func browse(_ url: URL) {
        if page.value == nil {
            page.value = .init(url: url)
            save.send()
        } else {
            navigate.send(url)
        }
    }
}
