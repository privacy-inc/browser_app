import SwiftUI

extension Fast {
    struct Content: View {
        let entry: Entry
        private let spacing = CGFloat(5)
        
        var body: some View {
            ZStack {
                Color(.secondarySystemBackground)
                    .edgesIgnoringSafeArea(.all)
                HStack(spacing: spacing) {
                    ForEach(0 ..< entry.sites.count, id: \.self) { column in
                        VStack(spacing: spacing) {
                            ForEach(0 ..< entry.sites[column].count, id: \.self) { index in
                                Cell(item: entry.sites[column][index])
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }
                .padding(.horizontal, spacing + 2)
            }
        }
    }
}
