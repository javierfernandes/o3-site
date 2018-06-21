---
title: "conceptos-dsls-domainspecificlanguage-dsl---pic2plot-diagramas-de-secuencia"
date:  2018-06-20T19:27:10-03:00
---


### []()Pic para expresar diagramas de secuencia

Pic2plot es un DSL construido utilizando otros lenguajes y herramientas GNU para generar diagramas UML de secuencia.


Por ejemplo, supongamos que queremos hacer este diagrama:



![](https://sites.google.com/site/programacionhm/_/rsrc/1402153838829/conceptos/dsls/domainspecificlanguage/seq-impr.gif)


Cómo podríamos implementarlo utilizando un lenguaje de propósito general como Java ?

```java
    DiagramaSecuencia diagrama = **new** DiagramaSecuencia();
    StakeHolder switch = **new** StakeHolder(*"s:Switch"*);
    diagrama.add(switch);

    StakeHolder pump = **new** StakeHolder(*"p:Pump"*);
    diagrama.add(pump);

    diagrama.*drawSlot*();    

        diagrama.*startControlOn*(switch);    
        diagrama.*startControlOn*(pump);        
        
    diagrama.addMessage(**new** *Message*(switch, pump, *"run()"*, RIGHT_TO_LEFT));
    diagrama.addMessage(**new** Message(switch, pump, *"stop()"*, RIGHT_TO_LEFT));

    diagrama.*drawSlot*();

        diagrama.*endControlOn*(pump);    
        diagrama.*endControlOn*(switch);
```

Observemos:

* **Donde están los elementos que definen mi diagrama particular en ese código **? 


 * **dispersos** entre las *construcciones del lenguaje*. Se pueden ver algunos *subrayados*.

 * Algunos como parámetros **"strings"**.
 * Otros como **nombres de clases**.
 * **nombres de métodos**

 * **constantes **(como RIGHT_TO_LEFT)

* **new** : aparece la idea de instanciar objetos, que podría considerarse como un detalle de implementación de mi sistema, Al menos, al tipo que tiene que definir como quiere que sea su diagramar, le gustaría no tener que lidear con parafernalia extra que no sea propia del diagrama de secuencia.
* DiagramaSecuencia: 


 * aparece la idea de instanciar el diagrama que no estaba en el DSL, porque ya todo el ejemplo era para definir el diagrama.
 * aparece la clase específica "DiagramaSecuencia".
* **Sintaxis:**


 * todo se ensucia con la sintaxis propia del lenguaje Java, que, nuevamente, probablemente no le interese a quien tenga que hacer un diagrama de secuencia. Ejemplo: "." para el envío de mensajes, "(" para enviar parámetros, ";", etc.
* **Message:**


 * aparece una clase y un objeto intermedio que en el lenguaje no se ve tan claramente, o mejor dicho, que no se puede mapear tan directamente al DSL

Ahora veamos el mismo ejemplo implementado con el DSL de Pic2Plot:
```
S,"s:Switch" P,"p:Pump" 
**|** S **[** P ****[**** S **=>** P, "run()" S **=>** P, "stop()" ****|**** ****]**** P
****]**** S
```


 
![](https://sites.google.com/site/programacionhm/_/rsrc/1402153838829/conceptos/dsls/domainspecificlanguage/seq-impr.gif)



Cosas para notar acá:

* Nuevamente, no es un lenguaje general, sus construcciones son solo para graficar diagramas de secuencia.
* A diferencia de SQL y de otros lenguajes, 


 * juega un poco con **imitar la parte gráfica**

 * para eso, utiliza **caracteres especiales** 


  * **=>** para el envío de mensaje
  * ```
********| ********para incluir un espacio (proyectando lo gráficos hacia abajo). 
```


**En conclusión**:

* Vemos que el DSL tiene un poder de síntesis y de expresividad mucho mayor.

* Porque los bloques del lenguaje estan directamente relacionados con un concepto del dominio (elementos del diagrama de secuencia), y esos son, de hecho, lo únicos elementos del lenguaje,....

* no hay ruido de sintaxis.

* no expone el modelo subyacente de objetos y clases que podría no ser trivial, o ser complejo.