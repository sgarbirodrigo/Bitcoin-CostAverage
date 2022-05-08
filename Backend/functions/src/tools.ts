import {firestore} from "firebase-admin/lib/firestore";
import Timestamp = firestore.Timestamp;
import {Schedule} from "./models/order_model";

enum WEEK_DAYS {SUNDAY = "sunday", MONDAY = "monday", TUESDAY = "tuesday", WEDNESDAY = "wednesday", THURSDAY = "thursday", FRIDAY = "friday", SATURDAY = "saturday"}

export class Tools {
    static getWeekDay(timestamp: Timestamp): WEEK_DAYS {
        const weekday = [WEEK_DAYS.SUNDAY, WEEK_DAYS.MONDAY, WEEK_DAYS.TUESDAY, WEEK_DAYS.WEDNESDAY, WEEK_DAYS.THURSDAY, WEEK_DAYS.FRIDAY, WEEK_DAYS.SATURDAY];
        const date: Date = timestamp.toDate();
        return weekday[date.getDay()];
    }

    static checkSchedule(schedule: Schedule): boolean {
        const today = this.getWeekDay(Timestamp.now());
        switch (today) {
            case WEEK_DAYS.SUNDAY:
                if (schedule.sunday) return true;
                break;
            case WEEK_DAYS.MONDAY:
                if (schedule.monday) return true;
                break;
            case WEEK_DAYS.TUESDAY:
                if (schedule.tuesday) return true;
                break;
            case WEEK_DAYS.WEDNESDAY:
                if (schedule.wednesday) return true;
                break;
            case WEEK_DAYS.THURSDAY:
                if (schedule.thursday) return true;
                break;
            case WEEK_DAYS.FRIDAY:
                if (schedule.friday) return true;
                break;
            case WEEK_DAYS.SATURDAY:
                if (schedule.saturday) return true;
                break;
        }
        return false;
    }
    static getBooleanValue(value) {
        //THE SEQUENCE OF THE TESTS DOES MATTER
        //test if can be used toString()
        if (typeof value === "undefined" || value === null) {
            return false;
        }
        if (value.toString() === "true") {
            return true;
        }
        if (this.isNumber(value)) {
            return value.toString() === "1";
        }


        return false;
    }

    static getNumberValue(value) {
        //INVALID TYPES WILL RETURN 0
        if (!this.isItemValid(value)) {
            return 0;
        }
        if (isNaN(Number(value.toString()))) {
            return 0;
        }
        return Number(value.toString());
    }/*
    static isBTCAddressValid(address:string){
        return WAValidator.validate(address,"BTC");
    }*/
    static isItemValid(data) {
        if (data === null || data === "undefined" || data === undefined) {
            return false;
        }
        if (typeof data === "string" || data instanceof String) {
            if (data.length === 0 || data.toString() === " ") {
                return false;
            }
        }
        return true;
    }

    static isNumber(value: string | number): boolean {
        if (!this.isItemValid(value)) {
            return false;
        }

        return !isNaN(Number(value));

        //return ((value !== null) && !isNaN(Number(value.toString())));
    }
}
