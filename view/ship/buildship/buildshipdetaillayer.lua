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

function var0_0.getUIName(arg0_1)
	return "BuildShipDetailUI1"
end

function var0_0.setItems(arg0_2, arg1_2)
	arg0_2.itemVO = arg1_2[ITEM_ID_EQUIP_QUICK_FINISH] or {
		count = 0,
		id = ITEM_ID_EQUIP_QUICK_FINISH
	}
end

function var0_0.setWorkCount(arg0_3, arg1_3)
	arg0_3.workCount = arg1_3
end

function var0_0.setBuildSpeedUpRemind(arg0_4, arg1_4)
	arg0_4.isStopSpeedUpRemind = arg1_4
end

var0_0.MODEL_INDEX = 2

function var0_0.setProjectList(arg0_5, arg1_5)
	arg0_5.projectList = arg1_5
	arg0_5.MODEL = #arg0_5.projectList > var0_0.MODEL_INDEX and var2_0 or var3_0
end

function var0_0.init(arg0_6)
	arg0_6.UIMgr = pg.UIMgr.GetInstance()
	arg0_6.multLineTF = arg0_6:findTF("list_mult_line")
	arg0_6.multLineContain = arg0_6:findTF("list_mult_line/content")
	arg0_6.multLineTpl = arg0_6:findTF("project_tpl", arg0_6.multLineContain)
	arg0_6.multList = UIItemList.New(arg0_6.multLineContain, arg0_6.multLineTpl)
	arg0_6.singleLineTF = arg0_6:findTF("list_single_line")
	arg0_6.singleLineContain = arg0_6:findTF("list_single_line/content")
	arg0_6.singleLineTpl = arg0_6:findTF("project_tpl", arg0_6.singleLineContain)
	arg0_6.singleList = UIItemList.New(arg0_6.singleLineContain, arg0_6.singleLineTpl)
	arg0_6.listCountTF = arg0_6:findTF("title/value")
	arg0_6.quickCount = arg0_6:findTF("quick_count")
	arg0_6.quickCountTF = arg0_6:findTF("quick_count/value")
	arg0_6.noneBg = arg0_6:findTF("none_bg")
	arg0_6.allLaunch = arg0_6:findTF("all_launch")
	arg0_6.aniBgTF = arg0_6:findTF("aniBg")
	arg0_6.autoLockShipToggle = arg0_6:findTF("autolockship/Toggle"):GetComponent(typeof(Toggle))
	arg0_6.canvasgroup = GetOrAddComponent(arg0_6._tf, typeof(CanvasGroup))

	setText(arg0_6:findTF("title/text"), i18n("build_detail_intro"))
	setText(arg0_6:findTF("autolockship/Text"), i18n("lock_new_ship"))
end

function var0_0.updatePlayer(arg0_7, arg1_7)
	arg0_7._player = arg1_7
end

