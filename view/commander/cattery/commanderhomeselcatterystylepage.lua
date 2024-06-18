local var0_0 = class("CommanderHomeSelCatteryStylePage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "CommanderHomeSelCatteryStylePage"
end

function var0_0.OnCatteryUpdate(arg0_2, arg1_2)
	arg0_2.cattery = arg1_2

	arg0_2:Update(arg0_2.home, arg1_2)
end

function var0_0.OnCatteryStyleUpdate(arg0_3, arg1_3)
	arg0_3:OnCatteryUpdate(arg1_3)
end

function var0_0.OnLoaded(arg0_4)
	arg0_4.scrollrect = arg0_4:findTF("scrollrect"):GetComponent("LScrollRect")
	arg0_4.okBtn = arg0_4:findTF("ok_button")

	setActive(arg0_4._tf, true)
end

function var0_0.OnInit(arg0_5)
	arg0_5.cards = {}

	function arg0_5.scrollrect.onInitItem(arg0_6)
		arg0_5:OnInitItem(arg0_6)
	end

	function arg0_5.scrollrect.onUpdateItem(arg0_7, arg1_7)
		arg0_5:OnUpdateItem(arg0_7, arg1_7)
	end

	onButton(arg0_5, arg0_5.okBtn, function()
		if arg0_5.selectedID then
			arg0_5:emit(CommanderHomeMediator.ON_CHANGE_STYLE, arg0_5.cattery.id, arg0_5.selectedID)
		end
	end, SFX_PANEL)
end

function var0_0.OnInitItem(arg0_9, arg1_9)
	local var0_9 = CatteryStyleCard.New(arg1_9)

	onButton(arg0_9, var0_9._tf, function()
		if not var0_9.style:IsOwn() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("cathome_style_unlock"))

			return
		end

		local var0_10 = var0_9.style.id

		arg0_9.selectedID = var0_10

		arg0_9:emit(CatteryDescPage.CHANGE_STYLE, var0_10)
	end, SFX_PANEL)

	arg0_9.cards[arg1_9] = var0_9
end

function var0_0.OnUpdateItem(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg0_11.cards[arg2_11]

	if not var0_11 then
		arg0_11:OnInitItem(arg2_11)

		var0_11 = arg0_11.cards[arg2_11]
	end

	local var1_11 = arg0_11.displays[arg1_11 + 1]
	local var2_11 = arg0_11.cattery:GetStyle() == var1_11.id

	var0_11:Update(var1_11, var2_11)
end

function var0_0.Update(arg0_12, arg1_12, arg2_12)
	arg0_12:Show()

	arg0_12.home = arg1_12
	arg0_12.cattery = arg2_12
	arg0_12.displays = {}

	local var0_12 = arg1_12:GetOwnStyles()

	for iter0_12, iter1_12 in ipairs(pg.commander_home_style.all) do
		local var1_12 = table.contains(var0_12, iter1_12)
		local var2_12 = CatteryStyle.New({
			id = iter1_12,
			own = var1_12
		})

		table.insert(arg0_12.displays, var2_12)
	end

	arg0_12.scrollrect:SetTotalCount(#arg0_12.displays)
end

function var0_0.OnDestroy(arg0_13)
	for iter0_13, iter1_13 in pairs(arg0_13.cards) do
		iter1_13:Dispose()
	end
end

return var0_0
