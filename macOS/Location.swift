import Foundation
import CoreLocation
import Combine

final class Location: NSObject, CLLocationManagerDelegate {
    let current = CurrentValueSubject<CLLocation?, Never>(nil)
    private var manager: CLLocationManager?
    
    func request() {
        guard manager == nil, current.value == nil else { return }
        manager = .init()
        manager!.delegate = self
        manager!.requestLocation()
    }
    
    func locationManager(_: CLLocationManager, didUpdateLocations: [CLLocation]) {
        current.value = didUpdateLocations.first
        manager = nil
    }
    
    func locationManager(_: CLLocationManager, didFailWithError: Error) { }
}
