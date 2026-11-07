# Catalog seed — progress (stopped 2026-11-07)

Data: `dataset.json` (names, descriptions, prices, kind, mode). Images: `images/<key>.jpg` (600x600, Pexels, sources in `sources.json`).

## Dashboard categories created
54 أنظمة المنزل الذكي (vendor 42) · 55 أدوات صحية (43) · 56 خدمات سباكة (43) · 57 أبواب وحدادة (44) · نجارة وأثاث (45, id unknown — read from select)
Existing: طاقة شمسية (vendor 19, id 43) · قطع تبريد وتكييف (23, id 47) · مواد بناء (11, id 49)

## Done (17, verified)
smart_switch 917, cctv_install 918, smart_plug 949, cctv_camera 1000, motion_sensor 1026, smart_lock 1057, smart_setup 1130,
toilet 1194, washbasin 1381, shower_set 1382, water_heater 1383, water_pump 1384, water_tank 1385, pump_install 1386, basin_install 1387,
iron_door 1388, window_guard 1389

## Unknown
welding_repair — image uploaded, save not confirmed. Check products list for "لحام وصيانة أبواب حديد" before re-adding.

## Remaining (14)
door_lock, door_hinges (44) · wood_door, kitchen_cabinet, furniture_repair, cabinet_hinge, cabinet_handle (45) ·
solar_panel, inverter (19) · split_ac (23) · ceramic_tiles, tile_adhesive, wall_paint (11) · (+ welding_repair if missing)

## Other pending
- Hidden: product 75 (rebar), store test1 (no delete in dashboard).
- Fix store `category` text: 11 "maintenance", 18 "Maintenance", 19 "electronics", 23 empty; add description for 19.
- Empty test categories "منتجات تجريبية" — consider deleting.
- App changes (orders auto-refresh, refresh button removed, fixed-price wording) — NOT committed yet. Then test, build release.

## Method that works (Claude in Chrome, slow upload ~1KB/s)
Fresh /products/create → upload image FIRST and wait for "تم الرفع" → fill texts → store → wait for category options → category → kind (service) → pricing → price/stock (triple-click + type + Tab) → verify values via JS → submit → wait ~18s.
