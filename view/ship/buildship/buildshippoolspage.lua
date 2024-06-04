local var0 = class("BuildShipPoolsPage", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "BuildShipPoolsPageUI"
end

function var0.RefreshActivityBuildPool(arg0, arg1)
	local var0 = underscore.detect(arg0.pools, function(arg0)
		return arg0:IsActivity() and arg0.activityId == arg1.id
	end)

	if var0 then
		arg0:UpdateBuildPoolExchange(var0)
		arg0:UpdateTicket()
	end
end

function var0.RefreshFreeBuildActivity(arg0)
	for iter0, iter1 in pairs(arg0.freeActTimer) do
		iter1:Stop()
	end

	arg0.freeActTimer = {}

	for iter2, iter3 in ipairs(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_BUILD_FREE)) do
		if iter3:isEnd() == false then
			arg0.freeActTimer[iter3.id] = Timer.New(function()
				arg0:emit(BuildShipMediator.ON_UPDATE_ACT)
			end, iter3.stopTime - pg.TimeMgr.GetInstance():GetServerTime())

			arg0.freeActTimer[iter3.id]:Start()
		end
	end
end

function var0.RefreshRegularExchangeCount(arg0)
	if arg0.pool then
		arg0:UpdateRegularBuildPoolExchange(arg0.pool)
	end
end

function var0.OnLoaded(arg0)
	arg0.quickCount = arg0:findTF("gallery/res_items/item")
	arg0.useItemTF = arg0:findTF("Text", arg0.quickCount)
	arg0.freeCount = arg0:findTF("gallery/res_items/ticket")
	arg0.ticketTF = arg0:findTF("Text", arg0.freeCount)
	arg0.patingTF = arg0:findTF("painting")
	arg0.poolContainer = arg0:findTF("gallery/toggle_bg/bg/toggles")
	arg0.newTpl = arg0.poolContainer:Find("new")
	arg0.newPoolTpls = {
		arg0.newTpl
	}
	arg0.specialTpl = arg0.poolContainer:Find("special")
	arg0.specialPoolTpls = {
		arg0.specialTpl
	}
	arg0.lightTpl = arg0.poolContainer:Find("light")
	arg0.lightPoolTpls = {
		arg0.lightTpl
	}
	arg0.heavyTpl = arg0.poolContainer:Find("heavy")
	arg0.heavyPoolTpls = {
		arg0.heavyTpl
	}
	arg0.maskContainer = arg0:findTF("gallery/mask")
	arg0.buildPoolExchangeTF = arg0:findTF("gallery/exchange_bg")
	arg0.buildPoolExchangeGetBtn = arg0.buildPoolExchangeTF:Find("get")
	arg0.buildPoolExchangeTxt = arg0.buildPoolExchangeTF:Find("Text"):GetComponent(typeof(Text))
	arg0.buildPoolExchangeGetBtnMark = arg0.buildPoolExchangeGetBtn:Find("mark")
	arg0.buildPoolExchangeGetTxt = arg0.buildPoolExchangeGetBtn:Find("Text"):GetComponent(typeof(Text))
	arg0.buildPoolExchangeName = arg0.buildPoolExchangeTF:Find("name"):GetComponent(typeof(Text))
	arg0.rtRegularExchange = arg0._tf:Find("gallery/exchange_ur_bg")

	setText(arg0.rtRegularExchange:Find("name/Text"), i18n("Normalbuild_URexchange_text1"))
	onButton(arg0, arg0.rtRegularExchange:Find("name/icon"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("Normalbuild_URexchange_help")
		})
	end, SFX_PANEL)
	setText(arg0.rtRegularExchange:Find("count/name"), i18n("Normalbuild_URexchange_text2") .. ":")
	setText(arg0.rtRegularExchange:Find("show/Text"), i18n("Normalbuild_URexchange_text3"))
	setText(arg0.rtRegularExchange:Find("get/Text"), i18n("Normalbuild_URexchange_text4"))

	for iter0, iter1 in ipairs({
		arg0.rtRegularExchange:Find("show"),
		arg0.rtRegularExchange:Find("get")
	}) do
		onButton(arg0, iter1, function()
			arg0:emit(BuildShipMediator.ON_BUILDPOOL_UR_EXCHANGE)
		end, SFX_PANEL)
	end

	arg0.tipSTxt = arg0:findTF("gallery/bg/type_intro/mask/title"):GetComponent("ScrollText")
	arg0.tipTime = arg0._tf:Find("gallery/bg/time_text")
	arg0.helpBtn = arg0:findTF("gallery/help_btn")
	arg0.testBtn = arg0:findTF("gallery/test_btn")
	arg0.prevArr = arg0:findTF("gallery/prev_arr")
	arg0.nextArr = arg0:findTF("gallery/next_arr")
	arg0.activityTimer = {}
	arg0.freeActTimer = {}
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.quickCount, function()
		local var0 = pg.shop_template[61008]

		shoppingBatch(61008, {
			id = var0.effect_args[1]
		}, 9, "build_ship_quickly_buy_stone")
	end)
	onButton(arg0, arg0.helpBtn, function()
		local var0 = arg0.pool
		local var1 = var0:getConfigTable()

		arg0.contextData.helpWindow:ExecuteAction("Show", var1, nil, var0:IsActivity())
	end, SFX_CANCEL)
