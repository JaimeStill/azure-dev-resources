import { v4 as uuid } from 'uuid';
export class BaseStorage {
    store;
    key;
    constructor(store) {
        this.store = store;
        this.key = uuid();
    }
    hasState() {
        return this.store.hasOwnProperty(this.key);
    }
    get() {
        const item = this.store.getItem(this.key);
        return item
            ? JSON.parse(item)
            : null;
    }
    set(value) {
        if (value)
            this.store.setItem(this.key, JSON.stringify(value));
        else
            this.store.removeItem(this.key);
    }
    clear() {
        this.store.removeItem(this.key);
    }
}
