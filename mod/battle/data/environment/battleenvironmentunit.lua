ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = var0_0.Battle.BattleConfig
local var3_0 = var0_0.Battle.BattleDataFunction
local var4_0 = class("BattleEnvironmentUnit")

var0_0.Battle.BattleEnvironmentUnit = var4_0
var4_0.__name = "BattleEnvironmentUnit"

function var4_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.EventDispatcher.AttachEventDispatcher(arg0_1)

	arg0_1._uid = arg1_1
end

function var4_0.ConfigCallback(arg0_2, arg1_2)
	arg0_2._callback = arg1_2
end

function var4_0.GetUniqueID(arg0_3)
	return arg0_3._uid
end

function var4_0.SetTemplate(arg0_4, arg1_4)
	arg0_4._template = arg1_4

	arg0_4:initBehaviours()
end

function var4_0.SetAOEData(arg0_5, arg1_5)
	arg0_5._expireTimeStamp = pg.TimeMgr.GetInstance():GetCombatTime() + arg0_5._template.life_time
	arg0_5._aoeData = arg1_5
end

function var4_0.GetAOEData(arg0_6)
	return arg0_6._aoeData
end

function var4_0.GetBehaviours(arg0_7)
	return arg0_7._behaviours
end

function var4_0.GetTemplate(arg0_8)
	return arg0_8._template
end

function var4_0.UpdateFrequentlyCollide(arg0_9, arg1_9)
	for iter0_9, iter1_9 in ipairs(arg0_9._behaviours) do
		iter1_9:UpdateCollideUnitList(arg1_9)
	end
end

function var4_0.Update(arg0_10)
	for iter0_10, iter1_10 in ipairs(arg0_10._behaviours) do
		iter1_10:OnUpdate()
	end
end

function var4_0.IsExpire(arg0_11, arg1_11)
	return arg1_11 > arg0_11._expireTimeStamp
end

function var4_0.Dispose(arg0_12)
	if arg0_12._callback then
		arg0_12._callback()
	end

	for iter0_12, iter1_12 in ipairs(arg0_12._behaviours) do
		iter1_12:Dispose()
	end
end

function var4_0.initBehaviours(arg0_13)
	arg0_13._behaviours = {}

	local var0_13 = var3_0.GetEnvironmentBehaviour(arg0_13._template.behaviours).behaviour_list

	for iter0_13, iter1_13 in ipairs(var0_13) do
		local var1_13 = var0_0.Battle.BattleEnvironmentBehaviour.CreateBehaviour(iter1_13)

		var1_13:SetUnitRef(arg0_13)
		var1_13:SetTemplate(iter1_13)
		table.insert(arg0_13._behaviours, var1_13)
	end
end
