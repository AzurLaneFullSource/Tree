local var0 = class("Dorm3dBaseView", import("view.base.BaseSubView"))

function var0.SetApartment(arg0, arg1, arg2)
	arg0.apartment = arg1

	local var0 = "dorm3d_enter_count_" .. arg0.apartment.configId

	PlayerPrefs.SetInt(var0, PlayerPrefs.GetInt(var0, 0) + 1)
	arg0:UpdateFavorDisplay()
	arg0:UpdateContactState()
end

function var0.OnInit(arg0)
	arg0.uiContianer = arg0._tf:Find("UI")

	local var0 = arg0.uiContianer:Find("base")

	onButton(arg0, var0:Find("btn_back"), function()
		arg0:emit(BaseUI.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0, var0:Find("btn_back/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("roll_gametip")
		})
	end, SFX_PANEL)

	arg0.rtFavorLevel = var0:Find("top/favor_level")

	onButton(arg0, arg0.rtFavorLevel, function()
		arg0:emit(Dorm3dSceneMediator.OPEN_LEVEL_LAYER)
	end, SFX_PANEL)
	onButton(arg0, var0:Find("bottom/btn_furniture"), function()
		local var0, var1 = arg0.apartment:checkUnlockConfig(getDorm3dGameset("drom3d_furniture_unlock")[2])

		if not var0 then
			pg.TipsMgr.GetInstance():ShowTips(var1)

			return
		end

		arg0:emit(Dorm3dSceneMediator.OPEN_FURNITURE_SELECT)
	end, SFX_PANEL)
	onButton(arg0, var0:Find("left/btn_photograph"), function()
		arg0:emit(Dorm3dSceneMediator.OPEN_CAMERA_LAYER)
	end, SFX_PANEL)
	onButton(arg0, var0:Find("left/btn_collection"), function()
		local var0, var1 = arg0.apartment:checkUnlockConfig(getDorm3dGameset("drom3d_recall_unlock")[2])

		if not var0 then
			pg.TipsMgr.GetInstance():ShowTips(var1)

			return
		end

		arg0:emit(Dorm3dSceneMediator.OPEN_COLLECTION_LAYER)
	end, SFX_PANEL)

	local var1 = arg0.uiContianer:Find("touch")

	onButton(arg0, var1:Find("btn_back"), function()
		arg0:ExitTouchMode()
	end, SFX_CANCEL)
	onButton(arg0, var1:Find("btn_back/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("roll_gametip")
		})
	end, SFX_PANEL)

	arg0.rtFavorUp = arg0._tf:Find("Toast/favor_up")

	setActive(arg0.rtFavorUp, false)

	arg0.rtFavorUpDaily = arg0._tf:Find("Toast/favor_up_daily")

	setActive(arg0.rtFavorUpDaily, false)

	for iter0, iter1 in ipairs({
		arg0.rtFavorUp,
		arg0.rtFavorUpDaily
	}) do
		iter1:GetComponent("DftAniEvent"):SetEndEvent(function(arg0)
			setActive(iter1, false)
		end)
	end

	arg0.rtLevelUpWindow = arg0._tf:Find("LevelUpWindow")

	setActive(arg0.rtLevelUpWindow, false)
	onButton(arg0, arg0.rtLevelUpWindow:Find("bg"), function()
		setActive(arg0.rtLevelUpWindow, false)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0.rtLevelUpWindow, arg0._tf)
		existCall(arg0.levelUpCallback)
	end, SFX_PANEL)

	local var2 = arg0.uiContianer:Find("watch")

	onButton(arg0, var2:Find("btn_back"), function()
		arg0:emit(Dorm3dScene.EXIT_WATCH_MODE)
	end)
	onButton(arg0, var2:Find("btn_back/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("roll_gametip")
		})
	end, SFX_PANEL)

	local var3 = arg0.uiContianer:Find("watch/Role")

	onButton(arg0, var3:Find("Talk"), function()
		local var0 = arg0:GetFurnitureTalk(arg0:GetZoneName())

		if not var0 then
			pg.TipsMgr.GetInstance():ShowTips("without topic")

			return
		end

		arg0:DoTalk(var0, true, function()
			arg0:emit(Dorm3dSceneMediator.TRIGGER_FAVOR, arg0.apartment.configId, Apartment.TRIGGER_TALK)
		end)
	end, SFX_CONFIRM)
	setText(var3:Find("Talk/Text"), i18n("dorm3d_talk"))
	onButton(arg0, var3:Find("Touch"), function()
		local var0, var1 = arg0.apartment:checkUnlockConfig(getDorm3dGameset("drom3d_touch_dialogue")[2])

		if not var0 then
			pg.TipsMgr.GetInstance():ShowTips(var1)

			return
		end

		arg0:EnterTouchMode()
	end, SFX_CONFIRM)
	setText(var3:Find("Touch/Text"), i18n("dorm3d_touch"))
	onButton(arg0, var3:Find("Gift"), function()
		local var0, var1 = arg0.apartment:checkUnlockConfig(getDorm3dGameset("drom3d_gift_dialogue")[2])

		if not var0 then
			pg.TipsMgr.GetInstance():ShowTips(var1)

			return
		end

		arg0:emit(Dorm3dSceneMediator.OPEN_GIFT_LAYER)
	end, SFX_CONFIRM)
	setText(var3:Find("Gift/Text"), i18n("dorm3d_gift"))

	arg0.rtFloatPage = arg0._tf:Find("FloatPage")
	arg0.tplFloat = arg0.rtFloatPage:Find("tpl")

	setActive(arg0.tplFloat, false)

	arg0._joystick = arg0._tf:Find("Stick")

	setActive(arg0._joystick, true)

	arg0._stickCom = arg0._joystick:GetComponent(typeof(SlideController))

	arg0._stickCom:SetStickFunc(function(arg0)
		arg0:emit(Dorm3dScene.ON_STICK_MOVE, arg0)
	end)
	arg0:SetUI("base")

	arg0.cvLoader = ShipProfileCVLoader.New()
