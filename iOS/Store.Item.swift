import SwiftUI
import Sleuth

extension Store {
    struct Item: View {
        let purchase: Purchases.Item
        let price: String
        let action: () -> Void
        @AppStorage(Defaults.Key.premium.rawValue) private var premium = false
        
        var body: some View {
            VStack {
                Image(purchase.image)
                    .padding(.top, 40)
                    .padding(.bottom)
                Text(verbatim: purchase.title)
                    .foregroundColor(.primary)
                    .font(.largeTitle.bold())
                Text(verbatim: purchase.subtitle)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                if premium {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.accentColor)
                        .padding(.vertical)
                } else {
                    Text(verbatim: price)
                        .bold()
                        .padding(.top, 40)
                    Button(action: action) {
                        ZStack {
                            Capsule()
                                .fill(Color.blue)
                            Text("Purchase")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                        }
                        .frame(width: 160)
                        .contentShape(Rectangle())
                    }
                }
                Spacer()
                    .frame(height: 50)
            }
            .textCase(.none)
            .padding()
            .frame(maxWidth: .greatestFiniteMagnitude)
        }
    }
}
