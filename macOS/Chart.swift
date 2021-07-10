import AppKit

final class Chart: NSView {
    required init?(coder: NSCoder) { nil }
    init(frame: CGRect, first: Date, values: [Double]) {
        super.init(frame: frame)
        layer = Layer(values: values)
        wantsLayer = true
        layer!.setNeedsDisplay()
        
        let since = Text()
        since.font = .preferredFont(forTextStyle: .callout)
        since.textColor = .tertiaryLabelColor
        since.stringValue = RelativeDateTimeFormatter().string(from: first)
        addSubview(since)
        
        let now = Text()
        now.font = .preferredFont(forTextStyle: .callout)
        now.textColor = .tertiaryLabelColor
        now.stringValue = NSLocalizedString("Now", comment: "")
        addSubview(now)
        
        since.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50).isActive = true
        since.leftAnchor.constraint(equalTo: leftAnchor, constant: 70).isActive = true
        
        now.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50).isActive = true
        now.rightAnchor.constraint(equalTo: rightAnchor, constant: -70).isActive = true
    }
    
    override var allowsVibrancy: Bool {
        true
    }
}

private final class Layer: CALayer {
    private let values: [Double]
    
    required init?(coder: NSCoder) { nil }
    override init(layer: Any) {
        values = []
        super.init(layer: layer)
    }
    
    init(values: [Double]) {
        self.values = values
        super.init()
    }
    
    override func draw(in context: CGContext) {
        context.setStrokeColor(NSColor.secondaryLabelColor.cgColor)
        context.setFillColor(NSColor.labelColor.cgColor)
        context.setLineWidth(1)
        context.addPath({
            if !values.isEmpty {
                $0.addLines(
                    between:
                        values
                            .enumerated()
                            .map {
                                .init(
                                    x: (Double(frame.maxX - 160) / .init(values.count - 1) * .init($0.0)) + 80,
                                    y: (Double(frame.maxY - 200) * $0.1) + 100)
                            })
            } else {
                $0.addLine(to: .init(x: frame.maxX, y: 0))
            }
            return $0
        } (CGMutablePath()))
        context.strokePath()
        context.setStrokeColor(NSColor.tertiaryLabelColor.cgColor)
        
        (0 ..< values.count)
            .forEach { index in
                let point = CGPoint(
                    x: (Double(frame.maxX - 160) / .init(values.count - 1) * .init(index)) + 80,
                    y: (Double(frame.maxY - 200) * .init(values[index])) + 100)
                context.addArc(
                    center: point,
                    radius: index == values.count - 1 ? 12 : 8,
                    startAngle: .zero,
                    endAngle: .pi * 2,
                    clockwise: false)
                context.setBlendMode(.clear)
                context.fillPath()
                
                context.addArc(
                    center: point,
                    radius: index == values.count - 1 ? 8 : 4,
                    startAngle: .zero,
                    endAngle: .pi * 2,
                    clockwise: false)
                
                context.setBlendMode(.normal)
                
                if index == values.count - 1 {
                    context.fillPath()
                } else {
                    context.strokePath()
                }
            }
    }
}
