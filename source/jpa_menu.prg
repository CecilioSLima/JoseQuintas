/*
JPA_MENU - MENU DO SISTEMA
1999.10 Jos� Quintas
*/

#include "hbgtinfo.ch"
#include "inkey.ch"

FUNCTION MenuCria()

   MEMVAR nMenuLevel, oMenuOptions
   PRIVATE nMenuLevel, oMenuOptions

nMenuLevel   := 0
oMenuOptions := {}

MenuOption( "Movto" )
   MenuDrop()
   MenuOption( "Pedidos/Notas Fiscais" )
      MenuDrop()
      MenuOption( "Or�amentos/Pedidos",           "P0600PED" )
      MenuOption( "Nota Fiscal (Servi�os)",       "PNOTASERVICO" )
      MenuOption( "Consulta a Notas Fiscais",     "PNOTACADASTRO" )
      MenuOption( "Gera Pedido de Retirada",      "PNOTAPEDRETIRA" )
      MenuOption( "Rel.Romaneio de NFs",          "PNOTAROMANEIO" )
      MenuOption( "Manifesto Eletr�nico",         "PJPMDF" )
      MenuOption( "Visualizar Vendas",            "PNOTAVERVENDAS" )
      MenuOption( "Visualizar pr�ximas vendas",   "PNOTAPROXIMAS" )
      MenuUnDrop()
   MenuOption( "Boletos" )
      MenuDrop()
      MenuOption( "Boletos Ita� Notas (Txt)",      "PBOL0020" )
      MenuOption( "Boletos Ita� Financeiro (Txt)", "PBOL0030" )
      MenuOption( "Boletos Ita� Avulso (Txt)",     "PBOL0040" )
      MenuOption( "Rel. Txt Ita�",                 "PBOL0050" )
      MenuOption( "Boletos p/ NF Emitidas",        "PBOL0060" )
      MenuOption( "Boletos p/ Doc.C.Receber",      "PBOL0061" )
      MenuOption( "Boletos Avulsos",               "PBOL0062" )
      MenuOption( "Boleto em PDF",                 "PTESTEBOLETO" )
      MenuUnDrop()
   MenuOption( "Op��es NFE/CTE/MDFE" )
      MenuDrop()
      MenuOption( "Gera Dados para NFS-E / RPS",  "PNOTAGERARPS" )
      MenuOption( "Gera Dados para NFEletr�nica", "PNOTAGERANFE" )
      MenuOption( "Cancelar CTE",                 "PDFECTECANCEL" )
      MenuOption( "Visualiza PDF",                "PDFEGERAPDF" )
      MenuOption( "Inutilizar n�mero CTE",        "PDFECTEINUT" )
      MenuOption( "Inutilizar n�mero NFE",        "PDFENFEINUT" )
      MenuUnDrop()
   MenuOption( "Pre�os/Comiss�es" )
      MenuDrop()
      MenuOption( "Pre�os Diferenciados",             "PPRE0010" )
      MenuOption( "Listagem Pre�os Diferenciados",    "PPRECORELTABCOMB" )
      MenuOption( "Reajuste Pre�os Diferenciados",    "PPRE0020" )
      MenuOption( "Percentuais das tabelas",          "PAUXPPRECO" )
      MenuOption( "Altera��o dos Precos",             "PPRE0040" )
      MenuOption( "Lista de Pre�os",                  "PPRECORELTABGERAL" )
      MenuOption( "Consulta/Altera��o de Pre�os",     "PNOT0213" )
      MenuOption( "Consulta de Pre�os",               "PNOT0214" )
      MenuOption( "Lista de Pre�os Img",              "PPRECORELTABMULTI" )
      MenuOption( "Pre�os - Percentuais das Tabelas", "PPRECOVALPERC" )
      MenuOption( "Html Tabela de Pre�os",            "PPRECOHTMLTABPRE" )
      MenuOption( "Arredondamento dos Pre�os",        "PSETUPPARAMROUND" )
      MenuOption( "Comiss�o de Vendedores",           "PJPCOMISS" )
      MenuUnDrop()
   MenuOption( "Etiquetas/Envelopes/Recibo" )
      MenuDrop()
      MenuOption( "Etiquetas p/ Embalagens", "PNOTAETIQUETA" )
      MenuOption( "Recibo de Uso Geral",     "PGERALRECIBO" )
      MenuUnDrop()
   MenuUnDrop()

MenuOption( "Estoq" )
   MenuDrop()
   MenuOption( "Estoque - Entradas",              "PESTOLANCA2" )
   MenuOption( "Estoque - Saidas",                "PESTOLANCA1" )
   MenuOption( "Consulta entradas de fornecedor", "PESTOENTFOR" )
   MenuOption( "Cod.Barras Manuten��o",           "PBAR0010" )
   MenuOption( "Cod.Barras Consulta/Ocorr�ncia",  "PBAR0040" )
   MenuOption( "Digita��o da Contagem F�sica",    "PJPFISICAA" )
   MenuOption( "Ver Erros de contagem F�sica",    "PJPFISICAD" )
   MenuOption( "Valor do Estoque",                "PESTOVALEST" )
   MenuOption( "Valor armaz�m",                   "PESTOTOTARMAZEM" )
   MenuUnDrop()

MenuOption( "Financeiro" )
   MenuDrop()
   MenuOption( "Banc�rio" )
      MenuDrop()
      MenuOption( "Movimenta��o",                 "PBANCOLANCA" )
      MenuOption( "Resumos e Grupos",             "PBANCOCCUSTO" )
      MenuOption( "Saldos das Contas no V�deo",   "PBANCOSALDO" )
      MenuOption( "Saldo Consolidado das Contas", "PBANCOCONSOLIDA" )
      MenuOption( "Gera��o de Lancamentos",       "PBANCOGERA" )
      MenuOption( "Valores: Comparativo p/Mes",   "PBANCOCOMPARAMES" )
      MenuOption( "Gr�fico: Resumo por Mes",      "PBANCOGRAFICOMES" )
      MenuOption( "Gr�fico: Per�odo por Resumo",  "PBANCOGRAFRESUMO" )
      MenuUnDrop()
   MenuOption( "Financeiro - Rec/Pag" )
      MenuDrop()
      MenuOption( "Contas a Receber (WT)",    "PFINANEDRECEBER" )
      MenuOption( "Baixa Individual C.Rec",   "PFIN0035" )
      MenuOption( "Baixa C.Rec.por Portador", "PFINANBAIXAPORT" )
      MenuOption( "Contas a Pagar (WT)",      "PFINANEDPAGAR" )
      MenuOption( "Baixa Individual C.Pagar", "PFIN0045" )
      MenuUnDrop()
   MenuUnDrop()

MenuOption( "Cont�bil" )
   MenuDrop()
   MenuOption( "Digita��o de Lan�amentos",  "PCONTLANCINCLUI" )
   MenuOption( "Corre��o de Capas de Lote", "PCONTLANCLOTE" )
   MenuOption( "Corre��o de Lan�amentos",   "PCONTLANCALTERA" )
   MenuOption( "Total de Lan�amentos",      "PCONTTOTAIS" )
   MenuOption( "Consulta a Saldos",         "PCONTSALDO" )
   MenuOption( "Fechamento de Exerc�cio",   "PCONTFECHA" )
   MenuOption( "Utilit�rios" )
      MenuDrop()
      MenuOption( "Atualiza��o de Sint�ticas",     "PCONTSINTETICA" )
      MenuOption( "Rec�lculo Geral",               "PCONTRECALCULO" )
      MenuOption( "Renumera C�digo Reduzido",      "PCONTREDRENUM" )
      MenuOption( "C�digos Reduzidos Dispon�veis", "PCONTREDDISP" )
      MenuUnDrop()
   MenuOption( "Configura��o" )
      MenuDrop()
      MenuOption( "Par�metros Cont�beis",       "PCONTSETUP" )
      MenuOption( "Livros/P�ginas dos Di�rios", "PCONTNUMDIA" )
      MenuOption( "Relat�rios Emitidos",        "PCONTEMITIDOS" )
      MenuUnDrop()
   MenuUnDrop()

