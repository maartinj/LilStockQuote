//
//  ContentView.swift
//  StockQuote
//
//  Created by Stewart Lynch on 2021-04-17.
//

import SwiftUI

struct ContentView: View {
    @State private var stock:Stock?
    @State private var symbol: String = ""
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter Stock Symbol", text: $symbol)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Get Update") {
                    getStockInfo(symbol: symbol)
                }
                if let stock = stock {
                    VStack {
                        Text(stock.name ?? "Unknown Stock")
                            .font(.title)
                        PropertyView(name: "Open", value: stock.open)
                        PropertyView(name: "High", value: stock.high)
                        PropertyView(name: "Low", value: stock.low)
                        PropertyView(name: "Current", value: stock.current)
                        PropertyView(name: "Prev", value: stock.previous_close)
                    }
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Lil Stock Quote")
        }
    }

    struct PropertyView: View {
        let name: String
        let value: Double
        var body: some View {
            HStack {
                Text(name)
                    .fontWeight(.bold)
                Text(value.asCurrency())
            }
        }
    }

    func getStockInfo(symbol: String) {
        let urlString = "https://api.lil.software/stocks?symbol=\(symbol.uppercased())"
        guard let url = URL(string: urlString) else {
            fatalError("URL could not be constructed")
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                fatalError("Error retieving quote: \(error.localizedDescription)")
            }
            let decoder = JSONDecoder()
            do {
                stock = try decoder.decode(Stock.self, from: data!)
            } catch {
                fatalError("Error decoding data \(error.localizedDescription)")
            }
        }
        .resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



