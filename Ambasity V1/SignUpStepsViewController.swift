//
//  SignUpStepsViewController.swift
//  Ambasity V1
//
//  Created by Zak on 4/14/18.
//  Copyright © 2018 ClosestPath. All rights reserved.
//

import UIKit
import Parse

struct Form {
    
    let headerText: String
    let descriptionText: String
    
}

class SignUpStepsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
// Variable Initializers
    private var username = String()
    private var password = String()
    private var confirmPassword = String()
    private var phoneNumber: Int?
    
    private var user = PFUser()
    
    private let forms = [
        
        Form(headerText: "Let's Get Started", descriptionText: "What is your email address?"),
        Form(headerText: "Create a Password", descriptionText: "Must be a minimum of 8 characters, include at least one number and one capital letter"),
        Form(headerText: "Confirm Your Password", descriptionText: "Re-enter your chosen password"),
        Form(headerText: "Enter Your Phone Number", descriptionText: "Include your area code")
        
    ]
    
// View Initializers
    private let cancelButton: UIButton = {
        let button = UIButton()
        
        let buttonTitle = NSMutableAttributedString(string: "Cancel", attributes:
            [NSAttributedStringKey.font: UIFont(name: "Avenir-Medium", size: 20)!,
             NSAttributedStringKey.foregroundColor: UIColor.white]
        )
        
        button.setAttributedTitle(buttonTitle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(cancelButton_TouchUpInside), for: .touchUpInside)
        
        return button
    }()
    
    @IBOutlet var collectionView: UICollectionView!
    
    private let inputTextField: UITextField = {
        let textField = UITextField()
        
        textField.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.9)
        
        textField.textAlignment = NSTextAlignment.center
        textField.font = UIFont(name: "Avenir-Medium", size: 20)
        textField.textColor = .darkGray
        
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 10
        
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    internal let continueButton: UIButton = {
        let button = UIButton()
        
        let buttonTitle = NSMutableAttributedString(string: "Continue", attributes:
            [NSAttributedStringKey.font: UIFont(name: "Avenir-Medium", size: 20)!,
             NSAttributedStringKey.foregroundColor: UIColor.darkGray]
        )
        
        button.backgroundColor = .white
        button.layer.cornerRadius = 25.0
        
        button.setAttributedTitle(buttonTitle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(continueButton_TouchUpInside), for: .touchUpInside)
        
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        
        let buttonTitle = NSMutableAttributedString(string: "Back", attributes:
            [NSAttributedStringKey.font: UIFont(name: "Avenir-Medium", size: 20)!,
             NSAttributedStringKey.foregroundColor: UIColor.darkGray]
        )
        
        let highlightedTitle = NSMutableAttributedString(string: "Back", attributes:
            [NSAttributedStringKey.font : UIFont(name: "Avenir-Medium", size: 20)!,
             NSAttributedStringKey.foregroundColor : UIColor.darkGray.withAlphaComponent(0.25)]
        )
        
        button.setAttributedTitle(buttonTitle, for: .normal)
        button.setAttributedTitle(highlightedTitle, for: .highlighted)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        
        button.addTarget(self, action: #selector(backButton_TouchUpInside), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = forms.count
        
        pc.currentPageIndicatorTintColor = .white
        pc.pageIndicatorTintColor = .gray
        
        pc.translatesAutoresizingMaskIntoConstraints = false
        
        return pc
    }()
    
// Main View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .mainBlue
        
        setupLayout()
        setupCollectionView()
        setupTextView()
        //setupKeyboardObservers()
    }
    
// Collection View Protocols
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! SignUpCell
        
        let form = forms[indexPath.item]
        cell.form = form
        
        return cell
    }
    
