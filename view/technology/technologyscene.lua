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

function var0_0.onBackPressed(arg0_2)
	if arg0_2.contextData.selectedIndex then
		arg0_2:cancelSelected()

		return
	end

	if arg0_2.contextData.page == var0_0.PageQueue then
		arg0_2:setPage(var0_0.PageBase)

		return
	end

	var0_0.super.onBackPressed(arg0_2)
end

function var0_0.ResUISettings(arg0_3)
	return true
end

function var0_0.setTechnologys(arg0_4, arg1_4, arg2_4)
	arg0_4.technologyVOs = arg1_4
	arg0_4.technologyQueue = arg2_4
end

function var0_0.setRefreshFlag(arg0_5, arg1_5)
	arg0_5.flag = arg1_5
end

function var0_0.setPlayer(arg0_6, arg1_6)
	arg0_6.player = arg1_6
end

function var0_0.init(arg0_7)
	arg0_7.backBtn = arg0_7._tf:Find("blur_panel/adapt/top/back")
	arg0_7.basePage = arg0_7._tf:Find("main/base_page")
	arg0_7.srcollView = arg0_7.basePage:Find("srcoll_rect/content")
	arg0_7.srcollViewCG = arg0_7.srcollView:GetComponent(typeof(CanvasGroup))
	arg0_7.helpBtn = arg0_7.basePage:Find("help_btn")
	arg0_7.refreshBtn = arg0_7.basePage:Find("refresh_btn")

	setText(arg0_7.refreshBtn:Find("Text"), i18n("technology_daily_refresh"))

	arg0_7.settingsBtn = arg0_7.basePage:Find("settings_btn")
	arg0_7.selectetPanel = arg0_7.basePage:Find("selecte_panel")

	setActive(arg0_7.selectetPanel, false)
	setText(arg0_7.selectetPanel:Find("consume_panel/bg/label/Text"), i18n("technology_consume"))
	setText(arg0_7.selectetPanel:Find("consume_panel/bg/task_panel/label/Text"), i18n("technology_request"))

	arg0_7.arrLeftBtn = arg0_7.selectetPanel:Find("left_arr_btn")
	arg0_7.arrRightBtn = arg0_7.selectetPanel:Find("right_arr_btn")
	arg0_7.technologyTpl = arg0_7.selectetPanel:Find("technology_card")
	arg0_7.descTxt = arg0_7.selectetPanel:Find("desc/bg/Text"):GetComponent(typeof(Text))
	arg0_7.timerTxt = arg0_7.selectetPanel:Find("timer/bg/Text"):GetComponent(typeof(Text))
	arg0_7.itemContainer = arg0_7.selectetPanel:Find("consume_panel/bg/container")
	arg0_7.itemTpl = arg0_7:findTF("item_tpl", arg0_7.itemContainer)
	arg0_7.emptyTF = arg0_7.selectetPanel:Find("consume_panel/bg/empty")
	arg0_7.taskPanel = arg0_7.selectetPanel:Find("consume_panel/bg/task_panel")
	arg0_7.taskSlider = arg0_7.taskPanel:Find("slider"):GetComponent(typeof(Slider))
	arg0_7.taskDesc = arg0_7.taskPanel:Find("slider/Text"):GetComponent(typeof(Text))
	arg0_7.descBG = arg0_7.selectetPanel:Find("desc/bg"):GetComponent(typeof(Image))
	arg0_7.queuePage = arg0_7._tf:Find("main/queue_page")
	arg0_7.queueView = arg0_7.queuePage:Find("queue_rect/content")

	local var0_7 = arg0_7._tf:Find("blur_panel/adapt/right")

	arg0_7.btnAwardQueue = var0_7:Find("btn_award")

	setText(arg0_7.btnAwardQueue:Find("Text"), i18n("technology_queue_getaward"))

	arg0_7.btnAwardQueueDisable = var0_7:Find("btn_award_disable")

	setText(arg0_7.btnAwardQueueDisable:Find("Text"), i18n("technology_queue_getaward"))

	arg0_7.btnQueue = arg0_7._tf:Find("blur_panel/adapt/left/btn_queue")
	arg0_7.cardtimer = {}
	arg0_7.queueTimer = {}
	arg0_7.queueCardTimer = {}
end

