import SwiftUI
import StoreKit
import Sleuth

struct Plus: View {
    @Binding var session: Session
    @State private var products = [(SKProduct, String)]()
    @State private var error: String?
    @State private var loading = true
    @State private var why = false
    @State private var alternatives = false
    @Environment(\.presentationMode) private var visible
    
    var body: some View {
        ScrollView {
            HStack {
                if !loading {
                    Button {
                        session.purchases.restore()
                    } label: {
                        Text("Restore purchases")
                            .foregroundColor(.secondary)
                            .frame(height: 50)
                            .contentShape(Rectangle())
                    }
                    .padding([.top, .leading])
                }
                Spacer()
                Button {
                    visible.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .frame(width: 60, height: 50)
                }
                .contentShape(Rectangle())
                .padding(.top)
            }
            if error != nil {
                HStack {
                    Spacer()
                    Text(verbatim: error!)
                        .foregroundColor(.secondary)
                        .padding(.top)
                        .padding()
                    Spacer()
                }
            } else if loading {
                HStack {
                    Spacer()
                    Text("Loading")
                        .bold()
                        .foregroundColor(.secondary)
                        .padding(.top)
                        .padding()
                    Spacer()
                }
            } else {
                ForEach(products, id: \.0.productIdentifier) { product in
                    Item(purchase: Purchases.Item(rawValue: product.0.productIdentifier)!, price: product.1) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            session.purchases.purchase(product.0)
                        }
                    }
                }
                
                Control.Option(text: "Why In-App Purchases", image: "questionmark") {
                    why = true
                }
                .padding(.top)
                .sheet(isPresented: $why) {
                    Plus.Card(session: $session, title: "Why purchasing\nPrivacy Plus?", message: """
By upgrading to Privacy Plus you are supporting the development and research necessary to fulfil our mission of bringing the most secure and private browser to iOS and macOS.

Compared to other browser alternatives, we at Privacy Inc. are an independent team, we don't have the support of big international corporations.

Furthermore, besides our In-App Purchases we don't monetize using any other mean, i.e. we don't monetize with your personal data, and we don't provide advertisements, in fact, is in our mission to remove ads from the web.
""", action: nil)
                }
                
                Control.Option(text: "Alternatives", image: "arrow.rectanglepath") {
                    alternatives = true
                }
                .sheet(isPresented: $alternatives) {
                    Plus.Card(session: $session, title: "Alternatives\nto purchasing", message: """
We ask you to purchase Privacy Plus only if you consider it a good product, if you think is helping you in some way and if you feel the difference between a mainstream browser and Privacy.

But we are not going to force you to buy it; you will be reminded from time to time that it would be a good idea if you support us with your purchase, but you can as easily ignore the pop-up and continue using Privacy.

We believe we can help you browse securely and privatly even if you can't support us at the moment.
""", action: nil)
                }
            }
            Spacer()
                .frame(height: 30)
        }
        .animation(.easeInOut(duration: 0.3))
        .onReceive(session.purchases.loading) {
            loading = $0
        }
        .onReceive(session.purchases.error) {
            error = $0
        }
        .onReceive(session.purchases.products) {
            error = nil
            products = $0
        }
        .onReceive(session.dismiss) {
            visible.wrappedValue.dismiss()
        }
        .onAppear {
            error = nil
            session.purchases.load()
        }
    }
}
