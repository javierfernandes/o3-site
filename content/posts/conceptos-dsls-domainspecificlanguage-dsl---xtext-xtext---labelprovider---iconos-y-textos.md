---
title: "conceptos-dsls-domainspecificlanguage-dsl---xtext-xtext---labelprovider---iconos-y-textos"
date:  2018-06-20T19:27:10-03:00
---


## Intro

Podemos customizar un aspecto más "visual" o "accesorio" si se quiere de nuestro lenguaje es que la parte estética del plugin IDE que nos genera.
En particular acá vamos a ver dos cosas:

* Cambiarle el ícono a los elementos de nuestro lenguaje
* Cambiarle el texto con el cual se representa uno de nuestros elementos del leguaje.

## Outline Default (no customizado)

Además del editor de texto, xtext nos genera una vista "Outline".
Ésta muestra en forma de arbol el contenido de uno de nuestros archivos y se va refrescando y vinculando con el editor de texto. Así si elegimos un elemento en esa vista, lo selecciona en el código y vice-versa.


Acá un ejemplo de cómo se ve por default para nuestro [ejemplo de los saludos](../conceptos-dsls-domainspecificlanguage-dsl---xtext-dsl-en-xtext---saludos).



[![](https://sites.google.com/site/programacionhm/_/rsrc/1402594572730/conceptos/dsls/domainspecificlanguage/dsl---xtext/xtext---labelprovider---iconos-y-textos/saludos-outline-default.png)
](conceptos-dsls-domainspecificlanguage-dsl---xtext-xtext---labelprovider---iconos-y-textos-saludos-outline-default-png?attredirects=0)

La vista de la derecha es el "outline". 
Como se ve usa los mismos íconos feuchos para todos los elementos (definiciones de **Alguien** y **Saludo**'s).


## Customizando el *DSLLabelProvider

Existe un objeto que se encarga de, a partir de los objetos de nuestro modelo semántico saber calcular:

* **el texto** que se va a mostrar
* **el ícono** para ese objeto.

Este objeto es de la clase ***DSLLabelProvider,** y está en el proyecto ".ui" de nuestro DSL.
Inicialmente trae un template de código comentado.


Es bastante simple extender, ya que trabaja con reflection para darnos una forma "declarativa" de definir estas cosas a través de métodos.
Muy similar a las ideas de los @Check y @Fix.


Acá el ejemplo para los saludos.





        **class** SaludosDSLLabelProvider extends **DefaultEObjectLabelProvider {


 `@Inject`
 `new(AdapterFactoryLabelProvider delegate) 
 `super(delegate);`
 `}`
 
 `// Saludo`
 ` def text(Saludo saludo) 
 `'Un saludo a ' + saludo.AQuien.name `
 `}`
 ` def image(Saludo saludo) 
 `'saludo.jpg'`
 `}`
 
 `// Alguien`
 ` def image(Alguien alguien) 
 `'alguien.png'`
 `}`
        }


Acá vemos que simplemente uno debe definir nuevos métodos que tienen que llamarse **text(T) **o **icon(T)** para retornar el texto customizado el ícono respectivamente, para un T específico.


El T sería la clase de nuestro elemento del DSL (modelo semántico).


**OJO que los íconos deben ir dentro de una carpeta "icons" de este mismo proyecto.**



Acá se muestra como queda nuestro ejemplo.



[![](https://sites.google.com/site/programacionhm/_/rsrc/1402595236991/conceptos/dsls/domainspecificlanguage/dsl---xtext/xtext---labelprovider---iconos-y-textos/saludos-outline-custom.png)
](conceptos-dsls-domainspecificlanguage-dsl---xtext-xtext---labelprovider---iconos-y-textos-saludos-outline-custom-png?attredirects=0)

Como se ve a la derecha, está usando nuestros íconos (que pusimos en la carpeta "icons"), y la descripción de los saludos ha cambiado a nuestro texto ("Un saludo a Jose").


## Dinamismo por objeto

Como éstos métodos reciben a los objetos instancias de las clases de nuestro modelo semántico. Tiene entre su estado interno, lo que ingresó el usuario en el DSL (así como estamos mostrando "Un saludo a XXXX"


Eso quiere decir que podríamos tener un algoritmo más complejo, o bueno, "comportamiento" para usar diferentes imágenes de acuerdo a diferentes condiciones.


Por ejemplo:


[![](https://sites.google.com/site/programacionhm/_/rsrc/1402595541851/conceptos/dsls/domainspecificlanguage/dsl---xtext/xtext---labelprovider---iconos-y-textos/male-icon.jpg)
](conceptos-dsls-domainspecificlanguage-dsl---xtext-xtext---labelprovider---iconos-y-textos-male-icon-jpg?attredirects=0)  En caso de que el nombre que ingresó sea MASCULINO

[![](https://sites.google.com/site/programacionhm/_/rsrc/1402595575489/conceptos/dsls/domainspecificlanguage/dsl---xtext/xtext---labelprovider---iconos-y-textos/female-icon.jpg)
](conceptos-dsls-domainspecificlanguage-dsl---xtext-xtext---labelprovider---iconos-y-textos-female-icon-jpg?attredirects=0) En caso en que sea FEMENINO


Teniendo nuestra propia lógica o motorcito para dado el nombre inferir si es MASCULINO o FEMENINO.

*