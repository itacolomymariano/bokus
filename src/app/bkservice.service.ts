import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { HttpClient, HttpHeaders } from '@angular/common/http';

const httpOptions = {
  headers: new HttpHeaders(
      {
          //'Access-Control-Allow-Origin': '*',
          //Authorization: 'Basic ' + btoa("admin" + ":" + "Cod@2024"),
          /*
          "Authorization": "Basic VGhpYWdvLnRvdHZzOlVzdWFyaW8wMSM="
            },          
          */
          /*'Authorization': 'Basic ' + btoa("Thiago.totvs" + ":" + "Usuario01#"),*/
          'Authorization': 'Basic ' + btoa("admin" + ":" + "teste"),
          'Content-Type': 'application/json',

      }
  ),
  params: {}
};

const options = httpOptions

@Injectable({
  providedIn: 'root'
})
export class BkserviceService {

  //SERVIÇO DE API REST

  apiurl =   ''//environment.APIURL;
  //Ita - 15/09/2024 - apiurl =   'http://187.94.58.51:8099/rest';
  //apiurl = 'http://26.12.9.223:8889/rest'; //Não costumava ser necessário o app-root pode ser que seja um bug

  wCliente: string = '';
  wLoja: string = '';
  wNome: string = '';
  wFantasia: string = '';
  lpedMark: boolean = false;
  wcodUsu: string = '';
  wnomeUsu: string = '';  

  constructor(
    private httpClient: HttpClient
  ) { }
 
