#include "TopConn.ch"
/////////////////////
/// Ita - 19/09/2024
///       Função appprt 
///       Invoca arquivos do tipo *.app
///       para execução via menu Protheus.
//////////////////////////////////////////
User Function appprt()
    //FWCallApp("bkanacred")
	FWCallApp("bokus")
Return

/////////////////////////////////////////////////////////////////////
///                     Ita - 23/09/2024                        /////
///   B I B L I O T E C A   D E   F U N Ç Õ E S   P A R A   O   /////
//////   A P P - BKANACRED(Análise de Crédito Bokus)   //////////////
/////////////////////////////////////////////////////////////////////

/////////////////////
/// Ita - 23/09/2024
///       Função fGetSeg
///       Obtém descrição do segmento de negócio do cliente
////////////////////////////////////////////////////////////
User Function fGetSeg(cCodSeg)
    Local _Enter := chr(13) + Chr(10)

    cQry := " SELECT SX5.X5_DESCRI " + _Enter
    cQry += "   FROM "+RetSQLName("SX5")+" SX5 " + _Enter
    cQry += "  WHERE SX5.X5_FILIAL = '"+FWxFilial("SX5")+"'" + _Enter
    cQry += "    AND SX5.X5_TABELA = 'T3'" + _Enter
    cQry += "    AND SX5.X5_CHAVE = '"+cCodSeg+"'" + _Enter
    cQry += "    AND SX5.D_E_L_E_T_ <> '*'" + _Enter

    MemoWrite("fGetSeg.SQL",cQry)
    MemoWrite("c:\temp\fGetSeg.SQL",cQry)

    TCQuery cQry NEW ALIAS "TSX5"

    DBSelectArea("TSX5")
    _cDescSeg := Alltrim( TSX5->X5_DESCRI )
    DBCloseArea()

Return(_cDescSeg)

//////////////////////////
/// Ita - 24/09/2024
///       Função fGetTotPV
///       Obtém para o app bkanacred. o Valor do Sald o do Pedido de Vendas
///       que encontra-se bloqueado ou ainda não foifaturado.
////////////////////////////////////////////////////////////////////////////
User Function fGetTotPV(xPedSC5,xFilSC5)

    Local _nSldPV := 0
    Local _Enter := chr(13) + Chr(10)
    Local cQuery := ""

    cQuery += "   SELECT SUM(TSC6.C6_VALOR) C6_VALOR   " + _Enter
    cQuery += "     FROM " + RetSQLName("SC6")+" TSC6, " + _Enter
    cQuery += "          " + RetSQLName("SC9")+" TSC9 " + _Enter
    cQuery += "    WHERE TSC6.C6_FILIAL = '"+FWxFilial('SC6')+"'" + _Enter
    cQuery += "      AND TSC9.C9_FILIAL = '"+FWxFilial('SC9')+"'" + _Enter
    cQuery += "      AND TSC6.C6_NUM = TSC9.C9_PEDIDO " + _Enter
    cQuery += "      AND TSC6.C6_ITEM = TSC9.C9_ITEM " + _Enter
    cQuery += "      AND TSC6.C6_PRODUTO = TSC9.C9_PRODUTO " + _Enter
    cQuery += "      AND ( TSC9.C9_BLCRED <> '10' AND TSC9.C9_BLEST <> '10' ) " + _Enter
	cQuery += "      AND TSC6.C6_QTDENT < TSC6.C6_QTDVEN " + _Enter //PEDIDO AINDA COM SALDO PARA ENTREGAR
    cQuery += "      AND TSC6.C6_NUM = '"+xPedSC5+"' " + _Enter
    cQuery += "      AND TSC6.D_E_L_E_T_ <> '*'" + _Enter
    cQuery += "      AND TSC9.D_E_L_E_T_ <> '*'" + _Enter

    MemoWrite("\po_log\fGetTotPV.SQL",cQuery)
    MemoWrite("c:\temp\fGetTotPV.SQL",cQuery)

    TCQuery cQuery NEW ALIAS "TVLPV"
    TCSetField("TVLPV","C6_VALOR","N",TamSX3("C6_VALOR")[1],TamSX3("C6_VALOR")[2]) 
    
    DBSelectArea("TVLPV")
        _nSldPV := TVLPV->C6_VALOR
    DBCloseArea()

Return(_nSldPV)

