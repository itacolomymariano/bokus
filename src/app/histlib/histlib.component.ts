import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { BkserviceService } from '../bkservice.service';
import { PoPageAction, PoTableColumn } from '@po-ui/ng-components';

@Component({
  selector: 'app-histlib',
  templateUrl: './histlib.component.html',
  styleUrl: './histlib.component.css'
})
export class HistlibComponent implements OnInit{


  codUsu: string = '';
  nomeUsu: string = '';

  historlib: Array<any> = [];
  hideLoading: boolean = true;

  colHistorico: Array<PoTableColumn> = [
		{ property: 'pedido', label: 'Pedido' },
		{ property: 'dtlib', label: 'Data Liberação' },
		{ property: 'hrlib', label: 'Hora Liberação' },
		{ property: 'codblq', label: 'Bloq.Liberado' },
		{ property: 'dscblq', label: 'Descrição' }  ]

    public readonly actions: Array<PoPageAction> = [
      { label: 'Home', url: '/home' },
    ];  
    
  constructor(
    private bkserviceService: BkserviceService,
    private router: Router
    ){}

  ngOnInit(): void {
      console.log("Itacolomy - HistlibComponent ==> ngOnInit()")
      this.getDadusu()
      this.getHistor(this.codUsu)
  }

  goBack(){
    this.router.navigate(['/home'])
  }

  getHistor(codusu: string){
    this.callHistorLib(codusu)
  }
  callHistorLib(codusu: string): void {
    this.hideLoading = false
    this.bkserviceService.getHistLib(codusu).subscribe({
      next: res =>{
        this.historlib = res.histlib
        this.hideLoading = true
      }, 
      error: () => this.hideLoading = true
    }) 
  }

  getDadusu(){
    this.callUsuProtheus()
  }

  callUsuProtheus(): void{
    this.hideLoading = false
    this.bkserviceService.callUsuProtheus().subscribe({
      next: res=>{
        this.codUsu = res.dadosusuario.cod
        this.nomeUsu = res.dadosusuario.nome
      }, 
      error: () => this.hideLoading = true
    }) 
  }
} //Fim da class HistlibComponent
