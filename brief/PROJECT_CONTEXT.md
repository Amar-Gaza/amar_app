# AMAR (عَمار) — Project Context & Handoff

> Handoff for a new Claude session. Covers everything done so far (Oct 31 – Nov 2, 2026).
> Project root: `C:\amar_app-main\amar_app-main` (no git repository; the folder is not under version control).
> Design reference: `D:\ajyal_flutter\AMAR_Screens.html` (export of the Figma file `7HsVP9kcW3cUqFVhC2qUSI`, 120 screens).
> API contract: `api/amar-openapi.json` (copied from `D:\ajyal_flutter\amar-openapi.json`, OpenAPI 3.1, "config v4", 59 endpoints).

---

## 1. Project overview

**What it is.** A Flutter delivery/home-services marketplace for the Gaza Strip. One codebase contains two apps with **fully separate sessions**:
- **Customer app**: browse categories/vendors/products, build a cart (one vendor per cart), request a server quote, place an order, follow/track it, approve or reject price offers, rate, receipts, share a tracking link, and manage the account.
- **Driver app**: phone + password login, go online/offline, share location, see available jobs, accept/reject, run status transitions (`next_action`), deliver with a photo, see cash, settlements and earnings, and edit the profile.

The vendor/store dashboard is **not** in this repo.

**Backend.** Masar platform, `https://masar.toldpath.com/api` (paths under `/v1`). Every response is an envelope `{success, message, data, meta, request_id}`. Behaviour is server-driven: statuses, transitions, polling intervals, modules, currency, service area and payment methods all come from `GET /v1/app/config`.

**Tech stack**
- Flutter 3.47.7 stable (Dart ≥3.4), Android + iOS (`windows/` folder exists but is unused).
- State, navigation and DI: **GetX** (`get`).
- Networking: **Dio**, through one `ApiClient` with interceptors.
- Storage: `flutter_secure_storage` (tokens), `get_storage` (locale, config cache).
- l10n: `gen-l10n` from ARB files (Arabic first, RTL; English second).
- Icons: `lucide_icons_flutter`. Font: **Cairo** (bundled TTFs).

**Architecture (layered, one direction)**
```
presentation (screens/widgets) → controllers (GetX) → data/services → core/network (Dio)
core = theme, l10n, constants, utils, storage (shared by everything)
```
```
lib/
├── main.dart                     # AppPreferences.init() → AmarApp
├── app/
│   ├── amar_app.dart             # GetMaterialApp (theme, locale, routes)
│   ├── bindings/                 # initial, customer, catalog, checkout, orders, account, driver
│   └── routes/                   # app_routes.dart, app_pages.dart, route_args.dart, middleware/
├── controllers/{customer,driver,shared}/
├── core/{constants,localization,network,storage,theme,utils}/
├── data/models/{masar (generated), api, auth, cart, requests}/
├── data/services/{customer,driver,shared}/
├── l10n/                         # GENERATED (merged ARB + app_localizations*.dart)
├── presentation/screens/{splash,onboarding,auth,customer,catalog,checkout,orders,account,driver}/
├── presentation/widgets/{common,auth,splash,shell,home,catalog,checkout,orders,notifications,account,driver}/
└── theme/                        # masar_theme.dart (generated, only statusColors still used), masar_icons.dart
```
Other folders: `api/` (OpenAPI contract), `env/` (dart-define files), `l10n_src/{pack,custom}/` (ARB sources), `tool/` (`merge_arb.ps1`, `check_secrets.dart`, git hooks), `../assets/images/app_logo.png` (old logo, now unused), `assets/fonts/Cairo-*.ttf`.

---

## 2. Key decisions (and why)

**Design system**
- The design uses the **Cairo** font and a teal palette. The old IBM Plex / Tailwind-like theme was replaced.
- Cairo static TTFs (Regular/Medium/SemiBold/Bold/ExtraBold) were generated from the Google Fonts variable font with `fontTools.varLib.instancer`, because Flutter does not map `fontWeight` to variable axes.
- Color tokens live in `core/theme/app_color_extension.dart` (`AppColorExtension`):

  | Token | Value | Token | Value |
  |---|---|---|---|
  | `brand` | `#14624A` | `brandSoft` | `#E3EDEA` |
  | `brandBright` | `#1F8A66` | `brandDeep` | `#0F5240` |
  | `ink` | `#13281F` | `accent` | `#CDEBDC` |
  | `surfaceSoft` | `#F1F6F4` | `border` | `#DDE7E2` |
  | `mutedText` | `#667A70` | `subtleText` | `#8AA196` |
  | `amber` / `onAmber` | `#F2A93B` / `#4A2F00` | `disabled` | `#C9D6D0` |
  | `warning` / `warningSoft` | `#9A6200` / `#FFF3D9` | `danger` / `dangerSoft` | `#C0392B` / `#FDECEB` |
  | `success` / `successSoft` | `#1F7A55` / `#E3F3E8` | `info` / `infoSoft` | `#2F5BD1` / `#E0EBFF` |
  | `promoStart` / `promoEnd` / `onPromo` | `#FBE7C0` / `#F7D089` / `#5B3B05` | `skeleton` | `#E3EDEA` |

  Gradients: `brandGradient`, `heroGradient`, `promoGradient`. The primary color comes from the design, not from the server (`#5d9175` is ignored).
  A dark set is defined, but dark mode stays disabled (`AppTheme.mode = ThemeMode.light`).
- `AppTheme` (`core/theme/app_theme.dart`) builds `ThemeData` itself and no longer depends on `MasarTheme`.
- `BrandMark` loads `assets/images/app_logo.png` (added by the user) and shows a placeholder icon until the file exists. The app name is Amar / عَمَار.
- The design's notes such as "API" annotation boxes and "بيانات نموذجية للمعاينة" (sample data) banners are design annotations. They were **not** implemented.

**Navigation and UX**
- **Customer main nav (4 tabs):** Home, My orders, Notifications, Account (`CustomerShellScreen` + `ShellController`). The catalog design showed a different nav (Discover/Favorites); section 1's nav was kept.
- **Design "Discover" (catalog 01)** was merged into the Home tab, because the two screens are nearly identical.
- **Vendor availability (catalog 07)** is a tab inside the vendor page (`VendorTab.hours`).
- **Favorites (heart icon)** was not implemented: there is no endpoint for it.
- **Search** covers products only: `q` exists only on `/products`.
- **Map widgets:** there is no maps package. Address uses the GPS position (shows coordinates). Tracking shows coordinates plus an "open in maps" button. Driver pickup/drop-off rows have a directions button (`Launcher.map`).
- **OTP** uses the system keyboard plus SMS autofill (hidden `TextField` under `OtpBoxes`). The custom numeric keypad was deleted. A rejected code stays visible in red until the user retries or edits it.
- **Splash:** shows the dark brand screen (design 01). On retry after a failure it shows the light "preparing your experience" checklist (design 02, `ConfigLoadingView`). It restores the **driver session first**, then the customer session.

