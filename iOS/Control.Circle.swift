import SwiftUI

extension Control {
    struct Circle: View {
        let image: String
        let action: () -> Void
        
        var body: some View {
            Button(action: action) { }
                .buttonStyle(Style { selected in
                    ZStack {
                        SwiftUI.Circle()
                            .fill(Color.clear)
                            .frame(width: 90, height: 90)
                        if selected {
                            SwiftUI.Circle()
                                .fill(UIApplication.dark ? Color.black : .white)
                                .frame(width: 44, height: 44)
                        } else {
                            SwiftUI.Circle()
                                .fill(Color.background)
                                .modifier(Neumorphic())
                                .frame(width: 50, height: 50)
                        }
                        Image(systemName: image)
                            .foregroundColor(selected ? Color(.tertiaryLabel) : .primary)
                    }
                    .contentShape(SwiftUI.Circle())
                })
        }
    }
}
