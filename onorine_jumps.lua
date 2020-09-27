-- Tracks if position logging is enabled
local position_logging_enabled = false;
local last_position = nil

-- Create a new frame
local frame = CreateFrame("FRAME")

-- Event handler for `OnUpdate` events
function frame:OnUpdate(event, arg1)
    if position_logging_enabled then
        local x, y, z, map_id = UnitPosition("player");
        local pos = "LOC_" .. x .. "_" .. y .. "_" .. z ..
            "_" .. map_id;

        if pos ~= last_position then
            table.insert(PlayerPosition, pos .. "_" .. GetTime())
        end

        last_position = pos
    end
end

frame:SetScript("OnUpdate", frame.OnUpdate)

SLASH_LOGPOS1     = "/logpos"
SLASH_ANGLESTORE1 = "/anglestore"
SLASH_ANGLE1      = "/angle"

latched_angle = 0.0

SlashCmdList["ANGLESTORE"] = function(msg)
    latched_angle = GetPlayerFacing()
end

SlashCmdList["ANGLE"] = function(msg)
    relative = ((GetPlayerFacing() - latched_angle) / (2 * 3.1415926)) * 360
    print("Angle changed by " .. relative)
end

SlashCmdList["LOGPOS"] = function(msg)
    if position_logging_enabled == false then
        print("Player position logging enabled")
        PlayerPosition = {}
        position_logging_enabled = true
    else
        print("Player position logging disabled")
        position_logging_enabled = false
    end
end

