---
title: "conceptos-metaprogramacion-introspection-introspection-en-javascript"
date:  2018-06-20T19:27:10-03:00
---


**Javascript tiene soporte para **introspection** y **self-modification** pero no a través de un API (es decir, no a través de un MOP), sino en el mismo lenguaje.****Intentemos el mismo ejemplo del libro. Definimos el objeto:**

**

**




        **var** libro = { 
            titulo: "El Juego de Ender",
            autor: "Orson Scott Card",  
            cliente: null,
            prestarA: **function**(cliente) {
 `**if** (**this**.cliente != **null**) **throw** "Libro ya prestado!!";`
 `**this**.cliente = cliente;`
 `} `
        };
**

**

**Imprimimos los slots del objeto:**

**

**




        

        println("Un objeto")
        **for** (property **in** libro) {
 `println("&nbsp;&nbsp;con " + property)`
        }
**

**

**Fíjense que acá está el soporte del lenguaje con el keyword in**

**Esto genera:**





        Un objeto
 `con **titulo**`
 `con **autor**`
 `con **cliente**`
 `con **prestarA**`
Ahora accedamos a un slot en particular:
        println("Titulo: " + libro["titulo"])
Podemos checkear si un slot existe en el objeto con:
        println("Tiene Autor? " + ("autor" in libro))
Obviamente tambíen podemos invocar un método:
        libro["prestarA"].**apply**(libro, ["Lector Frecuente"]);
Fíjense que acá se ve que el libro["prestarA"] nos está retornando un objeto de tipo **Function** que tiene el método **apply** que básicamente la ejecuta pasándole como parámetro el objeto target **this** y luego un array de argumentos.
Modificar una variable
        libro["titulo"] = "Ubik"