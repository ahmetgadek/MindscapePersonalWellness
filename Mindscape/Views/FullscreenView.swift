import SwiftUI
import WebKit

struct FullscreenView: View {
    @StateObject private var viewModel = FullscreenViewModel()
    
    private func updateSupportedInterfaceOrientations() {
        if #available(iOS 16.0, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let rootViewController = windowScene.windows.first?.rootViewController else {
                return
            }
            rootViewController.setNeedsUpdateOfSupportedInterfaceOrientations()
        } else {
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }
    
    var body: some View {
        OrientationLockView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                if let destination = viewModel.destination {
                    BrowserView(address: destination, onLoadComplete: {
                        viewModel.onPageLoaded()
                    })
                    .ignoresSafeArea()
                    .opacity(viewModel.isLoading ? 0 : 1)
                }
                
                if viewModel.isLoading {
                    ZStack {
                        Color.black
                            .ignoresSafeArea()
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5)
                    }
                }
            }
            .task {
                await viewModel.checkTokenAndLoad()
                // destination is set in viewModel, triggering BrowserView to appear and load
            }
        }
        .ignoresSafeArea()
        .statusBarHidden(true)
        .persistentSystemOverlays(.hidden)
        .onAppear {
            AppDelegate.orientationLock = .all
            updateSupportedInterfaceOrientations()
        }
        .onDisappear {
            AppDelegate.orientationLock = .portrait
            updateSupportedInterfaceOrientations()
        }
    }
}

struct OrientationLockView<Content: View>: UIViewControllerRepresentable {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    func makeUIViewController(context: Context) -> OrientationLockViewController<Content> {
        let hostingController = OrientationLockViewController(rootView: content)
        hostingController.view.backgroundColor = .black
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return hostingController
    }
    
    func updateUIViewController(_ uiViewController: OrientationLockViewController<Content>, context: Context) {
        uiViewController.rootView = content
    }
}

class OrientationLockViewController<Content: View>: UIHostingController<Content> {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var childForStatusBarHidden: UIViewController? {
        return nil
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.insetsLayoutMarginsFromSafeArea = false
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
}

struct BrowserView: UIViewRepresentable {
    let address: String
    let onLoadComplete: () -> Void
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.backgroundColor = .black
        webView.isOpaque = false
        webView.allowsBackForwardNavigationGestures = true
        
        if let url = URL(string: address) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let currentURL = webView.url?.absoluteString
        if currentURL != address, let url = URL(string: address) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onLoadComplete: onLoadComplete)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let onLoadComplete: () -> Void
        private var hasLoaded = false
        
        init(onLoadComplete: @escaping () -> Void) {
            self.onLoadComplete = onLoadComplete
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            decisionHandler(.allow)
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
            decisionHandler(.allow)
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            if !hasLoaded {
                hasLoaded = true
                onLoadComplete()
            }
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            if !hasLoaded {
                hasLoaded = true
                onLoadComplete()
            }
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            if !hasLoaded {
                hasLoaded = true
                onLoadComplete()
            }
        }
    }
}

