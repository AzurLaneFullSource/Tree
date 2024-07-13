ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleBuffAntiSubVigilance", var0_0.Battle.BattleBuffEffect)

var0_0.Battle.BattleBuffAntiSubVigilance = var1_0
var1_0.__name = "BattleBuffAntiSubVigilance"

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg0_2._tempData.arg_list

	arg0_2._vigilantRange = var0_2.vigilanceRange
	arg0_2._sonarRange = var0_2.sonarRange
	arg0_2._sonarFrequency = var0_2.sonarFrequency
end

function var1_0.onAttach(arg0_3, arg1_3)
	arg0_3._vigilantUnit = arg1_3
	arg0_3._vigilantState = arg1_3:InitAntiSubState(arg0_3._sonarRange, arg0_3._sonarFrequency)

	local var0_3 = arg0_3:getTargetList(arg0_3._vigilantUnit, "TargetHarmNearest", {
		range = 200
	})

	arg0_3._vigilantState:InitCheck(#var0_3)

	arg0_3._sonarCheckTimeStamp = pg.TimeMgr.GetInstance():GetCombatTime()
end

function var1_0.onUpdate(arg0_4)
	if #arg0_4:getTargetList(arg0_4._vigilantUnit, "TargetHarmNearest", {
		range = arg0_4._vigilantRange
	}) > 0 then
		arg0_4._vigilantState:VigilantAreaEngage()
	end

	local var0_4 = #arg0_4:getTargetList(arg0_4._vigilantUnit, "TargetHarmNearest", {
		range = 200
	})
	local var1_4 = #arg0_4:getTargetList(arg0_4._vigilantUnit, {
		"TargetAllFoe",
		"TargetHarmNearest",
		"TargetDiveState"
	}, {
		range = arg0_4._sonarRange
	})

	arg0_4._vigilantState:Update(var0_4, var1_4)

	local var2_4 = pg.TimeMgr.GetInstance():GetCombatTime()

	if var2_4 - arg0_4._sonarCheckTimeStamp >= arg0_4._sonarFrequency then
		arg0_4._vigilantState:SonarDetect(var1_4)

		arg0_4._sonarCheckTimeStamp = var2_4
	end
end

function var1_0.onAntiSubHateChain(arg0_5)
	arg0_5._vigilantState:HateChain()
end

function var1_0.onFriendlyShipDying(arg0_6, arg1_6, arg2_6, arg3_6)
	arg0_6._vigilantState:MineExplode()
end

function var1_0.onSubmarinFreeDive(arg0_7, arg1_7, arg2_7, arg3_7)
	return
end

function var1_0.onSubmarinFreeFloat(arg0_8, arg1_8, arg2_8, arg3_8)
	arg0_8._vigilantState:SubmarineFloat()
end
