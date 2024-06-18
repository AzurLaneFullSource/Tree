local var0_0 = class("BuildShipPoolsPage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "BuildShipPoolsPageUI"
end

function var0_0.RefreshActivityBuildPool(arg0_2, arg1_2)
	local var0_2 = underscore.detect(arg0_2.pools, function(arg0_3)
		return arg0_3:IsActivity() and arg0_3.activityId == arg1_2.id
	end)

	if var0_2 then
		arg0_2:UpdateBuildPoolExchange(var0_2)
		arg0_2:UpdateTicket()
	end
end

function var0_0.RefreshFreeBuildActivity(arg0_4)
	for iter0_4, iter1_4 in pairs(arg0_4.freeActTimer) do
		iter1_4:Stop()
	end

	arg0_4.freeActTimer = {}

	for iter2_4, iter3_4 in ipairs(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_BUILD_FREE)) do
		if iter3_4:isEnd() == false then
			arg0_4.freeActTimer[iter3_4.id] = Timer.New(function()
				arg0_4:emit(BuildShipMediator.ON_UPDATE_ACT)
			end, iter3_4.stopTime - pg.TimeMgr.GetInstance():GetServerTime())

			arg0_4.freeActTimer[iter3_4.id]:Start()
		end
	end
end

function var0_0.RefreshRegularExchangeCount(arg0_6)
	if arg0_6.pool then
		arg0_6:UpdateRegularBuildPoolExchange(arg0_6.pool)
	end
end

function var0_0.OnLoaded(arg0_7)
	arg0_7.quickCount = arg0_7:findTF("gallery/res_items/item")
	arg0_7.useItemTF = arg0_7:findTF("Text", arg0_7.quickCount)
	arg0_7.freeCount = arg0_7:findTF("gallery/res_items/ticket")
	arg0_7.ticketTF = arg0_7:findTF("Text", arg0_7.freeCount)
	arg0_7.patingTF = arg0_7:findTF("painting")
	arg0_7.poolContainer = arg0_7:findTF("gallery/toggle_bg/bg/toggles")
	arg0_7.newTpl = arg0_7.poolContainer:Find("new")
	arg0_7.newPoolTpls = {
		arg0_7.newTpl
	}
	arg0_7.specialTpl = arg0_7.poolContainer:Find("special")
	arg0_7.specialPoolTpls = {
		arg0_7.specialTpl
	}
	arg0_7.lightTpl = arg0_7.poolContainer:Find("light")
	arg0_7.lightPoolTpls = {
		arg0_7.lightTpl
	}
	arg0_7.heavyTpl = arg0_7.poolContainer:Find("heavy")
	arg0_7.heavyPoolTpls = {
		arg0_7.heavyTpl
	}
	arg0_7.maskContainer = arg0_7:findTF("gallery/mask")
	arg0_7.buildPoolExchangeTF = arg0_7:findTF("gallery/exchange_bg")
	arg0_7.buildPoolExchangeGetBtn = arg0_7.buildPoolExchangeTF:Find("get")
	arg0_7.buildPoolExchangeTxt = arg0_7.buildPoolExchangeTF:Find("Text"):GetComponent(typeof(Text))
	arg0_7.buildPoolExchangeGetBtnMark = arg0_7.buildPoolExchangeGetBtn:Find("mark")
	arg0_7.buildPoolExchangeGetTxt = arg0_7.buildPoolExchangeGetBtn:Find("Text"):GetComponent(typeof(Text))
	arg0_7.buildPoolExchangeName = arg0_7.buildPoolExchangeTF:Find("name"):GetComponent(typeof(Text))
	arg0_7.rtRegularExchange = arg0_7._tf:Find("gallery/exchange_ur_bg")

	setText(arg0_7.rtRegularExchange:Find("name/Text"), i18n("Normalbuild_URexchange_text1"))
	onButton(arg0_7, arg0_7.rtRegularExchange:Find("name/icon"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("Normalbuild_URexchange_help")
		})
	end, SFX_PANEL)
	setText(arg0_7.rtRegularExchange:Find("count/name"), i18n("Normalbuild_URexchange_text2") .. ":")
	setText(arg0_7.rtRegularExchange:Find("show/Text"), i18n("Normalbuild_URexchange_text3"))
	setText(arg0_7.rtRegularExchange:Find("get/Text"), i18n("Normalbuild_URexchange_text4"))

	for iter0_7, iter1_7 in ipairs({
		arg0_7.rtRegularExchange:Find("show"),
		arg0_7.rtRegularExchange:Find("get")
	}) do
		onButton(arg0_7, iter1_7, function()
			arg0_7:emit(BuildShipMediator.ON_BUILDPOOL_UR_EXCHANGE)
		end, SFX_PANEL)
	end

	arg0_7.tipSTxt = arg0_7:findTF("gallery/bg/type_intro/mask/title"):GetComponent("ScrollText")
	arg0_7.tipTime = arg0_7._tf:Find("gallery/bg/time_text")
	arg0_7.helpBtn = arg0_7:findTF("gallery/help_btn")
	arg0_7.testBtn = arg0_7:findTF("gallery/test_btn")
	arg0_7.prevArr = arg0_7:findTF("gallery/prev_arr")
	arg0_7.nextArr = arg0_7:findTF("gallery/next_arr")
	arg0_7.activityTimer = {}
	arg0_7.freeActTimer = {}
