import Foundation
import Sleuth

final class Defaults: UserDefaults {
    class var premium: Bool {
        get { self[.premium] as? Bool ?? false }
        set { self[.premium] = newValue }
    }
    
    class var rated: Bool {
        get { self[.rated] as? Bool ?? false }
        set { self[.rated] = newValue }
    }
    
    class var popups: Bool {
        get { self[.popups] as? Bool ?? true }
        set { self[.popups] = newValue }
    }
    
    class var javascript: Bool {
        get { self[.javascript] as? Bool ?? true }
        set { self[.javascript] = newValue }
    }
    
    class var ads: Bool {
        get { self[.ads] as? Bool ?? true }
        set { self[.ads] = newValue }
    }
    
    class var trackers: Bool {
        get { self[.trackers] as? Bool ?? true }
        set { self[.trackers] = newValue }
    }
    
    class var cookies: Bool {
        get { self[.cookies] as? Bool ?? true }
        set { self[.cookies] = newValue }
    }
    
    class var secure: Bool {
        get { self[.secure] as? Bool ?? true }
        set { self[.secure] = newValue }
    }
    
    class var dark: Bool {
        get { self[.dark] as? Bool ?? true }
        set { self[.dark] = newValue }
    }
    
    class var engine: Engine {
        get { (self[.engine] as? String).flatMap(Engine.init(rawValue:)) ?? .ecosia }
        set { self[.engine] = newValue.rawValue }
    }
    
    class var created: Date? {
        get { self[.created] as? Date }
        set { self[.created] = newValue }
    }
    
    class subscript(_ key: Key) -> Any? {
        get {
            standard.object(forKey: key.rawValue)
        }
        set {
            standard.setValue(newValue, forKey: key.rawValue)
        }
    }
}
