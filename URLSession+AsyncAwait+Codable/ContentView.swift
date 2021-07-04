//
//  ContentView.swift
//  URLSession+AsyncAwait+Codable
//
//  Created by h.crane on 2021/06/22.
//

import SwiftUI

@available(iOS 15, *)
struct ContentView:  View {
    
    private var useCase: APIUseCasable = APIUseCase()
    
    var body: some View {
        EmptyView()
            .task {
                await useCase.inputs.fetch()
            }
            .onReceive(useCase.outputs.users) { users in
                print("users: ", users)
            }
    }
}

@available(iOS 15, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
