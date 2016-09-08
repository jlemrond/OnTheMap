//
//  Utilities.swift
//  On The Map
//
//  Created by Jason Lemrond on 9/4/16.
//  Copyright © 2016 Jason Lemrond. All rights reserved.
//

import Foundation


func performOnMain(action: () -> Void) {

    dispatch_async(GlobalQueue.main) {
        action()
    }

}

func performHighPriority(action action: () -> Void) {

    dispatch_async(GlobalQueue.interactive) {
        action()
    }
    
}

func performStandardPriority(action action: () -> Void) {

    dispatch_async(GlobalQueue.initiated) {
        action()
    }

}

func performInBackground(action: () -> Void) {

    dispatch_async(GlobalQueue.utility) {
        action()
    }
    
}

func performLowPriority(action action: () -> Void) {

    dispatch_async(GlobalQueue.utility) {
        action()
    }

}



struct GlobalQueue {
    static var main: dispatch_queue_t {
        return dispatch_get_main_queue()
    }

    static var interactive: dispatch_queue_t {
        return dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.rawValue), 0)
    }

    static var initiated: dispatch_queue_t {
        return dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)
    }

    static var utility: dispatch_queue_t {
        return dispatch_get_global_queue(Int(QOS_CLASS_UTILITY.rawValue), 0)
    }

    static var background: dispatch_queue_t {
        return dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.rawValue), 0)
    }

    static var defaultQueue: dispatch_queue_t {
        return dispatch_get_global_queue(Int(QOS_CLASS_DEFAULT.rawValue), 0)
    }
}