**Data and API**
- Every endpoint has a typed service method. Request bodies with structure use request model classes in `data/models/requests/`; simple ones use `ApiBody` constants.
- `ApiClient` helpers: `data<T>` (non-null data), `nullable<T>`, `command` (`data: null` endpoints), `page<T>` (returns `Paged<T>` using meta `page/per_page/total/last_page`), plus `parseList` and `parseObject`. `send` supports `role:` (forces which session token is attached), `idempotencyKey:`, `onSendProgress:`, and FormData (multipart content type).
- **Token per role:** `AuthInterceptor.resolve(options)` uses `extra['role']` first, otherwise the path prefix (`/v1/driver/*` = driver). This was needed because `/v1/uploads` is shared and a driver upload must carry the driver token.
- **Cart:** one vendor per cart, because a quote is per vendor (`AddToCartResult.otherVendor`, with a replace-cart confirmation). The cart is in memory only. No total is shown before a quote: prices come only from the server.
- **Checkout idempotency:** `CheckoutController` creates one `Idempotency-Key` per quote and reuses it on retries of `POST /v1/orders`, so the server never creates a duplicate order.
- **Quote invalidation:** changing the address, schedule, payment or coupon calls `_invalidateQuote()`.
- **Home:** vendors, products and the active order are fetched with `_optional()`. A disabled module hides its section instead of failing home; connectivity errors still propagate.
- **Driver config:** the driver app loads its own config (`GET /v1/app/config?app=driver`) into `DriverSessionController.config`. The user config has `driver: null`.
- **Driver location:** sent every `max(15s, config.driver.location_min_interval_seconds)` while online. Failed fixes are buffered (up to 100) and resent as `points[]`. Going online first sends a fresh location, because the server requires it.
- **Generated models:** `masar_models.dart` (generated for config v3) was kept. The only v4 drift was `Vendor.is_open`, patched manually; a header comment marks the patch.

**Naming conventions**
- Screens `XxxScreen`, tabs `XxxTab`, controllers `XxxController`, bindings `XxxBinding`, one widget per file.
- Route constants live in `AppRoutes`. Typed route args live in `route_args.dart` (`ProductsArgs`, `VendorsArgs`, `ProductArgs` with `.tag`). Order and driver-order routes pass the `int` id as `Get.arguments`.
- Constants classes in `core/constants/api_query.dart`: `ApiQuery`, `ApiBody`, `ApiExtra`, `ApiErrorCodes`, `ApiMeta`, `ApiModules`, `PaymentMethods`, `OrderScope`, `EarningsPeriod`, `PollKeys`, `OrderActions`, `OfferStatus`, `DriverActions`, `ActionRequires`, `DeliveryConfirmation`, `VehicleTypes`.
- All UI sizes come from `AppSizes`, `AppSpacing`, `AppRadius`, `AppTypography`. Strings come from ARB files; nothing is hardcoded.

---

## 3. Work completed (by area)

### 3.0 Redesign phase 1: theme and shared widgets (Nov 2, 2026)
The UI is being rebuilt from `brief/design.html`.
- Theme: new palette and gradients (`app_color_extension.dart`), new `app_shadows.dart`, updated `app_radius`, `app_sizes`, `app_spacing` (`page = 20`), `app_typography`, `app_theme` (buttons, fields, snackbar, switch, checkbox).
- New widgets in `widgets/common/`: `square_icon_button`, `segmented_tabs` + `segment_button` + `segment_item`, `tone_pill`, `surface_card`, `hero_card`, `press_scale`, `focus_glow`.
- Updated widgets: `primary_button`, `app_text_field` (`suffix`, `enabled`, focus ring), `brand_mark`, `brand_wordmark`, `app_top_bar` (`showBrand` removed), `avatar_initial`, `field_label`, `select_row`, `screen_scaffold`, `section_header`, `status_illustration`.
- Screens were not rebuilt yet; splash, onboarding and auth come in phase 2.
- Phase order: 1 theme and widgets (done), 2 auth flow (done), 3 home with stores/companies, 4 services and dashboard.
- Decision: customer login also uses OTP, because the contract has no other customer login.

### 3.0b Redesign phase 2: auth flow (Nov 2, 2026)
- Flow: splash, onboarding (3 slides), `PhoneScreen` (sign up / sign in tabs), OTP, `ProfileSetupScreen`, new `LocationScreen` (`AppRoutes.location`), home. Existing users go from OTP to home. Customer sign-in also uses OTP.
- `AuthController`: `isSignup`, `hasConsent`, `canSubmit`, `nameInput`; the name is sent to verify-otp on sign up only. OTP length is fixed at `ApiRules.otpLength = 4`; the resend countdown is `AppDefaults.otpResendSeconds = 45`.
- `ProfileSetupController`: prefilled name, read-only phone, avatar upload, `skip()`. Continue and Skip both open Location.
- `LocationScreen` has no logic: GPS and areas are shown as coming soon and only Skip works, until GPS and the map are added together. Terms and privacy links are display-only.
- New auth widgets: `form_steps`, `auth_heading`, `auth_body_text`, `consent_check`, `driver_entry_card`, `page_dots`, `onboarding_page`, `map_preview`, `map_stripes_painter`, `area_chip`, `otp_sent_line`. Removed: `auth_intro`, `consent_text`, `phone_line`, `step_progress`, `language_toggle`.
- Assets added: `assets/images/onboarding_{1,2,3}.png`, extracted from the design.

### 3.1 Theme, fonts, shared widgets
- `pubspec.yaml`: registered the `Cairo` family (weights 400–800 under `assets/fonts/`).
- `core/theme/`:
  - `app_color_extension.dart`: new tokens (see the table above).
  - `app_typography.dart`: `fontFamily = 'Cairo'`; `apply(base, ink, muted)`.
  - `app_sizes.dart`, `app_radius.dart` (adds `pill`, `xlAll`, `pillAll`).
  - `app_theme.dart`: builds the full ThemeData.