function var0_0.didEnter(arg0_8)
	arg0_8.projectTFs = {}

	arg0_8.multList:make(function(arg0_9, arg1_9, arg2_9)
		if arg0_9 == UIItemList.EventUpdate then
			arg2_9.gameObject.name = "project_" .. arg1_9 + 1
			arg0_8.projectTFs[arg1_9 + 1] = arg2_9

			arg0_8:updateProject(arg1_9 + 1, arg0_8.projectList[arg1_9 + 1])
		end
	end)
	arg0_8.singleList:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			arg2_10.gameObject.name = "project_" .. arg1_10 + 1
			arg0_8.projectTFs[arg1_10 + 1] = arg2_10

			arg0_8:updateProject(arg1_10 + 1, arg0_8.projectList[arg1_10 + 1])
		end
	end)
	arg0_8:initProjectList()
	arg0_8:updateItem()
	arg0_8:updateListCount()

	local var0_8 = GameObject.Find("Overlay/UIOverlay")

	arg0_8.aniBgTF.transform:SetParent(var0_8.transform, false)
	onButton(arg0_8, arg0_8.allLaunch, function()
		local var0_11 = arg0_8:getNeedCount()

		if var0_11 > 0 and not arg0_8.isStopSpeedUpRemind then
			local var1_11 = pg.MsgboxMgr.GetInstance()

			var1_11:ShowMsgBox({
				showStopRemind = true,
				content = i18n("ship_buildShipScene_quest_quickFinish", var0_11, arg0_8.itemVO.count == 0 and COLOR_RED or COLOR_GREEN, arg0_8.itemVO.count),
				stopRamindContent = i18n("common_dont_remind_dur_login"),
				onYes = function()
					arg0_8:emit(BuildShipDetailMediator.LAUNCH_ALL, var1_11.stopRemindToggle.isOn)
				end
			})
		elseif #arg0_8.projectList > 0 then
			arg0_8:emit(BuildShipDetailMediator.LAUNCH_ALL)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_getShip_error_noShip"))
		end
	end, SFX_UI_BUILDING_FASTBUILDING)
	onButton(arg0_8, arg0_8.quickCount, function()
		local var0_13 = pg.shop_template[61009]

		shoppingBatch(61009, {
			id = var0_13.effect_args[1]
		}, 9, "build_ship_quickly_buy_tool")
	end)

	local var1_8 = pg.settings_other_template[22]
	local var2_8 = getProxy(PlayerProxy):getRawData():GetCommonFlag(_G[var1_8.name])

	if var1_8.default == 1 then
		var2_8 = not var2_8
	end

	arg0_8.autoLockShipToggle.isOn = var2_8 or false

	onToggle(arg0_8, go(arg0_8.autoLockShipToggle), function(arg0_14)
		arg0_8:ChangeAutoLockShip(var1_8, arg0_14)
	end, SFX_PANEL)
end

function var0_0.onBackPressed(arg0_15)
	if arg0_15.isPlayAnim then
		return
	end

	arg0_15:emit(var0_0.ON_BACK_PRESSED, true)
end

function var0_0.getNeedCount(arg0_16)
	local var0_16 = 0

	for iter0_16, iter1_16 in ipairs(arg0_16.projectList) do
		if iter1_16.state ~= BuildShip.FINISH then
			var0_16 = var0_16 + 1
		end
	end

	return var0_16
end

function var0_0.updateListCount(arg0_17)
	setText(arg0_17.listCountTF, arg0_17.workCount)
end

function var0_0.updateItem(arg0_18)
	setText(arg0_18.quickCountTF, arg0_18.itemVO.count)
end

