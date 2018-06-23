---
title: "conceptos-metaprogramacion-introspection-introspection-en-self"
date:  2018-06-20T19:27:10-03:00
---


Self es un poquito más dificil de mostrar porque tenemos que poner screenshots :(

Pero es interesante ver algún ejemplo.
El MOP de Self está basado en una idea llamada mirrors. La teoría de esto se explica en [esta otra sección del site](conceptos-mirrors)
Sin embargo acá vamos a ver ejemplos prácticos de reflection.
A modo de simplificación vamos a decir que el MOP está conformada por objetos llamados mirrors, que representan o reflejan nuestros objetos.

Dado un objeto puedo obtener su mirror con el método reflect: miObjeto

Acá entonces creamos un objeto libro...

**

        (|titulo <- 'El Juego de Ender'. autor <- 'Orson Scott Card'. cliente <- nil|).**



[![](https://sites.google.com/site/programacionhm/_/rsrc/1316819143473/conceptos/metaprogramacion/meta-self1.png)
](conceptos-metaprogramacion-meta-self1-png?attredirects=0)

****Hagamos algo de introspection. Obtenemos el mirror para este objeto. Para eso primero le agregamos como parent a oddball a fin de tener el método reflect:
**********

******

****parent`***** = traits oddball`
****Y ahora sí obtenemos el mirror con

**************

        reflect: self**********

****



[![](https://sites.google.com/site/programacionhm/_/rsrc/1316819835015/conceptos/metaprogramacion/meta-self2.png)
](conceptos-metaprogramacion-meta-self2-png?attredirects=0)

Ok, ya tenemos el mirror. Ahora a través de este mirror podemos introspectar nuestro libro.
El mirror tiene entiende varios mensajes para esto.
Vamos a ver los más básicos.

Con el mensaje names obtenemos la lista de nombres de slots del objeto.


[![](https://sites.google.com/site/programacionhm/_/rsrc/1316819976226/conceptos/metaprogramacion/meta-self3-slotNames.png)
](conceptos-metaprogramacion-meta-self3-slotNames-png?attredirects=0)
****Ahí se ve de *izquierda a derecha*: 

* **

**

nuestro objeto libro, ****

* **

**

luego su mirror, ****

* **

**

y finalmente la lista de nombres de sus slots.****

Nótese que el mensaje **names** se lo enviamos al mirror. Y a diferencia del API MOP de java, acá no tenemos que pasarle el objeto *libro* por parámetro. Porque **los mirrors son objetos con estado**. Es decir un mirror **refleja a un objeto en particular**. En java el API de reflection está asociada a las clases y su estructura, y no existen metaobjetos asociados a nuestras instancias.

Entonces, ya no necesitamos la ventanida de nuestro libro para introspectarlo, podemos trabajar solo con su mirror.

Hagamos algo más interesante. Cambiémosle el valor del slot **titulo** mediante su mirror.


************at: 'titulo' PutContents: (reflect: 'Ubik')
        **************

Luego de hacer **Do it**, vemos que el objeto cambió *(a la izquierda)*


[![](https://sites.google.com/site/programacionhm/_/rsrc/1316820302861/conceptos/metaprogramacion/meta-self4-atPutContents.png)
](conceptos-metaprogramacion-meta-self4-atPutContents-png?attredirects=0)
Algo para notar acá es que al enviar el mensaje **at PutContents** como parámetro **nuevo valor**, no estamos usando el string **Ubik** directamente, sino que primero obtenemos su **mirror**. Esta es una particularidad del MOP de mirrors. **Toda esta API trabaja en término de mirrors**, y nunca mezcla los diferentes niveles (el nivel de mirrors con el nivel de objetos "base").

Ahora vamos a acceder al valor de un slot via mirrors.
Para eso hacemos simplemente


**at**: 'titulo'`
Y eso nos da otro objeto cuyo título dice "Ubik"


[![](https://sites.google.com/site/programacionhm/_/rsrc/1316821528492/conceptos/metaprogramacion/meta-self5-at1.png)
](conceptos-metaprogramacion-meta-self5-at1-png?attredirects=0)
Excelente!
Ahora, que raro el nombre de la ventanita, no ? Además tiene unos slots raros, como "**mirror**"

Exploremos un poco.
Si este objeto fuea el valor "Ubik" al apretar en el iconito de "Ubik" de la ventanita de nuestro Libro, debería apuntar ahí.

Sin embargo miren lo que sucedió..


[![](https://sites.google.com/site/programacionhm/_/rsrc/1316821696101/conceptos/metaprogramacion/meta-self-at2.png)
](conceptos-metaprogramacion-meta-self-at2-png?attredirects=0)
Fíjense que** apuntan a diferentes objetos**. Y si mostramos la referencia de "mirror" desde el objeto *"a slot plan(titutlo = 'Ubik')" *apunta al mirror del libro.

Por qué es esto ?

Porque el mensaje "**at**" no nos devolvió el valor del slot, sino** un objeto que representa al slot mismo.** Es **un mirror del slot.**

Sería como en java teníamos modelado el concepto de Field. Acá el slot tiene estado, por lo cual tiene el valor "Ubik" dentro.

Ahora a este objeto "slotMirror" le podemos enviar el mensaje **contents** y nos debería dar el valor, no ?


[![](https://sites.google.com/site/programacionhm/_/rsrc/1316822089012/conceptos/metaprogramacion/meta-self-at3.png)
](conceptos-metaprogramacion-meta-self-at3-png?attredirects=0)
Bueno, no :(

Y qué nos dió ? Vemos el título de la ventana, y descubrimos que **nos dió un mirror del valor**. Es decir **un mirror del string "Ubik"**.
Esto refuerza la idea que contamos antes de que el MOP de Self es completamente consistente, y trabaja siempre en un metanivel. Todos sus métodos trabajan con mirrors. Por lo cual el valor del slot es un mirror del objeto real.

Entonces, cómo diablos obtenemos el objeto "Ubik" verdadero ?

Ah.. todos los mirrors entienden el mensaje **reflectee** que devuelve el objeto del nivel base que estan reflejando.

Enviémosle ese mensaje entonces a este mirror de "Ubik"


[![](https://sites.google.com/site/programacionhm/_/rsrc/1316822288042/conceptos/metaprogramacion/meta-self-at4.png)
](conceptos-metaprogramacion-meta-self-at4-png?attredirects=0)
Ahora sí ! finalmente vemos que nos retorna la misma instancia de "Ubik" que teníamos abierta :)