---
title: "conceptos-dsls-domainspecificlanguage-dsl---tcpip"
date:  2018-06-20T19:27:10-03:00
---


### TCP / IP
Alan Kay (y su equipo probablemente) implementaron el stack TCP / IP, a través de definir el protocolo con un DSL.
La particularidad es que el DSL es básicamente el mismo "diagrama" ASCII del RFC original.

Acá está:


[![](https://sites.google.com/site/programacionhm/_/rsrc/1402153838829/conceptos/dsls/domainspecificlanguage/tcpheader.png)
](conceptos-dsls-domainspecificlanguage-tcpheader-png?attredirects=0)

Y la definción de la gramática en notación BNF para poder parser e interpretar esto es:


[![](https://sites.google.com/site/programacionhm/_/rsrc/1402153838796/conceptos/dsls/domainspecificlanguage/diagramcode.png)
](conceptos-dsls-domainspecificlanguage-diagramcode-png?attredirects=0)
Con esto pudieron hacer una implementación de TCP/IP en **menos de 200 lineas**, cuando las implementaciones en **C tienen alrededor de 20.000 lineas** !!!