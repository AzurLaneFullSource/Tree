local var0 = class("BuildShipDetailLayer", import("...base.BaseUI"))
local var1 = 10
local var2 = 2
local var3 = 1
local var4 = 2
local var5 = {
	"resources/1",
	"resources/2",
	"resources/3",
	"resources/1"
}

function var0.getUIName(arg0)
	return "BuildShipDetailUI1"
end

function var0.setItems(arg0, arg1)
	arg0.itemVO = arg1[ITEM_ID_EQUIP_QUICK_FINISH] or {
		count = 0,
		id = ITEM_ID_EQUIP_QUICK_FINISH
	}
end

function var0.setWorkCount(arg0, arg1)
	arg0.workCount = arg1
end

function var0.setBuildSpeedUpRemind(arg0, arg1)
	arg0.isStopSpeedUpRemind = arg1
end

var0.MODEL_INDEX = 2

function var0.setProjectList(arg0, arg1)
	arg0.projectList = arg1
	arg0.MODEL = #arg0.projectList > var0.MODEL_INDEX and var2 or var3
end

function var0.init(arg0)
	arg0.UIMgr = pg.UIMgr.GetInstance()
	arg0.multLineTF = arg0:findTF("list_mult_line")
	arg0.multLineContain = arg0:findTF("list_mult_line/content")
	arg0.multLineTpl = arg0:findTF("project_tpl", arg0.multLineContain)
	arg0.multList = UIItemList.New(arg0.multLineContain, arg0.multLineTpl)
	arg0.singleLineTF = arg0:findTF("list_single_line")
	arg0.singleLineContain = arg0:findTF("list_single_line/content")
	arg0.singleLineTpl = arg0:findTF("project_tpl", arg0.singleLineContain)
	arg0.singleList = UIItemList.New(arg0.singleLineContain, arg0.singleLineTpl)
	arg0.listCountTF = arg0:findTF("title/value")
	arg0.quickCount = arg0:findTF("quick_count")
	arg0.quickCountTF = arg0:findTF("quick_count/value")
	arg0.noneBg = arg0:findTF("none_bg")
	arg0.allLaunch = arg0:findTF("all_launch")
	arg0.aniBgTF = arg0:findTF("aniBg")
	arg0.canvasgroup = GetOrAddComponent(arg0._tf, typeof(CanvasGroup))

	setText(arg0:findTF("title/text"), i18n("build_detail_intro"))
end

function var0.updatePlayer(arg0, arg1)
	arg0._player = arg1
end

function var0.didEnter(arg0)
	arg0.projectTFs = {}

	arg0.multList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg2.gameObject.name = "project_" .. arg1 + 1
			arg0.projectTFs[arg1 + 1] = arg2

			arg0:updateProject(arg1 + 1, arg0.projectList[arg1 + 1])
		end
	end)
	arg0.singleList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg2.gameObject.name = "project_" .. arg1 + 1
			arg0.projectTFs[arg1 + 1] = arg2

			arg0:updateProject(arg1 + 1, arg0.projectList[arg1 + 1])
		end
	end)
	arg0:initProjectList()
	arg0:updateItem()
	arg0:updateListCount()

	local var0 = GameObject.Find("Overlay/UIOverlay")

	arg0.aniBgTF.transform:SetParent(var0.transform, false)
	onButton(arg0, arg0.allLaunch, function()
		local var0 = arg0:getNeedCount()

		if var0 > 0 and not arg0.isStopSpeedUpRemind then
			local var1 = pg.MsgboxMgr.GetInstance()

			var1:ShowMsgBox({
				showStopRemind = true,
				content = i18n("ship_buildShipScene_quest_quickFinish", var0, arg0.itemVO.count == 0 and COLOR_RED or COLOR_GREEN, arg0.itemVO.count),
				stopRamindContent = i18n("common_dont_remind_dur_login"),
				onYes = function()
					arg0:emit(BuildShipDetailMediator.LAUNCH_ALL, var1.stopRemindToggle.isOn)
				end
			})
		elseif #arg0.projectList > 0 then
			arg0:emit(BuildShipDetailMediator.LAUNCH_ALL)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_getShip_error_noShip"))
		end
	end, SFX_UI_BUILDING_FASTBUILDING)
	onButton(arg0, arg0.quickCount, function()
		local var0 = pg.shop_template[61009]

		shoppingBatch(61009, {
			id = var0.effect_args[1]
		}, 9, "build_ship_quickly_buy_tool")
	end)
