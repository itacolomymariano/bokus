import { Component, OnInit, ViewChild } from '@angular/core';

import { PoMenuItem, PoTableColumn, PoTableComponent, PoNotificationService, PoRadioGroupOption, PoSelectOption, PoInfoOrientation, PoModalModule, PoModalAction, PoModalComponent, PoPageAction } from '@po-ui/ng-components';
import { ProAppConfigService } from '@totvs/protheus-lib-core';
import { BkserviceService } from '../bkservice.service';
import { Router } from '@angular/router';


@Component({
  selector: 'app-browse',
  templateUrl: './browse.component.html',
  styleUrl: './browse.component.css'
})
export class BrowseComponent implements OnInit{

  title = 'bkanacred';
  pedidos: Array<any> = [];
  pedrefresh: Array<any> = [];
  items : Array<any> = [];
  titulos: Array<any> = [];
  titliq: Array<any> = [];
  hideLoading: boolean = true;
  //orientation: PoInfoOrientation;

  lInfiniteScroll: boolean = true;
 
  codCli: string='';
  lojCli: string='';
  nomeCli: string = '';
  fantaCli: string = '';
  cnpjCli: string = '';
  inscCli: string = '';
  codblq: string = '';
  descblq: string = '';
  tel: string = '';
  codcnd: string = '';
  desccnd: string = '';
  //tel2: string = '';
  email: string = '';
  //fax: string = '';
  //vaz: string  = ''
  //fax2: string = '';
  codseg: string = '';
  descseg: string = '';
  cel: string = '';
  vendpir: string = '';
  descvend: string = '';
  //cel2: string = '';
  qtdtit: number = 0;
  titaberto: number = 0;
  venc15: number = 0;
  venc16: number = 0;
  limcred: number = 0;
  pedfat: number = 0;
  saldolim: number = 0;
  regsa1: string = '';
  pedido: string = '';
  filialpv: string = '';
  lLibAbas: boolean = false;

  content: string = ''; //Conteúdo do Modal - Pode ser a mensagem que será apresentada
  size: string = '';//'Small -'sm';Medium-'md';Large-'lg';Extra large-'xl';Automatic-'auto'
  titlemd: string = 'Bokus - Análise de Crédito'; //Título do Modal
  icon: string = ''; //ph ph-newspaper; ph ph-magnifying-glass ou fa fa-calculator
  lclickout: boolean = true;
  lhideclose: boolean = true;
  statuspedido: string = '';
  lShowPosicao: boolean = true;
  lShowHome: boolean = false;

  codUsu: string = '';//'000061';
  nomeUsu: string = '';//'Thiago.totvs';
  
  historlib: Array<any> = [];

  colHistorico: Array<PoTableColumn> = [
    { property: 'filial', label: 'Filial'},
    { property: 'nmeusu', label: 'Usuario'},
		{ property: 'pedido', label: 'Pedido' },
		{ property: 'dtlib', label: 'Data Liberação' },
		{ property: 'hrlib', label: 'Hora Liberação' },
		//{ property: 'codblq', label: 'Bloq.Liberado' },
		//{ property: 'dscblq', label: 'Descrição' }  ]
    { 
      property: 'codblq', 
      label: 'Bloq.Liberado', 
      type: 'label',
      labels: [
        { value:'OK', 
          textColor: 'white',
          color: 'color-10',
          label:'AUTORIZADO', 
          tooltip: 'Autorizado para faturar pedido.'
        },                        
        { value:'01', 
          textColor: 'white',
          color: 'color-07',
          label:'Crédito por Valor', 
          tooltip: 'Bloqueio de Crédito por Valor'
        },
        { value:'02', 
          textColor: 'white',
          color: 'color-05',
          label:'risco de crédito', 
          tooltip: 'bloqueio por risco de crédito'
        },                
        { value:'03', 
          textColor: 'white',
          color: 'color-08',
          label:'limite de crédito', 
          tooltip: 'bloqueio limite de crédito'
        },
        { value:'04', 
          textColor: 'white',
          color: 'color-09',
          label:'atraso de título', 
          tooltip: 'bloqueio atraso de título'
        },
        { value:'05', 
          textColor: 'white',
          color: 'color-03',
          label:'bloqueio diretoria', 
          tooltip: 'bloqueio diretoria'
        },
        { value:'XX', 
          textColor: 'white',
          color: 'color-12',
          label:'outros', 
          tooltip: 'bloqueio outros'
        },
        { value:'09', 
          textColor: 'white',
          color: 'color-01',
          label:'Rejeitado', 
          tooltip: 'Liberação de Crédito Rejeitada'
        }
      ]
    }]
    posicaocli: Array<any> = [];
  
