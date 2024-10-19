import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
//import { HomeComponent } from '../home/home.component';
import { PoPageAction, PoTableColumn } from '@po-ui/ng-components';
import { BkserviceService } from '../bkservice.service';

@Component({
  selector: 'app-posicao',
  templateUrl: './posicao.component.html',
  styleUrl: './posicao.component.css'
})

export class PosicaoComponent implements OnInit{

  codCli: string='';
  lojCli: string='';
  nomeCli: string = '';
  fantaCli: string = '';

  posicaocli: Array<any> = [];
  hideLoading: boolean = true;

  colPosicao: Array<PoTableColumn> = [
    { property: 'descr', label: 'Descrição' },
    { property: 'valor', label: 'Valor' },
    { property: 'valrea', label: 'Valores em R$' },
    { property: 'space', label: ' ' },
    { property: 'desc2', label: 'Descrição' },
    { property: 'conpos', label: 'Consulta Posição' }
  ]

  public readonly actions: Array<PoPageAction> = [
    { label: 'Home', url: '/home' },
  ];  
  constructor(
    private bkserviceService: BkserviceService,
    private router: Router
  ) {}
  ngOnInit(): void {
    console.log("Itacolomy executando PosicaoComponent - Invocando this.getPosicaoCli() ...")
    this.getCargCli()
    this.callPosicao(this.bkserviceService.wCliente,this.bkserviceService.wLoja)
    //this.getPosicaoCli()
  }
  goBack(){
    this.router.navigate(['/home'])
  }
  getPosicaoCli(): void {
    this.hideLoading = false
    this.posicaocli = this.bkserviceService.getPosicaoCli()
    this.hideLoading = true    
  }

  callPosicao(cliente: string,loja: string): void {
    this.hideLoading = false
    this.bkserviceService.callPosicao(cliente,loja).subscribe({
      next: res =>{
        this.posicaocli = res.poscli.dados
        console.log("Itacolomy retornando de this.bkserviceService.callPosicao(cliente,loja) res.poscli.dados",res.poscli.dados)
        /*
        for (let i = 0; i < res.poscli.dados.length; i++) { 
          //this.posicaocli[i]  = res.poscli.dados[i]
          this.posicaocli.push({
            descr: res.poscli.dados[i].descr,
            valor: res.poscli.dados[i].valor,
            valrea: res.poscli.dados[i].valrea,
            space: res.poscli.dados[i].space,
            desc2: res.poscli.dados[i].desc2,
            conpos: res.poscli.dados[i].conpos
          });          
          console.log("Itacolomy retornando de this.bkserviceService.callPosicao(cliente,loja) res.poscli.dados[i]",res.poscli.dados[i])
        }
          */
          

        this.hideLoading = true
      }, 
      error: () => this.hideLoading = true
    })   
  }

  getCargCli(){
    this.codCli = this.bkserviceService.wCliente
    this.lojCli = this.bkserviceService.wLoja
    this.nomeCli = this.bkserviceService.wNome
    this.fantaCli = this.bkserviceService.wFantasia

    console.log('this.codCli: '+this.codCli)
    console.log('this.lojCli: '+this.lojCli)
    console.log('this.nomeCli: '+this.nomeCli)
    console.log('this.fantaCli: '+this.fantaCli)

  }

} //Fim da class PosicaoComponent
