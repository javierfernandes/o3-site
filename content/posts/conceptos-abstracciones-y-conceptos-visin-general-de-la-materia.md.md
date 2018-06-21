Lo que nos interesa en esa materia son las abstracciones. Una abstracción es una forma de concebir cualquier entidad programática que nos permite concentrarnos en lo que consideremos esencial, dejando de lado aquello que nos interesa menos (o bien nos interesa menos *en este momento*).


Cabe mencionar que no todo proceso de abstracción es bueno ni malo *en sí.* Al abstraer uno elige determinadas características de una entidad programática y les da visibilidad, descartando otras. Elegir buenas abstracciones es vital para poder manejar la complejidad inherente a construir grandes sistemas de software, porque posibilitan la combinación de las partes de ese sistema sin tener que comprender la totalidad de cada una de ellas.


Probablemente la mayoría de nosotros hayamos comenzado a programar utilizando procedimientos o funciones como nuestras primeras formas de abstraer. Un procedimiento permite agrupar un conjuto de tareas que probablemente se realizan repetitivamente. Al agrupar esas tareas en un procedimiento y ponerles un nombre estoy *inventando *una nueva tarea posible; y eso me permite luego poder utilizar esa tarea sin tener que pensar en los pasos que la componen.


En el paradigma de objetos la primera abstracción que aparece es justamente la de *Objeto, *como una entidad opaca que exhibe un comportamiento a través de mensajes. La abstracción se produce porque yo puedo utilizar el objeto sin necesidad de conocer la forma en que están implementados esos mensajes. Los mensajes forman la interfaz del objeto mientras que los métodos y variables de instancia son la implementación. El hecho de que sólo accedamos al comportamiento del objeto mediante mensajes nos da la idea de encapsulamiento, que está muy relacionado a la idea de abstracción.


En este momento vale la pena hacer la aclaración que ni abstraer ni encapsular implican "esconder". Es un servicio que le estoy dando, no tiene que ver con una cuestión de seguridad. Por eso **lo que se busca no es que sea *imposible* ver los detalles de la implementación, solamente que no sea necesario**.


Luego, las clases nos permiten un nuevo nivel de abstracción; al modelar muchos objetos como instancias de una misma clase estamos diciendo que tienen todos el mismo comportamiento y nos estamos abstrayendo de las diferencias entre ellos. 


Podemos recordar el cuento de Borges, en el que el memorioso Funes recordaba cada detalle de cada caballo que había visto y por eso para él cada caballo era único, no tenía nada en común con los otros que había visto. Funes simplemente no entendía la idea de caballo, de llamar a todas esas cosas distintas de la misma manera; Funes era incapaz de abstraer. 


También el polimorfismo nos permite abstraernos de las diferencias entre múltiples objetos con distinto comportamiento, y tratarlos a todos por igual en algún contexto dado. Por otro lado, la herencia es otra abstracción que nos permite explicitar las similitudes y diferencias entre clases que tienen comportamiento en común. 


Muchas de las abstracciones que mencionamos logran que podamos *compartir código. *Sin embargo no debemos pensar en ese como el principal objetivo de una abstracción, el principal objetivo es **explicitar en el código nuestro conocimiento sobre el dominio**. La no repetición es una consecuencia natural: cuando encontramos buenas abstracciones para describir un dominio, esa descripción logra ser clara, concisa y consistente; las duplicaciones son potenciales fuentes de inconsistencia que siempre trataremos de evitar, y muchas veces nos van a guiar para encontrar la falta de abstracción.


Finalmente, el principal objetivo de esta materia es encontrar la mejor forma de describir cada problema. Vamos a encontrar problemas que no pueden ser correctamente descripto con las abstracciones que manejamos; y vamos a aprender nuevas formas de abstracción que atacan ese tipo de problemas.