    colPosicao: Array<PoTableColumn> = [
      { property: 'descr', label: 'Descrição' },
      { property: 'valor', label: 'Valor'}, //type: 'currency', format: 'BRL' },
      { property: 'valrea', label: 'Valores em R$'}, //type: 'currency', format: 'BRL' },
      { property: 'space', label: ' ' },
      { property: 'desc2', label: 'Descrição' },
      { property: 'conpos', label: 'Consulta Posição' }
    ]

  primaryActionLabel: string = '';
  primaryAction: PoModalAction = {
    action: () => {
      console.log("Itacolomy executando primaryAction")
      this.poModal.close();
      return
    },
    label: 'Fechar'
  };
  secondaryActionLabel: string = '';  
  secondaryAction: PoModalAction = {
    action: () => {
      console.log("Itacolomy executando secondaryAction")
      this.poModal.close();
      return
    },
    label: 'Cancel'
  };
 
  @ViewChild('POPedidos', { static: true }) poPedidos!: PoTableComponent;
  @ViewChild('POItems', { static: true }) poItems!: PoTableComponent;
  @ViewChild('POTitulos', { static: true }) poTitulos!: PoTableComponent;
  @ViewChild('POTitliq', { static: true }) poTitliq!: PoTableComponent;
  @ViewChild('POPosicao', { static: true }) poPosicao!: PoTableComponent;
  @ViewChild(PoModalComponent, { static: true }) poModal!: PoModalComponent;
 
  colunas: Array<PoTableColumn> = [
    { property: 'filial', label: 'Filial' },
    { property: 'num', label: 'Pedido' },
    { property: 'emissao', label: 'Emissao' },
    { property: 'codigo', label: 'Codigo' },
    { property: 'loja', label: 'Loja' },
    { property: 'nome', label: 'Razao/Nome' },
    { 
      property: 'statpv', 
      label: 'Status', 
      type: 'label',
      /****
        Por meio da tabela SC9, é possível identificar os códigos de  bloqueios nos seguintes campos :
        C9_BLCRED (campo)
                  Código atribuído:
                  01 - Bloqueio de Crédito por Valor   
                  04 - Vencimento do Limite de Crédito - Data de Crédito Vencida 
                  05 - Bloqueio Manual/Estorno
                  09 - Liberação de Crédito Rejeitada
                  10 - Faturado
                  ZZ - Liberação Tardia
        C9_BLCRED (campo) integração com Totvs Mais Negócios
                  Código atribuído:
                  80 ou 92 - Análise da plataforma Risk
                  90 ou 91 - Bloqueio por regras - plataforma Risk
        C9_BLEST (campo)
                  Código atribuído:
                  02 - Bloqueio de Estoque                        
                  03 - Bloqueio Manual de Estoque - Ocorre quando o Pedido já estava liberado por estoque, 
                       e é uma ação do usuário que invalida a liberação (que retorna para bloqueado). 
                      Isso pode ocorrer quando se altera o Pedido de Vendas já liberado, ou quando estorna a 
                      liberação em MATA460A - Documento de Saída (Ações relacionadas > Estorn. Docs).
                  10 - Faturado
                  ZZ - Liberação Tardia
        C9_BLWMS
                  01 - Bloqueio de Endereçamento do WMS/Somente SB2
                  02 - Bloqueio de Endereçamento do WMS             
                  03 - Bloqueio de WMS - Externo                 
                  05 - Liberação para Bloqueio 01                 
                  06 - Liberação para Bloqueio 02    
                  07 - Liberação para Bloqueio 03  
        Obs: Quando os campos C9_BLCRED e C9_BLEST estiverem vazios significa que o pedido liberado 
        não contém impedimentos para faturamento. 
        
        ============================================
        BLOQUEIOS BOKUS
        ============================================
        01 - bloqueio de crédito padrão ; 
        02 - bloqueio por risco de crédito ; 
        03 - bloqueio limite de crédito ; 
        04 - bloqueio atraso de título; 
        05 - bloqueio diretoria
        ============================================
      *********************************************/
      labels: [
                { value:'OK', 
                  textColor: 'white',
                  color: 'color-10',
                  label:'AUTORIZADO', 
                  tooltip: 'Autorizado para faturar pedido.'
                },                        
                { value:'01', 
                  textColor: 'white',
                  color: 'color-07',
                  label:'Crédito por Valor', 
                  tooltip: 'Bloqueio de Crédito por Valor'
                },
                { value:'02', 
                  textColor: 'white',
                  color: 'color-05',
                  label:'risco de crédito', 
                  tooltip: 'bloqueio por risco de crédito'
                },                
                { value:'03', 
                  textColor: 'white',
                  color: 'color-08',
                  label:'limite de crédito', 
                  tooltip: 'bloqueio limite de crédito'
                },
                { value:'04', 
                  textColor: 'white',
                  color: 'color-09',
                  label:'atraso de título', 
                  tooltip: 'bloqueio atraso de título'
                },
                { value:'05', 
                  textColor: 'white',
                  color: 'color-03',
                  label:'bloqueio diretoria', 
                  tooltip: 'bloqueio diretoria'
                },
                { value:'XX', 
                  textColor: 'white',
                  color: 'color-12',
                  label:'outros', 
                  tooltip: 'bloqueio outros'
                }/*,                                                                                                                
                { value:'04', 
                  textColor: 'white',
                  color: 'color-08',
                  label:'Vencimento do Limite', 
                  tooltip: 'Vencimento do Limite de Crédito - Data de Crédito Vencida'
                },
                { value:'05', 
                  textColor: 'white',
                  color: 'color-06',
                  label:'Bloq.Manual/Estorno', 
                  tooltip: 'Bloqueio Manual/Estorno'
                }*/,
                { value:'09', 
                  textColor: 'white',
                  color: 'color-01',
                  label:'Rejeitado', 
                  tooltip: 'Liberação de Crédito Rejeitada'
                }/*,
                { value:'ZZ', 
                  textColor: 'white',
                  color: 'color-03',
                  label:'Liberação Tardia', 
                  tooltip: 'Liberação Tardia'
                },                                                
                { value:'02', 
                  textColor: 'white',
                  color: 'color-04',
                  label:'Bloqueio de Estoque', 
                  tooltip: 'Bloqueio de Estoque'
                },                                                                
                { value:'03', 
                  textColor: 'white',
                  color: 'color-02',
                  label:'Bloq.Manual Estoq', 
                  tooltip: 'Bloqueio Manual de Estoque'
                }
                  */                                                                
              ]
     },
    { property: 'valor', label: 'Valor Total', type: 'currency', format: 'BRL' },
    { property: 'vendedor', label: 'Vendedor' },
    { property: 'condpgto', label: 'Cond.Pgto'}
  ];
 
