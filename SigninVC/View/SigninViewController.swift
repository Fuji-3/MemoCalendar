//
//  SigninViewController.swift
//  MemoCalendar
//
//  Created by Fuji3 on 2023/07/23.
//

import UIKit
import FirebaseAuthUI
import FirebaseEmailAuthUI
import FirebaseAppCheck

class SigninViewController: UIViewController,FUIAuthDelegate {
    private  var userDefaults:UserDefaults!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    //新規登録
    @IBOutlet weak var addButton: UIButton!
    //ログイン
    @IBOutlet weak var loginButton: UIButton!
    
    //ログインButtonn
    @IBAction func LoginButton(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: emailTextField.text ?? "", password: passTextField.text ?? ""){ [self] result, error in
            if let error = error {
                switch error.localizedDescription {
                    case "The password is invalid or the user does not have a password.":
                        print("パスワードが間違っているか、入力してください")
                    case "The email address is badly formatted.":
                        print("メールアドレスが間違ってます")
                    case "There is no user record corresponding to this identifier. The user may have been deleted.":
                        print("該当するユーザーがありません")
                    default:
                        break
                }
            }else{
                if let user = result?.user{
                    print("ログインした: \(user.uid):\(user.email)")
                                        
                    userDefaults = UserDefaults.standard
                    userDefaults.set(user.email, forKey: "email")
                    //ここで遷移
                    let stroyboad:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = stroyboad.instantiateViewController(withIdentifier: "MainVC") as! ViewController
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen
                    self.present(nav, animated: true)
                }
            }
            
            
            
            
        }
    }
    @IBAction func AddButton(_ sender: UIButton) {
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        let providers:[FUIAuthProvider] = [
            FUIEmailAuth()
        ]
        let appCheckProider = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(appCheckProider)
        
            
        authUI?.providers = providers
        let authViewController = authUI?.authViewController()
        present(authViewController!, animated: true,completion:  nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /*if (userDefaults.string(forKey: "usiD") != nil) {
            print("ログイン済み2")
            let alert = UIAlertController(title: "", message: "ログイン済2", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default){ (aciton) in
                
            }
            let cansetAction = UIAlertAction(title: "戻る", style: .cancel){(cancel) in
                
            }
            alert.addAction(okAction)
            alert.addAction(cansetAction)
            present(alert, animated: true)
        }else{
            print("ログインしていない")
        }*/
    }
    
    //成功 or 失敗で呼ばれる
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if let user = user{
            // ユーザーがサインイン成功した場合の処理
            print("ユーザーがサインインしました。UID: \(user.uid)")
            let userDefaults = UserDefaults.standard
            userDefaults.register(defaults: [user.email.debugDescription :user.uid])
            

        }else{
            if let error = error {
                print("新規登録をキャンセルしました")
            }
        }
    }
    
    

}
