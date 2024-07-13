local var0_0 = class("CommanderHomeBaseSelPage", import("view.base.BaseSubView"))

function var0_0.OnLoaded(arg0_1)
	arg0_1.scrollrect = arg0_1:findTF("scrollrect"):GetComponent("LScrollRect")
	arg0_1.okBtn = arg0_1:findTF("ok_button")

	setActive(arg0_1._tf, true)
end

function var0_0.OnInit(arg0_2)
	arg0_2.cards = {}

	function arg0_2.scrollrect.onInitItem(arg0_3)
		arg0_2:OnInitItem(arg0_3)
	end

	function arg0_2.scrollrect.onUpdateItem(arg0_4, arg1_4)
		arg0_2:OnUpdateItem(arg0_4, arg1_4)
	end
end

function var0_0.OnInitItem(arg0_5, arg1_5)
	local var0_5 = CommanderCard.New(arg1_5)

	onButton(arg0_5, var0_5._tf, function()
		arg0_5:OnSelected(var0_5)
	end, SFX_PANEL)

	arg0_5.cards[arg1_5] = var0_5
end

function var0_0.OnUpdateItem(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg0_7.cards[arg2_7]

	if not var0_7 then
		arg0_7:OnInitItem(arg2_7)

		var0_7 = arg0_7.cards[arg2_7]
	end

	local var1_7 = arg1_7 + 1
	local var2_7 = arg0_7.displays[var1_7]

	var0_7:update(var2_7)
	setActive(var0_7._tf:Find("line"), var1_7 % 4 == 1)
end

function var0_0.Update(arg0_8)
	arg0_8:Show()

	local var0_8 = getProxy(CommanderProxy):getData()

	arg0_8.displays = {}

	for iter0_8, iter1_8 in pairs(var0_8) do
		table.insert(arg0_8.displays, iter1_8)
	end

	local var1_8 = getProxy(FleetProxy):getCommandersInFleet()

	table.sort(arg0_8.displays, function(arg0_9, arg1_9)
		local var0_9 = table.contains(var1_8, arg0_9.id) and 1 or 0
		local var1_9 = table.contains(var1_8, arg1_9.id) and 1 or 0

		if var0_9 == var1_9 then
			return arg0_9.level > arg1_9.level
		else
			return var1_9 < var0_9
		end
	end)

	local var2_8 = 8 - #arg0_8.displays

	for iter2_8 = 1, var2_8 do
		table.insert(arg0_8.displays, false)
	end

	arg0_8.scrollrect:SetTotalCount(#arg0_8.displays, -1)
end

function var0_0.OnDestroy(arg0_10)
	for iter0_10, iter1_10 in pairs(arg0_10.cards) do
		iter1_10:clear()
	end
end

function var0_0.OnSelected(arg0_11)
	return
end

return var0_0