function var0_0.updateSettingsBtn(arg0_8)
	local var0_8 = arg0_8:findTF("RedPoint", arg0_8.settingsBtn)
	local var1_8 = arg0_8:findTF("TipText", arg0_8.settingsBtn)

	setText(var1_8, i18n("tec_settings_btn_word"))

	local var2_8 = arg0_8:findTF("TargetCatchup", arg0_8.settingsBtn)
	local var3_8 = arg0_8:findTF("Selected", var2_8)
	local var4_8 = arg0_8:findTF("ActCatchup", arg0_8.settingsBtn)

	arg0_8:updateSettingBtnVersion()

	local var5_8 = false
	local var6_8 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BLUEPRINT_CATCHUP)

	if var6_8 and not var6_8:isEnd() then
		local var7_8 = var6_8.data1
		local var8_8 = var6_8:getConfig("config_id")
		local var9_8 = pg.activity_event_blueprint_catchup[var8_8].char_choice
		local var10_8 = pg.activity_event_blueprint_catchup[var8_8].obtain_max

		if var7_8 < var10_8 then
			local var11_8 = arg0_8:findTF("Selected/CharImg", var4_8)

			setImageSprite(var11_8, LoadSprite("TecCatchup/QChar" .. var9_8, tostring(var9_8)))

			local var12_8 = arg0_8:findTF("Selected/ProgressText", var4_8)

			setText(var12_8, var7_8 .. "/" .. var10_8)

			local var13_8 = var6_8.stopTime - pg.TimeMgr.GetInstance():GetServerTime()

			if arg0_8.actCatchupTimer then
				arg0_8.actCatchupTimer:Stop()

				arg0_8.actCatchupTimer = nil
			end

			local var14_8 = arg0_8:findTF("TimeLeft/Day", var4_8)
			local var15_8 = arg0_8:findTF("TimeLeft/Hour", var4_8)
			local var16_8 = arg0_8:findTF("TimeLeft/Min", var4_8)
			local var17_8 = arg0_8:findTF("TimeLeft/NumText", var4_8)

			local function var18_8()
				local var0_9, var1_9, var2_9, var3_9 = pg.TimeMgr.GetInstance():parseTimeFrom(var13_8)

				var13_8 = var13_8 - 1

				if var0_9 >= 1 then
					setActive(var14_8, true)
					setActive(var15_8, false)
					setActive(var16_8, false)
					setText(var17_8, var0_9)
				elseif var0_9 <= 0 and var1_9 > 0 then
					setActive(var14_8, false)
					setActive(var15_8, true)
					setActive(var16_8, false)
					setText(var17_8, var1_9)
				elseif var0_9 <= 0 and var1_9 <= 0 and (var2_9 > 0 or var3_9 > 0) then
					setActive(var14_8, false)
					setActive(var15_8, false)
					setActive(var16_8, true)
					setText(var17_8, math.max(var2_9, 1))
				elseif var0_9 <= 0 and var1_9 <= 0 and var2_9 <= 0 and var3_9 <= 0 and arg0_8.actCatchupTimer then
					arg0_8.actCatchupTimer:Stop()

					arg0_8.actCatchupTimer = nil

					setActive(var4_8, false)
				end
			end

			arg0_8.actCatchupTimer = Timer.New(var18_8, 1, -1, 1)

			arg0_8.actCatchupTimer:Start()
			arg0_8.actCatchupTimer.func()

			var5_8 = true
		end
	end

	setActive(var4_8, var5_8)
	setActive(var2_8, true)

	local var19_8 = getProxy(TechnologyProxy)
	local var20_8 = var19_8:isOpenTargetCatchup()
	local var21_8 = var19_8:isOnCatchup()

	if var20_8 then
		if not var21_8 then
			setActive(var3_8, false)
			setActive(var0_8, true)
		else
			local var22_8 = var19_8:getCurCatchupTecInfo()
			local var23_8 = var22_8.tecID
			local var24_8 = var22_8.groupID
			local var25_8 = var22_8.printNum
			local var26_8 = var19_8:getCatchupData(var23_8):isUr(var24_8) and pg.technology_catchup_template[var23_8].obtain_max_per_ur or pg.technology_catchup_template[var23_8].obtain_max

			if var26_8 <= var25_8 then
				setActive(var3_8, false)
				setActive(var0_8, false)
			else
				setActive(var3_8, true)
				setActive(var0_8, false)

				local var27_8 = arg0_8:findTF("CharImg", var3_8)

				setImageSprite(var27_8, LoadSprite("TecCatchup/QChar" .. var24_8, tostring(var24_8)))

				local var28_8 = arg0_8:findTF("ProgressText", var3_8)

				setText(var28_8, var25_8 .. "/" .. var26_8)
			end
		end
	else
		setActive(var3_8, false)
		setActive(var0_8, false)
	end
end

function var0_0.updateSettingBtnVersion(arg0_10)
	local var0_10 = getProxy(TechnologyProxy):getTendency(2)
	local var1_10 = arg0_10.settingsBtn:Find("tag")

	setActive(var1_10, var0_10 > 0)

	if var0_10 > 0 then
		GetImageSpriteFromAtlasAsync("technologycard", "version_" .. var0_10, var1_10:Find("Image"), true)
	end
end

