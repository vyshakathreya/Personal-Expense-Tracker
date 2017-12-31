//
//  TransactionTableViewController.swift
//  Personal Expense Tracker
//
//  Created by Vyshak Athreya B K on 12/23/17.
//  Copyright © 2017 Vyshak Athreya B K. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class TransactionTableViewController: UITableViewController {

    @IBOutlet var transTableView: UITableView!
    var user:String!
    var uid:String!
    var userRoot:DatabaseReference!
    
    var transactionsIncomeExpense = Array<String>()
    var transactionsAmount = Array<String>()
    var transactionsDescription = Array<String>()
    var transactionsAccount = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uid = Auth.auth().currentUser?.uid
        user = Auth.auth().currentUser?.displayName
        userRoot = Database.database().reference().child("transactions/"+uid!)
        user = Auth.auth().currentUser?.displayName
        getData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionsIncomeExpense.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = transTableView.dequeueReusableCell(withIdentifier: "customtableCell") as! TransactionsTableViewCell
            cell.icmLbl.text = self.transactionsIncomeExpense[indexPath.row]
            cell.acLabel.text = self.transactionsAccount[indexPath.row]
            cell.amtLbl.text = self.transactionsAmount[indexPath.row]
            cell.descLbl.text = self.transactionsDescription[indexPath.row]
    return cell
    }

    func getData(){
        transactionsAmount.removeAll()
        transactionsAccount.removeAll()
        transactionsIncomeExpense.removeAll()
        transactionsDescription.removeAll()
        userRoot.observe(.value, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary{
                for (_,val) in value{
                    let jscon = JSON.init(val)
                    if let desc = jscon["desc"].string{
                        self.transactionsDescription.append(desc)
                    }else{
                        self.transactionsDescription.append("No Description")
                    }
                    if let amount = jscon["amount"].string, let acc = jscon["account"].string,
                        let categ = jscon["category"].string{
                        self.transactionsAmount.append(amount)
                        self.transactionsAccount.append(acc)
                        self.transactionsIncomeExpense.append(categ)
                        self.transTableView.reloadData()
                    }
                }
            }
        })
    }
    }
