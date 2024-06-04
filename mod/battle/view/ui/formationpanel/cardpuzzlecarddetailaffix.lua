ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig
local var2 = var0.Battle.BattleDataFunction

var0.Battle.CardPuzzleCardDetailAffix = class("CardPuzzleCardDetailAffix")

local var3 = var0.Battle.CardPuzzleCardDetailAffix

var3.__name = "CardPuzzleCardDetailAffix"

function var3.Ctor(arg0, arg1)
	arg0._go = arg1
	arg0._tf = arg0._go.transform
	arg0._nameLabel = arg0._tf:Find("name/labelCN")
	arg0._nameLabelEN = arg0._tf:Find("name/labelEN")
	arg0._desc = arg0._tf:Find("Desc")
end

function var3.SetActive(arg0, arg1)
	setActive(arg0._go, arg1)
end

function var3.SetAffixID(arg0, arg1)
	local var0 = var2.GetPuzzleCardAffixDataTemplate(arg1)

	setText(arg0._nameLabel, var0.name)
	setText(arg0._nameLabelEN, var0.name_EN)
	setText(arg0._desc, var0.discript)
end

function var3.Dispose(arg0)
	arg0._nameLabel = nil
	arg0._nameLabelEN = nil
	arg0._desc = nil
	arg0._tf = nil
	arg0._go = nil
end
