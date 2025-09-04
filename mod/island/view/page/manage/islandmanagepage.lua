local var0_0 = class("IslandManagePage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandManageUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.uiAnim = arg0_2._tf:GetComponent(typeof(Animation))
	arg0_2.uiAnimEvent = arg0_2._tf:GetComponent(typeof(DftAniEvent))

	arg0_2.uiAnimEvent:SetEndEvent(function()
		arg0_2.playingHideAnim = false

		var0_0.super.Hide(arg0_2)
	end)
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

function var0_0.OnInit(arg0_4)
	onButton(arg0_4, arg0_4._tf:Find("top/back"), function()
		arg0_4:Hide()
	end, SFX_PANEL)
	arg0_4.uiList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventInit then
			onButton(arg0_4, arg2_6:Find("btns/prepare"), function()
				arg0_4:OpenPage(IslandRestaurantPage, arg0_4.restIds[arg1_6 + 1])
			end, SFX_PANEL)
			onButton(arg0_4, arg2_6:Find("btns/opening"), function()
				arg0_4:OpenPage(IslandRestaurantPage, arg0_4.restIds[arg1_6 + 1])
			end, SFX_PANEL)
			onButton(arg0_4, arg2_6:Find("btns/close"), function()
				arg0_4:OpenPage(IslandRestaurantPage, arg0_4.restIds[arg1_6 + 1])
			end, SFX_PANEL)
		elseif arg0_6 == UIItemList.EventUpdate then
			arg0_4:UpdataRest(arg1_6, arg2_6)
		end
	end)

	arg0_4.restIds = pg.island_manage_restaurant.all
end

function var0_0.AddListeners(arg0_10)
	arg0_10:AddListener(IslandManageAgecny.UPDATE_RESTAURANT, arg0_10.Flush)
	arg0_10:AddListener(IslandManageAgecny.ADD_RESTAURANT, arg0_10.Flush)
	arg0_10:AddListener(IslandManageAgecny.ON_DAILY_REFRESH, arg0_10.Flush)
end

function var0_0.RemoveListeners(arg0_11)
	arg0_11:RemoveListener(IslandManageAgecny.UPDATE_RESTAURANT, arg0_11.Flush)
	arg0_11:RemoveListener(IslandManageAgecny.ADD_RESTAURANT, arg0_11.Flush)
	arg0_11:RemoveListener(IslandManageAgecny.ON_DAILY_REFRESH, arg0_11.Flush)
end

function var0_0.OnShow(arg0_12)
	arg0_12:BlurPanel()
	arg0_12:Flush()

	local var0_12 = {}

	arg0_12.uiList:eachActive(function(arg0_13, arg1_13)
		arg1_13:GetComponent(typeof(CanvasGroup)).alpha = 0

		table.insert(var0_12, function(arg0_14)
			arg1_13:GetComponent(typeof(Animation)):Play()
			arg0_12:managedTween(LeanTween.delayedCall, function()
				arg0_14()
			end, 0.05, nil)
		end)
	end)
	seriesAsync(var0_12)
end

function var0_0.OnEnable(arg0_16)
	arg0_16:Flush()
end