end

function var0.Flush(arg0, arg1, arg2)
	local var0 = getProxy(ActivityProxy)

	arg0.pools = underscore.filter(arg1, function(arg0)
		local var0 = var0:getBuildPoolActivity(arg0)

		return tobool(arg2) == (var0 and var0:getConfig("type") == ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD or false)
	end)

	if #arg0.pools > 4 then
		arg0:AdjustToggleContainer()
	end

	local var1 = {}
	local var2 = arg0:ActivePool()
	local var3 = BuildShipScene.buildShipActPoolId

	arg0:RemoveAllTimer()
	eachChild(arg0.poolContainer, function(arg0)
		setActive(arg0, false)
	end)

	for iter0, iter1 in ipairs(arg0.pools) do
		local var4 = iter1:GetMark()
		local var5 = arg0:GetPoolTpl(var4)

		setActive(var5, true)

		if iter1:IsActivity() then
			arg0:AddActivityTimer(iter1)
		end

		local var6 = var5:Find("frame")

		removeOnToggle(var6)
		triggerToggle(var6, false)
		onToggle(arg0, var6, function(arg0)
			if arg0 then
				arg0:SwitchPool(iter1)
			end
		end, SFX_PANEL)

		var1[iter1:GetPoolId()] = var5
	end

	table.sort(arg0.pools, function(arg0, arg1)
		local var0 = arg0:GetSortCode()
		local var1 = arg1:GetSortCode()

		if var0 == var1 then
			return arg0:GetPoolId() > arg1:GetPoolId()
		else
			return var1 < var0
		end
	end)

	for iter2, iter3 in ipairs(arg0.pools) do
		var1[iter3:GetPoolId()]:SetAsFirstSibling()
	end

	local var7 = arg0:GetActivePool(var2, var3)

	triggerToggle(var1[var7:GetPoolId()]:Find("frame"), true)

	local var8
	local var9

	arg0.contextData.projectName = nil

	scrollTo(arg0.poolContainer.parent, 0, 1)
	arg0:RefreshFreeBuildActivity()
	arg0:UpdateItem(arg0.contextData.itemVO.count)
	onNextTick(function()
		arg0:UpdateArr(#arg0.pools)
	end)
end

local function var1(arg0)
	local var0 = _.select(arg0.pools, function(arg0)
		return arg0:GetMark() == BuildShipPool.BUILD_POOL_MARK_NEW
	end)

	table.sort(var0, function(arg0, arg1)
		return arg0:GetPoolId() < arg1:GetPoolId()
	end)

	return var0[1]
end

function var0.GetActivePool(arg0, arg1, arg2)
	if not arg1 then
		return nil
	end

	local var0

	if arg1 == BuildShipPool.BUILD_POOL_MARK_NEW then
		var0 = _.detect(arg0.pools, function(arg0)
			return arg0:GetPoolId() == arg2
		end) or var1(arg0)
	else
		var0 = _.detect(arg0.pools, function(arg0)
			return arg0:GetMark() == arg1
		end)
	end

	return var0 or arg0.pools[1]
end

function var0.AdjustToggleContainer(arg0)
	if not arg0.isInit then
		local var0 = arg0.poolContainer.parent

		SetParent(var0, arg0.maskContainer)

		local var1 = 0.85

		var0.sizeDelta, var0.localScale = var0.sizeDelta * (1 + (1 - var1)), Vector3(var1, var1, 1)

		local var2 = arg0.poolContainer:GetComponent(typeof(HorizontalLayoutGroup))

		var2.padding.left = 60
		var2.padding.right = 60
		var2.padding.top = 0
		arg0.isInit = true
	end
end

function var0.UpdateArr(arg0, arg1)
	if arg1 <= 4 then
		setActive(arg0.prevArr, false)
		setActive(arg0.nextArr, false)

		return
	end

	local var0 = getBounds(arg0.maskContainer)
	local var1 = arg0.poolContainer:GetChild(0)
	local var2 = arg0.poolContainer:GetChild(arg0.poolContainer.childCount - 1)

	onScroll(arg0, arg0.poolContainer.parent, function(arg0)
		local var0 = getBounds(var1)
		local var1 = getBounds(var2)

		setActive(arg0.prevArr, arg0.x > 0.01)
		setActive(arg0.nextArr, arg0.x < 0.99)
	end)
	onButton(arg0, arg0.prevArr, function()
		scrollTo(arg0.poolContainer.parent, 0, 1)
	end, SFX_PANEL)
	onButton(arg0, arg0.nextArr, function()
		scrollTo(arg0.poolContainer.parent, 1, 1)
	end, SFX_PANEL)
end

function var0.GetPoolTpl(arg0, arg1)
	assert(arg0[arg1 .. "PoolTpls"])

	local var0 = arg0[arg1 .. "PoolTpls"]

	if #var0 <= 0 then
		local var1 = arg0[arg1 .. "Tpl"]
		local var2 = var1:GetSiblingIndex()
		local var3 = Object.Instantiate(var1, arg0.poolContainer).transform

		var3:SetSiblingIndex(var2 + 1)

		return var3
	else
		return table.remove(var0, 1)
	end
end

function var0.ActivePool(arg0)
	local var0 = _.any(arg0.pools, function(arg0)
		return arg0:IsActivity()
	end)
	local var1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILD)

	if arg0.contextData.activity and arg0.contextData.activity > 0 then
		arg0.contextData.projectName = BuildShipPool.BUILD_POOL_MARK_NEW

		local var2 = getProxy(ActivityProxy):getActivityById(arg0.contextData.activity)

		if var2 and not var2:isEnd() then
			BuildShipScene.buildShipActPoolId = var2:getConfig("config_id")
		end
	end

	local var3

	if arg0.contextData.projectName then
		var3 = arg0.contextData.projectName
	elseif BuildShipScene.projectName then
		if BuildShipScene.projectName == BuildShipPool.BUILD_POOL_MARK_NEW and not var0 then
			var3 = BuildShipPool.BUILD_POOL_MARK_HEAVY
		else
			var3 = BuildShipScene.projectName
		end
	elseif var0 then
		var3 = BuildShipPool.BUILD_POOL_MARK_NEW
	elseif var1 and not var1:isEnd() then
		local var4 = var1:getConfig("config_client").id
		local var5 = _.detect(arg0.pools, function(arg0)
			return arg0.id == var4
		end)

		var3 = var5 and var5:GetMark() or BuildShipPool.BUILD_POOL_MARK_HEAVY
	else
		var3 = arg0.contextData.projectName or BuildShipScene.projectName or BuildShipPool.BUILD_POOL_MARK_HEAVY
	end

	if not underscore.any(arg0.pools, function(arg0)
		return arg0:GetMark() == var3
	end) then
		return arg0.pools[1]:GetMark()
	else
		return var3
	end
