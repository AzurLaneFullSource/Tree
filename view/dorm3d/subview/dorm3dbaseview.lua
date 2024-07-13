local var0_0 = class("Dorm3dBaseView", import("view.base.BaseSubView"))

function var0_0.SetApartment(arg0_1, arg1_1, arg2_1)
	arg0_1.apartment = arg1_1

	local var0_1 = "dorm3d_enter_count_" .. arg0_1.apartment.configId

	PlayerPrefs.SetInt(var0_1, PlayerPrefs.GetInt(var0_1, 0) + 1)
	arg0_1:UpdateFavorDisplay()
	arg0_1:UpdateContactState()
end

function var0_0.OnInit(arg0_2)
	arg0_2.uiContianer = arg0_2._tf:Find("UI")

	local var0_2 = arg0_2.uiContianer:Find("base")

	onButton(arg0_2, var0_2:Find("btn_back"), function()
		arg0_2:emit(BaseUI.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0_2, var0_2:Find("btn_back/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("roll_gametip")
		})
	end, SFX_PANEL)

	arg0_2.rtFavorLevel = var0_2:Find("top/favor_level")

	onButton(arg0_2, arg0_2.rtFavorLevel, function()
		arg0_2:emit(Dorm3dSceneMediator.OPEN_LEVEL_LAYER)
	end, SFX_PANEL)
	onButton(arg0_2, var0_2:Find("bottom/btn_furniture"), function()
		local var0_6, var1_6 = arg0_2.apartment:checkUnlockConfig(getDorm3dGameset("drom3d_furniture_unlock")[2])

		if not var0_6 then
			pg.TipsMgr.GetInstance():ShowTips(var1_6)

			return
		end

		arg0_2:emit(Dorm3dSceneMediator.OPEN_FURNITURE_SELECT)
	end, SFX_PANEL)
	onButton(arg0_2, var0_2:Find("left/btn_photograph"), function()
		arg0_2:emit(Dorm3dSceneMediator.OPEN_CAMERA_LAYER)
	end, SFX_PANEL)
	onButton(arg0_2, var0_2:Find("left/btn_collection"), function()
		local var0_8, var1_8 = arg0_2.apartment:checkUnlockConfig(getDorm3dGameset("drom3d_recall_unlock")[2])

		if not var0_8 then
			pg.TipsMgr.GetInstance():ShowTips(var1_8)

			return
		end

		arg0_2:emit(Dorm3dSceneMediator.OPEN_COLLECTION_LAYER)
	end, SFX_PANEL)

	local var1_2 = arg0_2.uiContianer:Find("touch")

	onButton(arg0_2, var1_2:Find("btn_back"), function()
		arg0_2:ExitTouchMode()
	end, SFX_CANCEL)
	onButton(arg0_2, var1_2:Find("btn_back/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("roll_gametip")
		})
	end, SFX_PANEL)

	arg0_2.rtFavorUp = arg0_2._tf:Find("Toast/favor_up")

	setActive(arg0_2.rtFavorUp, false)

	arg0_2.rtFavorUpDaily = arg0_2._tf:Find("Toast/favor_up_daily")

	setActive(arg0_2.rtFavorUpDaily, false)

	for iter0_2, iter1_2 in ipairs({
		arg0_2.rtFavorUp,
		arg0_2.rtFavorUpDaily
	}) do
		iter1_2:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_11)
			setActive(iter1_2, false)
		end)
	end

	arg0_2.rtLevelUpWindow = arg0_2._tf:Find("LevelUpWindow")

	setActive(arg0_2.rtLevelUpWindow, false)
	onButton(arg0_2, arg0_2.rtLevelUpWindow:Find("bg"), function()
		setActive(arg0_2.rtLevelUpWindow, false)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_2.rtLevelUpWindow, arg0_2._tf)
		existCall(arg0_2.levelUpCallback)
	end, SFX_PANEL)

	local var2_2 = arg0_2.uiContianer:Find("watch")

	onButton(arg0_2, var2_2:Find("btn_back"), function()
		arg0_2:emit(Dorm3dScene.EXIT_WATCH_MODE)
	end)
	onButton(arg0_2, var2_2:Find("btn_back/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("roll_gametip")
		})
	end, SFX_PANEL)

	local var3_2 = arg0_2.uiContianer:Find("watch/Role")

	onButton(arg0_2, var3_2:Find("Talk"), function()
		local var0_15 = arg0_2:GetFurnitureTalk(arg0_2:GetZoneName())

		if not var0_15 then
			pg.TipsMgr.GetInstance():ShowTips("without topic")

			return
		end

		arg0_2:DoTalk(var0_15, true, function()
			arg0_2:emit(Dorm3dSceneMediator.TRIGGER_FAVOR, arg0_2.apartment.configId, Apartment.TRIGGER_TALK)
		end)
	end, SFX_CONFIRM)
	setText(var3_2:Find("Talk/Text"), i18n("dorm3d_talk"))
	onButton(arg0_2, var3_2:Find("Touch"), function()
		local var0_17, var1_17 = arg0_2.apartment:checkUnlockConfig(getDorm3dGameset("drom3d_touch_dialogue")[2])

		if not var0_17 then
			pg.TipsMgr.GetInstance():ShowTips(var1_17)

			return
		end

		arg0_2:EnterTouchMode()
	end, SFX_CONFIRM)
	setText(var3_2:Find("Touch/Text"), i18n("dorm3d_touch"))
	onButton(arg0_2, var3_2:Find("Gift"), function()
		local var0_18, var1_18 = arg0_2.apartment:checkUnlockConfig(getDorm3dGameset("drom3d_gift_dialogue")[2])

		if not var0_18 then
			pg.TipsMgr.GetInstance():ShowTips(var1_18)

			return
		end

		arg0_2:emit(Dorm3dSceneMediator.OPEN_GIFT_LAYER)
	end, SFX_CONFIRM)
	setText(var3_2:Find("Gift/Text"), i18n("dorm3d_gift"))

	arg0_2.rtFloatPage = arg0_2._tf:Find("FloatPage")
	arg0_2.tplFloat = arg0_2.rtFloatPage:Find("tpl")

	setActive(arg0_2.tplFloat, false)

	arg0_2._joystick = arg0_2._tf:Find("Stick")

	setActive(arg0_2._joystick, true)

	arg0_2._stickCom = arg0_2._joystick:GetComponent(typeof(SlideController))

	arg0_2._stickCom:SetStickFunc(function(arg0_19)
		arg0_2:emit(Dorm3dScene.ON_STICK_MOVE, arg0_19)
	end)
	arg0_2:SetUI("base")

	arg0_2.cvLoader = ShipProfileCVLoader.New()
