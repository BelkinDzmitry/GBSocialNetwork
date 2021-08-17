//
//  LoginFormController.swift
//  GBSocialNetwork
//
//  Created by Belkin on 08.08.2021.
//

import UIKit

final class LoginFormController: UIViewController {
    
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var titleImageView: UIImageView!
    @IBOutlet private var loginTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Жест тапа по скролу
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView?.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Подписываемся на два уведомления: одно приходит при появлении клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        // Второе — когда она пропадает
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "loginSegue" {
            let loginValue = loginTextField.text
            let passwordValue = passwordTextField.text
            
            if loginValue == "" && passwordValue == "" {
                print("Access ok")
                return true
            } else {
                print("Wrong login or password")
                showAlert(title: "Error", message: "Wrong login or password")
                return false
            }
        }
        return true
    }

    
    /*
     метод работы с контроллером, на который перейдём в будущем (изменение, запрос
    информации)
    */
    
//        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//            guard segue.identifier == "registerSegue" else { return }
//            guard  let destinationController = segue.destination as? UIViewController else { return }
//            destinationController.title = "123" //окрашивает фон в синий
//            print(destinationController.title!)
//             destinationController.tabBar.items?[1].badgeValue = "1" //добавляет один бейдж
//        }
    
    @IBAction private func loginButtonPressed(_ sender: UIButton) {
        
    }

    // создание алертов
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Ok",
                                        style: .cancel) { [weak self] _ in
            guard let self = self else { return }
            self.loginTextField.text = ""
            self.passwordTextField.text = ""
        }
       
        alertController.addAction(closeAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }
    
    // Когда клавиатура появляется
    @objc func keyboardWasShown (notification: Notification) {
        
        //Получаем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        //Добавляем отступ внизу UIScrollView, равный размеру клавиатуры
        self.scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    //Когда клавиатура исчезает
    @objc func keyboardWillBeHidden(notification: Notification) {
        //Устанавливаем отступ внизу UIScrollView, равный 0
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
        scrollView?.contentInset = contentInsets
    }
    
}
