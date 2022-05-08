import {Order} from "./order_model";

export class History{
    private _order:Order = new Order();
    private _response:String;
    private _result:String;

    get order(): Order {
        return this._order;
    }

    set order(value: Order) {
        this._order = value;
    }

    get response(): String {
        return this._response;
    }

    set response(value: String) {
        this._response = value;
    }

    get result(): String {
        return this._result;
    }

    set result(value: String) {
        this._result = value;
    }
}