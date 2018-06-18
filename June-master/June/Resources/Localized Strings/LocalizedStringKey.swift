//
//  LocalizedStringKey.swift
//  June
//
//  Created by Joshua Cleetus on 7/20/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

struct LocalizedStringKey {
    
    struct SignUpScreenViewHelper {
        static let errorMessage1 = "Username must be at least 3 characters long"
        static let errorMessage2 = "Username is a required field"
        static let errorMessage3 = "Password is a required field"
        static let errorMessage4 = "Password must be at least 8 characters long"
        static let errorMessage5 = "Password should have letters and numbers"
        static let errorMessage6 = "Invalid Username or Password!"
        static let errorMessage7 = "Username is taken!"
        static let errorMessage8 = "Could not create the user"
        static let loading = "Loading..."
        static let authenticating = "Authenticating..."
        static let getStartedLabelText = "Hey, sign up to get started."
        static let usernameInfoPlaceholder = "Create your username"
        static let passwordInfoPlaceholder = "Create your password"
        static let signUpButtonTitle = "Sign up"
        static let haveAnAccountLabelText = "Already have an account?"
        static let logInButtonTitle = "Log in"
    }
    
    struct EmailDiscoveryViewHelper {
        static let gmail = "gmail"
    }
    
    struct LoginScreenViewHelper {
        static let errorMessage1 = "Username must be at least 3 characters long"
        static let errorMessage2 = "Username is a required field"
        static let errorMessage3 = "Password is a required field"
        static let errorMessage4 = "Password must be at least 8 characters long"
        static let errorMessage5 = "Password should have letters and numbers"
        static let errorMessage6 = "Failed to Login. Please try again."
        static let errorMessage7 = "Something went wrong. Please try again."
        static let loading = "Loading..."
        static let authenticating = "Authenticating..."
        static let welcomeLabelText = "Welcome back."
        static let usernameInfoPlaceholder = "Enter username or email"
        static let passwordInfoPlaceholder = "Enter password"
        static let forgotPasswordButtonTitle = "Forgot username or password?"
        static let loginButtonTitle = "Log in"
        static let dontHaveLabelText = "Don't have an account?"
        static let signUpButtonTitle = "Don't have an account? Sign \n Up"
    }
    
    struct GenericEmailViewHelper {
        
    }
    
    struct RequestNotificationViewHelper {
        static let newPeopleTitle = "New Contact Requests"
        static let newSubscriptionsTitle = "New Subscription Requests"
    }
    
    struct HomeViewHelper {
        static let tabOneTitle = "Convos"
        static let tabTwoTitle = "Feed"
        static let tabFourTitle = "Favorites"
        static let tabFiveTitle = "Requests"
        static let NewMessages = "New Conversations"
        static let RedAndSend = "Conversations"
    }
    
    struct ForgotPasswordViewHelper {
        static let backButtonTitle = "Back"
        static let enterInfoLabel = "Forgot your username or password? Enter your info and I will send you a magic link to log in:"
        static let usernameTextFieldPlaceholder = "Enter your @username or email"
        static let sendLinkButtonTitle = "Send magic link"
        static let forgotEmailButtonTitle = "I don't remember my email."
    }

    struct FeedViewHelper {
        static let AgoStringTitle = " ago"
        static let SwipeStarTitle = "Star"
        static let SwipeUnstarTitle = "Unstar"
        static let SwipeRemoveBookmark = "Remove"
        static let SwipeAddBookmark = "Bookmark"
        static let SwipeRecategorizeTitle = "Recategorize"
        static let SwipeShareTitle = "Share"
        static let Today = "Today"
        static let YesterdayHeaderTitle = "Yesterday and Earlier"
        static let EarlierHeaderTitle = "Earlier"
        static let FeedTitle = "Feed"
        static let EmptyStateTitle = "Nothing New Today"
        static let RemovedBookmark = "Removed"
        static let Bookmarks = "Bookmarks"
        static let NoBookmarksTitle = "You don't have any\nbookmarks yet."
    }
    
    struct DetailedViewHelper {
        static let ShareInJuneTitle = "Share in June"
        static let ShareInIOSTitle = "Share in iOS"
        static let CancelTitle = "Cancel"
        static let RecategorizeTitle = "Recategorize"
        static let ReplyTitle = "Reply"
        static let BlockSenderTitle = "Block Sender"
        static let UnsubscribeTitle = "Unsubscribe"
        static let ToTitle = "to "
        static let CcTitle = "cc "
        static let SeparatorTitle = ", "
    }
    
