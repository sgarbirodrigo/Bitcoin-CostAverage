import {Tools} from "./tools";

export default class OrdersManager {
    constructor(public db, public admin) {
    }
    async runServerVerifications() {
        if (await this.isCrashStopActivated()) {
            return null;
        }
        return this;
    }
    private async isCrashStopActivated(): Promise<boolean> {
        const result: boolean = await new ReadDatabase(this.db).getCrashStopState();
        return result;
    }
}
export class ReadDatabase {
    constructor(private db) {
    }
    getCrashStopState(): Promise<boolean> {
        return this.db.collection("appConfig").doc("control").get()
            .then(result => {
                return result.data().crashStop;
            }).catch(err => {
                console.error("get crashstop error:", err);
                return false;
            }).then(crashStopOrfalse => {
                if (Tools.getBooleanValue(crashStopOrfalse)) {
                    console.log("crash stop activated");
                }
                return Tools.getBooleanValue(crashStopOrfalse);
            });
    }
/*
    getRacooneyConfig(): Promise<any> {
        return this.db.collection("racooney").doc("admin").get()
            .then(getEvent => {
                return getEvent.data();
            });
    }

    getUsernameByID(userId: string): Promise<string> {
        return this.db.collection("users").doc(userId)
            .get()
            .then((docSnapshot) => {
                if (docSnapshot.exists) {
                    return Promise.resolve(docSnapshot.data().name);
                } else {
                    return Promise.reject(null);
                }
            });
    }
    getEmailByID(userId: string): string {
        return Helpers.converters.base64ToString(userId);
    }

    isUsernameTaken(username: string) {
        return this.db.collection("usersNames").doc(username).get()
            .then((docSnapshot) => {
                return Promise.resolve(docSnapshot.exists);
            }).catch((err) => {
                console.log("erro:", err);
                return Promise.reject(false);
            });
    }*/
}