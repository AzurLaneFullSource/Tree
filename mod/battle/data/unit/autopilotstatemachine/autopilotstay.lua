ys = ys or {}

local var0_0 = ys
local var1_0 = class("AutoPilotStay", var0_0.Battle.IPilot)

var0_0.Battle.AutoPilotStay = var1_0
var1_0.__name = "AutoPilotStay"

function var1_0.Ctor(arg0_1, ...)
	var1_0.super.Ctor(arg0_1, ...)
end

function var1_0.GetDirection(arg0_2)
	if arg0_2:IsExpired() then
		arg0_2:Finish()
	end

	return Vector3.zero
end
