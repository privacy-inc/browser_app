import SwiftUI
import Sleuth

extension Plus {
    struct Item: View {
        let purchase: Purchases.Item
        let price: String
        let action: () -> Void
        @AppStorage(Defaults.Key.premium.rawValue) private var premium = false
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.background)
                VStack {
                    Image(purchase.image)
                        .padding(.top, 40)
                        .padding(.bottom)
                    Text(verbatim: purchase.title)
                        .font(Font.largeTitle.bold())
                    Text(verbatim: purchase.subtitle)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    if premium {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.largeTitle)
                            .padding(.top)
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
                        }
                        .contentShape(Rectangle())
                    }
                    Spacer()
                        .frame(height: 30)
                }
                .padding()
            }
            .padding(.horizontal)
        }
    }
}
