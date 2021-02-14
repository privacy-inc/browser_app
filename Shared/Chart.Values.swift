import Foundation

extension Chart {
    static func values(with chart: [Date]) -> [Double] {
        guard !chart.isEmpty else {
            return []
        }
        
        let interval = (Date().timeIntervalSince1970 - chart.first!.timeIntervalSince1970) / .init(Metrics.chart.divisions)
        let ranges = (0 ..< Metrics.chart.divisions).map {
            (.init($0) * interval) + chart.first!.timeIntervalSince1970
        }
        let array = chart.map(\.timeIntervalSince1970).reduce(into: Array(repeating: Double(), count: Metrics.chart.divisions)) {
            var index = 0
            while index < Metrics.chart.divisions - 1 && ranges[index + 1] < $1 {
                index += 1
            }
            $0[index] += 1
        }
        return array.map { $0 / array.max()! }
    }
}
