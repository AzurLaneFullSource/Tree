local var0_0 = class("TechnologyScene", import("..base.BaseUI"))

var0_0.PageBase = 1
var0_0.PageQueue = 2
var0_0.rarityColor = {
	["1"] = {
		"#4B7BC6FF",
		{
			0.0627450980392157,
			0.294117647058824,
			0.874509803921569,
			0.670588235294118
		}
	},
	["2"] = {
		"#776AB0FF",
		{
			0.294117647058824,
			0.235294117647059,
			0.576470588235294,
			0.670588235294118
		}
	},
	["3"] = {
		"#B76642FF",
		{
			0.749019607843137,
			0.286274509803922,
			0.0627450980392157,
			0.670588235294118
		}
	},
	["4"] = {
		"#368B78FF",
		{
			0.129411764705882,
			0.498039215686275,
			0.501960784313725,
			0.670588235294118
		}
	}
}

function var0_0.getUIName(arg0_1)
	return "TechnologyUI"
end

function var0_0.getResource(arg0_2)
	local var0_2 = {
		"ui/technologyui",
		"technologycard",
		"ui/TechnologyUI_atlas",
		"ui/iconcolorful",
		"ui/technologysettingsui_atlas",
		"ui/TechnologySettingsUI"
	}

	local function var1_2()
		local var0_3 = {}
		local var1_3 = pg.activity_event_blueprint_catchup.all

		for iter0_3, iter1_3 in ipairs(var1_3) do
			local var2_3 = pg.activity_event_blueprint_catchup[iter1_3].char_choice

			table.insert(var0_3, "TecCatchup/QChar" .. var2_3)
		end

		return var0_3
	end

	local function var2_2()
		local var0_4 = getProxy(TechnologyProxy)
		local var1_4 = var0_4:getTechnologys()
		local var2_4 = var0_4:getPlanningTechnologys()
		local var3_4 = {}

		local function var4_4(arg0_5)
			for iter0_5, iter1_5 in ipairs(arg0_5:getConfig("drop_client")) do
				if iter1_5 ~= nil then
					local var0_5 = Drop.Create(iter1_5):getIcon()

					table.insert(var3_4, var0_5)
				end
			end

			for iter2_5, iter3_5 in ipairs(arg0_5:getConfig("consume")) do
				if iter3_5 ~= nil then
					local var1_5 = Drop.Create(iter3_5):getIcon()

					table.insert(var3_4, var1_5)
				end
			end
		end

		for iter0_4, iter1_4 in ipairs(var1_4) do
			local var5_4 = "technologyshipicon/" .. iter1_4:getConfig("bg_icon")

			var4_4(iter1_4)
			table.insert(var3_4, var5_4)
		end

		for iter2_4, iter3_4 in ipairs(var2_4) do
			local var6_4 = "technologyshipicon/" .. iter3_4:getConfig("bg_icon")

			var4_4(iter3_4)
			table.insert(var3_4, var6_4)
		end

		return var3_4
	end

	local var3_2 = var1_2()
	local var4_2 = var2_2()

	return ResPathSupport.MergeLuaArr(var0_2, var3_2, var4_2, technologySetting)
end

function var0_0.onBackPressed(arg0_6)
	if arg0_6.contextData.selectedIndex then
		arg0_6:cancelSelected()

		return
	end

	if arg0_6.contextData.page == var0_0.PageQueue then
		arg0_6:setPage(var0_0.PageBase)

		return
	end

	var0_0.super.onBackPressed(arg0_6)
end

function var0_0.ResUISettings(arg0_7)
	return true
end

function var0_0.setTechnologys(arg0_8, arg1_8, arg2_8)
	arg0_8.technologyVOs = arg1_8
	arg0_8.technologyQueue = arg2_8
end

function var0_0.setRefreshFlag(arg0_9, arg1_9)
	arg0_9.flag = arg1_9
end

function var0_0.setPlayer(arg0_10, arg1_10)
	arg0_10.player = arg1_10
end