    struct RequestsViewHelper {
        static let RequestsTitle = "Requests"
        static let PeopleSectionTitle = "People"
        static let SubscriptionsSectionTitle = "Subscriptions"
        static let ApproveTitile = "Approve"
        static let IgnoreTitile = "Ignore"
        static let BlockTitile = "Block"
        static let DenyTitile = "Deny"
        static let UnblockTitile = "Unblock"
        static let ApprovedTitile = "Approved"
        static let IgnoredTitile = "Ignored"
        static let BlockedTitile = "Blocked"
        static let DeniedTitile = "Denied"
        static let UnblockedTitile = "Unblocked"
        static let MoreTitle = "···"
        static let SeeMoreTitle = "SEE MORE >"
        static let CollapseTitle = "COLLAPSE"
        static let UndoTitle = "Undo"
        static let BlockedMessage = "I will block New Messages from %@."
        static let IgnoredMessage = "Ignored %@. I will put New Messages from %@ in your request center."
        static let ApprovedMessage = "Approved %@. View message."
        static let DeniedMessage = "Denied %@."
        static let UnblockedMessage = "Unbloked %@."
        static let SubscriptionsApprovedMessage = "Approved %@."
        static let ToMessage = "to %@"
        static let ReplyTitle = "Reply"
        static let CannedResponseTitle = "Canned Response"
        static let NoResultsTitle = "No New Requests"
        static let MoreMessageTitle = "+%i more"
    }
    
    struct CannedResponseHelper {
        static let Title = "Canned response"
        static let InterestedTitle = "Interested"
        static let MaybeLaterTitle = "Maybe later"
        static let NoThanksTitle = "No thanks"
        static let InterestedMessage = "Hi %@, \nThanks for reaching out. I would like to learn more."
        static let MaybeLaterMessage = "Hi %@, \nThanks for reaching out. I’m not interested at the moment but let’s stay in touch."
        static let NoThanksMessage = "Hi %@, \nThanks for reaching out but I’m not interested."
    }
    
    struct ResponderHelper {
        static let HeaderTitle = "Share in June"
        static let InputCellPlaceholder = "To:"
        
        static let UnsupportedTypeError: String = "Unsupported media type. Please, try another file"
        static let FileTooLarge: String = "File is too large, please try another file"
        static let InvalidImage: String = "Invalid image. Please, try again with another image"
        
        static let UploadingErrorTitle: String = "Opps! Upload failed"
        static let OkButtonTitle: String = "Ok"
    }
    
    struct ComposeHelper {
        static let HeaderTitle = "New Message"
        static let FromTitle = "From"
        static let OkTitle = "OK"
        static let ErrorTitle = "Error"
        static let SucessTitle = "Sucess"
        static let ErrorMessage = "Message could not be sent."
        static let SucessMessage = "Message sent successfully."
    }
    
    struct SearchViewHelper {
        static let SearchTitle = "Search"
        static let ResultsTitle = "Search Results"
        static let NoSearchResultsTitle = "No Search Results"
    }
    
    struct AttachmentViewHelper {
        static let GalleryTitle = "Photo"
        static let CameraTitle = "Camera"
        static let FileTitle = "File"
        static let CancelTitle = "Cancel"
    }
    
    struct FeedDateConverterHelper {
        static let Yesterday = "Yesterday"
    }
    
    struct FeedAmazonCardHelper {
        static let ViewOrManageOrder = "View or manage order"
        static let OrderConfirmed = "Order confirmed"
        static let EstimatedToArrive = "Estimated to arrive by"
    }
    
    struct FeedCalendarInvite {
        static let YesActionTitle = "Yes"
        static let MaybeActionTitle = "Maybe"
        static let NoActionTitle = "No"
        static let AllDayTitle = " - All day"
        static let AmTitle = "am"
        static let PmTitle = "pm"
    }
    
    struct FeedBriefHelper {
        static let ViewButtonTitle = "View"
        static let PendingRequestsSingle = "pending request from"
        static let PendingRequestsPlural = "pending requests from"
        static let CollapseTitle = "Collapse"
        static let ViewAllTitle = "View More"
    }
    
    struct RecategorizeHelper {
        static let titleFirstPart = "Recategorize from"
        static let cancelTitle = "Cancel"
        static let conversationTitle = "Conversations"
    }
    
    struct LinkEmailHelper {
        static let PasswordTitle = "Password"
        static let PasswordMessage = "Please enter password to continue"
        static let PasswordPlaceholder = "Enter your password"
        static let ContinueTitle = "Continue"
        static let cancelTitle = "Cancel"
    }
    
    struct ShareHelper {
        static let HeaderTitle = "Share Message"
        static let OkTitle = "OK"
        static let ErrorTitle = "Error"
        static let SucessTitle = "Sucess"
        static let ErrorMessage = "Message could not be share."
        static let SucessMessage = "Message share successfully."
    }
    
    struct SpoolIndexHelper {
        static let viewMoreTitle: String = "View info"
    }
}
