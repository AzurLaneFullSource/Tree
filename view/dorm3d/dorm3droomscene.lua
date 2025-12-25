local var0_0 = class("Dorm3dRoomScene", import("view.dorm3d.Dorm3dRoomTemplateScene"))

var0_0.NOTIFY_UI_STATE = "Dorm3dRoomScene.NOTIFY_UI_STATE"

function var0_0.getUIName(arg0_1)
	return "Dorm3dMainUI"
end

function var0_0.SetRoom(arg0_2, arg1_2)
	var0_0.super.SetRoom(arg0_2, arg1_2)
	arg0_2:UpdateContactState()
end

function var0_0.SetApartment(arg0_3, arg1_3)
	arg0_3.apartment = arg1_3

	arg0_3:UpdateFavorDisplay()
end

function var0_0.init(arg0_4)
	var0_0.super.init(arg0_4)

	arg0_4.videoPlayer = VoiceChatLoader.New(arg0_4._tf)
	arg0_4.stockingView = Dorm3dStockingView.New(arg0_4._tf, arg0_4.event, setmetatable({}, {
		__index = arg0_4.contextData
	}))

	Shader.SetGlobalFloat("_ScreenClipOff", 1)

	arg0_4.uiContainer = arg0_4._tf:Find("UI")

	local var0_4 = arg0_4.uiContainer:Find("base")

	onButton(arg0_4, var0_4:Find("btn_back"), function()
		arg0_4:emit(BaseUI.ON_BACK)
	end, SFX_DORM_BACK)
	onButton(arg0_4, var0_4:Find("btn_back/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_dorm3d_info.tip
		})
	end, SFX_PANEL)

	arg0_4.rtFavorLevel = var0_4:Find("top/favor_level")

	setActive(arg0_4.rtFavorLevel, arg0_4.room:isPersonalRoom())
	onButton(arg0_4, arg0_4.rtFavorLevel, function()
		local var0_7 = {}

		arg0_4:emit(Dorm3dRoomMediator.OPEN_LEVEL_LAYER, {
			apartment = arg0_4.apartment,
			timeIndex = arg0_4.contextData.timeIndex,
			baseCamera = arg0_4.mainCameraTF,
			roomId = arg0_4.room:GetConfigID()
		})
	end, SFX_PANEL)
	onButton(arg0_4, var0_4:Find("top/setting"), function()
		arg0_4:emit(Dorm3dRoomMediator.OPEN_SETTING_LAYER)
	end)
	onButton(arg0_4, var0_4:Find("left/btn_photograph"), function()
		if #arg0_4.contextData.groupIds == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_photo_no_role"))

			return
		end

		local var0_9, var1_9 = arg0_4:CheckSystemOpen("Photo")

		if not var0_9 then
			pg.TipsMgr.GetInstance():ShowTips(var1_9)

			return
		end

		if not arg0_4.apartment then
			local var2_9 = arg0_4.contextData.groupIds[1]

			for iter0_9, iter1_9 in pairs(arg0_4.ladyDict) do
				if iter1_9.ladyBaseZone == arg0_4:GetAttachedFurnitureName() then
					var2_9 = iter0_9

					break
				end
			end

			arg0_4:SetApartment(getProxy(ApartmentProxy):getApartment(var2_9))
		end

		getProxy(Dorm3dChatProxy):TriggerEvent({
			{
				value = 1,
				event_type = arg0_4.contextData.timeIndex == 1 and 114 or 119,
				ship_id = arg0_4.apartment:GetConfigID()
			}
		})
		arg0_4:OutOfLazy(arg0_4.apartment:GetConfigID(), function()
			arg0_4:emit(Dorm3dRoomMediator.OPEN_CAMERA_LAYER, arg0_4, arg0_4.apartment:GetConfigID())
		end)
	end, SFX_PANEL)
	onButton(arg0_4, var0_4:Find("left/btn_collection"), function()
		local var0_11, var1_11 = arg0_4:CheckSystemOpen("Collection")

		if not var0_11 then
			pg.TipsMgr.GetInstance():ShowTips(var1_11)

			return
		end

		setActive(var0_4:Find("left/btn_collection/tip"), false)
		PlayerPrefs.SetInt("apartment_collection_item", 0)
		PlayerPrefs.SetInt("apartment_collection_recall", 0)
		arg0_4:emit(Dorm3dRoomMediator.OPEN_COLLECTION_LAYER, arg0_4.room:GetConfigID())
	end, SFX_PANEL)
	onButton(arg0_4, var0_4:Find("left/btn_furniture"), function()
		local var0_12, var1_12 = arg0_4:CheckSystemOpen("Furniture")

		if not var0_12 then
			pg.TipsMgr.GetInstance():ShowTips(var1_12)

			return
		end

		arg0_4:RemoveExtraSystem({
			SlideExtraSystem
		})
		arg0_4:emit(Dorm3dRoomMediator.OPEN_FURNITURE_SELECT, {
			apartment = arg0_4.apartment
		})

		arg0_4.isInFurnitureSelect = true
	end, SFX_PANEL)

	if not arg0_4.room:isPersonalRoom() then
		local var1_4 = arg0_4:CheckSystemOpen("Furniture")

		setActive(var0_4:Find("left/line_furniture"), var1_4)
		setActive(var0_4:Find("left/btn_furniture"), var1_4)
	end

	onButton(arg0_4, var0_4:Find("left/btn_accompany"), function()
		local var0_13, var1_13 = arg0_4:CheckSystemOpen("Accompany")

		if not var0_13 then
			pg.TipsMgr.GetInstance():ShowTips(var1_13)

			return
		end

		local var2_13 = arg0_4.apartment:GetConfigID()
		local var3_13

		arg0_4:emit(Dorm3dRoomMediator.OPEN_ACCOMPANY_WINDOW, {
			groupId = var2_13,
			confirmFunc = function(arg0_14)
				var3_13 = arg0_14
			end
		}, function()
			if var3_13 then
				arg0_4:OutOfLazy(var2_13, function()
					arg0_4:EnterAccompanyMode(var3_13)
				end)
			else
				arg0_4:CheckQueue()
			end
		end)
	end, SFX_PANEL)

	if not arg0_4.room:isPersonalRoom() then
		setActive(var0_4:Find("left/line_accompany"), false)
		setActive(var0_4:Find("left/btn_accompany"), false)
	end

	onButton(arg0_4, var0_4:Find("left/btn_skin"), function()
		arg0_4:ActiveCamera(arg0_4.cameras[var0_0.CAMERA.SKIN])
		arg0_4:emit(Dorm3dRoomMediator.OPEN_SKIN_SELECT_LAYER, arg0_4.apartment:GetConfigID(), arg0_4:GetCurrentLadyEnv(), nil, function()
			arg0_4:ChangePlayerPosition()
			arg0_4:ActiveCamera(arg0_4.cameras[var0_0.CAMERA.POV])
		end, false)
	end)

	if not arg0_4.room:isPersonalRoom() then
		setActive(var0_4:Find("left/line_skin"), false)
		setActive(var0_4:Find("left/btn_skin"), false)
	end

	onButton(arg0_4, var0_4:Find("left/btn_invite"), function()
		arg0_4:emit(Dorm3dRoomMediator.OPEN_INVITE_WINDOW, arg0_4.room:GetConfigID(), underscore.rest(arg0_4.contextData.groupIds, 1))
	end, SFX_PANEL)

	if arg0_4.room:isPersonalRoom() then
		setActive(var0_4:Find("left/line_invite"), false)
		setActive(var0_4:Find("left/btn_invite"), false)
	end

	arg0_4.btnZone = var0_4:Find("right/Zone")
	arg0_4.rtZoneList = var0_4:Find("right/Zone/List")

	setActive(arg0_4.rtZoneList, false)
	onButton(arg0_4, arg0_4.btnZone, function()
		setActive(arg0_4.rtZoneList, not isActive(arg0_4.rtZoneList))
	end, SFX_PANEL)
	UIItemList.StaticAlign(arg0_4.rtZoneList, arg0_4.rtZoneList:GetChild(0), #arg0_4.zoneDatas, function(arg0_21, arg1_21, arg2_21)
		if arg0_21 ~= UIItemList.EventUpdate then
			return
		end

		arg1_21 = arg1_21 + 1

		local var0_21 = arg0_4.zoneDatas[arg1_21]
		local var1_21 = var0_21:GetWatchCameraName()

		arg2_21.name = var1_21

		setText(arg2_21:Find("Name"), var0_21:GetName())
		setActive(arg2_21:Find("Line"), arg1_21 < #arg0_4.zoneDatas)
		onButton(arg0_4, arg2_21, function()
			if arg0_4.uiState ~= "base" then
				return
			end

			setActive(arg0_4.rtZoneList, false)
			arg0_4:ShiftZoneSafe(var1_21)
		end, SFX_PANEL)
	end)

	local var2_4 = arg0_4.uiContainer:Find("walk")
	local var3_4 = arg0_4.uiContainer:Find("ik")

	onButton(arg0_4, var3_4:Find("btn_back"), function()
		if arg0_4.ikSpecialCall then
			local var0_23 = arg0_4.ikSpecialCall

			arg0_4.ikSpecialCall = nil

			existCall(var0_23)
		else
			arg0_4:ExitTouchMode()
		end
	end, SFX_DORM_BACK)
	onButton(arg0_4, var3_4:Find("btn_back_heartbeat"), function()
		arg0_4:ExitHeartbeatMode()
	end, SFX_DORM_BACK)
	setActive(var3_4:Find("btn_back_heartbeat"), false)
	onButton(arg0_4, var3_4:Find("btn_back/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("roll_gametip")
		})
	end, SFX_PANEL)
	onButton(arg0_4, var3_4:Find("Right/btn_camera"), function()
		arg0_4:CycleIKCameraGroup()
	end, SFX_PANEL)
	onButton(arg0_4, var3_4:Find("Right/MenuSmall"), function()
		setActive(var3_4:Find("Right/MenuSmall"), false)
		setActive(var3_4:Find("Right/Menu"), true)
	end, SFX_PANEL)
	onButton(arg0_4, var3_4:Find("Right/Menu/Collapse"), function()
		setActive(var3_4:Find("Right/Menu"), false)
		setActive(var3_4:Find("Right/MenuSmall"), true)
	end, SFX_PANEL)
	onButton(arg0_4, var3_4:Find("Right/Menu"), function()
		setActive(var3_4:Find("Right"), false)
		arg0_4:emit(Dorm3dRoomMediator.OPEN_SKIN_SELECT_LAYER, arg0_4.apartment:GetConfigID(), arg0_4:GetCurrentLadyEnv(), function(arg0_30, arg1_30, arg2_30)
			seriesAsync({
				function(arg0_31)
					arg0_4:SetIKState(false, arg0_31)
				end,
				function(arg0_32)
					arg0_30:SwitchCharacterSkin(arg1_30, arg2_30)
					arg0_4:SwitchIKConfig(arg0_30, arg0_30.ikConfig.id)
					arg0_4:SetIKState(true, arg0_32)
				end
			})
		end, function()
			setActive(var3_4:Find("Right"), true)
		end, true)
	end, SFX_PANEL)

	local var4_4 = arg0_4._tf:Find("IKControl")

	arg0_4.ikTipsRoot = var4_4:Find("Tips")

	setActive(arg0_4.ikTipsRoot, false)

	arg0_4.ikClickTipsRoot = var4_4:Find("ClickTips")

	setActive(arg0_4.ikClickTipsRoot, false)

	arg0_4.ikHand = var4_4:Find("Handler")

	setActive(arg0_4.ikHand, false)
	eachChild(arg0_4.ikHand, function(arg0_34)
		setActive(arg0_34, false)
	end)

	arg0_4.ikTextTipsRoot = var4_4:Find("TextTips")

	setActive(arg0_4.ikTextTipsRoot, false)
	eachChild(arg0_4.ikTextTipsRoot, function(arg0_35)
		setActive(arg0_35, false)
	end)

	arg0_4.ikControlUI = var4_4

	local var5_4 = arg0_4.uiContainer:Find("accompany")

	onButton(arg0_4, var5_4:Find("btn_back"), function()
		arg0_4:ExitAccompanyMode()
	end, SFX_DORM_BACK)

	arg0_4.unlockList = {}
	arg0_4.rtFavorUp = arg0_4._tf:Find("Toast/favor_up")

	arg0_4.rtFavorUp:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_37)
		setActive(arg0_4.rtFavorUp, false)

		if #arg0_4.unlockList > 0 then
			setText(arg0_4.rtFavorUp:Find("Text"), table.remove(arg0_4.unlockList, 1))
			setActive(arg0_4.rtFavorUp, true)
		end
	end)
	setActive(arg0_4.rtFavorUp, false)

	arg0_4.rtFavorUpDaily = arg0_4._tf:Find("Toast/favor_up_daily")

	setActive(arg0_4.rtFavorUpDaily, false)

	arg0_4.rtStaminaPop = arg0_4._tf:Find("Toast/stamina")

	local var6_4 = arg0_4.rtStaminaPop:GetComponent("DftAniEvent")

	var6_4:SetTriggerEvent(function(arg0_38)
		local var0_38, var1_38 = getProxy(ApartmentProxy):getStamina()

		setText(arg0_4.rtStaminaPop:Find("Text"), string.format("%d/%d", var0_38, var1_38))
	end)
	var6_4:SetEndEvent(function(arg0_39)
		setActive(arg0_4.rtStaminaPop, false)
	end)
	setActive(arg0_4.rtStaminaPop, false)

	arg0_4.rtLevelUpWindow = arg0_4._tf:Find("LevelUpWindow")

	setActive(arg0_4.rtLevelUpWindow, false)
	onButton(arg0_4, arg0_4.rtLevelUpWindow:Find("bg"), function()
		if arg0_4.isLock then
			return
		end

		arg0_4.isLock = true

		quickPlayAnimation(arg0_4.rtLevelUpWindow, "anim_dorm3d_levelup_out")
		LeanTween.delayedCall(0.2, System.Action(function()
			arg0_4.isLock = false

			setActive(arg0_4.rtLevelUpWindow, false)
			arg0_4:UnOverlayPanel(arg0_4.rtLevelUpWindow, arg0_4._tf)
			existCall(arg0_4.levelUpCallback)
		end))
	end, SFX_PANEL)

	local var7_4 = arg0_4.uiContainer:Find("watch")

	onButton(arg0_4, var7_4:Find("btn_back"), function()
		arg0_4:ExitWatchMode()
	end, SFX_DORM_BACK)
	onButton(arg0_4, var7_4:Find("btn_back/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("roll_gametip")
		})
	end, SFX_PANEL)

	arg0_4.rtStaminaDisplay = var7_4:Find("stamina")
	arg0_4.rtRole = arg0_4.uiContainer:Find("watch/Role")

	onButton(arg0_4, arg0_4.rtRole:Find("Talk"), function()
		local var0_44 = arg0_4:GetCurrentLadyEnv().ladyBaseZone
		local var1_44 = arg0_4.apartment:getFurnitureTalking(arg0_4.room:GetConfigID(), var0_44)

		if #var1_44 == 0 then
			pg.TipsMgr.GetInstance():ShowTips("without topic")

			return
		end

		arg0_4:DoTalk(var1_44[math.random(#var1_44)], function()
			local var0_45 = getDorm3dGameset("drom3d_favir_trigger_talk")[1]

			arg0_4:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_4.apartment.configId, var0_45)
		end)
	end, SFX_DORM_CLICK)
	setText(arg0_4.rtRole:Find("Talk/bg/Text"), i18n("dorm3d_talk"))

	arg0_4.rtRoleTouchSubView = Dorm3dRTRoleTouchSubView.New(arg0_4.rtRole:Find("Touch"), arg0_4.event, setmetatable({
		onClick = function(arg0_46)
			arg0_4:EnterTouchMode(arg0_46)
		end
	}, {
		__index = arg0_4.contextData
	}))

	onButton(arg0_4, arg0_4.rtRole:Find("Gift"), function()
		arg0_4:emit(arg0_4.SHOW_BLOCK)
		arg0_4:ActiveStateCamera("gift", function()
			arg0_4:emit(arg0_4.HIDE_BLOCK)
		end)
		arg0_4:emit(Dorm3dRoomMediator.OPEN_GIFT_LAYER, {
			groupId = arg0_4.apartment:GetConfigID(),
			baseCamera = arg0_4.mainCameraTF
		})
	end, SFX_DORM_CLICK)
	setText(arg0_4.rtRole:Find("Gift/bg/Text"), i18n("dorm3d_gift"))
	onButton(arg0_4, arg0_4.rtRole:Find("MiniGame"), function()
		assert(not arg0_4.nowMiniGameId)

		arg0_4.nowMiniGameId = arg0_4.room:getMiniGames()[1]

		local var0_49 = pg.dorm3d_minigame[arg0_4.nowMiniGameId]
		local var1_49 = arg0_4:GetCurrentLadyEnv()

		getProxy(Dorm3dChatProxy):TriggerEvent({
			{
				value = 1,
				event_type = arg0_4.contextData.timeIndex == 1 and 112 or 117,
				ship_id = arg0_4.apartment:GetConfigID()
			},
			{
				value = 1,
				event_type = 158,
				ship_id = arg0_4.apartment:GetConfigID()
			}
		})

		local var2_49 = {}

		table.insert(var2_49, function(arg0_50)
			arg0_4:SetAllBlackbloardValue("inLockLayer", true)
			arg0_4:TempHideUI(true, arg0_50)
		end)

		if var0_49.area ~= "" and var1_49.ladyBaseZone ~= var0_49.area then
			table.insert(var2_49, function(arg0_51)
				arg0_4:ShiftZone(var0_49.area, arg0_51)
			end)
		end

		local var3_49
		local var4_49

		if var0_49.action ~= "" then
			var3_49, var4_49 = unpack(var0_49.action)
		end

		table.insert(var2_49, function(arg0_52)
			parallelAsync({
				function(arg0_53)
					if var3_49 then
						arg0_4:PlaySingleAction(var1_49, var3_49, arg0_53)
					else
						arg0_53()
					end
				end,
				function(arg0_54)
					arg0_4:ActiveStateCamera("talk", arg0_54)
				end
			}, arg0_52)
		end)
		table.insert(var2_49, function(arg0_55)
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataMiniGame(1))
			arg0_4:HandleGameNotification(Dorm3dMiniGameMediator.OPERATION, {
				operationCode = "BEFORE_OPEN_GAME",
				miniGameId = arg0_4.nowMiniGameId
			})
			arg0_4:EnableMiniGameCutIn()
			arg0_4:emit(Dorm3dRoomMediator.OPEN_MINIGAME_WINDOW, {
				isDorm3d = true,
				minigameId = arg0_4.nowMiniGameId
			}, arg0_55)
		end)
		table.insert(var2_49, function(arg0_56)
			arg0_4:DisableMiniGameCutIn()

			if var4_49 then
				arg0_4:PlaySingleAction(var1_49, var4_49, arg0_56)
			else
				arg0_56()
			end
		end)
		seriesAsync(var2_49, function()
			arg0_4:SetAllBlackbloardValue("inLockLayer", false)
			arg0_4:TempHideUI(false)

			arg0_4.nowMiniGameId = nil
		end)
	end, SFX_DORM_CLICK)
	setText(arg0_4.rtRole:Find("MiniGame/bg/Text"), i18n("dorm3d_minigame_button1"))

	if not arg0_4.room:isPersonalRoom() then
		onButton(arg0_4, arg0_4.rtRole:Find("PublicGame"), switch(arg0_4.room.id, {
			[4] = function()
				return function()
					arg0_4:emit(Dorm3dRoomMediator.ENTER_VOLLEYBALL, arg0_4.apartment:GetConfigID())
				end
			end,
			[16] = function()
				return function()
					arg0_4:emit(Dorm3dRoomMediator.ENTER_DANCE, arg0_4.apartment:GetConfigID())
				end
			end
		}), SFX_DORM_CLICK)
		setText(arg0_4.rtRole:Find("PublicGame/bg/Text"), switch(arg0_4.room.id, {
			[4] = function()
				return i18n("dorm3d_volleyball_button")
			end,
			[16] = function()
				return i18n("dorm3d_dance_button")
			end
		}))
	end

	onButton(arg0_4, arg0_4.rtRole:Find("Performance"), function()
		arg0_4:DoTalk(20500, function()
			pg.TipsMgr.GetInstance():ShowTips("Success!")
		end)
	end, SFX_DORM_CLICK)

	arg0_4.rtFloatPage = arg0_4._tf:Find("FloatPage")
	arg0_4.tplFloat = arg0_4.rtFloatPage:Find("tpl")

	setActive(arg0_4.tplFloat, false)

	local var8_4 = cloneTplTo(arg0_4.tplFloat, arg0_4.rtFloatPage, "lady")

	eachChild(var8_4, function(arg0_66)
		setActive(arg0_66, arg0_66.name == "walk")
	end)

	arg0_4._joystick = arg0_4._tf:Find("Stick")

	setActive(arg0_4._joystick, false)
	arg0_4._joystick:GetComponent(typeof(SlideController)):SetStickFunc(function(arg0_67)
		arg0_4:emit(arg0_4.ON_STICK_MOVE, arg0_67)
	end)

	arg0_4.povLayer = arg0_4._tf:Find("POVControl")

	setActive(arg0_4.povLayer, false)
	;(function()
		local var0_68 = arg0_4.povLayer:Find("Move"):GetComponent(typeof(SlideController))

		var0_68:AddBeginDragFunc(function(arg0_69, arg1_69)
			arg0_4:emit(arg0_4.ON_POV_STICK_MOVE_BEGIN, arg1_69)
		end)
		var0_68:SetStickFunc(function(arg0_70)
			arg0_4:emit(arg0_4.ON_POV_STICK_MOVE, arg0_70)
		end)
		var0_68:AddDragEndFunc(function(arg0_71, arg1_71)
			arg0_4:emit(arg0_4.ON_POV_STICK_MOVE_END, arg1_71)
		end)
		arg0_4.povLayer:Find("View"):GetComponent(typeof(SlideController)):SetStickFunc(function(arg0_72)
			arg0_4:emit(arg0_4.ON_POV_STICK_VIEW, arg0_72)
		end)
	end)()

	arg0_4.ikControlLayer = var4_4:Find("ControlLayer")

	;(function()
		local var0_73
		local var1_73 = arg0_4.ikControlLayer:GetComponent(typeof(SlideController))

		var1_73:AddBeginDragFunc(function(arg0_74, arg1_74)
			local var0_74 = arg0_4:GetCurrentLadyEnv()

			if not var0_74.IKSettings then
				return
			end

			local var1_74 = arg1_74.position
			local var2_74 = CameraMgr.instance:Raycast(var0_74.IKSettings.CameraRaycaster, var1_74):ToTable()

			if #var2_74 > 0 then
				local var3_74 = var2_74[1].gameObject.transform
				local var4_74 = table.keyof(var0_74.IKSettings.Colliders, var3_74)

				warning(var3_74, var4_74)

				if var4_74 then
					arg0_4:emit(var0_0.ON_BEGIN_DRAG_CHARACTER_BODY, var0_74, var4_74, var1_74)

					var0_73 = tobool(var0_74.ikHandler)

					return
				end
			end
		end)
		var1_73:AddDragFunc(function(arg0_75, arg1_75)
			local var0_75 = arg1_75.position
			local var1_75 = arg0_4:GetCurrentLadyEnv()

			if var1_75.ikHandler then
				arg0_4:emit(var0_0.ON_DRAG_CHARACTER_BODY, var1_75, var0_75)

				return
			end

			if var0_73 then
				return
			end

			local var2_75 = arg1_75.delta

			arg0_4:emit(arg0_4.ON_STICK_MOVE, var2_75)
		end)
		var1_73:AddDragEndFunc(function(arg0_76, arg1_76)
			var0_73 = nil

			local var0_76 = arg0_4:GetCurrentLadyEnv()

			if var0_76.ikHandler then
				arg0_4:emit(var0_0.ON_RELEASE_CHARACTER_BODY, var0_76)

				return
			end
		end)
	end)()

	arg0_4.rtExtraScreen = arg0_4._tf:Find("ExtraScreen")
	arg0_4.rtTouchGamePanel = arg0_4.rtExtraScreen:Find("TouchGame")
	arg0_4.rtTimelineScreen = arg0_4.rtExtraScreen:Find("TimelineScreen")

	onButton(arg0_4, arg0_4.rtTimelineScreen:Find("btn_skip"), function()
		existCall(arg0_4.timelineFinishCall)
	end, SFX_CANCEL)

	arg0_4.uiStack = {}
	arg0_4.uiStore = {}
