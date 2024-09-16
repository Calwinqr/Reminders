//
//  ViewController.swift
//  Reminders
//
//  Created by Calwin on 10/09/24.
//


//Add code data to save the reminders.
//Icon
import UserNotifications
import UIKit
import CoreData

class ViewController: UIViewController {
    
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var reminders=[Reminder]()

    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate=self
        table.dataSource=self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success{
                print("success")
            }
            else if let e=error{
                print(e)
            }
        }
        load()
        table.reloadData()
    }

    @IBAction func AddBtnPressed(_ sender: UIBarButtonItem) {
        let addVC=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddReminderViewController") as! AddReminderViewController
        addVC.title="New Reminder"
        addVC.navigationItem.largeTitleDisplayMode = .never
        addVC.completion={title, body, date in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
//                let newReminder=Reminder(title: title, identifier: "id_\(title)", date: date)
                let newReminder=Reminder(context: self.context)
                newReminder.title=title
                newReminder.date=date
                newReminder.body=body
                self.reminders.append(newReminder)
                self.table.reloadData()
                self.save()
                
                //Notification-
                let content=UNMutableNotificationContent()
                content.title=title
                content.sound = .default
                content.body=body
                
                let trigger=UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date), repeats: false)
                let request=UNNotificationRequest(identifier: "id_\(title)", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request) { error in
                    if error != nil{
                        print(error!)
                    }
                }
            }
        }
        navigationController?.pushViewController(addVC, animated: true)
    }
    
//    struct Reminder{
//        var title: String
//        var identifier: String
//        var date: Date
//    }
    
    func save(){
        do{
            try context.save()
        }
        catch{
            print(error)
        }
    }
    
    func load(){
        let request: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        do{
            reminders = try context.fetch(request)
        }
        catch{
            print(error)
        }
    }
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text=reminders[indexPath.row].title
        let formater=DateFormatter()
        formater.dateFormat="dd MMM YYYY"
        cell.detailTextLabel?.text=formater.string(from:reminders[indexPath.row].date!)
        return cell
    }
    
    
}