function var0_0.setPage(arg0_11, arg1_11)
	arg0_11.contextData.page = arg1_11

	setActive(arg0_11.basePage, arg1_11 == var0_0.PageBase)
	setActive(arg0_11.queuePage, arg1_11 == var0_0.PageQueue)
	setActive(arg0_11._tf:Find("blur_panel/adapt/top/title"), arg1_11 == var0_0.PageBase)
	setActive(arg0_11._tf:Find("blur_panel/adapt/left"), arg1_11 == var0_0.PageBase)
	setActive(arg0_11._tf:Find("blur_panel/adapt/top/title_queue"), arg1_11 == var0_0.PageQueue)
	setActive(arg0_11._tf:Find("blur_panel/adapt/right"), arg1_11 == var0_0.PageQueue)

	if arg1_11 == var0_0.PageBase then
		for iter0_11, iter1_11 in ipairs(arg0_11.technologyVOs) do
			if iter1_11:isActivate() then
				if arg0_11.enhancelTimer then
					arg0_11.enhancelTimer:Stop()
				end

				arg0_11.enhancelTimer = Timer.New(function()
					arg0_11.srcollView:GetComponent("EnhancelScrollView"):SetHorizontalTargetItemIndex(arg0_11.technologyCards[iter0_11]:GetComponent("EnhanceItem").scrollViewItemIndex)

					arg0_11.enhancelTimer = nil
				end, 0.35, 1)

				arg0_11.enhancelTimer:Start()

				break
			end
		end
	end
end

function var0_0.didEnter(arg0_13)
	arg0_13:initTechnologys()
	arg0_13:initQueue()
	arg0_13:setPage(arg0_13.contextData.page or var0_0.PageBase)
	onButton(arg0_13, arg0_13.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.technology_help_text.tip
		})
	end, SFX_PANEL)
	onButton(arg0_13, arg0_13.refreshBtn, function()
		if tobool(getProxy(TechnologyProxy):getActivateTechnology()) then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("technology_canot_refresh")
			})

			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("technology_refresh_tip"),
			onYes = function()
				arg0_13:emit(TechnologyMediator.ON_REFRESH)
			end
		})
	end, SFX_PANEL)

	local var0_13 = getProxy(TechnologyProxy):getConfigMaxVersion()

	onButton(arg0_13, arg0_13.settingsBtn, function()
		arg0_13:emit(TechnologyMediator.ON_CLICK_SETTINGS_BTN)
	end, SFX_PANEL)
	onButton(arg0_13, arg0_13.backBtn, function()
		arg0_13:onBackPressed()
	end, SOUND_BACK)
	onButton(arg0_13, arg0_13.selectetPanel, function()
		arg0_13:cancelSelected()
	end, SFX_PANEL)
	arg0_13:updateRefreshBtn(arg0_13.flag)
	arg0_13:updateSettingsBtn()
end

