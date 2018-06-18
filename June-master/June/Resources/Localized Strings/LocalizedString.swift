//
//  LocalizedString.swift
//  June
//
//  Created by Tatia Chachua on 02/01/18.
//  Copyright © 2018 Joshua Cleetus. All rights reserved.
//

enum LocalizedString: String {
    
    // NavBar Title
    case NavBarDone
    case NavBarCancel
    case NavBarEdit
    case NavBarSend
    case NavBarClose
    case NavBarAdd
    case NavBarSave
    case NavBarDelete
    case NavBarClaim
    case NavBarNext
    case NavBarLoad
    
    // LoginViewController
    case LoginViewLoginButtonTitle
    case LoginViewLoginLabelTitle
    case LoginViewUsernameInfoPlaceholderTitle
    case LoginViewPasswordInfoPlaceholderTitle
    case LoginViewDontHaveAccountLabelTitle
    case LoginViewForgotPasswordButtonTitle
    case LoginViewSignUpButtonTitle
    case LoginViewErrorMessageUsernameTooShort
    case LoginViewErrorMessageUsernameRequirement
    case LoginViewErrorMessagePasswordRequirement
    case LoginViewErrorMessagePasswordLength
    
    // ForgotPasswordViewController
    case ForgotPasswordViewBackButtonTitle
    case ForgotPasswordViewEnterInfoLabel
    case ForgotPasswordViewUsernameTextFieldPlaceholder
    case ForgotPasswordViewSendLinkButtonTitle
    
    // SentEmailViewController
    case SentEmailViewSentLinkLabelTitle
    case SentEmailViewExpireLabelTitle
    case SentEmailViewOpenEmailLabel
    case SentEmailViewDeleyTimeLabel
    case SentEmailViewResendEmailLabel
    case SentEmailViewBackToButtonTitle
    
    // SettingsViewController
    case SettingsViewTitleLabel
    case SettingsViewUserNameLabel
    case SettingsViewChangePasswordLabel
    case SettingsViewPasswordLabel
    case SettingsViewReceiveNotificationsLabel
    case SettingsViewSignOutLabelTitle
    case SettingsViewNewPasswordTextFieldTitle
    case SettingsViewChangePasswordFieldPlaceholderTitle
    case SettingsViewOriginalPasswordPlaceholderTitle
    case SettingsViewErrorAlertOldPasswordRequirement
    case SettingsViewErrorAlertNewPasswordRequirement
    case SettingsViewErrorAlertReenterNewPassword
    case SettingsViewErrorAlertNewPasswordMatch
    case SettingsViewErrorAlertNewPasswordCannotMatchOldOne
    case SettingsViewErrorAlertwrongOldPassword
    case SettingsViewErrorAlert8CharacterRequired
    case SettingsViewErrorAlertNumbersCharacterRequirement
    case SettingsViewErrorAlertCheckPassword
    case SettingsViewSuccessAlertPasswordChanged
    case SettingsViewErrorAlertSomethingWrong
    case SettingsViewSaveChangesButtonTitle
    case SettingsViewSettingsForFeedTitle
    case SettingsViewBottomEditButtonTitle
    case SettingsViewEditAccountsTitle
    case SettingsViewEditButtonTitle
    case SettingsViewAddAccountButtonTitle
    case SettingsViewEditButtonDoneTitle
    case SettingsViewEditNameButtonTitle
    
    // AddAccountViewController
    case AddAccountViewTitleLabel
    case AddAccountViewAlertPasswordTitle
    case AddAccountViewAlertPasswordMessageTitle
    case AddAccountViewAlertActionContinueTitle
    case AddAccountViewAlertActionCancelTitle
    case AddAccountViewAlertTextFieldPlaceholderTitle
    
    // AddAccountAlertViewController
    case AddAccountAlertViewTitleLabel
    case AddAccountAlertViewEmailPlaceholderTitle
    case AddAccountAlertViewErrorLabelTitle
    case AddAccountAlertViewErrorAlertTitle
    case AddAccountAlertViewSuccessLabelTitle
    
    // AccountsViewController
    case AccountsViewViewAllLabel
    case AccountsViewEmailAccountsLabelTitle
    case AccountsViewEditLabelTitle
    case AccountsViewSettingsButtonTitle
    case AccountsViewHelpButtonTitle
    case AccountsViewAddAccountButtonTitle
    case AccountsViewSpamButtonTitle
    
    // StarredViewController
    case StarredViewMessageButtonTitle
    case StarredViewFeedButtonTitle
    
