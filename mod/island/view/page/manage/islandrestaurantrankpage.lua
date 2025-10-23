local var0_0 = class("IslandRestaurantRankPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandRestaurantRankUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.viewTF = arg0_2._tf:Find("window/view")

	local var0_2 = arg0_2.viewTF:Find("content")
	local var1_2 = var0_2:Find("tpl")

	setText(var1_2:Find("info/top/exp/name"), i18n("island_manage_need_ext"))
	setText(var1_2:Find("info/top/finished/Text"), i18n("island_manage_reach"))
	setText(var1_2:Find("info/bottom/content/shelf/info/name"), i18n("island_manage_slot"))
	setText(var1_2:Find("info/bottom/content/capacity/info/name"), i18n("island_manage_food_cnt"))
	setText(var1_2:Find("info/bottom/content/percent/info/name"), i18n("island_manage_sale_ratio"))
	setText(var1_2:Find("info/bottom/content/assistant/info/name"), i18n("island_manage_worker_cnt"))

	arg0_2.uiList = UIItemList.New(var0_2, var1_2)
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf:Find("mask"), function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf:Find("window/close"), function()
		arg0_3:Hide()
	end, SFX_PANEL)
	arg0_3.uiList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventInit then
			arg0_3:InitItem(arg1_6, arg2_6)
		elseif arg0_6 == UIItemList.EventUpdate then
			arg0_3:UpdataItem(arg1_6, arg2_6)
		end
	end)

	arg0_3.rankIds = pg.island_manage_rank.all

	table.sort(arg0_3.rankIds)
end

function var0_0.InitItem(arg0_7, arg1_7, arg2_7)
	local var0_7 = pg.island_manage_rank[arg0_7.rankIds[arg1_7 + 1]]

	arg2_7.name = var0_7.id

	LoadImageSpriteAsync("island/islandrestaurant/" .. var0_7.icon, arg2_7:Find("icon"))
	setText(arg2_7:Find("info/top/name"), var0_7.name)

	local var1_7 = arg2_7:Find("info/bottom/content")

	setText(var1_7:Find("shelf/info/value"), var0_7.slot_num[1])
	setText(var1_7:Find("capacity/info/value"), var0_7.slot_num[2])
	setText(var1_7:Find("percent/info/value"), var0_7.bonus_coefficient / 100 .. "%")
	setText(var1_7:Find("assistant/info/value"), var0_7.assistant_num)
	setActive(arg2_7:Find("dot/silder"), arg1_7 + 1 ~= #arg0_7.rankIds)
end

function var0_0.UpdataItem(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg0_8.rankIds[arg1_8 + 1]
	local var1_8 = arg0_8.rankIds[arg1_8]
	local var2_8 = arg0_8.expData[var0_8]
	local var3_8 = var0_8 <= arg0_8.level

	setActive(arg2_8:Find("dot/finished"), var3_8)
	setActive(arg2_8:Find("info/top/finished"), var3_8)
	setActive(arg2_8:Find("info/top/exp"), not var3_8)

	local var4_8 = arg0_8.expData[var1_8] or 0
	local var5_8 = 0

	if var2_8 ~= var4_8 then
		var5_8 = (arg0_8.sales - var4_8) / (var2_8 - var4_8)
	end

	setSlider(arg2_8:Find("dot/silder"), 0, 1, var5_8)
	setText(arg2_8:Find("info/top/exp/value"), arg0_8.sales .. "/" .. var4_8)
end

function var0_0.OnShow(arg0_9, arg1_9)
	arg0_9:BlurPanel()

	arg0_9.rest = getProxy(IslandProxy):GetIsland():GetManageAgency():GetRestaurant(arg1_9)
	arg0_9.level = arg0_9.rest:GetRankLevel()
	arg0_9.sales = arg0_9.rest:GetSales()
	arg0_9.expData = IslandRestaurant.GET_RNAK_EXPS(arg1_9)

	arg0_9.uiList:align(#arg0_9.rankIds)

	local var0_9 = {}

	arg0_9.uiList:eachActive(function(arg0_10, arg1_10)
		arg1_10:GetComponent(typeof(CanvasGroup)).alpha = 0

		table.insert(var0_9, function(arg0_11)
			arg1_10:GetComponent(typeof(CanvasGroup)).alpha = 1

			arg1_10:GetComponent(typeof(Animation)):Play()
			arg0_9:managedTween(LeanTween.delayedCall, function()
				arg0_11()
			end, 0.03, nil)
		end)
	end)
	seriesAsync(var0_9, function()
		scrollTo(arg0_9.viewTF, 0, 1 - (arg0_9.level - 1) / (#arg0_9.rankIds - 3))
	end)
end

function var0_0.OnHide(arg0_14)
	arg0_14:UnBlurPanel()
end

function var0_0.OnDestroy(arg0_15)
	arg0_15:OnHide()
end

return var0_0
