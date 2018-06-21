---
title: "conceptos-dsls-domainspecificlanguage-dsl---sed"
date:  2018-06-20T19:27:10-03:00
---


### []()Sed (linux command)
De Stream Editor, es un comando de linux se utiliza para procesar texto de entrada (stream) generando una salida. Utiliza su propio lenguaje similar a regexp para definir las transformaciones a realizar en forma declarativa.

```
    echo **abcd123** | sed '**s**#\**([a-z]***\**).***#**\1**#'


Produce:    **    abcd**


```



El parámetro que le pasamos a sed tiene la siguiente sintaxis:```
                 s#pattern#sustitution#'
```



Pattern es lo que solemos llamar **regular expression. **Y tiene una sintaxis y elementos específicos ya definidos que podemos usar.
* En nuestro caso:

 * **\(**   **\)**  : delimita un token, para luego poder ser referenciado numéricamente en la substitución como "**\1**"
 * **[a-z]**: cualquier caracter entre "a" y "z"
 * **[a-z]* : **muchas veces, cualquier caracter entre "a" y "z"
 * **.** (punto) : cualquier caracter
 * .* : cualquier caracter, muchas veces
* En nuestro ejemplo sed va a matchear abcd123

 * abcd = [a-z]* = \1

 * 123 =  .*
 * es decir "(1)123"