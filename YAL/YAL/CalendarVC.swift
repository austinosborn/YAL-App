//
//  CalendarVC.swift
//  YAL
//
//  Created by Austin on 11/6/18.
//  Copyright © 2018 inTENsity. All rights reserved.
//

import Foundation
import UIKit
import EventKit

struct Event : Codable {
    let title : String?
    let description : String?
    let time : Double?
    let address : String?
}

class CalendarVC : UITableViewController {
    
    var sourceURL : String = "https://pastebin.com/raw/ddADXECj"
    var events : [Event] = []
    
    
    override func viewDidLoad() {
        self.navigationItem.title = "Organization Calendar"
        let url = URL(string: sourceURL)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        URLSession.shared.dataTask(with: url!) { data, _, _ in
            guard let data = data else { return }
            do {
                self.events = try JSONDecoder().decode([Event].self, from: data)
            }
            catch let jsonError {
                print("Unable to parse officers: Error \(jsonError.localizedDescription)")
                
            }
            DispatchQueue.main.sync {
                self.tableView.reloadData()
            }
        }.resume()
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        
        let event = events[indexPath.row]
        
        cell.textLabel?.text = event.title
        
        var subtitle = ""
        

        if let time = event.time {
            let date = Date(timeIntervalSince1970: Double(time))
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "EEEE, MMM d, yyyy HH:mm a"
            subtitle.append("Time: \(dateFormatter.string(from: date))\n")
        }
        if let location = event.address {
            subtitle.append("Location: \(location)\n")
        }
        
        if let description = event.description {
            subtitle.append("Description: \(description)\n")
        }
        
        cell.detailTextLabel?.text = subtitle
        cell.detailTextLabel?.numberOfLines = 0
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let alert = UIAlertController(title: "Add event to calendar", message: "Would you like to an this event to your calendar?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .default) { (action) in
            let eventStore = EKEventStore()
            switch EKEventStore.authorizationStatus(for: EKEntityType.event) {
            case .authorized:
                self.addEvent(event: self.events[indexPath.row])
            default:
                eventStore.requestAccess(to: EKEntityType.event, completion: { (allowed, error) in
                    if allowed {
                        self.addEvent(event: self.events[indexPath.row])
                    }
                })
            }
        }
        let no = UIAlertAction(title: "No", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(yes)
        alert.addAction(no)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func addEvent(event: Event) {
        let store = EKEventStore()
        var calendarEvent = EKEvent(eventStore: store)
        calendarEvent.title = event.title
        guard let time = event.time else { return }
        calendarEvent.startDate = Date(timeIntervalSince1970: time)
        calendarEvent.endDate = calendarEvent.startDate.addingTimeInterval(60 * 60 * 3)
        calendarEvent.calendar = store.defaultCalendarForNewEvents
        do {
            try store.save(calendarEvent, span: .thisEvent)
        } catch { error
            print("Error adding event to calendar: \(error.localizedDescription)")
            
        }
    }
    
    
}
