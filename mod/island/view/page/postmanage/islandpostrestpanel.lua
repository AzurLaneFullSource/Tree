local var0_0 = class("IslandPostRestPanel", import("view.base.BaseSubView"))

var0_0.MAX_ASSISTANT_CNT = 2
var0_0.MAX_SHELF_CNT = 5

function var0_0.getUIName(arg0_1)
	return "IslandPostRestPanel"
end

function var0_0.OnLoaded(arg0_2)
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
end

function var0_0.TriggerEvent(arg0_5, arg1_5)
	local var0_5 = -1

	for iter0_5, iter1_5 in ipairs(arg0_5.restIds) do
		if iter1_5 == arg1_5 then
			var0_5 = iter0_5

			break
		end
	end

	if var0_5 < 0 then
		return
	end

	arg0_5.uiList:eachActive(function(arg0_6, arg1_6)
		if arg0_6 + 1 == var0_5 then
			triggerButton(arg1_6:Find("btns/opening"))
		end
	end)
end

function var0_0.InitItem(arg0_7, arg1_7, arg2_7)
	onButton(arg0_7, arg2_7:Find("btns/prepare"), function()
		arg0_7:OpenRestaurant(arg0_7.restIds[arg1_7 + 1])
	end, SFX_PANEL)
	onButton(arg0_7, arg2_7:Find("btns/opening"), function()
		arg0_7:OpenRestaurant(arg0_7.restIds[arg1_7 + 1])
	end, SFX_PANEL)
	onButton(arg0_7, arg2_7:Find("btns/close"), function()
		arg0_7:OpenRestaurant(arg0_7.restIds[arg1_7 + 1])
	end, SFX_PANEL)
end

function var0_0.OpenRestaurant(arg0_11, arg1_11)
	arg0_11:emit(IslandMediator.OPEN_PAGE, "IslandRestaurantPage", {
		arg1_11,
		true
	})
end

