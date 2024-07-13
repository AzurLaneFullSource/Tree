ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleSkillCLS", var0_0.Battle.BattleSkillEffect)

var0_0.Battle.BattleSkillCLS = var1_0
var1_0.__name = "BattleSkillCLS"
var1_0.TYPE_BULLET = 1
var1_0.TYPE_AIRCRAFT = 2
var1_0.TYPE_MINION = 3

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1, lv)

	arg0_1._clsTypeList = arg0_1._tempData.arg_list.typeList or {}
end

function var1_0.DoDataEffect(arg0_2, arg1_2)
	arg0_2:doCls(arg1_2)
end

function var1_0.DoDataEffectWithoutTarget(arg0_3, arg1_3)
	arg0_3:doCls(arg1_3)
end

function var1_0.doCls(arg0_4, arg1_4)
	local var0_4 = var0_0.Battle.BattleDataProxy.GetInstance()
	local var1_4 = arg1_4:GetIFF() * -1

	for iter0_4, iter1_4 in ipairs(arg0_4._clsTypeList) do
		if iter1_4 == var1_0.TYPE_BULLET then
			var0_4:CLSBullet(var1_4)
		elseif iter1_4 == var1_0.TYPE_AIRCRAFT then
			var0_4:CLSAircraft(var1_4)
		elseif iter1_4 == var1_0.TYPE_MINION then
			var0_4:CLSMinion()
		end
	end
end
