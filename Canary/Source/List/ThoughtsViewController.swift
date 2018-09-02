import UIKit
import RealmSwift

protocol EditorDelegate: class {
    func panned(_ sender: UIPanGestureRecognizer)
    func tappedClose()
}

class ThoughtsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var items: [Thought] = []
    private var tableView: UITableView!
    private var modalContainerView: UIView!
    private var modalViewDismissalAnimator: UIViewPropertyAnimator?
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
        
        modalContainerView = createEditModal()
        view.addSubview(modalContainerView)
        constrainEditModal()
        
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
    
    private func createEditModal() -> UIView {
        let modalContainerView = UIView()
        
        let editViewInteractor = EditViewInteractor()
        editViewController = EditViewController(interactor: editViewInteractor)
        editViewInteractor.viewController = editViewController
        editViewController?.delegate = self
        
        modalContainerView.addSubview(editViewController!.view)
        editViewController?.view.translatesAutoresizingMaskIntoConstraints = false
        editViewController?.view.leadingAnchor.constraint(equalTo: modalContainerView.leadingAnchor).isActive = true
        editViewController?.view.trailingAnchor.constraint(equalTo: modalContainerView.trailingAnchor).isActive = true
        editViewController?.view.bottomAnchor.constraint(equalTo: modalContainerView.bottomAnchor).isActive = true
        editViewController?.view.topAnchor.constraint(equalTo: modalContainerView.topAnchor).isActive = true
        
        modalContainerView.transform = modalContainerView.transform.translatedBy(x: 0, y: UIScreen.main.bounds.height)
        
        return modalContainerView
    }
    
    private func constrainEditModal() {
        modalContainerView.translatesAutoresizingMaskIntoConstraints = false
        modalContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        modalContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        modalContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        modalContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
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
        editViewController?.setup(items[indexPath.row])
        
        let springAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.9) {
            self.modalContainerView.transform = .identity
        }
        springAnimator.startAnimation()
    }
    
    @objc private func tappedAdd() {
        presentInputViewController()
    }
    
    private func presentInputViewController() {
        editViewController?.setup(Thought.create())
        let springAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.9) {
            self.modalContainerView.transform = .identity
        }
        springAnimator.startAnimation()
    }
    
    private func checkEmptyState() {
        showEmptyState(items.isEmpty)
    }
    
    private func showEmptyState(_ show: Bool) {
        tableView.isHidden = show
        emptyView.isHidden = !show
    }
}

extension ThoughtsViewController: EditorDelegate {
    
    func tappedClose() {
        UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
            self.modalContainerView.transform = self.modalContainerView.transform.translatedBy(x: 0, y: UIScreen.main.bounds.height)
        }.startAnimation()
    }
    
    func panned(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            // Set up animator for interactive dismissal
            modalViewDismissalAnimator = UIViewPropertyAnimator(duration: 0.4, curve: .easeInOut, animations: {
                self.modalContainerView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
            })
            modalViewDismissalAnimator?.startAnimation()
            modalViewDismissalAnimator?.pauseAnimation()
        case .changed:
            modalViewDismissalAnimator?.fractionComplete = sender.translation(in: view).y / UIScreen.main.bounds.height
        case .ended:
            let velocity = sender.velocity(in: view)
            modalViewDismissalAnimator?.isReversed = velocity.y < 50
            modalViewDismissalAnimator?.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        default:
            return
        }
    }
}
