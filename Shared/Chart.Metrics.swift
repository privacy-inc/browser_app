import Foundation

extension Chart {
    struct Metrics {
        static let divisions = 6
        static let horizontal = 15
        static let vertical = 6
        
        static func values(with chart: [Date]) -> [Double] {
            guard !chart.isEmpty else {
                return []
            }
            
            let interval = (Date().timeIntervalSince1970 - chart.first!.timeIntervalSince1970) / .init(divisions)
            let ranges = (0 ..< divisions).map {
                (.init($0) * interval) + chart.first!.timeIntervalSince1970
            }
            let array = chart.map(\.timeIntervalSince1970).reduce(into: Array(repeating: Double(), count: divisions)) {
                var index = 0
                while index < divisions - 1 && ranges[index + 1] < $1 {
                    index += 1
                }
                $0[index] += 1
            }
            return array.map { $0 / array.max()! }
        }
    }
}
