local var0_0 = class("IslandShopBuySuccessLayer", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandShopBuySuccessUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.awardList = UIItemList.New(arg0_2._tf:Find("awards"), arg0_2._tf:Find("awards/item"))

	setText(arg0_2._tf:Find("tip/text"), i18n("island_3Dshop_close"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf:Find("award_window"), function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf:Find("tip"), function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.SetUp(arg0_6, arg1_6)
	arg0_6.awardList:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			local var0_7 = arg1_6[arg1_7 + 1]

			updateCustomDrop(arg2_7:Find("IslandItemTpl"), var0_7, {
				style = "island"
			})
			setActive(arg2_7:Find("split"), var0_7.type == VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT)
		end
	end)
	arg0_6.awardList:align(#arg1_6)
end

function var0_0.OnShow(arg0_8, arg1_8, arg2_8)
	arg0_8:BlurPanel(arg0_8._tf)

	local var0_8 = table.mergeArray(arg1_8.awards or {}, arg1_8.drops or {})

	table.sort(var0_8, CompareFuncs({
		function(arg0_9)
			return arg0_9.type == VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT and 0 or 1
		end
	}))
	arg0_8:SetUp(var0_8)

	arg0_8.callback = arg2_8
	arg0_8.active = true
end

function var0_0.OnHide(arg0_10)
	arg0_10:UnOverlayPanel(arg0_10._tf, arg0_10._parentTf)

	if arg0_10.active then
		arg0_10.active = false

		if arg0_10.callback then
			arg0_10.callback()
		end
	end
end

function var0_0.OnDestroy(arg0_11)
	return
end

return var0_0
