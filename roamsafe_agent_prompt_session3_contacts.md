# ANTIGRAVITY AGENT PROMPT — ROAMSAFE: CONTACTS MODULE

---

## CONTEXT

You are continuing work on the RoamSafe Flutter project. The folder structure, BLoC, routing, DI, and services are already in place. This session implements the **complete Contacts module** across the following files:

- `lib/features/contacts/presentation/pages/contacts_screen.dart` — main page with tabs
- `lib/features/contacts/presentation/pages/add_contact_screen.dart` — add contact form + result states
- `lib/features/contacts/presentation/bloc/contacts_bloc.dart`
- `lib/features/contacts/presentation/bloc/contacts_event.dart`
- `lib/features/contacts/presentation/bloc/contacts_state.dart`
- `lib/features/contacts/domain/entities/contact_entity.dart`
- `lib/features/contacts/data/models/contact_model.dart`
- `lib/features/contacts/data/datasources/contacts_remote_datasource.dart`
- `lib/features/contacts/data/repositories/contacts_repository_impl.dart`
- `lib/features/contacts/domain/repositories/contacts_repository.dart`
- `lib/features/contacts/domain/usecases/add_contact_usecase.dart`
- `lib/features/contacts/domain/usecases/remove_contact_usecase.dart`
- `lib/features/contacts/domain/usecases/get_contacts_usecase.dart`
- `lib/shared/widgets/custom_button.dart` — already exists, reuse it

Figma references are in `figma_images/`:
- `figma_images/contacts_main.png`
- `figma_images/contacts_add1.png`
- `figma_images/contacts_add2.png`
- `figma_images/contacts_add3.png`
- `figma_images/contacts_confirmed1.png`
- `figma_images/contacts_confirmed2.png`
- `figma_images/contacts_pending1.png`
- `figma_images/contacts_pending2.png`

---

## CRITICAL REMINDERS (lessons from previous sessions)

- **Register ALL new services and repositories in `core/di/injection.dart`** — do not skip this. Every class retrieved via `sl<T>()` must be registered or the app will crash with a GetIt error.
- Run `flutter analyze` before reporting done — fix every warning and error.
- All strings → `AppStrings`. All colors → `AppColors`.
- Use dummy/hardcoded data for all lists — no real API calls yet. Mark every stubbed call with `// TODO: replace with API call`.
- No phone numbers — contacts are identified by **email and name only**.

---

## DATA MODEL

### `ContactEntity`
```dart
class ContactEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final ContactStatus status; // confirmed | pending

  const ContactEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
  });

  // initials helper
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  List<Object?> get props => [id, name, email, status];
}

enum ContactStatus { confirmed, pending }
```

### `ContactModel` (extends or maps to `ContactEntity`)
Standard JSON model with `fromJson` / `toJson`. Fields match entity above.

---

## DUMMY DATA

Use this hardcoded list in `ContactsRepositoryImpl` for both confirmed and pending until APIs are ready:

```dart
// Confirmed contacts dummy data
final List<ContactEntity> _dummyConfirmed = [
  ContactEntity(id: '1', name: 'Adimula Mutiu', email: 'adi@gmail.com', status: ContactStatus.confirmed),
  ContactEntity(id: '2', name: 'Janet Faith', email: 'adi@gmail.com', status: ContactStatus.confirmed),
  ContactEntity(id: '3', name: 'Adekangbe Murphy', email: 'adi@gmail.com', status: ContactStatus.confirmed),
];

// Pending contacts dummy data
final List<ContactEntity> _dummyPending = [
  ContactEntity(id: '4', name: 'Adimula Mutiu', email: 'adi@gmail.com', status: ContactStatus.pending),
  ContactEntity(id: '5', name: 'Janet Faith', email: 'adi@gmail.com', status: ContactStatus.pending),
  ContactEntity(id: '6', name: 'Adekangbe Murphy', email: 'adi@gmail.com', status: ContactStatus.pending),
];
```

The repository holds these in memory (a local `List`) so that add/remove operations reflect immediately in the UI without needing an API. When the API is integrated later, swap out the in-memory list for real calls.

---

## BLOC DEFINITION

