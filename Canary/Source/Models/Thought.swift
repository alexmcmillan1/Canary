import RealmSwift

class Thought: Object {
    @objc dynamic var content = ""
    
    static func withContent(_ content: String? = "") -> Thought {
        let temp = Thought()
        temp.content = content!
        return temp
    }
}
