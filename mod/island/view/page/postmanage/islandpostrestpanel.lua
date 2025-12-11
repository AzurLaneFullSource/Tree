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

function var0_0.InitItem(arg0_5, arg1_5, arg2_5)
	onButton(arg0_5, arg2_5:Find("btns/prepare"), function()
		arg0_5:OpenRestaurant(arg0_5.restIds[arg1_5 + 1])
	end, SFX_PANEL)
	onButton(arg0_5, arg2_5:Find("btns/opening"), function()
		arg0_5:OpenRestaurant(arg0_5.restIds[arg1_5 + 1])
	end, SFX_PANEL)
	onButton(arg0_5, arg2_5:Find("btns/close"), function()
		arg0_5:OpenRestaurant(arg0_5.restIds[arg1_5 + 1])
	end, SFX_PANEL)
end

function var0_0.OpenRestaurant(arg0_9, arg1_9)
	arg0_9:emit(IslandMediator.OPEN_PAGE, "IslandRestaurantPage", {
		arg1_9,
		true
	})
end

function var0_0.UpdateItem(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg0_10.restIds[arg1_10 + 1]

	arg2_10.name = var0_10

	local var1_10 = pg.island_manage_restaurant[var0_10].name

	setText(arg2_10:Find("name"), var1_10)

	local var2_10 = arg0_10.rests[var0_10]

	setActive(arg2_10:Find("lock"), not var2_10)
	setActive(arg2_10:Find("btns/lock"), not var2_10)
	setActive(arg2_10:Find("rank"), var2_10)
	setActive(arg2_10:Find("opening"), var2_10 and var2_10:GetStatus() == IslandRestaurant.STATUS.OPENING)

	if var2_10 then
		local var3_10 = var2_10:GetEventInfo()

		setActive(arg2_10:Find("name/event"), var2_10:GetEventInfo() ~= 0)
	else
		setActive(arg2_10:Find("name/event"), false)
	end

	local var4_10 = var2_10 and var2_10:GetAssistants() or {}

	UIItemList.StaticAlign(arg2_10:Find("ships"), arg2_10:Find("ships/tpl"), var0_0.MAX_ASSISTANT_CNT, function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventUpdate then
			local var0_11 = var4_10[arg1_11 + 1]

			setActive(arg2_11:Find("lock"), not var0_11)

			local var1_11 = var0_11 and var0_11.shipId

			setActive(arg2_11:Find("icon"), var1_11 and var1_11 ~= 0)

			if var1_11 and var1_11 ~= 0 then
				local var2_11 = IslandShip.StaticGetPrefab(var1_11)

				LoadImageSpriteAsync("squareicon/" .. var2_11, arg2_11:Find("icon"))
			end
		end
	end)

	local var5_10 = var2_10 and var2_10:GetCommondities() or {}
	local var6_10 = var2_10 and var2_10:GetShelfCnt() or 0

	UIItemList.StaticAlign(arg2_10:Find("shelfs"), arg2_10:Find("shelfs/tpl"), var0_0.MAX_SHELF_CNT, function(arg0_12, arg1_12, arg2_12)
		if arg0_12 == UIItemList.EventUpdate then
			local var0_12 = var5_10[arg1_12 + 1]
			local var1_12 = var6_10 < arg1_12 + 1

			setActive(arg2_12:Find("lock"), var1_12)
			setActive(arg2_12:Find("drop"), var0_12)

			if var0_12 then
				local var2_12 = Drop.New({
					type = DROP_TYPE_ISLAND_ITEM,
					id = var0_12.id,
					count = var0_12.num
				})

				updateCustomDrop(arg2_12:Find("drop"), var2_12)
			end
		end
	end)

	if var2_10 then
		local var7_10 = var2_10:getConfig("opening_number")
		local var8_10 = var2_10:GetRemainCnt()

		setText(arg2_10:Find("btns/prepare/Text"), string.format("%s(%d/%d)", i18n("island_manage_prepare"), var8_10, var7_10))
		setText(arg2_10:Find("btns/end/Text"), string.format("%s(%d/%d)", i18n("island_manage_daily_cnt_tip"), var8_10, var7_10))
		LoadImageSpriteAsync("island/islandrestaurant/" .. var2_10:GetRankIcon(), arg2_10:Find("rank"), true)
		arg0_10:UpdataStatusInfo(arg2_10, var2_10)
	end
end

function var0_0.UpdataStatusInfo(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg2_13:GetStatus()

	if var0_13 == IslandRestaurant.STATUS.OPENING then
		local var1_13 = pg.TimeMgr.GetInstance()
		local var2_13 = arg2_13:GetEndTime() - var1_13:GetServerTime()

		setText(arg1_13:Find("opening/Text"), var1_13:DescCDTime(var2_13))
	end

	eachChild(arg1_13:Find("btns"), function(arg0_14)
		setActive(arg0_14, arg0_14.name == var0_13)
	end)
end

function var0_0.Show(arg0_15)
	arg0_15.super.Show(arg0_15)
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
			local var0_18 = arg0_16.rests[arg0_18]

			return var0_18 and arg0_16:GetStatusSortWeight(var0_18:GetStatus()) or 999
		end,
		function(arg0_19)
			return arg0_19
		end
	}))
	arg0_16.uiList:align(#arg0_16.restIds)
	arg0_16:StartTimer()
	arg0_16:UpdateTime()
end

function var0_0.GetStatusSortWeight(arg0_20, arg1_20)
	return switch(arg1_20, {
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

function var0_0.UpdateTime(arg0_26)
	arg0_26.uiList:eachActive(function(arg0_27, arg1_27)
		local var0_27 = arg0_26.rests[arg0_26.restIds[arg0_27 + 1]]

		if var0_27 then
			arg0_26:UpdataStatusInfo(arg1_27, var0_27)
		end
	end)
end

function var0_0.StartTimer(arg0_28)
	arg0_28.timer = Timer.New(function()
		arg0_28:UpdateTime()
	end, 1, -1)

	arg0_28.timer:Start()
end

function var0_0.StopTimer(arg0_30)
	if arg0_30.timer ~= nil then
		arg0_30.timer:Stop()

		arg0_30.timer = nil
	end
end

function var0_0.OnHide(arg0_31)
	arg0_31:StopTimer()
end

function var0_0.OnDestroy(arg0_32)
	arg0_32:OnHide()
end

return var0_0
