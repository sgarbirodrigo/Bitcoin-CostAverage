import {UserData} from "../models/userdata_model";
import {LoadData} from "../load_data";
import {User} from "../models/user_model";
import {CreateOrder, EXCHANGES, TYPE} from "../create_order";
import {Order} from "../models/order_model";


const serviceAccount = require("../test/constant-buyer-7f4095a862c8.json");
const admin = require("firebase-admin");
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});
//const db = admin.firestore();

describe("Options tests", () => { // the tests container
    let allListOrder: User[];
    const db = admin.firestore();
    it("fet user data", async () => { // the single test
        allListOrder = await new LoadData().getActiveUsersList(db);
        console.log(allListOrder);
        allListOrder.forEach((user) => {
            //console.log(`userExecution: ${user.orders.}`)
            Object.keys(user.orders).forEach((key: string) => {
                const order:Order = user.orders[key]
                console.log(`key: ${key} - ${order.pair}`)
            })
        })
        /*const userOrdersDataSnapshot = await db.collection("users").doc("XwlOFrSVSGgKWgJirenWOML1IaB3").collection("history").get();
        let hitorieList = [];
        userOrdersDataSnapshot.forEach((doc) => {
            let historie = doc.data();
            hitorieList.push(historie);
            console.log(historie);
            let binanceResponse: HistoryResponseBinance = JSON.parse(historie["response"]) as HistoryResponseBinance;
            console.log("Timestamp: " + binanceResponse.timestamp);
            let timestamp: Timestamp = Timestamp.fromMillis(binanceResponse.timestamp);
            db.collection("users")
                .doc("XwlOFrSVSGgKWgJirenWOML1IaB3")
                .collection("history")
                .doc(doc.id).update({timestamp:timestamp});
        });*/

    });/*
    it("test get user data", async () => { // the single test
        allListOrder = await new LoadData().getAllListOrders(db);
        console.log(allListOrder);

        /!*const userOrdersDataSnapshot = await db.collection("users").doc("XwlOFrSVSGgKWgJirenWOML1IaB3").collection("history").get();
        let hitorieList = [];
        userOrdersDataSnapshot.forEach((doc) => {
            let historie = doc.data();
            hitorieList.push(historie);
            console.log(historie);
            let binanceResponse: HistoryResponseBinance = JSON.parse(historie["response"]) as HistoryResponseBinance;
            console.log("Timestamp: " + binanceResponse.timestamp);
            let timestamp: Timestamp = Timestamp.fromMillis(binanceResponse.timestamp);
            db.collection("users")
                .doc("XwlOFrSVSGgKWgJirenWOML1IaB3")
                .collection("history")
                .doc(doc.id).update({timestamp:timestamp});
        });*!/

    });*/
    /*it("update history", async () => { // the single test
        //const db = admin.firestore();
        //allListOrder = await new LoadData().getAllListOrders(db);
        this.getUsersHistory(db, "XwlOFrSVSGgKWgJirenWOML1IaB3")
            .then((history: History[]) => {
                console.log(history);
                //let userData = {userId: userId, user: user, orders: orders};
                //return userData;
            })
        //console.log(allListOrder);
    });*/
    /*it("test buy order", async () => { // the single test
        let result = await createFromList(db,allListOrder);
    });*/
});