MenuOption( "Fiscal" )
   MenuDrop()
   MenuOption( "Entradas ICMS/IPI (WT)",        "PFISCENTRADAS" )
   MenuOption( "Sa�das   ICMS/IPI (WT)",        "PFISCSAIDAS" )
   MenuOption( "Carta de Corre��o de NF",       "PFISCCORRECAO" )
   MenuOption( "Total de Lan�tos LFiscal",      "PFISCTOTAIS" )
   MenuOption( "Tributa��o" )
      MenuDrop()
      MenuOption( "Decretos/Leis",              "PLEISDECRETO" )
      MenuOption( "UFs (Unidades Federativas)", "PLEISUF" )
      MenuOption( "Tributa��o de Cadastros",    "PLEISTRICAD" )
      MenuOption( "Tributa��o de Empresa",      "PLEISTRIEMP" )
      MenuOption( "Tributa��o de Produtos",     "PLEISTRIPRO" )
      MenuOption( "Tributa��o de UFs",          "PLEISTRIUF" )
      MenuOption( "Regras de Tributa��o",       "PLEISIMPOSTO" )
      MenuUnDrop()
   MenuUnDrop()

MenuOption( "Relat�rios" )
   MenuDrop()
   MenuOption( "Rel.Pedidos/NF/OS" )
      MenuDrop()
      MenuOption( "Pedidos/Or�amentos",              "LJPPEDI" )
      MenuOption( "Rentabilidade por Produto",       "PNOTARELRENTAB" )
      MenuOption( "Clientes para Vendedor *TES*",    "PNOTAFICCLIVEN" )
      MenuOption( "Notas Fiscais Emitidas",          "PNOTARELNOTAS" )
      MenuOption( "Planilha Compras/Vendas Gerente", "PNOTAPLANILHAG" )
      MenuOption( "Planilha Compras/Vendas",         "PNOTAPLANILHACV" )
      MenuOption( "Planilha Vendas",                 "PNOTAPLANILHAC" )
      MenuOption( "Notas em Excel",                  "PNOTAXLS" )
      MenuOption( "Vendas a Clientes",               "PNOTARELCLIVEND" )
      MenuOption( "RMA/Baixa PE",                    "PNOTARELPEDREL" )
      MenuOption( "Rel.Mapa de Vendas-Pedidos",      "PNOTARELMAPA" )
      MenuOption( "Rel.Compara Meses Compra/Venda",  "PNOTARELCOMPMES" )
      MenuOption( "Rel.Comparativo Mensal",          "PNOTARELCOMPCLI" )
      MenuOption( "Vendas Mensais por Cliente",      "PNOTARELVENDCLI" )
      MenuUnDrop()
   MenuOption( "Rel.Banc�rio" )
      MenuDrop()
      MenuOption( "Rel.Extrato de Conta(s)",        "PBANCORELEXTRATO" )
      MenuOption( "Rel.Saldos das Contas",          "PBANCORELSALDO" )
      MenuOption( "Rel.Movimento por Grupo/Resumo", "PBANCORELCCUSTO" )
      MenuUnDrop()
   MenuOption( "Rel.Estoque" )
      MenuDrop()
      MenuOption( "Rel.Ent/Sa�/Pos/Invent",         "LJPESTOQA" )
      MenuOption( "Rel.Entradas Forn/Item",         "LJPESTOQB" )
      MenuOption( "Rel.Sa�das Cliente/Item",        "LJPESTOQC" )
      MenuOption( "Rel.An�lise para Compra",        "PESTORELANALISE" )
      MenuOption( "Rel.Formul�rio Contagem Fisica", "PJPFISICAB" )
      MenuOption( "Rel.Contagem F�sica",            "LJPFISICA" )
      MenuOption( "Produtos em Excel",              "PESTOITEMXLS" )
      MenuUnDrop()
   MenuOption( "Rel.Financeiro" )
      MenuDrop()
      MenuOption( "Rel.Doc.Contas a Receber", "PFINANRELRECEBER" )
      MenuOption( "Rel.Maiores Clientes",     "PFINANRELMAICLI" )
      MenuOption( "Rel.Doc.Contas a Pagar",   "PFINANRELPAGAR" )
      MenuOption( "Rel.Maiores Fornecedores", "PFINANRELMAIFOR" )
      MenuOption( "Rel.Fluxo de Caixa",       "PFINANRELFLUXO" )
      MenuUnDrop()
   MenuOption( "Rel.Cont�bil" )
      MenuDrop()
      MenuOption( "Rel.Plano de Contas",                 "PCONTREL0360" )
      MenuOption( "Rel.Balancete de Verifica��o",        "PCONTREL0270" )
      MenuOption( "Rel.Balancete do per�odo",            "PCONTREL0520" )
      MenuOption( "Rel.Livro Di�rio",                    "PCONTREL0210" )
      MenuOption( "Rel.Livro Caixa",                     "PCONTREL0010" )
      MenuOption( "Rel.Raz�o/Caixa",                     "PCONTREL0380" )
      MenuOption( "Rel.Demonstra��o de Resultado",       "PCONTREL0310" )
      MenuOption( "Rel.Balan�o Patrimonial",             "PCONTREL0320" )
      MenuOption( "Rel.Termos de Abertura/Encerramento", "PCONTREL0390" )
      MenuOption( "-", "-" )
      MenuOption( "Rel.Confer�ncia",                     "PCONTREL0250" )
      MenuOption( "Rel.Contas Admin/C.Custo",            "PCONTREL0550" )
      MenuOption( "Rel.Despesas por Centro de Custo",    "PCONTREL0300" )
      MenuOption( "Rel.Retrospectiva de Contas",         "PCONTREL0330" )
      MenuOption( "Rel.Retrospectiva de Contas-C.Custo", "PCONTREL0530" )
      MenuOption( "Rel.Raz�o de Concilia��o",            "PCONTREL0385" )
      MenuOption( "-", "-" )
      MenuOption( "Rel.Cta.Admin x Cont�beis",           "PCONTREL0470" )
      MenuOption( "Rel.Hist�ricos Padr�o",               "PCONTREL0370" )
      MenuOption( "Rel.Lan�amentos Padr�o",              "PCONTREL0230" )
      MenuOption( "Rel.Par�metros do Sistema",           "PCONTREL0340" )
      MenuUnDrop()
   MenuOption( "Rel.Fiscais" )
      MenuDrop()
      MenuOption( "Rel.Confer�ncia LFiscal",                   "PFISCREL0060" )
      MenuOption( "Rel.DOPUF - ICMS",                          "PFISCREL0070" )
      MenuOption( "Rel.Defesa Civil",                          "PFISCREL0140" )
      MenuOption( "Rel.LMP Livro Mov. Produtos",               "PFISCREL0130" )
      MenuOption( "Rel.Livro Entradas/Saidas (P1/P1A/P2/P2A)", "PFISCREL0030" )
      MenuOption( "Rel.Livro Produ��o e Estoque (P3)",         "PFISCREL0010" )
      MenuOption( "Rel.Livro Apura��o de ICMS/IPI (P9)",       "PFISCREL0040" )
      MenuOption( "Rel.Livro Oper.Interestaduais (P12)",       "PFISCREL0080" )
      MenuOption( "Rel.Movimentos Irregulares",                "PFISCREL0090" )
      MenuOption( "Rel.Resumo por UF - ICMS/IPI",              "PFISCREL0100" )
      MenuOption( "Rel.Resumo por UF/Al�quota",                "PFISCREL0110" )
      MenuOption( "Rel.Resumo por Uf/Nat/Al�quota",            "PFISCREL0120" )
      MenuOption( "Rel.Termos de Abertura/Encerramento",       "PFISCREL0020" )
      MenuOption( "Rel.Resumo por Data",                       "PFISCREL0050" )
      MenuOption( "Rel.Regras de Tributa��o",                  "PLEISRELIMPOSTO" )
      MenuUnDrop()
   MenuOption( "Rel.Cadastros" )
      MenuDrop()
      MenuOption( "Rel.Cidades/Pa�ses",        "PLEISRELCIDADE" )
      MenuOption( "Rel.Clientes/Fornecedores", "LJPCADAS" )
      MenuOption( "Rel.Formas de Pagamento",   "LJPFORPAG" )
      MenuOption( "Rel.Produtos",              "LJPITEM" )
      MenuOption( "Rel.Tabelas Auxiliares",    "LJPTABEL" )
      MenuOption( "Rel.Transportadoras",       "LJPCADAS3" )
      MenuUnDrop()
   MenuOption( "Gerencial", "LBALGER" )
   MenuUnDrop()