end

function var0.UpdateItem(arg0, arg1)
	setText(arg0.useItemTF, arg1)
	Canvas.ForceUpdateCanvases()
end

function var0.UpdateTicket(arg0)
	local var0 = getProxy(ActivityProxy)
	local var1 = var0:getBuildFreeActivityByBuildId(arg0.pool.id)

	if var1 and not var1:isEnd() then
		local var2 = Drop.New({
			type = DROP_TYPE_VITEM,
			id = var1:getConfig("config_client")[1],
			count = var1.data1
		})
		local var3 = var1.stopTime - pg.TimeMgr.GetInstance():GetServerTime() < 259200

		setActive(arg0.freeCount:Find("tip"), var3 and var2.count > 0)
		LoadImageSpriteAtlasAsync(var2:getConfig("icon"), "", arg0.freeCount:Find("icon"))
		setText(arg0.ticketTF, var1.data1)
		onButton(arg0, arg0.freeCount, function()
			arg0:emit(BaseUI.ON_DROP, var2)
		end, SFX_PANEL)

		local var4 = arg0:findTF("gallery/item_bg/ticket")

		LoadImageSpriteAtlasAsync(var2:getConfig("icon"), "", var4:Find("icon"))
		setText(var4:Find("name"), var2:getConfig("name"))
		setText(var4:Find("tip"), i18n("build_ticket_description"))
	end

	local var5 = checkExist(var0:getBuildPoolActivity(arg0.pool), {
		"getConfig",
		{
			"type"
		}
	}) == ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD

	setText(arg0:findTF("gallery/prints/intro/text"), var5 and i18n("newserver_build_tip") or i18n("build_pools_intro"))
	setActive(arg0.freeCount, tobool(var1))
	setActive(arg0.quickCount, not var5)

	arg0.useTicket = var5 or var1 and var1.data1 > 0

	setActive(arg0:findTF("gallery/item_bg/item"), not arg0.useTicket)
	setActive(arg0:findTF("gallery/item_bg/gold"), not arg0.useTicket)
	setActive(arg0:findTF("gallery/item_bg/ticket"), arg0.useTicket)