    // ThreadsViewController
    case ThreadsViewNewConversationsButtonTitle
    case ThreadsViewConversationsButtonTitle
    case ThreadsViewNoNewMessageLabelTitle
    
    // ThreadsDetailViewController
    case ThreadsDetailViewActionSheetTitle
    case ThreadsDetailViewActionSheetConversationsTitle
    case ThreadsDetailViewActionSheetPromotionsTitle
    case ThreadsDetailViewActionSheetNotificationsTitle
    case ThreadsDetailViewActionSheetTripsTitle
    case ThreadsDetailViewActionSheetPurchasesTitle
    case ThreadsDetailViewActionSheetFinanceTitle
    case ThreadsDetailViewActionSheetSocialTitle
    case ThreadsDetailViewActionSheetNewsTitle
    
    // GenericEmailViewController
    case GenericEmailViewBackButtonTitle
    case GenericEmailViewEnterPasswordLabelTitle
    case GenericEmailViewPasswordInfoPlaceholderTitle
    case GenericEmailViewNextButtonTitle
    
    // SignUpViewController
    case SignUpViewSignUpLabelTitle
    case SignUpViewIamJuneLabelTitle
    case SignUpViewUsernameFieldPlaceholder
    case SignUpViewPasswordFieldPlaceholder
    case SignUpViewHaveAnAccountLabelTitle
    case SignUpViewSignUpButtonTitle
    case SignUpViewLogInButtonTitle
    case SignUpViewErrorAertUsernameTooShort
    case SignUpViewErrorAlertUsernameRequirement
    case SignUpViewErrorAlertPasswordRequirement
    case SignUpViewErrorAlertPasswordLength
    case SignUpViewErrorAlertPasswordLettersNumbersRequirement
    
    // EmailDiscoveryViewController
    case EmailDiscoveryViewBackButtonTitle
    case EmailDiscoveryViewLinkLabelTitle
    case EmailDiscoveryViewEmailInfoTitle
    case EmailDiscoveryViewNextButtonTitle
    case EmailDiscoveryViewErrorAlertEmailRequirement
    case EmailDiscoveryViewErrorAlertEnterValidEmail
    
    // HomeViewController
    case HomeViewTabOneTitle
    case HomeViewTabTwoTitle
    case HomeViewTabFourTitle
    case HomeViewTabFiveTitle
    
    // ConvosViewController
    case ConvosToDoTitle
    case ConvosNewHeader
    case ConvosNoNewItemsTitle
    case ConvosNoNewOrSeenItemsTitle
    case ConvosViewAllButtonTitle
    case ConvosCollapseButtonTitle
    case ConvosSeenHeader
    case ConvosClearedTitle
    case ConvosLoaderTitle
    case ConvosSeparatorTitle
    
    // RolodexsViewController
    case RolodexsLoaderTitle
    case RolodexsSeparatorTitle
    
    // Romio Alert View
    case RomioAlertViewNoButtonTitle
    case RomioAlertViewYesButtonTitle
    case RomioAlertViewOKButtonTitle
    case RomioAlertViewApplyTotalButtonTitle
    case RomioAlertViewAddCustomTotalMessage
    case RomioAlertViewSetFullCostMessage
    
    // SettingsForFeedEditAction (SettingsViewController)
    case SettingsForFeedTitle
    case SettingsViewEditPopupDescriptionTitle
    case SettingsViewEditPopupCategoriesTitle
    case SettingsViewEditPopupBatchTitle
    case SettingsViewEditPopupNewsTitle
    case SettingsViewEditPopupPromosTitle
    case SettingsViewEditPopupSocialTitle
    case SettingsViewEditPopupTripsTitle
    case SettingsViewEditPopupPurchasesTitle
    case SettingsViewEditPopupFinanceTitle
    case SettingsViewEditPopupMiniPopupTitle
    case SettingsViewEditPopupDescriptionForNewsInfo
    case SettingsViewEditPopupDescriptionForPromosInfo
    case SettingsViewEditPopupDescriptionForSocialInfo
    case SettingsViewEditPopupDescriptionForTripsInfo
    case SettingsViewEditPopupDescriptionForPurchasesInfo
    case SettingsViewEditPopupDescriptionForFinanceInfo
    
    // SettingsInfoAlertsUIAction (SettingsViewController)
    case SettingsViewInfoAlertAutoRespondTitle
    case SettingsViewInfoAlertTitle
    case SettingsViewInfoAlertDescriptionLabelTitle
    
