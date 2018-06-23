---
title: "conceptos-dsls-domainspecificlanguage-dsl---xtext-xtext---embebiendo-xbase-en-nuestro-dsl"
date:  2018-06-20T19:27:10-03:00
---


## Extendiendo o embebiendo XBase

XBase es el lenguaje en el cual se basa xtend. Y está hecho, lógicamente con xtext. Con lo cual cualquiera de nuestros lenguajes puede extender XBase, o bien utilizar algunas de sus construcciones, por ejemplo para escribir código "java" o similar dentro de nuestros lenguajes.
Para eso, en nuestra gramática debemos agregar





        grammar org.uqbar.paco.dsl.xtext.mapping.MappingDsl **with org.eclipse.xtext.xbase.Xbase**

        **

**

        generate mappingDsl "http://www.uqbar.org/paco/dsl/xtext/mapping/MappingDsl"
        

        **import "http://www.eclipse.org/xtext/common/JavaVMTypes" as types**



Al hacer esto se va a generar automáticamente el paquete "jvmmodel" y una clase Inferrer.


Además se van a incluir dependencias a varios plugins de xbase que tienen bastante código de ejemplo o para reutilizar en los diferentes extension points de xtext.


El ejemplo de [ORM Mappings](conceptos-dsls-domainspecificlanguage-dsl---xtext-xtext-dsl---orm-mappings) usa elementos Java embebidos. Ahí mismo explica como hacer varias cositas útiles.