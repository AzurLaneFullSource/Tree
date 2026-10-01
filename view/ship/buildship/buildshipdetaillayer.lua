local var0_0 = class("BuildShipDetailLayer", import("...base.BaseUI"))
local var1_0 = 10
local var2_0 = 2
local var3_0 = 1
local var4_0 = 2
local var5_0 = {
	"resources/1",
	"resources/2",
	"resources/3",
	"resources/1"
}

function var0_0.getResource(arg0_1)
	local var0_1 = {
		"ui/building"
	}

	for iter0_1, iter1_1 in ipairs(pg.ship_data_create_material.all) do
		local var1_1 = pg.ship_data_create_material[iter1_1]

		if var1_1 then
			if noEmptyStr(var1_1.ship_icon) then
				table.insert(var0_1, ResPathSupport.ConstPath.UI.ShipModelBuliding .. var1_1.ship_icon)
			end

			if noEmptyStr(var1_1.build_anim) then
				table.insert(var0_1, ResPathSupport.CombinePath(ResPathSupport.ConstPath.UI.Base, var1_1.build_anim))
			end
		end
	end

	return table.insertto(var0_1, var0_0.super.getResource(arg0_1))
end

function var0_0.getUIName(arg0_2)
	return "BuildShipDetailUI1"
end

function var0_0.setItems(arg0_3, arg1_3)
	arg0_3.itemVO = arg1_3[ITEM_ID_EQUIP_QUICK_FINISH] or {
		count = 0,
		id = ITEM_ID_EQUIP_QUICK_FINISH
	}
end

function var0_0.setWorkCount(arg0_4, arg1_4)
	arg0_4.workCount = arg1_4
end

function var0_0.setBuildSpeedUpRemind(arg0_5, arg1_5)
	arg0_5.isStopSpeedUpRemind = arg1_5
end

var0_0.MODEL_INDEX = 2

function var0_0.setProjectList(arg0_6, arg1_6)
	arg0_6.projectList = arg1_6
	arg0_6.MODEL = #arg0_6.projectList > var0_0.MODEL_INDEX and var2_0 or var3_0
end

function var0_0.init(arg0_7)
	arg0_7.multLineTF = arg0_7._tf:Find("list_mult_line")
	arg0_7.multLineContain = arg0_7._tf:Find("list_mult_line/content")
	arg0_7.multLineTpl = arg0_7.multLineContain:Find("project_tpl")
	arg0_7.multList = UIItemList.New(arg0_7.multLineContain, arg0_7.multLineTpl)
	arg0_7.singleLineTF = arg0_7._tf:Find("list_single_line")
	arg0_7.singleLineContain = arg0_7._tf:Find("list_single_line/content")
	arg0_7.singleLineTpl = arg0_7.singleLineContain:Find("project_tpl")
	arg0_7.singleList = UIItemList.New(arg0_7.singleLineContain, arg0_7.singleLineTpl)
	arg0_7.listCountTF = arg0_7._tf:Find("title/value")
	arg0_7.quickCount = arg0_7._tf:Find("quick_count")
	arg0_7.quickCountTF = arg0_7._tf:Find("quick_count/value")
	arg0_7.noneBg = arg0_7._tf:Find("none_bg")
	arg0_7.allLaunch = arg0_7._tf:Find("all_launch")
	arg0_7.aniBgTF = arg0_7._tf:Find("aniBg")
	arg0_7.autoLockShipToggle = arg0_7._tf:Find("autolockship/Toggle"):GetComponent(typeof(Toggle))
	arg0_7.canvasgroup = GetOrAddComponent(arg0_7._tf, typeof(CanvasGroup))

	setText(arg0_7._tf:Find("title/text"), i18n("build_detail_intro"))
	setText(arg0_7._tf:Find("autolockship/Text"), i18n("lock_new_ship"))
end

function var0_0.updatePlayer(arg0_8, arg1_8)
	arg0_8._player = arg1_8
end

