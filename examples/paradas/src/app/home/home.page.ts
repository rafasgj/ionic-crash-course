import { Component } from '@angular/core';

import { DatapoaService } from "../services/datapoa.service";

@Component({
  selector: 'app-home',
  templateUrl: 'home.page.html',
  styleUrls: ['home.page.scss'],
})
export class HomePage {

    constructor(public datapoa: DatapoaService) {}

    public ngOnInit() {
        console.log("ON NG INIT");
        let a = -30.058590;
        let b = -51.177123;
        let c = -30.055466;
        let d = -51.170243;
        this.datapoa.initialize(a, b, c, d)
     }

}
