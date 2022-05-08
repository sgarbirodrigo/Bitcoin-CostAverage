export interface HistoryResponseBinance {
    info: Info
    id: string
    clientOrderId: string
    timestamp: number
    datetime: string
    symbol: string
    type: string
    timeInForce: string
    postOnly: boolean
    side: string
    price: number
    amount: number
    cost: number
    average: number
    filled: number
    remaining: number
    status: string
    fee: Fee
    trades: Trade[]
}

export interface Info {
    symbol: string
    orderId: number
    orderListId: number
    clientOrderId: string
    transactTime: number
    price: string
    origQty: string
    executedQty: string
    cummulativeQuoteQty: string
    status: string
    timeInForce: string
    type: string
    side: string
    fills: Fill[]
}

export interface Fill {
    price: string
    qty: string
    commission: string
    commissionAsset: string
    tradeId: number
}

export interface Fee {
    cost: number
    currency: string
}

export interface Trade {
    info: Info2
    symbol: string
    price: number
    amount: number
    cost: number
    fee: Fee2
}

export interface Info2 {
    price: string
    qty: string
    commission: string
    commissionAsset: string
    tradeId: number
}

export interface Fee2 {
    cost: number
    currency: string
}
