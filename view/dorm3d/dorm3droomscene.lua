local var0_0 = class("Dorm3dRoomScene", import("view.dorm3d.Dorm3dRoomTemplateScene"))

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

	Shader.SetGlobalFloat("_ScreenClipOff", 1)

	arg0_4.uiContianer = arg0_4._tf:Find("UI")

	local var0_4 = arg0_4.uiContianer:Find("base")

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
	onButton(arg0_4, var0_4:Find("left/btn_photograph"), function()
		if #arg0_4.contextData.groupIds == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_photo_no_role"))

			return
		end

		local var0_8, var1_8 = arg0_4:CheckSystemOpen("Photo")

		if not var0_8 then
			pg.TipsMgr.GetInstance():ShowTips(var1_8)

			return
		end

		if not arg0_4.apartment then
			local var2_8 = arg0_4.contextData.groupIds[1]

			for iter0_8, iter1_8 in pairs(arg0_4.ladyDict) do
				if iter1_8.ladyBaseZone == arg0_4:GetAttachedFurnitureName() then
					var2_8 = iter0_8

					break
				end
			end

			arg0_4:SetApartment(getProxy(ApartmentProxy):getApartment(var2_8))
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
		local var0_10, var1_10 = arg0_4:CheckSystemOpen("Collection")

		if not var0_10 then
			pg.TipsMgr.GetInstance():ShowTips(var1_10)

			return
		end

		setActive(var0_4:Find("left/btn_collection/tip"), false)
		PlayerPrefs.SetInt("apartment_collection_item", 0)
		PlayerPrefs.SetInt("apartment_collection_recall", 0)
		arg0_4:emit(Dorm3dRoomMediator.OPEN_COLLECTION_LAYER, arg0_4.room:GetConfigID())
	end, SFX_PANEL)
	onButton(arg0_4, var0_4:Find("left/btn_furniture"), function()
		local var0_11, var1_11 = arg0_4:CheckSystemOpen("Furniture")

		if not var0_11 then
			pg.TipsMgr.GetInstance():ShowTips(var1_11)

			return
		end

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
		local var0_12, var1_12 = arg0_4:CheckSystemOpen("Accompany")

		if not var0_12 then
			pg.TipsMgr.GetInstance():ShowTips(var1_12)

			return
		end

		local var2_12 = arg0_4.apartment:GetConfigID()
		local var3_12

		arg0_4:emit(Dorm3dRoomMediator.OPEN_ACCOMPANY_WINDOW, {
			groupId = var2_12,
			confirmFunc = function(arg0_13)
				var3_12 = arg0_13
			end
		}, function()
			if var3_12 then
				arg0_4:OutOfLazy(var2_12, function()
					arg0_4:EnterAccompanyMode(var3_12)
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
		arg0_4:emit(Dorm3dRoomMediator.OPEN_SKIN_SELECT_LAYER, arg0_4.apartment:GetConfigID(), arg0_4.ladyDict[arg0_4.apartment:GetConfigID()], nil, function()
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
	UIItemList.StaticAlign(arg0_4.rtZoneList, arg0_4.rtZoneList:GetChild(0), #arg0_4.zoneDatas, function(arg0_20, arg1_20, arg2_20)
		if arg0_20 ~= UIItemList.EventUpdate then
			return
		end

		arg1_20 = arg1_20 + 1

		local var0_20 = arg0_4.zoneDatas[arg1_20]
		local var1_20 = var0_20:GetWatchCameraName()

		arg2_20.name = var1_20

		setText(arg2_20:Find("Name"), var0_20:GetName())
		setActive(arg2_20:Find("Line"), arg1_20 < #arg0_4.zoneDatas)
		onButton(arg0_4, arg2_20, function()
			if arg0_4.uiState ~= "base" then
				return
			end

			setActive(arg0_4.rtZoneList, false)

			local var0_21 = {}

			if arg0_4.room:isPersonalRoom() and not arg0_4:GetBlackboardValue(arg0_4.ladyDict[arg0_4.apartment:GetConfigID()], "inPending") then
				table.insert(var0_21, function(arg0_22)
					arg0_4:OutOfLazy(arg0_4.apartment:GetConfigID(), arg0_22)
				end)
			end

			table.insert(var0_21, function(arg0_23)
				arg0_4:ShiftZone(var1_20, arg0_23)
			end)
			seriesAsync(var0_21, function()
				arg0_4:CheckQueue()
			end)
		end, SFX_PANEL)
	end)

	local var2_4 = arg0_4.uiContianer:Find("walk")
	local var3_4 = arg0_4.uiContianer:Find("ik")

	onButton(arg0_4, var3_4:Find("btn_back"), function()
		if arg0_4.ikSpecialCall then
			local var0_25 = arg0_4.ikSpecialCall

			arg0_4.ikSpecialCall = nil

			existCall(var0_25)
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
		arg0_4:emit(Dorm3dRoomMediator.OPEN_SKIN_SELECT_LAYER, arg0_4.apartment:GetConfigID(), arg0_4.ladyDict[arg0_4.apartment:GetConfigID()], function(arg0_32, arg1_32, arg2_32)
			seriesAsync({
				function(arg0_33)
					arg0_4:SetIKState(false, arg0_33)
				end,
				function(arg0_34)
					arg0_32:SwitchCharacterSkin(arg1_32, arg2_32)
					arg0_4:SwitchIKConfig(arg0_32, arg0_32.ikConfig.id)
					arg0_4:SetIKState(true, arg0_34)
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
	eachChild(arg0_4.ikHand, function(arg0_36)
		setActive(arg0_36, false)
	end)

	arg0_4.ikTextTipsRoot = var4_4:Find("TextTips")

	setActive(arg0_4.ikTextTipsRoot, false)
	eachChild(arg0_4.ikTextTipsRoot, function(arg0_37)
		setActive(arg0_37, false)
	end)

	arg0_4.ikControlUI = var4_4

	local var5_4 = arg0_4.uiContianer:Find("accompany")

	onButton(arg0_4, var5_4:Find("btn_back"), function()
		arg0_4:ExitAccompanyMode()
	end, SFX_DORM_BACK)

	arg0_4.unlockList = {}
	arg0_4.rtFavorUp = arg0_4._tf:Find("Toast/favor_up")

	arg0_4.rtFavorUp:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_39)
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

	var6_4:SetTriggerEvent(function(arg0_40)
		local var0_40, var1_40 = getProxy(ApartmentProxy):getStamina()

		setText(arg0_4.rtStaminaPop:Find("Text"), string.format("%d/%d", var0_40, var1_40))
	end)
	var6_4:SetEndEvent(function(arg0_41)
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
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_4.rtLevelUpWindow, arg0_4._tf)
			existCall(arg0_4.levelUpCallback)
		end))
	end, SFX_PANEL)

	local var7_4 = arg0_4.uiContianer:Find("watch")

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
	arg0_4.rtRole = arg0_4.uiContianer:Find("watch/Role")

	onButton(arg0_4, arg0_4.rtRole:Find("Talk"), function()
		local var0_46 = arg0_4.ladyDict[arg0_4.apartment:GetConfigID()].ladyBaseZone
		local var1_46 = arg0_4.apartment:getFurnitureTalking(arg0_4.room:GetConfigID(), var0_46)

		if #var1_46 == 0 then
			pg.TipsMgr.GetInstance():ShowTips("without topic")

			return
		end

		arg0_4:DoTalk(var1_46[math.random(#var1_46)], function()
			local var0_47 = getDorm3dGameset("drom3d_favir_trigger_talk")[1]

			arg0_4:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_4.apartment.configId, var0_47)
		end)
	end, SFX_DORM_CLICK)
	setText(arg0_4.rtRole:Find("Talk/bg/Text"), i18n("dorm3d_talk"))
	onButton(arg0_4, arg0_4.rtRole:Find("Touch"), function()
		getProxy(Dorm3dChatProxy):TriggerEvent({
			{
				value = 1,
				event_type = arg0_4.contextData.timeIndex == 1 and 111 or 116,
				ship_id = arg0_4.apartment:GetConfigID()
			},
			{
				value = 1,
				event_type = 156,
				ship_id = arg0_4.apartment:GetConfigID()
			}
		})
		arg0_4:EnterTouchPerformance()
	end, SFX_DORM_CLICK)
	setText(arg0_4.rtRole:Find("Touch/bg/Text"), i18n("dorm3d_touch"))
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

		local var0_51 = pg.dorm3d_minigame[arg0_4.nowMiniGameId]
		local var1_51 = arg0_4.ladyDict[arg0_4.apartment:GetConfigID()]

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

		local var2_51 = {}

		table.insert(var2_51, function(arg0_52)
			arg0_4:SetAllBlackbloardValue("inLockLayer", true)
			arg0_4:TempHideUI(true, arg0_52)
		end)

		if var0_51.area ~= "" and var1_51.ladyBaseZone ~= var0_51.area then
			table.insert(var2_51, function(arg0_53)
				arg0_4:ShiftZone(var0_51.area, arg0_53)
			end)
		end

		local var3_51
		local var4_51

		if var0_51.action ~= "" then
			var3_51, var4_51 = unpack(var0_51.action)
		end

		table.insert(var2_51, function(arg0_54)
			parallelAsync({
				function(arg0_55)
					if var3_51 then
						arg0_4:PlaySingleAction(var1_51, var3_51, arg0_55)
					else
						arg0_55()
					end
				end,
				function(arg0_56)
					arg0_4:ActiveStateCamera("talk", arg0_56)
				end
			}, arg0_54)
		end)
		table.insert(var2_51, function(arg0_57)
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataMiniGame(1))
			arg0_4:HandleGameNotification(Dorm3dMiniGameMediator.OPERATION, {
				operationCode = "BEFORE_OPEN_GAME",
				miniGameId = arg0_4.nowMiniGameId
			})
			arg0_4:EnableMiniGameCutIn()
			arg0_4:emit(Dorm3dRoomMediator.OPEN_MINIGAME_WINDOW, {
				isDorm3d = true,
				minigameId = arg0_4.nowMiniGameId
			}, arg0_57)
		end)
		table.insert(var2_51, function(arg0_58)
			arg0_4:DisableMiniGameCutIn()

			if var4_51 then
				arg0_4:PlaySingleAction(var1_51, var4_51, arg0_58)
			else
				arg0_58()
			end
		end)
		seriesAsync(var2_51, function()
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

	eachChild(var8_4, function(arg0_68)
		setActive(arg0_68, arg0_68.name == "walk")
	end)

	arg0_4._joystick = arg0_4._tf:Find("Stick")

	setActive(arg0_4._joystick, false)
	arg0_4._joystick:GetComponent(typeof(SlideController)):SetStickFunc(function(arg0_69)
		arg0_4:emit(arg0_4.ON_STICK_MOVE, arg0_69)
	end)

	arg0_4.povLayer = arg0_4._tf:Find("POVControl")

	setActive(arg0_4.povLayer, false)
	;(function()
		local var0_70 = arg0_4.povLayer:Find("Move"):GetComponent(typeof(SlideController))

		var0_70:AddBeginDragFunc(function(arg0_71, arg1_71)
			arg0_4:emit(arg0_4.ON_POV_STICK_MOVE_BEGIN, arg1_71)
		end)
		var0_70:SetStickFunc(function(arg0_72)
			arg0_4:emit(arg0_4.ON_POV_STICK_MOVE, arg0_72)
		end)
		var0_70:AddDragEndFunc(function(arg0_73, arg1_73)
			arg0_4:emit(arg0_4.ON_POV_STICK_MOVE_END, arg1_73)
		end)
		arg0_4.povLayer:Find("View"):GetComponent(typeof(SlideController)):SetStickFunc(function(arg0_74)
			arg0_4:emit(arg0_4.ON_POV_STICK_VIEW, arg0_74)
		end)
	end)()

	arg0_4.ikControlLayer = var4_4:Find("ControlLayer")

	;(function()
		local var0_75
		local var1_75 = arg0_4.ikControlLayer:GetComponent(typeof(SlideController))

		var1_75:AddBeginDragFunc(function(arg0_76, arg1_76)
			local var0_76 = arg0_4.ladyDict[arg0_4.apartment:GetConfigID()]

			if not var0_76.IKSettings then
				return
			end

			local var1_76 = arg1_76.position
			local var2_76 = CameraMgr.instance:Raycast(var0_76.IKSettings.CameraRaycaster, var1_76)

			if var2_76.Length ~= 0 then
				local var3_76 = var2_76[0].gameObject.transform
				local var4_76 = table.keyof(var0_76.IKSettings.Colliders, var3_76)

				warning(var3_76, var4_76)

				if var4_76 then
					arg0_4:emit(var0_0.ON_BEGIN_DRAG_CHARACTER_BODY, var0_76, var4_76, var1_76)

					var0_75 = tobool(var0_76.ikHandler)

					return
				end
			end
		end)
		var1_75:AddDragFunc(function(arg0_77, arg1_77)
			local var0_77 = arg1_77.position
			local var1_77 = arg0_4.ladyDict[arg0_4.apartment:GetConfigID()]

			if var1_77.ikHandler then
				arg0_4:emit(var0_0.ON_DRAG_CHARACTER_BODY, var1_77, var0_77)

				return
			end

			if var0_75 then
				return
			end

			local var2_77 = arg1_77.delta

			arg0_4:emit(arg0_4.ON_STICK_MOVE, var2_77)
		end)
		var1_75:AddDragEndFunc(function(arg0_78, arg1_78)
			var0_75 = nil

			local var0_78 = arg0_4.ladyDict[arg0_4.apartment:GetConfigID()]

			if var0_78.ikHandler then
				arg0_4:emit(var0_0.ON_RELEASE_CHARACTER_BODY, var0_78)

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

function var0_0.InitExtraSystem(arg0_80, arg1_80)
	arg1_80 = arg1_80 or {
		"FurnitureSlide"
	}

	for iter0_80, iter1_80 in ipairs(arg1_80) do
		switch(iter1_80, {
			FurnitureSlide = function()
				if not SlideExtraSystem.IsOpen(arg0_80.room) then
					return
				end

				arg0_80:emit(Dorm3dRoomMediator.ADD_EXTRA_SYSTEM_FURNITURE_SLIDE, {
					scene = arg0_80
				})
			end
		})
	end
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
		local var0_91 = arg0_82.ladyDict[arg0_82.apartment:GetConfigID()]

		if not arg0_82:GetBlackboardValue(var0_91, "inIK") then
			return
		end

		arg0_82:OnTouchCharacterBody(arg1_91)
	end)
	arg0_82:bind(var0_0.ON_IK_STATUS_CHANGED, function(arg0_92, arg1_92, arg2_92)
		local var0_92 = arg0_82.ladyDict[arg0_82.apartment:GetConfigID()]

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
	arg0_95:InitExtraSystem()

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

	arg0_101.uiStore = {}

	eachChild(arg0_101.uiContianer, function(arg0_102)
		setActive(arg0_102, arg0_102.name == arg0_101.uiState)
	end)
	arg0_101:EnablePOVLayer(arg0_101.uiState == "base" or arg0_101.uiState == "walk")
	arg0_101:TempHideContact(arg0_101.uiState ~= "base")
	arg0_101:SetFloatEnable(arg0_101.uiState == "walk")
	setActive(arg0_101.rtFloatPage, arg0_101.uiState == "walk")
	setActive(arg0_101.ikControlUI, arg0_101.uiState == "ik")
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
				end))

				var1_104 = var1_104 + 0.066
			end

			setActive(arg0_101.rtRole:Find("Gift/bg/Tip"), Dorm3dGift.NeedViewTip(arg0_101.apartment:GetConfigID()))
		end,
		ik = function()
			setActive(arg0_101.uiContianer:Find("ik/Right/MenuSmall"), arg0_101.room:isPersonalRoom() and not arg0_101.performanceInfo)
			setActive(arg0_101.uiContianer:Find("ik/Right/Menu"), false)
		end,
		walk = function()
			setText(arg0_101.uiContianer:Find("walk/dialogue/content"), i18n("dorm3d_removable", arg0_101.apartment:getConfig("name")))
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

function var0_0.EnterWatchMode(arg0_111)
	local var0_111 = arg0_111.apartment:GetConfigID()

	seriesAsync({
		function(arg0_112)
			arg0_111:emit(arg0_111.SHOW_BLOCK)
			arg0_111:SetBlackboardValue(arg0_111.ladyDict[var0_111], "inWatchMode", true)
			arg0_111:SetUI(arg0_112, "watch")
		end,
		function(arg0_113)
			arg0_111:emit(arg0_111.HIDE_BLOCK)
		end
	})
end

function var0_0.ExitWatchMode(arg0_114)
	local var0_114 = arg0_114.apartment:GetConfigID()

	seriesAsync({
		function(arg0_115)
			arg0_114:emit(arg0_114.SHOW_BLOCK)
			arg0_114:SetUI(arg0_115, "back")
		end,
		function(arg0_116)
			arg0_114:SetBlackboardValue(arg0_114.ladyDict[var0_114], "inWatchMode", false)
			arg0_114:emit(arg0_114.HIDE_BLOCK)
			arg0_114:CheckQueue()
		end
	})
end

function var0_0.SetInPending(arg0_117, arg1_117, arg2_117)
	local var0_117 = arg0_117:GetBlackboardValue(arg1_117, "groupId")
	local var1_117 = pg.dorm3d_welcome[arg2_117]

	arg0_117:SetBlackboardValue(arg1_117, "inPending", true)
	arg0_117:ChangeCanWatchState(arg1_117)
	arg0_117:EnableHeadIK(arg1_117, false)

	arg0_117.contextData.ladyZone[var0_117] = var1_117.area
	arg1_117.ladyBaseZone = arg0_117.contextData.ladyZone[var0_117]
	arg1_117.ladyActiveZone = var1_117.welcome_staypoint

	arg0_117:ChangeCharacterPosition(arg1_117)

	if var1_117.item_shield ~= "" then
		arg0_117.hideItemDic = {}

		for iter0_117, iter1_117 in ipairs(var1_117.item_shield) do
			local var2_117 = arg0_117.modelRoot:Find(iter1_117)

			if not var2_117 then
				warning(string.format("welcome:%d without hide item:%s", arg2_117, iter1_117))
			else
				arg0_117.hideItemDic[iter1_117] = isActive(var2_117)

				setActive(var2_117, false)
			end
		end
	end

	onNextTick(function()
		if arg1_117.tfPendintItem then
			setActive(arg1_117.tfPendintItem, true)
		end

		arg0_117:SwitchAnim(arg1_117, var1_117.welcome_idle)
	end)

	arg0_117.wakeUpTalkId = var1_117.welcome_talk
end

function var0_0.SetOutPending(arg0_119, arg1_119)
	arg0_119:SetBlackboardValue(arg1_119, "inPending", false)
	arg0_119:ChangeCanWatchState(arg1_119)
	arg0_119:EnableHeadIK(arg1_119, true)

	arg0_119.wakeUpTalkId = nil

	if arg1_119.tfPendintItem then
		setActive(arg1_119.tfPendintItem, false)
	end

	if arg0_119.hideItemDic then
		for iter0_119, iter1_119 in pairs(arg0_119.hideItemDic) do
			setActive(arg0_119.modelRoot:Find(iter0_119), iter1_119)
		end

		arg0_119.hideItemDic = nil
	end
end

function var0_0.IsModeInHidePending(arg0_120, arg1_120)
	for iter0_120, iter1_120 in pairs(arg0_120.ladyDict) do
		if iter1_120.hideItemDic and iter1_120.hideItemDic[arg1_120] ~= nil then
			return true
		end
	end

	return false
end

function var0_0.EnterAccompanyMode(arg0_121, arg1_121)
	local var0_121 = pg.dorm3d_accompany[arg1_121]
	local var1_121
	local var2_121

	if var0_121.sceneInfo ~= "" then
		var1_121, var2_121 = unpack(string.split(var0_121.sceneInfo, "|"))
	end

	local var3_121 = {
		type = "timeline",
		name = var0_121.timeline,
		scene = var1_121,
		sceneRoot = var2_121,
		accompanys = {}
	}

	for iter0_121, iter1_121 in ipairs(var0_121.jump_trigger) do
		local var4_121, var5_121 = unpack(iter1_121)

		var3_121.accompanys[var4_121] = var5_121
	end

	local var6_121, var7_121 = unpack(var0_121.favor)

	getProxy(Dorm3dChatProxy):TriggerEvent({
		{
			value = 1,
			event_type = 161,
			ship_id = arg0_121.apartment:GetConfigID()
		}
	})
	getProxy(ApartmentProxy):RecordAccompanyTime()
	pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataAccompany(1, var0_121.ship_id, var0_121.performance_time, 0, var1_121 or arg0_121.dormSceneMgr.artSceneInfo))

	local var8_121 = {}

	table.insert(var8_121, function(arg0_122)
		arg0_121:SetUI(arg0_122, "blank", "accompany")
	end)
	table.insert(var8_121, function(arg0_123)
		arg0_121.accompanyFavorCount = 0
		arg0_121.accompanyFavorTimer = Timer.New(function()
			arg0_121.accompanyFavorCount = arg0_121.accompanyFavorCount + 1
		end, var6_121, -1)

		arg0_121.accompanyFavorTimer:Start()

		arg0_121.accompanyPerformanceTimer = Timer.New(function()
			arg0_121.canTriggerAccompanyPerformance = true
		end, var0_121.performance_time, -1)

		arg0_121.accompanyPerformanceTimer:Start()
		arg0_121:PlayTimeline(var3_121, function(arg0_126, arg1_126)
			arg1_126()
			arg0_123()
		end)
	end)
	seriesAsync(var8_121, function()
		assert(arg0_121.accompanyFavorTimer)
		arg0_121.accompanyFavorTimer:Stop()

		arg0_121.accompanyFavorTimer = nil

		assert(arg0_121.accompanyPerformanceTimer)
		arg0_121.accompanyPerformanceTimer:Stop()

		arg0_121.accompanyPerformanceTimer = nil
		arg0_121.canTriggerAccompanyPerformance = nil

		local var0_127 = math.min(arg0_121.accompanyFavorCount, getProxy(ApartmentProxy):getStamina())

		if var0_127 > 0 then
			local var1_127 = var7_121[var0_127]

			warning(var1_127)
			arg0_121:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_121.apartment.configId, var1_127)
		end

		local var2_127 = 0
		local var3_127 = getProxy(ApartmentProxy):GetAccompanyTime()

		if var3_127 then
			var2_127 = pg.TimeMgr.GetInstance():GetServerTime() - var3_127
		end

		pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataAccompany(2, var0_121.ship_id, var0_121.performance_time, var2_127, var1_121 or arg0_121.dormSceneMgr.artSceneInfo))
		arg0_121:SetUI(nil, "back", "back")
	end)
end

function var0_0.ExitAccompanyMode(arg0_128)
	existCall(arg0_128.timelineFinishCall)
end

function var0_0.EnterTouchPerformance(arg0_129)
	local var0_129 = arg0_129.ladyDict[arg0_129.apartment:GetConfigID()]
	local var1_129 = arg0_129.room:getApartmentZoneConfig(var0_129.ladyBaseZone, "touch_performance", arg0_129.apartment:GetConfigID())

	if not var1_129 or var1_129 == 0 then
		arg0_129:EnterTouchMode()
	else
		arg0_129:DoTalk(var1_129)
	end
end

function var0_0.EnterTouchMode(arg0_130)
	local var0_130 = arg0_130.ladyDict[arg0_130.apartment:GetConfigID()]

	if arg0_130:GetBlackboardValue(var0_130, "inTouching") then
		return
	end

	local var1_130 = arg0_130.room:getApartmentZoneConfig(var0_130.ladyBaseZone, "touch_id", arg0_130.apartment:GetConfigID())

	arg0_130.touchConfig = pg.dorm3d_touch_data[var1_130]

	if not arg0_130.touchConfig then
		arg0_130:EnterTimelineTouchMode()

		return
	end

	arg0_130.inTouchGame = arg0_130.touchConfig.heartbeat_enable > 0

	setActive(arg0_130.rtTouchGamePanel, arg0_130.inTouchGame)

	if arg0_130.inTouchGame then
		arg0_130.touchCount = 0
		arg0_130.touchLevel = 1
		arg0_130.lastCount = 0
		arg0_130.topCount = 0

		arg0_130:UpdateTouchGameDisplay()
		setSlider(arg0_130.rtTouchGamePanel:Find("slider"), 0, 100, arg0_130.touchCount >= 200 and 100 or arg0_130.touchCount % 100)
		quickPlayAnimation(arg0_130.rtTouchGamePanel, "anim_dorm3d_touch_in")
		quickPlayAnimation(arg0_130.rtTouchGamePanel:Find("slider/icon"), "anim_dorm3d_touch_icon")

		arg0_130.downTimer = Timer.New(function()
			local var0_131 = pg.dorm3d_set.reduce_interaction.key_value_int

			if arg0_130.touchLevel > 1 then
				var0_131 = pg.dorm3d_set.reduce_heartbeat.key_value_int
			end

			arg0_130:UpdateTouchCount(var0_131)
		end, 1, -1)

		arg0_130.downTimer:Start()
	end

	local var2_130 = {}

	table.insert(var2_130, function(arg0_132)
		arg0_130:SetBlackboardValue(var0_130, "inTouching", true)
		arg0_130:emit(arg0_130.SHOW_BLOCK)
		arg0_130:SetUI(arg0_132, "blank")
	end)
	table.insert(var2_130, function(arg0_133)
		local var0_133 = arg0_130.touchConfig.ik_status[1]

		arg0_130:SwitchIKConfig(var0_130, var0_133)
		setActive(arg0_130.uiContianer:Find("ik/btn_back"), true)
		arg0_130:SetIKState(true, arg0_133)
	end)
	table.insert(var2_130, function(arg0_134)
		existCall(arg0_134)
	end)
	seriesAsync(var2_130, function()
		Shader.SetGlobalFloat("_ScreenClipOff", 0)
		arg0_130:emit(arg0_130.HIDE_BLOCK)
	end)
end

function var0_0.ExitTouchMode(arg0_136)
	local var0_136 = arg0_136.ladyDict[arg0_136.apartment:GetConfigID()]

	if not arg0_136:GetBlackboardValue(var0_136, "inTouching") then
		return
	end

	if arg0_136.touchTimelineConfig then
		existCall(arg0_136.timelineFinishCall)

		return
	end

	local var1_136 = {}

	if arg0_136.inTouchGame then
		table.insert(var1_136, function(arg0_137)
			arg0_136:emit(arg0_136.SHOW_BLOCK)
			quickPlayAnimation(arg0_136.rtTouchGamePanel, "anim_dorm3d_touch_out")
			onDelayTick(arg0_137, 0.5)
		end)
		table.insert(var1_136, function(arg0_138)
			local var0_138 = 0

			for iter0_138, iter1_138 in ipairs(arg0_136.touchConfig.heartbeat_favor) do
				if iter1_138[1] > arg0_136.topCount then
					break
				else
					var0_138 = iter1_138[2]
				end
			end

			if var0_138 > 0 then
				arg0_136:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_136.apartment.configId, var0_138)
			end

			arg0_136.touchCount = nil
			arg0_136.touchLevel = nil
			arg0_136.topCount = nil

			if arg0_136.downTimer then
				arg0_136.downTimer:Stop()

				arg0_136.downTimer = nil
			end

			arg0_136.inTouchGame = false

			setActive(arg0_136.rtTouchGamePanel, false)
			Shader.SetGlobalFloat("_ScreenClipOff", 1)
			arg0_138()
		end)
	else
		table.insert(var1_136, function(arg0_139)
			arg0_136:emit(arg0_136.SHOW_BLOCK)

			local var0_139 = arg0_136.touchConfig.default_favor

			if var0_139 > 0 then
				arg0_136:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_136.apartment.configId, var0_139)
			end

			Shader.SetGlobalFloat("_ScreenClipOff", 1)
			arg0_139()
		end)
	end

	table.insert(var1_136, function(arg0_140)
		var0_136.ikConfig = {
			character_position = var0_136.ladyBaseZone,
			character_action = arg0_136.touchConfig.finish_action
		}

		arg0_136:SetIKState(false, arg0_140)
	end)
	table.insert(var1_136, function(arg0_141)
		var0_136.ikConfig = nil
		arg0_136.blockIK = nil

		arg0_136:SetUI(arg0_141, "back")
	end)
	seriesAsync(var1_136, function()
		arg0_136:SetBlackboardValue(var0_136, "inTouching", false)
		arg0_136:emit(arg0_136.HIDE_BLOCK)

		arg0_136.touchConfig = nil

		local var0_142 = arg0_136.touchExitCall

		arg0_136.touchExitCall = nil

		existCall(var0_142)
	end)
end

function var0_0.ChangeWalkScene(arg0_143, arg1_143, arg2_143, arg3_143)
	local var0_143 = arg0_143.ladyDict[arg0_143.apartment:GetConfigID()]

	seriesAsync({
		function(arg0_144)
			arg0_143:ChangeArtScene(arg2_143, arg0_144)
		end,
		function(arg0_145)
			arg0_143:ChangeSubScene(arg2_143, arg0_145)
		end,
		function(arg0_146)
			arg0_143:emit(arg0_143.SHOW_BLOCK)

			if arg1_143 == "back" then
				arg0_143:SetUI(arg0_146, "back")
			elseif arg1_143 == "change" and arg0_143.uiState ~= "walk" then
				arg0_143:SetUI(arg0_146, "walk")
			else
				arg0_146()
			end
		end
	}, function()
		arg0_143:emit(arg0_143.HIDE_BLOCK)
		arg0_143:SetBlackboardValue(var0_143, "inWalk", arg1_143 == "change")
		existCall(arg3_143)
	end)
end

function var0_0.EnterTimelineTouchMode(arg0_148)
	local var0_148 = arg0_148.ladyDict[arg0_148.apartment:GetConfigID()]

	if arg0_148:GetBlackboardValue(var0_148, "inIK") then
		return
	end

	local var1_148 = arg0_148.room:getApartmentZoneConfig(var0_148.ladyBaseZone, "touch_id", arg0_148.apartment:GetConfigID())
	local var2_148 = pg.dorm3d_ik_timeline[var1_148]

	assert(var2_148, "Missing config in dorm3d_ik_timeline ID: " .. (var1_148 or "nil"))

	arg0_148.touchTimelineConfig = var2_148

	local var3_148 = {}

	table.insert(var3_148, function(arg0_149)
		arg0_148:SetBlackboardValue(var0_148, "inIK", true)
		arg0_148:emit(arg0_148.SHOW_BLOCK)
		arg0_148:SetUI(arg0_149, "ik")
	end)
	table.insert(var3_148, function(arg0_150)
		setActive(arg0_148.uiContianer:Find("ik/btn_back"), true)
		setActive(arg0_148.uiContianer:Find("ik/Right/btn_camera"), false)
		setActive(arg0_148.uiContianer:Find("ik/Right/Menu"), false)
		setActive(arg0_148.uiContianer:Find("ik/Right/MenuSmall"), false)
		Shader.SetGlobalFloat("_ScreenClipOff", 0)
		arg0_148:emit(arg0_148.HIDE_BLOCK)
		arg0_148:HideCharacterBylayer(var0_148)
		setActive(var0_148.ladyCollider, false)

		local var0_150
		local var1_150

		if #var2_148.scene > 0 then
			var0_150, var1_150 = unpack(string.split(var2_148.scene, "|"))
		end

		arg0_148:PlayTimeline({
			name = var2_148.timeline,
			scene = var0_150,
			sceneRoot = var1_150
		}, function(arg0_151, arg1_151)
			arg1_151()
			arg0_148:ExitTimelineTouchMode()
		end)
	end)
	seriesAsync(var3_148, function()
		return
	end)
end

function var0_0.ExitTimelineTouchMode(arg0_153)
	local var0_153 = arg0_153.ladyDict[arg0_153.apartment:GetConfigID()]

	if not arg0_153:GetBlackboardValue(var0_153, "inIK") then
		return
	end

	arg0_153.touchTimelineConfig = nil

	local var1_153 = {}

	table.insert(var1_153, function(arg0_154)
		arg0_153:emit(arg0_153.SHOW_BLOCK)
		Shader.SetGlobalFloat("_ScreenClipOff", 1)
		arg0_154()
	end)
	table.insert(var1_153, function(arg0_155)
		arg0_153:RevertCharacterBylayer(var0_153)
		setActive(var0_153.ladyCollider, true)
		arg0_153:SetUI(arg0_155, "back")
	end)
	seriesAsync(var1_153, function()
		arg0_153:SetBlackboardValue(var0_153, "inIK", false)
		arg0_153:emit(arg0_153.HIDE_BLOCK)
	end)
end

function var0_0.EnterWalkMode(arg0_157)
	local var0_157 = arg0_157.apartment:GetConfigID()
	local var1_157 = arg0_157.ladyDict[var0_157]

	seriesAsync({
		function(arg0_158)
			arg0_157:emit(arg0_157.SHOW_BLOCK)
			arg0_157:HideCharacter(var0_157)
			arg0_157:SetBlackboardValue(var1_157, "inWalk", true)
			arg0_157:SetUI(arg0_158, "walk")
		end,
		function(arg0_159)
			arg0_157:emit(arg0_157.HIDE_BLOCK)
			arg0_157:ChangeArtScene(arg0_157.walkInfo.scene .. "|" .. arg0_157.walkInfo.sceneRoot, arg0_159)
		end,
		function(arg0_160)
			arg0_157:LoadSubScene(arg0_157.walkInfo, arg0_160)
		end
	}, function()
		return
	end)
end

function var0_0.ExitWalkMode(arg0_162)
	local var0_162 = arg0_162.apartment:GetConfigID()
	local var1_162 = arg0_162.ladyDict[var0_162]

	seriesAsync({
		function(arg0_163)
			arg0_162:ChangeArtScene(arg0_162.walkLastSceneInfo, arg0_163)
		end,
		function(arg0_164)
			arg0_162:UnloadSubScene(arg0_162.walkInfo, arg0_164)
		end,
		function(arg0_165)
			arg0_162:emit(arg0_162.SHOW_BLOCK)
			arg0_162:SetUI(arg0_165, "back")
		end
	}, function()
		arg0_162:emit(arg0_162.HIDE_BLOCK)
		arg0_162:RevertCharacter(var0_162)
		arg0_162:SetBlackboardValue(var1_162, "inWalk", false)

		local var0_166 = arg0_162.walkExitCall

		arg0_162.walkExitCall = nil
		arg0_162.walkLastSceneInfo = nil
		arg0_162.walkInfo = nil

		existCall(var0_166)
	end)
end

function var0_0.EnableMiniGameCutIn(arg0_167)
	if not arg0_167.tfCutIn then
		return
	end

	local var0_167 = arg0_167.rtExtraScreen:Find("MiniGameCutIn")

	setActive(var0_167, true)

	local var1_167 = GetOrAddComponent(var0_167:Find("bg/mask/cut_in"), "CameraRTUI")

	setActive(var1_167, true)
	pg.CameraRTMgr.GetInstance():Bind(var1_167, arg0_167.tfCutIn:Find("TestCamera"):GetComponent(typeof(Camera)))
	quickPlayAnimator(arg0_167.modelCutIn.lady, "Idle")
	quickPlayAnimator(arg0_167.modelCutIn.player, "Idle")
	setActive(arg0_167.tfCutIn, true)
end

function var0_0.DisableMiniGameCutIn(arg0_168)
	if not arg0_168.tfCutIn then
		return
	end

	local var0_168 = arg0_168.rtExtraScreen:Find("MiniGameCutIn")
	local var1_168 = GetOrAddComponent(var0_168:Find("bg/mask/cut_in"), "CameraRTUI")

	pg.CameraRTMgr.GetInstance():Clean(var1_168)
	setActive(var0_168, false)
	setActive(arg0_168.tfCutIn, false)
end

function var0_0.SwitchIKConfig(arg0_169, arg1_169, arg2_169)
	local var0_169 = pg.dorm3d_ik_status[arg2_169]

	if var0_169.skin_id ~= arg1_169.skinId then
		local var1_169 = pg.dorm3d_ik_status.get_id_list_by_base[var0_169.base]
		local var2_169 = _.detect(var1_169, function(arg0_170)
			return pg.dorm3d_ik_status[arg0_170].skin_id == arg1_169.skinId
		end)

		assert(var2_169, string.format("Missing Status Config By Skin: %s original Status: %s", arg1_169.skinId, arg2_169))

		var0_169 = pg.dorm3d_ik_status[var2_169]
	end

	arg1_169.ikConfig = var0_169
end

function var0_0.SetIKState(arg0_171, arg1_171, arg2_171)
	local var0_171 = arg0_171.ladyDict[arg0_171.apartment:GetConfigID()]
	local var1_171 = {}

	if arg1_171 then
		table.insert(var1_171, function(arg0_172)
			arg0_171:SetBlackboardValue(var0_171, "inIK", true)
			arg0_171:emit(arg0_171.SHOW_BLOCK)

			local var0_172 = var0_171.ikConfig.camera_group

			setActive(arg0_171.uiContianer:Find("ik/Right/btn_camera"), #pg.dorm3d_ik_status.get_id_list_by_camera_group[var0_172] > 1)
			setActive(arg0_171.ikControlUI, true)
			arg0_172()
		end)

		if arg0_171.uiState ~= "ik" then
			table.insert(var1_171, function(arg0_173)
				arg0_171:SetUI(arg0_173, "ik")
			end)
		end

		table.insert(var1_171, function(arg0_174)
			Shader.SetGlobalFloat("_ScreenClipOff", 0)
			arg0_171:SetIKStatus(var0_171, var0_171.ikConfig, arg0_174)
		end)
		table.insert(var1_171, function(arg0_175)
			arg0_171:emit(arg0_171.HIDE_BLOCK)
			arg0_175()
		end)
	else
		assert(arg0_171.uiState == "ik")
		table.insert(var1_171, function(arg0_176)
			setActive(arg0_171.ikControlUI, false)
			arg0_171:emit(arg0_171.SHOW_BLOCK)
			Shader.SetGlobalFloat("_ScreenClipOff", 1)
			arg0_176()
		end)
		table.insert(var1_171, function(arg0_177)
			arg0_171:ExitIKStatus(var0_171, var0_171.ikConfig, arg0_177)
			arg0_171:ResetSceneItemAnimators()
		end)
		table.insert(var1_171, function(arg0_178)
			arg0_171:SetUI(arg0_178, "back")
		end)
		table.insert(var1_171, function(arg0_179)
			arg0_171:SetBlackboardValue(var0_171, "inIK", false)
			arg0_171:emit(arg0_171.HIDE_BLOCK)
			arg0_179()
		end)
	end

	seriesAsync(var1_171, arg2_171)
end

function var0_0.TouchModeAction(arg0_180, arg1_180, arg2_180, arg3_180, ...)
	return switch(arg3_180, {
		function(arg0_181, arg1_181)
			return function(arg0_182)
				seriesAsync({
					function(arg0_183)
						if not arg1_181 or arg1_181 == "" then
							return arg0_183()
						end

						arg0_180:PlaySingleAction(arg1_180, arg1_181, arg0_183)
					end,
					function(arg0_184)
						arg0_180:SwitchIKConfig(arg1_180, arg0_181)
						arg0_180:SetIKState(true, arg0_184)
					end,
					arg0_182
				})
			end
		end,
		function()
			return function()
				if arg0_180.ikSpecialCall then
					local var0_186 = arg0_180.ikSpecialCall

					arg0_180.ikSpecialCall = nil

					existCall(var0_186)
				else
					arg0_180:ExitTouchMode()
				end
			end
		end,
		function(arg0_187, arg1_187)
			return function(arg0_188)
				arg0_180:PlaySingleAction(arg1_180, arg1_187, arg0_188)
			end
		end,
		function(arg0_189, arg1_189, arg2_189)
			return function(arg0_190)
				seriesAsync({
					function(arg0_191)
						arg0_180:DoTalk(arg1_189, arg0_191)
					end,
					function(arg0_192)
						if not arg2_189 or arg2_189 == 0 then
							return arg0_192()
						end

						arg0_180:SwitchIKConfig(arg1_180, arg2_189)
						arg0_180:SetIKState(true, arg0_192)
					end,
					arg0_190
				})
			end
		end,
		function(arg0_193, arg1_193, arg2_193, arg3_193)
			return function(arg0_194)
				arg0_180:PlaySceneItemAnim(arg2_193, arg3_193)
				arg0_180:PlaySingleAction(arg1_193, arg0_194)
			end
		end,
		function(arg0_195)
			return function(arg0_196)
				local var0_196 = pg.dorm3d_ik_touch[arg2_180]

				if #var0_196.scene_item == 0 then
					return
				end

				local var1_196 = arg0_180:GetSceneItem(var0_196.scene_item)

				if not var1_196 then
					warning(string.format("dorm3d_ik_touch:%d without scene_item:%s", arg2_180, var0_196.scene_item))

					return
				end

				local var2_196 = var1_196:Find(arg0_195)

				if not IsNil(var2_196) then
					setActive(var2_196, false)
					setActive(var2_196, true)
				end

				arg0_196()
			end
		end,
		function(arg0_197)
			local var0_197 = pg.dorm3d_ik_touch_move[arg0_197]
			local var1_197 = var0_197.target_ik
			local var2_197 = var0_197.move_time
			local var3_197 = var0_197.ik_point
			local var4_197 = var0_197.touch_step

			arg1_180.IKSettings.forceMove = arg1_180.IKSettings.forceMove or {}

			local var5_197 = arg1_180.IKSettings.forceMove

			var5_197[var1_197] = var5_197[var1_197] or {}
			var5_197[var1_197].count = var5_197[var1_197].count or 0

			return function(arg0_198)
				seriesAsync({
					function(arg0_199)
						if var5_197[var1_197].count >= #var4_197 then
							return arg0_199()
						end

						local var0_199 = Dorm3dIK.New({
							configId = var1_197
						})
						local var1_199 = Vector2.New(unpack(var3_197))
						local var2_199 = var5_197[var1_197].count
						local var3_199 = var4_197[var2_199 + 1] - (var2_199 == 0 and 0 or var4_197[var2_199])

						var5_197[var1_197].count = var2_199 + 1

						pg.IKMgr.GetInstance():ResetIK(var0_199:GetTriggerBoneName())

						local var4_199 = arg1_180.IKSettings.Colliders[var0_199:GetTriggerBoneName()]
						local var5_199 = arg0_180.raycastCamera:WorldToScreenPoint(var4_199.position)

						pg.IKMgr.GetInstance():PlayIKMove(var5_199, var0_199:GetTriggerBoneName(), var1_199, var4_197[var2_199 + 1], var2_197, function()
							var5_197[var1_197].count = 0

							arg0_199()
						end)
					end,
					arg0_198
				})
			end
		end
	}, function()
		return function()
			return
		end
	end, ...)
end

function var0_0.OnTriggerIK(arg0_203, arg1_203)
	local var0_203 = arg0_203.ladyDict[arg0_203.apartment:GetConfigID()]

	if var0_203.ikTimelineMode then
		arg0_203:ExitIKTimelineStatus(var0_203)

		local var1_203 = arg1_203:GetTimelineAction()

		if var1_203 then
			arg0_203.nowTimelinePlayer:TriggerEvent(var1_203)
		end

		return
	end

	if not var0_203.ikConfig then
		return
	end

	local var2_203 = arg1_203:GetControllerPath()
	local var3_203 = var0_203.ikActionDict[var2_203]

	if not var3_203 then
		return
	end

	arg0_203.blockIK = true

	arg0_203:TouchModeAction(var0_203, arg1_203:GetConfigID(), unpack(var3_203))(function()
		arg0_203:ResetIKTipTimer()

		arg0_203.blockIK = nil
	end)
end

function var0_0.OnTouchCharacterBody(arg0_205, arg1_205)
	local var0_205 = arg0_205.ladyDict[arg0_205.apartment:GetConfigID()]

	if not var0_205.ikConfig then
		return
	end

	if type(var0_205.ikConfig.touch_data) ~= "table" then
		return
	end

	for iter0_205, iter1_205 in ipairs(var0_205.iKTouchDatas) do
		local var1_205, var2_205, var3_205 = unpack(iter1_205)
		local var4_205 = pg.dorm3d_ik_touch[var1_205]

		if var4_205.body == arg1_205 then
			local var5_205 = var4_205.action_emote

			if #var5_205 > 0 then
				arg0_205:PlayFaceAnim(var0_205, var5_205)
			end

			local var6_205 = var4_205.vibrate

			if type(var6_205) == "table" and VibrateMgr.Instance:IsSupport() then
				local var7_205 = {}
				local var8_205 = {}
				local var9_205 = {}

				underscore.each(var6_205, function(arg0_206)
					local var0_206 = arg0_206[1]

					if PLATFORM == PLATFORM_IPHONEPLAYER then
						var0_206 = var0_206 / 1000
					end

					table.insert(var7_205, var0_206)
					table.insert(var8_205, arg0_206[2])
					table.insert(var9_205, 1)
				end)

				if PLATFORM == PLATFORM_ANDROID then
					VibrateMgr.Instance:VibrateWaveform(var7_205, var8_205)
				elseif PLATFORM == PLATFORM_IPHONEPLAYER then
					VibrateMgr.Instance:VibrateWaveform(var7_205, var8_205, var9_205)
				end
			end

			arg0_205.blockIK = true

			arg0_205:TouchModeAction(var0_205, var1_205, unpack(var3_205))(function()
				arg0_205:ResetIKTipTimer()

				arg0_205.blockIK = nil
			end)

			return
		end
	end
end

function var0_0.UpdateTouchGameDisplay(arg0_208)
	setActive(arg0_208.rtTouchGamePanel:Find("effect_bg"), arg0_208.touchLevel == 2)
	setActive(arg0_208.rtTouchGamePanel:Find("slider/icon/beating"), arg0_208.touchLevel == 2)

	if arg0_208.touchLevel == 1 then
		setActive(arg0_208.uiContianer:Find("ik/btn_back"), true)
		setActive(arg0_208.uiContianer:Find("ik/btn_back_heartbeat"), false)
		quickPlayAnimation(arg0_208.rtTouchGamePanel, "anim_dorm3d_touch_change_out")
		quickPlayAnimation(arg0_208.rtTouchGamePanel:Find("slider/icon"), "anim_dorm3d_touch_icon")
	elseif arg0_208.touchLevel == 2 then
		setActive(arg0_208.uiContianer:Find("ik/btn_back"), false)
		setActive(arg0_208.uiContianer:Find("ik/btn_back_heartbeat"), true)
		quickPlayAnimation(arg0_208.rtTouchGamePanel, "anim_dorm3d_touch_change")
		quickPlayAnimation(arg0_208.rtTouchGamePanel:Find("slider/icon"), "anim_dorm3d_touch_icon_1")
		pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_heartbeat")
	end
end

function var0_0.UpdateTouchCount(arg0_209, arg1_209)
	if arg0_209.touchLevel > 1 then
		arg1_209 = math.min(0, arg1_209)
	end

	arg0_209.touchCount = math.clamp(arg0_209.touchCount + arg1_209, 0, 100)

	if arg0_209.sliderLT and LeanTween.isTweening(arg0_209.sliderLT) then
		LeanTween.cancel(arg0_209.sliderLT)

		arg0_209.sliderLT = nil
	end

	setSlider(arg0_209.rtTouchGamePanel:Find("slider"), 0, 100, arg0_209.touchCount)

	local var0_209

	if arg0_209.touchCount >= 100 then
		var0_209 = 2
	elseif arg0_209.touchCount <= 0 then
		var0_209 = 1
	end

	if var0_209 and var0_209 ~= arg0_209.touchLevel then
		if arg0_209.blockIK then
			return
		end

		arg0_209.touchLevel = var0_209

		local var1_209 = arg0_209.touchConfig.ik_status[var0_209]

		if var1_209 then
			if var0_209 > 1 then
				arg0_209.touchCount = 200
			elseif var0_209 == 1 then
				arg0_209.touchCount = 0
			end

			local var2_209 = arg0_209.ladyDict[arg0_209.apartment:GetConfigID()]

			seriesAsync({
				function(arg0_210)
					arg0_209:ShowBlackScreen(true, arg0_210)
				end,
				function(arg0_211)
					arg0_209:SwitchIKConfig(var2_209, var1_209)
					arg0_209:SetIKState(true, arg0_211)

					if var0_209 > 1 and arg0_209.touchConfig.heartbeat_enter_anim ~= "" then
						arg0_209:SwitchAnim(var2_209, arg0_209.touchConfig.heartbeat_enter_anim)
					end
				end,
				function(arg0_212)
					arg0_209:ShowBlackScreen(false, arg0_212)
				end
			})
		end

		arg0_209:UpdateTouchCount(0)
		arg0_209:UpdateTouchGameDisplay()
	end

	arg0_209.topCount = math.max(arg0_209.topCount, arg0_209.touchCount)
end

function var0_0.ExitHeartbeatMode(arg0_213)
	if not arg0_213.touchLevel or arg0_213.touchLevel == 1 then
		return
	end

	arg0_213.touchCount = 0

	arg0_213:UpdateTouchCount(0)
end

function var0_0.DoTouch(arg0_214, arg1_214, arg2_214)
	if arg0_214.inTouchGame then
		switch(arg2_214, {
			function()
				arg0_214:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat.key_value_int)
			end,
			function()
				arg0_214:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat.key_value_int)
			end,
			function()
				arg0_214:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat.key_value_int)
			end,
			function()
				arg0_214:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat_trriger.key_value_int)
			end
		})
	end