end

function var0_0.BindEvent(arg0_78)
	var0_0.super.BindEvent(arg0_78)
	arg0_78:bind(arg0_78.CLICK_CHARACTER, function(arg0_79, arg1_79)
		if arg0_78.uiState ~= "base" or not arg0_78.ladyDict[arg1_79].nowCanWatchState then
			return
		end

		local var0_79 = {}
		local var1_79 = arg0_78.ladyDict[arg1_79]

		if arg0_78:GetBlackboardValue(var1_79, "inPending") then
			table.insert(var0_79, function(arg0_80)
				arg0_78:OutOfPending(arg1_79, arg0_80)
			end)
		else
			table.insert(var0_79, function(arg0_81)
				arg0_78:OutOfLazy(arg1_79, arg0_81)
			end)
		end

		seriesAsync(var0_79, function()
			if not arg0_78.room:isPersonalRoom() then
				arg0_78:SetApartment(getProxy(ApartmentProxy):getApartment(arg1_79))
			end

			arg0_78:EnterWatchMode()
		end)
		pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_touch_v1")
	end)
	arg0_78:bind(arg0_78.CLICK_CONTACT, function(arg0_83, arg1_83)
		arg0_78:TriggerContact(arg1_83)
	end)
	arg0_78:bind(arg0_78.DISTANCE_TRIGGER, function(arg0_84, arg1_84, arg2_84)
		if arg0_78.uiState == "base" then
			arg0_78:CheckDistanceTalk(arg1_84, arg2_84)
		end
	end)
	arg0_78:bind(arg0_78.WALK_DISTANCE_TRIGGER, function(arg0_85, arg1_85, arg2_85)
		if arg0_78.apartment and arg0_78.apartment:GetConfigID() == arg1_85 then
			existCall(arg0_78.walkNearCallback, arg2_85)
		end
	end)
	arg0_78:bind(arg0_78.CHANGE_WATCH, function(arg0_86, arg1_86)
		arg0_78:ChangeCanWatchState(arg0_78.ladyDict[arg1_86])
	end)
	arg0_78:bind(arg0_78.ON_TOUCH_CHARACTER, function(arg0_87, arg1_87)
		local var0_87 = arg0_78:GetCurrentLadyEnv()

		if not arg0_78:GetBlackboardValue(var0_87, "inIK") then
			return
		end

		arg0_78:OnTouchCharacterBody(arg1_87)
	end)
	arg0_78:bind(var0_0.ON_IK_STATUS_CHANGED, function(arg0_88, arg1_88, arg2_88)
		local var0_88 = arg0_78:GetCurrentLadyEnv()

		if not arg0_78:GetBlackboardValue(var0_88, "inTouching") then
			return
		end

		arg0_78:DoTouch(arg1_88, arg2_88)
	end)
	arg0_78:bind(arg0_78.ON_ENTER_SECTOR, function(arg0_89, arg1_89)
		arg0_78:ChangeCanWatchState(arg0_78.ladyDict[arg1_89])
	end)
	arg0_78:bind(arg0_78.ON_CHANGE_DISTANCE, function(arg0_90, arg1_90, arg2_90)
		arg0_78:ChangeCanWatchState(arg0_78.ladyDict[arg1_90])
	end)
end

function var0_0.didEnter(arg0_91)
	arg0_91.resumeCallback = arg0_91.contextData.resumeCallback
	arg0_91.contextData.resumeCallback = nil

	var0_0.super.didEnter(arg0_91)
	arg0_91:UpdateZoneList()
	arg0_91:SetUI(function()
		arg0_91:didEnterCheck()
	end, "base")
end

function var0_0.FinishEnterResume(arg0_93)
	if not arg0_93.resumeCallback then
		return
	end

	local var0_93 = arg0_93.resumeCallback

	arg0_93.resumeCallback = nil

	return var0_93()
