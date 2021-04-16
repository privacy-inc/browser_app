import WebKit
import Sleuth

extension WKUserContentController {
    private static var _cookies: WKContentRuleList?
    private static var _ads: WKContentRuleList?
    private static var _blockers: WKContentRuleList?
    private static var _dark: WKContentRuleList?
    private static var _secure: WKContentRuleList?
    
    func cookies() {
        if let _cookies = Self._cookies {
            add(_cookies)
        } else {
            WKContentRuleListStore.default()!.compileContentRuleList(forIdentifier: "cookies", encodedContentRuleList: Block.cookies) { [weak self] list, _ in
                self?.add(list!)
                Self._cookies = list!
            }
        }
    }
    
    func ads() {
        if let _ads = Self._ads {
            add(_ads)
        } else {
            WKContentRuleListStore.default()!.compileContentRuleList(forIdentifier: "ads", encodedContentRuleList: Block.ads) { [weak self] list, _ in
                self?.add(list!)
                Self._ads = list!
            }
        }
    }
    
    func blockers() {
        if let _blockers = Self._blockers {
            add(_blockers)
        } else {
            WKContentRuleListStore.default()!.compileContentRuleList(forIdentifier: "blockers", encodedContentRuleList: Block.blockers) { [weak self] list, _ in
                self?.add(list!)
                Self._blockers = list!
            }
        }
        
        addUserScript(.init(source: Scripts.scroll, injectionTime: .atDocumentEnd, forMainFrameOnly: true))
    }
    
    func dark() {
        if let _dark = Self._dark {
            add(_dark)
        } else {
            WKContentRuleListStore.default()!.compileContentRuleList(forIdentifier: "dark", encodedContentRuleList: Block.dark) { [weak self] list, _ in
                self?.add(list!)
                Self._dark = list!
            }
        }
        
//        addUserScript(.init(source: Scripts.dark, injectionTime: .atDocumentEnd, forMainFrameOnly: false))
        
        
        addUserScript(.init(source: """

function makeDark(element) {
    const background_color = getComputedStyle(element).getPropertyValue("background-color");
    const parts = background_color.match(/[\\d.]+/g);
    const shadow = getComputedStyle(element).getPropertyValue("box-shadow");
    const text_color = element.style.color;
    const gradient = getComputedStyle(element).getPropertyValue("background").includes("gradient");

    if (element.tagName != "A" && text_color != "") {
        element.style.setProperty("color", "#cecccf", "important");
    }

    if (shadow != "none") {
        element.style.setProperty("box-shadow", "none", "important");
    }

    if (gradient) {
        element.style.background = "none";
        element.style.backgroundColor = "rgba(37, 34, 40)";
    } else if (parts.length > 3) {
        if (parts[3] > 0) {
            element.style.backgroundColor = `rgba(37, 34, 40, ${ parts[3] })`;
        }
    } else {
        element.style.backgroundColor = "rgba(37, 34, 40)";
    }
}

                        event = function(event){
                                if (event.animationName == 'nodeInserted') makeDark(event.target);
                            }
                                
                        document.addEventListener('webkitAnimationStart', event, false);

                        const style = document.createElement('style');
                            style.innerHTML = " @-webkit-keyframes nodeInserted {   from { outline-color: #fff;  } to { outline-color: #000; } } * { -webkit-animation-duration: 0.01s; -webkit-animation-name: nodeInserted; }  ";
                            document.head.appendChild(style);

""", injectionTime: .atDocumentStart, forMainFrameOnly: false))
    }
    
    func secure() {
        if let _secure = Self._secure {
            add(_secure)
        } else {
            WKContentRuleListStore.default()!.compileContentRuleList(forIdentifier: "secure", encodedContentRuleList: Block.secure) { [weak self] list, _ in
                self?.add(list!)
                Self._secure = list!
            }
        }
    }
    
    func location() {
        addUserScript(.init(source: Scripts.location, injectionTime: .atDocumentEnd, forMainFrameOnly: true))
    }
}
