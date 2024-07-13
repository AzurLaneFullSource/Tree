ys = ys or {}
ys.Battle.BattleFleetAttrComponent = class("BattleFleetAttrComponent")
ys.Battle.BattleFleetAttrComponent.__name = "BattleFleetAttrComponent"

local var0_0 = ys.Battle.BattleFleetAttrComponent
local var1_0 = ys.Battle.BattleConst
local var2_0 = ys.Battle.BattleConfig
local var3_0 = ys.Battle.BattleEvent

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._client = arg1_1

	arg0_1:initFleetAttr()
end

function var0_0.Dispose(arg0_2)
	arg0_2._client = nil
end

function var0_0.initFleetAttr(arg0_3)
	arg0_3._fleetAttrList = {}
end

function var0_0.GetCurrent(arg0_4, arg1_4)
	return arg0_4._fleetAttrList[arg1_4] or 0
end

function var0_0.SetCurrent(arg0_5, arg1_5, arg2_5)
	local var0_5 = arg0_5:GetCurrent(arg1_5)
	local var1_5 = var2_0.FLEET_ATTR_CAP[arg1_5]

	if var1_5 then
		arg2_5 = Mathf.Clamp(arg2_5, 0, var1_5)
	else
		arg2_5 = math.max(arg2_5, 0)
	end

	arg0_5._fleetAttrList[arg1_5] = arg2_5

	if var0_5 ~= arg2_5 then
		local var2_5 = arg2_5 - var0_5

		arg0_5._client:FleetBuffTrigger(var1_0.BuffEffectType.ON_FLEET_ATTR_UPDATE, {
			attr = arg1_5,
			value = arg2_5,
			delta = var2_5
		})
		arg0_5._client:DispatchEvent(ys.Event.New(var3_0.UPDATE_FLEET_ATTR, {
			attr = arg1_5,
			value = arg2_5
		}))
	end
end
