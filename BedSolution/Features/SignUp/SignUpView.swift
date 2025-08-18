//
//  SignUpView.swift
//  BedSolution
//
//  Created by 이재호 on 7/28/25.
//

import SwiftUI
import AuthenticationServices
import Logging

struct SignUpView: View {
    @Environment(\.theme) private var theme
    @FocusState private var keyboardScope: KeyboardScope?
    @State private var authController = AuthController.shared
    @State private var email = ""
    @State private var password = ""
    @State private var passwordConfirmation = ""
    @State private var state = SignUpState.idle
    @State private var isSigning = false
    @State private var errorOccurred: Bool = false
    @State private var signupError: SignUpError?
    @State private var registerPatient: Bool = false
    private let logger = Logger(label: "SignUPView")

    private enum SignUpState {
        case idle, signin, signup
    }
    
    private enum KeyboardScope {
        case email, password, passwordConfirmation
    }
    
    private enum SignUpError: LocalizedError {
        case signupFailed
        case signinFailed
        
        var errorDescription: String? {
            switch self {
            case .signupFailed:
                "Sign up failed. Please try again."
            case .signinFailed:
                "Sign in failed. Please try again."
            }
        }
    }
    
    private var signInForm: some View {
        VStack {
            TextField("이메일", text: $email, prompt: Text("이메일"))
                .textContentType(.emailAddress)
                .labelsHidden()
                .textStyle(theme.textTheme.bodyLarge)
                .roundedTextFieldStyle()
                .focused($keyboardScope, equals: .email)
                .onSubmit {
                    keyboardScope = .password
                }
            
            SecureField("비밀번호", text: $password, prompt: Text("비밀번호"))
                .textContentType(.password)
                .labelsHidden()
                .textStyle(theme.textTheme.bodyLarge)
                .roundedTextFieldStyle()
                .focused($keyboardScope, equals: .password)
        }
    }
    
    private var signUpForm: some View {
        VStack {
            TextField("이메일", text: $email, prompt: Text("이메일"))
                .textContentType(.emailAddress)
                .labelsHidden()
                .textStyle(theme.textTheme.bodyLarge)
                .roundedTextFieldStyle()
                .focused($keyboardScope, equals: .email)
                .onSubmit {
                    keyboardScope = .password
                }
            
            SecureField("비밀번호", text: $password, prompt: Text("비밀번호"))
                .textContentType(.password)
                .labelsHidden()
                .textStyle(theme.textTheme.bodyLarge)
                .roundedTextFieldStyle()
                .focused($keyboardScope, equals: .password)
                .onSubmit {
                    keyboardScope = .passwordConfirmation
                }
            
            SecureField("비밀번호 재입력", text: $passwordConfirmation, prompt: Text("비밀번호 재입력"))
                .textContentType(.password)
                .labelsHidden()
                .textStyle(theme.textTheme.bodyLarge)
                .roundedTextFieldStyle()
                .focused($keyboardScope, equals: .passwordConfirmation)
        }
    }
    