### Events (`contacts_event.dart`)
```dart
abstract class ContactsEvent extends Equatable {}

class LoadContactsEvent extends ContactsEvent { ... }
class AddContactEvent extends ContactsEvent {
  final String name;
  final String email;
  ...
}
class RemoveContactEvent extends ContactsEvent {
  final String contactId;
  ...
}
class AcceptContactEvent extends ContactsEvent {   // for pending tab: accept
  final String contactId;
  ...
}
class DeclineContactEvent extends ContactsEvent {  // for pending tab: decline
  final String contactId;
  ...
}
class SearchContactsEvent extends ContactsEvent {
  final String query;
  ...
}
```

### States (`contacts_state.dart`)
```dart
abstract class ContactsState extends Equatable {}

class ContactsInitial extends ContactsState { ... }
class ContactsLoading extends ContactsState { ... }
class ContactsLoaded extends ContactsState {
  final List<ContactEntity> confirmed;
  final List<ContactEntity> pending;
  final List<ContactEntity> filtered; // search results
  ...
}
class ContactsError extends ContactsState {
  final String message;
  ...
}
class AddContactSuccess extends ContactsState { ... }
class AddContactFailure extends ContactsState { ... }  // user not found
class RemoveContactSuccess extends ContactsState { ... }
```

### Bloc logic (`contacts_bloc.dart`)
- `LoadContactsEvent` → loads dummy data, emits `ContactsLoaded`
- `AddContactEvent` → simulate: if email contains "@" and email != current user email → emit `AddContactSuccess`, add to pending list; else emit `AddContactFailure`. Mark with `// TODO: replace with API call`
- `RemoveContactEvent` → remove from confirmed list, emit updated `ContactsLoaded`
- `AcceptContactEvent` → move from pending to confirmed, emit updated `ContactsLoaded`
- `DeclineContactEvent` → remove from pending list, emit updated `ContactsLoaded`
- `SearchContactsEvent` → filter confirmed list by name or email, update `filtered` in state

---

## SCREEN 1 — Contacts Main Screen (`contacts_screen.dart`)

**Figma refs:** `contacts_main.png`, `contacts_confirmed1.png`, `contacts_confirmed2.png`, `contacts_pending1.png`, `contacts_pending2.png`

### Layout
```
AppBar: back arrow (left) | "Contacts" (center, bold)

Section header: "Trusted Contacts" (bold, large)
Subtitle: "Manage your emergency contacts" (grey)

Tab switcher row (two pills, full width):
  [Confirmed Contacts]  [Pending]
  Active tab = teal filled, white text, rounded pill
  Inactive tab = white/light background, grey text, rounded pill, border

Search bar:
  Light grey background, rounded, search icon left,
  italic placeholder "Search for contact"

Contact list (scrollable):
  Each row = rounded card, light grey background:
    - Initials avatar circle (teal bg, white text, 2 letters)
    - Name (bold) + email (grey, smaller) stacked
    - Right side differs by tab:
        Confirmed tab → red trash icon button
        Pending tab   → green tick icon + red X icon (side by side)

Empty state (if list is empty):
  Centered text: "No contacts yet" (confirmed)
               or "No pending requests" (pending)

"Add New Contact" button — full width teal, fixed at bottom above bottom nav
Bottom nav bar — Contacts tab active
```

### Confirmed tab — delete flow
Tapping the red trash icon opens a **bottom sheet modal** (not a separate screen) matching `contacts_confirmed2.png`:
- White rounded top sheet
- Pink/light-red circle with person-minus icon (use `Icons.person_remove`)
- Title: "Remove [Contact Name]?"
- Subtitle: "They will no longer be able to receive emergency notifications from you. This action cannot be undone."
- Red full-width button: "Remove Contact" → dispatches `RemoveContactEvent(contactId)`
- White outlined full-width button: "Cancel" → closes sheet

### Pending tab — accept/decline flow
- Green tick → dispatches `AcceptContactEvent(contactId)` immediately, no confirmation needed, contact moves to confirmed list
- Red X → opens a **bottom sheet modal** matching `contacts_pending2.png`:
  - White rounded top sheet
  - Light orange/salmon circle with warning triangle icon (`Icons.warning_amber_rounded`)
  - Title: "Decline this Request"
  - Subtitle: "This user will not be added to your Trusted Contacts list. This action cannot be undone."
  - Red full-width button: "Decline Request" → dispatches `DeclineContactEvent(contactId)`
  - White outlined full-width button: "Cancel" → closes sheet

### Search behaviour
- `SearchContactsEvent` fires on every keystroke (`onChanged`)
- Filters the **currently active tab's list** (confirmed or pending) by name or email
- If search query is empty, show full list