end

function var0_0.DoTalk(arg0_219, arg1_219, arg2_219)
	while rawget(arg0_219, "class") ~= var0_0 do
		arg0_219 = getmetatable(arg0_219).__index
	end

	if arg0_219.apartment and arg0_219:GetBlackboardValue(arg0_219.ladyDict[arg0_219.apartment:GetConfigID()], "inTalking") then
		errorMsg("Talking block:" .. arg1_219)

		return
	end

	if not arg0_219.room:isPersonalRoom() then
		local var0_219 = pg.dorm3d_dialogue_group[arg1_219].char_id

		if arg0_219.apartment then
			assert(arg0_219.apartment:GetConfigID() == var0_219)
		else
			arg0_219:SetApartment(getProxy(ApartmentProxy):getApartment(var0_219))
		end
	end

	local var1_219 = arg0_219.ladyDict[arg0_219.apartment:GetConfigID()]

	if arg1_219 == 10010 and not arg0_219.apartment.talkDic[arg1_219] then
		arg0_219.firstTimelineTouch = true
		arg0_219.firstMoveGuide = true
	end

	getProxy(Dorm3dChatProxy):TriggerEvent({
		{
			value = 1,
			event_type = arg0_219.contextData.timeIndex == 1 and 110 or 115,
			ship_id = arg0_219.apartment:GetConfigID()
		},
		{
			value = 1,
			event_type = 155,
			ship_id = arg0_219.apartment:GetConfigID()
		}
	})

	local var2_219 = {}

	if arg0_219:GetBlackboardValue(var1_219, "inPending") then
		table.insert(var2_219, function(arg0_220)
			arg0_219:OutOfLazy(arg0_219.apartment:GetConfigID(), arg0_220)
		end)
	end

	local var3_219 = pg.dorm3d_dialogue_group[arg1_219]
	local var4_219 = var3_219.performance_type == 1
	local var5_219

	table.insert(var2_219, function(arg0_221)
		arg0_219:emit(arg0_219.SHOW_BLOCK)
		arg0_219:SetBlackboardValue(var1_219, var4_219 and "inPerformance" or "inTalking", true)
		arg0_219:emit(Dorm3dRoomMediator.DO_TALK, arg1_219, function(arg0_222)
			var5_219 = arg0_222

			arg0_221()
		end)
	end)
	table.insert(var2_219, function(arg0_223)
		pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataDialog(arg0_219.apartment.configId, arg0_219.apartment.level, arg1_219, var3_219.type, arg0_219.room:getZoneConfig(arg0_219.ladyDict[arg0_219.apartment:GetConfigID()].ladyBaseZone, "id"), var3_219.action_type, table.CastToString(var3_219.trigger_config), arg0_219.room:GetConfigID()))

		if pg.NewGuideMgr.GetInstance():IsBusy() then
			pg.NewGuideMgr.GetInstance():Pause()
		end

		arg0_219:SetUI(arg0_223, "blank")
	end)

	if var3_219.trigger_area and var3_219.trigger_area ~= "" then
		table.insert(var2_219, function(arg0_224)
			arg0_219:ShiftZone(var3_219.trigger_area, arg0_224)
		end)
	end

	if var3_219.performance_type == 0 then
		table.insert(var2_219, function(arg0_225)
			arg0_219:emit(arg0_219.HIDE_BLOCK)

			if arg0_219.contextData.isVideoTalk then
				arg0_219.videoPlayer:ExecuteAction("Play", var3_219.story, function()
					onDelayTick(arg0_225, 0.001)
				end)
			else
				pg.NewStoryMgr.GetInstance():ForceManualPlay(var3_219.story, function()
					onDelayTick(arg0_225, 0.001)
				end, true)
			end
		end)
	elseif var3_219.performance_type == 1 then
		table.insert(var2_219, function(arg0_228)
			arg0_219:emit(arg0_219.HIDE_BLOCK)
			arg0_219:PerformanceQueue(var3_219.story, arg0_228)
		end)
	else
		assert(false)
	end

	table.insert(var2_219, function(arg0_229)
		arg0_219:emit(arg0_219.SHOW_BLOCK)
		arg0_229()
	end)
	table.insert(var2_219, function(arg0_230)
		local var0_230 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(var3_219.story)

		if var0_230 then
			local var1_230 = "1"

			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataStory(var0_230, var1_230))
		end

		if var5_219 and #var5_219 > 0 then
			arg0_219:emit(Dorm3dRoomMediator.OPEN_DROP_LAYER, var5_219, arg0_230)
		else
			arg0_230()
		end
	end)
	table.insert(var2_219, function(arg0_231)
		if pg.NewGuideMgr.GetInstance():IsPause() then
			pg.NewGuideMgr.GetInstance():Resume()
		end

		arg0_219:emit(arg0_219.HIDE_BLOCK)

		if arg0_219.contextData.isVideoTalk then
			existCall(arg0_231)
		else
			arg0_219:SetBlackboardValue(var1_219, var4_219 and "inPerformance" or "inTalking", false)
			arg0_219:SetUI(arg0_231, "back")
		end
	end)
	seriesAsync(var2_219, function()
		if arg2_219 then
			return arg2_219()
		else
			arg0_219:CheckQueue()
		end
	end)