function var0_0.init(arg0_11)
	arg0_11.backBtn = arg0_11._tf:Find("blur_panel/adapt/top/back")
	arg0_11.basePage = arg0_11._tf:Find("main/base_page")
	arg0_11.srcollView = arg0_11.basePage:Find("srcoll_rect/content")
	arg0_11.srcollViewCG = arg0_11.srcollView:GetComponent(typeof(CanvasGroup))
	arg0_11.helpBtn = arg0_11.basePage:Find("help_btn")
	arg0_11.refreshBtn = arg0_11.basePage:Find("refresh_btn")

	setText(arg0_11.refreshBtn:Find("Text"), i18n("technology_daily_refresh"))

	arg0_11.settingsBtn = arg0_11.basePage:Find("settings_btn")
	arg0_11.selectetPanel = arg0_11.basePage:Find("selecte_panel")

	setActive(arg0_11.selectetPanel, false)
	setText(arg0_11.selectetPanel:Find("consume_panel/bg/label/Text"), i18n("technology_consume"))
	setText(arg0_11.selectetPanel:Find("consume_panel/bg/task_panel/label/Text"), i18n("technology_request"))

	arg0_11.arrLeftBtn = arg0_11.selectetPanel:Find("left_arr_btn")
	arg0_11.arrRightBtn = arg0_11.selectetPanel:Find("right_arr_btn")
	arg0_11.technologyTpl = arg0_11.selectetPanel:Find("technology_card")
	arg0_11.descTxt = arg0_11.selectetPanel:Find("desc/bg/Text"):GetComponent(typeof(Text))
	arg0_11.timerTxt = arg0_11.selectetPanel:Find("timer/bg/Text"):GetComponent(typeof(Text))
	arg0_11.itemContainer = arg0_11.selectetPanel:Find("consume_panel/bg/container")
	arg0_11.itemTpl = arg0_11.itemContainer:Find("item_tpl")
	arg0_11.emptyTF = arg0_11.selectetPanel:Find("consume_panel/bg/empty")
	arg0_11.taskPanel = arg0_11.selectetPanel:Find("consume_panel/bg/task_panel")
	arg0_11.taskSlider = arg0_11.taskPanel:Find("slider"):GetComponent(typeof(Slider))
	arg0_11.taskDesc = arg0_11.taskPanel:Find("slider/Text"):GetComponent(typeof(Text))
	arg0_11.descBG = arg0_11.selectetPanel:Find("desc/bg"):GetComponent(typeof(Image))
	arg0_11.queuePage = arg0_11._tf:Find("main/queue_page")
	arg0_11.queueView = arg0_11.queuePage:Find("queue_rect/content")

	local var0_11 = arg0_11._tf:Find("blur_panel/adapt/right")

	arg0_11.btnAwardQueue = var0_11:Find("btn_award")

	setText(arg0_11.btnAwardQueue:Find("Text"), i18n("technology_queue_getaward"))

	arg0_11.btnAwardQueueDisable = var0_11:Find("btn_award_disable")

	setText(arg0_11.btnAwardQueueDisable:Find("Text"), i18n("technology_queue_getaward"))

	arg0_11.btnQueue = arg0_11._tf:Find("blur_panel/adapt/left/btn_queue")
	arg0_11.cardtimer = {}
	arg0_11.queueTimer = {}
	arg0_11.queueCardTimer = {}
end

function var0_0.updateSettingsBtn(arg0_12)
	local var0_12 = arg0_12.settingsBtn:Find("RedPoint")
	local var1_12 = arg0_12.settingsBtn:Find("TipText")

	setText(var1_12, i18n("tec_settings_btn_word"))

	local var2_12 = arg0_12.settingsBtn:Find("TargetCatchup")
	local var3_12 = var2_12:Find("Selected")
	local var4_12 = arg0_12.settingsBtn:Find("ActCatchup")

	arg0_12:updateSettingBtnVersion()

	local var5_12 = false
	local var6_12 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BLUEPRINT_CATCHUP)

	if var6_12 and not var6_12:isEnd() then
		local var7_12 = var6_12.data1
		local var8_12 = var6_12:getConfig("config_id")
		local var9_12 = pg.activity_event_blueprint_catchup[var8_12].char_choice
		local var10_12 = pg.activity_event_blueprint_catchup[var8_12].obtain_max

		if var7_12 < var10_12 then
			local var11_12 = var4_12:Find("Selected/CharImg")

			setImageSprite(var11_12, LoadSprite("TecCatchup/QChar" .. var9_12, tostring(var9_12)))

			local var12_12 = var4_12:Find("Selected/ProgressText")

			setText(var12_12, var7_12 .. "/" .. var10_12)

			local var13_12 = var6_12.stopTime - pg.TimeMgr.GetInstance():GetServerTime()

			if arg0_12.actCatchupTimer then
				arg0_12.actCatchupTimer:Stop()

				arg0_12.actCatchupTimer = nil
			end

			local var14_12 = var4_12:Find("TimeLeft/Day")
			local var15_12 = var4_12:Find("TimeLeft/Hour")
			local var16_12 = var4_12:Find("TimeLeft/Min")
			local var17_12 = var4_12:Find("TimeLeft/NumText")

			local function var18_12()
				local var0_13, var1_13, var2_13, var3_13 = pg.TimeMgr.GetInstance():parseTimeFrom(var13_12)

				var13_12 = var13_12 - 1

				if var0_13 >= 1 then
					setActive(var14_12, true)
					setActive(var15_12, false)
					setActive(var16_12, false)
					setText(var17_12, var0_13)
				elseif var0_13 <= 0 and var1_13 > 0 then
					setActive(var14_12, false)
					setActive(var15_12, true)
					setActive(var16_12, false)
					setText(var17_12, var1_13)
				elseif var0_13 <= 0 and var1_13 <= 0 and (var2_13 > 0 or var3_13 > 0) then
					setActive(var14_12, false)
					setActive(var15_12, false)
					setActive(var16_12, true)
					setText(var17_12, math.max(var2_13, 1))
				elseif var0_13 <= 0 and var1_13 <= 0 and var2_13 <= 0 and var3_13 <= 0 and arg0_12.actCatchupTimer then
					arg0_12.actCatchupTimer:Stop()

					arg0_12.actCatchupTimer = nil

					setActive(var4_12, false)
				end
			end

			arg0_12.actCatchupTimer = Timer.New(var18_12, 1, -1, 1)

			arg0_12.actCatchupTimer:Start()
			arg0_12.actCatchupTimer.func()

			var5_12 = true
		end
	end

	setActive(var4_12, var5_12)
	setActive(var2_12, true)

	local var19_12 = getProxy(TechnologyProxy)
	local var20_12 = var19_12:isOpenTargetCatchup()
	local var21_12 = var19_12:isOnCatchup()

	if var20_12 then
		if not var21_12 then
			setActive(var3_12, false)
			setActive(var0_12, true)
		else
			local var22_12 = var19_12:getCurCatchupTecInfo()
			local var23_12 = var22_12.tecID
			local var24_12 = var22_12.groupID
			local var25_12 = var22_12.printNum
			local var26_12 = var19_12:getCatchupData(var23_12):isUr(var24_12) and pg.technology_catchup_template[var23_12].obtain_max_per_ur or pg.technology_catchup_template[var23_12].obtain_max

			if var26_12 <= var25_12 then
				setActive(var3_12, false)
				setActive(var0_12, false)
			else
				setActive(var3_12, true)
				setActive(var0_12, false)

				local var27_12 = var3_12:Find("CharImg")

				setImageSprite(var27_12, LoadSprite("TecCatchup/QChar" .. var24_12, tostring(var24_12)))

				local var28_12 = var3_12:Find("ProgressText")

				setText(var28_12, var25_12 .. "/" .. var26_12)
			end
		end
	else
		setActive(var3_12, false)
		setActive(var0_12, false)
	end
