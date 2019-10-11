# -*- coding: utf-8 -*-
"""
Command to clear build directory, copy this file to the correct folder and then build a test document
rm /tmp/test.pdf; rm -rf /tmp/build/*; sudo cp ~/atomone.py /usr/lib/python3.6/site-packages/pygments/styles/.;lualatex --shell-escape --output-directory=build test.tex; okular build/test.pdf

This highlighting scheme goes well with the following pygments lexer: https://github.com/sisl/pygments-julia
"""

from pygments.style import Style
from pygments.token import Keyword, Name, Comment, String, Error, \
     Number, Operator, Generic, Whitespace


class AtomoneStyle(Style):
    """
    Bagge's style
    """
    default_style = ''
    background_color = '#f0f3f3'

    styles = {
        Whitespace:         '#bbbbbb',
        Comment:            'italic #A2A2A2',
        Comment.Preproc:    'noitalic #A2A2A2',
        Comment.Special:    'bold',

        Keyword:            'bold #AD00AC', # function, for, if
        Keyword.Pseudo:     'nobold',
        Keyword.Type:       '#008491',

        Operator:           '#555555',
        Operator.Word:      'bold #FF0000',# Does not seem to be used

        Name.Builtin:       '#008491', # Both these should be set to same
        Name.Function:      '#0064BB', # Both these should be set to same
        Name.Class:         'bold #000000',
        Name.Namespace:     'bold #FF0000',# Does not seem to be used
        Name.Exception:     'bold #CC0000',
        Name.Variable:      '#000000',
        Name.Constant:      '#000000',
        Name.Label:         '#FF0000',
        Name.Entity:        'bold #999999',
        Name.Attribute:     '#330000',
        Name.Tag:           'bold #FF0000',
        Name.Decorator:     '#9999FF',

        String:             '#BBDB00', # This is used for strings
        String.Doc:         'italic',
        String.Interpol:    '#AA0000', # Used for itnerpolations
        String.Escape:      'bold #CC3300',
        String.Regex:       '#33AAAA',
        String.Symbol:      '#FFCC33',
        String.Other:       '#CC3300',

        Number:             '#FF6600',

        Generic.Heading:    'bold #1A3300',
        Generic.Subheading: 'bold #003300',
        Generic.Deleted:    'border:#CC0000 bg:#FFCCCC',
        Generic.Inserted:   'border:#00CC00 bg:#CCFFCC',
        Generic.Error:      '#D60000',
        Generic.Emph:       'italic',
        Generic.Strong:     'bold',
        Generic.Prompt:     'bold #078600',
        Generic.Output:     '#787878',
        Generic.Traceback:  '#787878',

        Error:              'bg:#FFAAAA #AA0000'
    }
# # # rm -rf /tmp/build/*; sudo cp ~/atomone.py /lib64/python2.7/site-packages/pygments/styles/.;lualatex --output-directory=build --shell-escape test.tex; okular build/test.pdf
