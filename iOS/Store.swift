import SwiftUI
import StoreKit
import Sleuth

struct Store: View {
    @State private var products = [(product: SKProduct, price: String)]()
    @State private var error: String?
    @State private var loading = true
    @State private var why = false
    @State private var alternatives = false
    
    var body: some View {
        Popup(title: "", leading: {
            Button {
                purchases.restore()
            } label: {
                if error == nil && !loading {
                    Text("Restore purchases")
                        .font(.footnote.bold())
                        .frame(height: 50)
                        .contentShape(Rectangle())
                }
            }
        }) {
            if let error = error {
                Text(verbatim: error)
                    .foregroundColor(.secondary)
                    .padding()
                    .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude, alignment: .topLeading)
            } else if loading {
                Image(systemName: "hourglass.bottomhalf.fill")
                    .font(.largeTitle)
                    .foregroundColor(.init(.tertiaryLabel))
                    .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
            } else {
                List {
                    Section(header:
                                ForEach(products, id: \.product.productIdentifier) { product in
                                    Item(purchase: Purchases.Item(rawValue: product.0.productIdentifier)!, price: product.1) {
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            purchases.purchase(product.0)
                                        }
                                    }
                                }) {
                        NavigationLink(destination: Info.Why()) {
                            Label("Why In-App Purchases", systemImage: "questionmark.circle.fill")
                                .font(.footnote)
                        }
                        NavigationLink(destination: Info.Alternatives()) {
                            Label("Alternatives", systemImage: "arrow.rectanglepath")
                                .font(.footnote)
                        }
                    }
                }
                .listStyle(GroupedListStyle())
            }
        }
        .onReceive(purchases.loading) {
            loading = $0
        }
        .onReceive(purchases.error) {
            error = $0
        }
        .onReceive(purchases.products) {
            error = nil
            products = $0
        }
        .onAppear {
            purchases.load()
        }
    }
}
