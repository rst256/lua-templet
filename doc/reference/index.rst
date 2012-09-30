Template preprocessor
=====================

.. module:: templet

.. function:: loadstring(s)

   :param string s: template
   :returns: :class:`templet.Template` object

   Parse template from string.

.. function:: loadfile(filename)

   :param string filename: template filename
   :returns: :class:`templet.Template` object

   Parse template from file.

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
           if chunk ~= nil then
             table.insert(result, tostring(chunk))
           end
         end

      is used, and :meth:`render` returns the result of ``table.concat(result)``.
