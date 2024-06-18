ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleDataFunction
local var2_0 = class("BattleScoreBarView")

var0_0.Battle.BattleScoreBarView = var2_0
var2_0.__name = "BattleScoreBarView"

function var2_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform

	arg0_1:init()
end

function var2_0.init(arg0_2)
	arg0_2._scoreTF = arg0_2._tf:Find("bg/Text")
	arg0_2._comboTF = arg0_2._tf:Find("comboMark")
	arg0_2._comboText = arg0_2._tf:Find("comboMark/value")
end

function var2_0.SetActive(arg0_3, arg1_3)
	SetActive(arg0_3._tf, arg1_3)
end

function var2_0.UpdateScore(arg0_4, arg1_4)
	setText(arg0_4._scoreTF, arg1_4)
end

function var2_0.UpdateCombo(arg0_5, arg1_5)
	if arg1_5 > 1 then
		SetActive(arg0_5._comboTF, true)
	else
		SetActive(arg0_5._comboTF, false)
	end

	setText(arg0_5._comboText, arg1_5)
end
