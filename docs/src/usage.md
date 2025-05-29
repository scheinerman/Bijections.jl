# Using `Bijections`

```@setup example
using Bijections
```

## Adding and deleting key/value pairs

Once a `Bijection`, `b`, is created, we add a new key-value pair in
the same manner as with a `Dict`:

```@repl example
b = Bijection{Int, String}();
b[1] = "hello"
b[2] = "bye"
```
Notice, however, that if we add a new key with a value that already
exists in the `Bijection` an error ensues:

```@repl example
b[3] = "hello"
```

On the contrary, if a key already has a value it can be changed by giving
it a new value as long as it doesn't break bijectiveness (i.e. the new
value is not already in the `Bijection`):

```@repl example
b[1] = "ciao"
```

## Accessing values from keys, and keys from values

To access a value associated with a given key, we use the same syntax
as for a `Dict`:

```@repl example
b[1]
b[2]
```

If the key is not in the `Bijection` an error is raised:

```@repl example
b[3]
```

Since the values in a `Bijection` must be distinct, we can give a
value as an input and retrieve its associate key. The function
`inverse(b,y)` finds the value `x` such that `b[x]==y`. However, we
provide the handy short cut `b(y)`:

```@repl example
b("bye")
b("ciao")
```

Naturally, if the requested value is not in the `Bijection` an error
is raised:

```@repl example
b("hello")
```

In order to access the domain and image sets of the `Bijection`, one can
use the `Base.keys` and `Base.values` functions.

```@repl example
keys(b)
values(b)
```

The `collect` function returns the `Bijection` as an array of
key-value pairs:

```@repl example
collect(b)
```

The `length` function returns the number of key-value pairs:

```@repl example
length(b)
```

The `isempty` function returns `true` exactly when the `Bijection`
contains no pairs:

```@repl example
isempty(b)
```