end

function var0_0.EnableJoystick(arg0_94, arg1_94)
	setActive(arg0_94._joystick, arg1_94)
end

function var0_0.EnablePOVLayer(arg0_95, arg1_95)
	setActive(arg0_95.povLayer, arg1_95)

	if not arg1_95 then
		arg0_95:emit(arg0_95.ON_POV_STICK_MOVE_END)
	end
end

function var0_0.SetUIStore(arg0_96, arg1_96, ...)
	table.insertto(arg0_96.uiStore, {
		...
	})
	existCall(arg1_96)
end

function var0_0.SetUI(arg0_97, arg1_97, ...)
	warning("SetUI", ...)

	while rawget(arg0_97, "class") ~= var0_0 do
		arg0_97 = getmetatable(arg0_97).__index
	end

	table.insertto(arg0_97.uiStore, {
		...
	})

	for iter0_97, iter1_97 in ipairs(arg0_97.uiStore) do
		if iter1_97 == "back" then
			assert(#arg0_97.uiStack > 0)

			arg0_97.uiState = table.remove(arg0_97.uiStack)
		elseif iter1_97 == arg0_97.uiState and iter1_97 == "ik" then
			-- block empty
		else
			table.insert(arg0_97.uiStack, arg0_97.uiState)

			arg0_97.uiState = iter1_97
		end
	end

	pg.m02:sendNotification(var0_0.NOTIFY_UI_STATE, arg0_97.uiState)

	arg0_97.uiStore = {}

	eachChild(arg0_97.uiContainer, function(arg0_98)
		setActive(arg0_98, arg0_98.name == arg0_97.uiState)
	end)
	arg0_97:EnablePOVLayer(arg0_97.uiState == "base" or arg0_97.uiState == "walk")
	arg0_97:TempHideContact(arg0_97.uiState ~= "base")
	arg0_97:SetFloatEnable(arg0_97.uiState == "walk")
	setActive(arg0_97.rtFloatPage, arg0_97.uiState == "walk")
	setActive(arg0_97.ikControlUI, arg0_97.uiState == "ik")

	if arg0_97.uiState ~= "stocking" then
		arg0_97.stockingView:Hide()
	end

	warning("SetUI to ", arg0_97.uiState)
	switch(arg0_97.uiState, {
		base = function()
			if not arg0_97.room:isPersonalRoom() then
				arg0_97:SetApartment(nil)
			end

			arg0_97:UpdateBtnState()
		end,
		watch = function()
			eachChild(arg0_97.rtRole, function(arg0_101)
				setActive(arg0_101, false)
			end)

			local var0_100 = underscore.filter({
				"Talk",
				"Touch",
				"Gift",
				"MiniGame",
				"PublicGame",
				"Performance"
			}, function(arg0_102)
				return arg0_97:CheckSystemOpen(arg0_102)
			end)
			local var1_100 = 0.05

			for iter0_100, iter1_100 in ipairs(var0_100) do
				LeanTween.delayedCall(var1_100, System.Action(function()
					setActive(arg0_97.rtRole:Find(iter1_100), true)

					if iter1_100 == "Touch" then
						local var0_103 = arg0_97.apartment:GetConfigID()

						arg0_97.rtRoleTouchSubView:Flush(arg0_97.room, var0_103, arg0_97.ladyDict[var0_103].ladyBaseZone)
					end
				end))

				var1_100 = var1_100 + 0.066
			end

			setActive(arg0_97.rtRole:Find("Gift/bg/Tip"), Dorm3dGift.NeedViewTip(arg0_97.apartment:GetConfigID()))
		end,
		ik = function()
			setActive(arg0_97.uiContainer:Find("ik/Right/MenuSmall"), arg0_97.room:isPersonalRoom() and not arg0_97.performanceInfo)
			setActive(arg0_97.uiContainer:Find("ik/Right/Menu"), false)
		end,
		walk = function()
			setText(arg0_97.uiContainer:Find("walk/dialogue/content"), i18n("dorm3d_removable", arg0_97.apartment:getConfig("name")))
		end,
		stocking = function()
			arg0_97.stockingView:Show()
		end
	})
	arg0_97:ActiveStateCamera(arg0_97.uiState, function()
		if arg1_97 then
			arg1_97()
		elseif arg0_97.uiState == "base" then
			arg0_97:CheckQueue()
		end
	end)
end

function var0_0.EnterWatchMode(arg0_108)
	local var0_108 = arg0_108.apartment:GetConfigID()

	seriesAsync({
		function(arg0_109)
			arg0_108:emit(arg0_108.SHOW_BLOCK)
			arg0_108:SetBlackboardValue(arg0_108.ladyDict[var0_108], "inWatchMode", true)
			arg0_108:SetUI(arg0_109, "watch")
		end,
		function(arg0_110)
			arg0_108:emit(arg0_108.HIDE_BLOCK)
		end
	})
end

function var0_0.ExitWatchMode(arg0_111)
	local var0_111 = arg0_111.apartment:GetConfigID()

	seriesAsync({
		function(arg0_112)
			arg0_111:emit(arg0_111.SHOW_BLOCK)
			arg0_111:SetUI(arg0_112, "back")
		end,
		function(arg0_113)
			arg0_111:SetBlackboardValue(arg0_111.ladyDict[var0_111], "inWatchMode", false)
			arg0_111:emit(arg0_111.HIDE_BLOCK)
			arg0_111:CheckQueue()
		end
	})
end

function var0_0.SetInPending(arg0_114, arg1_114, arg2_114)
	local var0_114 = arg0_114:GetBlackboardValue(arg1_114, "groupId")
	local var1_114 = pg.dorm3d_welcome[arg2_114]

	arg0_114:SetBlackboardValue(arg1_114, "inPending", true)
	arg0_114:ChangeCanWatchState(arg1_114)
	arg0_114:EnableHeadIK(arg1_114, false)

	arg0_114.contextData.ladyZone[var0_114] = var1_114.area

	arg1_114:SetZone(arg0_114.contextData.ladyZone[var0_114], var1_114.welcome_staypoint)
	arg0_114:ChangeCharacterPosition(arg1_114)

	if var1_114.item_shield ~= "" then
		arg0_114.hideItemDic = {}

		for iter0_114, iter1_114 in ipairs(var1_114.item_shield) do
			local var2_114 = arg0_114.modelRoot:Find(iter1_114)

			if not var2_114 then
				warning(string.format("welcome:%d without hide item:%s", arg2_114, iter1_114))
			else
				arg0_114.hideItemDic[iter1_114] = isActive(var2_114)

				setActive(var2_114, false)
			end
		end
	end

	onNextTick(function()
		if arg1_114.tfPendintItem then
			setActive(arg1_114.tfPendintItem, true)
		end

		arg0_114:SwitchAnim(arg1_114, var1_114.welcome_idle)
	end)

	arg0_114.wakeUpTalkId = var1_114.welcome_talk
end

function var0_0.SetOutPending(arg0_116, arg1_116)
	arg0_116:SetBlackboardValue(arg1_116, "inPending", false)
	arg0_116:ChangeCanWatchState(arg1_116)
	arg0_116:EnableHeadIK(arg1_116, true)

	arg0_116.wakeUpTalkId = nil

	if arg1_116.tfPendintItem then
		setActive(arg1_116.tfPendintItem, false)
	end

	if arg0_116.hideItemDic then
		for iter0_116, iter1_116 in pairs(arg0_116.hideItemDic) do
			setActive(arg0_116.modelRoot:Find(iter0_116), iter1_116)
		end

		arg0_116.hideItemDic = nil
	end
end

function var0_0.IsModeInHidePending(arg0_117, arg1_117)
	for iter0_117, iter1_117 in pairs(arg0_117.ladyDict) do
		if iter1_117.hideItemDic and iter1_117.hideItemDic[arg1_117] ~= nil then
			return true
		end
	end

	return false
end

function var0_0.EnterAccompanyMode(arg0_118, arg1_118)
	local var0_118 = pg.dorm3d_accompany[arg1_118]
	local var1_118
	local var2_118

	if var0_118.sceneInfo ~= "" then
		var1_118, var2_118 = unpack(string.split(var0_118.sceneInfo, "|"))
	end

	local var3_118 = {
		type = "timeline",
		name = var0_118.timeline,
		scene = var1_118,
		sceneRoot = var2_118,
		accompanys = {}
	}

	for iter0_118, iter1_118 in ipairs(var0_118.jump_trigger) do
		local var4_118, var5_118 = unpack(iter1_118)

		var3_118.accompanys[var4_118] = var5_118
	end

	local var6_118, var7_118 = unpack(var0_118.favor)

	getProxy(Dorm3dChatProxy):TriggerEvent({
		{
			value = 1,
			event_type = 161,
			ship_id = arg0_118.apartment:GetConfigID()
		}
	})
	getProxy(ApartmentProxy):RecordAccompanyTime()
	pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataAccompany(1, var0_118.ship_id, var0_118.performance_time, 0, var1_118 or arg0_118.dormSceneMgr.artSceneInfo))

	local var8_118 = {}

	table.insert(var8_118, function(arg0_119)
		arg0_118:SetUI(arg0_119, "blank", "accompany")
	end)
	table.insert(var8_118, function(arg0_120)
		arg0_118.accompanyFavorCount = 0
		arg0_118.accompanyFavorTimer = Timer.New(function()
			arg0_118.accompanyFavorCount = arg0_118.accompanyFavorCount + 1
		end, var6_118, -1)

		arg0_118.accompanyFavorTimer:Start()

		arg0_118.accompanyPerformanceTimer = Timer.New(function()
			arg0_118.canTriggerAccompanyPerformance = true
		end, var0_118.performance_time, -1)

		arg0_118.accompanyPerformanceTimer:Start()
		arg0_118:PlayTimeline(var3_118, function(arg0_123, arg1_123)
			arg1_123()
			arg0_120()
		end)
	end)
	seriesAsync(var8_118, function()
		assert(arg0_118.accompanyFavorTimer)
		arg0_118.accompanyFavorTimer:Stop()

		arg0_118.accompanyFavorTimer = nil

		assert(arg0_118.accompanyPerformanceTimer)
		arg0_118.accompanyPerformanceTimer:Stop()

		arg0_118.accompanyPerformanceTimer = nil
		arg0_118.canTriggerAccompanyPerformance = nil

		local var0_124 = math.min(arg0_118.accompanyFavorCount, getProxy(ApartmentProxy):getStamina())

		if var0_124 > 0 then
			local var1_124 = var7_118[var0_124]

			warning(var1_124)
			arg0_118:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_118.apartment.configId, var1_124)
		end

		local var2_124 = 0
		local var3_124 = getProxy(ApartmentProxy):GetAccompanyTime()

		if var3_124 then
			var2_124 = pg.TimeMgr.GetInstance():GetServerTime() - var3_124
		end

		pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataAccompany(2, var0_118.ship_id, var0_118.performance_time, var2_124, var1_118 or arg0_118.dormSceneMgr.artSceneInfo))
		arg0_118:SetUI(nil, "back", "back")
	end)
end

function var0_0.ExitAccompanyMode(arg0_125)
	existCall(arg0_125.timelineFinishCall)
end

function var0_0.EnterTouchPerformance(arg0_126)
	local var0_126 = arg0_126:GetCurrentLadyEnv()
	local var1_126 = arg0_126.room:getApartmentZoneConfig(var0_126.ladyBaseZone, "touch_performance", arg0_126.apartment:GetConfigID())

	if not var1_126 or var1_126 == 0 then
		arg0_126:EnterTouchMode()
	else
		arg0_126:DoTalk(var1_126)
	end
end

function var0_0.EnterTouchMode(arg0_127, arg1_127)
	local var0_127 = arg0_127:GetCurrentLadyEnv()

	if arg0_127:GetBlackboardValue(var0_127, "inTouching") then
		return
	end

	arg1_127 = arg1_127 or arg0_127.room:getApartmentZoneConfig(var0_127.ladyBaseZone, "touch_id", arg0_127.apartment:GetConfigID())
	arg0_127.touchConfig = pg.dorm3d_touch_data[arg1_127]

	if not arg0_127.touchConfig then
		warning("dorm3d_touch_data no config for id:" .. tostring(arg1_127))

		return
	end

	arg0_127.inTouchGame = arg0_127.touchConfig.heartbeat_enable > 0

	setActive(arg0_127.rtTouchGamePanel, arg0_127.inTouchGame)

	if arg0_127.inTouchGame then
		arg0_127.touchCount = 0
		arg0_127.touchLevel = 1
		arg0_127.lastCount = 0
		arg0_127.topCount = 0

		arg0_127:UpdateTouchGameDisplay()
		setSlider(arg0_127.rtTouchGamePanel:Find("slider"), 0, 100, arg0_127.touchCount >= 200 and 100 or arg0_127.touchCount % 100)
		quickPlayAnimation(arg0_127.rtTouchGamePanel, "anim_dorm3d_touch_in")
		quickPlayAnimation(arg0_127.rtTouchGamePanel:Find("slider/icon"), "anim_dorm3d_touch_icon")

		arg0_127.downTimer = Timer.New(function()
			local var0_128 = pg.dorm3d_set.reduce_interaction.key_value_int

			if arg0_127.touchLevel > 1 then
				var0_128 = pg.dorm3d_set.reduce_heartbeat.key_value_int
			end

			arg0_127:UpdateTouchCount(var0_128)
		end, 1, -1)

		arg0_127.downTimer:Start()
	end

	local var1_127 = {}

	table.insert(var1_127, function(arg0_129)
		arg0_127:SetBlackboardValue(var0_127, "inTouching", true)
		arg0_127:emit(arg0_127.SHOW_BLOCK)
		arg0_127:SetUI(arg0_129, "blank")
	end)
	table.insert(var1_127, function(arg0_130)
		local var0_130 = arg0_127.touchConfig.ik_status[1]

		arg0_127:SwitchIKConfig(var0_127, var0_130)
		setActive(arg0_127.uiContainer:Find("ik/btn_back"), true)
		arg0_127:SetIKState(true, arg0_130)
	end)
	table.insert(var1_127, function(arg0_131)
		existCall(arg0_131)
	end)
	seriesAsync(var1_127, function()
		Shader.SetGlobalFloat("_ScreenClipOff", 0)
		arg0_127:emit(arg0_127.HIDE_BLOCK)
	end)
