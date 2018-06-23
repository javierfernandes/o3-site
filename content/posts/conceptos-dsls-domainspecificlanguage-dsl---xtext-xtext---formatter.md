---
title: "conceptos-dsls-domainspecificlanguage-dsl---xtext-xtext---formatter"
date:  2018-06-20T19:27:10-03:00
---


## Intro

Este es otro punto de extension para nuestro lenguaje. La idea es customizar la forma en la que se formatea el codigo, es decir, dónde forzar quiebres de línea, donde forzar espacios, etc.
## *DSLFormatter

Para eso, nuevamente existe una clase, tipo Strategy, que ya viene generado como un template vacío en nuestro lenguaje:






[![](https://sites.google.com/site/programacionhm/_/rsrc/1402664723794/conceptos/dsls/domainspecificlanguage/dsl---xtext/xtext---formatter/formatter-class.png)
](conceptos-dsls-domainspecificlanguage-dsl---xtext-xtext---formatter-formatter-class-png?attredirects=0)

Esta clase debe implementar un único método:



        **override protected void** configureFormatting(FormattingConfig c)


En éste, debe configurar las reglas de formateo sobre el objeto que nos pasan por parámetro.
Pero para eso necesitamos poder hacer referencia a la gramática.


Veamos primero para el ejemplo de los Saludos, cómo quedaría el código si lo formateamos, sin haber customizado el Formatter:



[![](https://sites.google.com/site/programacionhm/_/rsrc/1402664943481/conceptos/dsls/domainspecificlanguage/dsl---xtext/xtext---formatter/formatter-default.png)
](conceptos-dsls-domainspecificlanguage-dsl---xtext-xtext---formatter-formatter-default-png?attredirects=0)


Ok, horrible.


Recordemos la gramática:





        Model:
 `(quienes+=Alguien)*`
 `(saludos+=Saludo)*;`
        ...

No hace falta que mostremos toda la gramática, acá ya vemos la regla principal Model.
Nos gustaría decir que:

* luego de cada **Alguien**, introduzca una nueva linea
* luego de cada **Saludo, **también**.**


Necesitamos desde el Formatter entonces hacer referencia a la gramática, a Model, y a la idea de que dentro declara Saludo's.


### *GrammarAccess

Para esto último, xtext, además de generar las clases de nuestro modelo semántico, el editor de texto, etc, genera un conjunto de classes que representan a la gramática, y que sirve para luego hacer referencia desde el formatter.


La clase principal se llama



            <<NOMBRE DEL DSL>>**GrammarAccess**

A partir de este objeto podemos obtener acceso a otros objetos que representan cada uno de los elementos de nuestra gramática, y sus atributos.
Acá se ve para el ejemplo de saludos:
[![](https://sites.google.com/site/programacionhm/_/rsrc/1402665332898/conceptos/dsls/domainspecificlanguage/dsl---xtext/xtext---formatter/formatter-grammar.png)
](conceptos-dsls-domainspecificlanguage-dsl---xtext-xtext---formatter-formatter-grammar-png?attredirects=0)

## Definiendo reglas en el Formatter usando el GrammarAccess

Entonces ahora sí podemos definir reglas, declarando que necesitamos el GrammarAccess como una extension:





        **class** SaludosDSLFormatter extends AbstractDeclarativeFormatter {


 `@Inject **extension **SaludosDSLGrammarAccess`
 
 `**override protected void** configureFormatting(FormattingConfig c) 
 `c.setLinewrap().after(getAlguienRule())`
 `c.setLinewrap().after(getSaludoRule())`
 `}`


        }


Estamos diciendo que inserte una nueva linea, luego de (after) las reglas Alguien, y Saludo.


Y acá vemos como formatea ahora:

[![](https://sites.google.com/site/programacionhm/_/rsrc/1402665618873/conceptos/dsls/domainspecificlanguage/dsl---xtext/xtext---formatter/formatter-newlines.png)
](conceptos-dsls-domainspecificlanguage-dsl---xtext-xtext---formatter-formatter-newlines-png?attredirects=0)

Ahora, cómo sabía yo que tenía que usar ese "getAlguienRule" y "getSaludoRule" ?


Ja ! Bueno, en parte porque XText algo ayuda, si van a la clase GrammarAccess van a ver mucho código bastante incomprensible, pero cada método tiene un comentario, donde figura exáctamente la partecita de la gramática que definimos nosotros.
Así podemos rápidamente saber que regla es esa.
Acá un pedacito de código:





** `//Bienvenida:`**

** `//` `"Hola" aQuien=[Alguien] "!";`**

 `public ParserRule getRule() { return rule; }`


** `//"Hola" aQuien=[Alguien] "!"`**

 `public Group getGroup() { return cGroup; }`


** `//"Hola"`**

 `public Keyword getHolaKeyword_0() { return cHolaKeyword_0; }`


** `//aQuien=[Alguien]`**

 `public Assignment getAQuienAssignment_1() { return cAQuienAssignment_1; }`


Marcamos en negrita los comentarios.


También en parte hay que ir jugando un poco con prueba y error hasta encontrar la mejor forma de definir lo que queremos hacer con el formatter.


### Agregando espacio entre dos "secciones"

Queremos agregar un doble espacio entre el conjunto de definiciones de "quienes" y de "saludos".





 `override protected void configureFormatting(FormattingConfig c) 
 `c.setLinewrap().after(getAlguienRule())`
 `c.setLinewrap().after(getSaludoRule())`
 
** `c.setLinewrap(2).between(modelAccess.quienesAlguienParserRuleCall_0_0, modelAccess.saludosSaludoParserRuleCall_1_0)`**

 `}`
Para eso usamos el "between" y las dos reglas, de Alguien y Saludo. between(Alguien, Saludo) 2 linewraps.
## Ejemplos


* Ver clase **MappingDslFormatter **del ejemplo de los [Mappings](conceptos-dsls-domainspecificlanguage-dsl---xtext-xtext-dsl---orm-mappings) para un formatter un poco más complejo.