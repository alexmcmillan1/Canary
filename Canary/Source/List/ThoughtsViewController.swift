import UIKit
import RealmSwift

class ThoughtsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var items: [Thought] = []
    private var tableView: UITableView!
    private var modalContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = createTableView()
        modalContainer = createEditModalView()
        view.addSubview(tableView)
        view.addSubview(modalContainer)
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        items = getItems()
        tableView.reloadData()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Thoughts"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tappedAdd))
    }
    
    private func getItems() -> [Thought] {
        let realm = try! Realm()
        return realm.objects(Thought.self).map { $0 }
    }
    
    private func createTableView() -> UITableView {
        let tableView = UITableView(frame: UIScreen.main.bounds)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 64
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "ThoughtTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: ThoughtTableViewCell.reuseIdentifier)
        return tableView
    }
    
    private func createEditModalView() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 64, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64))
        view.backgroundColor = .red
        view.layer.cornerRadius = 16
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ThoughtTableViewCell.reuseIdentifier, for: indexPath) as? ThoughtTableViewCell else {
            fatalError()
        }
        cell.mainLabel.text = items[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] _, indexPath in
            let realm = try! Realm()
            if let thought = self?.items[indexPath.row] {
                try! realm.write {
                    realm.delete(thought)
                }
                self?.items.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
        
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = EditViewController()
        viewController.setup(items[indexPath.row])
        present(viewController, animated: true, completion: nil)
    }
    
    @objc private func tappedAdd() {
        presentInputViewController()
    }
    
    private func presentInputViewController() {
        let inputViewController = InputViewController()
        present(inputViewController, animated: true, completion: nil)
    }
}