function var0_0.didEnter(arg0_9)
	arg0_9.projectTFs = {}

	arg0_9.multList:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			arg2_10.gameObject.name = "project_" .. arg1_10 + 1
			arg0_9.projectTFs[arg1_10 + 1] = arg2_10

			arg0_9:updateProject(arg1_10 + 1, arg0_9.projectList[arg1_10 + 1])
		end
	end)
	arg0_9.singleList:make(function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventUpdate then
			arg2_11.gameObject.name = "project_" .. arg1_11 + 1
			arg0_9.projectTFs[arg1_11 + 1] = arg2_11

			arg0_9:updateProject(arg1_11 + 1, arg0_9.projectList[arg1_11 + 1])
		end
	end)
	arg0_9:initProjectList()
	arg0_9:updateItem()
	arg0_9:updateListCount()

	local var0_9 = GameObject.Find("Overlay/UIOverlay")

	arg0_9.aniBgTF.transform:SetParent(var0_9.transform, false)
	onButton(arg0_9, arg0_9.allLaunch, function()
		local var0_12 = arg0_9:getNeedCount()

		if var0_12 > 0 and not arg0_9.isStopSpeedUpRemind then
			local var1_12 = pg.MsgboxMgr.GetInstance()

			var1_12:ShowMsgBox({
				showStopRemind = true,
				content = i18n("ship_buildShipScene_quest_quickFinish", var0_12, arg0_9.itemVO.count == 0 and COLOR_RED or COLOR_GREEN, arg0_9.itemVO.count),
				stopRamindContent = i18n("common_dont_remind_dur_login"),
				onYes = function()
					arg0_9:emit(BuildShipDetailMediator.LAUNCH_ALL, var1_12.stopRemindToggle.isOn)
				end
			})
		elseif #arg0_9.projectList > 0 then
			arg0_9:emit(BuildShipDetailMediator.LAUNCH_ALL)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_getShip_error_noShip"))
		end
	end, SFX_UI_BUILDING_FASTBUILDING)
	onButton(arg0_9, arg0_9.quickCount, function()
		local var0_14 = 61009
		local var1_14 = ShopConst.GetShopConfig(var0_14)

		shoppingBatch(var0_14, {
			id = var1_14.effect_args[1]
		}, 9, "build_ship_quickly_buy_tool")
	end)

	local var1_9 = pg.settings_other_template[22]
	local var2_9 = getProxy(PlayerProxy):getRawData():GetCommonFlag(_G[var1_9.name])

	if var1_9.default == 1 then
		var2_9 = not var2_9
	end

	arg0_9.autoLockShipToggle.isOn = var2_9 or false

	onToggle(arg0_9, go(arg0_9.autoLockShipToggle), function(arg0_15)
		arg0_9:ChangeAutoLockShip(var1_9, arg0_15)
	end, SFX_PANEL)
end

function var0_0.onBackPressed(arg0_16)
	if arg0_16.isPlayAnim then
		return
	end

	arg0_16:emit(var0_0.ON_BACK_PRESSED, true)
end

function var0_0.getNeedCount(arg0_17)
	local var0_17 = 0

	for iter0_17, iter1_17 in ipairs(arg0_17.projectList) do
		if iter1_17.state ~= BuildShip.FINISH then
			var0_17 = var0_17 + 1
		end
	end

	return var0_17
end

function var0_0.updateListCount(arg0_18)
	setText(arg0_18.listCountTF, arg0_18.workCount)
end

function var0_0.updateItem(arg0_19)
	setText(arg0_19.quickCountTF, arg0_19.itemVO.count)
end

