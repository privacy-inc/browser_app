import SwiftUI

struct Icon: View {
    let domain: String
    @State private var image = UIImage(systemName: "app",
                                       withConfiguration: UIImage
                                        .SymbolConfiguration(textStyle: .title1))!.withRenderingMode(.alwaysTemplate)
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 28, height: 28)
            .foregroundColor(.init(.quaternaryLabel))
            .onAppear {
                favicon.load(domain: domain)
            }
            .onReceive(favicon.icons) { icons in
                icons[domain]
                    .flatMap(UIImage.init(data:))
                    .map {
                        image = $0
                    }
            }
    }
}
