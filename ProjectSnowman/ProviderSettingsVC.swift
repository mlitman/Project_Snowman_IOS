//
//  ProviderSettingsVC.swift
//  ProjectSnowman
//
//  Created by Michael Litman on 5/2/16.
//  Copyright © 2016 iLash. All rights reserved.
//

import UIKit
import Firebase

class ProviderSettingsVC: UIViewController
{
    @IBOutlet weak var updatedLabel: UILabel!
    @IBOutlet weak var errorTV: UITextView!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var street1TF: UITextField!
    @IBOutlet weak var street2TF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var stateTF: UITextField!
    @IBOutlet weak var zipTF: UITextField!
    @IBOutlet weak var nameOnBankAccountTF: UITextField!
    @IBOutlet weak var routingNumberTF: UITextField!
    @IBOutlet weak var accountNumberTF: UITextField!
    @IBOutlet weak var accountTypeSegments: UISegmentedControl!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        errorTV.hidden = true
        updatedLabel.alpha = 0.0
        
        //get current profile
        if(Core.userProfileDictionary != nil)
        {
            let up = Core.userProfileDictionary
            self.firstNameTF.text = up["first_name"]
            self.lastNameTF.text = up["last_name"]
            self.street1TF.text = up["street1"]
            self.street2TF.text = up["street2"]
            self.cityTF.text = up["city"]
            self.stateTF.text = up["state"]
            self.zipTF.text = up["zip"]
            self.nameOnBankAccountTF.text = up["name_on_bank_account"]
            self.routingNumberTF.text = up["routing_number"]
            self.accountNumberTF.text = up["account_number"]
            if(up["account_type"] == "company")
            {
                self.accountTypeSegments.selectedSegmentIndex = 1
            }
        }
        else
        {
            let ref = Core.fireBaseRef.childByAppendingPath("profile").childByAppendingPath(Core.fireBaseRef.authData.uid)
            ref.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                if(snapshot.value is NSNull)
                {
                    Core.userProfileDictionary = [String : String]()
                }
                else
                {
                    Core.userProfileDictionary = snapshot.value as! [String : String]
                    let up = Core.userProfileDictionary
                    self.firstNameTF.text = up["first_name"]
                    self.lastNameTF.text = up["last_name"]
                    self.street1TF.text = up["street1"]
                    self.street2TF.text = up["street2"]
                    self.cityTF.text = up["city"]
                    self.stateTF.text = up["state"]
                    self.zipTF.text = up["zip"]
                    self.nameOnBankAccountTF.text = up["name_on_bank_account"]
                    self.routingNumberTF.text = up["routing_number"]
                    self.accountNumberTF.text = up["account_number"]
                    if(up["account_type"] == "company")
                    {
                        self.accountTypeSegments.selectedSegmentIndex = 1
                    }
                }
            })
        }
    }

    func validateForm() -> Bool
    {
        var msg = ""
        if(firstNameTF.text == "")
        {
            msg = "You must enter a first name"
        }
        else if(lastNameTF.text == "")
        {
            msg = "You must enter a last name"
        }
        else if(street1TF.text == "")
        {
            msg = "You must enter a street"
        }
        else if(cityTF.text == "")
        {
            msg = "You must enter a city"
        }
        else if(stateTF.text == "")
        {
            msg = "You must enter a state"
        }
        else if(zipTF.text == "")
        {
            msg = "You must enter a zip"
        }
        else if(nameOnBankAccountTF.text == "")
        {
            msg = "You must the name as it appears on your bank account"
        }
        else if(accountNumberTF.text == "")
        {
            msg = "You must enter your bank account number to receive payouts"
        }
        else if(routingNumberTF.text == "")
        {
            msg = "You must enter a routing number to receive payouts"
        }
        if(msg != "")
        {
            errorTV.text = msg
            errorTV.textColor = UIColor.redColor()
            errorTV.hidden = false
            return false
        }
        errorTV.text = ""
        errorTV.hidden = true
        return true
    }
    
    @IBAction func updateButtonPressed(sender: AnyObject)
    {
        if(self.validateForm())
        {
            let ref = Core.fireBaseRef.childByAppendingPath("profile").childByAppendingPath(Core.fireBaseRef.authData.uid)
            Core.userProfileDictionary["first_name"] = self.firstNameTF.text!
            Core.userProfileDictionary["last_name"] = self.lastNameTF.text!
            Core.userProfileDictionary["street1"] = self.street1TF.text!
            Core.userProfileDictionary["street2"] = self.street2TF.text!
            Core.userProfileDictionary["city"] = self.cityTF.text!
            Core.userProfileDictionary["state"] = self.stateTF.text!
            Core.userProfileDictionary["zip"] = self.zipTF.text!
            Core.userProfileDictionary["name_on_bank_account"] = self.nameOnBankAccountTF.text!
            Core.userProfileDictionary["routing_number"] = self.routingNumberTF.text!
            Core.userProfileDictionary["account_number"] = self.accountNumberTF.text!
            var accountType = "individual"
            if(self.accountTypeSegments.selectedSegmentIndex == 1)
            {
                accountType = "company"
            }
            Core.userProfileDictionary["account_type"] = accountType
            
            ref.setValue(Core.userProfileDictionary, withCompletionBlock: { (error: NSError!, firebase: Firebase!) in
                
                if(error == nil)
                {
                    UIView.animateWithDuration(0.5, animations: {
                        self.updatedLabel.alpha = 1.0
                        }, completion: { (done: Bool) in
                            UIView.animateWithDuration(0.5, animations: {
                                self.updatedLabel.alpha = 0.0
                            })
                    })
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
