import AppKit
import Combine
import Sleuth

extension Trackers {
    final class Bottom: NSVisualEffectView {
        let sorted = CurrentValueSubject<Sleuth.Trackers, Never>(.attempts)
        private var sub: AnyCancellable?
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            state = .active
            material = .menu
            
            let segmented = NSSegmentedControl(labels: ["Attempts", "Recent"], trackingMode: .selectOne, target: self, action: #selector(change))
            segmented.selectedSegment = 0
            segmented.translatesAutoresizingMaskIntoConstraints = false
            addSubview(segmented)
            
            let domains = Text()
            addSubview(domains)
            
            let incidences = Text()
            incidences.alignment = .right
            addSubview(incidences)
            
            segmented.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            segmented.leftAnchor.constraint(equalTo: leftAnchor, constant: List.insets).isActive = true
            segmented.widthAnchor.constraint(equalToConstant: List.width).isActive = true
            
            domains.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
            domains.rightAnchor.constraint(equalTo: incidences.leftAnchor, constant: -20).isActive = true
            
            incidences.topAnchor.constraint(equalTo: domains.topAnchor).isActive = true
            incidences.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            
            sub = cloud
                .archive
                .map(\.trackers)
                .removeDuplicates {
                    $0.attempts == $1.attempts && $0.count == $1.count
                }
                .sink { trackers in
                    domains.attributedStringValue = .make {
                        $0.append(.make(session.decimal.string(from: NSNumber(value: trackers.count)) ?? "",
                                        font: .monoDigit(style: .title1, weight: .regular),
                                        alignment: .right))
                        $0.linebreak()
                        $0.append(.make("Trackers", font: .preferredFont(forTextStyle: .callout),
                                        color: .tertiaryLabelColor,
                                        alignment: .right))
                    }
                    
                    incidences.attributedStringValue = .make {
                        $0.append(.make(session.decimal.string(from: NSNumber(value: trackers.attempts)) ?? "",
                                        font: .monoDigit(style: .title1, weight: .regular),
                                        alignment: .right))
                        $0.linebreak()
                        $0.append(.make("Attempts blocked",
                                        font: .preferredFont(forTextStyle: .callout),
                                        color: .tertiaryLabelColor,
                                        alignment: .right))
                    }
                }
        }
        
        @objc private func change(_ segmented: NSSegmentedControl) {
            switch segmented.selectedSegment {
            case 0:
                sorted.send(.attempts)
            default:
                sorted.send(.recent)
            }
        }
    }
}