User Function fCopyLog
    If MsgYesNo("Deseja Fazer copia dos arquivos da pasta \system para c:\temp ?","")
        
        //If !ExistDir("\po_log")
        //    Alert("A pasta \po_log NAO EXISTE!")
        //    Return
        //Else
        //    MsgInfo("A pasta \po_log EXISTE!","")
        //EndIf
        

        _lOkSQLCop := __copyfile("\po_log\getPedidos.SQL","c:\temp\getPedidos.SQL",,,.F.)
        If _lOkSQLCop
            MsgInfo("Copia do arquivo getPedidos.SQL realizada com Sucesso!","")
        Else
            Alert("Nao conseguiu copiar a query getPedidos.SQL para c:\temp\getPedidos.SQL")
        EndIf

        
        _lOkSQLCop := __copyfile("\po_log\getDatCli.SQL","c:\temp\getDatCli.SQL",,,.F.)
        If _lOkSQLCop
            MsgInfo("Copia do arquivo getDatCli.SQL realizada com Sucesso!","")
        Else
            Alert("Nao conseguiu copiar a query getDatCli.SQL para c:\temp\getDatCli.SQL")
        EndIf        


        _lOkLogCop := __copyfile("\po_log\getPedidos_qtd_pedidos.log","c:\temp\getPedidos_qtd_pedidos.log",,,.F.)
        If _lOkLogCop
            MsgInfo("Copia do Log getPedidos_qtd_pedidos.log realizada com Sucesso!","")
        Else
            Alert("Nao conseguiu copiar os logs getPedidos_qtd_pedidos.log")
        EndIf 

        
        _lOkLogCop := __copyfile("\po_log\getPedidos.log","c:\temp\getPedidos.log",,,.F.)
        If _lOkLogCop
            MsgInfo("Copia do Log getPedidos.log realizada com Sucesso!","")
        Else
            Alert("Nao conseguiu copiar os logs getPedidos.log")
        EndIf 
		
        
        _lOkLogCop := __copyfile("\po_log\getDatCli.log","c:\temp\getDatCli.log",,,.F.)
        If _lOkLogCop
            MsgInfo("Copia do Log getDatCli.log realizada com Sucesso!","")
        Else
            Alert("Nao conseguiu copiar os logs getDatCli.log")
        EndIf 

		_lOkLogCop := __copyfile("\po_log\getHistLib.SQL","c:\temp\getHistLib.SQL")
        If _lOkLogCop
            MsgInfo("Copia do Log getHistLib.SQL realizada com Sucesso!","")
        Else
            Alert("Nao conseguiu copiar os logs getHistLib.SQL")
        EndIf 
		/*
		If MsgYesNo("Deseja copiar todos os arquivos para pasta c:\temp\po_log\ ?","")
			CpyS2T( "\po_log\*.*", "c:\temp\po_log\", .F., .F. )
		EndIf
		*/
		
		_lOkLogCop := __copyfile("\po_log\getPedidos_Itens.SQL","c:\temp\getPedidos_Itens.SQL")
        If _lOkLogCop
            MsgInfo("Copia do Log getPedidos_Itens.SQL realizada com Sucesso!","")
        Else
            Alert("Nao conseguiu copiar os logs getPedidos_Itens.SQL")
        EndIf

		
		_lOkLogCop := __copyfile("\po_log\getPedidos_Pedidos.SQL","c:\temp\getPedidos_Pedidos.SQL")
        If _lOkLogCop
            MsgInfo("Copia do Log getPedidos_Pedidos.SQL realizada com Sucesso!","")
        Else
            Alert("Nao conseguiu copiar os logs getPedidos_Pedidos.SQL")
        EndIf		 		

    EndIf
Return

/////////////////////
/// Ita - 23/09/2024
///       Função fQTitAbt
///       Obtém a quantidade de títulos com saldo
///       em aberto do cliente.
//////////////////////////////////////////////////
User Function fQTitAbt(xCodCli,xLojCli,xCall)

    Local _Enter := chr(13) + Chr(10)
    Local _lQtdAbt := If(xCall==1,.T.,.F.)

    If _lQtdAbt
        cQrySE1 := " SELECT COUNT(*) QTITABT " + _Enter
    Else
        cQrySE1 := " SELECT SUM(SE1.E1_SALDO) SLDABT " + _Enter
    EndIf
    cQrySE1 += "   FROM "+RetSQLName("SE1")+" SE1 " + _Enter
    cQrySE1 += "  WHERE SE1.E1_FILIAL = '"+FWxFilial("SE1")+"'" + _Enter
    cQrySE1 += "    AND SE1.E1_CLIENTE = '"+xCodCli+"'" + _Enter
    cQrySE1 += "    AND SE1.E1_LOJA = '"+xLojCli+"'"  + _Enter
    cQrySE1 += "    AND SE1.E1_SALDO > 0 " + _Enter
    cQrySE1 += "    AND SE1.E1_TIPO NOT IN ('NCC','NDC') " + _Enter
    cQrySE1 += "    AND SE1.D_E_L_E_T_ <> '*'" + _Enter

    If _lQtdAbt
        MemoWrite("\po_log\fQTitAbt.SQL",cQrySE1)
        MemoWrite("c:\temp\fQTitAbt.SQL",cQrySE1)
    Else
        MemoWrite("\po_log\fSldTAbt.SQL",cQrySE1)
        MemoWrite("c:\temp\fSldTAbt.SQL",cQrySE1)    
    EndIf

    TCQuery cQrySE1 NEW ALIAS "TSE1"

    TCSetField("TSE1","QTITABT","N",06,00) 
    TCSetField("TSE1","SLDABT","N",TamSX3("E1_SALDO")[1],TamSX3("E1_SALDO")[2]) 

    DBSelectArea("TSE1")
    _nQtTitAbt := If(_lQtdAbt,TSE1->QTITABT,TSE1->SLDABT)
    DBCloseArea()

Return(_nQtTitAbt)

////////////////////
/// Ita - 23/09/2024
///       Função fVencAbt
///       Obtém o saldo dos valores de títulos
///       em aberto do cliente com até 15 dias vencidos
///       ou com maior ou igual a 16 dias vencidos.
////////////////////////////////////////////////////////
User Function fVencAbt(xCodCli,xLojCli,xCall)

    Local _Enter := chr(13) + Chr(10)
    Local _lV15 := If(xCall==1,.T.,.F.)

    cQrySE1 := " SELECT SUM(SE1.E1_SALDO) SLDVENC " + _Enter
    cQrySE1 += "   FROM "+RetSQLName("SE1")+" SE1 " + _Enter
    cQrySE1 += "  WHERE SE1.E1_FILIAL = '"+FWxFilial("SE1")+"'" + _Enter
    cQrySE1 += "    AND SE1.E1_CLIENTE = '"+xCodCli+"'" + _Enter
    cQrySE1 += "    AND SE1.E1_LOJA = '"+xLojCli+"'"  + _Enter
    cQrySE1 += "    AND SE1.E1_SALDO > 0 " + _Enter
    cQrySE1 += "    AND ( "+DTOS(DATE())+" > SE1.E1_VENCREA )" + _Enter
    If _lV15
        cQrySE1 += "    AND ("+DTOS(DATE())+" - SE1.E1_VENCREA <= 15)" + _Enter
    Else
        cQrySE1 += "    AND ("+DTOS(DATE())+" - SE1.E1_VENCREA >= 16)" + _Enter
    EndIf
    cQrySE1 += "    AND SE1.E1_TIPO NOT IN ('NCC','NDC') " + _Enter
    cQrySE1 += "    AND SE1.D_E_L_E_T_ <> '*'" + _Enter

    If _lV15
        MemoWrite("\po_log\fV15Dias.SQL",cQrySE1)
        MemoWrite("c:\temp\fV15Dias.SQL",cQrySE1)
    Else
        MemoWrite("\po_log\fVM16Dias.SQL",cQrySE1)
        MemoWrite("c:\temp\fVM16Dias.SQL",cQrySE1)    
    EndIf

    TCQuery cQrySE1 NEW ALIAS "VSE1"

    TCSetField("VSE1","SLDVENC","N",TamSX3("E1_SALDO")[1],TamSX3("E1_SALDO")[2]) 

    DBSelectArea("VSE1")
    _nSldVenc := VSE1->SLDVENC
    DBCloseArea()

