local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
local beautiful = require("beautiful")

function factory(shape, margins, border_width)
    shape = shape or gears.shape.rounded_bar
    margins = margins or {2, 2, 2, 2}
    border_width = border_width or 1
    local text_widget = wibox.widget {
        font = beautiful.font,
        align  = 'center',
        widget = wibox.widget.textbox
    }

    local progress_bar = wibox.widget {
            max_value     = 100,
            value         = 0,
            border_width = border_width,
            border_color = beautiful.bg_focus,
            background_color = beautiful.bg_normal,
            color = beautiful.bg_focus,
            shape = shape,
            widget = wibox.widget.progressbar
    }

    pb_widget = wibox.widget {
        {

            progress_bar,
            text_widget,
            layout = wibox.layout.stack
        },
        top = margins[0],
        right = margins[1],
        bottom= margins[2],
        left = margins[3],
        width = 100,
        forced_width = 100,
        layout = wibox.container.margin
    }


    local trigger = [[bash -c '
      stdbuf -oL alsactl monitor
    ']]

    local value_cmd = [[bash -c '
      amixer sget Master
    ']]


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
                    progress_bar.border_color = beautiful.bg_minimize
                    progress_bar.color = beautiful.bg_minimize
                else
                    progress_bar.border_color = beautiful.bg_focus
                    progress_bar.color = beautiful.bg_focus
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

