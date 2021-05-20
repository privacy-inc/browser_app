import SwiftUI

extension Tab {
    struct Options: View, Tabber {
        @Binding var session: Session
        let id: UUID
        @Environment(\.presentationMode) private var visible
        
        var body: some View {
            NavigationView {
                List {
                    Section(
                        header: Text("URL")) {
                        Control(title: "Share", image: "square.and.arrow.up") {
                            
                        }
                        Control(title: "Copy", image: "doc.on.doc") {
                            
                        }
                    }
                    Section(
                        header: Text("Page")) {
                        Control(title: "Share", image: "square.and.arrow.up") {
                            
                        }
                        Control(title: "Download", image: "square.and.arrow.down") {
                            
                        }
                        Control(title: "Print", image: "printer") {
                            
                        }
                        Control(title: "Export as PDF", image: "doc.richtext") {
                            
                        }
                    }
                    Section(
                        header: Text("Image")) {
                        Control(title: "Add to Photos", image: "photo") {
                            dismiss()
                            url
                                .flatMap {
                                    try? Data(contentsOf: $0)
                                }
                                .flatMap(UIImage.init(data:))
                                .map {
                                    UIImageWriteToSavedPhotosAlbum($0, nil, nil, nil)
                                    session.toast = .init(title: "Added to Photos", icon: "photo")
                                }
                        }
                        .opacity(photo ? 1 : 0.3)
                    }
                    .disabled(!photo)
                }
                .listStyle(GroupedListStyle())
                .navigationBarTitle("Sharing options", displayMode: .large)
                .navigationBarItems(trailing:
                                        Button(action: dismiss) {
                                            Image(systemName: "xmark")
                                                .foregroundColor(.secondary)
                                                .frame(width: 30, height: 50)
                                                .padding(.leading, 40)
                                                .contentShape(Rectangle())
                                        })
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
        
        private var string: String {
            browse
                .map(session.archive.page)
                .map(\.access.string)
            ?? ""
        }
        
        private var url: URL? {
            browse
                .map(session.archive.page)
                .flatMap(\.access.url)
        }
        
        private var photo: Bool {
            switch string.components(separatedBy: ".").last!.lowercased() {
            case "png", "jpg", "jpeg", "bmp", "gif": return true
            default: return false
            }
        }
        
        private func dismiss() {
            visible.wrappedValue.dismiss()
        }
    }
}