end

function var0_0.OnInit(arg0_10)
	onButton(arg0_10, arg0_10.quickCount, function()
		local var0_11 = pg.shop_template[61008]

		shoppingBatch(61008, {
			id = var0_11.effect_args[1]
		}, 9, "build_ship_quickly_buy_stone")
	end)
	onButton(arg0_10, arg0_10.helpBtn, function()
		local var0_12 = arg0_10.pool
		local var1_12 = var0_12:getConfigTable()

		arg0_10.contextData.helpWindow:ExecuteAction("Show", var1_12, nil, var0_12:IsActivity())
	end, SFX_CANCEL)
end

function var0_0.Flush(arg0_13, arg1_13, arg2_13)
	local var0_13 = getProxy(ActivityProxy)

	arg0_13.pools = underscore.filter(arg1_13, function(arg0_14)
		local var0_14 = var0_13:getBuildPoolActivity(arg0_14)

		return tobool(arg2_13) == (var0_14 and var0_14:getConfig("type") == ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD or false)
	end)

	if #arg0_13.pools > 4 then
		arg0_13:AdjustToggleContainer()
	end

	local var1_13 = {}
	local var2_13 = arg0_13:ActivePool()
	local var3_13 = BuildShipScene.buildShipActPoolId

	arg0_13:RemoveAllTimer()
	eachChild(arg0_13.poolContainer, function(arg0_15)
		setActive(arg0_15, false)
	end)

	for iter0_13, iter1_13 in ipairs(arg0_13.pools) do
		local var4_13 = iter1_13:GetMark()
		local var5_13 = arg0_13:GetPoolTpl(var4_13)

		setActive(var5_13, true)

		if iter1_13:IsActivity() then
			arg0_13:AddActivityTimer(iter1_13)
		end

		local var6_13 = var5_13:Find("frame")

		removeOnToggle(var6_13)
		triggerToggle(var6_13, false)
		onToggle(arg0_13, var6_13, function(arg0_16)
			if arg0_16 then
				arg0_13:SwitchPool(iter1_13)
			end
		end, SFX_PANEL)

		var1_13[iter1_13:GetPoolId()] = var5_13
	end

	table.sort(arg0_13.pools, function(arg0_17, arg1_17)
		local var0_17 = arg0_17:GetSortCode()
		local var1_17 = arg1_17:GetSortCode()

		if var0_17 == var1_17 then
			return arg0_17:GetPoolId() > arg1_17:GetPoolId()
		else
			return var1_17 < var0_17
		end
	end)

	for iter2_13, iter3_13 in ipairs(arg0_13.pools) do
		var1_13[iter3_13:GetPoolId()]:SetAsFirstSibling()
	end

	local var7_13 = arg0_13:GetActivePool(var2_13, var3_13)

	triggerToggle(var1_13[var7_13:GetPoolId()]:Find("frame"), true)

	local var8_13
	local var9_13

	arg0_13.contextData.projectName = nil

	scrollTo(arg0_13.poolContainer.parent, 0, 1)
	arg0_13:RefreshFreeBuildActivity()
	arg0_13:UpdateItem(arg0_13.contextData.itemVO.count)
	onNextTick(function()
		arg0_13:UpdateArr(#arg0_13.pools)
	end)
end

local function var1_0(arg0_19)
	local var0_19 = _.select(arg0_19.pools, function(arg0_20)
		return arg0_20:GetMark() == BuildShipPool.BUILD_POOL_MARK_NEW
	end)

	table.sort(var0_19, function(arg0_21, arg1_21)
		return arg0_21:GetPoolId() < arg1_21:GetPoolId()
	end)

	return var0_19[1]
end

function var0_0.GetActivePool(arg0_22, arg1_22, arg2_22)
	if not arg1_22 then
		return nil
	end

	local var0_22

	if arg1_22 == BuildShipPool.BUILD_POOL_MARK_NEW then
		var0_22 = _.detect(arg0_22.pools, function(arg0_23)
			return arg0_23:GetPoolId() == arg2_22
		end) or var1_0(arg0_22)
	else
		var0_22 = _.detect(arg0_22.pools, function(arg0_24)
			return arg0_24:GetMark() == arg1_22
		end)
	end

	return var0_22 or arg0_22.pools[1]
end

function var0_0.AdjustToggleContainer(arg0_25)
	if not arg0_25.isInit then
		local var0_25 = arg0_25.poolContainer.parent

		SetParent(var0_25, arg0_25.maskContainer)

		local var1_25 = 0.85

		var0_25.sizeDelta, var0_25.localScale = var0_25.sizeDelta * (1 + (1 - var1_25)), Vector3(var1_25, var1_25, 1)

		local var2_25 = arg0_25.poolContainer:GetComponent(typeof(HorizontalLayoutGroup))

		var2_25.padding.left = 60
		var2_25.padding.right = 60
		var2_25.padding.top = 0
		arg0_25.isInit = true
	end
end

function var0_0.UpdateArr(arg0_26, arg1_26)
	if arg1_26 <= 4 then
		setActive(arg0_26.prevArr, false)
		setActive(arg0_26.nextArr, false)

		return
	end

	local var0_26 = getBounds(arg0_26.maskContainer)
	local var1_26 = arg0_26.poolContainer:GetChild(0)
	local var2_26 = arg0_26.poolContainer:GetChild(arg0_26.poolContainer.childCount - 1)

	onScroll(arg0_26, arg0_26.poolContainer.parent, function(arg0_27)
		local var0_27 = getBounds(var1_26)
		local var1_27 = getBounds(var2_26)

		setActive(arg0_26.prevArr, arg0_27.x > 0.01)
		setActive(arg0_26.nextArr, arg0_27.x < 0.99)
	end)
	onButton(arg0_26, arg0_26.prevArr, function()
		scrollTo(arg0_26.poolContainer.parent, 0, 1)
	end, SFX_PANEL)
	onButton(arg0_26, arg0_26.nextArr, function()
		scrollTo(arg0_26.poolContainer.parent, 1, 1)
	end, SFX_PANEL)
end

function var0_0.GetPoolTpl(arg0_30, arg1_30)
	assert(arg0_30[arg1_30 .. "PoolTpls"])

	local var0_30 = arg0_30[arg1_30 .. "PoolTpls"]

	if #var0_30 <= 0 then
		local var1_30 = arg0_30[arg1_30 .. "Tpl"]
		local var2_30 = var1_30:GetSiblingIndex()
		local var3_30 = Object.Instantiate(var1_30, arg0_30.poolContainer).transform

		var3_30:SetSiblingIndex(var2_30 + 1)

		return var3_30
	else
		return table.remove(var0_30, 1)
	end
end

function var0_0.ActivePool(arg0_31)
	local var0_31 = _.any(arg0_31.pools, function(arg0_32)
		return arg0_32:IsActivity()
	end)
	local var1_31 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILD)

	if arg0_31.contextData.activity and arg0_31.contextData.activity > 0 then
		arg0_31.contextData.projectName = BuildShipPool.BUILD_POOL_MARK_NEW

		local var2_31 = getProxy(ActivityProxy):getActivityById(arg0_31.contextData.activity)

		if var2_31 and not var2_31:isEnd() then
			BuildShipScene.buildShipActPoolId = var2_31:getConfig("config_id")
		end
	end

	local var3_31

	if arg0_31.contextData.projectName then
		var3_31 = arg0_31.contextData.projectName
	elseif BuildShipScene.projectName then
		if BuildShipScene.projectName == BuildShipPool.BUILD_POOL_MARK_NEW and not var0_31 then
			var3_31 = BuildShipPool.BUILD_POOL_MARK_HEAVY
		else
			var3_31 = BuildShipScene.projectName
		end
	elseif var0_31 then
		var3_31 = BuildShipPool.BUILD_POOL_MARK_NEW
	elseif var1_31 and not var1_31:isEnd() then
		local var4_31 = var1_31:getConfig("config_client").id
		local var5_31 = _.detect(arg0_31.pools, function(arg0_33)
			return arg0_33.id == var4_31
		end)

		var3_31 = var5_31 and var5_31:GetMark() or BuildShipPool.BUILD_POOL_MARK_HEAVY
	else
		var3_31 = arg0_31.contextData.projectName or BuildShipScene.projectName or BuildShipPool.BUILD_POOL_MARK_HEAVY
	end

	if not underscore.any(arg0_31.pools, function(arg0_34)
		return arg0_34:GetMark() == var3_31
	end) then
		return arg0_31.pools[1]:GetMark()
	else
		return var3_31
	end