end

function var0_0.DoTalkTouchOption(arg0_233, arg1_233, arg2_233, arg3_233)
	local var0_233 = arg0_233.rtExtraScreen:Find("TalkTouchOption")
	local var1_233
	local var2_233 = var0_233:Find("content")

	UIItemList.StaticAlign(var2_233, var2_233:Find("clickTpl"), #arg1_233.options, function(arg0_234, arg1_234, arg2_234)
		arg1_234 = arg1_234 + 1

		if arg0_234 == UIItemList.EventUpdate then
			local var0_234 = arg1_233.options[arg1_234]

			setAnchoredPosition(arg2_234, NewPos(unpack(var0_234.pos)))
			onButton(arg0_233, arg2_234, function()
				var1_233(var0_234.flag)
			end, SFX_CONFIRM)
			setActive(arg2_234, not table.contains(arg2_233, var0_234.flag))
		end
	end)
	setActive(var0_233, true)

	function var1_233(arg0_236)
		setActive(var0_233, false)
		arg3_233(arg0_236)
	end
end

function var0_0.DoTimelineOption(arg0_237, arg1_237, arg2_237)
	local var0_237 = arg0_237.rtTimelineScreen:Find("TimelineOption")
	local var1_237
	local var2_237 = var0_237:Find("content")

	UIItemList.StaticAlign(var2_237, var2_237:Find("clickTpl"), #arg1_237, function(arg0_238, arg1_238, arg2_238)
		arg1_238 = arg1_238 + 1

		if arg0_238 == UIItemList.EventUpdate then
			local var0_238 = arg1_237[arg1_238]

			setText(arg2_238:Find("Text"), HXSet.hxLan(var0_238.content))
			onButton(arg0_237, arg2_238, function()
				var1_237(arg1_238)
			end, SFX_CONFIRM)
		end
	end)
	setActive(var0_237, true)

	function var1_237(arg0_240)
		setActive(var0_237, false)
		arg2_237(arg0_240)
	end
