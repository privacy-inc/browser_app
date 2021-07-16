import AppKit
import Combine
import Sleuth

extension Trackers {
    final class Bar: NSView {
        let sorted = CurrentValueSubject<Sleuth.Trackers, Never>(.attempts)
        private var sub: AnyCancellable?
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            let icon = Image(icon: "shield.lefthalf.fill")
            icon.contentTintColor = .secondaryLabelColor
            icon.symbolConfiguration = .init(textStyle: .title3)
            addSubview(icon)
            
            let segmented = NSSegmentedControl(labels: ["Attempts", "Recent"], trackingMode: .selectOne, target: self, action: #selector(change))
            segmented.selectedSegment = 0
            segmented.translatesAutoresizingMaskIntoConstraints = false
            addSubview(segmented)

            let domains = Text()
            addSubview(domains)
            
            let incidences = Text()
            incidences.alignment = .right
            addSubview(incidences)
            
            icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            icon.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 85).isActive = true
            
            segmented.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            segmented.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            segmented.widthAnchor.constraint(equalToConstant: 260).isActive = true
            
            domains.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            domains.rightAnchor.constraint(equalTo: incidences.leftAnchor, constant: -10).isActive = true
            
            incidences.centerYAnchor.constraint(equalTo: domains.centerYAnchor).isActive = true
            incidences.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
            
            sub = cloud
                .archive
                .map(\.trackers)
                .removeDuplicates {
                    $0.attempts == $1.attempts && $0.count == $1.count
                }
                .sink { trackers in
                    domains.attributedStringValue = .make {
                        $0.append(.make(NumberFormatter
                                            .decimal
                                            .string(from: NSNumber(value: trackers.count)) ?? "",
                                        font: .monoDigit(style: .title2, weight: .regular),
                                        alignment: .right))
                        $0.linebreak()
                        $0.append(.make("Trackers", font: .preferredFont(forTextStyle: .footnote),
                                        color: .secondaryLabelColor,
                                        alignment: .right))
                    }
                    
                    incidences.attributedStringValue = .make {
                        $0.append(.make(NumberFormatter
                                            .decimal
                                            .string(from: NSNumber(value: trackers.attempts)) ?? "",
                                        font: .monoDigit(style: .title2, weight: .regular),
                                        alignment: .right))
                        $0.linebreak()
                        $0.append(.make("Attempts blocked",
                                        font: .preferredFont(forTextStyle: .footnote),
                                        color: .secondaryLabelColor,
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
