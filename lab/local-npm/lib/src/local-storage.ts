import { BaseStorage } from './base-storage';

export class LocalStorage<T> extends BaseStorage<T> {
    constructor() {
        super(localStorage);
    }
}
