//
//  ContentView.swift
//  boiKhata
//
//  Created by Dhruba Chakraborty on 31/3/22.
//

import SwiftUI
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore
import MobileCoreServices
class AppViewModel: ObservableObject{
    
    let auth = Auth.auth()
    
    @Published var signedIn = false
    @Published var list = [Info]()
    
    func addData(name: String, email: String, phone: String, count: String, color: String, address: String){
        
        let db = Firestore.firestore()
        
        db.collection("Info").addDocument(data: ["name": name, "email": email, "phone": phone, "count": count, "color": color, "address": address]) { error in
            
            if error == nil {
//                self.getData()
            }
            else{
                
            }
        }
        
    }
    
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
                VStack{
                    DocumentView()
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

struct DocumentPicker : UIViewControllerRepresentable {
    func makeCoordinator() -> DocumentPicker.Coordinator {
        return DocumentPicker.Coordinator(parent1: self)
    }
    @Binding var alert: Bool
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .open)
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DocumentPicker>) {
        
    }
    class Coordinator: NSObject, UIDocumentPickerDelegate{
        var parent : DocumentPicker
        init(parent1: DocumentPicker){
            parent = parent1
        }
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]){
            let bucket = Storage.storage().reference()
            bucket.child((urls.first?.deletingPathExtension().lastPathComponent)!).putFile(from: urls.first!, metadata: nil) {
                (_, err) in
                
                if err != nil{
                    print((err?.localizedDescription)!)
                    return
                }
                print("Success")
                self.parent.alert.toggle()
            }
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
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding()
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
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
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
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
struct DocumentView: View{
    @State var show = false
    @EnvironmentObject var viewModel: AppViewModel
    @State private var showingAlert = false
    @State var alert = false
    @State var name = ""
    @State var email = ""
    @State var phone = ""
    @State var count = ""
    @State var color = ""
    @State var address = ""
    var body: some View {
        NavigationView{
            
            VStack(spacing: 10){
                Image("logo")
                    .resizable()
//                    .scaledToFit()
                    .frame(width: 100, height: 100)
                Text("1. Rename the pdf file to your phone number\n2. Pick the pdf file and wait for confirmation\n3. Fill up the form and submit\nWe will call you as soon as we get your request")
//                .lineSpacing(10)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
            Text("Pick the document you want to print:")
    Button(action: {
        self.show.toggle()
    }){
    Text("Pick your document")
            .sheet(isPresented: $show){
                DocumentPicker(alert: self.$alert)
            }
            .alert(isPresented: $alert){
                Alert(title: Text("Message"), message: Text("Uploaded Successfully!\nFill up the form below and submit"), dismissButton: .default(Text("Ok")))
            }
            }
                Group{
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .autocapitalization(.none)
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .autocapitalization(.none)
            TextField("Phone", text: $phone)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .autocapitalization(.none)
            TextField("Copies", text: $count)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .autocapitalization(.none)
            TextField("Color/b&w", text: $color)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .autocapitalization(.none)
            TextField("Address", text: $address)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .autocapitalization(.none)
                }
            Button(action: {
                
                viewModel.addData(name: name, email: email, phone: phone, count: count, color: color, address: address)
                
                name = ""
                email = ""
                phone = ""
                count = ""
                color = ""
                address = ""
                showingAlert = true
            }, label: {
                Text("Submit")
            })
            .alert("Order Done\nWait for the confirmation", isPresented: $showingAlert) {
                        Button("OK", role: .cancel) { }
                    }
        }
        }
        .navigationTitle("Welcome to Boi Khata")
        .toolbar{
            Button(action: {
                viewModel.signOut()}, label: {
                Text("Sign Out")
                    .foregroundColor(Color.purple)
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

