use('demo-sv43')
db.sales.find({ 'customer.age': { $gt: 30}})

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
        {'customer.age': {&lt: 30} }
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
        {'customer.age': {&lt: 30} }
    ]
}).count()
