local Vehicle = {}
Vehicle.__index = Vehicle

function Vehicle:New(model)
    local self = setmetatable({}, Vehicle)
    self.vehicle = {model}
    self.isValid = true
    return self
end

function Vehicle:Load()
    -- local hash = joaat(model)
    local model = self.vehicle[1]
    if not IsModelInCdimage(model) or not IsModelAVehicle(model) then
        self.isValid = false
        print("Invalid Vehicle")
        return
    end

    RequestModel(model) 
    while not HasModelLoaded(model) do
        Wait(500) 
    end
    
    self.vehicle[model] = true
    
end

function Vehicle:Spawn()
    local ready = {}

        
    if self.vehicle then
        for i =1, #self.vehicle do
            local veh = self.vehicle[i]
            ready = {veh}
        end
    end
    self.ped = PlayerPedId()
    self.coords = GetEntityCoords(self.ped)

    if ready and self.isValid then
        
        local vehicle = CreateVehicle(ready[1], self.coords.x, self.coords.y, self.coords.z+1, 100, true, false)
        SetPedIntoVehicle(self.ped, vehicle, -1)
        SetVehicleOnGroundProperly(vehicle)
        SetEntityAsNoLongerNeeded(vehicle)
        SetModelAsNoLongerNeeded(ready[1])
        Entity(vehicle).state:set("owner", GetPlayerServerId(PlayerId()), true)
        print(Entity(vehicle).state.owner)
        print(("vehicle %s spawned"):format(ready[1]))
    end
    ready = {}
    self.vehicle = {}
end


RegisterCommand("veh", function(_, a)
    local model = a[1] or "brioso"
    
    local vehicle = Vehicle:New(model)
    vehicle:Load()
    vehicle:Spawn()
 
end, false) /*intellisense hack */

