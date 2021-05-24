import SwiftUI
import StoreKit
import Sleuth

struct Store: View {
    @Binding var session: Session
    @State private var products = [(product: SKProduct, price: String)]()
    @State private var error: String?
    @State private var loading = true
    @State private var why = false
    @State private var alternatives = false
    @Environment(\.presentationMode) private var visible
    
    var body: some View {
        Popup(title: "", leading: {
            Button {
                session.purchases.restore()
            } label: {
                Text("Restore purchases")
                    .font(.footnote.bold())
                    .frame(height: 50)
                    .contentShape(Rectangle())
            }
        }) {
            if let error = error {
                Text(verbatim: error)
                            .foregroundColor(.secondary)
                            .padding()
                            .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude, alignment: .topLeading)
            } else if loading {
                Text("Loading")
                            .bold()
                            .foregroundColor(.secondary)
                            .padding()
                            .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude, alignment: .topLeading)
            } else {
                List {
                    Section(header:
                                ForEach(products, id: \.product.productIdentifier) { product in
                                    Item(purchase: Purchases.Item(rawValue: product.0.productIdentifier)!, price: product.1) {
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            session.purchases.purchase(product.0)
                                        }
                                    }
                                }) {
                        NavigationLink(destination: Info.Why()) {
                            Label("Why In-App Purchases", systemImage: "questionmark")
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
        .onAppear {
            session.purchases.load()
        }
    }
}