function var0_0.Flush(arg0_17)
	arg0_17.rests = getProxy(IslandProxy):GetIsland():GetManageAgency():GetRestaurants()

	table.sort(arg0_17.restIds, CompareFuncs({
		function(arg0_18)
			return arg0_17.rests[arg0_18] and 0 or 1
		end,
		function(arg0_19)
			return arg0_19
		end
	}))
	arg0_17.uiList:align(#arg0_17.restIds)
	arg0_17:StartTimer()
	arg0_17:UpdateTime()
end

function var0_0.UpdataRest(arg0_20, arg1_20, arg2_20)
	local var0_20 = arg0_20.restIds[arg1_20 + 1]
	local var1_20 = pg.island_manage_restaurant[var0_20]

	arg2_20.name = var0_20

	LoadImageSpriteAsync("island/islandrestaurant/" .. var1_20.icon, arg2_20:Find("bg"))
	setText(arg2_20:Find("bg/name/Text"), var1_20.name)
	setText(arg2_20:Find("bg/name_en/Text"), var1_20.name_en)

	local var2_20 = arg0_20.rests[var0_20]
	local var3_20 = not var2_20

	setActive(arg2_20:Find("bg/rank"), not var3_20)
	setActive(arg2_20:Find("bg/lock"), var3_20)
	setActive(arg2_20:Find("bg/event"), not var3_20)
	setActive(arg2_20:Find("bg/status"), not var3_20)
	setActive(arg2_20:Find("btns"), not var3_20)

	if var2_20 then
		local var4_20 = var2_20:getConfig("opening_number")
		local var5_20 = var2_20:GetRemainCnt()

		setText(arg2_20:Find("btns/prepare/Text"), string.format("%s(%d/%d)", i18n("island_manage_prepare"), var5_20, var4_20))
		setText(arg2_20:Find("btns/end/Text"), string.format("%s(%d/%d)", i18n("island_manage_daily_cnt_tip"), var5_20, var4_20))
		LoadImageSpriteAsync("island/islandrestaurant/" .. var2_20:GetRankIcon(), arg2_20:Find("bg/rank"))

		local var6_20 = var2_20:GetEventInfo()

		setActive(arg2_20:Find("bg/event"), var6_20 ~= 0)
		arg0_20:UpdataStatusInfo(arg2_20, var2_20)
	end
end

function var0_0.UpdataStatusInfo(arg0_21, arg1_21, arg2_21)
	local var0_21 = arg2_21:GetStatus()
	local var1_21 = var0_21 == IslandRestaurant.STATUS.OPENING or var0_21 == IslandRestaurant.STATUS.CLOSE

	setActive(arg1_21:Find("bg/status/prepare"), var0_21 == IslandRestaurant.STATUS.PREPARE)
	setActive(arg1_21:Find("bg/status/opening"), var1_21)
	setActive(arg1_21:Find("bg/status/end"), var0_21 == IslandRestaurant.STATUS.END)

	if var0_21 == IslandRestaurant.STATUS.OPENING then
		local var2_21 = pg.TimeMgr.GetInstance()
		local var3_21 = arg2_21:GetEndTime() - var2_21:GetServerTime()

		setText(arg1_21:Find("bg/status/opening/Text"), var2_21:DescCDTime(var3_21))
	elseif var0_21 == IslandRestaurant.STATUS.CLOSE then
		setText(arg1_21:Find("bg/status/opening/Text"), "00:00:00")
	end

	local var4_21 = arg2_21:GetStatus()

	eachChild(arg1_21:Find("btns"), function(arg0_22)
		setActive(arg0_22, arg0_22.name == var4_21)
	end)
end

function var0_0.UpdateTime(arg0_23)
	arg0_23.uiList:eachActive(function(arg0_24, arg1_24)
		local var0_24 = arg0_23.rests[arg0_23.restIds[arg0_24 + 1]]

		if var0_24 then
			arg0_23:UpdataStatusInfo(arg1_24, var0_24)
		end
	end)
end

function var0_0.StartTimer(arg0_25)
	arg0_25.timer = Timer.New(function()
		arg0_25:UpdateTime()
	end, 1, -1)

	arg0_25.timer:Start()
end

function var0_0.StopTimer(arg0_27)
	if arg0_27.timer ~= nil then
		arg0_27.timer:Stop()

		arg0_27.timer = nil
	end
end

function var0_0.Hide(arg0_28)
	if arg0_28.playingHideAnim then
		return
	end

	arg0_28.uiAnim:Play("anim_IslandManageUI_Out")

	arg0_28.playingHideAnim = true
end

function var0_0.OnHide(arg0_29)
	arg0_29:StopTimer()
	arg0_29:UnBlurPanel()
end

function var0_0.OnDisable(arg0_30)
	arg0_30:OnHide()
end

function var0_0.OnDestroy(arg0_31)
	arg0_31.uiAnimEvent:SetEndEvent(nil)
end

return var0_0
