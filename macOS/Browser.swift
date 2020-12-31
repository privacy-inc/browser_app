import Combine
import Sleuth

final class Browser {
    let page = CurrentValueSubject<Page?, Never>(nil)
    let error = CurrentValueSubject<String?, Never>(nil)
    let backwards = CurrentValueSubject<Bool, Never>(false)
    let forwards = CurrentValueSubject<Bool, Never>(false)
    let loading = CurrentValueSubject<Bool, Never>(false)
    let progress = CurrentValueSubject<Double, Never>(.init())
    let browse = PassthroughSubject<URL, Never>()
    let previous = PassthroughSubject<Void, Never>()
    let next = PassthroughSubject<Void, Never>()
    let reload = PassthroughSubject<Void, Never>()
    let stop = PassthroughSubject<Void, Never>()
    var subscription: AnyCancellable?
    
    init() {
        subscription = page.debounce(for: .seconds(1), scheduler: DispatchQueue.main).sink { [weak self] in
            guard let page = $0 else { return }
            FileManager.save(page)
        }
    }
}
