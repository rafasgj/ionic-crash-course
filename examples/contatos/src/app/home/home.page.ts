import { Component } from '@angular/core';

import { ContatosService } from '../services/contatos.service';

@Component({
  selector: 'app-home',
  templateUrl: 'home.page.html',
  styleUrls: ['home.page.scss'],
})
export class HomePage {
    constructor(public contatosService: ContatosService) {}
}