Return(_nSldVenc)

/////////////////////
/// Ita - 24/09/2024
///       Função fPedAFat
///       Obtém saldo dos valores de pedidos 
///       a faturar.
/////////////////////////////////////////////
User Function fPedAFat(xCodCli,xLojCli)

    Local _Enter := chr(13) + Chr(10)

	cQuery := " SELECT SUM( SC9.C9_QTDLIB * SC6.C6_PRCVEN ) VALAFAT " + _Enter
	cQuery += "  FROM " + RetSqlName("SC5") + " SC5, " + RetSQLName("SC6")+" SC6, " + _Enter
	cQuery += "       " + RetSQLName("SC9") + " SC9, " + RetSQLName("SA1")+" SA1 " + _Enter
	cQuery += " WHERE SC5.C5_FILIAL = '"+FWxFilial('SC5')+"' " + _Enter
	cQuery += "   AND SC6.C6_FILIAL = '"+FWxFilial('SC6')+"' " + _Enter
	cQuery += "   AND SC9.C9_FILIAL = '"+FWxFilial('SC9')+"' " + _Enter
	cQuery += "   AND SA1.A1_FILIAL = '"+FWxFilial('SA1')+"' " + _Enter

	cQuery += "   AND SC5.C5_CLIENTE = '"+xCodCli+"' " + _Enter
	cQuery += "   AND SC5.C5_LOJACLI = '"+xLojCli+"' " + _Enter

	cQuery += "   AND SC5.C5_NUM = SC6.C6_NUM " + _Enter
	cQuery += "   AND SC5.C5_CLIENTE = SA1.A1_COD " + _Enter
	cQuery += "   AND SC5.C5_LOJACLI = SA1.A1_LOJA " + _Enter
	cQuery += "   AND SC6.C6_NUM = SC9.C9_PEDIDO " + _Enter
	cQuery += "   AND SC6.C6_NUM = SC9.C9_PEDIDO " + _Enter
	cQuery += "   AND SC6.C6_ITEM = SC9.C9_ITEM " + _Enter
	cQuery += "   AND SC6.C6_PRODUTO = SC9.C9_PRODUTO " + _Enter
	cQuery += "   AND ( SC9.C9_BLCRED = '"+SPACE(TamSX3("C9_BLCRED")[1])+"' AND SC9.C9_BLEST = '"+SPACE(TamSX3("C9_BLEST")[1])+"' ) " + _Enter //Pedido Liberado
	cQuery += "   AND SC6.C6_QTDENT < SC6.C6_QTDVEN " + _Enter //PEDIDO AINDA COM SALDO PARA ENTREGAR
	cQuery += "   AND SA1.A1_MSBLQL = '2' " + _Enter
	cQuery += "   AND SC5.D_E_L_E_T_ <> '*' " + _Enter
	cQuery += "   AND SC6.D_E_L_E_T_ <> '*' " + _Enter
	cQuery += "   AND SC9.D_E_L_E_T_ <> '*' " + _Enter
	cQuery += "   AND SA1.D_E_L_E_T_ <> '*' " + _Enter

	MemoWrite("\po_log\fPedAFat.SQL",cQuery) //Ita - 03/09/2024
	MemoWrite("C:\TEMP\fPedAFat.SQL",cQuery)

    TCQuery cQuery NEW ALIAS "PAFAT"

    TCSetField("PAFAT","VALAFAT","N",TamSX3("C6_VALOR")[1],TamSX3("C6_VALOR")[2]) 

    DBSelectArea("PAFAT")
    _nVlAFat := PAFAT->VALAFAT
    DBCloseArea()

Return(_nVlAFat)

/////////////////////
/// Ita - 24/09/2024
///       Função fPedAFat
///       Obtém saldo dos valores de pedidos 
///       a faturar.
/////////////////////////////////////////////
User Function fSaldLC(xCodCli,xLojCli)

    Local _Enter := chr(13) + Chr(10)

    cQry := " SELECT ( SA1.A1_LC - (SA1.A1_SALDUP + SA1.A1_SALPEDL)) SLDDISP " + _Enter
    cQry += "   FROM "+RetSQLName("SA1")+" SA1 " + _Enter
    cQry += "  WHERE SA1.A1_FILIAL = '"+FWxFilial("SA1")+"'" + _Enter
    cQry += "    AND SA1.A1_COD = '"+xCodCli+"'" + _Enter
    cQry += "    AND SA1.A1_LOJA = '"+xLojCli+"'" + _Enter
    cQry += "    AND SA1.D_E_L_E_T_ <> '*'" + _Enter

    MemoWrite("\po_log\fSaldLC.SQL",cQry)
    MemoWrite("c:\temp\fSaldLC.SQL",cQry)

    TCQuery cQry NEW ALIAS "XSSA1"

    DBSelectArea("XSSA1")
    _nSaldLC := XSSA1->SLDDISP
    DBCloseArea()

Return(_nSaldLC)

User Function getC5Rec(pedido)
    
    Local _Enter := chr(13) + Chr(10)
    Local nRegSC5 := 0
    
    cQryC5 := " SELECT SC5.R_E_C_N_O_ RECSC5 " + _Enter
    cQryC5 += "   FROM "+RetSQLName("SC5")+" SC5 " + _Enter
    cQryC5 += "  WHERE SC5.C5_NUM = '"+pedido+"' " + _Enter
    cQryC5 += "    AND SC5.D_E_L_E_T_ <> '*'" + _Enter

    MemoWrite("getRecSC5,SQL",cQryC5)
    MemoWrite("c:\temp\getRecSC5,SQL",cQryC5)

    TCQuery cQryC5 NEW ALIAS "REXSC5"

    TCSetField("REXSC5","RECSC5","N",10,00) 

    DBSelectArea("REXSC5")
        nRegSC5 := REXSC5->RECSC5
    DBCloseArea()

