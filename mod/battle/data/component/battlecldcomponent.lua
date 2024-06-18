ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = class("BattleCldComponent")

var0_0.Battle.BattleCldComponent = var2_0
var2_0.__name = "BattleCldComponent"

function var2_0.Ctor(arg0_1)
	return
end

function var2_0.SetActive(arg0_2, arg1_2)
	arg0_2._cldData.Active = arg1_2
end

function var2_0.SetImmuneCLD(arg0_3, arg1_3)
	arg0_3._cldData.ImmuneCLD = arg1_3
end

function var2_0.SetCldData(arg0_4, arg1_4)
	arg0_4._cldData = arg1_4
	arg0_4._cldData.distList = {}
	arg0_4._cldData.Active = false
	arg0_4._cldData.ImmuneCLD = false
	arg0_4._cldData.FriendlyCld = false
	arg0_4._cldData.Surface = var1_0.OXY_STATE.FLOAT
	arg0_4._box.data = arg1_4
end

function var2_0.ActiveFriendlyCld(arg0_5)
	arg0_5._cldData.FriendlyCld = true
end

function var2_0.GetCldData(arg0_6)
	return arg0_6._cldData
end

function var2_0.GetCldBox(arg0_7, arg1_7)
	assert(false, "BattleCldComponent.GetCldBox:重写这个方法啦！")
end

function var2_0.GetCldBoxSize(arg0_8)
	assert(false, "BattleCldComponent.GetCldBoxSize:重写这个方法啦！")

	return nil
end

function var2_0.FixSpeed(arg0_9, arg1_9)
	if not arg0_9._cldData.FriendlyCld then
		return
	end

	if #arg0_9._cldData.distList == 0 then
		return
	end

	if arg1_9.x == 0 and arg1_9.z == 0 then
		arg0_9:HandleStaticCld(arg1_9)
	else
		arg0_9:HandleDynamicCld(arg1_9)
	end
end

function var2_0.HandleDynamicCld(arg0_10, arg1_10)
	local var0_10 = false
	local var1_10 = false

	for iter0_10, iter1_10 in ipairs(arg0_10._cldData.distList) do
		local var2_10 = iter1_10.x

		if not var0_10 and var2_10 * math.abs(arg1_10.x) / arg1_10.x < 0 then
			arg1_10.x = 0
			var0_10 = true
		end

		local var3_10 = iter1_10.z

		if not var1_10 and var3_10 * math.abs(arg1_10.z) / arg1_10.z < 0 then
			arg1_10.z = 0
			var1_10 = true
		end

		if var0_10 and var1_10 then
			return
		end
	end
end

function var2_0.HandleStaticCld(arg0_11, arg1_11)
	local var0_11 = arg0_11._cldData.distList[1]
	local var1_11 = Vector3(var0_11.x, 0, var0_11.z).normalized

	arg1_11.x = var0_0.Battle.BattleFormulas.ConvertShipSpeed(var1_11.x)
	arg1_11.z = var0_0.Battle.BattleFormulas.ConvertShipSpeed(var1_11.z)
end
