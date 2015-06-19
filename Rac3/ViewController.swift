//
//  ViewController.swift
//  Rac3
//
//  Created by Kristian Andersen on 18/06/15.
//  Copyright (c) 2015 KristianCo. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ViewController: UIViewController {
    
    func createSignal() -> Signal<String, NoError> {
        var count = 0
        return Signal { sink in
            NSTimer.schedule(repeatInterval: 1.0) { timer in
                sendNext(sink, "tick \(count++)")
            }
            
            return nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let signal = self.createSignal()
        signal.observe(next: { println($0) })
        
        let upperMapping: (Signal<String, NoError>) -> (Signal<String, NoError>) = map { value in
            return value.uppercaseString
        }
        
//        signal
//            |> upperMapping
//            |> observe(next: { println($0) }
        
        let upperSignal = upperMapping(signal)
        upperSignal.observe(SinkOf { event in
            switch event {
            case .Next(let box): println(box.value)
            case .Error(let box): println(box.value)
                case .
            default: break
            }
        })
    }
}