end

function var0_0.initNodeCanvas(arg0_20, arg1_20)
	arg0_20.rtMainAI = arg1_20

	local var0_20 = pg.NodeCanvasMgr.GetInstance()

	var0_20:SetOwner(arg0_20.rtMainAI)

	for iter0_20, iter1_20 in ipairs(arg0_20.contextData.blackboard or {
		inTalking = false,
		inWatchMode = false
	}) do
		arg0_20:SetBlackboardValue(iter0_20, iter1_20)
	end

	var0_20:RegisterFunc("ClickCharacter", function(arg0_21)
		if arg0_20.uiState ~= "base" then
			return
		end

		if not arg0_20:GetBlackboardValue("inWatchMode") then
			arg0_20:OutOfLazy(function()
				arg0_20:emit(Dorm3dScene.ENTER_WATCH_MODE)
			end)
		end
	end)
	var0_20:RegisterFunc("MoveFurniture", function(arg0_23)
		if arg0_20.uiState ~= "base" then
			return
		end

		arg0_20:OutOfLazy(function()
			arg0_20:SetBlackboardValue("inMoving", true)
			arg0_20:emit(Dorm3dScene.MOVE_PLAYER_TO_FURNITURE, arg0_23.name, function()
				arg0_20:SetBlackboardValue("inMoving", false)
			end)
		end)
	end)
	var0_20:RegisterFunc("ClickCharacterInWatch", function()
		arg0_20:OutOfLazy(function()
			arg0_20:emit(Dorm3dScene.WATCH_MODE_INTERACTIVE)
		end)
	end)
	var0_20:RegisterFunc("ClickContact", function(arg0_28)
		arg0_20:TriggerContact(arg0_28)
	end)
	var0_20:RegisterFunc("ShortWaitAction", function()
		arg0_20:DoShortWait()
	end)
	var0_20:RegisterFunc("LongWaitAction", function()
		arg0_20:DoLongWait()
	end)
end

function var0_0.BindEvent(arg0_31)
	arg0_31:bind(Dorm3dScene.ON_TOUCH_CHARACTER, function(arg0_32, arg1_32)
		if not arg0_31:GetBlackboardValue("inTouching") then
			return
		end

		arg0_31:DoTouch(arg1_32, 1)
	end)
	arg0_31:bind(Dorm3dScene.ON_ROLEWATCH_CAMERA_MAX, function(arg0_33, arg1_33)
		if not arg0_31:GetBlackboardValue("inTouching") then
			return
		end

		arg0_31:DoTouch(arg1_33, 0)
	end)
