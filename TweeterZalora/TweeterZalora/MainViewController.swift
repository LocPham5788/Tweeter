//
//  ViewController.swift
//  TweeterZalora
//
//  Created by Pham Tan Loc on 8/24/17.
//  Copyright © 2017 Pham Tan Loc. All rights reserved.
//

import UIKit
import Foundation

class MainViewController: UIViewController, UITextViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var txtInputMessage: UITextView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var vwDisplayedMessage: UIView!
    @IBOutlet weak var txtMessageDisplay: UITextView!
    
    @IBOutlet weak var inputMessageView: UIView!
    @IBOutlet weak var mLabelCharsCount: UILabel!
    @IBOutlet weak var dissmissableView: UIView!
    
    // MARK: Constains
    
    @IBOutlet weak var heightOfLabelCharsCount: NSLayoutConstraint!
    @IBOutlet weak var heightOfSendButton: NSLayoutConstraint!
    @IBOutlet weak var heightOfInputView: NSLayoutConstraint!
    @IBOutlet weak var marginBottomOfInputView: NSLayoutConstraint!
    
    // MARK: Propertises
    
    let tweeterModel = TweeterModel.shared
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup notification center
        setupNotification()
        setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Setup
    
    private func setupNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillShow),
                                       name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillHide),
                                       name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func setupUI() {
        // For input message
        txtInputMessage.delegate = self
        txtInputMessage.layer.borderWidth = 1.0
        txtInputMessage.layer.cornerRadius = 4.0
        
        btnSend.layer.cornerRadius = 4.0
        
        // Add gesture to dismiss view
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(sender:)))
        singleTap.delegate = self
        dissmissableView.addGestureRecognizer(singleTap)
    }
    
    private func refreshUI() {
        let charsCount = txtInputMessage.text.characters.count
        if charsCount > 0 {
            btnSend.isEnabled = true
            // Display number of chars
            mLabelCharsCount.text = "Chars: \(charsCount)"
            // Show chars count label
            mLabelCharsCount.isHidden = false
        } else {
            // Disable send button
            btnSend.isEnabled = false
            // Show chars count label
            mLabelCharsCount.isHidden = true
        }
    }
    
    func dismissKeyboard(sender: UITapGestureRecognizer? = nil) {
        self.txtInputMessage.endEditing(true)
        self.dissmissableView.isHidden = true
    }
    
    // MARK: UITextViewDelegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.dissmissableView.isHidden = false
        
        self.refreshUI()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        // Get textview contentsize
        var contentSize = textView.contentSize
        let charsCount = textView.text.characters.count
        // Refresh UI
        self.refreshUI()
        if charsCount > 0 {
            heightOfLabelCharsCount.constant = 10
            // Change height of SEND button
            heightOfSendButton.constant = contentSize.height - 10 > 44 ? 44 : contentSize.height - 10
        } else {
            heightOfLabelCharsCount.constant = 0
            // Increase height of SEND button
            heightOfSendButton.constant = 44
        }
        // Change height animation if needed
        if contentSize.height < 44 {
            contentSize.height = 44
        }
        // Set maxium of height is 300
        if contentSize.height < 300 {
            UIView.animate(withDuration: 0.1, animations: {
                // Height of input view = Content size + Margin top/bottom
                self.heightOfInputView.constant = contentSize.height + 16
            })
        }
        
    }
    
    // MARK: Show/Hide Keyboard Notification
    
    internal func keyboardWillShow(aNotification :NSNotification) {
        let userInfo: NSDictionary = aNotification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height + 1
        let duration = userInfo.value(forKey: UIKeyboardAnimationDurationUserInfoKey) as! Double
        
        UIView.animate(withDuration: duration, animations: {
            self.marginBottomOfInputView.constant = keyboardHeight
        })
    }
    
    internal func keyboardWillHide(aNotification :NSNotification) {
        let userInfo: NSDictionary = aNotification.userInfo! as NSDictionary
        let duration = userInfo.value(forKey: UIKeyboardAnimationDurationUserInfoKey) as! Double
        UIView.animate(withDuration: duration, animations: {
            self.marginBottomOfInputView.constant = 0
        })
    }
    
    // MARK: IBAction
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        self.txtInputMessage.endEditing(true)
        self.dissmissableView.isHidden = true
        // For nil or empty message
        guard let inputMessage = self.txtInputMessage.text else {
            ShowAlertManager.showErrorMessageDialog(presentedVC: self, message: "Your input message is empty. Please try again")
            return
        }
        // For all spaces message
        if inputMessage.trimmingCharacters(in: .whitespaces).isEmpty {
            ShowAlertManager.showErrorMessageDialog(presentedVC: self, message: "Your input message is invalid. Please try again")
        }
        
        // For a span of non-whitespace characters longer than 50 characters
        if tweeterModel.checkIfMessageIsNonWhiteSpace(message: inputMessage) {
            ShowAlertManager.showErrorMessageDialog(presentedVC: self, message: "Your input message can't have any spans of non-whitespace characters longer than 50 characters. Please try again")
        }
        
        // For valid input
        // Split message into seperate parts
        let messageParts = tweeterModel.splitMessageToParts(message: inputMessage, limit: 50)
        if messageParts.count == 0 {
            // Splitted FAILED
            ShowAlertManager.showErrorMessageDialog(presentedVC: self, message: "Your input message is invalid. Please try again")
        }
        
        // For display output message
        var displayMessage = ""
        if messageParts.count > 1 {
            for i in 0 ..< messageParts.count {
                if i < messageParts.count - 1 {
                    displayMessage += "\(i + 1)/\(messageParts.count) \(messageParts[i])\n"
                }
                else {
                    displayMessage += "\(i + 1)/\(messageParts.count) \(messageParts[i])"
                }
            }
        } else {
            displayMessage += "\(messageParts[0])"
        }
        
        self.txtMessageDisplay.text = displayMessage
        self.refreshUI()
    }
    
}

