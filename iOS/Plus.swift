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
                    Why(session: $session)
                }
                
                Control.Option(text: "Alternatives", image: "arrow.rectanglepath") {
                    alternatives = true
                }
                .sheet(isPresented: $alternatives) {
                    Alternatives(session: $session)
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
