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
		end,
		function(arg0_191, arg1_191)
			return function()
				local var0_192 = arg0_168.apartment:GetConfigID()

				arg0_168.ikSwitchSkinId = arg0_168.apartment:GetCurSkinId()

				arg1_168:SwitchCharacterSkin(var0_192, arg0_191)
				arg0_168:SwitchIKConfig(arg1_168, arg1_191)
				arg0_168:SetIKState(true)
			end
		end
	}, function()
		return function()
			return
		end
	end, ...)
end

function var0_0.OnTriggerIK(arg0_195, arg1_195)
	local var0_195 = arg0_195:GetCurrentLadyEnv()

	if var0_195.ikTimelineMode then
		arg0_195:ExitIKTimelineStatus(var0_195)

		local var1_195 = arg1_195:GetTimelineAction()

		if var1_195 then
			arg0_195.nowTimelinePlayer:TriggerEvent(var1_195)
		end

		return
	end

	if not var0_195.ikConfig then
		return
	end

	local var2_195 = arg1_195:GetControllerPath()
	local var3_195 = var0_195.ikActionDict[var2_195]

	if not var3_195 then
		return
	end

	arg0_195.blockIK = true

	arg0_195:TouchModeAction(var0_195, arg1_195:GetConfigID(), unpack(var3_195))(function()
		arg0_195:ResetIKTipTimer()

		arg0_195.blockIK = nil
	end)
end

function var0_0.OnTouchCharacterBody(arg0_197, arg1_197)
	local var0_197 = arg0_197:GetCurrentLadyEnv()

	if not var0_197.ikConfig then
		return
	end

	if type(var0_197.ikConfig.touch_data) ~= "table" then
		return
	end

	for iter0_197, iter1_197 in ipairs(var0_197.iKTouchDatas) do
		local var1_197, var2_197, var3_197 = unpack(iter1_197)
		local var4_197 = pg.dorm3d_ik_touch[var1_197]

		if var4_197.body == arg1_197 then
			local var5_197 = var4_197.action_emote

			if #var5_197 > 0 then
				arg0_197:PlayFaceAnim(var0_197, var5_197)
			end

			local var6_197 = var4_197.vibrate

			if type(var6_197) == "table" and VibrateMgr.Instance:IsSupport() then
				local var7_197 = {}
				local var8_197 = {}
				local var9_197 = {}

				underscore.each(var6_197, function(arg0_198)
					local var0_198 = arg0_198[1]

					if PLATFORM == PLATFORM_IPHONEPLAYER then
						var0_198 = var0_198 / 1000
					end

					table.insert(var7_197, var0_198)
					table.insert(var8_197, arg0_198[2])
					table.insert(var9_197, 1)
				end)

				if PLATFORM == PLATFORM_ANDROID then
					VibrateMgr.Instance:VibrateWaveform(var7_197, var8_197)
				elseif PLATFORM == PLATFORM_IPHONEPLAYER then
					VibrateMgr.Instance:VibrateWaveform(var7_197, var8_197, var9_197)
				end
			end

			arg0_197.blockIK = true

			arg0_197:TouchModeAction(var0_197, var1_197, unpack(var3_197))(function()
				arg0_197:ResetIKTipTimer()

				arg0_197.blockIK = nil
			end)

			return
		end
	end
end

function var0_0.UpdateTouchGameDisplay(arg0_200)
	setActive(arg0_200.rtTouchGamePanel:Find("effect_bg"), arg0_200.touchLevel == 2)
	setActive(arg0_200.rtTouchGamePanel:Find("slider/icon/beating"), arg0_200.touchLevel == 2)

	if arg0_200.touchLevel == 1 then
		setActive(arg0_200.uiContainer:Find("ik/btn_back"), true)
		setActive(arg0_200.uiContainer:Find("ik/btn_back_heartbeat"), false)
		quickPlayAnimation(arg0_200.rtTouchGamePanel, "anim_dorm3d_touch_change_out")
		quickPlayAnimation(arg0_200.rtTouchGamePanel:Find("slider/icon"), "anim_dorm3d_touch_icon")
	elseif arg0_200.touchLevel == 2 then
		setActive(arg0_200.uiContainer:Find("ik/btn_back"), false)
		setActive(arg0_200.uiContainer:Find("ik/btn_back_heartbeat"), true)
		quickPlayAnimation(arg0_200.rtTouchGamePanel, "anim_dorm3d_touch_change")
		quickPlayAnimation(arg0_200.rtTouchGamePanel:Find("slider/icon"), "anim_dorm3d_touch_icon_1")
		pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_heartbeat")
	end
end

function var0_0.UpdateTouchCount(arg0_201, arg1_201)
	if arg0_201.touchLevel > 1 then
		arg1_201 = math.min(0, arg1_201)
	end

	arg0_201.touchCount = math.clamp(arg0_201.touchCount + arg1_201, 0, 100)

	if arg0_201.sliderLT and LeanTween.isTweening(arg0_201.sliderLT) then
		LeanTween.cancel(arg0_201.sliderLT)

		arg0_201.sliderLT = nil
	end

	setSlider(arg0_201.rtTouchGamePanel:Find("slider"), 0, 100, arg0_201.touchCount)

	local var0_201

	if arg0_201.touchCount >= 100 then
		var0_201 = 2
	elseif arg0_201.touchCount <= 0 then
		var0_201 = 1
	end

	if var0_201 and var0_201 ~= arg0_201.touchLevel then
		if arg0_201.blockIK then
			return
		end

		arg0_201.touchLevel = var0_201

		local var1_201 = arg0_201.touchConfig.ik_status[var0_201]

		if var1_201 then
			if var0_201 > 1 then
				arg0_201.touchCount = 200
			elseif var0_201 == 1 then
				arg0_201.touchCount = 0
			end

			local var2_201 = arg0_201:GetCurrentLadyEnv()

			seriesAsync({
				function(arg0_202)
					arg0_201:ShowBlackScreen(true, arg0_202)
				end,
				function(arg0_203)
					arg0_201:SwitchIKConfig(var2_201, var1_201)
					arg0_201:SetIKState(true, arg0_203)

					if var0_201 > 1 and arg0_201.touchConfig.heartbeat_enter_anim ~= "" then
						arg0_201:SwitchAnim(var2_201, arg0_201.touchConfig.heartbeat_enter_anim)
					end
				end,
				function(arg0_204)
					arg0_201:ShowBlackScreen(false, arg0_204)
				end
			})
		end

		arg0_201:UpdateTouchCount(0)
		arg0_201:UpdateTouchGameDisplay()
	end

	arg0_201.topCount = math.max(arg0_201.topCount, arg0_201.touchCount)
end

function var0_0.ExitHeartbeatMode(arg0_205)
	if not arg0_205.touchLevel or arg0_205.touchLevel == 1 then
		return
	end

	arg0_205.touchCount = 0

	arg0_205:UpdateTouchCount(0)
end

function var0_0.DoTouch(arg0_206, arg1_206, arg2_206)
	if arg0_206.inTouchGame then
		switch(arg2_206, {
			function()
				arg0_206:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat.key_value_int)
			end,
			function()
				arg0_206:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat.key_value_int)
			end,
			function()
				arg0_206:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat.key_value_int)
			end,
			function()
				arg0_206:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat_trriger.key_value_int)
			end
		})
	end
