import { BaseStorage } from './base-storage';

export class SessionStorage<T> extends BaseStorage<T> {
    constructor() {
        super(sessionStorage);
    }
}
