local var0_0 = class("BuildShipPoolsPage", import("...base.BaseSubView"))

function var0_0.getResource(arg0_1)
	local var0_1 = {
		"ui/buildshipui_atlas"
	}

	local function var1_1(arg0_2)
		if noEmptyStr(arg0_2) and not table.contains(var0_1, arg0_2) then
			table.insert(var0_1, arg0_2)
		end
	end

	local function var2_1(arg0_3)
		if noEmptyStr(arg0_3) then
			table.insertto(var0_1, ResPathSupport.GetPaintingListByPaintingName(arg0_3))
		end
	end

	local function var3_1(arg0_4)
		if noEmptyStr(arg0_4) then
			var1_1(ResPathSupport.CombinePath(ResPathSupport.ConstPath.UI.BuildPainting, arg0_4))
		end
	end

	local var4_1 = getProxy(ActivityProxy)
	local var5_1 = getProxy(BuildShipProxy):GetPools()

	for iter0_1, iter1_1 in ipairs(var5_1 or {}) do
		local var6_1 = iter1_1:getConfigTable()
		local var7_1 = iter1_1:IsActivity() and var4_1:getBuildActivityCfgByID(var6_1.id) or var4_1:getNoneActBuildActivityCfgByID(var6_1.id)
		local var8_1

		if var7_1 then
			var8_1 = var7_1 and var7_1.bg
		else
			var8_1 = ResPathSupport.CombinePath(ResPathSupport.ConstPath.BG.LoadingBG, "bg_" .. var6_1.icon)
		end

		var1_1(var8_1)

		local var9_1 = var4_1:getBuildPoolActivity(iter1_1)

		if PLATFORM_CODE == PLATFORM_CH and var9_1 then
			var3_1(var9_1:getConfig("config_client").build_painting)
		end

		if iter1_1:IsActivity() then
			local var10_1 = pg.ship_data_create_exchange[iter1_1:GetActivityId()]

			if var10_1 and #var10_1.exchange_ship_id > 0 then
				local var11_1 = pg.ship_data_statistics[var10_1.exchange_ship_id[1]]
				local var12_1 = var11_1 and pg.ship_skin_template[var11_1.skin_id]

				var2_1(var12_1 and var12_1.painting)
			end
		end
	end

	for iter2_1, iter3_1 in ipairs(var4_1:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_BUILD_FREE)) do
		if not iter3_1:isEnd() then
			local var13_1 = iter3_1:getConfig("config_client")[1]
			local var14_1 = Drop.New({
				type = DROP_TYPE_VITEM,
				id = var13_1,
				count = iter3_1.data1
			})

			var1_1(var14_1:getConfig("icon"))
		end
	end

	local var15_1 = arg0_1.contextData and arg0_1.contextData.falgShip or getProxy(BayProxy):getShipById(getProxy(PlayerProxy):getData().character)

	var2_1(var15_1 and var15_1:getPainting())

	return table.insertto(var0_1, var0_0.super.getResource(arg0_1))
end

function var0_0.getUIName(arg0_5)
	return "BuildShipPoolsPageUI"
end

function var0_0.RefreshActivityBuildPool(arg0_6, arg1_6)
	local var0_6 = underscore.detect(arg0_6.pools, function(arg0_7)
		return arg0_7:IsActivity() and arg0_7.activityId == arg1_6.id
	end)

	if var0_6 then
		arg0_6:UpdateBuildPoolExchange(var0_6)
		arg0_6:UpdateTicket()
	end
end

function var0_0.RefreshFreeBuildActivity(arg0_8)
	for iter0_8, iter1_8 in pairs(arg0_8.freeActTimer) do
		iter1_8:Stop()
	end

	arg0_8.freeActTimer = {}

	for iter2_8, iter3_8 in ipairs(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_BUILD_FREE)) do
		if iter3_8:isEnd() == false then
			arg0_8.freeActTimer[iter3_8.id] = Timer.New(function()
				arg0_8:emit(BuildShipMediator.ON_UPDATE_ACT)
			end, iter3_8.stopTime - pg.TimeMgr.GetInstance():GetServerTime())

			arg0_8.freeActTimer[iter3_8.id]:Start()
		end
	end
