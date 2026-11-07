# AMAR (عَمَار) — Project Context & Handoff

## 1. Overview
- Flutter marketplace for Gaza: products (stores) and services (companies/technicians). One codebase, two apps with separate sessions: **customer** (OTP login) and **driver** (phone + password).
- Root: `C:\Users\HP\Desktop\Ammar app\amar_app` (git, GitHub `Amar-Gaza`, base `main`, current branch `feature/local-storage-gps-location-search`). App id `com.ajyal.amar` (Android + iOS); Android `namespace` is still `com.example.amar_app` (Firebase matches the applicationId, not the namespace).
- Backend: Masar, `https://masar.toldpath.com/api` (`/v1/...`), envelope `{success, message, data, meta, request_id}`; errors `{error: {code, details, hint}}`. Statuses, modules, polling, payment methods come from `GET /v1/app/config` (v6).
- Push notifications: **Firebase Cloud Messaging only** (Masar sends to FCM with our service account key); everything else stays on the Masar REST API.
- Stack: Flutter 3.47.7, GetX (state/nav/DI), Dio (one `ApiClient`), flutter_secure_storage + get_storage, gen-l10n (Arabic first, RTL), Lucide icons, Cairo font, google_maps_flutter, geolocator, geocoding, image_picker.
- Vendor dashboard is NOT in this repo and the contract has no write endpoints for it.

## 2. Structure
- `brief/`: `design.html` (customer UI), `عَمَار — تصميم السائق.html` (driver UI), `amar-openapi (2).json` (contract, also `api/amar-openapi.json`), Postman collections, `amar-dart-models` + `amar-flutter-handoff` (v6 models/ARB/theme), `questions_en.md`, this file.
- Trainer push guide: `masar-push-guide.html` (sent by the trainer; kept outside the repo, ask the user for it). Summary in section 5.
- `lib/core/`: `constants/` (`api_endpoints`, `api_query` = ApiQuery/ApiBody/ApiErrorCodes/..., `app_defaults`, `app_env`, `app_durations`, `storage_keys`), `network/` (`api_client`, `api_failure`, interceptors), `localization/` (`error_message_resolver`, `locale_controller`, `price_label`, `location_issue_text`), `storage/` (`secure_token_storage`, `app_preferences`), `theme/`.
- `lib/data/models/`: `masar/masar_models.dart` (v6, generated), `catalog/`, `requests/`, `cart/`.
- `lib/data/services/{customer,driver,shared}/`, `lib/controllers/{customer,driver,shared}/`, `lib/app/{bindings,routes}/`.
- `lib/presentation/screens/` and `widgets/` by area (auth, customer shell/home/cart, catalog, checkout, orders, account, driver).
- `l10n_src/pack/` (v6 pack, do not edit), `l10n_src/custom/` (our keys) → merged into `lib/l10n/app_{ar,en}.arb` (generated).
- `env/dev.json` (git-ignored): `AMAR_PROJECT_KEY`, `AMAR_DEV_MEMBER`, `AMAR_MAPS_KEY`. `ios/Flutter/Maps.xcconfig` (git-ignored). `.gitignore` also ignores `google-services.json` and `GoogleService-Info.plist`.

## 3. Key decisions and conventions
- **User rules:** reply in Arabic (simple Levantine, Arabic script); code/comments/commits in English. Small phases, short summary after each. **Never decide unclear logic alone: ask the user with options + recommendation.** Give the user the exact backend request when a response is needed; they run it. Don't commit unless asked. Update this file after each change (`/handoff`) so teammates can follow.
- **Code rules:** no hardcoded colors/text/sizes/durations (tokens, constants, ARB); one widget per file; no helper functions returning widgets; controllers UI-free; no Dio outside `core/network`; don't edit generated files; `dart format` + `flutter analyze` after changes. Never `offAllNamed` to a route whose controller is alive below.
- **l10n:** add keys only in `l10n_src/custom/app_custom_{ar,en}.arb`, no reserved prefixes (`status|action|confirm|cancelReason|error`), no apostrophes; merge (pack + custom → `lib/l10n`), then `flutter gen-l10n`.
- **Secrets:** keys only in `env/*.json`; never in code, docs, logs or chat. Firebase **service account JSON** goes only to the Masar dashboard (project owner uploads it), never into the app, git or chat. Project key and maps key should be rotated (pasted in chat earlier).
- **Design:** primary `#14624a`; app name Amar/عمار; logo `assets/images/app_logo.png`.
- **Customer nav:** tabs home, orders, cart, account; notifications open from the bell (`AppRoutes.notifications`). Cart tab owns `CheckoutController`.
- **Catalog:** `kind` = `product|service`; `price_mode: inspection` shows "after inspection". Categories merged by name. One vendor per cart; services never enter the cart (`AppRoutes.serviceRequest`), date from tomorrow; service price accepted/rejected in order details.
- **Payment:** config methods + vendor gateways (`bank_transfer` + `payment_gateway_id`); `awaiting_payment` shows receipt upload. Postman `cash` vs config `cash_on_delivery`: verify on device.
- **Errors:** `ErrorInterceptor` → `ApiFailure`; `ErrorMessageResolver.resolve` used by all banners/views.
- **Map:** `MapPickerScreen` returns `PickedLocation`; only when `AppEnv.hasMaps`.

