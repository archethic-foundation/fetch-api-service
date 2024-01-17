# Archethic FetchApiService (FAS)

An API server that exposes various off-chain resources such as cryptoassets prices.

## Envs

- ARCHETHIC_CMC_PRO_API_KEY: An API key for the CoinMarketCap provider

## Quotes

Cryptoassets are identified by [Unified Cryptoasset ID (UCID)](https://support.coinmarketcap.com/hc/en-us/articles/20092704479515).
Available cryptoassets in this API:

- uco:      6887
- matic:    3890
- bnb:      1839
- btc:      1
- eth:      1027
- ... more later

Providers requested:

- coinmarketcap.com
- ... more later

### Latest

Return the latest available quotes from given cryptoassets. The result is an aggregate of multiple providers.
**The values are cached for a few minutes.**

`GET /api/v1/quotes/latest?ucids=6887,1,1027,3890,1839`

```json
{
  "1": 46886.44559469423,
  "1839": 301.88655780971703,
  "1027": 2263.032408397367,
  "3890": 0.790940929057782,
  "6887": 0.04767200156279931
}
```
