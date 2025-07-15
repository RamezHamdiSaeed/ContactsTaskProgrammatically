import UIKit

class AddContactViewController: UIViewController {
    let nameField = UITextField()
    let phoneField = UITextField()
    let saveButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Contact"
        view.backgroundColor = .white
        setupForm()
    }

    func setupForm() {
        nameField.placeholder = "Name"
        nameField.backgroundColor = .lightGray
        phoneField.placeholder = "Phone"
        phoneField.keyboardType = .phonePad
        phoneField.backgroundColor = .lightGray


        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [nameField, phoneField, saveButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        [nameField, phoneField].forEach {
            $0.borderStyle = .roundedRect
        }

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }

    @objc func saveTapped() {
        guard let name = nameField.text, !name.isEmpty,
              let phone = phoneField.text, !phone.isEmpty else {
            return
        }

        var contacts = ContactStorage.fetch()
        contacts.append(Contact(name: name, phone: phone))
        ContactStorage.save(contacts)

        navigationController?.popViewController(animated: true)
    }
}
