Templet for Lua
===============

Templet is a template preprocessor written in pure Lua, which parses text
templates with embedded Lua statements and Lua expressions. Templet works
with Lua 5.1, Lua 5.2 and `LuaJIT`_.

.. _LuaJIT: http://luajit.org/

Consider the example of a system of non-interacting classical particles.
We would like to generate C code that moves the particles by a given time
step. This should work for both 2 and 3 dimensional systems, and constant
parameters should be substituted along the way.

First, the template is parsed, e.g., from a multi-line Lua string:

.. code-block:: lua

   local temp = templet.loadstring([[
   for (int i = 0; i < ${nparticle}; ++i) {
     |for i = 1, #coord do
     r[i].${coord[i]} = r[i].${coord[i]} + v[i].${coord[i]} * ${timestep};
     |end
   }
   ]])

The template is then rendered, given a set of parameters:

.. code-block:: lua

   local env = {coord = {"x", "y", "z"}, nparticle = 5000, timestep = 0.001}
   print(temp(env))

In the resulting output, the loop has been expanded, and constants substituted:

::

   for (int i = 0; i < 5000; ++i) {
     r[i].x = r[i].x + v[i].x * 0.001;
     r[i].y = r[i].y + v[i].y * 0.001;
     r[i].z = r[i].z + v[i].z * 0.001;
   }

.. code-block:: lua

   local env = {coord = {"x", "y"}, nparticle = 1000, timestep = 0.002}
   print(temp(env))

The same template can be rendered, e.g., for a 2-dimensional system:

::

   for (int i = 0; i < 1000; ++i) {
     r[i].x = r[i].x + v[i].x * 0.002;
     r[i].y = r[i].y + v[i].y * 0.002;
   }

The resulting C code could be passed to an OpenCL compiler for just-in-time
compilation, and execution on a GPU or similar floating-point accelerator.

Reference
---------

.. toctree::
   :maxdepth: 2

   reference/index

Installation
------------

Templet is available from a `git repository`_::

   git clone http://git.colberg.org/lua-templet.git

.. _git repository: http://git.colberg.org/lua-templet.git

Tutorial
--------

Templates may contain Lua statements and Lua expressions.

A statement is prefixed with ``|``, and extends to the end of the line::

   |for i = 1, 10 do
   |  if i > 5 then
   Hello, World!
   |  end
   |end

Note that a statement may be preceded by whitespace only.

An expression is enclosed with ``${}``, and may appear anywhere on a line::

   ${hello}, ${world}!

A template is parsed using :func:`templet.loadstring`:

.. code-block:: lua

   local templet = require("templet")

   local temp = templet.loadstring([[
   |for i = 1, 10 do
   |  if i > 5 then
   Hello, World!
   |  end
   |end
   ]])

Alternatively, a template is loaded from a file using :func:`templet.loadfile`.

This creates a template object, which is then rendered:

.. code-block:: lua

   local result = temp()
   print(result)

::

   Hello, World!
   Hello, World!
   Hello, World!
   Hello, World!
   Hello, World!

By default, a template is rendered in the global environment (``_G``),
i.e. variables in the template reference global variables. To substitute
variables with values, the environment may be set by passing a table as
the first argument:

.. code-block:: lua

   local temp = templet.loadstring([[${hello}, ${world}!]])
   print(temp({hello = "Hallo", world = "Welt"}))
   print(temp({hello = "你好", world = "世界"}))

::

   Hallo, Welt!
   你好, 世界!

A template is rendered and returned as a string by default. Alternatively,
an output function may be specified as the second argument, which is repeatedly
called for the set of chunks that yield the rendered template.

.. code-block:: lua

   local temp = templet.loadstring([[
   |for i = 1, 3 do
   double x${i} = ${math.sqrt(i)};
   |end
   ]])
   temp({math = math}, io.write)

::

   double x1 = 1;
   double x2 = 1.4142135623731;
   double x3 = 1.7320508075689;

Suppose we wish to substitute floating-point values in a template using
hexadecimal floating-point constants, which are an exact representation of
binary values. We pass an output function that checks whether a chunk is a
floating-point number, and converts to its hexadecimal representation:

.. code-block:: lua

   local result = {}

   local output = function(chunk)
     if type(chunk) == "number" and math.floor(chunk) ~= chunk then
       table.insert(result, string.format("%a", chunk))
     else
       table.insert(result, tostring(chunk))
     end
   end

   temp({math = math}, output)
   print(table.concat(result))

::

   double x1 = 1;
   double x2 = 0x1.6a09e667f3bcdp+0;
   double x3 = 0x1.bb67ae8584caap+0;

(Note that hexadecimal constants require Lua 5.2 or LuaJIT.)


Acknowledgements
----------------

I would like to thank Rici Lake for writing the `Slightly Less Simple Lua
Preprocessor <http://lua-users.org/wiki/SlightlyLessSimpleLuaPreprocessor>`_
example, which provided the basis of the Templet parser, as well as Michal
Januszewski and the `Sailfish <http://sailfish.us.edu.pl>`_ contributors for
providing a real-world example of dynamically compiled GPU code templates in
a simulation code.