### "Add New Contact" button
Navigates to `AppRoutes.addContact` via `context.pushNamed(AppRoutes.addContact)`

### BlocListener
Wrap the screen body in a `BlocConsumer`. Listen for:
- `RemoveContactSuccess` → show snackbar "Contact removed"
- `AcceptContactEvent` result → show snackbar "Contact accepted"
- `DeclineContactEvent` result → show snackbar "Request declined"

---

## SCREEN 2 — Add Contact Screen (`add_contact_screen.dart`)

**Figma refs:** `contacts_add1.png` (form), `contacts_add2.png` (success), `contacts_add3.png` (failure)

This screen has **three internal states** managed locally (not via routing):
1. `_AddContactView.form` — the input form
2. `_AddContactView.success` — contact added successfully
3. `_AddContactView.failure` — contact not found

Use a local `enum _AddContactView { form, success, failure }` and `setState` to switch between them.

### State 1 — Form View (`contacts_add1.png`)
```
AppBar: back arrow | "Add Contact" (center)

Body (centered, padded):
  Label: "Contact Name"
  CustomTextField: placeholder "Enter contact's full name"
    - text input, no special keyboard

  SizedBox height 16

  Label: "Contact Email"
  CustomTextField: placeholder "Enter contact's email address"
    - email keyboard type
    - validator: must be valid email format

  SizedBox height 32

  "Add Contact" button — full width teal
    - validates form before dispatching
    - shows loading spinner inside button while processing
    - on tap → dispatches AddContactEvent(name, email)
```

### State 2 — Success View (`contacts_add2.png`)
```
No AppBar — full screen centered layout

Top ~55% of screen:
  Large circle — light green background
  Inside: Image.asset('assets/images/success.png')
           fit: BoxFit.contain, sized ~180x180

Bottom section (centered, padded horizontal 32):
  Title: "Contact Added Successfully!" (bold, large, center)
  SizedBox 12
  Body text (center, grey, height 1.5):
    "The contact have been added pending their approval.
     They will appear on the 'Pending List' until they
     accept your request to add them."
  SizedBox 40

  "Back to Contacts" button — full width teal
    → context.goNamed(AppRoutes.contacts)

  SizedBox 12

  "Add Another Contact" button — full width, white bg, teal border, teal text
    → setState(() => _currentView = _AddContactView.form)
    → also clear the form fields (reset controllers)
```

### State 3 — Failure View (`contacts_add3.png`)
```
No AppBar — full screen centered layout

Top ~55% of screen:
  Large circle — light pink/salmon background
  Inside: Image.asset('assets/images/error.png')
           fit: BoxFit.contain, sized ~180x180

Bottom section (centered, padded horizontal 32):
  Title: "Contact Not Found" (bold, large, center)
  SizedBox 12
  Body text (center, grey, height 1.5):
    "It looks like the email of the person is not registered
     with us. To add them to your contacts, they must
     have an account with us."
  SizedBox 40

  "Back to Contacts" button — full width teal
    → context.goNamed(AppRoutes.contacts)

  SizedBox 12

  "Add Another Contact" button — full width, white bg, teal border, teal text
    → setState(() => _currentView = _AddContactView.form)
    → also clear the form fields
```

### BlocListener in Add Contact Screen
```dart
BlocListener<ContactsBloc, ContactsState>(
  listener: (context, state) {
    if (state is AddContactSuccess) {
      setState(() => _currentView = _AddContactView.success);
    } else if (state is AddContactFailure) {
      setState(() => _currentView = _AddContactView.failure);
    }
  },
  child: _buildCurrentView(),
)
```

---

## SHARED WIDGET — Contact Avatar

Create a reusable private widget (or a shared widget if used elsewhere) `_ContactAvatar`:

```dart
// Generates consistent colors per contact based on name hash
Color _avatarColor(String name) {
  final colors = [
    const Color(0xFF7E57C2), // purple
    const Color(0xFFFF7043), // orange
    const Color(0xFF26A69A), // teal
    const Color(0xFF42A5F5), // blue
    const Color(0xFFEC407A), // pink
  ];
  return colors[name.hashCode.abs() % colors.length];
}

Widget _ContactAvatar(String name) {
  final color = _avatarColor(name);
  return CircleAvatar(
    backgroundColor: color.withValues(alpha: 0.2),
    child: Text(
      initials(name),
      style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14),
    ),
  );
}
```

