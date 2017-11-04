//
//  ViewController.swift
//  UserList
//
//  Created by Minh Tuan on 11/3/17.
//  Copyright © 2017 Minh Tuan. All rights reserved.
//

import UIKit
struct User {
    var name: String
    var address: String
    var image: String
     
    
    init(_ name: String, address: String, image: String) {
        self.name = name
        self.address = address
        self.image = image
    }
}
class ViewController: UIViewController {
    
    @IBOutlet weak var tableviewUser: UITableView!
    
    fileprivate let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    fileprivate let fileManager = FileManager.default
    
    fileprivate var users = [User]()
//    var index : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "User List"
        setupRight()
        setupTableView()
//        loadDataFromBundlePlist()
    }
   override func viewWillAppear(_ animated: Bool) {
        loadDataFromBundlePlist()
        tableviewUser.reloadData()
    }
    func setupTableView(){
        tableviewUser.dataSource = self
        tableviewUser.delegate = self
        tableviewUser.register(UINib.init(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
    }
    func setupRight(){
        let item = UIBarButtonItem(image: #imageLiteral(resourceName: "if_insert-object_23421"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(insertUser))
        navigationItem.rightBarButtonItem = item
    }
    @objc func insertUser(){
        let path = documentDirectory.appending("/UserData.plist")
        let new = User.init("Minh Tuấn", address: "Số 7 Thiền Quang", image: "Davis")
        users.insert(new, at: 0)
        if fileManager.fileExists(atPath: path){
            var newArray = [[String : String]]()
            for item in users {
                var data = [String : String]()
                data["Name"] = item.name
                data["Address"] = item.address
                data["image"] = item.image
                newArray.append(data)
            }
        (newArray as NSArray).write(toFile: path, atomically: true)
        }
        self.tableviewUser.reloadData()

    }
    func loadDataFromBundlePlist() {
        
        let path = documentDirectory.appending("/UserData.plist")
        
        if !fileManager.fileExists(atPath: path) {
            if let bundleURL = Bundle.main.path(forResource: "UserData", ofType: "plist") {
                try? fileManager.copyItem(atPath: bundleURL, toPath: path)
                
                guard let plistData = try? Data.init(contentsOf: URL.init(fileURLWithPath: path)) else { return }
                
                guard let result = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [[String: String]] else { return }
                for userInformation in result! {
                    let user = User.init(userInformation["Name"]!, address: userInformation["Address"]!, image:userInformation["image"]!)
                    users.append(user)
                    print(users.count)
                }
            }
        } else {
            guard let plistData = try? Data.init(contentsOf: URL.init(fileURLWithPath: path)) else { return }
            
            guard let result = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [[String: String]] else { return }
            for userInformation in result! {
                let user = User.init(userInformation["Name"]!, address: userInformation["Address"]!, image:userInformation["image"]!)
                users.append(user)
                print(users.count)
            }
        }
        tableviewUser.reloadData()
    }

}
extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.5
    }
}
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let userProfileCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell else { return UITableViewCell() }
        
        let user = users[indexPath.row]
        
        userProfileCell.user = user
        
        return userProfileCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewProFile = ProFileViewController(nibName: "ProFileViewController", bundle: nil)
        let nameLable = users[indexPath.row]
        viewProFile.lableName = nameLable.name
        viewProFile.lableAddress = nameLable.address
        viewProFile.indexRow = indexPath.row
        navigationController?.pushViewController(viewProFile, animated: true)
        users.removeAll()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            self.users.remove(at: indexPath.row)
            self.tableviewUser.deleteRows(at: [indexPath], with: .automatic)
        }
        let path = documentDirectory.appending("/UserData.plist")
        if fileManager.fileExists(atPath: path){
            var newArray = [[String : String]]()
            for item in users {
                var data = [String : String]()
                data["Name"] = item.name
                data["Address"] = item.address
                data["image"] = item.image
                newArray.append(data)
            }
            (newArray as NSArray).write(toFile: path, atomically: true)
        }
    }
}
