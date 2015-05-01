//
//  LoginViewController.swift
//  Esrap
//
//  Created by Amie Kweon on 4/30/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignIn(sender: AnyObject) {
        let username = emailTextField.text
        let password = passwordTextField.text

        PFUser.logInWithUsernameInBackground(username, password: password) { (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                println("success signing in")
                self.goToChatViewController()
            } else {
                println("error signing in = \(error)")
            }
        }
    }

    @IBAction func onSignUp(sender: AnyObject) {
        var user = PFUser()
        user.username = emailTextField.text
        user.password = passwordTextField.text
        user.email = emailTextField.text

        user.signUpInBackgroundWithBlock { (suceeded, error) -> Void in
            if (error == nil) {
                println("success signing up")
                self.goToChatViewController()
            } else {
                if let userInfo = error?.userInfo,
                       error = userInfo["error"] as? String {
                    println("error = \(error)")
                }
            }
        }


    }

    func goToChatViewController() {
        performSegueWithIdentifier("chatSegue", sender: self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