---

## DEPENDENCY INJECTION — MANDATORY

In `core/di/injection.dart`, register ALL of the following. Do not skip any:

```dart
// Contacts
sl.registerLazySingleton<ContactsRepository>(() => ContactsRepositoryImpl());
sl.registerLazySingleton<GetContactsUsecase>(() => GetContactsUsecase(sl()));
sl.registerLazySingleton<AddContactUsecase>(() => AddContactUsecase(sl()));
sl.registerLazySingleton<RemoveContactUsecase>(() => RemoveContactUsecase(sl()));

// ContactsBloc — register as factory (new instance per page)
sl.registerFactory<ContactsBloc>(() => ContactsBloc(
  getContactsUsecase: sl(),
  addContactUsecase: sl(),
  removeContactUsecase: sl(),
));
```

If the project uses `@injectable` annotations instead of manual registration, add the correct annotations (`@lazySingleton`, `@injectable`, `@factoryMethod`) to each class and run:
```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## ROUTING — ADD THESE ROUTES

In `core/router/app_routes.dart`:
```dart
static const String contacts = 'contacts';
static const String addContact = 'add-contact';
```

In `core/router/app_router.dart`, add the routes:
```dart
GoRoute(
  name: AppRoutes.contacts,
  path: '/contacts',
  builder: (context, state) => BlocProvider(
    create: (_) => sl<ContactsBloc>()..add(LoadContactsEvent()),
    child: const ContactsScreen(),
  ),
),
GoRoute(
  name: AppRoutes.addContact,
  path: '/contacts/add',
  builder: (context, state) => BlocProvider.value(
    value: sl<ContactsBloc>(),
    child: const AddContactScreen(),
  ),
),
```

Note: `addContact` uses `BlocProvider.value` so it shares the same `ContactsBloc` instance from the contacts screen — state updates (like `AddContactSuccess`) are immediately reflected when navigating back.

---

## STRINGS TO ADD TO `AppStrings`

```dart
static const String contacts = 'Contacts';
static const String trustedContacts = 'Trusted Contacts';
static const String manageEmergencyContacts = 'Manage your emergency contacts';
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
static const String contactAddedDesc = "The contact have been added pending their approval. They will appear on the 'Pending List' until they accept your request to add them.";
static const String contactNotFound = 'Contact Not Found';
static const String contactNotFoundDesc = 'It looks like the email of the person is not registered with us. To add them to your contacts, they must have an account with us.';
static const String backToContacts = 'Back to Contacts';
static const String addAnotherContact = 'Add Another Contact';
static const String removeContact = 'Remove Contact';
static const String declineRequest = 'Decline Request';
static const String cancel = 'Cancel';
static const String noContactsYet = 'No contacts yet';
static const String noPendingRequests = 'No pending requests';
static const String contactRemoved = 'Contact removed';
static const String contactAccepted = 'Contact accepted';
static const String requestDeclined = 'Request declined';
```

---

## CHECKLIST BEFORE REPORTING DONE

- [ ] `flutter analyze` passes — zero errors, zero warnings
- [ ] `CallService` and all other previously registered services are still intact in `injection.dart` (do not overwrite, only append)
- [ ] All new classes registered in `injection.dart`
- [ ] Confirmed tab shows dummy confirmed contacts with trash icon
- [ ] Pending tab shows dummy pending contacts with tick + X icons
- [ ] Tapping trash → bottom sheet with "Remove [Name]?" → confirm removes from list
- [ ] Tapping X on pending → bottom sheet "Decline this Request" → confirm removes from pending
- [ ] Tapping tick on pending → immediately moves contact to confirmed list
- [ ] Search filters the active tab's list in real time
- [ ] Add Contact form validates name and email before submitting
- [ ] Success view shows `assets/images/success.png` inside green circle
- [ ] Failure view shows `assets/images/error.png` inside pink circle
- [ ] "Add Another Contact" clears the form and returns to form view
- [ ] "Back to Contacts" navigates to contacts screen
- [ ] Bottom nav shows Contacts tab as active on contacts screen
- [ ] No hardcoded strings — all reference `AppStrings`
- [ ] No hardcoded colors — all reference `AppColors`
- [ ] Avatar initials are 2 letters (first letter of first + last name)
- [ ] Avatar colors are consistent per contact name (hash-based)