end

function var0_0.DoTimelineTouch(arg0_241, arg1_241, arg2_241)
	local var0_241 = arg0_241.rtTimelineScreen:Find("TimelineTouch")
	local var1_241
	local var2_241 = var0_241:Find("content")

	UIItemList.StaticAlign(var2_241, var2_241:Find("clickTpl"), #arg1_241, function(arg0_242, arg1_242, arg2_242)
		arg1_242 = arg1_242 + 1

		if arg0_242 == UIItemList.EventUpdate then
			local var0_242 = arg1_241[arg1_242]

			setAnchoredPosition(arg2_242, NewPos(unpack(var0_242.pos)))
			onButton(arg0_241, arg2_242, function()
				var1_241(arg1_242)
			end, SFX_CONFIRM)

			if arg0_241.firstTimelineTouch then
				arg0_241.firstTimelineTouch = nil

				setActive(arg2_242:Find("finger"), true)
			end
		end
	end)
	setActive(var0_241, true)

	function var1_241(arg0_244)
		setActive(var0_241, false)
		arg2_241(arg0_244)
	end
end

function var0_0.DoShortWait(arg0_245, arg1_245)
	local var0_245 = arg0_245.ladyDict[arg1_245]
	local var1_245 = getProxy(ApartmentProxy):getApartment(arg1_245)
	local var2_245 = arg0_245.room:getApartmentZoneConfig(var0_245.ladyBaseZone, "special_action", arg1_245)
	local var3_245 = var2_245 and var2_245[math.random(#var2_245)] or nil

	if not var3_245 then
		return
	end

	arg0_245:PlaySingleAction(var0_245, var3_245)
end

function var0_0.OutOfLazy(arg0_246, arg1_246, arg2_246)
	local var0_246 = arg0_246.ladyDict[arg1_246]
	local var1_246 = {}

	if arg0_246:GetBlackboardValue(var0_246, "inPending") then
		table.insert(var1_246, function(arg0_247)
			arg0_246.shiftLady = arg1_246

			arg0_246:ShiftZone(var0_246.ladyBaseZone, arg0_247)
		end)
	end

	seriesAsync(var1_246, arg2_246)
end

function var0_0.OutOfPending(arg0_248, arg1_248, arg2_248)
	assert(arg0_248.wakeUpTalkId)

	local var0_248 = arg0_248.wakeUpTalkId

	seriesAsync({
		function(arg0_249)
			arg0_248:SetUI(arg0_249, "blank")
		end,
		function(arg0_250)
			arg0_248.shiftLady = arg1_248

			local var0_250 = arg0_248.ladyDict[arg1_248]

			arg0_248:ShiftZone(var0_250.ladyBaseZone, arg0_250)
		end,
		function(arg0_251)
			arg0_248:DoTalk(var0_248, arg0_251)
		end
	}, function()
		arg0_248:SetUIStore(arg2_248, "back")
	end)
end

function var0_0.ChangeCanWatchState(arg0_253, arg1_253)
	local var0_253

	if arg0_253:GetBlackboardValue(arg1_253, "inPending") then
		var0_253 = tobool(arg0_253:GetBlackboardValue(arg1_253, "inDistance"))
	else
		local var1_253 = arg0_253:GetBlackboardValue(arg1_253, "groupId")

		var0_253 = tobool(arg0_253.activeLady[var1_253] and pg.NodeCanvasMgr.GetInstance():GetBlackboradValue("canWatch", arg1_253.ladyBlackboard))
	end

	if (not arg1_253.nowCanWatchState or arg1_253.nowCanWatchState ~= var0_253) and arg1_253.ladyWatchFloat then
		arg1_253.nowCanWatchState = var0_253

		arg0_253:ShowOrHideCanWatchMark(arg1_253, arg1_253.nowCanWatchState)
	end
end

function var0_0.HandleGameNotification(arg0_254, arg1_254, arg2_254)
	local var0_254 = arg0_254.ladyDict[arg0_254.apartment:GetConfigID()]

	switch(arg1_254, {
		[Dorm3dMiniGameMediator.OPERATION] = function()
			local var0_255 = arg2_254.miniGameId

			switch(arg2_254.miniGameId, {
				[67] = function()
					if arg2_254.operationCode == "GAME_HIT_AREA" then
						local var0_256 = {
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
						local var1_256, var2_256 = unpack(var0_256[arg2_254.index])

						arg0_254:PlayFaceAnim(var0_254, var1_256)

						if arg0_254.tfCutIn then
							quickPlayAnimator(arg0_254.modelCutIn.lady, var2_256)
							quickPlayAnimator(arg0_254.modelCutIn.player, var2_256)
						end
					elseif arg2_254.operationCode == "GAME_RESULT" then
						if arg2_254.win then
							arg0_254:PlayFaceAnim(var0_254, "Face_XYX_victory")
							arg0_254:PlaySingleAction(var0_254, "minigame_win")
						else
							arg0_254:PlayFaceAnim(var0_254, "Face_XYX_lose")
							arg0_254:PlaySingleAction(var0_254, "minigame_lose")
						end

						setActive(arg0_254.rtExtraScreen:Find("MiniGameCutIn"), false)
					end
				end,
				[70] = function()
					if arg2_254.operationCode == "GAME_READY" then
						arg0_254.cameras[var0_0.CAMERA.TALK].Follow = nil
						arg0_254.cameras[var0_0.CAMERA.TALK].LookAt = nil

						arg0_254:PlaySingleAction(var0_254, "shuohua_sikao")
					elseif arg2_254.operationCode == "ROUND_RESULT" then
						local var0_257

						if arg2_254.success then
							var0_257 = {
								"shuohua_wenhou",
								"shuohua_sikao"
							}
						else
							var0_257 = {
								"shuohua_yaotou",
								"shuohua_sikao"
							}
						end

						seriesAsync(underscore.map(var0_257, function(arg0_258)
							return function(arg0_259)
								arg0_254:PlaySingleAction(var0_254, arg0_258, arg0_259)
							end
						end), function()
							return
						end)
					elseif arg2_254.operationCode == "GAME_RESULT" then
						local var1_257 = arg0_254.cameras[var0_0.CAMERA.TALK].transform

						var1_257.position = var1_257.position + var1_257.right * 0.11

						local var2_257 = {
							"shuohua_gandong"
						}

						seriesAsync(underscore.map(var2_257, function(arg0_261)
							return function(arg0_262)
								arg0_254:PlaySingleAction(var0_254, arg0_261, arg0_262)
							end
						end), function()
							return
						end)
					end
				end,
				[75] = function()
					if arg2_254.operationCode == "BEFORE_OPEN_GAME" then
						arg0_254.cameras[var0_0.CAMERA.TALK].Follow = nil
						arg0_254.cameras[var0_0.CAMERA.TALK].LookAt = nil
					elseif arg2_254.operationCode == "GAME_RPS_RESULT" then
						if arg2_254.index == 1 then
							arg0_254:PlaySingleAction(var0_254, "ab_shuohua_lianxuyaotou_01")
							arg0_254:PlayFaceAnim(var0_254, "Face_weixiao")
						elseif arg2_254.index == 2 then
							arg0_254:PlaySingleAction(var0_254, "ab_shuohua_lianxudiantou_01")
							arg0_254:PlayFaceAnim(var0_254, "Face_kaixin")
						end
					elseif arg2_254.operationCode == "GAME_RESULT" then
						if not arg2_254.win then
							arg0_254:PlaySingleAction(var0_254, "ab_shuohua_taibangle_01")
						end

						arg0_254:PlayFaceAnim(var0_254, "Face_kaixin")
					end
				end
			}, function()
				warning("without miniGameId:" .. arg2_254.miniGameId)
			end)

			if arg2_254.operationCode == "BEFORE_OPEN_GAME" then
				local var1_255 = getProxy(PlayerProxy):getPlayerId()
				local var2_255 = 0

				if var0_255 == 67 or var0_255 == 70 then
					var2_255 = PlayerPrefs.GetInt("mg_new_score_" .. tostring(var1_255) .. "_" .. arg2_254.miniGameId, 0)
				else
					var2_255 = PlayerPrefs.GetInt("mg_score_" .. tostring(var1_255) .. "_" .. arg2_254.miniGameId, 0)
				end

				arg0_254.highScore = var2_255
			elseif arg2_254.operationCode == "GAME_RESULT" then
				local var3_255 = arg2_254.score
				local var4_255 = getProxy(PlayerProxy):getPlayerId()

				if var3_255 > arg0_254.highScore then
					if var0_255 == 67 or var0_255 == 70 then
						PlayerPrefs.SetInt("mg_new_score_" .. tostring(var4_255) .. "_" .. arg2_254.miniGameId, var3_255)
					end

					getProxy(Dorm3dChatProxy):TriggerEvent({
						{
							event_type = 159,
							value = var3_255,
							ship_id = arg0_254.apartment:GetConfigID()
						}
					})
				end

				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataMiniGame(2, arg2_254.score))
			elseif arg2_254.operationCode == "GAME_CLOSE" and arg2_254.doTrack == false then
				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataMiniGame(3))
			end
		end
	})
end

function var0_0.PerformanceQueue(arg0_266, arg1_266, arg2_266)
	local var0_266, var1_266 = pcall(function()
		return require("GameCfg.dorm." .. arg1_266)
	end)

	if not var0_266 then
		errorMsg("不存在表演ID对应的Lua:" .. arg1_266)
		existCall(arg2_266)

		return
	end

	warning(arg1_266)

	arg0_266.performanceInfo = {
		name = arg1_266
	}

	local var2_266 = {}

	table.insert(var2_266, function(arg0_268)
		arg0_266:SetUI(arg0_268, "blank")
	end)
	table.insertto(var2_266, underscore.map(var1_266, function(arg0_269)
		return switch(arg0_269.type, {
			function()
				return function(arg0_271)
					local var0_271 = unpack(arg0_269.params)

					arg0_266:DoTalk(var0_271, arg0_271, true)
				end
			end,
			function()
				return function(arg0_273)
					arg0_266.touchExitCall = arg0_273

					arg0_266:EnterTouchMode()
				end
			end,
			function()
				return function(arg0_275)
					local var0_275 = arg0_266.ladyDict[arg0_266.apartment:GetConfigID()]

					arg0_266:PlaySingleAction(var0_275, arg0_269.name, arg0_275)
				end
			end,
			function()
				return function(arg0_277)
					arg0_266:emit(arg0_266.PLAY_EXPRESSION, arg0_269)
					arg0_277()
				end
			end,
			function()
				return function(arg0_279)
					arg0_266:ShiftZone(arg0_269.name, arg0_279)
				end
			end,
			function()
				return function(arg0_281)
					arg0_266.contextData.timeIndex = arg0_269.params[1]

					if arg0_266.dormSceneMgr.artSceneInfo == arg0_266.dormSceneMgr.sceneInfo then
						arg0_266:SwitchDayNight(arg0_266.contextData.timeIndex)
						onNextTick(function()
							arg0_266:RefreshSlots()
						end)
					end

					arg0_266:UpdateContactState()
					onNextTick(arg0_281)
				end
			end,
			function()
				return function(arg0_284)
					if arg0_269.name then
						arg0_266:ActiveCameraByName(arg0_269.name)
						existCall(arg0_284)
					else
						arg0_266:ActiveStateCamera(arg0_269.params[1], arg0_284)
					end
				end
			end,
			function()
				return function(arg0_286)
					if arg0_269.name == "base" then
						arg0_266:ChangeArtScene(arg0_266.dormSceneMgr.sceneInfo, arg0_286)
					else
						local var0_286 = arg0_269.params.scene
						local var1_286 = arg0_269.params.sceneRoot

						arg0_266:ChangeArtScene(var0_286 .. "|" .. var1_286, arg0_286)
					end
				end
			end,
			function()
				return function(arg0_288)
					local var0_288 = arg0_269.params.name

					if arg0_269.name == "load" then
						func = tobool(arg0_269.params.wait_timeline) and function(arg0_289)
							arg0_266.waitForTimeline = arg0_289
						end

						arg0_266:LoadTimelineScene(var0_288, true, func, arg0_288)
					elseif arg0_269.name == "unload" then
						arg0_266:UnloadTimelineScene(var0_288, true, arg0_288)
					else
						assert(false)
					end
				end
			end,
			function()
				return function(arg0_291)
					setActive(arg0_266.uiContianer:Find("walk/btn_back"), false)

					local var0_291 = arg0_266.ladyDict[arg0_266.apartment:GetConfigID()]

					if arg0_269.name == "change" then
						local var1_291 = arg0_269.params.scene
						local var2_291 = arg0_269.params.sceneRoot

						var0_291.walkBornPoint = arg0_269.params.point or "Default"

						arg0_266:ChangeWalkScene(arg0_269.name, var1_291 .. "|" .. var2_291, arg0_291)
					elseif arg0_269.name == "back" then
						var0_291.walkBornPoint = nil

						arg0_266:ChangeWalkScene(arg0_269.name, arg0_266.dormSceneMgr.sceneInfo, arg0_291)
					elseif arg0_269.name == "set" then
						local function var3_291()
							local var0_292 = arg0_291

							arg0_291 = nil

							return existCall(var0_292)
						end

						for iter0_291, iter1_291 in pairs(arg0_269.params) do
							switch(iter0_291, {
								back_button_trigger = function(arg0_293)
									onButton(arg0_266, arg0_266.uiContianer:Find("walk/btn_back"), var3_291, SFX_DORM_BACK)
									setActive(arg0_266.uiContianer:Find("walk/btn_back"), IsUnityEditor and arg0_293)
								end,
								near_trigger = function(arg0_294)
									if arg0_294 == true then
										arg0_294 = 1.5
									end

									if arg0_294 then
										function arg0_266.walkNearCallback(arg0_295)
											if arg0_295 < arg0_294 then
												arg0_266.walkNearCallback = nil

												var3_291()
											end
										end
									else
										arg0_266.walkNearCallback = nil
									end
								end
							}, nil, iter1_291)
						end

						if arg0_266.firstMoveGuide then
							setActive(arg0_266.povLayer:Find("Guide"), arg0_266.firstMoveGuide)

							arg0_266.firstMoveGuide = nil
						end
					else
						assert(false)
					end
				end
			end,
			function()
				return function(arg0_297)
					if arg0_269.name == "set" then
						local var0_297 = arg0_266.ladyDict[arg0_266.apartment:GetConfigID()]

						arg0_266:SwitchIKConfig(var0_297, arg0_269.params.state)
						setActive(arg0_266.uiContianer:Find("ik/btn_back"), not arg0_269.params.hide_back)

						arg0_266.ikSpecialCall = arg0_297

						arg0_266:SetIKState(true)
					elseif arg0_269.name == "back" then
						local var1_297 = arg0_266.ladyDict[arg0_266.apartment:GetConfigID()]

						var1_297.ikConfig = arg0_269.params

						arg0_266:SetIKState(false, function()
							var1_297.ikConfig = nil

							existCall(arg0_297)
						end)
					else
						assert(false)
					end
				end
			end,
			function()
				return function(arg0_300)
					arg0_266.blackSceneInfo = setmetatable(arg0_269.params or {}, {
						__index = {
							color = "#000000",
							time = 0.3,
							delay = arg0_269.name == "show" and 0 or 0.5
						}
					})

					if arg0_269.name == "show" then
						arg0_266:ShowBlackScreen(true, arg0_300)
					elseif arg0_269.name == "hide" then
						arg0_266:ShowBlackScreen(false, arg0_300)
					else
						assert(false)
					end

					arg0_266.blackSceneInfo = nil
				end
			end
		})
	end))
	table.insert(var2_266, function(arg0_301)
		arg0_266:SetUI(arg0_301, "back")

		arg0_266.performanceInfo = nil
	end)
	seriesAsync(var2_266, arg2_266)
end

function var0_0.TriggerContact(arg0_302, arg1_302)
	arg0_302:emit(Dorm3dRoomMediator.COLLECTION_ITEM, {
		itemId = arg1_302,
		roomId = arg0_302.room:GetConfigID(),
		groupId = arg0_302.room:isPersonalRoom() and arg0_302.apartment:GetConfigID() or 0
	})
end

function var0_0.UpdateContactState(arg0_303)
	arg0_303:SetContactStateDic(arg0_303.room:getTriggerableCollectItemDic(arg0_303.contextData.timeIndex))
end

function var0_0.UpdateFavorDisplay(arg0_304)
	local var0_304, var1_304 = getProxy(ApartmentProxy):getStamina()

	setText(arg0_304.rtStaminaDisplay:Find("Text"), string.format("%d/%d", var0_304, var1_304))
	setActive(arg0_304.rtStaminaDisplay, false)

	if arg0_304.apartment then
		setText(arg0_304.rtFavorLevel:Find("rank/Text"), arg0_304.apartment.level)

		local var2_304, var3_304 = arg0_304.apartment:getFavor()
		local var4_304 = arg0_304.apartment:isMaxFavor()

		setActive(arg0_304.rtFavorLevel:Find("Max"), var4_304)
		setActive(arg0_304.rtFavorLevel:Find("Text"), not var4_304)
		setText(arg0_304.rtFavorLevel:Find("Text"), string.format("<color=#ff6698>%d</color>/%d", var2_304, var3_304))
	end

	setActive(arg0_304.rtFavorLevel:Find("red"), Dorm3dLevelLayer.IsShowRed())
end

function var0_0.UpdateBtnState(arg0_305)
	local var0_305 = not arg0_305.room:isPersonalRoom() or arg0_305:CheckSystemOpen("Furniture")
	local var1_305 = Dorm3dFurniture.IsTimelimitShopTip(arg0_305.room:GetConfigID())

	setActive(arg0_305.uiContianer:Find("base/left/btn_furniture/tipTimelimit"), var0_305 and var1_305)

	local var2_305 = Dorm3dFurniture.NeedViewTip(arg0_305.room:GetConfigID())

	setActive(arg0_305.uiContianer:Find("base/left/btn_furniture/tip"), var0_305 and not var1_305 and var2_305)
	setActive(arg0_305.uiContianer:Find("base/btn_back/main"), underscore(getProxy(ApartmentProxy):getRawData()):chain():values():filter(function(arg0_306)
		return tobool(arg0_306)
	end):any(function(arg0_307)
		return #arg0_307:getSpecialTalking() > 0 or arg0_307:getIconTip() == "main"
	end):value())
	setActive(arg0_305.uiContianer:Find("base/left/btn_collection/tip"), PlayerPrefs.GetInt("apartment_collection_item", 0) > 0 or PlayerPrefs.GetInt("apartment_collection_recall", 0) > 0)
end

function var0_0.AddUnlockDisplay(arg0_308, arg1_308)
	table.insert(arg0_308.unlockList, arg1_308)

	if not isActive(arg0_308.rtFavorUp) then
		setText(arg0_308.rtFavorUp:Find("Text"), table.remove(arg0_308.unlockList, 1))
		setActive(arg0_308.rtFavorUp, true)
	end
end

function var0_0.PopFavorTrigger(arg0_309, arg1_309)
	local var0_309 = arg1_309.triggerId
	local var1_309 = arg1_309.delta
	local var2_309 = arg1_309.cost
	local var3_309 = arg1_309.apartment
	local var4_309 = pg.dorm3d_favor_trigger[var0_309]

	if var4_309.is_repeat == 0 then
		if var0_309 == getDorm3dGameset("drom3d_favir_trigger_onwer")[1] then
			arg0_309:AddUnlockDisplay(i18n("dorm3d_own_favor"))
		elseif var0_309 == getDorm3dGameset("drom3d_favir_trigger_propose")[1] then
			arg0_309:AddUnlockDisplay(i18n("dorm3d_pledge_favor"))
		else
			arg0_309:AddUnlockDisplay(string.format("unknow favor trigger:%d unlock", var0_309))
		end
	elseif arg1_309.delta > 0 then
		local var5_309, var6_309 = var3_309:getFavor()
		local var7_309 = var5_309 + var1_309

		setText(arg0_309.rtFavorUpDaily:Find("bg/Text"), string.format("<size=48>+%d</size>", math.min(9999, var1_309)))
		setSlider(arg0_309.rtFavorUpDaily:Find("bg/slider"), 0, var6_309, var5_309)
		setAnchoredPosition(arg0_309.rtFavorUpDaily:Find("bg"), arg1_309.isGift and NewPos(-354, 223) or NewPos(-208, 105))

		local var8_309 = {}
		local var9_309 = arg0_309.rtFavorUpDaily:Find("bg/effect")

		eachChild(var9_309, function(arg0_310)
			setActive(arg0_310, false)
		end)

		local var10_309

		if var4_309.effect and var4_309.effect ~= "" then
			var10_309 = var9_309:Find(var4_309.effect .. "(Clone)")

			if not var10_309 then
				table.insert(var8_309, function(arg0_311)
					LoadAndInstantiateAsync("Dorm3D/Effect/Prefab/ExpressionUI", "uifx_dorm3d_yinfu01", function(arg0_312)
						setParent(arg0_312, var9_309)

						var10_309 = tf(arg0_312)

						arg0_311()
					end)
				end)
			else
				setActive(var10_309, true)
			end
		end

		local var11_309 = arg0_309.rtFavorUpDaily:GetComponent("DftAniEvent")

		var11_309:SetTriggerEvent(function(arg0_313)
			local var0_313 = GetComponent(arg0_309.rtFavorUpDaily:Find("bg/slider"), typeof(Slider))

			LeanTween.value(var5_309, var7_309, 0.5):setOnUpdate(System.Action_float(function(arg0_314)
				var0_313.value = arg0_314
			end)):setEase(LeanTweenType.easeInOutQuad):setDelay(0.165):setOnComplete(System.Action(function()
				LeanTween.delayedCall(0.165, System.Action(function()
					if arg0_309.exited then
						return
					end

					quickPlayAnimator(arg0_309.rtFavorUpDaily, "favor_out")
				end))
			end))
			pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_progaress_bar")
		end)
		var11_309:SetEndEvent(function(arg0_317)
			setActive(arg0_309.rtFavorUpDaily, false)
		end)
		seriesAsync(var8_309, function()
			local var0_318 = arg0_309.ladyDict[var3_309:GetConfigID()]

			setLocalPosition(arg0_309.rtFavorUpDaily, arg0_309:GetLocalPosition(arg0_309:GetScreenPosition(var0_318.ladyHeadCenter.position), arg0_309.rtFavorUpDaily.parent))
			setActive(arg0_309.rtFavorUpDaily, true)
			SetCompomentEnabled(arg0_309.rtFavorUpDaily, typeof(Animator), true)
			quickPlayAnimator(arg0_309.rtFavorUpDaily, "favor_open")

			if var2_309 > 0 then
				local var1_318, var2_318 = getProxy(ApartmentProxy):getStamina()

				setText(arg0_309.rtStaminaPop:Find("Text/Text (1)"), "-" .. var2_309)
				setText(arg0_309.rtStaminaPop:Find("Text"), string.format("%d/%d", var1_318 + var2_309, var2_318))
				setActive(arg0_309.rtStaminaPop, true)
			end
		end)
	end
end

function var0_0.PopFavorLevelUp(arg0_319, arg1_319, arg2_319, arg3_319)
	arg0_319.isLock = true

	LeanTween.delayedCall(0.33, System.Action(function()
		arg0_319.isLock = false
	end))

	local var0_319 = math.floor(arg1_319.level / 10)
	local var1_319 = math.fmod(arg1_319.level, 10)

	GetImageSpriteFromAtlasAsync("ui/favor_atlas", var1_319, arg0_319.rtLevelUpWindow:Find("panel/bg/item1/mark/level/digit2"))
	GetImageSpriteFromAtlasAsync("ui/favor_atlas", var0_319, arg0_319.rtLevelUpWindow:Find("panel/bg/item1/mark/level/digit1"))
	setActive(arg0_319.rtLevelUpWindow:Find("panel/bg/item1/mark/level/digit1"), var0_319 > 0)

	local var2_319
	local var3_319

	arg0_319.clientAward, var3_319 = Dorm3dIconHelper.SplitStory(arg1_319:getFavorConfig("levelup_client_item", arg1_319.level))
	arg0_319.serverAward = arg2_319

	local var4_319 = arg0_319.rtLevelUpWindow:Find("panel/info/content/itemContent")

	if not arg0_319.levelItemList then
		arg0_319.levelItemList = UIItemList.New(var4_319, var4_319:Find("tpl"))

		arg0_319.levelItemList:make(function(arg0_321, arg1_321, arg2_321)
			local var0_321 = arg1_321 + 1

			if arg0_321 == UIItemList.EventUpdate then
				if arg1_321 < #arg0_319.serverAward then
					updateDorm3dIcon(arg2_321, arg0_319.serverAward[var0_321])
					onButton(arg0_319, arg2_321, function()
						arg0_319:emit(BaseUI.ON_NEW_DROP, {
							drop = arg0_319.serverAward[var0_321]
						})
					end, SFX_PANEL)
				else
					Dorm3dIconHelper.UpdateDorm3dIcon(arg2_321, arg0_319.clientAward[var0_321 - #arg0_319.serverAward])
					onButton(arg0_319, arg2_321, function()
						arg0_319:emit(Dorm3dRoomMediator.ON_DROP_CLIENT, {
							data = arg0_319.clientAward[var0_321 - #arg0_319.serverAward]
						})
					end, SFX_PANEL)
				end
			end
		end)
	end

	arg0_319.levelItemList:align(#arg0_319.serverAward + #arg0_319.clientAward)
	setActive(arg0_319.rtLevelUpWindow, true)
	pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_upgrade")
	pg.UIMgr.GetInstance():OverlayPanel(arg0_319.rtLevelUpWindow, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_DORM3D
	})

	function arg0_319.levelUpCallback()
		arg0_319.levelUpCallback = nil

		if var3_319 then
			arg0_319:PopNewStoryTip(var3_319)
		end

		existCall(arg3_319)
	end
end

function var0_0.PopNewStoryTip(arg0_325, arg1_325, arg2_325)
	local var0_325 = arg0_325.uiContianer:Find("base/top/story_tip")

	setActive(var0_325, true)
	LeanTween.delayedCall(1, System.Action(function()
		setActive(var0_325, false)
	end))
	setText(var0_325:Find("Text"), i18n("dorm3d_story_unlock_tip", pg.dorm3d_recall[arg1_325[2]].name))
	existCall(arg2_325)
end

function var0_0.UpdateZoneList(arg0_327)
	local var0_327

	if arg0_327.room:isPersonalRoom() then
		var0_327 = arg0_327.ladyDict[arg0_327.apartment:GetConfigID()].ladyBaseZone
	else
		var0_327 = arg0_327:GetAttachedFurnitureName()
	end

	for iter0_327, iter1_327 in ipairs(arg0_327.zoneDatas) do
		if iter1_327:GetWatchCameraName() == var0_327 then
			setText(arg0_327.btnZone:Find("Text"), iter1_327:GetName())
			setTextColor(arg0_327.rtZoneList:GetChild(iter0_327 - 1):Find("Name"), Color.NewHex("5CCAFF"))
		else
			setTextColor(arg0_327.rtZoneList:GetChild(iter0_327 - 1):Find("Name"), Color.NewHex("FFFFFF99"))
		end
	end
end

function var0_0.TalkingEventHandle(arg0_328, arg1_328)
	local var0_328 = {}
	local var1_328 = {}
	local var2_328 = arg1_328.data

	if var2_328.op_list then
		for iter0_328, iter1_328 in ipairs(var2_328.op_list) do
			table.insert(var0_328, function(arg0_329)
				local function var0_329()
					local var0_330 = arg0_329

					arg0_329 = nil

					return existCall(var0_330)
				end

				switch(iter1_328.type, {
					action = function()
						local var0_331 = arg0_328.ladyDict[arg0_328.apartment:GetConfigID()]

						arg0_328:PlaySingleAction(var0_331, iter1_328.name, var0_329)
					end,
					item_action = function()
						arg0_328:PlaySceneItemAnim(iter1_328.id, iter1_328.name)
						var0_329()
					end,
					extra_item_action = function()
						local var0_333 = arg0_328.ladyDict[arg0_328.apartment:GetConfigID()].extraItems[iter1_328.name]

						warning(iter1_328.name)
						warning(var0_333.trans)

						if var0_333 then
							var0_333.trans:GetComponent(typeof(Animator)):PlayInFixedTime(iter1_328.param)
						end

						var0_329()
					end,
					timeline = function()
						if arg0_328.inTouchGame then
							setActive(arg0_328.rtTouchGamePanel, false)
						end

						arg0_328:PlayTimeline(iter1_328, function(arg0_335, arg1_335)
							setActive(arg0_328.rtTouchGamePanel, arg0_328.inTouchGame)

							var1_328.notifiCallback = arg1_335

							var0_329()
						end)
					end,
					clickOption = function()
						arg0_328:DoTalkTouchOption(iter1_328, arg1_328.flags, function(arg0_337)
							var1_328.optionIndex = arg0_337

							var0_329()
						end)
					end,
					wait = function()
						arg0_328.LTs = arg0_328.LTs or {}

						table.insert(arg0_328.LTs, LeanTween.delayedCall(iter1_328.time, System.Action(var0_329)).uniqueId)
					end,
					expression = function()
						arg0_328:emit(arg0_328.PLAY_EXPRESSION, iter1_328)
						var0_329()
					end
				}, function()
					assert(false, "op type error:", iter1_328.type)
				end)

				if iter1_328.skip then
					var0_329()
				end
			end)
		end
	end

	seriesAsync(var0_328, function()
		if arg1_328.callbackData then
			arg0_328:emit(Dorm3dRoomMediator.TALKING_EVENT_FINISH, arg1_328.callbackData.name, var1_328)
		end
	end)
end

function var0_0.CheckQueue(arg0_342)
	if arg0_342.inGuide or arg0_342.uiState ~= "base" then
		return
	end

	if arg0_342.room:GetConfigID() == 1 and arg0_342:CheckGuide() then
		-- block empty
	elseif arg0_342.room:isPersonalRoom() and arg0_342:CheckLevelUp() then
		-- block empty
	elseif arg0_342.apartment and arg0_342:CheckEnterDeal() then
		-- block empty
	elseif arg0_342.apartment and arg0_342:CheckActiveTalk() then
		-- block empty
	elseif arg0_342.apartment then
		arg0_342:CheckFavorTrigger()
	end

	arg0_342.contextData.hasEnterCheck = true
end

function var0_0.didEnterCheck(arg0_343)
	local var0_343

	if arg0_343.contextData.specialId then
		var0_343 = arg0_343.contextData.specialId
		arg0_343.contextData.specialId = nil

		arg0_343:DoTalk(var0_343, function()
			arg0_343:closeView()
		end)
	elseif not arg0_343.contextData.hasEnterCheck and arg0_343.apartment then
		for iter0_343, iter1_343 in ipairs(arg0_343.apartment:getForceEnterTalking(arg0_343.room:GetConfigID())) do
			var0_343 = iter1_343

			arg0_343:DoTalk(iter1_343)

			break
		end
	end

	if var0_343 and pg.dorm3d_dialogue_group[var0_343].extend_loading > 0 then
		arg0_343.contextData.hasEnterCheck = true

		pg.SceneAnimMgr.GetInstance():RegisterDormNextCall(function()
			arg0_343:FinishEnterResume()
		end)
	else
		if arg0_343.apartment and arg0_343.contextData.pendingDic[arg0_343.apartment:GetConfigID()] then
			arg0_343.contextData.hasEnterCheck = true
		end

		for iter2_343, iter3_343 in pairs(arg0_343.contextData.pendingDic) do
			arg0_343:SetInPending(arg0_343.ladyDict[iter2_343], iter3_343)
		end

		arg0_343.contextData.pendingDic = {}

		arg0_343:FinishEnterResume()
		arg0_343:CheckQueue()
	end
end

function var0_0.CheckGuide(arg0_346)
	if arg0_346:GetBlackboardValue(arg0_346.ladyDict[arg0_346.apartment:GetConfigID()], "inPending") then
		return
	end

	for iter0_346, iter1_346 in ipairs({
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
				return arg0_346:CheckSystemOpen("Furniture")
			end
		},
		{
			name = "DORM3D_GUIDE_07",
			active = function()
				return arg0_346:CheckSystemOpen("DayNight")
			end
		}
	}) do
		if not pg.NewStoryMgr.GetInstance():IsPlayed(iter1_346.name) and iter1_346.active() then
			arg0_346:SetAllBlackbloardValue("inGuide", true)

			local function var0_346()
				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(2, pg.NewStoryMgr.GetInstance():StoryName2StoryId(iter1_346.name)))
				arg0_346:SetAllBlackbloardValue("inGuide", false)
			end

			pg.m02:sendNotification(GAME.STORY_UPDATE, {
				storyId = iter1_346.name
			})
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(1, pg.NewStoryMgr.GetInstance():StoryName2StoryId(iter1_346.name)))
			pg.NewGuideMgr.GetInstance():Play(iter1_346.name, nil, var0_346, var0_346)

			return true
		end
	end

	return false
end

function var0_0.CheckFavorTrigger(arg0_352)
	for iter0_352, iter1_352 in ipairs({
		{
			triggerId = getDorm3dGameset("drom3d_favir_trigger_onwer")[1],
			active = function()
				local var0_353 = getProxy(CollectionProxy):getShipGroup(arg0_352.apartment.configId)

				return tobool(var0_353)
			end
		},
		{
			triggerId = getDorm3dGameset("drom3d_favir_trigger_propose")[1],
			active = function()
				local var0_354 = getProxy(CollectionProxy):getShipGroup(arg0_352.apartment.configId)

				return var0_354 and var0_354.married > 0
			end
		}
	}) do
		if arg0_352.apartment.triggerCountDic[iter1_352.triggerId] == 0 and iter1_352.active() then
			arg0_352:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_352.apartment.configId, iter1_352.triggerId)
		end
	end
