local var0_0 = class("IslandRestaurantUpgradePage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandRestaurantUpgradeUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.titleTF = arg0_2._tf:Find("title/name/Text")

	local var0_2 = arg0_2._tf:Find("window/summary")

	setText(var0_2:Find("title/Text"), i18n("island_manage_result_3"))

	arg0_2.shelfTF = var0_2:Find("shelf/info/value")

	setText(var0_2:Find("shelf/info/name"), i18n("island_manage_slot"))

	arg0_2.capacityTF = var0_2:Find("capacity/info/value")

	setText(var0_2:Find("capacity/info/name"), i18n("island_manage_food_cnt"))

	arg0_2.percentTF = var0_2:Find("percent/info/value")

	setText(var0_2:Find("percent/info/name"), i18n("island_manage_sale_ratio"))

	arg0_2.assistantTF = var0_2:Find("assistant/info/value")

	setText(var0_2:Find("assistant/info/name"), i18n("island_manage_worker_cnt"))

	arg0_2.viewTF = arg0_2._tf:Find("window/rank")
	arg0_2.uiList = UIItemList.New(arg0_2.viewTF:Find("content"), arg0_2.viewTF:Find("content/tpl"))

	setText(arg0_2._tf:Find("tip"), i18n("child_close_tip"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf:Find("mask"), function()
		arg0_3:Hide()
	end, SFX_PANEL)
	arg0_3.uiList:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventInit then
			local var0_5 = pg.island_manage_rank[arg0_3.rankIds[arg1_5 + 1]]

			arg2_5.name = var0_5.id

			LoadImageSpriteAsync("island/islandrestaurant/" .. var0_5.icon, arg2_5:Find("icon"))
			setActive(arg2_5:Find("dot/silder"), arg1_5 + 1 ~= #arg0_3.rankIds)
		elseif arg0_5 == UIItemList.EventUpdate then
			arg0_3:UpdataItem(arg1_5, arg2_5)
		end
	end)

	arg0_3.rankIds = pg.island_manage_rank.all

	table.sort(arg0_3.rankIds)
end

function var0_0.OnShow(arg0_6, arg1_6, arg2_6)
	arg0_6:BlurPanel()

	arg0_6.callback = arg2_6
	arg0_6.restId = arg1_6.restId
	arg0_6.oldSale = arg1_6.oldSale
	arg0_6.rest = getProxy(IslandProxy):GetIsland():GetManageAgency():GetRestaurant(arg0_6.restId)
	arg0_6.level = arg0_6.rest:GetRankLevel()
	arg0_6.sales = arg0_6.rest:GetSales()
	arg0_6.expData = IslandRestaurant.GET_RNAK_EXPS(arg0_6.restId)

	setText(arg0_6.titleTF, arg0_6.rest:getConfig("name"))
	arg0_6:UpdataSummary()
	arg0_6.uiList:align(#arg0_6.rankIds)
	scrollTo(arg0_6.viewTF, (arg0_6.level - 1) / (#arg0_6.rankIds - 3), 0)
end

function var0_0.UpdataItem(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg0_7.rankIds[arg1_7 + 1]
	local var1_7 = arg0_7.rankIds[arg1_7]
	local var2_7 = arg0_7.expData[var0_7]
	local var3_7 = var0_7 <= arg0_7.level

	setActive(arg2_7:Find("dot/finished"), var3_7)

	local var4_7 = arg0_7.expData[var1_7] or 0
	local var5_7 = (arg0_7.sales - var4_7) / (var2_7 - var4_7)

	setSlider(arg2_7:Find("dot/silder"), 0, 1, var5_7)
end

function var0_0.UpdataSummary(arg0_8)
	local var0_8 = pg.island_manage_rank[arg0_8.level]
	local var1_8 = pg.island_manage_rank[arg0_8.level - 1]

	setText(arg0_8.shelfTF:Find("base"), var1_8.slot_num[1])

	local var2_8 = var0_8.slot_num[1] - var1_8.slot_num[1]

	setText(arg0_8.shelfTF:Find("add"), var2_8 > 0 and "+" .. var2_8 or "")
	setText(arg0_8.capacityTF:Find("base"), var1_8.slot_num[2])

	local var3_8 = var0_8.slot_num[2] - var1_8.slot_num[2]

	setText(arg0_8.capacityTF:Find("add"), var3_8 > 0 and "+" .. var3_8 or "")
	setText(arg0_8.percentTF:Find("base"), var1_8.bonus_coefficient / 100 .. "%")

	local var4_8 = (var0_8.bonus_coefficient - var1_8.bonus_coefficient) / 100

	setText(arg0_8.percentTF:Find("add"), var4_8 > 0 and "+" .. var4_8 .. "%" or "")
	setText(arg0_8.assistantTF:Find("base"), var1_8.assistant_num)

	local var5_8 = var0_8.assistant_num - var1_8.assistant_num

	setText(arg0_8.assistantTF:Find("add"), var5_8 > 0 and "+" .. var5_8 or "")
end

function var0_0.OnHide(arg0_9)
	arg0_9:UnBlurPanel()
	existCall(arg0_9.callback)

	arg0_9.callback = nil
end

return var0_0
