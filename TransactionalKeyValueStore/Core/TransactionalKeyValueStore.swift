import Foundation

final class TransactionalKeyValueStore {

    private var commandsStack = [Command]()

    private var store: [String: String] {
        commandsStack.reduce([:]) { partialResult, command in
            var mutableResult = partialResult
            switch command {
            case .set(let key, let value): mutableResult[key] = value
            case .delete(let key): mutableResult.removeValue(forKey: key)
            default: break
            }
            return mutableResult
        }
    }

    @discardableResult
    func run(_ command: Command) -> RunResult {
        switch command {
        case .set:
            commandsStack.append(command)
            return .empty
        case .get(let key):
            guard let value = store[key] else { return .error("key not set")}
            return .value(value)
        case .count(let value):
            let count = store.filter { $0.value == value }.count
            return .value("\(count)")
        case .delete(let key):
            if store[key] != nil {
                commandsStack.append(command)
                return .empty
            } else {
                return .error("key not set")
            }
        case .begin:
            commandsStack.append(command)
            return .empty
        case .commit:
            if let lastBeginIndex = findLastBeginIndex() {
                commandsStack.remove(at: lastBeginIndex)
                return .empty
            } else {
                return .error("no transaction")
            }
        case .rollback:
            if let lastBeginIndex = findLastBeginIndex() {
                commandsStack.removeLast(commandsStack.count - lastBeginIndex)
                return .empty
            } else {
                return .error("no transaction")
            }
        }
    }

    private func findLastBeginIndex() -> Array.Index? {
        commandsStack.lastIndex { command in
            switch command {
            case .begin: return true
            default: return false
            }
        }
    }
}
