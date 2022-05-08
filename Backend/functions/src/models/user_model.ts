import {firestore} from "firebase-admin/lib/firestore";
import {Order} from "./order_model";
import List = Mocha.reporters.List;
import {UserRecord} from "firebase-functions/lib/providers/auth";
import Timestamp = firestore.Timestamp;

export class User {
    private _active: boolean = false;
    private _private_key: string = "";
    private _uid: string = "";
    private _public_key: string = "";
    private _orders: Map<string,Order>;
    get orders(): Map<string,Order> {
        return this._orders;
    }

    set orders(value: Map<string,Order>) {
        this._orders = value;
    }

    get id(): string {
        return this._uid;
    }

    set id(value: string) {
        this._uid = value;
    }

    constructor() {
    }

    get active(): boolean {
        return this._active;
    }

    set active(value: boolean) {
        this._active = value;
    }

    get private_key(): string {
        return this._private_key;
    }

    set private_key(value: string) {
        this._private_key = value;
    }

    get public_key(): string {
        return this._public_key;
    }

    set public_key(value: string) {
        this._public_key = value;
    }
}

export class UserManager{
    constructor(public admin){

    }
    async onNewUser(user:UserRecord){
        console.log(`New user creation: ${user}`);
        const userDoc = {
            "email": user.email, "active": false, "createdTimestamp": Timestamp.now(), "uid": user.uid,
            "displayName": user.displayName, "private_key": "", "public_key": ""
        }
        return this.admin.firestore().collection("users").doc(user.uid)
            .set(userDoc).then(writeResult => {
                console.log("User Created result:", writeResult);
                return Promise.resolve();
            }).catch(err => {
                console.log(err);
                return Promise.reject(err);
            });
    }
}


