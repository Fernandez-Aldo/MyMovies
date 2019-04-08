//
//  LoginViewController.swift
//  MyMovies
//
///  Created by MAC Consultant on 04/01/19.
//  Copyright © 2019 Aldo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginWebButton: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passTextField.text = ""
        passTextField.isSecureTextEntry = true
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        setLoggingIn(true)
        TheDBUser.requestToken(completionHandler: handleRequestTokenResponse(success:error:))
    }
    
    private func handleRequestTokenResponse(success: Bool, error: Error?) {
        if success {
            print("Access Token: \(Auth.requestToken)")
            
            let user = LoginRequest(userName: self.emailTextField.text!, password: self.passTextField.text!, requestToken: Auth.requestToken)
            
            TheDBUser.requestLogin(for: user, completionHandler: self.handleRequestLogin(success:error:))
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
            setLoggingIn(false)
        }
    }
    
    private func handleRequestLogin(success: Bool, error: Error?) {
        if success {
            TheDBUser.requestSessionId(completionHandler: handleRequestSessionResponse(success:error:))
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
            setLoggingIn(false)
        }
    }
    
    
    func handleRequestSessionResponse(success: Bool, error: Error?) {
        setLoggingIn(false)
        if success {
            self.performSegue(withIdentifier: "completeLogin", sender: nil)
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
            setLoggingIn(false)
        }
    }
    
    @IBAction func loginViaWebsiteTapped() {
        setLoggingIn(true)
        TheDBUser.requestToken { (success, error) in
            if success {
                DispatchQueue.main.async {
                    UIApplication.shared.open(Endpoints.webAuth.url, options: [:], completionHandler: nil)
                }
                
            }
        }
    }
    
    private func setLoggingIn(_ loggingIn: Bool) {
        loginButton.isEnabled = !loggingIn
        loginWebButton.isEnabled = !loggingIn
        emailTextField.isEnabled = !loggingIn
        passTextField.isEnabled = !loggingIn
    }
    
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Couldn't verify user details", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}