Return(nRegSC5)
User Function getC9Rec(pedido)

    Local _Enter := chr(13) + Chr(10)
    Local nRegSC9 := 0

    cQryC9 := " SELECT SC9.R_E_C_N_O_ RECSC9 " + _Enter
    cQryC9 += "   FROM "+RetSQLName("SC9")+" SC9 " + _Enter
    cQryC9 += "  WHERE SC9.C9_PEDIDO = '"+pedido+"' " + _Enter
    cQryC9 += "    AND ( SC9.C9_BLCRED <> '  ' AND SC9.C9_BLEST <> '10' ) " + _Enter
    cQryC9 += "    AND SC9.D_E_L_E_T_ <> '*'" + _Enter

    MemoWrite("getRecC9,SQL",cQryC9)
    MemoWrite("c:\temp\getRecC9,SQL",cQryC9)

    TCQuery cQryC5 NEW ALIAS "REXSC9"

    TCSetField("REXSC9","RECSC9","N",10,00) 

    DBSelectArea("REXSC9")
        nRegSC9 := REXSC9->RECSC9
    DBCloseArea()

Return(nRegSC9)
/*
User Function M450ClAut(lAutomato,pedido,cliente,statpv)
     //Ma450Proces("SC9",.T.,.F.,@lEnd,FWModeAccess("SA1",3)=="C")
    ////////////////////////////////////////////////////////////////////////
    /// Ita - Liberaçao Automatica do Crédito do Cliente do Pedido de Vendas
    ///       Parâmetros
    ///       Grupo: LIBAUT
    mv_par01 := pedido						//01 - Pedido de ?
    mv_par02 :=	pedido						//02 - Pedido ate ?
    mv_par03 := cliente 					//03 - Cliente de ?
    mv_par04 :=	cliente						//04 - Cliente ate ?
    mv_par05 := CTOD('01/01/1999')			//05 - Data de Entrega de ?
    mv_par06 :=	CTOD('31/12/2049')			//06 - Data de Entrega ate ?
    lEnd := .F.
    lAutomato := .T. 	//Informa a execução em Job da A450LibAut()
    _liberou := f450Proces("SC9",.T.,.F.,@lEnd,FWModeAccess("SA1",3)=="C",.F.,.F.,pedido,cliente)
	If _liberou
		fSavHisLib(pedido,statpv) //Ita - 01/10/2024 - Salva o Histórico da Liberação
	EndIf
Return
*/
//Static Function f450Proces(cAlias,lAvCred,lAvEst,lEnd,lEmpresa ,lAvWMS, lLogMsg,pedido,cliente)
User Function f450Proces(cAlias,lAvCred,lAvEst,lEnd,lEmpresa ,lAvWMS, lLogMsg,pedido,cliente)

Local aArea     	:= GetArea()
Local aAreaSM0  	:= SM0->(GetArea())
Local aRegSC6   	:= {}
Local bWhile    	:= {|| !Eof()}
Local lCredito  	:= .F.
Local lEstoque  	:= .F.
Local lMvAvalEst	:= SuperGetMV("MV_AVALEST")==2
Local lBlqEst   	:= SuperGetMV("MV_AVALEST")==3 .And. !lAvEst
Local lMta450T2 	:= ExistBlock("MTA450T2")
Local lMt450End 	:= ExistBlock("MT450END")
Local lMta450T  	:= ExistBlock("MTA450T")
Local lMa450Ped 	:= ExistBlock("MA450PED")
Local lMTValAvC 	:= ExistBlock("MTVALAVC")
Local lMT450Ite 	:= ExistBlock("MT450ITE")                             
Local lMT450TpLi	:= ExistBlock("MT450TPLI")
Local lMT450Qry		:= ExistBlock("MT450QRY")
Local lFatCredTools	:= FindFunction("FatCredTools")
Local nValAV		:= 0
Local lLibPedCr 	:= .T.
Local cBlqCred  	:= ""
Local cQuery    	:= ""
Local cIndSC9   	:= ""
Local cAliasSC9 	:= "MA450PROC"
Local cMensagem 	:= ""
Local cEmpresa  	:= cEmpAnt
Local cSavFil   	:= cFilAnt
Local cTipLib   	:= ""
Local cQuebra   	:= ""
Local nValItPed 	:= 0		
Local nMvTipCrd 	:= SuperGetMV("MV_TIPACRD", .F., 1)
Local nVlrTitAbe	:= 0
Local nVlrTitAtr	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para e-Commerce      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lECommerce 	:= SuperGetMV("MV_LJECOMM",,.F.)
Local cOrcamto   	:= ""     //Obtem o Orcamento original para posicionar na tabela MF5

lEmpresa := .F.
lAvWMS   := .F.
lLogMsg  := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o numero de registros a processar                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ProcRegua(SC9->(LastRec()))
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as filiais a serem liberadas                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lEmpresa
	cEmpresa := cEmpAnt
	bWhile   := {|| !Eof() .And. SM0->M0_CODIGO == cEmpresa }
Else
	cEmpresa := cEmpAnt+cFilAnt
	//Ita - 02/10/2024 - bWhile   := {|| !Eof() .And. SM0->M0_CODIGO+FWGETCODFILIAL == cEmpresa }
	bWhile   := {|| !Eof() .And. SM0->M0_CODIGO+FWxFilial() == cEmpresa }