end

function var0_0.ExitTouchMode(arg0_133)
	local var0_133 = arg0_133:GetCurrentLadyEnv()

	if not arg0_133:GetBlackboardValue(var0_133, "inTouching") then
		return
	end

	local var1_133 = {}

	if arg0_133.inTouchGame then
		table.insert(var1_133, function(arg0_134)
			arg0_133:emit(arg0_133.SHOW_BLOCK)
			quickPlayAnimation(arg0_133.rtTouchGamePanel, "anim_dorm3d_touch_out")
			onDelayTick(arg0_134, 0.5)
		end)
		table.insert(var1_133, function(arg0_135)
			local var0_135 = 0

			for iter0_135, iter1_135 in ipairs(arg0_133.touchConfig.heartbeat_favor) do
				if iter1_135[1] > arg0_133.topCount then
					break
				else
					var0_135 = iter1_135[2]
				end
			end

			if var0_135 > 0 then
				arg0_133:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_133.apartment.configId, var0_135)
			end

			arg0_133.touchCount = nil
			arg0_133.touchLevel = nil
			arg0_133.topCount = nil

			if arg0_133.downTimer then
				arg0_133.downTimer:Stop()

				arg0_133.downTimer = nil
			end

			arg0_133.inTouchGame = false

			setActive(arg0_133.rtTouchGamePanel, false)
			Shader.SetGlobalFloat("_ScreenClipOff", 1)
			arg0_135()
		end)
	else
		table.insert(var1_133, function(arg0_136)
			arg0_133:emit(arg0_133.SHOW_BLOCK)

			local var0_136 = arg0_133.touchConfig.default_favor

			if var0_136 > 0 then
				arg0_133:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_133.apartment.configId, var0_136)
			end

			Shader.SetGlobalFloat("_ScreenClipOff", 1)
			arg0_136()
		end)
	end

	table.insert(var1_133, function(arg0_137)
		var0_133.ikConfig = {
			character_position = var0_133.ladyBaseZone,
			character_action = arg0_133.touchConfig.finish_action
		}

		arg0_133:emit(Dorm3dStockingMgr.ON_EXIT_TOUCH_MODE)
		arg0_133:SetIKState(false, arg0_137)
	end)
	table.insert(var1_133, function(arg0_138)
		var0_133.ikConfig = nil
		arg0_133.blockIK = nil

		arg0_133:SetUI(arg0_138, "back")
	end)
	seriesAsync(var1_133, function()
		arg0_133:SetBlackboardValue(var0_133, "inTouching", false)
		arg0_133:emit(arg0_133.HIDE_BLOCK)

		arg0_133.touchConfig = nil

		local var0_139 = arg0_133.touchExitCall

		arg0_133.touchExitCall = nil

		existCall(var0_139)
	end)
end

function var0_0.ChangeWalkScene(arg0_140, arg1_140, arg2_140, arg3_140)
	local var0_140 = arg0_140:GetCurrentLadyEnv()

	seriesAsync({
		function(arg0_141)
			arg0_140:ChangeArtScene(arg2_140, arg0_141)
		end,
		function(arg0_142)
			arg0_140:ChangeSubScene(arg2_140, arg0_142)
		end,
		function(arg0_143)
			arg0_140:emit(arg0_140.SHOW_BLOCK)

			if arg1_140 == "back" then
				arg0_140:SetUI(arg0_143, "back")
			elseif arg1_140 == "change" and arg0_140.uiState ~= "walk" then
				arg0_140:SetUI(arg0_143, "walk")
			else
				arg0_143()
			end
		end
	}, function()
		arg0_140:emit(arg0_140.HIDE_BLOCK)
		arg0_140:SetBlackboardValue(var0_140, "inWalk", arg1_140 == "change")
		existCall(arg3_140)
	end)
end

function var0_0.EnterWalkMode(arg0_145)
	local var0_145 = arg0_145.apartment:GetConfigID()
	local var1_145 = arg0_145.ladyDict[var0_145]

	seriesAsync({
		function(arg0_146)
			arg0_145:emit(arg0_145.SHOW_BLOCK)
			arg0_145:HideCharacter(var0_145)
			arg0_145:SetBlackboardValue(var1_145, "inWalk", true)
			arg0_145:SetUI(arg0_146, "walk")
		end,
		function(arg0_147)
			arg0_145:emit(arg0_145.HIDE_BLOCK)
			arg0_145:ChangeArtScene(arg0_145.walkInfo.scene .. "|" .. arg0_145.walkInfo.sceneRoot, arg0_147)
		end,
		function(arg0_148)
			arg0_145:LoadSubScene(arg0_145.walkInfo, arg0_148)
		end
	}, function()
		return
	end)
end

function var0_0.ExitWalkMode(arg0_150)
	local var0_150 = arg0_150.apartment:GetConfigID()
	local var1_150 = arg0_150.ladyDict[var0_150]

	seriesAsync({
		function(arg0_151)
			arg0_150:RevertArtScene(arg0_150.walkLastSceneInfo, arg0_151)
		end,
		function(arg0_152)
			arg0_150:UnloadSubScene(arg0_150.walkInfo, arg0_152)
		end,
		function(arg0_153)
			arg0_150:emit(arg0_150.SHOW_BLOCK)
			arg0_150:SetUI(arg0_153, "back")
		end
	}, function()
		arg0_150:emit(arg0_150.HIDE_BLOCK)
		arg0_150:RevertCharacter(var0_150)
		arg0_150:SetBlackboardValue(var1_150, "inWalk", false)

		local var0_154 = arg0_150.walkExitCall

		arg0_150.walkExitCall = nil
		arg0_150.walkLastSceneInfo = nil
		arg0_150.walkInfo = nil

		existCall(var0_154)
	end)
end

function var0_0.EnableMiniGameCutIn(arg0_155)
	if not arg0_155.tfCutIn then
		return
	end

	local var0_155 = arg0_155.rtExtraScreen:Find("MiniGameCutIn")

	setActive(var0_155, true)

	local var1_155 = GetOrAddComponent(var0_155:Find("bg/mask/cut_in"), "CameraRTUI")

	setActive(var1_155, true)
	pg.CameraRTMgr.GetInstance():Bind(var1_155, arg0_155.tfCutIn:Find("TestCamera"):GetComponent(typeof(Camera)))
	quickPlayAnimator(arg0_155.modelCutIn.lady, "Idle")
	quickPlayAnimator(arg0_155.modelCutIn.player, "Idle")
	setActive(arg0_155.tfCutIn, true)
end

function var0_0.DisableMiniGameCutIn(arg0_156)
	if not arg0_156.tfCutIn then
		return
	end

	local var0_156 = arg0_156.rtExtraScreen:Find("MiniGameCutIn")
	local var1_156 = GetOrAddComponent(var0_156:Find("bg/mask/cut_in"), "CameraRTUI")

	pg.CameraRTMgr.GetInstance():Clean(var1_156)
	setActive(var0_156, false)
	setActive(arg0_156.tfCutIn, false)
end

function var0_0.SwitchIKConfig(arg0_157, arg1_157, arg2_157)
	warning("switchIkstatus", arg2_157)

	local var0_157 = pg.dorm3d_ik_status[arg2_157]

	if var0_157.skin_id ~= arg1_157.skinId then
		local var1_157 = pg.dorm3d_ik_status.get_id_list_by_base[var0_157.base]
		local var2_157 = _.detect(var1_157, function(arg0_158)
			return pg.dorm3d_ik_status[arg0_158].skin_id == arg1_157.skinId
		end)

		assert(var2_157, string.format("Missing Status Config By Skin: %s original Status: %s", arg1_157.skinId, arg2_157))

		var0_157 = pg.dorm3d_ik_status[var2_157]
	end

	arg1_157.ikConfig = var0_157
end