end

function var0.initNodeCanvas(arg0, arg1)
	arg0.rtMainAI = arg1

	local var0 = pg.NodeCanvasMgr.GetInstance()

	var0:SetOwner(arg0.rtMainAI)

	for iter0, iter1 in ipairs(arg0.contextData.blackboard or {
		inTalking = false,
		inWatchMode = false
	}) do
		arg0:SetBlackboardValue(iter0, iter1)
	end

	var0:RegisterFunc("ClickCharacter", function(arg0)
		if arg0.uiState ~= "base" then
			return
		end

		if not arg0:GetBlackboardValue("inWatchMode") then
			arg0:OutOfLazy(function()
				arg0:emit(Dorm3dScene.ENTER_WATCH_MODE)
			end)
		end
	end)
	var0:RegisterFunc("MoveFurniture", function(arg0)
		if arg0.uiState ~= "base" then
			return
		end

		arg0:OutOfLazy(function()
			arg0:SetBlackboardValue("inMoving", true)
			arg0:emit(Dorm3dScene.MOVE_PLAYER_TO_FURNITURE, arg0.name, function()
				arg0:SetBlackboardValue("inMoving", false)
			end)
		end)
	end)
	var0:RegisterFunc("ClickCharacterInWatch", function()
		arg0:OutOfLazy(function()
			arg0:emit(Dorm3dScene.WATCH_MODE_INTERACTIVE)
		end)
	end)
	var0:RegisterFunc("ClickContact", function(arg0)
		arg0:TriggerContact(arg0)
	end)
	var0:RegisterFunc("ShortWaitAction", function()
		arg0:DoShortWait()
	end)
	var0:RegisterFunc("LongWaitAction", function()
		arg0:DoLongWait()
	end)
end