- `presentation/widgets/common/`:
  - Brand and navigation: `brand_mark.dart`, `brand_wordmark.dart`, `app_top_bar.dart` (centered title, square back button at start, optional trailing), `directional_icons.dart`.
  - Tiles and states: `icon_tile.dart`, `state_tone.dart` (`StateTone` enum and colors), `status_illustration.dart`, `state_view.dart` (generic full-screen state), `code_chip.dart`.
  - Banners and errors: `info_banner.dart`, `error_banner.dart`, `error_view.dart` (offline / unavailable / API error with request id), `support_reference.dart`, `offline_banner.dart`.
  - Buttons: `link_button.dart`, `primary_button.dart` (shadow, loading).
  - Lists and loading: `empty_view.dart`, `skeleton_box.dart`, `skeleton_list.dart`, `loading_view.dart`.
  - Fields and selection: `field_label.dart`, `app_text_field.dart` (label above, helper, counter, `prefixIcon`, `obscure`, `hintTextDirection`), `select_row.dart`, `language_sheet.dart`.
  - Other: `section_header.dart`, `avatar_initial.dart`, `network_thumb.dart`, `screen_scaffold.dart` (now supports `appBar` and pinned `bottom`).
- Removed: `brand_logo.dart`, `auth_header.dart`, `numeric_keypad.dart`, `keypad_key.dart`, `otp_expired_notice.dart`, `otp_resend_bar.dart`, the old home widgets, `home/product_card.dart`, and `screens/customer/home/home_screen.dart`.

### 3.2 Section 1: Auth and foundation (15 design screens)
- **Splash:**
  - `screens/splash/splash_screen.dart`, using `widgets/splash/splash_brand_view.dart` (01) and `config_loading_view.dart` + `config_step_row.dart` (02).
  - `SplashController` gained `isRetrying` and `DriverSessionController` injection; it routes to `driverHome`, `home` or `onboarding`.
- **Onboarding:** restyled (`BrandMark`). Its content was kept: there is no design for it.
- **Phone login (03):** `screens/auth/phone/phone_screen.dart`, with `widgets/auth/phone_field.dart` (dial-code segment), `language_toggle.dart` (EN/ع), `consent_text.dart`, `auth_intro.dart`, and a "أنت سائق؟" link to `driverLogin`.
- **OTP (04, 05A, 05B, 07A, 07B):**
  - `screens/auth/otp/otp_screen.dart` (state switcher) and `otp_form.dart`.
  - Widgets: `otp_input.dart`, `otp_boxes.dart`, `otp_resend_row.dart`, `phone_line.dart`, `auth_loading_view.dart`.
  - `AuthController`: new `otpInput`, `setCode()`, `retryOtp()`, `isVerifying`. `addDigit` and `deleteDigit` were removed. A failed verification keeps the code.
- **Profile completion (06):** `screens/auth/profile/profile_setup_screen.dart`, with `step_progress.dart`, `profile_avatar.dart` and a language picker. `ProfileSetupController` now takes `LocaleController` and sends `name + locale`.
- **Shell and home (08, 09):**
  - `screens/customer/shell/customer_shell_screen.dart` (`IndexedStack` + offline banner) and `widgets/shell/customer_bottom_nav.dart` + `nav_item.dart`.
  - `screens/customer/home/home_tab.dart`, with `widgets/home/`: `home_header.dart` (wordmark, cart button, bell, avatar), `home_search_field.dart`, `category_strip.dart`, `category_tile.dart`, `vendor_card.dart`, `horizontal_strip.dart`, `active_order_card.dart`.
- **States (10A–10D):** `SkeletonList`, `EmptyView`, `OfflineBanner` + `ErrorView` (offline), `ErrorView` (API error with `SupportReference`).
- `controllers/shared/connectivity_controller.dart` (connectivity_plus) drives the offline banner.

### 3.3 API layer (all 59 endpoints)
- `core/constants/api_endpoints.dart`: every path, including helper functions such as `order(id)` and `driverOrderTransition(id)`.
- `core/network/api_client.dart`: helpers described in section 2.
- `core/network/interceptors/auth_interceptor.dart` (`resolve`) and `error_interceptor.dart` (uses `resolve` for 401 events).
- `core/network/api_failure.dart`: adds `isConnectivity` and `isUnavailable`.
- Models added:
  - `data/models/api/`: `paged.dart`, `cancel_reason.dart`, `driver_login_result.dart`.
  - `data/models/requests/`: `address_request`, `place_input`, `quote_request` (`CartLine`, `QuoteItem`, `QuoteRequest`), `place_order_request`, `rate_order_request`, `vendor_application_request`, `transition_request` (+ `DeliverRequest`), `location_request` (`LocationPoint`, `LocationRequest`).
  - `data/models/cart/cart_item.dart`: `CartItem` (key, `choiceLabels`, `toCartLine()`) and `ProductOptionType`.
- Customer services (`data/services/customer/`):
  - `auth_service` (logout via `command`).
  - `profile_service`: `me`, `update(name, locale, avatarUploadId)`, `deleteAccount`, `updateFcmToken`.
  - `catalog_service`: `categories`, `vendors` (Paged), `vendor`, `products` (Paged), `product`, `applyAsVendor`.
  - `address_service`: list, create, update, delete.
  - `order_service`: list (Paged), show, quote, `place(request, idempotencyKey)`, `validateCoupon`, `cancelReasons`, cancel, events, offer, approve/reject offer, rate, receipt, tracking, create/revoke share link, `publicTracking`, `sandboxAdvance`.
  - `app_config_service` (unchanged).
- Shared services (`data/services/shared/`):
  - `notification_service`: `NotificationService.customer` / `.driver` named constructors; the driver instance is registered with tag `'driver'`.
  - `upload_service`: multipart, `role`, `onProgress`.
  - `device_location_service`: geolocator permission flow; throws `LocationException(LocationIssue)`.
- Driver services (`data/services/driver/`):
  - `driver_auth_service`: login, logout.
  - `driver_profile_service`: me, update, `setOnline`, fcm token.
  - `driver_order_service`: available, `current` (nullable), history (Paged), show, accept, reject, transition, deliver.
  - `driver_location_service`.
  - `driver_wallet_service`: cash, earnings, `sandboxSettleCash`.
- `app/bindings/initial_binding.dart`: registers all services (permanent), plus `CartController`, `ConnectivityController`, `DeviceLocationService` and `DriverSessionController`.
- `masar_models.dart`: added `Vendor.isOpen` (`is_open`).