## 4. Done
- API layer (all endpoints), catalog, checkout, orders/tracking, account, driver app, platform config; redesign of auth flow, home, categories, providers, vendor tabs; map + address picker, services request, bank transfer receipt; centralized errors.
- Driver redesign complete (home, history, wallet, account, job screen, notifications, profile). Driver login sends local phone format (`0599100001`).
- Nov 4–5 (PR #3, #4): local storage (cart persisted, `AppPreferences`), GPS auto location detection, map picker + location search, `CurrentLocationSheet` on home, animated customer bottom nav (`nav_motion`, `nav_bar_painter`), nav bar color.
- Already in code for push: `ProfileService.updateFcmToken(String?)` (`PUT /v1/me/fcm-token`), driver equivalent (`PUT /v1/driver/me/fcm-token`), `NotificationService` (list / readAll / markOpened) for both roles, customer and driver notification screens. Nothing calls `updateFcmToken` yet.

## 5. In progress — Firebase push notifications (analysis only, no code yet)
- **How it works (trainer guide):** event (status change, `order.available`, `offer.sent`, `broadcast`, `push_lab.test`) → Masar saves it in `GET /notifications` (recipient language) → queue → FCM with our key → last device that saved a token for that account. Order/broadcast pushes may be delayed up to ~5 min; push lab test is instant.
- **Push `message.data`** (all strings): `notification_id` (always), `event` (always), `type` (`order`, `order.available`, `broadcast`), `order_id`, `status`. Convert `order_id` to int.
- **Client work planned:** add `firebase_core` + `firebase_messaging`; `flutterfire configure` → `lib/firebase_options.dart`; init in `main.dart` + background handler; after login request permission, `getToken()` → PUT token, listen `onTokenRefresh`; on logout PUT `{token: null}` **before** clearing the session token; foreground `onMessage` (system does not show it); tap (`onMessageOpenedApp` + `getInitialMessage`) → `POST .../notifications/{id}/opened` then open the right screen; unread count from `meta.unread`; keep server locale in sync.
- **User steps pending:** create one Firebase project, add Android app `com.ajyal.amar` (+ iOS only if there is a paid Apple account), run `firebase login` + `flutterfire configure` (or give the project id), project owner uploads the service account key in Masar dashboard → Developer center → Push lab.
- **Open questions (waiting for the user):** customer + driver logged in on the same device (register token for both roles or only one); foreground display (in-app banner vs `flutter_local_notifications`); tap navigation per event/role; when to ask permission; bell unread badge; sync locale to server on language change; commit `google-services.json` / `firebase_options.dart` or keep ignored; Android only or iOS too.
- Other open items: driver redesign and phase 4 flows not yet checked on a device; orders/tracking/notifications/account/cart screens still use the old layout; `test/widget_test.dart` has no `main`; release signed with debug key; working tree has uncommitted generated plugin files (linux/macos) and `.vscode/settings.json`.

## 6. Next steps
1. User answers the push open questions and finishes the Firebase setup steps.
2. Implement push in small phases: (a) packages + Firebase init, (b) token register/refresh/remove for both roles, (c) foreground + tap handling + opened report, (d) unread badge + locale sync.
3. Test with Masar Push lab: foreground, background, terminated; check "opened" status; real order status change + broadcast.
4. Device QA of driver redesign and phase 4 flows.
5. Production: keystore + release signing, `env/prod.json`, AAB, restrict/rotate maps key.
6. Restyle orders/tracking/notifications/account/cart to the design.

## 7. Commands
- Run: `flutter run --dart-define-from-file=env/dev.json`
- Analyze: `flutter analyze`; format: `dart format lib`
- l10n: merge ARB (pack + custom), then `flutter gen-l10n`
- Debug APK: `flutter build apk --debug --dart-define-from-file=env/dev.json`
- Release APK (test only, debug-signed): `flutter build apk --release --dart-define-from-file=env/dev.json`
- Firebase (after setup): `dart pub global activate flutterfire_cli`, `flutterfire configure --project=<FIREBASE_PROJECT_ID>`
