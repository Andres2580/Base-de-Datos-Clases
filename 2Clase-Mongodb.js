
/*
    find
    Metodo que permite realizar consultas. Puede recibir dos parametros 
    - filtros
    - campos a mostrar por cada documento (proyeccion)
*/
use('demo-sv43');

/*
    Ejercicio 1
    Mostrar todas las ventas.
*/
use('demo-sv43')
db.sales.find()
/*
    Ejercicio 2
    Mostrar las ventas realizadas en línea
*/
use('demo-sv43')
db.sales.find({purchaseMethod: 'Online'})
/*
    Ejercicio 3
    Mostrar las ventas realizadas en líneas y en la ubicación de Denver
*/
use('demo-sv43')
db.sales.find({purchaseMethod: 'Online', 
storeLocation: 'Denver'})

use('demo-sv43')
db.sales.find({
    $and: [
        {purchaseMethod: 'Online'}, 
        {storeLocation: 'Denver'}]
})
/*
    Ejercicio 4
    Mostrar las ventas realizadas en Denver o Seattle
*/
use('demo-sv43')
db.sales.find({
    $or: [
        {storeLocation: 'Denver'}, 
        {storeLocation: 'Seattle'}
    ]
})

use('demo-sv43')
db.sales.find({storeLocation: { $in: ['Denver', 'Seattle']}})
/*
    Ejercicio 4.1
    Mostrar las ventas realizadas en ubicaciones distintas a Denver y Seattle
*/
use('demo-sv43')
db.sales.find({
    $and: [
        {storeLocation: { $ne: 'Denver'}}, 
        {storeLocation: { $ne: 'Seattle'}}
    ]
})

use('demo-sv43')
db.sales.find({storeLocation: { $nin: ['Denver', 'Seattle']}})
/*
    Ejercicio 5
    Mostrar por cada venta solo el lugar donde se realizó.
*/
use('demo-sv43')
db.sales.find({},{storeLocation: 1, _id:0})
/*
    Ejercicio 6
    Mostrar por cada venta el género y la edad del cliente
*/
use('demo-sv43')
db.sales.find({}, {'customer.gender':1, 'customer.age': 1, _id: 0}).
projection({'gender': '$customer.gender', 'age': '$customer.age', _id: 0})
/*
    Ejercicio 7
    Mostrar las ventas cuyos clientes tenga una edad mayor a 30.
*/
use('demo-sv43')
db.sales.find({ 'customer.age': { $gt: 30}})
