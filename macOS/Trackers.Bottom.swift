import AppKit
import Combine
import Sleuth

extension Trackers {
    final class Bottom: NSView {
        let sorted = CurrentValueSubject<Sleuth.Trackers, Never>(.attempts)
        private var sub: AnyCancellable?
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            let segmented = NSSegmentedControl(labels: ["Attempts", "Recent"], trackingMode: .selectOne, target: nil, action: nil)
            segmented.selectedSegment = 0
            segmented.segmentStyle = .separated
            segmented.translatesAutoresizingMaskIntoConstraints = false
            addSubview(segmented)
            
            let domains = Text()
            addSubview(domains)
            
            let incidences = Text()
            addSubview(incidences)
            
            segmented.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
            segmented.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
            segmented.widthAnchor.constraint(equalToConstant: 200).isActive = true
            
            domains.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
            domains.leftAnchor.constraint(equalTo: segmented.rightAnchor, constant: 60).isActive = true
            
            incidences.topAnchor.constraint(equalTo: domains.topAnchor).isActive = true
            incidences.leftAnchor.constraint(equalTo: domains.rightAnchor, constant: 30).isActive = true
            
            sub = cloud
                .archive
                .map(\.trackers)
                .removeDuplicates {
                    $0.attempts == $1.attempts && $0.count == $1.count
                }
                .sink { trackers in
                    domains.attributedStringValue = .make {
                        $0.append(.make(session.decimal.string(from: NSNumber(value: trackers.count)) ?? "",
                                        font: .monoDigit(style: .title1, weight: .regular)))
                        $0.linebreak()
                        $0.append(.make("Trackers", font: .preferredFont(forTextStyle: .callout), color: .secondaryLabelColor))
                    }
                    
                    incidences.attributedStringValue = .make {
                        $0.append(.make(session.decimal.string(from: NSNumber(value: trackers.attempts)) ?? "",
                                        font: .monoDigit(style: .title1, weight: .regular)))
                        $0.linebreak()
                        $0.append(.make("Attempts blocked", font: .preferredFont(forTextStyle: .callout), color: .secondaryLabelColor))
                    }
                }
        }
    }
}