function var0_0.UpdateItem(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg0_12.restIds[arg1_12 + 1]

	arg2_12.name = var0_12

	local var1_12 = pg.island_manage_restaurant[var0_12].name

	setText(arg2_12:Find("name"), var1_12)

	local var2_12 = arg0_12.rests[var0_12]

	setActive(arg2_12:Find("lock"), not var2_12)
	setActive(arg2_12:Find("btns/lock"), not var2_12)
	setActive(arg2_12:Find("rank"), var2_12)
	setActive(arg2_12:Find("opening"), var2_12 and var2_12:GetStatus() == IslandRestaurant.STATUS.OPENING)

	if var2_12 then
		local var3_12 = var2_12:GetEventInfo()

		setActive(arg2_12:Find("name/event"), var2_12:GetEventInfo() ~= 0)
	else
		setActive(arg2_12:Find("name/event"), false)
	end

	onButton(arg0_12, arg2_12:Find("name/event"), function()
		arg0_12:emit(IslandPostManagePage.EVENT_SHOW_SP_EVENT_TIP, var2_12, false)
	end, SFX_PANEL)

	local var4_12 = var2_12 and var2_12:GetAssistants() or {}

	UIItemList.StaticAlign(arg2_12:Find("ships"), arg2_12:Find("ships/tpl"), var0_0.MAX_ASSISTANT_CNT, function(arg0_14, arg1_14, arg2_14)
		if arg0_14 == UIItemList.EventUpdate then
			local var0_14 = var4_12[arg1_14 + 1]

			setActive(arg2_14:Find("lock"), not var0_14)

			local var1_14 = var0_14 and var0_14.shipId

			setActive(arg2_14:Find("icon"), var1_14 and var1_14 ~= 0)

			if var1_14 and var1_14 ~= 0 then
				local var2_14 = IslandShip.StaticGetPrefab(var1_14)

				LoadImageSpriteAsync("squareicon/" .. var2_14, arg2_14:Find("icon"))
			end
		end
	end)

	local var5_12 = var2_12 and var2_12:GetCommondities() or {}
	local var6_12 = var2_12 and var2_12:GetShelfCnt() or 0

	UIItemList.StaticAlign(arg2_12:Find("shelfs"), arg2_12:Find("shelfs/tpl"), var0_0.MAX_SHELF_CNT, function(arg0_15, arg1_15, arg2_15)
		if arg0_15 == UIItemList.EventUpdate then
			local var0_15 = var5_12[arg1_15 + 1]
			local var1_15 = var6_12 < arg1_15 + 1

			setActive(arg2_15:Find("lock"), var1_15)
			setActive(arg2_15:Find("drop"), var0_15)

			if var0_15 then
				local var2_15 = Drop.New({
					type = DROP_TYPE_ISLAND_ITEM,
					id = var0_15.id,
					count = var0_15.num
				})

				updateCustomDrop(arg2_15:Find("drop"), var2_15)
			end
		end
	end)

	if var2_12 then
		local var7_12 = var2_12:getConfig("opening_number")
		local var8_12 = var2_12:GetRemainCnt()

		setText(arg2_12:Find("btns/prepare/Text"), string.format("%s(%d/%d)", i18n("island_manage_prepare"), var8_12, var7_12))
		setText(arg2_12:Find("btns/end/Text"), string.format("%s(%d/%d)", i18n("island_manage_daily_cnt_tip"), var8_12, var7_12))
		LoadImageSpriteAsync("island/islandrestaurant/" .. var2_12:GetRankIcon(), arg2_12:Find("rank"), true)
		arg0_12:UpdataStatusInfo(arg2_12, var2_12)
	end
end

function var0_0.UpdataStatusInfo(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg2_16:GetStatus()

	if var0_16 == IslandRestaurant.STATUS.OPENING then
		local var1_16 = pg.TimeMgr.GetInstance()
		local var2_16 = arg2_16:GetEndTime() - var1_16:GetServerTime()

		setText(arg1_16:Find("opening/Text"), var1_16:DescCDTime(var2_16))
	end

	eachChild(arg1_16:Find("btns"), function(arg0_17)
		setActive(arg0_17, arg0_17.name == var0_16)
	end)
end

function var0_0.Show(arg0_18)
	arg0_18.super.Show(arg0_18)
	arg0_18:Flush()
	arg0_18:CheckEventTip()
end

function var0_0.CheckEventTip(arg0_19)
	if not getProxy(SettingsProxy):ShouldTipIslandRestEvet() then
		return
	end

	local var0_19

	for iter0_19, iter1_19 in pairs(arg0_19.rests) do
		local var1_19 = iter1_19:GetEventInfo()

		if iter1_19:GetEventInfo() ~= 0 then
			var0_19 = iter1_19

			break
		end
	end

	if var0_19 then
		arg0_19:emit(IslandPostManagePage.EVENT_SHOW_SP_EVENT_TIP, var0_19, true)
	end
end

function var0_0.Flush(arg0_20)
	arg0_20:StopTimer()

	arg0_20.rests = getProxy(IslandProxy):GetIsland():GetManageAgency():GetRestaurants()

	table.sort(arg0_20.restIds, CompareFuncs({
		function(arg0_21)
			return arg0_20.rests[arg0_21] and 0 or 1
		end,
		function(arg0_22)
			local var0_22 = arg0_20.rests[arg0_22]

			return var0_22 and arg0_20:GetStatusSortWeight(var0_22:GetStatus()) or 999
		end,
		function(arg0_23)
			return arg0_23
		end
	}))
	arg0_20.uiList:align(#arg0_20.restIds)
	arg0_20:StartTimer()
	arg0_20:UpdateTime()
end

function var0_0.GetStatusSortWeight(arg0_24, arg1_24)
	return switch(arg1_24, {
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

function var0_0.UpdateTime(arg0_30)
	arg0_30.uiList:eachActive(function(arg0_31, arg1_31)
		local var0_31 = arg0_30.rests[arg0_30.restIds[arg0_31 + 1]]

		if var0_31 then
			arg0_30:UpdataStatusInfo(arg1_31, var0_31)
		end
	end)
end

function var0_0.StartTimer(arg0_32)
	arg0_32.timer = Timer.New(function()
		arg0_32:UpdateTime()
	end, 1, -1)

	arg0_32.timer:Start()
end

function var0_0.StopTimer(arg0_34)
	if arg0_34.timer ~= nil then
		arg0_34.timer:Stop()

		arg0_34.timer = nil
	end
end

function var0_0.OnHide(arg0_35)
	arg0_35:StopTimer()
end

function var0_0.OnDestroy(arg0_36)
	arg0_36:OnHide()
end

return var0_0