MenuOption( "Governo" )
   MenuDrop()
   MenuOption( "Arquivo I-SIMP ANP",      "PJPANPMOV" )
   MenuOption( "SPED Cont�bil",           "PCONTSPED" )
   MenuOption( "SPED FCONT 2011",         "PCONTFCONT" )
   MenuOption( "SPED Fiscal/Pis/Cofins",  "PFISCSPED" )
   MenuOption( "Gera LF->Sintegra",       "PFISCSINTEGRA" )
   MenuOption( "Consulta NFe na Sefaz",   "PTESTECONSULTADFE" )
   MenuUnDrop()

MenuOption( "Cadastros" )
   MenuDrop()
   MenuOption( "Agenda de Telefones/Endere�os",    "PJPAGENDA" )
   MenuOption( "Clientes/Fornecedores",            "PJPCADAS1" )
   MenuOption( "Clientes/Fornecedores (Consulta)", "PJPCADAS1B" )
   MenuOption( "Contas Administrativas",           "PCONTCTAADM" )
   MenuOption( "Empresa",                          "PJPEMPRE" )
   MenuOption( "Hist�ricos Padr�o",                "PCONTHISTORICO" )
   MenuOption( "Lan�amentos Padr�o",               "PCONTLANCPAD" )
   MenuOption( "Licen�as" )
      MenuDrop()
      MenuOption( "Licen�as - Lan�amentos", "PJPLICMOV" )
      MenuOption( "Licen�as - Tipos",       "PAUXLICTIP" )
      MenuOption( "Licen�as - Objetos",     "PAUXLICOBJ" )
      MenuOption( "Licen�as - Listagem",    "LJPLICMOV" )
      MenuUnDrop()
   MenuOption( "Plano de Contas",              "PCONTCONTAS" )
   MenuOption( "Produtos/Servi�os",            "PJPITEM" )
   MenuOption( "Produtos/Servi�os (Consulta)", "PJPITEMB" )
   MenuOption( "Transportadoras",              "PJPCADAS3" )
   MenuOption( "Vendedores/T�cnicos",          "PJPVENDED" )
   MenuOption( "Centros de Custo",             "PAUXCCUSTO" )
   MenuOption( "Produtos (Composi��o)",        "PJPPROMIX" )
   MenuOption( "Ve�culos",                     "PJPVEICUL" )
   MenuOption( "Motoristas",                   "PJPMOTORI" )
   MenuOption( "Auxiliares Fiscais" )
      MenuDrop()
      MenuOption( "Carta de Corre��o (C�digos)", "PLEISCORRECAO" )
      MenuOption( "Cidades/Pa�ses",              "PLEISCIDADE" )
      MenuOption( "CFOP (Natureza de Opera��o)", "PLEISCFOP" )
      MenuOption( "CST/CSOSN ICMS",              "PLEISICMCST" )
      MenuOption( "CNAE (Ramos de Atividade)",   "PLEISCNAE" )
      MenuOption( "CST IPI",                     "PLEISIPICST" )
      MenuOption( "CST PIS/Cofins",              "PLEISPISCST" )
      MenuOption( "Modelos de Doctos Fiscais",   "PLEISMODFIS" )
      MenuOption( "Enquadramento IPI",           "PLEISIPIENQ" )
      MenuOption( "Enquadramento PIS/Cofins",    "PLEISPISENQ" )
      MenuOption( "Estoque Unidade de Medida",   "PLEISPROUNI" )
//    MenuOption( "NCM - Classifica��o de Produtos", "XXX" )
      MenuOption( "Origem da Mercadoria",        "PLEISORIMER" )
      MenuOption( "Plano de Contas Referencial", "PLEISREFCTA" )
      MenuOption( "Qualifica��o do Assinante",   "PLEISQUAASS" )
      MenuOption( "UFs (Unidades Federativas)",  "PLEISUF" )
      MenuOption( "IBPT Imposto Acumulado",      "PLEISIBPT" )
      MenuUnDrop()
   MenuOption( "Auxiliares Financeiros" )
      MenuDrop()
      MenuOption( "Bancos",                         "PAUXBANCO" )
      MenuOption( "Valores do D�lar",               "PJPDOLAR" )
      MenuOption( "Formas de Pagamento",            "PJPFORPAG" )
      MenuOption( "Opera��o (Financeiro)",          "PAUXFINOPE" )
      MenuOption( "Portadores (Financeiro)",        "PAUXFINPOR" )
      MenuUnDrop()
   MenuOption( "Auxiliares Outros" )
      MenuDrop()
      MenuOption( "Bases de Rastreamento",        "PJPNFBASE" )
      MenuOption( "Clientes - Grupo de Clientes", "PAUXCLIGRU" )
      MenuOption( "Clientes - Status",            "PJPCLISTA" )
      MenuOption( "Empresas/Filiais (C�digo)",    "PAUXFILIAL" )
      MenuOption( "Estoque - Departamento",       "PESTODEPTO" )
      MenuOption( "Estoque - Se��o",              "PESTOSECAO" )
      MenuOption( "Estoque - Grupo",              "PESTOGRUPO" )
      MenuOption( "Estoque - Localiza��o",        "PESTOLOCAL" )
      MenuOption( "M�dia (origem)",               "PAUXMIDIA" )
      MenuOption( "Motivos de Cancelamento",      "PAUXMOTIVO" )
      MenuOption( "Transa��o",                    "PJPTRANSA" )
      MenuUnDrop()
   MenuUnDrop()

MenuOption( "Integra��o" )
   MenuDrop()
   MenuOption( "XML de NFE" )
      MenuDrop()
      MenuOption( "Envia XML para servidor",         "PNFESALVAMYSQL" )
      MenuOption( "Envia email de NFE",              "PTESTEEMAILDFE2" )
      MenuOption( "Envia XML para email indicado",   "PTESTEEMAILDFE" )
      MenuOption( "Importa arquivos XML",            "PNFEIMPORTA" )
      MenuOption( "Tabela de Convers�o",             "PEDI0150" )
      MenuOption( "Tipos de Convers�o",              "PAUXEDICFG" )
      MenuUnDrop()
   MenuOption( "Gera EDI Financeiro CLARCON",        "PEDICFIN" )
   MenuOption( "Arquivos de retorno ITA�",           "PRETITAU" )
   MenuOption( "Importa notas TOPPETRO",             "PEDI0010" )
   MenuOption( "Grava NFs no L.Fiscal",              "PEDI0040" )
   MenuOption( "Grava LFiscal no Cont�bil",          "PEDI0060" )
   MenuOption( "Exporta Clientes Excel CSV",         "PEDI0270" )
   MenuOption( "CT Importa Contas (Entre Empresas)", "PCONTIMPPLANO" )
   MenuOption( "CT Importar Excel KITFRAME",         "PCONTIMPEXCEL" )
   MenuOption( "CT Importa SPED CONT�BIL",           "PCONTIMPSPED" )
   MenuUnDrop()

MenuOption( "Gerente" )
   MenuDrop()
   MenuOption( "Movimenta��o em Pedidos",         "PNOTACONSPROD" )
   MenuOption( "Resumo do Per�odo (Ped/Fin)",     "PNOTARESUMO" )
   MenuOption( "Acertos Diversos" )
      MenuDrop()
      MenuOption( "Checagem/An�lise Geral",       "PNOTACHECAGEM" )
      MenuOption( "Rec�lculo de Estoque",         "PESTORECALCULO" )
      MenuUnDrop()
   MenuOption( "Estat�stica de Uso",              "PADMESTATISTICA" )
   MenuOption( "Log de Utiliza��o do Sistema",    "PADMINLOG" )
   MenuOption( "Usu�rios/Senhas/Acessos",         "PADMINACESSO" )
   MenuUnDrop()

   MenuOption( "Etc" )
      MenuDrop()
      MenuOption( "NFE 13 DE MAIO", "ETCMAIO" )
      MenuUnDrop()

