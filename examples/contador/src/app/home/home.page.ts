import { Component } from '@angular/core';

@Component({
  selector: 'app-home',
  templateUrl: 'home.page.html',
  styleUrls: ['home.page.scss'],
})
export class HomePage {
    public counter: number = 0;

    constructor() {}

    increaseCounter() {
        this.counter += 1;
        console.log("counter == " + this.counter)
    }
}
