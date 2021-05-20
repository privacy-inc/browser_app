import SwiftUI

extension Tab {
    struct Indicator: Shape {
        var percent: Double
        
        func path(in rect: CGRect) -> Path {
            .init {
                $0.move(to: .init(x: 0, y: 1))
                $0.addLine(to: .init(x: .init(percent) * rect.width, y: 1))
            }
        }
        
        var animatableData: Double {
            get {
                percent
            }
            set {
                percent = newValue
            }
        }
    }
}
