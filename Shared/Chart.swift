import SwiftUI
import Sleuth

struct Chart: View {
    private let values: [Double]
    private let since: String
    
    init(chart: [Date]) {
        values = Metrics.values(with: chart)
        since = chart.isEmpty ? "" : RelativeDateTimeFormatter().localizedString(for: chart.first!, relativeTo: .init())
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Usage")
                    .font(.footnote)
                    .padding(.leading)
                Spacer()
            }
            ZStack {
                Pattern()
                    .stroke(Color.primary.opacity(0.15), style: .init(lineWidth: 1, lineCap: .round, dash: [1, 4]))
                Shade(values: values)
                    .fill(Color.accentColor.opacity(0.3))
                Road(values: values)
                    .stroke(Color.accentColor, style: .init(lineWidth: 2, lineCap: .round))
                ForEach(0 ..< values.count, id: \.self) {
                    Dot(y: values[$0], index: $0, count: values.count)
                        .fill(Color.black)
                    Dot(y: values[$0], index: $0, count: values.count)
                        .stroke(Color.primary, style: .init(lineWidth: 2, lineCap: .round))
                }
            }
            .padding()
            HStack {
                Text(verbatim: since)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Spacer()
                Text("Now")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
        }
    }
}

private struct Pattern: Shape {
    func path(in rect: CGRect) -> Path {
        .init { path in
            path.move(to: .zero)
            (1 ..< Chart.Metrics.horizontal).map { rect.maxX / .init(Chart.Metrics.horizontal) * .init($0) }.forEach {
                path.move(to: .init(x: $0, y: 0))
                path.addLine(to: .init(x: $0, y: rect.maxY))
            }
            (1 ..< Chart.Metrics.vertical).map { rect.maxY / .init(Chart.Metrics.vertical) * .init($0) }.forEach {
                path.move(to: .init(x: 0, y: $0))
                path.addLine(to: .init(x: rect.maxX, y: $0))
            }
        }
    }
}

private struct Shade: Shape {
    let values: [Double]
    
    func path(in rect: CGRect) -> Path {
        .init {
            if !values.isEmpty {
                $0.move(to: .init(x: 0, y: rect.maxY))
                $0.addLines(values.enumerated().map {
                    .init(x: Double(rect.maxX) / .init(values.count - 1) * .init($0.0), y: .init(rect.maxY) - (.init(rect.maxY) * $0.1))
                })
                $0.addLine(to: .init(x: rect.maxX, y: rect.maxY))
                $0.addLine(to: .init(x: 0, y: rect.maxY))
                $0.closeSubpath()
            }
        }
    }
}

private struct Road: Shape {
    let values: [Double]

    func path(in rect: CGRect) -> Path {
        .init {
            $0.move(to: .init(x: 0, y: rect.maxY))
            if !values.isEmpty {
                $0.addLines(values.enumerated().map {
                    .init(x: Double(rect.maxX) / .init(values.count - 1) * .init($0.0), y: .init(rect.maxY) - (.init(rect.maxY) * $0.1))
                })
            } else {
                $0.addLine(to: .init(x: rect.maxX, y: rect.maxY))
            }
        }
    }
}

private struct Dot: Shape {
    let y: Double
    let index: Int
    let count: Int

    func path(in rect: CGRect) -> Path {
        .init {
            $0.addArc(center: .init(x: Double(rect.maxX) / .init(count - 1) * .init(index), y: .init(rect.maxY) - (.init(rect.maxY) * y)), radius: 5, startAngle: .zero, endAngle: .init(radians: .pi * 2), clockwise: true)
        }
    }
}
