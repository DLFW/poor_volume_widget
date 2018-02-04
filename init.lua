local wibox = require("wibox")
local awful = require("awful")
local brightness_text = wibox.widget.textbox()
-- brightness_text:set_font('Play 9')

-- local brightness_icon = wibox.widget {
--     {
--     	image = path_to_icons .. "display-brightness-symbolic.svg",
--     	resize = false,
--         widget = wibox.widget.imagebox,
--     },
--     top = 3,
--     widget = wibox.container.margin
-- }

brightness_text:set_text("foo!")

local brightness_widget = wibox.widget {
--    brightness_icon,
    brightness_text,
    layout = wibox.layout.fixed.horizontal,
}

local noisy = [[bash -c '
  tail -f /home/daniel/noisy
']]

awful.spawn.with_line_callback(noisy, {
    stdout = function(line)
        brightness_text:set_text(line)
    end,
    stderr = function(line)
        brightness_text:set_text("ERR:"..line)
    end,
})

return brightness_widget
