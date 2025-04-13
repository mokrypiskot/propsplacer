local MAX_REFRESH_TIMECOUNT = 100

local function loadProp(propData)
    Citizen.CreateThread(function()
        local propHash = GetHashKey(propData.model)

        RequestModel(propHash)

        local timeoutCount = 0

        while not HasModelLoaded(propHash) and timeoutCount < MAX_REFRESH_TIMECOUNT do
            timeoutCount = timeoutCount + 1
            Citizen.Wait(100)
        end

        if HasModelLoaded(propHash) then
            local object = CreateObject(propHash, propData.position.x, propData.position.y, propData.position.z, false, true, true)
            SetEntityRotation(object, propData.rotation.x, propData.rotation.y, propData.rotation.z, 2, true)
            FreezeEntityPosition(object, true)
            SetEntityAsMissionEntity(object, true, true)
        end
    end)
end

for _, propData in pairs(Config.props) do
    loadProp(propData)
end
