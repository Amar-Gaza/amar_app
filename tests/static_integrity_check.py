"""Run with: python tests/static_integrity_check.py

Local, source-level contract checks only: not a substitute for flutter test.
"""
from pathlib import Path
import re
import json
import hashlib
import sys

ROOT = Path(__file__).resolve().parents[1]
LIB = ROOT / 'lib'
WORKER = ROOT / 'cloudflare-worker' / 'worker.js'
MANIFEST = ROOT / 'docs' / 'untouched_v8_sha256.json'
ALLOWED = {
    'controllers/customer/ai_chat_controller.dart',
    'controllers/customer/ai_guided_checkout.dart',
    'controllers/customer/catalog_controller.dart',
    'data/models/ai/ai_intent.dart',
    'presentation/screens/ai/ai_assistant_screen.dart',
    'presentation/widgets/ai/ai_task_overlay.dart',
}
checks = []

def check(name, condition):
    checks.append((name, bool(condition)))
    print(('PASS ' if condition else 'FAIL ') + name)

manifest = json.loads(MANIFEST.read_text(encoding='utf-8'))
existing = {str(p.relative_to(LIB)).replace('\\','/') for p in LIB.rglob('*') if p.is_file()}
check('All 354 baseline lib files retained', len(existing)==354 and existing==set(manifest['all_files']))
unchanged_correct = all((LIB/p).is_file() and hashlib.sha256((LIB/p).read_bytes()).hexdigest() == value
                        for p,value in manifest['untouched_sha256'].items())
check('348 unrelated lib files unchanged byte-for-byte from V8',unchanged_correct and len(manifest['untouched_sha256'])==348)
check('Only six targeted Dart files can differ from V8',set(manifest['all_files']) - set(manifest['untouched_sha256']) == ALLOWED)
missing_imports=[]
for file in LIB.rglob('*.dart'):
    text=file.read_text(encoding='utf-8-sig')
    for import_path in re.findall(r'^\s*(?:import|export|part)\s+[\'\"]([^\'\"]+)[\'\"]',text,re.M):
        if import_path.startswith('.') and not (file.parent/import_path).resolve().is_file():
            missing_imports.append((file.relative_to(LIB),import_path))
check('Every relative import/export/part resolves',not missing_imports)
model=(LIB/'data/models/ai/ai_intent.dart').read_text()
chat=(LIB/'controllers/customer/ai_chat_controller.dart').read_text()
checkout=(LIB/'controllers/customer/ai_guided_checkout.dart').read_text()
ui=(LIB/'presentation/screens/ai/ai_assistant_screen.dart').read_text()
overlay=(LIB/'presentation/widgets/ai/ai_task_overlay.dart').read_text()
catalog=(LIB/'controllers/customer/catalog_controller.dart').read_text()
worker=WORKER.read_text()
check('Product vendor names parsed + saved',"json['vendor_name']" in model and "'vendor_name': vendorName" in model)
check('AI uses verified business identity, not numeric label', '_resolveVendorNames' in chat and "'المتجر رقم'" not in chat)
check('Cards have constrained action-button width', 'width: 112' in ui)
check('Top-level AI overlay does not use Tooltip', 'tooltip:' not in overlay)
check('Home starts fetching after onInit build', 'void onReady()' in catalog and 'unawaited(load());' in catalog)
check('Explicit address choice wins over default fallback', 'preferredAddressId == null &&' in checkout)
check('Changed vendor needs re-confirmation', 'suggestion.vendorId != null' in checkout and 'product.vendorId != suggestion.vendorId' in checkout)
check('Guided checkout never calls placeOrder()', '.placeOrder(' not in checkout and '_orders.place(' not in checkout)
check('Worker only makes Masar GET requests', "method: 'GET'" in worker and "pathname !== '/v1/ai/chat'" in worker and 'async function attachVendorNames' in worker)
check('Forms have allowlisted choice validation', 'f.choices.any(' in (LIB/'data/models/ai/ai_chat_form.dart').read_text())
print(f'\nStatic checks: {sum(v for _,v in checks)}/{len(checks)} passed')
if missing_imports: print('Missing imports:',missing_imports[:10])
sys.exit(0 if all(value for _,value in checks) else 1)
