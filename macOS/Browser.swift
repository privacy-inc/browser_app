import Foundation
import Combine
import Sleuth

final class Browser {
    let engine = Defaults.engine
    let dark = Defaults.dark
    let secure = Defaults.secure
    let trackers = Defaults.trackers
    let javascript = Defaults.javascript
    let popups = Defaults.popups
    let ads = Defaults.ads
    let cookies = Defaults.cookies
    let page = CurrentValueSubject<Page?, Never>(nil)
    let error = CurrentValueSubject<String?, Never>(nil)
    let backwards = CurrentValueSubject<Bool, Never>(false)
    let forwards = CurrentValueSubject<Bool, Never>(false)
    let progress = CurrentValueSubject<Double, Never>(0)
    let blocked = CurrentValueSubject<Set<String>, Never>([])
    let browse = PassthroughSubject<URL, Never>()
    let backward = PassthroughSubject<Void, Never>()
    let forward = PassthroughSubject<Void, Never>()
    let reload = PassthroughSubject<Void, Never>()
    let save = PassthroughSubject<Void, Never>()
}
