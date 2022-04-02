//
//  ContentView.swift
//  boiKhata
//
//  Created by Dhruba Chakraborty on 31/3/22.
//

import SwiftUI
import FirebaseAuth
class AppViewModel: ObservableObject{
    
    let auth = Auth.auth()
    
    @Published var signedIn = false
    
    var isSignedIn: Bool{
        return auth.currentUser != nil
    }
    func signIn(email: String, password: String){
        auth.signIn(withEmail: email, password: password) { [weak self]
            result, error in
            guard result != nil, error == nil else {
                return
            }
            DispatchQueue.main.async {
                //success
                    self?.signedIn = true
            }
        }
        
    }
    func signUp(email: String, password: String){
        auth.createUser(withEmail: email, password: password) { [weak self]
            result, error in
            guard result != nil, error == nil else {
                return
            }
            DispatchQueue.main.async {
                //success
                    self?.signedIn = true
            }
    }
    }
        func signOut() {
            try? auth.signOut()
            
            self.signedIn = false
        }
}


struct ContentView: View {
    @EnvironmentObject var viewModel: AppViewModel
    var body: some View {
        NavigationView {
            if viewModel.signedIn {
                VStack {
                    Text("You are signed in")
                    
                    Button(action: {
                        viewModel.signOut()}, label: {
                        Text("Sign Out")
                            .foregroundColor(Color.purple)
                    })
                }
                
            }
            else {
                SignInView()
                
            }
        }
        .onAppear{
            viewModel.signedIn = viewModel.isSignedIn
        }
    }
}
    
    struct SignInView: View {
        @State var email = ""
        @State var password = ""
        @EnvironmentObject var viewModel: AppViewModel
        var body: some View {
                VStack {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                
                VStack {
                    TextField("Email Address", text: $email)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding()
                    SecureField("Password", text: $password)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding()
                    
                    Button(action: {
                        
                        guard !email.isEmpty, !password.isEmpty else{
                            return
                        }
                        
                        viewModel.signIn(email: email, password: password)
                        
                    }, label: {
                        Text("Sign in")
                            .foregroundColor(Color.white)
                            .frame(width: 200, height: 50)
                            .background(Color.purple)
                            .cornerRadius(8)
                    })
                    
                    NavigationLink("Create Account", destination: SignUpView())
                        .padding()
                }
                .padding()
                    Spacer()
                }
                .navigationTitle("Sign In")
            }
    }

struct SignUpView: View {
    @State var email = ""
    @State var password = ""
    @EnvironmentObject var viewModel: AppViewModel
    var body: some View {
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
            
            VStack {
                TextField("Email Address", text: $email)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                SecureField("Password", text: $password)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                
                Button(action: {
                    
                    guard !email.isEmpty, !password.isEmpty else{
                        return
                    }
                    
                    viewModel.signUp(email: email, password: password)
                    
                }, label: {
                    Text("Create account")
                        .foregroundColor(Color.white)
                        .frame(width: 200, height: 50)
                        .background(Color.purple)
                        .cornerRadius(8)
                })
            }
            .padding()
                Spacer()
            }
            .navigationTitle("Create an account")
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

