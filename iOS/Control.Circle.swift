import SwiftUI

extension Control {
    struct Circle: View {
        let state: State
        let image: String
        let action: () -> Void
        
        var body: some View {
            Button(action: action) { }
                .buttonStyle(Style(state: state) { current in
                    ZStack {
                        SwiftUI.Circle()
                            .fill(Color.clear)
                            .frame(width: 85, height: 85)
                        switch current {
                        case .ready:
                            SwiftUI.Circle()
                                .fill(Color.background)
                                .modifier(Neumorphic())
                                .frame(width: 50, height: 50)
                        case .selected:
                            SwiftUI.Circle()
                                .fill(UIApplication.dark ? Color.black : .white)
                                .frame(width: 44, height: 44)
                        case .disabled:
                            SwiftUI.Circle()
                                .fill(UIApplication.dark ? Color.black : .white)
                                .frame(width: 44, height: 44)
                        }
                        Image(systemName: image)
                            .foregroundColor(current == .selected ? Color(.tertiaryLabel) : .primary)
                    }
                    .contentShape(SwiftUI.Circle())
                    .padding(.horizontal, 5)
                })
        }
    }
}