end

function var0_0.RefreshRegularExchangeCount(arg0_10)
	if arg0_10.pool then
		arg0_10:UpdateRegularBuildPoolExchange(arg0_10.pool)
	end
end

function var0_0.OnLoaded(arg0_11)
	arg0_11.quickCount = arg0_11._tf:Find("gallery/res_items/item")
	arg0_11.useItemTF = arg0_11.quickCount:Find("Text")
	arg0_11.freeCount = arg0_11._tf:Find("gallery/res_items/ticket")
	arg0_11.ticketTF = arg0_11.freeCount:Find("Text")
	arg0_11.patingTF = arg0_11._tf:Find("painting")
	arg0_11.poolContainer = arg0_11._tf:Find("gallery/toggle_bg/bg/toggles")
	arg0_11.newTpl = arg0_11.poolContainer:Find("new")
	arg0_11.newPoolTpls = {
		arg0_11.newTpl
	}
	arg0_11.specialTpl = arg0_11.poolContainer:Find("special")
	arg0_11.specialPoolTpls = {
		arg0_11.specialTpl
	}
	arg0_11.lightTpl = arg0_11.poolContainer:Find("light")
	arg0_11.lightPoolTpls = {
		arg0_11.lightTpl
	}
	arg0_11.heavyTpl = arg0_11.poolContainer:Find("heavy")
	arg0_11.heavyPoolTpls = {
		arg0_11.heavyTpl
	}
	arg0_11.maskContainer = arg0_11._tf:Find("gallery/mask")
	arg0_11.buildPoolExchangeTF = arg0_11._tf:Find("gallery/exchange_bg")
	arg0_11.buildPoolExchangeGetBtn = arg0_11.buildPoolExchangeTF:Find("get")
	arg0_11.buildPoolExchangeTxt = arg0_11.buildPoolExchangeTF:Find("Text"):GetComponent(typeof(Text))
	arg0_11.buildPoolExchangeGetBtnMark = arg0_11.buildPoolExchangeGetBtn:Find("mark")
	arg0_11.buildPoolExchangeGetTxt = arg0_11.buildPoolExchangeGetBtn:Find("Text"):GetComponent(typeof(Text))
	arg0_11.buildPoolExchangeName = arg0_11.buildPoolExchangeTF:Find("name"):GetComponent(typeof(Text))
	arg0_11.rtRegularExchange = arg0_11._tf:Find("gallery/exchange_ur_bg")

	setText(arg0_11.rtRegularExchange:Find("name/Text"), i18n("Normalbuild_URexchange_text1"))
	onButton(arg0_11, arg0_11.rtRegularExchange:Find("name/icon"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("Normalbuild_URexchange_help")
		})
	end, SFX_PANEL)
	setText(arg0_11.rtRegularExchange:Find("count/name"), i18n("Normalbuild_URexchange_text2") .. ":")
	setText(arg0_11.rtRegularExchange:Find("show/Text"), i18n("Normalbuild_URexchange_text3"))
	setText(arg0_11.rtRegularExchange:Find("get/Text"), i18n("Normalbuild_URexchange_text4"))

	for iter0_11, iter1_11 in ipairs({
		arg0_11.rtRegularExchange:Find("show"),
		arg0_11.rtRegularExchange:Find("get")
	}) do
		onButton(arg0_11, iter1_11, function()
			arg0_11:emit(BuildShipMediator.ON_BUILDPOOL_UR_EXCHANGE)
		end, SFX_PANEL)
	end

	arg0_11.tipSTxt = arg0_11._tf:Find("gallery/bg/type_intro/mask/title"):GetComponent("ScrollText")
	arg0_11.tipTime = arg0_11._tf:Find("gallery/bg/time_text")
	arg0_11.helpBtn = arg0_11._tf:Find("gallery/help_btn")
	arg0_11.testBtn = arg0_11._tf:Find("gallery/test_btn")
	arg0_11.prevArr = arg0_11._tf:Find("gallery/prev_arr")
	arg0_11.nextArr = arg0_11._tf:Find("gallery/next_arr")
	arg0_11.activityTimer = {}
	arg0_11.freeActTimer = {}
