//
//  ViewController.swift
//  Contacts
//
//  Created by Дмитрий Никольский on 01.11.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        storage = ContactStorage()
        loadContacts()
    }
    @IBAction func showMeContactAlert() {
        // создание аллерт контроллера
        let alertController = UIAlertController(title: "Создать новый контакт", message: "Введите имя и телефон", preferredStyle: .alert)
        
        // первое текстовое поле
        alertController.addTextField { textField in
            textField.placeholder = "Имя"
        }
        // второе текстовое поле
        alertController.addTextField { textField in
            textField.placeholder = "Номер телефона"
        }
        
        // кнопки
        // кнопка создания контакта
        let createButton = UIAlertAction(title: "Создать", style: .default) { _ in
            guard let contactName = alertController.textFields?[0].text,
                  let contactPhone = alertController.textFields?[1].text else {
                return
            }
        // создание контакта
        let contact = Contact(title: contactName, phone: contactPhone)
            self.contacts.append(contact)
            self.tableView.reloadData()
        }
        // кнопка отмены
        let cancelButton = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        // добавление кнопки в алерт контроллер
        alertController.addAction(createButton)
        alertController.addAction(cancelButton)
        
        // отображаем алерт контроллер
        self.present(alertController, animated: true, completion: nil)
    }
    private var contacts = [ContactProtocol] () {
        didSet {
            contacts.sort {$0.title < $1.title}
            storage.save(contacts: contacts)
        }
    }
    private func loadContacts() {
        contacts = storage.load()
    }
    
    var storage: ContactStorageProtocol!
}



extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        // попытка загрузки переиспользуемой ячейки
//        guard var cell = tableView.dequeueReusableCell(withIdentifier: "MyCell") else {
//            print("Создаем новую ячейку для строки с индексом \(indexPath.row)")
//            var newCell = UITableViewCell(style: .default, reuseIdentifier: "MyCell")
//            configure(cell: &newCell, for: indexPath)
//            return newCell
//        }
//        print("Используем старую ячейку для строки с индексом \(indexPath.row)")
//        configure(cell: &cell, for: indexPath)
//        return cell
//    }
//
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: "MyCell") {
            print("Используем старую ячейку для строки с индексом \(indexPath.row)")
            cell = reuseCell
        } else {
            print("Создаем новую ячейку для строки с индексом \(indexPath.row)")
            cell = UITableViewCell(style: .value1, reuseIdentifier: "MyCell")
        }
        configure(cell: &cell, for: indexPath)
        return cell
    }
    private func configure(cell: inout UITableViewCell, for indexPath: IndexPath) {
        var configuration = cell.defaultContentConfiguration()
        //имя контакта
        configuration.text = contacts[indexPath.row].title
        configuration.secondaryText = contacts[indexPath.row].phone
        cell.contentConfiguration = configuration
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // действие
        let actionDelete = UIContextualAction(style: .destructive, title: "Удалить") { _,_,_ in
        // удаляем экземпляр
            self.contacts.remove(at: indexPath.row)
        // перезагружаем таблицу
            tableView.reloadData()
        }
        // экземпляр, описывающий доступные действия
        let actions = UISwipeActionsConfiguration(actions: [actionDelete])
        return actions
    }
}