function var0.BindEvent(arg0)
	arg0:bind(Dorm3dScene.ON_TOUCH_CHARACTER, function(arg0, arg1)
		if not arg0:GetBlackboardValue("inTouching") then
			return
		end

		arg0:DoTouch(arg1, 1)
	end)
	arg0:bind(Dorm3dScene.ON_ROLEWATCH_CAMERA_MAX, function(arg0, arg1)
		if not arg0:GetBlackboardValue("inTouching") then
			return
		end

		arg0:DoTouch(arg1, 0)
	end)
end

function var0.TreeStart(arg0)
	if arg0.contextData.resumeCallback then
		arg0.contextData.resumeCallback()

		arg0.contextData.resumeCallback = nil
	end

	SetCompomentEnabled(arg0.rtMainAI, "BehaviourTreeOwner", true)
	arg0:EnterCheck()
end

function var0.SetBlackboardValue(arg0, arg1, arg2)
	arg0.contextData.blackboard = arg0.contextData.blackboard or {}
	arg0.contextData.blackboard[arg1] = arg2

	pg.NodeCanvasMgr.GetInstance():SetBlackboradValue(arg1, arg2)
end

function var0.GetBlackboardValue(arg0, arg1)
	arg0.contextData.blackboard = arg0.contextData.blackboard or {}

	return arg0.contextData.blackboard[arg1]
end

function var0.SendNodeCanvasEvent(arg0, arg1, arg2)
	pg.NodeCanvasMgr.GetInstance():SendEvent(arg1, arg2)
end

function var0.EnableJoystick(arg0, arg1)
	setActive(arg0._joystick, arg1)
end

function var0.SetInFurniture(arg0, arg1)
	arg0:SetBlackboardValue("inFurniture", arg1)
end

function var0.SetLadyTransform(arg0, arg1)
	arg0:SetBlackboardValue("ladyTransform", arg1)
end

function var0.SetUI(arg0, arg1)
	if arg0.uiState == arg1 then
		return
	end

	arg0.uiState = arg1

	eachChild(arg0.uiContianer, function(arg0)
		setActive(arg0, arg0.name == arg1)
	end)
end

function var0.EnterTouchMode(arg0)
	if arg0:GetBlackboardValue("inTouching") then
		return
	end

	arg0.touchConfig, arg0.touchDic = arg0.apartment:getTouchConfig(arg0:GetZoneName())

	local var0 = {}

	table.insert(var0, function(arg0)
		arg0:SetBlackboardValue("inTouching", true)
		setCanvasGroupAlpha(arg0.uiContianer, 0)
		arg0:emit(Dorm3dScene.SHOW_BLOCK)
		arg0:SetUI("touch")
		arg0()
	end)
	table.insert(var0, function(arg0)
		arg0:emit(Dorm3dScene.ENTER_FREELOOK_MODE, arg0, arg0.touchConfig)
	end)
	seriesAsync(var0, function()
		arg0:EnableJoystick(true)
		setCanvasGroupAlpha(arg0.uiContianer, 1)
		arg0:emit(Dorm3dScene.HIDE_BLOCK)
	end)
end

function var0.ExitTouchMode(arg0)
	if not arg0:GetBlackboardValue("inTouching") then
		return
	end

	local var0 = {}

	table.insert(var0, function(arg0)
		setCanvasGroupAlpha(arg0.uiContianer, 0)
		arg0:EnableJoystick(false)
		arg0:emit(Dorm3dScene.SHOW_BLOCK)
		arg0()
	end)
	table.insert(var0, function(arg0)
		arg0:emit(Dorm3dScene.EXIT_FREELOOK_MODE, arg0, arg0.touchConfig)
	end)
	seriesAsync(var0, function()
		arg0:SetBlackboardValue("inTouching", false)
		setCanvasGroupAlpha(arg0.uiContianer, 1)
		arg0:emit(Dorm3dScene.HIDE_BLOCK)
		arg0:SetUI("watch")

		arg0.touchConfig = nil
		arg0.touchDic = nil
	end)
end