end

function var0_0.DoTalk(arg0_211, arg1_211, arg2_211)
	while rawget(arg0_211, "class") ~= var0_0 do
		arg0_211 = getmetatable(arg0_211).__index
	end

	if arg0_211.apartment and arg0_211:GetBlackboardValue(arg0_211:GetCurrentLadyEnv(), "inTalking") then
		errorMsg("Talking block:" .. arg1_211)

		return
	end

	if not arg0_211.room:isPersonalRoom() then
		local var0_211 = pg.dorm3d_dialogue_group[arg1_211].char_id

		if arg0_211.apartment then
			assert(arg0_211.apartment:GetConfigID() == var0_211)
		else
			arg0_211:SetApartment(getProxy(ApartmentProxy):getApartment(var0_211))
		end
	end

	local var1_211 = arg0_211:GetCurrentLadyEnv()

	if arg1_211 == 10010 and not arg0_211.apartment.talkDic[arg1_211] then
		arg0_211.firstTimelineTouch = true
		arg0_211.firstMoveGuide = true
	end

	getProxy(Dorm3dChatProxy):TriggerEvent({
		{
			value = 1,
			event_type = arg0_211.contextData.timeIndex == 1 and 110 or 115,
			ship_id = arg0_211.apartment:GetConfigID()
		},
		{
			value = 1,
			event_type = 155,
			ship_id = arg0_211.apartment:GetConfigID()
		}
	})

	local var2_211 = {}

	if arg0_211:GetBlackboardValue(var1_211, "inPending") then
		table.insert(var2_211, function(arg0_212)
			arg0_211:OutOfLazy(arg0_211.apartment:GetConfigID(), arg0_212)
		end)
	end

	local var3_211 = pg.dorm3d_dialogue_group[arg1_211]
	local var4_211 = var3_211.performance_type == 1
	local var5_211

	table.insert(var2_211, function(arg0_213)
		arg0_211:emit(arg0_211.SHOW_BLOCK)
		arg0_211:SetBlackboardValue(var1_211, var4_211 and "inPerformance" or "inTalking", true)
		arg0_211:emit(Dorm3dRoomMediator.DO_TALK, arg1_211, function(arg0_214)
			var5_211 = arg0_214

			arg0_213()
		end)
	end)
	table.insert(var2_211, function(arg0_215)
		pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataDialog(arg0_211.apartment.configId, arg0_211.apartment.level, arg1_211, var3_211.type, arg0_211.room:getZoneConfig(arg0_211:GetCurrentLadyEnv().ladyBaseZone, "id"), var3_211.action_type, table.CastToString(var3_211.trigger_config), arg0_211.room:GetConfigID()))

		if pg.NewGuideMgr.GetInstance():IsBusy() then
			pg.NewGuideMgr.GetInstance():Pause()
		end

		arg0_211:SetUI(arg0_215, "blank")
	end)

	if var3_211.trigger_area and var3_211.trigger_area ~= "" then
		table.insert(var2_211, function(arg0_216)
			arg0_211:ShiftZone(var3_211.trigger_area, arg0_216)
		end)
	end

	if var3_211.performance_type == 0 then
		table.insert(var2_211, function(arg0_217)
			arg0_211:emit(arg0_211.HIDE_BLOCK)

			if arg0_211.contextData.isVideoTalk then
				arg0_211.videoPlayer:ExecuteAction("Play", var3_211.story, function()
					onDelayTick(arg0_217, 0.001)
				end)
			else
				pg.NewStoryMgr.GetInstance():ForceManualPlay(var3_211.story, function()
					onDelayTick(arg0_217, 0.001)
				end, true)
			end
		end)
	elseif var3_211.performance_type == 1 then
		table.insert(var2_211, function(arg0_220)
			arg0_211:emit(arg0_211.HIDE_BLOCK)
			arg0_211:PerformanceQueue(var3_211.story, arg0_220)
		end)
	else
		assert(false)
	end

	table.insert(var2_211, function(arg0_221)
		arg0_211:emit(arg0_211.SHOW_BLOCK)
		arg0_221()
	end)
	table.insert(var2_211, function(arg0_222)
		local var0_222 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(var3_211.story)

		if var0_222 then
			local var1_222 = "1"

			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataStory(var0_222, var1_222))
		end

		if var5_211 and #var5_211 > 0 then
			arg0_211:emit(Dorm3dRoomMediator.OPEN_DROP_LAYER, var5_211, arg0_222)
		else
			arg0_222()
		end
	end)
	table.insert(var2_211, function(arg0_223)
		if pg.NewGuideMgr.GetInstance():IsPause() then
			pg.NewGuideMgr.GetInstance():Resume()
		end

		arg0_211:emit(arg0_211.HIDE_BLOCK)

		if arg0_211.contextData.isVideoTalk then
			existCall(arg0_223)
		else
			arg0_211:SetBlackboardValue(var1_211, var4_211 and "inPerformance" or "inTalking", false)
			arg0_211:SetUI(arg0_223, "back")
		end
	end)
	seriesAsync(var2_211, function()
		if arg2_211 then
			return arg2_211()
		else
			arg0_211:CheckQueue()
		end
	end)
end

function var0_0.DoTalkTouchOption(arg0_225, arg1_225, arg2_225, arg3_225)
	local var0_225 = arg0_225.rtExtraScreen:Find("TalkTouchOption")
	local var1_225
	local var2_225 = var0_225:Find("content")

	UIItemList.StaticAlign(var2_225, var2_225:Find("clickTpl"), #arg1_225.options, function(arg0_226, arg1_226, arg2_226)
		arg1_226 = arg1_226 + 1

		if arg0_226 == UIItemList.EventUpdate then
			local var0_226 = arg1_225.options[arg1_226]

			setAnchoredPosition(arg2_226, NewPos(unpack(var0_226.pos)))
			onButton(arg0_225, arg2_226, function()
				var1_225(var0_226.flag)
			end, SFX_CONFIRM)
			setActive(arg2_226, not table.contains(arg2_225, var0_226.flag))
		end
	end)
	setActive(var0_225, true)

	function var1_225(arg0_228)
		setActive(var0_225, false)
		arg3_225(arg0_228)
	end
end

function var0_0.DoTimelineOption(arg0_229, arg1_229, arg2_229)
	local var0_229 = arg0_229.rtTimelineScreen:Find("TimelineOption")
	local var1_229
	local var2_229 = var0_229:Find("content")

	UIItemList.StaticAlign(var2_229, var2_229:Find("clickTpl"), #arg1_229, function(arg0_230, arg1_230, arg2_230)
		arg1_230 = arg1_230 + 1

		if arg0_230 == UIItemList.EventUpdate then
			local var0_230 = arg1_229[arg1_230]

			setText(arg2_230:Find("Text"), HXSet.hxLan(var0_230.content))
			onButton(arg0_229, arg2_230, function()
				var1_229(arg1_230)
			end, SFX_CONFIRM)
		end
	end)
	setActive(var0_229, true)

	function var1_229(arg0_232)
		setActive(var0_229, false)
		arg2_229(arg0_232)
	end
