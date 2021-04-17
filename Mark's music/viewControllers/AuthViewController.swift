//
//  AuthViewController.swift
//  Mark's music
//
//  Created by Кирилл Любарских  on 11.04.2021.
//

import UIKit

class AuthViewController: UIViewController {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        activityIndicator.isHidden = true
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    deinit {
        print("bye")
    }
    @IBAction func authButton(_ sender: UIButton) {

        
        let netword = AuthorizationInApp()
        guard let (userName, userPassword) = normalizeTextFieldContent() else {
            present(showAlert(title: "Ошибка", message: "Что-то пошло не так"),
                    animated: true,
                    completion: nil)
            return
        }
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        self.loginButtonOutlet.isHidden = true
        netword.getTocken(username: userName, password: userPassword) { (data) in
            
            let decodeClass = DecodeRequests()
            decodeClass.decodeAuth(data: data) { (response) in
                switch response.status {
                    case "error":
                        guard let desc = response.errorDesc else {return}
                        switch desc {
                        case "auth_hash_incorrect":
                            DispatchQueue.main.async {
                                self.present(showAlert(title: "Ошибка авторизации", message: "Пароль введен неверно"),
                                             animated: true,
                                             completion: nil)
                            }
                            
                        case "auth_user_not_found":
                            DispatchQueue.main.async {
                                self.present(showAlert(title: "Данный пользователь не обнаружен", message: ""),
                                             animated: true,
                                             completion: nil)
                            }
                            
                        default:
                            return
                        }
                    case "successfully":
                        let userDef = saveUserDefaults()
                        userDef.saveInUserDefaults(token: response.token!, userName: userName)
                        DispatchQueue.main.async {
                            let vc = self.storyboard?.instantiateViewController(identifier: "mainView")
                            
                            self.present(vc!, animated: true, completion: nil)
                        }
                        
                    default:
                        return
                    }
            }
            DispatchQueue.main.async {
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                self.loginButtonOutlet.isHidden = false
            }
            
        }
        
        
    }
    
    
    func normalizeTextFieldContent() -> (String, String)? {
        guard let userName = loginTextField.text else {return nil}
        guard let userPassword = passwordTextField.text else {return nil}
        
        
        guard !userName.isEmpty, !userPassword.isEmpty  else {
            present(showAlert(title: "Ошибка", message: "Нельзя оставлять текстовые поля пустыми"), animated: true)
            return nil
        }
        
        let userNameTrimming = userName.trimmingCharacters(in: .whitespaces)
        let userPasswordTrimming = userPassword.trimmingCharacters(in: .whitespaces)
        
        return (userNameTrimming, userPasswordTrimming)
        
    }
    
    
    
}
func showAlert(title: String, message: String) -> UIAlertController{
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let actionOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alert.addAction(actionOK)
    return alert
}

extension AuthViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
}
