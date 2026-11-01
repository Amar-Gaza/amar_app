$ErrorActionPreference = 'Stop'
$reserved = '^(status|action|confirm|cancelReason|error)'
foreach ($loc in 'ar', 'en') {
  $pack = Get-Content "l10n_src/pack/app_$loc.arb" -Raw -Encoding UTF8 | ConvertFrom-Json -AsHashtable
  $custom = Get-Content "l10n_src/custom/app_custom_$loc.arb" -Raw -Encoding UTF8 | ConvertFrom-Json -AsHashtable
  foreach ($k in $custom.Keys) {
    if ($k -like '@@*') { continue }
    $base = $k.TrimStart('@')
    if ($base -match $reserved) { throw "Custom key uses a reserved prefix: $base" }
    if ($pack.ContainsKey($k)) { throw "Duplicate key in pack and custom: $k" }
    $pack[$k] = $custom[$k]
  }
  $pack | ConvertTo-Json -Depth 10 | Set-Content "lib/l10n/app_$loc.arb" -Encoding UTF8
}
