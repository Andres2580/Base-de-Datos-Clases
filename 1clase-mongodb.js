use demo-sv43
go

db.users.find()
go
db.users.insertOne({username: 'eanaya', name: 'Ernesto Anaya', age: 25 })
db.users.insertOne({username: 'jdoe', name: 'John Doe', age: 'Treinta' })
go
/*
 Crear una colección de estudiantes con los siguientes campos:
    - Nombre, considerando como tipo de dato String
    - Apellido, considerando como tipo de dato String
    - Edad, considerando como tipo de dato Int
    - Carrera, considerando como tipo de dato String
*/
db.createCollection('students', {
    validator: {
        $jsonSchema: {
            bsonType: 'object',
            required: ['firstname', 'lastname', 'age', 'career'],
            properties: {
                firstname: {
                    bsonType: 'string',
                    description: 'Must be a string and is required'
                },
                lastname: {
                    bsonType: 'string',
                    description: 'Must be a string and is required'
                },
                age: {
                    bsonType: 'int',
                    description: 'Must be a int and is required',
                    minimum: 18,
                    maximum: 100
                },
                career: {
                    bsonType: 'string',
                    description: 'Must be a string and is required'
                }
            },
            /*additionalProperties: false - si o so deben tener estos campos y  no mas lo que se ha declarado*/
        }
    }
})

db.students.insertOne({firstname: 'Ernesto', lastname: 'Anaya', age: 25, career: 'Ingeniería de Sistemas de Información'})
db.students.find()


db.students.insertOne({firstname: 'Ernesto', lastname: 'Anaya', age: 25, career: 'Ingeniería de Sistemas de Información'})
db.students.insertOne({firstname: 'John', lastname: 'Doe', age: 17, career: 'Ingeniería de Sistemas de Información'})
db.students.insertOne({firstname: 'Jane', lastname: 'Stevens', age: 18, career: 'Ingeniería de Software', university: 'Universidad de Harvard'})

/*
db.students.insertMany([
    {firstname: 'Ernesto', lastname: 'Anaya', age: 25, career: 'Ingeniería de Sistemas de Información'},
    {firstname: 'John', lastname: 'Doe', age: 19, career: 'Ingeniería de Sistemas de Información'},
    {firstname: 'Jane', lastname: 'Stevens', age: 18, career: 'Ingeniería de Software', university: 'Universidad de Harvard'}
])
*/

db.students.find()

/*
 Crear una colección de cursos con los siguientes campos:
    - Nombre del curso, considerando como tipo de dato String
    - Código del curso, considerando como tipo de dato String
    - Listado de profesores, considerando como tipo de dato Array
*/

db.createCollection('courses', {
    validator: {
        $jsonSchema: {
            bsonType: 'object',
            required: ['name', 'code', 'teachers'],
            properties: {
                name: {
                    bsonType: 'string',
                    description: 'Must be a string and is required'
                },
                code: {
                    bsonType: 'string',
                    description: 'Must be a string and is required'
                },
                teachers: {
                    bsonType: 'array',
                    description: 'Must be a array and is required',
                    items: {
                        bsonType: 'object',
                        required: ['firstname', 'lastname'],
                        properties: {
                            firstname: {
                                bsonType: 'string',
                                description: 'Must be a string and is required'
                            },
                            lastname: {
                                bsonType: 'string',
                                description: 'Must be a string and is required'
                            },
                            contact: {
                                bsonType: 'object',
                                description: 'Must be a object and is required',
                                required: ['email', 'phone']
                            }
                        }
                    }
                }
            },
        }
    }
})

db.courses.insertOne({name: 'MongoDB', code: 'MONGO-101', teachers: [{firstname: 'Ernesto', lastname: 'Anaya'}]})

db.courses.find()