end

function var0_0.CheckEnterDeal(arg0_355)
	if arg0_355.contextData.hasEnterCheck then
		return false
	end

	local var0_355 = arg0_355.apartment:GetConfigID()
	local var1_355 = "dorm3d_enter_count_" .. var0_355
	local var2_355 = pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d")

	if PlayerPrefs.GetString("dorm3d_enter_count_day") ~= var2_355 then
		PlayerPrefs.SetString("dorm3d_enter_count_day", var2_355)
		PlayerPrefs.SetInt(var1_355, 1)
	else
		PlayerPrefs.SetInt(var1_355, PlayerPrefs.GetInt(var1_355, 0) + 1)
	end

	local var3_355 = arg0_355.apartment:getEnterTalking(arg0_355.room:GetConfigID())

	PlayerPrefs.SetString("DORM3D_DAILY_ENTER", pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d"))

	if #var3_355 > 0 then
		arg0_355:DoTalk(var3_355[math.random(#var3_355)])

		return true
	end
end

function var0_0.CheckActiveTalk(arg0_356)
	local var0_356 = arg0_356.ladyDict[arg0_356.apartment:GetConfigID()]

	if arg0_356:GetBlackboardValue(var0_356, "inPending") then
		return false
	end

	local var1_356 = arg0_356.apartment:getZoneTalking(arg0_356.room:GetConfigID(), var0_356.ladyBaseZone)

	if #var1_356 > 0 then
		arg0_356:DoTalk(var1_356[1])

		return true
	else
		return false
	end
end

function var0_0.CheckDistanceTalk(arg0_357, arg1_357, arg2_357)
	local var0_357 = arg0_357.ladyDict[arg1_357].ladyBaseZone
	local var1_357 = getProxy(ApartmentProxy):getApartment(arg1_357)

	for iter0_357, iter1_357 in ipairs(var1_357:getDistanceTalking(arg0_357.room:GetConfigID(), var0_357)) do
		arg0_357:DoTalk(iter1_357)

		return
	end
end

function var0_0.CheckSystemOpen(arg0_358, arg1_358)
	if arg0_358.room:isPersonalRoom() then
		return switch(arg1_358, {
			Talk = function()
				local var0_359 = 1

				return var0_359 <= arg0_358.apartment.level, i18n("apartment_level_unenough", var0_359)
			end,
			Touch = function()
				local var0_360 = getDorm3dGameset("drom3d_touch_dialogue")[1]

				return var0_360 <= arg0_358.apartment.level, i18n("apartment_level_unenough", var0_360)
			end,
			Gift = function()
				local var0_361 = getDorm3dGameset("drom3d_gift_dialogue")[1]

				return var0_361 <= arg0_358.apartment.level, i18n("apartment_level_unenough", var0_361)
			end,
			PublicGame = function()
				return false
			end,
			Photo = function()
				local var0_363 = getDorm3dGameset("drom3d_photograph_unlock")[1]

				return var0_363 <= arg0_358.apartment.level, i18n("apartment_level_unenough", var0_363)
			end,
			Collection = function()
				local var0_364 = getDorm3dGameset("drom3d_recall_unlock")[1]

				return var0_364 <= arg0_358.apartment.level, i18n("apartment_level_unenough", var0_364)
			end,
			Furniture = function()
				local var0_365 = getDorm3dGameset("drom3d_furniture_unlock")[1]

				return var0_365 <= arg0_358.apartment.level, i18n("apartment_level_unenough", var0_365)
			end,
			DayNight = function()
				local var0_366 = getDorm3dGameset("drom3d_time_unlock")[1]

				return var0_366 <= arg0_358.apartment.level, i18n("apartment_level_unenough", var0_366)
			end,
			Accompany = function()
				local var0_367 = 1

				return var0_367 <= arg0_358.apartment.level, i18n("apartment_level_unenough", var0_367)
			end,
			MiniGame = function()
				local var0_368 = 1

				if var0_368 > arg0_358.apartment.level then
					return false, i18n("apartment_level_unenough", var0_368)
				elseif #arg0_358.room:getMiniGames() <= 0 then
					return false, "without minigame config in room:" .. arg0_358.room.configId
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
		return switch(arg1_358, {
			Gift = function()
				return false
			end,
			PublicGame = function()
				return true
			end,
			Furniture = function()
				local var0_374 = arg0_358.room:GetFurnitureIDList()

				return var0_374 and #var0_374 > 0
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

function var0_0.CheckLevelUp(arg0_380)
	if arg0_380.apartment:canLevelUp() then
		arg0_380:emit(Dorm3dRoomMediator.FAVOR_LEVEL_UP, arg0_380.apartment.configId)

		return true
	end

	return false
end

function var0_0.GetIKHandTF(arg0_381)
	return arg0_381.ikHand
end

function var0_0.CycleIKCameraGroup(arg0_382)
	local var0_382 = arg0_382.ladyDict[arg0_382.apartment:GetConfigID()]

	assert(arg0_382:GetBlackboardValue(var0_382, "inIK"))
	seriesAsync({
		function(arg0_383)
			pg.IKMgr.GetInstance():ResetActiveIKs()

			local var0_383 = var0_382.ikConfig
			local var1_383 = var0_383.camera_group
			local var2_383 = pg.dorm3d_ik_status.get_id_list_by_camera_group[var1_383]
			local var3_383 = var2_383[table.indexof(var2_383, var0_383.id) % #var2_383 + 1]

			arg0_382:SwitchIKConfig(var0_382, var3_383)
			arg0_382:SetIKState(true)
		end
	})
end

function var0_0.TempHideUI(arg0_384, arg1_384, arg2_384)
	local var0_384 = defaultValue(arg0_384.hideCount, 0)

	arg0_384.hideCount = var0_384 + (arg1_384 and 1 or -1)

	assert(arg0_384.hideCount >= 0)

	if arg0_384.hideCount * var0_384 > 0 then
		return existCall(arg2_384)
	elseif arg0_384.hideCount > 0 then
		arg0_384:SetUI(arg2_384, "blank")
	else
		arg0_384:SetUI(arg2_384, "back")
	end
end

function var0_0.onBackPressed(arg0_385)
	if arg0_385.exited or arg0_385.retainCount > 0 then
		-- block empty
	elseif isActive(arg0_385.rtLevelUpWindow) then
		triggerButton(arg0_385.rtLevelUpWindow:Find("bg"))
	elseif arg0_385.uiState ~= "base" then
		-- block empty
	else
		arg0_385:closeView()
	end
end

function var0_0.willExit(arg0_386)
	if arg0_386.downTimer then
		arg0_386.downTimer:Stop()

		arg0_386.downTimer = nil
	end

	if arg0_386.LTs then
		underscore.map(arg0_386.LTs, function(arg0_387)
			LeanTween.cancel(arg0_387)
		end)

		arg0_386.LTs = nil
	end

	if arg0_386.sliderLT then
		LeanTween.cancel(arg0_386.sliderLT)

		arg0_386.sliderLT = nil
	end

	for iter0_386, iter1_386 in pairs(arg0_386.ladyDict) do
		iter1_386.wakeUpTalkId = nil
	end

	if arg0_386.accompanyFavorTimer then
		arg0_386.accompanyFavorTimer:Stop()

		arg0_386.accompanyFavorTimer = nil
	end

	if arg0_386.accompanyPerformanceTimer then
		arg0_386.accompanyPerformanceTimer:Stop()

		arg0_386.accompanyPerformanceTimer = nil
	end

	arg0_386.canTriggerAccompanyPerformance = nil

	arg0_386.videoPlayer:Destroy()
	var0_0.super.willExit(arg0_386)
end

return var0_0
