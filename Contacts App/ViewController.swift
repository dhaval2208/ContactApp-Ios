//
//  ViewController.swift
//  Contacts App
//
//  Created by Dhaval Bhimani on 2022-08-15.
//
import Contacts
import ContactsUI
import UIKit

struct Number {
    let name : String
    let id: String
    let source: CNContact
}

class ViewController: UIViewController, UITableViewDataSource, CNContactPickerDelegate, UITableViewDelegate {
    
    private let List: UITableView = {
        let List = UITableView()
        List.register(UITableViewCell.self,
                       forCellReuseIdentifier: "Phone")
        return List
    }()
    
    var models = [Number]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(List)
        List.frame = view.bounds
        List.dataSource = self
        List.delegate = self
       
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(didTapAdd))
    }

   @objc func didTapAdd(){
        let vc = CNContactPickerViewController()
        vc.delegate = self
        present(vc, animated: true)
    }
    func contactPicker(_picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let name = contact.givenName + " " + contact.familyName
        let identifier = contact.identifier
        let model = Number(name: name,
                           id: identifier,
                           source: contact
        )
        models.append(model)
        List.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let contact = models[indexPath.row].source
        let vc = CNContactViewController(forNewContact: contact)
        present(UINavigationController(rootViewController: vc), animated:true)
    
    }
}


