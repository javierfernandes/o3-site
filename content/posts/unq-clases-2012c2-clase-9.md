---
title: "unq-clases-2012c2-clase-9"
date:  2018-06-20T19:27:10-03:00
---


#### Material teórico
El material teórico disponible se encuentra en [Domain Specific Language](../conceptos-dsls-domainspecificlanguage).

#### Ejemplos

Todos los ejemplos se pueden bajar de acá: [https://xp-dev.com/svn/utn-tadp-projects/phm/trunk/programacionDeclarativa/](https://xp-dev.com/svn/utn-tadp-projects/phm/trunk/programacionDeclarativa/).
Para hacerlos andar, conviene pensar en tres workspaces diferentes:

* En un primer workspace, desde un Eclipse con Scala, importn los proyectos

 * [primera-parte](https://xp-dev.com/svn/utn-tadp-projects/phm/trunk/programacionDeclarativa/primera-parte/) que tiene todo los primeros ejemplos, hasta xml y annotations, y
 * [scala](https://xp-dev.com/svn/utn-tadp-projects/phm/trunk/programacionDeclarativa/scala/), que tiene el ejemplo de DSL interno en Scala.
* En un segundo workspace con el plugin de [XText](../te-xtext), importen:

 * [primera-parte](https://xp-dev.com/svn/utn-tadp-projects/phm/trunk/programacionDeclarativa/primera-parte/),
 * [xtext](https://xp-dev.com/svn/utn-tadp-projects/phm/trunk/programacionDeclarativa/xtext/), 
 * [xtext.generator](https://xp-dev.com/svn/utn-tadp-projects/phm/trunk/programacionDeclarativa/xtext.generator/) y 
 * [xtext.ui](https://xp-dev.com/svn/utn-tadp-projects/phm/trunk/programacionDeclarativa/xtext.ui/) (estos últimos 3 tienen las definiciones del DSL externo).
* Desde ese workspace, cuando ejecuten "Eclipse Application", les va a crear un tercer workspace, ahí deben importar:

 * [primera-parte](https://xp-dev.com/svn/utn-tadp-projects/phm/trunk/programacionDeclarativa/primera-parte/),
 * [xtext](https://xp-dev.com/svn/utn-tadp-projects/phm/trunk/programacionDeclarativa/xtext/) y
 * [XTextMapping](https://xp-dev.com/svn/utn-tadp-projects/phm/trunk/programacionDeclarativa/XTextMapping/), que tiene un ejemplo de uso del DSL.