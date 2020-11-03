local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
local beautiful = require("beautiful")

local card = "PCH"

function factory(shape, inner_shape, margins, border_width, width)
    shape = shape or gears.shape.rounded_bar
    inner_shape = inner_shape or gears.shape.rectangle
    margins = margins or {5, 4, 5, 4}
    border_width = border_width or 1
    width = width or 100
    local text_widget = wibox.widget {
        font = beautiful.font,
        align  = 'center',
        widget = wibox.widget.textbox
    }

    local progress_bar = wibox.widget {
            max_value     = 100,
            value         = 0,
            border_width = border_width,
            border_color = beautiful.border_poor_volume or beautiful.bg_focus,
            background_color = beautiful.bg_poor_volume or beautiful.bg_normal,
            color = beautiful.bar_poor_volume or beautiful.bg_focus,
            shape = shape,
            bar_shape = inner_shape,
            widget = wibox.widget.progressbar
    }

    local pb_widget = wibox.widget {
        {
            progress_bar,
            {
                text_widget,
                widget = wibox.container.background,
                fg = beautiful.text_poor_volume or beautiful.fg_normal
            },
            layout = wibox.layout.stack,
        },
        top = margins[1],
        right = margins[2],
        bottom= margins[3],
        left = margins[4],
        width = width,
        forced_width = width,
        layout = wibox.container.margin,
    }

    local trigger = string.format([[bash -c '
      stdbuf -oL alsactl monitor hw:%s
    ']], card)

    local value_cmd = string.format([[bash -c '
      amixer -D "hw:%s" sget Master
    ']], card)

    function update(trigger_line)
        awful.spawn.easy_async(
            value_cmd,
            function(stdout, stderr, reason, exit_code)
                value_string = string.match(string.match(stdout,"%d+%%"),"%d*")
                local muted = false
                if string.find(stdout, "%[off%]") then
                    muted = true
                end
                value = tonumber(value_string)
                text_widget:set_text(value_string .. "%" .. (muted and " (mute)" or ""))
                progress_bar.value = value
                if muted then
                    progress_bar.border_color = beautiful.border_muted_poor_volume or beautiful.bg_minimize
                    progress_bar.color = beautiful.bar_muted_poor_volume or beautiful.bg_minimize
                else
                    progress_bar.border_color = beautiful.border_poor_volume or beautiful.bg_focus
                    progress_bar.color = beautiful.bar_poor_volume or beautiful.bg_focus
                end
            end
        )
    end

    awful.spawn.with_line_callback(trigger, {
        stdout = function(line)
            update(line)
        end,
        stderr = function(line)
            text_widget:set_text("ERR:"..line)
        end,
    })

    update(nil)

    return pb_widget
end

return factory