function var0_0.SetIKState(arg0_159, arg1_159, arg2_159, arg3_159)
	arg3_159 = arg3_159 or {}

	local var0_159 = arg0_159:GetCurrentLadyEnv()
	local var1_159 = {}

	if arg1_159 then
		table.insert(var1_159, function(arg0_160)
			arg0_159:SetBlackboardValue(var0_159, "inIK", true)
			arg0_159:emit(arg0_159.SHOW_BLOCK)

			local var0_160 = var0_159.ikConfig.camera_group

			setActive(arg0_159.uiContainer:Find("ik/Right/btn_camera"), #pg.dorm3d_ik_status.get_id_list_by_camera_group[var0_160] > 1)
			setActive(arg0_159.ikControlUI, true)
			arg0_160()
		end)

		if arg0_159.uiState ~= "ik" then
			table.insert(var1_159, function(arg0_161)
				arg0_159:SetUI(arg0_161, "ik")
			end)
		end

		table.insert(var1_159, function(arg0_162)
			Shader.SetGlobalFloat("_ScreenClipOff", 0)
			arg0_159:SetIKStatus(var0_159, var0_159.ikConfig, arg0_162, arg3_159)
		end)
		table.insert(var1_159, function(arg0_163)
			arg0_159:emit(arg0_159.HIDE_BLOCK)
			arg0_163()
		end)
	else
		assert(arg0_159.uiState == "ik")
		table.insert(var1_159, function(arg0_164)
			setActive(arg0_159.ikControlUI, false)
			arg0_159:emit(arg0_159.SHOW_BLOCK)
			Shader.SetGlobalFloat("_ScreenClipOff", 1)
			arg0_164()
		end)
		table.insert(var1_159, function(arg0_165)
			arg0_159:ExitIKStatus(var0_159, var0_159.ikConfig, arg0_165, arg3_159)
			arg0_159:ResetSceneItemAnimators()
		end)
		table.insert(var1_159, function(arg0_166)
			arg0_159:SetUI(arg0_166, "back")
		end)
		table.insert(var1_159, function(arg0_167)
			arg0_159:SetBlackboardValue(var0_159, "inIK", false)
			arg0_159:emit(arg0_159.HIDE_BLOCK)
			arg0_167()
		end)
	end

	seriesAsync(var1_159, arg2_159)
end

function var0_0.TouchModeAction(arg0_168, arg1_168, arg2_168, arg3_168, ...)
	return switch(arg3_168, {
		function(arg0_169, arg1_169)
			return function(arg0_170)
				seriesAsync({
					function(arg0_171)
						if not arg1_169 or arg1_169 == "" then
							return arg0_171()
						end

						arg0_168:PlaySingleAction(arg1_168, arg1_169, arg0_171)
					end,
					function(arg0_172)
						arg0_168:SwitchIKConfig(arg1_168, arg0_169)
						arg0_168:SetIKState(true, arg0_172)
					end,
					arg0_170
				})
			end
		end,
		function()
			return function()
				if arg0_168.ikSpecialCall then
					local var0_174 = arg0_168.ikSpecialCall

					arg0_168.ikSpecialCall = nil

					existCall(var0_174)
				else
					arg0_168:ExitTouchMode()
				end
			end
		end,
		function(arg0_175, arg1_175)
			return function(arg0_176)
				arg0_168:PlaySingleAction(arg1_168, arg1_175, arg0_176)
			end
		end,
		function(arg0_177, arg1_177, arg2_177)
			return function(arg0_178)
				seriesAsync({
					function(arg0_179)
						arg0_168:DoTalk(arg1_177, arg0_179)
					end,
					function(arg0_180)
						if not arg2_177 or arg2_177 == 0 then
							return arg0_180()
						end

						arg0_168:SwitchIKConfig(arg1_168, arg2_177)
						arg0_168:SetIKState(true, arg0_180)
					end,
					arg0_178
				})
			end
		end,
		function(arg0_181, arg1_181, arg2_181, arg3_181)
			return function(arg0_182)
				arg0_168:PlaySceneItemAnim(arg2_181, arg3_181)
				arg0_168:PlaySingleAction(arg1_181, arg0_182)
			end
		end,
		function(arg0_183)
			return function(arg0_184)
				local var0_184 = pg.dorm3d_ik_touch[arg2_168]

				if #var0_184.scene_item == 0 then
					return
				end

				local var1_184 = arg0_168:GetSceneItem(var0_184.scene_item)

				if not var1_184 then
					warning(string.format("dorm3d_ik_touch:%d without scene_item:%s", arg2_168, var0_184.scene_item))

					return
				end

				local var2_184 = var1_184:Find(arg0_183)

				if not IsNil(var2_184) then
					setActive(var2_184, false)
					setActive(var2_184, true)
				end

				arg0_184()
			end
		end,
		function(arg0_185)
			local var0_185 = pg.dorm3d_ik_touch_move[arg0_185]
			local var1_185 = var0_185.target_ik
			local var2_185 = var0_185.move_time
			local var3_185 = var0_185.ik_point
			local var4_185 = var0_185.touch_step

			arg1_168.IKSettings.forceMove = arg1_168.IKSettings.forceMove or {}

			local var5_185 = arg1_168.IKSettings.forceMove

			var5_185[var1_185] = var5_185[var1_185] or {}
			var5_185[var1_185].count = var5_185[var1_185].count or 0

			return function(arg0_186)
				seriesAsync({
					function(arg0_187)
						if var5_185[var1_185].count >= #var4_185 then
							return arg0_187()
						end

						local var0_187 = Dorm3dIK.New({
							configId = var1_185
						})
						local var1_187 = Vector2.New(unpack(var3_185))
						local var2_187 = var5_185[var1_185].count
						local var3_187 = var4_185[var2_187 + 1] - (var2_187 == 0 and 0 or var4_185[var2_187])

						var5_185[var1_185].count = var2_187 + 1

						pg.IKMgr.GetInstance():ResetIK(var0_187:GetTriggerBoneName())

						local var4_187 = arg1_168.IKSettings.Colliders[var0_187:GetTriggerBoneName()]
						local var5_187 = arg0_168.raycastCamera:WorldToScreenPoint(var4_187.position)

						pg.IKMgr.GetInstance():PlayIKMove(var5_187, var0_187:GetTriggerBoneName(), var1_187, var4_185[var2_187 + 1], var2_185, function()
							var5_185[var1_185].count = 0

							arg0_187()
						end)
					end,
					arg0_186
				})
			end
		end,
		function(arg0_189)
			return function(arg0_190)
				arg0_168:emit(Dorm3dStockingMgr.SET_STOCKING_STATUS, arg0_189)
			end
		end
	}, function()
		return function()
			return
		end
	end, ...)
end

function var0_0.OnTriggerIK(arg0_193, arg1_193)
	local var0_193 = arg0_193:GetCurrentLadyEnv()

	if var0_193.ikTimelineMode then
		arg0_193:ExitIKTimelineStatus(var0_193)

		local var1_193 = arg1_193:GetTimelineAction()

		if var1_193 then
			arg0_193.nowTimelinePlayer:TriggerEvent(var1_193)
		end

		return
	end

	if not var0_193.ikConfig then
		return
	end

	local var2_193 = arg1_193:GetControllerPath()
	local var3_193 = var0_193.ikActionDict[var2_193]

	if not var3_193 then
		return
	end

	arg0_193.blockIK = true

	arg0_193:TouchModeAction(var0_193, arg1_193:GetConfigID(), unpack(var3_193))(function()
		arg0_193:ResetIKTipTimer()

		arg0_193.blockIK = nil
	end)
end

function var0_0.OnTouchCharacterBody(arg0_195, arg1_195)
	local var0_195 = arg0_195:GetCurrentLadyEnv()

	if not var0_195.ikConfig then
		return
	end

	if type(var0_195.ikConfig.touch_data) ~= "table" then
		return
	end

	for iter0_195, iter1_195 in ipairs(var0_195.iKTouchDatas) do
		local var1_195, var2_195, var3_195 = unpack(iter1_195)
		local var4_195 = pg.dorm3d_ik_touch[var1_195]

		if var4_195.body == arg1_195 then
			local var5_195 = var4_195.action_emote

			if #var5_195 > 0 then
				arg0_195:PlayFaceAnim(var0_195, var5_195)
			end

			local var6_195 = var4_195.vibrate

			if type(var6_195) == "table" and VibrateMgr.Instance:IsSupport() then
				local var7_195 = {}
				local var8_195 = {}
				local var9_195 = {}

				underscore.each(var6_195, function(arg0_196)
					local var0_196 = arg0_196[1]

					if PLATFORM == PLATFORM_IPHONEPLAYER then
						var0_196 = var0_196 / 1000
					end

					table.insert(var7_195, var0_196)
					table.insert(var8_195, arg0_196[2])
					table.insert(var9_195, 1)
				end)

				if PLATFORM == PLATFORM_ANDROID then
					VibrateMgr.Instance:VibrateWaveform(var7_195, var8_195)
				elseif PLATFORM == PLATFORM_IPHONEPLAYER then
					VibrateMgr.Instance:VibrateWaveform(var7_195, var8_195, var9_195)
				end
			end

			arg0_195.blockIK = true

			arg0_195:TouchModeAction(var0_195, var1_195, unpack(var3_195))(function()
				arg0_195:ResetIKTipTimer()

				arg0_195.blockIK = nil
			end)

			return
		end
	end
end

function var0_0.UpdateTouchGameDisplay(arg0_198)
	setActive(arg0_198.rtTouchGamePanel:Find("effect_bg"), arg0_198.touchLevel == 2)
	setActive(arg0_198.rtTouchGamePanel:Find("slider/icon/beating"), arg0_198.touchLevel == 2)

	if arg0_198.touchLevel == 1 then
		setActive(arg0_198.uiContainer:Find("ik/btn_back"), true)
		setActive(arg0_198.uiContainer:Find("ik/btn_back_heartbeat"), false)
		quickPlayAnimation(arg0_198.rtTouchGamePanel, "anim_dorm3d_touch_change_out")
		quickPlayAnimation(arg0_198.rtTouchGamePanel:Find("slider/icon"), "anim_dorm3d_touch_icon")
	elseif arg0_198.touchLevel == 2 then
		setActive(arg0_198.uiContainer:Find("ik/btn_back"), false)
		setActive(arg0_198.uiContainer:Find("ik/btn_back_heartbeat"), true)
		quickPlayAnimation(arg0_198.rtTouchGamePanel, "anim_dorm3d_touch_change")
		quickPlayAnimation(arg0_198.rtTouchGamePanel:Find("slider/icon"), "anim_dorm3d_touch_icon_1")
		pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_heartbeat")
	end
end

function var0_0.UpdateTouchCount(arg0_199, arg1_199)
	if arg0_199.touchLevel > 1 then
		arg1_199 = math.min(0, arg1_199)
	end

	arg0_199.touchCount = math.clamp(arg0_199.touchCount + arg1_199, 0, 100)

	if arg0_199.sliderLT and LeanTween.isTweening(arg0_199.sliderLT) then
		LeanTween.cancel(arg0_199.sliderLT)

		arg0_199.sliderLT = nil
	end

	setSlider(arg0_199.rtTouchGamePanel:Find("slider"), 0, 100, arg0_199.touchCount)

	local var0_199

	if arg0_199.touchCount >= 100 then
		var0_199 = 2
	elseif arg0_199.touchCount <= 0 then
		var0_199 = 1
	end

	if var0_199 and var0_199 ~= arg0_199.touchLevel then
		if arg0_199.blockIK then
			return
		end

		arg0_199.touchLevel = var0_199

		local var1_199 = arg0_199.touchConfig.ik_status[var0_199]

		if var1_199 then
			if var0_199 > 1 then
				arg0_199.touchCount = 200
			elseif var0_199 == 1 then
				arg0_199.touchCount = 0
			end

			local var2_199 = arg0_199:GetCurrentLadyEnv()

			seriesAsync({
				function(arg0_200)
					arg0_199:ShowBlackScreen(true, arg0_200)
				end,
				function(arg0_201)
					arg0_199:SwitchIKConfig(var2_199, var1_199)
					arg0_199:SetIKState(true, arg0_201)

					if var0_199 > 1 and arg0_199.touchConfig.heartbeat_enter_anim ~= "" then
						arg0_199:SwitchAnim(var2_199, arg0_199.touchConfig.heartbeat_enter_anim)
					end
				end,
				function(arg0_202)
					arg0_199:ShowBlackScreen(false, arg0_202)
				end
			})
		end

		arg0_199:UpdateTouchCount(0)
		arg0_199:UpdateTouchGameDisplay()
	end

	arg0_199.topCount = math.max(arg0_199.topCount, arg0_199.touchCount)
end

function var0_0.ExitHeartbeatMode(arg0_203)
	if not arg0_203.touchLevel or arg0_203.touchLevel == 1 then
		return
	end

	arg0_203.touchCount = 0

	arg0_203:UpdateTouchCount(0)
end

function var0_0.DoTouch(arg0_204, arg1_204, arg2_204)
	if arg0_204.inTouchGame then
		switch(arg2_204, {
			function()
				arg0_204:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat.key_value_int)
			end,
			function()
				arg0_204:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat.key_value_int)
			end,
			function()
				arg0_204:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat.key_value_int)
			end,
			function()
				arg0_204:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat_trriger.key_value_int)
			end
		})
	end
end

function var0_0.DoTalk(arg0_209, arg1_209, arg2_209)
	while rawget(arg0_209, "class") ~= var0_0 do
		arg0_209 = getmetatable(arg0_209).__index
	end

	if arg0_209.apartment and arg0_209:GetBlackboardValue(arg0_209:GetCurrentLadyEnv(), "inTalking") then
		errorMsg("Talking block:" .. arg1_209)

		return
	end

	if not arg0_209.room:isPersonalRoom() then
		local var0_209 = pg.dorm3d_dialogue_group[arg1_209].char_id

		if arg0_209.apartment then
			assert(arg0_209.apartment:GetConfigID() == var0_209)
		else
			arg0_209:SetApartment(getProxy(ApartmentProxy):getApartment(var0_209))
		end
	end

	local var1_209 = arg0_209:GetCurrentLadyEnv()

	if arg1_209 == 10010 and not arg0_209.apartment.talkDic[arg1_209] then
		arg0_209.firstTimelineTouch = true
		arg0_209.firstMoveGuide = true
	end

	getProxy(Dorm3dChatProxy):TriggerEvent({
		{
			value = 1,
			event_type = arg0_209.contextData.timeIndex == 1 and 110 or 115,
			ship_id = arg0_209.apartment:GetConfigID()
		},
		{
			value = 1,
			event_type = 155,
			ship_id = arg0_209.apartment:GetConfigID()
		}
	})

	local var2_209 = {}

	if arg0_209:GetBlackboardValue(var1_209, "inPending") then
		table.insert(var2_209, function(arg0_210)
			arg0_209:OutOfLazy(arg0_209.apartment:GetConfigID(), arg0_210)
		end)
	end

	local var3_209 = pg.dorm3d_dialogue_group[arg1_209]
	local var4_209 = var3_209.performance_type == 1
	local var5_209

	table.insert(var2_209, function(arg0_211)
		arg0_209:emit(arg0_209.SHOW_BLOCK)
		arg0_209:SetBlackboardValue(var1_209, var4_209 and "inPerformance" or "inTalking", true)
		arg0_209:emit(Dorm3dRoomMediator.DO_TALK, arg1_209, function(arg0_212)
			var5_209 = arg0_212

			arg0_211()
		end)
	end)
	table.insert(var2_209, function(arg0_213)
		pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataDialog(arg0_209.apartment.configId, arg0_209.apartment.level, arg1_209, var3_209.type, arg0_209.room:getZoneConfig(arg0_209:GetCurrentLadyEnv().ladyBaseZone, "id"), var3_209.action_type, table.CastToString(var3_209.trigger_config), arg0_209.room:GetConfigID()))

		if pg.NewGuideMgr.GetInstance():IsBusy() then
			pg.NewGuideMgr.GetInstance():Pause()
		end

		arg0_209:SetUI(arg0_213, "blank")
	end)

	if var3_209.trigger_area and var3_209.trigger_area ~= "" then
		table.insert(var2_209, function(arg0_214)
			arg0_209:ShiftZone(var3_209.trigger_area, arg0_214)
		end)
	end

	if var3_209.performance_type == 0 then
		table.insert(var2_209, function(arg0_215)
			arg0_209:emit(arg0_209.HIDE_BLOCK)

			if arg0_209.contextData.isVideoTalk then
				arg0_209.videoPlayer:ExecuteAction("Play", var3_209.story, function()
					onDelayTick(arg0_215, 0.001)
				end)
			else
				pg.NewStoryMgr.GetInstance():ForceManualPlay(var3_209.story, function()
					onDelayTick(arg0_215, 0.001)
				end, true)
			end
		end)
	elseif var3_209.performance_type == 1 then
		table.insert(var2_209, function(arg0_218)
			arg0_209:emit(arg0_209.HIDE_BLOCK)
			arg0_209:PerformanceQueue(var3_209.story, arg0_218)
		end)
	else
		assert(false)
	end

	table.insert(var2_209, function(arg0_219)
		arg0_209:emit(arg0_209.SHOW_BLOCK)
		arg0_219()
	end)
	table.insert(var2_209, function(arg0_220)
		local var0_220 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(var3_209.story)

		if var0_220 then
			local var1_220 = "1"

			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataStory(var0_220, var1_220))
		end

		if var5_209 and #var5_209 > 0 then
			arg0_209:emit(Dorm3dRoomMediator.OPEN_DROP_LAYER, var5_209, arg0_220)
		else
			arg0_220()
		end
	end)
	table.insert(var2_209, function(arg0_221)
		if pg.NewGuideMgr.GetInstance():IsPause() then
			pg.NewGuideMgr.GetInstance():Resume()
		end

		arg0_209:emit(arg0_209.HIDE_BLOCK)

		if arg0_209.contextData.isVideoTalk then
			existCall(arg0_221)
		else
			arg0_209:SetBlackboardValue(var1_209, var4_209 and "inPerformance" or "inTalking", false)
			arg0_209:SetUI(arg0_221, "back")
		end
	end)
	seriesAsync(var2_209, function()
		if arg2_209 then
			return arg2_209()
		else
			arg0_209:CheckQueue()
		end
	end)
end

function var0_0.DoTalkTouchOption(arg0_223, arg1_223, arg2_223, arg3_223)
	local var0_223 = arg0_223.rtExtraScreen:Find("TalkTouchOption")
	local var1_223
	local var2_223 = var0_223:Find("content")

	UIItemList.StaticAlign(var2_223, var2_223:Find("clickTpl"), #arg1_223.options, function(arg0_224, arg1_224, arg2_224)
		arg1_224 = arg1_224 + 1

		if arg0_224 == UIItemList.EventUpdate then
			local var0_224 = arg1_223.options[arg1_224]

			setAnchoredPosition(arg2_224, NewPos(unpack(var0_224.pos)))
			onButton(arg0_223, arg2_224, function()
				var1_223(var0_224.flag)
			end, SFX_CONFIRM)
			setActive(arg2_224, not table.contains(arg2_223, var0_224.flag))
		end
	end)
	setActive(var0_223, true)

	function var1_223(arg0_226)
		setActive(var0_223, false)
		arg3_223(arg0_226)
	end
end

function var0_0.DoTimelineOption(arg0_227, arg1_227, arg2_227)
	local var0_227 = arg0_227.rtTimelineScreen:Find("TimelineOption")
	local var1_227
	local var2_227 = var0_227:Find("content")

	UIItemList.StaticAlign(var2_227, var2_227:Find("clickTpl"), #arg1_227, function(arg0_228, arg1_228, arg2_228)
		arg1_228 = arg1_228 + 1

		if arg0_228 == UIItemList.EventUpdate then
			local var0_228 = arg1_227[arg1_228]

			setText(arg2_228:Find("Text"), HXSet.hxLan(var0_228.content))
			onButton(arg0_227, arg2_228, function()
				var1_227(arg1_228)
			end, SFX_CONFIRM)
		end
	end)
	setActive(var0_227, true)

	function var1_227(arg0_230)
		setActive(var0_227, false)
		arg2_227(arg0_230)
	end
end