EndIf
dbSelectArea("SM0")
dbSetOrder(1)
MsSeek(cEmpresa)
While Eval(bWhile)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica a filial corrente                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cFilAnt := FWxFilial() //FWGETCODFILIAL
	If lEmpresa
		//cMensagem := "("+FWGETCODFILIAL+"/"+SM0->M0_FILIAL+") "+RetTitle("C6_NUM")
		cMensagem := "("+FWxFilial()+"/"+SM0->M0_FILIAL+") "+RetTitle("C6_NUM")
	Else
		cMensagem := RetTitle("C6_NUM")
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a Query de Pesquisa                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SC9")
	dbSetOrder(1)

	cQuery := "SELECT SC9.R_E_C_N_O_ RECNO, SC9.C9_FILIAL,SC9.C9_PEDIDO,SC9.C9_ITEM,SC9.C9_BLCRED,SC5.C5_TIPLIB,SC6.R_E_C_N_O_ SC6RECNO "
	cQuery += "FROM "+RetSqlName("SC9")+" SC9,"
	cQuery += RetSqlName("SC5")+" SC5,"
	cQuery += RetSqlName("SC6")+" SC6 "
	cQuery += "WHERE SC9.C9_FILIAL = '"+xFilial("SC9")+"' AND "
	cQuery += "SC9.C9_PEDIDO  >= '"+pedido+"' AND "
	cQuery += "SC9.C9_PEDIDO  <= '"+pedido+"' AND "
	cQuery += "SC9.C9_CLIENTE >= '"+cliente+"' AND "
	cQuery += "SC9.C9_CLIENTE <= '"+cliente+"' AND "
	cQuery += "SC9.C9_NFISCAL = '"+Space(Len(SC9->C9_NFISCAL))+"' AND "
	cQuery += "SC9.D_E_L_E_T_ <> '*' AND "
	cQuery += "SC5.C5_FILIAL  = '"+xFilial("SC5")+"' AND "
	cQuery += "SC5.C5_NUM     = SC9.C9_PEDIDO AND "
	cQuery += "SC5.D_E_L_E_T_ <> '*' AND "			
	cQuery += "SC6.C6_FILIAL  = '"+xFilial("SC6")+"' AND "
	cQuery += "SC6.C6_NUM     = SC9.C9_PEDIDO AND "
	cQuery += "SC6.C6_ITEM    = SC9.C9_ITEM AND "
	cQuery += "SC6.C6_PRODUTO = SC9.C9_PRODUTO AND "			
	//cQuery += "SC6.C6_ENTREG  >= '"+Dtos(MV_PAR05)+"' AND "
	//cQuery += "SC6.C6_ENTREG  <= '"+Dtos(MV_PAR06)+"' AND "
	cQuery += "SC6.D_E_L_E_T_ <> '*' "

	If ( lAvCred .And. !lAvEst )
		cQuery += "AND (SC9.C9_BLCRED IN ('01','04') ) "
	EndIf
	//If ( lAvEst .And. !lAvCred )
	//	cQuery += "AND ( SC9.C9_BLEST = '02' OR SC9.C9_BLWMS='03' ) AND SC9.C9_BLCRED='  ' "
	//EndIf
	//If ( lAvEst .And. lAvCred )
	//	cQuery += "AND (SC9.C9_BLEST = '02' OR SC9.C9_BLCRED IN('01','04') OR SC9.C9_BLWMS='03') "
	//EndIf
	//If ( lAvWMS .And. !lAvEst )
	//	cQuery += "AND (SC9.C9_BLWMS='03') "
	//EndIf    

	If lMT450Qry
		cQuery := ExecBlock("MT450QRY",.F.,.F.,{ cQuery })
	EndIf
	
	cQuery += "ORDER BY "+SqlOrder(SC9->(IndexKey()))
	cQuery := ChangeQuery(cQuery)

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasSC9, .T., .T.)

	dbSelectArea(cAliasSC9)
	While (!((cAliasSC9)->(Eof())) .And. xFilial("SC9") == (cAliasSC9)->C9_FILIAL )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o tipo de Liberacao                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cTipLib := (cAliasSC9)->C5_TIPLIB
		                             
		If lMT450Ite
			ExecBlock("MT450ITE",.F.,.F.,{cAliasSC9})
		Endif			

		If lMT450TpLi 
			cTipLib := ExecBlock("MT450TPLI",.F.,.F.,{cTipLib})
		Endif			
		
		If cTipLib == "1"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Controle da Query para TOP CONNECT execeto AS/400                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SC9")
			MsGoto((cAliasSC9)->RECNO)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona Registros                                                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SC6")
			dbSetOrder(1)
			MsSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO)
			If ( SC6->C6_ENTREG >= mv_par05 .And. SC6->C6_ENTREG <= mv_par06 )
				dbSelectArea("SF4")
				dbSetOrder(1)
				MsSeek(cFilial+SC6->C6_TES)
				dbSelectArea("SC5")
				dbSetOrder(1)
				If MsSeek(xFilial("SC5")+SC9->C9_PEDIDO)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Para e-Commerce ira gravar com bloqueio de credito para Boleto(FI) e sem   ³
					//³bloqueio para os demais. Sera liberado com a baixa do titulo.              ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If  lECommerce .And. !( Empty(SC5->C5_ORCRES) ) .And. ChkFile("MF5")
					    MF5->( DbSetOrder(1) ) //MF5_FILIAL+MF5_ECALIA+MF5_ECVCHV
					
					    cOrcamto := Posicione("SL1",1,xFilial("SL1")+SC5->C5_ORCRES,"L1_ORCRES")
					    
					    If  !( Empty(cOrcamto) ) .And. !( Empty(Posicione("MF5",1,xFilial("MF5")+"SL1"+xFilial("SL1")+cOrcamto,"MF5_ECPEDI")) )
						    If  (Alltrim(SL1->L1_FORMPG) == "FI")
								(cAliasSC9)->( dbSkip() )
								//IncProc(cMensagem+"..:"+(cAliasSC9)->C9_PEDIDO+"/"+(cAliasSC9)->C9_ITEM)
								Loop
						    EndIf
					    EndIf
					EndIf

					If SC5->C5_TIPO$"BD"
						dbSelectArea("SA2")
						dbSetOrder(1)
						MsSeek(xFilial("SA2")+SC9->C9_CLIENTE+SC9->C9_LOJA)
						If ( lAvCred )
							lCredito := .T.
						Else
							lCredito := Empty(SC9->C9_BLCRED)
						EndIf
					Else
						dbSelectArea("SA1")
						dbSetOrder(1)
						MsSeek(xFilial("SA1")+SC9->C9_CLIENTE+SC9->C9_LOJA)
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Realiza a Avaliacao de Credito                                          ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If ( lAvCred )
							If lMTValAvC
								nValAv	:=	ExecBLock("MTValAvC",.F.,.F.,{'MA450PROCES',SC9->C9_PRCVEN*SC9->C9_QTDLIB,Nil})
							Else
								nValAv	:=	SC9->C9_PRCVEN*SC9->C9_QTDLIB					  
							Endif			
							//Analise de credito via Intellector Tools
							If lFatCredTools .AND. nMvTipCrd == 2
								
								If nValItPed == 0
									//Consulta os titulos em aberto
									nVlrTitAbe := SldCliente(SC9->C9_CLIENTE + SC9->C9_LOJA, Nil, Nil, .F.)
									//Consulta os titulos em atraso				
									nVlrTitAtr := CrdXTitAtr(SC9->C9_CLIENTE + SC9->C9_LOJA, Nil, Nil, .F.)
								EndIf
								
								nValItPed += nValAv
								
								//LJMsgRun(STR0075,,{|| lCredito := FatCredTools(SC9->C9_CLIENTE, SC9->C9_LOJA, nValItPed, nVlrTitAbe, nVlrTitAtr)})//"Aguarde... Efetuando Analise de Crédito."
                                lCredito := FatCredTools(SC9->C9_CLIENTE, SC9->C9_LOJA, nValItPed, nVlrTitAbe, nVlrTitAtr)
								//lCredito := FatCredTools(SC9->C9_CLIENTE, SC9->C9_LOJA, nValItPed, nVlrTitAbe, nVlrTitAtr)
							Else
								lCredito := MaAvalCred(SC9->C9_CLIENTE,SC9->C9_LOJA,nValAv,SC5->C5_MOEDA,.T.,@cBlqCred)
							EndIf
						Else
							lCredito := Empty(SC9->C9_BLCRED)
						EndIf
					EndIf
					If ( lAvEst .And. lCredito )
						If ( SF4->F4_ESTOQUE == "S" .And. Empty(SC9->C9_RESERVA))
							If lBlqEst
								lEstoque := .F.
							Else
								lEstoque := A440VerSB2(SC9->C9_QTDLIB,lMvAvalEst)
							EndIf
						Else
							lEstoque := .T.
						Endif
					Else
						lEstoque := IF(Empty(SC9->C9_BLEST),.T.,.F.)
					EndIf
					If SC6->(Found())
						Do Case
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Avalia Credito e Estoque                                       ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						Case ( lAvCred .And. lAvEst .And. lCredito .And. lEstoque)
							a450Grava(1,.T.,.T.,,,lAvEst)
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Avalia Credito e Nao Estoque                                   ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						Case ( lAvCred .And. !lAvEst .And. lCredito )
							a450Grava(1,.T.,.F.,,,lAvEst)
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Avalia Credito e bloqueia por Limite excedido                  ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						Case ( lAvCred .And. !lCredito )
							Begin Transaction
								RecLock(cAlias,.F.)
								SC9->C9_BLCRED := cBlqCred
								MsUnLock()
							End Transaction
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Avalia Estoque e Libera Estoque                                ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						Case ( lAvEst .And. lEstoque .And. lCredito)
							a450Grava(1,.F.,lAvEst,,,lAvEst, lLogMsg)
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Avalia Estoque e Bloqueia Estoque                              ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						Case ( lAvEst .And. !lEstoque )
							Begin Transaction
								RecLock(cAlias,.F.)
								SC9->C9_BLEST := "02"
								MsUnLock()
							End Transaction
						EndCase
					EndIf
					If ( lMta450T )
						ExecBlock("MTA450T",.F.,.F.)
					EndIf
				EndIf
			EndIf
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona Registros                                                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aadd(aRegSC6,(cAliasSC9)->SC6RECNO)
			
			If ( lMta450T2 )
				ExecBlock("MTA450T2",.F.,.F.)
			EndIf

			If (cAliasSC9)->C9_BLCRED <> '  '
				lLibPedCr := .F.
			Endif	
		EndIf
		cQuebra := (cAliasSC9)->C9_PEDIDO
		dbSelectArea(cAliasSC9)
		dbSkip()
		//IncProc(cMensagem+"..:"+(cAliasSC9)->C9_PEDIDO+"/"+(cAliasSC9)->C9_ITEM)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Liberacao por Pedido de Venda                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cQuebra <> (cAliasSC9)->C9_PEDIDO .Or. (cAliasSC9)->(Eof())
			If Len(aRegSC6) > 0
				dbSelectArea("SC5")
				dbSetOrder(1)
				MsSeek(xFilial("SC5")+cQuebra)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Para e-Commerce ira gravar com bloqueio de credito para Boleto(FI) e sem   ³
				//³bloqueio para os demais. Sera liberado com a baixa do titulo.              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If  lECommerce .And. !( Empty(SC5->C5_ORCRES) ) .And. ChkFile("MF5")
				    MF5->( DbSetOrder(1) ) //MF5_FILIAL+MF5_ECALIA+MF5_ECVCHV
				
				    cOrcamto := Posicione("SL1",1,xFilial("SL1")+SC5->C5_ORCRES,"L1_ORCRES")
				    
				    If  !( Empty(cOrcamto) ) .And. !( Empty(Posicione("MF5",1,xFilial("MF5")+"SL1"+xFilial("SL1")+cOrcamto,"MF5_ECPEDI")) )
					    If  (Alltrim(SL1->L1_FORMPG) == "FI")
							aRegSC6 := {}
							Loop
					    EndIf
				    EndIf
				EndIf

				Begin Transaction
					MaAvalSC5("SC5",3,.F.,.F.,,,,,,cQuebra,aRegSC6,.T.,!lLibPedCr)					
					aRegSC6 := {}
				End Transaction
				lLibPedCr := .T.			
			EndIf
			If lMa450Ped
				Execblock("MA450PED",.F.,.F.,{cQuebra} )
			Endif
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Controle de cancelamento do usuario                                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lEnd
			Exit
		EndIf
		
		If ( lMt450End )
			ExecBlock("MT450END",.F.,.F.)
		EndIf
		
	EndDo
	dbSelectArea(cAliasSC9)
	dbCloseArea()

	// Integrado ao wms devera avaliar as regras para convocação do serviço
	// e disponibilizar os registros de atividades do WMS para convocação
	If IntWms()
		WmsAvalExe()
	EndIf

	dbSelectArea("SM0")
	dbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a integridade da rotina                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cFilAnt := cSavFil
