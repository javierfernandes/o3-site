---
title: "conceptos-mixins-conflictos-con-traits-de-scala"
date:  2018-06-20T19:27:10-03:00
---


Uno estaría tentado a pensar que como Scala implementa mixins, no deberían aparecer conflictos al aplicar mixins con métodos con la misma firma, ya que la linearización se haría cargo de ellos. Esto no siempre se cumple.
Si tenemos:

        trait A {
          def m = "A"
        }

        trait B {
          def m = "B"
        }
        

        class C extends A with B
El compilador no nos dejará crear la clase C y nos lo explica diciendo:

        error: overriding method m in trait A of type => java.lang.String;` method m in trait B of type => java.lang.String needs `override' modifier`
Nos pide que B defina el el método m como override, pero B no conoce A (y no queremos que lo conozca!).
Podemos hacer que A y B extiendan un trait común que defina el método y luego poder definir el mismo en A y B como override:

        trait X {
         def m: String
        }


        trait A extends X {
          override def m = "A"
        }


        trait B extends X {
          override def m = "B"
        }


        class C extends A with B
        

``new C().m``
``res3: java.lang.String = B``
De esta forma le aseguramos al compilador que no nos importa que la implementación de B pise la de A, y vemos que finalmente la llamada a "m" retorna "B".
También podemos ver que ocurre cuando hacemos que A y B extiendan de jerarquías diferentes:

        trait X {
         def m: String
        }
        

        trait Y {
         def m: String
        }


        trait A extends X {
          override def m = "A"
        }


        trait B extends Y {
          override def m = "B"
        }


        class C extends A with B
El compilador se quejará nuevamente:


error: overriding method m in trait A of type => java.lang.String;
method m in trait B of type => java.lang.String cannot override a concrete member without a third member that's overridden by both (this rule is designed to preventaccidental overrides'')
Entonces podemos definir en nuestra clase C el método m:


        trait X {
         def m: String
        }


        trait Y {
         def m: String
        }


        trait A extends X {
          override def m = "A"
        }


        trait B extends Y {
          override def m = "B"
        }


        class C extends A with B {
         override def m = super.m
        }
        

        new C().m
        res0: java.lang.String = B``
Y también puede aplicarse al caso inicial:

        trait A {
          def m = "A"
        }


        trait B {
          def m = "B"
        }


        class C extends A with B {
         override def m = super.m
        }


        new C().m
        res0:java.lang.String = B``
## Combinando múltiples Mixins

Hay casos en los que quiero poder utilizar el comportamiento definido en varios mixins a la vez (alguien dijo traits?), pero cuando ellos definen el comportamiento en métodos con la misma firma se pisarán entre ellos por la linearización y no podré usarlos.
En otros lenguajes tenemos herramientas para definir alias a los métodos de los mixins y de esa forma evitar que la linearización me esconda las implementaciones.
Intentemos hacer algo similar en Scala:

        trait A {
          def m = "A"
        }


        trait B {
          def m = "B"
        }


        trait A2 extends A {
         def mA = m
        }


        trait B2 extends B {
         def mB = m
        }


        class C extends A2 with B2 {
         override def m = "C"
         def mix = mA + mB
        }


        new C().mix
``res0: java.lang.String = CC``
¿Qué pasó? El mensaje "m" que definen los traits A2 y B2 se está enviando a una instancia de C.
Ahora, si usamos super en A2 y B2:

        trait A {
          def m = "A"
        }


        trait B {
          def m = "B"
        }


        trait A2 extends A {
         def mA = super.m
        }


        trait B2 extends B {
         def mB = super.m
        }


        class C extends A2 with B2 {
         override def m = "C"
         def mix = mA + mB
        }


        new C().mix
``res0: java.lang.String = AB``
## Escapando de la linearización

Como vimos antes, cuando defino el orden en el que aplico mixins a mis construcciones tengo que tener mucho cuidado con el orden en función de cual de ellos me interesa más porque si hay métodos con la misma firma definidos en varios de ellos, el último mixin ganará y no voy a poder accederlos... o tal vez si.
En Scala vimos que podemos definir nuestro método "m" y llamar a super para que el mixin más proximo lo resuelva, pero lo que no vimos que es además podemos elegir específicamente cual de mis "supers" quiero que se ejecute:

        trait A {
          def m = "A"
        }


        trait B {
          def m = "B"
        }


        class C extends A with B {
         override def m = super[A].m
        }


        new C().m
        res0:java.lang.String = A``
Entonces, retomando el problema anterior, si queremos ejecutar m de A y B podemos hacer:

        trait A {
          def m = "A"
        }


        trait B {
          def m = "B"
        }


        class C extends A with B {
         override def m = super[A].m + super[B].m
        }


        new C().m
        res0:java.lang.String = AB``
Ahora tenemos una herramienta poderosa que nos permite definir cual de mis mixins ejecutar, evitando (en parte) lo que la linearización defina.