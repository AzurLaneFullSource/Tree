local var0_0 = class("IslandManagePage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandManageUI"
end

function var0_0.OnLoaded(arg0_2)
	setText(arg0_2._tf:Find("top/title/Text"), i18n("island_manage_title"))

	local var0_2 = arg0_2._tf:Find("window/view/content")
	local var1_2 = var0_2:Find("tpl")

	setText(var1_2:Find("bg/event/Text"), i18n("island_manage_sp_event"))
	setText(var1_2:Find("bg/status/prepare/Text"), i18n("island_manage_no_work"))
	setText(var1_2:Find("bg/status/end/Text"), i18n("island_manage_end_work"))
	setText(var1_2:Find("btns/opening/Text"), i18n("island_manage_view"))
	setText(var1_2:Find("btns/close/Text"), i18n("island_manage_result"))

	arg0_2.uiList = UIItemList.New(var0_2, var1_2)
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf:Find("top/back"), function()
		arg0_3:Hide()
	end, SFX_PANEL)
	arg0_3.uiList:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventInit then
			onButton(arg0_3, arg2_5:Find("btns/prepare"), function()
				arg0_3:OpenPage(IslandRestaurantPage, arg0_3.restIds[arg1_5 + 1])
			end, SFX_PANEL)
			onButton(arg0_3, arg2_5:Find("btns/opening"), function()
				arg0_3:OpenPage(IslandRestaurantPage, arg0_3.restIds[arg1_5 + 1])
			end, SFX_PANEL)
			onButton(arg0_3, arg2_5:Find("btns/close"), function()
				arg0_3:OpenPage(IslandRestaurantPage, arg0_3.restIds[arg1_5 + 1])
			end, SFX_PANEL)
		elseif arg0_5 == UIItemList.EventUpdate then
			arg0_3:UpdataRest(arg1_5, arg2_5)
		end
	end)

	arg0_3.restIds = pg.island_manage_restaurant.all
end

function var0_0.AddListeners(arg0_9)
	arg0_9:AddListener(IslandManageAgecny.UPDATE_RESTAURANT, arg0_9.Flush)
	arg0_9:AddListener(IslandManageAgecny.ADD_RESTAURANT, arg0_9.Flush)
	arg0_9:AddListener(IslandManageAgecny.ON_DAILY_REFRESH, arg0_9.Flush)
end

function var0_0.RemoveListeners(arg0_10)
	arg0_10:RemoveListener(IslandManageAgecny.UPDATE_RESTAURANT, arg0_10.Flush)
	arg0_10:RemoveListener(IslandManageAgecny.ADD_RESTAURANT, arg0_10.Flush)
	arg0_10:RemoveListener(IslandManageAgecny.ON_DAILY_REFRESH, arg0_10.Flush)
end

function var0_0.OnShow(arg0_11)
	arg0_11:BlurPanel()
	arg0_11:Flush()

	local var0_11 = {}

	arg0_11.uiList:eachActive(function(arg0_12, arg1_12)
		arg1_12:GetComponent(typeof(CanvasGroup)).alpha = 0

		table.insert(var0_11, function(arg0_13)
			arg1_12:GetComponent(typeof(Animation)):Play()
			arg0_11:managedTween(LeanTween.delayedCall, function()
				arg0_13()
			end, 0.05, nil)
		end)
	end)
	seriesAsync(var0_11)
end

function var0_0.OnEnable(arg0_15)
	arg0_15:Flush()
end

