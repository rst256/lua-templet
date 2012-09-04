Template preprocessor
=====================

.. module:: templet

.. function:: loadstring(s)

   :param string s: template
   :returns: :class:`templet.Template` object

   Parse template from string.

.. class:: Template

   .. method:: __call__([env[, f]])

      :param table env: template environment
      :param function f: output function

      Render template in given environment using the specified output function.

      If ``env`` is ``nil``, the global environment (``_G``) is used.

      If ``f`` is ``nil``, an output function equivalent to

      .. code-block:: lua

         local result = {}
         local output = function(chunk)
           table.insert(result, tostring(chunk))
         end

      is used, and :meth:`render` returns the result of ``table.concat(result)``.