function var0_0.DoTimelineTouch(arg0_231, arg1_231, arg2_231)
	local var0_231 = arg0_231.rtTimelineScreen:Find("TimelineTouch")
	local var1_231
	local var2_231 = var0_231:Find("content")

	UIItemList.StaticAlign(var2_231, var2_231:Find("clickTpl"), #arg1_231, function(arg0_232, arg1_232, arg2_232)
		arg1_232 = arg1_232 + 1

		if arg0_232 == UIItemList.EventUpdate then
			local var0_232 = arg1_231[arg1_232]

			setAnchoredPosition(arg2_232, NewPos(unpack(var0_232.pos)))
			onButton(arg0_231, arg2_232, function()
				var1_231(arg1_232)
			end, SFX_CONFIRM)

			if arg0_231.firstTimelineTouch then
				arg0_231.firstTimelineTouch = nil

				setActive(arg2_232:Find("finger"), true)
			end
		end
	end)
	setActive(var0_231, true)

	function var1_231(arg0_234)
		setActive(var0_231, false)
		arg2_231(arg0_234)
	end
end

function var0_0.DoShortWait(arg0_235, arg1_235)
	local var0_235 = arg0_235.ladyDict[arg1_235]
	local var1_235 = getProxy(ApartmentProxy):getApartment(arg1_235)
	local var2_235 = arg0_235.room:getApartmentZoneConfig(var0_235.ladyBaseZone, "special_action", arg1_235)
	local var3_235 = var2_235 and var2_235[math.random(#var2_235)] or nil

	if not var3_235 then
		return
	end

	arg0_235:PlaySingleAction(var0_235, var3_235)
end

function var0_0.OutOfLazy(arg0_236, arg1_236, arg2_236)
	local var0_236 = arg0_236.ladyDict[arg1_236]
	local var1_236 = {}

	if arg0_236:GetBlackboardValue(var0_236, "inPending") then
		table.insert(var1_236, function(arg0_237)
			arg0_236.shiftLady = arg1_236

			arg0_236:ShiftZone(var0_236.ladyBaseZone, arg0_237)
		end)
	end

	seriesAsync(var1_236, arg2_236)
end

function var0_0.OutOfPending(arg0_238, arg1_238, arg2_238)
	assert(arg0_238.wakeUpTalkId)

	local var0_238 = arg0_238.wakeUpTalkId

	seriesAsync({
		function(arg0_239)
			arg0_238:SetUI(arg0_239, "blank")
		end,
		function(arg0_240)
			arg0_238.shiftLady = arg1_238

			local var0_240 = arg0_238.ladyDict[arg1_238]

			arg0_238:ShiftZone(var0_240.ladyBaseZone, arg0_240)
		end,
		function(arg0_241)
			arg0_238:DoTalk(var0_238, arg0_241)
		end
	}, function()
		arg0_238:SetUIStore(arg2_238, "back")
	end)
end

function var0_0.ChangeCanWatchState(arg0_243, arg1_243)
	local var0_243

	if arg0_243:GetBlackboardValue(arg1_243, "inPending") then
		var0_243 = tobool(arg0_243:GetBlackboardValue(arg1_243, "inDistance"))
	else
		local var1_243 = arg0_243:GetBlackboardValue(arg1_243, "groupId")

		var0_243 = tobool(arg0_243.activeLady[var1_243] and pg.NodeCanvasMgr.GetInstance():GetBlackboradValue("canWatch", arg1_243.ladyBlackboard))
	end

	if arg1_243.blockCanWatch then
		var0_243 = false
	end

	if (not arg1_243.nowCanWatchState or arg1_243.nowCanWatchState ~= var0_243) and arg1_243.ladyWatchFloat then
		arg1_243.nowCanWatchState = var0_243

		arg0_243:ShowOrHideCanWatchMark(arg1_243, arg1_243.nowCanWatchState)
	end
end

function var0_0.HandleGameNotification(arg0_244, arg1_244, arg2_244)
	local var0_244 = arg0_244:GetCurrentLadyEnv()

	switch(arg1_244, {
		[Dorm3dMiniGameMediator.OPERATION] = function()
			local var0_245 = arg2_244.miniGameId

			switch(arg2_244.miniGameId, {
				[67] = function()
					if arg2_244.operationCode == "GAME_HIT_AREA" then
						local var0_246 = {
							{
								"Face_XYX_1",
								"zhongji"
							},
							{
								"Face_XYX_2",
								"qingji"
							},
							{
								"Face_XYX_3",
								"miss"
							}
						}
						local var1_246, var2_246 = unpack(var0_246[arg2_244.index])

						arg0_244:PlayFaceAnim(var0_244, var1_246)

						if arg0_244.tfCutIn then
							quickPlayAnimator(arg0_244.modelCutIn.lady, var2_246)
							quickPlayAnimator(arg0_244.modelCutIn.player, var2_246)
						end
					elseif arg2_244.operationCode == "GAME_RESULT" then
						if arg2_244.win then
							arg0_244:PlayFaceAnim(var0_244, "Face_XYX_victory")
							arg0_244:PlaySingleAction(var0_244, "minigame_win")
						else
							arg0_244:PlayFaceAnim(var0_244, "Face_XYX_lose")
							arg0_244:PlaySingleAction(var0_244, "minigame_lose")
						end

						setActive(arg0_244.rtExtraScreen:Find("MiniGameCutIn"), false)
					end
				end,
				[70] = function()
					if arg2_244.operationCode == "GAME_READY" then
						arg0_244.cameras[var0_0.CAMERA.TALK].Follow = nil
						arg0_244.cameras[var0_0.CAMERA.TALK].LookAt = nil

						arg0_244:PlaySingleAction(var0_244, "shuohua_sikao")
					elseif arg2_244.operationCode == "ROUND_RESULT" then
						local var0_247

						if arg2_244.success then
							var0_247 = {
								"shuohua_wenhou",
								"shuohua_sikao"
							}
						else
							var0_247 = {
								"shuohua_yaotou",
								"shuohua_sikao"
							}
						end

						seriesAsync(underscore.map(var0_247, function(arg0_248)
							return function(arg0_249)
								arg0_244:PlaySingleAction(var0_244, arg0_248, arg0_249)
							end
						end), function()
							return
						end)
					elseif arg2_244.operationCode == "GAME_RESULT" then
						local var1_247 = arg0_244.cameras[var0_0.CAMERA.TALK].transform

						var1_247.position = var1_247.position + var1_247.right * 0.11

						local var2_247 = {
							"shuohua_gandong"
						}

						seriesAsync(underscore.map(var2_247, function(arg0_251)
							return function(arg0_252)
								arg0_244:PlaySingleAction(var0_244, arg0_251, arg0_252)
							end
						end), function()
							return
						end)
					end
				end,
				[75] = function()
					if arg2_244.operationCode == "BEFORE_OPEN_GAME" then
						arg0_244.cameras[var0_0.CAMERA.TALK].Follow = nil
						arg0_244.cameras[var0_0.CAMERA.TALK].LookAt = nil
					elseif arg2_244.operationCode == "GAME_RPS_RESULT" then
						if arg2_244.index == 1 then
							arg0_244:PlaySingleAction(var0_244, "ab_shuohua_lianxuyaotou_01")
							arg0_244:PlayFaceAnim(var0_244, "Face_weixiao")
						elseif arg2_244.index == 2 then
							arg0_244:PlaySingleAction(var0_244, "ab_shuohua_lianxudiantou_01")
							arg0_244:PlayFaceAnim(var0_244, "Face_kaixin")
						end
					elseif arg2_244.operationCode == "GAME_RESULT" then
						if not arg2_244.win then
							arg0_244:PlaySingleAction(var0_244, "ab_shuohua_taibangle_01")
						end

						arg0_244:PlayFaceAnim(var0_244, "Face_kaixin")
					end
				end
			}, function()
				warning("without miniGameId:" .. arg2_244.miniGameId)
			end)

			if arg2_244.operationCode == "BEFORE_OPEN_GAME" then
				local var1_245 = getProxy(PlayerProxy):getPlayerId()
				local var2_245 = 0

				if var0_245 == 67 or var0_245 == 70 then
					var2_245 = PlayerPrefs.GetInt("mg_new_score_" .. tostring(var1_245) .. "_" .. arg2_244.miniGameId, 0)
				else
					var2_245 = PlayerPrefs.GetInt("mg_score_" .. tostring(var1_245) .. "_" .. arg2_244.miniGameId, 0)
				end

				arg0_244.highScore = var2_245
			elseif arg2_244.operationCode == "GAME_RESULT" then
				local var3_245 = arg2_244.score
				local var4_245 = getProxy(PlayerProxy):getPlayerId()

				if var3_245 > arg0_244.highScore then
					if var0_245 == 67 or var0_245 == 70 then
						PlayerPrefs.SetInt("mg_new_score_" .. tostring(var4_245) .. "_" .. arg2_244.miniGameId, var3_245)
					end

					getProxy(Dorm3dChatProxy):TriggerEvent({
						{
							event_type = 159,
							value = var3_245,
							ship_id = arg0_244.apartment:GetConfigID()
						}
					})
				end

				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataMiniGame(2, arg2_244.score))
			elseif arg2_244.operationCode == "GAME_CLOSE" and arg2_244.doTrack == false then
				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataMiniGame(3))
			end
		end
	})
end

function var0_0.PerformanceQueue(arg0_256, arg1_256, arg2_256)
	local var0_256, var1_256 = pcall(function()
		return require("GameCfg.dorm." .. arg1_256)
	end)

	if not var0_256 then
		errorMsg("不存在表演ID对应的Lua:" .. arg1_256)
		existCall(arg2_256)

		return
	end

	warning(arg1_256)

	arg0_256.performanceInfo = {
		name = arg1_256
	}

	local var2_256 = {}

	table.insert(var2_256, function(arg0_258)
		arg0_256:SetUI(arg0_258, "blank")
	end)
	table.insertto(var2_256, underscore.map(var1_256, function(arg0_259)
		return switch(arg0_259.type, {
			function()
				return function(arg0_261)
					local var0_261 = unpack(arg0_259.params)

					arg0_256:DoTalk(var0_261, arg0_261, true)
				end
			end,
			function()
				return function(arg0_263)
					arg0_256.touchExitCall = arg0_263

					arg0_256:EnterTouchMode()
				end
			end,
			function()
				return function(arg0_265)
					local var0_265 = arg0_256:GetCurrentLadyEnv()

					arg0_256:PlaySingleAction(var0_265, arg0_259.name, arg0_265)
				end
			end,
			function()
				return function(arg0_267)
					arg0_256:emit(arg0_256.PLAY_EXPRESSION, arg0_259)
					arg0_267()
				end
			end,
			function()
				return function(arg0_269)
					arg0_256:ShiftZone(arg0_259.name, arg0_269)
				end
			end,
			function()
				return function(arg0_271)
					arg0_256.contextData.timeIndex = arg0_259.params[1]

					local var0_271 = arg0_259.params[2] or false

					if Dorm3dSceneMgr.IsSameSceneInfo(arg0_256.dormSceneMgr.artSceneInfo, arg0_256.dormSceneMgr.sceneInfo) then
						arg0_256:SwitchDayNight(arg0_256.contextData.timeIndex)

						if var0_271 then
							onNextTick(function()
								arg0_256:RefreshSlots()
							end)
						end
					end

					arg0_256:UpdateContactState()
					onNextTick(arg0_271)
				end
			end,
			function()
				return function(arg0_274)
					if arg0_259.name then
						arg0_256:ActiveCameraByName(arg0_259.name)
						existCall(arg0_274)
					else
						arg0_256:ActiveStateCamera(arg0_259.params[1], arg0_274)
					end
				end
			end,
			function()
				return function(arg0_276)
					if arg0_259.name == "base" then
						arg0_256:RevertArtScene(arg0_256.dormSceneMgr.sceneInfo, arg0_276)
					else
						local var0_276 = arg0_259.params.scene
						local var1_276 = arg0_259.params.sceneRoot

						arg0_256:ChangeArtScene(var0_276 .. "|" .. var1_276, arg0_276)
					end
				end
			end,
			function()
				return function(arg0_278)
					local var0_278 = arg0_259.params.name

					if arg0_259.name == "load" then
						local var1_278 = tobool(arg0_259.params.wait_timeline) and function(arg0_279)
							arg0_256.waitForTimeline = arg0_279
						end

						arg0_256:LoadTimelineScene(var0_278, true, var1_278, arg0_278)
					elseif arg0_259.name == "unload" then
						arg0_256:UnloadTimelineScene(var0_278, true, arg0_278)
					else
						assert(false)
					end
				end
			end,
			function()
				return function(arg0_281)
					setActive(arg0_256.uiContainer:Find("walk/btn_back"), false)

					local var0_281 = arg0_256:GetCurrentLadyEnv()

					if arg0_259.name == "change" then
						local var1_281 = arg0_259.params.scene
						local var2_281 = arg0_259.params.sceneRoot

						var0_281.walkBornPoint = arg0_259.params.point or "Default"

						arg0_256:ChangeWalkScene(arg0_259.name, var1_281 .. "|" .. var2_281, arg0_281)
					elseif arg0_259.name == "back" then
						var0_281.walkBornPoint = nil

						arg0_256:ChangeWalkScene(arg0_259.name, arg0_256.dormSceneMgr.sceneInfo, arg0_281)
					elseif arg0_259.name == "set" then
						local function var3_281()
							local var0_282 = arg0_281

							arg0_281 = nil

							return existCall(var0_282)
						end

						for iter0_281, iter1_281 in pairs(arg0_259.params) do
							switch(iter0_281, {
								back_button_trigger = function(arg0_283)
									onButton(arg0_256, arg0_256.uiContainer:Find("walk/btn_back"), var3_281, SFX_DORM_BACK)
									setActive(arg0_256.uiContainer:Find("walk/btn_back"), IsUnityEditor and arg0_283)
								end,
								near_trigger = function(arg0_284)
									if arg0_284 == true then
										arg0_284 = 1.5
									end

									if arg0_284 then
										function arg0_256.walkNearCallback(arg0_285)
											if arg0_285 < arg0_284 then
												arg0_256.walkNearCallback = nil

												var3_281()
											end
										end
									else
										arg0_256.walkNearCallback = nil
									end
								end
							}, nil, iter1_281)
						end

						if arg0_256.firstMoveGuide then
							setActive(arg0_256.povLayer:Find("Guide"), arg0_256.firstMoveGuide)

							arg0_256.firstMoveGuide = nil
						end
					else
						assert(false)
					end
				end
			end,
			function()
				return function(arg0_287)
					if arg0_259.name == "set" then
						local var0_287 = arg0_256:GetCurrentLadyEnv()

						arg0_256:SwitchIKConfig(var0_287, arg0_259.params.state)
						setActive(arg0_256.uiContainer:Find("ik/btn_back"), not arg0_259.params.hide_back)

						arg0_256.ikSpecialCall = arg0_287

						arg0_256:SetIKState(true)
					elseif arg0_259.name == "back" then
						local var1_287 = arg0_256:GetCurrentLadyEnv()

						var1_287.ikConfig = arg0_259.params

						arg0_256:SetIKState(false, function()
							var1_287.ikConfig = nil

							existCall(arg0_287)
						end)
					else
						assert(false)
					end
				end
			end,
			function()
				return function(arg0_290)
					arg0_256.blackSceneInfo = setmetatable(arg0_259.params or {}, {
						__index = {
							color = "#000000",
							time = 0.3,
							delay = arg0_259.name == "show" and 0 or 0.5
						}
					})

					if arg0_259.name == "show" then
						arg0_256:ShowBlackScreen(true, arg0_290)
					elseif arg0_259.name == "hide" then
						arg0_256:ShowBlackScreen(false, arg0_290)
					else
						assert(false)
					end

					arg0_256.blackSceneInfo = nil
				end
			end,
			function()
				return function(arg0_292)
					local var0_292 = arg0_256:GetCurrentLadyEnv()

					if arg0_259.name == "set" then
						arg0_256:emit(Dorm3dStockingMgr.SET_STOCKING_STATUS, arg0_259.params)
					elseif arg0_259.name == "exit" then
						arg0_256:emit(Dorm3dStockingMgr.EXIT_STOCKING_STATUS)
					end
				end
			end
		})
	end))
	table.insert(var2_256, function(arg0_293)
		arg0_256:SetUI(arg0_293, "back")

		arg0_256.performanceInfo = nil
	end)
	seriesAsync(var2_256, arg2_256)
