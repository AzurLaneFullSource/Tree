local var0_0 = class("IslandPostRestPanel", import("view.base.BaseSubView"))

var0_0.MAX_ASSISTANT_CNT = 2
var0_0.MAX_SHELF_CNT = 5
var0_0.ScrollValue = 0

function var0_0.getUIName(arg0_1)
	return "IslandPostRestPanel"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.scrollTF = arg0_2._tf:Find("view")

	local var0_2 = arg0_2._tf:Find("view/content")
	local var1_2 = var0_2:Find("tpl")

	setText(var1_2:Find("btns/opening/Text"), i18n("island_manage_view"))
	setText(var1_2:Find("btns/close/Text"), i18n("island_manage_result"))
	setText(var1_2:Find("btns/lock/Text"), i18n("word_lock"))
	setText(var1_2:Find("name/event/Text"), i18n("island_post_event_label"))

	arg0_2.uiList = UIItemList.New(var0_2, var1_2)
end

function var0_0.OnInit(arg0_3)
	arg0_3.restIds = pg.island_set.post_manage_operate.key_value_varchar

	arg0_3.uiList:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventInit then
			arg0_3:InitItem(arg1_4, arg2_4)
		elseif arg0_4 == UIItemList.EventUpdate then
			arg0_3:UpdateItem(arg1_4, arg2_4)
		end
	end)
	onScroll(arg0_3, arg0_3.scrollTF, function(arg0_5)
		var0_0.ScrollValue = arg0_5.x
	end)
end

function var0_0.TriggerEvent(arg0_6, arg1_6)
	local var0_6 = -1

	for iter0_6, iter1_6 in ipairs(arg0_6.restIds) do
		if iter1_6 == arg1_6 then
			var0_6 = iter0_6

			break
		end
	end

	if var0_6 < 0 then
		return
	end

	arg0_6.uiList:eachActive(function(arg0_7, arg1_7)
		if arg0_7 + 1 == var0_6 then
			triggerButton(arg1_7:Find("btns/opening"))
		end
	end)
end

function var0_0.InitItem(arg0_8, arg1_8, arg2_8)
	onButton(arg0_8, arg2_8:Find("btns/prepare"), function()
		arg0_8:OpenRestaurant(arg0_8.restIds[arg1_8 + 1])
	end, SFX_PANEL)
	onButton(arg0_8, arg2_8:Find("btns/opening"), function()
		arg0_8:OpenRestaurant(arg0_8.restIds[arg1_8 + 1])
	end, SFX_PANEL)
	onButton(arg0_8, arg2_8:Find("btns/close"), function()
		arg0_8:OpenRestaurant(arg0_8.restIds[arg1_8 + 1])
	end, SFX_PANEL)
end

function var0_0.OpenRestaurant(arg0_12, arg1_12)
	arg0_12:emit(IslandMediator.OPEN_PAGE, "IslandRestaurantPage", {
		arg1_12,
		true
	})
end