  colItems: Array<PoTableColumn> = [
    { property: 'filial', label: 'Filial' },
    { property: 'item', label: 'Item' },
    { property: 'codigo', label: 'Codigo' },
    { property: 'desc', label: 'Descrição' },
    { property: 'prunit', label: 'Preço', type: 'currency', format: 'BRL' },
    { property: 'quantidade', label: 'Quantidade' },
    { property: 'um', label: 'Unidade' },
    { property: 'vlrtot', label: 'Total', type: 'currency', format: 'BRL' },
  ]
  coltitulos: Array<PoTableColumn> = [
  { property: 'filial', label: 'Filial'},
  { property: 'emissao', label:'Emissão'},
  { property: 'prefixo', label:'Prefixo'},
  { property: 'num', label:'Numero'}, 
  { property: 'parcela', label:'Parcela'}, 
  { property: 'tipo', label:'Tipo'}, 
  { property: 'valor', label:'Valor',type: 'currency', format: 'BRL'}, 
  { property: 'saldo', label:'Saldo',type: 'currency', format: 'BRL'}, 
  { property: 'vencrea', label:'Venc.Real'} 
  ];

  colLiquidados: Array<PoTableColumn> = [
    { property: 'filial', label: 'Filial'},
    { property: 'emissao', label:'Emissão'},
    { property: 'prefixo', label:'Prefixo'},
    { property: 'num', label:'Numero'}, 
    { property: 'parcela', label:'Parcela'}, 
    { property: 'tipo', label:'Tipo'}, 
    { property: 'baixa', label:'Dt.Baixa'}, 
    { property: 'valor', label:'Valor Recebido', type: 'currency', format: 'BRL'}
    ];

    readonly menus: Array<PoMenuItem> = [
      { label: 'Sair', action: this.closeApp.bind(this) }
    ];