  getPedidos(): Observable<any> {
    console.log("Itacolomy executando BkserviceService: invocando this.httpClient.get('/api/v1/getPedidos?cCall=P&cPedSC5=xxxxxx&filialpv=xxxxxx, options)...")
    return this.httpClient.get('/api/v1/getPedidos?cCall=P&cPedSC5=xxxxxx&filialpv=xxxxxx', options)
    //return this.httpClient.get(this.apiurl+'/api/v1/getPedidos', options)
}
getItems(pedido: string, filialpv: string): Observable<any> {
  console.log("Itacolomy executando BkserviceService: invocando this.httpClient.get('/api/v1/getItems', options)...")
  return this.httpClient.get('/api/v1/getPedidos?cCall=I&cPedSC5='+pedido+'&filialpv='+filialpv, options)
  //return this.httpClient.get(this.apiurl+'/api/v1/getPedidos', options)
}
getDatCli(cliente: string, loja: string, statpv: string) : Observable<any> {
  console.log("Itacolomy executando BkserviceService: invocando this.httpClient.get('/api/v1/getDatCli?cliente='+cliente+'&loja='+loja&statpv='+statpv, options) ...")
  return this.httpClient.get('/api/v1/getDatCli?cliente='+cliente+'&loja='+loja+'&statpv='+statpv, options)  
}

getTitAbt(cliente: string, loja: string, filialpv: string) : Observable<any> {
  console.log("Itacolomy executando BkserviceService: invocando this.httpClient.get('/api/v1/getTitAbt?cliente='+cliente+'&loja='+loja+'&filialpv='+filialpv, options) ...")
  return this.httpClient.get('/api/v1/getTitAbt?cliente='+cliente+'&loja='+loja+'&filialpv='+filialpv, options)    
}
getTitLiq(cliente: string, loja: string, filialpv: string) : Observable<any> {  
  console.log("Itacolomy executando BkserviceService: invocando this.httpClient.get('/api/v1/getTitLiq?cliente='+cliente+'&loja='+loja+'&filialpv='+filialpv, options) ...")
  return this.httpClient.get('/api/v1/getTitLiq?cliente='+cliente+'&loja='+loja+'&filialpv='+filialpv, options)    
}

//callPosicao(regsa1: string): Observable<any>{
  callPosicao(cliente: string, loja: string): Observable<any>{
  console.log("Itacolomy executando BkserviceService: invocando this.httpClient.get('/api/v1/callPosicao?cliente='+cliente+'&loja='+loja', options) ...")
  return this.httpClient.get('/api/v1/callPosicao?cliente='+cliente+'&loja='+loja, options)      
  //return this.httpClient.get('/api/v1/callPosicao?regsa1='+regsa1, options)      
}

getRefSaldo(regsa1: string): Observable<any>{
  console.log("Itacolomy executando BkserviceService: invocando this.httpClient.get('/api/v1/getRefSaldo?regsa1='+regsa1, options) ...")
  return this.httpClient.get('/api/v1/getRefSaldo?regsa1='+regsa1, options) }
  
libCredPV(pedido: string,cliente: string, lAutoLib: string, statpv: string, filialpv: string): Observable<any>{
  console.log("Itacolomy executando BkserviceService: invocando this.httpClient.get('/api/v1/libCredPV?pedido='+pedido+'&cliente='+cliente+'&lAutoLib='+lAutoLib+'&filialpv='+filialpv, options) ...")
  return this.httpClient.post('/api/v1/libCredPV?pedido='+pedido+'&cliente='+cliente+'&lAutoLib='+lAutoLib+'&statpv='+statpv+'&filialpv='+filialpv, options) }

libCliCred(pedido: string,cliente: string, lAutoLib: string, statpv: string, filialpv: string): Observable<any>{
  console.log("Itacolomy executando BkserviceService: invocando this.httpClient.get('/api/v1/libCliCred?pedido='+pedido+'&cliente='+cliente+'&lAutoLib='+lAutoLib+'&statpv='+statpv+'&filialpv='+filialpv, options) ...")
return this.httpClient.post('/api/v1/libCliCred?pedido='+pedido+'&cliente='+cliente+'&lAutoLib='+lAutoLib+'&statpv='+statpv+'&filialpv='+filialpv, options) }

deletePV(pedido: string, filialpv: string): Observable<any>{
  console.log("Itacolomy executando BkserviceService: invocando this.httpClient.get('/api/v1/deletePV?pedido='+pedido+'&filialpv='+filialpv, options) ...")
return this.httpClient.get('/api/v1/deletePV?pedido='+pedido+'&filialpv='+filialpv, options) }

getHistLib(codusu: string): Observable<any>{
  console.log("Itacolomy executando BkserviceService: invocando this.httpClient.get('/api/v1/getHistLib?codusu='+codusu, options) ...")
return this.httpClient.get('/api/v1/getHistLib?codusu='+codusu, options) }  

callUsuProtheus(): Observable<any>{
  console.log("Itacolomy executando BkserviceService: invocando this.httpClient.get('/api/v1/callUsuProtheus, options) ...")
return this.httpClient.get('/api/v1/callUsuProtheus', options) }    

geTmptHisLib(){
  return [
    {
      pedido: "000061",
      dtlib: "03/10/2024",
      hrlib: "09:56:10",
      codblq: "01",
      dscblq: "Crédito por Valor"
    
    },
    {
      pedido: "031096",
      dtlib: "03/10/2024",
      hrlib: "09:57:22",
      codblq: "01",
      dscblq: "Crédito por Valor"
    
    }    
  ]
}

getPosicaoCli() {
  return [
    {
      descr: 'Limite Crédito',
      valor: 0,
      valrea: 0,
      space: ' ',
      desc2: 'Primeira Compra',
      conpos: ' '      
    },
    {
      descr: 'Saldo Histórico',
      valor: 0,
      valrea: 0,
      space: ' ',
      desc2: 'Última Compra',
      conpos: ' '      
    },
    {
      descr: 'Li Cred Sec',
      valor: 0,
      valrea: 0,
      space: ' ',
      desc2: 'Maior Atraso',
      conpos: ' '      
    },
    {
      descr: 'Saldo LC Sec',
      valor: 0,
      valrea: 0,
      space: ' ',
      desc2: 'Média Atraso',
      conpos: ' '      
    },
    {
      descr: 'Maior Compra',
      valor: 0,
      valrea: 0,
      space: ' ',
      desc2: 'Grau de Risco',
      conpos: ' '      
    },                            
  ]
}

  getPedidosTmp(){
    return [
      {
        filial: '01',
        num: '12345',
        emissao: '28/04/2024',
        codigo: '000001',
        loja: '001',
        nome: 'PIPOCA MAIS',
        statpv: '01',
        valor: 'R$ 100.000,00'
      },
      {
        filial: '01',
        num: '12346',
        emissao: '05/06/2024',
        codigo: '000002',
        loja: '001',
        nome: 'ATACADÃO',
        statpv: 'OK',
        valor: 'R$ 50.000,00'
      },
      {
        filial: '01',
        num: '12347',
        emissao: '03/05/2024',
        codigo: '000003',
        loja: '002',
        nome: 'CECILIA DOCES',
        statpv: 'OK',
        valor: 'R$ 75.000,00'
      }    
    ]
      
  }  


} //Fim da class BkserviceService
