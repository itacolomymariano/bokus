import { Component, OnInit } from '@angular/core';
import { ProAppConfigService } from '@totvs/protheus-lib-core';
import { PoMenuItem } from '@po-ui/ng-components';
import { BkserviceService } from './bkservice.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrl: './app.component.css'
})
export default class AppComponent implements OnInit{

  hideLoading: boolean = true;
  constructor(
    private proAppConfigService: ProAppConfigService,
    private bkserviceService: BkserviceService
  ) {
    this.proAppConfigService.loadAppConfig();
  }

  readonly menus: Array<PoMenuItem> = [
    {
      icon: 'po-icon po-icon-sale',
      label: 'Home',
      shortLabel: "Home",
      link: '/home'
    },
    {
      icon: "po-icon po-icon-exit",
      label: "Sair",
      shortLabel: "Sair",
      action: this.closeApp.bind(this)
    }];

  ngOnInit(): void {
      console.log("Itacolomy AppComponent: ngOnInit() - Iniciando App bkanacred... ")
      
  }

  closeApp(): void {
    if (this.proAppConfigService.insideProtheus()) {
      this.proAppConfigService.callAppClose();
    } else {
      alert('O App não está sendo executado dentro do Protheus.');
    }
  }

} //Fim da class AppComponet
