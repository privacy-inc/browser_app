import Foundation
import Combine
import Sleuth

final class Browser {
    let page = CurrentValueSubject<Page?, Never>(nil)
    let forwards = CurrentValueSubject<Bool, Never>(false)
    let loading = CurrentValueSubject<Bool, Never>(false)
    let progress = CurrentValueSubject<Double, Never>(.init())
    let browse = PassthroughSubject<URL, Never>()
    let search = PassthroughSubject<String, Never>()
    let previous = PassthroughSubject<Void, Never>()
    let next = PassthroughSubject<Void, Never>()
    let reload = PassthroughSubject<Void, Never>()
    let stop = PassthroughSubject<Void, Never>()
    let close = PassthroughSubject<Void, Never>()
    private var subscription: AnyCancellable?
    
    init() {
        subscription = page.debounce(for: .seconds(0.8), scheduler: DispatchQueue.main).sink {
            guard let page = $0 else { return }
            Share.chart.append(.init())
            FileManager.save(page)
        }
    }
}