dbSelectArea("SC9")
RestArea(aAreaSM0)
RestArea(aArea)
Return(.T.)

////// EXCLUSÃO DO PEDIDO DE VENDAS - 29/09/2024 /////////
/// Tenta estornar as liberações. caso haja faturamento, ela elimina o resíduo, 
/// se não há faturamento, a rotina tentará excluir o pedido do sistema.

User function DelPedido( cPedido, filialpv )
    //local cFilSC5 := FWxFilial("SC5")
    //local cFilSC6 := FWxFilial("SC6")
    local cFilSC5 := filialpv
    local cFilSC6 := filialpv
    local aCabec := {}
    local lFaturado := .F., lLiberado := .F.
    local lPodeExcluir := .T.
    local nCount
    local lDeletou := .F.
    local lEliRes := .F.

     if SC5->( dbSeek( cFilSC5 + cPedido ) )

          // avalia os itens, de modo a eliminar resíduos caso haja faturamento
          SC6->( dbGoTop() )
          SC6->( dbSeek( cFilSC6 + cPedido ) )
          While !SC6->(EOF()) .AND. SC6->C6_FILIAL == cFilSC6 .AND. SC6->C6_NUM == SC5->C5_NUM
               // tenta estornar as liberações do item
               MaAvalSC6("SC6",4,"SC5",Nil,Nil,Nil,Nil,Nil,Nil)
               
               lFaturado := (SC6->C6_QTDENT > 0)
               lLiberado := (SC6->C6_QTDEMP > 0)

               // se há liberação ou faturamento, o pedido não pode ser excluido!
               //Ita - 11/10/2024 - Solicitação - Bokus - if lLiberado .OR. lFaturado
                    lPodeExcluir := .F.
               //endif

               // se não pode excluir e não estiver liberado, tento eliminar o resíduo do item
               if !lPodeExcluir .AND. !lLiberado
                    MaResDoFat()
               endif

               SC6->( dbSkip() )
          EndDo

          // depois de processar cada item do pedido, verifico
          // a possibilidade de excluir o pedido
          // obs.: o procedimento de eliminação de resídios, dentro do loop
          // já se encarrega de encerrar o pedido por resíduo
          if lPodeExcluir
               aAdd( aCabec, {"C5_NUM"          , SC5->C5_NUM         , Nil} )
               aAdd( aCabec, {"C5_TIPO"         , SC5->C5_TIPO        , Nil} )
               aAdd( aCabec, {"C5_CLIENTE"      , SC5->C5_CLIENTE     , Nil} )
               aAdd( aCabec, {"C5_LOJACLI"      , SC5->C5_LOJACLI     , Nil} )
               aAdd( aCabec, {"C5_LOJAENT"      , SC5->C5_LOJAENT     , Nil} )
               aAdd( aCabec, {"C5_CONDPAG"      , SC5->C5_CONDPAG     , Nil} )
               
               lMsErroAuto := .F.
               MATA410(aCabec, {} , 5)
               if lMsErroAuto
                    //MostraErro()
                    aLogAuto := GetAutoGRLog()
                    _cTxtErro := ""
                    For nCount := 1 To Len(aLogAuto)
                        _cTxtErro += StrTran(StrTran(aLogAuto[nCount], "<", ""), "-", "") + " " + _Enter
                        ConOut(_cTxtErro)
                    Next nCount		
                    MemoWrite("\po_log\DelPedido.log",_cTxtErro)                    
                    MemoWrite("c:\temp\DelPedido.log",_cTxtErro)
               else
                    lDeletou := .T.
                    ConOut("Pedido "+cPedido+" excluído com sucesso!")
               endif
          else
               if !EMPTY(SC5->C5_NOTA) .OR. (SC5->C5_LIBEROK = 'E')
                    lEliRes := .T.
                    ConOut("Resíduos do pedido "+cPedido+" foram eliminados. O pedido foi encerrado!")
               endif
          endif

     endif