end

function var0_0.UpdateItem(arg0_35, arg1_35)
	setText(arg0_35.useItemTF, arg1_35)
	Canvas.ForceUpdateCanvases()
end

function var0_0.UpdateTicket(arg0_36)
	local var0_36 = getProxy(ActivityProxy)
	local var1_36 = var0_36:getBuildFreeActivityByBuildId(arg0_36.pool.id)

	if var1_36 and not var1_36:isEnd() then
		local var2_36 = Drop.New({
			type = DROP_TYPE_VITEM,
			id = var1_36:getConfig("config_client")[1],
			count = var1_36.data1
		})
		local var3_36 = var1_36.stopTime - pg.TimeMgr.GetInstance():GetServerTime() < 259200

		setActive(arg0_36.freeCount:Find("tip"), var3_36 and var2_36.count > 0)
		LoadImageSpriteAtlasAsync(var2_36:getConfig("icon"), "", arg0_36.freeCount:Find("icon"))
		setText(arg0_36.ticketTF, var1_36.data1)
		onButton(arg0_36, arg0_36.freeCount, function()
			arg0_36:emit(BaseUI.ON_DROP, var2_36)
		end, SFX_PANEL)

		local var4_36 = arg0_36:findTF("gallery/item_bg/ticket")

		LoadImageSpriteAtlasAsync(var2_36:getConfig("icon"), "", var4_36:Find("icon"))
		setText(var4_36:Find("name"), var2_36:getConfig("name"))
		setText(var4_36:Find("tip"), i18n("build_ticket_description"))
	end

	local var5_36 = checkExist(var0_36:getBuildPoolActivity(arg0_36.pool), {
		"getConfig",
		{
			"type"
		}
	}) == ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD

	setText(arg0_36:findTF("gallery/prints/intro/text"), var5_36 and i18n("newserver_build_tip") or i18n("build_pools_intro"))
	setActive(arg0_36.freeCount, tobool(var1_36))
	setActive(arg0_36.quickCount, not var5_36)

	arg0_36.useTicket = var5_36 or var1_36 and var1_36.data1 > 0

	setActive(arg0_36:findTF("gallery/item_bg/item"), not arg0_36.useTicket)
	setActive(arg0_36:findTF("gallery/item_bg/gold"), not arg0_36.useTicket)
	setActive(arg0_36:findTF("gallery/item_bg/ticket"), arg0_36.useTicket)
