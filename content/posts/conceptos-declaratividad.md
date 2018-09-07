---
title: "conceptos-declaratividad"
date: 2018-09-07T11:43:34-03:00
toc: true
---

# Programación Imperativa


Es, probablemente, la visión tradicional de la programación: 
        
> mi programa **dá ordenes a la computadora.**

Donde nuestro programa se define por conceptos como: 

* algoritmo, 
* sentencias,
* variables,
* asignaciones,
* el orden o secuencia de ejecución son factores importantes.

Aquí vemos el diagrama de alto nivel que esquematiza la idea de programa:

[![](https://sites.google.com/site/programacionhm/_/rsrc/1401131526621/conceptos/declaratividad/imperativa.png)
](conceptos-declaratividad-imperativa-png?attredirects=0)


Por ejemplo en los paradigmas:

* **Estructurado**: algoritmo y orden
* **OOP**: no tanto centrado en algoritmo, pero si existe la secuencia u orden.

El "algoritmo" es lo que valida la "regla de negocio".


Característica principal
 
**Las "reglas de negocio" estan <mezcladas> con los algoritmos u ordenes a la computadora.**


Contrastado con estas visiones, introducimos:


# Programación Declarativa

Existe una separación entre "hechos" ó "reglas de negocio"   e   instrucciones y ordenes.


```
    EL QUÉ                vs              EL CÓMO
```


//TODO


El diagrama a continuación esquematiza la estructura de un programa declarativo.

[![](https://sites.google.com/site/programacionhm/_/rsrc/1401131950143/conceptos/declaratividad/declaratividad.png)
](conceptos-declaratividad-declaratividad-png?attredirects=0)

En rojo vemos un ejemplo de sistema declarativo: una base de datos relacional.

## Ejemplo teórico: la cafetería.

Tomemos como ejemplo, un programa para instruir a alguien a ir de un aula a la cafeteria.

#### La versión Imperativa

* doblar a la izquierda,
* luego caminar derecho 30 metros.
* Doblar a la derecha
* Caminar hasta tener a la derecha la oficina 80.
* Doblar a la izquierda.
Luego, si cambio de lugar de origen, o destino, necesito cambiar todo mi programa.

#### La versión declarativa

* hago un mapa de la universidad (también declarativo, es información pura, sin algoritmo)
* luego mi programa es declarativo, expresado como el **goal u objetivo: ** *"ir desde aula 60 hasta cafetería"*.

Ahora incluso me sirve para hacer varios otros programas. Para volver de la cafetería, o ir a otras aulas, etc.


En el imperativo, estaba el mapa de la universidad ?
Sí, en la cabeza del programador, y entretejida y escondida (**implícita**) detrás de las instrucciones imperativas.
En el declarativo, está **explícita** toda la información.
# Ejemplos

## DAO/Home Imperativo
[https://xp-dev.com/svn/uqbar/examples/paco/trunk/declaratividad/primera-parte-xtend/](https://xp-dev.com/svn/uqbar/examples/paco/trunk/declaratividad/primera-parte-xtend/)


Problemas que tiene esta solución:

* La información del Mapeo no está explicitada en ningun lugar.
* De hecho está repetida entre el add, find y rowmapper: los strings de los nombres de las columnas.
* Está implícita la relación entre "columna" y "field" de la clase.
* Se ve solo en el orden en que le pasamos los datos al invocar el constructor.

Y si agrego un nuevo atributo ?
Tengo que tocar en todos lados.

## Home Declarativa con Annotations

Definimos entonces:

**Base de conocimientos**: deberá expresar la información de mapeo entre tabla y clase, de forma independiente a cómo se va a utilizar esa información.
Lo vamos a hacer en las mismas clases, mediante annotations.


Y así separamos: información de algoritmo.

[![](https://sites.google.com/site/programacionhm/_/rsrc/1401133192111/conceptos/declaratividad/genericDAO.png)
](conceptos-declaratividad-genericDAO-png?attredirects=0)

Así, la información del mapeo la re-utilizamos entre los diferentes métodos del DAO.
Ya no hay repetición dentro del DAO.


Pero además, nuestro DAO es suficientemente genérico (es el motor), con lo cual ahora podemos usarlo sobre diferentes clases (Email, Usuario, o cualquier otra nueva clase). 

## Introspective DAO/Home

//TODO

## Implementación con XML

//TODO

# Borrador Inicial (inicios de O3 / PHM)

#### Tecnologías

* ejemplos de declaratividad de TADP (1 o 2 clases)

 * annotations en java
 * XML
 * pico container / ¿juice?
 * comparar XML con lenguajes de Scripting.
 * Combinar DSL con declaratividad, o sea usar DSLs para hacer cosas declarativas
* Pragmas de Pharo
* magritte (1 clase)


#### Ejemplos:

* Con hibernate podemos mostrar XML y annotations
* Con magritte podemos automatizar ABMs con Seaside
* ... pragmas?
* Extener los ejemplos de declaratividad de TADP.
