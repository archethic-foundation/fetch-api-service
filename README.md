# ArchethicFrontApiServer

An API server that provides various off-chain resources.
Such as cryptocurrencies prices.

## Quotes

Cryptocurrencies handled:

- bitcoin
- bnb
- eth
- matic
- uco
- ... more later

Providers requested:

- coinmarketcap.com
- ... more later

### Latest

Return the latest available quotes from given cryptocurrencies. The result is an aggregate of multiple providers.
**The values are cached for an entire minute.**

`GET /api/v1/quotes/latest?currency=uco,bitcoin,bnb,matic,eth`

```json
{
  "bitcoin":46886.44559469423,
  "bnb":301.88655780971703,
  "eth":2263.032408397367,
  "matic":0.790940929057782,
  "uco":0.04767200156279931
}
```