Return({lDeletou,lEliRes})

//Static Function fSavHisLib(pedido,statpv)
User Function fSavHisLib(pedido,statpv,filialpv)
    _cDscBlq := u_fGtDscBlq( Alltrim( statpv ) )
	
	DbSelectArea("ZZ1") //Histórico das Liberações
	RecLock("ZZ1",.T.)
		cUserID := RetCodUsr()
		cNomUser := UsrRetName(cUserID)
		//ZZ1->ZZ1_FILIAL := FWxFilial("ZZ1")			//Filial 
		ZZ1->ZZ1_FILIAL := filialpv					//Filial 
		ZZ1->ZZ1_CODUSU := cUserID					//Cod. do Usuario que efetuou a liberacao.
		ZZ1->ZZ1_NMEUSU := cNomUser					//Nome do usuario que efeuou a liberacao.
		ZZ1->ZZ1_PEDIDO := pedido					//Pedido que foi liberado
		ZZ1->ZZ1_DTLIB  := Date()					//Data em que o pedido foi liberado.
		ZZ1->ZZ1_HRLIB  := Time()					//Hora em que o pedido foi liberado.
		ZZ1->ZZ1_BLQLIB	:= Alltrim( statpv )		//Tipo de bloqueio liberado pelo usuario.
		ZZ1->ZZ1_DSCBLQ	:= _cDscBlq					//Descricao do bloqueio do pedido de vendas liberado pelo usuario.	
	ZZ1->(MsUnLock())
	
	ConOut("Itacolomy - fSavHisLib() - Salvei o Histórico da Liberação do Pedido: ["+pedido+"] Bloqueio: ["+_cDscBlq+"] Usuario: ["+cUserID+"] Nome: ["+cNomUser+"] filial: ["+filialpv+"]")
Return

