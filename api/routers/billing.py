from fastapi import APIRouter, HTTPException
from db.postgres import get_postgres_pool
from models.postgres import AccountResponse, InvoiceRequest, InvoiceResponse

router = APIRouter(prefix="/billing", tags=["Billing"])

@router.get("/account/{premise_id}", response_model=AccountResponse)
async def get_account(premise_id: str):
    pool = await get_postgres_pool()

    async with pool.acquire() as conn:
        row = await conn.fetchrow(
            """
            SELECT premise_id, consumer_name, tariff_class, current_balance
            FROM accounts
            WHERE premise_id = $1
            """,
            premise_id,
        )

    if row is None:
        raise HTTPException(status_code=404, detail="Account not found")

    return AccountResponse(
        premise_id=row["premise_id"],
        consumer_name=row["consumer_name"],
        tariff_class=row["tariff_class"],
        current_balance=float(row["current_balance"]),
    )

@router.post("/invoice", response_model=InvoiceResponse)
async def create_invoice(payload: InvoiceRequest):
    pool = await get_postgres_pool()

    rate = 0.20 if payload.usage_kwh <= 500 else 0.28
    surcharge = 5.00
    amount = round(payload.usage_kwh * rate + surcharge, 2)

    async with pool.acquire() as conn:
        async with conn.transaction():
            account = await conn.fetchrow(
                """
                SELECT premise_id, current_balance
                FROM accounts
                WHERE premise_id = $1
                FOR UPDATE
                """,
                payload.premise_id,
            )

            if account is None:
                raise HTTPException(status_code=404, detail="Account not found")
            
            invoice = await conn.fetchrow(
                """
                INSERT INTO invoices (premise_id, billing_month, amount)
                VALUES ($1, $2, $3)
                ON CONFLICT (premise_id, billing_month)
                DO UPDATE SET amount = EXCLUDED.amount
                RETURNING invoice_id, premise_id, billing_month, amount
                """,
                payload.premise_id,
                payload.billing_month,
                amount,
            )

            new_balance = float(account["current_balance"]) + amount

            await conn.execute(
                """
                UPDATE accounts
                SET current_balance = $1
                WHERE premise_id = $2
                """,
                new_balance,
                payload.premise_id,
            )

    return InvoiceResponse(
        invoice_id=invoice["invoice_id"],
        premise_id=invoice["premise_id"],
        billing_month=invoice["billing_month"],
        amount=float(invoice["amount"]),
        new_balance = float(new_balance),
    )
