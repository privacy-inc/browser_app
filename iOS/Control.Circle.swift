import SwiftUI

extension Control {
    struct Circle: View {
        var background = Color.background
        let state: State
        let image: String
        let action: () -> Void
        
        var body: some View {
            Button(action: action) { }
                .buttonStyle(Style(state: state) { current in
                    ZStack {
                        SwiftUI.Circle()
                            .fill(Color.clear)
                            .frame(width: 80, height: 80)
                        switch current {
                        case .ready:
                            SwiftUI.Circle()
                                .fill(background)
                                .modifier(Neumorphic())
                                .frame(width: 50, height: 50)
                        case .selected:
                            SwiftUI.Circle()
                                .fill(UIApplication.dark ? Color.black : .white)
                                .frame(width: 44, height: 44)
                        case .disabled:
                            EmptyView()
                        }
                        Image(systemName: image)
                            .foregroundColor(current == .ready ? Color.primary : .init(.tertiaryLabel) )
                    }
                    .contentShape(SwiftUI.Circle())
                })
        }
    }
}
