# Payments service

Charges a customer's saved card and records the result.

- `charge(customer_id, amount_cents)` charges exactly `amount_cents`. No fees, surcharges or rounding.
- A declined card returns `{ok: false, reason}`. It never raises.
- Every charge is idempotent on `(customer_id, idempotency_key)`.