end

function var0.SwitchPool(arg0, arg1)
	arg0.pool = arg1
	arg0.buildPainting = nil

	local var0 = getProxy(ActivityProxy)
	local var1 = var0:getBuildPoolActivity(arg1)

	if PLATFORM_CODE == PLATFORM_CH and var1 then
		arg0.buildPainting = var1:getConfig("config_client").build_painting
	end

	setActive(arg0.tipTime, var1 and var1:isVariableTime())

	if isActive(arg0.tipTime) then
		local var2 = pg.TimeMgr.GetInstance()
		local var3 = var1:getStartTime()
		local var4 = var1.stopTime

		setText(arg0.tipTime, var2:STimeDescC(var3, "%Y.%m.%d") .. " - " .. var2:STimeDescC(var4, "%m.%d %H:%M"))
	end

	local var5 = arg1:GetMark()
	local var6 = GetSpriteFromAtlas("ui/BuildShipUI_atlas", "sub_title_" .. var5)

	arg0:findTF("gallery/bg/type"):GetComponent(typeof(Image)).sprite = var6

	local var7 = arg1:getConfigTable()
	local var8
	local var9

	if arg1:IsActivity() then
		var8 = var0:getBuildActivityCfgByID(var7.id)
	else
		var8 = var0:getNoneActBuildActivityCfgByID(var7.id)
	end

	local var10 = LoadSprite(var8 and var8.bg or "loadingbg/bg_" .. var7.icon)
	local var11 = var8 and var8.buildship_tip

	arg0.tipSTxt:SetText(var11 and HXSet.hxLan(var11) or i18n("buildship_" .. var5 .. "_tip"))

	arg0:findTF("gallery/bg"):GetComponent(typeof(Image)).sprite = var10

	local var12 = arg0:findTF("gallery/item_bg/item/Text")
	local var13 = arg0:findTF("gallery/item_bg/gold/Text")

	setText(var12, var7.number_1)
	setText(var13, var7.use_gold)
	arg0:UpdateBuildPoolExchange(arg1)
	arg0:UpdateRegularBuildPoolExchange(arg1)
	arg0:UpdateTicket()
	arg0:UpdateTestBtn(arg1)
	arg0:UpdateBuildPoolPaiting(arg1)

	local var14 = {}

	if arg1:getConfig("exchange_count") > 0 then
		table.insert(var14, function(arg0)
			if getProxy(BuildShipProxy):getRegularExchangeCount() < pg.ship_data_create_exchange[REGULAR_BUILD_POOL_EXCHANGE_ID].exchange_request or PlayerPrefs.GetString("REGULAR_BUILD_MAX_TIP", "") == pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d") then
				arg0()
			else
				local var0 = pg.MsgboxMgr.GetInstance()

				local function var1(arg0)
					PlayerPrefs.SetString("REGULAR_BUILD_MAX_TIP", arg0 and pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d") or "")
				end

				var0:ShowMsgBox({
					showStopRemind = true,
					content = i18n("Normalbuild_URexchange_warning3"),
					stopRamindContent = i18n("dont_remind_today"),
					onYes = function()
						var1(var0.stopRemindToggle.isOn)
						arg0()
					end,
					onNo = function()
						var1(var0.stopRemindToggle.isOn)
					end
				})
			end
		end)
	end

	onButton(arg0, arg0:findTF("gallery/start_btn"), function()
		seriesAsync(var14, function()
			local var0 = arg0.useTicket and var0:getBuildFreeActivityByBuildId(arg0.pool.id) or nil

			if arg0.useTicket and (not var0 or var0:isEnd()) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

				return
			end

			arg0.contextData.msgbox:ExecuteAction("Show", arg0.useTicket and {
				buildType = "ticket",
				itemVO = Item.New({
					id = var0:getConfig("config_client")[1],
					count = var0.data1
				}),
				buildPool = var7,
				max = MAX_BUILD_WORK_COUNT - arg0.contextData.startCount,
				onConfirm = function(arg0)
					if arg1:IsActivity() then
						arg0:emit(BuildShipMediator.ACT_ON_BUILD, arg1:GetActivityId(), var7.id, arg0, true)
					else
						arg0:emit(BuildShipMediator.ON_BUILD, var7.id, arg0, true)
					end
				end
			} or {
				buildType = "base",
				player = arg0.contextData.player,
				itemVO = arg0.contextData.itemVO,
				buildPool = var7,
				max = MAX_BUILD_WORK_COUNT - arg0.contextData.startCount,
				onConfirm = function(arg0)
					if arg1:IsActivity() then
						arg0:emit(BuildShipMediator.ACT_ON_BUILD, arg1:GetActivityId(), var7.id, arg0)
					else
						arg0:emit(BuildShipMediator.ON_BUILD, var7.id, arg0)
					end
				end
			})
		end)
	end, SFX_UI_BUILDING_STARTBUILDING)

	BuildShipScene.projectName = var5

	if arg1:IsActivity() then
		BuildShipScene.buildShipActPoolId = arg1:GetPoolId()
	end
end

local function var2(arg0)
	if not arg0:IsActivity() then
		return false
	end

	local var0 = pg.ship_data_create_exchange[arg0:GetActivityId()]

	return var0 and #var0.exchange_ship_id > 0
end

function var0.UpdateBuildPoolPaiting(arg0, arg1)
	local var0

	if arg0.buildPainting then
		var0 = arg0.buildPainting
	elseif var2(arg1) then
		local var1 = pg.ship_data_create_exchange[arg1:GetActivityId()].exchange_ship_id[1]
		local var2 = pg.ship_data_statistics[var1]

		assert(var2)

		var0 = pg.ship_skin_template[var2.skin_id].painting
	else
		var0 = arg0.contextData.falgShip:getPainting()
	end

	if arg0.painting ~= var0 then
		local function var3()
			arg0.painting = var0
		end

		if arg0.buildPainting then
			setBuildPaintingPrefabAsync(arg0.patingTF, var0, "build", var3)
		else
			setPaintingPrefabAsync(arg0.patingTF, var0, "build", var3)
		end
	end
end

function var0.UpdateBuildPoolExchange(arg0, arg1)
	local var0
	local var1
	local var2

	if arg1:IsActivity() then
		local var3 = arg1:GetActivityId()
		local var4 = pg.ship_data_create_exchange[var3]

		if var4 then
			var0 = var4.exchange_request
			var1 = var4.exchange_available_times
			var2 = var4.exchange_ship_id[1]
		end
	end

	local var5 = var0 and var0 > 0 and var1 and var1 > 0

	if var5 then
		local var6 = arg1:GetActivity()
		local var7 = var6.data1
		local var8 = var6.data2
		local var9 = math.min(var1, var8 + 1) * var0

		arg0.buildPoolExchangeTxt.text = i18n("build_count_tip") .. "<color=#FFDF48>" .. var7 .. "</color>/" .. var9

		local var10 = var8 < var1 and var9 <= var7

		setActive(arg0.buildPoolExchangeGetBtnMark, var10)

		arg0.buildPoolExchangeGetTxt.text = var8 .. "/" .. var1

		local var11 = pg.ship_data_statistics[var2].name

		arg0.buildPoolExchangeName.text = SwitchSpecialChar(var11, true)

		local var12 = pg.ship_data_statistics[var2].rarity

		eachChild(arg0.buildPoolExchangeTF:Find("bg"), function(arg0)
			setActive(arg0, arg0.name == tostring(var12))
		end)
		onButton(arg0, arg0.buildPoolExchangeTF, function()
			if var10 then
				arg0:emit(BuildShipMediator.ON_BUILDPOOL_EXCHANGE, var6.id)
			end
		end, SFX_PANEL)
		setGray(arg0.buildPoolExchangeGetBtn, not var10, true)
		setButtonEnabled(arg0.buildPoolExchangeTF, var10)
	else
		removeOnButton(arg0.buildPoolExchangeTF)
	end

	setActive(arg0.buildPoolExchangeTF, var5)
end

function var0.UpdateRegularBuildPoolExchange(arg0, arg1)
	local var0 = arg1:getConfig("exchange_count") > 0

	setActive(arg0.rtRegularExchange, var0)

	if var0 then
		local var1 = getProxy(BuildShipProxy):getRegularExchangeCount()
		local var2 = pg.ship_data_create_exchange[REGULAR_BUILD_POOL_EXCHANGE_ID]

		setText(arg0.rtRegularExchange:Find("count/Text"), "<color=#FFDF48>" .. var1 .. "</color>/" .. var2.exchange_request)
		setActive(arg0.rtRegularExchange:Find("show"), var1 < var2.exchange_request)
		setActive(arg0.rtRegularExchange:Find("get"), var1 >= var2.exchange_request)
	end
end

function var0.UpdateTestBtn(arg0, arg1)
	local var0 = false

	if PLATFORM_CODE ~= PLATFORM_JP and arg1:IsActivity() and not arg1:IsEnd() then
		local var1 = arg1:GetStageId()

		if var1 then
			var0 = true

			onButton(arg0, arg0.testBtn, function()
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("juese_tiyan"),
					onYes = function()
						arg0:emit(BuildShipMediator.SIMULATION_BATTLE, var1)
					end
				})
			end, SFX_PANEL)
		end
	end

	setActive(arg0.testBtn, var0)
