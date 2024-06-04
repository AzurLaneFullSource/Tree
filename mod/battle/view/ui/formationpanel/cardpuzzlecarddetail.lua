ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig
local var2 = var0.Battle.BattleDataFunction

var0.Battle.CardPuzzleCardDetail = class("CardPuzzleCardDetail")

local var3 = var0.Battle.CardPuzzleCardDetail

var3.__name = "CardPuzzleCardDetail"

function var3.Ctor(arg0, arg1)
	arg0._go = arg1
	arg0._tf = arg0._go.transform
	arg0._desc = arg0._tf:Find("Desc")
	arg0._affixList = arg0._tf:Find("affixList")
	arg0._affixContainer = arg0._affixList:Find("container")
	arg0._affixTpl = arg0._tf:Find("tpl")
	arg0._affixViewList = {}
	arg0._bound = 960 - rtf(arg0._tf).rect.width * 0.5
end

function var3.Dispose(arg0)
	arg0._affixList = nil
	arg0._affixContainer = nil
	arg0._affixTpl = nil
	arg0._desc = nil
	arg0._tf = nil
	arg0._go = nil
end

function var3.Active(arg0, arg1)
	setActive(arg0._go, arg1)
end

function var3.SetReferenceCard(arg0, arg1)
	local var0 = arg1:GetCardInfo():GetCardID()
	local var1 = var2.GetPuzzleCardDataTemplate(var0)

	setText(arg0._desc, var1.discript)

	local var2 = #var1.label
	local var3 = 0

	while var3 < var2 do
		var3 = var3 + 1

		local var4 = arg0._affixViewList[var3]

		if var4 == nil then
			local var5 = cloneTplTo(arg0._affixTpl, arg0._affixContainer)

			var4 = var0.Battle.CardPuzzleCardDetailAffix.New(var5)

			table.insert(arg0._affixViewList, var4)
		end

		var4:SetAffixID(var1.label[var3])
	end

	for iter0, iter1 in ipairs(arg0._affixViewList) do
		local var6 = iter0 <= var3

		iter1:SetActive(var6)
	end

	arg0._pos = arg0._pos or Vector3.New(0, 0, 0)

	local var7 = arg1:GetUIPos()

	if var7.x > arg0._bound then
		arg0._pos.x = arg0._bound
	else
		arg0._pos.x = var7.x
	end

	arg0._pos.y = var7.y + 130
	arg0._tf.anchoredPosition = arg0._pos
end
