local var0 = class("CommanderHomeBaseSelPage", import("view.base.BaseSubView"))

function var0.OnLoaded(arg0)
	arg0.scrollrect = arg0:findTF("scrollrect"):GetComponent("LScrollRect")
	arg0.okBtn = arg0:findTF("ok_button")

	setActive(arg0._tf, true)
end

function var0.OnInit(arg0)
	arg0.cards = {}

	function arg0.scrollrect.onInitItem(arg0)
		arg0:OnInitItem(arg0)
	end

	function arg0.scrollrect.onUpdateItem(arg0, arg1)
		arg0:OnUpdateItem(arg0, arg1)
	end
end

function var0.OnInitItem(arg0, arg1)
	local var0 = CommanderCard.New(arg1)

	onButton(arg0, var0._tf, function()
		arg0:OnSelected(var0)
	end, SFX_PANEL)

	arg0.cards[arg1] = var0
end

function var0.OnUpdateItem(arg0, arg1, arg2)
	local var0 = arg0.cards[arg2]

	if not var0 then
		arg0:OnInitItem(arg2)

		var0 = arg0.cards[arg2]
	end

	local var1 = arg1 + 1
	local var2 = arg0.displays[var1]

	var0:update(var2)
	setActive(var0._tf:Find("line"), var1 % 4 == 1)
end

function var0.Update(arg0)
	arg0:Show()

	local var0 = getProxy(CommanderProxy):getData()

	arg0.displays = {}

	for iter0, iter1 in pairs(var0) do
		table.insert(arg0.displays, iter1)
	end

	local var1 = getProxy(FleetProxy):getCommandersInFleet()

	table.sort(arg0.displays, function(arg0, arg1)
		local var0 = table.contains(var1, arg0.id) and 1 or 0
		local var1 = table.contains(var1, arg1.id) and 1 or 0

		if var0 == var1 then
			return arg0.level > arg1.level
		else
			return var1 < var0
		end
	end)

	local var2 = 8 - #arg0.displays

	for iter2 = 1, var2 do
		table.insert(arg0.displays, false)
	end

	arg0.scrollrect:SetTotalCount(#arg0.displays, -1)
end

function var0.OnDestroy(arg0)
	for iter0, iter1 in pairs(arg0.cards) do
		iter1:clear()
	end
end

function var0.OnSelected(arg0)
	return
end

return var0
