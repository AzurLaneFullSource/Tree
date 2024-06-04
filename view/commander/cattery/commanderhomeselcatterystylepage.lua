local var0 = class("CommanderHomeSelCatteryStylePage", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "CommanderHomeSelCatteryStylePage"
end

function var0.OnCatteryUpdate(arg0, arg1)
	arg0.cattery = arg1

	arg0:Update(arg0.home, arg1)
end

function var0.OnCatteryStyleUpdate(arg0, arg1)
	arg0:OnCatteryUpdate(arg1)
end

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

	onButton(arg0, arg0.okBtn, function()
		if arg0.selectedID then
			arg0:emit(CommanderHomeMediator.ON_CHANGE_STYLE, arg0.cattery.id, arg0.selectedID)
		end
	end, SFX_PANEL)
end

function var0.OnInitItem(arg0, arg1)
	local var0 = CatteryStyleCard.New(arg1)

	onButton(arg0, var0._tf, function()
		if not var0.style:IsOwn() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("cathome_style_unlock"))

			return
		end

		local var0 = var0.style.id

		arg0.selectedID = var0

		arg0:emit(CatteryDescPage.CHANGE_STYLE, var0)
	end, SFX_PANEL)

	arg0.cards[arg1] = var0
end

function var0.OnUpdateItem(arg0, arg1, arg2)
	local var0 = arg0.cards[arg2]

	if not var0 then
		arg0:OnInitItem(arg2)

		var0 = arg0.cards[arg2]
	end

	local var1 = arg0.displays[arg1 + 1]
	local var2 = arg0.cattery:GetStyle() == var1.id

	var0:Update(var1, var2)
end

function var0.Update(arg0, arg1, arg2)
	arg0:Show()

	arg0.home = arg1
	arg0.cattery = arg2
	arg0.displays = {}

	local var0 = arg1:GetOwnStyles()

	for iter0, iter1 in ipairs(pg.commander_home_style.all) do
		local var1 = table.contains(var0, iter1)
		local var2 = CatteryStyle.New({
			id = iter1,
			own = var1
		})

		table.insert(arg0.displays, var2)
	end

	arg0.scrollrect:SetTotalCount(#arg0.displays)
end

function var0.OnDestroy(arg0)
	for iter0, iter1 in pairs(arg0.cards) do
		iter1:Dispose()
	end
end

return var0