end

function var0_0.TriggerContact(arg0_294, arg1_294)
	arg0_294:emit(Dorm3dRoomMediator.COLLECTION_ITEM, {
		itemId = arg1_294,
		roomId = arg0_294.room:GetConfigID(),
		groupId = arg0_294.room:isPersonalRoom() and arg0_294.apartment:GetConfigID() or 0
	})
end

function var0_0.UpdateContactState(arg0_295)
	arg0_295:SetContactStateDic(arg0_295.room:getTriggerableCollectItemDic(arg0_295.contextData.timeIndex))
end

function var0_0.UpdateFavorDisplay(arg0_296)
	local var0_296, var1_296 = getProxy(ApartmentProxy):getStamina()

	setText(arg0_296.rtStaminaDisplay:Find("Text"), string.format("%d/%d", var0_296, var1_296))
	setActive(arg0_296.rtStaminaDisplay, false)

	if arg0_296.apartment then
		setText(arg0_296.rtFavorLevel:Find("rank/Text"), arg0_296.apartment.level)

		local var2_296, var3_296 = arg0_296.apartment:getFavor()
		local var4_296 = arg0_296.apartment:isMaxFavor()

		setActive(arg0_296.rtFavorLevel:Find("Max"), var4_296)
		setActive(arg0_296.rtFavorLevel:Find("Text"), not var4_296)
		setText(arg0_296.rtFavorLevel:Find("Text"), string.format("<color=#ff6698>%d</color>/%d", var2_296, var3_296))
	end

	setActive(arg0_296.rtFavorLevel:Find("red"), Dorm3dLevelLayer.IsShowRed())
end

function var0_0.UpdateBtnState(arg0_297)
	local var0_297 = not arg0_297.room:isPersonalRoom() or arg0_297:CheckSystemOpen("Furniture")
	local var1_297 = Dorm3dFurniture.IsTimelimitShopTip(arg0_297.room:GetConfigID())

	setActive(arg0_297.uiContainer:Find("base/left/btn_furniture/tipTimelimit"), var0_297 and var1_297)

	local var2_297 = Dorm3dFurniture.NeedViewTip(arg0_297.room:GetConfigID())

	setActive(arg0_297.uiContainer:Find("base/left/btn_furniture/tip"), var0_297 and not var1_297 and var2_297)
	setActive(arg0_297.uiContainer:Find("base/btn_back/main"), underscore(getProxy(ApartmentProxy):getRawData()):chain():values():filter(function(arg0_298)
		return tobool(arg0_298)
	end):any(function(arg0_299)
		return #arg0_299:getSpecialTalking() > 0 or arg0_299:getIconTip() == "main"
	end):value())
	setActive(arg0_297.uiContainer:Find("base/left/btn_collection/tip"), PlayerPrefs.GetInt("apartment_collection_item", 0) > 0 or PlayerPrefs.GetInt("apartment_collection_recall", 0) > 0)
end

function var0_0.AddUnlockDisplay(arg0_300, arg1_300)
	table.insert(arg0_300.unlockList, arg1_300)

	if not isActive(arg0_300.rtFavorUp) then
		setText(arg0_300.rtFavorUp:Find("Text"), table.remove(arg0_300.unlockList, 1))
		setActive(arg0_300.rtFavorUp, true)
	end
end

function var0_0.PopFavorTrigger(arg0_301, arg1_301)
	local var0_301 = arg1_301.triggerId
	local var1_301 = arg1_301.delta
	local var2_301 = arg1_301.cost
	local var3_301 = arg1_301.apartment
	local var4_301 = pg.dorm3d_favor_trigger[var0_301]

	if var4_301.is_repeat == 0 then
		if var0_301 == getDorm3dGameset("drom3d_favir_trigger_onwer")[1] then
			arg0_301:AddUnlockDisplay(i18n("dorm3d_own_favor"))
		elseif var0_301 == getDorm3dGameset("drom3d_favir_trigger_propose")[1] then
			arg0_301:AddUnlockDisplay(i18n("dorm3d_pledge_favor"))
		else
			arg0_301:AddUnlockDisplay(string.format("unknow favor trigger:%d unlock", var0_301))
		end
	elseif arg1_301.delta > 0 then
		local var5_301, var6_301 = var3_301:getFavor()
		local var7_301 = var5_301 + var1_301

		setText(arg0_301.rtFavorUpDaily:Find("bg/Text"), string.format("<size=48>+%d</size>", math.min(9999, var1_301)))
		setSlider(arg0_301.rtFavorUpDaily:Find("bg/slider"), 0, var6_301, var5_301)
		setAnchoredPosition(arg0_301.rtFavorUpDaily:Find("bg"), arg1_301.isGift and NewPos(-354, 223) or NewPos(-208, 105))

		local var8_301 = {}
		local var9_301 = arg0_301.rtFavorUpDaily:Find("bg/effect")

		eachChild(var9_301, function(arg0_302)
			setActive(arg0_302, false)
		end)

		local var10_301

		if var4_301.effect and var4_301.effect ~= "" then
			var10_301 = var9_301:Find(var4_301.effect .. "(Clone)")

			if not var10_301 then
				table.insert(var8_301, function(arg0_303)
					LoadAndInstantiateAsync("Dorm3D/Effect/Prefab/ExpressionUI", "uifx_dorm3d_yinfu01", function(arg0_304)
						setParent(arg0_304, var9_301)

						var10_301 = tf(arg0_304)

						arg0_303()
					end)
				end)
			else
				setActive(var10_301, true)
			end
		end

		local var11_301 = arg0_301.rtFavorUpDaily:GetComponent("DftAniEvent")

		var11_301:SetTriggerEvent(function(arg0_305)
			local var0_305 = GetComponent(arg0_301.rtFavorUpDaily:Find("bg/slider"), typeof(Slider))

			LeanTween.value(var5_301, var7_301, 0.5):setOnUpdate(System.Action_float(function(arg0_306)
				var0_305.value = arg0_306
			end)):setEase(LeanTweenType.easeInOutQuad):setDelay(0.165):setOnComplete(System.Action(function()
				LeanTween.delayedCall(0.165, System.Action(function()
					if arg0_301.exited then
						return
					end

					quickPlayAnimator(arg0_301.rtFavorUpDaily, "favor_out")
				end))
			end))
			pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_progaress_bar")
		end)
		var11_301:SetEndEvent(function(arg0_309)
			setActive(arg0_301.rtFavorUpDaily, false)
		end)
		seriesAsync(var8_301, function()
			local var0_310 = arg0_301.ladyDict[var3_301:GetConfigID()]

			setLocalPosition(arg0_301.rtFavorUpDaily, arg0_301:GetLocalPosition(arg0_301:GetScreenPosition(var0_310.ladyHeadCenter.position), arg0_301.rtFavorUpDaily.parent))
			setActive(arg0_301.rtFavorUpDaily, true)
			SetCompomentEnabled(arg0_301.rtFavorUpDaily, typeof(Animator), true)
			quickPlayAnimator(arg0_301.rtFavorUpDaily, "favor_open")

			if var2_301 > 0 then
				local var1_310, var2_310 = getProxy(ApartmentProxy):getStamina()

				setText(arg0_301.rtStaminaPop:Find("Text/Text (1)"), "-" .. var2_301)
				setText(arg0_301.rtStaminaPop:Find("Text"), string.format("%d/%d", var1_310 + var2_301, var2_310))
				setActive(arg0_301.rtStaminaPop, true)
			end
		end)
	end
end

