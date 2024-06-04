ys = ys or {}

local var0 = ys
local var1 = class("BattleBuffAntiSubVigilance", var0.Battle.BattleBuffEffect)

var0.Battle.BattleBuffAntiSubVigilance = var1
var1.__name = "BattleBuffAntiSubVigilance"

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.SetArgs(arg0, arg1, arg2)
	local var0 = arg0._tempData.arg_list

	arg0._vigilantRange = var0.vigilanceRange
	arg0._sonarRange = var0.sonarRange
	arg0._sonarFrequency = var0.sonarFrequency
end

function var1.onAttach(arg0, arg1)
	arg0._vigilantUnit = arg1
	arg0._vigilantState = arg1:InitAntiSubState(arg0._sonarRange, arg0._sonarFrequency)

	local var0 = arg0:getTargetList(arg0._vigilantUnit, "TargetHarmNearest", {
		range = 200
	})

	arg0._vigilantState:InitCheck(#var0)

	arg0._sonarCheckTimeStamp = pg.TimeMgr.GetInstance():GetCombatTime()
end

function var1.onUpdate(arg0)
	if #arg0:getTargetList(arg0._vigilantUnit, "TargetHarmNearest", {
		range = arg0._vigilantRange
	}) > 0 then
		arg0._vigilantState:VigilantAreaEngage()
	end

	local var0 = #arg0:getTargetList(arg0._vigilantUnit, "TargetHarmNearest", {
		range = 200
	})
	local var1 = #arg0:getTargetList(arg0._vigilantUnit, {
		"TargetAllFoe",
		"TargetHarmNearest",
		"TargetDiveState"
	}, {
		range = arg0._sonarRange
	})

	arg0._vigilantState:Update(var0, var1)

	local var2 = pg.TimeMgr.GetInstance():GetCombatTime()

	if var2 - arg0._sonarCheckTimeStamp >= arg0._sonarFrequency then
		arg0._vigilantState:SonarDetect(var1)

		arg0._sonarCheckTimeStamp = var2
	end
end

function var1.onAntiSubHateChain(arg0)
	arg0._vigilantState:HateChain()
end

function var1.onFriendlyShipDying(arg0, arg1, arg2, arg3)
	arg0._vigilantState:MineExplode()
end

function var1.onSubmarinFreeDive(arg0, arg1, arg2, arg3)
	return
end

function var1.onSubmarinFreeFloat(arg0, arg1, arg2, arg3)
	arg0._vigilantState:SubmarineFloat()
end
