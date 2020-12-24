import WebKit
import Sleuth

extension WKUserContentController {
    private static var cookies: WKContentRuleList?
    private static var ads: WKContentRuleList?
    
    func blockCookies() {
        if let cookies = Self.cookies {
            add(cookies)
        } else {
            WKContentRuleListStore.default()!.compileContentRuleList(forIdentifier: "cookies", encodedContentRuleList: Cookies.rule) { [weak self] list, _ in
                self?.add(list!)
                Self.cookies = list!
            }
        }
    }
    
    func blockAds() {
        if let ads = Self.ads {
            add(ads)
        } else {
            WKContentRuleListStore.default()!.compileContentRuleList(forIdentifier: "ads", encodedContentRuleList: Ads.serialise) { [weak self] list, _ in
                self?.add(list!)
                Self.ads = list!
            }
        }
        
        addUserScript(.init(source: Scripts.scroll, injectionTime: .atDocumentEnd, forMainFrameOnly: true))
    }
    
    func dark() {
        addUserScript(.init(source: Scripts.dark, injectionTime: .atDocumentEnd, forMainFrameOnly: false))
    }
}
