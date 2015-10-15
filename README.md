Bijections
==========

This package provides a `Bijection` data type for Julia. Please see
the accompanying file `Bijections.pdf` in the `doc` folder for full
details.

**Warning!** I have not updated the documentation for `Bijections`
since upgrading to Julia 0.4.

Synopsis
--------

A `Dict` in Julia is not one-to-one. Two different keys might have the
same value. This data structure behaves just like a `Dict` except it
blocks assigning the same value to two different keys.

