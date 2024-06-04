local var0 = class("TechnologyScene", import("..base.BaseUI"))

var0.PageBase = 1
var0.PageQueue = 2
var0.rarityColor = {
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

function var0.getUIName(arg0)
	return "TechnologyUI"
end

function var0.onBackPressed(arg0)
	if arg0.contextData.selectedIndex then
		arg0:cancelSelected()

		return
	end

	if arg0.contextData.page == var0.PageQueue then
		arg0:setPage(var0.PageBase)

		return
	end

	var0.super.onBackPressed(arg0)
end

function var0.ResUISettings(arg0)
	return true
end

function var0.setTechnologys(arg0, arg1, arg2)
	arg0.technologyVOs = arg1
	arg0.technologyQueue = arg2
end

function var0.setRefreshFlag(arg0, arg1)
	arg0.flag = arg1
end

function var0.setPlayer(arg0, arg1)
	arg0.player = arg1
end

function var0.init(arg0)
	arg0.backBtn = arg0._tf:Find("blur_panel/adapt/top/back")
	arg0.basePage = arg0._tf:Find("main/base_page")
	arg0.srcollView = arg0.basePage:Find("srcoll_rect/content")
	arg0.srcollViewCG = arg0.srcollView:GetComponent(typeof(CanvasGroup))
	arg0.helpBtn = arg0.basePage:Find("help_btn")
	arg0.refreshBtn = arg0.basePage:Find("refresh_btn")

	setText(arg0.refreshBtn:Find("Text"), i18n("technology_daily_refresh"))

	arg0.settingsBtn = arg0.basePage:Find("settings_btn")
	arg0.selectetPanel = arg0.basePage:Find("selecte_panel")

	setActive(arg0.selectetPanel, false)
	setText(arg0.selectetPanel:Find("consume_panel/bg/label/Text"), i18n("technology_consume"))
	setText(arg0.selectetPanel:Find("consume_panel/bg/task_panel/label/Text"), i18n("technology_request"))

	arg0.arrLeftBtn = arg0.selectetPanel:Find("left_arr_btn")
	arg0.arrRightBtn = arg0.selectetPanel:Find("right_arr_btn")
	arg0.technologyTpl = arg0.selectetPanel:Find("technology_card")
	arg0.descTxt = arg0.selectetPanel:Find("desc/bg/Text"):GetComponent(typeof(Text))
	arg0.timerTxt = arg0.selectetPanel:Find("timer/bg/Text"):GetComponent(typeof(Text))
	arg0.itemContainer = arg0.selectetPanel:Find("consume_panel/bg/container")
	arg0.itemTpl = arg0:findTF("item_tpl", arg0.itemContainer)
	arg0.emptyTF = arg0.selectetPanel:Find("consume_panel/bg/empty")
	arg0.taskPanel = arg0.selectetPanel:Find("consume_panel/bg/task_panel")
	arg0.taskSlider = arg0.taskPanel:Find("slider"):GetComponent(typeof(Slider))
	arg0.taskDesc = arg0.taskPanel:Find("slider/Text"):GetComponent(typeof(Text))
	arg0.descBG = arg0.selectetPanel:Find("desc/bg"):GetComponent(typeof(Image))
	arg0.queuePage = arg0._tf:Find("main/queue_page")
	arg0.queueView = arg0.queuePage:Find("queue_rect/content")

	local var0 = arg0._tf:Find("blur_panel/adapt/right")

	arg0.btnAwardQueue = var0:Find("btn_award")

	setText(arg0.btnAwardQueue:Find("Text"), i18n("technology_queue_getaward"))

	arg0.btnAwardQueueDisable = var0:Find("btn_award_disable")

	setText(arg0.btnAwardQueueDisable:Find("Text"), i18n("technology_queue_getaward"))

	arg0.btnQueue = arg0._tf:Find("blur_panel/adapt/left/btn_queue")
	arg0.cardtimer = {}
	arg0.queueTimer = {}
	arg0.queueCardTimer = {}
end

function var0.updateSettingsBtn(arg0)
	local var0 = arg0:findTF("RedPoint", arg0.settingsBtn)
	local var1 = arg0:findTF("TipText", arg0.settingsBtn)

	setText(var1, i18n("tec_settings_btn_word"))

	local var2 = arg0:findTF("TargetCatchup", arg0.settingsBtn)
	local var3 = arg0:findTF("Selected", var2)
	local var4 = arg0:findTF("ActCatchup", arg0.settingsBtn)

	arg0:updateSettingBtnVersion()

	local var5 = false
	local var6 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BLUEPRINT_CATCHUP)

	if var6 and not var6:isEnd() then
		local var7 = var6.data1
		local var8 = var6:getConfig("config_id")
		local var9 = pg.activity_event_blueprint_catchup[var8].char_choice
		local var10 = pg.activity_event_blueprint_catchup[var8].obtain_max

		if var7 < var10 then
			local var11 = arg0:findTF("Selected/CharImg", var4)

			setImageSprite(var11, LoadSprite("TecCatchup/QChar" .. var9, tostring(var9)))

			local var12 = arg0:findTF("Selected/ProgressText", var4)

			setText(var12, var7 .. "/" .. var10)

			local var13 = var6.stopTime - pg.TimeMgr.GetInstance():GetServerTime()

			if arg0.actCatchupTimer then
				arg0.actCatchupTimer:Stop()

				arg0.actCatchupTimer = nil
			end

			local var14 = arg0:findTF("TimeLeft/Day", var4)
			local var15 = arg0:findTF("TimeLeft/Hour", var4)
			local var16 = arg0:findTF("TimeLeft/Min", var4)
			local var17 = arg0:findTF("TimeLeft/NumText", var4)

			local function var18()
				local var0, var1, var2, var3 = pg.TimeMgr.GetInstance():parseTimeFrom(var13)

				var13 = var13 - 1

				if var0 >= 1 then
					setActive(var14, true)
					setActive(var15, false)
					setActive(var16, false)
					setText(var17, var0)
				elseif var0 <= 0 and var1 > 0 then
					setActive(var14, false)
					setActive(var15, true)
					setActive(var16, false)
					setText(var17, var1)
				elseif var0 <= 0 and var1 <= 0 and (var2 > 0 or var3 > 0) then
					setActive(var14, false)
					setActive(var15, false)
					setActive(var16, true)
					setText(var17, math.max(var2, 1))
				elseif var0 <= 0 and var1 <= 0 and var2 <= 0 and var3 <= 0 and arg0.actCatchupTimer then
					arg0.actCatchupTimer:Stop()

					arg0.actCatchupTimer = nil

					setActive(var4, false)
				end
			end

			arg0.actCatchupTimer = Timer.New(var18, 1, -1, 1)

			arg0.actCatchupTimer:Start()
			arg0.actCatchupTimer.func()

			var5 = true
		end
	end

	setActive(var4, var5)
	setActive(var2, true)

	local var19 = getProxy(TechnologyProxy)
	local var20 = var19:isOpenTargetCatchup()
	local var21 = var19:isOnCatchup()

	if var20 then
		if not var21 then
			setActive(var3, false)
			setActive(var0, true)
		else
			local var22 = var19:getCurCatchupTecInfo()
			local var23 = var22.tecID
			local var24 = var22.groupID
			local var25 = var22.printNum
			local var26 = var19:getCatchupData(var23):isUr(var24) and pg.technology_catchup_template[var23].obtain_max_per_ur or pg.technology_catchup_template[var23].obtain_max

			if var26 <= var25 then
				setActive(var3, false)
				setActive(var0, false)
			else
				setActive(var3, true)
				setActive(var0, false)

				local var27 = arg0:findTF("CharImg", var3)

				setImageSprite(var27, LoadSprite("TecCatchup/QChar" .. var24, tostring(var24)))

				local var28 = arg0:findTF("ProgressText", var3)

				setText(var28, var25 .. "/" .. var26)
			end
		end
	else
		setActive(var3, false)
		setActive(var0, false)
	end