MenuOption( "Sistema" )
   MenuDrop()
   MenuOption( "Sair do Sistema",    { || SairDoSistema() } )
   MenuOption( "Compacta��o/Reindexa��o", "JPA_INDEX" )
   MenuOption( "JPA Update - Download Vers�o",  "PUPDATEEXEDOWN" )
   IF IsMySerialHD()
      MenuOption( "JPA Update - Upload Vers�o", "PUPDATEEXEUP" )
   ENDIF
   MenuOption( "Backup em arquivo ZIP",         "PUTILBACKUP" )
   MenuOption( "Envia backup pra JPA (ZIP)",    "PUTILBACKUPENVIA" )
   MenuOption( "Utilit�rios Diversos" )
      MenuDrop()
      MenuOption( "Acesso Direto a Arquivos",   "PUTILDBASE" )
      MenuOption( "Calculadora (s-F10)",        { || Calculadora() } )
      MenuOption( "Calend�rio (s-F9)",          { || Calendario() } )
      MenuOption( "Jogo Forca",                 "PGAMEFORCA" )
      MenuOption( "Jogo Teste de QI",           "PGAMETESTEQI" )
      MenuOption( "Mudan�a de senha",           { || pw_AlteraSenha() } )
      MenuOption( "Teclado Virtual",            "PTOOLVKEYBOARD" )
      MenuOption( "Ascii Table",                "PTOOLTABASCII" )
      MenuOption( "Color Table",                "PSETUPCOLOR" )
      MenuOption( "Windows Modo Deus",          "PTOOLGODMODE" )
      MenuUnDrop()
   MenuOption( "Atualiza��o" )
      MenuDrop()
      MenuOption( "Download Tabelas",           "PEDI0260" )
      MenuOption( "Importa CNAE ANP T002",      "PEDI0240" )
      MenuOption( "Importa plano referencial",  "PEDI0290" )
      MenuUnDrop()
   MenuOption( "Configura��es" )
      MenuDrop()
      MenuOption( "Config.Ativa��o/Desativa��o", "PSETUPPARAMALL" )
      MenuOption( "Config.Empresa Usu�ria",      "PSETUPEMPRESA" )
      MenuOption( "Config.Numera��o do Sistema", "PSETUPNUMERO" )
      MenuOption( "Libera��o por telefone",      { || pSetupLibera() } )
      MenuOption( "Altera��o no UAC Windows",    { || pSetupWindows() } )
      MenuOption( "Libera��es extras" )
         MenuDrop()
         MenuOption( "VER pre�o de custo (I)",          "ADMPRECUS" )
         MenuOption( "Ocorr�ncias Alterar/Excluir (I)", "ADMOCOALT" )
         MenuUnDrop()
      MenuOption( "Libera��es ref. Notas" )
         MenuDrop()
         MenuOption( "Cancelamento de Nota Fiscal", "ADMNOTCAN" )
         MenuOption( "Cancelamento de NF-e",        "ADMNFECAN" )
         MenuOption( "Carta de Corre��o",           "ADMNFECCE" )
         MenuUnDrop()
      MenuOption( "Libera��es ref. Pedidos" )
         MenuDrop()
         MenuOption( "Ped.Barras Venda/Garantia (I)",      "ADMPEDBAR" )
         MenuOption( "Ped.Barras Limpar C�d.Barras (I)",   "ADMPEDLBA" )
         MenuOption( "Ped.Cancelamento (I)",               "ADMPEDCAN" )
         MenuOption( "Ped.Duplicar Pedidos (I)",           "ADMPEDCLO" )
         MenuOption( "Ped.Cupom (I)",                      "ADMPEDCUP" )
         MenuOption( "Ped.Email Varios Pedidos (I)",       "ADMPEDMKT" )
         MenuOption( "Ped.Garantia (I)",                   "ADMPEDGAR" )
         MenuOption( "Ped.Fatura (I)",                     "ADMPEDFAT" )
         MenuOption( "Ped.Juntar Pedidos (I)",             "ADMPEDJUN" )
         MenuOption( "Ped.Libera Sem Cr�dito (I)",         "ADMPEDCRE" )
         MenuOption( "Ped.Libera Sem Estoque (I)",         "ADMPEDEST" )
         MenuOption( "Ped.Libera Desconto (I)",            "ADMPEDDES" )
         MenuOption( "Ped.Libera Sem Relacionado (I)",     "ADMPEDREL" )
         MenuOption( "Ped.Libera Pag Atraso (I)",          "ADMPEDPAG" )
         MenuOption( "Ped.Libera Cliente Bloqueado (I)",   "ADMPEDBLO" )
         MenuOption( "Ped.Alterar Vendedor (I)",           "ADMPEDVEN" )
         MenuOption( "Ped.Nota Fiscal/Cupom (I)",          "ADMPEDNOT" )
         MenuOption( "Ped.Gerar CTE",                      "ADMPEDCTE" )
         MenuOption( "Ped.Libera Abaixo do Custo (I)",     "ADMPEDCUS" )
         MenuOption( "Ped.Libera diferente da tabela (I)", "ADMPEDTAB" )
         MenuOption( "Ped. Confirmar ADMPEDLIBn" )
            MenuDrop()
            MenuOption( "Ped.Confirmar ADMPEDLIB1 (I)", "ADMPEDLIB1" )
            MenuOption( "Ped.Confirmar ADMPEDLIB2 (I)", "ADMPEDLIB2" )
            MenuOption( "Ped.Confirmar ADMPEDLIB3 (I)", "ADMPEDLIB3" )
            MenuOption( "Ped.Confirmar ADMPEDLIB4 (I)", "ADMPEDLIB4" )
            MenuOption( "Ped.Confirmar ADMPEDLIB5 (I)", "ADMPEDLIB5" )
            MenuOption( "Ped.Confirmar ADMPEDLIB6 (I)", "ADMPEDLIB6" )
            MenuOption( "Ped.Confirmar ADMPEDLIB7 (I)", "ADMPEDLIB7" )
            MenuOption( "Ped.Confirmar ADMPEDLIB8 (I)", "ADMPEDLIB8" )
            MenuOption( "Ped.Confirmar ADMPEDLIB9 (I)", "ADMPEDLIB9" )
            MenuUnDrop()
         MenuUnDrop()
      MenuUnDrop()
   MenuOption( "JPA - Servidor/Site" )
      MenuDrop()
      MenuOption( "Processa Emails Servidor",   "PDFESERVER" )
      MenuOption( "Zip de XML",                 "PEDIXML" )
      MenuOption( "Zip de XML de/para",         "PEDIXML2" )
      IF IsMySerialHD()
         MenuOption( "Site josequintas.com.br",  "PSITEJPA" )
      ENDIF
      IF IsMySerialHD()
         MenuOption( "Upload de Tabelas",         "PEDI0190" )
      ENDIF
      MenuOption( "Importa ANP Excel" )
         MenuDrop()
         MenuOption( "Importa T001.xls Agentes",      "PEDI0200" )
         MenuOption( "Importa T008.xls Instala��es",  "PEDI0210" )
         MenuOption( "Importa T018.xls Localidades",  "PEDI0220" )
         MenuOption( "Importa T002.xls CNAE",         "PEDI0280" )
         MenuUnDrop()
      MenuOption( "Importa IBGE Excel CNAE 21",       "PEDI0230" )
      MenuUnDrop()
   MenuOption( "Testes" )
      MenuDrop()
      MenuOption( "Testes SPED" )
         MenuDrop()
         MenuOption( "Validar XML",             "PTESVALIDAXML" )
         MenuUnDrop()
      MenuOption( "Testes JPA" )
         MenuDrop()
         MenuOption( "Estilo de menus",                "PTESMENU" )
         MenuOption( "Clientes Excel por regiao",      "PTESTREGIAO" )
         MenuOption( "Preencher CEST",                 "PTESCEST" )
         MenuOption( "Telemarketing",                  "PNOTAVENDAS" )
         MenuOption( "Teste Filtro",                   "PTESFILTRO" )
         MenuOption( "Windows Style",                  "PTESWIN" )
         MenuOption( "MySQL Backup",                   "SQLBACKUP" )
         MenuOption( "MySQL Exportar para MySQL",      "SQLFROMDBF" )
         MenuUnDrop()
      MenuOption( "Testes Aplicativo" )
         MenuDrop()
         MenuOption( "Manual Imprimir",              "HELPPRINT" )
         MenuOption( "Retorna pre�os diferenciados", "PPRECOCANCEL" )
         MenuUnDrop()
      MenuUnDrop()
   MenuOption( "Sobre o JPA-Integra", { || pinfoJPA() } )
   MenuUnDrop()

   RETURN oMenuOptions

