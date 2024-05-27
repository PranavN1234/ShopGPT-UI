import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1.5, anchor: .center)
            Text("Loading...")
                .padding(.top, 10)
        }
    }
}

#Preview {
    LoadingView()
}
