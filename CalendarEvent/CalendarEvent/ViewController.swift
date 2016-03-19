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
        var success = false
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        do {
            try eventStore.saveEvent(event, span: .ThisEvent, commit: true)
            savedEventId = event.eventIdentifier
            success = true
            
        } catch {
            print("Could not save Event")
        }
        
        let message = (success) ? "Event added successfully to calendar" : "Failed to add event to calendar"
        let alertView = UIAlertView(title: "", message: message, delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "Dismiss")
        alertView.show()

        
    }
    
    func deleteEvent(eventStore: EKEventStore, eventId: String) {
        
        let eventToRemove = eventStore.eventWithIdentifier(eventId)
        if eventToRemove != nil {
            do {
                try eventStore.removeEvent(eventToRemove!, span: .ThisEvent)
            } catch {
                print("Could not delete Event")
            }
        }
        
        
    }
    
    
    @IBAction func deleteEventFromCalendar(sender: AnyObject) {
        
        let eventStore = EKEventStore()
        if(EKEventStore.authorizationStatusForEntityType(.Event) == EKAuthorizationStatus.Authorized) {
            deleteEvent(eventStore, eventId: savedEventId)
            
        }
    }
    
    
    
    
    @IBAction func addEventToCalendar(sender: AnyObject) {
        
        let eventStore = EKEventStore()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        dateFormatter.timeZone = NSTimeZone.systemTimeZone()
        
        let startDate = dateFormatter.dateFromString("2016-05-13 1:30:00 UTC")!
        let endDate = startDate.dateByAddingTimeInterval(60*60)
        
        //print("Current timezone: "
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

