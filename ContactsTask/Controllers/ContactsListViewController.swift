import UIKit

class ContactsListViewController: UITableViewController, UISearchBarDelegate {
    var contacts: [Contact] = []
    var filteredContacts: [Contact] = []
    var isSearching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts"
        contacts = ContactStorage.fetch()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contacts = ContactStorage.fetch()
        tableView.reloadData()
    }

    func setupUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addContactTapped))

//        let searchBar = UISearchBar()
//        searchBar.delegate = self
//        searchBar.placeholder = "Search Contacts"
//        tableView.tableHeaderView = searchBar

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.backgroundColor = .lightGray
    }

    @objc func addContactTapped() {
        let vc = AddContactViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        let data = isSearching ? filteredContacts : contacts
        if data.isEmpty {
            tableView.setEmptyMessage("No Contacts Yet.\nTap + to add one.")
        } else {
            tableView.restore()
        }
        return 1
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let searchBar = UISearchBar()
        searchBar.barTintColor = .lightGray
        searchBar.delegate = self
        searchBar.placeholder = "Search contacts..."
        return searchBar
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isSearching ? filteredContacts.count : contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = isSearching ? filteredContacts : contacts
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let contact = data[indexPath.row]
        cell.textLabel?.text = "\(contact.name) - \(contact.phone)"
        cell.textLabel?.textColor = .black
        cell.backgroundColor = .white
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = isSearching ? filteredContacts : contacts
        let contact = data[indexPath.row]
        let vc = ContactDetailViewController(contact: contact)
        navigationController?.pushViewController(vc, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            contacts.remove(at: indexPath.row)
            ContactStorage.save(contacts)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = !searchText.isEmpty
        filteredContacts = contacts.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        tableView.reloadData()
    }
}

extension UITableView {
    func setEmptyMessage(_ message: String) {
        let label = UILabel()
        label.text = message
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        backgroundView = label
        separatorStyle = .none
    }

    func restore() {
        backgroundView = nil
        separatorStyle = .singleLine
    }
}