function var0.DoTouch(arg0, arg1, arg2)
	assert(arg0.touchConfig and arg0.touchDic)
	warning(arg1, arg2, arg0.touchDic[arg2][arg1])

	local var0 = pg.dorm3d_touch_trigger[arg0.touchDic[arg2][arg1]]

	if not var0 then
		return
	end

	local var1 = {}

	if var0.talk_id > 0 then
		table.insert(var1, function(arg0)
			arg0:DoTalk(var0.talk_id, false, arg0)
		end)
	elseif var0.action then
		table.insert(var1, function(arg0)
			arg0:emit(Dorm3dScene.PLAY_SINGLE_ACTION, var0.action, arg0)
		end)
	end

	seriesAsync(var1, function()
		if var0.favor_trigger_id > 0 then
			arg0:emit(Dorm3dSceneMediator.TRIGGER_FAVOR, arg0.apartment.configId, Apartment.TRIGGER_TOUCH)

			local var0 = 202200
			local var1 = pg.ship_skin_words[var0].voice_key
			local var2 = {
				"get_1",
				"touch_1",
				"touch_1_1",
				"touch_1_2",
				"touch_2_2"
			}

			arg0.cvIndex = arg0.cvIndex or 0

			local var3 = var2[arg0.cvIndex + 1]

			arg0.cvIndex = (arg0.cvIndex + 1) % #var2

			local var4 = "event:/cv/" .. var1 .. "/" .. var3

			arg0.cvLoader:PlaySound(var4)
		end
	end)
end

function var0.DoTalk(arg0, arg1, arg2, arg3)
	if arg0:GetBlackboardValue("inTalking") then
		return
	end

	local var0 = {}
	local var1

	table.insert(var0, function(arg0)
		arg0:emit(Dorm3dSceneMediator.DO_TALK, arg1, function(arg0)
			var1 = arg0

			arg0()
		end)
	end)

	local var2 = pg.dorm3d_dialogue_group[arg1]

	table.insert(var0, function(arg0)
		warning(arg1)

		if var2.type == 101 then
			PlayerPrefs.SetInt("dorm3d_enter_count_" .. arg0.apartment.configId, 0)
		end

		arg0:SetBlackboardValue("inTalking", true)
		setCanvasGroupAlpha(arg0.uiContianer, 0)
		arg0:emit(Dorm3dScene.SHOW_BLOCK)
		arg0()
	end)

	if var2.trigger_area and var2.trigger_area ~= "" then
		table.insert(var0, function(arg0)
			arg0:emit(Dorm3dScene.MOVE_PLAYER_TO_FURNITURE, var2.trigger_area, arg0)
		end)
	end

	if arg2 then
		table.insert(var0, function(arg0)
			arg0:emit(Dorm3dScene.ON_DIALOGUE_BEGIN, arg0)
		end)
	end

	if var2.standby_action and var2.standby_action ~= "" then
		table.insert(var0, function(arg0)
			arg0:emit(Dorm3dScene.PLAY_SINGLE_ACTION, var2.standby_action, arg0)
		end)
	end

	table.insert(var0, function(arg0)
		pg.NewStoryMgr.GetInstance():ForceManualPlay(var2.story, arg0, true)
	end)

	if var2.finish_action and var2.finish_action ~= "" then
		table.insert(var0, function(arg0)
			arg0:emit(Dorm3dScene.PLAY_SINGLE_ACTION, var2.finish_action, arg0)
		end)
	end

	if arg2 then
		table.insert(var0, function(arg0)
			arg0:emit(Dorm3dScene.ON_DIALOGUE_END, arg0)
		end)
	end

	table.insert(var0, function(arg0)
		if var1 and #var1 > 0 then
			arg0:emit(Dorm3dSceneMediator.OPEN_DROP_LAYER, var1, arg0)
		else
			arg0()
		end
	end)
	table.insert(var0, function(arg0)
		setCanvasGroupAlpha(arg0.uiContianer, 1)
		arg0:emit(Dorm3dScene.HIDE_BLOCK)
		arg0:SetBlackboardValue("inTalking", false)
		arg0()
	end)
	seriesAsync(var0, arg3)
