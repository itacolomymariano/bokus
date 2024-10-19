//import { provideHttpClient, withInterceptorsFromDi,withFetch } from '@angular/common/http';
import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { FormsModule } from '@angular/forms';

//import { AppRoutingModule, routes } from './app-routing.module';
//import { routes } from './app-routing.module';
import AppComponent from './app.component';
import { routes } from './app.routes';
//import { AppComponent } from './app.component';
import { PoAvatarModule, PoModule } from '@po-ui/ng-components';
import { RouterModule } from '@angular/router';
import { HttpClientModule } from '@angular/common/http';
import { PoTemplatesModule } from '@po-ui/ng-templates';
import { ProtheusLibCoreModule } from '@totvs/protheus-lib-core';
import { HomeComponent } from './home/home.component';
import { BrowseComponent } from './browse/browse.component';
import { PosicaoComponent } from './posicao/posicao.component';
import { HistlibComponent } from './histlib/histlib.component';

@NgModule({
  declarations: [
    AppComponent,
    HomeComponent,
    BrowseComponent,
    PosicaoComponent,
    HistlibComponent
  ],
  imports: [
    BrowserModule,
    //AppRoutingModule,
    RouterModule.forRoot(routes),
    HttpClientModule,
    FormsModule,
    PoModule,
    PoTemplatesModule,
    ProtheusLibCoreModule,
    PoAvatarModule          
  ],
  providers: [
    //provideHttpClient(withInterceptorsFromDi()),
    //provideHttpClient(withFetch()), //É altamente recomendável habilitar fetch para aplicativos que usam Server-Side Rendering para melhor desempenho e compatibilidade.
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
