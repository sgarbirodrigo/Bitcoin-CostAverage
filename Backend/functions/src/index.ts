import {buy_updated, createFromList} from "./create_order";
import {LoadData} from "./load_data";
import {UserData} from "./models/userdata_model";
import {firestore} from "firebase-admin/lib/firestore";
import Timestamp = firestore.Timestamp;
import {User, UserManager} from "./models/user_model";
import {ResponseCat, RESPONSECAT_TYPES} from "./models/responseCat";
import OrdersManager from "./orders_manager";

const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

const db = admin.firestore();

exports.subscriptionAlteration = functions
    .https
    .onRequest((req, res) => {
        return new OrdersManager(db, admin)
            .runServerVerifications()
            .then((ordersManager: OrdersManager) => {
                if (ordersManager === null) {
                    return Promise.reject();
                }

                return new ResponseCat(admin, req).instance()
                    .then((result) => {
                        return res.status(200).send(`Deu bom: ${JSON.stringify(req.body)}`);
                    }).catch(err => {
                        return res.status(500).send(`Deu ruim: ${JSON.stringify(req.body)}`);
                    });
            });
    });
exports.buyDaily = functions.pubsub.schedule("0 23 * * *")
    .timeZone("America/Sao_Paulo") // Users can choose timezone - default is America/Los_Angeles
    .onRun(() => {
        return new OrdersManager(db, admin)
            .runServerVerifications()
            .then((ordersManager: OrdersManager) => {
                if (ordersManager === null) {
                    return Promise.reject();
                }

                return buy_updated(db);
            });
    });

exports.accountCreated = functions.auth.user().onCreate(user => {
    return new OrdersManager(db, admin)
        .runServerVerifications()
        .then((ordersManager: OrdersManager) => {
            if (ordersManager === null) {
                return Promise.reject();
            }

            return new UserManager(admin).onNewUser(user);
        });

});


