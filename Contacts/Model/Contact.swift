//
//  Contact.swift
//  Contacts
//
//  Created by Дмитрий Никольский on 02.11.2022.
//

import UIKit

protocol ContactProtocol {
    /// Имя
    var title: String {get set}
    /// Номер телефона
    var phone: String {get set}
}

struct Contact: ContactProtocol {
    var title: String
    var phone: String
}

protocol ContactStorageProtocol {
    // загрузка списка контактов
    func load() -> [ContactProtocol]
    // обновление контактов
    func save(contacts:[ContactProtocol])
}

class ContactStorage: ContactStorageProtocol {
    //ссылка на хранилище
    private var storage = UserDefaults.standard
    // ключ для сохранения
    private var storageKey = "contacts"
    // перечисление с ключами для записи в хранилище
    private enum ContactKey: String {
        case title
        case phone
    }
    func load() -> [ContactProtocol] {
        var resultContacts: [ContactProtocol] = []
        let contactsFromStorage = storage.array(forKey: storageKey) as? [[String:String]] ?? []
        for contact in contactsFromStorage {
            guard let title = contact [ContactKey.title.rawValue],
                  let phone = contact [ContactKey.phone.rawValue] else {
                continue
            }
            resultContacts.append(Contact(title: title, phone: phone))
        }
        return resultContacts
    }
    
    func save(contacts: [ContactProtocol]) {
        var arrayForStorage: [[String:String]] = []
        contacts.forEach { contact in
            var newElementForStorage: Dictionary<String, String> = [:]
            newElementForStorage[ContactKey.title.rawValue] = contact.title
            newElementForStorage[ContactKey.phone.rawValue] = contact.phone
            arrayForStorage.append(newElementForStorage)
        }
        storage.set(arrayForStorage, forKey: storageKey)
    }
}
