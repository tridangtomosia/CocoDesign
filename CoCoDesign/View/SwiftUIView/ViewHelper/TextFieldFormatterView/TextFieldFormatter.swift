import SwiftUI

protocol TextFieldFormatter {
    associatedtype Value
    var limit: Int { get }
    func displayString(for value: Value) -> String
    func editingString(for value: Value) -> String
    func value(from string: String) -> Value
}

struct CurrencyTextFieldFormatter: TextFieldFormatter {
    typealias Value = String

    var limit = 12

    func displayString(for value: String) -> String {
        return value.phoneFormat("###-###-#####")
    }

    func editingString(for value: String) -> String {
        return value.phoneFormat("###-###-#####")
    }

    func value(from string: String) -> String {
        return string.replace(pattern: "-", withString: "") ?? ""
    }
}

struct FormattedTextField<Formatter: TextFieldFormatter>: View {
    init(_ title: String,
         value: Binding<Formatter.Value>,
         formatter: Formatter) {
        self.title = title
        self.value = value
        self.formatter = formatter
    }

    let title: String
    let value: Binding<Formatter.Value>
    let formatter: Formatter

    var body: some View {
        TextField(title, text: Binding(get: {
            self.formatter.displayString(for: self.value.wrappedValue)
            }, set: { string in
                if string.count <= self.formatter.limit {
                    self.editingValue = string
                    let valueString = self.formatter.value(from: string) as? String ?? ""
                    self.value.wrappedValue = valueString as! Formatter.Value
                } else {
                    var limitString = string
                    limitString.removeLast()
                    self.editingValue = limitString
                    let valueString = self.formatter.value(from: limitString) as? String ?? ""
                    self.value.wrappedValue = valueString as! Formatter.Value
                }
        }), onEditingChanged: { isEditing in
            self.isEditing = isEditing
            self.editingValue = self.formatter.editingString(for: self.value.wrappedValue)
        })
    }

    @State private var isEditing: Bool = false
    @State private var editingValue: String = ""
}