end

function var0_0.OnInit(arg0_14)
	onButton(arg0_14, arg0_14.quickCount, function()
		local var0_15 = 61008
		local var1_15 = ShopConst.GetShopConfig(var0_15)

		shoppingBatch(var0_15, {
			id = var1_15.effect_args[1]
		}, 9, "build_ship_quickly_buy_stone")
	end)
	onButton(arg0_14, arg0_14.helpBtn, function()
		local var0_16 = arg0_14.pool
		local var1_16 = var0_16:getConfigTable()

		arg0_14.contextData.helpWindow:ExecuteAction("Show", var1_16, nil, var0_16:IsActivity())
	end, SFX_CANCEL)
end

function var0_0.Flush(arg0_17, arg1_17, arg2_17)
	local var0_17 = getProxy(ActivityProxy)

	arg0_17.pools = underscore.filter(arg1_17, function(arg0_18)
		local var0_18 = var0_17:getBuildPoolActivity(arg0_18)

		return tobool(arg2_17) == (var0_18 and var0_18:getConfig("type") == ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD or false)
	end)

	if #arg0_17.pools > 4 then
		arg0_17:AdjustToggleContainer()
	end

	local var1_17 = {}
	local var2_17 = arg0_17:ActivePool()
	local var3_17 = BuildShipScene.buildShipActPoolId

	arg0_17:RemoveAllTimer()
	eachChild(arg0_17.poolContainer, function(arg0_19)
		setActive(arg0_19, false)
	end)

	for iter0_17, iter1_17 in ipairs(arg0_17.pools) do
		local var4_17 = iter1_17:GetMark()
		local var5_17 = arg0_17:GetPoolTpl(var4_17)

		setActive(var5_17, true)

		if iter1_17:IsActivity() then
			arg0_17:AddActivityTimer(iter1_17)
		end

		local var6_17 = var5_17:Find("frame")

		removeOnToggle(var6_17)
		triggerToggle(var6_17, false)
		onToggle(arg0_17, var6_17, function(arg0_20)
			if arg0_20 then
				arg0_17:SwitchPool(iter1_17)
			end
		end, SFX_PANEL)

		var1_17[iter1_17:GetPoolId()] = var5_17
	end

	table.sort(arg0_17.pools, function(arg0_21, arg1_21)
		local var0_21 = arg0_21:GetSortCode()
		local var1_21 = arg1_21:GetSortCode()

		if var0_21 == var1_21 then
			return arg0_21:GetPoolId() > arg1_21:GetPoolId()
		else
			return var1_21 < var0_21
		end
	end)

	for iter2_17, iter3_17 in ipairs(arg0_17.pools) do
		var1_17[iter3_17:GetPoolId()]:SetAsFirstSibling()
	end

	local var7_17 = arg0_17:GetActivePool(var2_17, var3_17)

	triggerToggle(var1_17[var7_17:GetPoolId()]:Find("frame"), true)

	local var8_17
	local var9_17

	arg0_17.contextData.projectName = nil

	scrollTo(arg0_17.poolContainer.parent, 0, 1)
	arg0_17:RefreshFreeBuildActivity()
	arg0_17:UpdateItem(arg0_17.contextData.itemVO.count)
	onNextTick(function()
		arg0_17:UpdateArr(#arg0_17.pools)
	end)
end

local function var1_0(arg0_23)
	local var0_23 = _.select(arg0_23.pools, function(arg0_24)
		return arg0_24:GetMark() == BuildShipPool.BUILD_POOL_MARK_NEW
	end)

	table.sort(var0_23, function(arg0_25, arg1_25)
		return arg0_25:GetPoolId() < arg1_25:GetPoolId()
	end)

	return var0_23[1]
end

function var0_0.GetActivePool(arg0_26, arg1_26, arg2_26)
	if not arg1_26 then
		return nil
	end

	local var0_26

	if arg1_26 == BuildShipPool.BUILD_POOL_MARK_NEW then
		var0_26 = _.detect(arg0_26.pools, function(arg0_27)
			return arg0_27:GetPoolId() == arg2_26
		end) or var1_0(arg0_26)
	else
		var0_26 = _.detect(arg0_26.pools, function(arg0_28)
			return arg0_28:GetMark() == arg1_26
		end)
	end

	return var0_26 or arg0_26.pools[1]
end

function var0_0.AdjustToggleContainer(arg0_29)
	if not arg0_29.isInit then
		local var0_29 = arg0_29.poolContainer.parent

		SetParent(var0_29, arg0_29.maskContainer)

		local var1_29 = 0.85

		var0_29.sizeDelta, var0_29.localScale = var0_29.sizeDelta * (1 + (1 - var1_29)), Vector3(var1_29, var1_29, 1)

		local var2_29 = arg0_29.poolContainer:GetComponent(typeof(HorizontalLayoutGroup))

		var2_29.padding.left = 60
		var2_29.padding.right = 60
		var2_29.padding.top = 0
		arg0_29.isInit = true
	end
end

function var0_0.UpdateArr(arg0_30, arg1_30)
	if arg1_30 <= 4 then
		setActive(arg0_30.prevArr, false)
		setActive(arg0_30.nextArr, false)

		return
	end

	local var0_30 = getBounds(arg0_30.maskContainer)
	local var1_30 = arg0_30.poolContainer:GetChild(0)
	local var2_30 = arg0_30.poolContainer:GetChild(arg0_30.poolContainer.childCount - 1)

	onScroll(arg0_30, arg0_30.poolContainer.parent, function(arg0_31)
		local var0_31 = getBounds(var1_30)
		local var1_31 = getBounds(var2_30)

		setActive(arg0_30.prevArr, arg0_31.x > 0.01)
		setActive(arg0_30.nextArr, arg0_31.x < 0.99)
	end)
	onButton(arg0_30, arg0_30.prevArr, function()
		scrollTo(arg0_30.poolContainer.parent, 0, 1)
	end, SFX_PANEL)
	onButton(arg0_30, arg0_30.nextArr, function()
		scrollTo(arg0_30.poolContainer.parent, 1, 1)
	end, SFX_PANEL)
end

function var0_0.GetPoolTpl(arg0_34, arg1_34)
	assert(arg0_34[arg1_34 .. "PoolTpls"])

	local var0_34 = arg0_34[arg1_34 .. "PoolTpls"]

	if #var0_34 <= 0 then
		local var1_34 = arg0_34[arg1_34 .. "Tpl"]
		local var2_34 = var1_34:GetSiblingIndex()
		local var3_34 = Object.Instantiate(var1_34, arg0_34.poolContainer).transform

		var3_34:SetSiblingIndex(var2_34 + 1)

		return var3_34
	else
		return table.remove(var0_34, 1)
	end
end

function var0_0.ActivePool(arg0_35)
	local var0_35 = _.any(arg0_35.pools, function(arg0_36)
		return arg0_36:IsActivity()
	end)
	local var1_35 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILD)

	if arg0_35.contextData.activity and arg0_35.contextData.activity > 0 then
		arg0_35.contextData.projectName = BuildShipPool.BUILD_POOL_MARK_NEW

		local var2_35 = getProxy(ActivityProxy):getActivityById(arg0_35.contextData.activity)

		if var2_35 and not var2_35:isEnd() then
			BuildShipScene.buildShipActPoolId = var2_35:getConfig("config_id")
		end
	end

	local var3_35

	if arg0_35.contextData.projectName then
		var3_35 = arg0_35.contextData.projectName
	elseif BuildShipScene.projectName then
		if BuildShipScene.projectName == BuildShipPool.BUILD_POOL_MARK_NEW and not var0_35 then
			var3_35 = BuildShipPool.BUILD_POOL_MARK_HEAVY
		else
			var3_35 = BuildShipScene.projectName
		end
	elseif var0_35 then
		var3_35 = BuildShipPool.BUILD_POOL_MARK_NEW
	elseif var1_35 and not var1_35:isEnd() then
		local var4_35 = var1_35:getConfig("config_client").id
		local var5_35 = _.detect(arg0_35.pools, function(arg0_37)
			return arg0_37.id == var4_35
		end)

		var3_35 = var5_35 and var5_35:GetMark() or BuildShipPool.BUILD_POOL_MARK_HEAVY
	else
		var3_35 = arg0_35.contextData.projectName or BuildShipScene.projectName or BuildShipPool.BUILD_POOL_MARK_HEAVY
	end

	if not underscore.any(arg0_35.pools, function(arg0_38)
		return arg0_38:GetMark() == var3_35
	end) then
		return arg0_35.pools[1]:GetMark()
	else
		return var3_35
	end
