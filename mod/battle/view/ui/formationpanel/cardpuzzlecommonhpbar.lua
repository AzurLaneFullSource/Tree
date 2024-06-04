ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig

var0.Battle.CardPuzzleCommonHPBar = class("CardPuzzleCommonHPBar")

local var2 = var0.Battle.CardPuzzleCommonHPBar

var2.__name = "CardPuzzleCommonHPBar"

function var2.Ctor(arg0, arg1)
	arg0._go = arg1
	arg0._tf = arg0._go.transform
	arg0._hpTF = arg0._tf:Find("fleetBlood/blood")
	arg0._hpProgress = arg0._hpTF:GetComponent(typeof(Image))
end

function var2.SetCardPuzzleComponent(arg0, arg1)
	arg0._info = arg1
end

function var2.Update(arg0)
	arg0:updateHPBar()
end

function var2.updateHPBar(arg0)
	local var0 = arg0._info:GetCurrentCommonHP() / arg0._info:GetTotalCommonHP()

	arg0._hpProgress.fillAmount = var0
end

function var2.Dispose(arg0)
	arg0._hpProgress = nil
	arg0._hpTF = nil
	arg0._tf = nil
	arg0._go = nil
end

function var2.updateResource(arg0)
	return
end
