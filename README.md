# Archethic FetchApiService (FAS)

An API server that exposes various off-chain resources such as cryptoassets prices.

## Envs

- ARCHETHIC_CMC_PRO_API_KEY: An API key for the CoinMarketCap provider
- ARCHETHIC_COINGECKO_API_KEY: An API key for the CoinGecko provider
- ARCHETHIC_FAS_PORT: The listening HTTP port

## Quotes

Cryptoassets are identified by [Unified Cryptoasset ID (UCID)](https://support.coinmarketcap.com/hc/en-us/articles/20092704479515).
Available cryptoassets in this API:

- uco: 6887
- matic: 3890
- bnb: 1839
- btc: 1
- eth: 1027
- usdc: 3408
- eure: 20920
- usdt: 825
- ... more later

Providers requested:

- coinmarketcap.com
- coingecko.com
- ... more later

### Latest

Return the latest available quotes from given cryptoassets. The result is an aggregate of multiple providers.
**The values are cached for a few minutes.**

`GET /api/v1/quotes/latest[?ucids=6887,1,1027,3890,1839]`

```json
{
  "1": 46886.44559469423,
  "1839": 301.88655780971703,
  "1027": 2263.032408397367,
  "3890": 0.790940929057782,
  "6887": 0.04767200156279931
}
```

### History

Return the historical values (market cap, price and volume) from given cryptoasset. The result is an aggregate of multiple providers.
The result is a list of pairs `[timestamp, value]`.
**The values are cached for a few minutes.**

Available intervals:

- "hourly"
- "daily"
- "weekly"
- "biweekly"
- "monthly"
- "bimonthly"
- "yearly"

`GET /api/v1/quotes/history?ucid=6887&interval=hourly`

```json
{
  "market_caps":[
    [1724310118423,0.0],
    [1724310423772,0.0],
    ...
  ],
  "prices":[
    [1724310118423,0.016558402243090357],
    [1724310423772,0.016562097651212856],
    ...
  ],
  "total_volumes":[
    [1724310118423,2344.4700086016405],
    [1724310423772,2344.993613232555],
    ...
  ]
}
```

## Upgrade

```bash
MIX_ENV=prod mix release
service archethic-fas restart
```
