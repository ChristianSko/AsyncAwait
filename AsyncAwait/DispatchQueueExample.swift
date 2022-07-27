//
//  DispatchQueueExample.swift
//  AsyncAwait
//
//  Created by Skorobogatow, Christian on 27/7/22.
//

import SwiftUI

class DispatchQueueViewModel: ObservableObject {
    
    @Published var dataArray: [String] = []
    
    func addTitle1() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dataArray.append("Title1 : \(Thread.current)")
        }
    }

    func addTitle2() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            let title = "Title2 : \(Thread.current)"
            DispatchQueue.main.async {
                self.dataArray.append(title)

                let title3 =  "Title3 : \(Thread.current)"
                self.dataArray.append(title3)
            }

        }
    }
    
}


struct DispatchQueueExample: View {
    @StateObject private var viewModel = DispatchQueueViewModel()
    
    
    var body: some View {
        List {
            ForEach(viewModel.dataArray, id: \.self) { data in
                Text(data)
            }
        }
        .onAppear {
            viewModel.addTitle1()
            viewModel.addTitle2()
        }
    }
}

struct DispatchQueueExample_Previews: PreviewProvider {
    static var previews: some View {
        DispatchQueueExample()
    }
}