function var0_0.PopFavorLevelUp(arg0_311, arg1_311, arg2_311, arg3_311)
	arg0_311.isLock = true

	LeanTween.delayedCall(0.33, System.Action(function()
		arg0_311.isLock = false
	end))

	local var0_311 = math.floor(arg1_311.level / 10)
	local var1_311 = math.fmod(arg1_311.level, 10)

	GetImageSpriteFromAtlasAsync("ui/favor_atlas", var1_311, arg0_311.rtLevelUpWindow:Find("panel/bg/item1/mark/level/digit2"))
	GetImageSpriteFromAtlasAsync("ui/favor_atlas", var0_311, arg0_311.rtLevelUpWindow:Find("panel/bg/item1/mark/level/digit1"))
	setActive(arg0_311.rtLevelUpWindow:Find("panel/bg/item1/mark/level/digit1"), var0_311 > 0)

	local var2_311
	local var3_311

	arg0_311.clientAward, var3_311 = Dorm3dIconHelper.SplitStory(arg1_311:getFavorConfig("levelup_client_item", arg1_311.level))
	arg0_311.serverAward = arg2_311

	local var4_311 = arg0_311.rtLevelUpWindow:Find("panel/info/content/itemContent")

	if not arg0_311.levelItemList then
		arg0_311.levelItemList = UIItemList.New(var4_311, var4_311:Find("tpl"))

		arg0_311.levelItemList:make(function(arg0_313, arg1_313, arg2_313)
			local var0_313 = arg1_313 + 1

			if arg0_313 == UIItemList.EventUpdate then
				if arg1_313 < #arg0_311.serverAward then
					updateDorm3dIcon(arg2_313, arg0_311.serverAward[var0_313])
					onButton(arg0_311, arg2_313, function()
						arg0_311:emit(BaseUI.ON_NEW_DROP, {
							style = "dorm",
							drop = arg0_311.serverAward[var0_313]
						})
					end, SFX_PANEL)
				else
					Dorm3dIconHelper.UpdateDorm3dIcon(arg2_313, arg0_311.clientAward[var0_313 - #arg0_311.serverAward])
					onButton(arg0_311, arg2_313, function()
						arg0_311:emit(Dorm3dRoomMediator.ON_DROP_CLIENT, {
							data = arg0_311.clientAward[var0_313 - #arg0_311.serverAward]
						})
					end, SFX_PANEL)
				end
			end
		end)
	end

	arg0_311.levelItemList:align(#arg0_311.serverAward + #arg0_311.clientAward)
	setActive(arg0_311.rtLevelUpWindow, true)
	pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_upgrade")
	arg0_311:OverlayPanel(arg0_311.rtLevelUpWindow)

	function arg0_311.levelUpCallback()
		arg0_311.levelUpCallback = nil

		if var3_311 then
			arg0_311:PopNewStoryTip(var3_311)
		end

		existCall(arg3_311)
	end
end

function var0_0.PopNewStoryTip(arg0_317, arg1_317, arg2_317)
	local var0_317 = arg0_317.uiContainer:Find("base/top/story_tip")

	setActive(var0_317, true)
	LeanTween.delayedCall(1, System.Action(function()
		setActive(var0_317, false)
	end))
	setText(var0_317:Find("Text"), i18n("dorm3d_story_unlock_tip", pg.dorm3d_recall[arg1_317[2]].name))
	existCall(arg2_317)
end

function var0_0.UpdateZoneList(arg0_319)
	local var0_319

	if arg0_319.room:isPersonalRoom() then
		var0_319 = arg0_319:GetCurrentLadyEnv().ladyBaseZone
	else
		var0_319 = arg0_319:GetAttachedFurnitureName()
	end

	for iter0_319, iter1_319 in ipairs(arg0_319.zoneDatas) do
		if iter1_319:GetWatchCameraName() == var0_319 then
			setText(arg0_319.btnZone:Find("Text"), iter1_319:GetName())
			setTextColor(arg0_319.rtZoneList:GetChild(iter0_319 - 1):Find("Name"), Color.NewHex("5CCAFF"))
		else
			setTextColor(arg0_319.rtZoneList:GetChild(iter0_319 - 1):Find("Name"), Color.NewHex("FFFFFF99"))
		end
	end
end

function var0_0.TalkingEventHandle(arg0_320, arg1_320)
	local var0_320 = {}
	local var1_320 = {}
	local var2_320 = arg1_320.data

	if var2_320.op_list then
		for iter0_320, iter1_320 in ipairs(var2_320.op_list) do
			table.insert(var0_320, function(arg0_321)
				local function var0_321()
					local var0_322 = arg0_321

					arg0_321 = nil

					return existCall(var0_322)
				end

				switch(iter1_320.type, {
					action = function()
						local var0_323 = arg0_320:GetCurrentLadyEnv()

						arg0_320:PlaySingleAction(var0_323, iter1_320.name, var0_321)
					end,
					item_action = function()
						arg0_320:PlaySceneItemAnim(iter1_320.id, iter1_320.name)
						var0_321()
					end,
					extra_item_action = function()
						local var0_325 = arg0_320:GetCurrentLadyEnv().extraItems[iter1_320.name]

						warning(iter1_320.name)
						warning(var0_325.trans)

						if var0_325 then
							var0_325.trans:GetComponent(typeof(Animator)):PlayInFixedTime(iter1_320.param)
						end

						var0_321()
					end,
					timeline = function()
						if arg0_320.inTouchGame then
							setActive(arg0_320.rtTouchGamePanel, false)
						end

						arg0_320:PlayTimeline(iter1_320, function(arg0_327, arg1_327)
							setActive(arg0_320.rtTouchGamePanel, arg0_320.inTouchGame)

							var1_320.notifiCallback = arg1_327

							var0_321()
						end)
					end,
					clickOption = function()
						arg0_320:DoTalkTouchOption(iter1_320, arg1_320.flags, function(arg0_329)
							var1_320.optionIndex = arg0_329

							var0_321()
						end)
					end,
					wait = function()
						arg0_320.LTs = arg0_320.LTs or {}

						table.insert(arg0_320.LTs, LeanTween.delayedCall(iter1_320.time, System.Action(var0_321)).uniqueId)
					end,
					expression = function()
						arg0_320:emit(arg0_320.PLAY_EXPRESSION, iter1_320)
						var0_321()
					end
				}, function()
					assert(false, "op type error:", iter1_320.type)
				end)

				if iter1_320.skip then
					var0_321()
				end
			end)
		end
	end

	seriesAsync(var0_320, function()
		if arg1_320.callbackData then
			arg0_320:emit(Dorm3dRoomMediator.TALKING_EVENT_FINISH, arg1_320.callbackData.name, var1_320)
		end
	end)
end

function var0_0.CheckQueue(arg0_334)
	if arg0_334.inGuide or arg0_334.uiState ~= "base" then
		return
	end

	if arg0_334.room:GetConfigID() == 1 and arg0_334:CheckGuide() then
		-- block empty
	elseif arg0_334.room:isPersonalRoom() and arg0_334:CheckLevelUp() then
		-- block empty
	elseif arg0_334.apartment and arg0_334:CheckEnterDeal() then
		-- block empty
	elseif arg0_334.apartment and arg0_334:CheckActiveTalk() then
		-- block empty
	elseif arg0_334.apartment then
		arg0_334:CheckFavorTrigger()
	end

	arg0_334.contextData.hasEnterCheck = true
end

function var0_0.didEnterCheck(arg0_335)
	local var0_335

	if arg0_335.contextData.specialId then
		var0_335 = arg0_335.contextData.specialId
		arg0_335.contextData.specialId = nil

		arg0_335:DoTalk(var0_335, function()
			arg0_335:closeView()
		end)

		if arg0_335.contextData.isVideoTalk then
			arg0_335.contextData.hasEnterCheck = true
		end
	elseif not arg0_335.contextData.hasEnterCheck and arg0_335.apartment then
		for iter0_335, iter1_335 in ipairs(arg0_335.apartment:getForceEnterTalking(arg0_335.room:GetConfigID())) do
			var0_335 = iter1_335

			arg0_335:DoTalk(iter1_335)

			break
		end
	end

	if var0_335 and pg.dorm3d_dialogue_group[var0_335].extend_loading > 0 then
		arg0_335.contextData.hasEnterCheck = true

		pg.SceneAnimMgr.GetInstance():RegisterDormNextCall(function()
			arg0_335:FinishEnterResume()
		end)
	else
		if arg0_335.apartment and arg0_335.contextData.pendingDic[arg0_335.apartment:GetConfigID()] then
			arg0_335.contextData.hasEnterCheck = true
		end

		for iter2_335, iter3_335 in pairs(arg0_335.contextData.pendingDic) do
			arg0_335:SetInPending(arg0_335.ladyDict[iter2_335], iter3_335)
		end

		arg0_335.contextData.pendingDic = {}

		arg0_335:FinishEnterResume()
		arg0_335:CheckQueue()
	end
end

function var0_0.CheckGuide(arg0_338)
	if arg0_338:GetBlackboardValue(arg0_338:GetCurrentLadyEnv(), "inPending") then
		return
	end

	if DORM_LOCK_GUIDE then
		return false
	end

	for iter0_338, iter1_338 in ipairs({
		{
			name = "DORM3D_GUIDE_03",
			active = function()
				return true
			end
		},
		{
			name = "DORM3D_GUIDE_04",
			active = function()
				return true
			end
		},
		{
			name = "DORM3D_GUIDE_05",
			active = function()
				return arg0_338:CheckSystemOpen("Furniture")
			end
		},
		{
			name = "DORM3D_GUIDE_07",
			active = function()
				return arg0_338:CheckSystemOpen("DayNight")
			end
		}
	}) do
		if not pg.NewStoryMgr.GetInstance():IsPlayed(iter1_338.name) and iter1_338.active() then
			arg0_338:SetAllBlackbloardValue("inGuide", true)

			local function var0_338()
				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(2, pg.NewStoryMgr.GetInstance():StoryName2StoryId(iter1_338.name)))
				arg0_338:SetAllBlackbloardValue("inGuide", false)
			end

			pg.m02:sendNotification(GAME.STORY_UPDATE, {
				storyId = iter1_338.name
			})
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(1, pg.NewStoryMgr.GetInstance():StoryName2StoryId(iter1_338.name)))
			pg.NewGuideMgr.GetInstance():Play(iter1_338.name, nil, var0_338, var0_338)

			return true
		end
	end

	return false
end

function var0_0.CheckFavorTrigger(arg0_344)
	for iter0_344, iter1_344 in ipairs({
		{
			triggerId = getDorm3dGameset("drom3d_favir_trigger_onwer")[1],
			active = function()
				local var0_345 = getProxy(CollectionProxy):getShipGroup(arg0_344.apartment.configId)

				return tobool(var0_345)
			end
		},
		{
			triggerId = getDorm3dGameset("drom3d_favir_trigger_propose")[1],
			active = function()
				local var0_346 = getProxy(CollectionProxy):getShipGroup(arg0_344.apartment.configId)

				return var0_346 and var0_346.married > 0
			end
		}
	}) do
		if arg0_344.apartment.triggerCountDic[iter1_344.triggerId] == 0 and iter1_344.active() then
			arg0_344:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_344.apartment.configId, iter1_344.triggerId)
		end
	end
end

function var0_0.CheckEnterDeal(arg0_347)
	if arg0_347.contextData.hasEnterCheck then
		return false
	end

	local var0_347 = arg0_347.apartment:GetConfigID()
	local var1_347 = "dorm3d_enter_count_" .. var0_347
	local var2_347 = pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d")

	if PlayerPrefs.GetString("dorm3d_enter_count_day") ~= var2_347 then
		PlayerPrefs.SetString("dorm3d_enter_count_day", var2_347)
		PlayerPrefs.SetInt(var1_347, 1)
	else
		PlayerPrefs.SetInt(var1_347, PlayerPrefs.GetInt(var1_347, 0) + 1)
	end

	local var3_347 = arg0_347.apartment:getEnterTalking(arg0_347.room:GetConfigID())

	PlayerPrefs.SetString("DORM3D_DAILY_ENTER", pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d"))

	if #var3_347 > 0 then
		arg0_347:DoTalk(var3_347[math.random(#var3_347)])

		return true
	end
end

function var0_0.CheckActiveTalk(arg0_348)
	local var0_348 = arg0_348:GetCurrentLadyEnv()

	if arg0_348:GetBlackboardValue(var0_348, "inPending") then
		return false
	end

	local var1_348 = arg0_348.apartment:getZoneTalking(arg0_348.room:GetConfigID(), var0_348.ladyBaseZone)

	if #var1_348 > 0 then
		arg0_348:DoTalk(var1_348[1])

		return true
	else
		return false
	end
end

function var0_0.CheckDistanceTalk(arg0_349, arg1_349, arg2_349)
	local var0_349 = arg0_349.ladyDict[arg1_349].ladyBaseZone
	local var1_349 = getProxy(ApartmentProxy):getApartment(arg1_349)

	for iter0_349, iter1_349 in ipairs(var1_349:getDistanceTalking(arg0_349.room:GetConfigID(), var0_349)) do
		arg0_349:DoTalk(iter1_349)

		return
	end
end

function var0_0.CheckSystemOpen(arg0_350, arg1_350)
	if arg0_350.room:isPersonalRoom() then
		return switch(arg1_350, {
			Talk = function()
				local var0_351 = 1

				return var0_351 <= arg0_350.apartment.level, i18n("apartment_level_unenough", var0_351)
			end,
			Touch = function()
				local var0_352 = getDorm3dGameset("drom3d_touch_dialogue")[1]

				return var0_352 <= arg0_350.apartment.level, i18n("apartment_level_unenough", var0_352)
			end,
			Gift = function()
				local var0_353 = getDorm3dGameset("drom3d_gift_dialogue")[1]

				return var0_353 <= arg0_350.apartment.level, i18n("apartment_level_unenough", var0_353)
			end,
			PublicGame = function()
				return false
			end,
			Photo = function()
				local var0_355 = getDorm3dGameset("drom3d_photograph_unlock")[1]

				return var0_355 <= arg0_350.apartment.level, i18n("apartment_level_unenough", var0_355)
			end,
			Collection = function()
				local var0_356 = getDorm3dGameset("drom3d_recall_unlock")[1]

				return var0_356 <= arg0_350.apartment.level, i18n("apartment_level_unenough", var0_356)
			end,
			Furniture = function()
				local var0_357 = getDorm3dGameset("drom3d_furniture_unlock")[1]

				return var0_357 <= arg0_350.apartment.level, i18n("apartment_level_unenough", var0_357)
			end,
			DayNight = function()
				local var0_358 = getDorm3dGameset("drom3d_time_unlock")[1]

				return var0_358 <= arg0_350.apartment.level, i18n("apartment_level_unenough", var0_358)
			end,
			Accompany = function()
				local var0_359 = 1

				return var0_359 <= arg0_350.apartment.level, i18n("apartment_level_unenough", var0_359)
			end,
			MiniGame = function()
				local var0_360 = 1

				if var0_360 > arg0_350.apartment.level then
					return false, i18n("apartment_level_unenough", var0_360)
				elseif #arg0_350.room:getMiniGames() <= 0 then
					return false, "without minigame config in room:" .. arg0_350.room.configId
				else
					return true
				end
			end,
			Invite = function()
				return false
			end,
			Performance = function()
				return IsUnityEditor
			end
		}, function()
			return true
		end)
	else
		return switch(arg1_350, {
			Gift = function()
				return false
			end,
			PublicGame = function()
				return true
			end,
			Furniture = function()
				local var0_366 = #arg0_350.room:GetFurnitures() > 0
				local var1_366 = #_.filter(arg0_350.room:GetFurnitureIDList() or {}, function(arg0_367)
					return Dorm3dFurniture.New({
						configId = arg0_367
					}):InShopTime()
				end) > 0

				return var0_366 or var1_366
			end,
			DayNight = function()
				return false
			end,
			Accompany = function()
				return false
			end,
			MiniGame = function()
				return false
			end,
			Performance = function()
				return IsUnityEditor
			end
		}, function()
			return true
		end)
	end
end

function var0_0.CheckLevelUp(arg0_373)
	if arg0_373.apartment:canLevelUp() then
		arg0_373:emit(Dorm3dRoomMediator.FAVOR_LEVEL_UP, arg0_373.apartment.configId)

		return true
	end

	return false
end

function var0_0.GetIKHandTF(arg0_374)
	return arg0_374.ikHand
end

function var0_0.CycleIKCameraGroup(arg0_375)
	local var0_375 = arg0_375:GetCurrentLadyEnv()

	assert(arg0_375:GetBlackboardValue(var0_375, "inIK"))
	seriesAsync({
		function(arg0_376)
			pg.IKMgr.GetInstance():ResetActiveIKs()

			local var0_376 = var0_375.ikConfig
			local var1_376 = var0_376.camera_group
			local var2_376 = pg.dorm3d_ik_status.get_id_list_by_camera_group[var1_376]
			local var3_376 = var2_376[table.indexof(var2_376, var0_376.id) % #var2_376 + 1]

			arg0_375:SwitchIKConfig(var0_375, var3_376)
			arg0_375:SetIKState(true)
		end
	})
end

function var0_0.TempHideUI(arg0_377, arg1_377, arg2_377)
	local var0_377 = defaultValue(arg0_377.hideCount, 0)

	arg0_377.hideCount = var0_377 + (arg1_377 and 1 or -1)

	assert(arg0_377.hideCount >= 0)

	if arg0_377.hideCount * var0_377 > 0 then
		return existCall(arg2_377)
	elseif arg0_377.hideCount > 0 then
		arg0_377:SetUI(arg2_377, "blank")
	else
		arg0_377:SetUI(arg2_377, "back")
	end
end

function var0_0.onBackPressed(arg0_378)
	if arg0_378.exited or arg0_378.retainCount > 0 then
		-- block empty
	elseif isActive(arg0_378.rtLevelUpWindow) then
		triggerButton(arg0_378.rtLevelUpWindow:Find("bg"))
	elseif arg0_378.uiState ~= "base" then
		-- block empty
	else
		arg0_378:closeView()
	end
end

function var0_0.willExit(arg0_379)
	if arg0_379.downTimer then
		arg0_379.downTimer:Stop()

		arg0_379.downTimer = nil
	end

	if arg0_379.LTs then
		underscore.map(arg0_379.LTs, function(arg0_380)
			LeanTween.cancel(arg0_380)
		end)

		arg0_379.LTs = nil
	end

	if arg0_379.sliderLT then
		LeanTween.cancel(arg0_379.sliderLT)

		arg0_379.sliderLT = nil
	end

	for iter0_379, iter1_379 in pairs(arg0_379.ladyDict) do
		iter1_379.wakeUpTalkId = nil
	end

	if arg0_379.accompanyFavorTimer then
		arg0_379.accompanyFavorTimer:Stop()

		arg0_379.accompanyFavorTimer = nil
	end

	if arg0_379.accompanyPerformanceTimer then
		arg0_379.accompanyPerformanceTimer:Stop()

		arg0_379.accompanyPerformanceTimer = nil
	end

	arg0_379.canTriggerAccompanyPerformance = nil

	arg0_379.videoPlayer:Destroy()
	var0_0.super.willExit(arg0_379)
end

return var0_0