    public readonly actions: Array<PoPageAction> = [
      /*{ label: 'Home', url: '/home' },*/
      { label: 'Sair', action: this.closeApp.bind(this) }
    ];

  constructor(
    private proAppConfigService: ProAppConfigService,
    private bkserviceService: BkserviceService,
    private poNotificationService: PoNotificationService,
    private router: Router
  ) {
  }
  ngOnInit(): void {
    console.log("Itacolomy executando HomeComponent: ngOnInit() invocando this.getPedidos()...")
    this.getPedidos();      
    this.getDadusu() //Obtém dados do usuário do Protheus
    //this.getHistor(this.codUsu)
    //console.log("Itacolomy executando HomeComponent: ngOnInit() invocando this.getHistor - this.bkserviceService.wcodUsu",this.bkserviceService.wcodUsu)
    //this.getHistor()

    //this.getPedidosTmp()
    //this.getDadosCli()
  }

  /*
  onClick() {
    this.closeApp.bind(this)
  }
    */
 
  closeApp(): void {
    if (this.proAppConfigService.insideProtheus()) {
      this.proAppConfigService.callAppClose();
    } else {
      alert('O App não está sendo executado dentro do Protheus.');
    }
  }
 
  changeOptions(event: any, type: any): void {
    this.getItems(event.num,event.filial)
    console.log("Itacolomy - changeOptions - event: ",event )
    this.bkserviceService.lpedMark = true;
    this.statuspedido = event.statpv
    this.pedido = event.num
    this.filialpv = event.filial
    this.getDatCli(event.codigo,event.loja,event.statpv);
    this.getTitAbt(event.codigo,event.loja,event.filial)
    this.getTitLiq(event.codigo,event.loja,event.filial)
    //this.getCargCli()
    this.callPosicao(event.codigo,event.loja)    
    type === "new" ? this.lLibAbas=true : this.lLibAbas=false
    /*
    this.dynamicForm.form.value.quantidade = 0
    this.fornecedor = []
    //Ita - 16/09/2024 - this.cc = ''
    //Ita - 16/09/2024 - this.armazem = ''
    this.CCLookup = '';
    this.armazemLookup = '';
    this.multiLookup = []
    //  O usuário seleciona um produto e se já não estiver marcado abre o modal
    //    para ele informar a quantidade(obrigatório) e o fornecedor(opcional)
    //    Se já estiver marcado é chamada outra funcão
    this.evento = event
    this.uniMedida = event.unidade
    this.tipo = type
    type === "new" ? this.poModal.open() : this.selectProducts()
    */
  }
 
  
  getPedidosTmp(): void {
    this.hideLoading = false
    this.pedidos = this.bkserviceService.getPedidosTmp()
    this.hideLoading = true
    /*.subscribe({
      next: res => {
        this.pedidos = res.pedidos
        this.hideLoading = true
      }, 
      error: () => this.hideLoading = true
    })*/
     }
  
  getPedidos(): void {
    console.log("Itacolomy executando AppComponent: ngOnInit()==>getPedidos() invocando this.bkserviceService.getPedidos()...")
    this.hideLoading = false
    this.bkserviceService.getPedidos().subscribe({
      next: res => {
        this.pedidos = res.pedidos
        this.hideLoading = true
        console.log("Itacolomy AppComponent: retornando de this.bkserviceService.getPedidos()...")
        console.log("Itacolomy AppComponent: next: res => ...", res.pedidos)
        }, 
        error: () => this.hideLoading = true
      })    
  } //Fim do método getPedidos()
 
  showMore() {
    this.addPedidos();
  }
  addPedidos(): void {
    this.hideLoading = false
    this.bkserviceService.getPedidos().subscribe({
      next: res => {
        //Ita - 13/10/2024 - this.pedidos = [...this.pedidos, res.pedidos ];
        console.log("Itacolomy - addPedidos() - retorno de this.bkserviceService.getPedidos() - res.pedidos[0].num:",res.pedidos[0].num)
        if(res.pedidos[0].num){
          this.pedidos.concat(res.pedidos)
          console.log("Itacolomy - addPedidos() - retorno de this.bkserviceService.getPedidos() - CONCATENEI OS PEDIDOS!")
        }else{
          console.log("Itacolomy - addPedidos() - retorno de this.bkserviceService.getPedidos() - NAO OBTEVE PEDIDOS PARA CONCATENAR!")
          this.content = "Não há mais pedidos para carregar!"
          this.poModal.open()                                  
        }
        this.hideLoading = true
      },
      error: () => this.hideLoading = true
    });
  }
 
