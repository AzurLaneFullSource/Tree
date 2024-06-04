ys = ys or {}

local var0 = ys
local var1 = class("AutoPilotStay", var0.Battle.IPilot)

var0.Battle.AutoPilotStay = var1
var1.__name = "AutoPilotStay"

function var1.Ctor(arg0, ...)
	var1.super.Ctor(arg0, ...)
end

function var1.GetDirection(arg0)
	if arg0:IsExpired() then
		arg0:Finish()
	end

	return Vector3.zero
end
