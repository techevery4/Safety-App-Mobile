/// All user-visible strings used in RoamSafe.
/// Centralised for easy localisation later.
class AppStrings {
  AppStrings._();

  // App
  static const String appName = 'RoamSafe';

  // Onboarding
  static const String skip = 'Skip';
  static const String next = 'Next  →';
  static const String getStarted = 'Get Started';

  static const String onboardingTitle1 = 'Stay Connected';
  static const String onboardingDesc1 =
      'Share your real time location with your inner circle.';
  static const String onboardingTitle2 = 'Instant Emergency Response';
  static const String onboardingDesc2 =
      'Trigger a response alert with a single tap or a quick shake of your phone.';
  static const String onboardingTitle3 = 'Enjoy Peace of Mind';
  static const String onboardingDesc3 =
      'Rest easy knowing that help is just a touch away.';

  // Registration
  static const String registration = 'Registration';
  static const String whatsYourEmail = "What's email address?";
  static const String enterValidEmail =
      'Enter a valid email address for registration.';
  static const String emailLabel = 'Email:';
  static const String emailHint = 'Enter email address';
  static const String passwordLabel = 'Password:';
  static const String passwordHint = 'Enter password';
  static const String confirmPasswordLabel = 'Confirm Password';
  static const String confirmPasswordHint = 'Enter password';
  static const String register = 'Register  →';
  static const String byContinuing =
      'By continuing, you agree to receive an SMS for verification';
  static const String termsAndPrivacy =
      'Terms and Privacy Policy apply. Message and data rates\nmay apply.';
  static const String terms = 'Terms';
  static const String privacyPolicy = 'Privacy Policy';

  // Account Created
  static const String accountCreatedSuccessfully =
      'Account created successfully.';
  static const String accountSetUp = 'Account Set up';

  // Profile Setup
  static const String setUpYourProfile = 'Set up your profile';
  static const String stepOf = 'Step %d of %d';
  static const String enterYourInformation = 'Enter your Information';
  static const String firstName = 'First Name';
  static const String lastName = 'Last Name';
  static const String continueText = 'Continue  →';

  // Upload Picture
  static const String uploadAPicture = 'Upload a picture';
  static const String uploadClearPicture = 'Upload a clear picture.';
  static const String photoInstructions =
      'Please follow the following instructions to ensure your identity can be verified quickly.';
  static const String clearViewOfFace = 'Clear view of your face.';
  static const String goodLighting = 'Good lighting.';
  static const String noSunglasses = 'No sunglasses.';
  static const String recentPicture = 'Recent picture.';
  static const String takeAPhoto = 'Take a photo';
  static const String uploadFromGallery = 'Upload from gallery';

  // Looking Good
  static const String lookingGood = 'Looking  Good!';
  static const String profilePictureSet =
      'Your profile picture is set. This helps your contacts identify you quickly.';
  static const String continueBtn = 'Continue';
  static const String changePhoto = 'Change Photo';

  // Setup Complete
  static const String setupComplete = 'Set Up Complete!';
  static const String setupDonePercent = '100% Set up done.';
  static const String profileReady =
      'Your profile is ready. You can RoamSafe now.';
  static const String profileInformation = 'Profile Information';
  static const String goToDashboard = 'Go to Dashboard  →';

  // Upload Failed
  static const String uploadFailed = 'Upload Failed!';
  static const String uploadFailedDesc =
      "We couldn't process this image. Please ensure that the image is clear and that it is a JPG or PNG and less than 5MB";
  static const String tryAgain = 'Try Again';

  // Login
  static const String logIn = 'Log in';
  static const String welcomeBack = 'Welcome Back';
  static const String enterYourEmail = 'Enter your email to log in.';
  static const String logInButton = 'Log in';
  static const String dontHaveAccount = "Don't have an account?";
  static const String registerInstead = 'Register Instead';
  static const String alreadyHaveAccount = "Already have an account?";
  static const String loginInstead = 'Login Instead';