end

function var0_0.TreeStart(arg0_34)
	if arg0_34.contextData.resumeCallback then
		arg0_34.contextData.resumeCallback()

		arg0_34.contextData.resumeCallback = nil
	end

	SetCompomentEnabled(arg0_34.rtMainAI, "BehaviourTreeOwner", true)
	arg0_34:EnterCheck()
end

function var0_0.SetBlackboardValue(arg0_35, arg1_35, arg2_35)
	arg0_35.contextData.blackboard = arg0_35.contextData.blackboard or {}
	arg0_35.contextData.blackboard[arg1_35] = arg2_35

	pg.NodeCanvasMgr.GetInstance():SetBlackboradValue(arg1_35, arg2_35)
end

function var0_0.GetBlackboardValue(arg0_36, arg1_36)
	arg0_36.contextData.blackboard = arg0_36.contextData.blackboard or {}

	return arg0_36.contextData.blackboard[arg1_36]
end

function var0_0.SendNodeCanvasEvent(arg0_37, arg1_37, arg2_37)
	pg.NodeCanvasMgr.GetInstance():SendEvent(arg1_37, arg2_37)
end

function var0_0.EnableJoystick(arg0_38, arg1_38)
	setActive(arg0_38._joystick, arg1_38)
end

function var0_0.SetInFurniture(arg0_39, arg1_39)
	arg0_39:SetBlackboardValue("inFurniture", arg1_39)
end

function var0_0.SetLadyTransform(arg0_40, arg1_40)
	arg0_40:SetBlackboardValue("ladyTransform", arg1_40)
end

function var0_0.SetUI(arg0_41, arg1_41)
	if arg0_41.uiState == arg1_41 then
		return
	end

	arg0_41.uiState = arg1_41

	eachChild(arg0_41.uiContianer, function(arg0_42)
		setActive(arg0_42, arg0_42.name == arg1_41)
	end)
end

function var0_0.EnterTouchMode(arg0_43)
	if arg0_43:GetBlackboardValue("inTouching") then
		return
	end

	arg0_43.touchConfig, arg0_43.touchDic = arg0_43.apartment:getTouchConfig(arg0_43:GetZoneName())

	local var0_43 = {}

	table.insert(var0_43, function(arg0_44)
		arg0_43:SetBlackboardValue("inTouching", true)
		setCanvasGroupAlpha(arg0_43.uiContianer, 0)
		arg0_43:emit(Dorm3dScene.SHOW_BLOCK)
		arg0_43:SetUI("touch")
		arg0_44()
	end)
	table.insert(var0_43, function(arg0_45)
		arg0_43:emit(Dorm3dScene.ENTER_FREELOOK_MODE, arg0_45, arg0_43.touchConfig)
	end)
	seriesAsync(var0_43, function()
		arg0_43:EnableJoystick(true)
		setCanvasGroupAlpha(arg0_43.uiContianer, 1)
		arg0_43:emit(Dorm3dScene.HIDE_BLOCK)
	end)
end

function var0_0.ExitTouchMode(arg0_47)
	if not arg0_47:GetBlackboardValue("inTouching") then
		return
	end

	local var0_47 = {}

	table.insert(var0_47, function(arg0_48)
		setCanvasGroupAlpha(arg0_47.uiContianer, 0)
		arg0_47:EnableJoystick(false)
		arg0_47:emit(Dorm3dScene.SHOW_BLOCK)
		arg0_48()
	end)
	table.insert(var0_47, function(arg0_49)
		arg0_47:emit(Dorm3dScene.EXIT_FREELOOK_MODE, arg0_49, arg0_47.touchConfig)
	end)
	seriesAsync(var0_47, function()
		arg0_47:SetBlackboardValue("inTouching", false)
		setCanvasGroupAlpha(arg0_47.uiContianer, 1)
		arg0_47:emit(Dorm3dScene.HIDE_BLOCK)
		arg0_47:SetUI("watch")

		arg0_47.touchConfig = nil
		arg0_47.touchDic = nil
	end)
end

