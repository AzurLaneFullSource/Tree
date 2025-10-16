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
	arg0_4.stockingView = Dorm3dStockingView.New(arg0_4._tf, arg0_4.event, setmetatable({
		GetTipShowInfo = function()
			return arg0_4.stockingMgr:GetTipShowInfo()
		end
	}, {
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
		local var0_8 = {}

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

		local var0_10, var1_10 = arg0_4:CheckSystemOpen("Photo")

		if not var0_10 then
			pg.TipsMgr.GetInstance():ShowTips(var1_10)

			return
		end

		if not arg0_4.apartment then
			local var2_10 = arg0_4.contextData.groupIds[1]

			for iter0_10, iter1_10 in pairs(arg0_4.ladyDict) do
				if iter1_10.ladyBaseZone == arg0_4:GetAttachedFurnitureName() then
					var2_10 = iter0_10

					break
				end
			end

			arg0_4:SetApartment(getProxy(ApartmentProxy):getApartment(var2_10))
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
		local var0_12, var1_12 = arg0_4:CheckSystemOpen("Collection")

		if not var0_12 then
			pg.TipsMgr.GetInstance():ShowTips(var1_12)

			return
		end

		setActive(var0_4:Find("left/btn_collection/tip"), false)
		PlayerPrefs.SetInt("apartment_collection_item", 0)
		PlayerPrefs.SetInt("apartment_collection_recall", 0)
		arg0_4:emit(Dorm3dRoomMediator.OPEN_COLLECTION_LAYER, arg0_4.room:GetConfigID())
	end, SFX_PANEL)
	onButton(arg0_4, var0_4:Find("left/btn_furniture"), function()
		local var0_13, var1_13 = arg0_4:CheckSystemOpen("Furniture")

		if not var0_13 then
			pg.TipsMgr.GetInstance():ShowTips(var1_13)

			return
		end

		arg0_4:RemoveExtraSystem({
			DormConst.EXTRA_SYSTEMS.FurnitureSlide
		})
		arg0_4:emit(Dorm3dRoomMediator.OPEN_FURNITURE_SELECT, {
			apartment = arg0_4.apartment
		})
	end, SFX_PANEL)

	if not arg0_4.room:isPersonalRoom() then
		local var1_4 = arg0_4:CheckSystemOpen("Furniture")

		setActive(var0_4:Find("left/line_furniture"), var1_4)
		setActive(var0_4:Find("left/btn_furniture"), var1_4)
	end

	onButton(arg0_4, var0_4:Find("left/btn_accompany"), function()
		local var0_14, var1_14 = arg0_4:CheckSystemOpen("Accompany")

		if not var0_14 then
			pg.TipsMgr.GetInstance():ShowTips(var1_14)

			return
		end

		local var2_14 = arg0_4.apartment:GetConfigID()
		local var3_14

		arg0_4:emit(Dorm3dRoomMediator.OPEN_ACCOMPANY_WINDOW, {
			groupId = var2_14,
			confirmFunc = function(arg0_15)
				var3_14 = arg0_15
			end
		}, function()
			if var3_14 then
				arg0_4:OutOfLazy(var2_14, function()
					arg0_4:EnterAccompanyMode(var3_14)
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
	UIItemList.StaticAlign(arg0_4.rtZoneList, arg0_4.rtZoneList:GetChild(0), #arg0_4.zoneDatas, function(arg0_22, arg1_22, arg2_22)
		if arg0_22 ~= UIItemList.EventUpdate then
			return
		end

		arg1_22 = arg1_22 + 1

		local var0_22 = arg0_4.zoneDatas[arg1_22]
		local var1_22 = var0_22:GetWatchCameraName()

		arg2_22.name = var1_22

		setText(arg2_22:Find("Name"), var0_22:GetName())
		setActive(arg2_22:Find("Line"), arg1_22 < #arg0_4.zoneDatas)
		onButton(arg0_4, arg2_22, function()
			if arg0_4.uiState ~= "base" then
				return
			end

			setActive(arg0_4.rtZoneList, false)

			local var0_23 = {}

			if arg0_4.room:isPersonalRoom() and not arg0_4:GetBlackboardValue(arg0_4:GetCurrentLadyEnv(), "inPending") then
				table.insert(var0_23, function(arg0_24)
					arg0_4:OutOfLazy(arg0_4.apartment:GetConfigID(), arg0_24)
				end)
			end

			table.insert(var0_23, function(arg0_25)
				arg0_4:ShiftZone(var1_22, arg0_25)
			end)
			seriesAsync(var0_23, function()
				arg0_4:CheckQueue()
			end)
		end, SFX_PANEL)
	end)

	local var2_4 = arg0_4.uiContainer:Find("walk")
	local var3_4 = arg0_4.uiContainer:Find("ik")

	onButton(arg0_4, var3_4:Find("btn_back"), function()
		if arg0_4.ikSpecialCall then
			local var0_27 = arg0_4.ikSpecialCall

			arg0_4.ikSpecialCall = nil

			existCall(var0_27)
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
		arg0_4:emit(Dorm3dRoomMediator.OPEN_SKIN_SELECT_LAYER, arg0_4.apartment:GetConfigID(), arg0_4:GetCurrentLadyEnv(), function(arg0_34, arg1_34, arg2_34)
			seriesAsync({
				function(arg0_35)
					arg0_4:SetIKState(false, arg0_35)
				end,
				function(arg0_36)
					arg0_34:SwitchCharacterSkin(arg1_34, arg2_34)
					arg0_4:SwitchIKConfig(arg0_34, arg0_34.ikConfig.id)
					arg0_4:SetIKState(true, arg0_36)
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
	eachChild(arg0_4.ikHand, function(arg0_38)
		setActive(arg0_38, false)
	end)

	arg0_4.ikTextTipsRoot = var4_4:Find("TextTips")

	setActive(arg0_4.ikTextTipsRoot, false)
	eachChild(arg0_4.ikTextTipsRoot, function(arg0_39)
		setActive(arg0_39, false)
	end)

	arg0_4.ikControlUI = var4_4

	local var5_4 = arg0_4.uiContainer:Find("accompany")

	onButton(arg0_4, var5_4:Find("btn_back"), function()
		arg0_4:ExitAccompanyMode()
	end, SFX_DORM_BACK)

	arg0_4.unlockList = {}
	arg0_4.rtFavorUp = arg0_4._tf:Find("Toast/favor_up")

	arg0_4.rtFavorUp:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_41)
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

	var6_4:SetTriggerEvent(function(arg0_42)
		local var0_42, var1_42 = getProxy(ApartmentProxy):getStamina()

		setText(arg0_4.rtStaminaPop:Find("Text"), string.format("%d/%d", var0_42, var1_42))
	end)
	var6_4:SetEndEvent(function(arg0_43)
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
		local var0_48 = arg0_4:GetCurrentLadyEnv().ladyBaseZone
		local var1_48 = arg0_4.apartment:getFurnitureTalking(arg0_4.room:GetConfigID(), var0_48)

		if #var1_48 == 0 then
			pg.TipsMgr.GetInstance():ShowTips("without topic")

			return
		end

		arg0_4:DoTalk(var1_48[math.random(#var1_48)], function()
			local var0_49 = getDorm3dGameset("drom3d_favir_trigger_talk")[1]

			arg0_4:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_4.apartment.configId, var0_49)
		end)
	end, SFX_DORM_CLICK)
	setText(arg0_4.rtRole:Find("Talk/bg/Text"), i18n("dorm3d_talk"))

	arg0_4.rtRoleTouchSubView = Dorm3dRTRoleTouchSubView.New(arg0_4.rtRole:Find("Touch"), arg0_4.event, setmetatable({
		onClick = function(arg0_50)
			arg0_4:EnterTouchMode(arg0_50)
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

		local var0_53 = pg.dorm3d_minigame[arg0_4.nowMiniGameId]
		local var1_53 = arg0_4:GetCurrentLadyEnv()

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

		local var2_53 = {}

		table.insert(var2_53, function(arg0_54)
			arg0_4:SetAllBlackbloardValue("inLockLayer", true)
			arg0_4:TempHideUI(true, arg0_54)
		end)

		if var0_53.area ~= "" and var1_53.ladyBaseZone ~= var0_53.area then
			table.insert(var2_53, function(arg0_55)
				arg0_4:ShiftZone(var0_53.area, arg0_55)
			end)
		end

		local var3_53
		local var4_53

		if var0_53.action ~= "" then
			var3_53, var4_53 = unpack(var0_53.action)
		end

		table.insert(var2_53, function(arg0_56)
			parallelAsync({
				function(arg0_57)
					if var3_53 then
						arg0_4:PlaySingleAction(var1_53, var3_53, arg0_57)
					else
						arg0_57()
					end
				end,
				function(arg0_58)
					arg0_4:ActiveStateCamera("talk", arg0_58)
				end
			}, arg0_56)
		end)
		table.insert(var2_53, function(arg0_59)
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataMiniGame(1))
			arg0_4:HandleGameNotification(Dorm3dMiniGameMediator.OPERATION, {
				operationCode = "BEFORE_OPEN_GAME",
				miniGameId = arg0_4.nowMiniGameId
			})
			arg0_4:EnableMiniGameCutIn()
			arg0_4:emit(Dorm3dRoomMediator.OPEN_MINIGAME_WINDOW, {
				isDorm3d = true,
				minigameId = arg0_4.nowMiniGameId
			}, arg0_59)
		end)
		table.insert(var2_53, function(arg0_60)
			arg0_4:DisableMiniGameCutIn()

			if var4_53 then
				arg0_4:PlaySingleAction(var1_53, var4_53, arg0_60)
			else
				arg0_60()
			end
		end)
		seriesAsync(var2_53, function()
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

	eachChild(var8_4, function(arg0_70)
		setActive(arg0_70, arg0_70.name == "walk")
	end)

	arg0_4._joystick = arg0_4._tf:Find("Stick")

	setActive(arg0_4._joystick, false)
	arg0_4._joystick:GetComponent(typeof(SlideController)):SetStickFunc(function(arg0_71)
		arg0_4:emit(arg0_4.ON_STICK_MOVE, arg0_71)
	end)

	arg0_4.povLayer = arg0_4._tf:Find("POVControl")

	setActive(arg0_4.povLayer, false)
	;(function()
		local var0_72 = arg0_4.povLayer:Find("Move"):GetComponent(typeof(SlideController))

		var0_72:AddBeginDragFunc(function(arg0_73, arg1_73)
			arg0_4:emit(arg0_4.ON_POV_STICK_MOVE_BEGIN, arg1_73)
		end)
		var0_72:SetStickFunc(function(arg0_74)
			arg0_4:emit(arg0_4.ON_POV_STICK_MOVE, arg0_74)
		end)
		var0_72:AddDragEndFunc(function(arg0_75, arg1_75)
			arg0_4:emit(arg0_4.ON_POV_STICK_MOVE_END, arg1_75)
		end)
		arg0_4.povLayer:Find("View"):GetComponent(typeof(SlideController)):SetStickFunc(function(arg0_76)
			arg0_4:emit(arg0_4.ON_POV_STICK_VIEW, arg0_76)
		end)
	end)()

	arg0_4.ikControlLayer = var4_4:Find("ControlLayer")

	;(function()
		local var0_77
		local var1_77 = arg0_4.ikControlLayer:GetComponent(typeof(SlideController))

		var1_77:AddBeginDragFunc(function(arg0_78, arg1_78)
			local var0_78 = arg0_4:GetCurrentLadyEnv()

			if not var0_78.IKSettings then
				return
			end

			local var1_78 = arg1_78.position
			local var2_78 = CameraMgr.instance:Raycast(var0_78.IKSettings.CameraRaycaster, var1_78):ToTable()

			if #var2_78 > 0 then
				local var3_78 = var2_78[1].gameObject.transform
				local var4_78 = table.keyof(var0_78.IKSettings.Colliders, var3_78)

				warning(var3_78, var4_78)

				if var4_78 then
					arg0_4:emit(var0_0.ON_BEGIN_DRAG_CHARACTER_BODY, var0_78, var4_78, var1_78)

					var0_77 = tobool(var0_78.ikHandler)

					return
				end
			end
		end)
		var1_77:AddDragFunc(function(arg0_79, arg1_79)
			local var0_79 = arg1_79.position
			local var1_79 = arg0_4:GetCurrentLadyEnv()

			if var1_79.ikHandler then
				arg0_4:emit(var0_0.ON_DRAG_CHARACTER_BODY, var1_79, var0_79)

				return
			end

			if var0_77 then
				return
			end

			local var2_79 = arg1_79.delta

			arg0_4:emit(arg0_4.ON_STICK_MOVE, var2_79)
		end)
		var1_77:AddDragEndFunc(function(arg0_80, arg1_80)
			var0_77 = nil

			local var0_80 = arg0_4:GetCurrentLadyEnv()

			if var0_80.ikHandler then
				arg0_4:emit(var0_0.ON_RELEASE_CHARACTER_BODY, var0_80)

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

function var0_0.BindEvent(arg0_82)
	var0_0.super.BindEvent(arg0_82)
	arg0_82:bind(arg0_82.CLICK_CHARACTER, function(arg0_83, arg1_83)
		if arg0_82.uiState ~= "base" or not arg0_82.ladyDict[arg1_83].nowCanWatchState then
			return
		end

		local var0_83 = {}
		local var1_83 = arg0_82.ladyDict[arg1_83]

		if arg0_82:GetBlackboardValue(var1_83, "inPending") then
			table.insert(var0_83, function(arg0_84)
				arg0_82:OutOfPending(arg1_83, arg0_84)
			end)
		else
			table.insert(var0_83, function(arg0_85)
				arg0_82:OutOfLazy(arg1_83, arg0_85)
			end)
		end

		seriesAsync(var0_83, function()
			if not arg0_82.room:isPersonalRoom() then
				arg0_82:SetApartment(getProxy(ApartmentProxy):getApartment(arg1_83))
			end

			arg0_82:EnterWatchMode()
		end)
		pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_touch_v1")
	end)
	arg0_82:bind(arg0_82.CLICK_CONTACT, function(arg0_87, arg1_87)
		arg0_82:TriggerContact(arg1_87)
	end)
	arg0_82:bind(arg0_82.DISTANCE_TRIGGER, function(arg0_88, arg1_88, arg2_88)
		if arg0_82.uiState == "base" then
			arg0_82:CheckDistanceTalk(arg1_88, arg2_88)
		end
	end)
	arg0_82:bind(arg0_82.WALK_DISTANCE_TRIGGER, function(arg0_89, arg1_89, arg2_89)
		if arg0_82.apartment and arg0_82.apartment:GetConfigID() == arg1_89 then
			existCall(arg0_82.walkNearCallback, arg2_89)
		end
	end)
	arg0_82:bind(arg0_82.CHANGE_WATCH, function(arg0_90, arg1_90)
		arg0_82:ChangeCanWatchState(arg0_82.ladyDict[arg1_90])
	end)
	arg0_82:bind(arg0_82.ON_TOUCH_CHARACTER, function(arg0_91, arg1_91)
		local var0_91 = arg0_82:GetCurrentLadyEnv()

		if not arg0_82:GetBlackboardValue(var0_91, "inIK") then
			return
		end

		arg0_82:OnTouchCharacterBody(arg1_91)
	end)
	arg0_82:bind(var0_0.ON_IK_STATUS_CHANGED, function(arg0_92, arg1_92, arg2_92)
		local var0_92 = arg0_82:GetCurrentLadyEnv()

		if not arg0_82:GetBlackboardValue(var0_92, "inTouching") then
			return
		end

		arg0_82:DoTouch(arg1_92, arg2_92)
	end)
	arg0_82:bind(arg0_82.ON_ENTER_SECTOR, function(arg0_93, arg1_93)
		arg0_82:ChangeCanWatchState(arg0_82.ladyDict[arg1_93])
	end)
	arg0_82:bind(arg0_82.ON_CHANGE_DISTANCE, function(arg0_94, arg1_94, arg2_94)
		arg0_82:ChangeCanWatchState(arg0_82.ladyDict[arg1_94])
	end)
end

function var0_0.didEnter(arg0_95)
	arg0_95.resumeCallback = arg0_95.contextData.resumeCallback
	arg0_95.contextData.resumeCallback = nil

	var0_0.super.didEnter(arg0_95)
	arg0_95:UpdateZoneList()
	arg0_95:SetUI(function()
		arg0_95:didEnterCheck()
	end, "base")
end

function var0_0.FinishEnterResume(arg0_97)
	if not arg0_97.resumeCallback then
		return
	end

	local var0_97 = arg0_97.resumeCallback

	arg0_97.resumeCallback = nil

	return var0_97()
end

function var0_0.EnableJoystick(arg0_98, arg1_98)
	setActive(arg0_98._joystick, arg1_98)
end

function var0_0.EnablePOVLayer(arg0_99, arg1_99)
	setActive(arg0_99.povLayer, arg1_99)

	if not arg1_99 then
		arg0_99:emit(arg0_99.ON_POV_STICK_MOVE_END)
	end
end

function var0_0.SetUIStore(arg0_100, arg1_100, ...)
	table.insertto(arg0_100.uiStore, {
		...
	})
	existCall(arg1_100)
end

function var0_0.SetUI(arg0_101, arg1_101, ...)
	warning("SetUI", ...)

	while rawget(arg0_101, "class") ~= var0_0 do
		arg0_101 = getmetatable(arg0_101).__index
	end

	table.insertto(arg0_101.uiStore, {
		...
	})

	for iter0_101, iter1_101 in ipairs(arg0_101.uiStore) do
		if iter1_101 == "back" then
			assert(#arg0_101.uiStack > 0)

			arg0_101.uiState = table.remove(arg0_101.uiStack)
		elseif iter1_101 == arg0_101.uiState and iter1_101 == "ik" then
			-- block empty
		else
			table.insert(arg0_101.uiStack, arg0_101.uiState)

			arg0_101.uiState = iter1_101
		end
	end

	pg.m02:sendNotification(var0_0.NOTIFY_UI_STATE, arg0_101.uiState)

	arg0_101.uiStore = {}

	eachChild(arg0_101.uiContainer, function(arg0_102)
		setActive(arg0_102, arg0_102.name == arg0_101.uiState)
	end)
	arg0_101:EnablePOVLayer(arg0_101.uiState == "base" or arg0_101.uiState == "walk")
	arg0_101:TempHideContact(arg0_101.uiState ~= "base")
	arg0_101:SetFloatEnable(arg0_101.uiState == "walk")
	setActive(arg0_101.rtFloatPage, arg0_101.uiState == "walk")
	setActive(arg0_101.ikControlUI, arg0_101.uiState == "ik")

	if arg0_101.uiState ~= "stocking" then
		arg0_101.stockingView:Hide()
	end

	warning("SetUI to ", arg0_101.uiState)
	switch(arg0_101.uiState, {
		base = function()
			if not arg0_101.room:isPersonalRoom() then
				arg0_101:SetApartment(nil)
			end

			arg0_101:UpdateBtnState()
		end,
		watch = function()
			eachChild(arg0_101.rtRole, function(arg0_105)
				setActive(arg0_105, false)
			end)

			local var0_104 = underscore.filter({
				"Talk",
				"Touch",
				"Gift",
				"MiniGame",
				"PublicGame",
				"Performance"
			}, function(arg0_106)
				return arg0_101:CheckSystemOpen(arg0_106)
			end)
			local var1_104 = 0.05

			for iter0_104, iter1_104 in ipairs(var0_104) do
				LeanTween.delayedCall(var1_104, System.Action(function()
					setActive(arg0_101.rtRole:Find(iter1_104), true)

					if iter1_104 == "Touch" then
						local var0_107 = arg0_101.apartment:GetConfigID()

						arg0_101.rtRoleTouchSubView:Flush(arg0_101.room, var0_107, arg0_101.ladyDict[var0_107].ladyBaseZone)
					end
				end))

				var1_104 = var1_104 + 0.066
			end

			setActive(arg0_101.rtRole:Find("Gift/bg/Tip"), Dorm3dGift.NeedViewTip(arg0_101.apartment:GetConfigID()))
		end,
		ik = function()
			setActive(arg0_101.uiContainer:Find("ik/Right/MenuSmall"), arg0_101.room:isPersonalRoom() and not arg0_101.performanceInfo)
			setActive(arg0_101.uiContainer:Find("ik/Right/Menu"), false)
		end,
		walk = function()
			setText(arg0_101.uiContainer:Find("walk/dialogue/content"), i18n("dorm3d_removable", arg0_101.apartment:getConfig("name")))
		end,
		stocking = function()
			arg0_101.stockingView:Show()
		end
	})
	arg0_101:ActiveStateCamera(arg0_101.uiState, function()
		if arg1_101 then
			arg1_101()
		elseif arg0_101.uiState == "base" then
			arg0_101:CheckQueue()
		end
	end)
end

function var0_0.EnterWatchMode(arg0_112)
	local var0_112 = arg0_112.apartment:GetConfigID()

	seriesAsync({
		function(arg0_113)
			arg0_112:emit(arg0_112.SHOW_BLOCK)
			arg0_112:SetBlackboardValue(arg0_112.ladyDict[var0_112], "inWatchMode", true)
			arg0_112:SetUI(arg0_113, "watch")
		end,
		function(arg0_114)
			arg0_112:emit(arg0_112.HIDE_BLOCK)
		end
	})
end

function var0_0.ExitWatchMode(arg0_115)
	local var0_115 = arg0_115.apartment:GetConfigID()

	seriesAsync({
		function(arg0_116)
			arg0_115:emit(arg0_115.SHOW_BLOCK)
			arg0_115:SetUI(arg0_116, "back")
		end,
		function(arg0_117)
			arg0_115:SetBlackboardValue(arg0_115.ladyDict[var0_115], "inWatchMode", false)
			arg0_115:emit(arg0_115.HIDE_BLOCK)
			arg0_115:CheckQueue()
		end
	})
end

function var0_0.SetInPending(arg0_118, arg1_118, arg2_118)
	local var0_118 = arg0_118:GetBlackboardValue(arg1_118, "groupId")
	local var1_118 = pg.dorm3d_welcome[arg2_118]

	arg0_118:SetBlackboardValue(arg1_118, "inPending", true)
	arg0_118:ChangeCanWatchState(arg1_118)
	arg0_118:EnableHeadIK(arg1_118, false)

	arg0_118.contextData.ladyZone[var0_118] = var1_118.area

	arg1_118:SetZone(arg0_118.contextData.ladyZone[var0_118], var1_118.welcome_staypoint)
	arg0_118:ChangeCharacterPosition(arg1_118)

	if var1_118.item_shield ~= "" then
		arg0_118.hideItemDic = {}

		for iter0_118, iter1_118 in ipairs(var1_118.item_shield) do
			local var2_118 = arg0_118.modelRoot:Find(iter1_118)

			if not var2_118 then
				warning(string.format("welcome:%d without hide item:%s", arg2_118, iter1_118))
			else
				arg0_118.hideItemDic[iter1_118] = isActive(var2_118)

				setActive(var2_118, false)
			end
		end
	end

	onNextTick(function()
		if arg1_118.tfPendintItem then
			setActive(arg1_118.tfPendintItem, true)
		end

		arg0_118:SwitchAnim(arg1_118, var1_118.welcome_idle)
	end)

	arg0_118.wakeUpTalkId = var1_118.welcome_talk
end

function var0_0.SetOutPending(arg0_120, arg1_120)
	arg0_120:SetBlackboardValue(arg1_120, "inPending", false)
	arg0_120:ChangeCanWatchState(arg1_120)
	arg0_120:EnableHeadIK(arg1_120, true)

	arg0_120.wakeUpTalkId = nil

	if arg1_120.tfPendintItem then
		setActive(arg1_120.tfPendintItem, false)
	end

	if arg0_120.hideItemDic then
		for iter0_120, iter1_120 in pairs(arg0_120.hideItemDic) do
			setActive(arg0_120.modelRoot:Find(iter0_120), iter1_120)
		end

		arg0_120.hideItemDic = nil
	end
end

function var0_0.IsModeInHidePending(arg0_121, arg1_121)
	for iter0_121, iter1_121 in pairs(arg0_121.ladyDict) do
		if iter1_121.hideItemDic and iter1_121.hideItemDic[arg1_121] ~= nil then
			return true
		end
	end

	return false
end

function var0_0.EnterAccompanyMode(arg0_122, arg1_122)
	local var0_122 = pg.dorm3d_accompany[arg1_122]
	local var1_122
	local var2_122

	if var0_122.sceneInfo ~= "" then
		var1_122, var2_122 = unpack(string.split(var0_122.sceneInfo, "|"))
	end

	local var3_122 = {
		type = "timeline",
		name = var0_122.timeline,
		scene = var1_122,
		sceneRoot = var2_122,
		accompanys = {}
	}

	for iter0_122, iter1_122 in ipairs(var0_122.jump_trigger) do
		local var4_122, var5_122 = unpack(iter1_122)

		var3_122.accompanys[var4_122] = var5_122
	end

	local var6_122, var7_122 = unpack(var0_122.favor)

	getProxy(Dorm3dChatProxy):TriggerEvent({
		{
			value = 1,
			event_type = 161,
			ship_id = arg0_122.apartment:GetConfigID()
		}
	})
	getProxy(ApartmentProxy):RecordAccompanyTime()
	pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataAccompany(1, var0_122.ship_id, var0_122.performance_time, 0, var1_122 or arg0_122.dormSceneMgr.artSceneInfo))

	local var8_122 = {}

	table.insert(var8_122, function(arg0_123)
		arg0_122:SetUI(arg0_123, "blank", "accompany")
	end)
	table.insert(var8_122, function(arg0_124)
		arg0_122.accompanyFavorCount = 0
		arg0_122.accompanyFavorTimer = Timer.New(function()
			arg0_122.accompanyFavorCount = arg0_122.accompanyFavorCount + 1
		end, var6_122, -1)

		arg0_122.accompanyFavorTimer:Start()

		arg0_122.accompanyPerformanceTimer = Timer.New(function()
			arg0_122.canTriggerAccompanyPerformance = true
		end, var0_122.performance_time, -1)

		arg0_122.accompanyPerformanceTimer:Start()
		arg0_122:PlayTimeline(var3_122, function(arg0_127, arg1_127)
			arg1_127()
			arg0_124()
		end)
	end)
	seriesAsync(var8_122, function()
		assert(arg0_122.accompanyFavorTimer)
		arg0_122.accompanyFavorTimer:Stop()

		arg0_122.accompanyFavorTimer = nil

		assert(arg0_122.accompanyPerformanceTimer)
		arg0_122.accompanyPerformanceTimer:Stop()

		arg0_122.accompanyPerformanceTimer = nil
		arg0_122.canTriggerAccompanyPerformance = nil

		local var0_128 = math.min(arg0_122.accompanyFavorCount, getProxy(ApartmentProxy):getStamina())

		if var0_128 > 0 then
			local var1_128 = var7_122[var0_128]

			warning(var1_128)
			arg0_122:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_122.apartment.configId, var1_128)
		end

		local var2_128 = 0
		local var3_128 = getProxy(ApartmentProxy):GetAccompanyTime()

		if var3_128 then
			var2_128 = pg.TimeMgr.GetInstance():GetServerTime() - var3_128
		end

		pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataAccompany(2, var0_122.ship_id, var0_122.performance_time, var2_128, var1_122 or arg0_122.dormSceneMgr.artSceneInfo))
		arg0_122:SetUI(nil, "back", "back")
	end)
end

function var0_0.ExitAccompanyMode(arg0_129)
	existCall(arg0_129.timelineFinishCall)
end

function var0_0.EnterTouchPerformance(arg0_130)
	local var0_130 = arg0_130:GetCurrentLadyEnv()
	local var1_130 = arg0_130.room:getApartmentZoneConfig(var0_130.ladyBaseZone, "touch_performance", arg0_130.apartment:GetConfigID())

	if not var1_130 or var1_130 == 0 then
		arg0_130:EnterTouchMode()
	else
		arg0_130:DoTalk(var1_130)
	end
end

function var0_0.EnterTouchMode(arg0_131, arg1_131)
	local var0_131 = arg0_131:GetCurrentLadyEnv()

	if arg0_131:GetBlackboardValue(var0_131, "inTouching") then
		return
	end

	arg1_131 = arg1_131 or arg0_131.room:getApartmentZoneConfig(var0_131.ladyBaseZone, "touch_id", arg0_131.apartment:GetConfigID())
	arg0_131.touchConfig = pg.dorm3d_touch_data[arg1_131]

	if not arg0_131.touchConfig then
		warning("dorm3d_touch_data no config for id:" .. tostring(arg1_131))

		return
	end

	arg0_131.inTouchGame = arg0_131.touchConfig.heartbeat_enable > 0

	setActive(arg0_131.rtTouchGamePanel, arg0_131.inTouchGame)

	if arg0_131.inTouchGame then
		arg0_131.touchCount = 0
		arg0_131.touchLevel = 1
		arg0_131.lastCount = 0
		arg0_131.topCount = 0

		arg0_131:UpdateTouchGameDisplay()
		setSlider(arg0_131.rtTouchGamePanel:Find("slider"), 0, 100, arg0_131.touchCount >= 200 and 100 or arg0_131.touchCount % 100)
		quickPlayAnimation(arg0_131.rtTouchGamePanel, "anim_dorm3d_touch_in")
		quickPlayAnimation(arg0_131.rtTouchGamePanel:Find("slider/icon"), "anim_dorm3d_touch_icon")

		arg0_131.downTimer = Timer.New(function()
			local var0_132 = pg.dorm3d_set.reduce_interaction.key_value_int

			if arg0_131.touchLevel > 1 then
				var0_132 = pg.dorm3d_set.reduce_heartbeat.key_value_int
			end

			arg0_131:UpdateTouchCount(var0_132)
		end, 1, -1)

		arg0_131.downTimer:Start()
	end

	local var1_131 = {}

	table.insert(var1_131, function(arg0_133)
		arg0_131:SetBlackboardValue(var0_131, "inTouching", true)
		arg0_131:emit(arg0_131.SHOW_BLOCK)
		arg0_131:SetUI(arg0_133, "blank")
	end)
	table.insert(var1_131, function(arg0_134)
		local var0_134 = arg0_131.touchConfig.ik_status[1]

		arg0_131:SwitchIKConfig(var0_131, var0_134)
		setActive(arg0_131.uiContainer:Find("ik/btn_back"), true)
		arg0_131:SetIKState(true, arg0_134)
	end)
	table.insert(var1_131, function(arg0_135)
		existCall(arg0_135)
	end)
	seriesAsync(var1_131, function()
		Shader.SetGlobalFloat("_ScreenClipOff", 0)
		arg0_131:emit(arg0_131.HIDE_BLOCK)
	end)
end

function var0_0.ExitTouchMode(arg0_137)
	local var0_137 = arg0_137:GetCurrentLadyEnv()

	if not arg0_137:GetBlackboardValue(var0_137, "inTouching") then
		return
	end

	local var1_137 = {}

	if arg0_137.inTouchGame then
		table.insert(var1_137, function(arg0_138)
			arg0_137:emit(arg0_137.SHOW_BLOCK)
			quickPlayAnimation(arg0_137.rtTouchGamePanel, "anim_dorm3d_touch_out")
			onDelayTick(arg0_138, 0.5)
		end)
		table.insert(var1_137, function(arg0_139)
			local var0_139 = 0

			for iter0_139, iter1_139 in ipairs(arg0_137.touchConfig.heartbeat_favor) do
				if iter1_139[1] > arg0_137.topCount then
					break
				else
					var0_139 = iter1_139[2]
				end
			end

			if var0_139 > 0 then
				arg0_137:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_137.apartment.configId, var0_139)
			end

			arg0_137.touchCount = nil
			arg0_137.touchLevel = nil
			arg0_137.topCount = nil

			if arg0_137.downTimer then
				arg0_137.downTimer:Stop()

				arg0_137.downTimer = nil
			end

			arg0_137.inTouchGame = false

			setActive(arg0_137.rtTouchGamePanel, false)
			Shader.SetGlobalFloat("_ScreenClipOff", 1)
			arg0_139()
		end)
	else
		table.insert(var1_137, function(arg0_140)
			arg0_137:emit(arg0_137.SHOW_BLOCK)

			local var0_140 = arg0_137.touchConfig.default_favor

			if var0_140 > 0 then
				arg0_137:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_137.apartment.configId, var0_140)
			end

			Shader.SetGlobalFloat("_ScreenClipOff", 1)
			arg0_140()
		end)
	end

	table.insert(var1_137, function(arg0_141)
		var0_137.ikConfig = {
			character_position = var0_137.ladyBaseZone,
			character_action = arg0_137.touchConfig.finish_action
		}

		arg0_137:emit(var0_0.STOCKING_EVENT, "OnExitTouchMode")
		arg0_137:SetIKState(false, arg0_141)
	end)
	table.insert(var1_137, function(arg0_142)
		var0_137.ikConfig = nil
		arg0_137.blockIK = nil

		arg0_137:SetUI(arg0_142, "back")
	end)
	seriesAsync(var1_137, function()
		arg0_137:SetBlackboardValue(var0_137, "inTouching", false)
		arg0_137:emit(arg0_137.HIDE_BLOCK)

		arg0_137.touchConfig = nil

		local var0_143 = arg0_137.touchExitCall

		arg0_137.touchExitCall = nil

		existCall(var0_143)
	end)
end

function var0_0.ChangeWalkScene(arg0_144, arg1_144, arg2_144, arg3_144)
	local var0_144 = arg0_144:GetCurrentLadyEnv()

	seriesAsync({
		function(arg0_145)
			arg0_144:ChangeArtScene(arg2_144, arg0_145)
		end,
		function(arg0_146)
			arg0_144:ChangeSubScene(arg2_144, arg0_146)
		end,
		function(arg0_147)
			arg0_144:emit(arg0_144.SHOW_BLOCK)

			if arg1_144 == "back" then
				arg0_144:SetUI(arg0_147, "back")
			elseif arg1_144 == "change" and arg0_144.uiState ~= "walk" then
				arg0_144:SetUI(arg0_147, "walk")
			else
				arg0_147()
			end
		end
	}, function()
		arg0_144:emit(arg0_144.HIDE_BLOCK)
		arg0_144:SetBlackboardValue(var0_144, "inWalk", arg1_144 == "change")
		existCall(arg3_144)
	end)
end

function var0_0.EnterWalkMode(arg0_149)
	local var0_149 = arg0_149.apartment:GetConfigID()
	local var1_149 = arg0_149.ladyDict[var0_149]

	seriesAsync({
		function(arg0_150)
			arg0_149:emit(arg0_149.SHOW_BLOCK)
			arg0_149:HideCharacter(var0_149)
			arg0_149:SetBlackboardValue(var1_149, "inWalk", true)
			arg0_149:SetUI(arg0_150, "walk")
		end,
		function(arg0_151)
			arg0_149:emit(arg0_149.HIDE_BLOCK)
			arg0_149:ChangeArtScene(arg0_149.walkInfo.scene .. "|" .. arg0_149.walkInfo.sceneRoot, arg0_151)
		end,
		function(arg0_152)
			arg0_149:LoadSubScene(arg0_149.walkInfo, arg0_152)
		end
	}, function()
		return
	end)
end

function var0_0.ExitWalkMode(arg0_154)
	local var0_154 = arg0_154.apartment:GetConfigID()
	local var1_154 = arg0_154.ladyDict[var0_154]

	seriesAsync({
		function(arg0_155)
			arg0_154:RevertArtScene(arg0_154.walkLastSceneInfo, arg0_155)
		end,
		function(arg0_156)
			arg0_154:UnloadSubScene(arg0_154.walkInfo, arg0_156)
		end,
		function(arg0_157)
			arg0_154:emit(arg0_154.SHOW_BLOCK)
			arg0_154:SetUI(arg0_157, "back")
		end
	}, function()
		arg0_154:emit(arg0_154.HIDE_BLOCK)
		arg0_154:RevertCharacter(var0_154)
		arg0_154:SetBlackboardValue(var1_154, "inWalk", false)

		local var0_158 = arg0_154.walkExitCall

		arg0_154.walkExitCall = nil
		arg0_154.walkLastSceneInfo = nil
		arg0_154.walkInfo = nil

		existCall(var0_158)
	end)
end

function var0_0.EnableMiniGameCutIn(arg0_159)
	if not arg0_159.tfCutIn then
		return
	end

	local var0_159 = arg0_159.rtExtraScreen:Find("MiniGameCutIn")

	setActive(var0_159, true)

	local var1_159 = GetOrAddComponent(var0_159:Find("bg/mask/cut_in"), "CameraRTUI")

	setActive(var1_159, true)
	pg.CameraRTMgr.GetInstance():Bind(var1_159, arg0_159.tfCutIn:Find("TestCamera"):GetComponent(typeof(Camera)))
	quickPlayAnimator(arg0_159.modelCutIn.lady, "Idle")
	quickPlayAnimator(arg0_159.modelCutIn.player, "Idle")
	setActive(arg0_159.tfCutIn, true)
end

function var0_0.DisableMiniGameCutIn(arg0_160)
	if not arg0_160.tfCutIn then
		return
	end

	local var0_160 = arg0_160.rtExtraScreen:Find("MiniGameCutIn")
	local var1_160 = GetOrAddComponent(var0_160:Find("bg/mask/cut_in"), "CameraRTUI")

	pg.CameraRTMgr.GetInstance():Clean(var1_160)
	setActive(var0_160, false)
	setActive(arg0_160.tfCutIn, false)
end

function var0_0.SwitchIKConfig(arg0_161, arg1_161, arg2_161)
	warning("switchIkstatus", arg2_161)

	local var0_161 = pg.dorm3d_ik_status[arg2_161]

	if var0_161.skin_id ~= arg1_161.skinId then
		local var1_161 = pg.dorm3d_ik_status.get_id_list_by_base[var0_161.base]
		local var2_161 = _.detect(var1_161, function(arg0_162)
			return pg.dorm3d_ik_status[arg0_162].skin_id == arg1_161.skinId
		end)

		assert(var2_161, string.format("Missing Status Config By Skin: %s original Status: %s", arg1_161.skinId, arg2_161))

		var0_161 = pg.dorm3d_ik_status[var2_161]
	end

	arg1_161.ikConfig = var0_161
end

function var0_0.SetIKState(arg0_163, arg1_163, arg2_163, arg3_163)
	arg3_163 = arg3_163 or {}

	local var0_163 = arg0_163:GetCurrentLadyEnv()
	local var1_163 = {}

	if arg1_163 then
		table.insert(var1_163, function(arg0_164)
			arg0_163:SetBlackboardValue(var0_163, "inIK", true)
			arg0_163:emit(arg0_163.SHOW_BLOCK)

			local var0_164 = var0_163.ikConfig.camera_group

			setActive(arg0_163.uiContainer:Find("ik/Right/btn_camera"), #pg.dorm3d_ik_status.get_id_list_by_camera_group[var0_164] > 1)
			setActive(arg0_163.ikControlUI, true)
			arg0_164()
		end)

		if arg0_163.uiState ~= "ik" then
			table.insert(var1_163, function(arg0_165)
				arg0_163:SetUI(arg0_165, "ik")
			end)
		end

		table.insert(var1_163, function(arg0_166)
			Shader.SetGlobalFloat("_ScreenClipOff", 0)
			arg0_163:SetIKStatus(var0_163, var0_163.ikConfig, arg0_166, arg3_163)
		end)
		table.insert(var1_163, function(arg0_167)
			arg0_163:emit(arg0_163.HIDE_BLOCK)
			arg0_167()
		end)
	else
		assert(arg0_163.uiState == "ik")
		table.insert(var1_163, function(arg0_168)
			setActive(arg0_163.ikControlUI, false)
			arg0_163:emit(arg0_163.SHOW_BLOCK)
			Shader.SetGlobalFloat("_ScreenClipOff", 1)
			arg0_168()
		end)
		table.insert(var1_163, function(arg0_169)
			arg0_163:ExitIKStatus(var0_163, var0_163.ikConfig, arg0_169, arg3_163)
			arg0_163:ResetSceneItemAnimators()
		end)
		table.insert(var1_163, function(arg0_170)
			arg0_163:SetUI(arg0_170, "back")
		end)
		table.insert(var1_163, function(arg0_171)
			arg0_163:SetBlackboardValue(var0_163, "inIK", false)
			arg0_163:emit(arg0_163.HIDE_BLOCK)
			arg0_171()
		end)
	end

	seriesAsync(var1_163, arg2_163)
end

function var0_0.TouchModeAction(arg0_172, arg1_172, arg2_172, arg3_172, ...)
	return switch(arg3_172, {
		function(arg0_173, arg1_173)
			return function(arg0_174)
				seriesAsync({
					function(arg0_175)
						if not arg1_173 or arg1_173 == "" then
							return arg0_175()
						end

						arg0_172:PlaySingleAction(arg1_172, arg1_173, arg0_175)
					end,
					function(arg0_176)
						arg0_172:SwitchIKConfig(arg1_172, arg0_173)
						arg0_172:SetIKState(true, arg0_176)
					end,
					arg0_174
				})
			end
		end,
		function()
			return function()
				if arg0_172.ikSpecialCall then
					local var0_178 = arg0_172.ikSpecialCall

					arg0_172.ikSpecialCall = nil

					existCall(var0_178)
				else
					arg0_172:ExitTouchMode()
				end
			end
		end,
		function(arg0_179, arg1_179)
			return function(arg0_180)
				arg0_172:PlaySingleAction(arg1_172, arg1_179, arg0_180)
			end
		end,
		function(arg0_181, arg1_181, arg2_181)
			return function(arg0_182)
				seriesAsync({
					function(arg0_183)
						arg0_172:DoTalk(arg1_181, arg0_183)
					end,
					function(arg0_184)
						if not arg2_181 or arg2_181 == 0 then
							return arg0_184()
						end

						arg0_172:SwitchIKConfig(arg1_172, arg2_181)
						arg0_172:SetIKState(true, arg0_184)
					end,
					arg0_182
				})
			end
		end,
		function(arg0_185, arg1_185, arg2_185, arg3_185)
			return function(arg0_186)
				arg0_172:PlaySceneItemAnim(arg2_185, arg3_185)
				arg0_172:PlaySingleAction(arg1_185, arg0_186)
			end
		end,
		function(arg0_187)
			return function(arg0_188)
				local var0_188 = pg.dorm3d_ik_touch[arg2_172]

				if #var0_188.scene_item == 0 then
					return
				end

				local var1_188 = arg0_172:GetSceneItem(var0_188.scene_item)

				if not var1_188 then
					warning(string.format("dorm3d_ik_touch:%d without scene_item:%s", arg2_172, var0_188.scene_item))

					return
				end

				local var2_188 = var1_188:Find(arg0_187)

				if not IsNil(var2_188) then
					setActive(var2_188, false)
					setActive(var2_188, true)
				end

				arg0_188()
			end
		end,
		function(arg0_189)
			local var0_189 = pg.dorm3d_ik_touch_move[arg0_189]
			local var1_189 = var0_189.target_ik
			local var2_189 = var0_189.move_time
			local var3_189 = var0_189.ik_point
			local var4_189 = var0_189.touch_step

			arg1_172.IKSettings.forceMove = arg1_172.IKSettings.forceMove or {}

			local var5_189 = arg1_172.IKSettings.forceMove

			var5_189[var1_189] = var5_189[var1_189] or {}
			var5_189[var1_189].count = var5_189[var1_189].count or 0

			return function(arg0_190)
				seriesAsync({
					function(arg0_191)
						if var5_189[var1_189].count >= #var4_189 then
							return arg0_191()
						end

						local var0_191 = Dorm3dIK.New({
							configId = var1_189
						})
						local var1_191 = Vector2.New(unpack(var3_189))
						local var2_191 = var5_189[var1_189].count
						local var3_191 = var4_189[var2_191 + 1] - (var2_191 == 0 and 0 or var4_189[var2_191])

						var5_189[var1_189].count = var2_191 + 1

						pg.IKMgr.GetInstance():ResetIK(var0_191:GetTriggerBoneName())

						local var4_191 = arg1_172.IKSettings.Colliders[var0_191:GetTriggerBoneName()]
						local var5_191 = arg0_172.raycastCamera:WorldToScreenPoint(var4_191.position)

						pg.IKMgr.GetInstance():PlayIKMove(var5_191, var0_191:GetTriggerBoneName(), var1_191, var4_189[var2_191 + 1], var2_189, function()
							var5_189[var1_189].count = 0

							arg0_191()
						end)
					end,
					arg0_190
				})
			end
		end,
		function(arg0_193)
			return function(arg0_194)
				arg0_172.stockingMgr:SetStockingStatus(arg0_193)
			end
		end
	}, function()
		return function()
			return
		end
	end, ...)
end

function var0_0.OnTriggerIK(arg0_197, arg1_197)
	local var0_197 = arg0_197:GetCurrentLadyEnv()

	if var0_197.ikTimelineMode then
		arg0_197:ExitIKTimelineStatus(var0_197)

		local var1_197 = arg1_197:GetTimelineAction()

		if var1_197 then
			arg0_197.nowTimelinePlayer:TriggerEvent(var1_197)
		end

		return
	end

	if not var0_197.ikConfig then
		return
	end

	local var2_197 = arg1_197:GetControllerPath()
	local var3_197 = var0_197.ikActionDict[var2_197]

	if not var3_197 then
		return
	end

	arg0_197.blockIK = true

	arg0_197:TouchModeAction(var0_197, arg1_197:GetConfigID(), unpack(var3_197))(function()
		arg0_197:ResetIKTipTimer()

		arg0_197.blockIK = nil
	end)
end

function var0_0.OnTouchCharacterBody(arg0_199, arg1_199)
	local var0_199 = arg0_199:GetCurrentLadyEnv()

	if not var0_199.ikConfig then
		return
	end

	if type(var0_199.ikConfig.touch_data) ~= "table" then
		return
	end

	for iter0_199, iter1_199 in ipairs(var0_199.iKTouchDatas) do
		local var1_199, var2_199, var3_199 = unpack(iter1_199)
		local var4_199 = pg.dorm3d_ik_touch[var1_199]

		if var4_199.body == arg1_199 then
			local var5_199 = var4_199.action_emote

			if #var5_199 > 0 then
				arg0_199:PlayFaceAnim(var0_199, var5_199)
			end

			local var6_199 = var4_199.vibrate

			if type(var6_199) == "table" and VibrateMgr.Instance:IsSupport() then
				local var7_199 = {}
				local var8_199 = {}
				local var9_199 = {}

				underscore.each(var6_199, function(arg0_200)
					local var0_200 = arg0_200[1]

					if PLATFORM == PLATFORM_IPHONEPLAYER then
						var0_200 = var0_200 / 1000
					end

					table.insert(var7_199, var0_200)
					table.insert(var8_199, arg0_200[2])
					table.insert(var9_199, 1)
				end)

				if PLATFORM == PLATFORM_ANDROID then
					VibrateMgr.Instance:VibrateWaveform(var7_199, var8_199)
				elseif PLATFORM == PLATFORM_IPHONEPLAYER then
					VibrateMgr.Instance:VibrateWaveform(var7_199, var8_199, var9_199)
				end
			end

			arg0_199.blockIK = true

			arg0_199:TouchModeAction(var0_199, var1_199, unpack(var3_199))(function()
				arg0_199:ResetIKTipTimer()

				arg0_199.blockIK = nil
			end)

			return
		end
	end
end

function var0_0.UpdateTouchGameDisplay(arg0_202)
	setActive(arg0_202.rtTouchGamePanel:Find("effect_bg"), arg0_202.touchLevel == 2)
	setActive(arg0_202.rtTouchGamePanel:Find("slider/icon/beating"), arg0_202.touchLevel == 2)

	if arg0_202.touchLevel == 1 then
		setActive(arg0_202.uiContainer:Find("ik/btn_back"), true)
		setActive(arg0_202.uiContainer:Find("ik/btn_back_heartbeat"), false)
		quickPlayAnimation(arg0_202.rtTouchGamePanel, "anim_dorm3d_touch_change_out")
		quickPlayAnimation(arg0_202.rtTouchGamePanel:Find("slider/icon"), "anim_dorm3d_touch_icon")
	elseif arg0_202.touchLevel == 2 then
		setActive(arg0_202.uiContainer:Find("ik/btn_back"), false)
		setActive(arg0_202.uiContainer:Find("ik/btn_back_heartbeat"), true)
		quickPlayAnimation(arg0_202.rtTouchGamePanel, "anim_dorm3d_touch_change")
		quickPlayAnimation(arg0_202.rtTouchGamePanel:Find("slider/icon"), "anim_dorm3d_touch_icon_1")
		pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_heartbeat")
	end
end

function var0_0.UpdateTouchCount(arg0_203, arg1_203)
	if arg0_203.touchLevel > 1 then
		arg1_203 = math.min(0, arg1_203)
	end

	arg0_203.touchCount = math.clamp(arg0_203.touchCount + arg1_203, 0, 100)

	if arg0_203.sliderLT and LeanTween.isTweening(arg0_203.sliderLT) then
		LeanTween.cancel(arg0_203.sliderLT)

		arg0_203.sliderLT = nil
	end

	setSlider(arg0_203.rtTouchGamePanel:Find("slider"), 0, 100, arg0_203.touchCount)

	local var0_203

	if arg0_203.touchCount >= 100 then
		var0_203 = 2
	elseif arg0_203.touchCount <= 0 then
		var0_203 = 1
	end

	if var0_203 and var0_203 ~= arg0_203.touchLevel then
		if arg0_203.blockIK then
			return
		end

		arg0_203.touchLevel = var0_203

		local var1_203 = arg0_203.touchConfig.ik_status[var0_203]

		if var1_203 then
			if var0_203 > 1 then
				arg0_203.touchCount = 200
			elseif var0_203 == 1 then
				arg0_203.touchCount = 0
			end

			local var2_203 = arg0_203:GetCurrentLadyEnv()

			seriesAsync({
				function(arg0_204)
					arg0_203:ShowBlackScreen(true, arg0_204)
				end,
				function(arg0_205)
					arg0_203:SwitchIKConfig(var2_203, var1_203)
					arg0_203:SetIKState(true, arg0_205)

					if var0_203 > 1 and arg0_203.touchConfig.heartbeat_enter_anim ~= "" then
						arg0_203:SwitchAnim(var2_203, arg0_203.touchConfig.heartbeat_enter_anim)
					end
				end,
				function(arg0_206)
					arg0_203:ShowBlackScreen(false, arg0_206)
				end
			})
		end

		arg0_203:UpdateTouchCount(0)
		arg0_203:UpdateTouchGameDisplay()
	end

	arg0_203.topCount = math.max(arg0_203.topCount, arg0_203.touchCount)
end

function var0_0.ExitHeartbeatMode(arg0_207)
	if not arg0_207.touchLevel or arg0_207.touchLevel == 1 then
		return
	end

	arg0_207.touchCount = 0

	arg0_207:UpdateTouchCount(0)
end

function var0_0.DoTouch(arg0_208, arg1_208, arg2_208)
	if arg0_208.inTouchGame then
		switch(arg2_208, {
			function()
				arg0_208:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat.key_value_int)
			end,
			function()
				arg0_208:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat.key_value_int)
			end,
			function()
				arg0_208:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat.key_value_int)
			end,
			function()
				arg0_208:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat_trriger.key_value_int)
			end
		})
	end
end

function var0_0.DoTalk(arg0_213, arg1_213, arg2_213)
	while rawget(arg0_213, "class") ~= var0_0 do
		arg0_213 = getmetatable(arg0_213).__index
	end

	if arg0_213.apartment and arg0_213:GetBlackboardValue(arg0_213:GetCurrentLadyEnv(), "inTalking") then
		errorMsg("Talking block:" .. arg1_213)

		return
	end

	if not arg0_213.room:isPersonalRoom() then
		local var0_213 = pg.dorm3d_dialogue_group[arg1_213].char_id

		if arg0_213.apartment then
			assert(arg0_213.apartment:GetConfigID() == var0_213)
		else
			arg0_213:SetApartment(getProxy(ApartmentProxy):getApartment(var0_213))
		end
	end

	local var1_213 = arg0_213:GetCurrentLadyEnv()

	if arg1_213 == 10010 and not arg0_213.apartment.talkDic[arg1_213] then
		arg0_213.firstTimelineTouch = true
		arg0_213.firstMoveGuide = true
	end

	getProxy(Dorm3dChatProxy):TriggerEvent({
		{
			value = 1,
			event_type = arg0_213.contextData.timeIndex == 1 and 110 or 115,
			ship_id = arg0_213.apartment:GetConfigID()
		},
		{
			value = 1,
			event_type = 155,
			ship_id = arg0_213.apartment:GetConfigID()
		}
	})

	local var2_213 = {}

	if arg0_213:GetBlackboardValue(var1_213, "inPending") then
		table.insert(var2_213, function(arg0_214)
			arg0_213:OutOfLazy(arg0_213.apartment:GetConfigID(), arg0_214)
		end)
	end

	local var3_213 = pg.dorm3d_dialogue_group[arg1_213]
	local var4_213 = var3_213.performance_type == 1
	local var5_213

	table.insert(var2_213, function(arg0_215)
		arg0_213:emit(arg0_213.SHOW_BLOCK)
		arg0_213:SetBlackboardValue(var1_213, var4_213 and "inPerformance" or "inTalking", true)
		arg0_213:emit(Dorm3dRoomMediator.DO_TALK, arg1_213, function(arg0_216)
			var5_213 = arg0_216

			arg0_215()
		end)
	end)
	table.insert(var2_213, function(arg0_217)
		pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataDialog(arg0_213.apartment.configId, arg0_213.apartment.level, arg1_213, var3_213.type, arg0_213.room:getZoneConfig(arg0_213:GetCurrentLadyEnv().ladyBaseZone, "id"), var3_213.action_type, table.CastToString(var3_213.trigger_config), arg0_213.room:GetConfigID()))

		if pg.NewGuideMgr.GetInstance():IsBusy() then
			pg.NewGuideMgr.GetInstance():Pause()
		end

		arg0_213:SetUI(arg0_217, "blank")
	end)

	if var3_213.trigger_area and var3_213.trigger_area ~= "" then
		table.insert(var2_213, function(arg0_218)
			arg0_213:ShiftZone(var3_213.trigger_area, arg0_218)
		end)
	end

	if var3_213.performance_type == 0 then
		table.insert(var2_213, function(arg0_219)
			arg0_213:emit(arg0_213.HIDE_BLOCK)

			if arg0_213.contextData.isVideoTalk then
				arg0_213.videoPlayer:ExecuteAction("Play", var3_213.story, function()
					onDelayTick(arg0_219, 0.001)
				end)
			else
				pg.NewStoryMgr.GetInstance():ForceManualPlay(var3_213.story, function()
					onDelayTick(arg0_219, 0.001)
				end, true)
			end
		end)
	elseif var3_213.performance_type == 1 then
		table.insert(var2_213, function(arg0_222)
			arg0_213:emit(arg0_213.HIDE_BLOCK)
			arg0_213:PerformanceQueue(var3_213.story, arg0_222)
		end)
	else
		assert(false)
	end

	table.insert(var2_213, function(arg0_223)
		arg0_213:emit(arg0_213.SHOW_BLOCK)
		arg0_223()
	end)
	table.insert(var2_213, function(arg0_224)
		local var0_224 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(var3_213.story)

		if var0_224 then
			local var1_224 = "1"

			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataStory(var0_224, var1_224))
		end

		if var5_213 and #var5_213 > 0 then
			arg0_213:emit(Dorm3dRoomMediator.OPEN_DROP_LAYER, var5_213, arg0_224)
		else
			arg0_224()
		end
	end)
	table.insert(var2_213, function(arg0_225)
		if pg.NewGuideMgr.GetInstance():IsPause() then
			pg.NewGuideMgr.GetInstance():Resume()
		end

		arg0_213:emit(arg0_213.HIDE_BLOCK)

		if arg0_213.contextData.isVideoTalk then
			existCall(arg0_225)
		else
			arg0_213:SetBlackboardValue(var1_213, var4_213 and "inPerformance" or "inTalking", false)
			arg0_213:SetUI(arg0_225, "back")
		end
	end)
	seriesAsync(var2_213, function()
		if arg2_213 then
			return arg2_213()
		else
			arg0_213:CheckQueue()
		end
	end)
end

function var0_0.DoTalkTouchOption(arg0_227, arg1_227, arg2_227, arg3_227)
	local var0_227 = arg0_227.rtExtraScreen:Find("TalkTouchOption")
	local var1_227
	local var2_227 = var0_227:Find("content")

	UIItemList.StaticAlign(var2_227, var2_227:Find("clickTpl"), #arg1_227.options, function(arg0_228, arg1_228, arg2_228)
		arg1_228 = arg1_228 + 1

		if arg0_228 == UIItemList.EventUpdate then
			local var0_228 = arg1_227.options[arg1_228]

			setAnchoredPosition(arg2_228, NewPos(unpack(var0_228.pos)))
			onButton(arg0_227, arg2_228, function()
				var1_227(var0_228.flag)
			end, SFX_CONFIRM)
			setActive(arg2_228, not table.contains(arg2_227, var0_228.flag))
		end
	end)
	setActive(var0_227, true)

	function var1_227(arg0_230)
		setActive(var0_227, false)
		arg3_227(arg0_230)
	end
end

function var0_0.DoTimelineOption(arg0_231, arg1_231, arg2_231)
	local var0_231 = arg0_231.rtTimelineScreen:Find("TimelineOption")
	local var1_231
	local var2_231 = var0_231:Find("content")

	UIItemList.StaticAlign(var2_231, var2_231:Find("clickTpl"), #arg1_231, function(arg0_232, arg1_232, arg2_232)
		arg1_232 = arg1_232 + 1

		if arg0_232 == UIItemList.EventUpdate then
			local var0_232 = arg1_231[arg1_232]

			setText(arg2_232:Find("Text"), HXSet.hxLan(var0_232.content))
			onButton(arg0_231, arg2_232, function()
				var1_231(arg1_232)
			end, SFX_CONFIRM)
		end
	end)
	setActive(var0_231, true)

	function var1_231(arg0_234)
		setActive(var0_231, false)
		arg2_231(arg0_234)
	end
end

function var0_0.DoTimelineTouch(arg0_235, arg1_235, arg2_235)
	local var0_235 = arg0_235.rtTimelineScreen:Find("TimelineTouch")
	local var1_235
	local var2_235 = var0_235:Find("content")

	UIItemList.StaticAlign(var2_235, var2_235:Find("clickTpl"), #arg1_235, function(arg0_236, arg1_236, arg2_236)
		arg1_236 = arg1_236 + 1

		if arg0_236 == UIItemList.EventUpdate then
			local var0_236 = arg1_235[arg1_236]

			setAnchoredPosition(arg2_236, NewPos(unpack(var0_236.pos)))
			onButton(arg0_235, arg2_236, function()
				var1_235(arg1_236)
			end, SFX_CONFIRM)

			if arg0_235.firstTimelineTouch then
				arg0_235.firstTimelineTouch = nil

				setActive(arg2_236:Find("finger"), true)
			end
		end
	end)
	setActive(var0_235, true)

	function var1_235(arg0_238)
		setActive(var0_235, false)
		arg2_235(arg0_238)
	end
end

function var0_0.DoShortWait(arg0_239, arg1_239)
	local var0_239 = arg0_239.ladyDict[arg1_239]
	local var1_239 = getProxy(ApartmentProxy):getApartment(arg1_239)
	local var2_239 = arg0_239.room:getApartmentZoneConfig(var0_239.ladyBaseZone, "special_action", arg1_239)
	local var3_239 = var2_239 and var2_239[math.random(#var2_239)] or nil

	if not var3_239 then
		return
	end

	arg0_239:PlaySingleAction(var0_239, var3_239)
end

function var0_0.OutOfLazy(arg0_240, arg1_240, arg2_240)
	local var0_240 = arg0_240.ladyDict[arg1_240]
	local var1_240 = {}

	if arg0_240:GetBlackboardValue(var0_240, "inPending") then
		table.insert(var1_240, function(arg0_241)
			arg0_240.shiftLady = arg1_240

			arg0_240:ShiftZone(var0_240.ladyBaseZone, arg0_241)
		end)
	end

	seriesAsync(var1_240, arg2_240)
end

function var0_0.OutOfPending(arg0_242, arg1_242, arg2_242)
	assert(arg0_242.wakeUpTalkId)

	local var0_242 = arg0_242.wakeUpTalkId

	seriesAsync({
		function(arg0_243)
			arg0_242:SetUI(arg0_243, "blank")
		end,
		function(arg0_244)
			arg0_242.shiftLady = arg1_242

			local var0_244 = arg0_242.ladyDict[arg1_242]

			arg0_242:ShiftZone(var0_244.ladyBaseZone, arg0_244)
		end,
		function(arg0_245)
			arg0_242:DoTalk(var0_242, arg0_245)
		end
	}, function()
		arg0_242:SetUIStore(arg2_242, "back")
	end)
end

function var0_0.ChangeCanWatchState(arg0_247, arg1_247)
	local var0_247

	if arg0_247:GetBlackboardValue(arg1_247, "inPending") then
		var0_247 = tobool(arg0_247:GetBlackboardValue(arg1_247, "inDistance"))
	else
		local var1_247 = arg0_247:GetBlackboardValue(arg1_247, "groupId")

		var0_247 = tobool(arg0_247.activeLady[var1_247] and pg.NodeCanvasMgr.GetInstance():GetBlackboradValue("canWatch", arg1_247.ladyBlackboard))
	end

	if arg1_247.blockCanWatch then
		var0_247 = false
	end

	if (not arg1_247.nowCanWatchState or arg1_247.nowCanWatchState ~= var0_247) and arg1_247.ladyWatchFloat then
		arg1_247.nowCanWatchState = var0_247

		arg0_247:ShowOrHideCanWatchMark(arg1_247, arg1_247.nowCanWatchState)
	end
end

function var0_0.HandleGameNotification(arg0_248, arg1_248, arg2_248)
	local var0_248 = arg0_248:GetCurrentLadyEnv()

	switch(arg1_248, {
		[Dorm3dMiniGameMediator.OPERATION] = function()
			local var0_249 = arg2_248.miniGameId

			switch(arg2_248.miniGameId, {
				[67] = function()
					if arg2_248.operationCode == "GAME_HIT_AREA" then
						local var0_250 = {
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
						local var1_250, var2_250 = unpack(var0_250[arg2_248.index])

						arg0_248:PlayFaceAnim(var0_248, var1_250)

						if arg0_248.tfCutIn then
							quickPlayAnimator(arg0_248.modelCutIn.lady, var2_250)
							quickPlayAnimator(arg0_248.modelCutIn.player, var2_250)
						end
					elseif arg2_248.operationCode == "GAME_RESULT" then
						if arg2_248.win then
							arg0_248:PlayFaceAnim(var0_248, "Face_XYX_victory")
							arg0_248:PlaySingleAction(var0_248, "minigame_win")
						else
							arg0_248:PlayFaceAnim(var0_248, "Face_XYX_lose")
							arg0_248:PlaySingleAction(var0_248, "minigame_lose")
						end

						setActive(arg0_248.rtExtraScreen:Find("MiniGameCutIn"), false)
					end
				end,
				[70] = function()
					if arg2_248.operationCode == "GAME_READY" then
						arg0_248.cameras[var0_0.CAMERA.TALK].Follow = nil
						arg0_248.cameras[var0_0.CAMERA.TALK].LookAt = nil

						arg0_248:PlaySingleAction(var0_248, "shuohua_sikao")
					elseif arg2_248.operationCode == "ROUND_RESULT" then
						local var0_251

						if arg2_248.success then
							var0_251 = {
								"shuohua_wenhou",
								"shuohua_sikao"
							}
						else
							var0_251 = {
								"shuohua_yaotou",
								"shuohua_sikao"
							}
						end

						seriesAsync(underscore.map(var0_251, function(arg0_252)
							return function(arg0_253)
								arg0_248:PlaySingleAction(var0_248, arg0_252, arg0_253)
							end
						end), function()
							return
						end)
					elseif arg2_248.operationCode == "GAME_RESULT" then
						local var1_251 = arg0_248.cameras[var0_0.CAMERA.TALK].transform

						var1_251.position = var1_251.position + var1_251.right * 0.11

						local var2_251 = {
							"shuohua_gandong"
						}

						seriesAsync(underscore.map(var2_251, function(arg0_255)
							return function(arg0_256)
								arg0_248:PlaySingleAction(var0_248, arg0_255, arg0_256)
							end
						end), function()
							return
						end)
					end
				end,
				[75] = function()
					if arg2_248.operationCode == "BEFORE_OPEN_GAME" then
						arg0_248.cameras[var0_0.CAMERA.TALK].Follow = nil
						arg0_248.cameras[var0_0.CAMERA.TALK].LookAt = nil
					elseif arg2_248.operationCode == "GAME_RPS_RESULT" then
						if arg2_248.index == 1 then
							arg0_248:PlaySingleAction(var0_248, "ab_shuohua_lianxuyaotou_01")
							arg0_248:PlayFaceAnim(var0_248, "Face_weixiao")
						elseif arg2_248.index == 2 then
							arg0_248:PlaySingleAction(var0_248, "ab_shuohua_lianxudiantou_01")
							arg0_248:PlayFaceAnim(var0_248, "Face_kaixin")
						end
					elseif arg2_248.operationCode == "GAME_RESULT" then
						if not arg2_248.win then
							arg0_248:PlaySingleAction(var0_248, "ab_shuohua_taibangle_01")
						end

						arg0_248:PlayFaceAnim(var0_248, "Face_kaixin")
					end
				end
			}, function()
				warning("without miniGameId:" .. arg2_248.miniGameId)
			end)

			if arg2_248.operationCode == "BEFORE_OPEN_GAME" then
				local var1_249 = getProxy(PlayerProxy):getPlayerId()
				local var2_249 = 0

				if var0_249 == 67 or var0_249 == 70 then
					var2_249 = PlayerPrefs.GetInt("mg_new_score_" .. tostring(var1_249) .. "_" .. arg2_248.miniGameId, 0)
				else
					var2_249 = PlayerPrefs.GetInt("mg_score_" .. tostring(var1_249) .. "_" .. arg2_248.miniGameId, 0)
				end

				arg0_248.highScore = var2_249
			elseif arg2_248.operationCode == "GAME_RESULT" then
				local var3_249 = arg2_248.score
				local var4_249 = getProxy(PlayerProxy):getPlayerId()

				if var3_249 > arg0_248.highScore then
					if var0_249 == 67 or var0_249 == 70 then
						PlayerPrefs.SetInt("mg_new_score_" .. tostring(var4_249) .. "_" .. arg2_248.miniGameId, var3_249)
					end

					getProxy(Dorm3dChatProxy):TriggerEvent({
						{
							event_type = 159,
							value = var3_249,
							ship_id = arg0_248.apartment:GetConfigID()
						}
					})
				end

				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataMiniGame(2, arg2_248.score))
			elseif arg2_248.operationCode == "GAME_CLOSE" and arg2_248.doTrack == false then
				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataMiniGame(3))
			end
		end
	})
end

function var0_0.PerformanceQueue(arg0_260, arg1_260, arg2_260)
	local var0_260, var1_260 = pcall(function()
		return require("GameCfg.dorm." .. arg1_260)
	end)

	if not var0_260 then
		errorMsg("不存在表演ID对应的Lua:" .. arg1_260)
		existCall(arg2_260)

		return
	end

	warning(arg1_260)

	arg0_260.performanceInfo = {
		name = arg1_260
	}

	local var2_260 = {}

	table.insert(var2_260, function(arg0_262)
		arg0_260:SetUI(arg0_262, "blank")
	end)
	table.insertto(var2_260, underscore.map(var1_260, function(arg0_263)
		return switch(arg0_263.type, {
			function()
				return function(arg0_265)
					local var0_265 = unpack(arg0_263.params)

					arg0_260:DoTalk(var0_265, arg0_265, true)
				end
			end,
			function()
				return function(arg0_267)
					arg0_260.touchExitCall = arg0_267

					arg0_260:EnterTouchMode()
				end
			end,
			function()
				return function(arg0_269)
					local var0_269 = arg0_260:GetCurrentLadyEnv()

					arg0_260:PlaySingleAction(var0_269, arg0_263.name, arg0_269)
				end
			end,
			function()
				return function(arg0_271)
					arg0_260:emit(arg0_260.PLAY_EXPRESSION, arg0_263)
					arg0_271()
				end
			end,
			function()
				return function(arg0_273)
					arg0_260:ShiftZone(arg0_263.name, arg0_273)
				end
			end,
			function()
				return function(arg0_275)
					arg0_260.contextData.timeIndex = arg0_263.params[1]

					local var0_275 = arg0_263.params[2] or false

					if Dorm3dSceneMgr.IsSameSceneInfo(arg0_260.dormSceneMgr.artSceneInfo, arg0_260.dormSceneMgr.sceneInfo) then
						arg0_260:SwitchDayNight(arg0_260.contextData.timeIndex)

						if var0_275 then
							onNextTick(function()
								arg0_260:RefreshSlots()
							end)
						end
					end

					arg0_260:UpdateContactState()
					onNextTick(arg0_275)
				end
			end,
			function()
				return function(arg0_278)
					if arg0_263.name then
						arg0_260:ActiveCameraByName(arg0_263.name)
						existCall(arg0_278)
					else
						arg0_260:ActiveStateCamera(arg0_263.params[1], arg0_278)
					end
				end
			end,
			function()
				return function(arg0_280)
					if arg0_263.name == "base" then
						arg0_260:RevertArtScene(arg0_260.dormSceneMgr.sceneInfo, arg0_280)
					else
						local var0_280 = arg0_263.params.scene
						local var1_280 = arg0_263.params.sceneRoot

						arg0_260:ChangeArtScene(var0_280 .. "|" .. var1_280, arg0_280)
					end
				end
			end,
			function()
				return function(arg0_282)
					local var0_282 = arg0_263.params.name

					if arg0_263.name == "load" then
						local var1_282 = tobool(arg0_263.params.wait_timeline) and function(arg0_283)
							arg0_260.waitForTimeline = arg0_283
						end

						arg0_260:LoadTimelineScene(var0_282, true, var1_282, arg0_282)
					elseif arg0_263.name == "unload" then
						arg0_260:UnloadTimelineScene(var0_282, true, arg0_282)
					else
						assert(false)
					end
				end
			end,
			function()
				return function(arg0_285)
					setActive(arg0_260.uiContainer:Find("walk/btn_back"), false)

					local var0_285 = arg0_260:GetCurrentLadyEnv()

					if arg0_263.name == "change" then
						local var1_285 = arg0_263.params.scene
						local var2_285 = arg0_263.params.sceneRoot

						var0_285.walkBornPoint = arg0_263.params.point or "Default"

						arg0_260:ChangeWalkScene(arg0_263.name, var1_285 .. "|" .. var2_285, arg0_285)
					elseif arg0_263.name == "back" then
						var0_285.walkBornPoint = nil

						arg0_260:ChangeWalkScene(arg0_263.name, arg0_260.dormSceneMgr.sceneInfo, arg0_285)
					elseif arg0_263.name == "set" then
						local function var3_285()
							local var0_286 = arg0_285

							arg0_285 = nil

							return existCall(var0_286)
						end

						for iter0_285, iter1_285 in pairs(arg0_263.params) do
							switch(iter0_285, {
								back_button_trigger = function(arg0_287)
									onButton(arg0_260, arg0_260.uiContainer:Find("walk/btn_back"), var3_285, SFX_DORM_BACK)
									setActive(arg0_260.uiContainer:Find("walk/btn_back"), IsUnityEditor and arg0_287)
								end,
								near_trigger = function(arg0_288)
									if arg0_288 == true then
										arg0_288 = 1.5
									end

									if arg0_288 then
										function arg0_260.walkNearCallback(arg0_289)
											if arg0_289 < arg0_288 then
												arg0_260.walkNearCallback = nil

												var3_285()
											end
										end
									else
										arg0_260.walkNearCallback = nil
									end
								end
							}, nil, iter1_285)
						end

						if arg0_260.firstMoveGuide then
							setActive(arg0_260.povLayer:Find("Guide"), arg0_260.firstMoveGuide)

							arg0_260.firstMoveGuide = nil
						end
					else
						assert(false)
					end
				end
			end,
			function()
				return function(arg0_291)
					if arg0_263.name == "set" then
						local var0_291 = arg0_260:GetCurrentLadyEnv()

						arg0_260:SwitchIKConfig(var0_291, arg0_263.params.state)
						setActive(arg0_260.uiContainer:Find("ik/btn_back"), not arg0_263.params.hide_back)

						arg0_260.ikSpecialCall = arg0_291

						arg0_260:SetIKState(true)
					elseif arg0_263.name == "back" then
						local var1_291 = arg0_260:GetCurrentLadyEnv()

						var1_291.ikConfig = arg0_263.params

						arg0_260:SetIKState(false, function()
							var1_291.ikConfig = nil

							existCall(arg0_291)
						end)
					else
						assert(false)
					end
				end
			end,
			function()
				return function(arg0_294)
					arg0_260.blackSceneInfo = setmetatable(arg0_263.params or {}, {
						__index = {
							color = "#000000",
							time = 0.3,
							delay = arg0_263.name == "show" and 0 or 0.5
						}
					})

					if arg0_263.name == "show" then
						arg0_260:ShowBlackScreen(true, arg0_294)
					elseif arg0_263.name == "hide" then
						arg0_260:ShowBlackScreen(false, arg0_294)
					else
						assert(false)
					end

					arg0_260.blackSceneInfo = nil
				end
			end,
			function()
				return function(arg0_296)
					local var0_296 = arg0_260:GetCurrentLadyEnv()

					if arg0_263.name == "set" then
						arg0_260.stockingMgr:SetStockingStatus(arg0_263.params)
					elseif arg0_263.name == "exit" then
						arg0_260.stockingMgr:ExitStocking()
					end
				end
			end
		})
	end))
	table.insert(var2_260, function(arg0_297)
		arg0_260:SetUI(arg0_297, "back")

		arg0_260.performanceInfo = nil
	end)
	seriesAsync(var2_260, arg2_260)
end

function var0_0.TriggerContact(arg0_298, arg1_298)
	arg0_298:emit(Dorm3dRoomMediator.COLLECTION_ITEM, {
		itemId = arg1_298,
		roomId = arg0_298.room:GetConfigID(),
		groupId = arg0_298.room:isPersonalRoom() and arg0_298.apartment:GetConfigID() or 0
	})
end

function var0_0.UpdateContactState(arg0_299)
	arg0_299:SetContactStateDic(arg0_299.room:getTriggerableCollectItemDic(arg0_299.contextData.timeIndex))
end

function var0_0.UpdateFavorDisplay(arg0_300)
	local var0_300, var1_300 = getProxy(ApartmentProxy):getStamina()

	setText(arg0_300.rtStaminaDisplay:Find("Text"), string.format("%d/%d", var0_300, var1_300))
	setActive(arg0_300.rtStaminaDisplay, false)

	if arg0_300.apartment then
		setText(arg0_300.rtFavorLevel:Find("rank/Text"), arg0_300.apartment.level)

		local var2_300, var3_300 = arg0_300.apartment:getFavor()
		local var4_300 = arg0_300.apartment:isMaxFavor()

		setActive(arg0_300.rtFavorLevel:Find("Max"), var4_300)
		setActive(arg0_300.rtFavorLevel:Find("Text"), not var4_300)
		setText(arg0_300.rtFavorLevel:Find("Text"), string.format("<color=#ff6698>%d</color>/%d", var2_300, var3_300))
	end

	setActive(arg0_300.rtFavorLevel:Find("red"), Dorm3dLevelLayer.IsShowRed())
end

function var0_0.UpdateBtnState(arg0_301)
	local var0_301 = not arg0_301.room:isPersonalRoom() or arg0_301:CheckSystemOpen("Furniture")
	local var1_301 = Dorm3dFurniture.IsTimelimitShopTip(arg0_301.room:GetConfigID())

	setActive(arg0_301.uiContainer:Find("base/left/btn_furniture/tipTimelimit"), var0_301 and var1_301)

	local var2_301 = Dorm3dFurniture.NeedViewTip(arg0_301.room:GetConfigID())

	setActive(arg0_301.uiContainer:Find("base/left/btn_furniture/tip"), var0_301 and not var1_301 and var2_301)
	setActive(arg0_301.uiContainer:Find("base/btn_back/main"), underscore(getProxy(ApartmentProxy):getRawData()):chain():values():filter(function(arg0_302)
		return tobool(arg0_302)
	end):any(function(arg0_303)
		return #arg0_303:getSpecialTalking() > 0 or arg0_303:getIconTip() == "main"
	end):value())
	setActive(arg0_301.uiContainer:Find("base/left/btn_collection/tip"), PlayerPrefs.GetInt("apartment_collection_item", 0) > 0 or PlayerPrefs.GetInt("apartment_collection_recall", 0) > 0)
end

function var0_0.AddUnlockDisplay(arg0_304, arg1_304)
	table.insert(arg0_304.unlockList, arg1_304)

	if not isActive(arg0_304.rtFavorUp) then
		setText(arg0_304.rtFavorUp:Find("Text"), table.remove(arg0_304.unlockList, 1))
		setActive(arg0_304.rtFavorUp, true)
	end
end

function var0_0.PopFavorTrigger(arg0_305, arg1_305)
	local var0_305 = arg1_305.triggerId
	local var1_305 = arg1_305.delta
	local var2_305 = arg1_305.cost
	local var3_305 = arg1_305.apartment
	local var4_305 = pg.dorm3d_favor_trigger[var0_305]

	if var4_305.is_repeat == 0 then
		if var0_305 == getDorm3dGameset("drom3d_favir_trigger_onwer")[1] then
			arg0_305:AddUnlockDisplay(i18n("dorm3d_own_favor"))
		elseif var0_305 == getDorm3dGameset("drom3d_favir_trigger_propose")[1] then
			arg0_305:AddUnlockDisplay(i18n("dorm3d_pledge_favor"))
		else
			arg0_305:AddUnlockDisplay(string.format("unknow favor trigger:%d unlock", var0_305))
		end
	elseif arg1_305.delta > 0 then
		local var5_305, var6_305 = var3_305:getFavor()
		local var7_305 = var5_305 + var1_305

		setText(arg0_305.rtFavorUpDaily:Find("bg/Text"), string.format("<size=48>+%d</size>", math.min(9999, var1_305)))
		setSlider(arg0_305.rtFavorUpDaily:Find("bg/slider"), 0, var6_305, var5_305)
		setAnchoredPosition(arg0_305.rtFavorUpDaily:Find("bg"), arg1_305.isGift and NewPos(-354, 223) or NewPos(-208, 105))

		local var8_305 = {}
		local var9_305 = arg0_305.rtFavorUpDaily:Find("bg/effect")

		eachChild(var9_305, function(arg0_306)
			setActive(arg0_306, false)
		end)

		local var10_305

		if var4_305.effect and var4_305.effect ~= "" then
			var10_305 = var9_305:Find(var4_305.effect .. "(Clone)")

			if not var10_305 then
				table.insert(var8_305, function(arg0_307)
					LoadAndInstantiateAsync("Dorm3D/Effect/Prefab/ExpressionUI", "uifx_dorm3d_yinfu01", function(arg0_308)
						setParent(arg0_308, var9_305)

						var10_305 = tf(arg0_308)

						arg0_307()
					end)
				end)
			else
				setActive(var10_305, true)
			end
		end

		local var11_305 = arg0_305.rtFavorUpDaily:GetComponent("DftAniEvent")

		var11_305:SetTriggerEvent(function(arg0_309)
			local var0_309 = GetComponent(arg0_305.rtFavorUpDaily:Find("bg/slider"), typeof(Slider))

			LeanTween.value(var5_305, var7_305, 0.5):setOnUpdate(System.Action_float(function(arg0_310)
				var0_309.value = arg0_310
			end)):setEase(LeanTweenType.easeInOutQuad):setDelay(0.165):setOnComplete(System.Action(function()
				LeanTween.delayedCall(0.165, System.Action(function()
					if arg0_305.exited then
						return
					end

					quickPlayAnimator(arg0_305.rtFavorUpDaily, "favor_out")
				end))
			end))
			pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_progaress_bar")
		end)
		var11_305:SetEndEvent(function(arg0_313)
			setActive(arg0_305.rtFavorUpDaily, false)
		end)
		seriesAsync(var8_305, function()
			local var0_314 = arg0_305.ladyDict[var3_305:GetConfigID()]

			setLocalPosition(arg0_305.rtFavorUpDaily, arg0_305:GetLocalPosition(arg0_305:GetScreenPosition(var0_314.ladyHeadCenter.position), arg0_305.rtFavorUpDaily.parent))
			setActive(arg0_305.rtFavorUpDaily, true)
			SetCompomentEnabled(arg0_305.rtFavorUpDaily, typeof(Animator), true)
			quickPlayAnimator(arg0_305.rtFavorUpDaily, "favor_open")

			if var2_305 > 0 then
				local var1_314, var2_314 = getProxy(ApartmentProxy):getStamina()

				setText(arg0_305.rtStaminaPop:Find("Text/Text (1)"), "-" .. var2_305)
				setText(arg0_305.rtStaminaPop:Find("Text"), string.format("%d/%d", var1_314 + var2_305, var2_314))
				setActive(arg0_305.rtStaminaPop, true)
			end
		end)
	end
end

function var0_0.PopFavorLevelUp(arg0_315, arg1_315, arg2_315, arg3_315)
	arg0_315.isLock = true

	LeanTween.delayedCall(0.33, System.Action(function()
		arg0_315.isLock = false
	end))

	local var0_315 = math.floor(arg1_315.level / 10)
	local var1_315 = math.fmod(arg1_315.level, 10)

	GetImageSpriteFromAtlasAsync("ui/favor_atlas", var1_315, arg0_315.rtLevelUpWindow:Find("panel/bg/item1/mark/level/digit2"))
	GetImageSpriteFromAtlasAsync("ui/favor_atlas", var0_315, arg0_315.rtLevelUpWindow:Find("panel/bg/item1/mark/level/digit1"))
	setActive(arg0_315.rtLevelUpWindow:Find("panel/bg/item1/mark/level/digit1"), var0_315 > 0)

	local var2_315
	local var3_315

	arg0_315.clientAward, var3_315 = Dorm3dIconHelper.SplitStory(arg1_315:getFavorConfig("levelup_client_item", arg1_315.level))
	arg0_315.serverAward = arg2_315

	local var4_315 = arg0_315.rtLevelUpWindow:Find("panel/info/content/itemContent")

	if not arg0_315.levelItemList then
		arg0_315.levelItemList = UIItemList.New(var4_315, var4_315:Find("tpl"))

		arg0_315.levelItemList:make(function(arg0_317, arg1_317, arg2_317)
			local var0_317 = arg1_317 + 1

			if arg0_317 == UIItemList.EventUpdate then
				if arg1_317 < #arg0_315.serverAward then
					updateDorm3dIcon(arg2_317, arg0_315.serverAward[var0_317])
					onButton(arg0_315, arg2_317, function()
						arg0_315:emit(BaseUI.ON_NEW_DROP, {
							style = "dorm",
							drop = arg0_315.serverAward[var0_317]
						})
					end, SFX_PANEL)
				else
					Dorm3dIconHelper.UpdateDorm3dIcon(arg2_317, arg0_315.clientAward[var0_317 - #arg0_315.serverAward])
					onButton(arg0_315, arg2_317, function()
						arg0_315:emit(Dorm3dRoomMediator.ON_DROP_CLIENT, {
							data = arg0_315.clientAward[var0_317 - #arg0_315.serverAward]
						})
					end, SFX_PANEL)
				end
			end
		end)
	end

	arg0_315.levelItemList:align(#arg0_315.serverAward + #arg0_315.clientAward)
	setActive(arg0_315.rtLevelUpWindow, true)
	pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_upgrade")
	arg0_315:OverlayPanel(arg0_315.rtLevelUpWindow)

	function arg0_315.levelUpCallback()
		arg0_315.levelUpCallback = nil

		if var3_315 then
			arg0_315:PopNewStoryTip(var3_315)
		end

		existCall(arg3_315)
	end
end

function var0_0.PopNewStoryTip(arg0_321, arg1_321, arg2_321)
	local var0_321 = arg0_321.uiContainer:Find("base/top/story_tip")

	setActive(var0_321, true)
	LeanTween.delayedCall(1, System.Action(function()
		setActive(var0_321, false)
	end))
	setText(var0_321:Find("Text"), i18n("dorm3d_story_unlock_tip", pg.dorm3d_recall[arg1_321[2]].name))
	existCall(arg2_321)
end

function var0_0.UpdateZoneList(arg0_323)
	local var0_323

	if arg0_323.room:isPersonalRoom() then
		var0_323 = arg0_323:GetCurrentLadyEnv().ladyBaseZone
	else
		var0_323 = arg0_323:GetAttachedFurnitureName()
	end

	for iter0_323, iter1_323 in ipairs(arg0_323.zoneDatas) do
		if iter1_323:GetWatchCameraName() == var0_323 then
			setText(arg0_323.btnZone:Find("Text"), iter1_323:GetName())
			setTextColor(arg0_323.rtZoneList:GetChild(iter0_323 - 1):Find("Name"), Color.NewHex("5CCAFF"))
		else
			setTextColor(arg0_323.rtZoneList:GetChild(iter0_323 - 1):Find("Name"), Color.NewHex("FFFFFF99"))
		end
	end
end

function var0_0.TalkingEventHandle(arg0_324, arg1_324)
	local var0_324 = {}
	local var1_324 = {}
	local var2_324 = arg1_324.data

	if var2_324.op_list then
		for iter0_324, iter1_324 in ipairs(var2_324.op_list) do
			table.insert(var0_324, function(arg0_325)
				local function var0_325()
					local var0_326 = arg0_325

					arg0_325 = nil

					return existCall(var0_326)
				end

				switch(iter1_324.type, {
					action = function()
						local var0_327 = arg0_324:GetCurrentLadyEnv()

						arg0_324:PlaySingleAction(var0_327, iter1_324.name, var0_325)
					end,
					item_action = function()
						arg0_324:PlaySceneItemAnim(iter1_324.id, iter1_324.name)
						var0_325()
					end,
					extra_item_action = function()
						local var0_329 = arg0_324:GetCurrentLadyEnv().extraItems[iter1_324.name]

						warning(iter1_324.name)
						warning(var0_329.trans)

						if var0_329 then
							var0_329.trans:GetComponent(typeof(Animator)):PlayInFixedTime(iter1_324.param)
						end

						var0_325()
					end,
					timeline = function()
						if arg0_324.inTouchGame then
							setActive(arg0_324.rtTouchGamePanel, false)
						end

						arg0_324:PlayTimeline(iter1_324, function(arg0_331, arg1_331)
							setActive(arg0_324.rtTouchGamePanel, arg0_324.inTouchGame)

							var1_324.notifiCallback = arg1_331

							var0_325()
						end)
					end,
					clickOption = function()
						arg0_324:DoTalkTouchOption(iter1_324, arg1_324.flags, function(arg0_333)
							var1_324.optionIndex = arg0_333

							var0_325()
						end)
					end,
					wait = function()
						arg0_324.LTs = arg0_324.LTs or {}

						table.insert(arg0_324.LTs, LeanTween.delayedCall(iter1_324.time, System.Action(var0_325)).uniqueId)
					end,
					expression = function()
						arg0_324:emit(arg0_324.PLAY_EXPRESSION, iter1_324)
						var0_325()
					end
				}, function()
					assert(false, "op type error:", iter1_324.type)
				end)

				if iter1_324.skip then
					var0_325()
				end
			end)
		end
	end

	seriesAsync(var0_324, function()
		if arg1_324.callbackData then
			arg0_324:emit(Dorm3dRoomMediator.TALKING_EVENT_FINISH, arg1_324.callbackData.name, var1_324)
		end
	end)
end

function var0_0.CheckQueue(arg0_338)
	if arg0_338.inGuide or arg0_338.uiState ~= "base" then
		return
	end

	if arg0_338.room:GetConfigID() == 1 and arg0_338:CheckGuide() then
		-- block empty
	elseif arg0_338.room:isPersonalRoom() and arg0_338:CheckLevelUp() then
		-- block empty
	elseif arg0_338.apartment and arg0_338:CheckEnterDeal() then
		-- block empty
	elseif arg0_338.apartment and arg0_338:CheckActiveTalk() then
		-- block empty
	elseif arg0_338.apartment then
		arg0_338:CheckFavorTrigger()
	end

	arg0_338.contextData.hasEnterCheck = true
end

function var0_0.didEnterCheck(arg0_339)
	local var0_339

	if arg0_339.contextData.specialId then
		var0_339 = arg0_339.contextData.specialId
		arg0_339.contextData.specialId = nil

		arg0_339:DoTalk(var0_339, function()
			arg0_339:closeView()
		end)

		if arg0_339.contextData.isVideoTalk then
			arg0_339.contextData.hasEnterCheck = true
		end
	elseif not arg0_339.contextData.hasEnterCheck and arg0_339.apartment then
		for iter0_339, iter1_339 in ipairs(arg0_339.apartment:getForceEnterTalking(arg0_339.room:GetConfigID())) do
			var0_339 = iter1_339

			arg0_339:DoTalk(iter1_339)

			break
		end
	end

	if var0_339 and pg.dorm3d_dialogue_group[var0_339].extend_loading > 0 then
		arg0_339.contextData.hasEnterCheck = true

		pg.SceneAnimMgr.GetInstance():RegisterDormNextCall(function()
			arg0_339:FinishEnterResume()
		end)
	else
		if arg0_339.apartment and arg0_339.contextData.pendingDic[arg0_339.apartment:GetConfigID()] then
			arg0_339.contextData.hasEnterCheck = true
		end

		for iter2_339, iter3_339 in pairs(arg0_339.contextData.pendingDic) do
			arg0_339:SetInPending(arg0_339.ladyDict[iter2_339], iter3_339)
		end

		arg0_339.contextData.pendingDic = {}

		arg0_339:FinishEnterResume()
		arg0_339:CheckQueue()
	end
end

function var0_0.CheckGuide(arg0_342)
	if arg0_342:GetBlackboardValue(arg0_342:GetCurrentLadyEnv(), "inPending") then
		return
	end

	for iter0_342, iter1_342 in ipairs({
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
				return arg0_342:CheckSystemOpen("Furniture")
			end
		},
		{
			name = "DORM3D_GUIDE_07",
			active = function()
				return arg0_342:CheckSystemOpen("DayNight")
			end
		}
	}) do
		if not pg.NewStoryMgr.GetInstance():IsPlayed(iter1_342.name) and iter1_342.active() then
			arg0_342:SetAllBlackbloardValue("inGuide", true)

			local function var0_342()
				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(2, pg.NewStoryMgr.GetInstance():StoryName2StoryId(iter1_342.name)))
				arg0_342:SetAllBlackbloardValue("inGuide", false)
			end

			pg.m02:sendNotification(GAME.STORY_UPDATE, {
				storyId = iter1_342.name
			})
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(1, pg.NewStoryMgr.GetInstance():StoryName2StoryId(iter1_342.name)))
			pg.NewGuideMgr.GetInstance():Play(iter1_342.name, nil, var0_342, var0_342)

			return true
		end
	end

	return false
end

function var0_0.CheckFavorTrigger(arg0_348)
	for iter0_348, iter1_348 in ipairs({
		{
			triggerId = getDorm3dGameset("drom3d_favir_trigger_onwer")[1],
			active = function()
				local var0_349 = getProxy(CollectionProxy):getShipGroup(arg0_348.apartment.configId)

				return tobool(var0_349)
			end
		},
		{
			triggerId = getDorm3dGameset("drom3d_favir_trigger_propose")[1],
			active = function()
				local var0_350 = getProxy(CollectionProxy):getShipGroup(arg0_348.apartment.configId)

				return var0_350 and var0_350.married > 0
			end
		}
	}) do
		if arg0_348.apartment.triggerCountDic[iter1_348.triggerId] == 0 and iter1_348.active() then
			arg0_348:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_348.apartment.configId, iter1_348.triggerId)
		end
	end
end

function var0_0.CheckEnterDeal(arg0_351)
	if arg0_351.contextData.hasEnterCheck then
		return false
	end

	local var0_351 = arg0_351.apartment:GetConfigID()
	local var1_351 = "dorm3d_enter_count_" .. var0_351
	local var2_351 = pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d")

	if PlayerPrefs.GetString("dorm3d_enter_count_day") ~= var2_351 then
		PlayerPrefs.SetString("dorm3d_enter_count_day", var2_351)
		PlayerPrefs.SetInt(var1_351, 1)
	else
		PlayerPrefs.SetInt(var1_351, PlayerPrefs.GetInt(var1_351, 0) + 1)
	end

	local var3_351 = arg0_351.apartment:getEnterTalking(arg0_351.room:GetConfigID())

	PlayerPrefs.SetString("DORM3D_DAILY_ENTER", pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d"))

	if #var3_351 > 0 then
		arg0_351:DoTalk(var3_351[math.random(#var3_351)])

		return true
	end
end

function var0_0.CheckActiveTalk(arg0_352)
	local var0_352 = arg0_352:GetCurrentLadyEnv()

	if arg0_352:GetBlackboardValue(var0_352, "inPending") then
		return false
	end

	local var1_352 = arg0_352.apartment:getZoneTalking(arg0_352.room:GetConfigID(), var0_352.ladyBaseZone)

	if #var1_352 > 0 then
		arg0_352:DoTalk(var1_352[1])

		return true
	else
		return false
	end
end

function var0_0.CheckDistanceTalk(arg0_353, arg1_353, arg2_353)
	local var0_353 = arg0_353.ladyDict[arg1_353].ladyBaseZone
	local var1_353 = getProxy(ApartmentProxy):getApartment(arg1_353)

	for iter0_353, iter1_353 in ipairs(var1_353:getDistanceTalking(arg0_353.room:GetConfigID(), var0_353)) do
		arg0_353:DoTalk(iter1_353)

		return
	end
end

function var0_0.CheckSystemOpen(arg0_354, arg1_354)
	if arg0_354.room:isPersonalRoom() then
		return switch(arg1_354, {
			Talk = function()
				local var0_355 = 1

				return var0_355 <= arg0_354.apartment.level, i18n("apartment_level_unenough", var0_355)
			end,
			Touch = function()
				local var0_356 = getDorm3dGameset("drom3d_touch_dialogue")[1]

				return var0_356 <= arg0_354.apartment.level, i18n("apartment_level_unenough", var0_356)
			end,
			Gift = function()
				local var0_357 = getDorm3dGameset("drom3d_gift_dialogue")[1]

				return var0_357 <= arg0_354.apartment.level, i18n("apartment_level_unenough", var0_357)
			end,
			PublicGame = function()
				return false
			end,
			Photo = function()
				local var0_359 = getDorm3dGameset("drom3d_photograph_unlock")[1]

				return var0_359 <= arg0_354.apartment.level, i18n("apartment_level_unenough", var0_359)
			end,
			Collection = function()
				local var0_360 = getDorm3dGameset("drom3d_recall_unlock")[1]

				return var0_360 <= arg0_354.apartment.level, i18n("apartment_level_unenough", var0_360)
			end,
			Furniture = function()
				local var0_361 = getDorm3dGameset("drom3d_furniture_unlock")[1]

				return var0_361 <= arg0_354.apartment.level, i18n("apartment_level_unenough", var0_361)
			end,
			DayNight = function()
				local var0_362 = getDorm3dGameset("drom3d_time_unlock")[1]

				return var0_362 <= arg0_354.apartment.level, i18n("apartment_level_unenough", var0_362)
			end,
			Accompany = function()
				local var0_363 = 1

				return var0_363 <= arg0_354.apartment.level, i18n("apartment_level_unenough", var0_363)
			end,
			MiniGame = function()
				local var0_364 = 1

				if var0_364 > arg0_354.apartment.level then
					return false, i18n("apartment_level_unenough", var0_364)
				elseif #arg0_354.room:getMiniGames() <= 0 then
					return false, "without minigame config in room:" .. arg0_354.room.configId
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
		return switch(arg1_354, {
			Gift = function()
				return false
			end,
			PublicGame = function()
				return true
			end,
			Furniture = function()
				local var0_370 = #arg0_354.room:GetFurnitures() > 0
				local var1_370 = #_.filter(arg0_354.room:GetFurnitureIDList() or {}, function(arg0_371)
					return Dorm3dFurniture.New({
						configId = arg0_371
					}):InShopTime()
				end) > 0

				return var0_370 or var1_370
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

function var0_0.CheckLevelUp(arg0_377)
	if arg0_377.apartment:canLevelUp() then
		arg0_377:emit(Dorm3dRoomMediator.FAVOR_LEVEL_UP, arg0_377.apartment.configId)

		return true
	end

	return false
end

function var0_0.GetIKHandTF(arg0_378)
	return arg0_378.ikHand
end

function var0_0.CycleIKCameraGroup(arg0_379)
	local var0_379 = arg0_379:GetCurrentLadyEnv()

	assert(arg0_379:GetBlackboardValue(var0_379, "inIK"))
	seriesAsync({
		function(arg0_380)
			pg.IKMgr.GetInstance():ResetActiveIKs()

			local var0_380 = var0_379.ikConfig
			local var1_380 = var0_380.camera_group
			local var2_380 = pg.dorm3d_ik_status.get_id_list_by_camera_group[var1_380]
			local var3_380 = var2_380[table.indexof(var2_380, var0_380.id) % #var2_380 + 1]

			arg0_379:SwitchIKConfig(var0_379, var3_380)
			arg0_379:SetIKState(true)
		end
	})
end

function var0_0.TempHideUI(arg0_381, arg1_381, arg2_381)
	local var0_381 = defaultValue(arg0_381.hideCount, 0)

	arg0_381.hideCount = var0_381 + (arg1_381 and 1 or -1)

	assert(arg0_381.hideCount >= 0)

	if arg0_381.hideCount * var0_381 > 0 then
		return existCall(arg2_381)
	elseif arg0_381.hideCount > 0 then
		arg0_381:SetUI(arg2_381, "blank")
	else
		arg0_381:SetUI(arg2_381, "back")
	end
end

function var0_0.onBackPressed(arg0_382)
	if arg0_382.exited or arg0_382.retainCount > 0 then
		-- block empty
	elseif isActive(arg0_382.rtLevelUpWindow) then
		triggerButton(arg0_382.rtLevelUpWindow:Find("bg"))
	elseif arg0_382.uiState ~= "base" then
		-- block empty
	else
		arg0_382:closeView()
	end
end

function var0_0.willExit(arg0_383)
	if arg0_383.downTimer then
		arg0_383.downTimer:Stop()

		arg0_383.downTimer = nil
	end

	if arg0_383.LTs then
		underscore.map(arg0_383.LTs, function(arg0_384)
			LeanTween.cancel(arg0_384)
		end)

		arg0_383.LTs = nil
	end

	if arg0_383.sliderLT then
		LeanTween.cancel(arg0_383.sliderLT)

		arg0_383.sliderLT = nil
	end

	for iter0_383, iter1_383 in pairs(arg0_383.ladyDict) do
		iter1_383.wakeUpTalkId = nil
	end

	if arg0_383.accompanyFavorTimer then
		arg0_383.accompanyFavorTimer:Stop()

		arg0_383.accompanyFavorTimer = nil
	end

	if arg0_383.accompanyPerformanceTimer then
		arg0_383.accompanyPerformanceTimer:Stop()

		arg0_383.accompanyPerformanceTimer = nil
	end

	arg0_383.canTriggerAccompanyPerformance = nil

	arg0_383.videoPlayer:Destroy()
	var0_0.super.willExit(arg0_383)
end

return var0_0
