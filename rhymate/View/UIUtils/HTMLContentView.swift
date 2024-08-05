import SwiftUI
import WebKit

struct HTMLContentLinkOptions{
    let baseUrl: String
    let target: String
    let color: String
}

struct HTMLContentView: UIViewRepresentable {
    private let html: String

    init(
        htmlElements: [String],
        scheme: ColorScheme,
        classNames: String = "",
        linkOptions: HTMLContentLinkOptions
    ) {
        let textColor = scheme == .dark ? "white" : "black"
        
        var elements: String = ""
        for el in htmlElements {
            let elementWithWrapper = "<div class=\"element\">\(el)</div>"
            elements.append(elementWithWrapper)
        }
        
        let wrapper = """
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1">
        </head>
        <base href="\(linkOptions.baseUrl)" />
        <base target="\(linkOptions.target)" />
        <style>
            * {
                font-family: SF Pro, Sans-Serif;
                font-size: 1rem;
                line-height: 1.5rem;
                color: \(textColor);
                animation: fadeInAnimation ease .3s;
                margin: 0;
            }
        
            a {
                color: \(linkOptions.color);
            }
        
            .element {
                margin-bottom: 1rem;
                padding: 0 1.5rem;
            }
        
            \(classNames)
        
            @keyframes fadeInAnimation {
                0% {
                    opacity: 0;
                }
                100% {
                    opacity: 1;
                }
            }
        </style>
        <div>
            \(elements)
        </div>
        """
        self.html = wrapper
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(html, baseURL: nil)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        var parent: HTMLContentView

        init(_ parent: HTMLContentView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url, navigationAction.navigationType == .linkActivated {
                if navigationAction.targetFrame == nil {
                    UIApplication.shared.open(url)
                    decisionHandler(.cancel)
                } else {
                    decisionHandler(.allow)
                }
            } else {
                decisionHandler(.allow)
            }
        }
        
        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            if let url = navigationAction.request.url {
                UIApplication.shared.open(url)
            }
            return nil
        }
    }
}

#Preview {
    VStack {
        HTMLContentView(
            htmlElements: [
                #"A <a target="_blank" rel="mw:WikiLink" href="https://en.wiktionary.org/wiki/shrub" title="shrub">shrub</a> of the genus <i><a target="_blank" rel="mw:WikiLink" href="https://en.wiktionary.org/wiki/Rosa" title="Rosa">Rosa</a></i>, with red, pink, white or yellow <a target="_blank" rel="mw:WikiLink" href="https://en.wiktionary.org/wiki/flower" title="flower">flowers</a>."#
            ],
            scheme: .light,
            linkOptions: HTMLContentLinkOptions(
                baseUrl: "https://en.wiktionary.org/",
                target: "_target",
                color: ACCENT_COLOR
            )
        )
    }.frame(maxWidth: .infinity, maxHeight: .infinity)
}