// View Setup
    private func setupLayout() {
        view.addSubview(cancelButton)
        
        cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        view.addSubview(inputTextField)
        
        inputTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        inputTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        inputTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputTextField.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -25).isActive = true
        
        view.addSubview(continueButton)
        
        continueButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        continueButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
        continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        continueButton.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 25).isActive = true
        
        view.addSubview(pageControl)
        
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        
        view.addSubview(backButton)
        
        backButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backButton.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -15).isActive = true
    }
    
    private func setupCollectionView() {
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SignUpCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.isPagingEnabled = true
        collectionView.keyboardDismissMode = .onDrag
        collectionView.backgroundColor = .clear
        
    }
    
    private func setupTextView() {
        
        inputTextField.delegate = self
        let doneButtonToolBar = UIToolbar.init()
        doneButtonToolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(doneButton_TouchUpInside))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        doneButtonToolBar.items = [flexibleSpace, doneButton]
        inputTextField.inputAccessoryView = doneButtonToolBar
        
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
// Button Targets
    @objc private func cancelButton_TouchUpInside() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func doneButton_TouchUpInside() {
        view.endEditing(true)
    }
    
    @objc private func continueButton_TouchUpInside() {
        let currentIndex = pageControl.currentPage
        
        switch currentIndex {
        case 0:
            username = inputTextField.text! as String
        case 1:
            password = inputTextField.text! as String
        case 2:
            confirmPassword = inputTextField.text! as String
            if (password != confirmPassword) {
                
                let alert = UIAlertController(title: "Passwords Do Not Match", message: "Please re-enter the same password.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                return
            }
        case 3:
            phoneNumber = Int(inputTextField.text!)
            signUpUser()
        default: break
        }
        
        let nextIndex = min(currentIndex + 1, forms.count - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        
        inputTextField.text = ""
        backButton.isHidden = false
        
        switchInputMode(index: nextIndex)
        
        pageControl.currentPage = nextIndex
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc private func backButton_TouchUpInside() {
        
        let prevIndex = max(pageControl.currentPage - 1, 0)
        let indexPath = IndexPath(item: prevIndex, section: 0)
        
        inputTextField.text = ""
        
        if (prevIndex == 0) {
            backButton.isHidden = true
            recoverEmailInput()
        }
        
        switchInputMode(index: prevIndex)
        
        pageControl.currentPage = prevIndex
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    private func signUpUser() {
        user.username = username
        user.password = password
        user.email = username
        user["phoneNumber"] = phoneNumber
        
        user.signUpInBackground { (success, error) in
            
            if error != nil {
                
                let alert = UIAlertController(title: "Error", message: "Parse Server: \(error!.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                
                let storyboard = UIStoryboard(name: "PreOnboarding", bundle: nil)
                let preOnboardingViewController = storyboard.instantiateInitialViewController()!
                self.present(preOnboardingViewController, animated: true, completion: nil)
                
            }
        }
    }
    
    private func recoverEmailInput() {
        if (!username.isEmpty) {
            inputTextField.text = username
        }
    }
    
    private func switchInputMode(index: Int) {
        switch index {
        case 0:
            inputTextField.keyboardType = .emailAddress
            inputTextField.isSecureTextEntry = false
        case 1:
            inputTextField.keyboardType = .default
            inputTextField.isSecureTextEntry = true
        case 2:
            inputTextField.keyboardType = .default
            inputTextField.isSecureTextEntry = true
        case 3:
            inputTextField.keyboardType = .phonePad
            inputTextField.isSecureTextEntry = false
        default: break
        }
    }
}

// TextView Protocols
extension SignUpStepsViewController: UITextFieldDelegate {
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// Keyboard Protocols
extension SignUpStepsViewController {
    
    @objc func keyboardDidShow(_ notification: Notification) {
        
        if let info = notification.userInfo {
            
            if let kbSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size {
                
                let deltaY = continueButton.frame.maxY - (view.frame.height - kbSize.height)
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.frame = CGRect(x: 0, y: -deltaY, width: self.view.frame.width, height: self.view.frame.height)
                }, completion: nil)
                
            }
        }
        
    }
    
    @objc func keyboardDidHide(_ notification: Notification) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
        
    }
}
