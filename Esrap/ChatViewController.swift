//
//  ChatViewController.swift
//  Esrap
//
//  Created by Amie Kweon on 4/30/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var submitButton: UIButton!

    @IBOutlet weak var messagesTableView: UITableView!

    var currentSession: PFSession?
    var messages: [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

/*
        let user = PFSession.getCurrentSessionInBackgroundWithBlock { (session: PFSession?, error: NSError?) -> Void in
            currentSession = session
        }
*/

        messagesTableView.dataSource = self


        // Do any additional setup after loading the view.
        refresh()

        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "refresh", userInfo: nil, repeats: true)

    }
    @IBOutlet weak var messageTableVie: UITableView!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onSubmit(sender: AnyObject) {
        var message = PFObject(className: "Message")
        message["text"] = messageField.text
        message["user"] = PFUser.currentUser()
        
        message.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                println("Message is saved")
                self.messageField.text = ""
                self.refresh()
            }

        }
    }

    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        onSubmit(textField)
        return true
    }

    func refresh() {
        println("refreshed")
        let query = PFQuery(className: "Message")
        query.includeKey("user")
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            if (error == nil) {
                if let objects = objects as? [PFObject] {
                    self.messages = objects
                    self.messagesTableView.reloadData()
                }
            } else {
                println(error!.userInfo!)
            }
        }

    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let messages = messages {
            return messages.count
        }
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MessageCell", forIndexPath: indexPath) as? MessageCell
        if let cell = cell {
            var message = self.messages?[indexPath.row]
            if let message = message {
                var user = message["user"] as? PFObject
                var username = ""
                if user == nil {
                    username = "unknown"
                } else {
                    username = user!["username"] as! String
                }
                var content = message["text"] as? String

                cell.messageLabel.text = username + ": " + content!
            }
        }
        return cell!
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