  getItems(numped: string,filialpv: string){
    
    console.log("Itacolomy executando AppComponent: ngOnInit()==>getItems() invocando this.bkserviceService.getItems(numped,filialpv)...")
    this.hideLoading = false
    this.bkserviceService.getItems(numped,filialpv).subscribe({
      next: res => {
        this.items = res.pedidos
        this.hideLoading = true
        console.log("Itacolomy AppComponent: retornando de this.bkserviceService.getItems(numped,filialpv)...")
        console.log("Itacolomy AppComponent: next: res => ...", res.pedidos)
        }, 
        error: () => this.hideLoading = true
      })        
  }
 
  getDatCli(codigo: string, loja: string, statpv: string) {
    console.log("Itacolomy executando AppComponent: getDatCli(codigo: string, loja: string) invocando this.bkserviceService.getDatCli()...")
    this.hideLoading = false
    this.bkserviceService.getDatCli(codigo,loja,statpv).subscribe({
      next: res => {
        /*
        res.informacoes.forEach(info => {
          //console.log(item.id, item.nome);
          this.codCli      = info.codCli;
       });
       */
        for (let i = 0; i < res.informacoes.length; i++) { 

          this.codCli      = res.informacoes[i].codCli
          this.lojCli      = res.informacoes[i].lojCli
          this.nomeCli     = res.informacoes[i].nomeCli
          this.fantaCli    = res.informacoes[i].fanta
          this.cnpjCli     = res.informacoes[i].cnpjCli
          this.inscCli     = res.informacoes[i].inscCli
          this.codblq      = res.informacoes[i].codblq
          this.descblq     = res.informacoes[i].descblq
          this.tel         = res.informacoes[i].tel
          this.codcnd      = res.informacoes[i].codcnd
          this.desccnd     = res.informacoes[i].desccnd
          //this.tel2        = res.informacoes[i].tel2
          this.email       = res.informacoes[i].email
          //this.fax         = res.informacoes[i].fax
          //this.vaz         = res.informacoes[i].vaz
          //this.fax2        = res.informacoes[i].fax2
          this.codseg      = res.informacoes[i].codseg
          this.descseg     = res.informacoes[i].descseg
          this.cel         = res.informacoes[i].cel
          //this.cel2        = res.informacoes[i].cel2
          this.vendpir     = res.informacoes[i].vendpir
          this.descvend    = res.informacoes[i].descvend
          this.qtdtit      = res.informacoes[i].qtdtit
          this.titaberto   = res.informacoes[i].titaberto
          this.venc15      = res.informacoes[i].venc15
          this.venc16      = res.informacoes[i].venc16
          this.limcred     = res.informacoes[i].limcred
          this.pedfat      = res.informacoes[i].pedfat
          this.saldolim    = res.informacoes[i].saldolim
          this.regsa1      = res.informacoes[i].regsa1

          this.bkserviceService.wCliente = res.informacoes[i].codCli
          this.bkserviceService.wLoja = res.informacoes[i].lojCli
          this.bkserviceService.wNome = res.informacoes[i].nomeCli
          this.bkserviceService.wFantasia = res.informacoes[i].fanta
          
        }        
 
        this.hideLoading = true
        console.log("Itacolomy AppComponent: retornando de this.bkserviceService.getDatCli(codigo,loja)...")
        console.log("Itacolomy AppComponent: this.bkserviceService.getDatCli(codigo,loja) next: res => ...", res.informacoes)
 
      }, 
      error: () => this.hideLoading = true
    })
  }

  getTitAbt(codigo: string, loja: string, filialpv: string) {

    console.log("Itacolomy executando AppComponent: getTitAbt(codigo,loja) invocando this.bkserviceService.getTitAbt(codigo,loja)...")
    this.hideLoading = false
    this.bkserviceService.getTitAbt(codigo,loja,filialpv).subscribe({
      next: res => {
        this.titulos = res.titulos
        this.hideLoading = true
        console.log("Itacolomy AppComponent: retornando de this.bkserviceService.getTitAbt(codigo,loja)...")
        console.log("Itacolomy AppComponent: this.bkserviceService.getTitAbt(codigo,loja) next: res => ...", res.titulos)
      }, 
      error: () => this.hideLoading = true
    })     

  }