### 3.4 Section 2: Catalog (14 design screens)
- **Routes:** `search`, `categories`, `vendors`, `vendor`, `products`, `product`, `productOptions`, `productQuantity`.
- **Bindings** (`app/bindings/catalog_binding.dart`): `SearchBinding`, `CategoriesBinding`, `VendorsBinding`, `VendorDetailsBinding`, `ProductsBinding`, `ProductBinding` (puts `ProductController` with `tag = productId`, shared by the details, options and quantity screens).
- **Controllers:**
  - `controllers/shared/paged_list_controller.dart`: base class with `fetch(page, perPage)`, `load`, `loadMore`, and a `loadOnInit` flag.
  - `catalog_search_controller.dart` (named this way to avoid Flutter's `SearchController`), `categories_controller.dart`, `vendors_controller.dart`, `vendor_details_controller.dart` (`VendorTab`), `products_controller.dart`, `product_controller.dart` (selections, qty, `missingRequired`, `addToCart`/`replaceCart`), `cart_controller.dart`.
  - `catalog_controller.dart` (home): categories, vendors, products and `activeOrder`.
- **Screens** (`presentation/screens/catalog/`): `search_screen` (02/03), `categories_screen` (04), `vendors_screen` (05), `vendor_details_screen` (06/07, tabs: products, hours, about), `products_screen` (08/13), `product_details_screen` (09/12, includes `ProductPriceMode`), `product_options_screen` (10), `product_quantity_screen` (11).
- **Widgets** (`presentation/widgets/catalog/`):
  - Grids and cards: `product_grid`, `product_grid_card`, `vendor_list_card`, `vendor_meta_line`, `category_row`.
  - Vendor page: `vendor_header`, `vendor_stats`, `cover_back_button`, `opening_hours_card` (parses `{sat:[["08:00","14:00"]]}`), `availability_banner`, `info_box`.
  - Inputs: `quantity_stepper`, `option_choice_tile`, `catalog_search_field`.
  - Cart: `cart_button` (badge, opens `cart`), `add_to_cart_flow` (vendor conflict and snackbar).
  - Icons: `category_icon` (maps server icon names such as `droplets`, `zap`, `snowflake` to Lucide).

### 3.5 Section 3: Cart and checkout (19 design screens)
- **Routes:** `cart`, `checkoutDelivery`, `checkoutAddresses`, `checkoutAddressNew`, `checkoutDetails`, `checkoutCoupon`, `checkoutQuote`, `checkoutReview`, `checkoutSuccess`.
- **Bindings** (`app/bindings/checkout_binding.dart`):
  - `CheckoutBinding` is on the `cart` route; the controller lives as long as the cart route.
  - `AddressFormBinding` passes an `Address` argument when editing.
- **Controllers:**
  - `checkout_controller.dart`: addresses, schedule, payment, vendor, note, attachments (`PendingUpload` with progress/failure/retry), coupon check/apply/remove, quote and countdown timer, `placeOrder`, `refreshQuote`, `quoteNeedsRefresh`.
  - `address_form_controller.dart`: create or edit, GPS `locate()`, `openSettings()`.
- **Screens** (`presentation/screens/checkout/`):
  - Cart and delivery: `cart_screen` (01–03), `delivery_screen` (04; schedule sheet + date/time pickers, payment sheet).
  - Addresses: `address_picker_screen` (05), `address_form_screen` (06; also used for account editing).
  - Details: `checkout_details_screen` (07–09B; note + image attachments via camera/gallery). The class is `CheckoutDetailsScreen`.
  - Coupon and quote: `coupon_screen` (10–11B), `quote_screen` (12), `quote_expired_view` (13).
  - Review and result: `review_screen` (14/17), `placing_order_view` (15), `order_success_screen` (16; blocks back, "Track" switches to the Orders tab).
- **Widgets** (`presentation/widgets/checkout/`): `checkout_steps`, `bottom_action_bar`, `checkout_row`, `cart_line_card`, `label_value_row`, `payment_label` (`paymentLabel()`), `price_card` (`PriceLineKeys`), `attachment_tile`.

### 3.6 Section 4: Orders and tracking (20 design screens)
- **Routes:** `order`, `orderCancel`, `orderOffer`, `orderTracking`, `orderReceipt`, `orderRate`, `orderShare`, `publicTracking`.
- **Bindings** (`app/bindings/orders_binding.dart`): `OrderDetailsBinding`, `OrderActionsBinding`, `TrackingBinding`, `PublicTrackingBinding` (optional token argument).
- **Controllers:**
  - `orders_controller.dart` (tab, scopes, paging).
  - `order_details_controller.dart`: polls `events?since=` at `polling.events_seconds` and reloads the order.
  - `order_actions_controller.dart`: cancel reasons/cancel, offer load/approve/reject, rate, receipt, share link create/revoke.
  - `tracking_controller.dart`: polls on `tracking.next_poll_seconds`.
  - `public_tracking_controller.dart`: accepts a token or a full `/track/<token>` URL.
  - `notifications_controller.dart`: list, read all, opened.
- **Screens** (`presentation/screens/orders/`): `order_details_screen` (05/06, actions from `available_actions`, offer banner when the status is `priced`), `cancel_order_screen` (07/08), `offer_screen` (09–11), `tracking_screen` (12/13/17A–C), `receipt_screen` (14), `rate_order_screen` (15), `share_link_screen` (16, copies via Clipboard), `public_tracking_screen` (16B / account 13).
- **Tabs:** `screens/customer/orders/orders_tab.dart` and `notifications/notifications_tab.dart` use real data. Order cards open the order details.
- **Widgets** (`presentation/widgets/orders/`): `status_chip` (server hex color), `order_card`, `scope_tabs`, `status_progress`, `section_card`, `timeline_list`, `person_card` (call button), `route_card` (optional directions). Also `widgets/notifications/notification_tile.dart`.
- **Utilities:**
  - `core/utils/hex_color.dart`, `core/utils/date_formatter.dart`.
  - `core/utils/launcher.dart`: `call`, `web`, `map` (Google Maps directions URL).
  - `AppConfigController`: added `poll(key, fallback)` and `lastStep`.

### 3.7 Section 5: Account (16 design screens)
- **Routes:** `editProfile`, `addresses`, `addressForm`, `vendorApplication`, `support`.
- **Bindings** (`app/bindings/account_binding.dart`): `EditProfileBinding`, `AddressesBinding`, `VendorApplicationBinding`.
- **Controllers:** `edit_profile_controller.dart` (uploads the avatar with purpose `avatar`, then `PUT /me`, then changes the locale), `addresses_controller.dart`, `vendor_application_controller.dart` (optional GPS, categories from `modules_config.vendors.categories`).
- `SessionController.deleteAccount()`: `DELETE /me`, clears the session, goes to `phone`.
- **Screens:**
  - `screens/customer/account/account_tab.dart`: menu with profile, addresses, public tracking, join as vendor, support, terms (`config.terms_url`), logout, delete account.
  - `screens/account/`: `edit_profile_screen`, `addresses_screen`, `vendor_application_screen` (form + result), `support_screen` (calls `project.support_phone`).
- **Widget:** `widgets/account/menu_tile.dart`.

### 3.8 Section 6: Driver app (36 design screens)
- **Routes:** `driverLogin`, `driverHome`, `driverOrder`, `driverProfile`, `driverNotifications`.
- `app/routes/middleware/driver_auth_middleware.dart` guards the driver routes.
- **Bindings** (`app/bindings/driver_binding.dart`):
  - `DriverShellBinding` puts `DriverLocationController` (permanent), plus Home, Orders and Wallet controllers.
  - Also `DriverOrderBinding`, `DriverProfileBinding`, `DriverNotificationsBinding` (`NotificationsController` with `tag: driverTag = 'driver'`).
- **Controllers** (`controllers/driver/`):
  - `driver_session_controller.dart`: restore, login, logout, driver config, listens for driver 401s.
  - `driver_location_controller.dart`: `LocationState` (idle, sending, ok, permission, unavailable, failed); `start`, `stop`, `sendNow`; buffered points.
  - `driver_home_controller.dart`: `DriverTab`; refreshes me + current order + today's earnings; `setOnline`.
  - `driver_orders_controller.dart`: available (polled at `available_orders_seconds`) and history.
  - `driver_order_controller.dart`: accept, reject, `runNext()` for accept/transition/deliver; `needsPhoto`/`needsOtp`/`needsLocation`; photo upload with the driver role; `delivered` flag.
  - `driver_wallet_controller.dart`: cash and earnings by period.
  - `driver_profile_controller.dart`: locale, vehicle type, avatar.
- **Screens** (`presentation/screens/driver/`):
  - Entry and shell: `driver_login_screen` (01/03), `driver_shell_screen`.
  - Tabs: `driver_home_tab` (04/05 + location card), `driver_orders_tab` (08/09), `driver_wallet_tab` (26–30), `driver_account_tab` (31/35).
  - Job flow: `driver_order_screen` (10–18, 21, 22; includes `pickProofPhoto()`), `driver_action_sheet` (19/20: photo, OTP, fields, note).
  - Profile and inbox: `driver_profile_screen` (32), `driver_notifications_screen` (33/34).
- **Widgets** (`presentation/widgets/driver/`): `driver_order_card`, `location_status_card` (06/07/23–25), `stat_tile`.

### 3.9 Platform and config files
- `android/app/src/main/AndroidManifest.xml`:
  - Added `INTERNET`, `ACCESS_COARSE_LOCATION`, `ACCESS_FINE_LOCATION`.
  - Added `<queries>` intents for `tel`, `https` and `geo`.
- `ios/Runner/Info.plist`: added `NSLocationWhenInUseUsageDescription`, `NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription` (Arabic text).
- `pubspec.yaml`: `lucide_icons_flutter` ^1.2.0 → **^4.0.1**, added **`url_launcher: ^6.3.1`**, registered the Cairo fonts.
- `env/dev.json` (git-ignored) was created with `AMAR_PROJECT_KEY` (a test key). **The key is intentionally not copied into this file.**
- `.idea/runConfigurations/main_dart.xml`: `additionalArgs = --dart-define-from-file=env/dev.json`.
- `.vscode/launch.json` was created with the same args.
- `l10n_src/custom/app_custom_{ar,en}.arb`:
  - Hundreds of keys were added.
  - Removed: `phoneConsent`, `otpSubtitle`, `otpResendIn`, `homeGreeting`, `homeCategoriesEmpty`.
  - `commonRetry` changed to "إعادة المحاولة".
  - Merged output goes to `lib/l10n/app_{ar,en}.arb`, then `flutter gen-l10n`.

---

## 4. Bugs and fixes

1. **The project did not compile at all.** `lucide_icons_flutter 1.3.0` declares `LucideIconData extends IconData`, but `IconData` is `final` in Flutter 3.47. Fix: upgraded to `^4.0.1`. All icon names used were checked against the new version.
2. **Release builds could not reach the network.** The main `AndroidManifest.xml` lacked `INTERNET` (only the debug manifest had it). Fix: added it to the main manifest.
3. **Phone hint and dial-code segment rendered wrong in RTL.** The hint showed reversed digit groups, and the divider was on the wrong side. Fix: `hintTextDirection: textDirection` in `AppTextField`; the dial-code `Container` uses `BorderDirectional(end:)` with only the `Text` forced to LTR.
4. **Splash content was not centered.** A Column in a SafeArea shrank to its content. Fix: wrapped it in `SizedBox(width: double.infinity)`.
5. **ICU error in ARB** for "Today's summary". `use-escaping: true` treats `'` specially. Fix: changed the text to "Summary for today". Rule: **avoid apostrophes in ARB strings.**
6. **Class name clash.** `OrderDetailsScreen` existed in both checkout and orders. Fix: renamed the checkout one to `CheckoutDetailsScreen` (`checkout_details_screen.dart`).
7. **`'attached': is not true` assertion** (`RenderEditable._snapToPhysicalPixel`).
   - Cause: when the OTP was complete, `OtpScreen` replaced the whole screen with `AuthLoadingView`. The hidden OTP `TextField` was destroyed while focused, and a show-caret frame callback ran on a detached render object.
   - Fix (a): `OtpInput.onChanged` unfocuses (`FocusScope.of(context).unfocus()`) when the code is full.
   - Fix (b): `OtpScreen` keeps `OtpForm` mounted and shows the loader as a `Positioned.fill` overlay in a `Stack`.
8. **"A TextEditingController was used after being disposed"** (Login → Driver login → back to customer login → tap field).
   - Cause: `DriverLoginScreen`'s "not a driver?" button used `Get.offAllNamed(AppRoutes.phone)`. GetX built the new phone route reusing the already-registered `AuthController`, then disposed it together with the old route, which disposed `phoneInput`.
   - Fix in `driver_login_screen.dart`: `Navigator.of(context).canPop() ? Get.back<void>() : Get.offAllNamed<void>(AppRoutes.phone)`.
   - **General rule: never `offAllNamed` to a route whose controller instance is still alive below in the stack.**
9. **Lint follow-ups.** Added `await` to new `Get.offAllNamed` calls (splash driver branch, driver session login/expire, `deleteAccount`), and added curly braces in `driver_orders_controller.dart`. The 4 remaining `unawaited_futures` infos are pre-existing (`splash_controller` customer branch, `session_controller` ×2, `locale_controller`).
10. **Test-only issues (not app bugs).** `CachedNetworkImage` throws `MissingPluginException(getTemporaryDirectory)` in widget tests. The ₪ glyph is missing from the Cairo font in tests; on devices it should fall back to a system font (unverified).

---

## 5. Current state

**Verified**
- `flutter analyze`: **0 errors, 0 warnings**, 4 pre-existing infos (`unawaited_futures`).
- `flutter build apk --debug --dart-define-from-file=env/dev.json` succeeded (`√ Built build\app\outputs\flutter-apk\app-debug.apk`). Gradle warns about the Kotlin Gradle Plugin version (pre-existing, not blocking).
- Live API (test key), public endpoints only:
  - `app/config` (user and driver), `categories`, `vendors`, `products` all parse with the Dart models.
  - `?page=` works (meta: `page/per_page/total/last_page`).
  - `/v1/orders` returns 401 without a token, as expected.
- Visual golden renders of sections 1–3 (temporary tests, since deleted) were compared with the design and matched.

**Untested (needs a real device and accounts)**
- The whole authenticated flow end to end: OTP login, addresses, uploads, quote, place order, offers, tracking, rating, sharing, account deletion.
- The entire driver app: login, online toggle, location, accept, transitions, deliver with photo, wallet.
- Screens of sections 4–6 were **not** visually rendered or compared with the design; only analyzed and compiled.
- The two latest fixes (OTP caret assertion, disposed controller) were not re-run on a device.

**Partial or limitations**
- No in-app map (coordinates plus external maps).
- Attachments are images only (no `file_picker`, so no PDF).
- Dynamic `AppConfig.fields` forms are not built (the project config currently has `fields: {}`). Driver `next_action.fields` render raw keys as labels.
- No push notifications: the FCM token endpoints exist in the services, but Firebase is not integrated.
- Driver location is sent only while the app is in the foreground (no background service).
- The cart is in-memory only (lost on app restart).
- Several opaque values are shown raw: vehicle types (`motorcycle`, …), offer status chip, vendor categories (`electronics`, `Maintenance`) and vendor application status.
- `README.md` roadmap was not updated (it still says phases 3–6 are planned).
- `test/widget_test.dart` is still the commented-out template; there is no real test suite.

---

### 3.0c Phase 3: home, bottom nav, unified categories (Amar redesign)
- **Models/ARB:** `masar_models.dart` and `l10n_src/pack` are now v6. `ProductKinds`, `PriceModes`, `OrderStatusKeys` live in `api_query.dart`.
- **Tabs:** `CustomerTab { home, orders, cart, account }`. Notifications moved to the `AppRoutes.notifications` route (bell). `/cart` route removed: `CartTab` applies `CheckoutBinding` and deletes `CheckoutController` when the tab closes; checkout steps stay pushed above the shell. `CartButton` pops to home and selects the cart tab.
- **Bottom nav:** `customer_bottom_nav`, `nav_bar_painter` (moving notch), `nav_item`, `nav_badge`.
- **Home:** header, search, `active_order_card` + `progress_segments`, `promo_banner` (fixed, no endpoint), `category_grid`, `home_product_card`, `provider_section` + `provider_card` + `provider_logo`. "View all" opens `ProvidersScreen` (`AppRoutes.providers`, reads `CatalogController`).
- **Categories:** `CategoryGroup.merge` unifies server categories by trimmed name and drops empty ones; `ProductsArgs.categoryIds` fetches all ids and merges each page.
- **Providers:** `ProviderEntry.build` joins vendors with the first page (`AppDefaults.catalogPageMax`) of each kind. A vendor whose items fall past that page is not listed.
- **Vendor page:** `VendorTab { products, services, hours, about }`; only the kinds the vendor offers get a tab (`products?vendor=&kind=&per_page=1`).
- **Not backed by an endpoint:** promo banner and "most ordered" order (first products returned).

### 3.0d Phase 4: map, services, bank transfer
- **Map:** `google_maps_flutter`. Key `AMAR_MAPS_KEY` lives in `env/*.json` (Android: read by `android/app/build.gradle.kts`, prod file first; Dart: `AppEnv.hasMaps`) and `ios/Flutter/Maps.xcconfig` (git-ignored, see `Maps.example.xcconfig`). `MapPickerScreen` returns `PickedLocation`; without a key the address form stays GPS only. Area chips removed because `zones` is empty.
- **Services:** never enter the cart. `CartController.service` holds the pending item, `AppRoutes.serviceRequest` runs the checkout screens on it (`CheckoutBinding`), and a date from tomorrow on is required. Scheduling for products also starts tomorrow; "now" stays available for products.
- **Price approval:** `OrderDetailsController` loads `service-quote`; `ServiceQuoteCard` accepts or rejects (409 `quote_changed` reloads the price).
- **Bank transfer:** `CheckoutController.paymentOptions` merges config methods with `/vendors/{id}/payment-methods`; `TransferReceiptCard` uploads (`payment_receipt`, images only) on `awaiting_payment`.

## 6. Pending tasks / next steps (priority order)

1. **Device QA (user):** run both flows on a phone and fix the reported runtime errors. Pay special attention to:
   - quote/place-order payloads (`QuoteRequest.cart` options format, `dropoff_address_id`),
   - `PUT /me` accepting `locale`,
   - upload `purpose` values the server accepts (`order_attachment`, `avatar`, `delivery_proof`, `transition_proof` are assumptions),
   - the driver deliver flow with `delivery_confirmation: photo`,
   - the `open_now` query format (`1/0`).
2. Visually compare sections 4–6 with the design (render goldens like before: temporary test + fixtures, then delete them).
3. Look for more GetX `offAllNamed` same-route disposal risks:
   - `SessionController.signOut`/`_onUnauthorized` → `phone`,
   - `DriverSessionController.logout` → `driverLogin`,
   - checkout `offNamedUntil`.
4. Persist the cart (`get_storage`) and optionally the checkout draft.
5. Localize raw server keys: vehicle types, offer status, application status (map to ARB).
6. Push notifications (Firebase + `PUT /me/fcm-token`, `/driver/me/fcm-token`).
7. Background location for drivers (foreground service), if required.
8. Optional: a maps package for the address picker and tracking, and `file_picker` for PDF attachments.
9. Update `README.md` roadmap and project structure; write real widget and unit tests; regenerate `masar_models.dart` from the Masar Developer Center for config v4.
10. Ask the team lead to rotate the test project key, which was pasted in chat.

---

## 7. User rules and preferences (keep following)

- **Language:** the user writes in Arabic (Levantine/Palestinian dialect). **Reply in Arabic (Levantine), Arabic script**; never transliterated Latin. Code, identifiers and comments stay in English.
- **"كمل كل اشي بدون سوال":** the user asked to continue all remaining work **without asking questions**. Proceed autonomously and report at the end.
- When the user asks for a fix with "keep the response minimal", give the exact concise fix.
- **Project conventions** (from README; enforced throughout):
  - No hardcoded values: colors, sizes, strings, durations, endpoints and headers come from theme tokens, constants or ARB.
  - One widget per file; small custom widgets.
  - Controllers are UI-free: no `BuildContext`, no widgets.
  - One networking path: no `Dio` outside `core/network`.
  - Scope discipline: build only what the spec/design and API support (e.g. no favorites without an endpoint).
  - Conventional Commits if committing (repo is not git yet).
  - Match the surrounding code style and comment density.
- **Secrets:**
  - Keys live only in `env/dev.json` (git-ignored); never put keys in code, docs, logs or chat.
  - The key must be passed via `--dart-define-from-file=env/dev.json` (IDE run configs already do this).
  - **Do not write the project key into any committed file** (including this one).
- **l10n workflow:**
  - Add keys to `l10n_src/custom/app_custom_{ar,en}.arb`, never to `l10n_src/pack` and never with the reserved prefixes `status|action|confirm|cancelReason|error`.
  - Then merge into `lib/l10n/app_{ar,en}.arb` with the same rules as `tool/merge_arb.ps1`, and run `flutter gen-l10n`.
  - `merge_arb.ps1` needs PowerShell 7 (`-AsHashtable`), which is not installed; an equivalent Python merge was used.
  - Avoid apostrophes in ARB values.
- Do not modify generated files except the documented `Vendor.isOpen` patch: `lib/l10n/*` are generated, `masar_models.dart`, `masar_theme.dart` and `masar_icons.dart` are Masar-generated.
- After changes, always run `flutter analyze` (and `dart format lib`).

---

## 8. Important details

**Environment and run**
- Flutter at `C:\src\flutter` (3.47.7), Dart SDK also at `C:\Program Files\Dart`. Windows 11, Git Bash + PowerShell 5.1. Chrome available (used headless to render the design HTML to PNGs).
- Run: `flutter run --dart-define-from-file=env/dev.json`.
- `env/dev.example.json`: `{ "AMAR_PROJECT_KEY": "REPLACE_ME", "AMAR_DEV_MEMBER": "" }`. `AppEnv` reads `AMAR_PROJECT_KEY`, `AMAR_DEV_MEMBER`, `AMAR_APP_VERSION`; `baseUrl = https://masar.toldpath.com/api`.
- Headers sent on every request: `X-Project-Key`, `Accept`, `Accept-Language`, `X-App-Version`, `X-Config-Version`, optional `X-Dev-Member`. Auth uses `Authorization: Bearer`, and `Idempotency-Key` is added where needed.
- Test device seen: Xiaomi `25078RA3EA`. Installing failed with `INSTALL_FAILED_USER_RESTRICTED`; it needs "Install via USB" enabled in Developer options (Mi account + SIM).

**Dependencies:** `get ^4.6.6`, `dio ^5.7.0`, `flutter_secure_storage ^9.2.2`, `get_storage ^2.1.1`, `intl any`, `lucide_icons_flutter ^4.0.1`, `cached_network_image ^3.4.1`, `connectivity_plus ^6.0.5`, `uuid ^4.5.1`, `image_picker ^1.1.2`, `geolocator ^13.0.1`, `url_launcher ^6.3.1`; dev: `flutter_lints ^4.0.0`.

**Live project config (test project, config_version 4)**
- `modules`: approval, attachments, catalog, coupons, public_tracking, vendors.
- `payment_methods`: `[cash_on_delivery]`. `currency`: ILS ₪ (minor units 100). `fields`: `{}`.
- `modules_config`:
  - `catalog.cart`: max_lines 50, max_qty 99.
  - `vendors`: require_vendor, `categories: [electronics, maintenance]`.
  - `attachments`: max 10 files, 10 MB, jpeg/png/webp/pdf.
  - `approval`: priced_by operator, offer_ttl 60 min.
  - `public_tracking`: link_hours 48.
- `polling` (seconds): tracking 5, events 5, available_orders 10, notifications 30, config 300.
- Driver config (`?app=driver`): `driver {radius_km:10, location_min_interval_seconds:3, online_requires_location_minutes:5}`, `delivery_confirmation: photo`, driver-visible statuses pending → delivered/cancelled.
- Statuses: awaiting_pricing → priced → awaiting_vendor → preparing → pending → accepted → picked_up → on_the_way → arrived → delivered; cancelled.
- `service_area`: a GeoJSON Polygon around Gaza. Server returns `out_of_zone` for points outside it.

**Data quirks observed:** some category names have leading tabs (trimmed in the UI). Vendor `category` values are English keys. Most products have no image. `opening_hours` is `{day: [[from,to],...]}` with keys `sat..fri` (may be `{}`).

**Endpoints (all under `/v1`)**
- **Shared:**
  - `GET app/config?app=user|driver`
  - `POST uploads` (multipart: file, purpose)
  - `GET track/{token}` (public)
- **Customer auth and profile:**
  - `POST auth/send-otp`, `auth/verify-otp`, `auth/logout`
  - `GET|PUT|DELETE me`, `PUT me/fcm-token`
- **Catalog:**
  - `GET categories?vendor&kind`
  - `GET vendors?lat&lng&category&open_now&page&per_page`, `vendors/{id}`
  - `GET products?category&vendor&kind&q&page&per_page`, `products/{id}`
  - `POST vendor-applications`
- **Addresses:** `GET|POST addresses`, `PUT|DELETE addresses/{id}`.
- **Orders:**
  - `POST orders/quote`, `POST orders` (Idempotency-Key), `GET orders?scope=active|completed|cancelled&page&per_page`, `GET orders/{id}`
  - `POST orders/{id}/cancel`, `GET orders/{id}/events?since=`
  - `GET orders/{id}/offer`, `POST .../offer/approve` (Idempotency-Key), `POST .../offer/reject`
  - `POST orders/{id}/rate`, `GET orders/{id}/receipt`
  - `POST|DELETE orders/{id}/share-link`, `GET orders/{id}/tracking`
  - `GET cancel-reasons`, `POST coupons/validate`
  - `POST sandbox/orders/{id}/advance`
- **Notifications:** `GET notifications?unread&per_page`, `POST notifications/read-all`, `POST notifications/{id}/opened` (the same three exist under `/driver`).
- **Driver:**
  - `POST driver/auth/login|logout`
  - `GET|PUT driver/me`, `PUT driver/me/fcm-token`, `PUT driver/status` (is_online)
  - `POST driver/location`
  - `GET driver/cash`, `GET driver/earnings?period=day|week|month`
  - `GET driver/orders/available|current|history`, `GET driver/orders/{id}`
  - `POST driver/orders/{id}/accept` (idem), `/reject`, `/transition` (idem), `/deliver` (idem)
  - `POST driver/sandbox/settle-cash`
- **Error codes used:** `unauthenticated`, `otp_invalid`, `otp_expired`, `validation_failed`, `network_error`, `timeout`, `server_error`, `maintenance`, `quote_expired`, `quote_used`, `out_of_zone`, `already_taken`, `invalid_transition`, `cash_limit_reached`, `too_many_requests`, `app_update_required`, `missing_project_key`.

**Routes (`AppRoutes`)**
- **Auth and shell:** splash `/`, onboarding `/onboarding`, phone `/phone`, otp `/otp`, profile `/profile`, home `/home` (customer shell).
- **Catalog:** search `/search`, categories `/categories`, vendors `/vendors`, vendor `/vendor` (arg int), products `/products` (`ProductsArgs`), product `/product` (`ProductArgs`), productOptions `/product/options`, productQuantity `/product/quantity`.
- **Checkout:** cart `/cart`, checkoutDelivery `/checkout/delivery`, checkoutAddresses `/checkout/addresses`, checkoutAddressNew `/checkout/addresses/new`, checkoutDetails `/checkout/details`, checkoutCoupon `/checkout/coupon`, checkoutQuote `/checkout/quote`, checkoutReview `/checkout/review`, checkoutSuccess `/checkout/success` (arg `Order`).
- **Orders** (arg int order id): order `/order`, orderCancel `/order/cancel`, orderOffer `/order/offer`, orderTracking `/order/tracking`, orderReceipt `/order/receipt`, orderRate `/order/rate`, orderShare `/order/share`. Also publicTracking `/track` (optional String token).
- **Account:** editProfile `/account/profile`, addresses `/account/addresses`, addressForm `/account/addresses/form` (optional `Address`), vendorApplication `/account/vendor-application`, support `/account/support`.
- **Driver:** driverLogin `/driver/login`, driverHome `/driver`, driverOrder `/driver/order` (arg int), driverProfile `/driver/profile`, driverNotifications `/driver/notifications`.
- Middlewares: `CustomerAuthMiddleware` (profile, home, cart, order), `DriverAuthMiddleware` (driverHome, driverOrder).

**Key models (`masar_models.dart`):** `AppConfig`, `User`, `Driver`, `Category`, `Vendor` (+isOpen), `Product`/`ProductOption`(type single|multi)/`ProductChoice`, `Money{amount, formatted}`, `Address`, `Quote`, `PriceLine`, `Order` (status, availableActions `OrderAction{action: cancel|track|rate}`, timeline, price, driver `DriverPublic`), `OrderSummary`, `OrderEvent`, `Offer`/`OfferItem`, `Tracking`, `Receipt`, `ShareLink`, `PublicTracking`, `DriverOrder` (nextAction `NextAction{action: accept|transition|deliver, to, requires[], fields[], confirm}`, isMine, earning, payment.collect), `Cash`, `Earnings`, `AppNotification`, `Upload`, `CouponCheck`, `Status{key,label,color,icon,step,isTerminal}`.

**Assumptions made (unverified with the backend)**
- The `page` query param works for all paged lists (verified only on products).
- `open_now` is sent as `1/0` and `unread` as `1/0`.
- Upload purposes: `order_attachment`, `avatar`, `delivery_proof`, `transition_proof`.
- `PUT /me` accepts `locale`.
- `PriceLine` keys treated as standard rows: `items`, `items_total`, `delivery`, `delivery_fee`, `discount`, `coupon`, `total`.
- Offer exists when the order status is `priced`.
- `next_action.requires` values `photo`, `otp`, `location`.

---

## 9. Open questions and risks (need the user's confirmation)

1. The test project key was pasted in chat. Rotate it?
2. `pubspec.yaml` description says "home services app" while the README says "delivery marketplace". Which is correct?
3. Driver login lives inside the customer app (link on the phone screen). Is a separate driver build/flavor wanted instead?
4. Is background location tracking for drivers required? It needs a foreground service and more permissions.
5. Is a real map (Google Maps key) wanted for addresses and tracking?
6. Should the cart persist across app restarts?
7. Are the assumed upload `purpose` strings accepted by the server?
8. Should Firebase push notifications be integrated now?
9. The `lucide_icons_flutter` major upgrade (1 → 4) and the new `url_launcher` dependency were added without explicit approval. OK to keep?
10. The vendor `category` values and vehicle types come raw from the server. Translate them in ARB, or ask the backend for labels?

---

## 10. Starter prompt for a new session

```
اقرأ ملف PROJECT_CONTEXT.md في جذر المشروع (C:\amar_app-main\amar_app-main) كاملاً قبل أي شيء،
والتزم بالقواعد في القسم 7 (الرد بالعربي باللهجة الشامية، اتباع اتفاقيات الكود، عدم وضع المفاتيح في الملفات).
بعدها شغّل `flutter analyze` للتأكد من الحالة، ثم كمّل من القسم 6 (Pending tasks) حسب الأولوية،
أو صلّح أي خطأ أبعثه لك من الجوال. لا تسألني أسئلة إلا إذا كان القرار فعلاً لي.
```
