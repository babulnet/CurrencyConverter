//
//  ContentView.swift
//  CurrencyConverter
//
//  Created by Babul Raj on 29/12/22.
//

import SwiftUI

// This is used to invert the dependancy - To make UI indepenadnt of the presenter Logic so that view can be reused in another context
struct ConverterViewModel {
    var title: String
    var subTitle: String
    var itemsToConvert:[String]
    var convertedResult:[String]
}

protocol ConverterViewDataProvider:ObservableObject {
    func start(_ completion:((Bool)->())?)
    func convert(value:String?,amount:String)
    var convertItemModel:ConverterViewModel {get}
    var isLoading: Bool {get}
    var error: Error?{get set}
}

// View is made generic as its completely agnostic about what its converting

struct ConverterView<T:ConverterViewDataProvider>: View where T:ObservableObject {
    @ObservedObject var presenter: T
    @State private var searchText: String = ""
    @State private var selection:String = "USD - United States Dollar" //  this can be injected accordingly from outside based on context
    @State private var amount = ""
    @FocusState private var amountIsFocused: Bool

    
    var filterdItems: [String]?  {
        if searchText.isEmpty {
            return self.presenter.convertItemModel.convertedResult
        } else {
            return self.presenter.convertItemModel.convertedResult.filter({ item in
                item.contains(searchText.uppercased())
            })
        }
    }
    
    var body: some View {
        if presenter.isLoading {
            ProgressView("fetching data")
        } else {
            VStack {
                HStack {
                    VStack(alignment:.leading) {
                        CustomPicker(title: presenter.convertItemModel.title, selection: $selection, items: presenter.convertItemModel.itemsToConvert)
                            .frame(height: 100)
                            .cornerRadius(20)
                        HStack {
                            Text("\(presenter.convertItemModel.subTitle):")
                                .foregroundColor(.black )
                                .font(.subheadline)
                            TextField("", text: $amount)
                                .focused($amountIsFocused)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.decimalPad)
                        }
                    }
                    .padding()
                    
                    Spacer()
                    Button("Convert") {
                        amountIsFocused = false
                        presenter.convert(value: selection, amount: amount)
                    }.background {
                        Color.secondary
                    }
                    .foregroundColor(.white)
                    .buttonStyle(.bordered)
                    .cornerRadius(10)
                }.padding()
                ListView(searchText: $searchText, filterdItems: filterdItems)
            }.errorAlert(error: $presenter.error)
            .onAppear(perform: {
                presenter.start(nil)
            })
        }
    }
}

struct ConverterView_Previews: PreviewProvider {
    static var previews: some View {
        ConverterView(presenter: CurrencyRateConverterViewPresenter())
    }
}

struct ListView: View {
    let gridItem = GridItem(.adaptive(minimum: 300))
    @Binding var searchText: String

    var filterdItems: [String]?
    var body: some View {
        NavigationStack {
            VStack {
                if let list = filterdItems {
                    ScrollView {
                        LazyVGrid(columns: [gridItem,gridItem]) {
                            ForEach(list.sorted(by: >), id: \.self) { item in
                                HStack {
                                    Text(item)
                                        .font(.subheadline)
                                }
                                .frame(width:150,height:100)
                                .background {
                                    Color.secondary
                                }
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText,placement: .navigationBarDrawer(displayMode: .always))
                .textCase(.uppercase)
                .padding()
            
        }
    }
}


struct CustomPicker: View {
    var title: String
    @Binding var selection: String
    var items: [String]
    
    var body: some View {
        VStack(alignment:.leading) {
            HStack(spacing:8) {
                Text("\(title) :")
                    .foregroundColor(.black )
                    .font(.subheadline)
                Picker(selection: $selection) {
                    ForEach(items,id: \.self) { item in
                                            HStack {
                                                Text("\(item)")
                                            }
                                        }
                } label: {
                    Text("")
                }
            }
            .padding(.vertical,9)
        }
    }
}
                            
extension View {
    func errorAlert(error: Binding<Error?>, buttonTitle: String = "OK") -> some View {
        let localizedAlertError = LocalizedAlertError(error: error.wrappedValue)
        return alert(isPresented: .constant(localizedAlertError != nil), error: localizedAlertError) { _ in
            Button(buttonTitle) {
                error.wrappedValue = nil
            }
        } message: { error in
            Text(error.recoverySuggestion ?? "")
        }
    }
}

struct LocalizedAlertError: LocalizedError {
    let underlyingError: LocalizedError
    var errorDescription: String? {
        underlyingError.errorDescription
    }
    var recoverySuggestion: String? {
        underlyingError.recoverySuggestion
    }

    init?(error: Error?) {
        guard let localizedError = error as? LocalizedError else { return nil }
        underlyingError = localizedError
    }
}
