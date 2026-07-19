# Missing / Unclear Backend Endpoints

> For the DZ‑Immobilier Flutter app. Findings are from **live probes against
> production** (`https://www.dz-immobilier.com`, db `dzimmobilier`) on
> **2026‑06‑20**, authenticated with the test account (uid 835 / partner 890).
> Each item says what we tried, what happened, and what we need from the
> backend team to finish the integration.

---

## 0. TL;DR for the backend team

| # | Capability | Endpoint tried | Result | Need |
|---|-----------|----------------|--------|------|
| 1 | Public listings search | `POST /api/marketplace/v1/search` | **404** | A public JSON listings endpoint |
| 2 | Anonymous ORM read | `POST /web/dataset/call_kw` | **Session expired** (auth=user) | Public read path for listings |
| 3 | ~~Favorites toggle/list~~ | `/shop/wishlist/*` | ✅ **RESOLVED** | website_sale wishlist (see below) |
| 4 | ~~Make an offer~~ | `POST /dz/listing/offer-request` | ✅ **RESOLVED** | wired (see below) |
| 5 | Contact / lead | `POST /api/marketplace/v1/lead` | **404** | Working lead endpoint |
| 6 | Book a visit | `POST /dz/listing/visit-request` | ✅ exists (discovered) | Confirm `slot_datetime` format |
| 7 | Estimation history | `call_kw dz.valuation.request` | **AccessError** | Portal read rule / endpoint |
| 8 | Listing PDF report | `/valuation/<id>/<token>/pdf` | per‑estimation only | Clarify listing report |
| 9 | Nearby points / amenities | — | no structured field | Field or endpoint |
| 10 | Agency rating / reviews | `marketplace.seller` | no rating fields found | Source of "47 avis ★★★★★" |
| 11 | Interactive mortgage calc | `/api/mortgage/v1/total_cost` | ✅ exists (`/banks` + `/calculators/*` ❌) | Confirm payload |

---

## 🔬 Full reference-doc verification (live sweep · 2026-06-20)

Every endpoint listed in `DZ_IMMOBILIER_MOBILE_FLUTTER_REFERENCE.md` was probed
against **prod** with a logged-in session (empty payloads — nothing created).
✅ = route mounted (200/400/validation/auth error). ❌ = **404 Page Not Found**.

### Auth (§3, §10.2)
| Endpoint | Status |
|---|---|
| `POST /web/session/authenticate` | ✅ |
| `POST /web/session/destroy` | ✅ |
| `GET /web/session/get_session_info` | ✅ |
| `POST /web/signup` | ✅ |
| `POST /web/reset_password` | ✅ |
| `POST /web/session/change_password` | ❌ **404** (doc §3.4 wrong) |

### Picker (§10.3) — all ✅
`/api/picker/wilayas` ✅ · `/api/picker/communes` ✅ · `/api/picker/countries` ✅

### Valuation (§10.4) — all ✅
`categories` · `speed30_categories` · `attributes` · `quick_estimate` ·
`calculate` · `submit` · `fiscal_breakdown` · `rental_yield` · `comparables` ·
`market_overview` · `heatmap` · `llm_heatmap` · `price_heatmap_v115` ·
`owner_estimate_after` — **all ✅** (under `/api/valuation/v1/`).

### Intelligence (§10.5)
| Endpoint | Status |
|---|---|
| `form_schema`, `sections`, `constraints`, `dependencies`, `validate` | ✅ |
| `match` | ❌ 404 |
| `publish` | ❌ 404 |
| `agent_message` | ❌ 404 |

### Mortgage (§6, §10.6)
| Endpoint | Status |
|---|---|
| `POST /api/mortgage/v1/eligibility` | ✅ |
| `POST /api/mortgage/v1/total_cost` | ✅ |
| `GET /api/mortgage/v1/banks` | ❌ 404 |

### Calculators (§6.4) — all ❌
`/api/calculators/v1/monthly_payment` ❌ · `borrow_capacity` ❌ · `notary_fees` ❌
(none deployed; the per-listing `dz_credit_banks` JSON is the only live source).

### DGI (§10.9) — all ✅
`/api/dgi/wilayas` · `communes` · `natures` · `periods` · `lookup` ·
`currencies` — **all ✅**.

