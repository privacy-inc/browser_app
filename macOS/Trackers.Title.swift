import AppKit
import Combine

extension Trackers {
    final class Title: NSView {
        private var subscription: AnyCancellable?
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            
            let icon = Image(icon: "shield.lefthalf.fill")
            icon.contentTintColor = .controlAccentColor
            icon.symbolConfiguration = .init(textStyle: .largeTitle)
            addSubview(icon)
            
            let trackers = Text()
            trackers.font = .monospacedDigitSystemFont(ofSize: NSFont.preferredFont(forTextStyle: .title2).pointSize, weight: .regular)
            trackers.textColor = .systemPink
            addSubview(trackers)
            
            let titleTrackers = Text()
            titleTrackers.font = .preferredFont(forTextStyle: .callout)
            titleTrackers.textColor = .secondaryLabelColor
            titleTrackers.stringValue = NSLocalizedString("Trackers", comment: "")
            addSubview(titleTrackers)
            
            let incidences = Text()
            incidences.font = .monospacedDigitSystemFont(ofSize: NSFont.preferredFont(forTextStyle: .title2).pointSize, weight: .regular)
            incidences.textColor = .systemPink
            addSubview(incidences)
            
            let titleIncidences = Text()
            titleIncidences.font = .preferredFont(forTextStyle: .callout)
            titleIncidences.textColor = .secondaryLabelColor
            titleIncidences.stringValue = NSLocalizedString("Incidences", comment: "")
            addSubview(titleIncidences)
            
            subscription = cloud
                .archive
                .map(\.trackers)
                .removeDuplicates {
                    $0.flatMap(\.count) == $1.flatMap(\.count)
                }
                .sink {
                    trackers.stringValue = session.decimal.string(from: NSNumber(value: $0.count)) ?? ""
                    incidences.stringValue = session.decimal.string(from: NSNumber(value: $0
                                                                                    .map(\.1.count)
                                                                                    .reduce(0, +))) ?? ""
                }
            
            icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            trackers.bottomAnchor.constraint(equalTo: centerYAnchor, constant: 4).isActive = true
            incidences.bottomAnchor.constraint(equalTo: centerYAnchor, constant: 4).isActive = true
            
            icon.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
            trackers.rightAnchor.constraint(equalTo: incidences.leftAnchor, constant: -80).isActive = true
            incidences.rightAnchor.constraint(equalTo: icon.leftAnchor, constant: -50).isActive = true
            
            titleTrackers.centerXAnchor.constraint(equalTo: trackers.centerXAnchor).isActive = true
            titleIncidences.centerXAnchor.constraint(equalTo: incidences.centerXAnchor).isActive = true
            
            titleTrackers.topAnchor.constraint(equalTo: trackers.bottomAnchor, constant: 2).isActive = true
            titleIncidences.topAnchor.constraint(equalTo: incidences.bottomAnchor, constant: 2).isActive = true
        }
    }
}
