### []()Ruby & Rails

Vemos un poco de ruby on rails.
Generamos el scaffold para una nueva entidad, y vemos un poco el código generado para especificar la DB, específicamente la especificación de la creación de la tabla. Llamados objetos Migrators.



        class `CreatePosts < ActiveRecord::Migration`
              `def` `self``.up`
                `create_**table** ``:**posts**` `do` `|t|`
                  `t.string ``:**name**`
                  `t.string ``:**title**`
                  `t.text ``:**content**`
     
                  `t.**timestamps**`
                `end`
              `end`
     
              `def` `self``.down`
                `drop_table ``:posts`
              `end`
            end
Es UN DSL!

Luego vemos las entidades de dominio generadas.



        class `**Post** < ActiveRecord::Base`
          `**validates** ``:**name**``,  ``:**presence**` `=> ``true`
          `validates ``:**title**``, ``:presence` `=> ``true``,`
                     `:**length**` `=> { ``:**minimum**`** `=> ``5`** `}`
        end
Vemos acá un par de cosas:

* "validates" es un **método de clase**, heredado de ActiveRecord
* sin embargo, **con el juego de la sintaxis parecería una sentecia declarativa** del estilo *"validar que la longitud de title sea como mínimo 5"*
* es código ruby normal, solo que estos métodos son parte del "paquete" rails.
* estas declaraciones involucran comportamiento y complejidades que quedan "ocultas" tras esos métodos. Por ejemplo, 

 * validaciones a nivel de pantalla en la ui.
 * validaciones a nivel de persistencia de las entiedades (title length >= 5)

Ejemplo de uso:




        >> p = **Post.new**(:content => "A new post")
        => #<Post id: nil, name: nil, title: nil,
             `content: "A new post", created_at: nil,`
             `updated_at: nil>`
        >> **p.save**

        => false
        >> p.**errors**

        => #<OrderedHash { :**title**=>[**"can't be blank"**,
                                   `**"is too short (minimum is 5 characters)"**],`
                           `:**name**=>[**"can't be blank"**] }>


        Vemos ahora las asociaciones entre los modelos, es decir, las "relaciones"
        


 class` `**Post **< ActiveRecord::Base`
           `**has_many** ``:**comments**`
         end


         class `**Comment** < ActiveRecord::Base`
           `**belongs_to** ``:**post**`
         end

Post **has_many :comments**


* hace varias cosas a través de metaprogramación, gracias a que es dinámico (o son checkeos en tiempo de compilación), y tiene bloques...

 * agrega dos variables a Post y a Comment
 * genera código para mantener sincronizadas las properties.
 * agrega ciertas otras reglas de acuerdo a la relacion (por ejemplo si es una agregación)
 * utiliza inferencia sobre el nombre "comments" para traducir a singular y buscar el nombre de la clase "Comment"
 * etc.
* a pesar de hacer todo esto,

 * nosotros no lo vemos
 * ni lo hacemos manualmente.
* sin embargo, mantiene la declaratividad (has many comments), y "esconde" las complejidades del modelo subyacente (validaciones, creación de los scripts de db, etc).