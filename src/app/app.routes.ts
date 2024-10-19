import { NgModule } from '@angular/core';
//import { RouterModule, Routes } from '@angular/router';
import { Routes } from '@angular/router';
import { PosicaoComponent } from './posicao/posicao.component';
import { HomeComponent } from './home/home.component';
import { HistlibComponent } from './histlib/histlib.component';
import { BrowseComponent } from './browse/browse.component';

/*
import { SolicitacoesComponent } from './solicitacoes/solicitacoes.component';
import { BrowseComponent } from './browse/browse.component';
import { InformaFornecedorComponent } from './informa-fornecedor/informa-fornecedor.component';
import { AlteraSolicitacaoComponent } from './altera-solicitacao/altera-solicitacao.component';
import { CotacoesComponent } from './cotacoes/cotacoes.component';
*/
/*
export const routes: Routes = [
    { path: '', redirectTo: 'solicitacoes', pathMatch: 'full' },
    //{ path: 'home', component: HomeComponent },
    { path: 'solicitacoes', component: BrowseComponent },
    { path: 'solicita', component: SolicitacoesComponent },
    { path: 'informa', component: InformaFornecedorComponent },
    { path: 'altera', component: AlteraSolicitacaoComponent },
    { path: 'cotacoes', component: CotacoesComponent }
];
*/
export const routes: Routes = [
    { path: '', redirectTo: 'home', pathMatch: 'full' },
    { path: 'home', component: BrowseComponent },
    { path: 'posicao', component: PosicaoComponent },
    { path: 'histlib', component: HistlibComponent}
  ];
