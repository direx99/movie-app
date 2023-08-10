//
//  SignupView.swift
//  SignUp Login App
//
//  Created by Dinith Hasaranga on 2023-02-20.
//

import SwiftUI
import Firebase
struct SignupView: View {
    
    @State var email = ""
    @State var password = ""
    @State private var showPassword = false
    @State private var agreed = false
    @State private var isLoginMode = false
    @State private var showAlert = false

    
    @State var isOn: Bool = false
    
    init() {
        
        if(FirebaseApp.app() == nil){
            FirebaseApp.configure()
        }
    }

    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                Image("imglogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding(.bottom,-120)
                    .padding(.top)
                VStack(alignment: .leading){
                    Group{
                        
                        
                        Text("Create Account")
                            .font(.largeTitle)
                            .foregroundColor(Color("AppSecondaryColor")).bold()
                            .padding(.top,20 )
                        
                        Text("Connect with your friends today!")
                            .font(.body)
                            .foregroundColor(Color("AppGray"))
                            .padding(.bottom,40 )
                       
                        
                        
                        
                        Text("Email Address")
                            .font(.headline)
                            .padding(.vertical,-2)
                        
                        
                        TextField("Enter your email", text: $email)
                            .font(.body)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled(true)
                        //.autocapitalization(false)
                            .padding(.vertical,12)
                            .padding(.horizontal,15)
                            .frame(height: 40)
                            .background(Color("AppPrimaryColor"))
                        
                        
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1)
                                
                            )
                            .onTapGesture {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                            .padding(.bottom ,10)
                        
                        
                        
                        Text("Password")
                            .font(.headline)
                            .padding(.vertical,-2)
                        
                        
                        HStack {
                            if showPassword {
                                TextField("Enter your password", text: $password)
                            } else {
                                SecureField("Enter your password", text: $password)
                            }
                            Button(action: {
                                showPassword.toggle()
                            }) {
                                Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(.black)
                            }
                            
                        }.padding(.vertical,12)
                            .font(.body)
                            .padding(.horizontal,15)
                            .background(Color("AppPrimaryColor"))
                            .frame(height: 40)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1)
                                
                            )
                        
                        
                    }
                    
                    
                    
                    
                    
                    .padding(.vertical, 5)
                    
                    
                    
                    Spacer()
                    
                    
                    Button(action: {
                        handleAction()
                    }) {
                        Text("Sign Up")
                            .foregroundColor(.white)
                            .font(.headline)
                            . frame(maxWidth: . infinity)
                            .padding(.vertical,12)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 1)
                                
                            )
                        
                    }
                    .padding(.top ,20)
                    .padding(.bottom ,20)
                    
                  
                    
                }
                .padding(.horizontal,20)
                
                
            }
           
            

            
            
            
            
            Spacer()
            HStack{
                Text("Already have an account?")
                    .foregroundColor(.gray)
                NavigationLink(destination: LoginView()){
                    
                    
                    Text("Login")
                        .foregroundColor(Color.blue)
                        .font(.headline)
                    
                    
                }
            }
            .padding(.bottom)
            
            
            
            
        }
        .onTapGesture {
            hideKeyboard()
        }
        .alert(isPresented: $showAlert) {
                    Alert(title: Text("Success"), message: Text("Signup Successful"), dismissButton: .default(Text("OK")) {
                        // Dismiss the view when the alert is dismissed
                        presentationMode.wrappedValue.dismiss()
                    })
                }
        
        
    }
    private func handleAction() {
        if isLoginMode {
            print("Should log into Firebase with existing credentials")
        } else {
            createNewAccount()
        }
    }
    
    private func createNewAccount() {
        Auth.auth().createUser(withEmail: email, password: password){
            result, err in
            if let err = err {
                print("failed to create user: ", err)
                return
            }
            print("Successfully created user \(result?.user.uid ?? "")")
            showAlert = true
        }
        
    }
    
    
    
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