end

function var0_0.updateSettingBtnVersion(arg0_14)
	local var0_14 = getProxy(TechnologyProxy):getTendency(2)
	local var1_14 = arg0_14.settingsBtn:Find("tag")

	setActive(var1_14, var0_14 > 0)

	if var0_14 > 0 then
		GetImageSpriteFromAtlasAsync("technologycard", "version_" .. var0_14, var1_14:Find("Image"), true)
	end
end

function var0_0.setPage(arg0_15, arg1_15)
	arg0_15.contextData.page = arg1_15

	setActive(arg0_15.basePage, arg1_15 == var0_0.PageBase)
	setActive(arg0_15.queuePage, arg1_15 == var0_0.PageQueue)
	setActive(arg0_15._tf:Find("blur_panel/adapt/top/title"), arg1_15 == var0_0.PageBase)
	setActive(arg0_15._tf:Find("blur_panel/adapt/left"), arg1_15 == var0_0.PageBase)
	setActive(arg0_15._tf:Find("blur_panel/adapt/top/title_queue"), arg1_15 == var0_0.PageQueue)
	setActive(arg0_15._tf:Find("blur_panel/adapt/right"), arg1_15 == var0_0.PageQueue)

	if arg1_15 == var0_0.PageBase then
		for iter0_15, iter1_15 in ipairs(arg0_15.technologyVOs) do
			if iter1_15:isActivate() then
				if arg0_15.enhancelTimer then
					arg0_15.enhancelTimer:Stop()
				end

				arg0_15.enhancelTimer = Timer.New(function()
					arg0_15.srcollView:GetComponent("EnhancelScrollView"):SetHorizontalTargetItemIndex(arg0_15.technologyCards[iter0_15]:GetComponent("EnhanceItem").scrollViewItemIndex)

					arg0_15.enhancelTimer = nil
				end, 0.35, 1)

				arg0_15.enhancelTimer:Start()

				break
			end
		end
	end
end

function var0_0.didEnter(arg0_17)
	arg0_17:initTechnologys()
	arg0_17:initQueue()
	arg0_17:setPage(arg0_17.contextData.page or var0_0.PageBase)
	onButton(arg0_17, arg0_17.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.technology_help_text.tip
		})
	end, SFX_PANEL)
	onButton(arg0_17, arg0_17.refreshBtn, function()
		if tobool(getProxy(TechnologyProxy):getActivateTechnology()) then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("technology_canot_refresh")
			})

			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("technology_refresh_tip"),
			onYes = function()
				arg0_17:emit(TechnologyMediator.ON_REFRESH)
			end
		})
	end, SFX_PANEL)

	local var0_17 = getProxy(TechnologyProxy):getConfigMaxVersion()

	onButton(arg0_17, arg0_17.settingsBtn, function()
		arg0_17:emit(TechnologyMediator.ON_CLICK_SETTINGS_BTN)
	end, SFX_PANEL)
	onButton(arg0_17, arg0_17.backBtn, function()
		arg0_17:onBackPressed()
	end, SOUND_BACK)
	onButton(arg0_17, arg0_17.selectetPanel, function()
		arg0_17:cancelSelected()
	end, SFX_PANEL)
	arg0_17:updateRefreshBtn(arg0_17.flag)
	arg0_17:updateSettingsBtn()
end