end

function var0.DoTalkTouchOption(arg0, arg1, arg2, arg3)
	local var0 = arg0._tf:Find("ExtraScreen/TalkTouchOption")
	local var1 = pg.NewStoryMgr.GetInstance()._tf

	setActive(var0, true)

	if isActive(var1) then
		setParent(var0, var1)
	else
		pg.UIMgr.GetInstance():OverlayPanel(var0, {
			weight = LayerWeightConst.SECOND_LAYER,
			groupName = LayerWeightConst.GROUP_DORM3D
		})
	end

	local var2
	local var3 = var0:Find("content")

	UIItemList.StaticAlign(var3, var3:Find("clickTpl"), #arg1.options, function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1.options[arg1]

			setAnchoredPosition(arg2, NewPos(unpack(var0.pos)))
			onButton(arg0, arg2, function()
				var2(var0.flag)
			end, SFX_CONFIRM)
			setActive(arg2, not table.contains(arg2, var0.flag))
		end
	end)

	function var2(arg0)
		setActive(var0, false)

		if isActive(var1) then
			setParent(var0, arg0._tf)
		else
			pg.UIMgr.GetInstance():UnOverlayPanel(var0, arg0._tf)
		end

		arg3(arg0)
	end
end

function var0.DoTimelineOption(arg0, arg1, arg2)
	local var0 = arg0._tf:Find("ExtraScreen/TimelineOption")
	local var1 = pg.NewStoryMgr.GetInstance()._tf

	setActive(var0, true)

	if isActive(var1) then
		setParent(var0, var1)
	else
		pg.UIMgr.GetInstance():OverlayPanel(var0, {
			weight = LayerWeightConst.SECOND_LAYER,
			groupName = LayerWeightConst.GROUP_DORM3D
		})
	end

	local var2
	local var3 = var0:Find("content")

	UIItemList.StaticAlign(var3, var3:Find("clickTpl"), #arg1, function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1[arg1]

			setText(arg2:Find("Text"), var0.content)
			onButton(arg0, arg2, function()
				var2(arg1)
			end, SFX_CONFIRM)
		end
	end)

	function var2(arg0)
		setActive(var0, false)

		if isActive(var1) then
			setParent(var0, arg0._tf)
		else
			pg.UIMgr.GetInstance():UnOverlayPanel(var0, arg0._tf)
		end

		arg2(arg0)
	end
end

function var0.DoTimelineTouch(arg0, arg1, arg2)
	local var0 = arg0._tf:Find("ExtraScreen/TimelineTouch")
	local var1 = pg.NewStoryMgr.GetInstance()._tf

	setActive(var0, true)

	if isActive(var1) then
		setParent(var0, var1)
	else
		pg.UIMgr.GetInstance():OverlayPanel(var0, {
			weight = LayerWeightConst.SECOND_LAYER,
			groupName = LayerWeightConst.GROUP_DORM3D
		})
	end

	local var2
	local var3 = var0:Find("content")

	UIItemList.StaticAlign(var3, var3:Find("clickTpl"), #arg1, function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1[arg1]

			setAnchoredPosition(arg2, NewPos(unpack(var0.pos)))
			onButton(arg0, arg2, function()
				var2(arg1)
			end, SFX_CONFIRM)
		end
	end)

	function var2(arg0)
		setActive(var0, false)

		if isActive(var1) then
			setParent(var0, arg0._tf)
		else
			pg.UIMgr.GetInstance():UnOverlayPanel(var0, arg0._tf)
		end

		arg2(arg0)
	end
end