STATIC FUNCTION MenuOption( cCaption, oModule )

   LOCAL nCont, oLastMenu
   MEMVAR nMenuLevel, oMenuOptions

   oLastMenu := oMenuOptions
   FOR nCont = 1 TO nMenuLevel
      oLastMenu := oLastMenu[ Len( oLastMenu ) ]
      IF ValType( oLastMenu[ 2 ] ) # "A"
         oLastMenu[ 2 ] := {}
      ENDIF
      oLastMenu := oLastMenu[ 2 ]
   NEXT
   AAdd( oLastMenu, { cCaption, {}, oModule } )

   RETURN NIL

STATIC FUNCTION MenuDrop()

   MEMVAR nMenuLevel
   nMenuLevel++

   RETURN NIL

STATIC FUNCTION MenuUnDrop()

   MEMVAR nMenuLevel
   nMenuLevel--

   RETURN NIL

FUNCTION TelaPrinc( mTitulo )

   LOCAL cCorAnt

   cCorAnt := SetColor()
   mTitulo := AppEmpresaApelido() + " (" + AppUserName() + " ) " + mTitulo
   SetColor( SetColorTitulo() )
   Scroll( 0, 0, 0, MaxCol(), 0 )
   SayTitulo( mTitulo )
   SetColor( SetColorNormal() )
   Scroll( 1, 0, MaxRow() - 3, MaxCol(), 0 )
   //hb_Scroll( 1, 0, MaxRow() - 2, MaxCol(),,,, hb_UTF8ToStrBox( "." ) )  // screen background
   SetColor( SetColorMensagem() )
   @ MaxRow() - 2, 0 TO  MaxRow()-2, MaxCol() COLOR SetColorTraco()
//   Scroll( MaxRow() - 1, 0, MaxRow(), MaxCol(), 0 )
   SetColor( cCorAnt )

   RETURN NIL

FUNCTION MenuPrinc( mMenuOpt )

   LOCAL mOpc    := 1
   LOCAL nKey
   LOCAL mCont, mLenTot, mDife, mEspEntre, mEspFora, mColIni, aMouseMenu

   IF AppUserLevel() > 1
      RetiraOpcoesI( mMenuOpt )
   ENDIF

   IF AppMenuWindows()
      MenuDesenhoCentral()
      MenuWvg( mMenuOpt )
      RETURN NIL
   ENDIF
   // Ajusta textos para teclas de funcao
   // FOR mCont = 1 TO Len( mMenuOpt )
   //    mMenuOpt[ mCont, 1 ] := mMenuOpt[ mCont, 1 ] // Str( mCont, 2 ) + ":" + menu + " "
   // NEXT

   // Centraliza opcoes
   mLenTot := 0
   FOR mCont = 1 TO Len( mMenuOpt )
      mLenTot += Len( mMenuOpt[ mCont, 1 ] )
   NEXT
   mDife     := Max( MaxCol() + 1 - mLenTot, 0 )
   IF mDife < (Len( mMenuOpt ) + 1 )
      IF mDife >= ( Len( mMenuOpt ) - 1 )
         mEspEntre := 1
      ELSE
         mEspEntre := 0
      ENDIF
      mEspFora  := 0
   ELSE
      mEspEntre := int( mDife / ( Len( mMenuOpt ) + 1 ) )
      mEspFora  := int( ( mDife - ( mEspEntre * ( Len( mMenuOpt ) + 1 ) ) ) / 2 ) + mEspEntre
   ENDIF
   mColIni   := { mEspFora }
   FOR mCont = 2 TO Len( mMenuOpt )
      AAdd( mColIni, mColIni[ mCont - 1 ] + Len( mMenuOpt[ mCont - 1, 1 ] ) + mEspEntre )
   NEXT
   aMouseMenu := {}
   FOR mCont = 1 TO Len( mMenuOpt ) // Problema do clipper do Chr(59) no Inkey
      AAdd( aMouseMenu, { 1, mColIni[ mCont ], mColIni[ mCont ] - 1 + Len( mMenuOpt[ mCont, 1 ] ), 48 + mCont + Iif( mCont > 10, 1, 0 ), 0 } )
   NEXT
   Mensagem( "Selecione e tecle ENTER, ESC Sai" )
   DO WHILE .T.
      //wvt_DrawImage( 2, 0, MaxRow(), MaxCol(), "d:\cdrom\fontes\integra\image\jpa2017.bmp" )

      SetColor( SetColorNormal() )
      Scroll( 1, 0, 1, MaxCol(), 0 )
      FOR mCont = 1 TO Len( mMenuOpt )
         @ 1, mColIni[ mCont ] SAY mMenuOpt[ mCont, 1 ] COLOR iif( mCont == mOpc, SetColorFocus(), SetColorNormal() )
      NEXT
      //MenuDesenhoCentral()
      BoxMenu( 3, mColIni[ mOpc ] - 20 + Int( Len( mMenuOpt[ mOpc, 1 ] ) / 2 ), mMenuOpt[ mOpc, 2 ], 1,, .T., .T., aMouseMenu, 1 )
      nKey := Inkey( 60, INKEY_ALL - INKEY_MOVE + HB_INKEY_GTEVENT )
      DO CASE
      CASE nKey == K_ESC .OR. nKey == 0
          IF ! AppIsMultiThread()
              EXIT
         ENDIF
         SairDoSistema()
         LOOP
      CASE nKey == K_RIGHT
         mOpc := iif( mOpc == Len( mMenuOpt ), 1, mOpc + 1 )
      CASE nKey == K_LEFT
         mOpc := iif( mOpc == 1, Len( mMenuOpt ), mOpc - 1 )
      // Numeros, incluindo Chr(59) nao detectado no Inkey()
      CASE nKey > 48 .AND. nKey < 49 + Len( mMenuOpt ) + iif( Len( mMenuOpt ) > 10, 1, 0 )
         mOpc := Abs( nKey ) - 48
         mOpc := Iif( mOpc > 10, mOpc - 1, mOpc )
      ENDCASE
   ENDDO
   Mensagem()

   RETURN NIL