function var0_0.initTechnologys(arg0_20)
	arg0_20.technologyCards = {}
	arg0_20.lastButtonListener = arg0_20.lastButtonListener or {}

	if not arg0_20.itemList then
		arg0_20.itemList = UIItemList.New(arg0_20.srcollView, arg0_20.srcollView:GetChild(0))

		arg0_20.itemList:make(function(arg0_21, arg1_21, arg2_21)
			arg1_21 = arg1_21 + 1

			if arg0_21 == UIItemList.EventUpdate then
				arg2_21.name = arg1_21
				arg0_20.technologyCards[arg1_21] = arg2_21

				arg0_20:updateTechnologyTF(arg2_21, arg1_21, "base")

				local var0_21 = GetOrAddComponent(arg2_21, typeof(Button)).onClick

				if arg0_20.lastButtonListener[arg2_21] then
					var0_21:RemoveListener(arg0_20.lastButtonListener[arg2_21])
				end

				arg0_20.lastButtonListener[arg2_21] = function()
					pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)

					if arg0_20.technologyVOs[arg1_21]:isCompleted() then
						arg0_20:emit(TechnologyMediator.ON_FINISHED, {
							id = arg0_20.technologyVOs[arg1_21].id,
							pool_id = arg0_20.technologyVOs[arg1_21].poolId
						})
					else
						arg0_20:onSelected(arg2_21, arg1_21)
					end
				end

				var0_21:AddListener(arg0_20.lastButtonListener[arg2_21])
			end
		end)
	end

	arg0_20.itemList:align(#arg0_20.technologyVOs)
	setActive(arg0_20.srcollView, true)
end

function var0_0.initQueue(arg0_23)
	if not arg0_23.queueItemList then
		arg0_23.queueItemList = UIItemList.New(arg0_23.btnQueue, arg0_23.btnQueue:GetChild(0))

		arg0_23.queueItemList:make(function(arg0_24, arg1_24, arg2_24)
			arg1_24 = arg1_24 + 1

			if arg0_24 == UIItemList.EventUpdate then
				arg2_24.name = arg1_24

				if arg0_23.queueTimer[arg1_24] then
					arg0_23.queueTimer[arg1_24]:Stop()

					arg0_23.queueTimer[arg1_24] = nil
				end

				local var0_24 = {}
				local var1_24 = arg0_23.technologyQueue[arg1_24]

				if not var1_24 then
					var0_24.empty = true
				else
					local var2_24 = pg.TimeMgr.GetInstance():GetServerTime()
					local var3_24 = var1_24.time
					local var4_24 = var1_24:getConfig("time")

					if var2_24 < var3_24 - var4_24 then
						var0_24.waiting = true
					elseif var2_24 < var3_24 then
						var0_24.doing = true
						arg0_23.queueTimer[arg1_24] = Timer.New(function()
							local var0_25 = pg.TimeMgr.GetInstance():GetServerTime()

							if var0_25 < var3_24 then
								setSlider(arg2_24:Find("doing"), 0, var4_24, var4_24 - var3_24 + var0_25)
							else
								arg0_23:updateQueueChange()
							end
						end, 1, -1)

						arg0_23.queueTimer[arg1_24]:Start()
						arg0_23.queueTimer[arg1_24].func()
					else
						var0_24.complete = true
					end
				end

				eachChild(arg2_24, function(arg0_26)
					setActive(arg0_26, var0_24[arg0_26.name])
				end)
			end
		end)
	end

	arg0_23.queueItemList:align(TechnologyConst.QUEUE_TOTAL_COUNT)
	onButton(arg0_23, arg0_23.btnQueue, function()
		arg0_23:setPage(var0_0.PageQueue)
	end, SFX_PANEL)

	if not arg0_23.queueCardItemList then
		arg0_23.queueCardItemList = UIItemList.New(arg0_23.queueView, arg0_23.queueView:GetChild(0))

		arg0_23.queueCardItemList:make(function(arg0_28, arg1_28, arg2_28)
			arg1_28 = arg1_28 + 1

			if arg0_28 == UIItemList.EventUpdate then
				arg2_28.name = arg1_28

				arg0_23:updateTechnologyTF(arg2_28, arg1_28, "queue")
			end
		end)
	end

	arg0_23.queueCardItemList:align(TechnologyConst.QUEUE_TOTAL_COUNT)
	onButton(arg0_23, arg0_23.btnAwardQueue, function()
		if arg0_23.technologyQueue[1] and arg0_23.technologyQueue[1]:isCompleted() then
			arg0_23:emit(TechnologyMediator.ON_FINISH_QUEUE)
		end
	end, SFX_CONFIRM)
	setActive(arg0_23.btnAwardQueue, arg0_23.technologyQueue[1] and arg0_23.technologyQueue[1]:isCompleted())
	setActive(arg0_23.btnAwardQueueDisable, not isActive(arg0_23.btnAwardQueue))
end

function var0_0.updateRefreshBtn(arg0_30, arg1_30)
	setButtonEnabled(arg0_30.refreshBtn, arg1_30 == 0)
end

function var0_0.onSelected(arg0_31, arg1_31, arg2_31)
	if not arg2_31 then
		return
	end

	if not arg0_31.technologyVOs[arg2_31] then
		return
	end

	arg0_31.contextData.selectedIndex = arg2_31

	arg0_31:updateTechnologyTF(arg0_31.technologyTpl, arg2_31, "desc")

	arg0_31.srcollViewCG.alpha = 0.3

	setActive(arg1_31, false)
	setActive(arg0_31.selectetPanel, true)

	local var0_31 = {}

	eachChild(arg0_31.srcollView, function(arg0_32)
		var0_31[tonumber(arg0_32.name)] = arg0_32
	end)

	local function var1_31(arg0_33, arg1_33)
		local var0_33 = {}
		local var1_33 = arg0_33
		local var2_33 = var0_31[arg0_33].localPosition.x

		for iter0_33, iter1_33 in ipairs(var0_31) do
			var0_33[iter0_33] = var0_31[iter0_33].localPosition.x - var2_33
		end

		for iter2_33, iter3_33 in ipairs(var0_33) do
			if iter3_33 ~= 0 and (var0_33[var1_33] == 0 or arg1_33 and (iter3_33 > 0 and var0_33[var1_33] > 0 and iter3_33 > var0_33[var1_33] or iter3_33 < 0 and (var0_33[var1_33] > 0 or iter3_33 > var0_33[var1_33])) or not arg1_33 and (iter3_33 < 0 and var0_33[var1_33] < 0 and iter3_33 < var0_33[var1_33] or iter3_33 > 0 and (var0_33[var1_33] < 0 or iter3_33 < var0_33[var1_33]))) then
				var1_33 = iter2_33
			end
		end

		return var0_31[var1_33]
	end

	onButton(arg0_31, arg0_31.arrLeftBtn, function()
		if arg0_31.inAnim then
			return
		end

		arg0_31:cancelSelected()
		triggerButton(var1_31(arg2_31, true))
	end, SFX_PANEL)
	onButton(arg0_31, arg0_31.arrRightBtn, function()
		if arg0_31.inAnim then
			return
		end

		arg0_31:cancelSelected()
		triggerButton(var1_31(arg2_31, false))
	end, SFX_PANEL)
end

function var0_0.cancelSelected(arg0_36)
	if not arg0_36.technologyVOs[arg0_36.contextData.selectedIndex or 0] then
		return
	end

	local var0_36 = arg0_36.technologyCards[arg0_36.contextData.selectedIndex]

	arg0_36.contextData.selectedIndex = nil

	setActive(var0_36, true)
	removeOnButton(arg0_36.arrLeftBtn)
	removeOnButton(arg0_36.arrRightBtn)
	setActive(arg0_36.selectetPanel, false)

	arg0_36.srcollViewCG.alpha = 1
	arg0_36.inAnim = true

	if arg0_36.timer then
		arg0_36.timer:Stop()

		arg0_36.timer = nil
	end

	arg0_36.timer = Timer.New(function()
		arg0_36.inAnim = nil
	end, 0.2, 1)

	arg0_36.timer:Start()

	if arg0_36.extraTimer then
		arg0_36.extraTimer:Stop()

		arg0_36.extraTimer = nil
	end
end

function var0_0.updateTechnology(arg0_38, arg1_38)
	local var0_38

	for iter0_38, iter1_38 in ipairs(arg0_38.technologyVOs) do
		if iter1_38.id == arg1_38.id then
			arg0_38.technologyVOs[iter0_38] = arg1_38
			var0_38 = iter0_38

			break
		end
	end

	local var1_38 = arg0_38.technologyCards[var0_38]

	arg0_38:updateTechnologyTF(var1_38, var0_38, "base")

	if arg0_38.contextData.selectedIndex and arg0_38.technologyVOs[arg0_38.contextData.selectedIndex].id == arg1_38.id then
		arg0_38:updateTechnologyTF(arg0_38.technologyTpl, var0_38, "desc")
	end
end

function var0_0.updateQueueChange(arg0_39)
	arg0_39.queueItemList:align(#arg0_39.technologyQueue)
	arg0_39.queueCardItemList:align(TechnologyConst.QUEUE_TOTAL_COUNT)
	setActive(arg0_39.btnAwardQueue, arg0_39.technologyQueue[1] and arg0_39.technologyQueue[1]:isCompleted())
	setActive(arg0_39.btnAwardQueueDisable, not isActive(arg0_39.btnAwardQueue))

	local var0_39 = getProxy(TechnologyProxy):getActivateTechnology()

	if var0_39 then
		arg0_39:updateTechnology(var0_39)
	end
end

function var0_0.updateTechnologyTF(arg0_40, arg1_40, arg2_40, arg3_40)
	local var0_40

	if arg3_40 == "queue" then
		var0_40 = arg0_40.technologyQueue[arg2_40]

		local var1_40 = not tobool(var0_40)

		setActive(arg1_40:Find("frame"), not var1_40)
		setActive(arg1_40:Find("empty"), var1_40)

		if var1_40 then
			return
		end
	else
		var0_40 = arg0_40.technologyVOs[arg2_40]
	end

	arg0_40:updateInfo(arg1_40, var0_40, arg3_40)
	arg0_40:updateInfoVersionPickUp(arg1_40, var0_40)

	local var2_40 = var0_40:getConfig("time")
	local var3_40 = pg.TimeMgr.GetInstance():GetServerTime()
	local var4_40 = var0_40.time

	switch(arg3_40, {
		base = function()
			if arg0_40.cardtimer[arg2_40] then
				arg0_40.cardtimer[arg2_40]:Stop()

				arg0_40.cardtimer[arg2_40] = nil
			end

			local var0_41 = arg1_40:Find("frame/marks/time")
			local var1_41 = arg1_40:Find("frame/marks/Text")
			local var2_41 = var0_0.rarityColor[var0_40:getConfig("bg")]

			GetComponent(var0_41, "Shadow").effectColor = Color.New(unpack(var2_41[2]))

			local var3_41 = {}

			if var4_40 <= 0 then
				var3_41.blue = true

				setText(var1_41, setColorStr(i18n("technology_detail"), var2_41[1]))
				setText(var0_41, pg.TimeMgr.GetInstance():DescCDTime(var0_40:getConfig("time")))
			elseif var3_40 < var4_40 - var2_40 then
				var3_41.blue = true

				setText(var1_41, setColorStr(i18n("technology_queue_waiting"), var2_41[1]))
				setText(var0_41, pg.TimeMgr.GetInstance():DescCDTime(var0_40:getConfig("time")))

				arg0_40.cardtimer[arg2_40] = Timer.New(function()
					arg0_40:updateTechnology(var0_40)
				end, var4_40 - var2_40 - var3_40)

				arg0_40.cardtimer[arg2_40]:Start()
			elseif var3_40 < var4_40 then
				var3_41.blue = true

				setText(var1_41, setColorStr(i18n("technology_queue_processing"), var2_41[1]))

				arg0_40.cardtimer[arg2_40] = Timer.New(function()
					local var0_43 = var0_40.time
					local var1_43 = pg.TimeMgr.GetInstance():GetServerTime()

					if var1_43 < var0_43 then
						setText(var0_41, pg.TimeMgr.GetInstance():DescCDTime(var0_43 - var1_43))
					else
						arg0_40:updateTechnology(var0_40)
					end
				end, 1, -1)

				arg0_40.cardtimer[arg2_40]:Start()
				arg0_40.cardtimer[arg2_40].func()
			else
				var3_41.green = true

				if var0_40:isCompleted() then
					setText(var1_41, setColorStr(i18n("technology_queue_complete"), var2_41[1]))
				else
					setText(var1_41, setColorStr(i18n("technology_mission_unfinish"), var2_41[1]))
				end

				setText(var0_41, "00:00:00")
			end

			eachChild(arg1_40:Find("frame/marks/line"), function(arg0_44)
				setActive(arg0_44, var3_41[arg0_44.name])
			end)
		end,
		queue = function()
			if arg0_40.queueCardTimer[arg2_40] then
				arg0_40.queueCardTimer[arg2_40]:Stop()

				arg0_40.queueCardTimer[arg2_40] = nil
			end

			local var0_45 = arg1_40:Find("frame/marks/time")
			local var1_45 = arg1_40:Find("frame/marks/Text")
			local var2_45 = var0_0.rarityColor[var0_40:getConfig("bg")]

			GetComponent(var0_45, "Shadow").effectColor = Color.New(unpack(var2_45[2]))

			local var3_45 = {}

			if var4_40 <= 0 then
				assert(false, "error queue")
			elseif var3_40 < var4_40 - var2_40 then
				var3_45.blue = true

				setText(var1_45, setColorStr(i18n("technology_queue_waiting"), var2_45[1]))
				setText(var0_45, pg.TimeMgr.GetInstance():DescCDTime(var0_40:getConfig("time")))
			elseif var3_40 < var4_40 then
				var3_45.blue = true

				setText(var1_45, setColorStr(i18n("technology_queue_processing"), var2_45[1]))

				arg0_40.queueCardTimer[arg2_40] = Timer.New(function()
					local var0_46 = var0_40.time
					local var1_46 = pg.TimeMgr.GetInstance():GetServerTime()

					if var1_46 < var0_46 then
						setText(var0_45, pg.TimeMgr.GetInstance():DescCDTime(var0_46 - var1_46))
					end
				end, 1, -1)

				arg0_40.queueCardTimer[arg2_40]:Start()
				arg0_40.queueCardTimer[arg2_40].func()
			else
				var3_45.green = true

				setText(var1_45, setColorStr(i18n("technology_queue_complete"), var2_45[1]))
				setText(var0_45, "00:00:00")
			end

			eachChild(arg1_40:Find("frame/marks/line"), function(arg0_47)
				setActive(arg0_47, var3_45[arg0_47.name])
			end)
			setActive(arg1_40:Find("frame/mask"), var4_40 > 0 and var3_40 < var4_40 - var2_40)
		end,
		desc = function()
			arg0_40.descTxt.text = var0_40:getConfig("desc")
			arg0_40.descBG.sprite = GetSpriteFromAtlas("ui/TechnologyUI_atlas", var0_40:getConfig("rarity"))

			local var0_48 = var0_40:getConfig("consume")
			local var1_48 = UIItemList.New(arg0_40.itemContainer, arg0_40.itemTpl)

			var1_48:make(function(arg0_49, arg1_49, arg2_49)
				arg1_49 = arg1_49 + 1

				if arg0_49 == UIItemList.EventUpdate then
					arg0_40:updateItem(arg2_49, var0_40, var0_48[arg1_49])
					setActive(arg2_49:Find("check"), var0_40:isActivate())
					setActive(arg2_49:Find("icon_bg/count"), not var0_40:isActivate())
				end
			end)
			var1_48:align(#var0_48)
			setActive(arg0_40.emptyTF, not var0_48 or #var0_48 <= 0)

			local var2_48 = var0_40:getConfig("condition")

			if var2_48 > 0 then
				local var3_48 = getProxy(TaskProxy):getTaskById(var2_48) or Task.New({
					id = var2_48
				})

				arg0_40.taskSlider.value = var3_48.progress / var3_48:getConfig("target_num")
				arg0_40.taskDesc.text = var3_48:getConfig("desc") .. "(" .. var3_48.progress .. "/" .. var3_48:getConfig("target_num") .. ")"
			else
				arg0_40.taskDesc.text = i18n("technology_task_none_tip")
				arg0_40.taskSlider.value = 0
			end

			if arg0_40.extraTimer then
				arg0_40.extraTimer:Stop()

				arg0_40.extraTimer = nil
			end

			local var4_48 = {}

			if var4_40 <= 0 then
				var4_48.start_btn = true
				arg0_40.timerTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var2_40)
			elseif var3_40 < var4_40 - var2_40 then
				var4_48.stop_btn = true
				var4_48.join_btn = var0_40:finishCondition()
				var4_48.lock_join_btn = not var4_48.join_btn
				arg0_40.timerTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var2_40)
			elseif var3_40 < var4_40 then
				var4_48.stop_btn = true
				var4_48.join_btn = var0_40:finishCondition()
				var4_48.lock_join_btn = not var4_48.join_btn
				arg0_40.extraTimer = Timer.New(function()
					local var0_50 = pg.TimeMgr.GetInstance():GetServerTime()

					if var0_50 < var4_40 then
						arg0_40.timerTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var4_40 - var0_50)
					end
				end, 1, -1)

				arg0_40.extraTimer:Start()
				arg0_40.extraTimer.func()
			else
				if var0_40:isCompleted() then
					var4_48.finish_btn = true
				else
					var4_48.stop_btn = true
					var4_48.lock_join_btn = true
				end

				arg0_40.timerTxt.text = "00:00:00"
			end

			eachChild(arg1_40:Find("frame/btns"), function(arg0_51)
				setActive(arg0_51, var4_48[arg0_51.name])
			end)

			local var5_48 = arg1_40:Find("frame/btns/start_btn")

			onButton(arg0_40, var5_48, function()
				if getProxy(TechnologyProxy):getActivateTechnology() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("technology_is_actived"))

					return
				end

				local var0_52 = var0_40:getConfig("consume")

				if #var0_52 > 0 then
					local var1_52 = getDropInfo(var0_52)

					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("technology_task_build_tip", var1_52),
						onYes = function()
							arg0_40:emit(TechnologyMediator.ON_START, {
								id = var0_40.id,
								pool_id = var0_40.poolId
							})
						end
					})
				else
					arg0_40:emit(TechnologyMediator.ON_START, {
						id = var0_40.id,
						pool_id = var0_40.poolId
					})
				end
			end, SFX_PANEL)
			setButtonEnabled(var5_48, var0_40:hasResToStart())

			local var6_48 = arg1_40:Find("frame/btns/stop_btn")

			onButton(arg0_40, var6_48, function()
				if not var0_40:isActivate() then
					return
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("technology_stop_tip"),
					onYes = function()
						arg0_40:emit(TechnologyMediator.ON_STOP, {
							id = var0_40.id,
							pool_id = var0_40.poolId
						})
					end
				})
			end, SFX_PANEL)

			local var7_48 = arg1_40:Find("frame/btns/join_btn")

			onButton(arg0_40, var7_48, function()
				if #arg0_40.technologyQueue == TechnologyConst.QUEUE_TOTAL_COUNT then
					pg.TipsMgr.GetInstance():ShowTips(i18n("technology_queue_full"))

					return
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("technology_queue_in_doublecheck"),
					onYes = function()
						arg0_40:emit(TechnologyMediator.ON_JOIN_QUEUE, {
							id = var0_40.id,
							pool_id = var0_40.poolId
						})
					end
				})
			end, SFX_PANEL)

			local var8_48 = arg1_40:Find("frame/btns/lock_join_btn")

			onButton(arg0_40, var8_48, function()
				pg.TipsMgr.GetInstance():ShowTips(i18n("technology_queue_in_mission_incomplete"))
			end, SFX_PANEL)

			local var9_48 = arg1_40:Find("frame/btns/finish_btn")

			onButton(arg0_40, var9_48, function()
				arg0_40:emit(TechnologyMediator.ON_FINISHED, {
					id = var0_40.id,
					pool_id = var0_40.poolId
				})
			end, SFX_PANEL)
		end
	})
