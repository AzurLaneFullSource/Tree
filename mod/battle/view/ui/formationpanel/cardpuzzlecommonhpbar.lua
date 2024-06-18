ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig

var0_0.Battle.CardPuzzleCommonHPBar = class("CardPuzzleCommonHPBar")

local var2_0 = var0_0.Battle.CardPuzzleCommonHPBar

var2_0.__name = "CardPuzzleCommonHPBar"

function var2_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg0_1._go.transform
	arg0_1._hpTF = arg0_1._tf:Find("fleetBlood/blood")
	arg0_1._hpProgress = arg0_1._hpTF:GetComponent(typeof(Image))
end

function var2_0.SetCardPuzzleComponent(arg0_2, arg1_2)
	arg0_2._info = arg1_2
end

function var2_0.Update(arg0_3)
	arg0_3:updateHPBar()
end

function var2_0.updateHPBar(arg0_4)
	local var0_4 = arg0_4._info:GetCurrentCommonHP() / arg0_4._info:GetTotalCommonHP()

	arg0_4._hpProgress.fillAmount = var0_4
end

function var2_0.Dispose(arg0_5)
	arg0_5._hpProgress = nil
	arg0_5._hpTF = nil
	arg0_5._tf = nil
	arg0_5._go = nil
end

function var2_0.updateResource(arg0_6)
	return
end