function var0_0.DoTouch(arg0_51, arg1_51, arg2_51)
	assert(arg0_51.touchConfig and arg0_51.touchDic)
	warning(arg1_51, arg2_51, arg0_51.touchDic[arg2_51][arg1_51])

	local var0_51 = pg.dorm3d_touch_trigger[arg0_51.touchDic[arg2_51][arg1_51]]

	if not var0_51 then
		return
	end

	local var1_51 = {}

	if var0_51.talk_id > 0 then
		table.insert(var1_51, function(arg0_52)
			arg0_51:DoTalk(var0_51.talk_id, false, arg0_52)
		end)
	elseif var0_51.action then
		table.insert(var1_51, function(arg0_53)
			arg0_51:emit(Dorm3dScene.PLAY_SINGLE_ACTION, var0_51.action, arg0_53)
		end)
	end

	seriesAsync(var1_51, function()
		if var0_51.favor_trigger_id > 0 then
			arg0_51:emit(Dorm3dSceneMediator.TRIGGER_FAVOR, arg0_51.apartment.configId, Apartment.TRIGGER_TOUCH)

			local var0_54 = 202200
			local var1_54 = pg.ship_skin_words[var0_54].voice_key
			local var2_54 = {
				"get_1",
				"touch_1",
				"touch_1_1",
				"touch_1_2",
				"touch_2_2"
			}

			arg0_51.cvIndex = arg0_51.cvIndex or 0

			local var3_54 = var2_54[arg0_51.cvIndex + 1]

			arg0_51.cvIndex = (arg0_51.cvIndex + 1) % #var2_54

			local var4_54 = "event:/cv/" .. var1_54 .. "/" .. var3_54

			arg0_51.cvLoader:PlaySound(var4_54)
		end
	end)
end

function var0_0.DoTalk(arg0_55, arg1_55, arg2_55, arg3_55)
	if arg0_55:GetBlackboardValue("inTalking") then
		return
	end

	local var0_55 = {}
	local var1_55

	table.insert(var0_55, function(arg0_56)
		arg0_55:emit(Dorm3dSceneMediator.DO_TALK, arg1_55, function(arg0_57)
			var1_55 = arg0_57

			arg0_56()
		end)
	end)

	local var2_55 = pg.dorm3d_dialogue_group[arg1_55]

	table.insert(var0_55, function(arg0_58)
		warning(arg1_55)

		if var2_55.type == 101 then
			PlayerPrefs.SetInt("dorm3d_enter_count_" .. arg0_55.apartment.configId, 0)
		end

		arg0_55:SetBlackboardValue("inTalking", true)
		setCanvasGroupAlpha(arg0_55.uiContianer, 0)
		arg0_55:emit(Dorm3dScene.SHOW_BLOCK)
		arg0_58()
	end)

	if var2_55.trigger_area and var2_55.trigger_area ~= "" then
		table.insert(var0_55, function(arg0_59)
			arg0_55:emit(Dorm3dScene.MOVE_PLAYER_TO_FURNITURE, var2_55.trigger_area, arg0_59)
		end)
	end

	if arg2_55 then
		table.insert(var0_55, function(arg0_60)
			arg0_55:emit(Dorm3dScene.ON_DIALOGUE_BEGIN, arg0_60)
		end)
	end

	if var2_55.standby_action and var2_55.standby_action ~= "" then
		table.insert(var0_55, function(arg0_61)
			arg0_55:emit(Dorm3dScene.PLAY_SINGLE_ACTION, var2_55.standby_action, arg0_61)
		end)
	end

	table.insert(var0_55, function(arg0_62)
		pg.NewStoryMgr.GetInstance():ForceManualPlay(var2_55.story, arg0_62, true)
	end)

	if var2_55.finish_action and var2_55.finish_action ~= "" then
		table.insert(var0_55, function(arg0_63)
			arg0_55:emit(Dorm3dScene.PLAY_SINGLE_ACTION, var2_55.finish_action, arg0_63)
		end)
	end

	if arg2_55 then
		table.insert(var0_55, function(arg0_64)
			arg0_55:emit(Dorm3dScene.ON_DIALOGUE_END, arg0_64)
		end)
	end

	table.insert(var0_55, function(arg0_65)
		if var1_55 and #var1_55 > 0 then
			arg0_55:emit(Dorm3dSceneMediator.OPEN_DROP_LAYER, var1_55, arg0_65)
		else
			arg0_65()
		end
	end)
	table.insert(var0_55, function(arg0_66)
		setCanvasGroupAlpha(arg0_55.uiContianer, 1)
		arg0_55:emit(Dorm3dScene.HIDE_BLOCK)
		arg0_55:SetBlackboardValue("inTalking", false)
		arg0_66()
	end)
	seriesAsync(var0_55, arg3_55)
end

