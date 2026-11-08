import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';

// Tests the actual Cloudflare worker from this delivery, with intercepted
// Masar and Gemini calls. No real orders, purchases, secrets or HTTP traffic.
const source = fs.readFileSync(new URL('../cloudflare-worker/worker.js', import.meta.url), 'utf8');
const worker = (await import('data:text/javascript;base64,' + Buffer.from(source).toString('base64'))).default;
const ok = (data, status = 200) => new Response(JSON.stringify(data), {
  status, headers: {'content-type': 'application/json'},
});
const productRecords = [
  {id: 21, name: 'قاطع كهربائي 20 أمبير', description: 'حماية كهربائية', kind: 'product', vendor_id: 43, image_url: '', price: {formatted:'50 ₪'}},
  {id: 22, name: 'قاطع كهربائي 32 أمبير', description: 'حماية كهربائية', kind: 'product', vendor_id: 11, image_url: '', price: {formatted:'60 ₪'}},
  {id: 23, name: 'قاطع كهربائي 16 أمبير', description: 'لوحة توزيع', kind: 'product', vendor_id: 18, image_url: '', price: {formatted:'40 ₪'}},
  {id: 30, name: 'كورس إفرنجي', description: 'مستلزمات صحية', kind: 'product', vendor_id: 18, price: {formatted:'200 ₪'}},
  {id: 35, name: 'خدمة سباكة منزلية', description: 'فني سباكة', kind: 'service', vendor_id: 9, price: {formatted:'80 ₪'}},
  {id: 39, name: 'خدمة كهربائي', description: 'صيانة كهربائية', kind: 'service', vendor_id: 43, price: {formatted:'90 ₪'}},
];
const vendors = [
  {id:43, name:'شركة الكهرباء الحديثة', description:'مستلزمات كهربائية', category:'كهربائيات', address:'غزة'},
  {id:11, name:'متجر الأمان للأدوات الكهربائية', description:'قواطع ولوحات', category:'كهربائيات', address:'رفح'},
  {id:18, name:'مركز النور', description:'أدوات صحية وكهربائية', category:'متعدد', address:'خان يونس'},
  {id:9, name:'السبّاك المحترف', description:'خدمة سباكة', category:'سباكة', address:'غزة'},
];
let state;
function reset() {
  state = {calls: [], invalidToken: false, meFailure: false, vendorFailures: new Set(), productsFailure: false,
    modelStatus: 200, modelObject: {action:'chat',kind:'any',query:'',reply:'أهلاً، كيف أساعدك؟',
      target_index:0,open_screen:false,quantity:1,suggestions:['ابحث عن منتج']},
    modelInvalid: false, modelRequests: []};
  globalThis.fetch = async (url, options = {}) => {
    const u = new URL(url);
    state.calls.push({url: u.toString(), method: options.method || 'GET', headers: options.headers || {}});
    if (u.hostname === 'generativelanguage.googleapis.com') {
      state.modelRequests.push(JSON.parse(options.body));
      if (state.modelStatus !== 200) return ok({error:{status:'RESOURCE_EXHAUSTED'}}, state.modelStatus);
      return ok({candidates:[{content:{parts:[{text: state.modelInvalid ? 'not-json' : JSON.stringify(state.modelObject)}]}}]});
    }
    if (u.pathname === '/api/v1/me') {
      if (state.meFailure) return ok({success:false}, 503);
      if (state.invalidToken) return ok({success:false}, 401);
      return ok({success:true,data:{id:555}});
    }
    if (u.pathname === '/api/v1/products') {
      if (state.productsFailure) return ok({success:false}, 503);
      const query = u.searchParams.get('q') || '';
      const kind = u.searchParams.get('kind');
      return ok({success:true,data:productRecords.filter(p =>
        (!query || `${p.name} ${p.description}`.includes(query)) && (!kind || p.kind === kind)),
        meta:{last_page:1}});
    }
    if (u.pathname === '/api/v1/vendors') return ok({success:true,data:vendors,meta:{last_page:1}});
    if (/\/api\/v1\/vendors\/\d+$/.test(u.pathname)) {
      const id = Number(u.pathname.split('/').at(-1));
      if (state.vendorFailures.has(id)) return ok({success:false}, 503);
      const record = vendors.find(v=>v.id === id);
      return record ? ok({success:true,data:record}) : ok({error:'not_found'},404);
    }
    if (/\/api\/v1\/products\/\d+$/.test(u.pathname)) {
      const record = productRecords.find(p=>p.id===Number(u.pathname.split('/').at(-1)));
      return record ? ok({success:true,data:record}) : ok({error:'not_found'},404);
    }
    if (u.pathname === '/api/v1/categories') return ok({success:true,data:[{id:4,name:'كهربائيات'}, {id:5,name:'الصيانة'}]});
    throw new Error('Unexpected URL: ' + url);
  };
}
async function request(message, extras = {}, env = {GEMINI_API_KEY:'MOCK_KEY',MASAR_PROJECT_KEY:'MOCK_KEY'}) {
  const res = await worker.fetch(new Request('https://test.invalid/v1/ai/chat',{
    method:'POST',headers:{'content-type':'application/json',authorization:'Bearer TEST_TOKEN'},
    body:JSON.stringify({message,locale:'ar', ...extras})
  }),env);
  return {status:res.status, body:await res.json(), headers:res.headers};
}
function ensureReadOnly() {
  const masarCalls = state.calls.filter(c=>c.url.startsWith('https://masar.toldpath.com/'));
  assert.ok(masarCalls.every(c=>c.method === 'GET'), 'No Masar mutations allowed');
  assert.ok(masarCalls.every(c=>!/(orders\/place|checkout\/place|payments\/charge|\/delete)/.test(c.url)));
}