    // FavoritesViewController
    case FavoritesViewComingSoonLabelTotle
    
    // FullEmailViewController
    case fullEmailViewTopFullEmailTitle
    
    var commentValue: String {
        get {
            switch self {
            case .NavBarDone, .NavBarCancel, .NavBarEdit, .NavBarSend, .NavBarClose, .NavBarAdd, .NavBarSave, .NavBarDelete, .NavBarClaim, .NavBarNext, .NavBarLoad:
                return "NavBar Titles"
            case .LoginViewLoginButtonTitle, .LoginViewLoginLabelTitle, .LoginViewUsernameInfoPlaceholderTitle, .LoginViewPasswordInfoPlaceholderTitle, .LoginViewDontHaveAccountLabelTitle, .LoginViewForgotPasswordButtonTitle, .LoginViewSignUpButtonTitle, .LoginViewErrorMessageUsernameTooShort, .LoginViewErrorMessageUsernameRequirement, .LoginViewErrorMessagePasswordRequirement, .LoginViewErrorMessagePasswordLength:
                return "LoginViewController"
            case .ForgotPasswordViewBackButtonTitle, .ForgotPasswordViewEnterInfoLabel, .ForgotPasswordViewUsernameTextFieldPlaceholder, .ForgotPasswordViewSendLinkButtonTitle:
                return "ForgotPasswordViewController"
            case .SentEmailViewSentLinkLabelTitle, .SentEmailViewExpireLabelTitle, .SentEmailViewOpenEmailLabel, .SentEmailViewDeleyTimeLabel, .SentEmailViewBackToButtonTitle, .SentEmailViewResendEmailLabel:
                return "SentEmailViewController"
            case .SettingsViewTitleLabel, .SettingsViewUserNameLabel, .SettingsViewChangePasswordLabel, .SettingsViewPasswordLabel, .SettingsViewReceiveNotificationsLabel, .SettingsViewSignOutLabelTitle, .SettingsViewNewPasswordTextFieldTitle, .SettingsViewChangePasswordFieldPlaceholderTitle, .SettingsViewOriginalPasswordPlaceholderTitle, .SettingsViewErrorAlertOldPasswordRequirement, .SettingsViewErrorAlertNewPasswordRequirement, .SettingsViewErrorAlertReenterNewPassword, .SettingsViewErrorAlertNewPasswordMatch, .SettingsViewErrorAlertNewPasswordCannotMatchOldOne, .SettingsViewErrorAlertwrongOldPassword, .SettingsViewErrorAlert8CharacterRequired, .SettingsViewErrorAlertNumbersCharacterRequirement, .SettingsViewErrorAlertCheckPassword, .SettingsViewSuccessAlertPasswordChanged, .SettingsViewErrorAlertSomethingWrong, .SettingsViewSaveChangesButtonTitle, .SettingsViewSettingsForFeedTitle, .SettingsViewBottomEditButtonTitle, .SettingsViewEditAccountsTitle, .SettingsViewEditButtonTitle, .SettingsViewAddAccountButtonTitle, .SettingsViewEditButtonDoneTitle, .SettingsViewEditNameButtonTitle:
                return "SettingsViewController"
            case .AddAccountViewTitleLabel, .AddAccountViewAlertPasswordTitle, .AddAccountViewAlertPasswordMessageTitle, .AddAccountViewAlertActionContinueTitle, .AddAccountViewAlertActionCancelTitle, .AddAccountViewAlertTextFieldPlaceholderTitle:
                return "AddAccountViewController"
            case .AddAccountAlertViewTitleLabel, .AddAccountAlertViewEmailPlaceholderTitle, .AddAccountAlertViewErrorLabelTitle, .AddAccountAlertViewErrorAlertTitle, .AddAccountAlertViewSuccessLabelTitle:
                return "AddAccountAlertViewController"
            case .AccountsViewViewAllLabel, .AccountsViewEmailAccountsLabelTitle, .AccountsViewEditLabelTitle, .AccountsViewSettingsButtonTitle, .AccountsViewHelpButtonTitle, .AccountsViewAddAccountButtonTitle, .AccountsViewSpamButtonTitle:
                return "AccountsViewController"
                
                case .StarredViewMessageButtonTitle, .StarredViewFeedButtonTitle:
                return "StarredViewController"
                
                case .ThreadsViewNewConversationsButtonTitle, .ThreadsViewConversationsButtonTitle, .ThreadsViewNoNewMessageLabelTitle:
                return "ThreadsViewController"
                
            case .ThreadsDetailViewActionSheetTitle, .ThreadsDetailViewActionSheetConversationsTitle, .ThreadsDetailViewActionSheetPromotionsTitle, .ThreadsDetailViewActionSheetNotificationsTitle, .ThreadsDetailViewActionSheetTripsTitle, .ThreadsDetailViewActionSheetPurchasesTitle, .ThreadsDetailViewActionSheetFinanceTitle, .ThreadsDetailViewActionSheetSocialTitle, .ThreadsDetailViewActionSheetNewsTitle:
                return "ThreadsDetailViewController"
            case .GenericEmailViewBackButtonTitle, .GenericEmailViewEnterPasswordLabelTitle, .GenericEmailViewPasswordInfoPlaceholderTitle, .GenericEmailViewNextButtonTitle:
                return "GenericEmailViewController"
            case .SignUpViewSignUpLabelTitle, .SignUpViewIamJuneLabelTitle, .SignUpViewUsernameFieldPlaceholder, .SignUpViewPasswordFieldPlaceholder, .SignUpViewHaveAnAccountLabelTitle, .SignUpViewSignUpButtonTitle, .SignUpViewLogInButtonTitle, .SignUpViewErrorAertUsernameTooShort, .SignUpViewErrorAlertUsernameRequirement, .SignUpViewErrorAlertPasswordRequirement, .SignUpViewErrorAlertPasswordLength, .SignUpViewErrorAlertPasswordLettersNumbersRequirement:
                return "SignUpViewController"
            case .EmailDiscoveryViewBackButtonTitle, .EmailDiscoveryViewLinkLabelTitle, .EmailDiscoveryViewEmailInfoTitle, .EmailDiscoveryViewNextButtonTitle, .EmailDiscoveryViewErrorAlertEmailRequirement, .EmailDiscoveryViewErrorAlertEnterValidEmail:
                return "EmailDiscoveryViewController"
            
                case .HomeViewTabOneTitle, .HomeViewTabTwoTitle, .HomeViewTabFourTitle, .HomeViewTabFiveTitle:
                return "HomeViewController"
            case .ConvosToDoTitle, .ConvosNoNewItemsTitle, .ConvosNoNewOrSeenItemsTitle, .ConvosNewHeader, .ConvosViewAllButtonTitle, .ConvosCollapseButtonTitle, .ConvosSeenHeader, .ConvosClearedTitle, .ConvosLoaderTitle, .ConvosSeparatorTitle:
                return "ConvosViewController"
                
                case .RolodexsLoaderTitle, .RolodexsSeparatorTitle:
                return "RolodexsViewController"
            case .RomioAlertViewNoButtonTitle, .RomioAlertViewYesButtonTitle, .RomioAlertViewOKButtonTitle, .RomioAlertViewApplyTotalButtonTitle, .RomioAlertViewAddCustomTotalMessage, .RomioAlertViewSetFullCostMessage:
                return "RomioAlertView"
            case .SettingsForFeedTitle, .SettingsViewEditPopupDescriptionTitle, .SettingsViewEditPopupCategoriesTitle, .SettingsViewEditPopupBatchTitle, .SettingsViewEditPopupNewsTitle, .SettingsViewEditPopupPromosTitle, .SettingsViewEditPopupSocialTitle, .SettingsViewEditPopupTripsTitle, .SettingsViewEditPopupPurchasesTitle, .SettingsViewEditPopupFinanceTitle, .SettingsViewEditPopupMiniPopupTitle, .SettingsViewEditPopupDescriptionForNewsInfo, .SettingsViewEditPopupDescriptionForPromosInfo, .SettingsViewEditPopupDescriptionForSocialInfo, .SettingsViewEditPopupDescriptionForTripsInfo, .SettingsViewEditPopupDescriptionForPurchasesInfo, .SettingsViewEditPopupDescriptionForFinanceInfo:
                return "SettingsForFeedEditAction"
                
            case .SettingsViewInfoAlertAutoRespondTitle, .SettingsViewInfoAlertTitle, .SettingsViewInfoAlertDescriptionLabelTitle:
                return "SettingsInfoAlertsUIAction"
                
            case .FavoritesViewComingSoonLabelTotle:
                return "FavoritesViewController"
                
            case .fullEmailViewTopFullEmailTitle:
                return "FullEmailViewController"
                

            }
            
        }
    }
}

struct Localized {
    
    static func string(forKey key: LocalizedString) -> String {
        return NSLocalizedString(key.rawValue, comment: key.commentValue)
    }
    
}
