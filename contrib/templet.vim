" Vim syntax file for Templet preprocessor.
" Copyright © 2012–2015 Peter Colberg.
" Distributed under the MIT license. (See accompanying file LICENSE.)
"
" This file may be used to extend the syntax highlighting of any
" language. For example, to highlight Templet statements in OpenCL
" files, copy this file to ~/.vim/after/syntax/opencl/templet.vim

syn region templetLine		matchgroup=Operator start="^\s*|" end="$"
syn region templetCondNest	start=/{/ end=/}/ contained transparent contains=templetCondNest
syn region templetExpr		matchgroup=Operator start="\${" end="}" contains=templetCondNest

hi def link templetLine		PreProc
hi def link templetExpr		PreProc