end

function var0.AddActivityTimer(arg0, arg1)
	arg0:RemoveActivityTimer(arg1)

	if arg1:IsActivity() then
		local var0 = arg1:GetActivity()

		assert(var0)

		local var1 = var0.stopTime - pg.TimeMgr.GetInstance():GetServerTime()

		arg0.activityTimer[arg1.id] = Timer.New(function()
			arg0:RemoveActivityTimer(arg1)
			arg0:emit(BuildShipMediator.ON_UPDATE_ACT)
		end, var1, 1)

		arg0.activityTimer[arg1.id]:Start()
	end
end

function var0.RemoveActivityTimer(arg0, arg1)
	if arg0.activityTimer[arg1.id] then
		arg0.activityTimer[arg1.id]:Stop()

		arg0.activityTimer[arg1.id] = nil
	end
end

function var0.RemoveAllTimer(arg0)
	for iter0, iter1 in pairs(arg0.activityTimer) do
		iter1:Stop()
	end

	arg0.activityTimer = {}

	for iter2, iter3 in pairs(arg0.freeActTimer) do
		iter3:Stop()
	end

	arg0.freeActTimer = {}
end

function var0.ShowOrHide(arg0, arg1)
	if arg1 then
		arg0:Show()
	else
		arg0:Hide()
	end
end

function var0.OnDestroy(arg0)
	arg0:RemoveAllTimer()

	arg0.activityTimer = nil
end

return var0
