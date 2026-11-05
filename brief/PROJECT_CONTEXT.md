# AMAR (عَمَار) — Project Context & Handoff

## 1. Overview
- Flutter marketplace for Gaza: products (stores) and services (companies/technicians). One codebase, two apps with separate sessions: **customer** (OTP login) and **driver** (phone + password).
- Root: `C:\Users\RUC\StudioProjects\amar\amar_app` (git repo, branch `main`, work uncommitted unless the user commits). App id `com.ajyal.amar` (Android + iOS).
- Backend: Masar, `https://masar.toldpath.com/api` (`/v1/...`), envelope `{success, message, data, meta, request_id}`; errors `{error: {code, details, hint}}`. Statuses, modules, polling, payment methods come from `GET /v1/app/config` (v6).
- Stack: Flutter 3.47.7 (`C:\src\flutter`), GetX (state/nav/DI), Dio (one `ApiClient`), flutter_secure_storage + get_storage, gen-l10n (Arabic first, RTL), Lucide icons, Cairo font, google_maps_flutter, geolocator, image_picker.
- Vendor dashboard is NOT in this repo and the contract has no write endpoints for it.

## 2. Structure
- `brief/`: `design.html` (customer UI source), `عَمَار — تصميم السائق.html` (driver UI source), `amar-openapi (2).json` (contract), Postman collections (user/driver), `amar-dart-models` + `amar-flutter-handoff` (v6 models/ARB/theme), `questions_en.md`, this file.
- `lib/core/`: `constants/` (`api_endpoints`, `api_query` = ApiQuery/ApiBody/ApiErrorCodes/PaymentMethods/ProductKinds/PriceModes/OrderStatusKeys, `app_defaults`, `app_env`, `app_durations`), `network/` (`api_client`, `api_failure`, interceptors), `localization/` (`error_message_resolver`, `price_label`, `location_issue_text`), `theme/` (tokens, `app_category_tints`, `app_shadows`).
- `lib/data/models/`: `masar/masar_models.dart` (v6, generated), `catalog/` (`category_group`, `provider_entry`, `picked_location`, `payment_option`), `requests/`, `cart/`.
- `lib/data/services/{customer,driver,shared}/`, `lib/controllers/{customer,driver,shared}/`, `lib/app/{bindings,routes}/`.
- `lib/presentation/screens/` and `widgets/` by area (auth, customer shell/home/cart, catalog, checkout, orders, account, driver).
- `l10n_src/pack/` (v6 pack, do not edit), `l10n_src/custom/` (our keys) → merged into `lib/l10n/app_{ar,en}.arb` (generated).
- `env/dev.json` (git-ignored): `AMAR_PROJECT_KEY`, `AMAR_DEV_MEMBER`, `AMAR_MAPS_KEY`. `ios/Flutter/Maps.xcconfig` (git-ignored) for the iOS maps key.

## 3. Key decisions and conventions
- **User rules:** reply in Arabic (simple Levantine, Arabic script); code/comments/commits in English. Small phases, short summary after each. Give the user the exact backend request when a response is needed; they run it. On design vs backend conflict, ask with options + recommendation. Don't commit unless asked. Remind the user that the home promo banner and search hint have no endpoint.
- **Code rules:** no hardcoded colors/text/sizes/durations (tokens, constants, ARB); one widget per file; no helper functions returning widgets; controllers UI-free; no Dio outside `core/network`; don't edit generated files; `dart format` + `flutter analyze` after changes. Never `offAllNamed` to a route whose controller is alive below.
- **l10n:** add keys only in `l10n_src/custom/app_custom_{ar,en}.arb`, no reserved prefixes (`status|action|confirm|cancelReason|error`), no apostrophes; merge with Python (pack + custom → `lib/l10n`), then `flutter gen-l10n`.
- **Secrets:** keys only in `env/*.json`; never in code, docs, logs or chat. The project key and the maps key were pasted in chat earlier: both should be rotated, and the maps key restricted to `com.ajyal.amar` + signing SHA-1.
- **Design:** primary `#14624a` (server color ignored); app name Amar/عمار; logo `assets/images/app_logo.png` (letter placeholder if missing).
- **Customer nav:** tabs home, orders, cart, account (`CustomerTab`); notifications open from the bell (`AppRoutes.notifications`). Cart tab owns `CheckoutController` (`CartTab`).
- **Catalog:** item `kind` = `product|service`; `price_mode: inspection` shows "after inspection". Categories merged by name (`CategoryGroup`). Home sections "المتاجر" (kind product) and "خدمات الشركات" (kind service) built from vendors + first 50 items per kind; vendors with no items hidden. Vendor page shows a tab only for kinds it offers.
- **Cart:** one vendor per cart. **Services never enter the cart**: `CartController.service` + `AppRoutes.serviceRequest` reuse the checkout screens; date required, from tomorrow. Product scheduling also starts tomorrow ("now" allowed). After the vendor prices a service, the customer accepts/rejects in order details (`ServiceQuoteCard`); accepted services stay in "My orders", not the cart (user not yet confirmed this).
- **Payment:** options = config methods + `/vendors/{id}/payment-methods` gateways (`bank_transfer` + `payment_gateway_id`). `awaiting_payment` shows `TransferReceiptCard` (upload purpose `payment_receipt`, images only). Postman uses `cash` while config says `cash_on_delivery`: verify on device.
- **Errors (centralized):** `ErrorInterceptor` → `ApiFailure(code, message, statusCode, requestId, details)`; non-envelope replies mapped by HTTP status (`ApiErrorCodes.fromStatus`); parse errors in `ApiClient.send` → `invalid_response`; debug builds print `method path -> ApiFailure(...)`. `ErrorMessageResolver.resolve` order: first `details.fields` reason for 422 → server message (skipped for technical codes) → ARB text by code (`failure*` keys). All banners/views use it.
- **Map:** `MapPickerScreen` returns `PickedLocation`; shown only when `AppEnv.hasMaps`. Android reads the key from `env/prod.json` or `env/dev.json` in `build.gradle.kts`.