end

function var0_0.dfs(arg0_60, arg1_60, arg2_60)
	if arg1_60.name ~= "item_tpl" then
		for iter0_60 = 1, arg1_60.childCount do
			arg0_60:dfs(arg1_60:GetChild(iter0_60 - 1), arg2_60)
		end
	else
		arg2_60(arg1_60)
	end
end

local var1_0 = {
	tag_red = "F15F34FF",
	tag_blue = "2541E3FF"
}

function var0_0.updateInfo(arg0_61, arg1_61, arg2_61, arg3_61)
	setImageSprite(arg1_61:Find("frame"), GetSpriteFromAtlas("technologycard", arg2_61:getConfig("bg") .. (arg3_61 == "desc" and "_l" or "")))
	setImageSprite(arg1_61:Find("frame/icon_mask/icon"), GetSpriteFromAtlas("technologyshipicon/" .. arg2_61:getConfig("bg_icon"), arg2_61:getConfig("bg_icon")), true)
	setImageSprite(arg1_61:Find("frame/top/label"), GetSpriteFromAtlas("technologycard", arg2_61:getConfig("label")))
	setImageSprite(arg1_61:Find("frame/top/label/text"), GetSpriteFromAtlas("technologycard", arg2_61:getConfig("label_color")), true)
	setImageSprite(arg1_61:Find("frame/top/label/version"), GetSpriteFromAtlas("technologycard", "version_" .. arg2_61:getConfig("blueprint_version")), true)
	setImageColor(arg1_61:Find("frame/top/pick_up"), Color.NewHex(var1_0[arg2_61:getConfig("label")]))
	setText(arg1_61:Find("frame/name_bg/Text"), arg2_61:getConfig("name"))
	setText(arg1_61:Find("frame/sub_name"), arg2_61:getConfig("sub_name") or "")

	local var0_61 = arg2_61:getConfig("drop_client")
	local var1_61 = arg1_61:Find("frame/item_container")
	local var2_61 = 0

	arg0_61:dfs(var1_61, function(arg0_62)
		var2_61 = var2_61 + 1

		setActive(arg0_62, var2_61 <= #var0_61)

		if var2_61 <= #var0_61 then
			arg0_61:updateItem(arg0_62, arg2_61, var0_61[var2_61])
		end
	end)
	switch(arg3_61, {
		desc = function()
			return
		end
	}, function()
		setActive(var1_61:GetChild(1), #var0_61 > 2)

		var1_61:GetChild(0):GetComponent("HorizontalLayoutGroup").padding.right = #var0_61 == 4 and 25 or 0
		var1_61:GetChild(1):GetComponent("HorizontalLayoutGroup").padding.left = #var0_61 == 4 and 25 or 0
	end)
end

function var0_0.updateInfoVersionPickUp(arg0_65, arg1_65, arg2_65)
	local var0_65 = getProxy(TechnologyProxy):getTendency(2)

	setActive(arg1_65:Find("frame/top/pick_up"), var0_65 == arg2_65:getConfig("blueprint_version"))
end

function var0_0.updateItem(arg0_66, arg1_66, arg2_66, arg3_66)
	local var0_66 = Drop.Create(arg3_66)

	updateDrop(arg1_66, setmetatable({
		count = 0
	}, {
		__index = var0_66
	}))

	local var1_66 = arg0_66:findTF("icon_bg/count", arg1_66)

	if not IsNil(var1_66) then
		setColorCount(var1_66, var0_66:getOwnedCount(), var0_66.count)
	end

	onButton(arg0_66, arg1_66, function()
		local var0_67 = var0_66:getConfig("display_icon") or {}

		if #var0_67 > 0 then
			local var1_67 = {
				type = MSGBOX_TYPE_ITEM_BOX,
				items = _.map(var0_67, function(arg0_68)
					return {
						type = arg0_68[1],
						id = arg0_68[2]
					}
				end),
				content = var0_66:getConfig("display")
			}

			function var1_67.itemFunc(arg0_69)
				arg0_66:emit(var0_0.ON_DROP, arg0_69, function()
					pg.MsgboxMgr.GetInstance():ShowMsgBox(var1_67)
				end)
			end

			pg.MsgboxMgr.GetInstance():ShowMsgBox(var1_67)
		else
			arg0_66:emit(var0_0.ON_DROP, var0_66)
		end
	end, SFX_PANEL)
end

function var0_0.updatePickUpVersionChange(arg0_71)
	arg0_71:updateSettingBtnVersion()

	for iter0_71, iter1_71 in ipairs(arg0_71.technologyCards) do
		arg0_71:updateInfoVersionPickUp(iter1_71, arg0_71.technologyVOs[iter0_71])
	end

	for iter2_71, iter3_71 in ipairs(arg0_71.technologyQueue) do
		arg0_71:updateInfoVersionPickUp(arg0_71.queueCardItemList.container:GetChild(iter2_71 - 1), iter3_71)
	end
end

function var0_0.clearTimer(arg0_72, ...)
	if arg0_72.timer then
		arg0_72.timer:Stop()

		arg0_72.timer = nil
	end

	if arg0_72.extraTimer then
		arg0_72.extraTimer:Stop()

		arg0_72.extraTimer = nil
	end

	if arg0_72.enhancelTimer then
		arg0_72.enhancelTimer:Stop()

		arg0_72.enhancelTimer = nil
	end

	for iter0_72, iter1_72 in pairs(arg0_72.cardtimer) do
		iter1_72:Stop()
	end

	arg0_72.cardtimer = {}

	for iter2_72, iter3_72 in pairs(arg0_72.queueTimer) do
		iter3_72:Stop()
	end

	arg0_72.queueTimer = {}

	for iter4_72, iter5_72 in pairs(arg0_72.queueCardTimer) do
		iter5_72:Stop()
	end

	arg0_72.queueCardTimer = {}

	if arg0_72.actCatchupTimer then
		arg0_72.actCatchupTimer:Stop()

		arg0_72.actCatchupTimer = nil
	end
end

function var0_0.willExit(arg0_73)
	arg0_73:clearTimer()

	arg0_73.cardtimer = nil
	arg0_73.queueTimer = nil
	arg0_73.queueCardTimer = nil
end

return var0_0
