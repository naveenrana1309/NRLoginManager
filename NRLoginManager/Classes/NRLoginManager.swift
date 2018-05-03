//
//  NRLoginManager.swift
//  MojoRate
//
//  Created by Naveen Rana on 28/04/18.
//  Copyright © 2018 ARIMOJO PRIVATE LIMITED. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FacebookLogin
import GoogleSignIn


/// This library provides makes your login work easy by integrating the facebook and google login with one line of code.
open class NRLoginManager: NSObject, GIDSignInDelegate, GIDSignInUIDelegate{
    
    public static let shared = NRLoginManager()
    
    public enum SocialType {
        case facebook
        case google
    }
    
    
    /// Add google Client Id https://developers.google.com/identity/sign-in/ios/start-integrating
    public var clientID: String = "" {
        didSet {
            GIDSignIn.sharedInstance().clientID = clientID
        }
    }
    
    public var socialType: SocialType = .facebook
    public typealias CompletionHandler = (_ user: User?, _ error: Error?) -> ()
    typealias SuccessErrorCompletionHandler = (_ success: Bool, _ error: Error?) -> ()
    fileprivate func loginError(info: String = "app error") -> Error {
        return NSError(domain: "Error", code: -1309, userInfo: ["error": info])
        
    }
    
    var handler: CompletionHandler?
    
    //MARK: Set up Appdelegate
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?)  {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    public func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool  {
        switch socialType {
        case .facebook:
            return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        case .google:
            return GIDSignIn.sharedInstance().handle(url,sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        }
    }
    
    
    //MARK: Login
    public func login(type: SocialType,handler: @escaping CompletionHandler) {
        self.handler = handler
        self.socialType = type
        switch socialType {
        case .facebook:
            facebookLogin()
        case .google:
            if clientID.isEmpty {
                handler(nil, loginError(info: "Please provide client id: NRLoginManager.shared.clientID = "))
                return ()
            }
            googleLogin()
        }
    }
    
    //MARK: Facebook Login
    fileprivate  func facebookAuthenticattion(_ handler: @escaping SuccessErrorCompletionHandler) {
        let loginManager = LoginManager()
        if let viewController = UIApplication.shared.keyWindow?.rootViewController {
            loginManager.logIn(readPermissions: [.publicProfile,.email,.userBirthday], viewController: viewController) { (loginResult) in
                switch loginResult {
                case .failed(let error):
                    print(error)
                    handler(false, error)
                case .cancelled:
                    print("User cancelled login.")
                    handler(false, self.loginError())
                    
                case .success(_, _, _):
                    handler(true, nil)
                }
            }
            
        }
        
    }
    
    fileprivate func facebookLogin() {
        self.facebookAuthenticattion { (success, error) in
            if success {
                let params = ["fields": "email, id, name, picture.type(large), birthday"]
                let meRequest = FBSDKGraphRequest(graphPath: "me", parameters: params)
                _ = meRequest?.start { (connection, userinfo, error) in
                    
                    if error != nil {
                        print(error!)
                        self.handler?(nil, error)
                    }
                    else {
                        self.handler?(User(response: userinfo!), nil)
                    }
                    
                }
                
            }
            else {
                self.handler?(nil, error)
                
            }
        }
    }
    
    
    //MARK: Google Login
    
    fileprivate func googleLogin() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    //MARK: Google Sign in Delegates
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let _ = error {
            self.handler?(nil,error)
        } else {
            self.handler?(User(googleUser: user),error)
            
            // ...
        }
    }
    
    public func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
        self.handler?(nil,error)
    }
    
    public func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        
    }
    
    public func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        
    }
    
    //MARK: Logout and clear session
    public func logout() {
        switch socialType {
        case .facebook:
            LoginManager().logOut()
        case .google:
            GIDSignIn.sharedInstance().signOut()
        }
    }
    
    
    //MARK: User for Social Login
    public struct User {
        public var name = ""
        public var id = ""
        public var email: String?
        public var profilePic = ""
        
        init(response: Any) {
            let userDict = response as! NSDictionary
            self.name = userDict["name"] as! String
            self.id = userDict["id"] as! String
            self.email = userDict["email"] as? String
            self.profilePic = userDict.value(forKeyPath: "picture.data.url") as! String
        }
        
        init(googleUser: GIDGoogleUser) {
            self.name = googleUser.profile.name
            self.id = googleUser.userID
            self.email = googleUser.profile.email
            if googleUser.profile.hasImage {
                self.profilePic = googleUser.profile.imageURL(withDimension: 200).absoluteString
            }
        }
        
    }
    
    
    
}

