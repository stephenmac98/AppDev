//
//  SecondViewController.swift
//  TopSecret
//
//  Created by Stephen Blackwell on 3/10/20.
//  Copyright © 2020 Stephen Blackwell. All rights reserved.
//

import UIKit
import AVFoundation

class SecondViewController: UIViewController {
    

    let systemSoundID: SystemSoundID = 1321
    
    
    var answerMessage = "        "

    @IBOutlet weak var answer: UILabel!
    
    @IBOutlet weak var c1: UIImageView!
    @IBOutlet weak var c2: UIImageView!
    @IBOutlet weak var c3: UIImageView!
    @IBOutlet weak var c4: UIImageView!
    
    var colorAnswerSet: [UIColor] = []
    var colorViews: [UIImageView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answer.text = answerMessage
        colorViews = [c1, c2, c3, c4]
        // Do any additional setup after loading the view.
        setColors()
        AudioServicesPlaySystemSound(systemSoundID)
    }
    
    func setColors() {
        if colorAnswerSet.count > 0 {
            for i in 0..<colorAnswerSet.count{
                colorViews[i].backgroundColor = colorAnswerSet[i]
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
