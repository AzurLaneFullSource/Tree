ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = class("BattleCldComponent")

var0.Battle.BattleCldComponent = var2
var2.__name = "BattleCldComponent"

function var2.Ctor(arg0)
	return
end

function var2.SetActive(arg0, arg1)
	arg0._cldData.Active = arg1
end

function var2.SetImmuneCLD(arg0, arg1)
	arg0._cldData.ImmuneCLD = arg1
end

function var2.SetCldData(arg0, arg1)
	arg0._cldData = arg1
	arg0._cldData.distList = {}
	arg0._cldData.Active = false
	arg0._cldData.ImmuneCLD = false
	arg0._cldData.FriendlyCld = false
	arg0._cldData.Surface = var1.OXY_STATE.FLOAT
	arg0._box.data = arg1
end

function var2.ActiveFriendlyCld(arg0)
	arg0._cldData.FriendlyCld = true
end

function var2.GetCldData(arg0)
	return arg0._cldData
end

function var2.GetCldBox(arg0, arg1)
	assert(false, "BattleCldComponent.GetCldBox:重写这个方法啦！")
end

function var2.GetCldBoxSize(arg0)
	assert(false, "BattleCldComponent.GetCldBoxSize:重写这个方法啦！")

	return nil
end

function var2.FixSpeed(arg0, arg1)
	if not arg0._cldData.FriendlyCld then
		return
	end

	if #arg0._cldData.distList == 0 then
		return
	end

	if arg1.x == 0 and arg1.z == 0 then
		arg0:HandleStaticCld(arg1)
	else
		arg0:HandleDynamicCld(arg1)
	end
end

function var2.HandleDynamicCld(arg0, arg1)
	local var0 = false
	local var1 = false

	for iter0, iter1 in ipairs(arg0._cldData.distList) do
		local var2 = iter1.x

		if not var0 and var2 * math.abs(arg1.x) / arg1.x < 0 then
			arg1.x = 0
			var0 = true
		end

		local var3 = iter1.z

		if not var1 and var3 * math.abs(arg1.z) / arg1.z < 0 then
			arg1.z = 0
			var1 = true
		end

		if var0 and var1 then
			return
		end
	end
end

function var2.HandleStaticCld(arg0, arg1)
	local var0 = arg0._cldData.distList[1]
	local var1 = Vector3(var0.x, 0, var0.z).normalized

	arg1.x = var0.Battle.BattleFormulas.ConvertShipSpeed(var1.x)
	arg1.z = var0.Battle.BattleFormulas.ConvertShipSpeed(var1.z)
end