end

function var0_0.UpdateItem(arg0_39, arg1_39)
	setText(arg0_39.useItemTF, arg1_39)
	Canvas.ForceUpdateCanvases()
end

function var0_0.UpdateTicket(arg0_40)
	local var0_40 = getProxy(ActivityProxy)
	local var1_40 = var0_40:getBuildFreeActivityByBuildId(arg0_40.pool.id)

	if var1_40 and not var1_40:isEnd() then
		local var2_40 = Drop.New({
			type = DROP_TYPE_VITEM,
			id = var1_40:getConfig("config_client")[1],
			count = var1_40.data1
		})
		local var3_40 = var1_40.stopTime - pg.TimeMgr.GetInstance():GetServerTime() < 259200

		setActive(arg0_40.freeCount:Find("tip"), var3_40 and var2_40.count > 0)
		LoadImageSpriteAtlasAsync(var2_40:getConfig("icon"), "", arg0_40.freeCount:Find("icon"))
		setText(arg0_40.ticketTF, var1_40.data1)
		onButton(arg0_40, arg0_40.freeCount, function()
			arg0_40:emit(BaseUI.ON_DROP, var2_40)
		end, SFX_PANEL)

		local var4_40 = arg0_40._tf:Find("gallery/item_bg/ticket")

		LoadImageSpriteAtlasAsync(var2_40:getConfig("icon"), "", var4_40:Find("icon"))
		setText(var4_40:Find("name"), var2_40:getConfig("name"))
		setText(var4_40:Find("tip"), i18n("build_ticket_description"))
	end

	local var5_40 = checkExist(var0_40:getBuildPoolActivity(arg0_40.pool), {
		"getConfig",
		{
			"type"
		}
	}) == ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD

	setText(arg0_40._tf:Find("gallery/prints/intro/text"), var5_40 and i18n("newserver_build_tip") or i18n("build_pools_intro"))
	setActive(arg0_40.freeCount, tobool(var1_40))
	setActive(arg0_40.quickCount, not var5_40)

	arg0_40.useTicket = var5_40 or var1_40 and var1_40.data1 > 0

	setActive(arg0_40._tf:Find("gallery/item_bg/item"), not arg0_40.useTicket)
	setActive(arg0_40._tf:Find("gallery/item_bg/gold"), not arg0_40.useTicket)
	setActive(arg0_40._tf:Find("gallery/item_bg/ticket"), arg0_40.useTicket)
