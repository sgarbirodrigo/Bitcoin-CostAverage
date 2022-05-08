import { User } from "./user_model";
import {Order} from "./order_model";
import {firestore} from "firebase-admin/lib/firestore";
import Timestamp = firestore.Timestamp;

export class UserData {
    private _userId:string="";
    private _user:User=new User();
    private _orders:Array<Order>= [];
    get userId() {
        return this._userId;
    }
    constructor() {
    }
    set userId(value) {
        this._userId = value;
    }

    get user() {
        return this._user;
    }

    set user(value) {
        this._user = value;
    }
}

export interface UserDataRac {
    FCMToken: string;
    //balance: BigNumber;
    createdDate: Timestamp;
    email: string;
    userId: string;
    name: string;
    emailVerified: boolean;
    //last_timestamp: firestore.Timestamp;
}