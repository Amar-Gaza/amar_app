# AMAR Telegram bot

Order from AMAR by chatting with a Telegram bot, without the app. The bot
talks to the same Masar API as the app, so orders show up in the same
dashboard and reach the same drivers. The Flutter app is unchanged.

## Flow

1. `/start`, then share the phone number (Telegram button).
2. Type the OTP that Masar sends to that number.
3. 🛒 New order: pick a vendor, a product and a quantity. Repeat to add more.
4. ✅ Checkout: pick a saved address or send a location and a short description.
5. See the price summary and confirm (cash on delivery).
6. The bot sends a message on every status change, and shows price offers
   (approve / reject) for service orders.

Menu: 🛒 New order · 🧺 My cart · 📦 My orders · 🚪 Log out.

## Run locally

1. Create a bot with [@BotFather](https://t.me/BotFather) (`/newbot`) and copy its token.
2. `cp env/bot.example.json env/bot.json` and fill `TELEGRAM_BOT_TOKEN` and
   `AMAR_PROJECT_KEY` (same key as the app's `env/dev.json`).
3. Run it:

```bash
dart pub get
dart run bin/amar_bot.dart
```

The bot uses long polling, so it needs no public URL or webhook.

## Deploy

Any host that runs a Docker container works (one instance only):

```bash
docker build -t amar-bot .
docker run -d --restart unless-stopped \
  -e TELEGRAM_BOT_TOKEN=... -e AMAR_PROJECT_KEY=... \
  -v amar-bot-data:/app/data amar-bot
```

Environment variables override `env/bot.json`. Optional: `AMAR_DEV_MEMBER`,
`AMAR_BASE_URL`, `BOT_DATA_DIR`.

## Notes

- `data/sessions.json` holds customer tokens. Keep it out of git and on the
  bot host only.
- Products with options are hidden; they need the app's option picker.
- Payment is cash on delivery; bank transfer needs a receipt upload in the app.
