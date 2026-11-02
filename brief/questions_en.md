# Amar app: open questions before coding

No code has been changed. Questions 1 to 3 need an answer before work can start. The others have a recommended default.

## Blockers

- **Missing dashboard contract and code (Q1):** The Postman files cover only the user app and the driver app. OpenAPI has no endpoints to create, edit, or delete products or services. The project context also says the vendor dashboard is not in this repo.
- **Missing `env/dev.json` (Q2):** Without the test project key, I can't call the live API or check real data such as `zones` and a service's `fields`.
- **Unclear app name and logo (Q3):** The brief says "Ghammar", but the design and API say "عَمَار". The only logo in the repo, `assets/images/logo.png`, is a letter A with a wrench.

## Questions

### 1. What does "dashboard" mean for this task?

- **Option A, real dashboard:** You send the dashboard code and its API contract, and I build full create, edit, and delete flows for products and services. This delivers the task as written, but it can't start without those files.
- **Option B, customer app only:** I add services to this app: browsing, booking, status tracking, and accepting or rejecting a price. This can start now, but it includes no management features.
- **Difference:** Option A lets vendors manage their items. Option B lets customers use services.
- **Recommended: Option B for now, if only this app is in scope.** The backend already supports it; full management needs Option A.

### 2. How will the test key be provided?

- **Option A, you add `env/dev.json` locally:** I can test against live data, and the key stays out of chat and git.
- **Option B, continue without it:** Work can continue, but real response values stay unverified, so some questions may come back later.
- **Difference:** Option A checks the work against real data. Option B relies on the written contract alone.
- **Recommended: Option A.** Do not paste the key in chat; `env/dev.json` is already git-ignored.

### 3. Which app name and logo are final?

- **Option A, keep "عَمَار" with the current logo:** No new asset or contract change is needed, and the name matches the design and API.
- **Option B, change the name to "Ghammar" or use a new logo:** You give me the exact name in Arabic and English, plus the logo file if it changes. All visible branding then changes.
- **Difference:** Option A uses what already exists. Option B needs your final branding first.
- **Recommended: Option A.** It matches the current design and API, and I'd use the logo on both Splash and the Home header instead of "ع".

### 4. How should Home separate stores and companies?

The API has no store or company type. Every provider is a `Vendor`, and the type sits on each item as `kind = product | service`. Vendors can't be filtered by kind.

- **Option A, combine three lists in the app:** Fetch `products?kind=product`, `products?kind=service`, and `vendors`, then match them by `vendor_id`. This uses the current API, and a provider with both kinds appears in both sections automatically.
- **Option B, ask for a backend change:** Add a vendor kind or filter. The app logic becomes simpler, but the work must wait for the backend.
- **Difference:** Option A works now with more logic in the app. Option B is cleaner but depends on another team.
- **Recommended: Option A.** It needs no backend change.

### 5. Should Home show one card per provider or one per item?

- **Option A, one card per provider:** Each section shows a provider once, with its first matching item.
- **Option B, one card per item:** A provider with five products appears five times.
- **Difference:** Option A keeps the sections short and provider-focused. Option B shows more items but repeats providers.
- **Recommended: Option A.** It matches your rule that a provider with both kinds appears exactly twice; tapping a card opens the provider page.

### 6. What should the section titles say?

- **Option A, "المتاجر" and "خدمات الشركات":** The second title makes it clear that this section lists services.
- **Option B, "المتاجر" and "الخدمات":** The second title is shorter, but it doesn't mention companies.
- **Difference:** Only the second title changes. Both sections keep "عرض الكل" (View all).
- **Recommended: Option A.** It is the clearest match for the stores and companies split.

### 7. What should happen to "الأكثر طلباً" (Most ordered)?

The API has no sort by popularity.

- **Option A, rename it "منتجات مختارة" (Selected products):** The section stays and shows regular items from `/products`.
- **Option B, keep the title:** The layout matches the design exactly, but the title makes a claim the data doesn't support.
- **Option C, remove the section:** The title problem goes away, but Home no longer matches the design here.
- **Difference:** Option A keeps the section with an honest title, Option B keeps the wording, and Option C removes it.
- **Recommended: Option A.** It keeps the layout without making a false claim.

### 8. What should happen to the "خصم 15%" banner?

The API has no offers or promotions endpoint.

- **Option A, remove it:** Home shows only real data.
- **Option B, keep it as a fixed banner:** Home matches the design, but the offer would not be real.
- **Difference:** Option A avoids fake content. Option B keeps the visual element.
- **Recommended: Option A.** The brief forbids fake data.

### 9. What should the search hint say?

Search uses `q` on `/products`, so it doesn't search stores.

- **Option A, change it to "ابحث عن خدمة أو منتج":** The hint promises only what search can do.
- **Option B, keep the design text, which includes "متجر":** It matches the design, but a store search may return nothing.
- **Difference:** Option A is accurate. Option B follows the design wording.
- **Recommended: Option A.** Users shouldn't be promised a search the API doesn't provide.

### 10. How should sign up and sign in work?

The server uses phone and OTP only, with no password. A new number creates an account automatically.

- **Option A, keep two tabs:** "إنشاء حساب" asks for name, phone, and terms. "تسجيل الدخول" asks for phone only. Both go through OTP.
- **Option B, use one phone screen:** There is one simple flow, and new users enter their name later. It removes the design's two tabs.
- **Difference:** Option A stays closer to the design. Option B has fewer steps.
- **Recommended: Option A.** It keeps the design and matches the API once email, password, and forgot password are removed.

### 11. Can the phone be edited on Complete profile?

`PUT /me` has no phone field.

