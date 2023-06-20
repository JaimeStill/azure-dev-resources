import { v4 as uuid } from 'uuid';
import { IStorage } from './istorage';

export abstract class BaseStorage<T> implements IStorage<T> {
    protected key: string;

    constructor(protected store: Storage) {
        this.key = uuid();
    }

    hasState(): boolean {
        return this.store.hasOwnProperty(this.key);
    }

    get(): T | null {
        const item: string | null = this.store.getItem(this.key);

        return item
            ? <T>JSON.parse(item)
            : null;
    }

    set(value: T | null): void {
        if (value)
            this.store.setItem(this.key, JSON.stringify(value))
        else
            this.store.removeItem(this.key);
    }

    clear(): void {
        this.store.removeItem(this.key);
    }
}
