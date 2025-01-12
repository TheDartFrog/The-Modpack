--[[
	Copyright (c) 2020 Modpack Team
	Brent Batch#9261
]]--
dofile "../../libs/load_libs.lua"

print("loading LaserSight.lua")


LaserSight = class( nil )
LaserSight.maxChildCount = -1
LaserSight.maxParentCount = -1
LaserSight.connectionInput = sm.interactable.connectionType.logic
LaserSight.connectionOutput = sm.interactable.connectionType.power + sm.interactable.connectionType.logic
LaserSight.colorNormal = sm.color.new(0x222222ff)
LaserSight.colorHighlight = sm.color.new(0x333333ff)
LaserSight.poseWeightCount = 1


function LaserSight.server_onFixedUpdate(self, dt)

	local parents = self.interactable:getParents()
	local active = false
	for k, v in pairs(parents) do active = active or v.active end
	
    if active then
        local hit, fraction = sm.physics.distanceRaycast(self.shape.worldPosition - self.shape.right/50, self.shape.up * 2500)
        if hit then
			self.interactable.power = fraction * 2500 * 4 + 0.5
		end
	else
		self.interactable.power = 0
    end
	if not self.lastpower then self.lastpower = self.interactable.power end
	local deltapower = self.interactable.power - self.lastpower
	self.interactable.active = self.lastdeltapower and self.lastdeltapower - deltapower < -1.5 or false
	self.lastdeltapower = deltapower
	self.lastpower = self.interactable.power
end


function LaserSight.client_onFixedUpdate(self)
	if not sm.exists(self.interactable) then return end
	local parents = self.interactable:getParents()
	local active = false
	for k, v in pairs(parents) do active = active or v.active end
	
    if active then
        local hit, fraction = sm.physics.distanceRaycast(self.shape.worldPosition - self.shape.right/50, self.shape.up * 2500)
        if hit then
		
            self.interactable:setPoseWeight(0, 0.000055 + fraction*1.00002)
        end
    else
		self.interactable:setPoseWeight(0, 0)
	end
end