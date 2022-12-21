import Foundation

@MainActor
final class TransactionalKeyValueStoreViewModel: ObservableObject {

    @Published
    var setKeyText: String = ""

    @Published
    var setValueText: String = ""

    @Published
    var getText: String = ""

    @Published
    var deleteText: String = ""

    @Published
    var countText: String = ""

    @Published
    var isPresentingDeleteConfirmation = false

    @Published
    var isPresentingCommitConfirmation = false

    @Published
    var isPresentingRollbackConfirmation = false

    @Published
    var alertInfo: AlertInfo?

    private let core = TransactionalKeyValueStore()

    func set() {
        let key = setKeyText.trim()
        let value = setValueText.trim()
        guard key.count > 0, value.count > 0 else { return }

        let result = core.run(.set(key, value))

        switch result {
        case .error(let errorMessage):
            alertInfo = AlertInfo(title: "Error", message: errorMessage)
        default:
            cleanAllTextFields()
        }
    }

    func get() {
        let key = getText.trim()
        guard key.count > 0 else { return }

        let result = core.run(.get(key))

        switch result {
        case .error(let errorMessage):
            alertInfo = AlertInfo(title: "Error", message: errorMessage)
        case .value(let value):
            alertInfo = AlertInfo(title: "Process output", message: value)
            cleanAllTextFields()
        default:
            break
        }
    }

    func showDeleteConfirmation() {
        guard deleteText.trim().count > 0 else { return }

        isPresentingDeleteConfirmation = true
    }

    func delete() {
        let key = deleteText.trim()

        let result = core.run(.delete(key))

        switch result {
        case .error(let errorMessage):
            alertInfo = AlertInfo(title: "Error", message: errorMessage)
        default:
            cleanAllTextFields()
        }
    }

    func count() {
        let value = countText.trim()
        guard value.count > 0 else { return }

        let result = core.run(.count(value))

        switch result {
        case .error(let errorMessage):
            alertInfo = AlertInfo(title: "Error", message: errorMessage)
        case .value(let value):
            alertInfo = AlertInfo(title: "Process output", message: value)
            cleanAllTextFields()
        default:
            break
        }
    }

    func beginTransaction() {
        let result = core.run(.begin)

        switch result {
        case .error(let errorMessage):
            alertInfo = AlertInfo(title: "Error", message: errorMessage)
        default:
            cleanAllTextFields()
        }
    }

    func showCommitConfirmation() {
        isPresentingCommitConfirmation = true
    }

    func commitTransaction() {
        let result = core.run(.commit)

        switch result {
        case .error(let errorMessage):
            alertInfo = AlertInfo(title: "Error", message: errorMessage)
        default:
            cleanAllTextFields()
        }
    }

    func showRollbackConfirmation() {
        isPresentingRollbackConfirmation = true
    }

    func rollbackTransaction() {
        let result = core.run(.rollback)

        switch result {
        case .error(let errorMessage):
            alertInfo = AlertInfo(title: "Error", message: errorMessage)
        default:
            cleanAllTextFields()
        }
    }

    private func cleanAllTextFields() {
        setKeyText = ""
        setValueText = ""
        getText = ""
        deleteText = ""
        countText = ""
    }
}