reset();
test('health reports v8 and revision', async()=>{
  const res=await worker.fetch(new Request('https://test.invalid/health'),{});
  assert.equal(res.status,200);
  const body=await res.json();
  assert.equal(body.version,8); assert.equal(body.revision,'vendor-names-1');
  assert.equal(res.headers.get('cache-control'),'no-store');
});
test('unknown route is 404', async()=>{reset(); const r=await worker.fetch(new Request('https://test.invalid/other'),{}); assert.equal(r.status,404)});
test('non-POST chat rejects', async()=>{reset(); const r=await worker.fetch(new Request('https://test.invalid/v1/ai/chat'),{}); assert.equal(r.status,405)});
test('non-JSON rejected', async()=>{reset(); const r=await worker.fetch(new Request('https://test.invalid/v1/ai/chat',{method:'POST'}),{}); assert.equal(r.status,415)});
test('missing secret rejected', async()=>{reset(); const r=await request('مرحبا',{},{}); assert.equal(r.status,503)});
test('missing authorization rejected', async()=>{reset(); const r=await worker.fetch(new Request('https://test.invalid/v1/ai/chat',{method:'POST',headers:{'content-type':'application/json'},body:'{"message":"مرحبا"}'}),{GEMINI_API_KEY:'x',MASAR_PROJECT_KEY:'x'}); assert.equal(r.status,401)});
test('invalid JSON rejected', async()=>{reset(); const r=await worker.fetch(new Request('https://test.invalid/v1/ai/chat',{method:'POST',headers:{'content-type':'application/json',authorization:'Bearer TEST'},body:'{' }),{GEMINI_API_KEY:'x',MASAR_PROJECT_KEY:'x'}); assert.equal(r.status,400)});
test('empty message rejected', async()=>{reset(); assert.equal((await request('')).status,422)});
test('message above 2000 rejected', async()=>{reset(); assert.equal((await request('a'.repeat(2001))).status,422)});
test('raw payload above 16000 rejected', async()=>{reset(); assert.equal((await request('مرحبا',{history:[{role:'user',text:'A'.repeat(18000)}]})).status,413)});
test('invalid user token rejected before Gemini', async()=>{reset(); state.invalidToken=true; const r=await request('كيف الحال؟'); assert.equal(r.status,401); assert.equal(state.modelRequests.length,0)});
test('Masar authentication outage is 502', async()=>{reset(); state.meFailure=true; const r=await request('مرحبا'); assert.equal(r.status,502)});
test('greeting replies locally', async()=>{reset(); const r=await request('مرحبا'); assert.equal(r.status,200); assert.equal(r.body.action,'chat'); assert.equal(state.modelRequests.length,0)});
test('prepare order breaker with Arabic quantity', async()=>{
  reset(); const r=await request('يا عَمّار، اطلبلي قاطع كهربائي عدد قطعتين، وجهزلي السلة والمراجعة بدون تأكيد');
  assert.equal(r.status,200); assert.equal(r.body.action,'prepare_order'); assert.equal(r.body.quantity,2); assert.equal(r.body.results.length,3);
  ensureReadOnly();
});
test('numeric quantity and verified vendor names', async()=>{
  reset(); const r=await request('اطلبلي قاطع كهربائي عدد 2');
  assert.equal(r.body.quantity,2);
  assert.equal(r.body.results.find(p=>p.vendor_id===43).vendor_name,'شركة الكهرباء الحديثة');
  assert.equal(r.body.results.find(p=>p.vendor_id===11).vendor_name,'متجر الأمان للأدوات الكهربائية');
  assert.equal(r.body.results.find(p=>p.vendor_id===18).vendor_name,'مركز النور');
  assert.ok(r.body.results.every(p=>p.type==='product' && p.name.includes('قاطع')));
  ensureReadOnly();
});
test('default quantity 1', async()=>{reset(); assert.equal((await request('اعمللي طلب على قاطع كهربائي')).body.quantity,1)});
test('reject quantity 40 before search', async()=>{reset(); const r=await request('اطلبلي قاطع كهربائي عدد 40'); assert.equal(r.body.action,'ask_clarification'); assert.equal(state.calls.filter(c=>c.url.includes('/v1/products')).length,0)});
test('not a service when searching a circuit breaker', async()=>{reset(); const r=await request('ابحث عن قاطع كهربائي'); assert.equal(r.body.action,'search_catalog'); assert.ok(r.body.results.every(p=>p.type==='product'))});
test('sanitary fixture voice variation', async()=>{reset(); const r=await request('اطلبلي كورس إفرنجي'); assert.equal(r.body.action,'prepare_order'); assert.equal(r.body.results[0]?.name,'كورس إفرنجي')});
test('real vendor fallback on individual endpoint outage', async()=>{
  reset(); state.vendorFailures.add(43); const r=await request('اطلبلي قاطع كهربائي عدد 2');
  assert.equal(r.body.results.find(p=>p.vendor_id===43).vendor_name,'');
  assert.ok(r.body.unresolved_vendors>0); assert.match(r.body.reply,/تعذر التحقق/); ensureReadOnly();
});
test('catalog failure reported as 502', async()=>{reset();state.productsFailure=true; const r=await request('ابحث عن قاطع كهربائي'); assert.equal(r.status,502); assert.equal(r.body.error,'catalog_unavailable')});
test('no match does not fabricate product', async()=>{reset(); const r=await request('ابحث عن منظومة عاكسة زمردية'); assert.equal(r.body.action,'search_catalog'); assert.equal(r.body.results.length,0);ensureReadOnly()});
test('show cart',async()=>{reset();assert.equal((await request('افتح السلة')).body.action,'show_cart')});
test('open home',async()=>{reset();assert.equal((await request('افتح الرئيسية')).body.action,'open_home')});
test('browse categories',async()=>{reset();const r=await request('شو الأقسام');assert.equal(r.body.action,'browse_categories');assert.equal(r.body.results.length,2)});
test('vendor search uses verified names',async()=>{reset();const r=await request('بدي شركات سباكة');assert.equal(r.body.action,'search_vendors'); assert.ok(r.body.results.some(v=>v.name==='السبّاك المحترف'))});
test('open second result verifies it against Masar',async()=>{
  reset(); const r=await request('افتح الثاني',{last_results:[{id:21,type:'product',name:'قاطع 20'}, {id:22,type:'product',name:'قاطع 32'}]});
  assert.equal(r.body.action,'open_result');assert.equal(r.body.navigate.id,22);ensureReadOnly();
});
test('open invalid result requests clarification',async()=>{reset();const r=await request('افتح الثالث',{last_results:[{id:21,type:'product'}]});assert.equal(r.body.action,'ask_clarification')});
test('multiturn Gemini response preserves pending form',async()=>{
  reset();state.modelObject={action:'chat',kind:'any',query:'',reply:'قاطع 20 أمبير مناسب لبعض الدوائر، بدك نقارن الخيارات؟', target_index:0,open_screen:false,quantity:1,suggestions:['قارن 20 و32 أمبير','كمل النموذج']};
  const r=await request('شو الفرق بين 20 و32 أمبير؟',{history:[{role:'user',text:'بدي قاطع كهربائي'}], pending_form:{stage:'options',question:'اختار الأمبير',product:'قاطع كهربائي',options:[{label:'الأمبير',choices:['20A','32A']}]}});
  assert.equal(r.body.action,'chat');assert.deepEqual(r.body.suggestions,['قارن 20 و32 أمبير','كمل النموذج']);
  assert.equal(state.modelRequests[0].contents[0].parts[0].text.includes('pending_form'),true);
});
test('malformed model reply rejected',async()=>{reset();state.modelInvalid=true;const r=await request('كيف الحال اليوم؟');assert.equal(r.status,502);assert.equal(r.body.error,'ai_request_failed')});
test('model rate limit reported without unsafe fallback',async()=>{reset();state.modelStatus=429;const r=await request('هل يوجد ضمان؟');assert.equal(r.status,429);assert.equal(r.body.error,'ai_request_failed')});
test('no Masar order/payment write across representative intents',async()=>{
  reset(); for(const query of ['مرحبا','افتح السلة','ابحث عن قاطع كهربائي','اطلبلي قاطع كهربائي عدد 2','بدي شركات سباكة']) await request(query);
  ensureReadOnly();
});
