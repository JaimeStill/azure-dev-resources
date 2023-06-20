import { 
    IStorage,
    SessionStorage
} from '@local/simple-storage';

interface StoreUser {
    id: number;
    name: string;
    username: string;
    email: string;
    website: string;
}

export class AppStorage {
    private store: IStorage<StoreUser>;

    private getButton = (selector: string): HTMLButtonElement =>
        this.root.querySelector<HTMLButtonElement>(selector)!;

    private getOutlet = (): HTMLDivElement => this.root.querySelector<HTMLDivElement>('#outlet')!;

    private render = (): string =>
        this.getOutlet().innerHTML = this.store.hasState()
            ? `<pre><code>${JSON.stringify(this.store.get())}</code></pre>`
            : `<p>Click <strong>Load</strong> to initialize storage state</p>`;

    private setupLoad = (): void =>
        this.getButton('#load').addEventListener('click', () => {
            if (!this.store.hasState()) {
                this.store.set(<StoreUser>{
                    "id": 1,
                    "name": "Leanne Graham",
                    "username": "Bret",
                    "email": "Sincere@april.biz",
                    "website": "hildegard.org"
                });

                this.render();
            }
        });

    private setupClear = (): void =>
        this.getButton('#clear').addEventListener('click', () => {
            if (this.store.hasState()) {
                this.store.clear();
                this.render();
            }
        });

    private init(): void {
        this.root.innerHTML = `
            <div id="outlet"></div>
            <div class="controls">
                <button id="load" type="button">Load</button>
                <button id="clear" type="button">Clear</button>
            </div>
        `;

        this.render();
        this.setupLoad();
        this.setupClear();
    }

    constructor(private root: HTMLDivElement) {
        this.store = new SessionStorage();
        this.init();
    }
}