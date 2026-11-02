# Amar · Postman

Your team: User app. Your collection: `user-app.postman_collection.json`.

1. Import `user-app.postman_collection.json` and `environment.ar.json` (or `environment.en.json`) into Postman.
2. Select the environment and run the whole collection in order (Runner): each request saves tokens and ids for the next ones.
3. Or from a terminal, inside this folder: `npx newman run user-app.postman_collection.json -e environment.ar.json`

The "Helper" folder plays the other app so your collection runs alone; it is not part of your app.

فريقك: تطبيق المستخدم. مجموعتك: `user-app.postman_collection.json`.

1. استورد `user-app.postman_collection.json` و `environment.ar.json` (أو `environment.en.json`) في Postman.
2. اختر البيئة وشغّل المجموعة كاملة بالترتيب (Runner): كل طلب يحفظ التوكنات والمعرّفات للطلبات التالية.
3. أو من الطرفية، داخل هذا المجلد: `npx newman run user-app.postman_collection.json -e environment.ar.json`

مجلد «Helper» يلعب دور التطبيق الآخر لتعمل مجموعتك وحدها؛ وليس جزءًا من تطبيقك.
