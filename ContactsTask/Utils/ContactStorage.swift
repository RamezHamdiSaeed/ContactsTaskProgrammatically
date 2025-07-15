import Foundation

class ContactStorage {
    private static let key = "contacts"

    static func save(_ contacts: [Contact]) {
        if let data = try? JSONEncoder().encode(contacts) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    static func fetch() -> [Contact] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let contacts = try? JSONDecoder().decode([Contact].self, from: data) else {
            return []
        }
        return contacts
    }
}