### Growth (§10.8) — all ✅
`/api/growth/v1/prix_par_wilaya` ✅ · `/api/growth/v1/favorites_lookup` ✅

### Diaspora (§10.7)
| Endpoint | Status |
|---|---|
| `payment_intent`, `signature_request`, `visit_request` | ✅ |
| `faq` (`/api/diaspora/v1/faq`) | ❌ 404 |

### AI Blog (§10.10)
`/api/ai-blog/v1/trends` ✅ · `/api/ai-blog/v1/generate` ✅
(`translate/<id>` not probed — needs id)

### Embed (§10.11)
`/api/embed/v1/track` ✅ · `/api/embed/v1/estimate` ❌ 404

### Marketplace / Wishlist (§7) — documented family is dead
`/api/marketplace/v1/search` ❌ · `/api/marketplace/v1/lead` ❌ ·
`/api/wishlist/v1/toggle` ❌ · `/api/wishlist/v1/list` ❌
→ **Use instead:** `/shop/wishlist*` (wishlist) and `/dz/listing/offer-request`
(offer) — both ✅ (see resolved items below).

### Booking (§7.4.2)
`POST /booking/submit` ✅ (exists) — but the website actually uses
`POST /dz/listing/visit-request` ✅.

### Notifications (§11.8, §15) — all ❌
`/api/notifications/v1/inbox` ❌ · `mark_read` ❌ · `register_token` ❌
(no FCM/inbox backend yet.)

### Subscription / Agency / Expert (§8, §9) — all ❌
`/api/subscription/v1/current` ❌ · `/api/agency/v1/dashboard` ❌ ·
`/api/agency/v1/statistics` ❌ · `/api/expert/v1/contribute_price` ❌ ·
`/api/expert/v1/directory` ❌ (agency/expert features are web-only / not built).

### Undocumented but live (discovered by the app)
`POST /dz/listing/offer-request` ✅ · `POST /dz/listing/visit-request` ✅ ·
`GET /shop/wishlist?count=1` ✅ · `POST /shop/wishlist/add` ✅ ·
`POST /shop/wishlist/remove/<id>` ✅

### ❌ Summary — documented but NOT on prod (22)
`web/session/change_password` · `mortgage/v1/banks` ·
`calculators/v1/{monthly_payment,borrow_capacity,notary_fees}` ·
`diaspora/v1/faq` · `embed/v1/estimate` ·
`marketplace/v1/{search,lead}` · `wishlist/v1/{toggle,list}` ·
`notifications/v1/{inbox,mark_read,register_token}` ·
`subscription/v1/current` · `agency/v1/{dashboard,statistics}` ·
`expert/v1/{contribute_price,directory}` ·
`intelligence/v1/{match,publish,agent_message}`

---

## ✅ What is confirmed working

So the team knows the baseline the app currently relies on:

- **Auth** — `POST /web/session/authenticate` (login OK; wrong password returns a
  JSON‑RPC `error` with `data.name = odoo.exceptions.AccessDenied`, **not**
  `uid:false`). `POST /web/session/destroy` (logout). `POST /web/session/get_session_info`.
- **Pickers** — `POST /api/picker/wilayas` → `{ "result": { "wilayas": [...] } }` (58 items).
- **ORM** — `POST /web/dataset/call_kw` works for an **authenticated** session.
  `product.template` `search_read` / `read` / `search_count` all return data.
- **Listings live on `product.template`** with `website_published = true`
  (28 records). Real fields: `wilaya_id`, `commune_id`, `dz_neighborhood`,
  `dz_surface_m2`, `dz_bedrooms_count`, `dz_bathrooms_count`, `dz_parkings_count`,
  `dz_floor_number/total`, `dz_property_type_label`, `dz_ref_code`, `categ_id`,
  `marketplace_seller_id`, `dz_agent_*`, `dz_valuation_*`, `dz_dgi_*`,
  `dz_credit_banks` (JSON), `dz_*_score`, `description_sale`, `website_description`,
  `product_template_image_ids`. Currency is **DZD** (`currency_id`).
- **Images** (public, HTTP 200): `…/web/image/product.template/<id>/image_512|1024`
  and gallery `…/web/image/product.image/<imageId>/image_1024`.
