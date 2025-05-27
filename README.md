# Bijections


## New in version 0.2

* The `domain` and `image` functions now return iterators [breaking].
* The `Bijection` data structure has been simplified.
* Option to use `IdDict` instead of `Dict`; see the Mutable page in this documentation. 

It is likely that code using version 0.1 will not need to be modified to work with 0.2.

## About

Julia dictionaries are not one-to-one. That is, two different keys might have the same value. 
A `Bijection` data structure behaves just like a dictionary, except it prevents the assignment of the same value to two different keys.

See [the documentation](https://docs.juliahub.com/General/Bijections/stable/).