STATIC FUNCTION BoxMenu( mLini, mColi, mMenuOpt, mOpc, mTitulo, mSaiSetas, mSaiFunc, aMouseConv, nLevel )

   LOCAL mLinf, mColf, mCont, nKey, aMouseLen, lExit, xLin, xCol, cTexto, oElement
   LOCAL nMRow, nMCol, cCorAnt, m_ProgTxt
   MEMVAR m_Prog, cDummy
   PRIVATE cDummy

   hb_Default( @mSaiSetas, .F. )
   hb_Default( @mSaiFunc, .F. )
   hb_Default( @mTitulo, "" )
   hb_Default( @mOpc, 1 )
   cCorAnt := SetColor()
   mLinf     := mLini + Len( mMenuOpt ) + iif( Empty( mTitulo ), 1, 2 )
   IF mLinf > MaxRow() - 4
      mLini := mLini + MaxRow() - 4 - mLinf
      mLinf := mLini + Len( mMenuOpt ) + iif( Empty( mTitulo ), 1, 2 )
   ENDIF
   mColi := iif( mColi < 0, 0, mColi )
   mColf := mColi + 37
   IF mColf > MaxCol() - 2
      mColi := mColi - 10 // Se nao conseguiu +5, tenta -5
      mColf := mColf - 10
      IF mColf > MaxCol() - 2
         mColi := mColi + MaxCol() - 2 - mColf
         mColf := mColi + 37
      ENDIF
   ENDIF
   wOpen( mLini, mColi, mLinf, mColf, mTitulo )
   aMouseLen := Len( aMouseConv )
   ASize( aMouseConv, Len( aMouseConv ) + Len( mMenuOpt ) )
   FOR mCont = 1 TO Len( mMenuOpt )
      xLin := mLini + iif( Empty( mTitulo ), 0, 1 ) + mCont
      xCol := mColi + 1
      AIns( aMouseConv, 1 )
      aMouseConv[ 1 ] := { xLin, xCol, xCol + 33, 64 + mCont, nLevel }
   NEXT
   DO WHILE .T.
      NovaVersao() // Verifica se foi instalada nova versao
      FOR EACH oElement IN mMenuOpt
         IF oElement[ 1 ] == "-"
            @ mLini + iif( Empty( mTitulo ), 0, 1 ) + oElement:__EnumIndex, mColi + 1 TO mLini + iif( Empty( mTitulo ), 0, 1 ) + oElement:__EnumIndex, mColi + 36 COLOR iif( oElement:__EnumIndex == mOpc, SetColorFocus(), SetColorBox() )
         ELSE
            cTexto := " " + Chr( 64 + oElement:__EnumIndex ) + ":" + oElement[ 1 ]
            cTexto := Pad( cTexto, 34 ) + iif( Len( oElement[ 2 ] ) > 0, Chr(16), " " ) + " "
            @ mLini + iif( Empty( mTitulo ), 0, 1 ) + oElement:__EnumIndex, mColi + 1 SAY cTexto COLOR iif( oElement:__EnumIndex == mOpc, SetColorFocus(), SetColorBox() )
         ENDIF
      NEXT
      SetColor( SetColorNormal() )
      nKey := Inkey(1800)
      lExit := .F.
      DO CASE
      CASE nKey == K_ESC .OR. nKey == K_RBUTTONDOWN .OR. nKey == 0
         IF nKey == 0
            CLS
            QUIT
         ENDIF
         IF nLevel == 1
            KEYBOARD Chr( K_ESC )
         ENDIF
         EXIT

      CASE nKey == K_LBUTTONDOWN // Click Esquerda
         nMRow := MROW()
         nMCol := MCOL()
         FOR EACH oElement IN aMouseConv
            IF nMRow == oElement[ 1 ] .AND. nMCol >= oElement[ 2 ] .AND. nMCol <= oElement[ 3 ]
               IF oElement[ 5 ] == nLevel // Nivel Atual
                  KEYBOARD Chr( oElement[ 4 ] )
               ELSEIF oElement[ 5 ] == 0 // Principal
                  KEYBOARD Chr( oElement[ 4 ] )
                  lExit := .T.
               ELSE
                  KEYBOARD Replicate( Chr( K_ESC ), nLevel - oElement[ 5 ] - 1 ) + Chr( oElement[ 4 ] )
                  lExit := .T.
               ENDIF
               EXIT
            ENDIF
         NEXT
         IF lExit
            EXIT
         ENDIF
      CASE nKey > 64 .AND. nKey < 65 + Len( mMenuOpt ) // Letra menu atual
         mOpc := nKey - 64
         KEYBOARD Chr( K_ENTER )
      CASE mSaiSetas .AND. ( nKey == K_RIGHT .OR. nKey == K_LEFT )
         IF nLevel == 1
            KEYBOARD Chr( nKey )
         ENDIF
         EXIT
      CASE nKey == K_DOWN
         IF mOpc < Len( mMenuOpt )
            IF mMenuOpt[ mOpc + 1, 1 ] == "-"
               mOpc += 1
            ENDIF
         ENDIF
         mOpc := iif( mOpc >= Len( mMenuOpt ), 1, mOpc + 1 )
      CASE nKey == K_UP
         IF mOpc > 1
            IF mMenuOpt[ mOpc - 1, 1 ] == "-"
               mOpc -= 1
            ENDIF
         ENDIF
         mOpc := iif( mOpc <= 1, Len( mMenuOpt ), mOpc - 1 )
      CASE nKey == K_HOME
         mOpc := 1
      CASE nKey == K_END
         mOpc := Len( mMenuOpt )
      CASE nKey == K_ENTER
         IF Len( mMenuOpt[ mOpc, 2 ] ) > 0
            BoxMenu( mLini + iif( Empty( mTitulo ), 0, 1 ) + mOpc, mColi + 5, mMenuOpt[ mOpc, 2 ], 1, mMenuOpt[ mOpc, 1 ], .T., .T., aMouseConv, nLevel + 1 )
         ELSEIF ValType( mMenuOpt[ mOpc, 3 ] ) == "C"
            m_Prog := mMenuOpt[ mOpc, 3 ]
            IF m_Prog == "-"
            ELSEIF m_Prog == "NAOTEM"
               MsgStop( "Opcao em projeto/desenvolvimento" )
            ELSEIF "(I)" $ m_Prog .OR. Left( m_Prog, 3 ) == "ADM"
               MsgStop( "Modulo interno, no menu apenas pra efeito de configuracao" )
            ELSEIF "(" $ m_Prog
               WSave()
               Mensagem()
               SayTitulo( AppEmpresaApelido() + " (" + AppUserName() + " ) (" + m_Prog + " ) " + Upper( mMenuOpt[ mOpc, 1 ] ) )
               Scroll( 1, 0, MaxRow() - 3, MaxCol(), 0 )
               cDummy := &( mMenuOpt[ mOpc, 3 ] )
               WRestore()
            ELSE
               wSave()
               Mensagem()
               m_ProgTxt := AppEmpresaApelido() + " (" + AppUserName() + ") (" + m_Prog + ") " + Upper( mMenuOpt[ mOpc, 1 ] )
               RunModule( m_Prog, m_ProgTxt )
               wRestore()
            ENDIF
            m_Prog := "JPA"
            SetColor( SetColorNormal() )
         ELSEIF ValType( mMenuOpt[ mOpc, 3 ] ) == "B"
            wSave()
            Mensagem()
            Scroll( 2, 0, MaxRow() - 3, MaxCol(), 0 )
            Eval( mMenuOpt[ mOpc, 3 ] )
            WRestore()
         ENDIF

      CASE SetKey( nKey ) != NIL
         Eval( SetKey( nKey ), ProcName(), ProcLine(), ReadVar() )

      OTHERWISE // Vamos ver se e' atalho
         nKey := Asc( Upper( Chr( nKey ) ) )
         FOR EACH oElement IN aMouseConv
            IF nKey == oElement[ 4 ]
               IF oElement[ 5 ] == nLevel // Nivel Atual
                  KEYBOARD Chr( oElement[ 4 ] )
               ELSEIF oElement[ 5 ] == 0 // Principal
                  KEYBOARD Chr( oElement[ 4 ] )
                  lExit := .T.
               ELSE
                  KEYBOARD Replicate( Chr(27), nLevel - oElement[ 5 ] - 1 ) + Chr( oElement[ 4 ] )
                  lExit := .T.
               ENDIF
               EXIT
            ENDIF
         NEXT
      ENDCASE
      CLOSE DATABASES
      IF lExit
         EXIT
      ENDIF
   ENDDO
   FOR EACH oElement IN mMenuOpt
      ADel( aMouseConv, 1 )
   NEXT
   ASize( aMouseConv, aMouseLen )
   wClose()
   SetColor( cCorAnt )

   RETURN NIL

FUNCTION LogDeUso( cHrInic, cModulo )

   LOCAL nElapsed, cTexto

   nElapsed := TimeDiff( cHrInic, Time() )
   IF nElapsed > 119 // a partir de 2 minutos
      cTexto := ""
      cTexto += "Modulo " + cModulo
      cTexto += ", por " + LTrim( Str( nElapsed / 60 ) ) + "m (" + Left( cHrInic, 5 ) + " a " + Left( Time(), 5 ) + ")"
      cTexto += " (ID " + DriveSerial() + ")"
      GravaOcorrencia( ,, cTexto )
   ENDIF

   RETURN NIL

FUNCTION SayTitulo( cTextoTitulo )

   @ 0, 0 SAY Padc( cTextoTitulo, MaxCol() + 1 ) COLOR SetColorTitulo()
   hb_gtInfo( HB_GTI_WINTITLE, cTextoTitulo )

   RETURN NIL

