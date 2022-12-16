//
//  AuthViewController.swift
//  Spotify
//
//  Created by Amini on 25/12/21.
//

import UIKit
import WebKit
import Combine

class AuthViewController: UIViewController, WKNavigationDelegate {
    
    private let webView: WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        
        let webView = WKWebView(frame: .zero,
                                configuration: config)
        
        return webView
    }()
    
    public var completionHandler: ((Bool) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sign In"
        view.backgroundColor = .systemBackground
        
        webView.navigationDelegate = self
        
        view.addSubview(webView)
        
        guard let url = AuthManager.shared.signInURL else {
            return
        }
        
        webView.load(URLRequest(url: url))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }

    private var subcsriptions = Set<AnyCancellable>()


    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {
            return
        }
        
        //Exchange the code for access token
        let component = URLComponents(string: url.absoluteString)
        guard let code = component?.queryItems?.first(where: { $0.name == "code"})?.value
            else {
            return
        }
        webView.isHidden = true
        
        AuthManager.shared.excngeCodeForToken(code: code).sink { completion in
            if case .failure(let error) = completion {
                // handle failure
                print(error)
            }
        } receiveValue: { [weak self] success in
            
            self?.saveUserProfile()
            
            DispatchQueue.main.async {
                self?.navigationController?.popToRootViewController(animated: true)
                self?.completionHandler?(success)
            }
        }.store(in: &subcsriptions)
        
        print("Code :\(code)")
    }
    
    var subscriptions = Set<AnyCancellable>()

    private func saveUserProfile() {
        UserProfileData.current.publisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {(completion) in
                switch completion {
                case .failure(let error):
                    print(error)
                    return
                case .finished:
                    return
                }
            }, receiveValue: {(profile: UserProfile) in
                UserCache.shared.saveUser(profile: profile)
            })
            .store(in: &subcsriptions)
    }
    
//    private func cacheProfile(profile: UserProfile) {
//        UserDefaults.standard.set(profile, forKey: "user_profile")
//    }
}
