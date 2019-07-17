import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class ContatosService {
    public contatos: Contato[] = [
        new Contato("Luana", ["555-1234", "555-3241"]),
        new Contato("Rafael", ["555-3421"]),
        new Contato("Maya", ["555-4321"])
    ];
  constructor() { }
}

class Contato {
  constructor(public name:string, public phones:string[]) {}
}