end

function var0_0.SwitchPool(arg0_38, arg1_38)
	arg0_38.pool = arg1_38
	arg0_38.buildPainting = nil

	local var0_38 = getProxy(ActivityProxy)
	local var1_38 = var0_38:getBuildPoolActivity(arg1_38)

	if PLATFORM_CODE == PLATFORM_CH and var1_38 then
		arg0_38.buildPainting = var1_38:getConfig("config_client").build_painting
	end

	setActive(arg0_38.tipTime, var1_38 and var1_38:isVariableTime())

	if isActive(arg0_38.tipTime) then
		local var2_38 = pg.TimeMgr.GetInstance()
		local var3_38 = var1_38:getStartTime()
		local var4_38 = var1_38.stopTime

		setText(arg0_38.tipTime, var2_38:STimeDescC(var3_38, "%Y.%m.%d") .. " - " .. var2_38:STimeDescC(var4_38, "%m.%d %H:%M"))
	end

	local var5_38 = arg1_38:GetMark()
	local var6_38 = GetSpriteFromAtlas("ui/BuildShipUI_atlas", "sub_title_" .. var5_38)

	arg0_38:findTF("gallery/bg/type"):GetComponent(typeof(Image)).sprite = var6_38

	local var7_38 = arg1_38:getConfigTable()
	local var8_38
	local var9_38

	if arg1_38:IsActivity() then
		var8_38 = var0_38:getBuildActivityCfgByID(var7_38.id)
	else
		var8_38 = var0_38:getNoneActBuildActivityCfgByID(var7_38.id)
	end

	local var10_38 = LoadSprite(var8_38 and var8_38.bg or "loadingbg/bg_" .. var7_38.icon)
	local var11_38 = var8_38 and var8_38.buildship_tip

	arg0_38.tipSTxt:SetText(var11_38 and HXSet.hxLan(var11_38) or i18n("buildship_" .. var5_38 .. "_tip"))

	arg0_38:findTF("gallery/bg"):GetComponent(typeof(Image)).sprite = var10_38

	local var12_38 = arg0_38:findTF("gallery/item_bg/item/Text")
	local var13_38 = arg0_38:findTF("gallery/item_bg/gold/Text")

	setText(var12_38, var7_38.number_1)
	setText(var13_38, var7_38.use_gold)
	arg0_38:UpdateBuildPoolExchange(arg1_38)
	arg0_38:UpdateRegularBuildPoolExchange(arg1_38)
	arg0_38:UpdateTicket()
	arg0_38:UpdateTestBtn(arg1_38)
	arg0_38:UpdateBuildPoolPaiting(arg1_38)

	local var14_38 = {}

	if arg1_38:getConfig("exchange_count") > 0 then
		table.insert(var14_38, function(arg0_39)
			if getProxy(BuildShipProxy):getRegularExchangeCount() < pg.ship_data_create_exchange[REGULAR_BUILD_POOL_EXCHANGE_ID].exchange_request or PlayerPrefs.GetString("REGULAR_BUILD_MAX_TIP", "") == pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d") then
				arg0_39()
			else
				local var0_39 = pg.MsgboxMgr.GetInstance()

				local function var1_39(arg0_40)
					PlayerPrefs.SetString("REGULAR_BUILD_MAX_TIP", arg0_40 and pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d") or "")
				end

				var0_39:ShowMsgBox({
					showStopRemind = true,
					content = i18n("Normalbuild_URexchange_warning3"),
					stopRamindContent = i18n("dont_remind_today"),
					onYes = function()
						var1_39(var0_39.stopRemindToggle.isOn)
						arg0_39()
					end,
					onNo = function()
						var1_39(var0_39.stopRemindToggle.isOn)
					end
				})
			end
		end)
	end

	onButton(arg0_38, arg0_38:findTF("gallery/start_btn"), function()
		seriesAsync(var14_38, function()
			local var0_44 = arg0_38.useTicket and var0_38:getBuildFreeActivityByBuildId(arg0_38.pool.id) or nil

			if arg0_38.useTicket and (not var0_44 or var0_44:isEnd()) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

				return
			end

			arg0_38.contextData.msgbox:ExecuteAction("Show", arg0_38.useTicket and {
				buildType = "ticket",
				itemVO = Item.New({
					id = var0_44:getConfig("config_client")[1],
					count = var0_44.data1
				}),
				buildPool = var7_38,
				max = MAX_BUILD_WORK_COUNT - arg0_38.contextData.startCount,
				onConfirm = function(arg0_45)
					if arg1_38:IsActivity() then
						arg0_38:emit(BuildShipMediator.ACT_ON_BUILD, arg1_38:GetActivityId(), var7_38.id, arg0_45, true)
					else
						arg0_38:emit(BuildShipMediator.ON_BUILD, var7_38.id, arg0_45, true)
					end
				end
			} or {
				buildType = "base",
				player = arg0_38.contextData.player,
				itemVO = arg0_38.contextData.itemVO,
				buildPool = var7_38,
				max = MAX_BUILD_WORK_COUNT - arg0_38.contextData.startCount,
				onConfirm = function(arg0_46)
					if arg1_38:IsActivity() then
						arg0_38:emit(BuildShipMediator.ACT_ON_BUILD, arg1_38:GetActivityId(), var7_38.id, arg0_46)
					else
						arg0_38:emit(BuildShipMediator.ON_BUILD, var7_38.id, arg0_46)
					end
				end
			})
		end)
	end, SFX_UI_BUILDING_STARTBUILDING)

	BuildShipScene.projectName = var5_38

	if arg1_38:IsActivity() then
		BuildShipScene.buildShipActPoolId = arg1_38:GetPoolId()
	end
end

local function var2_0(arg0_47)
	if not arg0_47:IsActivity() then
		return false
	end

	local var0_47 = pg.ship_data_create_exchange[arg0_47:GetActivityId()]

	return var0_47 and #var0_47.exchange_ship_id > 0
end

function var0_0.UpdateBuildPoolPaiting(arg0_48, arg1_48)
	local var0_48

	if arg0_48.buildPainting then
		var0_48 = arg0_48.buildPainting
	elseif var2_0(arg1_48) then
		local var1_48 = pg.ship_data_create_exchange[arg1_48:GetActivityId()].exchange_ship_id[1]
		local var2_48 = pg.ship_data_statistics[var1_48]

		assert(var2_48)

		var0_48 = pg.ship_skin_template[var2_48.skin_id].painting
	else
		var0_48 = arg0_48.contextData.falgShip:getPainting()
	end

	if arg0_48.painting ~= var0_48 then
		local function var3_48()
			arg0_48.painting = var0_48
		end

		if arg0_48.buildPainting then
			setBuildPaintingPrefabAsync(arg0_48.patingTF, var0_48, "build", var3_48)
		else
			setPaintingPrefabAsync(arg0_48.patingTF, var0_48, "build", var3_48)
		end
	end
end

function var0_0.UpdateBuildPoolExchange(arg0_50, arg1_50)
	local var0_50
	local var1_50
	local var2_50

	if arg1_50:IsActivity() then
		local var3_50 = arg1_50:GetActivityId()
		local var4_50 = pg.ship_data_create_exchange[var3_50]

		if var4_50 then
			var0_50 = var4_50.exchange_request
			var1_50 = var4_50.exchange_available_times
			var2_50 = var4_50.exchange_ship_id[1]
		end
	end

	local var5_50 = var0_50 and var0_50 > 0 and var1_50 and var1_50 > 0

	if var5_50 then
		local var6_50 = arg1_50:GetActivity()
		local var7_50 = var6_50.data1
		local var8_50 = var6_50.data2
		local var9_50 = math.min(var1_50, var8_50 + 1) * var0_50

		arg0_50.buildPoolExchangeTxt.text = i18n("build_count_tip") .. "<color=#FFDF48>" .. var7_50 .. "</color>/" .. var9_50

		local var10_50 = var8_50 < var1_50 and var9_50 <= var7_50

		setActive(arg0_50.buildPoolExchangeGetBtnMark, var10_50)

		arg0_50.buildPoolExchangeGetTxt.text = var8_50 .. "/" .. var1_50

		local var11_50 = pg.ship_data_statistics[var2_50].name

		arg0_50.buildPoolExchangeName.text = SwitchSpecialChar(var11_50, true)

		local var12_50 = pg.ship_data_statistics[var2_50].rarity

		eachChild(arg0_50.buildPoolExchangeTF:Find("bg"), function(arg0_51)
			setActive(arg0_51, arg0_51.name == tostring(var12_50))
		end)
		onButton(arg0_50, arg0_50.buildPoolExchangeTF, function()
			if var10_50 then
				arg0_50:emit(BuildShipMediator.ON_BUILDPOOL_EXCHANGE, var6_50.id)
			end
		end, SFX_PANEL)
		setGray(arg0_50.buildPoolExchangeGetBtn, not var10_50, true)
		setButtonEnabled(arg0_50.buildPoolExchangeTF, var10_50)
	else
		removeOnButton(arg0_50.buildPoolExchangeTF)
	end

	setActive(arg0_50.buildPoolExchangeTF, var5_50)
end

function var0_0.UpdateRegularBuildPoolExchange(arg0_53, arg1_53)
	local var0_53 = arg1_53:getConfig("exchange_count") > 0

	setActive(arg0_53.rtRegularExchange, var0_53)

	if var0_53 then
		local var1_53 = getProxy(BuildShipProxy):getRegularExchangeCount()
		local var2_53 = pg.ship_data_create_exchange[REGULAR_BUILD_POOL_EXCHANGE_ID]

		setText(arg0_53.rtRegularExchange:Find("count/Text"), "<color=#FFDF48>" .. var1_53 .. "</color>/" .. var2_53.exchange_request)
		setActive(arg0_53.rtRegularExchange:Find("show"), var1_53 < var2_53.exchange_request)
		setActive(arg0_53.rtRegularExchange:Find("get"), var1_53 >= var2_53.exchange_request)
	end
end

function var0_0.UpdateTestBtn(arg0_54, arg1_54)
	local var0_54 = false

	if PLATFORM_CODE ~= PLATFORM_JP and arg1_54:IsActivity() and not arg1_54:IsEnd() then
		local var1_54 = arg1_54:GetStageId()

		if var1_54 then
			var0_54 = true

			onButton(arg0_54, arg0_54.testBtn, function()
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("juese_tiyan"),
					onYes = function()
						arg0_54:emit(BuildShipMediator.SIMULATION_BATTLE, var1_54)
					end
				})
			end, SFX_PANEL)
		end
	end

	setActive(arg0_54.testBtn, var0_54)
