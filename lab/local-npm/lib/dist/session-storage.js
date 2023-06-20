import { BaseStorage } from './base-storage';
export class SessionStorage extends BaseStorage {
    constructor() {
        super(sessionStorage);
    }
}
