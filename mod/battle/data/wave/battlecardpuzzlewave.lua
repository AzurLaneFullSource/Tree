ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig
local var2 = var0.Battle.BattleFleetCardPuzzleCardManageComponent

var0.Battle.BattleCardPuzzleWave = class("BattleCardPuzzleWave", var0.Battle.BattleWaveInfo)
var0.Battle.BattleCardPuzzleWave.__name = "BattleCardPuzzleWave"

local var3 = var0.Battle.BattleCardPuzzleWave

function var3.Ctor(arg0)
	var3.super.Ctor(arg0)
end

function var3.SetWaveData(arg0, arg1)
	var3.super.SetWaveData(arg0, arg1)

	arg0._cardID = arg0._param.card_id
	arg0._moveTo = arg0._param.move_to
	arg0._moveOP = arg0._param.move_op or var2.FUNC_NAME_ADD
	arg0._op = arg0._param.shuffle or 1
end

function var3.DoWave(arg0)
	var3.super.DoWave(arg0)

	local var0 = var0.Battle.BattleDataProxy.GetInstance():GetFleetByIFF(var1.FRIENDLY_CODE):GetCardPuzzleComponent()
	local var1 = var0:GenerateCard(arg0._cardID)
	local var2 = var0:GetCardPileByIndex(arg0._moveTo)

	var2[arg0._moveOP](var2, var1)

	if arg0._op == 1 then
		var2:Shuffle()
	end

	arg0:doPass()
end
