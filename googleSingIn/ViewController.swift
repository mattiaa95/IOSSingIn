//
//  ViewController.swift
//  googleSingIn
//
//  Created by Mattia on 06/03/2019.
//  Copyright © 2019 Mattia. All rights reserved.
//

import UIKit
import GoogleSignIn
import FacebookLogin
import FacebookCore
import TwitterKit
import LinkedinSwift

class ViewController: UIViewController, GIDSignInUIDelegate {
    @IBOutlet weak var token: UITextView!
    
    let linkedinHelper = LinkedinSwiftHelper(configuration: LinkedinSwiftConfiguration(clientId: "868pwy7gzu2kok", clientSecret: "rKEGlhWB1kSdNhSA", state: "linkedin\(Int(Date().timeIntervalSince1970))", permissions: ["r_basicprofile", "r_emailaddress"], redirectUrl: "https://github.com/tonyli508/LinkedinSwift"), nativeAppChecker: WebLoginOnly())

    override func viewDidLoad() {
        super.viewDidLoad()
        //FACEBOOK
        let loginButtonFacebook = LoginButton(readPermissions: [ .publicProfile ])
        loginButtonFacebook.center = CGPoint.init(x: 100, y: 100)
        view.addSubview(loginButtonFacebook)
        
        if let accessToken = AccessToken.current {
            self.token.text = accessToken.authenticationToken
            print(accessToken.authenticationToken)
        }
        
        //GOOGLE
         GIDSignIn.sharedInstance().uiDelegate = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ViewController.receiveToggleAuthUINotification(_:)),
                                               name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
                                               object: nil)
        
        //Twitter
        let logInButtonTwitter = TWTRLogInButton(logInCompletion: { session, error in
            if (session != nil) {
                print("token: \(session!.authToken)");
                print("secretToken: \(session!.authTokenSecret)");
            } else {
                print("error: \(error!.localizedDescription)");
            }
        })
        logInButtonTwitter.center = view.center
        view.addSubview(logInButtonTwitter)
        // Do any additional setup after loading the view, typically from a nib.
    }

    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func receiveToggleAuthUINotification(_ notification: NSNotification) {
        if notification.name.rawValue == "ToggleAuthUINotification" {
            if notification.userInfo != nil {
                guard let userInfo = notification.userInfo as? [String:String] else { return }
                print(userInfo["token"]!)
                self.token.text = userInfo["token"]!
            }
        }
    }
    
    @objc func loginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let _, let _, let accessToken):
                print("Logged in!")
                print(accessToken.authenticationToken)
                self.token.text = accessToken.authenticationToken
            }
        }
    }

    @IBAction func singut(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
    }
    
    
    /**
     Login with Linkedin
     */
    @IBAction func login() {
        
        linkedinHelper.authorizeSuccess({ (lsToken) -> Void in
            print("Login success LinkedIn lsToken.accessToken: \(String(describing: lsToken.accessToken))")
        }, error: { (error) -> Void in
            print("Encounter error: \(error.localizedDescription)")
        }, cancel: { () -> Void in
            print("User Cancelled!")
        })
    }
    
    @IBAction func logout() {
        linkedinHelper.logout()
    }
    
}

