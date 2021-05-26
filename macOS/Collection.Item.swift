import AppKit

extension Collection {
    struct Item: Hashable {
        let id: Int
        let string: NSAttributedString
        let rect: CGRect
        
        init(id: Int, x: CGFloat, y: CGFloat) {
            self.id = id
            
            string = .init()
            rect = .init()
//            var size = Metrics.board.item.size
//            switch path {
//            case .column:
//                text = .make([.init(string: Session.archive[title: path] + " ",
//                                    attributes: [
//                                        .font: NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title2).pointSize, weight: .bold),
//                                        .foregroundColor: NSColor.labelColor,
//                                        .kern: 1]),
//                              .init(string: Session.decimal.string(from: .init(value: Session.archive.count(path)))!,
//                                                  attributes: [
//                                                    .font: NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .callout).pointSize, weight: .regular),
//                                                    .foregroundColor: NSColor.secondaryLabelColor,
//                                                    .kern: 1])])
//            case .card:
//                text = .make([.init(string: Session.archive[content: path],
//                                    attributes: [
//                                        .font: NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize, weight: .regular),
//                                        .foregroundColor: NSColor.labelColor,
//                                        .kern: 1])])
//                size.width -= Metrics.board.card.left + 4
//            default:
//                text = .init()
//            }
//
//            rect = {
//                .init(x: x, y: y,
//                      width: Metrics.board.item.padding2 + Metrics.board.item.size.width,
//                      height: ceil($0.height) + Metrics.board.item.padding2)
//            } (CTFramesetterSuggestFrameSizeWithConstraints(CTFramesetterCreateWithAttributedString(text), CFRange(), nil, size, nil))
        }
        
        func hash(into: inout Hasher) {
            into.combine(id)
            into.combine(string)
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id && lhs.string == rhs.string
        }
    }
}