- **Wishlist** (website_sale, **logged-in users only** — verified live):
  - `GET /shop/wishlist?count=1` → JSON array of wishlisted **variant** ids, e.g. `[281]`.
  - `POST /shop/wishlist/add` (type=json) `{ "product_id": <variantId> }` → `"product.wishlist(<id>,)"`.
  - `POST /shop/wishlist/remove/<wishId>` (type=json) → removes.
  - `call_kw product.wishlist search_read [id, product_id]` returns the user's own
    rows (used to detect state + resolve the wish id for removal).
  - ⚠️ `product_id` is the **variant** id (`product.product`, e.g. 281), **not** the
    template id (77). The app reads `product_variant_id` from the listing.

> ⚠️ The reference doc (`DZ_IMMOBILIER_MOBILE_FLUTTER_REFERENCE.md`) lists several
> endpoints that are **not deployed on prod** (notably the entire
> `/api/marketplace/*` and `/api/wishlist/*` families). Treat that doc as
> aspirational and verify each endpoint before relying on it.

---

## 🔴 Blocking / missing

### 1. Public listings search — `/api/marketplace/v1/search` returns 404
`POST` with the documented body returns the Odoo **"Page Not Found"** HTML page.
The app instead queries `product.template` via `call_kw`, which requires a
session (see #2).
**Need:** a public (`auth='public'`) JSON endpoint returning paginated listings
(filters: wilaya, commune, transaction, type, price/surface range, rooms, sort).

### 2. Anonymous ORM access — `call_kw` is `auth='user'`
A fresh website session (from `GET /`) has **`uid = null`**, so `call_kw`
raises `odoo.http.SessionExpiredException` ("Session expired"). Visiting a
website page does **not** assign the public user to the session.
**Current workaround:** the app signs in with a shared **read‑only browse
account** (`ApiConstants.browseLogin/browsePassword`) and retries.
**Need (pick one):** (a) ship endpoint #1 as `auth='public'`; or (b) bless a
dedicated least‑privilege browse user we can ship safely.
**Security note:** embedding credentials in the app binary is a known risk —
please provision a throwaway, listings‑read‑only account or a public endpoint.

### 3. ✅ Favorites / wishlist — RESOLVED (use website_sale, not the doc's API)
The documented `/api/wishlist/v1/*` family is **404** and `dz.wishlist` does not
exist. The working mechanism is Odoo's standard **website_sale wishlist**:
- `GET /shop/wishlist?count=1` → `[<variantId>, ...]`
- `POST /shop/wishlist/add` (json) `{ product_id: <variantId> }`
- `POST /shop/wishlist/remove/<wishId>` (json)
- `product.wishlist` (model `id`, `product_id`, `partner_id`, `active`)

The app now wires this in `PropertyProvider.fetchWishlist/addToWishlist/
removeFromWishlist`. **Requires a logged-in user** — the "Sauvegarder" heart is
gated behind login (guests get a "Se connecter" prompt). `product_id` is the
**variant** id.
> Open question: is there a JSON list endpoint returning full product summaries
> for a wishlist *screen* (not just ids)? For now we read `product.wishlist` +
> `product.template` via `call_kw`.

### 4. ✅ Make an offer — RESOLVED (`POST /dz/listing/offer-request`)
Found in the website's `DzListingCta` widget (frontend JS). It's a JSON-RPC
(`type='json'`, **public**) controller. Verified live: an empty body returns
`{ "success": false, "error": "product_tmpl_id manquant" }`.

**Request** (JSON-RPC envelope, params flat):
```json
{ "jsonrpc":"2.0","method":"call","params": {
  "product_tmpl_id": 77,
  "offer_amount": 74100000,
  "financing": "classic",          // "cash" | "classic" | "mourabaha"
  "visitor_name": "…",             // required
  "visitor_phone": "…",            // required (WhatsApp)
  "visitor_email": "…",            // optional
  "message": "…"                   // optional
}}
```
**Response:** `{ "result": { "success": true, "message": "…" } }` or
`{ "result": { "success": false, "error": "…" } }`.

The app now wires this in `PropertyProvider.submitOffer` + the native
**OfferSheet** bottom sheet (price defaults to 95% of the asking price, like the
website). No login required.

### 5. Contact / lead — `/api/marketplace/v1/lead` returns 404
The documented lead endpoint is **not deployed** (same family as #1).
**Need:** the working lead‑capture endpoint (creates `crm.lead`, routes to the
seller team) with its exact payload + auth (public or session).

### 6. Book a visit — endpoint discovered: `POST /dz/listing/visit-request`
The real visit-request controller is `POST /dz/listing/visit-request` (same
`DzListingCta` JSON-RPC mechanism as the offer). Fields seen on the website
form: `product_tmpl_id`, `slot_datetime`, `visitor_name`, `visitor_phone`,
`visitor_email`, `message`. (The doc's `/booking/submit` also exists but returns
400; the website uses `/dz/listing/visit-request`.)
**Need:** the exact `slot_datetime` format + any other required fields, so we can
wire a native "Réserver une visite" sheet like the offer one.

### 7. Estimation history — `dz.valuation.request` access denied
`call_kw` `search_count`/`search_read` on `dz.valuation.request` →
**AccessError** ("allowed for groups: DZ Valuation User/Manager, Portal").
Our test user (835) is **not** a portal user.
**Need:** either confirm normal portal users can read their **own** estimations,
and expose the V116 OR‑domain (`partner_id` OR `contact_email` OR
`contact_phone`), or provide a dedicated endpoint
`POST /api/valuation/v1/my_estimations`. Needed to populate the profile stats
(currently shown as 0).

### 8. Listing report PDF — which report?
`/valuation/<id>/<access_token>/pdf` is **per‑estimation** (needs a token we
don't have for a listing). The website listing page shows a
"Voir le rapport (PDF)" button.
**Need:** clarify whether a listing has its own report PDF, and if so the URL +
how to obtain its token from `product.template`.

---

## 🟡 Unclear / nice‑to‑have (data exists but source unconfirmed)

### 9. Nearby points / amenities ribbon
The website ribbon ("Bordj El Kiffan · Hôpitaux · 10 min · mosquée ·
1 min de la plage") has **no structured field** — it appears derived from the
free‑text description. The app currently shows city/neighborhood + specs.
**Need:** a structured field or endpoint (nearby POIs, transport times) for a
reliable amenities ribbon.

### 10. Agency rating & reviews
On `product.template`, `rating_avg = 0` and `rating_count = 0` for VLI‑0077, yet
the website shows "**avis 47 ★★★★★ · répond en 2 h**". The "47" looks like
`dz_published_days_ago`, not a review count. `marketplace.seller` `fields_get`
exposed no rating fields to our user.
**Need:** the real source of the agency star rating + review count (model +
fields, or an endpoint). Response time is available (`dz_agent_response_time`).

### 11. Interactive mortgage simulation
Static per‑bank monthlies are already on the listing via `dz_credit_banks`
(rendered in the app):
```json
[{"name":"CNEP-Banque","short":"CNEP-Banque","rate":5.0,"type":"Classique","monthly":411812.0,"is_islamic":false,"is_best":true}, ...]
```
For the **interactive** financing block (down‑payment % and duration sliders) we
need a calculator endpoint. The reference doc lists `POST /api/mortgage/v1/total_cost`
and `POST /api/calculators/v1/monthly_payment` — **untested**.
**Need:** confirm these are live on prod + exact request/response.

### 12. Product variant requirement
The website showed a warning: *"لا توجد تركيبة صحيحة لهذا المنتج"* (no valid
variant for this product). If add‑to‑cart / offer / booking flows require a
resolved `product.product` variant, document how mobile should resolve it from a
`product.template` id.

### 13. Auth flow details to confirm
- `POST /web/signup` — exact **success** response shape; does email verification
  block immediate login? (We did **not** create a real account to avoid a prod
  side effect.)
- `POST /web/reset_password` — success/empty response confirmation.
- `POST /web/session/change_password` — confirm the `fields` payload shape.

---

## Appendix — JSON‑RPC envelope reminder

All custom + ORM endpoints expect:
```json
{ "jsonrpc": "2.0", "method": "call", "params": { ... } }
```
Headers: `Content-Type: application/json`, `X-Requested-With: XMLHttpRequest`
(required to pass Odoo's CSRF check on JSON controllers). Session is a cookie
(`session_id`), **not** a Bearer token.