  getTitLiq(codigo: string, loja: string, filialpv: string){

    console.log("Itacolomy executando AppComponent: getTitLiq(codigo,loja) invocando this.bkserviceService.getTitLiq(codigo,loja, filialpv)...")
    this.hideLoading = false
    this.bkserviceService.getTitLiq(codigo,loja,filialpv).subscribe({
      next: res => {
        this.titliq = res.titliq
        this.hideLoading = true
        console.log("Itacolomy AppComponent: retornando de this.bkserviceService.getTitLiq(codigo,loja, filialpv)...")
        console.log("Itacolomy AppComponent: this.bkserviceService.getTitLiq(codigo,loja,filialpv) next: res => ...", res.titliq)
      }, 
      error: () => this.hideLoading = true
    })     

  }

  goRefSaldo(regsa1: string): void {
    if (this.proAppConfigService.insideProtheus()) {
      this.getRefSaldo(regsa1);
    } else {
      alert('O Recalculo de Saldos só poderá ser realizado dentro do Protheus.');
    }
  }  

  getRefSaldo(regsa1: string): void {
    this.hideLoading = false
    this.bkserviceService.getRefSaldo(regsa1).subscribe({
      next: res =>{
        console.log("Itacolomy retornando de this.bkserviceService.getRefSaldo(cliente,loja)", res.cliref)
        this.hideLoading = true
        this.content = "O processo refaz saldo foi concluído!"
        this.poModal.open()        
      }, 
      error: () => this.hideLoading = true
    })   
  }  
  
  golibCredPV(pedido: string,cliente: string, lAutoLib: string, statpv: string, filialpv: string): void {
    if (this.proAppConfigService.insideProtheus()) {
      if (this.statuspedido == "OK"){
        this.content = "O Pedido selecionado já encontra-se Autorizado para faturamento!"
        this.poModal.open()
      }else{
        if (this.statuspedido == "09"){
          this.content = "O Pedido selecionado encontra-se rejeitado, não poderá ser liberado para faturamento!"
          this.poModal.open()
        }else{
          this.libCredPV(pedido,cliente,lAutoLib,statpv, filialpv);
        }
      }
    } else {
      alert('A liberação de Crédito do Pedido de Vendas só poderá ser realizada dentro do Protheus.');
    }
  }  

  libCredPV(pedido: string,cliente: string, lAutoLib: string, statpv: string, filialpv: string): void {
    this.hideLoading = false
    this.bkserviceService.libCredPV(pedido,cliente, lAutoLib, statpv, filialpv).subscribe({
      next: res =>{
        console.log("Itacolomy retornando de this.bkserviceService.libCredPV(pedido,cliente, lAutoLib)", res.libped)
        console.log("Itacolomy retornando de this.bkserviceService.libCredPV - res.libped.liberou", res.libped[0].liberou)
        this.hideLoading = true
        if (res.libped[0].liberou === "S") {
            /** Ita - 02/10/2024 Atualiza o pedido no grid **/
            //Ita - 16/10/2024 - const index = this.pedidos.findIndex(obj => obj.num === pedido);
            //const index = this.pedidos.findIndex(obj => obj.num === pedido && obj.filial === filialpv);
            const index = this.pedidos.findIndex(obj => obj.num == pedido && obj.filial == filialpv);
            if (index !== -1) {
              
              //this.pedidos.splice(index, 1);  // Remover o pedido do grid(array pedidos)
              this.pedidos[index].statpv = 'OK' // Atualiza o status do pedido no grid(array pedidos)
            }
            /**Ita - 02/10/2024 Fim da instrução para atualizar o pedido do grid */
            this.getHistor(this.codUsu)//Ita - 08/10/2024
            this.content = "Pedido Liberado!"
            this.poModal.open()
        }else{
            this.content = "O pedido não foi liberado! Favor verificar se há limites finaceiros disponíveis ou se há alguma restrição de estoques."
            this.poModal.open()
        }
                        
      }, 
      error: () => this.hideLoading = true
    })   
  }

  golibCliCred(pedido: string,cliente: string, lAutoLib: string, statpv: string, filialpv: string): void {
    if (this.proAppConfigService.insideProtheus()) {
      if (this.statuspedido == "OK"){
        this.content = "O Pedido selecionado já encontra-se Autorizado para faturamento!"
        this.poModal.open()
      }else{
        if (this.statuspedido == "09"){
          this.content = "O Pedido selecionado encontra-se rejeitado, não poderá ser liberado para faturamento!"
          this.poModal.open()
        }else{
          this.libCliCred(pedido,cliente,lAutoLib,statpv,filialpv);
        }
      }      
      
    } else {
      alert('A liberação de Crédito do Cliente só poderá ser realizada dentro do Protheus.');
    }
  }    