function var0_0.DoTalkTouchOption(arg0_67, arg1_67, arg2_67, arg3_67)
	local var0_67 = arg0_67._tf:Find("ExtraScreen/TalkTouchOption")
	local var1_67 = pg.NewStoryMgr.GetInstance()._tf

	setActive(var0_67, true)

	if isActive(var1_67) then
		setParent(var0_67, var1_67)
	else
		pg.UIMgr.GetInstance():OverlayPanel(var0_67, {
			weight = LayerWeightConst.SECOND_LAYER,
			groupName = LayerWeightConst.GROUP_DORM3D
		})
	end

	local var2_67
	local var3_67 = var0_67:Find("content")

	UIItemList.StaticAlign(var3_67, var3_67:Find("clickTpl"), #arg1_67.options, function(arg0_68, arg1_68, arg2_68)
		arg1_68 = arg1_68 + 1

		if arg0_68 == UIItemList.EventUpdate then
			local var0_68 = arg1_67.options[arg1_68]

			setAnchoredPosition(arg2_68, NewPos(unpack(var0_68.pos)))
			onButton(arg0_67, arg2_68, function()
				var2_67(var0_68.flag)
			end, SFX_CONFIRM)
			setActive(arg2_68, not table.contains(arg2_67, var0_68.flag))
		end
	end)

	function var2_67(arg0_70)
		setActive(var0_67, false)

		if isActive(var1_67) then
			setParent(var0_67, arg0_67._tf)
		else
			pg.UIMgr.GetInstance():UnOverlayPanel(var0_67, arg0_67._tf)
		end

		arg3_67(arg0_70)
	end
end

function var0_0.DoTimelineOption(arg0_71, arg1_71, arg2_71)
	local var0_71 = arg0_71._tf:Find("ExtraScreen/TimelineOption")
	local var1_71 = pg.NewStoryMgr.GetInstance()._tf

	setActive(var0_71, true)

	if isActive(var1_71) then
		setParent(var0_71, var1_71)
	else
		pg.UIMgr.GetInstance():OverlayPanel(var0_71, {
			weight = LayerWeightConst.SECOND_LAYER,
			groupName = LayerWeightConst.GROUP_DORM3D
		})
	end

	local var2_71
	local var3_71 = var0_71:Find("content")

	UIItemList.StaticAlign(var3_71, var3_71:Find("clickTpl"), #arg1_71, function(arg0_72, arg1_72, arg2_72)
		arg1_72 = arg1_72 + 1

		if arg0_72 == UIItemList.EventUpdate then
			local var0_72 = arg1_71[arg1_72]

			setText(arg2_72:Find("Text"), var0_72.content)
			onButton(arg0_71, arg2_72, function()
				var2_71(arg1_72)
			end, SFX_CONFIRM)
		end
	end)

	function var2_71(arg0_74)
		setActive(var0_71, false)

		if isActive(var1_71) then
			setParent(var0_71, arg0_71._tf)
		else
			pg.UIMgr.GetInstance():UnOverlayPanel(var0_71, arg0_71._tf)
		end

		arg2_71(arg0_74)
	end
end

function var0_0.DoTimelineTouch(arg0_75, arg1_75, arg2_75)
	local var0_75 = arg0_75._tf:Find("ExtraScreen/TimelineTouch")
	local var1_75 = pg.NewStoryMgr.GetInstance()._tf

	setActive(var0_75, true)

	if isActive(var1_75) then
		setParent(var0_75, var1_75)
	else
		pg.UIMgr.GetInstance():OverlayPanel(var0_75, {
			weight = LayerWeightConst.SECOND_LAYER,
			groupName = LayerWeightConst.GROUP_DORM3D
		})
	end

	local var2_75
	local var3_75 = var0_75:Find("content")

	UIItemList.StaticAlign(var3_75, var3_75:Find("clickTpl"), #arg1_75, function(arg0_76, arg1_76, arg2_76)
		arg1_76 = arg1_76 + 1

		if arg0_76 == UIItemList.EventUpdate then
			local var0_76 = arg1_75[arg1_76]

			setAnchoredPosition(arg2_76, NewPos(unpack(var0_76.pos)))
			onButton(arg0_75, arg2_76, function()
				var2_75(arg1_76)
			end, SFX_CONFIRM)
		end
	end)

	function var2_75(arg0_78)
		setActive(var0_75, false)

		if isActive(var1_75) then
			setParent(var0_75, arg0_75._tf)
		else
			pg.UIMgr.GetInstance():UnOverlayPanel(var0_75, arg0_75._tf)
		end

		arg2_75(arg0_78)
	end
end