end

function var0.updateSettingBtnVersion(arg0)
	local var0 = getProxy(TechnologyProxy):getTendency(2)
	local var1 = arg0.settingsBtn:Find("tag")

	setActive(var1, var0 > 0)

	if var0 > 0 then
		GetImageSpriteFromAtlasAsync("technologycard", "version_" .. var0, var1:Find("Image"), true)
	end
end

function var0.setPage(arg0, arg1)
	arg0.contextData.page = arg1

	setActive(arg0.basePage, arg1 == var0.PageBase)
	setActive(arg0.queuePage, arg1 == var0.PageQueue)
	setActive(arg0._tf:Find("blur_panel/adapt/top/title"), arg1 == var0.PageBase)
	setActive(arg0._tf:Find("blur_panel/adapt/left"), arg1 == var0.PageBase)
	setActive(arg0._tf:Find("blur_panel/adapt/top/title_queue"), arg1 == var0.PageQueue)
	setActive(arg0._tf:Find("blur_panel/adapt/right"), arg1 == var0.PageQueue)

	if arg1 == var0.PageBase then
		for iter0, iter1 in ipairs(arg0.technologyVOs) do
			if iter1:isActivate() then
				if arg0.enhancelTimer then
					arg0.enhancelTimer:Stop()
				end

				arg0.enhancelTimer = Timer.New(function()
					arg0.srcollView:GetComponent("EnhancelScrollView"):SetHorizontalTargetItemIndex(arg0.technologyCards[iter0]:GetComponent("EnhanceItem").scrollViewItemIndex)

					arg0.enhancelTimer = nil
				end, 0.35, 1)

				arg0.enhancelTimer:Start()

				break
			end
		end
	end
