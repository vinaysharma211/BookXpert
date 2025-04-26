//
//  LoginVC.swift
//  BookXpert
//
//  Created by APPLE on 23/04/25.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

class LoginVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupLogo()
        setupGoogleSignInButton()
    }
    
    // MARK: - BookXpert Logo with Welcome Text
    func setupLogo() {
        // Logo
        let logoImageView = UIImageView(image: UIImage(named: "bookxpert"))
        logoImageView.contentMode = .scaleAspectFit
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false

        // Welcome Label
        let welcomeLabel = UILabel()
        welcomeLabel.text = "Welcome to BookXpert!\nSign in to continue."
        welcomeLabel.textAlignment = .center
        welcomeLabel.textColor = .white
        welcomeLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        welcomeLabel.numberOfLines = 2
        view.addSubview(welcomeLabel)
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Logo
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.widthAnchor.constraint(equalToConstant: 150),
            logoImageView.heightAnchor.constraint(equalToConstant: 150),
            
            // Label
            welcomeLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }

    
    // MARK: - Google Sign-In Button
    func setupGoogleSignInButton() {
        let signInButton = UIButton(type: .system)
        signInButton.setTitle("Sign in with Google", for: .normal)
        signInButton.setTitleColor(.darkGray, for: .normal)
        signInButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        signInButton.backgroundColor = .white
        signInButton.layer.cornerRadius = 25
        signInButton.layer.shadowColor = UIColor.black.cgColor
        signInButton.layer.shadowOpacity = 0.1
        signInButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        signInButton.layer.shadowRadius = 4
        signInButton.contentHorizontalAlignment = .left
        signInButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 80, bottom: 0, right: 0)
        
        // Google logo
        let googleLogo = UIImageView(image: UIImage(named: "google_icon")) // Put a PNG named google_icon in Assets
        googleLogo.frame = CGRect(x: 50, y: 13, width: 24, height: 24)
        signInButton.addSubview(googleLogo)
        
        view.addSubview(signInButton)
        
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 320),
            signInButton.widthAnchor.constraint(equalToConstant: 280),
            signInButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Add action
        signInButton.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
    }
    
    // MARK: - Gradient Background
    func setupGradientBackground() {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.systemIndigo.cgColor, UIColor.systemTeal.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Check if user is already signed in
        if Auth.auth().currentUser != nil {
            // User is signed in, skip login
            goToDashboard()
        }
    }
    
    @objc func handleSignIn() {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            if let error = error {
                print("Google Sign-In failed:", error.localizedDescription)
                return
            }

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                print("Token extraction failed")
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Firebase Sign-In failed:", error.localizedDescription)
                    return
                }
                // Signed in
                print("User is signed in: \(authResult?.user.uid ?? "")")

                self.goToDashboard()
            }
        }
    }
    
    private func goToDashboard() {
        let dashboardVC = DashBoardVC()
        self.navigationController?.setViewControllers([dashboardVC], animated: true)
    }
}


