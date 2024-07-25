import SwiftUI
import WebKit

struct HTMLContentView: UIViewRepresentable  {
    private let html: String
    
    init(htmlElements: [String], scheme:ColorScheme) {
        let textColor = scheme == .dark ? "white" : "black"
        
        
        var elemts: String = ""
        for el in htmlElements {
            let elementWithWrapper = "<div class=\"element\">\(el)</div>"
            elemts.append(elementWithWrapper)
        }
        
        let wrapper = """
        <style>
            * {
                font-family: Sans-Serif;
                font-size: 1.5rem;
                line-height: 2.25rem;
                color:\(textColor);
                animation: fadeInAnimation ease .5s;
            }
        
            a {
                color: orange;
            }
        
            .element {
                margin-bottom: 1.5rem;
            }
        
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
            \(elemts)
        <div>
        """
        self.html = wrapper
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(html, baseURL: nil)
    }
    
}

#Preview {
    VStack{
        HTMLContentView(
            htmlElements: [
                #"A <a rel=\"mw:WikiLink\" href=\"/wiki/shrub\" title=\"shrub\">shrub</a> of the genus <i><a rel=\"mw:WikiLink\" href=\"/wiki/Rosa\" title=\"Rosa\">Rosa</a></i>, with red, pink, white or yellow <a rel=\"mw:WikiLink\" href=\"/wiki/flower\" title=\"flower\">flowers</a>."#,
                #"A <a rel=\"mw:WikiLink\" href=\"/wiki/shrub\" title=\"shrub\">shrub</a> of the genus <i><a rel=\"mw:WikiLink\" href=\"/wiki/Rosa\" title=\"Rosa\">Rosa</a></i>, with red, pink, white or yellow <a rel=\"mw:WikiLink\" href=\"/wiki/flower\" title=\"flower\">flowers</a>."#,
                
            ],
            scheme: .light
        )
    }.frame(
        width: .infinity,
        height: .infinity
    )
}
