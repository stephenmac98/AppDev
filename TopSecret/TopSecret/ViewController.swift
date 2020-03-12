//
//  ViewController.swift
//  TopSecret
//
//  Created by Stephen Blackwell on 3/10/20.
//  Copyright © 2020 Stephen Blackwell. All rights reserved.
//

import UIKit
import AVFoundation

// create a sound ID, in this case its the tweet sound.

// to play sound
class ViewController: UIViewController {

    @IBOutlet weak var b1: UIButton!
    @IBOutlet weak var b2: UIButton!
    @IBOutlet weak var b3: UIButton!
    @IBOutlet weak var b4: UIButton!
    
    @IBOutlet weak var c1: UIImageView!
    @IBOutlet weak var c2: UIImageView!
    @IBOutlet weak var c3: UIImageView!
    @IBOutlet weak var c4: UIImageView!
    
    
    @IBOutlet weak var guessLabel: UILabel!
    
    @IBOutlet weak var colNumButton: UIButton!
    
    var uiColorArray: [UIColor] = [.blue, .red, .green, .yellow, .purple, .orange, .brown, .magenta, .systemIndigo]
    
    let systemSoundID: SystemSoundID = 1073

    
    var colorGuesses: [UIColor] = []
    var guesses: [Int] = []
    var code: [Int] = []
    var colorMap: [UIColor] = []
    var colorCode: [UIColor] = []
    
    var buttons: [UIButton] = []
    var colorViews: [UIImageView] = []
    
    var isColor = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Welcome to Stephen Blackwell's password guesses.\nThe color/number button will switch between the two options.\nWhen switching to color it will select four random colors from a set to be the colors used in that instance.\nThere will be a sound that plays when you press enter, representing whether your answer was correct.")
        buttons = [b1, b2, b3, b4]
        colorViews = [c1, c2, c3, c4]
        
        for i in 0..<buttons.count{
            let button = buttons[i]
            button.layer.borderWidth = 3.0
            button.layer.borderColor = UIColor.black.cgColor
        }
        
        resetNumbers()
        
        
    }
    
    
    //Button Functions
    
    //GUESS BUTTON PRESSED
    @IBAction func buttonPressed(_ sender: UIButton) {
        if !isColor{ //NUMBER MODE
            for i in 0..<buttons.count{
                if buttons[i] == sender{
                    guesses.append(i + 1)
                }
            }
            
            guessLabel.text = getStatus()
        }
        else{ //COLOR MODE
            for i in 0..<buttons.count{
                if buttons[i] == sender{
                    colorGuesses.append(colorMap[i])
                }
            }
            setColors()
        }
    }
    //Switch between color and number
    @IBAction func switchColNum(_ sender: UIButton) {
        if isColor{
            //IN NUMBER MODE
            resetNumbers()
            isColor = false
            colNumButton.setTitle("COLOR", for: .normal)
        }
        else {
            //IN COLOR MODE
            resetColors()
            isColor = true
            colNumButton.setTitle("NUMBER", for: .normal)
        }
    }
    
    
    //Number Functions
    
    //Get string for status
    func getStatus() -> String{
        var message = ""
        let stars = 4 - guesses.count
        if (stars>=0) {
            for item in guesses{
                message = message + String(item) + " "
            }
            for _ in 0..<stars{
                message = message + "* "
            }
        }
        else{
            for i in 0..<4{
                message = message + String(guesses[i]) + " "
            }
        }
        return String(message.dropLast())
    }
    //Set Number Code
    func setCode() {
        code = []
        for _ in 0..<4{
            code.append(Int.random(in: 1...4))
        }
        print(code)
    }
    //Reset the values for a numbers game
    func resetNumbers(){
        setCode()
        guesses = []
        guessLabel.text = getStatus()
        for item in colorViews{
            item.backgroundColor = .clear
        }
        for item in buttons{
            item.backgroundColor = .clear
            item.setTitleColor(.black, for: .normal)
        }
    }
    
    
    //Color Functions
    
    //Sets the 'color to button' map, and the solution key
    func setColorMap() {
        uiColorArray.shuffle()
        colorMap = []
        var answerString = "["
        for item in uiColorArray[0...3]{
            colorMap.append(item)
        }
        colorCode = []
        for _ in 0..<4{
            let i = Int.random(in: 0...3)
            answerString = answerString + String(i + 1) + ", "
            colorCode.append(colorMap[i])
        }
        print(answerString.dropLast().dropLast() + "]")
    }
    //Set button background colors and hide text
    func setButtonColors() {
        for i in 0..<4{
            let button = buttons[i]
            button.backgroundColor = colorMap[i]
            button.setTitleColor(.clear, for: .normal)
        }
    }
    //Set color views
    func setColors() {
        let guessCount = colorGuesses.count
        for i in 0..<4{
            if i < (guessCount){
                colorViews[i].backgroundColor = colorGuesses[i]
            }
            else{
                colorViews[i].backgroundColor = .lightGray
            }
        }
    }
    //reset the values for a letters game
    func resetColors() {
        colorGuesses = []
        setColorMap()
        setButtonColors()
        setColors()
        guessLabel.text = "       "
    }
    
    
    //Transition Functions
    override func shouldPerformSegue(withIdentifier identifier: String, sender:
    Any?) -> Bool {
        if !isColor{ //NUMBER MODE
            if guesses.count < 4{
                guesses = []
                guessLabel.text = getStatus()
                AudioServicesPlaySystemSound (systemSoundID)
                return false
            }
            for i in 0..<4{
                if code[i] != guesses[i]{
                    guesses = []
                    guessLabel.text = getStatus()
                    AudioServicesPlaySystemSound (systemSoundID)
                    return false
                }
            }
            return true
        }
        else{ //COLOR MODE
            if colorGuesses.count < 4{
                colorGuesses = []
                guessLabel.text = getStatus()
                for item in colorViews{
                    item.backgroundColor = .lightGray
                }
                return false
            }
            for i in 0..<4{
                if colorCode[i] != colorGuesses[i]{
                    colorGuesses = []
                    for item in colorViews{
                        item.backgroundColor = .lightGray
                    }
                    AudioServicesPlaySystemSound (systemSoundID)
                    return false
                }
            }
            return true
        }
    }
    
    //Reset on return from win page
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {
        if isColor{
            resetColors()
        }
        else{
            resetNumbers()
        }
        
    }
    
    //Pass success values to win page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is SecondViewController {
            var ans = " "
            if !isColor{
                for item in code{
                    ans = ans + String(item) + " "
                }
            }
            let vc = segue.destination as? SecondViewController
            vc?.answerMessage = String(ans)
            vc?.colorAnswerSet = colorCode
        }
    }
    
}

