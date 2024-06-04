ys = ys or {}
ys.Battle.BattleFleetAttrComponent = class("BattleFleetAttrComponent")
ys.Battle.BattleFleetAttrComponent.__name = "BattleFleetAttrComponent"

local var0 = ys.Battle.BattleFleetAttrComponent
local var1 = ys.Battle.BattleConst
local var2 = ys.Battle.BattleConfig
local var3 = ys.Battle.BattleEvent

function var0.Ctor(arg0, arg1)
	arg0._client = arg1

	arg0:initFleetAttr()
end

function var0.Dispose(arg0)
	arg0._client = nil
end

function var0.initFleetAttr(arg0)
	arg0._fleetAttrList = {}
end

function var0.GetCurrent(arg0, arg1)
	return arg0._fleetAttrList[arg1] or 0
end

function var0.SetCurrent(arg0, arg1, arg2)
	local var0 = arg0:GetCurrent(arg1)
	local var1 = var2.FLEET_ATTR_CAP[arg1]

	if var1 then
		arg2 = Mathf.Clamp(arg2, 0, var1)
	else
		arg2 = math.max(arg2, 0)
	end

	arg0._fleetAttrList[arg1] = arg2

	if var0 ~= arg2 then
		local var2 = arg2 - var0

		arg0._client:FleetBuffTrigger(var1.BuffEffectType.ON_FLEET_ATTR_UPDATE, {
			attr = arg1,
			value = arg2,
			delta = var2
		})
		arg0._client:DispatchEvent(ys.Event.New(var3.UPDATE_FLEET_ATTR, {
			attr = arg1,
			value = arg2
		}))
	end
end
