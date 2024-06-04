ys = ys or {}

local var0 = ys
local var1 = class("BattleSkillCLS", var0.Battle.BattleSkillEffect)

var0.Battle.BattleSkillCLS = var1
var1.__name = "BattleSkillCLS"
var1.TYPE_BULLET = 1
var1.TYPE_AIRCRAFT = 2
var1.TYPE_MINION = 3

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1, lv)

	arg0._clsTypeList = arg0._tempData.arg_list.typeList or {}
end

function var1.DoDataEffect(arg0, arg1)
	arg0:doCls(arg1)
end

function var1.DoDataEffectWithoutTarget(arg0, arg1)
	arg0:doCls(arg1)
end

function var1.doCls(arg0, arg1)
	local var0 = var0.Battle.BattleDataProxy.GetInstance()
	local var1 = arg1:GetIFF() * -1

	for iter0, iter1 in ipairs(arg0._clsTypeList) do
		if iter1 == var1.TYPE_BULLET then
			var0:CLSBullet(var1)
		elseif iter1 == var1.TYPE_AIRCRAFT then
			var0:CLSAircraft(var1)
		elseif iter1 == var1.TYPE_MINION then
			var0:CLSMinion()
		end
	end
end
