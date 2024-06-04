ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = var0.Battle.BattleConfig
local var3 = var0.Battle.BattleDataFunction
local var4 = class("BattleEnvironmentUnit")

var0.Battle.BattleEnvironmentUnit = var4
var4.__name = "BattleEnvironmentUnit"

function var4.Ctor(arg0, arg1, arg2)
	var0.EventDispatcher.AttachEventDispatcher(arg0)

	arg0._uid = arg1
end

function var4.ConfigCallback(arg0, arg1)
	arg0._callback = arg1
end

function var4.GetUniqueID(arg0)
	return arg0._uid
end

function var4.SetTemplate(arg0, arg1)
	arg0._template = arg1

	arg0:initBehaviours()
end

function var4.SetAOEData(arg0, arg1)
	arg0._expireTimeStamp = pg.TimeMgr.GetInstance():GetCombatTime() + arg0._template.life_time
	arg0._aoeData = arg1
end

function var4.GetAOEData(arg0)
	return arg0._aoeData
end

function var4.GetBehaviours(arg0)
	return arg0._behaviours
end

function var4.GetTemplate(arg0)
	return arg0._template
end

function var4.UpdateFrequentlyCollide(arg0, arg1)
	for iter0, iter1 in ipairs(arg0._behaviours) do
		iter1:UpdateCollideUnitList(arg1)
	end
end

function var4.Update(arg0)
	for iter0, iter1 in ipairs(arg0._behaviours) do
		iter1:OnUpdate()
	end
end

function var4.IsExpire(arg0, arg1)
	return arg1 > arg0._expireTimeStamp
end

function var4.Dispose(arg0)
	if arg0._callback then
		arg0._callback()
	end

	for iter0, iter1 in ipairs(arg0._behaviours) do
		iter1:Dispose()
	end
end

function var4.initBehaviours(arg0)
	arg0._behaviours = {}

	local var0 = var3.GetEnvironmentBehaviour(arg0._template.behaviours).behaviour_list

	for iter0, iter1 in ipairs(var0) do
		local var1 = var0.Battle.BattleEnvironmentBehaviour.CreateBehaviour(iter1)

		var1:SetUnitRef(arg0)
		var1:SetTemplate(iter1)
		table.insert(arg0._behaviours, var1)
	end
end