  libCliCred(pedido: string,cliente: string, lAutoLib: string, statpv: string, filialpv: string): void {
    this.hideLoading = false
    this.bkserviceService.libCliCred(pedido,cliente, lAutoLib, statpv, filialpv).subscribe({
      next: res =>{
        console.log("Itacolomy retornando de this.bkserviceService.libCliCred(pedido,cliente, lAutoLib)", res.libcli)
        console.log("Itacolomy retornando de this.bkserviceService.libCliCred - res.libped.liberou", res.libcli[0].liberou)
        this.hideLoading = true
        if (res.libcli[0].liberou === "S") {
            /** Ita - 02/10/2024 Atualiza o pedido no grid **/
            //Ita - 16/10/2024 - const index = this.pedidos.findIndex(obj => obj.num === pedido);
            //const index = this.pedidos.findIndex(obj => obj.num === pedido && obj.filial === filialpv);
            const index = this.pedidos.findIndex(obj => obj.num == pedido && obj.filial == filialpv);
            if (index !== -1) {
              
              //this.pedidos.splice(index, 1);  // Remover o pedido do grid(array pedidos)
              this.pedidos[index].statpv = 'OK' // Atualiza o status do pedido no grid(array pedidos)
            }
            /**Ita - 02/10/2024 Fim da instrução para atualizar o pedido do grid */
            this.getHistor(this.codUsu)//Ita - 08/10/2024
            this.content = "Cliente Liberado!"
            this.poModal.open()                        
        }else{
          this.content = "O cliente não foi liberado! Favor verificar se há limites finaceiros disponíveis ou se há alguma restrição de estoques."
          this.poModal.open()                        
        }
      }, 
      error: () => this.hideLoading = true
    })   
  }

  godeletePV(pedido: string, filialpv: string): void {
    if (this.proAppConfigService.insideProtheus()) {
      this.deletePV(pedido,filialpv);
    } else {
      alert('A Operação de exclusão do pedido só poderá ser realizada dentro do Protheus.');
    }
  }    

  deletePV(pedido: string, filialpv: string): void {
    this.hideLoading = false
    this.bkserviceService.deletePV(pedido,filialpv).subscribe({
      next: res =>{
        console.log("Itacolomy retornando de this.bkserviceService.deletePV(pedido)", res.delped.operacao)
        this.hideLoading = true
        
        /** Ita - 02/10/2024 Remove o pedido do grid */
        //Ita - 16/10/2024 - const index = this.pedidos.findIndex(obj => obj.num === pedido);
        //const index = this.pedidos.findIndex(obj => obj.num === pedido && obj.filial === filialpv);
        //const objPedido = {num: pedido, filial: filialpv}
        //const index =  this.pedidos.indexOf(objPedido);
        const index = this.pedidos.findIndex(obj => obj.num == pedido && obj.filial == filialpv);
        
        console.log("Itacolomy - Pesquisou pedido["+pedido+"] filial["+filialpv+"] this.pedidos.findIndex retornou indice: ["+index+"] this.pedidos.length:["+this.pedidos.length+"]")
        if (index !== -1) {
          
          // Remover a informação do array
          //this.pedidos.splice(index, 1);
          this.poPedidos.removeItem(index)
          this.pedidos = [...this.poPedidos.items];
          this.poPedidos.unselectRows()
      
          console.log("Itacolomy - achou o pedido: ["+pedido+"] filial: ["+filialpv+"] no array indice: ["+index+"] this.pedidos.length:["+this.pedidos.length+"]")
          this.content = "O cancelamento do pedido ["+pedido+"] da filial: ["+filialpv+"] foi concluído!"
          this.poModal.open()                        
        }else{
          console.log("Itacolomy - nao localizou o pedido: ["+pedido+"] filial: ["+filialpv+"]  no array indice: ["+index+"] this.pedidos.length:["+this.pedidos.length+"]")
        }
        /** Ita - 02/10/2024 Fim da instrução para remover o pedido do grid */
        

      }, 
      error: () => this.hideLoading = true
    })   
  }
  /*
  validAbas(){
    console.log("Estou na Validação do PO-TAB Aba Informações ",this.lLibAbas)
    return !this.lLibAbas
  }
    */

