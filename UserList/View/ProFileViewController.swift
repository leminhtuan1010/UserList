//
//  ProFileViewController.swift
//  UserList
//
//  Created by Minh Tuan on 11/4/17.
//  Copyright © 2017 Minh Tuan. All rights reserved.
//

import UIKit
class ProFileViewController: UIViewController {
    fileprivate let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    fileprivate let fileManager = FileManager.default
    
    @IBOutlet weak var bt_index: UIButton!
    @IBOutlet weak var lbl_Name: UITextField!
    @IBOutlet weak var lbl_dob: UITextField!
    @IBAction func acc_Update(_ sender: Any) {
        updatePlist()
        self.navigationController?.popViewController(animated: true)
    }
    var lableName = String()
    var lableAddress = String()
    var indexRow : Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLable()
        setupNavigation()

    }
    
    func setupNavigation(){
        navigationItem.title = "Update User"
    }
    func setupLable(){
//        lbl_Name.text = lableName
//        lbl_dob.text = lableAddress
        lbl_Name.placeholder = lableName
        lbl_dob.placeholder = lableAddress
        
//        lbl_Name.layer.borderColor = UIColor.blue.cgColor
//        lbl_dob.layer.borderColor = UIColor.blue.cgColor
        bt_index.layer.borderColor = UIColor.blue.cgColor
        bt_index.layer.borderWidth = 2
//        lbl_Name.layer.borderWidth = 2
//        lbl_dob.layer.borderWidth = 2
        lbl_Name.layer.cornerRadius = 8
        lbl_dob.layer.cornerRadius = 8
        bt_index.layer.cornerRadius = 8
    }
    func updatePlist(){
         let path = documentDirectory.appending("/UserData.plist")
        guard let plistData = try? Data.init(contentsOf: URL.init(fileURLWithPath: path)) else { return }
        
        guard var result = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [[String: String]] else { return }
        if lbl_Name.text == nil{
            result?[indexRow]["Name"] = lbl_Name.placeholder
        }else {
            result?[indexRow]["Name"] = lbl_Name.text
    }
        if lbl_dob.text == nil {
            result?[indexRow]["Address"] = lbl_dob.placeholder
        }else{
            result?[indexRow]["Address"] = lbl_dob.text
        }
    (result! as NSArray).write(toFile: path, atomically: true)
}
}
