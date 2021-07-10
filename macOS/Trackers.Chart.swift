import AppKit

extension Trackers {
    final class Chart: NSView {
        required init?(coder: NSCoder) { nil }
        init(frame: CGRect, values: [Double]) {
            super.init(frame: frame)
            wantsLayer = true
            layer?.addSublayer(Layer(frame: frame.insetBy(dx: 80, dy: 100), values: values))
        }
        
        override var allowsVibrancy: Bool {
            true
        }
    }
    
    private final class Layer: CALayer {
        required init?(coder: NSCoder) { nil }
        override init(layer: Any) {
            super.init(layer: layer)
        }
        
        init(frame: CGRect, values: [Double]) {
            super.init()
            self.frame = frame
            
            let road = CAShapeLayer()
            road.strokeColor = NSColor.tertiaryLabelColor.cgColor
            road.fillColor = .clear
            road.lineWidth = 2
            road.lineCap = .round
            road.lineJoin = .round
            road.path = {
                $0.move(to: .zero)
                if !values.isEmpty {
                    $0.addLines(
                        between:
                            values
                                .enumerated()
                                .map {
                                    .init(
                                        x: .init(bounds.maxX) / .init(values.count - 1) * .init($0.0),
                                        y: .init(bounds.maxY) * $0.1)
                                })
                } else {
                    $0.addLine(to: .init(x: bounds.maxX, y: 0))
                }
                return $0
            } (CGMutablePath())
            addSublayer(road)
            
            (0 ..< values.count)
                .forEach { index in
                    let dot = CAShapeLayer()
                    dot.lineWidth = 3
                    dot.fillColor = .clear
                    dot.strokeColor = index == values.count - 1 ? NSColor.labelColor.cgColor : NSColor.quaternaryLabelColor.cgColor
                    dot.path = {
                        $0.addArc(
                            center: .init(
                                x: .init(bounds.maxX) / .init(values.count - 1) * .init(index),
                                y: .init(bounds.maxY) * .init(values[index])),
                            radius: index == values.count - 1 ? 10 : 6,
                            startAngle: .zero,
                            endAngle: .pi * 2,
                            clockwise: true)
                        return $0
                    } (CGMutablePath())
                    addSublayer(dot)
                }
        }
    }
}