  getHistor(codusu: string){
    //console.log("callHistorLib - getHistor - invocando this.bkserviceService.geTmptHisLib() ")
    //this.historlib = this.bkserviceService.geTmptHisLib()
    //this.hideLoading = false
    
    console.log("callHistorLib - getHistor - invocando this.bkserviceService.callHistorLib() - codusu ",codusu)
    this.callHistorLib(codusu)
    
    
    //console.log("callHistorLib - getHistor - retornando de this.bkserviceService.geTmptHisLib() - this.historlib",this.historlib)
    //this.hideLoading = true

  }

  callHistorLib(codusu: string): void {
    this.hideLoading = false
    console.log("callHistorLib - invocando his.bkserviceService.getHistLib("+codusu+")",codusu)
    this.bkserviceService.getHistLib(codusu).subscribe({
      next: res =>{
        this.historlib = res.histlib
        console.log("callHistorLib - retornando de his.bkserviceService.getHistLib(codusu)",res.histlib)
        this.hideLoading = true
      }, 
      error: () => this.hideLoading = true
    }) 
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

  goPosicao(){
    //this.router.navigate(['posicao'])
    this.lShowPosicao = false;
    this.lShowHome = true; 
    
    console.log("goPosicao() exibindo Posicao do Cliente: this.lShowPosicao ",this.lShowPosicao)
    console.log("goPosicao() exibindo Posicao do Cliente: this.lShowHome ",this.lShowHome) 
    
 } 
 goBack(){
  this.lShowPosicao = true;
  this.lShowHome = false;  
  console.log("goBack() Saindo da Posicao do Cliente: this.lShowPosicao",this.lShowPosicao)  
  console.log("goBack() Saindo da Posicao do Cliente: this.lShowHome",this.lShowHome)  

 }
 
 getDadusu(){
  this.callUsuProtheus()
}

callUsuProtheus(): void{
  this.hideLoading = false
  this.bkserviceService.callUsuProtheus().subscribe({
    next: res=>{
      this.codUsu = res.dadosusuario[0].cod
      this.nomeUsu = res.dadosusuario[0].nome
      this.bkserviceService.wcodUsu = res.dadosusuario[0].cod
      this.bkserviceService.wnomeUsu = res.dadosusuario[0].nome
      console.log("callUsuProtheus - retornando de this.bkserviceService.callUsuProtheus()...",)
      console.log("callUsuProtheus - res.dadosusuario.cod",res.dadosusuario[0].cod)
      console.log("callUsuProtheus - res.dadosusuario.nome",res.dadosusuario[0].nome)
      console.log("callUsuProtheus - this.bkserviceService.wcodUsu",this.bkserviceService.wcodUsu)
      console.log("callUsuProtheus - this.bkserviceService.wnomeUsu",this.bkserviceService.wnomeUsu)
      console.log("Itacolomy executando HomeComponent: ngOnInit() invocando this.getHistor - this.bkserviceService.wcodUsu",this.bkserviceService.wcodUsu)
      this.getHistor(this.codUsu)
      this.hideLoading = true      
    }, 
    error: () => this.hideLoading = true
  }) 
}
  getDadosCli() {
    this.codCli = '009817';
    this.lojCli = '001';
    this.nomeCli = 'NASCIMENTO E LUIZ COMÉRCIO VAREJISTA E MERCADORIA';
    this.cnpjCli = '312.660.030.0001/78';
    this.inscCli = '16.332.214-2';
    this.codblq = '06';
    this.descblq = 'BLOQUEIO ATRASO/LIMITE DE CRÉDITO';
    this.tel = '(83) 99186-3874';
    this.codcnd = 'V13';
    this.desccnd = '28 DIAS - VEND';
    //this.tel2 = '99186-3874';
    this.email = 'II.luiz22@hotmail.com';
    //this.fax = '';
    //this.vaz = '';
    //this.fax2 = '';
    this.codseg = '036';
    this.descseg = 'MERCADINHO(VAREJISTA)';
    this.cel = '99186-3874';
    this.vendpir = '670';
    this.descvend = 'FRANCISCO - PRACA';
    //this.cel2 = '99186-3874';
    this.qtdtit = 1;
    this.titaberto = 547.88;
    this.venc15 = 0;
    this.venc16 = 547.88;
    this.limcred = 1500.59;
    this.pedfat = 0;
    this.saldolim = 952.71;    
  }


} //Fim da class BrowseComponent
