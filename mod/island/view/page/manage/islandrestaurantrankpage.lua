local var0_0 = class("IslandRestaurantRankPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandRestaurantRankUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.uiAnim = arg0_2._tf:GetComponent(typeof(Animation))
	arg0_2.uiAnimEvent = arg0_2._tf:GetComponent(typeof(DftAniEvent))

	arg0_2.uiAnimEvent:SetEndEvent(function()
		arg0_2.playingHideAnim = false

		var0_0.super.Hide(arg0_2)
	end)

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

function var0_0.OnInit(arg0_4)
	onButton(arg0_4, arg0_4._tf:Find("mask"), function()
		arg0_4:Hide()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4._tf:Find("window/close"), function()
		arg0_4:Hide()
	end, SFX_PANEL)
	arg0_4.uiList:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventInit then
			arg0_4:InitItem(arg1_7, arg2_7)
		elseif arg0_7 == UIItemList.EventUpdate then
			arg0_4:UpdataItem(arg1_7, arg2_7)
		end
	end)

	arg0_4.rankIds = pg.island_manage_rank.all

	table.sort(arg0_4.rankIds)
end

function var0_0.InitItem(arg0_8, arg1_8, arg2_8)
	local var0_8 = pg.island_manage_rank[arg0_8.rankIds[arg1_8 + 1]]

	arg2_8.name = var0_8.id

	LoadImageSpriteAsync("island/islandrestaurant/" .. var0_8.icon, arg2_8:Find("icon"))
	setText(arg2_8:Find("info/top/name"), var0_8.name)

	local var1_8 = arg2_8:Find("info/bottom/content")

	setText(var1_8:Find("shelf/info/value"), var0_8.slot_num[1])
	setText(var1_8:Find("capacity/info/value"), var0_8.slot_num[2])
	setText(var1_8:Find("percent/info/value"), var0_8.bonus_coefficient / 100 .. "%")
	setText(var1_8:Find("assistant/info/value"), var0_8.assistant_num)
	setActive(arg2_8:Find("dot/silder"), arg1_8 + 1 ~= #arg0_8.rankIds)
end

function var0_0.UpdataItem(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg0_9.rankIds[arg1_9 + 1]
	local var1_9 = arg0_9.rankIds[arg1_9]
	local var2_9 = arg0_9.expData[var0_9]
	local var3_9 = var0_9 <= arg0_9.level

	setActive(arg2_9:Find("dot/finished"), var3_9)
	setActive(arg2_9:Find("info/top/finished"), var3_9)
	setActive(arg2_9:Find("info/top/exp"), not var3_9)
	setText(arg2_9:Find("info/top/exp/value"), arg0_9.sales .. "/" .. var2_9)

	local var4_9 = arg0_9.expData[var1_9] or 0
	local var5_9 = (arg0_9.sales - var4_9) / (var2_9 - var4_9)

	setSlider(arg2_9:Find("dot/silder"), 0, 1, var5_9)
end

function var0_0.OnShow(arg0_10, arg1_10)
	arg0_10:BlurPanel()

	arg0_10.rest = getProxy(IslandProxy):GetIsland():GetManageAgency():GetRestaurant(arg1_10)
	arg0_10.level = arg0_10.rest:GetRankLevel()
	arg0_10.sales = arg0_10.rest:GetSales()
	arg0_10.expData = IslandRestaurant.GET_RNAK_EXPS(arg1_10)

	arg0_10.uiList:align(#arg0_10.rankIds)

	local var0_10 = {}

	arg0_10.uiList:eachActive(function(arg0_11, arg1_11)
		arg1_11:GetComponent(typeof(CanvasGroup)).alpha = 0

		table.insert(var0_10, function(arg0_12)
			arg1_11:GetComponent(typeof(CanvasGroup)).alpha = 1

			arg1_11:GetComponent(typeof(Animation)):Play()
			arg0_10:managedTween(LeanTween.delayedCall, function()
				arg0_12()
			end, 0.03, nil)
		end)
	end)
	seriesAsync(var0_10, function()
		scrollTo(arg0_10.viewTF, 0, 1 - (arg0_10.level - 1) / (#arg0_10.rankIds - 3))
	end)
end

function var0_0.HideByAnim(arg0_15)
	if arg0_15.playingHideAnim then
		return
	end

	arg0_15.uiAnim:Play("anim_IslandRestaurantRankUI_Out")

	arg0_15.playingHideAnim = true
end

function var0_0.OnHide(arg0_16)
	arg0_16:UnBlurPanel()
end

function var0_0.OnDestroy(arg0_17)
	arg0_17.uiAnimEvent:SetEndEvent(nil)
end

return var0_0
