import SwiftUI

extension Activity {
    struct Chart: View {
        let values: [Double]
        var body: some View {
            ZStack {
                Road(values: values)
                    .stroke(Color.secondary, style: .init(lineWidth: 1, lineCap: .round, lineJoin: .round))
                    .clipShape(Holes(values: values))
                    .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
                ForEach(0 ..< values.count, id: \.self) {
                    Dot(y: values[$0], index: $0, radius: $0 == values.count - 1 ? 7 : 3)
                        .stroke(Color.secondary, lineWidth: 1)
//                    if $0 == values.count - 1 {
//                        Dot(y: values.last!, index: values.count - 1, radius: 7)
//                            .fill(Color.primary)
//                    }
                }
            }
        }
    }
}

private struct Road: Shape {
    let values: [Double]

    func path(in rect: CGRect) -> Path {
        .init {
            let rect = rect.insetBy(dx: 30, dy: 30)
            if !values.isEmpty {
                $0.addLines(values.enumerated().map {
                    .init(x: (.init(rect.maxX / 9) * .init($0.0)) + Double(15),
                          y: (.init(rect.maxY) - (.init(rect.maxY) * $0.1)) + Double(15))
                })
            } else {
                $0.addLine(to: .init(x: rect.maxX, y: rect.maxY))
            }
        }
    }
}

struct Holes: Shape {
    let values: [Double]
    
    func path(in rect: CGRect) -> Path {
        var path = Rectangle().path(in: rect)
        let rect = rect.insetBy(dx: 30, dy: 30)
        (0 ..< values.count)
            .forEach { index in
                path
                    .addPath(
                        .init(
                            UIBezierPath(cgPath: Circle()
                                            .path(in: CGRect(
                                                    x: (Double(rect.maxX / 9) * Double(index)) + Double(10),
                                                    y: (Double(rect.maxY) - (Double(rect.maxY) * values[index])) + Double(10),
                                                    width: Double(10),
                                                    height: Double(10)))
                                            .cgPath)
                                .reversing()
                                .cgPath))
            }
        return path
    }
}

private struct Dot: Shape {
    let y: Double
    let index: Int
    let radius: CGFloat

    func path(in rect: CGRect) -> Path {
        .init {
            let rect = rect.insetBy(dx: 30, dy: 30)
            $0.addArc(center: .init(x: (.init(rect.maxX / 9) * .init(index)) + Double(15),
                                    y: (.init(rect.maxY) - (.init(rect.maxY) * y)) + Double(15)),
                      radius: radius, startAngle: .zero, endAngle: .init(radians: .pi * 2), clockwise: true)
        }
    }
}
