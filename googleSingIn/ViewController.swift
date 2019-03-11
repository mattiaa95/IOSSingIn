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

class ViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    @IBOutlet weak var token: UITextView!
    
    let linkedinHelper = LinkedinSwiftHelper(configuration: LinkedinSwiftConfiguration(clientId: "868pwy7gzu2kok", clientSecret: "rKEGlhWB1kSdNhSA", state: "linkedin\(Int(Date().timeIntervalSince1970))", permissions: ["r_basicprofile", "r_emailaddress"], redirectUrl: "https://github.com/tonyli508/LinkedinSwift"), nativeAppChecker: WebLoginOnly())

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //GOOGLE
    
    @IBAction func logimByGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    //MARK:- Google Delegate
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
    }
    
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
                     withError error: Error!) {
        if let error = error  {
             print("\(error)")
        } else {
            let idToken = user.authentication.idToken
            print(idToken!)
            self.token.text = idToken
        }
    }
    
    //GoogleSingOut
    @IBAction func singut(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
    }
    //End Google
    
    //Facebook custom login
    @IBAction func loginButtonFacebook() {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success( _, _, let accessToken):
                print("Logged in!")
                print(accessToken.authenticationToken)
                self.token.text = accessToken.authenticationToken
            }
        }
    }
    
    //Facebook custom logout
    @IBAction func logOutButtonFacebook() {
        let loginManager = LoginManager()
        loginManager.logOut()
    }
    
    // Twitter login custom
    @IBAction func logInTwitter() {
        TWTRTwitter.sharedInstance().logIn {
            (session, error) -> Void in
            if (session != nil) {
                print("token: \(session!.authToken)")
                print("secretToken: \(session!.authTokenSecret)")
                self.token.text = session!.authToken
            } else {
                print("error: \(error!.localizedDescription)")
            }
        }

    }
    

    /**
     Login with Linkedin
     */
    @IBAction func login() {
        linkedinHelper.authorizeSuccess({ (lsToken) -> Void in
            print("Login success LinkedIn lsToken.accessToken: \(String(describing: lsToken.accessToken))")
            self.token.text = lsToken.accessToken
        }, error: { (error) -> Void in
            print("Encounter error: \(error.localizedDescription)")
        }, cancel: { () -> Void in
            print("User Cancelled!")
        })
    }
    //Linkedin logout
    @IBAction func logout() {
        linkedinHelper.logout()
    }
    
}

