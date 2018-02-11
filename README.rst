poor volume widget
==================

A simple volume widget for `Awesome WM`_, based on a progress bar showing the Master volume and the muted state.
In contrast to many other volume widgets, it doesn't use polling but reacts event driven. That means that the display is updated as soon as the volume or the muted state changes without any delay.

The poor volume widget depends on the programs ``alsactl`` and ``amixer``. Both must be installed. The first one is used to trigger the update, the latter is used to request the actual values for updating the display.

.. image:: poor_volume_widget_example.png

Colors and fonts are taken from the theme:

* The bar border and filling is ``beautiful.bg_focus``
* The background is ``beautiful.bg_normal``
* The font is ``beautiful.font``
* When muted, the bar border and filling is ``beautiful.bg_minimize``

As of now, the widget does not support any interaction. This is quite fine for me and I don't plan to add any interactive function.
 
 
.. _`Awesome WM`: https://awesomewm.org