function var0_0.initTechnologys(arg0_24)
	arg0_24.technologyCards = {}
	arg0_24.lastButtonListener = arg0_24.lastButtonListener or {}

	if not arg0_24.itemList then
		arg0_24.itemList = UIItemList.New(arg0_24.srcollView, arg0_24.srcollView:GetChild(0))

		arg0_24.itemList:make(function(arg0_25, arg1_25, arg2_25)
			arg1_25 = arg1_25 + 1

			if arg0_25 == UIItemList.EventUpdate then
				arg2_25.name = arg1_25
				arg0_24.technologyCards[arg1_25] = arg2_25

				arg0_24:updateTechnologyTF(arg2_25, arg1_25, "base")

				local var0_25 = GetOrAddComponent(arg2_25, typeof(Button)).onClick

				if arg0_24.lastButtonListener[arg2_25] then
					var0_25:RemoveListener(arg0_24.lastButtonListener[arg2_25])
				end

				arg0_24.lastButtonListener[arg2_25] = function()
					pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)

					if arg0_24.technologyVOs[arg1_25]:isCompleted() then
						arg0_24:emit(TechnologyMediator.ON_FINISHED, {
							id = arg0_24.technologyVOs[arg1_25].id,
							pool_id = arg0_24.technologyVOs[arg1_25].poolId
						})
					else
						arg0_24:onSelected(arg2_25, arg1_25)
					end
				end

				var0_25:AddListener(arg0_24.lastButtonListener[arg2_25])
			end
		end)
	end

	arg0_24.itemList:align(#arg0_24.technologyVOs)
	setActive(arg0_24.srcollView, true)
end

function var0_0.initQueue(arg0_27)
	if not arg0_27.queueItemList then
		arg0_27.queueItemList = UIItemList.New(arg0_27.btnQueue, arg0_27.btnQueue:GetChild(0))

		arg0_27.queueItemList:make(function(arg0_28, arg1_28, arg2_28)
			arg1_28 = arg1_28 + 1

			if arg0_28 == UIItemList.EventUpdate then
				arg2_28.name = arg1_28

				if arg0_27.queueTimer[arg1_28] then
					arg0_27.queueTimer[arg1_28]:Stop()

					arg0_27.queueTimer[arg1_28] = nil
				end

				local var0_28 = {}
				local var1_28 = arg0_27.technologyQueue[arg1_28]

				if not var1_28 then
					var0_28.empty = true
				else
					local var2_28 = pg.TimeMgr.GetInstance():GetServerTime()
					local var3_28 = var1_28.time
					local var4_28 = var1_28:getConfig("time")

					if var2_28 < var3_28 - var4_28 then
						var0_28.waiting = true
					elseif var2_28 < var3_28 then
						var0_28.doing = true
						arg0_27.queueTimer[arg1_28] = Timer.New(function()
							local var0_29 = pg.TimeMgr.GetInstance():GetServerTime()

							if var0_29 < var3_28 then
								setSlider(arg2_28:Find("doing"), 0, var4_28, var4_28 - var3_28 + var0_29)
							else
								arg0_27:updateQueueChange()
							end
						end, 1, -1)

						arg0_27.queueTimer[arg1_28]:Start()
						arg0_27.queueTimer[arg1_28].func()
					else
						var0_28.complete = true
					end
				end

				eachChild(arg2_28, function(arg0_30)
					setActive(arg0_30, var0_28[arg0_30.name])
				end)
			end
		end)
	end

	arg0_27.queueItemList:align(TechnologyConst.QUEUE_TOTAL_COUNT)
	onButton(arg0_27, arg0_27.btnQueue, function()
		arg0_27:setPage(var0_0.PageQueue)
	end, SFX_PANEL)

	if not arg0_27.queueCardItemList then
		arg0_27.queueCardItemList = UIItemList.New(arg0_27.queueView, arg0_27.queueView:GetChild(0))

		arg0_27.queueCardItemList:make(function(arg0_32, arg1_32, arg2_32)
			arg1_32 = arg1_32 + 1

			if arg0_32 == UIItemList.EventUpdate then
				arg2_32.name = arg1_32

				arg0_27:updateTechnologyTF(arg2_32, arg1_32, "queue")
			end
		end)
	end

	arg0_27.queueCardItemList:align(TechnologyConst.QUEUE_TOTAL_COUNT)
	onButton(arg0_27, arg0_27.btnAwardQueue, function()
		if arg0_27.technologyQueue[1] and arg0_27.technologyQueue[1]:isCompleted() then
			arg0_27:emit(TechnologyMediator.ON_FINISH_QUEUE)
		end
	end, SFX_CONFIRM)
	setActive(arg0_27.btnAwardQueue, arg0_27.technologyQueue[1] and arg0_27.technologyQueue[1]:isCompleted())
	setActive(arg0_27.btnAwardQueueDisable, not isActive(arg0_27.btnAwardQueue))
end

function var0_0.updateRefreshBtn(arg0_34, arg1_34)
	setButtonEnabled(arg0_34.refreshBtn, arg1_34 == 0)
end

function var0_0.onSelected(arg0_35, arg1_35, arg2_35)
	if not arg2_35 then
		return
	end

	if not arg0_35.technologyVOs[arg2_35] then
		return
	end

	arg0_35.contextData.selectedIndex = arg2_35

	arg0_35:updateTechnologyTF(arg0_35.technologyTpl, arg2_35, "desc")

	arg0_35.srcollViewCG.alpha = 0.3

	setActive(arg1_35, false)
	setActive(arg0_35.selectetPanel, true)

	local var0_35 = {}

	eachChild(arg0_35.srcollView, function(arg0_36)
		var0_35[tonumber(arg0_36.name)] = arg0_36
	end)

	local function var1_35(arg0_37, arg1_37)
		local var0_37 = {}
		local var1_37 = arg0_37
		local var2_37 = var0_35[arg0_37].localPosition.x

		for iter0_37, iter1_37 in ipairs(var0_35) do
			var0_37[iter0_37] = var0_35[iter0_37].localPosition.x - var2_37
		end

		for iter2_37, iter3_37 in ipairs(var0_37) do
			if iter3_37 ~= 0 and (var0_37[var1_37] == 0 or arg1_37 and (iter3_37 > 0 and var0_37[var1_37] > 0 and iter3_37 > var0_37[var1_37] or iter3_37 < 0 and (var0_37[var1_37] > 0 or iter3_37 > var0_37[var1_37])) or not arg1_37 and (iter3_37 < 0 and var0_37[var1_37] < 0 and iter3_37 < var0_37[var1_37] or iter3_37 > 0 and (var0_37[var1_37] < 0 or iter3_37 < var0_37[var1_37]))) then
				var1_37 = iter2_37
			end
		end

		return var0_35[var1_37]
	end

	onButton(arg0_35, arg0_35.arrLeftBtn, function()
		if arg0_35.inAnim then
			return
		end

		arg0_35:cancelSelected()
		triggerButton(var1_35(arg2_35, true))
	end, SFX_PANEL)
	onButton(arg0_35, arg0_35.arrRightBtn, function()
		if arg0_35.inAnim then
			return
		end

		arg0_35:cancelSelected()
		triggerButton(var1_35(arg2_35, false))
	end, SFX_PANEL)
end

function var0_0.cancelSelected(arg0_40)
	if not arg0_40.technologyVOs[arg0_40.contextData.selectedIndex or 0] then
		return
	end

	local var0_40 = arg0_40.technologyCards[arg0_40.contextData.selectedIndex]

	arg0_40.contextData.selectedIndex = nil

	setActive(var0_40, true)
	removeOnButton(arg0_40.arrLeftBtn)
	removeOnButton(arg0_40.arrRightBtn)
	setActive(arg0_40.selectetPanel, false)

	arg0_40.srcollViewCG.alpha = 1
	arg0_40.inAnim = true

	if arg0_40.timer then
		arg0_40.timer:Stop()

		arg0_40.timer = nil
	end

	arg0_40.timer = Timer.New(function()
		arg0_40.inAnim = nil
	end, 0.2, 1)

	arg0_40.timer:Start()

	if arg0_40.extraTimer then
		arg0_40.extraTimer:Stop()

		arg0_40.extraTimer = nil
	end
end

function var0_0.updateTechnology(arg0_42, arg1_42)
	local var0_42

	for iter0_42, iter1_42 in ipairs(arg0_42.technologyVOs) do
		if iter1_42.id == arg1_42.id then
			arg0_42.technologyVOs[iter0_42] = arg1_42
			var0_42 = iter0_42

			break
		end
	end

	local var1_42 = arg0_42.technologyCards[var0_42]

	arg0_42:updateTechnologyTF(var1_42, var0_42, "base")

	if arg0_42.contextData.selectedIndex and arg0_42.technologyVOs[arg0_42.contextData.selectedIndex].id == arg1_42.id then
		arg0_42:updateTechnologyTF(arg0_42.technologyTpl, var0_42, "desc")
	end
end

function var0_0.updateQueueChange(arg0_43)
	arg0_43.queueItemList:align(#arg0_43.technologyQueue)
	arg0_43.queueCardItemList:align(TechnologyConst.QUEUE_TOTAL_COUNT)
	setActive(arg0_43.btnAwardQueue, arg0_43.technologyQueue[1] and arg0_43.technologyQueue[1]:isCompleted())
	setActive(arg0_43.btnAwardQueueDisable, not isActive(arg0_43.btnAwardQueue))

	local var0_43 = getProxy(TechnologyProxy):getActivateTechnology()

	if var0_43 then
		arg0_43:updateTechnology(var0_43)
	end
end

function var0_0.updateTechnologyTF(arg0_44, arg1_44, arg2_44, arg3_44)
	local var0_44

	if arg3_44 == "queue" then
		var0_44 = arg0_44.technologyQueue[arg2_44]

		local var1_44 = not tobool(var0_44)

		setActive(arg1_44:Find("frame"), not var1_44)
		setActive(arg1_44:Find("empty"), var1_44)

		if var1_44 then
			return
		end
	else
		var0_44 = arg0_44.technologyVOs[arg2_44]
	end

	arg0_44:updateInfo(arg1_44, var0_44, arg3_44)
	arg0_44:updateInfoVersionPickUp(arg1_44, var0_44)

	local var2_44 = var0_44:getConfig("time")
	local var3_44 = pg.TimeMgr.GetInstance():GetServerTime()
	local var4_44 = var0_44.time

	switch(arg3_44, {
		base = function()
			if arg0_44.cardtimer[arg2_44] then
				arg0_44.cardtimer[arg2_44]:Stop()

				arg0_44.cardtimer[arg2_44] = nil
			end

			local var0_45 = arg1_44:Find("frame/marks/time")
			local var1_45 = arg1_44:Find("frame/marks/Text")
			local var2_45 = var0_0.rarityColor[var0_44:getConfig("bg")]

			GetComponent(var0_45, "Shadow").effectColor = Color.New(unpack(var2_45[2]))

			local var3_45 = {}

			if var4_44 <= 0 then
				var3_45.blue = true

				setText(var1_45, setColorStr(i18n("technology_detail"), var2_45[1]))
				setText(var0_45, pg.TimeMgr.GetInstance():DescCDTime(var0_44:getConfig("time")))
			elseif var3_44 < var4_44 - var2_44 then
				var3_45.blue = true

				setText(var1_45, setColorStr(i18n("technology_queue_waiting"), var2_45[1]))
				setText(var0_45, pg.TimeMgr.GetInstance():DescCDTime(var0_44:getConfig("time")))

				arg0_44.cardtimer[arg2_44] = Timer.New(function()
					arg0_44:updateTechnology(var0_44)
				end, var4_44 - var2_44 - var3_44)

				arg0_44.cardtimer[arg2_44]:Start()
			elseif var3_44 < var4_44 then
				var3_45.blue = true

				setText(var1_45, setColorStr(i18n("technology_queue_processing"), var2_45[1]))

				arg0_44.cardtimer[arg2_44] = Timer.New(function()
					local var0_47 = var0_44.time
					local var1_47 = pg.TimeMgr.GetInstance():GetServerTime()

					if var1_47 < var0_47 then
						setText(var0_45, pg.TimeMgr.GetInstance():DescCDTime(var0_47 - var1_47))
					else
						arg0_44:updateTechnology(var0_44)
					end
				end, 1, -1)

				arg0_44.cardtimer[arg2_44]:Start()
				arg0_44.cardtimer[arg2_44].func()
			else
				var3_45.green = true

				if var0_44:isCompleted() then
					setText(var1_45, setColorStr(i18n("technology_queue_complete"), var2_45[1]))
				else
					setText(var1_45, setColorStr(i18n("technology_mission_unfinish"), var2_45[1]))
				end

				setText(var0_45, "00:00:00")
			end

			eachChild(arg1_44:Find("frame/marks/line"), function(arg0_48)
				setActive(arg0_48, var3_45[arg0_48.name])
			end)
		end,
		queue = function()
			if arg0_44.queueCardTimer[arg2_44] then
				arg0_44.queueCardTimer[arg2_44]:Stop()

				arg0_44.queueCardTimer[arg2_44] = nil
			end

			local var0_49 = arg1_44:Find("frame/marks/time")
			local var1_49 = arg1_44:Find("frame/marks/Text")
			local var2_49 = var0_0.rarityColor[var0_44:getConfig("bg")]

			GetComponent(var0_49, "Shadow").effectColor = Color.New(unpack(var2_49[2]))

			local var3_49 = {}

			if var4_44 <= 0 then
				assert(false, "error queue")
			elseif var3_44 < var4_44 - var2_44 then
				var3_49.blue = true

				setText(var1_49, setColorStr(i18n("technology_queue_waiting"), var2_49[1]))
				setText(var0_49, pg.TimeMgr.GetInstance():DescCDTime(var0_44:getConfig("time")))
			elseif var3_44 < var4_44 then
				var3_49.blue = true

				setText(var1_49, setColorStr(i18n("technology_queue_processing"), var2_49[1]))

				arg0_44.queueCardTimer[arg2_44] = Timer.New(function()
					local var0_50 = var0_44.time
					local var1_50 = pg.TimeMgr.GetInstance():GetServerTime()

					if var1_50 < var0_50 then
						setText(var0_49, pg.TimeMgr.GetInstance():DescCDTime(var0_50 - var1_50))
					end
				end, 1, -1)

				arg0_44.queueCardTimer[arg2_44]:Start()
				arg0_44.queueCardTimer[arg2_44].func()
			else
				var3_49.green = true

				setText(var1_49, setColorStr(i18n("technology_queue_complete"), var2_49[1]))
				setText(var0_49, "00:00:00")
			end

			eachChild(arg1_44:Find("frame/marks/line"), function(arg0_51)
				setActive(arg0_51, var3_49[arg0_51.name])
			end)
			setActive(arg1_44:Find("frame/mask"), var4_44 > 0 and var3_44 < var4_44 - var2_44)
		end,
		desc = function()
			arg0_44.descTxt.text = var0_44:getConfig("desc")
			arg0_44.descBG.sprite = GetSpriteFromAtlas("ui/TechnologyUI_atlas", var0_44:getConfig("rarity"))

			local var0_52 = var0_44:getConfig("consume")
			local var1_52 = UIItemList.New(arg0_44.itemContainer, arg0_44.itemTpl)

			var1_52:make(function(arg0_53, arg1_53, arg2_53)
				arg1_53 = arg1_53 + 1

				if arg0_53 == UIItemList.EventUpdate then
					arg0_44:updateItem(arg2_53, var0_44, var0_52[arg1_53])
					setActive(arg2_53:Find("check"), var0_44:isActivate())
					setActive(arg2_53:Find("icon_bg/count"), not var0_44:isActivate())
				end
			end)
			var1_52:align(#var0_52)
			setActive(arg0_44.emptyTF, not var0_52 or #var0_52 <= 0)

			local var2_52 = var0_44:getConfig("condition")

			if var2_52 > 0 then
				local var3_52 = getProxy(TaskProxy):getTaskById(var2_52) or Task.New({
					id = var2_52
				})

				arg0_44.taskSlider.value = var3_52.progress / var3_52:getConfig("target_num")
				arg0_44.taskDesc.text = var3_52:getConfig("desc") .. "(" .. var3_52.progress .. "/" .. var3_52:getConfig("target_num") .. ")"
			else
				arg0_44.taskDesc.text = i18n("technology_task_none_tip")
				arg0_44.taskSlider.value = 0
			end

			if arg0_44.extraTimer then
				arg0_44.extraTimer:Stop()

				arg0_44.extraTimer = nil
			end

			local var4_52 = {}

			if var4_44 <= 0 then
				var4_52.start_btn = true
				arg0_44.timerTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var2_44)
			elseif var3_44 < var4_44 - var2_44 then
				var4_52.stop_btn = true
				var4_52.join_btn = var0_44:finishCondition()
				var4_52.lock_join_btn = not var4_52.join_btn
				arg0_44.timerTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var2_44)
			elseif var3_44 < var4_44 then
				var4_52.stop_btn = true
				var4_52.join_btn = var0_44:finishCondition()
				var4_52.lock_join_btn = not var4_52.join_btn
				arg0_44.extraTimer = Timer.New(function()
					local var0_54 = pg.TimeMgr.GetInstance():GetServerTime()

					if var0_54 < var4_44 then
						arg0_44.timerTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var4_44 - var0_54)
					end
				end, 1, -1)

				arg0_44.extraTimer:Start()
				arg0_44.extraTimer.func()
			else
				if var0_44:isCompleted() then
					var4_52.finish_btn = true
				else
					var4_52.stop_btn = true
					var4_52.lock_join_btn = true
				end

				arg0_44.timerTxt.text = "00:00:00"
			end

			eachChild(arg1_44:Find("frame/btns"), function(arg0_55)
				setActive(arg0_55, var4_52[arg0_55.name])
			end)

			local var5_52 = arg1_44:Find("frame/btns/start_btn")

			onButton(arg0_44, var5_52, function()
				if getProxy(TechnologyProxy):getActivateTechnology() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("technology_is_actived"))

					return
				end

				local var0_56 = var0_44:getConfig("consume")

				if #var0_56 > 0 then
					local var1_56 = getDropInfo(var0_56)

					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("technology_task_build_tip", var1_56),
						onYes = function()
							arg0_44:emit(TechnologyMediator.ON_START, {
								id = var0_44.id,
								pool_id = var0_44.poolId
							})
						end
					})
				else
					arg0_44:emit(TechnologyMediator.ON_START, {
						id = var0_44.id,
						pool_id = var0_44.poolId
					})
				end
			end, SFX_PANEL)
			setButtonEnabled(var5_52, var0_44:hasResToStart())

			local var6_52 = arg1_44:Find("frame/btns/stop_btn")

			onButton(arg0_44, var6_52, function()
				if not var0_44:isActivate() then
					return
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("technology_stop_tip"),
					onYes = function()
						arg0_44:emit(TechnologyMediator.ON_STOP, {
							id = var0_44.id,
							pool_id = var0_44.poolId
						})
					end
				})
			end, SFX_PANEL)

			local var7_52 = arg1_44:Find("frame/btns/join_btn")

			onButton(arg0_44, var7_52, function()
				if #arg0_44.technologyQueue == TechnologyConst.QUEUE_TOTAL_COUNT then
					pg.TipsMgr.GetInstance():ShowTips(i18n("technology_queue_full"))

					return
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("technology_queue_in_doublecheck"),
					onYes = function()
						arg0_44:emit(TechnologyMediator.ON_JOIN_QUEUE, {
							id = var0_44.id,
							pool_id = var0_44.poolId
						})
					end
				})
			end, SFX_PANEL)

			local var8_52 = arg1_44:Find("frame/btns/lock_join_btn")

			onButton(arg0_44, var8_52, function()
				pg.TipsMgr.GetInstance():ShowTips(i18n("technology_queue_in_mission_incomplete"))
			end, SFX_PANEL)

			local var9_52 = arg1_44:Find("frame/btns/finish_btn")

			onButton(arg0_44, var9_52, function()
				arg0_44:emit(TechnologyMediator.ON_FINISHED, {
					id = var0_44.id,
					pool_id = var0_44.poolId
				})
			end, SFX_PANEL)
		end
	})
