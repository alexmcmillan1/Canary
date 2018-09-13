import UIKit
import RealmSwift
import TinyConstraints

protocol EditorDelegate: class {
    func tappedClose()
}

enum SortMode: Int {
    case dateDescending = 0
    case dateAscending
    case alphabeticalAscending
    case alphabeticalDescending
}

class ThoughtsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var items: [Thought] = []
    private var tableView: UITableView!
    private var emptyView: UIView!
    private var addButton: CircleImageButton!
    private var sortButton: CircleImageButton!
    private var sortMode = SortMode.dateDescending
    private var sortImages: [UIImage?] = [UIImage(named: "sort_updated_descending"),
                                          UIImage(named: "sort_updated_ascending"),
                                          UIImage(named: "sort_alphabetically_ascending"),
                                          UIImage(named: "sort_alphabetically_descending")]
    private let dateFormatter = ThoughtDateFormatter()
    
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
        
        sortButton = CircleImageButton(UIImage(named: "sort_updated_descending"))
        sortButton.addTarget(self, action: #selector(tappedSort), for: .touchUpInside)
        view.addSubview(sortButton)
        sortButton.topToSuperview(offset: 48)
        sortButton.trailingToSuperview(offset: 16)
        
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        items = getItems()
        checkEmptyState()
        sortItems(by: sortMode)
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
        tableView.rowHeight = 72
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
        let date = Date(timeIntervalSince1970: items[indexPath.row].lastUpdated)
        
        let aFewSecondsAgo = Date(timeIntervalSinceNow: -3)
        print(ThoughtDateFormatter().string(from: aFewSecondsAgo))
        
        cell.lastUpdatedLabel.text = dateFormatter.formattedString(from: date)
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
        present(editViewController, animated: true)
    }
    
    @objc private func tappedSort() {
        let sortModeIndex = (sortMode.rawValue + 1) % 4
        if let newSortMode = SortMode(rawValue: sortModeIndex) {
            sortMode = newSortMode
            sortButton.animateToImage(sortImages[sortModeIndex], immediately: true)
            sortItems(by: sortMode)
        }
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
        sortButton.alpha = show ? 0.2 : 1
        sortButton.isUserInteractionEnabled = !show
    }
    
    private func sortItems(by: SortMode) {
        items.sort { (thoughtA, thoughtB) -> Bool in
            switch by {
            case .alphabeticalAscending:
                return thoughtA.content < thoughtB.content
            case .alphabeticalDescending:
                return thoughtA.content > thoughtB.content
            case .dateAscending:
                return thoughtA.lastUpdated < thoughtB.lastUpdated
            case .dateDescending:
                return thoughtA.lastUpdated > thoughtB.lastUpdated
            }
        }
        
        tableView.reloadData()
    }
}