User Function fGtDscBlq( statpv )

	aBloqueios := {}
    aAdd(aBloqueios, {'OK','AUTORIZADO'}) 
    aAdd(aBloqueios, {'01','Crédito por Valor'})
    aAdd(aBloqueios, {'02','risco de crédito'})
    aAdd(aBloqueios, {'03','limite de crédito'})
    aAdd(aBloqueios, {'04','atraso de título'})
    aAdd(aBloqueios, {'05','bloqueio diretoria'})
	aAdd(aBloqueios, {'09','Lib.Crédito Rejeitada'})
	aAdd(aBloqueios, {'XX','bloqueio outros'})

	nPosBlq := aScan(aBloqueios,{|x| x[1] == Alltrim( statpv ) })
	cDscBloq := aBloqueios[nPosBlq,2]

Return( cDscBloq )

/////////////////////
/// Ita - 04/10/2024
///       Função fUltBaixa
///       Obtém a última data de baixa do título.
/////////////////////////////////////////////////
User Function fUltBaixa(xPrefSE5,xNumSE5,xParSE5,xTipSE5,filialpv)
	
	Local _Enter := chr(13) + Chr(10)
	
	cQrySE5 := " SELECT TOP 1 SE5.E5_DATA " + _Enter
	cQrySE5 += "   FROM "+RetSQLName("SE5")+" SE5 " + _Enter
	//Ita - 15/10/2024 - cQrySE5 += "  WHERE SE5.E5_FILIAL = '"+FWxFilial("SE5")+"'" + _Enter
	cQrySE5 += "  WHERE SE5.E5_FILIAL = '"+filialpv+"'" + _Enter
	cQrySE5 += "    AND SE5.E5_PREFIXO = '"+xPrefSE5+"'" + _Enter
	cQrySE5 += "    AND SE5.E5_NUMERO = '"+xNumSE5+"'" + _Enter
	cQrySE5 += "    AND SE5.E5_PARCELA = '"+xParSE5+"'" + _Enter
	cQrySE5 += "    AND SE5.E5_TIPO = '"+xTipSE5+"'" + _Enter
	cQrySE5 += "    AND SE5.D_E_L_E_T_ <> '*'" + _Enter
	//cQrySE5 += "  ORDER SE5.E5_DATA DESC" + _Enter

	MemoWrite("\po_log\fUltBaixa.SQL",cQrySE5)
	MemoWrite("fUltBaixa.SQL",cQrySE5)

	TCQuery cQrySE5 NEW ALIAS "XSE5"

	TCSetField("XSE5","E5_DATA","D",08,00) 

	DbSelectArea("XSE5")
	_dUltDtBx := XSE5->E5_DATA
	dbCloseArea()

Return(_dUltDtBx)

/////////////////////
/// Ita - 08/10/2024
///       Função fChkSC9
///       Checa se o pedido de vendas passado por
///       parâmetro foi liberado totalmente por
///       crédito.
///////////////////////////////////////////////////
User Function fChkSC9(pedido,filialpv)
	
	Local _Enter := chr(13) + Chr(10)
	
	cQrySC9 := " SELECT COUNT(*) NQTDBLQ " + _Enter
	cQrySC9 += "   FROM "+RetSQLName("SC9")+" SC9 " + _Enter
	//cQrySC9 += "  WHERE SC9.C9_FILIAL = '"+FWxFilial("SC9")+"'" + _Enter
	cQrySC9 += "  WHERE SC9.C9_FILIAL = '"+filialpv+"'" + _Enter
	cQrySC9 += "    AND (SC9.C9_BLCRED <> '"+SPACE(TamSX3("C9_BLCRED")[1])+"' AND SC9.C9_BLCRED <> '10') " + _Enter
	cQrySC9 += "    AND SC9.C9_PEDIDO = '"+pedido+"'" + _Enter
	cQrySC9 += "    AND SC9.D_E_L_E_T_ <> '*'" + _Enter

	MemoWrite("\po_log\fChkSC9.SQL",cQrySC9)
	MemoWrite("fChkSC9.SQL",cQrySC9)

	TCQuery cQrySC9 NEW ALIAS "CSC9"
	TCSetField("CSC9","NQTDBLQ","N",10,00)
	DbSelectArea("CSC9")
	_lSC9Lib := If(CSC9->NQTDBLQ>0,.F.,.T.)
	dbCloseArea()

Return(_lSC9Lib)


/////////////////////
/// Ita - 08/10/2024
///       Função fUpdSC9
///       Faz liberação de crédito forçada do pedido de vendas passado por
///       parâmetro.
///////////////////////////////////////////////////
User Function fUpdSC9(pedido, filialpv)
	
	Local _Enter := chr(13) + Chr(10)
	
	cQrySC9 := " UPDATE "+RetSQLName("SC9")+" " + _Enter
	cQrySC9 += "    SET C9_BLCRED = '"+SPACE(TamSX3("C9_BLCRED")[1])+"'," + _Enter
	cQrySC9 += "        C9_XLBPNL = 'S'" + _Enter
	//cQrySC9 += "  WHERE C9_FILIAL = '"+FWxFilial("SC9")+"'" + _Enter
	cQrySC9 += "  WHERE C9_FILIAL = '"+filialpv+"'" + _Enter
	cQrySC9 += "    AND C9_PEDIDO = '"+pedido+"'" + _Enter
	cQrySC9 += "    AND D_E_L_E_T_ <> '*'" + _Enter

	MemoWrite("\po_log\fUpdSC9.SQL",cQrySC9)
	MemoWrite("fUpdSC9.SQL",cQrySC9)

	If TCSQLExec(cQrySC9) <> 0 
		_lSC9Upd := .F.
      	xTxtLgErro := "Ocorreu erro ao tentar liberar o pedido de venda: ["+pedido+"] filial: ["+filialpv+"] - TCSQLError() " + TCSQLError()
      	MemoWrite("\po_log\fUpdSC9.log",xTxtLgErro) 
      	MemoWrite("fUpdSC9.log",xTxtLgErro) 
	Else
		xTxtLgErro :=""
		_lSC9Upd := .T.
	EndIf

Return({_lSC9Upd,xTxtLgErro})
