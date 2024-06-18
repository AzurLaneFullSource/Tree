ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig
local var2_0 = var0_0.Battle.BattleDataFunction

var0_0.Battle.CardPuzzleCardDetail = class("CardPuzzleCardDetail")

local var3_0 = var0_0.Battle.CardPuzzleCardDetail

var3_0.__name = "CardPuzzleCardDetail"

function var3_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg0_1._go.transform
	arg0_1._desc = arg0_1._tf:Find("Desc")
	arg0_1._affixList = arg0_1._tf:Find("affixList")
	arg0_1._affixContainer = arg0_1._affixList:Find("container")
	arg0_1._affixTpl = arg0_1._tf:Find("tpl")
	arg0_1._affixViewList = {}
	arg0_1._bound = 960 - rtf(arg0_1._tf).rect.width * 0.5
end

function var3_0.Dispose(arg0_2)
	arg0_2._affixList = nil
	arg0_2._affixContainer = nil
	arg0_2._affixTpl = nil
	arg0_2._desc = nil
	arg0_2._tf = nil
	arg0_2._go = nil
end

function var3_0.Active(arg0_3, arg1_3)
	setActive(arg0_3._go, arg1_3)
end

function var3_0.SetReferenceCard(arg0_4, arg1_4)
	local var0_4 = arg1_4:GetCardInfo():GetCardID()
	local var1_4 = var2_0.GetPuzzleCardDataTemplate(var0_4)

	setText(arg0_4._desc, var1_4.discript)

	local var2_4 = #var1_4.label
	local var3_4 = 0

	while var3_4 < var2_4 do
		var3_4 = var3_4 + 1

		local var4_4 = arg0_4._affixViewList[var3_4]

		if var4_4 == nil then
			local var5_4 = cloneTplTo(arg0_4._affixTpl, arg0_4._affixContainer)

			var4_4 = var0_0.Battle.CardPuzzleCardDetailAffix.New(var5_4)

			table.insert(arg0_4._affixViewList, var4_4)
		end

		var4_4:SetAffixID(var1_4.label[var3_4])
	end

	for iter0_4, iter1_4 in ipairs(arg0_4._affixViewList) do
		local var6_4 = iter0_4 <= var3_4

		iter1_4:SetActive(var6_4)
	end

	arg0_4._pos = arg0_4._pos or Vector3.New(0, 0, 0)

	local var7_4 = arg1_4:GetUIPos()

	if var7_4.x > arg0_4._bound then
		arg0_4._pos.x = arg0_4._bound
	else
		arg0_4._pos.x = var7_4.x
	end

	arg0_4._pos.y = var7_4.y + 130
	arg0_4._tf.anchoredPosition = arg0_4._pos
end
