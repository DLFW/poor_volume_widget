poor volume widget
==================

A simple volume widget for `Awesome WM`_, based on a progress bar showing the Master volume and the muted state.
In contrast to many other volume widgets, it doesn't use polling but reacts event driven. That means that the display is updated as soon as the volume or the muted state changes without any delay.

The poor volume widget depends on the programs ``alsactl`` and ``amixer``. Both must be installed. The first one is used to trigger the update, the latter is used to request the actual values for updating the display.

.. image:: poor_volume_widget_example.png

Colors are taken from the theme:

* The background color is ``beautiful.bg_poor_volume`` or ``beautiful.bg_normal``
* The border color is ``beautiful.border_poor_volume`` or ``beautiful.bg_focus``
* The bar color is ``beautiful.bar_poor_volume`` or ``beautiful.bg_focus``
* The font color is ``beautiful.text_poor_volume`` or ``beautiful.fg_normal``
* When muted, the bar border and filling is ``beautiful.bg_minimize``

As of now, the widget does not support any interaction. This is quite fine for me and I don't plan to add any interactive function.

Installation
------------

Change into your awesome configuration directory (mostly ~/.config/awesome) and clone the project (``git clone https://github.com/DLFW/poor_volume_widget.git``).
Adapt card name in the top section of ``init.lua`` is necessary. (Cmpr. ``cat /proc/asound/cards``)
Import the widget somewhere *after* you've loaded your theme and before you have to use the widget. (Doing it after loading the theme is neccessary to allow the widget to load the themes attributes.)
The import returns a factory function. All paramters are optional. Parameters are:
* background shape (default: rectangle)
* bar shape (default: rounded rectangle)
* margins (list of 4 integers: top, left, bottom, right; default: {5, 4, 5, 4})
* border width (default: 1)

Example:

.. code-block:: lua

    beautiful.init("/home/somebody/.config/awesome/theme.lua")
    local poor_volume_widget = require("poor_volume_widget")(gears.shape.powerline, gears.shape.powerline, {0,0,0,0}, 0)
    
Insert it into your desktop however you want like any other widget. Maybe like this:

.. code-block:: lua

    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            poor_volume_widget,
            mykeyboardlayout,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox,
        },
    }
 
 
.. _`Awesome WM`: https://awesomewm.org