function var0_0.Flush(arg0_16)
	arg0_16:StopTimer()

	arg0_16.rests = getProxy(IslandProxy):GetIsland():GetManageAgency():GetRestaurants()

	table.sort(arg0_16.restIds, CompareFuncs({
		function(arg0_17)
			return arg0_16.rests[arg0_17] and 0 or 1
		end,
		function(arg0_18)
			return arg0_18
		end
	}))
	arg0_16.uiList:align(#arg0_16.restIds)
	arg0_16:StartTimer()
	arg0_16:UpdateTime()
end

function var0_0.UpdataRest(arg0_19, arg1_19, arg2_19)
	local var0_19 = arg0_19.restIds[arg1_19 + 1]
	local var1_19 = pg.island_manage_restaurant[var0_19]

	arg2_19.name = var0_19

	LoadImageSpriteAsync("island/islandrestaurant/" .. var1_19.icon, arg2_19:Find("bg"))
	setText(arg2_19:Find("bg/name/Text"), var1_19.name)
	setText(arg2_19:Find("bg/name_en/Text"), var1_19.name_en)

	local var2_19 = arg0_19.rests[var0_19]
	local var3_19 = not var2_19

	setActive(arg2_19:Find("bg/rank"), not var3_19)
	setActive(arg2_19:Find("bg/lock"), var3_19)
	setActive(arg2_19:Find("bg/event"), not var3_19)
	setActive(arg2_19:Find("bg/status"), not var3_19)
	setActive(arg2_19:Find("btns"), not var3_19)

	if var2_19 then
		local var4_19 = var2_19:getConfig("opening_number")
		local var5_19 = var2_19:GetRemainCnt()

		setText(arg2_19:Find("btns/prepare/Text"), string.format("%s(%d/%d)", i18n("island_manage_prepare"), var5_19, var4_19))
		setText(arg2_19:Find("btns/end/Text"), string.format("%s(%d/%d)", i18n("island_manage_daily_cnt_tip"), var5_19, var4_19))
		LoadImageSpriteAsync("island/islandrestaurant/" .. var2_19:GetRankIcon(), arg2_19:Find("bg/rank"))

		local var6_19 = var2_19:GetEventInfo()

		setActive(arg2_19:Find("bg/event"), var6_19 ~= 0)
		arg0_19:UpdataStatusInfo(arg2_19, var2_19)
	end
end

function var0_0.UpdataStatusInfo(arg0_20, arg1_20, arg2_20)
	local var0_20 = arg2_20:GetStatus()
	local var1_20 = var0_20 == IslandRestaurant.STATUS.OPENING or var0_20 == IslandRestaurant.STATUS.CLOSE

	setActive(arg1_20:Find("bg/status/prepare"), var0_20 == IslandRestaurant.STATUS.PREPARE)
	setActive(arg1_20:Find("bg/status/opening"), var1_20)
	setActive(arg1_20:Find("bg/status/end"), var0_20 == IslandRestaurant.STATUS.END)

	if var0_20 == IslandRestaurant.STATUS.OPENING then
		local var2_20 = pg.TimeMgr.GetInstance()
		local var3_20 = arg2_20:GetEndTime() - var2_20:GetServerTime()

		setText(arg1_20:Find("bg/status/opening/Text"), var2_20:DescCDTime(var3_20))
	elseif var0_20 == IslandRestaurant.STATUS.CLOSE then
		setText(arg1_20:Find("bg/status/opening/Text"), "00:00:00")
	end

	eachChild(arg1_20:Find("btns"), function(arg0_21)
		setActive(arg0_21, arg0_21.name == var0_20)
	end)
end

function var0_0.UpdateTime(arg0_22)
	arg0_22.uiList:eachActive(function(arg0_23, arg1_23)
		local var0_23 = arg0_22.rests[arg0_22.restIds[arg0_23 + 1]]

		if var0_23 then
			arg0_22:UpdataStatusInfo(arg1_23, var0_23)
		end
	end)
end

function var0_0.StartTimer(arg0_24)
	arg0_24.timer = Timer.New(function()
		arg0_24:UpdateTime()
	end, 1, -1)

	arg0_24.timer:Start()
end

function var0_0.StopTimer(arg0_26)
	if arg0_26.timer ~= nil then
		arg0_26.timer:Stop()

		arg0_26.timer = nil
	end
end

function var0_0.OnHide(arg0_27)
	arg0_27:StopTimer()
	arg0_27:UnBlurPanel()
end

function var0_0.OnDisable(arg0_28)
	arg0_28:OnHide()
end

function var0_0.OnDestroy(arg0_29)
	return
end

return var0_0
