export class Schedule {
    private _monday: boolean = false;
    private _tuesday: boolean = false;
    private _wednesday: boolean = false;
    private _thursday: boolean = false;
    private _friday: boolean = false;
    private _saturday: boolean = false;
    private _sunday: boolean = false;

    get monday(): boolean {
        return this._monday;
    }

    set monday(value: boolean) {
        this._monday = value;
    }

    get tuesday(): boolean {
        return this._tuesday;
    }

    set tuesday(value: boolean) {
        this._tuesday = value;
    }

    get wednesday(): boolean {
        return this._wednesday;
    }

    set wednesday(value: boolean) {
        this._wednesday = value;
    }

    checkValidity(x): boolean {
        if (x == null) {
            return true;
        }

        if (x === null) {
            return true;
        }

        if (typeof x === "undefined") {
            return true;
        }
        return false;
    }

    get thursday(): boolean {
        /*if (this.checkValidity(this._thursday)) {
            return false;
        }*/
        return this._thursday;
    }

    set thursday(value: boolean) {
        this._thursday = value;
    }

    get friday(): boolean {
        return this._friday;
    }

    set friday(value: boolean) {
        this._friday = value;
    }

    get saturday(): boolean {
        return this._saturday;
    }

    set saturday(value: boolean) {
        this._saturday = value;
    }

    get sunday(): boolean {
        return this._sunday;
    }

    set sunday(value: boolean) {
        this._sunday = value;
    }
}

export class Order {
    private _exchange: string = "";
    private _amount: number = 0;
    private _pair: string = "";
    private _active: boolean = false;
    private _userId: string = "";
    private _schedule: Schedule = new Schedule();

    get schedule(): Schedule {
        return this._schedule;
    }

    set schedule(value: Schedule) {
        this._schedule = value;
    }

    get userId(): string {
        return this._userId;
    }

    set userId(value: string) {
        this._userId = value;
    }

    get active(): boolean {
        return this._active;
    }

    set active(value: boolean) {
        this._active = value;
    }

    constructor() {
    }

    get exchange(): string {
        return this._exchange;
    }

    set exchange(value: string) {
        this._exchange = value;
    }

    get amount(): number {
        return this._amount;
    }

    set amount(value: number) {
        this._amount = value;
    }

    get pair(): string {
        return this._pair;
    }

    set pair(value: string) {
        this._pair = value;
    }
}