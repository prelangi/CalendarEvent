//
//  ViewController.swift
//  CalendarEvent
//
//  Created by Prasanthi Relangi on 3/18/16.
//  Copyright © 2016 prasanthi. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController {

    var savedEventId : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func createEvent(eventStore: EKEventStore, title: String, startDate: NSDate, endDate: NSDate) {
        
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        do {
            try eventStore.saveEvent(event, span: .ThisEvent, commit: true)
            savedEventId = event.eventIdentifier
        } catch {
            print("Could not save Event")
        }
        
    }

    @IBAction func addEventToCalendar(sender: AnyObject) {
        
        let eventStore = EKEventStore()
        
        let startDate = NSDate()
        let endDate = startDate.dateByAddingTimeInterval(60*60)
        
        if(EKEventStore.authorizationStatusForEntityType(.Event) != EKAuthorizationStatus.Authorized) {
            eventStore.requestAccessToEntityType(.Event, completion: {
                (granted:Bool, error: NSError?) -> Void in
                    self.createEvent(eventStore,title: "Custom Event", startDate: startDate, endDate: endDate)

            })
        }
        else {
            createEvent(eventStore,title: "Custom Event", startDate: startDate, endDate: endDate)
        }
        
    }

}

