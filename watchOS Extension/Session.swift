import Foundation
import Sleuth

struct Session {
    var archive = Archive.new
    let decimal = NumberFormatter()
    
    init() {
        decimal.numberStyle = .decimal
    }
}
