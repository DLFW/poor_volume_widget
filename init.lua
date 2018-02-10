local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")
local text_widget = wibox.widget.textbox()

local stdout_widget = wibox.widget {
    text_widget,
    layout = wibox.layout.fixed.horizontal,
}


local trigger = [[bash -c '
  stdbuf -oL alsactl monitor
']]

local value_cmd = [[bash -c '
  awk -F"[][]" '"'"'/dB/ { print $2 }'"'"' <(amixer sget Master) | sed "s/%//"
']]

bar_width=20

function value_to_bar(value)
    bars = math.floor(bar_width * value / 100)
--     return tostring(bars)
-- end
    result = "[" .. string.rep("#",bars) .. string.rep(" ",bar_width-bars) .. "]"
    return result
end

function update(trigger_line)
    awful.spawn.easy_async(
        value_cmd,
        function(stdout, stderr, reason, exit_code) 
            --naughty.notify { text = stdout }
            value = tonumber(stdout)
            text_widget:set_text(value_to_bar(value))
            --text_widget:set_text(stdout)
        end
    )
end

awful.spawn.with_line_callback(trigger, {
    stdout = function(line)
        --naughty.notify { text = line }
        update(line)
    end,
    stderr = function(line)
        text_widget:set_text("ERR:"..line)
    end,
})

update(nil)

return stdout_widget

