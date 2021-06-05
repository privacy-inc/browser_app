import AppKit
import Combine

extension Search {
    final class Bar: NSView, CAAnimationDelegate {
        override var frame: NSRect {
            didSet {
                shape
                    .map {
                        $0.path = {
                            $0.move(to: .init(x: 0, y: 1))
                            $0.addLine(to: .init(x: frame.width, y: 1))
                            return $0
                        } (CGMutablePath())
                    }
            }
        }
        
        private weak var shape: CAShapeLayer?
        private var subscription: AnyCancellable?
        
        required init?(coder: NSCoder) { nil }
        init(id: UUID) {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            
            let background = NSVisualEffectView()
            background.translatesAutoresizingMaskIntoConstraints = false
            background.wantsLayer = true
            background.layer!.cornerRadius = 4
            background.state = .active
            addSubview(background)
            
            let shape = CAShapeLayer()
            shape.strokeColor = NSColor.controlAccentColor.cgColor
            shape.fillColor = .clear
            shape.lineWidth = 3
            shape.lineCap = .round
            shape.lineJoin = .round
            shape.strokeEnd = 0
            background.layer!.addSublayer(shape)
            self.shape = shape

            background.topAnchor.constraint(equalTo: topAnchor).isActive = true
            background.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            background.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            background.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            
            subscription = tabber
                .items
                .map {
                    $0[progress: id]
                }
                .removeDuplicates()
                .sink { progress in
                    shape.strokeStart = 0
                    shape.strokeEnd = .init(progress)
                    guard progress == 1 else { return }
                    shape.add({
                        $0.duration = 1
                        $0.timingFunction = .init(name: .easeInEaseOut)
                        $0.delegate = self
                        return $0
                    } (CABasicAnimation(keyPath: "strokeEnd")), forKey: "strokeEnd")
                }
        }
        
        func animationDidStop(_: CAAnimation, finished: Bool) {
            if finished {
                shape?.strokeStart = 1
                shape?.add({
                    $0.duration = 1
                    $0.timingFunction = .init(name: .easeInEaseOut)
                    return $0
                } (CABasicAnimation(keyPath: "strokeStart")), forKey: "strokeStart")
            }
        }
    }
}
