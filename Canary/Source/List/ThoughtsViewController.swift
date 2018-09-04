import UIKit
import RealmSwift

protocol EditorDelegate: class {
    func tappedClose()
}

class ThoughtsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var items: [Thought] = []
    private var tableView: UITableView!
    private var editViewController: EditViewController?
    private var emptyView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        
        tableView = createTableView()
        view.addSubview(tableView)
        
        emptyView = EmptyViewController().view
        view.addSubview(emptyView)
        constrainEmptyView()
        
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        items = getItems()
        checkEmptyState()
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
    
    private func constrainEmptyView() {
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        emptyView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ThoughtTableViewCell.reuseIdentifier, for: indexPath) as? ThoughtTableViewCell else {
            fatalError()
        }
        cell.mainLabel.text = items[indexPath.row].content
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
                self?.checkEmptyState()
            }
        }
        
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    @objc private func tappedAdd() {
        presentInputViewController()
    }
    
    private func presentInputViewController() {
        
    }
    
    private func checkEmptyState() {
        showEmptyState(items.isEmpty)
    }
    
    private func showEmptyState(_ show: Bool) {
        tableView.isHidden = show
        emptyView.isHidden = !show
    }
}
