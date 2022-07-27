//
//  ContentView.swift
//  AsyncAwait
//
//  Created by Skorobogatow, Christian on 27/7/22.
//

import SwiftUI



class AsyncAwaitViewModel: ObservableObject {
    
    @Published var dataArray: [String] = []
    
    func author1() async {
        let author1 = "Author1 : \(Thread.current)"
        self.dataArray.append(author1)
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        let author2 = "Author2 : \(Thread.current)"
        await MainActor.run(body: {
            self.dataArray.append(author2)
            
            let author3 = "Author3 : \(Thread.current)"
            self.dataArray.append(author3)
        })
        
        await addSomething()
    }
    
    
    func addSomething () async {
       
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        let something1 = "something1 : \(Thread.current)"
        await MainActor.run(body: {
            self.dataArray.append(something1)
            
            let something2 = "something2 : \(Thread.current)"
            self.dataArray.append(something2)
        })
    }
}

struct AsyncAwaitExample: View {
    
    @StateObject private var viewModel = AsyncAwaitViewModel()
    
    
    var body: some View {
        List {
            ForEach(viewModel.dataArray, id: \.self) { data in
                Text(data)
            }
        }
        .task {
            await viewModel.author1()
            await viewModel.addSomething()
            
            let finalText = "Final Text: \(Thread.current)"
            viewModel.dataArray.append(finalText)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AsyncAwaitExample()
    }
}
