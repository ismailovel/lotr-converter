//
//  ContentView.swift
//  LOTRConverter
//
//  Created by Ismailov on 22.01.2025.
//

import SwiftUI
import TipKit

struct ContentView: View {
    @State var showExchangeInfo = false
    @State var showSelectCurrency = false
    
    @State var leftAmount = ""
    @State var rightAmount = ""
    
    @FocusState var leftTyping
    @FocusState var rightTyping
    
    @State var leftCurrency: Currency = .silverPiece
    @State var rightCurrency: Currency = .goldPiece
    
    let currencyTip = CurrencyTip()
    
    var body: some View {
        ZStack {
            Image(.background)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Image(.prancingpony)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                
                Text("Currency Exchange")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                
                HStack {
                    
                    VStack {
                        
                        HStack {
                            Image(leftCurrency.image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 33)
                            
                            Text(leftCurrency.name)
                                .font(.headline)
                                .foregroundStyle(.white)
                        }
                        .padding(.bottom, -5)
                        .onTapGesture {
                            showSelectCurrency.toggle()
                            currencyTip.invalidate(reason: .actionPerformed)
                        }
                        .popoverTip(currencyTip, arrowEdge: .bottom)
                        
                        TextField("Amount", text: $leftAmount)
                            .textFieldStyle(.roundedBorder)
                            .focused($leftTyping)
                    }
                    
                    Image(systemName: "equal")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .symbolEffect(.pulse)
                    
                    VStack {
                        HStack {
                            Text(rightCurrency.name)
                                .font(.headline)
                                .foregroundStyle(.white)
                            
                            Image(rightCurrency.image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 33)
                        }
                        .padding(.bottom, -5)
                        .onTapGesture {
                            showSelectCurrency.toggle()
                            currencyTip.invalidate(reason: .actionPerformed)
                        }
                        
                        TextField("Amount", text: $rightAmount)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.trailing)
                            .focused($rightTyping)
                    }
                }
                .padding()
                .padding(.horizontal)
                .background(.black.opacity(0.5))
                .clipShape(.capsule)
                .keyboardType(.decimalPad)
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button {
                        showExchangeInfo.toggle()
                        leftTyping = false
                        rightTyping = false
                    } label: {
                        Image(systemName: "info.circle.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                    }
                    .padding(.trailing)
                }
            }
        }
        .task {
            try? Tips.configure()
        }
        .onTapGesture {
            leftTyping = false
            rightTyping = false
        }
        .onChange(of: leftAmount) { oldValue, newValue in
            if leftTyping {
                rightAmount = leftCurrency.convert(newValue, to: rightCurrency)
            }
        }
        .onChange(of: rightAmount) { oldValue, newValue in
            if rightTyping {
                leftAmount = rightCurrency.convert(newValue, to: leftCurrency)
            }
        }
        .onChange(of: leftCurrency) { _ , _ in
            leftAmount = rightCurrency.convert(rightAmount, to: leftCurrency)
        }
        .onChange(of: rightCurrency) { _ , _ in
            rightAmount = leftCurrency.convert(leftAmount, to: rightCurrency)
        }
        .sheet(isPresented: $showExchangeInfo) {
            ExchangeInfo()
        }
        .sheet(isPresented: $showSelectCurrency) {
            SelectCurrency(topCurrency: $leftCurrency, bottomCurrency: $rightCurrency)
        }
    }
}

#Preview {
    ContentView()
}