function var0_0.UpdateItem(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg0_13.restIds[arg1_13 + 1]

	arg2_13.name = var0_13

	local var1_13 = pg.island_manage_restaurant[var0_13].name

	setText(arg2_13:Find("name"), var1_13)

	local var2_13 = arg0_13.rests[var0_13]

	setActive(arg2_13:Find("lock"), not var2_13)
	setActive(arg2_13:Find("btns/lock"), not var2_13)
	setActive(arg2_13:Find("rank"), var2_13)
	setActive(arg2_13:Find("opening"), var2_13 and var2_13:GetStatus() == IslandRestaurant.STATUS.OPENING)

	if var2_13 then
		local var3_13 = var2_13:GetEventInfo()

		setActive(arg2_13:Find("name/event"), var2_13:GetEventInfo() ~= 0)
	else
		setActive(arg2_13:Find("name/event"), false)
	end

	onButton(arg0_13, arg2_13:Find("name/event"), function()
		arg0_13:emit(IslandPostManagePage.EVENT_SHOW_SP_EVENT_TIP, var2_13, false)
	end, SFX_PANEL)

	local var4_13 = var2_13 and var2_13:GetAssistants() or {}

	UIItemList.StaticAlign(arg2_13:Find("ships"), arg2_13:Find("ships/tpl"), var0_0.MAX_ASSISTANT_CNT, function(arg0_15, arg1_15, arg2_15)
		if arg0_15 == UIItemList.EventUpdate then
			local var0_15 = var4_13[arg1_15 + 1]

			setActive(arg2_15:Find("lock"), not var0_15)

			local var1_15 = var0_15 and var0_15.shipId

			setActive(arg2_15:Find("icon"), var1_15 and var1_15 ~= 0)

			if var1_15 and var1_15 ~= 0 then
				local var2_15 = IslandShip.StaticGetPrefab(var1_15)

				LoadImageSpriteAsync("squareicon/" .. var2_15, arg2_15:Find("icon"))
			end
		end
	end)

	local var5_13 = var2_13 and var2_13:GetCommondities() or {}
	local var6_13 = var2_13 and var2_13:GetShelfCnt() or 0

	UIItemList.StaticAlign(arg2_13:Find("shelfs"), arg2_13:Find("shelfs/tpl"), var0_0.MAX_SHELF_CNT, function(arg0_16, arg1_16, arg2_16)
		if arg0_16 == UIItemList.EventUpdate then
			local var0_16 = var5_13[arg1_16 + 1]
			local var1_16 = var6_13 < arg1_16 + 1

			setActive(arg2_16:Find("lock"), var1_16)
			setActive(arg2_16:Find("drop"), var0_16)

			if var0_16 then
				local var2_16 = Drop.New({
					type = DROP_TYPE_ISLAND_ITEM,
					id = var0_16.id,
					count = var0_16.num
				})

				updateCustomDrop(arg2_16:Find("drop"), var2_16)
			end
		end
	end)

	if var2_13 then
		local var7_13 = var2_13:getConfig("opening_number")
		local var8_13 = var2_13:GetRemainCnt()

		setText(arg2_13:Find("btns/prepare/Text"), string.format("%s(%d/%d)", i18n("island_manage_prepare"), var8_13, var7_13))
		setText(arg2_13:Find("btns/end/Text"), string.format("%s(%d/%d)", i18n("island_manage_daily_cnt_tip"), var8_13, var7_13))
		LoadImageSpriteAsync("island/islandrestaurant/" .. var2_13:GetRankIcon(), arg2_13:Find("rank"), true)
		arg0_13:UpdataStatusInfo(arg2_13, var2_13)
	end
end

function var0_0.UpdataStatusInfo(arg0_17, arg1_17, arg2_17)
	local var0_17 = arg2_17:GetStatus()

	if var0_17 == IslandRestaurant.STATUS.OPENING then
		local var1_17 = pg.TimeMgr.GetInstance()
		local var2_17 = arg2_17:GetEndTime() - var1_17:GetServerTime()

		setText(arg1_17:Find("opening/Text"), var1_17:DescCDTime(var2_17))
	end

	eachChild(arg1_17:Find("btns"), function(arg0_18)
		setActive(arg0_18, arg0_18.name == var0_17)
	end)
end

function var0_0.Show(arg0_19)
	arg0_19.super.Show(arg0_19)
	arg0_19:Flush()
	arg0_19:CheckEventTip()
	scrollTo(arg0_19.scrollTF, var0_0.ScrollValue)
end

function var0_0.CheckEventTip(arg0_20)
	if not getProxy(SettingsProxy):ShouldTipIslandRestEvet() then
		return
	end

	local var0_20

	for iter0_20, iter1_20 in pairs(arg0_20.rests) do
		local var1_20 = iter1_20:GetEventInfo()

		if iter1_20:GetEventInfo() ~= 0 then
			var0_20 = iter1_20

			break
		end
	end

	if var0_20 then
		arg0_20:emit(IslandPostManagePage.EVENT_SHOW_SP_EVENT_TIP, var0_20, true)
	end
end

function var0_0.Flush(arg0_21)
	arg0_21:StopTimer()

	arg0_21.rests = getProxy(IslandProxy):GetIsland():GetManageAgency():GetRestaurants()

	table.sort(arg0_21.restIds, CompareFuncs({
		function(arg0_22)
			return arg0_21.rests[arg0_22] and 0 or 1
		end,
		function(arg0_23)
			local var0_23 = arg0_21.rests[arg0_23]

			return var0_23 and arg0_21:GetStatusSortWeight(var0_23:GetStatus()) or 999
		end,
		function(arg0_24)
			return arg0_24
		end
	}))
	arg0_21.uiList:align(#arg0_21.restIds)
	arg0_21:StartTimer()
	arg0_21:UpdateTime()
end

function var0_0.GetStatusSortWeight(arg0_25, arg1_25)
	return switch(arg1_25, {
		[IslandRestaurant.STATUS.CLOSE] = function()
			return 1
		end,
		[IslandRestaurant.STATUS.PREPARE] = function()
			return 2
		end,
		[IslandRestaurant.STATUS.OPENING] = function()
			return 3
		end,
		[IslandRestaurant.STATUS.END] = function()
			return 4
		end
	}, function()
		return 999
	end)
end

function var0_0.UpdateTime(arg0_31)
	arg0_31.uiList:eachActive(function(arg0_32, arg1_32)
		local var0_32 = arg0_31.rests[arg0_31.restIds[arg0_32 + 1]]

		if var0_32 then
			arg0_31:UpdataStatusInfo(arg1_32, var0_32)
		end
	end)
end

function var0_0.StartTimer(arg0_33)
	arg0_33.timer = Timer.New(function()
		arg0_33:UpdateTime()
	end, 1, -1)

	arg0_33.timer:Start()
end

function var0_0.StopTimer(arg0_35)
	if arg0_35.timer ~= nil then
		arg0_35.timer:Stop()

		arg0_35.timer = nil
	end
end

function var0_0.OnHide(arg0_36)
	arg0_36:StopTimer()
end

function var0_0.OnDestroy(arg0_37)
	arg0_37:OnHide()
end

return var0_0
