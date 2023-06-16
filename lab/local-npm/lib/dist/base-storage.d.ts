import { IStorage } from './istorage';
export declare abstract class BaseStorage<T> implements IStorage<T> {
    protected store: Storage;
    protected key: string;
    constructor(store: Storage);
    hasState(): boolean;
    get(): T | null;
    set(value: T | null): void;
    clear(): void;
}