  // Dashboard
  static const String welcome = 'Welcome,';
  static const String statusSafe = 'Status: Safe';
  static const String statusEmergency = 'EMERGENCY ACTIVE';
  static const String advertisement = 'Advertisement';
  static const String sos = 'SOS';
  static const String tapToTrigger = 'Tap to trigger';

  // Bottom Nav
  static const String home = 'Home';
  static const String contacts = 'Contacts';
  static const String location = 'Location';
  static const String settings = 'Settings';

  // OTP
  static const String otpVerification = 'OTP Verification';
  static const String enterOtp = 'Enter the OTP sent to your email';
  static const String verify = 'Verify';
  static const String resendOtp = 'Resend OTP';

  // General
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String confirm = 'Confirm';
  static const String ok = 'OK';
  static const String yes = 'Yes';
  static const String no = 'No';
  static const String loading = 'Loading...';
  static const String error = 'Error';
  static const String success = 'Success';
  static const String retry = 'Retry';
  static const String noDataFound = 'No data found';
  static const String somethingWentWrong =
      'Something went wrong. Please try again.';

  // Contacts
  static const String trustedContacts = 'Trusted Contacts';
  static const String manageEmergencyContacts =
      'Manage your emergency contacts';
  static const String confirmedContacts = 'Confirmed Contacts';
  static const String pending = 'Pending';
  static const String searchForContact = 'Search for contact';
  static const String addNewContact = 'Add New Contact';
  static const String addContact = 'Add Contact';
  static const String contactName = 'Contact Name';
  static const String contactEmail = 'Contact Email';
  static const String enterContactName = "Enter contact's full name";
  static const String enterContactEmail = "Enter contact's email address";
  static const String contactAddedSuccessfully = 'Contact Added Successfully!';
  static const String contactAddedDesc =
      "The contact have been added pending their approval. They will appear on the 'Pending List' until they accept your request to add them.";
  static const String contactNotFound = 'Contact Not Found';
  static const String contactNotFoundDesc =
      'It looks like the email of the person is not registered with us. To add them to your contacts, they must have an account with us.';
  static const String backToContacts = 'Back to Contacts';
  static const String addAnotherContact = 'Add Another Contact';
  static const String removeContact = 'Remove Contact';
  static const String removeContactDesc =
      'They will no longer be able to receive emergency notifications from you. This action cannot be undone.';
  static const String declineRequest = 'Decline Request';
  static const String declineThisRequest = 'Decline this Request';
  static const String declineRequestDesc =
      'This user will not be added to your Trusted Contacts list. This action cannot be undone.';
  static const String noContactsYet = 'No contacts yet';
  static const String noPendingRequests = 'No pending requests';
  static const String contactRemoved = 'Contact removed';
  static const String contactAccepted = 'Contact accepted';
  static const String requestDeclined = 'Request declined';

  // Ad Manager
  static const String adManager = 'Ad Manager';
  static const String createAdCampaign = 'Create Ad Campaign';
  static const String adCampaignDetails = 'Ad Campaign Details';
  static const String campaignName = 'Campaign Name';
  static const String enterCampaignName = 'Enter Ad Campaign name';
  static const String adThumbnailImage = 'Ad Thumbnail Image';
  static const String uploadAdImage = 'Upload Ad Image';
  static const String uploadFormats = 'PNG, JPG up to 10MB (1080×1920px)';
  static const String uploadFromGalleryAd = 'Upload From Gallery';
  static const String schedule = 'Schedule';
  static const String startDate = 'Start Date';
  static const String duration = 'Duration';
  static const String dailyRate = 'Daily Rate';
  static const String total = 'Total';
  static const String proceedToPayment = 'Proceed to Payment';
  static const String adVettingDisclaimer =
      'Ads are vetted to maintain the integrity of the platform. Your campaign will go live after a short review process.';
  static const String adCreatedSuccess = 'Ad Campaign Created Successfully!';
}