end

function var0_0.SwitchPool(arg0_42, arg1_42)
	arg0_42.pool = arg1_42
	arg0_42.buildPainting = nil

	local var0_42 = getProxy(ActivityProxy)
	local var1_42 = var0_42:getBuildPoolActivity(arg1_42)

	if PLATFORM_CODE == PLATFORM_CH and var1_42 then
		arg0_42.buildPainting = var1_42:getConfig("config_client").build_painting
	end

	setActive(arg0_42.tipTime, var1_42 and var1_42:isVariableTime())

	if isActive(arg0_42.tipTime) then
		local var2_42 = pg.TimeMgr.GetInstance()
		local var3_42 = var1_42:getStartTime()
		local var4_42 = var1_42.stopTime

		setText(arg0_42.tipTime, var2_42:STimeDescC(var3_42, "%Y.%m.%d") .. " - " .. var2_42:STimeDescC(var4_42, "%m.%d %H:%M"))
	end

	local var5_42 = arg1_42:GetMark()
	local var6_42 = GetSpriteFromAtlas("ui/BuildShipUI_atlas", "sub_title_" .. var5_42)

	arg0_42._tf:Find("gallery/bg/type"):GetComponent(typeof(Image)).sprite = var6_42

	local var7_42 = arg1_42:getConfigTable()
	local var8_42
	local var9_42

	if arg1_42:IsActivity() then
		var8_42 = var0_42:getBuildActivityCfgByID(var7_42.id)
	else
		var8_42 = var0_42:getNoneActBuildActivityCfgByID(var7_42.id)
	end

	local var10_42 = arg1_42:IsActivity() and not arg1_42:IsNewServerBuild() and arg1_42:GetActivityTimeStr() or ""

	setText(arg0_42._tf:Find("gallery/bg/act_time"), var10_42)

	local var11_42 = HXSet.HxPath(var8_42 and var8_42.bg or "loadingbg/bg_" .. var7_42.icon)
	local var12_42 = LoadSprite(var11_42)
	local var13_42 = var8_42 and var8_42.buildship_tip

	arg0_42.tipSTxt:SetText(var13_42 and HXSet.hxLan(var13_42) or i18n("buildship_" .. var5_42 .. "_tip"))

	arg0_42._tf:Find("gallery/bg"):GetComponent(typeof(Image)).sprite = var12_42

	local var14_42 = arg0_42._tf:Find("gallery/item_bg/item/Text")
	local var15_42 = arg0_42._tf:Find("gallery/item_bg/gold/Text")

	setText(var14_42, var7_42.number_1)
	setText(var15_42, var7_42.use_gold)
	arg0_42:UpdateBuildPoolExchange(arg1_42)
	arg0_42:UpdateRegularBuildPoolExchange(arg1_42)
	arg0_42:UpdateTicket()
	arg0_42:UpdateTestBtn(arg1_42)
	arg0_42:UpdateBuildPoolPaiting(arg1_42)

	local var16_42 = {}

	if arg1_42:getConfig("exchange_count") > 0 then
		table.insert(var16_42, function(arg0_43)
			if getProxy(BuildShipProxy):getRegularExchangeCount() < pg.ship_data_create_exchange[REGULAR_BUILD_POOL_EXCHANGE_ID].exchange_request or PlayerPrefs.GetString("REGULAR_BUILD_MAX_TIP", "") == pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d") then
				arg0_43()
			else
				local var0_43 = pg.MsgboxMgr.GetInstance()

				local function var1_43(arg0_44)
					PlayerPrefs.SetString("REGULAR_BUILD_MAX_TIP", arg0_44 and pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d") or "")
				end

				var0_43:ShowMsgBox({
					showStopRemind = true,
					content = i18n("Normalbuild_URexchange_warning3"),
					stopRamindContent = i18n("dont_remind_today"),
					onYes = function()
						var1_43(var0_43.stopRemindToggle.isOn)
						arg0_43()
					end,
					onNo = function()
						var1_43(var0_43.stopRemindToggle.isOn)
					end
				})
			end
		end)
	end

	onButton(arg0_42, arg0_42._tf:Find("gallery/start_btn"), function()
		seriesAsync(var16_42, function()
			local var0_48 = arg0_42.useTicket and var0_42:getBuildFreeActivityByBuildId(arg0_42.pool.id) or nil

			if arg0_42.useTicket and (not var0_48 or var0_48:isEnd()) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

				return
			end

			arg0_42.contextData.msgbox:ExecuteAction("Show", arg0_42.useTicket and {
				buildType = "ticket",
				itemVO = Item.New({
					id = var0_48:getConfig("config_client")[1],
					count = var0_48.data1
				}),
				buildPool = var7_42,
				max = MAX_BUILD_WORK_COUNT - arg0_42.contextData.startCount,
				onConfirm = function(arg0_49)
					if arg1_42:IsActivity() then
						arg0_42:emit(BuildShipMediator.ACT_ON_BUILD, arg1_42:GetActivityId(), var7_42.id, arg0_49, true)
					else
						arg0_42:emit(BuildShipMediator.ON_BUILD, var7_42.id, arg0_49, true)
					end
				end
			} or {
				buildType = "base",
				player = arg0_42.contextData.player,
				itemVO = arg0_42.contextData.itemVO,
				buildPool = var7_42,
				max = MAX_BUILD_WORK_COUNT - arg0_42.contextData.startCount,
				onConfirm = function(arg0_50)
					if arg1_42:IsActivity() then
						arg0_42:emit(BuildShipMediator.ACT_ON_BUILD, arg1_42:GetActivityId(), var7_42.id, arg0_50)
					else
						arg0_42:emit(BuildShipMediator.ON_BUILD, var7_42.id, arg0_50)
					end
				end
			})
		end)
	end, SFX_UI_BUILDING_STARTBUILDING)

	BuildShipScene.projectName = var5_42

	if arg1_42:IsActivity() then
		BuildShipScene.buildShipActPoolId = arg1_42:GetPoolId()
	end
end

local function var2_0(arg0_51)
	if not arg0_51:IsActivity() then
		return false
	end

	local var0_51 = pg.ship_data_create_exchange[arg0_51:GetActivityId()]

	return var0_51 and #var0_51.exchange_ship_id > 0
end

function var0_0.UpdateBuildPoolPaiting(arg0_52, arg1_52)
	local var0_52

	if arg0_52.buildPainting then
		var0_52 = arg0_52.buildPainting
	elseif var2_0(arg1_52) then
		local var1_52 = pg.ship_data_create_exchange[arg1_52:GetActivityId()].exchange_ship_id[1]
		local var2_52 = pg.ship_data_statistics[var1_52]

		assert(var2_52)

		var0_52 = pg.ship_skin_template[var2_52.skin_id].painting
	else
		var0_52 = arg0_52.contextData.falgShip:getPainting()
	end

	if arg0_52.painting ~= var0_52 then
		local function var3_52()
			arg0_52.painting = var0_52

			arg0_52:Hx4Channel()
		end

		arg0_52:RevertHxChannel()

		if arg0_52.buildPainting then
			setBuildPaintingPrefabAsync(arg0_52.patingTF, var0_52, "build", var3_52)
		else
			setPaintingPrefabAsync(arg0_52.patingTF, var0_52, "build", var3_52)
		end
	end
end

local function var3_0(arg0_54)
	local var0_54 = arg0_54.patingTF:Find("fitter")

	if var0_54.childCount <= 0 then
		return nil
	end

	local var1_54 = var0_54:GetChild(0)

	if IsNil(var1_54) then
		return nil
	end

	local var2_54 = pg.SdkMgr.GetInstance():GetChannelUIDIncludeHarmony()

	return (var1_54:Find("build_hx_ch" .. var2_54))
end

function var0_0.Hx4Channel(arg0_55)
	local var0_55 = var3_0(arg0_55)

	if not IsNil(var0_55) then
		setActive(var0_55, HXSet.isHx())
	end
end

function var0_0.RevertHxChannel(arg0_56)
	local var0_56 = var3_0(arg0_56)

	if not IsNil(var0_56) then
		setActive(var0_56, false)
	end
end

function var0_0.UpdateBuildPoolExchange(arg0_57, arg1_57)
	local var0_57
	local var1_57
	local var2_57

	if arg1_57:IsActivity() then
		local var3_57 = arg1_57:GetActivityId()
		local var4_57 = pg.ship_data_create_exchange[var3_57]

		if var4_57 then
			var0_57 = var4_57.exchange_request
			var1_57 = var4_57.exchange_available_times
			var2_57 = var4_57.exchange_ship_id[1]
		end
	end

	local var5_57 = var0_57 and var0_57 > 0 and var1_57 and var1_57 > 0

	if var5_57 then
		local var6_57 = arg1_57:GetActivity()
		local var7_57 = var6_57.data1
		local var8_57 = var6_57.data2
		local var9_57 = math.min(var1_57, var8_57 + 1) * var0_57

		arg0_57.buildPoolExchangeTxt.text = i18n("build_count_tip") .. "<color=#FFDF48>" .. var7_57 .. "</color>/" .. var9_57

		local var10_57 = var8_57 < var1_57 and var9_57 <= var7_57

		setActive(arg0_57.buildPoolExchangeGetBtnMark, var10_57)

		arg0_57.buildPoolExchangeGetTxt.text = var8_57 .. "/" .. var1_57

		local var11_57 = pg.ship_data_statistics[var2_57].name

		arg0_57.buildPoolExchangeName.text = SwitchSpecialChar(var11_57, true)

		local var12_57 = pg.ship_data_statistics[var2_57].rarity

		eachChild(arg0_57.buildPoolExchangeTF:Find("bg"), function(arg0_58)
			setActive(arg0_58, arg0_58.name == tostring(var12_57))
		end)
		onButton(arg0_57, arg0_57.buildPoolExchangeTF, function()
			if var10_57 then
				arg0_57:emit(BuildShipMediator.ON_BUILDPOOL_EXCHANGE, var6_57.id)
			end
		end, SFX_PANEL)
		setGray(arg0_57.buildPoolExchangeGetBtn, not var10_57, true)
		setButtonEnabled(arg0_57.buildPoolExchangeTF, var10_57)
	else
		removeOnButton(arg0_57.buildPoolExchangeTF)
	end

	setActive(arg0_57.buildPoolExchangeTF, var5_57)
end

function var0_0.UpdateRegularBuildPoolExchange(arg0_60, arg1_60)
	local var0_60 = arg1_60:getConfig("exchange_count") > 0

	setActive(arg0_60.rtRegularExchange, var0_60)

	if var0_60 then
		local var1_60 = getProxy(BuildShipProxy):getRegularExchangeCount()
		local var2_60 = pg.ship_data_create_exchange[REGULAR_BUILD_POOL_EXCHANGE_ID]

		setText(arg0_60.rtRegularExchange:Find("count/Text"), "<color=#FFDF48>" .. var1_60 .. "</color>/" .. var2_60.exchange_request)
		setActive(arg0_60.rtRegularExchange:Find("show"), var1_60 < var2_60.exchange_request)
		setActive(arg0_60.rtRegularExchange:Find("get"), var1_60 >= var2_60.exchange_request)
	end
end

function var0_0.UpdateTestBtn(arg0_61, arg1_61)
	local var0_61 = false

	if PLATFORM_CODE ~= PLATFORM_JP and arg1_61:IsActivity() and not arg1_61:IsEnd() then
		local var1_61 = arg1_61:GetStageId()

		if var1_61 then
			var0_61 = true

			onButton(arg0_61, arg0_61.testBtn, function()
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("juese_tiyan"),
					onYes = function()
						arg0_61:emit(BuildShipMediator.SIMULATION_BATTLE, var1_61)
					end
				})
			end, SFX_PANEL)
		end
	end

	setActive(arg0_61.testBtn, var0_61)
