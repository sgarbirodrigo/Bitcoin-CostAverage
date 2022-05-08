import {firestore} from "firebase-admin/lib/firestore";
import Timestamp = firestore.Timestamp;
import {User} from "./models/user_model";
import {Order} from "./models/order_model";
import {LoadData} from "./load_data";

export enum TYPE {SELL = "sell", BUY = "buy"}

export enum EXCHANGES {BINANCE = "binance"}

export class CreateOrder {
    _exchange: EXCHANGES = EXCHANGES.BINANCE;
    _ccxt;
    _exchangeSelected;

    constructor(secretKey: string, key: string, exchange: EXCHANGES) {
        this._exchange = exchange;
        switch (exchange) {
            case EXCHANGES.BINANCE:
                this._ccxt = require("ccxt");
                this._exchangeSelected = new this._ccxt.binance({
                    "apiKey": key,
                    "secret": secretKey,
                    "timeout": 30000,
                    "enableRateLimit": true,
                });
        }
    }

    async order_binance(quantity: number, pair: string, type: TYPE): Promise<any> {
        const params = {
            "quoteOrderQty": quantity,
        }
        return this._exchangeSelected.create_order(pair, "market", type, null, null, params)
            .then((response) => {
                console.info(`Order created: ${JSON.stringify(response)}`);
                return Promise.resolve(JSON.stringify(response));
            }).catch(error => {
                console.error("Erro caught: ", error.message);
                return Promise.reject(error.message);
            });
    }


}

export async function buy_updated(db) {
    let allListOrder: User[];
    allListOrder = await new LoadData().getActiveUsersList(db);
    return createFromList(db, allListOrder);
}

export async function createFromList(db, allListOrder: User[]) {
    let ordersPromises: any = []
    allListOrder.forEach((user) => {
        let createOrder = new CreateOrder(user.private_key, user.public_key, EXCHANGES.BINANCE);
        Object.keys(user.orders).forEach((key: string) => {
            const order:Order = user.orders[key]
            ordersPromises.push(createOrder.order_binance(order.amount, order.pair, TYPE.BUY)
                .then((response) => {
                    return db.collection("users").doc(user.id).collection("history").add({
                        result: "success",
                        order: order,
                        timestamp: Timestamp.now(),
                        response,
                    });
                }).catch((error) => {
                    //console.log("error:", error);
                    return db.collection("users").doc(user.id).collection("history").add({
                        result: "failure",
                        order: order,
                        timestamp: Timestamp.now(),
                        error,
                    });
                }));
        })
    })
    return Promise.all(ordersPromises);
}