end

function var0.didEnter(arg0)
	arg0:initTechnologys()
	arg0:initQueue()
	arg0:setPage(arg0.contextData.page or var0.PageBase)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.technology_help_text.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.refreshBtn, function()
		if tobool(getProxy(TechnologyProxy):getActivateTechnology()) then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("technology_canot_refresh")
			})

			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("technology_refresh_tip"),
			onYes = function()
				arg0:emit(TechnologyMediator.ON_REFRESH)
			end
		})
	end, SFX_PANEL)

	local var0 = getProxy(TechnologyProxy):getConfigMaxVersion()

	onButton(arg0, arg0.settingsBtn, function()
		arg0:emit(TechnologyMediator.ON_CLICK_SETTINGS_BTN)
	end, SFX_PANEL)
	onButton(arg0, arg0.backBtn, function()
		arg0:onBackPressed()
	end, SOUND_BACK)
	onButton(arg0, arg0.selectetPanel, function()
		arg0:cancelSelected()
	end, SFX_PANEL)
	arg0:updateRefreshBtn(arg0.flag)
	arg0:updateSettingsBtn()
end

function var0.initTechnologys(arg0)
	arg0.technologyCards = {}
	arg0.lastButtonListener = arg0.lastButtonListener or {}

	if not arg0.itemList then
		arg0.itemList = UIItemList.New(arg0.srcollView, arg0.srcollView:GetChild(0))

		arg0.itemList:make(function(arg0, arg1, arg2)
			arg1 = arg1 + 1

			if arg0 == UIItemList.EventUpdate then
				arg2.name = arg1
				arg0.technologyCards[arg1] = arg2

				arg0:updateTechnologyTF(arg2, arg1, "base")

				local var0 = GetOrAddComponent(arg2, typeof(Button)).onClick

				if arg0.lastButtonListener[arg2] then
					var0:RemoveListener(arg0.lastButtonListener[arg2])
				end

				arg0.lastButtonListener[arg2] = function()
					pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)

					if arg0.technologyVOs[arg1]:isCompleted() then
						arg0:emit(TechnologyMediator.ON_FINISHED, {
							id = arg0.technologyVOs[arg1].id,
							pool_id = arg0.technologyVOs[arg1].poolId
						})
					else
						arg0:onSelected(arg2, arg1)
					end
				end

				var0:AddListener(arg0.lastButtonListener[arg2])
			end
		end)
	end

	arg0.itemList:align(#arg0.technologyVOs)
	setActive(arg0.srcollView, true)
end

function var0.initQueue(arg0)
	if not arg0.queueItemList then
		arg0.queueItemList = UIItemList.New(arg0.btnQueue, arg0.btnQueue:GetChild(0))

		arg0.queueItemList:make(function(arg0, arg1, arg2)
			arg1 = arg1 + 1

			if arg0 == UIItemList.EventUpdate then
				arg2.name = arg1

				if arg0.queueTimer[arg1] then
					arg0.queueTimer[arg1]:Stop()

					arg0.queueTimer[arg1] = nil
				end

				local var0 = {}
				local var1 = arg0.technologyQueue[arg1]

				if not var1 then
					var0.empty = true
				else
					local var2 = pg.TimeMgr.GetInstance():GetServerTime()
					local var3 = var1.time
					local var4 = var1:getConfig("time")

					if var2 < var3 - var4 then
						var0.waiting = true
					elseif var2 < var3 then
						var0.doing = true
						arg0.queueTimer[arg1] = Timer.New(function()
							local var0 = pg.TimeMgr.GetInstance():GetServerTime()

							if var0 < var3 then
								setSlider(arg2:Find("doing"), 0, var4, var4 - var3 + var0)
							else
								arg0:updateQueueChange()
							end
						end, 1, -1)

						arg0.queueTimer[arg1]:Start()
						arg0.queueTimer[arg1].func()
					else
						var0.complete = true
					end
				end

				eachChild(arg2, function(arg0)
					setActive(arg0, var0[arg0.name])
				end)
			end
		end)
	end

	arg0.queueItemList:align(TechnologyConst.QUEUE_TOTAL_COUNT)
	onButton(arg0, arg0.btnQueue, function()
		arg0:setPage(var0.PageQueue)
	end, SFX_PANEL)

	if not arg0.queueCardItemList then
		arg0.queueCardItemList = UIItemList.New(arg0.queueView, arg0.queueView:GetChild(0))

		arg0.queueCardItemList:make(function(arg0, arg1, arg2)
			arg1 = arg1 + 1

			if arg0 == UIItemList.EventUpdate then
				arg2.name = arg1

				arg0:updateTechnologyTF(arg2, arg1, "queue")
			end
		end)
	end

	arg0.queueCardItemList:align(TechnologyConst.QUEUE_TOTAL_COUNT)
	onButton(arg0, arg0.btnAwardQueue, function()
		if arg0.technologyQueue[1] and arg0.technologyQueue[1]:isCompleted() then
			arg0:emit(TechnologyMediator.ON_FINISH_QUEUE)
		end
	end, SFX_CONFIRM)
	setActive(arg0.btnAwardQueue, arg0.technologyQueue[1] and arg0.technologyQueue[1]:isCompleted())
	setActive(arg0.btnAwardQueueDisable, not isActive(arg0.btnAwardQueue))
end

function var0.updateRefreshBtn(arg0, arg1)
	setButtonEnabled(arg0.refreshBtn, arg1 == 0)
end

function var0.onSelected(arg0, arg1, arg2)
	if not arg2 then
		return
	end

	if not arg0.technologyVOs[arg2] then
		return
	end

	arg0.contextData.selectedIndex = arg2

	arg0:updateTechnologyTF(arg0.technologyTpl, arg2, "desc")

	arg0.srcollViewCG.alpha = 0.3

	setActive(arg1, false)
	setActive(arg0.selectetPanel, true)

	local var0 = {}

	eachChild(arg0.srcollView, function(arg0)
		var0[tonumber(arg0.name)] = arg0
	end)

	local function var1(arg0, arg1)
		local var0 = {}
		local var1 = arg0
		local var2 = var0[arg0].localPosition.x

		for iter0, iter1 in ipairs(var0) do
			var0[iter0] = var0[iter0].localPosition.x - var2
		end

		for iter2, iter3 in ipairs(var0) do
			if iter3 ~= 0 and (var0[var1] == 0 or arg1 and (iter3 > 0 and var0[var1] > 0 and iter3 > var0[var1] or iter3 < 0 and (var0[var1] > 0 or iter3 > var0[var1])) or not arg1 and (iter3 < 0 and var0[var1] < 0 and iter3 < var0[var1] or iter3 > 0 and (var0[var1] < 0 or iter3 < var0[var1]))) then
				var1 = iter2
			end
		end

		return var0[var1]
	end

	onButton(arg0, arg0.arrLeftBtn, function()
		if arg0.inAnim then
			return
		end

		arg0:cancelSelected()
		triggerButton(var1(arg2, true))
	end, SFX_PANEL)
	onButton(arg0, arg0.arrRightBtn, function()
		if arg0.inAnim then
			return
		end

		arg0:cancelSelected()
		triggerButton(var1(arg2, false))
	end, SFX_PANEL)
end

function var0.cancelSelected(arg0)
	if not arg0.technologyVOs[arg0.contextData.selectedIndex or 0] then
		return
	end

	local var0 = arg0.technologyCards[arg0.contextData.selectedIndex]

	arg0.contextData.selectedIndex = nil

	setActive(var0, true)
	removeOnButton(arg0.arrLeftBtn)
	removeOnButton(arg0.arrRightBtn)
	setActive(arg0.selectetPanel, false)

	arg0.srcollViewCG.alpha = 1
	arg0.inAnim = true

	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end

	arg0.timer = Timer.New(function()
		arg0.inAnim = nil
	end, 0.2, 1)

	arg0.timer:Start()

	if arg0.extraTimer then
		arg0.extraTimer:Stop()

		arg0.extraTimer = nil
	end
end

function var0.updateTechnology(arg0, arg1)
	local var0

	for iter0, iter1 in ipairs(arg0.technologyVOs) do
		if iter1.id == arg1.id then
			arg0.technologyVOs[iter0] = arg1
			var0 = iter0

			break
		end
	end

	local var1 = arg0.technologyCards[var0]

	arg0:updateTechnologyTF(var1, var0, "base")

	if arg0.contextData.selectedIndex and arg0.technologyVOs[arg0.contextData.selectedIndex].id == arg1.id then
		arg0:updateTechnologyTF(arg0.technologyTpl, var0, "desc")
	end
end

function var0.updateQueueChange(arg0)
	arg0.queueItemList:align(#arg0.technologyQueue)
	arg0.queueCardItemList:align(TechnologyConst.QUEUE_TOTAL_COUNT)
	setActive(arg0.btnAwardQueue, arg0.technologyQueue[1] and arg0.technologyQueue[1]:isCompleted())
	setActive(arg0.btnAwardQueueDisable, not isActive(arg0.btnAwardQueue))

	local var0 = getProxy(TechnologyProxy):getActivateTechnology()

	if var0 then
		arg0:updateTechnology(var0)
	end
end

function var0.updateTechnologyTF(arg0, arg1, arg2, arg3)
	local var0

	if arg3 == "queue" then
		var0 = arg0.technologyQueue[arg2]

		local var1 = not tobool(var0)

		setActive(arg1:Find("frame"), not var1)
		setActive(arg1:Find("empty"), var1)

		if var1 then
			return
		end
	else
		var0 = arg0.technologyVOs[arg2]
	end

	arg0:updateInfo(arg1, var0, arg3)
	arg0:updateInfoVersionPickUp(arg1, var0)

	local var2 = var0:getConfig("time")
	local var3 = pg.TimeMgr.GetInstance():GetServerTime()
	local var4 = var0.time

	switch(arg3, {
		base = function()
			if arg0.cardtimer[arg2] then
				arg0.cardtimer[arg2]:Stop()

				arg0.cardtimer[arg2] = nil
			end

			local var0 = arg1:Find("frame/marks/time")
			local var1 = arg1:Find("frame/marks/Text")
			local var2 = var0.rarityColor[var0:getConfig("bg")]

			GetComponent(var0, "Shadow").effectColor = Color.New(unpack(var2[2]))

			local var3 = {}

			if var4 <= 0 then
				var3.blue = true

				setText(var1, setColorStr(i18n("technology_detail"), var2[1]))
				setText(var0, pg.TimeMgr.GetInstance():DescCDTime(var0:getConfig("time")))
			elseif var3 < var4 - var2 then
				var3.blue = true

				setText(var1, setColorStr(i18n("technology_queue_waiting"), var2[1]))
				setText(var0, pg.TimeMgr.GetInstance():DescCDTime(var0:getConfig("time")))

				arg0.cardtimer[arg2] = Timer.New(function()
					arg0:updateTechnology(var0)
				end, var4 - var2 - var3)

				arg0.cardtimer[arg2]:Start()
			elseif var3 < var4 then
				var3.blue = true

				setText(var1, setColorStr(i18n("technology_queue_processing"), var2[1]))

				arg0.cardtimer[arg2] = Timer.New(function()
					local var0 = var0.time
					local var1 = pg.TimeMgr.GetInstance():GetServerTime()

					if var1 < var0 then
						setText(var0, pg.TimeMgr.GetInstance():DescCDTime(var0 - var1))
					else
						arg0:updateTechnology(var0)
					end
				end, 1, -1)

				arg0.cardtimer[arg2]:Start()
				arg0.cardtimer[arg2].func()
			else
				var3.green = true

				if var0:isCompleted() then
					setText(var1, setColorStr(i18n("technology_queue_complete"), var2[1]))
				else
					setText(var1, setColorStr(i18n("technology_mission_unfinish"), var2[1]))
				end

				setText(var0, "00:00:00")
			end

			eachChild(arg1:Find("frame/marks/line"), function(arg0)
				setActive(arg0, var3[arg0.name])
			end)
		end,
		queue = function()
			if arg0.queueCardTimer[arg2] then
				arg0.queueCardTimer[arg2]:Stop()

				arg0.queueCardTimer[arg2] = nil
			end

			local var0 = arg1:Find("frame/marks/time")
			local var1 = arg1:Find("frame/marks/Text")
			local var2 = var0.rarityColor[var0:getConfig("bg")]

			GetComponent(var0, "Shadow").effectColor = Color.New(unpack(var2[2]))

			local var3 = {}

			if var4 <= 0 then
				assert(false, "error queue")
			elseif var3 < var4 - var2 then
				var3.blue = true

				setText(var1, setColorStr(i18n("technology_queue_waiting"), var2[1]))
				setText(var0, pg.TimeMgr.GetInstance():DescCDTime(var0:getConfig("time")))
			elseif var3 < var4 then
				var3.blue = true

				setText(var1, setColorStr(i18n("technology_queue_processing"), var2[1]))

				arg0.queueCardTimer[arg2] = Timer.New(function()
					local var0 = var0.time
					local var1 = pg.TimeMgr.GetInstance():GetServerTime()

					if var1 < var0 then
						setText(var0, pg.TimeMgr.GetInstance():DescCDTime(var0 - var1))
					end
				end, 1, -1)

				arg0.queueCardTimer[arg2]:Start()
				arg0.queueCardTimer[arg2].func()
			else
				var3.green = true

				setText(var1, setColorStr(i18n("technology_queue_complete"), var2[1]))
				setText(var0, "00:00:00")
			end

			eachChild(arg1:Find("frame/marks/line"), function(arg0)
				setActive(arg0, var3[arg0.name])
			end)
			setActive(arg1:Find("frame/mask"), var4 > 0 and var3 < var4 - var2)
		end,
		desc = function()
			arg0.descTxt.text = var0:getConfig("desc")
			arg0.descBG.sprite = GetSpriteFromAtlas("ui/TechnologyUI_atlas", var0:getConfig("rarity"))

			local var0 = var0:getConfig("consume")
			local var1 = UIItemList.New(arg0.itemContainer, arg0.itemTpl)

			var1:make(function(arg0, arg1, arg2)
				arg1 = arg1 + 1

				if arg0 == UIItemList.EventUpdate then
					arg0:updateItem(arg2, var0, var0[arg1])
					setActive(arg2:Find("check"), var0:isActivate())
					setActive(arg2:Find("icon_bg/count"), not var0:isActivate())
				end
			end)
			var1:align(#var0)
			setActive(arg0.emptyTF, not var0 or #var0 <= 0)

			local var2 = var0:getConfig("condition")

			if var2 > 0 then
				local var3 = getProxy(TaskProxy):getTaskById(var2) or Task.New({
					id = var2
				})

				arg0.taskSlider.value = var3.progress / var3:getConfig("target_num")
				arg0.taskDesc.text = var3:getConfig("desc") .. "(" .. var3.progress .. "/" .. var3:getConfig("target_num") .. ")"
			else
				arg0.taskDesc.text = i18n("technology_task_none_tip")
				arg0.taskSlider.value = 0
			end

			if arg0.extraTimer then
				arg0.extraTimer:Stop()

				arg0.extraTimer = nil
			end

			local var4 = {}

			if var4 <= 0 then
				var4.start_btn = true
				arg0.timerTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var2)
			elseif var3 < var4 - var2 then
				var4.stop_btn = true
				var4.join_btn = var0:finishCondition()
				var4.lock_join_btn = not var4.join_btn
				arg0.timerTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var2)
			elseif var3 < var4 then
				var4.stop_btn = true
				var4.join_btn = var0:finishCondition()
				var4.lock_join_btn = not var4.join_btn
				arg0.extraTimer = Timer.New(function()
					local var0 = pg.TimeMgr.GetInstance():GetServerTime()

					if var0 < var4 then
						arg0.timerTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var4 - var0)
					end
				end, 1, -1)

				arg0.extraTimer:Start()
				arg0.extraTimer.func()
			else
				if var0:isCompleted() then
					var4.finish_btn = true
				else
					var4.stop_btn = true
					var4.lock_join_btn = true
				end

				arg0.timerTxt.text = "00:00:00"
			end

			eachChild(arg1:Find("frame/btns"), function(arg0)
				setActive(arg0, var4[arg0.name])
			end)

			local var5 = arg1:Find("frame/btns/start_btn")

			onButton(arg0, var5, function()
				if getProxy(TechnologyProxy):getActivateTechnology() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("technology_is_actived"))

					return
				end

				local var0 = var0:getConfig("consume")

				if #var0 > 0 then
					local var1 = getDropInfo(var0)

					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("technology_task_build_tip", var1),
						onYes = function()
							arg0:emit(TechnologyMediator.ON_START, {
								id = var0.id,
								pool_id = var0.poolId
							})
						end
					})
				else
					arg0:emit(TechnologyMediator.ON_START, {
						id = var0.id,
						pool_id = var0.poolId
					})
				end
			end, SFX_PANEL)
			setButtonEnabled(var5, var0:hasResToStart())

			local var6 = arg1:Find("frame/btns/stop_btn")

			onButton(arg0, var6, function()
				if not var0:isActivate() then
					return
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("technology_stop_tip"),
					onYes = function()
						arg0:emit(TechnologyMediator.ON_STOP, {
							id = var0.id,
							pool_id = var0.poolId
						})
					end
				})
			end, SFX_PANEL)

			local var7 = arg1:Find("frame/btns/join_btn")

			onButton(arg0, var7, function()
				if #arg0.technologyQueue == TechnologyConst.QUEUE_TOTAL_COUNT then
					pg.TipsMgr.GetInstance():ShowTips(i18n("technology_queue_full"))

					return
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("technology_queue_in_doublecheck"),
					onYes = function()
						arg0:emit(TechnologyMediator.ON_JOIN_QUEUE, {
							id = var0.id,
							pool_id = var0.poolId
						})
					end
				})
			end, SFX_PANEL)

			local var8 = arg1:Find("frame/btns/lock_join_btn")

			onButton(arg0, var8, function()
				pg.TipsMgr.GetInstance():ShowTips(i18n("technology_queue_in_mission_incomplete"))
			end, SFX_PANEL)

			local var9 = arg1:Find("frame/btns/finish_btn")

			onButton(arg0, var9, function()
				arg0:emit(TechnologyMediator.ON_FINISHED, {
					id = var0.id,
					pool_id = var0.poolId
				})
			end, SFX_PANEL)
		end
	})