end

function var0_0.AddActivityTimer(arg0_64, arg1_64)
	arg0_64:RemoveActivityTimer(arg1_64)

	if arg1_64:IsActivity() then
		local var0_64 = arg1_64:GetActivity()

		assert(var0_64)

		local var1_64 = var0_64.stopTime - pg.TimeMgr.GetInstance():GetServerTime()

		arg0_64.activityTimer[arg1_64.id] = Timer.New(function()
			arg0_64:RemoveActivityTimer(arg1_64)
			arg0_64:emit(BuildShipMediator.ON_UPDATE_ACT)
		end, var1_64, 1)

		arg0_64.activityTimer[arg1_64.id]:Start()
	end
end

function var0_0.RemoveActivityTimer(arg0_66, arg1_66)
	if arg0_66.activityTimer[arg1_66.id] then
		arg0_66.activityTimer[arg1_66.id]:Stop()

		arg0_66.activityTimer[arg1_66.id] = nil
	end
end

function var0_0.RemoveAllTimer(arg0_67)
	for iter0_67, iter1_67 in pairs(arg0_67.activityTimer) do
		iter1_67:Stop()
	end

	arg0_67.activityTimer = {}

	for iter2_67, iter3_67 in pairs(arg0_67.freeActTimer) do
		iter3_67:Stop()
	end

	arg0_67.freeActTimer = {}
end

function var0_0.ShowOrHide(arg0_68, arg1_68)
	if arg1_68 then
		arg0_68:Show()
	else
		arg0_68:Hide()
	end
end

function var0_0.OnDestroy(arg0_69)
	arg0_69:RevertHxChannel()
	arg0_69:RemoveAllTimer()

	arg0_69.activityTimer = nil
end

return var0_0