function var0.DoShortWait(arg0)
	local var0 = arg0.apartment:getZone(arg0:GetZoneName()):getConfig("special_action")
	local var1 = var0 ~= "" and var0[math.random(#var0)] or nil

	if not var1 then
		return
	end

	arg0:emit(Dorm3dScene.PLAY_SINGLE_ACTION, var1)
end

function var0.DoLongWait(arg0)
	local var0 = arg0.apartment:getZone(arg0:GetZoneName())

	if arg0:GetBlackboardValue("inWatchMode") then
		local var1 = var0:getConfig("special_talk")
		local var2 = var1 ~= "" and var1[math.random(#var1)] or nil

		if not var2 then
			return
		end

		arg0:DoTalk(var2)
	else
		assert(not arg0:GetBlackboardValue("inLazy"))

		local var3 = var0:getConfig("lazy_action")

		if var3 == "" then
			return
		end

		arg0:SetBlackboardValue("inLazy", true)
		arg0:emit(Dorm3dScene.PLAY_SINGLE_ACTION, var3[1])
	end
end

function var0.OutOfLazy(arg0, arg1)
	local var0 = {}

	if arg0:GetBlackboardValue("inLazy") then
		local var1 = arg0.apartment:getZone(arg0:GetZoneName())

		table.insert(var0, function(arg0)
			arg0:emit(Dorm3dScene.SHOW_BLOCK)
			arg0:emit(Dorm3dScene.PLAY_SINGLE_ACTION, var1:getConfig("lazy_action")[2], function()
				arg0:SetBlackboardValue("inLazy", false)
				arg0:emit(Dorm3dScene.HIDE_BLOCK)
				arg0()
			end)
		end)
	end

	arg0.contextData.enterZone = nil

	seriesAsync(var0, arg1)
end

function var0.TriggerContact(arg0, arg1)
	arg0:emit(Dorm3dSceneMediator.COLLECTION_ITEM, arg0.apartment.configId, arg0.contactDic[arg1])
end

function var0.UpdateContactState(arg0)
	local var0 = arg0.apartment:getTriggerableCollectItems()

	arg0.contactDic = {}

	for iter0, iter1 in ipairs(var0) do
		local var1 = pg.dorm3d_collection_template[iter1]

		arg0.contactDic[var1.model] = iter1
	end

	arg0:emit(Dorm3dScene.ON_UPDATE_CONTACT_STSTE, arg0.contactDic)

	if not arg0.floatTimer then
		arg0.floatTimer = Timer.New(function()
			arg0:UpdateContactPosition()
		end, 1 / (Application.targetFrameRate or 60), -1)

		arg0.floatTimer:Start()
	end

	if #var0 > 0 then
		arg0.floatTimer:Resume()
	else
		arg0.floatTimer:Pause()
	end

	arg0:UpdateContactPosition()
end

function var0.UpdateContactPosition(arg0)
	arg0:emit(Dorm3dScene.ON_UPDATE_CONTACT_POSITION, arg0.contactDic)
end

function var0.UpdateFavorDisplay(arg0)
	setText(arg0.rtFavorLevel:Find("rank/Text"), arg0.apartment.level)

	local var0 = arg0.apartment.favor
	local var1 = arg0.apartment:getNextExp()

	setText(arg0.rtFavorLevel:Find("Text"), string.format("<color=#ff6698>%d</color>/%d", var0, var1))
end

function var0.CheckFavorTrigger(arg0)
	if arg0.uiState ~= "base" then
		return
	end

	local var0 = {}
	local var1 = getProxy(CollectionProxy):getShipGroup(arg0.apartment.configId)

	table.insert(var0, function(arg0)
		if arg0.apartment.triggerCountDic[Apartment.TRIGGER_OWNER] == 0 and var1 then
			arg0:emit(Dorm3dSceneMediator.TRIGGER_FAVOR, arg0.apartment.configId, Apartment.TRIGGER_OWNER)
		else
			arg0()
		end
	end)
	table.insert(var0, function(arg0)
		if arg0.apartment.triggerCountDic[Apartment.TRIGGER_PROPOSE] == 0 and var1 and var1.married > 0 then
			arg0:emit(Dorm3dSceneMediator.TRIGGER_FAVOR, arg0.apartment.configId, Apartment.TRIGGER_PROPOSE)
		else
			arg0()
		end
	end)
	seriesAsync(var0, function()
		arg0:CheckLevelUp()
	end)
end

function var0.CheckLevelUp(arg0)
	if arg0.apartment.favor >= arg0.apartment:getNextExp() then
		arg0:emit(Dorm3dSceneMediator.FAVOR_LEVEL_UP, arg0.apartment.configId)
	end
end

function var0.PopFavorTrigger(arg0, arg1, arg2, arg3)
	if pg.dorm3d_favor_trigger[arg1].is_repeat > 0 then
		local var0 = arg3.daily - arg2
		local var1 = arg3.daily
		local var2 = getDorm3dGameset("daily_exp_max")[1]

		setText(arg0.rtFavorUpDaily:Find("info/Text"), i18n("xxx"))
		setText(arg0.rtFavorUpDaily:Find("info/count"), string.format("<color=#ffffff>%d</color>/%d", var1, var2))
		setSlider(arg0.rtFavorUpDaily:Find("slider/back"), 0, var2, var1)
		setSlider(arg0.rtFavorUpDaily:Find("slider/front"), 0, var2, var0)
		setActive(arg0.rtFavorUpDaily, true)
	else
		setText(arg0.rtFavorUp:Find("Text"), string.format("once plus %d", arg2))
		setActive(arg0.rtFavorUp, true)
	end
end

function var0.PopFavorLevelUp(arg0, arg1, arg2)
	eachChild(arg0.rtLevelUpWindow:Find("panel/mark/level"), function(arg0)
		setActive(arg0, arg0.name == tostring(arg1.level))
	end)
	setText(arg0.rtLevelUpWindow:Find("panel/info/Text"), arg1:getFavorConfig("levelup_trigger_mention"))
	setActive(arg0.rtLevelUpWindow, true)
	pg.UIMgr.GetInstance():OverlayPanel(arg0.rtLevelUpWindow, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_DORM3D
	})

	function arg0.levelUpCallback()
		arg0.levelUpCallback = nil

		existCall(arg2)
	end
end

function var0.TalkingEventHandle(arg0, arg1)
	local var0 = {}
	local var1 = {}
	local var2 = arg1.data

	if var2.op_list then
		for iter0, iter1 in ipairs(var2.op_list) do
			table.insert(var0, function(arg0)
				if iter1.skip then
					arg0()

					arg0 = nil
				end

				switch(iter1.type, {
					action = function()
						arg0:emit(Dorm3dScene.PLAY_SINGLE_ACTION, iter1.name, arg0)
					end,
					timeline = function()
						arg0:emit(Dorm3dScene.PLAY_TIMELINE, iter1, function(arg0)
							var1.optionIndex = arg0.optionIndex

							existCall(arg0)
						end)
					end,
					clickOption = function()
						arg0:DoTalkTouchOption(iter1, arg1.flags, function(arg0)
							var1.optionIndex = arg0

							existCall(arg0)
						end)
					end,
					wait = function()
						arg0.LTs = arg0.LTs or {}

						table.insert(arg0.LTs, LeanTween.delayedCall(iter1.time, System.Action(function()
							existCall(arg0)
						end)).uniqueId)
					end
				}, function()
					assert(false, "op type error:", iter1.type)
				end)
			end)
		end
	end

	seriesAsync(var0, function()
		if arg1.callbackData then
			arg0:emit(Dorm3dSceneMediator.TALKING_EVENT_FINISH, arg1.callbackData.name, var1)
		end
	end)
end

function var0.GetFurnitureTalk(arg0, arg1)
	local var0 = arg0.apartment:getFurnitureTalking(arg1)

	return var0[math.random(#var0)]
end

function var0.EnterCheck(arg0)
	local var0 = {}

	if arg0.contextData.hasEnterCheck then
		arg0:CheckFavorTrigger()
	else
		arg0.contextData.hasEnterCheck = true

		if arg0.contextData.enterType == 1 then
			local var1 = arg0:GetEnterTalk()

			if var1 then
				table.insert(var0, function(arg0)
					arg0:DoTalk(var1, false, arg0)
				end)
			end

			seriesAsync(var0, function()
				arg0:CheckFavorTrigger()
			end)
		elseif arg0.contextData.enterType == 2 then
			local var2 = arg0.apartment:getZone(arg0.contextData.enterZone):getConfig("lazy_action")

			if var2 == "" then
				return
			end

			arg0:SetBlackboardValue("inLazy", true)
			arg0:emit(Dorm3dScene.SWITCH_ACTION, var2[3])
		else
			assert(false)
		end
	end
end

function var0.GetEnterTalk(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.apartment:getEnterTalking()) do
		local var1 = pg.dorm3d_dialogue_group[iter1]

		if var1.type == 104 and not pg.NewStoryMgr.GetInstance():IsPlayed(var1.story) then
			return iter1
		elseif var1.type == 105 and PlayerPrefs.GetString("DORM3D_DAILY_ENTER", "") ~= pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d") then
			PlayerPrefs.SetString("DORM3D_DAILY_ENTER", pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d"))

			return iter1
		elseif var1.type == 1053 and not pg.NewStoryMgr.GetInstance():IsPlayed(var1.story) then
			local var2 = getProxy(CollectionProxy):getShipGroup(arg0.apartment.configId)

			if var2 and var2.married > 0 then
				return iter1
			end
		elseif var1.type == 1052 and underscore.any(var1.trigger_config, function(arg0)
			return getProxy(ActivityProxy):IsActivityNotEnd(arg0)
		end) then
			table.insert(var0, iter1)
		elseif var1.type == 1051 and PlayerPrefs.GetInt("dorm3d_enter_count_" .. arg0.apartment.configId, 0) > var1.trigger_config[2] then
			table.insert(var0, iter1)
		end
	end

	return var0[math.random(#var0)]
end

function var0.EnterWatchMode(arg0)
	arg0:SetBlackboardValue("inWatchMode", true)
	arg0:SetUI("watch")
end

function var0.ExitWatchMode(arg0)
	arg0:SetBlackboardValue("inWatchMode", false)
	arg0:SetUI("base")
	arg0:CheckFavorTrigger()
end

function var0.GetZoneName(arg0)
	local var0 = arg0:GetBlackboardValue("inFurniture")

	return arg0.contextData.enterZone or var0 and var0.name or "Default"
end

function var0.TempHideUI(arg0, arg1)
	local var0 = defaultValue(arg0.hideCount, 0)

	arg0.hideCount = var0 + (arg1 and 1 or -1)

	assert(arg0.hideCount >= 0)

	if arg0.hideCount * var0 > 0 then
		return
	end

	local var1 = arg0.hideCount == 0 and arg0.uiState or nil

	eachChild(arg0.uiContianer, function(arg0)
		setActive(arg0, arg0.name == var1)
	end)
	setActive(arg0.rtFloatPage, arg0.hideCount == 0)
end

function var0.onBackPressed(arg0)
	if isActive(arg0.rtLevelUpWindow) then
		triggerButton(arg0.rtLevelUpWindow:Find("bg"))
	elseif arg0.uiState ~= "base" then
		triggerButton(arg0.uiContianer:Find(arg0.uiState .. "/btn_back"))
	else
		return false
	end

	return true
end

function var0.OnDestroy(arg0)
	arg0.cvLoader:Dispose()

	if arg0.floatTimer then
		arg0.floatTimer:Stop()
	end

	if arg0.LTs then
		underscore.map(arg0.LTs, function(arg0)
			LeanTween.cancel(arg0)
		end)

		arg0.LTs = nil
	end

	arg0:SetBlackboardValue("inLockLayer", nil)

	arg0.contextData.charFurnitureName = nil

	SetCompomentEnabled(arg0.rtMainAI, "BehaviourTreeOwner", false)
	pg.NodeCanvasMgr.GetInstance():Clear()
end

return var0
