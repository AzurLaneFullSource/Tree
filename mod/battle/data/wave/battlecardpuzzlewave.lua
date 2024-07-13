ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig
local var2_0 = var0_0.Battle.BattleFleetCardPuzzleCardManageComponent

var0_0.Battle.BattleCardPuzzleWave = class("BattleCardPuzzleWave", var0_0.Battle.BattleWaveInfo)
var0_0.Battle.BattleCardPuzzleWave.__name = "BattleCardPuzzleWave"

local var3_0 = var0_0.Battle.BattleCardPuzzleWave

function var3_0.Ctor(arg0_1)
	var3_0.super.Ctor(arg0_1)
end

function var3_0.SetWaveData(arg0_2, arg1_2)
	var3_0.super.SetWaveData(arg0_2, arg1_2)

	arg0_2._cardID = arg0_2._param.card_id
	arg0_2._moveTo = arg0_2._param.move_to
	arg0_2._moveOP = arg0_2._param.move_op or var2_0.FUNC_NAME_ADD
	arg0_2._op = arg0_2._param.shuffle or 1
end

function var3_0.DoWave(arg0_3)
	var3_0.super.DoWave(arg0_3)

	local var0_3 = var0_0.Battle.BattleDataProxy.GetInstance():GetFleetByIFF(var1_0.FRIENDLY_CODE):GetCardPuzzleComponent()
	local var1_3 = var0_3:GenerateCard(arg0_3._cardID)
	local var2_3 = var0_3:GetCardPileByIndex(arg0_3._moveTo)

	var2_3[arg0_3._moveOP](var2_3, var1_3)

	if arg0_3._op == 1 then
		var2_3:Shuffle()
	end

	arg0_3:doPass()
end
