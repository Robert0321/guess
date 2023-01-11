//
//  GuessNumberViewController.swift
//  guess
//
//  Created by Robert on 6/1/23.
//
import UIKit

class GuessNumberViewController: UIViewController {
    
    var randomNumber: Int = 0
    var life: Int = 5
    var rangeMax: Int = 99
    var rangeMin: Int = 1
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet var moonImageViews: [UIImageView]!
    @IBOutlet weak var goButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // goButton樣式設定
//        goButton.clipsToBounds = true
//        goButton.layer.cornerRadius = goButton.frame.width/2
        
        //指定數字鍵盤
        inputTextField.keyboardType = .numberPad
        //限制TextField輸入字串元數協定
        inputTextField.delegate = self
        //點選畫面任一處關閉小鍵盤
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self,action: #selector(GuessNumberViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        
        startNewGame()
    }
    // 點選畫面任一處關閉小鍵盤
    @objc func didTapView() {
        self.view.endEditing(true)
    }
    
    @IBAction func goButtonPressed(_ sender: Any) {
        if let goButtonTitle = goButton.title(for: .normal){
            if goButtonTitle == "Go"{
                checkNumber()
            }else {
                startNewGame()
            }
        }
        
    }
    
    func checkNumber() {
        if let inputText = inputTextField.text {
            if let number = Int(inputText) {
                if number == randomNumber {
                    messageLabel.text = "You're right!"
                    gameOver()
                }else {
                    moonImageViews[life].isHidden = true
                    life -= 1
                    if number > randomNumber {
                        rangeMax = number
                        messageLabel.text = "Too high! (\(rangeMin)~\(rangeMax)"
                    }else {
                        rangeMin = number
                        messageLabel.text = "Too low. (\(rangeMin)~\(rangeMax)"
                    }
                    inputTextField.text = ""
                    if life < 0 {
                        messageLabel.text = "Game over. The number is \(randomNumber)."
                        gameOver()
                    }
                }
            }
        }
    }
    
    func gameOver(){
        
        goButton.setTitle("Try again", for: .normal)
//        goButtonWidth.constant = 200
        inputTextField.isEnabled = false
    }
    
    func startNewGame(){
        goButton.setTitle("Go", for: .normal)
//        goButtonWidth.constant = 60
        inputTextField.text = ""
        inputTextField.isEnabled = true
        messageLabel.text = "Guess a number between 1~99"

        
        randomNumber = Int.random(in: 1...99)
        rangeMin = 1
        rangeMax = 99
    
        life = 5
        for moonImageView in moonImageViews {
            moonImageView.isHidden = false
        }
    }
}
extension GuessNumberViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        // text為目前textField的字串，string為使用者輸入字串，newLength為使用者按下數字後整個字串新的長度
        let newLength = text.count + string.count
        // 當newLength不超過二字元時，回傳true，更新textField字串
        if newLength <= 2 {
            return true
            // 反之若是newLength超過二字元時，則回傳false，無論使用者按了什麼按鈕都不會更新textField
        } else {
            return false
        }
    }
}