end

function var0.onBackPressed(arg0)
	if arg0.isPlayAnim then
		return
	end

	arg0:emit(var0.ON_BACK_PRESSED, true)
end

function var0.getNeedCount(arg0)
	local var0 = 0

	for iter0, iter1 in ipairs(arg0.projectList) do
		if iter1.state ~= BuildShip.FINISH then
			var0 = var0 + 1
		end
	end

	return var0
end

function var0.updateListCount(arg0)
	setText(arg0.listCountTF, arg0.workCount)
end

function var0.updateItem(arg0)
	setText(arg0.quickCountTF, arg0.itemVO.count)
end

function var0.initProjectList(arg0)
	for iter0, iter1 in pairs(arg0.buildTimers or {}) do
		pg.TimeMgr.GetInstance():RemoveTimer(iter1)
	end

	arg0.buildTimers = {}

	local var0 = arg0.MODEL == var2 and #arg0.projectList or 0
	local var1 = arg0.MODEL == var3 and #arg0.projectList or 0

	setActive(arg0.multLineTF, var0 > 0)
	setActive(arg0.singleLineTF, var1 > 0)
	arg0.multList:align(var0)
	arg0.singleList:align(var1)
	setActive(arg0.noneBg, #arg0.projectList <= 0)
end

function var0.initMultLine(arg0)
	arg0.multList:align(#arg0.projectList)
end

function var0.initSingleLine(arg0)
	arg0.singleList:align(#arg0.projectList)
end

function var0.updateProject(arg0, arg1, arg2)
	assert(isa(arg2, BuildShip), "必须是实例BuildShip")

	local var0 = arg0.projectTFs[arg1]

	if IsNil(var0) then
		return
	end

	local var1 = arg0:findTF("frame/buiding", var0)
	local var2 = arg0:findTF("frame/finished", var0)
	local var3 = arg0:findTF("frame/waiting", var0)

	setActive(var3, false)
	setActive(var1, arg2.state == BuildShip.ACTIVE)
	setActive(var2, arg2.state == BuildShip.FINISH)

	var0:GetComponent("CanvasGroup").alpha = arg2.state == BuildShip.INACTIVE and 0.6 or 1

	local var4 = pg.ship_data_create_material[arg2.type]
	local var5 = tonumber(var4.ship_icon)
	local var6 = arg0:findTF("ship_modal", var1)

	for iter0 = 0, var6.childCount - 1 do
		local var7 = var6:GetChild(iter0)

		setActive(var7, false)
	end

	if arg2.state == BuildShip.ACTIVE then
		local var8 = GetComponent(var1, typeof(CanvasGroup))

		if var8 then
			var8.alpha = 1
		end

		local var9 = arg0:findTF("shipModelBuliding" .. var5, var6)

		if not var9 then
			PoolMgr.GetInstance():GetUI("shipModelBuliding" .. var5, true, function(arg0)
				arg0.transform:SetParent(var6, false)

				arg0.transform.localPosition = Vector3(1, 1, 1)
				arg0.transform.localScale = Vector3(1, 1, 1)

				arg0.transform:SetAsFirstSibling()

				arg0.name = "shipModelBuliding" .. var5

				setActive(arg0, true)
			end)
		else
			setActive(var9, true)
		end

		local var10 = arg0:findTF("timer/Text", var1)

		onButton(arg0, arg0:findTF("quick_btn", var1), function()
			local var0, var1, var2 = BuildShip.canQuickBuildShip(arg1)

			if not var0 then
				if var2 then
					GoShoppingMsgBox(i18n("switch_to_shop_tip_1"), ChargeScene.TYPE_ITEM, var2)
				else
					pg.TipsMgr.GetInstance():ShowTips(var1)
				end

				return
			end

			if arg0.isStopSpeedUpRemind then
				arg0:emit(BuildShipDetailMediator.ON_QUICK, arg1)
			else
				local var3 = pg.MsgboxMgr.GetInstance()

				var3:ShowMsgBox({
					showStopRemind = true,
					content = i18n("ship_buildShipScene_quest_quickFinish", 1, arg0.itemVO.count == 0 and COLOR_RED or COLOR_GREEN, arg0.itemVO.count),
					stopRamindContent = i18n("dont_remind_session"),
					onYes = function()
						arg0:emit(BuildShipDetailMediator.ON_QUICK, arg1, var3.stopRemindToggle.isOn)
					end
				})
			end
		end, SFX_UI_BUILDING_FASTBUILDING)

		local function var11()
			pg.TimeMgr.GetInstance():RemoveTimer(arg0.buildTimers[arg1])

			arg0.buildTimers[arg1] = nil

			setActive(var1, false)
			setActive(var2, true)
		end

		local function var12(arg0)
			local var0 = pg.TimeMgr.GetInstance():DescCDTime(arg0)

			setText(var10, var0)
		end

		if arg0.buildTimers[arg1] then
			pg.TimeMgr.GetInstance():RemoveTimer(arg0.buildTimers[arg1])

			arg0.buildTimers[arg1] = nil
		end

		arg0.buildTimers[arg1] = pg.TimeMgr.GetInstance():AddTimer("timer" .. arg1, 0, 1, function()
			local var0 = arg2:getLeftTime()

			if var0 <= 0 then
				var11()
			else
				var12(var0)
			end
		end)
	elseif arg2.state == BuildShip.FINISH then
		GetOrAddComponent(var1, typeof(CanvasGroup)).alpha = 0

		setActive(var1, true)

		local var13 = arg0:findTF("shipModelBuliding" .. var5, var6)

		if var13 then
			setActive(var13, true)
		end

		arg0:setSpriteTo(var5[tonumber(var4.ship_icon)], arg0:findTF("ship_modal", var2), false)

		local var14 = findTF(var2, "launched_btn")

		onButton(arg0, var14, function()
			arg0:emit(BuildShipDetailMediator.ON_LAUNCHED, arg1)
		end, SFX_PANEL)
		onButton(arg0, var0, function()
			triggerButton(var14)
		end, SFX_PANEL)
	elseif arg2.state == BuildShip.INACTIVE then
		setActive(var3, true)
		setActive(var1, false)
		setActive(var2, false)
	end
end

function var0.playGetShipAnimate(arg0, arg1, arg2)
	arg0.canvasgroup.blocksRaycasts = false

	local var0 = pg.ship_data_create_material[arg2]

	arg0.isPlayAnim = true
	arg0.onLoading = true

	pg.CpkPlayMgr.GetInstance():PlayCpkMovie(function()
		arg0.onLoading = false

		if var0 and var0.build_voice ~= "" then
			arg0:playCV(var0.build_voice)
		end
	end, function()
		arg0.isPlayAnim = false
		arg0.canvasgroup.blocksRaycasts = true

		arg1()
	end, "ui", var0.build_anim or "Building", true, false, {
		weight = LayerWeightConst.SECOND_LAYER
	}, 4.5, true)
end

function var0.willExit(arg0)
	pg.CpkPlayMgr.GetInstance():DisposeCpkMovie()

	for iter0, iter1 in pairs(arg0.buildTimers) do
		pg.TimeMgr.GetInstance():RemoveTimer(iter1)
	end

	if arg0.aniBgTF then
		SetParent(arg0.aniBgTF, arg0._tf)
	end

	arg0.buildTimers = nil

	arg0:stopCV()

	arg0.onLoading = false

	arg0.multList:each(function(arg0, arg1)
		local var0 = arg0:findTF("frame/buiding/ship_modal", arg1)

		eachChild(var0, function(arg0)
			PoolMgr.GetInstance():ReturnUI(arg0.name, arg0)
		end)
	end)
	arg0.singleList:each(function(arg0, arg1)
		local var0 = arg0:findTF("frame/buiding/ship_modal", arg1)

		eachChild(var0, function(arg0)
			PoolMgr.GetInstance():ReturnUI(arg0.name, arg0)
		end)
	end)
end

function var0.playCV(arg0, arg1)
	arg0:stopCV()

	local var0 = "event:/cv/build/" .. arg1

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0)

	arg0.voiceContent = var0
end

function var0.stopCV(arg0)
	if arg0.voiceContent then
		pg.CriMgr.GetInstance():UnloadSoundEffect_V3(arg0.voiceContent)
	end

	arg0.voiceContent = nil
end

return var0