- **Option A, read-only:** The verified number is shown but can't be edited.
- **Option B, hide the field:** The screen is simpler, but it no longer matches the design.
- **Difference:** Both are safe. Option A keeps the design's field.
- **Recommended: Option A.** It matches both the design and the API.

### 12. What should Skip do on Complete profile?

The user's name is optional on the server.

- **Option A, skip without asking again:** The user goes to Location. Account shows the phone number instead of a name, and the name can be added later from Edit profile.
- **Option B, remind the user later:** The profile gets completed more often, but the extra prompts interrupt the user.
- **Difference:** Option A has less friction. Option B collects more profile data.
- **Recommended: Option A.** The API doesn't require a name.

### 13. How should the Location screen save the user's choice?

The API has no "area" field, and an address needs `lat` and `lng`.

- **Option A, save on the device only:** GPS or area choice is used to sort nearby providers. Areas come from `zones` in the config. A real address is still required at checkout.
- **Option B, create a server address from GPS:** Checkout may be faster, but it can create an inaccurate saved address. Area chips can't do this reliably because they don't give an exact point.
- **Difference:** Option A separates browsing location from delivery address. Option B saves an address earlier.
- **Recommended: Option A.** It works for both GPS and area selection without saving a wrong address.

### 14. What should Skip do on Location?

- **Option A, allow browsing without location:** Home opens without nearby sorting or distance. The header shows "حدّد موقعك", which reopens Location. An address is still required to order.
- **Option B, ask again at each launch:** More users may set a location, but it can annoy users who chose to skip.
- **Difference:** Option A asks once. Option B keeps asking.
- **Recommended: Option A.** It respects the skip while keeping ordering valid.

### 15. Should the cart allow more than one store?

The design shows items from multiple stores, but the server prices an order for one vendor.

- **Option A, one store per cart:** Adding an item from another store asks whether to replace the cart.
- **Option B, multiple stores:** The cart must split into separate orders, with separate quotes, payments, and delivery fees.
- **Difference:** Option A is simpler and matches the API. Option B is more flexible but adds much more work and more failure cases.
- **Recommended: Option A.** It matches how the server creates quotes.

### 16. What prices should the cart show?

The "free delivery over 200 ₪" bar has no backend source, and the final total comes only from the server.

- **Option A, remove the bar and show only an estimated item subtotal:** The final total appears on the quote screen.
- **Option B, keep the bar and calculate delivery in the app:** It matches the design, but the amounts can be wrong.
- **Difference:** Option A shows only reliable numbers. Option B follows the design more closely.
- **Recommended: Option A.** The server is the only source for the final price.

### 17. How should services be ordered?

The design has no service booking flow. The contract doesn't say whether one order can mix products and services. Inspection-priced services use `service_*` statuses and a quote the customer accepts or rejects. These `service-quote` endpoints are in OpenAPI but not in Postman.

- **Option A, keep services and products in separate orders:** Use the OpenAPI endpoints and build the new screens in the design style.
- **Option B, allow mixed orders:** Customers can use one cart for everything, but the server may reject it or handle it in ways the contract doesn't describe.
- **Difference:** Option A avoids undocumented behavior. Option B is more convenient but needs backend confirmation.
- **Recommended: Option A.** Mixed orders aren't documented, so I shouldn't assume they work.

### 18. Should bank transfer be included?

Bank transfer is in Postman, but not in the brief or the design. It includes vendor payment gateways and receipt upload.

- **Option A, include it:** Users can pay by transfer and upload a receipt. This adds new screens and order states.
- **Option B, leave it out:** There is less work, but transfer orders can't be completed in the app.
- **Difference:** Option A follows the full contract. Option B keeps the first release smaller.
- **Recommended: Option A.** Postman is the contract, and a transfer order can't finish without this flow.

### 19. Which map should the app use?

Location and Tracking both show a map, but the project has no map package. A static drawing would be fake.

- **Option A, `flutter_map` with OpenStreetMap:** Shows a real map with no API key, but the tile source needs to be suitable for production use.
- **Option B, Google Maps:** Well-known map experience, but it needs an API key and a billing account.
- **Option C, no in-app map:** Shows coordinates and a button to open an external maps app, but doesn't match the design.
- **Difference:** Options A and B show a real map, and they differ mainly in setup and account needs. Option C is the simplest but gives up the design.
- **Recommended: Option A.** It gives a real map without a key or billing setup.

### 20. What should happen to design elements with no backend support?

This covers points, favorites, payment methods in Account, the notification toggle, reorder, chat with the driver, notification categories, the combined past-orders tab, and the privacy policy link.

- **Option A, adapt to the API:**
  - Remove the unsupported features.
  - Show notifications as one list, without category tabs.
  - Use three order tabs: current, completed, and cancelled.
  - Show the terms link only until a privacy URL is provided.
- **Option B, keep them visually:** The screens look like the design, but the controls wouldn't work or would need placeholder data.
- **Difference:** Option A has only working features. Option B has a closer visual match.
- **Recommended: Option A.** The brief forbids fake data and placeholder logic.

### 21. How should screens outside the design be handled?

The design has 10 screens. The app has many others, such as vendor, product, checkout steps, order details, and the driver app.

- **Option A, apply the new theme and shared widgets:** Their logic stays, but they aren't individually redesigned. Bottom navigation follows the design: Cart becomes a tab, and Notifications opens from the bell.
- **Option B, redesign each screen:** The visual result could be more complete, but there is no design to follow, so I would be guessing.
- **Option C, leave them unchanged:** This is the fastest, but old and new styles would be mixed.
- **Difference:** Option A gives a consistent look with limited risk. Option B needs more design work, and Option C leaves the app inconsistent.
- **Recommended: Option A.** It removes the old look without inventing new designs.
