FROM dart:stable AS build
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get
COPY . .
RUN dart compile exe bin/amar_bot.dart -o bin/amar_bot

FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/amar_bot /app/bin/amar_bot
WORKDIR /app
# Sessions (customer tokens) live here: mount a volume to keep them.
ENV BOT_DATA_DIR=/app/data
CMD ["/app/bin/amar_bot"]
