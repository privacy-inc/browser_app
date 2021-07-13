import AppKit
import Combine

extension Bar.Tab.Search {
    final class Background: NSView, CAAnimationDelegate {
        private weak var shape: CAShapeLayer?
        private var subscription: AnyCancellable?
        
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
        
        required init?(coder: NSCoder) { nil }
        init(id: UUID) {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            wantsLayer = true
            layer!.cornerRadius = 4
            layer!.backgroundColor = NSColor.quaternaryLabelColor.cgColor
            
            let shape = CAShapeLayer()
            shape.strokeColor = NSColor.controlAccentColor.cgColor
            shape.fillColor = .clear
            shape.lineWidth = 3
            shape.lineCap = .round
            shape.lineJoin = .round
            shape.strokeEnd = 0
            layer!.addSublayer(shape)
            self.shape = shape
            
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
        
        override var allowsVibrancy: Bool {
            true
        }
    }
}