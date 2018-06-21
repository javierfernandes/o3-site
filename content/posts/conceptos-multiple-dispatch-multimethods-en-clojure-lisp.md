---
title: "conceptos-multiple-dispatch-multimethods-en-clojure-lisp"
date:  2018-06-20T19:27:10-03:00
---


### []()MultiMethods en un lenguaje funcional (clojure)
Primero definimos la "herencia":

        (**derive** ::artesano ::trabajador)
        (**derive** ::zapatero ::trabajador)

        (**derive** ::cuero ::material)
        (**derive** ::goma ::material)


Declaramos ahora el multimethod usando la función especial defmulti y luego definimos cada implementación según los parámetros

        (**defmulti** trabajar (**fn** [x y] [x y]))
        (**defmethod** trabajar [::artesano ::cuero] [t m] "Hice un llaverito!")
        (**defmethod** trabajar [::artesano ::goma] [t m] (str "Trabajo con: " m))
        (**defmethod** trabajar [::zapatero ::cuero] [t m] "Hice un mocasin!")
        (**defmethod** trabajar [::zapatero ::goma] [t m] "Hice una sandalia!")
        (**defmethod** trabajar [::trabajador ::material] [t m] "Trabajador no sabe que hacer con material!")

Y ahora ya podemos invocar esta función a ver qué pasa:


        user=>` (`**`trabajar`**` ::artesano ::cuero)`
**`"Hice un llaverito!"`**


        user=>` (`**`trabajar`**` ::zapatero ::cuero)`
**`"Hice un mocasin!"`**`**

**`
Ahora invoquémoslo con una variable, en lugar de usar directamente los objetos (symbols). 

        user=> (**def** trabajador ::artesano)    // definimos la variable 'trabajador' como el symbol 'artesano'
**`#'user/trabajador`**           
        user=> trabajador                 // a ver qué tiene trabajador ?....
**`:user/artesano`**                       // bien.. tiene artesano
        user=> (**trabajar** trabajador ::goma)            // invocamos ahora trabajar con la variable
**`"Trabajo con: :user/goma"`**                      // bien, se ejecutó el método de artesano + goma.