    var body: some View {
        let headerLayout = state == .idle ? AnyLayout(VStackLayout(alignment: .center, spacing: 0)): AnyLayout(HStackLayout(alignment: .center, spacing: 8))
        NavigationStack {
            VStack {
                if state == .idle {
                    Spacer()
                }
                
                headerLayout {
                    Image(.bedSolutionIcon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: state == .idle ? 190: 80, height: state == .idle ? 190: 80)
                    VStack(alignment: state == .idle ? .center: .leading, spacing: 2) {
                        Text("Bed Solution")
                            .textStyle(state == .idle ? theme.textTheme.emphasizedDisplaySmall: theme.textTheme.emphasizedTitleMedium)
                            .foregroundColorSet(theme.colorTheme.onSurface)
                        Text("욕창 방지 솔루션")
                            .textStyle(theme.textTheme.bodyLarge)
                            .foregroundColorSet(theme.colorTheme.onSurfaceVarient)
                    }
                }
                
                Spacer()
                
                if state == .signin {
                    signInForm
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 50, trailing: 0))
                } else if state == .signup {
                    signUpForm
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 50, trailing: 0))
                }
                
                if state != .idle {
                    Spacer()
                }
                
                VStack(spacing: 8) {
                    if state != .signin {
                        Button(action: signUp) {
                            HStack {
                                if isSigning {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                }
                                Text("회원가입")
                                    .textStyle(theme.textTheme.emphasizedBodyLarge)
                            }
                            .frame(minWidth: 300, maxWidth: 400)
                        }
                        .buttonStyle(
                            type: .emphasized,
                            option: .fiilled,
                            primary: theme.colorTheme.primary,
                            onPrimary: theme.colorTheme.onPrimary
                        )
                        .disabled(state == .signup && (email.isEmpty || password.isEmpty || password != passwordConfirmation))
                    }
                    if state != .signup {
                        Button(action: signIn) {
                            HStack {
                                if isSigning {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                }
                                Text("로그인")
                                    .textStyle(theme.textTheme.emphasizedBodyLarge)
                            }
                            .frame(minWidth: 300, maxWidth: 400)
                        }
                        .buttonStyle(
                            type: .emphasized,
                            option: state == .signin ? .fiilled: .outline,
                            primary: theme.colorTheme.primary,
                            onPrimary: theme.colorTheme.onPrimary
                        )
                        .disabled(state == .signin && (email.isEmpty || password.isEmpty))
                    }
                    if state != .idle {
                        Button(action: backToStart) {
                            Text("뒤로가기")
                                .textStyle(theme.textTheme.labelLarge)
                                .foregroundColorSet(theme.colorTheme.tertiary)
                        }
                        .padding(EdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0))
                    }
                }
                .disabled(isSigning)
            }
            .padding(EdgeInsets(top: 0, leading: 25, bottom: 30, trailing: 25))
            .backgroundColorSet(theme.colorTheme.surface)
            .ignoresSafeArea(.keyboard)
            .navigationDestination(isPresented: $registerPatient) {
                PatientRegisterView()
            }
        }
        .alert(isPresented: $errorOccurred, error: signupError) { _ in
            Button(action: { signupError = nil ; errorOccurred = false }) {
                Text("확인")
            }
        } message: { error in
            Text(error.localizedDescription)
        }
    }
    
    private func signUp() {
        if state != .signup {
            withAnimation(.default) { state = .signup }
            return
        }
        keyboardScope = .none
        isSigning = true
        Task {
            let isSuccess = await authController.signup(email: email, password: password)
            logger.info("Success to sign up")
            isSigning = false
            if !isSuccess {
                errorOccurred = true
                signupError = .signupFailed
                return
            }
            if !(await authController.isPatientRegistered()) {
                logger.info("Patient is not exit. Navigating to register patient page.")
                registerPatient = true
                return
            }
            logger.info("Patient is exit. Signing in.")
        }
    }
    
    private func signIn() {
        if state != .signin {
            withAnimation(.default) { state = .signin }
            return
        }
        keyboardScope = .none
        isSigning = true
        Task {
            let isSuccess = await authController.signin(email: email, password: password)
            logger.info("Success to sign in")
            isSigning = false
            if !isSuccess {
                errorOccurred = true
                signupError = .signinFailed
                return
            }
            if !(await authController.isPatientRegistered()) {
                logger.info("Patient is not exit. Navigating to register patient page.")
                registerPatient = true
                return
            }
            logger.info("Patient is exit. Signing in.")
        }
    }
    
    private func backToStart() {
        removeFieldValue()
        withAnimation(.default) { state = .idle }
    }
    
    private func removeFieldValue() {
        password.removeAll()
        passwordConfirmation.removeAll()
        email.removeAll()
    }
}

#Preview {
    SignUpView()
}
