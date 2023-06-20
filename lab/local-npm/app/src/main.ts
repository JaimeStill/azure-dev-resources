import './style.css'
import { AppStorage } from './app-storage.ts'

document.querySelector<HTMLDivElement>('#app')!.innerHTML = `
  <div>
    <h1>Local <em>Simple Storage</em> npm Package</h1>
    <div id="storage"></div>
  </div>
`

new AppStorage(document.querySelector<HTMLDivElement>('#storage')!)
