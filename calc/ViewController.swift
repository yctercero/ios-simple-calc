//
//  ViewController.swift
//  calc
//
//  Created by Yara Tercero on 3/10/16.
//  Copyright © 2016 Yara Tercero. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtraction = "-"
        case Addition = "+"
        case Clear = "C"
        case PosNeg = "+/-"
        case Dot = "."
        case Empty = "Empty"
    }
    
    @IBOutlet weak var outputLabel: UILabel!
    
    var btnSound: AVAudioPlayer!
    
    var runningNumber = ""
    var leftValStr = ""
    var rightValStr = ""
    var currentOperation: Operation = Operation.Empty
    var result = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "btn 2", ofType: "wav")
        
        let soundURL = URL(fileURLWithPath: path!)
        
        do {
          try btnSound = AVAudioPlayer(contentsOf: soundURL)
            btnSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        
    }

    @IBAction func numberPressed(_ btn: UIButton!) {
        playSound()
        
        runningNumber += "\(btn.tag)"
        
        outputLabel.text = runningNumber
    }
    
    @IBAction func onDividePressed(_ sender: AnyObject) {
        processOperation(Operation.Divide)
    }
    
    @IBAction func onMultiplyPressed(_ sender: AnyObject) {
        processOperation(Operation.Multiply)
    }
    
    @IBAction func onSubtractPressed(_ sender: AnyObject) {
        processOperation(Operation.Subtraction)
    }
    
    @IBAction func onAdditionPressed(_ sender: AnyObject) {
        processOperation(Operation.Addition)
    }
    
    @IBAction func onEqualPressed(_ sender: AnyObject) {
        processOperation(currentOperation)
    }
    
    @IBAction func onClearPressed(_ sender: AnyObject) {
        processUncommonButtons(Operation.Clear)
    }
    
    @IBAction func onPosNegPressed(_ sender: AnyObject) {
        processUncommonButtons(Operation.PosNeg)
    }
    
    @IBAction func onDotPressed(_ sender: AnyObject) {
        processUncommonButtons(Operation.Dot)
    }
    
    @IBOutlet var clearOutlet: UIButton!
    
    
    func processUncommonButtons(_ op: Operation) {
        playSound()
        
        if op == Operation.Clear {
            if clearOutlet.currentTitle == "C" {
                outputLabel.text = ""
                
                runningNumber = ""
                
                clearOutlet.setTitle("AC", for: UIControlState())
            } else if clearOutlet.currentTitle == "AC" {
                outputLabel.text = ""
                
                leftValStr = ""
                
                rightValStr = ""
                
                runningNumber = ""
                
                result = ""
                
                currentOperation = Operation.Empty
                
                clearOutlet.setTitle("C", for: UIControlState())
            }
        } else if op == Operation.PosNeg {
            let searchCharachter: Character = "-"
            if runningNumber.characters.contains(searchCharachter) {
                
                 runningNumber.remove(at: runningNumber.startIndex)
                
                outputLabel.text = runningNumber
                
            } else {
                runningNumber = "-" + runningNumber
                
                outputLabel.text = runningNumber
            }
        } else if op == Operation.Dot {
            let searchCharachter: Character = "."

            if !(runningNumber.characters.contains(searchCharachter)) {
                if runningNumber == "" {
                    runningNumber = runningNumber + "0."
                    
                    outputLabel.text = runningNumber
                } else {
                    runningNumber = runningNumber + "."
                    
                    outputLabel.text = runningNumber
                }
            } else if runningNumber.characters.contains(searchCharachter){
               
            }
        }
    }
    
    func processOperation(_ op: Operation) {
        playSound()
        
        if currentOperation != Operation.Empty {
            
            //User selected an operator, followed by a second operator without first entering a number
            if runningNumber != "" {
                rightValStr = runningNumber
                
                runningNumber = ""
                
                if currentOperation == Operation.Multiply {
                    result = "\(Double(leftValStr)! * Double(rightValStr)!)"
                } else if currentOperation == Operation.Divide {
                    result = "\(Double(leftValStr)! / Double(rightValStr)!)"
                } else if currentOperation == Operation.Subtraction {
                    result = "\(Double(leftValStr)! - Double(rightValStr)!)"
                } else if currentOperation == Operation.Addition {
                    result = "\(Double(leftValStr)! + Double(rightValStr)!)"
                }
            }
            
            
            
            leftValStr = result
            
            outputLabel.text = result
            
            currentOperation = op
            
        } else {
            //First time operator is pressed
            leftValStr = runningNumber
            
            runningNumber = ""
            
            currentOperation = op
        }
    }
    
    func playSound() {
        if btnSound.isPlaying {
            btnSound.stop()
        }
        
        btnSound.play()
    }

}

