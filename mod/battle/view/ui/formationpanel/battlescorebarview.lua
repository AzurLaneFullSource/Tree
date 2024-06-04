ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleDataFunction
local var2 = class("BattleScoreBarView")

var0.Battle.BattleScoreBarView = var2
var2.__name = "BattleScoreBarView"

function var2.Ctor(arg0, arg1)
	arg0._go = arg1
	arg0._tf = arg1.transform

	arg0:init()
end

function var2.init(arg0)
	arg0._scoreTF = arg0._tf:Find("bg/Text")
	arg0._comboTF = arg0._tf:Find("comboMark")
	arg0._comboText = arg0._tf:Find("comboMark/value")
end

function var2.SetActive(arg0, arg1)
	SetActive(arg0._tf, arg1)
end

function var2.UpdateScore(arg0, arg1)
	setText(arg0._scoreTF, arg1)
end

function var2.UpdateCombo(arg0, arg1)
	if arg1 > 1 then
		SetActive(arg0._comboTF, true)
	else
		SetActive(arg0._comboTF, false)
	end

	setText(arg0._comboText, arg1)
end