function var0_0.initProjectList(arg0_20)
	for iter0_20, iter1_20 in pairs(arg0_20.buildTimers or {}) do
		pg.TimeMgr.GetInstance():RemoveTimer(iter1_20)
	end

	arg0_20.buildTimers = {}

	local var0_20 = arg0_20.MODEL == var2_0 and #arg0_20.projectList or 0
	local var1_20 = arg0_20.MODEL == var3_0 and #arg0_20.projectList or 0

	setActive(arg0_20.multLineTF, var0_20 > 0)
	setActive(arg0_20.singleLineTF, var1_20 > 0)
	arg0_20.multList:align(var0_20)
	arg0_20.singleList:align(var1_20)
	setActive(arg0_20.noneBg, #arg0_20.projectList <= 0)
end

function var0_0.initMultLine(arg0_21)
	arg0_21.multList:align(#arg0_21.projectList)
end

function var0_0.initSingleLine(arg0_22)
	arg0_22.singleList:align(#arg0_22.projectList)
end

function var0_0.updateProject(arg0_23, arg1_23, arg2_23)
	assert(isa(arg2_23, BuildShip), "必须是实例BuildShip")

	local var0_23 = arg0_23.projectTFs[arg1_23]

	if IsNil(var0_23) then
		return
	end

	local var1_23 = var0_23:Find("frame/buiding")
	local var2_23 = var0_23:Find("frame/finished")
	local var3_23 = var0_23:Find("frame/waiting")

	setActive(var3_23, false)
	setActive(var1_23, arg2_23.state == BuildShip.ACTIVE)
	setActive(var2_23, arg2_23.state == BuildShip.FINISH)

	var0_23:GetComponent("CanvasGroup").alpha = arg2_23.state == BuildShip.INACTIVE and 0.6 or 1

	local var4_23 = pg.ship_data_create_material[arg2_23.type]
	local var5_23 = tonumber(var4_23.ship_icon)
	local var6_23 = var1_23:Find("ship_modal")

	for iter0_23 = 0, var6_23.childCount - 1 do
		local var7_23 = var6_23:GetChild(iter0_23)

		setActive(var7_23, false)
	end

	if arg2_23.state == BuildShip.ACTIVE then
		local var8_23 = GetComponent(var1_23, typeof(CanvasGroup))

		if var8_23 then
			var8_23.alpha = 1
		end

		local var9_23 = var6_23:Find("shipModelBuliding" .. var5_23)

		if not var9_23 then
			PoolMgr.GetInstance():GetUI("shipModelBuliding" .. var5_23, true, function(arg0_24)
				arg0_24.transform:SetParent(var6_23, false)

				arg0_24.transform.localPosition = Vector3(1, 1, 1)
				arg0_24.transform.localScale = Vector3(1, 1, 1)

				arg0_24.transform:SetAsFirstSibling()
				setActive(arg0_24, true)
			end)
		else
			setActive(var9_23, true)
		end

		local var10_23 = var1_23:Find("timer/Text")

		onButton(arg0_23, var1_23:Find("quick_btn"), function()
			local var0_25, var1_25, var2_25 = BuildShip.canQuickBuildShip(arg1_23)

			if not var0_25 then
				if var2_25 then
					GoShoppingMsgBox(i18n("switch_to_shop_tip_1"), ChargeScene.TYPE_ITEM, var2_25)
				else
					pg.TipsMgr.GetInstance():ShowTips(var1_25)
				end

				return
			end

			if arg0_23.isStopSpeedUpRemind then
				arg0_23:emit(BuildShipDetailMediator.ON_QUICK, arg1_23)
			else
				local var3_25 = pg.MsgboxMgr.GetInstance()

				var3_25:ShowMsgBox({
					showStopRemind = true,
					content = i18n("ship_buildShipScene_quest_quickFinish", 1, arg0_23.itemVO.count == 0 and COLOR_RED or COLOR_GREEN, arg0_23.itemVO.count),
					stopRamindContent = i18n("dont_remind_session"),
					onYes = function()
						arg0_23:emit(BuildShipDetailMediator.ON_QUICK, arg1_23, var3_25.stopRemindToggle.isOn)
					end
				})
			end
		end, SFX_UI_BUILDING_FASTBUILDING)

		local function var11_23()
			pg.TimeMgr.GetInstance():RemoveTimer(arg0_23.buildTimers[arg1_23])

			arg0_23.buildTimers[arg1_23] = nil

			setActive(var1_23, false)
			setActive(var2_23, true)
		end

		local function var12_23(arg0_28)
			local var0_28 = pg.TimeMgr.GetInstance():DescCDTime(arg0_28)

			setText(var10_23, var0_28)
		end

		if arg0_23.buildTimers[arg1_23] then
			pg.TimeMgr.GetInstance():RemoveTimer(arg0_23.buildTimers[arg1_23])

			arg0_23.buildTimers[arg1_23] = nil
		end

		arg0_23.buildTimers[arg1_23] = pg.TimeMgr.GetInstance():AddTimer("timer" .. arg1_23, 0, 1, function()
			local var0_29 = arg2_23:getLeftTime()

			if var0_29 <= 0 then
				var11_23()
			else
				var12_23(var0_29)
			end
		end)
	elseif arg2_23.state == BuildShip.FINISH then
		GetOrAddComponent(var1_23, typeof(CanvasGroup)).alpha = 0

		setActive(var1_23, true)

		local var13_23 = var6_23:Find("shipModelBuliding" .. var5_23)

		if var13_23 then
			setActive(var13_23, true)
		end

		arg0_23:setSpriteTo(var5_0[tonumber(var4_23.ship_icon)], var2_23:Find("ship_modal"), false)

		local var14_23 = findTF(var2_23, "launched_btn")

		onButton(arg0_23, var14_23, function()
			arg0_23:emit(BuildShipDetailMediator.ON_LAUNCHED, arg1_23)
		end, SFX_PANEL)
		onButton(arg0_23, var0_23, function()
			triggerButton(var14_23)
		end, SFX_PANEL)
	elseif arg2_23.state == BuildShip.INACTIVE then
		setActive(var3_23, true)
		setActive(var1_23, false)
		setActive(var2_23, false)
	end
end

function var0_0.playGetShipAnimate(arg0_32, arg1_32, arg2_32)
	arg0_32.canvasgroup.blocksRaycasts = false

	local var0_32 = pg.ship_data_create_material[arg2_32]

	arg0_32.isPlayAnim = true
	arg0_32.onLoading = true

	pg.CpkPlayMgr.GetInstance():PlayCpkMovie(function()
		arg0_32.onLoading = false

		if var0_32 and var0_32.build_voice ~= "" then
			arg0_32:playCV(var0_32.build_voice)
		end

		warning("BuildingCPK PlayCallBack", pg.CpkPlayMgr.GetInstance()._ratioFitter.enabled)
	end, function()
		arg0_32.isPlayAnim = false
		arg0_32.canvasgroup.blocksRaycasts = true

		arg1_32()
	end, "ui", var0_32.build_anim or "Building", true, false, 4.5, true)
end

function var0_0.willExit(arg0_35)
	pg.CpkPlayMgr.GetInstance():DisposeCpkMovie()

	for iter0_35, iter1_35 in pairs(arg0_35.buildTimers) do
		pg.TimeMgr.GetInstance():RemoveTimer(iter1_35)
	end

	if arg0_35.aniBgTF then
		SetParent(arg0_35.aniBgTF, arg0_35._tf)
	end

	arg0_35.buildTimers = nil

	arg0_35:stopCV()

	arg0_35.onLoading = false

	arg0_35.multList:each(function(arg0_36, arg1_36)
		local var0_36 = arg1_36:Find("frame/buiding/ship_modal")

		eachChild(var0_36, function(arg0_37)
			PoolMgr.GetInstance():ReturnUI(arg0_37.name, arg0_37)
		end)
	end)
	arg0_35.singleList:each(function(arg0_38, arg1_38)
		local var0_38 = arg1_38:Find("frame/buiding/ship_modal")

		eachChild(var0_38, function(arg0_39)
			PoolMgr.GetInstance():ReturnUI(arg0_39.name, arg0_39)
		end)
	end)
end

function var0_0.playCV(arg0_40, arg1_40)
	arg0_40:stopCV()

	local var0_40 = "event:/cv/build/" .. arg1_40

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0_40)

	arg0_40.voiceContent = var0_40
end

function var0_0.stopCV(arg0_41)
	if arg0_41.voiceContent then
		pg.CriMgr.GetInstance():UnloadSoundEffect_V3(arg0_41.voiceContent)
	end

	arg0_41.voiceContent = nil
end

function var0_0.ChangeAutoLockShip(arg0_42, arg1_42, arg2_42)
	local var0_42 = _G[arg1_42.name]
	local var1_42 = getProxy(PlayerProxy):getRawData():GetCommonFlag(var0_42)
	local var2_42 = not arg2_42

	if arg1_42.default == 1 then
		var2_42 = arg2_42
	end

	if var2_42 then
		pg.m02:sendNotification(GAME.CANCEL_COMMON_FLAG, {
			flagID = var0_42
		})
	else
		pg.m02:sendNotification(GAME.COMMON_FLAG, {
			flagID = var0_42
		})
	end
end

return var0_0
