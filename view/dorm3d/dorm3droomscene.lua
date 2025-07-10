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

			local var0_22 = {}

			if arg0_4.room:isPersonalRoom() and not arg0_4:GetBlackboardValue(arg0_4.ladyDict[arg0_4.apartment:GetConfigID()], "inPending") then
				table.insert(var0_22, function(arg0_23)
					arg0_4:OutOfLazy(arg0_4.apartment:GetConfigID(), arg0_23)
				end)
			end

			table.insert(var0_22, function(arg0_24)
				arg0_4:ShiftZone(var1_21, arg0_24)
			end)
			seriesAsync(var0_22, function()
				arg0_4:CheckQueue()
			end)
		end, SFX_PANEL)
	end)

	local var2_4 = arg0_4.uiContianer:Find("walk")
	local var3_4 = arg0_4.uiContianer:Find("ik")

	onButton(arg0_4, var3_4:Find("btn_back"), function()
		if arg0_4.ikSpecialCall then
			local var0_26 = arg0_4.ikSpecialCall

			arg0_4.ikSpecialCall = nil

			existCall(var0_26)
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
		arg0_4:emit(Dorm3dRoomMediator.OPEN_SKIN_SELECT_LAYER, arg0_4.apartment:GetConfigID(), arg0_4.ladyDict[arg0_4.apartment:GetConfigID()], function(arg0_33, arg1_33, arg2_33)
			seriesAsync({
				function(arg0_34)
					arg0_4:SetIKState(false, arg0_34)
				end,
				function(arg0_35)
					arg0_33:SwitchCharacterSkin(arg1_33, arg2_33)
					arg0_4:SwitchIKConfig(arg0_33, arg0_33.ikConfig.id)
					arg0_4:SetIKState(true, arg0_35)
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
	eachChild(arg0_4.ikHand, function(arg0_37)
		setActive(arg0_37, false)
	end)

	arg0_4.ikTextTipsRoot = var4_4:Find("TextTips")

	setActive(arg0_4.ikTextTipsRoot, false)
	eachChild(arg0_4.ikTextTipsRoot, function(arg0_38)
		setActive(arg0_38, false)
	end)

	arg0_4.ikControlUI = var4_4

	local var5_4 = arg0_4.uiContianer:Find("accompany")

	onButton(arg0_4, var5_4:Find("btn_back"), function()
		arg0_4:ExitAccompanyMode()
	end, SFX_DORM_BACK)

	arg0_4.unlockList = {}
	arg0_4.rtFavorUp = arg0_4._tf:Find("Toast/favor_up")

	arg0_4.rtFavorUp:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_40)
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

	var6_4:SetTriggerEvent(function(arg0_41)
		local var0_41, var1_41 = getProxy(ApartmentProxy):getStamina()

		setText(arg0_4.rtStaminaPop:Find("Text"), string.format("%d/%d", var0_41, var1_41))
	end)
	var6_4:SetEndEvent(function(arg0_42)
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
		local var0_47 = arg0_4.ladyDict[arg0_4.apartment:GetConfigID()].ladyBaseZone
		local var1_47 = arg0_4.apartment:getFurnitureTalking(arg0_4.room:GetConfigID(), var0_47)

		if #var1_47 == 0 then
			pg.TipsMgr.GetInstance():ShowTips("without topic")

			return
		end

		arg0_4:DoTalk(var1_47[math.random(#var1_47)], function()
			local var0_48 = getDorm3dGameset("drom3d_favir_trigger_talk")[1]

			arg0_4:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_4.apartment.configId, var0_48)
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

		local var0_52 = pg.dorm3d_minigame[arg0_4.nowMiniGameId]
		local var1_52 = arg0_4.ladyDict[arg0_4.apartment:GetConfigID()]

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

		local var2_52 = {}

		table.insert(var2_52, function(arg0_53)
			arg0_4:SetAllBlackbloardValue("inLockLayer", true)
			arg0_4:TempHideUI(true, arg0_53)
		end)

		if var0_52.area ~= "" and var1_52.ladyBaseZone ~= var0_52.area then
			table.insert(var2_52, function(arg0_54)
				arg0_4:ShiftZone(var0_52.area, arg0_54)
			end)
		end

		local var3_52
		local var4_52

		if var0_52.action ~= "" then
			var3_52, var4_52 = unpack(var0_52.action)
		end

		table.insert(var2_52, function(arg0_55)
			parallelAsync({
				function(arg0_56)
					if var3_52 then
						arg0_4:PlaySingleAction(var1_52, var3_52, arg0_56)
					else
						arg0_56()
					end
				end,
				function(arg0_57)
					arg0_4:ActiveStateCamera("talk", arg0_57)
				end
			}, arg0_55)
		end)
		table.insert(var2_52, function(arg0_58)
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataMiniGame(1))
			arg0_4:HandleGameNotification(Dorm3dMiniGameMediator.OPERATION, {
				operationCode = "BEFORE_OPEN_GAME",
				miniGameId = arg0_4.nowMiniGameId
			})
			arg0_4:EnableMiniGameCutIn()
			arg0_4:emit(Dorm3dRoomMediator.OPEN_MINIGAME_WINDOW, {
				isDorm3d = true,
				minigameId = arg0_4.nowMiniGameId
			}, arg0_58)
		end)
		table.insert(var2_52, function(arg0_59)
			arg0_4:DisableMiniGameCutIn()

			if var4_52 then
				arg0_4:PlaySingleAction(var1_52, var4_52, arg0_59)
			else
				arg0_59()
			end
		end)
		seriesAsync(var2_52, function()
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

	eachChild(var8_4, function(arg0_69)
		setActive(arg0_69, arg0_69.name == "walk")
	end)

	arg0_4._joystick = arg0_4._tf:Find("Stick")

	setActive(arg0_4._joystick, false)
	arg0_4._joystick:GetComponent(typeof(SlideController)):SetStickFunc(function(arg0_70)
		arg0_4:emit(arg0_4.ON_STICK_MOVE, arg0_70)
	end)

	arg0_4.povLayer = arg0_4._tf:Find("POVControl")

	setActive(arg0_4.povLayer, false)
	;(function()
		local var0_71 = arg0_4.povLayer:Find("Move"):GetComponent(typeof(SlideController))

		var0_71:AddBeginDragFunc(function(arg0_72, arg1_72)
			arg0_4:emit(arg0_4.ON_POV_STICK_MOVE_BEGIN, arg1_72)
		end)
		var0_71:SetStickFunc(function(arg0_73)
			arg0_4:emit(arg0_4.ON_POV_STICK_MOVE, arg0_73)
		end)
		var0_71:AddDragEndFunc(function(arg0_74, arg1_74)
			arg0_4:emit(arg0_4.ON_POV_STICK_MOVE_END, arg1_74)
		end)
		arg0_4.povLayer:Find("View"):GetComponent(typeof(SlideController)):SetStickFunc(function(arg0_75)
			arg0_4:emit(arg0_4.ON_POV_STICK_VIEW, arg0_75)
		end)
	end)()

	arg0_4.ikControlLayer = var4_4:Find("ControlLayer")

	;(function()
		local var0_76
		local var1_76 = arg0_4.ikControlLayer:GetComponent(typeof(SlideController))

		var1_76:AddBeginDragFunc(function(arg0_77, arg1_77)
			local var0_77 = arg0_4.ladyDict[arg0_4.apartment:GetConfigID()]

			if not var0_77.IKSettings then
				return
			end

			local var1_77 = arg1_77.position
			local var2_77 = CameraMgr.instance:Raycast(var0_77.IKSettings.CameraRaycaster, var1_77)

			if var2_77.Length ~= 0 then
				local var3_77 = var2_77[0].gameObject.transform
				local var4_77 = table.keyof(var0_77.IKSettings.Colliders, var3_77)

				warning(var3_77, var4_77)

				if var4_77 then
					arg0_4:emit(var0_0.ON_BEGIN_DRAG_CHARACTER_BODY, var0_77, var4_77, var1_77)

					var0_76 = tobool(var0_77.ikHandler)

					return
				end
			end
		end)
		var1_76:AddDragFunc(function(arg0_78, arg1_78)
			local var0_78 = arg1_78.position
			local var1_78 = arg0_4.ladyDict[arg0_4.apartment:GetConfigID()]

			if var1_78.ikHandler then
				arg0_4:emit(var0_0.ON_DRAG_CHARACTER_BODY, var1_78, var0_78)

				return
			end

			if var0_76 then
				return
			end

			local var2_78 = arg1_78.delta

			arg0_4:emit(arg0_4.ON_STICK_MOVE, var2_78)
		end)
		var1_76:AddDragEndFunc(function(arg0_79, arg1_79)
			var0_76 = nil

			local var0_79 = arg0_4.ladyDict[arg0_4.apartment:GetConfigID()]

			if var0_79.ikHandler then
				arg0_4:emit(var0_0.ON_RELEASE_CHARACTER_BODY, var0_79)

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

function var0_0.InitExtraSystem(arg0_81, arg1_81)
	arg1_81 = arg1_81 or {
		"FurnitureSlide"
	}

	for iter0_81, iter1_81 in ipairs(arg1_81) do
		switch(iter1_81, {
			FurnitureSlide = function()
				if not SlideExtraSystem.IsOpen(arg0_81.room) then
					return
				end

				arg0_81:emit(Dorm3dRoomMediator.ADD_EXTRA_SYSTEM_FURNITURE_SLIDE, {
					scene = arg0_81
				})
			end
		})
	end
end

function var0_0.BindEvent(arg0_83)
	var0_0.super.BindEvent(arg0_83)
	arg0_83:bind(arg0_83.CLICK_CHARACTER, function(arg0_84, arg1_84)
		if arg0_83.uiState ~= "base" or not arg0_83.ladyDict[arg1_84].nowCanWatchState then
			return
		end

		local var0_84 = {}
		local var1_84 = arg0_83.ladyDict[arg1_84]

		if arg0_83:GetBlackboardValue(var1_84, "inPending") then
			table.insert(var0_84, function(arg0_85)
				arg0_83:OutOfPending(arg1_84, arg0_85)
			end)
		else
			table.insert(var0_84, function(arg0_86)
				arg0_83:OutOfLazy(arg1_84, arg0_86)
			end)
		end

		seriesAsync(var0_84, function()
			if not arg0_83.room:isPersonalRoom() then
				arg0_83:SetApartment(getProxy(ApartmentProxy):getApartment(arg1_84))
			end

			arg0_83:EnterWatchMode()
		end)
		pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_touch_v1")
	end)
	arg0_83:bind(arg0_83.CLICK_CONTACT, function(arg0_88, arg1_88)
		arg0_83:TriggerContact(arg1_88)
	end)
	arg0_83:bind(arg0_83.DISTANCE_TRIGGER, function(arg0_89, arg1_89, arg2_89)
		if arg0_83.uiState == "base" then
			arg0_83:CheckDistanceTalk(arg1_89, arg2_89)
		end
	end)
	arg0_83:bind(arg0_83.WALK_DISTANCE_TRIGGER, function(arg0_90, arg1_90, arg2_90)
		if arg0_83.apartment and arg0_83.apartment:GetConfigID() == arg1_90 then
			existCall(arg0_83.walkNearCallback, arg2_90)
		end
	end)
	arg0_83:bind(arg0_83.CHANGE_WATCH, function(arg0_91, arg1_91)
		arg0_83:ChangeCanWatchState(arg0_83.ladyDict[arg1_91])
	end)
	arg0_83:bind(arg0_83.ON_TOUCH_CHARACTER, function(arg0_92, arg1_92)
		local var0_92 = arg0_83.ladyDict[arg0_83.apartment:GetConfigID()]

		if not arg0_83:GetBlackboardValue(var0_92, "inIK") then
			return
		end

		arg0_83:OnTouchCharacterBody(arg1_92)
	end)
	arg0_83:bind(var0_0.ON_IK_STATUS_CHANGED, function(arg0_93, arg1_93, arg2_93)
		local var0_93 = arg0_83.ladyDict[arg0_83.apartment:GetConfigID()]

		if not arg0_83:GetBlackboardValue(var0_93, "inTouching") then
			return
		end

		arg0_83:DoTouch(arg1_93, arg2_93)
	end)
	arg0_83:bind(arg0_83.ON_ENTER_SECTOR, function(arg0_94, arg1_94)
		arg0_83:ChangeCanWatchState(arg0_83.ladyDict[arg1_94])
	end)
	arg0_83:bind(arg0_83.ON_CHANGE_DISTANCE, function(arg0_95, arg1_95, arg2_95)
		arg0_83:ChangeCanWatchState(arg0_83.ladyDict[arg1_95])
	end)
end

function var0_0.didEnter(arg0_96)
	arg0_96:InitExtraSystem()

	arg0_96.resumeCallback = arg0_96.contextData.resumeCallback
	arg0_96.contextData.resumeCallback = nil

	var0_0.super.didEnter(arg0_96)
	arg0_96:UpdateZoneList()
	arg0_96:SetUI(function()
		arg0_96:didEnterCheck()
	end, "base")
end

function var0_0.FinishEnterResume(arg0_98)
	if not arg0_98.resumeCallback then
		return
	end

	local var0_98 = arg0_98.resumeCallback

	arg0_98.resumeCallback = nil

	return var0_98()
end

function var0_0.EnableJoystick(arg0_99, arg1_99)
	setActive(arg0_99._joystick, arg1_99)
end

function var0_0.EnablePOVLayer(arg0_100, arg1_100)
	setActive(arg0_100.povLayer, arg1_100)

	if not arg1_100 then
		arg0_100:emit(arg0_100.ON_POV_STICK_MOVE_END)
	end
end

function var0_0.SetUIStore(arg0_101, arg1_101, ...)
	table.insertto(arg0_101.uiStore, {
		...
	})
	existCall(arg1_101)
end

function var0_0.SetUI(arg0_102, arg1_102, ...)
	while rawget(arg0_102, "class") ~= var0_0 do
		arg0_102 = getmetatable(arg0_102).__index
	end

	table.insertto(arg0_102.uiStore, {
		...
	})

	for iter0_102, iter1_102 in ipairs(arg0_102.uiStore) do
		if iter1_102 == "back" then
			assert(#arg0_102.uiStack > 0)

			arg0_102.uiState = table.remove(arg0_102.uiStack)
		elseif iter1_102 == arg0_102.uiState and iter1_102 == "ik" then
			-- block empty
		else
			table.insert(arg0_102.uiStack, arg0_102.uiState)

			arg0_102.uiState = iter1_102
		end
	end

	arg0_102.uiStore = {}

	eachChild(arg0_102.uiContianer, function(arg0_103)
		setActive(arg0_103, arg0_103.name == arg0_102.uiState)
	end)
	arg0_102:EnablePOVLayer(arg0_102.uiState == "base" or arg0_102.uiState == "walk")
	arg0_102:TempHideContact(arg0_102.uiState ~= "base")
	arg0_102:SetFloatEnable(arg0_102.uiState == "walk")
	setActive(arg0_102.rtFloatPage, arg0_102.uiState == "walk")
	setActive(arg0_102.ikControlUI, arg0_102.uiState == "ik")
	switch(arg0_102.uiState, {
		base = function()
			if not arg0_102.room:isPersonalRoom() then
				arg0_102:SetApartment(nil)
			end

			arg0_102:UpdateBtnState()
		end,
		watch = function()
			eachChild(arg0_102.rtRole, function(arg0_106)
				setActive(arg0_106, false)
			end)

			local var0_105 = underscore.filter({
				"Talk",
				"Touch",
				"Gift",
				"MiniGame",
				"PublicGame",
				"Performance"
			}, function(arg0_107)
				return arg0_102:CheckSystemOpen(arg0_107)
			end)
			local var1_105 = 0.05

			for iter0_105, iter1_105 in ipairs(var0_105) do
				LeanTween.delayedCall(var1_105, System.Action(function()
					setActive(arg0_102.rtRole:Find(iter1_105), true)
				end))

				var1_105 = var1_105 + 0.066
			end

			setActive(arg0_102.rtRole:Find("Gift/bg/Tip"), Dorm3dGift.NeedViewTip(arg0_102.apartment:GetConfigID()))
		end,
		ik = function()
			setActive(arg0_102.uiContianer:Find("ik/Right/MenuSmall"), arg0_102.room:isPersonalRoom() and not arg0_102.performanceInfo)
			setActive(arg0_102.uiContianer:Find("ik/Right/Menu"), false)
		end,
		walk = function()
			setText(arg0_102.uiContianer:Find("walk/dialogue/content"), i18n("dorm3d_removable", arg0_102.apartment:getConfig("name")))
		end
	})
	arg0_102:ActiveStateCamera(arg0_102.uiState, function()
		if arg1_102 then
			arg1_102()
		elseif arg0_102.uiState == "base" then
			arg0_102:CheckQueue()
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
	arg1_118.ladyBaseZone = arg0_118.contextData.ladyZone[var0_118]
	arg1_118.ladyActiveZone = var1_118.welcome_staypoint

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
	local var0_130 = arg0_130.ladyDict[arg0_130.apartment:GetConfigID()]
	local var1_130 = arg0_130.room:getApartmentZoneConfig(var0_130.ladyBaseZone, "touch_performance", arg0_130.apartment:GetConfigID())

	if not var1_130 or var1_130 == 0 then
		arg0_130:EnterTouchMode()
	else
		arg0_130:DoTalk(var1_130)
	end
end

function var0_0.EnterTouchMode(arg0_131)
	local var0_131 = arg0_131.ladyDict[arg0_131.apartment:GetConfigID()]

	if arg0_131:GetBlackboardValue(var0_131, "inTouching") then
		return
	end

	local var1_131 = arg0_131.room:getApartmentZoneConfig(var0_131.ladyBaseZone, "touch_id", arg0_131.apartment:GetConfigID())

	arg0_131.touchConfig = pg.dorm3d_touch_data[var1_131]

	if not arg0_131.touchConfig then
		arg0_131:EnterTimelineTouchMode()

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

	local var2_131 = {}

	table.insert(var2_131, function(arg0_133)
		arg0_131:SetBlackboardValue(var0_131, "inTouching", true)
		arg0_131:emit(arg0_131.SHOW_BLOCK)
		arg0_131:SetUI(arg0_133, "blank")
	end)
	table.insert(var2_131, function(arg0_134)
		local var0_134 = arg0_131.touchConfig.ik_status[1]

		arg0_131:SwitchIKConfig(var0_131, var0_134)
		setActive(arg0_131.uiContianer:Find("ik/btn_back"), true)
		arg0_131:SetIKState(true, arg0_134)
	end)
	table.insert(var2_131, function(arg0_135)
		existCall(arg0_135)
	end)
	seriesAsync(var2_131, function()
		Shader.SetGlobalFloat("_ScreenClipOff", 0)
		arg0_131:emit(arg0_131.HIDE_BLOCK)
	end)
end

function var0_0.ExitTouchMode(arg0_137)
	local var0_137 = arg0_137.ladyDict[arg0_137.apartment:GetConfigID()]

	if not arg0_137:GetBlackboardValue(var0_137, "inTouching") then
		return
	end

	if arg0_137.touchTimelineConfig then
		existCall(arg0_137.timelineFinishCall)

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
	local var0_144 = arg0_144.ladyDict[arg0_144.apartment:GetConfigID()]

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

function var0_0.EnterTimelineTouchMode(arg0_149)
	local var0_149 = arg0_149.ladyDict[arg0_149.apartment:GetConfigID()]

	if arg0_149:GetBlackboardValue(var0_149, "inIK") then
		return
	end

	local var1_149 = arg0_149.room:getApartmentZoneConfig(var0_149.ladyBaseZone, "touch_id", arg0_149.apartment:GetConfigID())
	local var2_149 = pg.dorm3d_ik_timeline[var1_149]

	assert(var2_149, "Missing config in dorm3d_ik_timeline ID: " .. (var1_149 or "nil"))

	arg0_149.touchTimelineConfig = var2_149

	local var3_149 = {}

	table.insert(var3_149, function(arg0_150)
		arg0_149:SetBlackboardValue(var0_149, "inIK", true)
		arg0_149:emit(arg0_149.SHOW_BLOCK)
		arg0_149:SetUI(arg0_150, "ik")
	end)
	table.insert(var3_149, function(arg0_151)
		setActive(arg0_149.uiContianer:Find("ik/btn_back"), true)
		setActive(arg0_149.uiContianer:Find("ik/Right/btn_camera"), false)
		setActive(arg0_149.uiContianer:Find("ik/Right/Menu"), false)
		setActive(arg0_149.uiContianer:Find("ik/Right/MenuSmall"), false)
		Shader.SetGlobalFloat("_ScreenClipOff", 0)
		arg0_149:emit(arg0_149.HIDE_BLOCK)
		arg0_149:HideCharacterBylayer(var0_149)
		setActive(var0_149.ladyCollider, false)

		local var0_151
		local var1_151

		if #var2_149.scene > 0 then
			var0_151, var1_151 = unpack(string.split(var2_149.scene, "|"))
		end

		arg0_149:PlayTimeline({
			name = var2_149.timeline,
			scene = var0_151,
			sceneRoot = var1_151
		}, function(arg0_152, arg1_152)
			arg1_152()
			arg0_149:ExitTimelineTouchMode()
		end)
	end)
	seriesAsync(var3_149, function()
		return
	end)
end

function var0_0.ExitTimelineTouchMode(arg0_154)
	local var0_154 = arg0_154.ladyDict[arg0_154.apartment:GetConfigID()]

	if not arg0_154:GetBlackboardValue(var0_154, "inIK") then
		return
	end

	arg0_154.touchTimelineConfig = nil

	local var1_154 = {}

	table.insert(var1_154, function(arg0_155)
		arg0_154:emit(arg0_154.SHOW_BLOCK)
		Shader.SetGlobalFloat("_ScreenClipOff", 1)
		arg0_155()
	end)
	table.insert(var1_154, function(arg0_156)
		arg0_154:RevertCharacterBylayer(var0_154)
		setActive(var0_154.ladyCollider, true)
		arg0_154:SetUI(arg0_156, "back")
	end)
	seriesAsync(var1_154, function()
		arg0_154:SetBlackboardValue(var0_154, "inIK", false)
		arg0_154:emit(arg0_154.HIDE_BLOCK)
	end)
end

function var0_0.EnterWalkMode(arg0_158)
	local var0_158 = arg0_158.apartment:GetConfigID()
	local var1_158 = arg0_158.ladyDict[var0_158]

	seriesAsync({
		function(arg0_159)
			arg0_158:emit(arg0_158.SHOW_BLOCK)
			arg0_158:HideCharacter(var0_158)
			arg0_158:SetBlackboardValue(var1_158, "inWalk", true)
			arg0_158:SetUI(arg0_159, "walk")
		end,
		function(arg0_160)
			arg0_158:emit(arg0_158.HIDE_BLOCK)
			arg0_158:ChangeArtScene(arg0_158.walkInfo.scene .. "|" .. arg0_158.walkInfo.sceneRoot, arg0_160)
		end,
		function(arg0_161)
			arg0_158:LoadSubScene(arg0_158.walkInfo, arg0_161)
		end
	}, function()
		return
	end)
end

function var0_0.ExitWalkMode(arg0_163)
	local var0_163 = arg0_163.apartment:GetConfigID()
	local var1_163 = arg0_163.ladyDict[var0_163]

	seriesAsync({
		function(arg0_164)
			arg0_163:ChangeArtScene(arg0_163.walkLastSceneInfo, arg0_164)
		end,
		function(arg0_165)
			arg0_163:UnloadSubScene(arg0_163.walkInfo, arg0_165)
		end,
		function(arg0_166)
			arg0_163:emit(arg0_163.SHOW_BLOCK)
			arg0_163:SetUI(arg0_166, "back")
		end
	}, function()
		arg0_163:emit(arg0_163.HIDE_BLOCK)
		arg0_163:RevertCharacter(var0_163)
		arg0_163:SetBlackboardValue(var1_163, "inWalk", false)

		local var0_167 = arg0_163.walkExitCall

		arg0_163.walkExitCall = nil
		arg0_163.walkLastSceneInfo = nil
		arg0_163.walkInfo = nil

		existCall(var0_167)
	end)
end

function var0_0.EnableMiniGameCutIn(arg0_168)
	if not arg0_168.tfCutIn then
		return
	end

	local var0_168 = arg0_168.rtExtraScreen:Find("MiniGameCutIn")

	setActive(var0_168, true)

	local var1_168 = GetOrAddComponent(var0_168:Find("bg/mask/cut_in"), "CameraRTUI")

	setActive(var1_168, true)
	pg.CameraRTMgr.GetInstance():Bind(var1_168, arg0_168.tfCutIn:Find("TestCamera"):GetComponent(typeof(Camera)))
	quickPlayAnimator(arg0_168.modelCutIn.lady, "Idle")
	quickPlayAnimator(arg0_168.modelCutIn.player, "Idle")
	setActive(arg0_168.tfCutIn, true)
end

function var0_0.DisableMiniGameCutIn(arg0_169)
	if not arg0_169.tfCutIn then
		return
	end

	local var0_169 = arg0_169.rtExtraScreen:Find("MiniGameCutIn")
	local var1_169 = GetOrAddComponent(var0_169:Find("bg/mask/cut_in"), "CameraRTUI")

	pg.CameraRTMgr.GetInstance():Clean(var1_169)
	setActive(var0_169, false)
	setActive(arg0_169.tfCutIn, false)
end

function var0_0.SwitchIKConfig(arg0_170, arg1_170, arg2_170)
	local var0_170 = pg.dorm3d_ik_status[arg2_170]

	if var0_170.skin_id ~= arg1_170.skinId then
		local var1_170 = pg.dorm3d_ik_status.get_id_list_by_base[var0_170.base]
		local var2_170 = _.detect(var1_170, function(arg0_171)
			return pg.dorm3d_ik_status[arg0_171].skin_id == arg1_170.skinId
		end)

		assert(var2_170, string.format("Missing Status Config By Skin: %s original Status: %s", arg1_170.skinId, arg2_170))

		var0_170 = pg.dorm3d_ik_status[var2_170]
	end

	arg1_170.ikConfig = var0_170
end

function var0_0.SetIKState(arg0_172, arg1_172, arg2_172)
	local var0_172 = arg0_172.ladyDict[arg0_172.apartment:GetConfigID()]
	local var1_172 = {}

	if arg1_172 then
		table.insert(var1_172, function(arg0_173)
			arg0_172:SetBlackboardValue(var0_172, "inIK", true)
			arg0_172:emit(arg0_172.SHOW_BLOCK)

			local var0_173 = var0_172.ikConfig.camera_group

			setActive(arg0_172.uiContianer:Find("ik/Right/btn_camera"), #pg.dorm3d_ik_status.get_id_list_by_camera_group[var0_173] > 1)
			setActive(arg0_172.ikControlUI, true)
			arg0_173()
		end)

		if arg0_172.uiState ~= "ik" then
			table.insert(var1_172, function(arg0_174)
				arg0_172:SetUI(arg0_174, "ik")
			end)
		end

		table.insert(var1_172, function(arg0_175)
			Shader.SetGlobalFloat("_ScreenClipOff", 0)
			arg0_172:SetIKStatus(var0_172, var0_172.ikConfig, arg0_175)
		end)
		table.insert(var1_172, function(arg0_176)
			arg0_172:emit(arg0_172.HIDE_BLOCK)
			arg0_176()
		end)
	else
		assert(arg0_172.uiState == "ik")
		table.insert(var1_172, function(arg0_177)
			setActive(arg0_172.ikControlUI, false)
			arg0_172:emit(arg0_172.SHOW_BLOCK)
			Shader.SetGlobalFloat("_ScreenClipOff", 1)
			arg0_177()
		end)
		table.insert(var1_172, function(arg0_178)
			arg0_172:ExitIKStatus(var0_172, var0_172.ikConfig, arg0_178)
			arg0_172:ResetSceneItemAnimators()
		end)
		table.insert(var1_172, function(arg0_179)
			arg0_172:SetUI(arg0_179, "back")
		end)
		table.insert(var1_172, function(arg0_180)
			arg0_172:SetBlackboardValue(var0_172, "inIK", false)
			arg0_172:emit(arg0_172.HIDE_BLOCK)
			arg0_180()
		end)
	end

	seriesAsync(var1_172, arg2_172)
end

function var0_0.TouchModeAction(arg0_181, arg1_181, arg2_181, arg3_181, ...)
	return switch(arg3_181, {
		function(arg0_182, arg1_182)
			return function(arg0_183)
				seriesAsync({
					function(arg0_184)
						if not arg1_182 or arg1_182 == "" then
							return arg0_184()
						end

						arg0_181:PlaySingleAction(arg1_181, arg1_182, arg0_184)
					end,
					function(arg0_185)
						arg0_181:SwitchIKConfig(arg1_181, arg0_182)
						arg0_181:SetIKState(true, arg0_185)
					end,
					arg0_183
				})
			end
		end,
		function()
			return function()
				if arg0_181.ikSpecialCall then
					local var0_187 = arg0_181.ikSpecialCall

					arg0_181.ikSpecialCall = nil

					existCall(var0_187)
				else
					arg0_181:ExitTouchMode()
				end
			end
		end,
		function(arg0_188, arg1_188)
			return function(arg0_189)
				arg0_181:PlaySingleAction(arg1_181, arg1_188, arg0_189)
			end
		end,
		function(arg0_190, arg1_190, arg2_190)
			return function(arg0_191)
				seriesAsync({
					function(arg0_192)
						arg0_181:DoTalk(arg1_190, arg0_192)
					end,
					function(arg0_193)
						if not arg2_190 or arg2_190 == 0 then
							return arg0_193()
						end

						arg0_181:SwitchIKConfig(arg1_181, arg2_190)
						arg0_181:SetIKState(true, arg0_193)
					end,
					arg0_191
				})
			end
		end,
		function(arg0_194, arg1_194, arg2_194, arg3_194)
			return function(arg0_195)
				arg0_181:PlaySceneItemAnim(arg2_194, arg3_194)
				arg0_181:PlaySingleAction(arg1_194, arg0_195)
			end
		end,
		function(arg0_196)
			return function(arg0_197)
				local var0_197 = pg.dorm3d_ik_touch[arg2_181]

				if #var0_197.scene_item == 0 then
					return
				end

				local var1_197 = arg0_181:GetSceneItem(var0_197.scene_item)

				if not var1_197 then
					warning(string.format("dorm3d_ik_touch:%d without scene_item:%s", arg2_181, var0_197.scene_item))

					return
				end

				local var2_197 = var1_197:Find(arg0_196)

				if not IsNil(var2_197) then
					setActive(var2_197, false)
					setActive(var2_197, true)
				end

				arg0_197()
			end
		end,
		function(arg0_198)
			local var0_198 = pg.dorm3d_ik_touch_move[arg0_198]
			local var1_198 = var0_198.target_ik
			local var2_198 = var0_198.move_time
			local var3_198 = var0_198.ik_point
			local var4_198 = var0_198.touch_step

			arg1_181.IKSettings.forceMove = arg1_181.IKSettings.forceMove or {}

			local var5_198 = arg1_181.IKSettings.forceMove

			var5_198[var1_198] = var5_198[var1_198] or {}
			var5_198[var1_198].count = var5_198[var1_198].count or 0

			return function(arg0_199)
				seriesAsync({
					function(arg0_200)
						if var5_198[var1_198].count >= #var4_198 then
							return arg0_200()
						end

						local var0_200 = Dorm3dIK.New({
							configId = var1_198
						})
						local var1_200 = Vector2.New(unpack(var3_198))
						local var2_200 = var5_198[var1_198].count
						local var3_200 = var4_198[var2_200 + 1] - (var2_200 == 0 and 0 or var4_198[var2_200])

						var5_198[var1_198].count = var2_200 + 1

						pg.IKMgr.GetInstance():ResetIK(var0_200:GetTriggerBoneName())

						local var4_200 = arg1_181.IKSettings.Colliders[var0_200:GetTriggerBoneName()]
						local var5_200 = arg0_181.raycastCamera:WorldToScreenPoint(var4_200.position)

						pg.IKMgr.GetInstance():PlayIKMove(var5_200, var0_200:GetTriggerBoneName(), var1_200, var4_198[var2_200 + 1], var2_198, function()
							var5_198[var1_198].count = 0

							arg0_200()
						end)
					end,
					arg0_199
				})
			end
		end
	}, function()
		return function()
			return
		end
	end, ...)
end

function var0_0.OnTriggerIK(arg0_204, arg1_204)
	local var0_204 = arg0_204.ladyDict[arg0_204.apartment:GetConfigID()]

	if var0_204.ikTimelineMode then
		arg0_204:ExitIKTimelineStatus(var0_204)

		local var1_204 = arg1_204:GetTimelineAction()

		if var1_204 then
			arg0_204.nowTimelinePlayer:TriggerEvent(var1_204)
		end

		return
	end

	if not var0_204.ikConfig then
		return
	end

	local var2_204 = arg1_204:GetControllerPath()
	local var3_204 = var0_204.ikActionDict[var2_204]

	if not var3_204 then
		return
	end

	arg0_204.blockIK = true

	arg0_204:TouchModeAction(var0_204, arg1_204:GetConfigID(), unpack(var3_204))(function()
		arg0_204:ResetIKTipTimer()

		arg0_204.blockIK = nil
	end)
end

function var0_0.OnTouchCharacterBody(arg0_206, arg1_206)
	local var0_206 = arg0_206.ladyDict[arg0_206.apartment:GetConfigID()]

	if not var0_206.ikConfig then
		return
	end

	if type(var0_206.ikConfig.touch_data) ~= "table" then
		return
	end

	for iter0_206, iter1_206 in ipairs(var0_206.iKTouchDatas) do
		local var1_206, var2_206, var3_206 = unpack(iter1_206)
		local var4_206 = pg.dorm3d_ik_touch[var1_206]

		if var4_206.body == arg1_206 then
			local var5_206 = var4_206.action_emote

			if #var5_206 > 0 then
				arg0_206:PlayFaceAnim(var0_206, var5_206)
			end

			local var6_206 = var4_206.vibrate

			if type(var6_206) == "table" and VibrateMgr.Instance:IsSupport() then
				local var7_206 = {}
				local var8_206 = {}
				local var9_206 = {}

				underscore.each(var6_206, function(arg0_207)
					local var0_207 = arg0_207[1]

					if PLATFORM == PLATFORM_IPHONEPLAYER then
						var0_207 = var0_207 / 1000
					end

					table.insert(var7_206, var0_207)
					table.insert(var8_206, arg0_207[2])
					table.insert(var9_206, 1)
				end)

				if PLATFORM == PLATFORM_ANDROID then
					VibrateMgr.Instance:VibrateWaveform(var7_206, var8_206)
				elseif PLATFORM == PLATFORM_IPHONEPLAYER then
					VibrateMgr.Instance:VibrateWaveform(var7_206, var8_206, var9_206)
				end
			end

			arg0_206.blockIK = true

			arg0_206:TouchModeAction(var0_206, var1_206, unpack(var3_206))(function()
				arg0_206:ResetIKTipTimer()

				arg0_206.blockIK = nil
			end)

			return
		end
	end
end

function var0_0.UpdateTouchGameDisplay(arg0_209)
	setActive(arg0_209.rtTouchGamePanel:Find("effect_bg"), arg0_209.touchLevel == 2)
	setActive(arg0_209.rtTouchGamePanel:Find("slider/icon/beating"), arg0_209.touchLevel == 2)

	if arg0_209.touchLevel == 1 then
		setActive(arg0_209.uiContianer:Find("ik/btn_back"), true)
		setActive(arg0_209.uiContianer:Find("ik/btn_back_heartbeat"), false)
		quickPlayAnimation(arg0_209.rtTouchGamePanel, "anim_dorm3d_touch_change_out")
		quickPlayAnimation(arg0_209.rtTouchGamePanel:Find("slider/icon"), "anim_dorm3d_touch_icon")
	elseif arg0_209.touchLevel == 2 then
		setActive(arg0_209.uiContianer:Find("ik/btn_back"), false)
		setActive(arg0_209.uiContianer:Find("ik/btn_back_heartbeat"), true)
		quickPlayAnimation(arg0_209.rtTouchGamePanel, "anim_dorm3d_touch_change")
		quickPlayAnimation(arg0_209.rtTouchGamePanel:Find("slider/icon"), "anim_dorm3d_touch_icon_1")
		pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_heartbeat")
	end
end

function var0_0.UpdateTouchCount(arg0_210, arg1_210)
	if arg0_210.touchLevel > 1 then
		arg1_210 = math.min(0, arg1_210)
	end

	arg0_210.touchCount = math.clamp(arg0_210.touchCount + arg1_210, 0, 100)

	if arg0_210.sliderLT and LeanTween.isTweening(arg0_210.sliderLT) then
		LeanTween.cancel(arg0_210.sliderLT)

		arg0_210.sliderLT = nil
	end

	setSlider(arg0_210.rtTouchGamePanel:Find("slider"), 0, 100, arg0_210.touchCount)

	local var0_210

	if arg0_210.touchCount >= 100 then
		var0_210 = 2
	elseif arg0_210.touchCount <= 0 then
		var0_210 = 1
	end

	if var0_210 and var0_210 ~= arg0_210.touchLevel then
		if arg0_210.blockIK then
			return
		end

		arg0_210.touchLevel = var0_210

		local var1_210 = arg0_210.touchConfig.ik_status[var0_210]

		if var1_210 then
			if var0_210 > 1 then
				arg0_210.touchCount = 200
			elseif var0_210 == 1 then
				arg0_210.touchCount = 0
			end

			local var2_210 = arg0_210.ladyDict[arg0_210.apartment:GetConfigID()]

			seriesAsync({
				function(arg0_211)
					arg0_210:ShowBlackScreen(true, arg0_211)
				end,
				function(arg0_212)
					arg0_210:SwitchIKConfig(var2_210, var1_210)
					arg0_210:SetIKState(true, arg0_212)

					if var0_210 > 1 and arg0_210.touchConfig.heartbeat_enter_anim ~= "" then
						arg0_210:SwitchAnim(var2_210, arg0_210.touchConfig.heartbeat_enter_anim)
					end
				end,
				function(arg0_213)
					arg0_210:ShowBlackScreen(false, arg0_213)
				end
			})
		end

		arg0_210:UpdateTouchCount(0)
		arg0_210:UpdateTouchGameDisplay()
	end

	arg0_210.topCount = math.max(arg0_210.topCount, arg0_210.touchCount)
end

function var0_0.ExitHeartbeatMode(arg0_214)
	if not arg0_214.touchLevel or arg0_214.touchLevel == 1 then
		return
	end

	arg0_214.touchCount = 0

	arg0_214:UpdateTouchCount(0)
end

function var0_0.DoTouch(arg0_215, arg1_215, arg2_215)
	if arg0_215.inTouchGame then
		switch(arg2_215, {
			function()
				arg0_215:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat.key_value_int)
			end,
			function()
				arg0_215:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat.key_value_int)
			end,
			function()
				arg0_215:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat.key_value_int)
			end,
			function()
				arg0_215:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat_trriger.key_value_int)
			end
		})
	end
end

function var0_0.DoTalk(arg0_220, arg1_220, arg2_220)
	while rawget(arg0_220, "class") ~= var0_0 do
		arg0_220 = getmetatable(arg0_220).__index
	end

	if arg0_220.apartment and arg0_220:GetBlackboardValue(arg0_220.ladyDict[arg0_220.apartment:GetConfigID()], "inTalking") then
		errorMsg("Talking block:" .. arg1_220)

		return
	end

	if not arg0_220.room:isPersonalRoom() then
		local var0_220 = pg.dorm3d_dialogue_group[arg1_220].char_id

		if arg0_220.apartment then
			assert(arg0_220.apartment:GetConfigID() == var0_220)
		else
			arg0_220:SetApartment(getProxy(ApartmentProxy):getApartment(var0_220))
		end
	end

	local var1_220 = arg0_220.ladyDict[arg0_220.apartment:GetConfigID()]

	if arg1_220 == 10010 and not arg0_220.apartment.talkDic[arg1_220] then
		arg0_220.firstTimelineTouch = true
		arg0_220.firstMoveGuide = true
	end

	getProxy(Dorm3dChatProxy):TriggerEvent({
		{
			value = 1,
			event_type = arg0_220.contextData.timeIndex == 1 and 110 or 115,
			ship_id = arg0_220.apartment:GetConfigID()
		},
		{
			value = 1,
			event_type = 155,
			ship_id = arg0_220.apartment:GetConfigID()
		}
	})

	local var2_220 = {}

	if arg0_220:GetBlackboardValue(var1_220, "inPending") then
		table.insert(var2_220, function(arg0_221)
			arg0_220:OutOfLazy(arg0_220.apartment:GetConfigID(), arg0_221)
		end)
	end

	local var3_220 = pg.dorm3d_dialogue_group[arg1_220]
	local var4_220 = var3_220.performance_type == 1
	local var5_220

	table.insert(var2_220, function(arg0_222)
		arg0_220:emit(arg0_220.SHOW_BLOCK)
		arg0_220:SetBlackboardValue(var1_220, var4_220 and "inPerformance" or "inTalking", true)
		arg0_220:emit(Dorm3dRoomMediator.DO_TALK, arg1_220, function(arg0_223)
			var5_220 = arg0_223

			arg0_222()
		end)
	end)
	table.insert(var2_220, function(arg0_224)
		pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataDialog(arg0_220.apartment.configId, arg0_220.apartment.level, arg1_220, var3_220.type, arg0_220.room:getZoneConfig(arg0_220.ladyDict[arg0_220.apartment:GetConfigID()].ladyBaseZone, "id"), var3_220.action_type, table.CastToString(var3_220.trigger_config), arg0_220.room:GetConfigID()))

		if pg.NewGuideMgr.GetInstance():IsBusy() then
			pg.NewGuideMgr.GetInstance():Pause()
		end

		arg0_220:SetUI(arg0_224, "blank")
	end)

	if var3_220.trigger_area and var3_220.trigger_area ~= "" then
		table.insert(var2_220, function(arg0_225)
			arg0_220:ShiftZone(var3_220.trigger_area, arg0_225)
		end)
	end

	if var3_220.performance_type == 0 then
		table.insert(var2_220, function(arg0_226)
			arg0_220:emit(arg0_220.HIDE_BLOCK)

			if arg0_220.contextData.isVideoTalk then
				arg0_220.videoPlayer:ExecuteAction("Play", var3_220.story, function()
					onDelayTick(arg0_226, 0.001)
				end)
			else
				pg.NewStoryMgr.GetInstance():ForceManualPlay(var3_220.story, function()
					onDelayTick(arg0_226, 0.001)
				end, true)
			end
		end)
	elseif var3_220.performance_type == 1 then
		table.insert(var2_220, function(arg0_229)
			arg0_220:emit(arg0_220.HIDE_BLOCK)
			arg0_220:PerformanceQueue(var3_220.story, arg0_229)
		end)
	else
		assert(false)
	end

	table.insert(var2_220, function(arg0_230)
		arg0_220:emit(arg0_220.SHOW_BLOCK)
		arg0_230()
	end)
	table.insert(var2_220, function(arg0_231)
		local var0_231 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(var3_220.story)

		if var0_231 then
			local var1_231 = "1"

			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataStory(var0_231, var1_231))
		end

		if var5_220 and #var5_220 > 0 then
			arg0_220:emit(Dorm3dRoomMediator.OPEN_DROP_LAYER, var5_220, arg0_231)
		else
			arg0_231()
		end
	end)
	table.insert(var2_220, function(arg0_232)
		if pg.NewGuideMgr.GetInstance():IsPause() then
			pg.NewGuideMgr.GetInstance():Resume()
		end

		arg0_220:emit(arg0_220.HIDE_BLOCK)

		if arg0_220.contextData.isVideoTalk then
			existCall(arg0_232)
		else
			arg0_220:SetBlackboardValue(var1_220, var4_220 and "inPerformance" or "inTalking", false)
			arg0_220:SetUI(arg0_232, "back")
		end
	end)
	seriesAsync(var2_220, function()
		if arg2_220 then
			return arg2_220()
		else
			arg0_220:CheckQueue()
		end
	end)
end

function var0_0.DoTalkTouchOption(arg0_234, arg1_234, arg2_234, arg3_234)
	local var0_234 = arg0_234.rtExtraScreen:Find("TalkTouchOption")
	local var1_234
	local var2_234 = var0_234:Find("content")

	UIItemList.StaticAlign(var2_234, var2_234:Find("clickTpl"), #arg1_234.options, function(arg0_235, arg1_235, arg2_235)
		arg1_235 = arg1_235 + 1

		if arg0_235 == UIItemList.EventUpdate then
			local var0_235 = arg1_234.options[arg1_235]

			setAnchoredPosition(arg2_235, NewPos(unpack(var0_235.pos)))
			onButton(arg0_234, arg2_235, function()
				var1_234(var0_235.flag)
			end, SFX_CONFIRM)
			setActive(arg2_235, not table.contains(arg2_234, var0_235.flag))
		end
	end)
	setActive(var0_234, true)

	function var1_234(arg0_237)
		setActive(var0_234, false)
		arg3_234(arg0_237)
	end
end

function var0_0.DoTimelineOption(arg0_238, arg1_238, arg2_238)
	local var0_238 = arg0_238.rtTimelineScreen:Find("TimelineOption")
	local var1_238
	local var2_238 = var0_238:Find("content")

	UIItemList.StaticAlign(var2_238, var2_238:Find("clickTpl"), #arg1_238, function(arg0_239, arg1_239, arg2_239)
		arg1_239 = arg1_239 + 1

		if arg0_239 == UIItemList.EventUpdate then
			local var0_239 = arg1_238[arg1_239]

			setText(arg2_239:Find("Text"), HXSet.hxLan(var0_239.content))
			onButton(arg0_238, arg2_239, function()
				var1_238(arg1_239)
			end, SFX_CONFIRM)
		end
	end)
	setActive(var0_238, true)

	function var1_238(arg0_241)
		setActive(var0_238, false)
		arg2_238(arg0_241)
	end
end

function var0_0.DoTimelineTouch(arg0_242, arg1_242, arg2_242)
	local var0_242 = arg0_242.rtTimelineScreen:Find("TimelineTouch")
	local var1_242
	local var2_242 = var0_242:Find("content")

	UIItemList.StaticAlign(var2_242, var2_242:Find("clickTpl"), #arg1_242, function(arg0_243, arg1_243, arg2_243)
		arg1_243 = arg1_243 + 1

		if arg0_243 == UIItemList.EventUpdate then
			local var0_243 = arg1_242[arg1_243]

			setAnchoredPosition(arg2_243, NewPos(unpack(var0_243.pos)))
			onButton(arg0_242, arg2_243, function()
				var1_242(arg1_243)
			end, SFX_CONFIRM)

			if arg0_242.firstTimelineTouch then
				arg0_242.firstTimelineTouch = nil

				setActive(arg2_243:Find("finger"), true)
			end
		end
	end)
	setActive(var0_242, true)

	function var1_242(arg0_245)
		setActive(var0_242, false)
		arg2_242(arg0_245)
	end
end

function var0_0.DoShortWait(arg0_246, arg1_246)
	local var0_246 = arg0_246.ladyDict[arg1_246]
	local var1_246 = getProxy(ApartmentProxy):getApartment(arg1_246)
	local var2_246 = arg0_246.room:getApartmentZoneConfig(var0_246.ladyBaseZone, "special_action", arg1_246)
	local var3_246 = var2_246 and var2_246[math.random(#var2_246)] or nil

	if not var3_246 then
		return
	end

	arg0_246:PlaySingleAction(var0_246, var3_246)
end

function var0_0.OutOfLazy(arg0_247, arg1_247, arg2_247)
	local var0_247 = arg0_247.ladyDict[arg1_247]
	local var1_247 = {}

	if arg0_247:GetBlackboardValue(var0_247, "inPending") then
		table.insert(var1_247, function(arg0_248)
			arg0_247.shiftLady = arg1_247

			arg0_247:ShiftZone(var0_247.ladyBaseZone, arg0_248)
		end)
	end

	seriesAsync(var1_247, arg2_247)
end

function var0_0.OutOfPending(arg0_249, arg1_249, arg2_249)
	assert(arg0_249.wakeUpTalkId)

	local var0_249 = arg0_249.wakeUpTalkId

	seriesAsync({
		function(arg0_250)
			arg0_249:SetUI(arg0_250, "blank")
		end,
		function(arg0_251)
			arg0_249.shiftLady = arg1_249

			local var0_251 = arg0_249.ladyDict[arg1_249]

			arg0_249:ShiftZone(var0_251.ladyBaseZone, arg0_251)
		end,
		function(arg0_252)
			arg0_249:DoTalk(var0_249, arg0_252)
		end
	}, function()
		arg0_249:SetUIStore(arg2_249, "back")
	end)
end

function var0_0.ChangeCanWatchState(arg0_254, arg1_254)
	local var0_254

	if arg0_254:GetBlackboardValue(arg1_254, "inPending") then
		var0_254 = tobool(arg0_254:GetBlackboardValue(arg1_254, "inDistance"))
	else
		local var1_254 = arg0_254:GetBlackboardValue(arg1_254, "groupId")

		var0_254 = tobool(arg0_254.activeLady[var1_254] and pg.NodeCanvasMgr.GetInstance():GetBlackboradValue("canWatch", arg1_254.ladyBlackboard))
	end

	if (not arg1_254.nowCanWatchState or arg1_254.nowCanWatchState ~= var0_254) and arg1_254.ladyWatchFloat then
		arg1_254.nowCanWatchState = var0_254

		arg0_254:ShowOrHideCanWatchMark(arg1_254, arg1_254.nowCanWatchState)
	end
end

function var0_0.HandleGameNotification(arg0_255, arg1_255, arg2_255)
	local var0_255 = arg0_255.ladyDict[arg0_255.apartment:GetConfigID()]

	switch(arg1_255, {
		[Dorm3dMiniGameMediator.OPERATION] = function()
			local var0_256 = arg2_255.miniGameId

			switch(arg2_255.miniGameId, {
				[67] = function()
					if arg2_255.operationCode == "GAME_HIT_AREA" then
						local var0_257 = {
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
						local var1_257, var2_257 = unpack(var0_257[arg2_255.index])

						arg0_255:PlayFaceAnim(var0_255, var1_257)

						if arg0_255.tfCutIn then
							quickPlayAnimator(arg0_255.modelCutIn.lady, var2_257)
							quickPlayAnimator(arg0_255.modelCutIn.player, var2_257)
						end
					elseif arg2_255.operationCode == "GAME_RESULT" then
						if arg2_255.win then
							arg0_255:PlayFaceAnim(var0_255, "Face_XYX_victory")
							arg0_255:PlaySingleAction(var0_255, "minigame_win")
						else
							arg0_255:PlayFaceAnim(var0_255, "Face_XYX_lose")
							arg0_255:PlaySingleAction(var0_255, "minigame_lose")
						end

						setActive(arg0_255.rtExtraScreen:Find("MiniGameCutIn"), false)
					end
				end,
				[70] = function()
					if arg2_255.operationCode == "GAME_READY" then
						arg0_255.cameras[var0_0.CAMERA.TALK].Follow = nil
						arg0_255.cameras[var0_0.CAMERA.TALK].LookAt = nil

						arg0_255:PlaySingleAction(var0_255, "shuohua_sikao")
					elseif arg2_255.operationCode == "ROUND_RESULT" then
						local var0_258

						if arg2_255.success then
							var0_258 = {
								"shuohua_wenhou",
								"shuohua_sikao"
							}
						else
							var0_258 = {
								"shuohua_yaotou",
								"shuohua_sikao"
							}
						end

						seriesAsync(underscore.map(var0_258, function(arg0_259)
							return function(arg0_260)
								arg0_255:PlaySingleAction(var0_255, arg0_259, arg0_260)
							end
						end), function()
							return
						end)
					elseif arg2_255.operationCode == "GAME_RESULT" then
						local var1_258 = arg0_255.cameras[var0_0.CAMERA.TALK].transform

						var1_258.position = var1_258.position + var1_258.right * 0.11

						local var2_258 = {
							"shuohua_gandong"
						}

						seriesAsync(underscore.map(var2_258, function(arg0_262)
							return function(arg0_263)
								arg0_255:PlaySingleAction(var0_255, arg0_262, arg0_263)
							end
						end), function()
							return
						end)
					end
				end,
				[75] = function()
					if arg2_255.operationCode == "BEFORE_OPEN_GAME" then
						arg0_255.cameras[var0_0.CAMERA.TALK].Follow = nil
						arg0_255.cameras[var0_0.CAMERA.TALK].LookAt = nil
					elseif arg2_255.operationCode == "GAME_RPS_RESULT" then
						if arg2_255.index == 1 then
							arg0_255:PlaySingleAction(var0_255, "ab_shuohua_lianxuyaotou_01")
							arg0_255:PlayFaceAnim(var0_255, "Face_weixiao")
						elseif arg2_255.index == 2 then
							arg0_255:PlaySingleAction(var0_255, "ab_shuohua_lianxudiantou_01")
							arg0_255:PlayFaceAnim(var0_255, "Face_kaixin")
						end
					elseif arg2_255.operationCode == "GAME_RESULT" then
						if not arg2_255.win then
							arg0_255:PlaySingleAction(var0_255, "ab_shuohua_taibangle_01")
						end

						arg0_255:PlayFaceAnim(var0_255, "Face_kaixin")
					end
				end
			}, function()
				warning("without miniGameId:" .. arg2_255.miniGameId)
			end)

			if arg2_255.operationCode == "BEFORE_OPEN_GAME" then
				local var1_256 = getProxy(PlayerProxy):getPlayerId()
				local var2_256 = 0

				if var0_256 == 67 or var0_256 == 70 then
					var2_256 = PlayerPrefs.GetInt("mg_new_score_" .. tostring(var1_256) .. "_" .. arg2_255.miniGameId, 0)
				else
					var2_256 = PlayerPrefs.GetInt("mg_score_" .. tostring(var1_256) .. "_" .. arg2_255.miniGameId, 0)
				end

				arg0_255.highScore = var2_256
			elseif arg2_255.operationCode == "GAME_RESULT" then
				local var3_256 = arg2_255.score
				local var4_256 = getProxy(PlayerProxy):getPlayerId()

				if var3_256 > arg0_255.highScore then
					if var0_256 == 67 or var0_256 == 70 then
						PlayerPrefs.SetInt("mg_new_score_" .. tostring(var4_256) .. "_" .. arg2_255.miniGameId, var3_256)
					end

					getProxy(Dorm3dChatProxy):TriggerEvent({
						{
							event_type = 159,
							value = var3_256,
							ship_id = arg0_255.apartment:GetConfigID()
						}
					})
				end

				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataMiniGame(2, arg2_255.score))
			elseif arg2_255.operationCode == "GAME_CLOSE" and arg2_255.doTrack == false then
				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataMiniGame(3))
			end
		end
	})
end

function var0_0.PerformanceQueue(arg0_267, arg1_267, arg2_267)
	local var0_267, var1_267 = pcall(function()
		return require("GameCfg.dorm." .. arg1_267)
	end)

	if not var0_267 then
		errorMsg("不存在表演ID对应的Lua:" .. arg1_267)
		existCall(arg2_267)

		return
	end

	warning(arg1_267)

	arg0_267.performanceInfo = {
		name = arg1_267
	}

	local var2_267 = {}

	table.insert(var2_267, function(arg0_269)
		arg0_267:SetUI(arg0_269, "blank")
	end)
	table.insertto(var2_267, underscore.map(var1_267, function(arg0_270)
		return switch(arg0_270.type, {
			function()
				return function(arg0_272)
					local var0_272 = unpack(arg0_270.params)

					arg0_267:DoTalk(var0_272, arg0_272, true)
				end
			end,
			function()
				return function(arg0_274)
					arg0_267.touchExitCall = arg0_274

					arg0_267:EnterTouchMode()
				end
			end,
			function()
				return function(arg0_276)
					local var0_276 = arg0_267.ladyDict[arg0_267.apartment:GetConfigID()]

					arg0_267:PlaySingleAction(var0_276, arg0_270.name, arg0_276)
				end
			end,
			function()
				return function(arg0_278)
					arg0_267:emit(arg0_267.PLAY_EXPRESSION, arg0_270)
					arg0_278()
				end
			end,
			function()
				return function(arg0_280)
					arg0_267:ShiftZone(arg0_270.name, arg0_280)
				end
			end,
			function()
				return function(arg0_282)
					arg0_267.contextData.timeIndex = arg0_270.params[1]

					if arg0_267.dormSceneMgr.artSceneInfo == arg0_267.dormSceneMgr.sceneInfo then
						arg0_267:SwitchDayNight(arg0_267.contextData.timeIndex)
						onNextTick(function()
							arg0_267:RefreshSlots()
						end)
					end

					arg0_267:UpdateContactState()
					onNextTick(arg0_282)
				end
			end,
			function()
				return function(arg0_285)
					if arg0_270.name then
						arg0_267:ActiveCameraByName(arg0_270.name)
						existCall(arg0_285)
					else
						arg0_267:ActiveStateCamera(arg0_270.params[1], arg0_285)
					end
				end
			end,
			function()
				return function(arg0_287)
					if arg0_270.name == "base" then
						arg0_267:ChangeArtScene(arg0_267.dormSceneMgr.sceneInfo, arg0_287)
					else
						local var0_287 = arg0_270.params.scene
						local var1_287 = arg0_270.params.sceneRoot

						arg0_267:ChangeArtScene(var0_287 .. "|" .. var1_287, arg0_287)
					end
				end
			end,
			function()
				return function(arg0_289)
					local var0_289 = arg0_270.params.name

					if arg0_270.name == "load" then
						func = tobool(arg0_270.params.wait_timeline) and function(arg0_290)
							arg0_267.waitForTimeline = arg0_290
						end

						arg0_267:LoadTimelineScene(var0_289, true, func, arg0_289)
					elseif arg0_270.name == "unload" then
						arg0_267:UnloadTimelineScene(var0_289, true, arg0_289)
					else
						assert(false)
					end
				end
			end,
			function()
				return function(arg0_292)
					setActive(arg0_267.uiContianer:Find("walk/btn_back"), false)

					local var0_292 = arg0_267.ladyDict[arg0_267.apartment:GetConfigID()]

					if arg0_270.name == "change" then
						local var1_292 = arg0_270.params.scene
						local var2_292 = arg0_270.params.sceneRoot

						var0_292.walkBornPoint = arg0_270.params.point or "Default"

						arg0_267:ChangeWalkScene(arg0_270.name, var1_292 .. "|" .. var2_292, arg0_292)
					elseif arg0_270.name == "back" then
						var0_292.walkBornPoint = nil

						arg0_267:ChangeWalkScene(arg0_270.name, arg0_267.dormSceneMgr.sceneInfo, arg0_292)
					elseif arg0_270.name == "set" then
						local function var3_292()
							local var0_293 = arg0_292

							arg0_292 = nil

							return existCall(var0_293)
						end

						for iter0_292, iter1_292 in pairs(arg0_270.params) do
							switch(iter0_292, {
								back_button_trigger = function(arg0_294)
									onButton(arg0_267, arg0_267.uiContianer:Find("walk/btn_back"), var3_292, SFX_DORM_BACK)
									setActive(arg0_267.uiContianer:Find("walk/btn_back"), IsUnityEditor and arg0_294)
								end,
								near_trigger = function(arg0_295)
									if arg0_295 == true then
										arg0_295 = 1.5
									end

									if arg0_295 then
										function arg0_267.walkNearCallback(arg0_296)
											if arg0_296 < arg0_295 then
												arg0_267.walkNearCallback = nil

												var3_292()
											end
										end
									else
										arg0_267.walkNearCallback = nil
									end
								end
							}, nil, iter1_292)
						end

						if arg0_267.firstMoveGuide then
							setActive(arg0_267.povLayer:Find("Guide"), arg0_267.firstMoveGuide)

							arg0_267.firstMoveGuide = nil
						end
					else
						assert(false)
					end
				end
			end,
			function()
				return function(arg0_298)
					if arg0_270.name == "set" then
						local var0_298 = arg0_267.ladyDict[arg0_267.apartment:GetConfigID()]

						arg0_267:SwitchIKConfig(var0_298, arg0_270.params.state)
						setActive(arg0_267.uiContianer:Find("ik/btn_back"), not arg0_270.params.hide_back)

						arg0_267.ikSpecialCall = arg0_298

						arg0_267:SetIKState(true)
					elseif arg0_270.name == "back" then
						local var1_298 = arg0_267.ladyDict[arg0_267.apartment:GetConfigID()]

						var1_298.ikConfig = arg0_270.params

						arg0_267:SetIKState(false, function()
							var1_298.ikConfig = nil

							existCall(arg0_298)
						end)
					else
						assert(false)
					end
				end
			end,
			function()
				return function(arg0_301)
					arg0_267.blackSceneInfo = setmetatable(arg0_270.params or {}, {
						__index = {
							color = "#000000",
							time = 0.3,
							delay = arg0_270.name == "show" and 0 or 0.5
						}
					})

					if arg0_270.name == "show" then
						arg0_267:ShowBlackScreen(true, arg0_301)
					elseif arg0_270.name == "hide" then
						arg0_267:ShowBlackScreen(false, arg0_301)
					else
						assert(false)
					end

					arg0_267.blackSceneInfo = nil
				end
			end
		})
	end))
	table.insert(var2_267, function(arg0_302)
		arg0_267:SetUI(arg0_302, "back")

		arg0_267.performanceInfo = nil
	end)
	seriesAsync(var2_267, arg2_267)
end

function var0_0.TriggerContact(arg0_303, arg1_303)
	arg0_303:emit(Dorm3dRoomMediator.COLLECTION_ITEM, {
		itemId = arg1_303,
		roomId = arg0_303.room:GetConfigID(),
		groupId = arg0_303.room:isPersonalRoom() and arg0_303.apartment:GetConfigID() or 0
	})
end

function var0_0.UpdateContactState(arg0_304)
	arg0_304:SetContactStateDic(arg0_304.room:getTriggerableCollectItemDic(arg0_304.contextData.timeIndex))
end

function var0_0.UpdateFavorDisplay(arg0_305)
	local var0_305, var1_305 = getProxy(ApartmentProxy):getStamina()

	setText(arg0_305.rtStaminaDisplay:Find("Text"), string.format("%d/%d", var0_305, var1_305))
	setActive(arg0_305.rtStaminaDisplay, false)

	if arg0_305.apartment then
		setText(arg0_305.rtFavorLevel:Find("rank/Text"), arg0_305.apartment.level)

		local var2_305, var3_305 = arg0_305.apartment:getFavor()
		local var4_305 = arg0_305.apartment:isMaxFavor()

		setActive(arg0_305.rtFavorLevel:Find("Max"), var4_305)
		setActive(arg0_305.rtFavorLevel:Find("Text"), not var4_305)
		setText(arg0_305.rtFavorLevel:Find("Text"), string.format("<color=#ff6698>%d</color>/%d", var2_305, var3_305))
	end

	setActive(arg0_305.rtFavorLevel:Find("red"), Dorm3dLevelLayer.IsShowRed())
end

function var0_0.UpdateBtnState(arg0_306)
	local var0_306 = not arg0_306.room:isPersonalRoom() or arg0_306:CheckSystemOpen("Furniture")
	local var1_306 = Dorm3dFurniture.IsTimelimitShopTip(arg0_306.room:GetConfigID())

	setActive(arg0_306.uiContianer:Find("base/left/btn_furniture/tipTimelimit"), var0_306 and var1_306)

	local var2_306 = Dorm3dFurniture.NeedViewTip(arg0_306.room:GetConfigID())

	setActive(arg0_306.uiContianer:Find("base/left/btn_furniture/tip"), var0_306 and not var1_306 and var2_306)
	setActive(arg0_306.uiContianer:Find("base/btn_back/main"), underscore(getProxy(ApartmentProxy):getRawData()):chain():values():filter(function(arg0_307)
		return tobool(arg0_307)
	end):any(function(arg0_308)
		return #arg0_308:getSpecialTalking() > 0 or arg0_308:getIconTip() == "main"
	end):value())
	setActive(arg0_306.uiContianer:Find("base/left/btn_collection/tip"), PlayerPrefs.GetInt("apartment_collection_item", 0) > 0 or PlayerPrefs.GetInt("apartment_collection_recall", 0) > 0)
end

function var0_0.AddUnlockDisplay(arg0_309, arg1_309)
	table.insert(arg0_309.unlockList, arg1_309)

	if not isActive(arg0_309.rtFavorUp) then
		setText(arg0_309.rtFavorUp:Find("Text"), table.remove(arg0_309.unlockList, 1))
		setActive(arg0_309.rtFavorUp, true)
	end
end

function var0_0.PopFavorTrigger(arg0_310, arg1_310)
	local var0_310 = arg1_310.triggerId
	local var1_310 = arg1_310.delta
	local var2_310 = arg1_310.cost
	local var3_310 = arg1_310.apartment
	local var4_310 = pg.dorm3d_favor_trigger[var0_310]

	if var4_310.is_repeat == 0 then
		if var0_310 == getDorm3dGameset("drom3d_favir_trigger_onwer")[1] then
			arg0_310:AddUnlockDisplay(i18n("dorm3d_own_favor"))
		elseif var0_310 == getDorm3dGameset("drom3d_favir_trigger_propose")[1] then
			arg0_310:AddUnlockDisplay(i18n("dorm3d_pledge_favor"))
		else
			arg0_310:AddUnlockDisplay(string.format("unknow favor trigger:%d unlock", var0_310))
		end
	elseif arg1_310.delta > 0 then
		local var5_310, var6_310 = var3_310:getFavor()
		local var7_310 = var5_310 + var1_310

		setText(arg0_310.rtFavorUpDaily:Find("bg/Text"), string.format("<size=48>+%d</size>", math.min(9999, var1_310)))
		setSlider(arg0_310.rtFavorUpDaily:Find("bg/slider"), 0, var6_310, var5_310)
		setAnchoredPosition(arg0_310.rtFavorUpDaily:Find("bg"), arg1_310.isGift and NewPos(-354, 223) or NewPos(-208, 105))

		local var8_310 = {}
		local var9_310 = arg0_310.rtFavorUpDaily:Find("bg/effect")

		eachChild(var9_310, function(arg0_311)
			setActive(arg0_311, false)
		end)

		local var10_310

		if var4_310.effect and var4_310.effect ~= "" then
			var10_310 = var9_310:Find(var4_310.effect .. "(Clone)")

			if not var10_310 then
				table.insert(var8_310, function(arg0_312)
					LoadAndInstantiateAsync("Dorm3D/Effect/Prefab/ExpressionUI", "uifx_dorm3d_yinfu01", function(arg0_313)
						setParent(arg0_313, var9_310)

						var10_310 = tf(arg0_313)

						arg0_312()
					end)
				end)
			else
				setActive(var10_310, true)
			end
		end

		local var11_310 = arg0_310.rtFavorUpDaily:GetComponent("DftAniEvent")

		var11_310:SetTriggerEvent(function(arg0_314)
			local var0_314 = GetComponent(arg0_310.rtFavorUpDaily:Find("bg/slider"), typeof(Slider))

			LeanTween.value(var5_310, var7_310, 0.5):setOnUpdate(System.Action_float(function(arg0_315)
				var0_314.value = arg0_315
			end)):setEase(LeanTweenType.easeInOutQuad):setDelay(0.165):setOnComplete(System.Action(function()
				LeanTween.delayedCall(0.165, System.Action(function()
					if arg0_310.exited then
						return
					end

					quickPlayAnimator(arg0_310.rtFavorUpDaily, "favor_out")
				end))
			end))
			pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_progaress_bar")
		end)
		var11_310:SetEndEvent(function(arg0_318)
			setActive(arg0_310.rtFavorUpDaily, false)
		end)
		seriesAsync(var8_310, function()
			local var0_319 = arg0_310.ladyDict[var3_310:GetConfigID()]

			setLocalPosition(arg0_310.rtFavorUpDaily, arg0_310:GetLocalPosition(arg0_310:GetScreenPosition(var0_319.ladyHeadCenter.position), arg0_310.rtFavorUpDaily.parent))
			setActive(arg0_310.rtFavorUpDaily, true)
			SetCompomentEnabled(arg0_310.rtFavorUpDaily, typeof(Animator), true)
			quickPlayAnimator(arg0_310.rtFavorUpDaily, "favor_open")

			if var2_310 > 0 then
				local var1_319, var2_319 = getProxy(ApartmentProxy):getStamina()

				setText(arg0_310.rtStaminaPop:Find("Text/Text (1)"), "-" .. var2_310)
				setText(arg0_310.rtStaminaPop:Find("Text"), string.format("%d/%d", var1_319 + var2_310, var2_319))
				setActive(arg0_310.rtStaminaPop, true)
			end
		end)
	end
end

function var0_0.PopFavorLevelUp(arg0_320, arg1_320, arg2_320, arg3_320)
	arg0_320.isLock = true

	LeanTween.delayedCall(0.33, System.Action(function()
		arg0_320.isLock = false
	end))

	local var0_320 = math.floor(arg1_320.level / 10)
	local var1_320 = math.fmod(arg1_320.level, 10)

	GetImageSpriteFromAtlasAsync("ui/favor_atlas", var1_320, arg0_320.rtLevelUpWindow:Find("panel/bg/item1/mark/level/digit2"))
	GetImageSpriteFromAtlasAsync("ui/favor_atlas", var0_320, arg0_320.rtLevelUpWindow:Find("panel/bg/item1/mark/level/digit1"))
	setActive(arg0_320.rtLevelUpWindow:Find("panel/bg/item1/mark/level/digit1"), var0_320 > 0)

	local var2_320
	local var3_320

	arg0_320.clientAward, var3_320 = Dorm3dIconHelper.SplitStory(arg1_320:getFavorConfig("levelup_client_item", arg1_320.level))
	arg0_320.serverAward = arg2_320

	local var4_320 = arg0_320.rtLevelUpWindow:Find("panel/info/content/itemContent")

	if not arg0_320.levelItemList then
		arg0_320.levelItemList = UIItemList.New(var4_320, var4_320:Find("tpl"))

		arg0_320.levelItemList:make(function(arg0_322, arg1_322, arg2_322)
			local var0_322 = arg1_322 + 1

			if arg0_322 == UIItemList.EventUpdate then
				if arg1_322 < #arg0_320.serverAward then
					updateDorm3dIcon(arg2_322, arg0_320.serverAward[var0_322])
					onButton(arg0_320, arg2_322, function()
						arg0_320:emit(BaseUI.ON_NEW_DROP, {
							drop = arg0_320.serverAward[var0_322]
						})
					end, SFX_PANEL)
				else
					Dorm3dIconHelper.UpdateDorm3dIcon(arg2_322, arg0_320.clientAward[var0_322 - #arg0_320.serverAward])
					onButton(arg0_320, arg2_322, function()
						arg0_320:emit(Dorm3dRoomMediator.ON_DROP_CLIENT, {
							data = arg0_320.clientAward[var0_322 - #arg0_320.serverAward]
						})
					end, SFX_PANEL)
				end
			end
		end)
	end

	arg0_320.levelItemList:align(#arg0_320.serverAward + #arg0_320.clientAward)
	setActive(arg0_320.rtLevelUpWindow, true)
	pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_upgrade")
	pg.UIMgr.GetInstance():OverlayPanel(arg0_320.rtLevelUpWindow, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_DORM3D
	})

	function arg0_320.levelUpCallback()
		arg0_320.levelUpCallback = nil

		if var3_320 then
			arg0_320:PopNewStoryTip(var3_320)
		end

		existCall(arg3_320)
	end
end

function var0_0.PopNewStoryTip(arg0_326, arg1_326, arg2_326)
	local var0_326 = arg0_326.uiContianer:Find("base/top/story_tip")

	setActive(var0_326, true)
	LeanTween.delayedCall(1, System.Action(function()
		setActive(var0_326, false)
	end))
	setText(var0_326:Find("Text"), i18n("dorm3d_story_unlock_tip", pg.dorm3d_recall[arg1_326[2]].name))
	existCall(arg2_326)
end

function var0_0.UpdateZoneList(arg0_328)
	local var0_328

	if arg0_328.room:isPersonalRoom() then
		var0_328 = arg0_328.ladyDict[arg0_328.apartment:GetConfigID()].ladyBaseZone
	else
		var0_328 = arg0_328:GetAttachedFurnitureName()
	end

	for iter0_328, iter1_328 in ipairs(arg0_328.zoneDatas) do
		if iter1_328:GetWatchCameraName() == var0_328 then
			setText(arg0_328.btnZone:Find("Text"), iter1_328:GetName())
			setTextColor(arg0_328.rtZoneList:GetChild(iter0_328 - 1):Find("Name"), Color.NewHex("5CCAFF"))
		else
			setTextColor(arg0_328.rtZoneList:GetChild(iter0_328 - 1):Find("Name"), Color.NewHex("FFFFFF99"))
		end
	end
end

function var0_0.TalkingEventHandle(arg0_329, arg1_329)
	local var0_329 = {}
	local var1_329 = {}
	local var2_329 = arg1_329.data

	if var2_329.op_list then
		for iter0_329, iter1_329 in ipairs(var2_329.op_list) do
			table.insert(var0_329, function(arg0_330)
				local function var0_330()
					local var0_331 = arg0_330

					arg0_330 = nil

					return existCall(var0_331)
				end

				switch(iter1_329.type, {
					action = function()
						local var0_332 = arg0_329.ladyDict[arg0_329.apartment:GetConfigID()]

						arg0_329:PlaySingleAction(var0_332, iter1_329.name, var0_330)
					end,
					item_action = function()
						arg0_329:PlaySceneItemAnim(iter1_329.id, iter1_329.name)
						var0_330()
					end,
					extra_item_action = function()
						local var0_334 = arg0_329.ladyDict[arg0_329.apartment:GetConfigID()].extraItems[iter1_329.name]

						warning(iter1_329.name)
						warning(var0_334.trans)

						if var0_334 then
							var0_334.trans:GetComponent(typeof(Animator)):PlayInFixedTime(iter1_329.param)
						end

						var0_330()
					end,
					timeline = function()
						if arg0_329.inTouchGame then
							setActive(arg0_329.rtTouchGamePanel, false)
						end

						arg0_329:PlayTimeline(iter1_329, function(arg0_336, arg1_336)
							setActive(arg0_329.rtTouchGamePanel, arg0_329.inTouchGame)

							var1_329.notifiCallback = arg1_336

							var0_330()
						end)
					end,
					clickOption = function()
						arg0_329:DoTalkTouchOption(iter1_329, arg1_329.flags, function(arg0_338)
							var1_329.optionIndex = arg0_338

							var0_330()
						end)
					end,
					wait = function()
						arg0_329.LTs = arg0_329.LTs or {}

						table.insert(arg0_329.LTs, LeanTween.delayedCall(iter1_329.time, System.Action(var0_330)).uniqueId)
					end,
					expression = function()
						arg0_329:emit(arg0_329.PLAY_EXPRESSION, iter1_329)
						var0_330()
					end
				}, function()
					assert(false, "op type error:", iter1_329.type)
				end)

				if iter1_329.skip then
					var0_330()
				end
			end)
		end
	end

	seriesAsync(var0_329, function()
		if arg1_329.callbackData then
			arg0_329:emit(Dorm3dRoomMediator.TALKING_EVENT_FINISH, arg1_329.callbackData.name, var1_329)
		end
	end)
end

function var0_0.CheckQueue(arg0_343)
	if arg0_343.inGuide or arg0_343.uiState ~= "base" then
		return
	end

	if arg0_343.room:GetConfigID() == 1 and arg0_343:CheckGuide() then
		-- block empty
	elseif arg0_343.room:isPersonalRoom() and arg0_343:CheckLevelUp() then
		-- block empty
	elseif arg0_343.apartment and arg0_343:CheckEnterDeal() then
		-- block empty
	elseif arg0_343.apartment and arg0_343:CheckActiveTalk() then
		-- block empty
	elseif arg0_343.apartment then
		arg0_343:CheckFavorTrigger()
	end

	arg0_343.contextData.hasEnterCheck = true
end

function var0_0.didEnterCheck(arg0_344)
	local var0_344

	if arg0_344.contextData.specialId then
		var0_344 = arg0_344.contextData.specialId
		arg0_344.contextData.specialId = nil

		arg0_344:DoTalk(var0_344, function()
			arg0_344:closeView()
		end)
	elseif not arg0_344.contextData.hasEnterCheck and arg0_344.apartment then
		for iter0_344, iter1_344 in ipairs(arg0_344.apartment:getForceEnterTalking(arg0_344.room:GetConfigID())) do
			var0_344 = iter1_344

			arg0_344:DoTalk(iter1_344)

			break
		end
	end

	if var0_344 and pg.dorm3d_dialogue_group[var0_344].extend_loading > 0 then
		arg0_344.contextData.hasEnterCheck = true

		pg.SceneAnimMgr.GetInstance():RegisterDormNextCall(function()
			arg0_344:FinishEnterResume()
		end)
	else
		if arg0_344.apartment and arg0_344.contextData.pendingDic[arg0_344.apartment:GetConfigID()] then
			arg0_344.contextData.hasEnterCheck = true
		end

		for iter2_344, iter3_344 in pairs(arg0_344.contextData.pendingDic) do
			arg0_344:SetInPending(arg0_344.ladyDict[iter2_344], iter3_344)
		end

		arg0_344.contextData.pendingDic = {}

		arg0_344:FinishEnterResume()
		arg0_344:CheckQueue()
	end
end

function var0_0.CheckGuide(arg0_347)
	if arg0_347:GetBlackboardValue(arg0_347.ladyDict[arg0_347.apartment:GetConfigID()], "inPending") then
		return
	end

	for iter0_347, iter1_347 in ipairs({
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
				return arg0_347:CheckSystemOpen("Furniture")
			end
		},
		{
			name = "DORM3D_GUIDE_07",
			active = function()
				return arg0_347:CheckSystemOpen("DayNight")
			end
		}
	}) do
		if not pg.NewStoryMgr.GetInstance():IsPlayed(iter1_347.name) and iter1_347.active() then
			arg0_347:SetAllBlackbloardValue("inGuide", true)

			local function var0_347()
				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(2, pg.NewStoryMgr.GetInstance():StoryName2StoryId(iter1_347.name)))
				arg0_347:SetAllBlackbloardValue("inGuide", false)
			end

			pg.m02:sendNotification(GAME.STORY_UPDATE, {
				storyId = iter1_347.name
			})
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(1, pg.NewStoryMgr.GetInstance():StoryName2StoryId(iter1_347.name)))
			pg.NewGuideMgr.GetInstance():Play(iter1_347.name, nil, var0_347, var0_347)

			return true
		end
	end

	return false
end

function var0_0.CheckFavorTrigger(arg0_353)
	for iter0_353, iter1_353 in ipairs({
		{
			triggerId = getDorm3dGameset("drom3d_favir_trigger_onwer")[1],
			active = function()
				local var0_354 = getProxy(CollectionProxy):getShipGroup(arg0_353.apartment.configId)

				return tobool(var0_354)
			end
		},
		{
			triggerId = getDorm3dGameset("drom3d_favir_trigger_propose")[1],
			active = function()
				local var0_355 = getProxy(CollectionProxy):getShipGroup(arg0_353.apartment.configId)

				return var0_355 and var0_355.married > 0
			end
		}
	}) do
		if arg0_353.apartment.triggerCountDic[iter1_353.triggerId] == 0 and iter1_353.active() then
			arg0_353:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_353.apartment.configId, iter1_353.triggerId)
		end
	end
end

function var0_0.CheckEnterDeal(arg0_356)
	if arg0_356.contextData.hasEnterCheck then
		return false
	end

	local var0_356 = arg0_356.apartment:GetConfigID()
	local var1_356 = "dorm3d_enter_count_" .. var0_356
	local var2_356 = pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d")

	if PlayerPrefs.GetString("dorm3d_enter_count_day") ~= var2_356 then
		PlayerPrefs.SetString("dorm3d_enter_count_day", var2_356)
		PlayerPrefs.SetInt(var1_356, 1)
	else
		PlayerPrefs.SetInt(var1_356, PlayerPrefs.GetInt(var1_356, 0) + 1)
	end

	local var3_356 = arg0_356.apartment:getEnterTalking(arg0_356.room:GetConfigID())

	PlayerPrefs.SetString("DORM3D_DAILY_ENTER", pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d"))

	if #var3_356 > 0 then
		arg0_356:DoTalk(var3_356[math.random(#var3_356)])

		return true
	end
end

function var0_0.CheckActiveTalk(arg0_357)
	local var0_357 = arg0_357.ladyDict[arg0_357.apartment:GetConfigID()]

	if arg0_357:GetBlackboardValue(var0_357, "inPending") then
		return false
	end

	local var1_357 = arg0_357.apartment:getZoneTalking(arg0_357.room:GetConfigID(), var0_357.ladyBaseZone)

	if #var1_357 > 0 then
		arg0_357:DoTalk(var1_357[1])

		return true
	else
		return false
	end
end

function var0_0.CheckDistanceTalk(arg0_358, arg1_358, arg2_358)
	local var0_358 = arg0_358.ladyDict[arg1_358].ladyBaseZone
	local var1_358 = getProxy(ApartmentProxy):getApartment(arg1_358)

	for iter0_358, iter1_358 in ipairs(var1_358:getDistanceTalking(arg0_358.room:GetConfigID(), var0_358)) do
		arg0_358:DoTalk(iter1_358)

		return
	end
end

function var0_0.CheckSystemOpen(arg0_359, arg1_359)
	if arg0_359.room:isPersonalRoom() then
		return switch(arg1_359, {
			Talk = function()
				local var0_360 = 1

				return var0_360 <= arg0_359.apartment.level, i18n("apartment_level_unenough", var0_360)
			end,
			Touch = function()
				local var0_361 = getDorm3dGameset("drom3d_touch_dialogue")[1]

				return var0_361 <= arg0_359.apartment.level, i18n("apartment_level_unenough", var0_361)
			end,
			Gift = function()
				local var0_362 = getDorm3dGameset("drom3d_gift_dialogue")[1]

				return var0_362 <= arg0_359.apartment.level, i18n("apartment_level_unenough", var0_362)
			end,
			PublicGame = function()
				return false
			end,
			Photo = function()
				local var0_364 = getDorm3dGameset("drom3d_photograph_unlock")[1]

				return var0_364 <= arg0_359.apartment.level, i18n("apartment_level_unenough", var0_364)
			end,
			Collection = function()
				local var0_365 = getDorm3dGameset("drom3d_recall_unlock")[1]

				return var0_365 <= arg0_359.apartment.level, i18n("apartment_level_unenough", var0_365)
			end,
			Furniture = function()
				local var0_366 = getDorm3dGameset("drom3d_furniture_unlock")[1]

				return var0_366 <= arg0_359.apartment.level, i18n("apartment_level_unenough", var0_366)
			end,
			DayNight = function()
				local var0_367 = getDorm3dGameset("drom3d_time_unlock")[1]

				return var0_367 <= arg0_359.apartment.level, i18n("apartment_level_unenough", var0_367)
			end,
			Accompany = function()
				local var0_368 = 1

				return var0_368 <= arg0_359.apartment.level, i18n("apartment_level_unenough", var0_368)
			end,
			MiniGame = function()
				local var0_369 = 1

				if var0_369 > arg0_359.apartment.level then
					return false, i18n("apartment_level_unenough", var0_369)
				elseif #arg0_359.room:getMiniGames() <= 0 then
					return false, "without minigame config in room:" .. arg0_359.room.configId
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
		return switch(arg1_359, {
			Gift = function()
				return false
			end,
			PublicGame = function()
				return true
			end,
			Furniture = function()
				local var0_375 = arg0_359.room:GetFurnitureIDList()

				return var0_375 and #var0_375 > 0
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

function var0_0.CheckLevelUp(arg0_381)
	if arg0_381.apartment:canLevelUp() then
		arg0_381:emit(Dorm3dRoomMediator.FAVOR_LEVEL_UP, arg0_381.apartment.configId)

		return true
	end

	return false
end

function var0_0.GetIKHandTF(arg0_382)
	return arg0_382.ikHand
end

function var0_0.CycleIKCameraGroup(arg0_383)
	local var0_383 = arg0_383.ladyDict[arg0_383.apartment:GetConfigID()]

	assert(arg0_383:GetBlackboardValue(var0_383, "inIK"))
	seriesAsync({
		function(arg0_384)
			pg.IKMgr.GetInstance():ResetActiveIKs()

			local var0_384 = var0_383.ikConfig
			local var1_384 = var0_384.camera_group
			local var2_384 = pg.dorm3d_ik_status.get_id_list_by_camera_group[var1_384]
			local var3_384 = var2_384[table.indexof(var2_384, var0_384.id) % #var2_384 + 1]

			arg0_383:SwitchIKConfig(var0_383, var3_384)
			arg0_383:SetIKState(true)
		end
	})
end

function var0_0.TempHideUI(arg0_385, arg1_385, arg2_385)
	local var0_385 = defaultValue(arg0_385.hideCount, 0)

	arg0_385.hideCount = var0_385 + (arg1_385 and 1 or -1)

	assert(arg0_385.hideCount >= 0)

	if arg0_385.hideCount * var0_385 > 0 then
		return existCall(arg2_385)
	elseif arg0_385.hideCount > 0 then
		arg0_385:SetUI(arg2_385, "blank")
	else
		arg0_385:SetUI(arg2_385, "back")
	end
end

function var0_0.onBackPressed(arg0_386)
	if arg0_386.exited or arg0_386.retainCount > 0 then
		-- block empty
	elseif isActive(arg0_386.rtLevelUpWindow) then
		triggerButton(arg0_386.rtLevelUpWindow:Find("bg"))
	elseif arg0_386.uiState ~= "base" then
		-- block empty
	else
		arg0_386:closeView()
	end
end

function var0_0.willExit(arg0_387)
	if arg0_387.downTimer then
		arg0_387.downTimer:Stop()

		arg0_387.downTimer = nil
	end

	if arg0_387.LTs then
		underscore.map(arg0_387.LTs, function(arg0_388)
			LeanTween.cancel(arg0_388)
		end)

		arg0_387.LTs = nil
	end

	if arg0_387.sliderLT then
		LeanTween.cancel(arg0_387.sliderLT)

		arg0_387.sliderLT = nil
	end

	for iter0_387, iter1_387 in pairs(arg0_387.ladyDict) do
		iter1_387.wakeUpTalkId = nil
	end

	if arg0_387.accompanyFavorTimer then
		arg0_387.accompanyFavorTimer:Stop()

		arg0_387.accompanyFavorTimer = nil
	end

	if arg0_387.accompanyPerformanceTimer then
		arg0_387.accompanyPerformanceTimer:Stop()

		arg0_387.accompanyPerformanceTimer = nil
	end

	arg0_387.canTriggerAccompanyPerformance = nil

	arg0_387.videoPlayer:Destroy()
	var0_0.super.willExit(arg0_387)
end

return var0_0
