import Foundation
import Combine

final class Browser {
    let entry = CurrentValueSubject<Int?, Never>(nil)
    let forwards = CurrentValueSubject<Bool, Never>(false)
    let loading = CurrentValueSubject<Bool, Never>(false)
    let progress = CurrentValueSubject<Double, Never>(.init())
    let search = PassthroughSubject<String, Never>()
    let previous = PassthroughSubject<Void, Never>()
    let next = PassthroughSubject<Void, Never>()
    let reload = PassthroughSubject<Void, Never>()
    let stop = PassthroughSubject<Void, Never>()
    let close = PassthroughSubject<Void, Never>()
    private var subscription: AnyCancellable?
}