end

function var0_0.AddActivityTimer(arg0_57, arg1_57)
	arg0_57:RemoveActivityTimer(arg1_57)

	if arg1_57:IsActivity() then
		local var0_57 = arg1_57:GetActivity()

		assert(var0_57)

		local var1_57 = var0_57.stopTime - pg.TimeMgr.GetInstance():GetServerTime()

		arg0_57.activityTimer[arg1_57.id] = Timer.New(function()
			arg0_57:RemoveActivityTimer(arg1_57)
			arg0_57:emit(BuildShipMediator.ON_UPDATE_ACT)
		end, var1_57, 1)

		arg0_57.activityTimer[arg1_57.id]:Start()
	end
end

function var0_0.RemoveActivityTimer(arg0_59, arg1_59)
	if arg0_59.activityTimer[arg1_59.id] then
		arg0_59.activityTimer[arg1_59.id]:Stop()

		arg0_59.activityTimer[arg1_59.id] = nil
	end
end

function var0_0.RemoveAllTimer(arg0_60)
	for iter0_60, iter1_60 in pairs(arg0_60.activityTimer) do
		iter1_60:Stop()
	end

	arg0_60.activityTimer = {}

	for iter2_60, iter3_60 in pairs(arg0_60.freeActTimer) do
		iter3_60:Stop()
	end

	arg0_60.freeActTimer = {}
end

function var0_0.ShowOrHide(arg0_61, arg1_61)
	if arg1_61 then
		arg0_61:Show()
	else
		arg0_61:Hide()
	end
end

function var0_0.OnDestroy(arg0_62)
	arg0_62:RemoveAllTimer()

	arg0_62.activityTimer = nil
end

return var0_0
