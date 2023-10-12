CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY,
    username TEXT NOT NULL,
    password TEXT NOT NULL, -- Argon2id hashed password
    token TEXT NOT NULL, -- API token
    enabled BOOLEAN NOT NULL DEFAULT TRUE,
    root BOOLEAN NOT NULL DEFAULT FALSE -- Whether or not the user has admin permissions
);

CREATE TABLE IF NOT EXISTS games (
    code TEXT PRIMARY KEY,
    enabled BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    game_started TIMESTAMPTZ, -- If this value is unset, the game has not yet started
    initial_balance INTEGER NOT NULL -- The initial balance of a user in the game in cents
);

CREATE TABLE IF NOT EXISTS game_user (
    id UUID NOT NULL REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    game_code TEXT NOT NULL REFERENCES games (code) ON UPDATE CASCADE ON DELETE CASCADE,
    balance INTEGER NOT NULL, -- The current balance of the user in cents
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS stock (
    id UUID PRIMARY KEY,
    game_code TEXT NOT NULL REFERENCES games (code) ON UPDATE CASCADE ON DELETE CASCADE,
    ticker TEXT NOT NULL, -- AAPL etc
    company_name TEXT NOT NULL,
    start_price INTEGER NOT NULL, -- The price of the stock at the start of the game in cents
    end_price INTEGER NOT NULL, -- The price of the stock at the end of the game in cents
    current_price TEXT NOT NULL DEFAULT 'start', -- The current price of the stock, 'start' means start price and 'end' means end price
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS news (
    id UUID PRIMARY KEY,
    title TEXT NOT NULL,
    game_code TEXT NOT NULL REFERENCES games (code) ON UPDATE CASCADE ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS user_transaction (
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    game_code TEXT NOT NULL REFERENCES games (code) ON UPDATE CASCADE ON DELETE CASCADE,
    stock_id UUID NOT NULL REFERENCES stock (id) ON UPDATE CASCADE ON DELETE CASCADE,
    stock_price INTEGER NOT NULL, -- The price of the stock at the time of the transaction in cents
    amount INTEGER NOT NULL, -- The amount of stocks bought/sold
    action TEXT NOT NULL, -- BUY or SELL
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);