### commandbox-apiman

Apiman is a curl-like application that can be executed from the commandbox commandline.

#### Installation:

```bash
box install commandbox-apiman
```

#### Usage

```bash
apiman <verb> <url>
```

#### Flags

Supported commandline flags
* **-q**: Query params - Set a semicolon separated list of query params for the request.
* **-c**: Cookies - Set a semicolon separated list of cookies for the request.
* **-h**: Headers - Set a semicolon separated list of headers for the request.
* **-f**: Form Fields - Set a semicolon separated list of form fields for the request. Only valid for POST/PUT operations.
* **-d**: Data - Set raw data for the body of a request. Only valid for POST/PUT operations.
* **-u**: User - Set the username for the request.
* **-p**: Passord - Set the password for the request.
* **-showHeaders**: Shows the response headers for the request.


`❯ apiman get https://jsonplaceholder.typicode.com/todos/1`
```json
{
    "userId":1,
    "id":1,
    "title":"delectus aut autem",
    "completed":false
}
```

If you need to pass query parameters you can either wrap the url in quotes to pass the query string or you may use the 
`query` paraameter to pass a list of semicolon seperated parameters.

`❯ apiman get "https://jsonplaceholder.typicode.com/comments?postId=1"` 

Can also be expressed as:

`❯ apiman get -q "postId=1" https://jsonplaceholder.typicode.com/comments`
```json
[
    {
        "postId":1,
        "id":1,
        "name":"id labore ex et quam laborum",
        "email":"Eliseo@gardner.biz",
        "body":"laudantium enim quasi est quidem magnam voluptate ipsam eos\ntempora quo necessitatibus\ndolor quam autem quasi\nreiciendis et nam sapiente accusantium"
    },
    {
        "postId":1,
        "id":2,
        "name":"quo vero reiciendis velit similique earum",
        "email":"Jayne_Kuhic@sydney.com",
        "body":"est natus enim nihil est dolore omnis voluptatem numquam\net omnis occaecati quod ullam at\nvoluptatem error expedita pariatur\nnihil sint nostrum voluptatem reiciendis et"
    },
    {
        "postId":1,
        "id":3,
        "name":"odio adipisci rerum aut animi",
        "email":"Nikita@garfield.biz",
        "body":"quia molestiae reprehenderit quasi aspernatur\naut expedita occaecati aliquam eveniet laudantium\nomnis quibusdam delectus saepe quia accusamus maiores nam est\ncum et ducimus et vero voluptates excepturi deleniti ratione"
    },
    {
        "postId":1,
        "id":4,
        "name":"alias odio sit",
        "email":"Lew@alysha.tv",
        "body":"non et atque\noccaecati deserunt quas accusantium unde odit nobis qui voluptatem\nquia voluptas consequuntur itaque dolor\net qui rerum deleniti ut occaecati"
    },
    {
        "postId":1,
        "id":5,
        "name":"vero eaque aliquid doloribus et culpa",
        "email":"Hayden@althea.biz",
        "body":"harum non quasi et ratione\ntempore iure ex voluptates in ratione\nharum architecto fugit inventore cupiditate\nvoluptates magni quo et"
    }
]
```

### Posting JSON data to a service

`❯ apiman post http://localhost:8000/ui/auth/login -h "Content-Type=application/json" -d '{username : "admin", password : "commandbox" }'`
```json
{
    "data":{
        "isIdentified":true,
        "user":"admin"
    },
    "error":false,
    "pagination":{
        "totalPages":1,
        "maxRows":0,
        "offset":0,
        "page":1,
        "totalRecords":0
    },
    "messages":[]
}
```

### Passing a username and password with a request

`❯ apiman get https://api.stripe.com/v1/charges -u "YOUR_USERNAME_HERE"`

```json
{
  "object": "list",
  "count": 45,
  "data": [
    ...
  ]
}
```