## 4. Done
- Earlier sections (Oct 31–Nov 1): full API layer (all endpoints), catalog, checkout, orders/tracking, account, driver app, platform config.
- Redesign phases 1–2: theme + shared widgets, auth flow (splash, onboarding, phone tabs, 4-digit OTP, profile, location).
- Phase 3: v6 models/ARB, curved bottom nav, home redesign, merged categories, providers sections + `ProvidersScreen`, vendor kind tabs.
- Phase 4: map + address picker, location screen adds a real address, home shows saved address, services request flow, service price accept/reject, bank transfer + receipt upload, removed credential `print`s in driver login, app id `com.ajyal.amar`, release APK builds.
- Error handling centralized (see section 3).
- Driver redesign 1 (Nov 3): home tab rebuilt to the driver design (header + online pill, location chip, earnings hero with spark bars from `Earnings.series`, then current task / available offers / offline card). Available offers moved to home (user choice); the "طلباتي" tab becomes history only. Driver shell uses the new `CurvedBottomNav`. New widgets in `widgets/driver/` and `widgets/common/` (`DotPill`, `BlinkingDot`, `CompactButton`, `DashedPainter`, `HeroCircle`). "Accept" opens the order screen (accept stays there). TODOs (no API): hours stat, trip minutes, bell unread dot.
- Driver redesign 2 (Nov 3): "طلباتي" = history only (summary tiles, all/completed/cancelled chips, grouped by day; `HistoryOrderTile`); "الرصيد" = `CashHeroCard` (cash on hand vs limit), period segments, `EarningsChartCard`, settlements as transactions; "حسابي" = `ProfileHeader` + `ProfileRow`s (edit, vehicle, notifications, language → profile screen, support, logout). Only logic touch: `DriverOrdersController.loadHistory()` (public wrapper, so available offers keep polling). Added `VehicleLabel`, `VehicleTypes` named consts, `DateFormatter.time/weekday/day`. Removed unused `stat_tile`, `location_status_card`, `driver_order_card`. TODOs (no API): driver fee + pickup on history items, earnings balance, growth %, settle-cash button, documents row.
- Driver redesign 3 (Nov 3): job screen (`DriverOrderScreen`) = `JobMap` (Google map with pickup/drop-off markers when `AppEnv.hasMaps` + coords, else drawn map) + `JobTopBar` + draggable sheet: offer view (header, route, fee, reject/accept) or task view (`ContactRow` customer/store with sms + call, `StageBar` over accepted→delivered, stage hint, route with directions, inline `ProofPhotoButton` / 4-box OTP / fields / note), `DeliveredPanel` on success. Removed `driver_action_sheet.dart` (inputs are inline now). Added `Launcher.sms` + Android `sms` query, `AppDefaults.deliveryOtpLength = 4` (design; API allows up to 10, verify).
- Driver redesign 4 (Nov 3): notifications screen (inline header + read-all, `DriverNotificationTile` with icon/tint picked by `event` keyword since the contract has no event enum, amber unread dot); profile edit restyled (`ProfileAvatar` now accepts `imageUrl`, vehicle `ChoicePill`s with `VehicleLabel`). Login screen already matched the driver design (phase 2), left unchanged. All driver screens in the design are now done.

## 5. In progress
- **Driver login fix (needs device check):** server compares the driver phone exactly as stored (`0599100001`); `+970599100001` returns 422 `fields.phone: بيانات الدخول غير صحيحة.` (confirmed in Postman). Driver login now sends `Validators.localPhone` (customer OTP still uses `normalizePhone` with `+970`).
- Driver redesign done in code; not yet checked on a device (home, tabs, job screen, notifications, profile).
- Phase task 3 not done: orders, tracking, notifications, account and cart screens still use the old layout (they work).
- Not tested on device/backend: map (key just added), address add, service request, quote accept, cash payment key, bank transfer receipt.
- Known: `test/widget_test.dart` has no `main` (no tests). Release is signed with the debug key. iOS map setup untested (built on Windows).

## 6. Next steps
1. User re-tests driver login on device.
2. User device QA of phase 4 flows; fix reported errors.
3. Production: keystore + release signing (outside git), `env/prod.json` with the real project key, build AAB, restrict/rotate maps key.
4. Restyle orders/tracking/notifications/account/cart to the design.
5. Later: persist cart, push notifications (Firebase), PDF receipts/attachments, background driver location, real tests.

## 7. Commands
- Run: `flutter run --dart-define-from-file=env/dev.json`
- Analyze: `flutter analyze` (4 pre-existing `unawaited_futures` infos expected); format: `dart format lib`
- l10n: merge ARB with Python, then `flutter gen-l10n`
- Debug APK: `flutter build apk --debug --dart-define-from-file=env/dev.json`
- Release APK (test only, debug-signed): `flutter build apk --release --dart-define-from-file=env/dev.json` → `build\app\outputs\flutter-apk\app-release.apk`