function var0_0.initProjectList(arg0_19)
	for iter0_19, iter1_19 in pairs(arg0_19.buildTimers or {}) do
		pg.TimeMgr.GetInstance():RemoveTimer(iter1_19)
	end

	arg0_19.buildTimers = {}

	local var0_19 = arg0_19.MODEL == var2_0 and #arg0_19.projectList or 0
	local var1_19 = arg0_19.MODEL == var3_0 and #arg0_19.projectList or 0

	setActive(arg0_19.multLineTF, var0_19 > 0)
	setActive(arg0_19.singleLineTF, var1_19 > 0)
	arg0_19.multList:align(var0_19)
	arg0_19.singleList:align(var1_19)
	setActive(arg0_19.noneBg, #arg0_19.projectList <= 0)
end

function var0_0.initMultLine(arg0_20)
	arg0_20.multList:align(#arg0_20.projectList)
end

function var0_0.initSingleLine(arg0_21)
	arg0_21.singleList:align(#arg0_21.projectList)
end

function var0_0.updateProject(arg0_22, arg1_22, arg2_22)
	assert(isa(arg2_22, BuildShip), "必须是实例BuildShip")

	local var0_22 = arg0_22.projectTFs[arg1_22]

	if IsNil(var0_22) then
		return
	end

	local var1_22 = arg0_22:findTF("frame/buiding", var0_22)
	local var2_22 = arg0_22:findTF("frame/finished", var0_22)
	local var3_22 = arg0_22:findTF("frame/waiting", var0_22)

	setActive(var3_22, false)
	setActive(var1_22, arg2_22.state == BuildShip.ACTIVE)
	setActive(var2_22, arg2_22.state == BuildShip.FINISH)

	var0_22:GetComponent("CanvasGroup").alpha = arg2_22.state == BuildShip.INACTIVE and 0.6 or 1

	local var4_22 = pg.ship_data_create_material[arg2_22.type]
	local var5_22 = tonumber(var4_22.ship_icon)
	local var6_22 = arg0_22:findTF("ship_modal", var1_22)

	for iter0_22 = 0, var6_22.childCount - 1 do
		local var7_22 = var6_22:GetChild(iter0_22)

		setActive(var7_22, false)
	end

	if arg2_22.state == BuildShip.ACTIVE then
		local var8_22 = GetComponent(var1_22, typeof(CanvasGroup))

		if var8_22 then
			var8_22.alpha = 1
		end

		local var9_22 = arg0_22:findTF("shipModelBuliding" .. var5_22, var6_22)

		if not var9_22 then
			PoolMgr.GetInstance():GetUI("shipModelBuliding" .. var5_22, true, function(arg0_23)
				arg0_23.transform:SetParent(var6_22, false)

				arg0_23.transform.localPosition = Vector3(1, 1, 1)
				arg0_23.transform.localScale = Vector3(1, 1, 1)

				arg0_23.transform:SetAsFirstSibling()

				arg0_23.name = "shipModelBuliding" .. var5_22

				setActive(arg0_23, true)
			end)
		else
			setActive(var9_22, true)
		end

		local var10_22 = arg0_22:findTF("timer/Text", var1_22)

		onButton(arg0_22, arg0_22:findTF("quick_btn", var1_22), function()
			local var0_24, var1_24, var2_24 = BuildShip.canQuickBuildShip(arg1_22)

			if not var0_24 then
				if var2_24 then
					GoShoppingMsgBox(i18n("switch_to_shop_tip_1"), ChargeScene.TYPE_ITEM, var2_24)
				else
					pg.TipsMgr.GetInstance():ShowTips(var1_24)
				end

				return
			end

			if arg0_22.isStopSpeedUpRemind then
				arg0_22:emit(BuildShipDetailMediator.ON_QUICK, arg1_22)
			else
				local var3_24 = pg.MsgboxMgr.GetInstance()

				var3_24:ShowMsgBox({
					showStopRemind = true,
					content = i18n("ship_buildShipScene_quest_quickFinish", 1, arg0_22.itemVO.count == 0 and COLOR_RED or COLOR_GREEN, arg0_22.itemVO.count),
					stopRamindContent = i18n("dont_remind_session"),
					onYes = function()
						arg0_22:emit(BuildShipDetailMediator.ON_QUICK, arg1_22, var3_24.stopRemindToggle.isOn)
					end
				})
			end
		end, SFX_UI_BUILDING_FASTBUILDING)

		local function var11_22()
			pg.TimeMgr.GetInstance():RemoveTimer(arg0_22.buildTimers[arg1_22])

			arg0_22.buildTimers[arg1_22] = nil

			setActive(var1_22, false)
			setActive(var2_22, true)
		end

		local function var12_22(arg0_27)
			local var0_27 = pg.TimeMgr.GetInstance():DescCDTime(arg0_27)

			setText(var10_22, var0_27)
		end

		if arg0_22.buildTimers[arg1_22] then
			pg.TimeMgr.GetInstance():RemoveTimer(arg0_22.buildTimers[arg1_22])

			arg0_22.buildTimers[arg1_22] = nil
		end

		arg0_22.buildTimers[arg1_22] = pg.TimeMgr.GetInstance():AddTimer("timer" .. arg1_22, 0, 1, function()
			local var0_28 = arg2_22:getLeftTime()

			if var0_28 <= 0 then
				var11_22()
			else
				var12_22(var0_28)
			end
		end)
	elseif arg2_22.state == BuildShip.FINISH then
		GetOrAddComponent(var1_22, typeof(CanvasGroup)).alpha = 0

		setActive(var1_22, true)

		local var13_22 = arg0_22:findTF("shipModelBuliding" .. var5_22, var6_22)

		if var13_22 then
			setActive(var13_22, true)
		end

		arg0_22:setSpriteTo(var5_0[tonumber(var4_22.ship_icon)], arg0_22:findTF("ship_modal", var2_22), false)

		local var14_22 = findTF(var2_22, "launched_btn")

		onButton(arg0_22, var14_22, function()
			arg0_22:emit(BuildShipDetailMediator.ON_LAUNCHED, arg1_22)
		end, SFX_PANEL)
		onButton(arg0_22, var0_22, function()
			triggerButton(var14_22)
		end, SFX_PANEL)
	elseif arg2_22.state == BuildShip.INACTIVE then
		setActive(var3_22, true)
		setActive(var1_22, false)
		setActive(var2_22, false)
	end
end

function var0_0.playGetShipAnimate(arg0_31, arg1_31, arg2_31)
	arg0_31.canvasgroup.blocksRaycasts = false

	local var0_31 = pg.ship_data_create_material[arg2_31]

	arg0_31.isPlayAnim = true
	arg0_31.onLoading = true

	pg.CpkPlayMgr.GetInstance():PlayCpkMovie(function()
		arg0_31.onLoading = false

		if var0_31 and var0_31.build_voice ~= "" then
			arg0_31:playCV(var0_31.build_voice)
		end

		warning("BuildingCPK PlayCallBack", pg.CpkPlayMgr.GetInstance()._ratioFitter.enabled)
	end, function()
		arg0_31.isPlayAnim = false
		arg0_31.canvasgroup.blocksRaycasts = true

		arg1_31()
	end, "ui", var0_31.build_anim or "Building", true, false, {
		weight = LayerWeightConst.SECOND_LAYER
	}, 4.5, true)
end

function var0_0.willExit(arg0_34)
	pg.CpkPlayMgr.GetInstance():DisposeCpkMovie()

	for iter0_34, iter1_34 in pairs(arg0_34.buildTimers) do
		pg.TimeMgr.GetInstance():RemoveTimer(iter1_34)
	end

	if arg0_34.aniBgTF then
		SetParent(arg0_34.aniBgTF, arg0_34._tf)
	end

	arg0_34.buildTimers = nil

	arg0_34:stopCV()

	arg0_34.onLoading = false

	arg0_34.multList:each(function(arg0_35, arg1_35)
		local var0_35 = arg0_34:findTF("frame/buiding/ship_modal", arg1_35)

		eachChild(var0_35, function(arg0_36)
			PoolMgr.GetInstance():ReturnUI(arg0_36.name, arg0_36)
		end)
	end)
	arg0_34.singleList:each(function(arg0_37, arg1_37)
		local var0_37 = arg0_34:findTF("frame/buiding/ship_modal", arg1_37)

		eachChild(var0_37, function(arg0_38)
			PoolMgr.GetInstance():ReturnUI(arg0_38.name, arg0_38)
		end)
	end)
end

function var0_0.playCV(arg0_39, arg1_39)
	arg0_39:stopCV()

	local var0_39 = "event:/cv/build/" .. arg1_39

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0_39)

	arg0_39.voiceContent = var0_39
end

function var0_0.stopCV(arg0_40)
	if arg0_40.voiceContent then
		pg.CriMgr.GetInstance():UnloadSoundEffect_V3(arg0_40.voiceContent)
	end

	arg0_40.voiceContent = nil
end

function var0_0.ChangeAutoLockShip(arg0_41, arg1_41, arg2_41)
	local var0_41 = _G[arg1_41.name]
	local var1_41 = getProxy(PlayerProxy):getRawData():GetCommonFlag(var0_41)
	local var2_41 = not arg2_41

	if arg1_41.default == 1 then
		var2_41 = arg2_41
	end

	if var2_41 then
		pg.m02:sendNotification(GAME.CANCEL_COMMON_FLAG, {
			flagID = var0_41
		})
	else
		pg.m02:sendNotification(GAME.COMMON_FLAG, {
			flagID = var0_41
		})
	end
end

return var0_0
