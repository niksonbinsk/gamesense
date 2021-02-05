

local function DEG2RAD(x) return x * math.pi / 180 end
local function RAD2DEG(x) return x * 180 / math.pi end

local function hsv2rgb(h, s, v, a)
    local r, g, b

    local i = math.floor(h * 6);
    local f = h * 6 - i;
    local p = v * (1 - s);
    local q = v * (1 - f * s);
    local t = v * (1 - (1 - f) * s);

    i = i % 6

    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end

    return r * 255, g * 255, b * 255, a * 255
end

local rainbow = 0.00
local rotationdegree = 0.000;

local function draw_svaston(x, y, size)

    local frametime = globals.frametime()
    local a = size / 60
    local gamma = math.atan(a / a)
    rainbow = rainbow + (frametime * 0.5)
    if rainbow > 1.0 then rainbow = 0.0 end
    if rotationdegree > 89 then rotationdegree = 0 end

    for i = 0, 4 do
        local p_0 = (a * math.sin(DEG2RAD(rotationdegree + (i * 90))))
        local p_1 = (a * math.cos(DEG2RAD(rotationdegree + (i * 90))))
        local p_2 =((a / math.cos(gamma)) * math.sin(DEG2RAD(rotationdegree + (i * 90) + RAD2DEG(gamma))))
        local p_3 =((a / math.cos(gamma)) * math.cos(DEG2RAD(rotationdegree + (i * 90) + RAD2DEG(gamma))))

        renderer.line(x, y, x + p_0, y - p_1, hsv2rgb(rainbow, 1, 1, 1))
        renderer.line(x + p_0, y - p_1, x + p_2, y - p_3, hsv2rgb(rainbow, 1, 1, 1))
    end
    rotationdegree = rotationdegree + (frametime * 150)
end

local crosshair = cvar.crosshair
local old_crosshair = crosshair:get_int()
crosshair:set_int(0)

client.set_event_callback("shutdown", function()
    crosshair:set_int(old_crosshair)
end)

client.set_event_callback("paint", function()
    local height, width = client.screen_size()
    
    draw_svaston(height / 2, width / 2, width / 2)
end)