end

function var0_0.DoTimelineTouch(arg0_233, arg1_233, arg2_233)
	local var0_233 = arg0_233.rtTimelineScreen:Find("TimelineTouch")
	local var1_233
	local var2_233 = var0_233:Find("content")

	UIItemList.StaticAlign(var2_233, var2_233:Find("clickTpl"), #arg1_233, function(arg0_234, arg1_234, arg2_234)
		arg1_234 = arg1_234 + 1

		if arg0_234 == UIItemList.EventUpdate then
			local var0_234 = arg1_233[arg1_234]

			setAnchoredPosition(arg2_234, NewPos(unpack(var0_234.pos)))
			onButton(arg0_233, arg2_234, function()
				var1_233(arg1_234)
			end, SFX_CONFIRM)

			if arg0_233.firstTimelineTouch then
				arg0_233.firstTimelineTouch = nil

				setActive(arg2_234:Find("finger"), true)
			end
		end
	end)
	setActive(var0_233, true)

	function var1_233(arg0_236)
		setActive(var0_233, false)
		arg2_233(arg0_236)
	end
end

function var0_0.DoShortWait(arg0_237, arg1_237)
	local var0_237 = arg0_237.ladyDict[arg1_237]
	local var1_237 = getProxy(ApartmentProxy):getApartment(arg1_237)
	local var2_237 = arg0_237.room:getApartmentZoneConfig(var0_237.ladyBaseZone, "special_action", arg1_237)
	local var3_237 = var2_237 and var2_237[math.random(#var2_237)] or nil

	if not var3_237 then
		return
	end

	arg0_237:PlaySingleAction(var0_237, var3_237)
end

function var0_0.OutOfLazy(arg0_238, arg1_238, arg2_238)
	local var0_238 = arg0_238.ladyDict[arg1_238]
	local var1_238 = {}

	if arg0_238:GetBlackboardValue(var0_238, "inPending") then
		table.insert(var1_238, function(arg0_239)
			arg0_238.shiftLady = arg1_238

			arg0_238:ShiftZone(var0_238.ladyBaseZone, arg0_239)
		end)
	end

	seriesAsync(var1_238, arg2_238)
end

function var0_0.OutOfPending(arg0_240, arg1_240, arg2_240)
	assert(arg0_240.wakeUpTalkId)

	local var0_240 = arg0_240.wakeUpTalkId

	seriesAsync({
		function(arg0_241)
			arg0_240:SetUI(arg0_241, "blank")
		end,
		function(arg0_242)
			arg0_240.shiftLady = arg1_240

			local var0_242 = arg0_240.ladyDict[arg1_240]

			arg0_240:ShiftZone(var0_242.ladyBaseZone, arg0_242)
		end,
		function(arg0_243)
			arg0_240:DoTalk(var0_240, arg0_243)
		end
	}, function()
		arg0_240:SetUIStore(arg2_240, "back")
	end)
end

function var0_0.ChangeCanWatchState(arg0_245, arg1_245)
	local var0_245

	if arg0_245:GetBlackboardValue(arg1_245, "inPending") then
		var0_245 = tobool(arg0_245:GetBlackboardValue(arg1_245, "inDistance"))
	else
		local var1_245 = arg0_245:GetBlackboardValue(arg1_245, "groupId")

		var0_245 = tobool(arg0_245.activeLady[var1_245] and pg.NodeCanvasMgr.GetInstance():GetBlackboradValue("canWatch", arg1_245.ladyBlackboard))
	end

	if arg1_245.blockCanWatch then
		var0_245 = false
	end

	if (not arg1_245.nowCanWatchState or arg1_245.nowCanWatchState ~= var0_245) and arg1_245.ladyWatchFloat then
		arg1_245.nowCanWatchState = var0_245

		arg0_245:ShowOrHideCanWatchMark(arg1_245, arg1_245.nowCanWatchState)
	end
end

function var0_0.HandleGameNotification(arg0_246, arg1_246, arg2_246)
	local var0_246 = arg0_246:GetCurrentLadyEnv()

	switch(arg1_246, {
		[Dorm3dMiniGameMediator.OPERATION] = function()
			local var0_247 = arg2_246.miniGameId

			switch(arg2_246.miniGameId, {
				[67] = function()
					if arg2_246.operationCode == "GAME_HIT_AREA" then
						local var0_248 = {
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
						local var1_248, var2_248 = unpack(var0_248[arg2_246.index])

						arg0_246:PlayFaceAnim(var0_246, var1_248)

						if arg0_246.tfCutIn then
							quickPlayAnimator(arg0_246.modelCutIn.lady, var2_248)
							quickPlayAnimator(arg0_246.modelCutIn.player, var2_248)
						end
					elseif arg2_246.operationCode == "GAME_RESULT" then
						if arg2_246.win then
							arg0_246:PlayFaceAnim(var0_246, "Face_XYX_victory")
							arg0_246:PlaySingleAction(var0_246, "minigame_win")
						else
							arg0_246:PlayFaceAnim(var0_246, "Face_XYX_lose")
							arg0_246:PlaySingleAction(var0_246, "minigame_lose")
						end

						setActive(arg0_246.rtExtraScreen:Find("MiniGameCutIn"), false)
					end
				end,
				[70] = function()
					if arg2_246.operationCode == "GAME_READY" then
						arg0_246.cameras[var0_0.CAMERA.TALK].Follow = nil
						arg0_246.cameras[var0_0.CAMERA.TALK].LookAt = nil

						arg0_246:PlaySingleAction(var0_246, "shuohua_sikao")
					elseif arg2_246.operationCode == "ROUND_RESULT" then
						local var0_249

						if arg2_246.success then
							var0_249 = {
								"shuohua_wenhou",
								"shuohua_sikao"
							}
						else
							var0_249 = {
								"shuohua_yaotou",
								"shuohua_sikao"
							}
						end

						seriesAsync(underscore.map(var0_249, function(arg0_250)
							return function(arg0_251)
								arg0_246:PlaySingleAction(var0_246, arg0_250, arg0_251)
							end
						end), function()
							return
						end)
					elseif arg2_246.operationCode == "GAME_RESULT" then
						local var1_249 = arg0_246.cameras[var0_0.CAMERA.TALK].transform

						var1_249.position = var1_249.position + var1_249.right * 0.11

						local var2_249 = {
							"shuohua_gandong"
						}

						seriesAsync(underscore.map(var2_249, function(arg0_253)
							return function(arg0_254)
								arg0_246:PlaySingleAction(var0_246, arg0_253, arg0_254)
							end
						end), function()
							return
						end)
					end
				end,
				[75] = function()
					if arg2_246.operationCode == "BEFORE_OPEN_GAME" then
						arg0_246.cameras[var0_0.CAMERA.TALK].Follow = nil
						arg0_246.cameras[var0_0.CAMERA.TALK].LookAt = nil
					elseif arg2_246.operationCode == "GAME_RPS_RESULT" then
						if arg2_246.index == 1 then
							arg0_246:PlaySingleAction(var0_246, "ab_shuohua_lianxuyaotou_01")
							arg0_246:PlayFaceAnim(var0_246, "Face_weixiao")
						elseif arg2_246.index == 2 then
							arg0_246:PlaySingleAction(var0_246, "ab_shuohua_lianxudiantou_01")
							arg0_246:PlayFaceAnim(var0_246, "Face_kaixin")
						end
					elseif arg2_246.operationCode == "GAME_RESULT" then
						if not arg2_246.win then
							arg0_246:PlaySingleAction(var0_246, "ab_shuohua_taibangle_01")
						end

						arg0_246:PlayFaceAnim(var0_246, "Face_kaixin")
					end
				end
			}, function()
				warning("without miniGameId:" .. arg2_246.miniGameId)
			end)

			if arg2_246.operationCode == "BEFORE_OPEN_GAME" then
				local var1_247 = getProxy(PlayerProxy):getPlayerId()
				local var2_247 = 0

				if var0_247 == 67 or var0_247 == 70 then
					var2_247 = PlayerPrefs.GetInt("mg_new_score_" .. tostring(var1_247) .. "_" .. arg2_246.miniGameId, 0)
				else
					var2_247 = PlayerPrefs.GetInt("mg_score_" .. tostring(var1_247) .. "_" .. arg2_246.miniGameId, 0)
				end

				arg0_246.highScore = var2_247
			elseif arg2_246.operationCode == "GAME_RESULT" then
				local var3_247 = arg2_246.score
				local var4_247 = getProxy(PlayerProxy):getPlayerId()

				if var3_247 > arg0_246.highScore then
					if var0_247 == 67 or var0_247 == 70 then
						PlayerPrefs.SetInt("mg_new_score_" .. tostring(var4_247) .. "_" .. arg2_246.miniGameId, var3_247)
					end

					getProxy(Dorm3dChatProxy):TriggerEvent({
						{
							event_type = 159,
							value = var3_247,
							ship_id = arg0_246.apartment:GetConfigID()
						}
					})
				end

				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataMiniGame(2, arg2_246.score))
			elseif arg2_246.operationCode == "GAME_CLOSE" and arg2_246.doTrack == false then
				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataMiniGame(3))
			end
		end
	})
end

function var0_0.PerformanceQueue(arg0_258, arg1_258, arg2_258)
	local var0_258, var1_258 = pcall(function()
		return require("GameCfg.dorm." .. arg1_258)
	end)

	if not var0_258 then
		errorMsg("不存在表演ID对应的Lua:" .. arg1_258)
		existCall(arg2_258)

		return
	end

	warning(arg1_258)

	arg0_258.performanceInfo = {
		name = arg1_258
	}

	local var2_258 = {}

	table.insert(var2_258, function(arg0_260)
		arg0_258:SetUI(arg0_260, "blank")
	end)
	table.insertto(var2_258, underscore.map(var1_258, function(arg0_261)
		return switch(arg0_261.type, {
			function()
				return function(arg0_263)
					local var0_263 = unpack(arg0_261.params)

					arg0_258:DoTalk(var0_263, arg0_263, true)
				end
			end,
			function()
				return function(arg0_265)
					arg0_258.touchExitCall = arg0_265

					arg0_258:EnterTouchMode()
				end
			end,
			function()
				return function(arg0_267)
					local var0_267 = arg0_258:GetCurrentLadyEnv()

					arg0_258:PlaySingleAction(var0_267, arg0_261.name, arg0_267)
				end
			end,
			function()
				return function(arg0_269)
					arg0_258:emit(arg0_258.PLAY_EXPRESSION, arg0_261)
					arg0_269()
				end
			end,
			function()
				return function(arg0_271)
					arg0_258:ShiftZone(arg0_261.name, arg0_271)
				end
			end,
			function()
				return function(arg0_273)
					arg0_258.contextData.timeIndex = arg0_261.params[1]

					local var0_273 = arg0_261.params[2] or false

					if Dorm3dSceneMgr.IsSameSceneInfo(arg0_258.dormSceneMgr.artSceneInfo, arg0_258.dormSceneMgr.sceneInfo) then
						arg0_258:SwitchDayNight(arg0_258.contextData.timeIndex)

						if var0_273 then
							onNextTick(function()
								arg0_258:RefreshSlots()
							end)
						end
					end

					arg0_258:UpdateContactState()
					onNextTick(arg0_273)
				end
			end,
			function()
				return function(arg0_276)
					if arg0_261.name then
						arg0_258:ActiveCameraByName(arg0_261.name)
						existCall(arg0_276)
					else
						arg0_258:ActiveStateCamera(arg0_261.params[1], arg0_276)
					end
				end
			end,
			function()
				return function(arg0_278)
					if arg0_261.name == "base" then
						arg0_258:RevertArtScene(arg0_258.dormSceneMgr.sceneInfo, arg0_278)
					else
						local var0_278 = arg0_261.params.scene
						local var1_278 = arg0_261.params.sceneRoot

						arg0_258:ChangeArtScene(var0_278 .. "|" .. var1_278, arg0_278)
					end
				end
			end,
			function()
				return function(arg0_280)
					local var0_280 = arg0_261.params.name

					if arg0_261.name == "load" then
						local var1_280 = tobool(arg0_261.params.wait_timeline) and function(arg0_281)
							arg0_258.waitForTimeline = arg0_281
						end

						arg0_258:LoadTimelineScene(var0_280, true, var1_280, arg0_280)
					elseif arg0_261.name == "unload" then
						arg0_258:UnloadTimelineScene(var0_280, true, arg0_280)
					else
						assert(false)
					end
				end
			end,
			function()
				return function(arg0_283)
					setActive(arg0_258.uiContainer:Find("walk/btn_back"), false)

					local var0_283 = arg0_258:GetCurrentLadyEnv()

					if arg0_261.name == "change" then
						local var1_283 = arg0_261.params.scene
						local var2_283 = arg0_261.params.sceneRoot

						var0_283.walkBornPoint = arg0_261.params.point or "Default"

						arg0_258:ChangeWalkScene(arg0_261.name, var1_283 .. "|" .. var2_283, arg0_283)
					elseif arg0_261.name == "back" then
						var0_283.walkBornPoint = nil

						arg0_258:ChangeWalkScene(arg0_261.name, arg0_258.dormSceneMgr.sceneInfo, arg0_283)
					elseif arg0_261.name == "set" then
						local function var3_283()
							local var0_284 = arg0_283

							arg0_283 = nil

							return existCall(var0_284)
						end

						for iter0_283, iter1_283 in pairs(arg0_261.params) do
							switch(iter0_283, {
								back_button_trigger = function(arg0_285)
									onButton(arg0_258, arg0_258.uiContainer:Find("walk/btn_back"), var3_283, SFX_DORM_BACK)
									setActive(arg0_258.uiContainer:Find("walk/btn_back"), IsUnityEditor and arg0_285)
								end,
								near_trigger = function(arg0_286)
									if arg0_286 == true then
										arg0_286 = 1.5
									end

									if arg0_286 then
										function arg0_258.walkNearCallback(arg0_287)
											if arg0_287 < arg0_286 then
												arg0_258.walkNearCallback = nil

												var3_283()
											end
										end
									else
										arg0_258.walkNearCallback = nil
									end
								end
							}, nil, iter1_283)
						end

						if arg0_258.firstMoveGuide then
							setActive(arg0_258.povLayer:Find("Guide"), arg0_258.firstMoveGuide)

							arg0_258.firstMoveGuide = nil
						end
					else
						assert(false)
					end
				end
			end,
			function()
				return function(arg0_289)
					if arg0_261.name == "set" then
						local var0_289 = arg0_258:GetCurrentLadyEnv()

						arg0_258:SwitchIKConfig(var0_289, arg0_261.params.state)
						setActive(arg0_258.uiContainer:Find("ik/btn_back"), not arg0_261.params.hide_back)

						arg0_258.ikSpecialCall = arg0_289

						arg0_258:SetIKState(true)
					elseif arg0_261.name == "back" then
						local var1_289 = arg0_258:GetCurrentLadyEnv()

						var1_289.ikConfig = arg0_261.params

						arg0_258:SetIKState(false, function()
							var1_289.ikConfig = nil

							existCall(arg0_289)
						end)
					else
						assert(false)
					end
				end
			end,
			function()
				return function(arg0_292)
					arg0_258.blackSceneInfo = setmetatable(arg0_261.params or {}, {
						__index = {
							color = "#000000",
							time = 0.3,
							delay = arg0_261.name == "show" and 0 or 0.5
						}
					})

					if arg0_261.name == "show" then
						arg0_258:ShowBlackScreen(true, arg0_292)
					elseif arg0_261.name == "hide" then
						arg0_258:ShowBlackScreen(false, arg0_292)
					else
						assert(false)
					end

					arg0_258.blackSceneInfo = nil
				end
			end,
			function()
				return function(arg0_294)
					local var0_294 = arg0_258:GetCurrentLadyEnv()

					if arg0_261.name == "set" then
						arg0_258:emit(Dorm3dStockingMgr.SET_STOCKING_STATUS, arg0_261.params)
					elseif arg0_261.name == "exit" then
						arg0_258:emit(Dorm3dStockingMgr.EXIT_STOCKING_STATUS)
					end
				end
			end
		})
	end))
	table.insert(var2_258, function(arg0_295)
		arg0_258:SetUI(arg0_295, "back")

		arg0_258.performanceInfo = nil
	end)
	seriesAsync(var2_258, arg2_258)
end

function var0_0.TriggerContact(arg0_296, arg1_296)
	arg0_296:emit(Dorm3dRoomMediator.COLLECTION_ITEM, {
		itemId = arg1_296,
		roomId = arg0_296.room:GetConfigID(),
		groupId = arg0_296.room:isPersonalRoom() and arg0_296.apartment:GetConfigID() or 0
	})
end

function var0_0.UpdateContactState(arg0_297)
	arg0_297:SetContactStateDic(arg0_297.room:getTriggerableCollectItemDic(arg0_297.contextData.timeIndex))
end

function var0_0.UpdateFavorDisplay(arg0_298)
	local var0_298, var1_298 = getProxy(ApartmentProxy):getStamina()

	setText(arg0_298.rtStaminaDisplay:Find("Text"), string.format("%d/%d", var0_298, var1_298))
	setActive(arg0_298.rtStaminaDisplay, false)

	if arg0_298.apartment then
		setText(arg0_298.rtFavorLevel:Find("rank/Text"), arg0_298.apartment.level)

		local var2_298, var3_298 = arg0_298.apartment:getFavor()
		local var4_298 = arg0_298.apartment:isMaxFavor()

		setActive(arg0_298.rtFavorLevel:Find("Max"), var4_298)
		setActive(arg0_298.rtFavorLevel:Find("Text"), not var4_298)
		setText(arg0_298.rtFavorLevel:Find("Text"), string.format("<color=#ff6698>%d</color>/%d", var2_298, var3_298))
	end

	setActive(arg0_298.rtFavorLevel:Find("red"), Dorm3dLevelLayer.IsShowRed())
end

function var0_0.UpdateBtnState(arg0_299)
	local var0_299 = not arg0_299.room:isPersonalRoom() or arg0_299:CheckSystemOpen("Furniture")
	local var1_299 = Dorm3dFurniture.IsTimelimitShopTip(arg0_299.room:GetConfigID())

	setActive(arg0_299.uiContainer:Find("base/left/btn_furniture/tipTimelimit"), var0_299 and var1_299)

	local var2_299 = Dorm3dFurniture.NeedViewTip(arg0_299.room:GetConfigID())

	setActive(arg0_299.uiContainer:Find("base/left/btn_furniture/tip"), var0_299 and not var1_299 and var2_299)
	setActive(arg0_299.uiContainer:Find("base/btn_back/main"), underscore(getProxy(ApartmentProxy):getRawData()):chain():values():filter(function(arg0_300)
		return tobool(arg0_300)
	end):any(function(arg0_301)
		return #arg0_301:getSpecialTalking() > 0 or arg0_301:getIconTip() == "main"
	end):value())
	setActive(arg0_299.uiContainer:Find("base/left/btn_collection/tip"), PlayerPrefs.GetInt("apartment_collection_item", 0) > 0 or PlayerPrefs.GetInt("apartment_collection_recall", 0) > 0)
end

function var0_0.AddUnlockDisplay(arg0_302, arg1_302)
	table.insert(arg0_302.unlockList, arg1_302)

	if not isActive(arg0_302.rtFavorUp) then
		setText(arg0_302.rtFavorUp:Find("Text"), table.remove(arg0_302.unlockList, 1))
		setActive(arg0_302.rtFavorUp, true)
	end
end

function var0_0.PopFavorTrigger(arg0_303, arg1_303)
	local var0_303 = arg1_303.triggerId
	local var1_303 = arg1_303.delta
	local var2_303 = arg1_303.cost
	local var3_303 = arg1_303.apartment
	local var4_303 = pg.dorm3d_favor_trigger[var0_303]

	if var4_303.is_repeat == 0 then
		if var0_303 == getDorm3dGameset("drom3d_favir_trigger_onwer")[1] then
			arg0_303:AddUnlockDisplay(i18n("dorm3d_own_favor"))
		elseif var0_303 == getDorm3dGameset("drom3d_favir_trigger_propose")[1] then
			arg0_303:AddUnlockDisplay(i18n("dorm3d_pledge_favor"))
		else
			arg0_303:AddUnlockDisplay(string.format("unknow favor trigger:%d unlock", var0_303))
		end
	elseif arg1_303.delta > 0 then
		local var5_303, var6_303 = var3_303:getFavor()
		local var7_303 = var5_303 + var1_303

		setText(arg0_303.rtFavorUpDaily:Find("bg/Text"), string.format("<size=48>+%d</size>", math.min(9999, var1_303)))
		setSlider(arg0_303.rtFavorUpDaily:Find("bg/slider"), 0, var6_303, var5_303)
		setAnchoredPosition(arg0_303.rtFavorUpDaily:Find("bg"), arg1_303.isGift and NewPos(-354, 223) or NewPos(-208, 105))

		local var8_303 = {}
		local var9_303 = arg0_303.rtFavorUpDaily:Find("bg/effect")

		eachChild(var9_303, function(arg0_304)
			setActive(arg0_304, false)
		end)

		local var10_303

		if var4_303.effect and var4_303.effect ~= "" then
			var10_303 = var9_303:Find(var4_303.effect .. "(Clone)")

			if not var10_303 then
				table.insert(var8_303, function(arg0_305)
					LoadAndInstantiateAsync("Dorm3D/Effect/Prefab/ExpressionUI", "uifx_dorm3d_yinfu01", function(arg0_306)
						setParent(arg0_306, var9_303)

						var10_303 = tf(arg0_306)

						arg0_305()
					end)
				end)
			else
				setActive(var10_303, true)
			end
		end

		local var11_303 = arg0_303.rtFavorUpDaily:GetComponent("DftAniEvent")

		var11_303:SetTriggerEvent(function(arg0_307)
			local var0_307 = GetComponent(arg0_303.rtFavorUpDaily:Find("bg/slider"), typeof(Slider))

			LeanTween.value(var5_303, var7_303, 0.5):setOnUpdate(System.Action_float(function(arg0_308)
				var0_307.value = arg0_308
			end)):setEase(LeanTweenType.easeInOutQuad):setDelay(0.165):setOnComplete(System.Action(function()
				LeanTween.delayedCall(0.165, System.Action(function()
					if arg0_303.exited then
						return
					end

					quickPlayAnimator(arg0_303.rtFavorUpDaily, "favor_out")
				end))
			end))
			pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_progaress_bar")
		end)
		var11_303:SetEndEvent(function(arg0_311)
			setActive(arg0_303.rtFavorUpDaily, false)
		end)
		seriesAsync(var8_303, function()
			local var0_312 = arg0_303.ladyDict[var3_303:GetConfigID()]

			setLocalPosition(arg0_303.rtFavorUpDaily, arg0_303:GetLocalPosition(arg0_303:GetScreenPosition(var0_312.ladyHeadCenter.position), arg0_303.rtFavorUpDaily.parent))
			setActive(arg0_303.rtFavorUpDaily, true)
			SetCompomentEnabled(arg0_303.rtFavorUpDaily, typeof(Animator), true)
			quickPlayAnimator(arg0_303.rtFavorUpDaily, "favor_open")

			if var2_303 > 0 then
				local var1_312, var2_312 = getProxy(ApartmentProxy):getStamina()

				setText(arg0_303.rtStaminaPop:Find("Text/Text (1)"), "-" .. var2_303)
				setText(arg0_303.rtStaminaPop:Find("Text"), string.format("%d/%d", var1_312 + var2_303, var2_312))
				setActive(arg0_303.rtStaminaPop, true)
			end
		end)
	end
end

function var0_0.PopFavorLevelUp(arg0_313, arg1_313, arg2_313, arg3_313)
	arg0_313.isLock = true

	LeanTween.delayedCall(0.33, System.Action(function()
		arg0_313.isLock = false
	end))

	local var0_313 = math.floor(arg1_313.level / 10)
	local var1_313 = math.fmod(arg1_313.level, 10)

	GetImageSpriteFromAtlasAsync("ui/favor_atlas", var1_313, arg0_313.rtLevelUpWindow:Find("panel/bg/item1/mark/level/digit2"))
	GetImageSpriteFromAtlasAsync("ui/favor_atlas", var0_313, arg0_313.rtLevelUpWindow:Find("panel/bg/item1/mark/level/digit1"))
	setActive(arg0_313.rtLevelUpWindow:Find("panel/bg/item1/mark/level/digit1"), var0_313 > 0)

	local var2_313
	local var3_313

	arg0_313.clientAward, var3_313 = Dorm3dIconHelper.SplitStory(arg1_313:getFavorConfig("levelup_client_item", arg1_313.level))
	arg0_313.serverAward = arg2_313

	local var4_313 = arg0_313.rtLevelUpWindow:Find("panel/info/content/itemContent")

	if not arg0_313.levelItemList then
		arg0_313.levelItemList = UIItemList.New(var4_313, var4_313:Find("tpl"))

		arg0_313.levelItemList:make(function(arg0_315, arg1_315, arg2_315)
			local var0_315 = arg1_315 + 1

			if arg0_315 == UIItemList.EventUpdate then
				if arg1_315 < #arg0_313.serverAward then
					updateDorm3dIcon(arg2_315, arg0_313.serverAward[var0_315])
					onButton(arg0_313, arg2_315, function()
						arg0_313:emit(BaseUI.ON_NEW_DROP, {
							style = "dorm",
							drop = arg0_313.serverAward[var0_315]
						})
					end, SFX_PANEL)
				else
					Dorm3dIconHelper.UpdateDorm3dIcon(arg2_315, arg0_313.clientAward[var0_315 - #arg0_313.serverAward])
					onButton(arg0_313, arg2_315, function()
						arg0_313:emit(Dorm3dRoomMediator.ON_DROP_CLIENT, {
							data = arg0_313.clientAward[var0_315 - #arg0_313.serverAward]
						})
					end, SFX_PANEL)
				end
			end
		end)
	end

	arg0_313.levelItemList:align(#arg0_313.serverAward + #arg0_313.clientAward)
	setActive(arg0_313.rtLevelUpWindow, true)
	pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_upgrade")
	arg0_313:OverlayPanel(arg0_313.rtLevelUpWindow)

	function arg0_313.levelUpCallback()
		arg0_313.levelUpCallback = nil

		if var3_313 then
			arg0_313:PopNewStoryTip(var3_313)
		end

		existCall(arg3_313)
	end
end

function var0_0.PopNewStoryTip(arg0_319, arg1_319, arg2_319)
	local var0_319 = arg0_319.uiContainer:Find("base/top/story_tip")

	setActive(var0_319, true)
	LeanTween.delayedCall(1, System.Action(function()
		setActive(var0_319, false)
	end))
	setText(var0_319:Find("Text"), i18n("dorm3d_story_unlock_tip", pg.dorm3d_recall[arg1_319[2]].name))
	existCall(arg2_319)
end

function var0_0.UpdateZoneList(arg0_321)
	local var0_321

	if arg0_321.room:isPersonalRoom() then
		var0_321 = arg0_321:GetCurrentLadyEnv().ladyBaseZone
	else
		var0_321 = arg0_321:GetAttachedFurnitureName()
	end

	for iter0_321, iter1_321 in ipairs(arg0_321.zoneDatas) do
		if iter1_321:GetWatchCameraName() == var0_321 then
			setText(arg0_321.btnZone:Find("Text"), iter1_321:GetName())
			setTextColor(arg0_321.rtZoneList:GetChild(iter0_321 - 1):Find("Name"), Color.NewHex("5CCAFF"))
		else
			setTextColor(arg0_321.rtZoneList:GetChild(iter0_321 - 1):Find("Name"), Color.NewHex("FFFFFF99"))
		end
	end
end

function var0_0.TalkingEventHandle(arg0_322, arg1_322)
	local var0_322 = {}
	local var1_322 = {}
	local var2_322 = arg1_322.data

	if var2_322.op_list then
		for iter0_322, iter1_322 in ipairs(var2_322.op_list) do
			table.insert(var0_322, function(arg0_323)
				local function var0_323()
					local var0_324 = arg0_323

					arg0_323 = nil

					return existCall(var0_324)
				end

				switch(iter1_322.type, {
					action = function()
						local var0_325 = arg0_322:GetCurrentLadyEnv()

						arg0_322:PlaySingleAction(var0_325, iter1_322.name, var0_323)
					end,
					item_action = function()
						arg0_322:PlaySceneItemAnim(iter1_322.id, iter1_322.name)
						var0_323()
					end,
					extra_item_action = function()
						local var0_327 = arg0_322:GetCurrentLadyEnv().extraItems[iter1_322.name]

						warning(iter1_322.name)
						warning(var0_327.trans)

						if var0_327 then
							var0_327.trans:GetComponent(typeof(Animator)):PlayInFixedTime(iter1_322.param)
						end

						var0_323()
					end,
					timeline = function()
						if arg0_322.inTouchGame then
							setActive(arg0_322.rtTouchGamePanel, false)
						end

						arg0_322:PlayTimeline(iter1_322, function(arg0_329, arg1_329)
							setActive(arg0_322.rtTouchGamePanel, arg0_322.inTouchGame)

							var1_322.notifiCallback = arg1_329

							var0_323()
						end)
					end,
					clickOption = function()
						arg0_322:DoTalkTouchOption(iter1_322, arg1_322.flags, function(arg0_331)
							var1_322.optionIndex = arg0_331

							var0_323()
						end)
					end,
					wait = function()
						arg0_322.LTs = arg0_322.LTs or {}

						table.insert(arg0_322.LTs, LeanTween.delayedCall(iter1_322.time, System.Action(var0_323)).uniqueId)
					end,
					expression = function()
						arg0_322:emit(arg0_322.PLAY_EXPRESSION, iter1_322)
						var0_323()
					end
				}, function()
					assert(false, "op type error:", iter1_322.type)
				end)

				if iter1_322.skip then
					var0_323()
				end
			end)
		end
	end

	seriesAsync(var0_322, function()
		if arg1_322.callbackData then
			arg0_322:emit(Dorm3dRoomMediator.TALKING_EVENT_FINISH, arg1_322.callbackData.name, var1_322)
		end
	end)
end

function var0_0.CheckQueue(arg0_336)
	if arg0_336.inGuide or arg0_336.uiState ~= "base" then
		return
	end

	if arg0_336.room:GetConfigID() == 1 and arg0_336:CheckGuide() then
		-- block empty
	elseif arg0_336.room:isPersonalRoom() and arg0_336:CheckLevelUp() then
		-- block empty
	elseif arg0_336.apartment and arg0_336:CheckEnterDeal() then
		-- block empty
	elseif arg0_336.apartment and arg0_336:CheckActiveTalk() then
		-- block empty
	elseif arg0_336.apartment then
		arg0_336:CheckFavorTrigger()
	end

	arg0_336.contextData.hasEnterCheck = true
end

function var0_0.didEnterCheck(arg0_337)
	local var0_337

	if arg0_337.contextData.specialId then
		var0_337 = arg0_337.contextData.specialId
		arg0_337.contextData.specialId = nil

		arg0_337:DoTalk(var0_337, function()
			arg0_337:closeView()
		end)

		if arg0_337.contextData.isVideoTalk then
			arg0_337.contextData.hasEnterCheck = true
		end
	elseif not arg0_337.contextData.hasEnterCheck and arg0_337.apartment then
		for iter0_337, iter1_337 in ipairs(arg0_337.apartment:getForceEnterTalking(arg0_337.room:GetConfigID())) do
			var0_337 = iter1_337

			arg0_337:DoTalk(iter1_337)

			break
		end
	end

	if var0_337 and pg.dorm3d_dialogue_group[var0_337].extend_loading > 0 then
		arg0_337.contextData.hasEnterCheck = true

		pg.SceneAnimMgr.GetInstance():RegisterDormNextCall(function()
			arg0_337:FinishEnterResume()
		end)
	else
		if arg0_337.apartment and arg0_337.contextData.pendingDic[arg0_337.apartment:GetConfigID()] then
			arg0_337.contextData.hasEnterCheck = true
		end

		for iter2_337, iter3_337 in pairs(arg0_337.contextData.pendingDic) do
			arg0_337:SetInPending(arg0_337.ladyDict[iter2_337], iter3_337)
		end

		arg0_337.contextData.pendingDic = {}

		arg0_337:FinishEnterResume()
		arg0_337:CheckQueue()
	end
end

function var0_0.CheckGuide(arg0_340)
	if arg0_340:GetBlackboardValue(arg0_340:GetCurrentLadyEnv(), "inPending") then
		return
	end

	if DORM_LOCK_GUIDE then
		return false
	end

	for iter0_340, iter1_340 in ipairs({
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
				return arg0_340:CheckSystemOpen("Furniture")
			end
		},
		{
			name = "DORM3D_GUIDE_07",
			active = function()
				return arg0_340:CheckSystemOpen("DayNight")
			end
		}
	}) do
		if not pg.NewStoryMgr.GetInstance():IsPlayed(iter1_340.name) and iter1_340.active() then
			arg0_340:SetAllBlackbloardValue("inGuide", true)

			local function var0_340()
				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(2, pg.NewStoryMgr.GetInstance():StoryName2StoryId(iter1_340.name)))
				arg0_340:SetAllBlackbloardValue("inGuide", false)
			end

			pg.m02:sendNotification(GAME.STORY_UPDATE, {
				storyId = iter1_340.name
			})
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(1, pg.NewStoryMgr.GetInstance():StoryName2StoryId(iter1_340.name)))
			pg.NewGuideMgr.GetInstance():Play(iter1_340.name, nil, var0_340, var0_340)

			return true
		end
	end

	return false
end

function var0_0.CheckFavorTrigger(arg0_346)
	for iter0_346, iter1_346 in ipairs({
		{
			triggerId = getDorm3dGameset("drom3d_favir_trigger_onwer")[1],
			active = function()
				local var0_347 = getProxy(CollectionProxy):getShipGroup(arg0_346.apartment.configId)

				return tobool(var0_347)
			end
		},
		{
			triggerId = getDorm3dGameset("drom3d_favir_trigger_propose")[1],
			active = function()
				local var0_348 = getProxy(CollectionProxy):getShipGroup(arg0_346.apartment.configId)

				return var0_348 and var0_348.married > 0
			end
		}
	}) do
		if arg0_346.apartment.triggerCountDic[iter1_346.triggerId] == 0 and iter1_346.active() then
			arg0_346:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_346.apartment.configId, iter1_346.triggerId)
		end
	end
end

function var0_0.CheckEnterDeal(arg0_349)
	if arg0_349.contextData.hasEnterCheck then
		return false
	end

	local var0_349 = arg0_349.apartment:GetConfigID()
	local var1_349 = "dorm3d_enter_count_" .. var0_349
	local var2_349 = pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d")

	if PlayerPrefs.GetString("dorm3d_enter_count_day") ~= var2_349 then
		PlayerPrefs.SetString("dorm3d_enter_count_day", var2_349)
		PlayerPrefs.SetInt(var1_349, 1)
	else
		PlayerPrefs.SetInt(var1_349, PlayerPrefs.GetInt(var1_349, 0) + 1)
	end

	local var3_349 = arg0_349.apartment:getEnterTalking(arg0_349.room:GetConfigID())

	PlayerPrefs.SetString("DORM3D_DAILY_ENTER", pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d"))

	if #var3_349 > 0 then
		arg0_349:DoTalk(var3_349[math.random(#var3_349)])

		return true
	end
end

function var0_0.CheckActiveTalk(arg0_350)
	local var0_350 = arg0_350:GetCurrentLadyEnv()

	if arg0_350:GetBlackboardValue(var0_350, "inPending") then
		return false
	end

	local var1_350 = arg0_350.apartment:getZoneTalking(arg0_350.room:GetConfigID(), var0_350.ladyBaseZone)

	if #var1_350 > 0 then
		arg0_350:DoTalk(var1_350[1])

		return true
	else
		return false
	end
end

function var0_0.CheckDistanceTalk(arg0_351, arg1_351, arg2_351)
	local var0_351 = arg0_351.ladyDict[arg1_351].ladyBaseZone
	local var1_351 = getProxy(ApartmentProxy):getApartment(arg1_351)

	for iter0_351, iter1_351 in ipairs(var1_351:getDistanceTalking(arg0_351.room:GetConfigID(), var0_351)) do
		arg0_351:DoTalk(iter1_351)

		return
	end
end

function var0_0.CheckSystemOpen(arg0_352, arg1_352)
	if arg0_352.room:isPersonalRoom() then
		return switch(arg1_352, {
			Talk = function()
				local var0_353 = 1

				return var0_353 <= arg0_352.apartment.level, i18n("apartment_level_unenough", var0_353)
			end,
			Touch = function()
				local var0_354 = getDorm3dGameset("drom3d_touch_dialogue")[1]

				return var0_354 <= arg0_352.apartment.level, i18n("apartment_level_unenough", var0_354)
			end,
			Gift = function()
				local var0_355 = getDorm3dGameset("drom3d_gift_dialogue")[1]

				return var0_355 <= arg0_352.apartment.level, i18n("apartment_level_unenough", var0_355)
			end,
			PublicGame = function()
				return false
			end,
			Photo = function()
				local var0_357 = getDorm3dGameset("drom3d_photograph_unlock")[1]

				return var0_357 <= arg0_352.apartment.level, i18n("apartment_level_unenough", var0_357)
			end,
			Collection = function()
				local var0_358 = getDorm3dGameset("drom3d_recall_unlock")[1]

				return var0_358 <= arg0_352.apartment.level, i18n("apartment_level_unenough", var0_358)
			end,
			Furniture = function()
				local var0_359 = getDorm3dGameset("drom3d_furniture_unlock")[1]

				return var0_359 <= arg0_352.apartment.level, i18n("apartment_level_unenough", var0_359)
			end,
			DayNight = function()
				local var0_360 = getDorm3dGameset("drom3d_time_unlock")[1]

				return var0_360 <= arg0_352.apartment.level, i18n("apartment_level_unenough", var0_360)
			end,
			Accompany = function()
				local var0_361 = 1

				return var0_361 <= arg0_352.apartment.level, i18n("apartment_level_unenough", var0_361)
			end,
			MiniGame = function()
				local var0_362 = 1

				if var0_362 > arg0_352.apartment.level then
					return false, i18n("apartment_level_unenough", var0_362)
				elseif #arg0_352.room:getMiniGames() <= 0 then
					return false, "without minigame config in room:" .. arg0_352.room.configId
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
		return switch(arg1_352, {
			Gift = function()
				return false
			end,
			PublicGame = function()
				return true
			end,
			Furniture = function()
				local var0_368 = #arg0_352.room:GetFurnitures() > 0
				local var1_368 = #_.filter(arg0_352.room:GetFurnitureIDList() or {}, function(arg0_369)
					return Dorm3dFurniture.New({
						configId = arg0_369
					}):InShopTime()
				end) > 0

				return var0_368 or var1_368
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

function var0_0.CheckLevelUp(arg0_375)
	if arg0_375.apartment:canLevelUp() then
		arg0_375:emit(Dorm3dRoomMediator.FAVOR_LEVEL_UP, arg0_375.apartment.configId)

		return true
	end

	return false
end

function var0_0.GetIKHandTF(arg0_376)
	return arg0_376.ikHand
end

function var0_0.CycleIKCameraGroup(arg0_377)
	local var0_377 = arg0_377:GetCurrentLadyEnv()

	assert(arg0_377:GetBlackboardValue(var0_377, "inIK"))
	seriesAsync({
		function(arg0_378)
			pg.IKMgr.GetInstance():ResetActiveIKs()

			local var0_378 = var0_377.ikConfig
			local var1_378 = var0_378.camera_group
			local var2_378 = pg.dorm3d_ik_status.get_id_list_by_camera_group[var1_378]
			local var3_378 = var2_378[table.indexof(var2_378, var0_378.id) % #var2_378 + 1]

			arg0_377:SwitchIKConfig(var0_377, var3_378)
			arg0_377:SetIKState(true)
		end
	})
end

function var0_0.TempHideUI(arg0_379, arg1_379, arg2_379)
	local var0_379 = defaultValue(arg0_379.hideCount, 0)

	arg0_379.hideCount = var0_379 + (arg1_379 and 1 or -1)

	assert(arg0_379.hideCount >= 0)

	if arg0_379.hideCount * var0_379 > 0 then
		return existCall(arg2_379)
	elseif arg0_379.hideCount > 0 then
		arg0_379:SetUI(arg2_379, "blank")
	else
		arg0_379:SetUI(arg2_379, "back")
	end
end

function var0_0.onBackPressed(arg0_380)
	if arg0_380.exited or arg0_380.retainCount > 0 then
		-- block empty
	elseif isActive(arg0_380.rtLevelUpWindow) then
		triggerButton(arg0_380.rtLevelUpWindow:Find("bg"))
	elseif arg0_380.uiState ~= "base" then
		-- block empty
	else
		arg0_380:closeView()
	end
end

function var0_0.willExit(arg0_381)
	if arg0_381.downTimer then
		arg0_381.downTimer:Stop()

		arg0_381.downTimer = nil
	end

	if arg0_381.LTs then
		underscore.map(arg0_381.LTs, function(arg0_382)
			LeanTween.cancel(arg0_382)
		end)

		arg0_381.LTs = nil
	end

	if arg0_381.sliderLT then
		LeanTween.cancel(arg0_381.sliderLT)

		arg0_381.sliderLT = nil
	end

	for iter0_381, iter1_381 in pairs(arg0_381.ladyDict) do
		iter1_381.wakeUpTalkId = nil
	end

	if arg0_381.accompanyFavorTimer then
		arg0_381.accompanyFavorTimer:Stop()

		arg0_381.accompanyFavorTimer = nil
	end

	if arg0_381.accompanyPerformanceTimer then
		arg0_381.accompanyPerformanceTimer:Stop()

		arg0_381.accompanyPerformanceTimer = nil
	end

	arg0_381.canTriggerAccompanyPerformance = nil

	arg0_381.videoPlayer:Destroy()
	var0_0.super.willExit(arg0_381)
end

return var0_0
