ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig
local var2_0 = var0_0.Battle.BattleDataFunction

var0_0.Battle.CardPuzzleCardDetailAffix = class("CardPuzzleCardDetailAffix")

local var3_0 = var0_0.Battle.CardPuzzleCardDetailAffix

var3_0.__name = "CardPuzzleCardDetailAffix"

function var3_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg0_1._go.transform
	arg0_1._nameLabel = arg0_1._tf:Find("name/labelCN")
	arg0_1._nameLabelEN = arg0_1._tf:Find("name/labelEN")
	arg0_1._desc = arg0_1._tf:Find("Desc")
end

function var3_0.SetActive(arg0_2, arg1_2)
	setActive(arg0_2._go, arg1_2)
end

function var3_0.SetAffixID(arg0_3, arg1_3)
	local var0_3 = var2_0.GetPuzzleCardAffixDataTemplate(arg1_3)

	setText(arg0_3._nameLabel, var0_3.name)
	setText(arg0_3._nameLabelEN, var0_3.name_EN)
	setText(arg0_3._desc, var0_3.discript)
end

function var3_0.Dispose(arg0_4)
	arg0_4._nameLabel = nil
	arg0_4._nameLabelEN = nil
	arg0_4._desc = nil
	arg0_4._tf = nil
	arg0_4._go = nil
end
