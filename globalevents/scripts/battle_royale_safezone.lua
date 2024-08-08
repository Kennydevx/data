local safeZoneCenter = {x = 1000, y = 1000, z = 7}  -- Defina as coordenadas do centro da safezone
local safeZoneRadius = 10  -- Defina o raio inicial da safezone
local tileToTransform = 223  -- ID do tile a ser transformado
local newTileId = 712  -- ID do novo tile

function onThink(interval, lastExecution)
    local areaRadius = safeZoneRadius
    for x = safeZoneCenter.x - areaRadius, safeZoneCenter.x + areaRadius do
        for y = safeZoneCenter.y - areaRadius, safeZoneCenter.y + areaRadius do
            local tile = Tile(Position(x, y, safeZoneCenter.z))
            if tile and tile:getGround() and tile:getGround():getId() == tileToTransform then
                tile:getGround():transform(newTileId)
            end
        end
    end

    safeZoneRadius = safeZoneRadius - 1  -- Reduzir o raio a cada execução
    if safeZoneRadius <= 0 then
        stopEvent()  -- Para o evento quando o raio chegar a zero
    end
    return true
end
