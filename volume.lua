local wibox = require("wibox")
local awful = require("awful")

volume_widget = wibox.widget.textbox()
volume_widget:set_align("awful")

function update_volume(widget)
    local fd = io.popen("amixer sget Master")
    local status = fd:read("*all")
    fd:close()

    -- local volume - tonumber(string.match(status, "(%d?%d?%d)%%")) / 100
    local volume = string.match(status, "(%d?%d?%d)%%")
    volume = string.format("% 3d", volume)

    status = string.match(status, "%[(o[^%]]*)%]")

    if string.find(status, "on", 1, true) then
        -- For the volume numbers
        volume = volume .. "%"
    else
        volume = volume .. "M"
    end
    widget:set_markup(volume)
end

volume_widget:buttons(awful.util.table.join(
        awful.button({ }, 1, function () awful.util.spawn("pavucontrol") end)
    ))
update_volume(volume_widget)

mytimer = timer( { timeout = 0.2 })
mytimer:connect_signal("timeout", function () update_volume(volume_widget) end)
mytimer:start()
