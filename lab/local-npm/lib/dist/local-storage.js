import { BaseStorage } from './base-storage';
export class LocalStorage extends BaseStorage {
    constructor() {
        super(localStorage);
    }
}
