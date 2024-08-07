local uniqueIdToCheck = 13550
local newItemId = 2160
local centerPosition = {x = 1000, y = 1000, z = 7}  -- Defina a posição central inicial

-- Função para obter todos os tiles com o uniqueid especificado
function getTilesWithUniqueId(fromPos, toPos, uniqueId)
    local tiles = {}
    for x = fromPos.x, toPos.x do
        for y = fromPos.y, toPos.y do
            local tilePos = {x = x, y = y, z = fromPos.z}
            local tile = Tile(tilePos)
            if tile then
                local items = tile:getItems()
                for _, tileItem in ipairs(items) do
                    if tileItem and tileItem:getAttribute(ITEM_ATTRIBUTE_UNIQUEID) == uniqueId then
                        table.insert(tiles, tilePos)
                    end
                end
            end
        end
    end
    return tiles
end

-- Função para encontrar o ponto central do círculo de tiles
function findCenterPoint(tiles)
    local totalX, totalY = 0, 0
    for _, pos in ipairs(tiles) do
        totalX = totalX + pos.x
        totalY = totalY + pos.y
    end
    local centerX = math.floor(totalX / #tiles)
    local centerY = math.floor(totalY / #tiles)
    return {x = centerX, y = centerY, z = tiles[1].z}
end

-- Função para transformar os tiles gradualmente até restar apenas um
function closeSafeZoneStep(tiles, centerPos)
    if #tiles > 1 then
        -- Encontra o tile mais distante do centro e o transforma
        local farthestTile, maxDistance = nil, -1
        for _, pos in ipairs(tiles) do
            local distance = math.sqrt((pos.x - centerPos.x)^2 + (pos.y - centerPos.y)^2)
            if distance > maxDistance then
                farthestTile = pos
                maxDistance = distance
            end
        end

        if farthestTile then
            local tile = Tile(farthestTile)
            if tile then
                local items = tile:getItems()
                for _, tileItem in ipairs(items) do
                    if tileItem and tileItem:getAttribute(ITEM_ATTRIBUTE_UNIQUEID) == uniqueIdToCheck then
                        tileItem:transform(newItemId)
                        break
                    end
                end
            end

            -- Remove o tile transformado da lista
            for i, pos in ipairs(tiles) do
                if pos.x == farthestTile.x and pos.y == farthestTile.y then
                    table.remove(tiles, i)
                    break
                end
            end
        end

        -- Chama a função novamente após um intervalo
        addEvent(closeSafeZoneStep, 1000, tiles, centerPos)
    else
        print("Apenas um sqm restante.")
    end
end

-- Função para iniciar o fechamento da safezone
function startSafeZone()
    local fromPos = {x = 990, y = 990, z = 7}
    local toPos = {x = 1010, y = 1010, z = 7}
    local tiles = getTilesWithUniqueId(fromPos, toPos, uniqueIdToCheck)
    if #tiles > 0 then
        local centerPos = findCenterPoint(tiles)
        closeSafeZoneStep(tiles, centerPos)
    else
        print("Nenhum tile encontrado com o uniqueid especificado.")
    end
end