end

function var0_0.dfs(arg0_64, arg1_64, arg2_64)
	if arg1_64.name ~= "item_tpl" then
		for iter0_64 = 1, arg1_64.childCount do
			arg0_64:dfs(arg1_64:GetChild(iter0_64 - 1), arg2_64)
		end
	else
		arg2_64(arg1_64)
	end
end

local var1_0 = {
	tag_red = "F15F34FF",
	tag_blue = "2541E3FF"
}

function var0_0.updateInfo(arg0_65, arg1_65, arg2_65, arg3_65)
	setImageSprite(arg1_65:Find("frame"), GetSpriteFromAtlas("technologycard", arg2_65:getConfig("bg") .. (arg3_65 == "desc" and "_l" or "")))
	setImageSprite(arg1_65:Find("frame/icon_mask/icon"), GetSpriteFromAtlas("technologyshipicon/" .. arg2_65:getConfig("bg_icon"), arg2_65:getConfig("bg_icon")), true)
	setImageSprite(arg1_65:Find("frame/top/label"), GetSpriteFromAtlas("technologycard", arg2_65:getConfig("label")))
	setImageSprite(arg1_65:Find("frame/top/label/text"), GetSpriteFromAtlas("technologycard", arg2_65:getConfig("label_color")), true)
	setImageSprite(arg1_65:Find("frame/top/label/version"), GetSpriteFromAtlas("technologycard", "version_" .. arg2_65:getConfig("blueprint_version")), true)
	setImageColor(arg1_65:Find("frame/top/pick_up"), Color.NewHex(var1_0[arg2_65:getConfig("label")]))
	setText(arg1_65:Find("frame/name_bg/Text"), arg2_65:getConfig("name"))
	setText(arg1_65:Find("frame/sub_name"), arg2_65:getConfig("sub_name") or "")

	local var0_65 = arg2_65:getConfig("drop_client")
	local var1_65 = arg1_65:Find("frame/item_container")
	local var2_65 = 0

	arg0_65:dfs(var1_65, function(arg0_66)
		var2_65 = var2_65 + 1

		setActive(arg0_66, var2_65 <= #var0_65)

		if var2_65 <= #var0_65 then
			arg0_65:updateItem(arg0_66, arg2_65, var0_65[var2_65])
		end
	end)
	switch(arg3_65, {
		desc = function()
			return
		end
	}, function()
		setActive(var1_65:GetChild(1), #var0_65 > 2)

		var1_65:GetChild(0):GetComponent("HorizontalLayoutGroup").padding.right = #var0_65 == 4 and 25 or 0
		var1_65:GetChild(1):GetComponent("HorizontalLayoutGroup").padding.left = #var0_65 == 4 and 25 or 0
	end)
end

function var0_0.updateInfoVersionPickUp(arg0_69, arg1_69, arg2_69)
	local var0_69 = getProxy(TechnologyProxy):getTendency(2)

	setActive(arg1_69:Find("frame/top/pick_up"), var0_69 == arg2_69:getConfig("blueprint_version"))
end

function var0_0.updateItem(arg0_70, arg1_70, arg2_70, arg3_70)
	local var0_70 = Drop.Create(arg3_70)

	updateDrop(arg1_70, setmetatable({
		count = 0
	}, {
		__index = var0_70
	}))

	local var1_70 = arg1_70:Find("icon_bg/count")

	if not IsNil(var1_70) then
		setColorCount(var1_70, var0_70:getOwnedCount(), var0_70.count)
	end

	onButton(arg0_70, arg1_70, function()
		local var0_71 = var0_70:getConfig("display_icon") or {}

		if #var0_71 > 0 then
			local var1_71 = {
				type = MSGBOX_TYPE_ITEM_BOX,
				items = _.map(var0_71, function(arg0_72)
					return {
						type = arg0_72[1],
						id = arg0_72[2]
					}
				end),
				content = var0_70:getConfig("display")
			}

			function var1_71.itemFunc(arg0_73)
				arg0_70:emit(var0_0.ON_DROP, arg0_73, function()
					pg.MsgboxMgr.GetInstance():ShowMsgBox(var1_71)
				end)
			end

			pg.MsgboxMgr.GetInstance():ShowMsgBox(var1_71)
		else
			arg0_70:emit(var0_0.ON_DROP, var0_70)
		end
	end, SFX_PANEL)
end

function var0_0.updatePickUpVersionChange(arg0_75)
	arg0_75:updateSettingBtnVersion()

	for iter0_75, iter1_75 in ipairs(arg0_75.technologyCards) do
		arg0_75:updateInfoVersionPickUp(iter1_75, arg0_75.technologyVOs[iter0_75])
	end

	for iter2_75, iter3_75 in ipairs(arg0_75.technologyQueue) do
		arg0_75:updateInfoVersionPickUp(arg0_75.queueCardItemList.container:GetChild(iter2_75 - 1), iter3_75)
	end
end

function var0_0.clearTimer(arg0_76, ...)
	if arg0_76.timer then
		arg0_76.timer:Stop()

		arg0_76.timer = nil
	end

	if arg0_76.extraTimer then
		arg0_76.extraTimer:Stop()

		arg0_76.extraTimer = nil
	end

	if arg0_76.enhancelTimer then
		arg0_76.enhancelTimer:Stop()

		arg0_76.enhancelTimer = nil
	end

	for iter0_76, iter1_76 in pairs(arg0_76.cardtimer) do
		iter1_76:Stop()
	end

	arg0_76.cardtimer = {}

	for iter2_76, iter3_76 in pairs(arg0_76.queueTimer) do
		iter3_76:Stop()
	end

	arg0_76.queueTimer = {}

	for iter4_76, iter5_76 in pairs(arg0_76.queueCardTimer) do
		iter5_76:Stop()
	end

	arg0_76.queueCardTimer = {}

	if arg0_76.actCatchupTimer then
		arg0_76.actCatchupTimer:Stop()

		arg0_76.actCatchupTimer = nil
	end
end

function var0_0.willExit(arg0_77)
	arg0_77:clearTimer()

	arg0_77.cardtimer = nil
	arg0_77.queueTimer = nil
	arg0_77.queueCardTimer = nil
end

return var0_0
