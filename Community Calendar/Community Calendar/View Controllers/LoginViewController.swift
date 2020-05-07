//
//  LoginViewController.swift
//  Community Calendar
//
//  Created by Hayden Hastings on 12/16/19.
//  Copyright © 2019 Lambda School All rights reserved.
//
//  Dev Notes:
//  If you wanted to keep the user logged in even after closing the app,
//  there are some great docs on https://github.com/auth0/JWTDecode.swift.
//  (let jwt = try decode(jwt: token); jwt.expiresAt)
//  When opening the app, you can decode the token and see if it has already
//  expired, if not, refresh the token, if it has expired, log the user in again
//  Store the token in apple's keychain

import UIKit
import OktaOidc

class LoginViewController: UIViewController, ControllerDelegate {
    // MARK: - Variables
//    var homeController = HomeViewController()
    var controller: Controller? {
        didSet {
            print("LoginVC controller: \(String(describing: controller))")
        }
    }
    let authController = AuthController()
    let eventController = EventController()
    // MARK: - IBOutlets
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logOutButton.isHidden = true
        LoginButton.isHidden = true
        
        imageView.layer.cornerRadius = imageView.frame.height / 2
        authController.setupOktaOidc()
        authController.signIn(viewController: self) {
            if let accessToken = self.authController.stateManager?.accessToken {
                print("Access Token: \(accessToken))")
                self.authController.getUser { (_) in
                    
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

    }
    
    // MARK: - Functions
    private func logoutAlertController() {
        let alert = UIAlertController(title: "Success", message: "You have successfully logged out", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
            DispatchQueue.main.async {
                self.tabBarController?.selectedIndex = 0
            }
        })
        
        DispatchQueue.main.async{
            self.presentedViewController?.dismiss(animated: false) {
                OperationQueue.main.addOperation {
                    self.present(alert, animated: true)
                }
            }
        }
    }
    

    
    private func updateViews() {
//        guard let name = response["given_name"] else { return }
    }
    
    // MARK: - IBAction
    @IBAction func loginOrSignUpButtonPressed(_ sender: Any) {

    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        

    }
    
//    @objc
//    func receiveImage(_ notification: Notification) {
//        guard let imageNot = notification.object as? ImageNotification else {
//            assertionFailure("Object type could not be inferred: \(notification.object as Any)")
//            return
//        }
//        if let imageURL = profile?.picture?.absoluteString, imageNot.url == imageURL {
//            DispatchQueue.main.async {
//                self.imageView.image = imageNot.image
//            }
//        }
//    }
    
//    func observeImage() {
//        NotificationCenter.default.addObserver(self, selector: #selector(receiveImage), name: .imageWasLoaded, object: nil)
//    }

}
