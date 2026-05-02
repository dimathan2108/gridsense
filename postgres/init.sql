CREATE TABLE IF NOT EXISTS accounts (
    premise_id TEXT PRIMARY KEY,
    consumer_name TEXT NOT NULL,
    tariff_class TEXT NOT NULL,
    current_balance NUMERIC(12,2) NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS invoices (
    invoice_id SERIAL PRIMARY KEY,
    premise_id TEXT NOT NULL REFERENCES accounts(premise_id),
    billing_month TEXT NOT NULL,
    amount NUMERIC(12,2) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
