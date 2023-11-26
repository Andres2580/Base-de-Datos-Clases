/*
    Ejercicio 8
Mostrar las ventas que hayan sido realizados en Denver o Seattle, y cuyos clientes tengan una edad
menor a 50.
and->dos condiciones que deb cunplirse al mismo tiempo
agrupo->arreglo[]
listas-> storeLocation
ubicacion y edad del usuario
*/
use('demo-sv43')
db.sales.find({
    $and: [
        {storeLocation : {$in : ['Denver', 'Seattle']}},
        {'customer.age': {$lt: 50} }
    ]
})

/*
    MODELADO RELACIONAL + NO RELACIONAL
    4 casos
    5 tablas + 3 colecciones
    30 minutos modelado realcional
    20 consultas simples (select anidados /vistas)
    40 consultas complejas (procedures / triggers)
    30 modelado no relacional /data model patterns / relaciones
    20 consultas mongodb
*/
/*
    Ejercicio 9
    Indicar la cantidad de ventas que hayan sido realizados en Denver o Seattle, y cuyos clientes tengan
una edad menor a 50.
-En seatle y denver se ha vendido en total habido 775 ventas para clientes
q tengan una edad menor a 50 años
*/
use('demo-sv43')
db.sales.find({
    $and: [
        {storeLocation : {$in : ['Denver', 'Seattle']}},
        {'customer.age': {$lt: 50} }
    ]
}).count()

/*
countDocuments: cuenta documentos que cumplan un filtros
- filtros (condiciones)
distinct: muestra los valores distintos de un campo
- campo cuyos valores distintos se quere mostrar
-filtros (condiciones)
*/
use('demo-sv43')
db.sales.countDocuments({
    $and: [
        {storeLocation : {$in : ['Denver', 'Seattle']}},
        {'customer.age': {$lt: 50} }
    ]
})

/*
    AGGREGATE
    son operaciones que se ejecutan de manera secuencial
    $match: filtrar
    $group: agrupar
    $project: definir una estructura de documento
    $sort: ordenar los resultados en base a uno o mas campos

    Ejercicio 12
    Mostrar la cantidad de ventas realizadas por cada metodo de pago
*/
use('demo-sv43')
db.sales.aggregate([
    { $group: {
        '_id': '$storeLocation',
        'quantity' : {$count: {}}
    }},
    {$project: {
        'location': '$_id',
        'quantity': '$quantity',
        '_id': false
    }},
    { $sort: {'quatity':-1}}
])
/*
    Ejercicio 14
Mostrar la cantidad de ventas realizadas en Seattle por cada método de pago. Considerar solo aquellos
métodos de pago que superaron las 100 ventas.
-se filtra con match
*/
use('demo-sv43')
db.sales.aggregate([
    { $match: { storeLocation: 'Seattle'}},
    { 
        $group: {
        '_id': '$purchaseMethod',
        'quantity' : {$count: {}}
    }},
    { $match: { 'quantity': { $gt: 100} }}
])

/*
Coleccion
alojamientos obligatorios:
-titulo: string
-ubicacion: object
-servicios: array (object)
-resenias: array(object)
-anfitrion:object
-precio: double

db.createColection

Relaciones
1 a 1: ubicacion(un alojamiento tiene un...)
1 a 1: anfitrion
1 a muchos: servicio
1 a muchos: resenha

Patrones:
 - subset pattern / reference: en una coleccion diferente se crean
 todas las resenias teniendo un campo como referencia al alojamiento.

 - embeded pattern
 anfitrion
 ubicacion

*/
