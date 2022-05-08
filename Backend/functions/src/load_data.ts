import {UserData} from "./models/userdata_model";
import {Order} from "./models/order_model";
import {User} from "./models/user_model";
import {Tools} from "./tools";

export class LoadData {
    async getActiveUsersList(db): Promise<Array<User>> {
        let usersData: Array<User> = Array<User>();
        let users = await this.getUsers(db);
        users.forEach((user, userId) => {
            if(user.active) {
                console.log("orders: "+user.orders);
                usersData.push(user);
                /*userPromise.push(
                    this.getUsersOrders(db, userId)
                        .then((orders: Order[]) => {
                            return {userId: userId, user: user, orders: orders};
                        })
                );*/
            }
        });
        return usersData;
    }

    async getAllListHistory(db): Promise<Array<UserData>> {
        let users = await this.getUsers(db);
        let userPromise: any = [];
        users.forEach((user, userId) => {
            userPromise.push(
                this.getUsersHistory(db, userId)
                    .then((orders: Order[]) => {
                        return {userId: userId, user: user, orders: orders};
                    })
            );
        });
        let listOrders = await Promise.all(userPromise)
            .then((listOrders: Array<any>) => {
                return listOrders;
            });
        let usersData: Array<UserData> = Array<UserData>();
        listOrders.forEach(value => {
            usersData.push(value);
        })
        return usersData;
    }

    async getUsers(db): Promise<Map<string, User>> {
        const usersDataSnapshot = await db.collection("users").get();
        let usersList: Map<string, User> = new Map<string, User>();
        usersDataSnapshot.forEach((doc) => {
            let user: User = doc.data();
            user.id = doc.id;
            usersList.set(user.id, user);
        });
        return usersList;
    }

    async getUsersOrders(db, user) {
        //console.log(Tools.getWeekDay(Timestamp.now()));
        const userOrdersDataSnapshot = await db.collection("users").doc(user).collection("orders").get();
        let ordersList: Array<Order> = [];
        userOrdersDataSnapshot.forEach((doc) => {
            let order: Order = doc.data();
            if(order.active) {
                if(Tools.checkSchedule(order.schedule)){
                    ordersList.push(order);
                }

            }
        });
        return ordersList;
    }



    async getUsersHistory(db, user) {
        const userOrdersDataSnapshot = await db.collection("users").doc(user).collection("history").get();
        let historyList: Array<Order> = [];
        userOrdersDataSnapshot.forEach((doc) => {
            let order: Order = doc.data();
            historyList.push(order);
        });
        return historyList;
    }


    async getUserData(db,) {
        const userDataSnapshot = await db.collection("users").get();
        userDataSnapshot.forEach((doc) => {
            console.log(doc.id, "=>", doc.data());
            let user: User = doc.data();
            console.log(user.active, user.private_key, user.public_key)
        });
    }
}