function var0_0.DoShortWait(arg0_79)
	local var0_79 = arg0_79.apartment:getZone(arg0_79:GetZoneName()):getConfig("special_action")
	local var1_79 = var0_79 ~= "" and var0_79[math.random(#var0_79)] or nil

	if not var1_79 then
		return
	end

	arg0_79:emit(Dorm3dScene.PLAY_SINGLE_ACTION, var1_79)
end

function var0_0.DoLongWait(arg0_80)
	local var0_80 = arg0_80.apartment:getZone(arg0_80:GetZoneName())

	if arg0_80:GetBlackboardValue("inWatchMode") then
		local var1_80 = var0_80:getConfig("special_talk")
		local var2_80 = var1_80 ~= "" and var1_80[math.random(#var1_80)] or nil

		if not var2_80 then
			return
		end

		arg0_80:DoTalk(var2_80)
	else
		assert(not arg0_80:GetBlackboardValue("inLazy"))

		local var3_80 = var0_80:getConfig("lazy_action")

		if var3_80 == "" then
			return
		end

		arg0_80:SetBlackboardValue("inLazy", true)
		arg0_80:emit(Dorm3dScene.PLAY_SINGLE_ACTION, var3_80[1])
	end
end

function var0_0.OutOfLazy(arg0_81, arg1_81)
	local var0_81 = {}

	if arg0_81:GetBlackboardValue("inLazy") then
		local var1_81 = arg0_81.apartment:getZone(arg0_81:GetZoneName())

		table.insert(var0_81, function(arg0_82)
			arg0_81:emit(Dorm3dScene.SHOW_BLOCK)
			arg0_81:emit(Dorm3dScene.PLAY_SINGLE_ACTION, var1_81:getConfig("lazy_action")[2], function()
				arg0_81:SetBlackboardValue("inLazy", false)
				arg0_81:emit(Dorm3dScene.HIDE_BLOCK)
				arg0_82()
			end)
		end)
	end

	arg0_81.contextData.enterZone = nil

	seriesAsync(var0_81, arg1_81)
end

function var0_0.TriggerContact(arg0_84, arg1_84)
	arg0_84:emit(Dorm3dSceneMediator.COLLECTION_ITEM, arg0_84.apartment.configId, arg0_84.contactDic[arg1_84])
end

function var0_0.UpdateContactState(arg0_85)
	local var0_85 = arg0_85.apartment:getTriggerableCollectItems()

	arg0_85.contactDic = {}

	for iter0_85, iter1_85 in ipairs(var0_85) do
		local var1_85 = pg.dorm3d_collection_template[iter1_85]

		arg0_85.contactDic[var1_85.model] = iter1_85
	end

	arg0_85:emit(Dorm3dScene.ON_UPDATE_CONTACT_STSTE, arg0_85.contactDic)

	if not arg0_85.floatTimer then
		arg0_85.floatTimer = Timer.New(function()
			arg0_85:UpdateContactPosition()
		end, 1 / (Application.targetFrameRate or 60), -1)

		arg0_85.floatTimer:Start()
	end

	if #var0_85 > 0 then
		arg0_85.floatTimer:Resume()
	else
		arg0_85.floatTimer:Pause()
	end

	arg0_85:UpdateContactPosition()
end

function var0_0.UpdateContactPosition(arg0_87)
	arg0_87:emit(Dorm3dScene.ON_UPDATE_CONTACT_POSITION, arg0_87.contactDic)
end

function var0_0.UpdateFavorDisplay(arg0_88)
	setText(arg0_88.rtFavorLevel:Find("rank/Text"), arg0_88.apartment.level)

	local var0_88 = arg0_88.apartment.favor
	local var1_88 = arg0_88.apartment:getNextExp()

	setText(arg0_88.rtFavorLevel:Find("Text"), string.format("<color=#ff6698>%d</color>/%d", var0_88, var1_88))
end

function var0_0.CheckFavorTrigger(arg0_89)
	if arg0_89.uiState ~= "base" then
		return
	end

	local var0_89 = {}
	local var1_89 = getProxy(CollectionProxy):getShipGroup(arg0_89.apartment.configId)

	table.insert(var0_89, function(arg0_90)
		if arg0_89.apartment.triggerCountDic[Apartment.TRIGGER_OWNER] == 0 and var1_89 then
			arg0_89:emit(Dorm3dSceneMediator.TRIGGER_FAVOR, arg0_89.apartment.configId, Apartment.TRIGGER_OWNER)
		else
			arg0_90()
		end
	end)
	table.insert(var0_89, function(arg0_91)
		if arg0_89.apartment.triggerCountDic[Apartment.TRIGGER_PROPOSE] == 0 and var1_89 and var1_89.married > 0 then
			arg0_89:emit(Dorm3dSceneMediator.TRIGGER_FAVOR, arg0_89.apartment.configId, Apartment.TRIGGER_PROPOSE)
		else
			arg0_91()
		end
	end)
	seriesAsync(var0_89, function()
		arg0_89:CheckLevelUp()
	end)
end

function var0_0.CheckLevelUp(arg0_93)
	if arg0_93.apartment.favor >= arg0_93.apartment:getNextExp() then
		arg0_93:emit(Dorm3dSceneMediator.FAVOR_LEVEL_UP, arg0_93.apartment.configId)
	end
end

function var0_0.PopFavorTrigger(arg0_94, arg1_94, arg2_94, arg3_94)
	if pg.dorm3d_favor_trigger[arg1_94].is_repeat > 0 then
		local var0_94 = arg3_94.daily - arg2_94
		local var1_94 = arg3_94.daily
		local var2_94 = getDorm3dGameset("daily_exp_max")[1]

		setText(arg0_94.rtFavorUpDaily:Find("info/Text"), i18n("xxx"))
		setText(arg0_94.rtFavorUpDaily:Find("info/count"), string.format("<color=#ffffff>%d</color>/%d", var1_94, var2_94))
		setSlider(arg0_94.rtFavorUpDaily:Find("slider/back"), 0, var2_94, var1_94)
		setSlider(arg0_94.rtFavorUpDaily:Find("slider/front"), 0, var2_94, var0_94)
		setActive(arg0_94.rtFavorUpDaily, true)
	else
		setText(arg0_94.rtFavorUp:Find("Text"), string.format("once plus %d", arg2_94))
		setActive(arg0_94.rtFavorUp, true)
	end
end

function var0_0.PopFavorLevelUp(arg0_95, arg1_95, arg2_95)
	eachChild(arg0_95.rtLevelUpWindow:Find("panel/mark/level"), function(arg0_96)
		setActive(arg0_96, arg0_96.name == tostring(arg1_95.level))
	end)
	setText(arg0_95.rtLevelUpWindow:Find("panel/info/Text"), arg1_95:getFavorConfig("levelup_trigger_mention"))
	setActive(arg0_95.rtLevelUpWindow, true)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_95.rtLevelUpWindow, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_DORM3D
	})

	function arg0_95.levelUpCallback()
		arg0_95.levelUpCallback = nil

		existCall(arg2_95)
	end
end

function var0_0.TalkingEventHandle(arg0_98, arg1_98)
	local var0_98 = {}
	local var1_98 = {}
	local var2_98 = arg1_98.data

	if var2_98.op_list then
		for iter0_98, iter1_98 in ipairs(var2_98.op_list) do
			table.insert(var0_98, function(arg0_99)
				if iter1_98.skip then
					arg0_99()

					arg0_99 = nil
				end

				switch(iter1_98.type, {
					action = function()
						arg0_98:emit(Dorm3dScene.PLAY_SINGLE_ACTION, iter1_98.name, arg0_99)
					end,
					timeline = function()
						arg0_98:emit(Dorm3dScene.PLAY_TIMELINE, iter1_98, function(arg0_102)
							var1_98.optionIndex = arg0_102.optionIndex

							existCall(arg0_99)
						end)
					end,
					clickOption = function()
						arg0_98:DoTalkTouchOption(iter1_98, arg1_98.flags, function(arg0_104)
							var1_98.optionIndex = arg0_104

							existCall(arg0_99)
						end)
					end,
					wait = function()
						arg0_98.LTs = arg0_98.LTs or {}

						table.insert(arg0_98.LTs, LeanTween.delayedCall(iter1_98.time, System.Action(function()
							existCall(arg0_99)
						end)).uniqueId)
					end
				}, function()
					assert(false, "op type error:", iter1_98.type)
				end)
			end)
		end
	end

	seriesAsync(var0_98, function()
		if arg1_98.callbackData then
			arg0_98:emit(Dorm3dSceneMediator.TALKING_EVENT_FINISH, arg1_98.callbackData.name, var1_98)
		end
	end)
end

function var0_0.GetFurnitureTalk(arg0_109, arg1_109)
	local var0_109 = arg0_109.apartment:getFurnitureTalking(arg1_109)

	return var0_109[math.random(#var0_109)]
end

function var0_0.EnterCheck(arg0_110)
	local var0_110 = {}

	if arg0_110.contextData.hasEnterCheck then
		arg0_110:CheckFavorTrigger()
	else
		arg0_110.contextData.hasEnterCheck = true

		if arg0_110.contextData.enterType == 1 then
			local var1_110 = arg0_110:GetEnterTalk()

			if var1_110 then
				table.insert(var0_110, function(arg0_111)
					arg0_110:DoTalk(var1_110, false, arg0_111)
				end)
			end

			seriesAsync(var0_110, function()
				arg0_110:CheckFavorTrigger()
			end)
		elseif arg0_110.contextData.enterType == 2 then
			local var2_110 = arg0_110.apartment:getZone(arg0_110.contextData.enterZone):getConfig("lazy_action")

			if var2_110 == "" then
				return
			end

			arg0_110:SetBlackboardValue("inLazy", true)
			arg0_110:emit(Dorm3dScene.SWITCH_ACTION, var2_110[3])
		else
			assert(false)
		end
	end
end

function var0_0.GetEnterTalk(arg0_113)
	local var0_113 = {}

	for iter0_113, iter1_113 in ipairs(arg0_113.apartment:getEnterTalking()) do
		local var1_113 = pg.dorm3d_dialogue_group[iter1_113]

		if var1_113.type == 104 and not pg.NewStoryMgr.GetInstance():IsPlayed(var1_113.story) then
			return iter1_113
		elseif var1_113.type == 105 and PlayerPrefs.GetString("DORM3D_DAILY_ENTER", "") ~= pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d") then
			PlayerPrefs.SetString("DORM3D_DAILY_ENTER", pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d"))

			return iter1_113
		elseif var1_113.type == 1053 and not pg.NewStoryMgr.GetInstance():IsPlayed(var1_113.story) then
			local var2_113 = getProxy(CollectionProxy):getShipGroup(arg0_113.apartment.configId)

			if var2_113 and var2_113.married > 0 then
				return iter1_113
			end
		elseif var1_113.type == 1052 and underscore.any(var1_113.trigger_config, function(arg0_114)
			return getProxy(ActivityProxy):IsActivityNotEnd(arg0_114)
		end) then
			table.insert(var0_113, iter1_113)
		elseif var1_113.type == 1051 and PlayerPrefs.GetInt("dorm3d_enter_count_" .. arg0_113.apartment.configId, 0) > var1_113.trigger_config[2] then
			table.insert(var0_113, iter1_113)
		end
	end

	return var0_113[math.random(#var0_113)]
end

function var0_0.EnterWatchMode(arg0_115)
	arg0_115:SetBlackboardValue("inWatchMode", true)
	arg0_115:SetUI("watch")
end

function var0_0.ExitWatchMode(arg0_116)
	arg0_116:SetBlackboardValue("inWatchMode", false)
	arg0_116:SetUI("base")
	arg0_116:CheckFavorTrigger()
end

function var0_0.GetZoneName(arg0_117)
	local var0_117 = arg0_117:GetBlackboardValue("inFurniture")

	return arg0_117.contextData.enterZone or var0_117 and var0_117.name or "Default"
end

function var0_0.TempHideUI(arg0_118, arg1_118)
	local var0_118 = defaultValue(arg0_118.hideCount, 0)

	arg0_118.hideCount = var0_118 + (arg1_118 and 1 or -1)

	assert(arg0_118.hideCount >= 0)

	if arg0_118.hideCount * var0_118 > 0 then
		return
	end

	local var1_118 = arg0_118.hideCount == 0 and arg0_118.uiState or nil

	eachChild(arg0_118.uiContianer, function(arg0_119)
		setActive(arg0_119, arg0_119.name == var1_118)
	end)
	setActive(arg0_118.rtFloatPage, arg0_118.hideCount == 0)
end

function var0_0.onBackPressed(arg0_120)
	if isActive(arg0_120.rtLevelUpWindow) then
		triggerButton(arg0_120.rtLevelUpWindow:Find("bg"))
	elseif arg0_120.uiState ~= "base" then
		triggerButton(arg0_120.uiContianer:Find(arg0_120.uiState .. "/btn_back"))
	else
		return false
	end

	return true
end

function var0_0.OnDestroy(arg0_121)
	arg0_121.cvLoader:Dispose()

	if arg0_121.floatTimer then
		arg0_121.floatTimer:Stop()
	end

	if arg0_121.LTs then
		underscore.map(arg0_121.LTs, function(arg0_122)
			LeanTween.cancel(arg0_122)
		end)

		arg0_121.LTs = nil
	end

	arg0_121:SetBlackboardValue("inLockLayer", nil)

	arg0_121.contextData.charFurnitureName = nil

	SetCompomentEnabled(arg0_121.rtMainAI, "BehaviourTreeOwner", false)
	pg.NodeCanvasMgr.GetInstance():Clear()
end

return var0_0
