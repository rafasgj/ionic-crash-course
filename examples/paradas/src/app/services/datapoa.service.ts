import { HttpClient, HttpParams } from '@angular/common/http';

import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class DatapoaService {
    public stops: any[] = [];
    private url: string = 'http://www.poatransporte.com.br/php/facades/process.php';

    constructor(private http: HttpClient) {}

    getStops(mxlat:number, mxlon:number, mnlat:number, mnlon:number)
    {
        let g = "((" + mxlat + "," + mxlon + "),(" + mnlat + "," + mnlon + "))";
        const options = {
            params: new HttpParams().set('a','tp').set('p', g)
        }
        return this.http.get<any[]>(this.url, options);
    }

    initialize(mxlat:number, mxlon: number, mnlat:number, mnlon: number)
    {
        this.getStops(mxlat, mxlon, mnlat, mnlon)
            .subscribe(
                (data: any[]) => { data.forEach((d) => {
                        this.stops.push(
                            new Stop(d.codigo, d.latitude, d.longitude, d.terminal, d.linhas)
                        );
                    })},
                (error) => { console.log("ERROR getting data"); console.log(error); }
            );
    }
}

class Stop {
    public codigo: string;
    public latitude: number;
    public longitude: number;
    public terminal: boolean;
    public linhas: Linha[];

    constructor(code: string, lat: string, lon: string, t: string, ls: any[])
    {
        this.codigo = code;
        this.latitude = parseFloat(lat);
        this.longitude = parseFloat(lon);
        this.terminal = (t == 'S' || t == 's');
        this.linhas = []
        ls.forEach((linha) => this.linhas.push(new Linha(linha)));
    }
}

class Linha {
    public codigo: string;
    public nome:string;

    constructor(stopLinha:any) {
        this.codigo = stopLinha.codigoLinha;
        this.nome = stopLinha.nomeLinha;
    }
}
