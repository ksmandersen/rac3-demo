//
//  CheatSheet.swift
//  Rac3
//
//  Created by Kristian Andersen on 18/06/15.
//  Copyright (c) 2015 KristianCo. All rights reserved.
//

import Foundation
import ReactiveCocoa

func createSignal() -> Signal<String, NoError> {
    var count = 0
    return Signal { sink in
        NSTimer.schedule(repeatInterval: 1.0) { timer in
            sendNext(sink, "Tick #\(count++)")
        }
        
        return nil
    }
}

func test() {
    let signal = createSignal()
    signal.observe(next: { println($0) })
    
    let upperMapping: (Signal<String, NoError>) -> (Signal<String, NoError>) = map {
        value in
        return value.uppercaseString
    }
    
    let upperSignal = upperMapping(signal)
    
    upperSignal.observe(SinkOf { event in
        switch event {
            case .Next(let data): println(data.value)
            default: break
        }
    })
    
    signal
        |> map { $0.uppercaseString }
        |> observe(next: { println($0) })
}

extension NSTimer {
    /**
    Creates and schedules a one-time `NSTimer` instance.
    
    :param: delay The delay before execution.
    :param: handler A closure to execute after `delay`.
    
    :returns: The newly-created `NSTimer` instance.
    */
    class func schedule(#delay: NSTimeInterval, handler: NSTimer! -> Void) -> NSTimer {
        let fireDate = delay + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, 0, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes)
        return timer
    }
    
    /**
    Creates and schedules a repeating `NSTimer` instance.
    
    :param: repeatInterval The interval between each execution of `handler`. Note that individual calls may be delayed; subsequent calls to `handler` will be based on the time the `NSTimer` was created.
    :param: handler A closure to execute after `delay`.
    
    :returns: The newly-created `NSTimer` instance.
    */
    class func schedule(repeatInterval interval: NSTimeInterval, handler: NSTimer! -> Void) -> NSTimer {
        let fireDate = interval + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, interval, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes)
        return timer
    }
}
