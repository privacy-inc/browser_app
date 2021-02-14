import AppKit
import Sleuth

extension Chart {
    final class Content: CALayer {
        required init?(coder: NSCoder) { nil }
        override init(layer: Any) {
            super.init(layer: layer)
        }
        
        init(frame: CGRect) {
            super.init()
            self.frame = frame
            
            let values = Chart.values(with: Share.chart)
            
            let pattern = CAShapeLayer()
            pattern.strokeColor = NSColor.labelColor.withAlphaComponent(0.15).cgColor
            pattern.fillColor = .clear
            pattern.lineWidth = 1
            pattern.lineCap = .round
            pattern.lineDashPattern = [1, 4]
            pattern.path = { path in
                path.move(to: .zero)
                (1 ..< Metrics.chart.horizontal).map { bounds.maxX / .init(Metrics.chart.horizontal) * .init($0) }.forEach {
                    path.move(to: .init(x: $0, y: 0))
                    path.addLine(to: .init(x: $0, y: bounds.maxY))
                }
                (1 ..< Metrics.chart.vertical).map { bounds.maxY / .init(Metrics.chart.vertical) * .init($0) }.forEach {
                    path.move(to: .init(x: 0, y: $0))
                    path.addLine(to: .init(x: bounds.maxX, y: $0))
                }
                return path
            } (CGMutablePath())
            addSublayer(pattern)
            
            let shade = CAShapeLayer()
            shade.fillColor = NSColor.controlAccentColor.withAlphaComponent(0.3).cgColor
            shade.path = {
                if !values.isEmpty {
                    $0.move(to: .init(x: 0, y: 0))
                    $0.addLines(between: values.enumerated().map {
                        .init(x: Double(bounds.maxX) / .init(values.count - 1) * .init($0.0), y: .init(bounds.maxY) * $0.1)
                    })
                    $0.addLine(to: .init(x: bounds.maxX, y: 0))
                    $0.addLine(to: .init(x: 0, y: 0))
                    $0.closeSubpath()
                }
                return $0
            } (CGMutablePath())
            addSublayer(shade)
            
            let road = CAShapeLayer()
            road.strokeColor = NSColor.controlAccentColor.cgColor
            road.fillColor = .clear
            road.lineWidth = 2
            road.lineCap = .round
            road.path = {
                $0.move(to: .init(x: 0, y: 0))
                if !values.isEmpty {
                    $0.addLines(between: values.enumerated().map {
                        .init(x: Double(bounds.maxX) / .init(values.count - 1) * .init($0.0), y: .init(bounds.maxY) * $0.1)
                    })
                } else {
                    $0.addLine(to: .init(x: bounds.maxX, y: 0))
                }
                return $0
            } (CGMutablePath())
            addSublayer(road)
            
            (0 ..< values.count).forEach { index in
                let dot = CAShapeLayer()
                dot.fillColor = .black
                dot.strokeColor = NSColor.labelColor.cgColor
                dot.lineWidth = 2
                dot.lineCap = .round
                dot.path = {
                    $0.addArc(center: .init(x: Double(bounds.maxX) / .init(values.count - 1) * .init(index), y: .init(bounds.maxY) * .init(values[index])), radius: 6, startAngle: .zero, endAngle: .pi * 2, clockwise: true)
                    return $0
                } (CGMutablePath())
                addSublayer(dot)
            }
        }
    }
}
