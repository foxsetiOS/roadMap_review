final class Observable<Value> {
    
    private var observers = [(Value) -> Void]()
    
    var value: Value {
        didSet { notifyObservers() }
    }
    
    init(_ value: Value) {
        self.value = value
    }
    
    func bind(_ observer: @escaping (Value) -> Void) {
        observer(value)
        observers.append(observer)
    }
    
    private func notifyObservers() {
        observers.forEach { $0(value) }
    }
}
