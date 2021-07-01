import SwiftUI

extension Trackers.Detail {
    struct Chart: View {
        let values: [Double]
        
        var body: some View {
            ZStack {
                Road(values: values)
                    .stroke(Color(.tertiaryLabel), style: .init(lineWidth: 3, lineCap: .round, lineJoin: .round))
                ForEach(0 ..< values.count, id: \.self) {
                    Dot(y: values[$0], index: $0, radius: $0 == values.count - 1 ? 5 : 3)
                        .fill(Color.primary)
                    if $0 == values.count - 1 {
                        Dot(y: values.last!, index: values.count - 1, radius: 9)
                            .fill(Color(.tertiaryLabel))
                    }
                }
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
                    .init(x: .init(rect.maxX / 9) * .init($0.0), y: .init(rect.maxY) - (.init(rect.maxY) * $0.1))
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
    let radius: CGFloat

    func path(in rect: CGRect) -> Path {
        .init {
            $0.addArc(center: .init(x: .init(rect.maxX / 9) * .init(index), y: .init(rect.maxY) - (.init(rect.maxY) * y)), radius: radius, startAngle: .zero, endAngle: .init(radians: .pi * 2), clockwise: true)
        }
    }
}
