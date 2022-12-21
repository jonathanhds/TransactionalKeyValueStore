import SwiftUI

struct TransactionalKeyValueStoreView: View {

    @StateObject
    private var viewModel = TransactionalKeyValueStoreViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                HStack(spacing: 12) {
                    Text("SET")
                    TextField("Key", text: $viewModel.setKeyText)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .accessibilityIdentifier("set_key")
                    TextField("Value", text: $viewModel.setValueText)
                        .autocorrectionDisabled()
                        .accessibilityIdentifier("set_value")
                    Spacer()
                    Button("Send") {
                        viewModel.set()
                    }
                    .accessibilityIdentifier("set_button")
                }

                HStack(spacing: 12) {
                    Text("GET")
                    TextField("Key", text: $viewModel.getText)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .accessibilityIdentifier("get_key")
                    Spacer()
                    Button("Send") {
                        viewModel.get()
                    }
                    .accessibilityIdentifier("get_button")
                }

                HStack(spacing: 12) {
                    Text("DELETE")
                    TextField("Key", text: $viewModel.deleteText)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .accessibilityIdentifier("delete_key")
                    Spacer()
                    Button("Send") {
                        viewModel.showDeleteConfirmation()
                    }
                    .accessibilityIdentifier("delete_button")
                    .confirmationDialog("Are you sure?", isPresented: $viewModel.isPresentingDeleteConfirmation) {
                        Button("Confirm") {
                            viewModel.delete()
                        }
                    }
                }

                HStack(spacing: 12) {
                    Text("COUNT")
                    TextField("Value", text: $viewModel.countText)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .accessibilityIdentifier("count_value")
                    Spacer()
                    Button("Send") {
                        viewModel.count()
                    }
                    .accessibilityIdentifier("count_button")
                }

                HStack(spacing: 12) {
                    Text("BEGIN")
                    Spacer()
                    Button("Send") {
                        viewModel.beginTransaction()
                    }
                    .accessibilityIdentifier("begin_button")
                }

                HStack(spacing: 12) {
                    Text("COMMIT")
                    Spacer()
                    Button("Send") {
                        viewModel.showCommitConfirmation()
                    }
                    .accessibilityIdentifier("commit_button")
                    .confirmationDialog("Are you sure?", isPresented: $viewModel.isPresentingCommitConfirmation) {
                        Button("Confirm") {
                            viewModel.commitTransaction()
                        }
                    }
                }

                HStack(spacing: 12) {
                    Text("ROLLBACK")
                    Spacer()
                    Button("Send") {
                        viewModel.showRollbackConfirmation()
                    }
                    .accessibilityIdentifier("rollback_button")
                    .confirmationDialog("Are you sure?", isPresented: $viewModel.isPresentingRollbackConfirmation) {
                        Button("Confirm") {
                            viewModel.rollbackTransaction()
                        }
                    }
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Trans. Key/Value Store")
        .alert(item: $viewModel.alertInfo) { alertInfo in
            Alert(
                title: Text(alertInfo.title),
                message: Text(alertInfo.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TransactionalKeyValueStoreView()
        }
    }
}
