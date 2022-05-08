export enum RESPONSECAT_TYPES {
    TEST = "TEST",
    INITIAL_PURCHASE = "INITIAL_PURCHASE",
    NON_RENEWING_PURCHASE = "NON_RENEWING_PURCHASE",
    RENEWAL = "RENEWAL",
    PRODUCT_CHANGE = "PRODUCT_CHANGE",
    CANCELLATION = "CANCELLATION",
    BILLING_ISSUE = "BILLING_ISSUE",
    SUBSCRIBER_ALIAS = "SUBSCRIBER_ALIAS",
    SUBSCRIPTION_PAUSED = "SUBSCRIPTION_PAUSED"
}

export class ResponseCat {
    admin;
    userId: string;
    type: RESPONSECAT_TYPES;
    req;

    constructor(admin, req) {
        this.req = req;
        this.admin = admin;
        this.type = req.body.event.type;
        this.userId = req.body.event.app_user_id;
    }

    async instance() {
        switch (this.type) {
            case RESPONSECAT_TYPES.TEST:
                console.log(`Valid test with type ${JSON.stringify(this.req.body)}`)
                break;
            case RESPONSECAT_TYPES.INITIAL_PURCHASE:
                return this.userSubscriptionChange(this.userId, true)
            case RESPONSECAT_TYPES.NON_RENEWING_PURCHASE:

                break;
            case RESPONSECAT_TYPES.RENEWAL:
                return this.userSubscriptionChange(this.userId, true)
            case RESPONSECAT_TYPES.PRODUCT_CHANGE:

                break;
            case RESPONSECAT_TYPES.CANCELLATION:
                return this.userSubscriptionChange(this.userId, false)
            case RESPONSECAT_TYPES.BILLING_ISSUE:
                break;
            case RESPONSECAT_TYPES.SUBSCRIBER_ALIAS:
                break;
            case RESPONSECAT_TYPES.SUBSCRIPTION_PAUSED:
                break;
        }
        return Promise.resolve();
    }

    async userSubscriptionChange(userId: string, active: boolean) {
        return this.admin.firestore().collection("users").doc(userId)
            .update({
                "active": active
            }).then(writeResult => {
                console.log(`deactivated - ${userId}:`, writeResult);
                return;
            }).catch(err => {
                console.log(`error trying to deactivate - ${userId}:`, err);
                return;
            });
    }
}