import SwiftUI

extension Tab.Loading {
    struct Indicator: Shape {
        var show: AnimatablePair<Double, Double>
        
        func path(in rect: CGRect) -> Path {
            .init {
                $0.move(to: .init(x: .init(show.first) * rect.width, y: 1))
                $0.addLine(to: .init(x: .init(show.second) * rect.width, y: 1))
            }
        }
        
        var animatableData: AnimatablePair<Double, Double> {
            get {
                show
            }
            set {
                show = newValue
            }
        }
    }
}