STATIC FUNCTION RetiraOpcoesI( mMenuOpt )

   LOCAL oElement

   FOR EACH oElement IN mMenuOpt
      IF Len( oElement[ 2 ] ) != 0
         RetiraOpcoesI( oElement[ 2 ] )
      ENDIF
   NEXT

   RETURN NIL

PROCEDURE PToolTabAscii

   LOCAL nCont, nRow, nCol

   nRow := 3
   nCol := 5
   FOR nCont = 1 TO 255
      @ nRow, nCol SAY StrZero( nCont, 3 ) + " " + Chr( nCont )
      nRow += 1
      IF nRow > MaxRow() - 5
         nCol += 10
         nRow := 3
      ENDIF
   NEXT
   MsgExclamation( "Ok" )

   RETURN

PROCEDURE PTESWIN

   LOCAL cisMultiThread, cPlayText, GetList := {}, cMenuWindows

   cIsMultiThread  := iif( AppIsMultiThread(), "S", "N" )
   cPlayText       := iif( AppIsPlayText(), "S", "N" )
   cMenuWindows    := iif( AppMenuWindows(), "S", "N" )
   @ 14, 10 SAY "MultiThread...............:" GET cIsMultiThread PICTURE "!A" VALID cIsMultiThread $ "SN"
   @ 18, 10 SAY "Speak Text W8.1 Enterprise:" GET cPlayText PICTURE "!A" VALID cPlayText $ "SN" WHEN AppUserLevel() == 0
   @ 20, 10 SAY "Menu Windows..............:" GET cMenuWindows PICTURE "!A" VALID cMenuWindows $ "SN"
   READ
   IF LastKey() != K_ESC
      AppIsMultiThread( cisMultiThread == "S" )
      AppIsPlayText( cPlayText == "S" )
      AppMenuWindows( cMenuWindows == "S" )
      hb_ThreadStart( { || Sistema() } )
      QUIT
   ENDIF

   RETURN

STATIC FUNCTION MenuWvg( mMenuOpt )

   LOCAL oMenu, nKey // , oImage // , oButton

   oMenu  := wvgSetAppWindow():MenuBar()
   //oButton := wvgtstPushButton():New()
   //oButton:oimage := { , WVG_IMAGE_BITMAPRESOURCE, "JPATECNOLOGIA", , 1 }
   //oButton:lImageResize := .T.
   //oButton:Create( , , { -2, 0 }, { -MaxRow(), -MaxCol() } )
   //oImage := wvgTstBitmap():New()
   //oImage:cImage := "jpatecnologia"
   //oImage:Create( ,,{ 0, 0 }, { -MaxRow() - 1, -MaxCol() - 1 } )
   BuildMenu( oMenu, mMenuOpt )
   DO WHILE .T.
      nKey := Inkey( 0 )
      DO CASE
      CASE nKey == HB_K_GOTFOCUS
      CASE nKey == HB_K_LOSTFOCUS
      CASE nKey == K_ESC
         EXIT
      ENDCASE
   ENDDO
   wvgSetAppWindow():oMenu := NIL
   wapi_SetMenu( wapi_GetActiveWindow(), NIL )
   wapi_DestroyMenu( oMenu:hWnd )

   RETURN NIL

FUNCTION BuildMenu( oMenu, acMenu )

   LOCAL oElement, oSubMenu, cbCode, m_ProgTxt
   MEMVAR m_Prog

   FOR EACH oElement IN acMenu
      IF Len( oElement[ 2 ] ) == 0
         m_Prog := oElement[ 3 ]
         IF ValType( m_Prog ) == "C"
            m_ProgTxt := AppEmpresaApelido() + " (" + AppUserName() + ") (" + m_Prog + ") " + Upper( oElement[ 1 ] )
            cbCode     := [{ || RunModule( "] + m_Prog + [", "] + m_ProgTxt + [" ) }]
            oMenu:AddItem( oElement[ 1 ] , &( cbCode ) )
         ELSE
            oMenu:AddItem( oElement[ 1 ], oElement[ 3 ] )
         ENDIF
      ELSE
         oSubMenu := WvgMenu():new( oMenu, , .T. ):Create()
         BuildMenu( oSubMenu, oElement[ 2 ] )
         oMenu:AddItem( oSubMenu, oElement[ 1 ] )

      ENDIF
   NEXT

   RETURN NIL

STATIC FUNCTION SairDoSistema()

   IF ! MsgYesNo( "Confirma saida do sistema?" )
      RETURN NIL
   ENDIF
   CLOSE DATABASES
   GtSetupFont(.T.)
   QUIT

   RETURN NIL

PROCEDURE PTESMENU

   LOCAL nStyle

   nStyle := AppStyle()
   nStyle += 1
   IF nStyle > 4
      nStyle := 1
   ENDIF
   AppStyle( nStyle )
   MsgExclamation( "Style atual " + Ltrim( Str( AppStyle() ) ) )

   RETURN

FUNCTION PToolVKeyboard()

   ShellExecuteOpen( "OSK.EXE" )

   RETURN NIL

FUNCTION PToolGodMode()

   IF ! Empty( GetEnv( "USERPROFILE" ) )
      hb_vfDirMake( GetEnv( "USERPROFILE" ) + "\desktop\God Mode.{ED7BA470-8E54-465E-825C-99712043E01C}" )
   ENDIF

   RETURN NIL

STATIC FUNCTION MenuDesenhoCentral()

   LOCAL aTexto, oElement, nRow, nCol, cSetColor := SetColor()

   aTexto := { ;
      "JPA Tecnologia (11) 2280-5776", ;
      "e-mail: suporte@jpatecnologia.com.br", ;
      "", ;
      "Licenciado: " + Trim( AppEmpresaNome() ), ;
      "", ; // "TerminalID: " + DriveSerial(), ;  // + "   ODBCMySql: " + DriverMySql
      Version() + " " + hb_GTInfo( HB_GTI_VERSION ), ;
      HB_Compiler(), ;
      "Base de dados DBF e MySQL(*)", ;
      "JPA Versao " + AppVersaoExe() }
   FOR EACH oElement IN aTexto
      IF ! Empty( oElement )
         oElement := " " + oElement + " "
      ENDIF
   NEXT
   nCol   := Max( Int( ( MaxCol() - 80 ) / 2 ), 0 )
   nRow   := Max( Int( ( MaxRow() - Len( aTexto ) ) / 2 ) - 2, 0 )
   SetColor( SetColorNormal() )
   @ nRow, 0 SAY ""
   FOR EACH oElement IN aTexto
      @ Row() + 1, nCol SAY Padc( oElement, 80 )
   NEXT
   SetColor( cSetColor )

   RETURN NIL

STATIC FUNCTION TimeDiff( mTimeIni, mTimeFim )

   mTimeIni := Val( Substr( mTimeIni, 1, 2 ) ) * 3600 + Val( Substr( mTimeIni, 4, 2 ) ) * 60 + Val( Substr( mTimeIni, 7, 2 ) )
   mTimeFim := Val( Substr( mTimeFim, 1, 2 ) ) * 3600 + Val( Substr( mTimeFim, 4, 2 ) ) * 60 + Val( Substr( mTimeFim, 7, 2 ) )

   RETURN mTimeFim - mTimeIni

REQUEST BROWSE
REQUEST ERRORSYS
REQUEST READMODAL
REQUEST HELP

