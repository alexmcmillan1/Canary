import UIKit
import RealmSwift
import TinyConstraints

protocol EditorDelegate: class {
    func tappedClose()
}

class ThoughtsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var items: [Thought] = []
    private var tableView: UITableView!
    private var emptyView: UIView!
    private var addButton: CircleImageButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []

        tableView = createTableView()
        view.addSubview(tableView)
        tableView.edgesToSuperview()
        
        emptyView = EmptyViewController().view
        view.addSubview(emptyView)
        emptyView.edgesToSuperview()

        addButton = CircleImageButton(UIImage(named: "handwrite"))
        addButton.addTarget(self, action: #selector(tappedAdd), for: .touchUpInside)
        view.addSubview(addButton)
        addButton.bottomToSuperview(offset: -32)
        addButton.centerXToSuperview()
        
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        items = getItems()
        checkEmptyState()
        tableView.reloadData()
    }
    
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func getItems() -> [Thought] {
        let realm = try! Realm()
        return realm.objects(Thought.self).map { $0 }
    }
    
    private func createTableView() -> UITableView {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 64
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "ThoughtTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: ThoughtTableViewCell.reuseIdentifier)
        return tableView
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
        let delete = UITableViewRowAction(style: .destructive, title: NSLocalizedString("Delete", comment: "")) { [weak self] _, indexPath in
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
        let editViewController = EditViewController(id: items[indexPath.row].id, text: items[indexPath.row].content)
        present(editViewController, animated: true)
    }
    
    @objc private func tappedAdd() {
        let editViewController = EditViewController()
        animateAddButton()
        present(editViewController, animated: true)
    }
    
    private func animateAddButton() {
        let animator = UIViewPropertyAnimator(duration: 0.1, curve: .easeInOut) {
            self.addButton.transform = self.addButton.transform.scaledBy(x: 0.8, y: 0.8)
        }
        
        let secondAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.5) {
            self.addButton.transform = .identity
        }
        
        animator.addCompletion { _ in
            secondAnimator.startAnimation()
        }
        
        animator.startAnimation()
    }
    
    private func checkEmptyState() {
        showEmptyState(items.isEmpty)
    }
    
    private func showEmptyState(_ show: Bool) {
        let alpha: CGFloat = show ? 1 : 0
        UIView.animate(withDuration: 0.5) {
            self.tableView.alpha = 1 - alpha
            self.emptyView.alpha = alpha
        }
    }
}
