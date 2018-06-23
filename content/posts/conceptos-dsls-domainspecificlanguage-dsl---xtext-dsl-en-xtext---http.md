---
title: "conceptos-dsls-domainspecificlanguage-dsl---xtext-dsl-en-xtext---http"
date:  2018-06-20T19:27:10-03:00
---


## Ejemplo de DSL en XText para invocaciones HTTP


//TODO: 
- poner link al código fuente.
- embeber algo de código de la gramática y del inferrer.
### Dominio

Veamos un ejemplo bien práctico. Vamos a usar un mismo dominio para ir mostrándo temas más avanzados de xtext.
**Dominio:**


* tenemos ya implementado un modelo objetos que sirve para hacer **invocaciones http a sistemas externos**

* esto está implementado como clases java, es decir como un API regular.
* La idea es que sirve para embeber y utilizar en cualquier sistema **para realizar invocaciones http**.
* Entonces, de qué consta una **invocación http** en general ?

 * **URL**: que identifica el servicio al cual invocar. Como cualquier URL web. Ej: *http://localhost:8080/miServicio*
 * **Tipo***: *el tipo de request http

  * **GET:** no contiene cuerpo (body). En cambio, puede tener parametros como parte de la URL:

  * **POST: **contiene cuerpo. Generalemente se envían los parámetros*.*
 * **Body:* ***es el contenido del mensaje propiamente dicho. Puede tener texto largo (a diferencia de la URL que tiene un límite).

  * Generalmente, enviamos xml por ejemplo como "body". A esto se lo llama servicios **XML-RPC**

 * **Headers:**


  * como parte del request HTTP, se pueden incluir Headers que son básicamente "key-values" parte del paquete.
  * son Strings.
Ejemplos de request HTTP:

 GETPOST 
```
 **GET** /index.html **HTTP/1.1**

** Host:** www.example.com
```
```
**POST** /path/script.cgi HTTP/1.0
**From:** frog@jmarshall.com
**User-Agent:** HTTPTool/1.0
**Content-Type:** application/x-www-form-urlencoded
**Content-Length:** 32

**home=Cosby&favorite+flavor=flies**

```
```
 HTTP/1.1 **200** **OK**

** Date:** Mon, 23 May 2005 22:38:34 GMT
** Server:** Apache/1.3.3.7 (Unix) (Red-Hat/Linux)
** Last-Modified:** Wed, 08 Jan 2003 23:11:55 GMT
** Etag:** "3f80f-1b6-3e1cb03b"
** Accept-Ranges:** bytes
** Content-Length:** 438
** Connection:** close
** Content-Type:** text/html; charset=UTF-8
 
 <html>
 <body>
 <h1>Happy New Millennium!</h1>
 (more file contents)
 .
 </body>
 </html>
```


### Bosquejando el lenguaje

Entonces, bosquejamos un ejemplo de lenguaje para especificar estas invocaciones http.
En un notepad o lo que sea.

    type **post**


    **url** "[http://charging.acme.com/reserve](http://charging.entelpcs.com/reserve)"

    header "servicio" = "luz"
    header "sessionId" = "987546213546"

    body [[
    <credit>
        <user userId="98546" />
        <checkCredit type="money" amount="23" />
    </credit>
    ]]
```
Pensamos en los conceptos del lenguaje: type, url, header, body, etc.
```

### Modelo semántico y gramática = Http.xtext

Entonces vamos a implementar nuestro lenguaje de invocaciones http con xtext.
Definimos la gramática y modelo.
Vemos el archivo .xtext y acá ya tenemos un modelo un poquito más complejo que el "Hola Mundo".
Vemos el mapeo o la relación entre la definición y las clases del dominio.


### Implementando un Interpreter Java
Como vimos antes, xtext ya se ocupa de toda la complejidad relacionada con el parsing de nuestro lenguaje. Y se basa en la idea de generar instancias de un "modelo semántico" como salida.
Es decir, que nuestros archivos son parseados y traducidos a instancias de nuestro modelo.
Una vez que llegamos al mundo de objetos y del modelo, las capacidades son infinitas. Justamente la gente de xtext decide expresar el modelo semántico a través de un framework de metamodelo llamado EMF (Eclipse Modelling Framework), sobre el cual existen muchas herramientas ya implementadas que podríamos usar sobre nuestro modelo, por ejemplo:

* frameworks para creare **editores gráficos**, como GMF: Graphical Modelling Framework.
* **persistencia**: existen varios proyectos de eclipse para persistir nuestros modelos de diversas formas, serializando, mapeando a ORMs, etc.

* **model to model transformations**: M2M es otro fwk eclipse para expresar transformaciones entre modelos.
* etc.
El "generador" que vimos antes, es un caso particular, donde estamos visitando nuestro las instancias de nuestro modelo, y evaluando templates para generar código. Pero podríamos pensar en un enfoque distinto.

Qué tal si **queremos que nuestra aplicación java** sepa **usar** las **instancias del modelo** semántico creadas por xtext (luego de parsear) **directamente**, sin necesidad de generar clases, ni correr el generador ??

Se puede!, Digamos que hacemos los siguientes pasos:

* delegamos en xtext el parseo
* luego visitamos las instancias del modelo, 


 * y ahí podríamos hacer lo que quisieramos
 * un ejemplo, sería adaptar los objetos, wrappearlos, etc.
Vemos acá un ejemplo de HttpDSLInterpreter.