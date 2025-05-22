import SwiftUI
import WebKit

struct HealthWebView: View {
    let url: URL
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        WebView(url: url)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
    }
}

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Update if needed
    }
}

#Preview {
    NavigationStack {
        HealthWebView(url: URL(string: "https://www.example.com")!)
    }
} 