end

function var0.dfs(arg0, arg1, arg2)
	if arg1.name ~= "item_tpl" then
		for iter0 = 1, arg1.childCount do
			arg0:dfs(arg1:GetChild(iter0 - 1), arg2)
		end
	else
		arg2(arg1)
	end
end

local var1 = {
	tag_red = "F15F34FF",
	tag_blue = "2541E3FF"
}

function var0.updateInfo(arg0, arg1, arg2, arg3)
	setImageSprite(arg1:Find("frame"), GetSpriteFromAtlas("technologycard", arg2:getConfig("bg") .. (arg3 == "desc" and "_l" or "")))
	setImageSprite(arg1:Find("frame/icon_mask/icon"), GetSpriteFromAtlas("technologyshipicon/" .. arg2:getConfig("bg_icon"), arg2:getConfig("bg_icon")), true)
	setImageSprite(arg1:Find("frame/top/label"), GetSpriteFromAtlas("technologycard", arg2:getConfig("label")))
	setImageSprite(arg1:Find("frame/top/label/text"), GetSpriteFromAtlas("technologycard", arg2:getConfig("label_color")), true)
	setImageSprite(arg1:Find("frame/top/label/version"), GetSpriteFromAtlas("technologycard", "version_" .. arg2:getConfig("blueprint_version")), true)
	setImageColor(arg1:Find("frame/top/pick_up"), Color.NewHex(var1[arg2:getConfig("label")]))
	setText(arg1:Find("frame/name_bg/Text"), arg2:getConfig("name"))
	setText(arg1:Find("frame/sub_name"), arg2:getConfig("sub_name") or "")

	local var0 = arg2:getConfig("drop_client")
	local var1 = arg1:Find("frame/item_container")
	local var2 = 0

	arg0:dfs(var1, function(arg0)
		var2 = var2 + 1

		setActive(arg0, var2 <= #var0)

		if var2 <= #var0 then
			arg0:updateItem(arg0, arg2, var0[var2])
		end
	end)
	switch(arg3, {
		desc = function()
			return
		end
	}, function()
		setActive(var1:GetChild(1), #var0 > 2)

		var1:GetChild(0):GetComponent("HorizontalLayoutGroup").padding.right = #var0 == 4 and 25 or 0
		var1:GetChild(1):GetComponent("HorizontalLayoutGroup").padding.left = #var0 == 4 and 25 or 0
	end)
end

function var0.updateInfoVersionPickUp(arg0, arg1, arg2)
	local var0 = getProxy(TechnologyProxy):getTendency(2)

	setActive(arg1:Find("frame/top/pick_up"), var0 == arg2:getConfig("blueprint_version"))
end

function var0.updateItem(arg0, arg1, arg2, arg3)
	local var0 = Drop.Create(arg3)

	updateDrop(arg1, setmetatable({
		count = 0
	}, {
		__index = var0
	}))

	local var1 = arg0:findTF("icon_bg/count", arg1)

	if not IsNil(var1) then
		setColorCount(var1, var0:getOwnedCount(), var0.count)
	end

	onButton(arg0, arg1, function()
		local var0 = var0:getConfig("display_icon") or {}

		if #var0 > 0 then
			local var1 = {
				type = MSGBOX_TYPE_ITEM_BOX,
				items = _.map(var0, function(arg0)
					return {
						type = arg0[1],
						id = arg0[2]
					}
				end),
				content = var0:getConfig("display")
			}

			function var1.itemFunc(arg0)
				arg0:emit(var0.ON_DROP, arg0, function()
					pg.MsgboxMgr.GetInstance():ShowMsgBox(var1)
				end)
			end

			pg.MsgboxMgr.GetInstance():ShowMsgBox(var1)
		else
			arg0:emit(var0.ON_DROP, var0)
		end
	end, SFX_PANEL)
end

function var0.updatePickUpVersionChange(arg0)
	arg0:updateSettingBtnVersion()

	for iter0, iter1 in ipairs(arg0.technologyCards) do
		arg0:updateInfoVersionPickUp(iter1, arg0.technologyVOs[iter0])
	end

	for iter2, iter3 in ipairs(arg0.technologyQueue) do
		arg0:updateInfoVersionPickUp(arg0.queueCardItemList.container:GetChild(iter2 - 1), iter3)
	end
end

function var0.clearTimer(arg0, ...)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end

	if arg0.extraTimer then
		arg0.extraTimer:Stop()

		arg0.extraTimer = nil
	end

	if arg0.enhancelTimer then
		arg0.enhancelTimer:Stop()

		arg0.enhancelTimer = nil
	end

	for iter0, iter1 in pairs(arg0.cardtimer) do
		iter1:Stop()
	end

	arg0.cardtimer = {}

	for iter2, iter3 in pairs(arg0.queueTimer) do
		iter3:Stop()
	end

	arg0.queueTimer = {}

	for iter4, iter5 in pairs(arg0.queueCardTimer) do
		iter5:Stop()
	end

	arg0.queueCardTimer = {}

	if arg0.actCatchupTimer then
		arg0.actCatchupTimer:Stop()

		arg0.actCatchupTimer = nil
	end
end

function var0.willExit(arg0)
	arg0:clearTimer()

	arg0.cardtimer = nil
	arg0.queueTimer = nil
	arg0.queueCardTimer = nil
end

return var0