REQUEST p0600Ped
REQUEST pNotaServico
REQUEST pNotaCadastro
REQUEST pNotaPedRetira
REQUEST pNotaRomaneio
REQUEST pjpmdf
REQUEST pNotaVerVendas
REQUEST pBol0020
REQUEST pBol0030
REQUEST pBol0040
REQUEST pBol0050
REQUEST pBol0060
REQUEST pBol0061
REQUEST pBol0062
REQUEST pTesteBoleto
REQUEST pNotaGeraRps
REQUEST pNotaGeraNfe
REQUEST pDfeCteCancel
REQUEST pDfeGeraPDF
REQUEST pDfeCteInut
REQUEST pDfeNfeInut
REQUEST pPre0010
REQUEST pPrecoRelTabComb
REQUEST pPre0020
REQUEST pPrecoRelTabGeral
REQUEST pNot0213
REQUEST pNot0214
REQUEST pPrecoRelTabMulti
REQUEST pSetupParamRound
REQUEST pNotaEtiqueta
REQUEST pGeralRecibo
REQUEST pEstoLanca2
REQUEST pEstoLanca1
REQUEST pEstoEntFor
REQUEST pBar0010
REQUEST pBar0040
REQUEST pjpfisicaa
REQUEST pjpfisicad
REQUEST pEstoValEst
REQUEST pEstoTotArmazem
REQUEST pBancoLanca
REQUEST pBancoCCusto
REQUEST pBancoSaldo
REQUEST pBancoConsolida
REQUEST pBancoGera
REQUEST pBancoComparaMes
REQUEST pBancoGraficoMes
REQUEST pBancoGrafResumo
REQUEST pFinanEdReceber
REQUEST pFin0035
REQUEST pFinanBaixaPort
REQUEST PFINANEDPAGAR
REQUEST pFin0045
REQUEST pContLancInclui
REQUEST pContLancLote
REQUEST pContLancAltera
REQUEST pContTotais
REQUEST pContSaldo
REQUEST pContFecha
REQUEST pContSintetica
REQUEST pContRecalculo
REQUEST pContRedRenum
REQUEST pContRedDisp
REQUEST pContSetup
REQUEST pContNumDia
REQUEST pContEmitidos
REQUEST pFiscEntradas
REQUEST pFiscSaidas
REQUEST pFiscCorrecao
REQUEST pFiscTotais
REQUEST pLeisDecreto
REQUEST pLeisUF
REQUEST pLeisTriCad
REQUEST pLeisTriEmp
REQUEST pLeisTriPro
REQUEST pLeisTriUF
REQUEST pLeisImposto
REQUEST ljppedi
REQUEST pNotaRelRentab
REQUEST pNotaFicCliVen
REQUEST pNotaRelNotas
REQUEST pNotaPlanilhaG
REQUEST pNotaXls
REQUEST pNotaRelCliVend
REQUEST pNotaRelPedRel
REQUEST pNotaRelMapa
REQUEST pNotaRelCompMes
REQUEST pNotaRelCompCli
REQUEST pNotaRelVendCli
REQUEST pBancoRelExtrato
REQUEST pBancoRelSaldo
REQUEST pBancoRelCCusto
REQUEST ljpestoqa
REQUEST ljpestoqb
REQUEST ljpestoqc
REQUEST pEstoRelAnalise
REQUEST pjpfisicab
REQUEST pjpfisicaa
REQUEST pEstoItemXls
REQUEST pfinanRelReceber
REQUEST pfinanRelMaiCli
REQUEST pFinanRelPagar
REQUEST pFinanRelMaiFor
REQUEST pFinanRelFluxo
REQUEST pContRel0360
REQUEST pContRel0270
REQUEST pContRel0520
REQUEST pContRel0210
REQUEST pContRel0010
REQUEST pContRel0380
REQUEST pContRel0310
REQUEST pContRel0320
REQUEST pContRel0390
REQUEST pContRel0250
REQUEST pContRel0550
REQUEST pContRel0300
REQUEST pContRel0330
REQUEST pContRel0530
REQUEST pContRel0385
REQUEST pContRel0250
REQUEST pContRel0550
REQUEST pContRel0300
REQUEST pContRel0330
REQUEST pContRel0530
REQUEST pContRel0530
REQUEST pContRel0385
REQUEST pContRel0470
REQUEST pContRel0370
REQUEST pContRel0230
REQUEST pContRel0340
REQUEST pFiscRel0060
REQUEST pFiscRel0070
REQUEST pFiscRel0140
REQUEST pFiscRel0130
REQUEST pFiscRel0030
REQUEST pFiscRel0010
REQUEST pFiscRel0040
REQUEST pFiscRel0080
REQUEST pFiscRel0090
REQUEST pFiscRel0100
REQUEST pFiscRel0110
REQUEST pFiscRel0120
REQUEST pFiscRel0020
REQUEST pFiscRel0050
REQUEST pLeisRelImposto
REQUEST pLeisRelCidade
REQUEST ljpCadas
REQUEST ljpForPag
REQUEST ljpitem
REQUEST ljptabel
REQUEST ljpcadas3
REQUEST pjpAnpMov
REQUEST pContSped
REQUEST pContFCont
REQUEST pFiscSped
REQUEST pFiscSintegra
REQUEST pTesteConsultaDfe
REQUEST pjpAgenda
REQUEST pjpCadas1
REQUEST pjpCadas1B
REQUEST pContCtaAdm
REQUEST pjpEmpre
REQUEST pContHistorico
REQUEST pContLancPad
REQUEST pjpLicMov
REQUEST pAuxLicTip
REQUEST pAuxLicObj
REQUEST ljpLicMov
REQUEST pContContas
REQUEST pjpItem
REQUEST pjpItemb
REQUEST pjpCadas3
REQUEST pjpVended
REQUEST pAuxCCusto
REQUEST pjpProMix
REQUEST pjpVeicul
REQUEST pjpMotori
REQUEST pLeisCorrecao
REQUEST pLeisCidade
REQUEST pLeisCfop
REQUEST pLeisIcmCst
REQUEST pLeisCnae
REQUEST pLeisIpiCst
REQUEST pLeisPisCst
REQUEST pLeisModFis
REQUEST pLeisIpiEnq
REQUEST pLeisPisEnq
REQUEST pLeisProUni
REQUEST pLeisOriMer
REQUEST pLeisRefCta
REQUEST pLeisQuaAss
REQUEST pLeisUF
REQUEST pLeisIBPT
REQUEST pAuxBanco
REQUEST pjpDolar
REQUEST pjpForPag
REQUEST pAuxFinOpe
REQUEST pAuxFinPor
REQUEST pjpNFBase
REQUEST pAuxCliGru
REQUEST pjpCliSta
REQUEST pAuxFilial
REQUEST pEstoDepto
REQUEST pEstoSecao
REQUEST pEstoGrupo
REQUEST pEstoLocal
REQUEST pAuxMidia
REQUEST pjpTransa
REQUEST pNfeSalvaMySql
REQUEST pTesteEmailDfe2
REQUEST pTesteEmailDfe
REQUEST pNfeImporta
REQUEST pEdi0150
REQUEST pAuxEdiCfg
REQUEST pEdiCfin
REQUEST pRetItau
REQUEST pEdi0010
REQUEST pEdi0040
REQUEST pEdi0060
REQUEST pEdi0270
REQUEST pContImpPlano
REQUEST pCOntImpExcel
REQUEST pContImpSped
REQUEST pNotaConsProd
REQUEST pNotaResumo
REQUEST pNotaChecagem
REQUEST pEstoRecalculo
REQUEST pAdmEstatistica
REQUEST pAdminLog
REQUEST pAdminAcesso
REQUEST EtcMaio
REQUEST pUpdateExeDown
REQUEST pUpdateExeUp
REQUEST pUtilBackup
REQUEST pUtilBackupEnvia
REQUEST pUtilDbase
REQUEST Calculadora
REQUEST Calendario
REQUEST pGameForca
REQUEST pGameTesteQI
REQUEST pw_AlteraSenha
REQUEST pToolVKeyboard
REQUEST pToolTabAscii
REQUEST pSetupColor
REQUEST pToolGodMode
REQUEST pEdi0260
REQUEST pEdi0240
REQUEST pEdi0290
REQUEST pSetupParamAll
REQUEST pSetupEmpresa
REQUEST pSetupNumero
REQUEST pSetupLibera
REQUEST pSetupWindows
REQUEST pDfeServer
REQUEST pEdiXML
REQUEST pEdiXML2
REQUEST pSiteJPA
REQUEST pEdi0200
REQUEST pEdi0210
REQUEST pEdi0220
REQUEST pEdi0280
REQUEST pEdi0230
REQUEST pTesValidaXml
REQUEST pTesMenu
REQUEST pTestRegiao
REQUEST pTesCest
REQUEST pNotaVendas
REQUEST pTesFiltro
REQUEST pTesWin
REQUEST SqlBackup
REQUEST SqlFromDbf
REQUEST HelpPrint
REQUEST pPrecoCancel
REQUEST pInfoJPA
REQUEST pNotaProximas
