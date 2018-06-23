---
title: "ejemplos-extra-de-dsls"
date:  2018-06-20T19:27:10-03:00
---


## Reglas en Drools
Drools es un rule engine (motor de reglas) embebible en sistemas java. Comúnmente resulta bastante complicado modelar un conjunto de reglas, con sus condiciones y acciones en un lenguaje de objetos. Otros tipos de lenguajes o paradigmas como el lógico idealmente, o hasta el funcional resultan más prácticos para modelar este tipo de dominios, ya que no poseen efecto de lado, y resultan más "declarativos".
Entonces Drools tiene su propio DSL para definir estas reglas. Veamos un ejemplo:

```
**rule** "A welcome task for the new user"
** when**

 A new node is created
 - the node has the type jnt:user
** then**

 Log "Creating welcome task for new user: " + node.getName()
 Create task "Welcome to Jahia!" with description "We are glad to have you in our platform." for user node.getName()
**end**


**rule** "A notification about new group member"
 **when**

 A new node is created
 - the node has the type jnt:member
 The node has a parent
** then**

 Log "Notifying members of the group '" + parent.getParent().getName() + "' about new member '" + node.getName()
 Create task "New member in the group" with description "A new member was added to the group." for members of group parent.getParent().getName()
**end**


```


## Otros Ejemplos / Tutoriales

* Como hacer un intérprete de un minilenguajecito en ioke [http://mikael-amborn.blogspot.com/2009/11/extreme-oop-exercise-in-ioke.html](http://mikael-amborn.blogspot.com/2009/11/extreme-oop-exercise-in-ioke.html)