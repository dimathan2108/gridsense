from pydantic import BaseModel
from typing import Optional

class AccountResponse(BaseModel):
    premise_id: str
    consumer_name: str
    tariff_class: str
    current_balance: float

class InvoiceRequest(BaseModel):
    premise_id: str
    billing_month: str
    usage_kwh: float

class InvoiceResponse(BaseModel):
    invoice_id: int
    premise_id: str
    billing_month: str
    amount: float
    new_balance: float
