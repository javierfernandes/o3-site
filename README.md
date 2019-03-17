# o3-site

Sitio de Objetos 3 en Hugo

# Ejecutar el sitio
Es necesario primero inicializar el submodulo git con el theme que estamos utializando para Hugo (minimo)

# `git submodule init`
# `git submodule update`
# `yarn start`


# Autoindexado

En un momento teníamos un hook que autoindexaba en cada commit el contenido para el buscador. Pero se empezó a romper y empiezan las clases :P Dejo acá el script

```js
  "husky": {
    "hooks": {
      "pre-commit": "yarn build-search-index && ./scripts/update-last-changed && git add ./public"
    }
  },
```