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

function var0_0.BindEvent(arg0_81)
	var0_0.super.BindEvent(arg0_81)
	arg0_81:bind(arg0_81.CLICK_CHARACTER, function(arg0_82, arg1_82)
		if arg0_81.uiState ~= "base" or not arg0_81.ladyDict[arg1_82].nowCanWatchState then
			return
		end

		local var0_82 = {}
		local var1_82 = arg0_81.ladyDict[arg1_82]

		if arg0_81:GetBlackboardValue(var1_82, "inPending") then
			table.insert(var0_82, function(arg0_83)
				arg0_81:OutOfPending(arg1_82, arg0_83)
			end)
		else
			table.insert(var0_82, function(arg0_84)
				arg0_81:OutOfLazy(arg1_82, arg0_84)
			end)
		end

		seriesAsync(var0_82, function()
			if not arg0_81.room:isPersonalRoom() then
				arg0_81:SetApartment(getProxy(ApartmentProxy):getApartment(arg1_82))
			end

			arg0_81:EnterWatchMode()
		end)
		pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_touch_v1")
	end)
	arg0_81:bind(arg0_81.CLICK_CONTACT, function(arg0_86, arg1_86)
		arg0_81:TriggerContact(arg1_86)
	end)
	arg0_81:bind(arg0_81.DISTANCE_TRIGGER, function(arg0_87, arg1_87, arg2_87)
		if arg0_81.uiState == "base" then
			arg0_81:CheckDistanceTalk(arg1_87, arg2_87)
		end
	end)
	arg0_81:bind(arg0_81.WALK_DISTANCE_TRIGGER, function(arg0_88, arg1_88, arg2_88)
		if arg0_81.apartment and arg0_81.apartment:GetConfigID() == arg1_88 then
			existCall(arg0_81.walkNearCallback, arg2_88)
		end
	end)
	arg0_81:bind(arg0_81.CHANGE_WATCH, function(arg0_89, arg1_89)
		arg0_81:ChangeCanWatchState(arg0_81.ladyDict[arg1_89])
	end)
	arg0_81:bind(arg0_81.ON_TOUCH_CHARACTER, function(arg0_90, arg1_90)
		local var0_90 = arg0_81.ladyDict[arg0_81.apartment:GetConfigID()]

		if not arg0_81:GetBlackboardValue(var0_90, "inIK") then
			return
		end

		arg0_81:OnTouchCharacterBody(arg1_90)
	end)
	arg0_81:bind(var0_0.ON_IK_STATUS_CHANGED, function(arg0_91, arg1_91, arg2_91)
		local var0_91 = arg0_81.ladyDict[arg0_81.apartment:GetConfigID()]

		if not arg0_81:GetBlackboardValue(var0_91, "inTouching") then
			return
		end

		arg0_81:DoTouch(arg1_91, arg2_91)
	end)
	arg0_81:bind(arg0_81.ON_ENTER_SECTOR, function(arg0_92, arg1_92)
		arg0_81:ChangeCanWatchState(arg0_81.ladyDict[arg1_92])
	end)
	arg0_81:bind(arg0_81.ON_CHANGE_DISTANCE, function(arg0_93, arg1_93, arg2_93)
		arg0_81:ChangeCanWatchState(arg0_81.ladyDict[arg1_93])
	end)
end

function var0_0.didEnter(arg0_94)
	arg0_94.resumeCallback = arg0_94.contextData.resumeCallback
	arg0_94.contextData.resumeCallback = nil

	var0_0.super.didEnter(arg0_94)
	arg0_94:UpdateZoneList()
	arg0_94:SetUI(function()
		arg0_94:didEnterCheck()
	end, "base")
end

function var0_0.FinishEnterResume(arg0_96)
	if not arg0_96.resumeCallback then
		return
	end

	local var0_96 = arg0_96.resumeCallback

	arg0_96.resumeCallback = nil

	return var0_96()
end

function var0_0.EnableJoystick(arg0_97, arg1_97)
	setActive(arg0_97._joystick, arg1_97)
end

function var0_0.EnablePOVLayer(arg0_98, arg1_98)
	setActive(arg0_98.povLayer, arg1_98)

	if not arg1_98 then
		arg0_98:emit(arg0_98.ON_POV_STICK_MOVE_END)
	end
end

function var0_0.SetUIStore(arg0_99, arg1_99, ...)
	table.insertto(arg0_99.uiStore, {
		...
	})
	existCall(arg1_99)
end

function var0_0.SetUI(arg0_100, arg1_100, ...)
	while rawget(arg0_100, "class") ~= var0_0 do
		arg0_100 = getmetatable(arg0_100).__index
	end

	table.insertto(arg0_100.uiStore, {
		...
	})

	for iter0_100, iter1_100 in ipairs(arg0_100.uiStore) do
		if iter1_100 == "back" then
			assert(#arg0_100.uiStack > 0)

			arg0_100.uiState = table.remove(arg0_100.uiStack)
		elseif iter1_100 == arg0_100.uiState and iter1_100 == "ik" then
			-- block empty
		else
			table.insert(arg0_100.uiStack, arg0_100.uiState)

			arg0_100.uiState = iter1_100
		end
	end

	pg.m02:sendNotification(var0_0.NOTIFY_UI_STATE, arg0_100.uiState)

	arg0_100.uiStore = {}

	eachChild(arg0_100.uiContianer, function(arg0_101)
		setActive(arg0_101, arg0_101.name == arg0_100.uiState)
	end)
	arg0_100:EnablePOVLayer(arg0_100.uiState == "base" or arg0_100.uiState == "walk")
	arg0_100:TempHideContact(arg0_100.uiState ~= "base")
	arg0_100:SetFloatEnable(arg0_100.uiState == "walk")
	setActive(arg0_100.rtFloatPage, arg0_100.uiState == "walk")
	setActive(arg0_100.ikControlUI, arg0_100.uiState == "ik")
	switch(arg0_100.uiState, {
		base = function()
			if not arg0_100.room:isPersonalRoom() then
				arg0_100:SetApartment(nil)
			end

			arg0_100:UpdateBtnState()
		end,
		watch = function()
			eachChild(arg0_100.rtRole, function(arg0_104)
				setActive(arg0_104, false)
			end)

			local var0_103 = underscore.filter({
				"Talk",
				"Touch",
				"Gift",
				"MiniGame",
				"PublicGame",
				"Performance"
			}, function(arg0_105)
				return arg0_100:CheckSystemOpen(arg0_105)
			end)
			local var1_103 = 0.05

			for iter0_103, iter1_103 in ipairs(var0_103) do
				LeanTween.delayedCall(var1_103, System.Action(function()
					setActive(arg0_100.rtRole:Find(iter1_103), true)
				end))

				var1_103 = var1_103 + 0.066
			end

			setActive(arg0_100.rtRole:Find("Gift/bg/Tip"), Dorm3dGift.NeedViewTip(arg0_100.apartment:GetConfigID()))
		end,
		ik = function()
			setActive(arg0_100.uiContianer:Find("ik/Right/MenuSmall"), arg0_100.room:isPersonalRoom() and not arg0_100.performanceInfo)
			setActive(arg0_100.uiContianer:Find("ik/Right/Menu"), false)
		end,
		walk = function()
			setText(arg0_100.uiContianer:Find("walk/dialogue/content"), i18n("dorm3d_removable", arg0_100.apartment:getConfig("name")))
		end
	})
	arg0_100:ActiveStateCamera(arg0_100.uiState, function()
		if arg1_100 then
			arg1_100()
		elseif arg0_100.uiState == "base" then
			arg0_100:CheckQueue()
		end
	end)
end

function var0_0.EnterWatchMode(arg0_110)
	local var0_110 = arg0_110.apartment:GetConfigID()

	seriesAsync({
		function(arg0_111)
			arg0_110:emit(arg0_110.SHOW_BLOCK)
			arg0_110:SetBlackboardValue(arg0_110.ladyDict[var0_110], "inWatchMode", true)
			arg0_110:SetUI(arg0_111, "watch")
		end,
		function(arg0_112)
			arg0_110:emit(arg0_110.HIDE_BLOCK)
		end
	})
end

function var0_0.ExitWatchMode(arg0_113)
	local var0_113 = arg0_113.apartment:GetConfigID()

	seriesAsync({
		function(arg0_114)
			arg0_113:emit(arg0_113.SHOW_BLOCK)
			arg0_113:SetUI(arg0_114, "back")
		end,
		function(arg0_115)
			arg0_113:SetBlackboardValue(arg0_113.ladyDict[var0_113], "inWatchMode", false)
			arg0_113:emit(arg0_113.HIDE_BLOCK)
			arg0_113:CheckQueue()
		end
	})
end

function var0_0.SetInPending(arg0_116, arg1_116, arg2_116)
	local var0_116 = arg0_116:GetBlackboardValue(arg1_116, "groupId")
	local var1_116 = pg.dorm3d_welcome[arg2_116]

	arg0_116:SetBlackboardValue(arg1_116, "inPending", true)
	arg0_116:ChangeCanWatchState(arg1_116)
	arg0_116:EnableHeadIK(arg1_116, false)

	arg0_116.contextData.ladyZone[var0_116] = var1_116.area

	arg1_116:SetZone(arg0_116.contextData.ladyZone[var0_116], var1_116.welcome_staypoint)
	arg0_116:ChangeCharacterPosition(arg1_116)

	if var1_116.item_shield ~= "" then
		arg0_116.hideItemDic = {}

		for iter0_116, iter1_116 in ipairs(var1_116.item_shield) do
			local var2_116 = arg0_116.modelRoot:Find(iter1_116)

			if not var2_116 then
				warning(string.format("welcome:%d without hide item:%s", arg2_116, iter1_116))
			else
				arg0_116.hideItemDic[iter1_116] = isActive(var2_116)

				setActive(var2_116, false)
			end
		end
	end

	onNextTick(function()
		if arg1_116.tfPendintItem then
			setActive(arg1_116.tfPendintItem, true)
		end

		arg0_116:SwitchAnim(arg1_116, var1_116.welcome_idle)
	end)

	arg0_116.wakeUpTalkId = var1_116.welcome_talk
end

function var0_0.SetOutPending(arg0_118, arg1_118)
	arg0_118:SetBlackboardValue(arg1_118, "inPending", false)
	arg0_118:ChangeCanWatchState(arg1_118)
	arg0_118:EnableHeadIK(arg1_118, true)

	arg0_118.wakeUpTalkId = nil

	if arg1_118.tfPendintItem then
		setActive(arg1_118.tfPendintItem, false)
	end

	if arg0_118.hideItemDic then
		for iter0_118, iter1_118 in pairs(arg0_118.hideItemDic) do
			setActive(arg0_118.modelRoot:Find(iter0_118), iter1_118)
		end

		arg0_118.hideItemDic = nil
	end
end

function var0_0.IsModeInHidePending(arg0_119, arg1_119)
	for iter0_119, iter1_119 in pairs(arg0_119.ladyDict) do
		if iter1_119.hideItemDic and iter1_119.hideItemDic[arg1_119] ~= nil then
			return true
		end
	end

	return false
end

function var0_0.EnterAccompanyMode(arg0_120, arg1_120)
	local var0_120 = pg.dorm3d_accompany[arg1_120]
	local var1_120
	local var2_120

	if var0_120.sceneInfo ~= "" then
		var1_120, var2_120 = unpack(string.split(var0_120.sceneInfo, "|"))
	end

	local var3_120 = {
		type = "timeline",
		name = var0_120.timeline,
		scene = var1_120,
		sceneRoot = var2_120,
		accompanys = {}
	}

	for iter0_120, iter1_120 in ipairs(var0_120.jump_trigger) do
		local var4_120, var5_120 = unpack(iter1_120)

		var3_120.accompanys[var4_120] = var5_120
	end

	local var6_120, var7_120 = unpack(var0_120.favor)

	getProxy(Dorm3dChatProxy):TriggerEvent({
		{
			value = 1,
			event_type = 161,
			ship_id = arg0_120.apartment:GetConfigID()
		}
	})
	getProxy(ApartmentProxy):RecordAccompanyTime()
	pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataAccompany(1, var0_120.ship_id, var0_120.performance_time, 0, var1_120 or arg0_120.dormSceneMgr.artSceneInfo))

	local var8_120 = {}

	table.insert(var8_120, function(arg0_121)
		arg0_120:SetUI(arg0_121, "blank", "accompany")
	end)
	table.insert(var8_120, function(arg0_122)
		arg0_120.accompanyFavorCount = 0
		arg0_120.accompanyFavorTimer = Timer.New(function()
			arg0_120.accompanyFavorCount = arg0_120.accompanyFavorCount + 1
		end, var6_120, -1)

		arg0_120.accompanyFavorTimer:Start()

		arg0_120.accompanyPerformanceTimer = Timer.New(function()
			arg0_120.canTriggerAccompanyPerformance = true
		end, var0_120.performance_time, -1)

		arg0_120.accompanyPerformanceTimer:Start()
		arg0_120:PlayTimeline(var3_120, function(arg0_125, arg1_125)
			arg1_125()
			arg0_122()
		end)
	end)
	seriesAsync(var8_120, function()
		assert(arg0_120.accompanyFavorTimer)
		arg0_120.accompanyFavorTimer:Stop()

		arg0_120.accompanyFavorTimer = nil

		assert(arg0_120.accompanyPerformanceTimer)
		arg0_120.accompanyPerformanceTimer:Stop()

		arg0_120.accompanyPerformanceTimer = nil
		arg0_120.canTriggerAccompanyPerformance = nil

		local var0_126 = math.min(arg0_120.accompanyFavorCount, getProxy(ApartmentProxy):getStamina())

		if var0_126 > 0 then
			local var1_126 = var7_120[var0_126]

			warning(var1_126)
			arg0_120:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_120.apartment.configId, var1_126)
		end

		local var2_126 = 0
		local var3_126 = getProxy(ApartmentProxy):GetAccompanyTime()

		if var3_126 then
			var2_126 = pg.TimeMgr.GetInstance():GetServerTime() - var3_126
		end

		pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataAccompany(2, var0_120.ship_id, var0_120.performance_time, var2_126, var1_120 or arg0_120.dormSceneMgr.artSceneInfo))
		arg0_120:SetUI(nil, "back", "back")
	end)
end

function var0_0.ExitAccompanyMode(arg0_127)
	existCall(arg0_127.timelineFinishCall)
end

function var0_0.EnterTouchPerformance(arg0_128)
	local var0_128 = arg0_128.ladyDict[arg0_128.apartment:GetConfigID()]
	local var1_128 = arg0_128.room:getApartmentZoneConfig(var0_128.ladyBaseZone, "touch_performance", arg0_128.apartment:GetConfigID())

	if not var1_128 or var1_128 == 0 then
		arg0_128:EnterTouchMode()
	else
		arg0_128:DoTalk(var1_128)
	end
end

function var0_0.EnterTouchMode(arg0_129)
	local var0_129 = arg0_129.ladyDict[arg0_129.apartment:GetConfigID()]

	if arg0_129:GetBlackboardValue(var0_129, "inTouching") then
		return
	end

	local var1_129 = arg0_129.room:getApartmentZoneConfig(var0_129.ladyBaseZone, "touch_id", arg0_129.apartment:GetConfigID())

	arg0_129.touchConfig = pg.dorm3d_touch_data[var1_129]

	if not arg0_129.touchConfig then
		arg0_129:EnterTimelineTouchMode()

		return
	end

	arg0_129.inTouchGame = arg0_129.touchConfig.heartbeat_enable > 0

	setActive(arg0_129.rtTouchGamePanel, arg0_129.inTouchGame)

	if arg0_129.inTouchGame then
		arg0_129.touchCount = 0
		arg0_129.touchLevel = 1
		arg0_129.lastCount = 0
		arg0_129.topCount = 0

		arg0_129:UpdateTouchGameDisplay()
		setSlider(arg0_129.rtTouchGamePanel:Find("slider"), 0, 100, arg0_129.touchCount >= 200 and 100 or arg0_129.touchCount % 100)
		quickPlayAnimation(arg0_129.rtTouchGamePanel, "anim_dorm3d_touch_in")
		quickPlayAnimation(arg0_129.rtTouchGamePanel:Find("slider/icon"), "anim_dorm3d_touch_icon")

		arg0_129.downTimer = Timer.New(function()
			local var0_130 = pg.dorm3d_set.reduce_interaction.key_value_int

			if arg0_129.touchLevel > 1 then
				var0_130 = pg.dorm3d_set.reduce_heartbeat.key_value_int
			end

			arg0_129:UpdateTouchCount(var0_130)
		end, 1, -1)

		arg0_129.downTimer:Start()
	end

	local var2_129 = {}

	table.insert(var2_129, function(arg0_131)
		arg0_129:SetBlackboardValue(var0_129, "inTouching", true)
		arg0_129:emit(arg0_129.SHOW_BLOCK)
		arg0_129:SetUI(arg0_131, "blank")
	end)
	table.insert(var2_129, function(arg0_132)
		local var0_132 = arg0_129.touchConfig.ik_status[1]

		arg0_129:SwitchIKConfig(var0_129, var0_132)
		setActive(arg0_129.uiContianer:Find("ik/btn_back"), true)
		arg0_129:SetIKState(true, arg0_132)
	end)
	table.insert(var2_129, function(arg0_133)
		existCall(arg0_133)
	end)
	seriesAsync(var2_129, function()
		Shader.SetGlobalFloat("_ScreenClipOff", 0)
		arg0_129:emit(arg0_129.HIDE_BLOCK)
	end)
end

function var0_0.ExitTouchMode(arg0_135)
	local var0_135 = arg0_135.ladyDict[arg0_135.apartment:GetConfigID()]

	if not arg0_135:GetBlackboardValue(var0_135, "inTouching") then
		return
	end

	if arg0_135.touchTimelineConfig then
		existCall(arg0_135.timelineFinishCall)

		return
	end

	local var1_135 = {}

	if arg0_135.inTouchGame then
		table.insert(var1_135, function(arg0_136)
			arg0_135:emit(arg0_135.SHOW_BLOCK)
			quickPlayAnimation(arg0_135.rtTouchGamePanel, "anim_dorm3d_touch_out")
			onDelayTick(arg0_136, 0.5)
		end)
		table.insert(var1_135, function(arg0_137)
			local var0_137 = 0

			for iter0_137, iter1_137 in ipairs(arg0_135.touchConfig.heartbeat_favor) do
				if iter1_137[1] > arg0_135.topCount then
					break
				else
					var0_137 = iter1_137[2]
				end
			end

			if var0_137 > 0 then
				arg0_135:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_135.apartment.configId, var0_137)
			end

			arg0_135.touchCount = nil
			arg0_135.touchLevel = nil
			arg0_135.topCount = nil

			if arg0_135.downTimer then
				arg0_135.downTimer:Stop()

				arg0_135.downTimer = nil
			end

			arg0_135.inTouchGame = false

			setActive(arg0_135.rtTouchGamePanel, false)
			Shader.SetGlobalFloat("_ScreenClipOff", 1)
			arg0_137()
		end)
	else
		table.insert(var1_135, function(arg0_138)
			arg0_135:emit(arg0_135.SHOW_BLOCK)

			local var0_138 = arg0_135.touchConfig.default_favor

			if var0_138 > 0 then
				arg0_135:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_135.apartment.configId, var0_138)
			end

			Shader.SetGlobalFloat("_ScreenClipOff", 1)
			arg0_138()
		end)
	end

	table.insert(var1_135, function(arg0_139)
		var0_135.ikConfig = {
			character_position = var0_135.ladyBaseZone,
			character_action = arg0_135.touchConfig.finish_action
		}

		arg0_135:SetIKState(false, arg0_139)
	end)
	table.insert(var1_135, function(arg0_140)
		var0_135.ikConfig = nil
		arg0_135.blockIK = nil

		arg0_135:SetUI(arg0_140, "back")
	end)
	seriesAsync(var1_135, function()
		arg0_135:SetBlackboardValue(var0_135, "inTouching", false)
		arg0_135:emit(arg0_135.HIDE_BLOCK)

		arg0_135.touchConfig = nil

		local var0_141 = arg0_135.touchExitCall

		arg0_135.touchExitCall = nil

		existCall(var0_141)
	end)
end

function var0_0.ChangeWalkScene(arg0_142, arg1_142, arg2_142, arg3_142)
	local var0_142 = arg0_142.ladyDict[arg0_142.apartment:GetConfigID()]

	seriesAsync({
		function(arg0_143)
			arg0_142:ChangeArtScene(arg2_142, arg0_143)
		end,
		function(arg0_144)
			arg0_142:ChangeSubScene(arg2_142, arg0_144)
		end,
		function(arg0_145)
			arg0_142:emit(arg0_142.SHOW_BLOCK)

			if arg1_142 == "back" then
				arg0_142:SetUI(arg0_145, "back")
			elseif arg1_142 == "change" and arg0_142.uiState ~= "walk" then
				arg0_142:SetUI(arg0_145, "walk")
			else
				arg0_145()
			end
		end
	}, function()
		arg0_142:emit(arg0_142.HIDE_BLOCK)
		arg0_142:SetBlackboardValue(var0_142, "inWalk", arg1_142 == "change")
		existCall(arg3_142)
	end)
end

function var0_0.EnterTimelineTouchMode(arg0_147)
	local var0_147 = arg0_147.ladyDict[arg0_147.apartment:GetConfigID()]

	if arg0_147:GetBlackboardValue(var0_147, "inIK") then
		return
	end

	local var1_147 = arg0_147.room:getApartmentZoneConfig(var0_147.ladyBaseZone, "touch_id", arg0_147.apartment:GetConfigID())
	local var2_147 = pg.dorm3d_ik_timeline[var1_147]

	assert(var2_147, "Missing config in dorm3d_ik_timeline ID: " .. (var1_147 or "nil"))

	arg0_147.touchTimelineConfig = var2_147

	local var3_147 = {}

	table.insert(var3_147, function(arg0_148)
		arg0_147:SetBlackboardValue(var0_147, "inIK", true)
		arg0_147:emit(arg0_147.SHOW_BLOCK)
		arg0_147:SetUI(arg0_148, "ik")
	end)
	table.insert(var3_147, function(arg0_149)
		setActive(arg0_147.uiContianer:Find("ik/btn_back"), true)
		setActive(arg0_147.uiContianer:Find("ik/Right/btn_camera"), false)
		setActive(arg0_147.uiContianer:Find("ik/Right/Menu"), false)
		setActive(arg0_147.uiContianer:Find("ik/Right/MenuSmall"), false)
		Shader.SetGlobalFloat("_ScreenClipOff", 0)
		arg0_147:emit(arg0_147.HIDE_BLOCK)
		arg0_147:HideCharacterBylayer(var0_147)
		setActive(var0_147.ladyCollider, false)

		local var0_149
		local var1_149

		if #var2_147.scene > 0 then
			var0_149, var1_149 = unpack(string.split(var2_147.scene, "|"))
		end

		arg0_147:PlayTimeline({
			name = var2_147.timeline,
			scene = var0_149,
			sceneRoot = var1_149
		}, function(arg0_150, arg1_150)
			arg1_150()
			arg0_147:ExitTimelineTouchMode()
		end)
	end)
	seriesAsync(var3_147, function()
		return
	end)
end

function var0_0.ExitTimelineTouchMode(arg0_152)
	local var0_152 = arg0_152.ladyDict[arg0_152.apartment:GetConfigID()]

	if not arg0_152:GetBlackboardValue(var0_152, "inIK") then
		return
	end

	arg0_152.touchTimelineConfig = nil

	local var1_152 = {}

	table.insert(var1_152, function(arg0_153)
		arg0_152:emit(arg0_152.SHOW_BLOCK)
		Shader.SetGlobalFloat("_ScreenClipOff", 1)
		arg0_153()
	end)
	table.insert(var1_152, function(arg0_154)
		arg0_152:RevertCharacterBylayer(var0_152)
		setActive(var0_152.ladyCollider, true)
		arg0_152:SetUI(arg0_154, "back")
	end)
	seriesAsync(var1_152, function()
		arg0_152:SetBlackboardValue(var0_152, "inIK", false)
		arg0_152:emit(arg0_152.HIDE_BLOCK)
	end)
end

function var0_0.EnterWalkMode(arg0_156)
	local var0_156 = arg0_156.apartment:GetConfigID()
	local var1_156 = arg0_156.ladyDict[var0_156]

	seriesAsync({
		function(arg0_157)
			arg0_156:emit(arg0_156.SHOW_BLOCK)
			arg0_156:HideCharacter(var0_156)
			arg0_156:SetBlackboardValue(var1_156, "inWalk", true)
			arg0_156:SetUI(arg0_157, "walk")
		end,
		function(arg0_158)
			arg0_156:emit(arg0_156.HIDE_BLOCK)
			arg0_156:ChangeArtScene(arg0_156.walkInfo.scene .. "|" .. arg0_156.walkInfo.sceneRoot, arg0_158)
		end,
		function(arg0_159)
			arg0_156:LoadSubScene(arg0_156.walkInfo, arg0_159)
		end
	}, function()
		return
	end)
end

function var0_0.ExitWalkMode(arg0_161)
	local var0_161 = arg0_161.apartment:GetConfigID()
	local var1_161 = arg0_161.ladyDict[var0_161]

	seriesAsync({
		function(arg0_162)
			arg0_161:RevertArtScene(arg0_161.walkLastSceneInfo, arg0_162)
		end,
		function(arg0_163)
			arg0_161:UnloadSubScene(arg0_161.walkInfo, arg0_163)
		end,
		function(arg0_164)
			arg0_161:emit(arg0_161.SHOW_BLOCK)
			arg0_161:SetUI(arg0_164, "back")
		end
	}, function()
		arg0_161:emit(arg0_161.HIDE_BLOCK)
		arg0_161:RevertCharacter(var0_161)
		arg0_161:SetBlackboardValue(var1_161, "inWalk", false)

		local var0_165 = arg0_161.walkExitCall

		arg0_161.walkExitCall = nil
		arg0_161.walkLastSceneInfo = nil
		arg0_161.walkInfo = nil

		existCall(var0_165)
	end)
end

function var0_0.EnableMiniGameCutIn(arg0_166)
	if not arg0_166.tfCutIn then
		return
	end

	local var0_166 = arg0_166.rtExtraScreen:Find("MiniGameCutIn")

	setActive(var0_166, true)

	local var1_166 = GetOrAddComponent(var0_166:Find("bg/mask/cut_in"), "CameraRTUI")

	setActive(var1_166, true)
	pg.CameraRTMgr.GetInstance():Bind(var1_166, arg0_166.tfCutIn:Find("TestCamera"):GetComponent(typeof(Camera)))
	quickPlayAnimator(arg0_166.modelCutIn.lady, "Idle")
	quickPlayAnimator(arg0_166.modelCutIn.player, "Idle")
	setActive(arg0_166.tfCutIn, true)
end

function var0_0.DisableMiniGameCutIn(arg0_167)
	if not arg0_167.tfCutIn then
		return
	end

	local var0_167 = arg0_167.rtExtraScreen:Find("MiniGameCutIn")
	local var1_167 = GetOrAddComponent(var0_167:Find("bg/mask/cut_in"), "CameraRTUI")

	pg.CameraRTMgr.GetInstance():Clean(var1_167)
	setActive(var0_167, false)
	setActive(arg0_167.tfCutIn, false)
end

function var0_0.SwitchIKConfig(arg0_168, arg1_168, arg2_168)
	warning("switchIkstatus", arg2_168)

	local var0_168 = pg.dorm3d_ik_status[arg2_168]

	if var0_168.skin_id ~= arg1_168.skinId then
		local var1_168 = pg.dorm3d_ik_status.get_id_list_by_base[var0_168.base]
		local var2_168 = _.detect(var1_168, function(arg0_169)
			return pg.dorm3d_ik_status[arg0_169].skin_id == arg1_168.skinId
		end)

		assert(var2_168, string.format("Missing Status Config By Skin: %s original Status: %s", arg1_168.skinId, arg2_168))

		var0_168 = pg.dorm3d_ik_status[var2_168]
	end

	arg1_168.ikConfig = var0_168
end

function var0_0.SetIKState(arg0_170, arg1_170, arg2_170)
	local var0_170 = arg0_170.ladyDict[arg0_170.apartment:GetConfigID()]
	local var1_170 = {}

	if arg1_170 then
		table.insert(var1_170, function(arg0_171)
			arg0_170:SetBlackboardValue(var0_170, "inIK", true)
			arg0_170:emit(arg0_170.SHOW_BLOCK)

			local var0_171 = var0_170.ikConfig.camera_group

			setActive(arg0_170.uiContianer:Find("ik/Right/btn_camera"), #pg.dorm3d_ik_status.get_id_list_by_camera_group[var0_171] > 1)
			setActive(arg0_170.ikControlUI, true)
			arg0_171()
		end)

		if arg0_170.uiState ~= "ik" then
			table.insert(var1_170, function(arg0_172)
				arg0_170:SetUI(arg0_172, "ik")
			end)
		end

		table.insert(var1_170, function(arg0_173)
			Shader.SetGlobalFloat("_ScreenClipOff", 0)
			arg0_170:SetIKStatus(var0_170, var0_170.ikConfig, arg0_173)
		end)
		table.insert(var1_170, function(arg0_174)
			arg0_170:emit(arg0_170.HIDE_BLOCK)
			arg0_174()
		end)
	else
		assert(arg0_170.uiState == "ik")
		table.insert(var1_170, function(arg0_175)
			setActive(arg0_170.ikControlUI, false)
			arg0_170:emit(arg0_170.SHOW_BLOCK)
			Shader.SetGlobalFloat("_ScreenClipOff", 1)
			arg0_175()
		end)
		table.insert(var1_170, function(arg0_176)
			arg0_170:ExitIKStatus(var0_170, var0_170.ikConfig, arg0_176)
			arg0_170:ResetSceneItemAnimators()
		end)
		table.insert(var1_170, function(arg0_177)
			arg0_170:SetUI(arg0_177, "back")
		end)
		table.insert(var1_170, function(arg0_178)
			arg0_170:SetBlackboardValue(var0_170, "inIK", false)
			arg0_170:emit(arg0_170.HIDE_BLOCK)
			arg0_178()
		end)
	end

	seriesAsync(var1_170, arg2_170)
end

function var0_0.TouchModeAction(arg0_179, arg1_179, arg2_179, arg3_179, ...)
	return switch(arg3_179, {
		function(arg0_180, arg1_180)
			return function(arg0_181)
				seriesAsync({
					function(arg0_182)
						if not arg1_180 or arg1_180 == "" then
							return arg0_182()
						end

						arg0_179:PlaySingleAction(arg1_179, arg1_180, arg0_182)
					end,
					function(arg0_183)
						arg0_179:SwitchIKConfig(arg1_179, arg0_180)
						arg0_179:SetIKState(true, arg0_183)
					end,
					arg0_181
				})
			end
		end,
		function()
			return function()
				if arg0_179.ikSpecialCall then
					local var0_185 = arg0_179.ikSpecialCall

					arg0_179.ikSpecialCall = nil

					existCall(var0_185)
				else
					arg0_179:ExitTouchMode()
				end
			end
		end,
		function(arg0_186, arg1_186)
			return function(arg0_187)
				arg0_179:PlaySingleAction(arg1_179, arg1_186, arg0_187)
			end
		end,
		function(arg0_188, arg1_188, arg2_188)
			return function(arg0_189)
				seriesAsync({
					function(arg0_190)
						arg0_179:DoTalk(arg1_188, arg0_190)
					end,
					function(arg0_191)
						if not arg2_188 or arg2_188 == 0 then
							return arg0_191()
						end

						arg0_179:SwitchIKConfig(arg1_179, arg2_188)
						arg0_179:SetIKState(true, arg0_191)
					end,
					arg0_189
				})
			end
		end,
		function(arg0_192, arg1_192, arg2_192, arg3_192)
			return function(arg0_193)
				arg0_179:PlaySceneItemAnim(arg2_192, arg3_192)
				arg0_179:PlaySingleAction(arg1_192, arg0_193)
			end
		end,
		function(arg0_194)
			return function(arg0_195)
				local var0_195 = pg.dorm3d_ik_touch[arg2_179]

				if #var0_195.scene_item == 0 then
					return
				end

				local var1_195 = arg0_179:GetSceneItem(var0_195.scene_item)

				if not var1_195 then
					warning(string.format("dorm3d_ik_touch:%d without scene_item:%s", arg2_179, var0_195.scene_item))

					return
				end

				local var2_195 = var1_195:Find(arg0_194)

				if not IsNil(var2_195) then
					setActive(var2_195, false)
					setActive(var2_195, true)
				end

				arg0_195()
			end
		end,
		function(arg0_196)
			local var0_196 = pg.dorm3d_ik_touch_move[arg0_196]
			local var1_196 = var0_196.target_ik
			local var2_196 = var0_196.move_time
			local var3_196 = var0_196.ik_point
			local var4_196 = var0_196.touch_step

			arg1_179.IKSettings.forceMove = arg1_179.IKSettings.forceMove or {}

			local var5_196 = arg1_179.IKSettings.forceMove

			var5_196[var1_196] = var5_196[var1_196] or {}
			var5_196[var1_196].count = var5_196[var1_196].count or 0

			return function(arg0_197)
				seriesAsync({
					function(arg0_198)
						if var5_196[var1_196].count >= #var4_196 then
							return arg0_198()
						end

						local var0_198 = Dorm3dIK.New({
							configId = var1_196
						})
						local var1_198 = Vector2.New(unpack(var3_196))
						local var2_198 = var5_196[var1_196].count
						local var3_198 = var4_196[var2_198 + 1] - (var2_198 == 0 and 0 or var4_196[var2_198])

						var5_196[var1_196].count = var2_198 + 1

						pg.IKMgr.GetInstance():ResetIK(var0_198:GetTriggerBoneName())

						local var4_198 = arg1_179.IKSettings.Colliders[var0_198:GetTriggerBoneName()]
						local var5_198 = arg0_179.raycastCamera:WorldToScreenPoint(var4_198.position)

						pg.IKMgr.GetInstance():PlayIKMove(var5_198, var0_198:GetTriggerBoneName(), var1_198, var4_196[var2_198 + 1], var2_196, function()
							var5_196[var1_196].count = 0

							arg0_198()
						end)
					end,
					arg0_197
				})
			end
		end
	}, function()
		return function()
			return
		end
	end, ...)
end

function var0_0.OnTriggerIK(arg0_202, arg1_202)
	local var0_202 = arg0_202.ladyDict[arg0_202.apartment:GetConfigID()]

	if var0_202.ikTimelineMode then
		arg0_202:ExitIKTimelineStatus(var0_202)

		local var1_202 = arg1_202:GetTimelineAction()

		if var1_202 then
			arg0_202.nowTimelinePlayer:TriggerEvent(var1_202)
		end

		return
	end

	if not var0_202.ikConfig then
		return
	end

	local var2_202 = arg1_202:GetControllerPath()
	local var3_202 = var0_202.ikActionDict[var2_202]

	if not var3_202 then
		return
	end

	arg0_202.blockIK = true

	arg0_202:TouchModeAction(var0_202, arg1_202:GetConfigID(), unpack(var3_202))(function()
		arg0_202:ResetIKTipTimer()

		arg0_202.blockIK = nil
	end)
end

function var0_0.OnTouchCharacterBody(arg0_204, arg1_204)
	local var0_204 = arg0_204.ladyDict[arg0_204.apartment:GetConfigID()]

	if not var0_204.ikConfig then
		return
	end

	if type(var0_204.ikConfig.touch_data) ~= "table" then
		return
	end

	for iter0_204, iter1_204 in ipairs(var0_204.iKTouchDatas) do
		local var1_204, var2_204, var3_204 = unpack(iter1_204)
		local var4_204 = pg.dorm3d_ik_touch[var1_204]

		if var4_204.body == arg1_204 then
			local var5_204 = var4_204.action_emote

			if #var5_204 > 0 then
				arg0_204:PlayFaceAnim(var0_204, var5_204)
			end

			local var6_204 = var4_204.vibrate

			if type(var6_204) == "table" and VibrateMgr.Instance:IsSupport() then
				local var7_204 = {}
				local var8_204 = {}
				local var9_204 = {}

				underscore.each(var6_204, function(arg0_205)
					local var0_205 = arg0_205[1]

					if PLATFORM == PLATFORM_IPHONEPLAYER then
						var0_205 = var0_205 / 1000
					end

					table.insert(var7_204, var0_205)
					table.insert(var8_204, arg0_205[2])
					table.insert(var9_204, 1)
				end)

				if PLATFORM == PLATFORM_ANDROID then
					VibrateMgr.Instance:VibrateWaveform(var7_204, var8_204)
				elseif PLATFORM == PLATFORM_IPHONEPLAYER then
					VibrateMgr.Instance:VibrateWaveform(var7_204, var8_204, var9_204)
				end
			end

			arg0_204.blockIK = true

			arg0_204:TouchModeAction(var0_204, var1_204, unpack(var3_204))(function()
				arg0_204:ResetIKTipTimer()

				arg0_204.blockIK = nil
			end)

			return
		end
	end
end

function var0_0.UpdateTouchGameDisplay(arg0_207)
	setActive(arg0_207.rtTouchGamePanel:Find("effect_bg"), arg0_207.touchLevel == 2)
	setActive(arg0_207.rtTouchGamePanel:Find("slider/icon/beating"), arg0_207.touchLevel == 2)

	if arg0_207.touchLevel == 1 then
		setActive(arg0_207.uiContianer:Find("ik/btn_back"), true)
		setActive(arg0_207.uiContianer:Find("ik/btn_back_heartbeat"), false)
		quickPlayAnimation(arg0_207.rtTouchGamePanel, "anim_dorm3d_touch_change_out")
		quickPlayAnimation(arg0_207.rtTouchGamePanel:Find("slider/icon"), "anim_dorm3d_touch_icon")
	elseif arg0_207.touchLevel == 2 then
		setActive(arg0_207.uiContianer:Find("ik/btn_back"), false)
		setActive(arg0_207.uiContianer:Find("ik/btn_back_heartbeat"), true)
		quickPlayAnimation(arg0_207.rtTouchGamePanel, "anim_dorm3d_touch_change")
		quickPlayAnimation(arg0_207.rtTouchGamePanel:Find("slider/icon"), "anim_dorm3d_touch_icon_1")
		pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_heartbeat")
	end
end

function var0_0.UpdateTouchCount(arg0_208, arg1_208)
	if arg0_208.touchLevel > 1 then
		arg1_208 = math.min(0, arg1_208)
	end

	arg0_208.touchCount = math.clamp(arg0_208.touchCount + arg1_208, 0, 100)

	if arg0_208.sliderLT and LeanTween.isTweening(arg0_208.sliderLT) then
		LeanTween.cancel(arg0_208.sliderLT)

		arg0_208.sliderLT = nil
	end

	setSlider(arg0_208.rtTouchGamePanel:Find("slider"), 0, 100, arg0_208.touchCount)

	local var0_208

	if arg0_208.touchCount >= 100 then
		var0_208 = 2
	elseif arg0_208.touchCount <= 0 then
		var0_208 = 1
	end

	if var0_208 and var0_208 ~= arg0_208.touchLevel then
		if arg0_208.blockIK then
			return
		end

		arg0_208.touchLevel = var0_208

		local var1_208 = arg0_208.touchConfig.ik_status[var0_208]

		if var1_208 then
			if var0_208 > 1 then
				arg0_208.touchCount = 200
			elseif var0_208 == 1 then
				arg0_208.touchCount = 0
			end

			local var2_208 = arg0_208.ladyDict[arg0_208.apartment:GetConfigID()]

			seriesAsync({
				function(arg0_209)
					arg0_208:ShowBlackScreen(true, arg0_209)
				end,
				function(arg0_210)
					arg0_208:SwitchIKConfig(var2_208, var1_208)
					arg0_208:SetIKState(true, arg0_210)

					if var0_208 > 1 and arg0_208.touchConfig.heartbeat_enter_anim ~= "" then
						arg0_208:SwitchAnim(var2_208, arg0_208.touchConfig.heartbeat_enter_anim)
					end
				end,
				function(arg0_211)
					arg0_208:ShowBlackScreen(false, arg0_211)
				end
			})
		end

		arg0_208:UpdateTouchCount(0)
		arg0_208:UpdateTouchGameDisplay()
	end

	arg0_208.topCount = math.max(arg0_208.topCount, arg0_208.touchCount)
end

function var0_0.ExitHeartbeatMode(arg0_212)
	if not arg0_212.touchLevel or arg0_212.touchLevel == 1 then
		return
	end

	arg0_212.touchCount = 0

	arg0_212:UpdateTouchCount(0)
end

function var0_0.DoTouch(arg0_213, arg1_213, arg2_213)
	if arg0_213.inTouchGame then
		switch(arg2_213, {
			function()
				arg0_213:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat.key_value_int)
			end,
			function()
				arg0_213:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat.key_value_int)
			end,
			function()
				arg0_213:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat.key_value_int)
			end,
			function()
				arg0_213:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat_trriger.key_value_int)
			end
		})
	end
end

function var0_0.DoTalk(arg0_218, arg1_218, arg2_218)
	while rawget(arg0_218, "class") ~= var0_0 do
		arg0_218 = getmetatable(arg0_218).__index
	end

	if arg0_218.apartment and arg0_218:GetBlackboardValue(arg0_218.ladyDict[arg0_218.apartment:GetConfigID()], "inTalking") then
		errorMsg("Talking block:" .. arg1_218)

		return
	end

	if not arg0_218.room:isPersonalRoom() then
		local var0_218 = pg.dorm3d_dialogue_group[arg1_218].char_id

		if arg0_218.apartment then
			assert(arg0_218.apartment:GetConfigID() == var0_218)
		else
			arg0_218:SetApartment(getProxy(ApartmentProxy):getApartment(var0_218))
		end
	end

	local var1_218 = arg0_218.ladyDict[arg0_218.apartment:GetConfigID()]

	if arg1_218 == 10010 and not arg0_218.apartment.talkDic[arg1_218] then
		arg0_218.firstTimelineTouch = true
		arg0_218.firstMoveGuide = true
	end

	getProxy(Dorm3dChatProxy):TriggerEvent({
		{
			value = 1,
			event_type = arg0_218.contextData.timeIndex == 1 and 110 or 115,
			ship_id = arg0_218.apartment:GetConfigID()
		},
		{
			value = 1,
			event_type = 155,
			ship_id = arg0_218.apartment:GetConfigID()
		}
	})

	local var2_218 = {}

	if arg0_218:GetBlackboardValue(var1_218, "inPending") then
		table.insert(var2_218, function(arg0_219)
			arg0_218:OutOfLazy(arg0_218.apartment:GetConfigID(), arg0_219)
		end)
	end

	local var3_218 = pg.dorm3d_dialogue_group[arg1_218]
	local var4_218 = var3_218.performance_type == 1
	local var5_218

	table.insert(var2_218, function(arg0_220)
		arg0_218:emit(arg0_218.SHOW_BLOCK)
		arg0_218:SetBlackboardValue(var1_218, var4_218 and "inPerformance" or "inTalking", true)
		arg0_218:emit(Dorm3dRoomMediator.DO_TALK, arg1_218, function(arg0_221)
			var5_218 = arg0_221

			arg0_220()
		end)
	end)
	table.insert(var2_218, function(arg0_222)
		pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataDialog(arg0_218.apartment.configId, arg0_218.apartment.level, arg1_218, var3_218.type, arg0_218.room:getZoneConfig(arg0_218.ladyDict[arg0_218.apartment:GetConfigID()].ladyBaseZone, "id"), var3_218.action_type, table.CastToString(var3_218.trigger_config), arg0_218.room:GetConfigID()))

		if pg.NewGuideMgr.GetInstance():IsBusy() then
			pg.NewGuideMgr.GetInstance():Pause()
		end

		arg0_218:SetUI(arg0_222, "blank")
	end)

	if var3_218.trigger_area and var3_218.trigger_area ~= "" then
		table.insert(var2_218, function(arg0_223)
			arg0_218:ShiftZone(var3_218.trigger_area, arg0_223)
		end)
	end

	if var3_218.performance_type == 0 then
		table.insert(var2_218, function(arg0_224)
			arg0_218:emit(arg0_218.HIDE_BLOCK)

			if arg0_218.contextData.isVideoTalk then
				arg0_218.videoPlayer:ExecuteAction("Play", var3_218.story, function()
					onDelayTick(arg0_224, 0.001)
				end)
			else
				pg.NewStoryMgr.GetInstance():ForceManualPlay(var3_218.story, function()
					onDelayTick(arg0_224, 0.001)
				end, true)
			end
		end)
	elseif var3_218.performance_type == 1 then
		table.insert(var2_218, function(arg0_227)
			arg0_218:emit(arg0_218.HIDE_BLOCK)
			arg0_218:PerformanceQueue(var3_218.story, arg0_227)
		end)
	else
		assert(false)
	end

	table.insert(var2_218, function(arg0_228)
		arg0_218:emit(arg0_218.SHOW_BLOCK)
		arg0_228()
	end)
	table.insert(var2_218, function(arg0_229)
		local var0_229 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(var3_218.story)

		if var0_229 then
			local var1_229 = "1"

			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataStory(var0_229, var1_229))
		end

		if var5_218 and #var5_218 > 0 then
			arg0_218:emit(Dorm3dRoomMediator.OPEN_DROP_LAYER, var5_218, arg0_229)
		else
			arg0_229()
		end
	end)
	table.insert(var2_218, function(arg0_230)
		if pg.NewGuideMgr.GetInstance():IsPause() then
			pg.NewGuideMgr.GetInstance():Resume()
		end

		arg0_218:emit(arg0_218.HIDE_BLOCK)

		if arg0_218.contextData.isVideoTalk then
			existCall(arg0_230)
		else
			arg0_218:SetBlackboardValue(var1_218, var4_218 and "inPerformance" or "inTalking", false)
			arg0_218:SetUI(arg0_230, "back")
		end
	end)
	seriesAsync(var2_218, function()
		if arg2_218 then
			return arg2_218()
		else
			arg0_218:CheckQueue()
		end
	end)
end

function var0_0.DoTalkTouchOption(arg0_232, arg1_232, arg2_232, arg3_232)
	local var0_232 = arg0_232.rtExtraScreen:Find("TalkTouchOption")
	local var1_232
	local var2_232 = var0_232:Find("content")

	UIItemList.StaticAlign(var2_232, var2_232:Find("clickTpl"), #arg1_232.options, function(arg0_233, arg1_233, arg2_233)
		arg1_233 = arg1_233 + 1

		if arg0_233 == UIItemList.EventUpdate then
			local var0_233 = arg1_232.options[arg1_233]

			setAnchoredPosition(arg2_233, NewPos(unpack(var0_233.pos)))
			onButton(arg0_232, arg2_233, function()
				var1_232(var0_233.flag)
			end, SFX_CONFIRM)
			setActive(arg2_233, not table.contains(arg2_232, var0_233.flag))
		end
	end)
	setActive(var0_232, true)

	function var1_232(arg0_235)
		setActive(var0_232, false)
		arg3_232(arg0_235)
	end
end

function var0_0.DoTimelineOption(arg0_236, arg1_236, arg2_236)
	local var0_236 = arg0_236.rtTimelineScreen:Find("TimelineOption")
	local var1_236
	local var2_236 = var0_236:Find("content")

	UIItemList.StaticAlign(var2_236, var2_236:Find("clickTpl"), #arg1_236, function(arg0_237, arg1_237, arg2_237)
		arg1_237 = arg1_237 + 1

		if arg0_237 == UIItemList.EventUpdate then
			local var0_237 = arg1_236[arg1_237]

			setText(arg2_237:Find("Text"), HXSet.hxLan(var0_237.content))
			onButton(arg0_236, arg2_237, function()
				var1_236(arg1_237)
			end, SFX_CONFIRM)
		end
	end)
	setActive(var0_236, true)

	function var1_236(arg0_239)
		setActive(var0_236, false)
		arg2_236(arg0_239)
	end
end

function var0_0.DoTimelineTouch(arg0_240, arg1_240, arg2_240)
	local var0_240 = arg0_240.rtTimelineScreen:Find("TimelineTouch")
	local var1_240
	local var2_240 = var0_240:Find("content")

	UIItemList.StaticAlign(var2_240, var2_240:Find("clickTpl"), #arg1_240, function(arg0_241, arg1_241, arg2_241)
		arg1_241 = arg1_241 + 1

		if arg0_241 == UIItemList.EventUpdate then
			local var0_241 = arg1_240[arg1_241]

			setAnchoredPosition(arg2_241, NewPos(unpack(var0_241.pos)))
			onButton(arg0_240, arg2_241, function()
				var1_240(arg1_241)
			end, SFX_CONFIRM)

			if arg0_240.firstTimelineTouch then
				arg0_240.firstTimelineTouch = nil

				setActive(arg2_241:Find("finger"), true)
			end
		end
	end)
	setActive(var0_240, true)

	function var1_240(arg0_243)
		setActive(var0_240, false)
		arg2_240(arg0_243)
	end
end

function var0_0.DoShortWait(arg0_244, arg1_244)
	local var0_244 = arg0_244.ladyDict[arg1_244]
	local var1_244 = getProxy(ApartmentProxy):getApartment(arg1_244)
	local var2_244 = arg0_244.room:getApartmentZoneConfig(var0_244.ladyBaseZone, "special_action", arg1_244)
	local var3_244 = var2_244 and var2_244[math.random(#var2_244)] or nil

	if not var3_244 then
		return
	end

	arg0_244:PlaySingleAction(var0_244, var3_244)
end

function var0_0.OutOfLazy(arg0_245, arg1_245, arg2_245)
	local var0_245 = arg0_245.ladyDict[arg1_245]
	local var1_245 = {}

	if arg0_245:GetBlackboardValue(var0_245, "inPending") then
		table.insert(var1_245, function(arg0_246)
			arg0_245.shiftLady = arg1_245

			arg0_245:ShiftZone(var0_245.ladyBaseZone, arg0_246)
		end)
	end

	seriesAsync(var1_245, arg2_245)
end

function var0_0.OutOfPending(arg0_247, arg1_247, arg2_247)
	assert(arg0_247.wakeUpTalkId)

	local var0_247 = arg0_247.wakeUpTalkId

	seriesAsync({
		function(arg0_248)
			arg0_247:SetUI(arg0_248, "blank")
		end,
		function(arg0_249)
			arg0_247.shiftLady = arg1_247

			local var0_249 = arg0_247.ladyDict[arg1_247]

			arg0_247:ShiftZone(var0_249.ladyBaseZone, arg0_249)
		end,
		function(arg0_250)
			arg0_247:DoTalk(var0_247, arg0_250)
		end
	}, function()
		arg0_247:SetUIStore(arg2_247, "back")
	end)
end

function var0_0.ChangeCanWatchState(arg0_252, arg1_252)
	local var0_252

	if arg0_252:GetBlackboardValue(arg1_252, "inPending") then
		var0_252 = tobool(arg0_252:GetBlackboardValue(arg1_252, "inDistance"))
	else
		local var1_252 = arg0_252:GetBlackboardValue(arg1_252, "groupId")

		var0_252 = tobool(arg0_252.activeLady[var1_252] and pg.NodeCanvasMgr.GetInstance():GetBlackboradValue("canWatch", arg1_252.ladyBlackboard))
	end

	if arg1_252.blockCanWatch then
		var0_252 = false
	end

	if (not arg1_252.nowCanWatchState or arg1_252.nowCanWatchState ~= var0_252) and arg1_252.ladyWatchFloat then
		arg1_252.nowCanWatchState = var0_252

		arg0_252:ShowOrHideCanWatchMark(arg1_252, arg1_252.nowCanWatchState)
	end
end

function var0_0.HandleGameNotification(arg0_253, arg1_253, arg2_253)
	local var0_253 = arg0_253.ladyDict[arg0_253.apartment:GetConfigID()]

	switch(arg1_253, {
		[Dorm3dMiniGameMediator.OPERATION] = function()
			local var0_254 = arg2_253.miniGameId

			switch(arg2_253.miniGameId, {
				[67] = function()
					if arg2_253.operationCode == "GAME_HIT_AREA" then
						local var0_255 = {
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
						local var1_255, var2_255 = unpack(var0_255[arg2_253.index])

						arg0_253:PlayFaceAnim(var0_253, var1_255)

						if arg0_253.tfCutIn then
							quickPlayAnimator(arg0_253.modelCutIn.lady, var2_255)
							quickPlayAnimator(arg0_253.modelCutIn.player, var2_255)
						end
					elseif arg2_253.operationCode == "GAME_RESULT" then
						if arg2_253.win then
							arg0_253:PlayFaceAnim(var0_253, "Face_XYX_victory")
							arg0_253:PlaySingleAction(var0_253, "minigame_win")
						else
							arg0_253:PlayFaceAnim(var0_253, "Face_XYX_lose")
							arg0_253:PlaySingleAction(var0_253, "minigame_lose")
						end

						setActive(arg0_253.rtExtraScreen:Find("MiniGameCutIn"), false)
					end
				end,
				[70] = function()
					if arg2_253.operationCode == "GAME_READY" then
						arg0_253.cameras[var0_0.CAMERA.TALK].Follow = nil
						arg0_253.cameras[var0_0.CAMERA.TALK].LookAt = nil

						arg0_253:PlaySingleAction(var0_253, "shuohua_sikao")
					elseif arg2_253.operationCode == "ROUND_RESULT" then
						local var0_256

						if arg2_253.success then
							var0_256 = {
								"shuohua_wenhou",
								"shuohua_sikao"
							}
						else
							var0_256 = {
								"shuohua_yaotou",
								"shuohua_sikao"
							}
						end

						seriesAsync(underscore.map(var0_256, function(arg0_257)
							return function(arg0_258)
								arg0_253:PlaySingleAction(var0_253, arg0_257, arg0_258)
							end
						end), function()
							return
						end)
					elseif arg2_253.operationCode == "GAME_RESULT" then
						local var1_256 = arg0_253.cameras[var0_0.CAMERA.TALK].transform

						var1_256.position = var1_256.position + var1_256.right * 0.11

						local var2_256 = {
							"shuohua_gandong"
						}

						seriesAsync(underscore.map(var2_256, function(arg0_260)
							return function(arg0_261)
								arg0_253:PlaySingleAction(var0_253, arg0_260, arg0_261)
							end
						end), function()
							return
						end)
					end
				end,
				[75] = function()
					if arg2_253.operationCode == "BEFORE_OPEN_GAME" then
						arg0_253.cameras[var0_0.CAMERA.TALK].Follow = nil
						arg0_253.cameras[var0_0.CAMERA.TALK].LookAt = nil
					elseif arg2_253.operationCode == "GAME_RPS_RESULT" then
						if arg2_253.index == 1 then
							arg0_253:PlaySingleAction(var0_253, "ab_shuohua_lianxuyaotou_01")
							arg0_253:PlayFaceAnim(var0_253, "Face_weixiao")
						elseif arg2_253.index == 2 then
							arg0_253:PlaySingleAction(var0_253, "ab_shuohua_lianxudiantou_01")
							arg0_253:PlayFaceAnim(var0_253, "Face_kaixin")
						end
					elseif arg2_253.operationCode == "GAME_RESULT" then
						if not arg2_253.win then
							arg0_253:PlaySingleAction(var0_253, "ab_shuohua_taibangle_01")
						end

						arg0_253:PlayFaceAnim(var0_253, "Face_kaixin")
					end
				end
			}, function()
				warning("without miniGameId:" .. arg2_253.miniGameId)
			end)

			if arg2_253.operationCode == "BEFORE_OPEN_GAME" then
				local var1_254 = getProxy(PlayerProxy):getPlayerId()
				local var2_254 = 0

				if var0_254 == 67 or var0_254 == 70 then
					var2_254 = PlayerPrefs.GetInt("mg_new_score_" .. tostring(var1_254) .. "_" .. arg2_253.miniGameId, 0)
				else
					var2_254 = PlayerPrefs.GetInt("mg_score_" .. tostring(var1_254) .. "_" .. arg2_253.miniGameId, 0)
				end

				arg0_253.highScore = var2_254
			elseif arg2_253.operationCode == "GAME_RESULT" then
				local var3_254 = arg2_253.score
				local var4_254 = getProxy(PlayerProxy):getPlayerId()

				if var3_254 > arg0_253.highScore then
					if var0_254 == 67 or var0_254 == 70 then
						PlayerPrefs.SetInt("mg_new_score_" .. tostring(var4_254) .. "_" .. arg2_253.miniGameId, var3_254)
					end

					getProxy(Dorm3dChatProxy):TriggerEvent({
						{
							event_type = 159,
							value = var3_254,
							ship_id = arg0_253.apartment:GetConfigID()
						}
					})
				end

				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataMiniGame(2, arg2_253.score))
			elseif arg2_253.operationCode == "GAME_CLOSE" and arg2_253.doTrack == false then
				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataMiniGame(3))
			end
		end
	})
end

function var0_0.PerformanceQueue(arg0_265, arg1_265, arg2_265)
	local var0_265, var1_265 = pcall(function()
		return require("GameCfg.dorm." .. arg1_265)
	end)

	if not var0_265 then
		errorMsg("不存在表演ID对应的Lua:" .. arg1_265)
		existCall(arg2_265)

		return
	end

	warning(arg1_265)

	arg0_265.performanceInfo = {
		name = arg1_265
	}

	local var2_265 = {}

	table.insert(var2_265, function(arg0_267)
		arg0_265:SetUI(arg0_267, "blank")
	end)
	table.insertto(var2_265, underscore.map(var1_265, function(arg0_268)
		return switch(arg0_268.type, {
			function()
				return function(arg0_270)
					local var0_270 = unpack(arg0_268.params)

					arg0_265:DoTalk(var0_270, arg0_270, true)
				end
			end,
			function()
				return function(arg0_272)
					arg0_265.touchExitCall = arg0_272

					arg0_265:EnterTouchMode()
				end
			end,
			function()
				return function(arg0_274)
					local var0_274 = arg0_265.ladyDict[arg0_265.apartment:GetConfigID()]

					arg0_265:PlaySingleAction(var0_274, arg0_268.name, arg0_274)
				end
			end,
			function()
				return function(arg0_276)
					arg0_265:emit(arg0_265.PLAY_EXPRESSION, arg0_268)
					arg0_276()
				end
			end,
			function()
				return function(arg0_278)
					arg0_265:ShiftZone(arg0_268.name, arg0_278)
				end
			end,
			function()
				return function(arg0_280)
					arg0_265.contextData.timeIndex = arg0_268.params[1]

					local var0_280 = arg0_268.params[2] or false

					if Dorm3dSceneMgr.IsSameSceneInfo(arg0_265.dormSceneMgr.artSceneInfo, arg0_265.dormSceneMgr.sceneInfo) then
						arg0_265:SwitchDayNight(arg0_265.contextData.timeIndex)

						if var0_280 then
							onNextTick(function()
								arg0_265:RefreshSlots()
							end)
						end
					end

					arg0_265:UpdateContactState()
					onNextTick(arg0_280)
				end
			end,
			function()
				return function(arg0_283)
					if arg0_268.name then
						arg0_265:ActiveCameraByName(arg0_268.name)
						existCall(arg0_283)
					else
						arg0_265:ActiveStateCamera(arg0_268.params[1], arg0_283)
					end
				end
			end,
			function()
				return function(arg0_285)
					if arg0_268.name == "base" then
						arg0_265:RevertArtScene(arg0_265.dormSceneMgr.sceneInfo, arg0_285)
					else
						local var0_285 = arg0_268.params.scene
						local var1_285 = arg0_268.params.sceneRoot

						arg0_265:ChangeArtScene(var0_285 .. "|" .. var1_285, arg0_285)
					end
				end
			end,
			function()
				return function(arg0_287)
					local var0_287 = arg0_268.params.name

					if arg0_268.name == "load" then
						local var1_287 = tobool(arg0_268.params.wait_timeline) and function(arg0_288)
							arg0_265.waitForTimeline = arg0_288
						end

						arg0_265:LoadTimelineScene(var0_287, true, var1_287, arg0_287)
					elseif arg0_268.name == "unload" then
						arg0_265:UnloadTimelineScene(var0_287, true, arg0_287)
					else
						assert(false)
					end
				end
			end,
			function()
				return function(arg0_290)
					setActive(arg0_265.uiContianer:Find("walk/btn_back"), false)

					local var0_290 = arg0_265.ladyDict[arg0_265.apartment:GetConfigID()]

					if arg0_268.name == "change" then
						local var1_290 = arg0_268.params.scene
						local var2_290 = arg0_268.params.sceneRoot

						var0_290.walkBornPoint = arg0_268.params.point or "Default"

						arg0_265:ChangeWalkScene(arg0_268.name, var1_290 .. "|" .. var2_290, arg0_290)
					elseif arg0_268.name == "back" then
						var0_290.walkBornPoint = nil

						arg0_265:ChangeWalkScene(arg0_268.name, arg0_265.dormSceneMgr.sceneInfo, arg0_290)
					elseif arg0_268.name == "set" then
						local function var3_290()
							local var0_291 = arg0_290

							arg0_290 = nil

							return existCall(var0_291)
						end

						for iter0_290, iter1_290 in pairs(arg0_268.params) do
							switch(iter0_290, {
								back_button_trigger = function(arg0_292)
									onButton(arg0_265, arg0_265.uiContianer:Find("walk/btn_back"), var3_290, SFX_DORM_BACK)
									setActive(arg0_265.uiContianer:Find("walk/btn_back"), IsUnityEditor and arg0_292)
								end,
								near_trigger = function(arg0_293)
									if arg0_293 == true then
										arg0_293 = 1.5
									end

									if arg0_293 then
										function arg0_265.walkNearCallback(arg0_294)
											if arg0_294 < arg0_293 then
												arg0_265.walkNearCallback = nil

												var3_290()
											end
										end
									else
										arg0_265.walkNearCallback = nil
									end
								end
							}, nil, iter1_290)
						end

						if arg0_265.firstMoveGuide then
							setActive(arg0_265.povLayer:Find("Guide"), arg0_265.firstMoveGuide)

							arg0_265.firstMoveGuide = nil
						end
					else
						assert(false)
					end
				end
			end,
			function()
				return function(arg0_296)
					if arg0_268.name == "set" then
						local var0_296 = arg0_265.ladyDict[arg0_265.apartment:GetConfigID()]

						arg0_265:SwitchIKConfig(var0_296, arg0_268.params.state)
						setActive(arg0_265.uiContianer:Find("ik/btn_back"), not arg0_268.params.hide_back)

						arg0_265.ikSpecialCall = arg0_296

						arg0_265:SetIKState(true)
					elseif arg0_268.name == "back" then
						local var1_296 = arg0_265.ladyDict[arg0_265.apartment:GetConfigID()]

						var1_296.ikConfig = arg0_268.params

						arg0_265:SetIKState(false, function()
							var1_296.ikConfig = nil

							existCall(arg0_296)
						end)
					else
						assert(false)
					end
				end
			end,
			function()
				return function(arg0_299)
					arg0_265.blackSceneInfo = setmetatable(arg0_268.params or {}, {
						__index = {
							color = "#000000",
							time = 0.3,
							delay = arg0_268.name == "show" and 0 or 0.5
						}
					})

					if arg0_268.name == "show" then
						arg0_265:ShowBlackScreen(true, arg0_299)
					elseif arg0_268.name == "hide" then
						arg0_265:ShowBlackScreen(false, arg0_299)
					else
						assert(false)
					end

					arg0_265.blackSceneInfo = nil
				end
			end
		})
	end))
	table.insert(var2_265, function(arg0_300)
		arg0_265:SetUI(arg0_300, "back")

		arg0_265.performanceInfo = nil
	end)
	seriesAsync(var2_265, arg2_265)
end

function var0_0.TriggerContact(arg0_301, arg1_301)
	arg0_301:emit(Dorm3dRoomMediator.COLLECTION_ITEM, {
		itemId = arg1_301,
		roomId = arg0_301.room:GetConfigID(),
		groupId = arg0_301.room:isPersonalRoom() and arg0_301.apartment:GetConfigID() or 0
	})
end

function var0_0.UpdateContactState(arg0_302)
	arg0_302:SetContactStateDic(arg0_302.room:getTriggerableCollectItemDic(arg0_302.contextData.timeIndex))
end

function var0_0.UpdateFavorDisplay(arg0_303)
	local var0_303, var1_303 = getProxy(ApartmentProxy):getStamina()

	setText(arg0_303.rtStaminaDisplay:Find("Text"), string.format("%d/%d", var0_303, var1_303))
	setActive(arg0_303.rtStaminaDisplay, false)

	if arg0_303.apartment then
		setText(arg0_303.rtFavorLevel:Find("rank/Text"), arg0_303.apartment.level)

		local var2_303, var3_303 = arg0_303.apartment:getFavor()
		local var4_303 = arg0_303.apartment:isMaxFavor()

		setActive(arg0_303.rtFavorLevel:Find("Max"), var4_303)
		setActive(arg0_303.rtFavorLevel:Find("Text"), not var4_303)
		setText(arg0_303.rtFavorLevel:Find("Text"), string.format("<color=#ff6698>%d</color>/%d", var2_303, var3_303))
	end

	setActive(arg0_303.rtFavorLevel:Find("red"), Dorm3dLevelLayer.IsShowRed())
end

function var0_0.UpdateBtnState(arg0_304)
	local var0_304 = not arg0_304.room:isPersonalRoom() or arg0_304:CheckSystemOpen("Furniture")
	local var1_304 = Dorm3dFurniture.IsTimelimitShopTip(arg0_304.room:GetConfigID())

	setActive(arg0_304.uiContianer:Find("base/left/btn_furniture/tipTimelimit"), var0_304 and var1_304)

	local var2_304 = Dorm3dFurniture.NeedViewTip(arg0_304.room:GetConfigID())

	setActive(arg0_304.uiContianer:Find("base/left/btn_furniture/tip"), var0_304 and not var1_304 and var2_304)
	setActive(arg0_304.uiContianer:Find("base/btn_back/main"), underscore(getProxy(ApartmentProxy):getRawData()):chain():values():filter(function(arg0_305)
		return tobool(arg0_305)
	end):any(function(arg0_306)
		return #arg0_306:getSpecialTalking() > 0 or arg0_306:getIconTip() == "main"
	end):value())
	setActive(arg0_304.uiContianer:Find("base/left/btn_collection/tip"), PlayerPrefs.GetInt("apartment_collection_item", 0) > 0 or PlayerPrefs.GetInt("apartment_collection_recall", 0) > 0)
end

function var0_0.AddUnlockDisplay(arg0_307, arg1_307)
	table.insert(arg0_307.unlockList, arg1_307)

	if not isActive(arg0_307.rtFavorUp) then
		setText(arg0_307.rtFavorUp:Find("Text"), table.remove(arg0_307.unlockList, 1))
		setActive(arg0_307.rtFavorUp, true)
	end
end

function var0_0.PopFavorTrigger(arg0_308, arg1_308)
	local var0_308 = arg1_308.triggerId
	local var1_308 = arg1_308.delta
	local var2_308 = arg1_308.cost
	local var3_308 = arg1_308.apartment
	local var4_308 = pg.dorm3d_favor_trigger[var0_308]

	if var4_308.is_repeat == 0 then
		if var0_308 == getDorm3dGameset("drom3d_favir_trigger_onwer")[1] then
			arg0_308:AddUnlockDisplay(i18n("dorm3d_own_favor"))
		elseif var0_308 == getDorm3dGameset("drom3d_favir_trigger_propose")[1] then
			arg0_308:AddUnlockDisplay(i18n("dorm3d_pledge_favor"))
		else
			arg0_308:AddUnlockDisplay(string.format("unknow favor trigger:%d unlock", var0_308))
		end
	elseif arg1_308.delta > 0 then
		local var5_308, var6_308 = var3_308:getFavor()
		local var7_308 = var5_308 + var1_308

		setText(arg0_308.rtFavorUpDaily:Find("bg/Text"), string.format("<size=48>+%d</size>", math.min(9999, var1_308)))
		setSlider(arg0_308.rtFavorUpDaily:Find("bg/slider"), 0, var6_308, var5_308)
		setAnchoredPosition(arg0_308.rtFavorUpDaily:Find("bg"), arg1_308.isGift and NewPos(-354, 223) or NewPos(-208, 105))

		local var8_308 = {}
		local var9_308 = arg0_308.rtFavorUpDaily:Find("bg/effect")

		eachChild(var9_308, function(arg0_309)
			setActive(arg0_309, false)
		end)

		local var10_308

		if var4_308.effect and var4_308.effect ~= "" then
			var10_308 = var9_308:Find(var4_308.effect .. "(Clone)")

			if not var10_308 then
				table.insert(var8_308, function(arg0_310)
					LoadAndInstantiateAsync("Dorm3D/Effect/Prefab/ExpressionUI", "uifx_dorm3d_yinfu01", function(arg0_311)
						setParent(arg0_311, var9_308)

						var10_308 = tf(arg0_311)

						arg0_310()
					end)
				end)
			else
				setActive(var10_308, true)
			end
		end

		local var11_308 = arg0_308.rtFavorUpDaily:GetComponent("DftAniEvent")

		var11_308:SetTriggerEvent(function(arg0_312)
			local var0_312 = GetComponent(arg0_308.rtFavorUpDaily:Find("bg/slider"), typeof(Slider))

			LeanTween.value(var5_308, var7_308, 0.5):setOnUpdate(System.Action_float(function(arg0_313)
				var0_312.value = arg0_313
			end)):setEase(LeanTweenType.easeInOutQuad):setDelay(0.165):setOnComplete(System.Action(function()
				LeanTween.delayedCall(0.165, System.Action(function()
					if arg0_308.exited then
						return
					end

					quickPlayAnimator(arg0_308.rtFavorUpDaily, "favor_out")
				end))
			end))
			pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_progaress_bar")
		end)
		var11_308:SetEndEvent(function(arg0_316)
			setActive(arg0_308.rtFavorUpDaily, false)
		end)
		seriesAsync(var8_308, function()
			local var0_317 = arg0_308.ladyDict[var3_308:GetConfigID()]

			setLocalPosition(arg0_308.rtFavorUpDaily, arg0_308:GetLocalPosition(arg0_308:GetScreenPosition(var0_317.ladyHeadCenter.position), arg0_308.rtFavorUpDaily.parent))
			setActive(arg0_308.rtFavorUpDaily, true)
			SetCompomentEnabled(arg0_308.rtFavorUpDaily, typeof(Animator), true)
			quickPlayAnimator(arg0_308.rtFavorUpDaily, "favor_open")

			if var2_308 > 0 then
				local var1_317, var2_317 = getProxy(ApartmentProxy):getStamina()

				setText(arg0_308.rtStaminaPop:Find("Text/Text (1)"), "-" .. var2_308)
				setText(arg0_308.rtStaminaPop:Find("Text"), string.format("%d/%d", var1_317 + var2_308, var2_317))
				setActive(arg0_308.rtStaminaPop, true)
			end
		end)
	end
end

function var0_0.PopFavorLevelUp(arg0_318, arg1_318, arg2_318, arg3_318)
	arg0_318.isLock = true

	LeanTween.delayedCall(0.33, System.Action(function()
		arg0_318.isLock = false
	end))

	local var0_318 = math.floor(arg1_318.level / 10)
	local var1_318 = math.fmod(arg1_318.level, 10)

	GetImageSpriteFromAtlasAsync("ui/favor_atlas", var1_318, arg0_318.rtLevelUpWindow:Find("panel/bg/item1/mark/level/digit2"))
	GetImageSpriteFromAtlasAsync("ui/favor_atlas", var0_318, arg0_318.rtLevelUpWindow:Find("panel/bg/item1/mark/level/digit1"))
	setActive(arg0_318.rtLevelUpWindow:Find("panel/bg/item1/mark/level/digit1"), var0_318 > 0)

	local var2_318
	local var3_318

	arg0_318.clientAward, var3_318 = Dorm3dIconHelper.SplitStory(arg1_318:getFavorConfig("levelup_client_item", arg1_318.level))
	arg0_318.serverAward = arg2_318

	local var4_318 = arg0_318.rtLevelUpWindow:Find("panel/info/content/itemContent")

	if not arg0_318.levelItemList then
		arg0_318.levelItemList = UIItemList.New(var4_318, var4_318:Find("tpl"))

		arg0_318.levelItemList:make(function(arg0_320, arg1_320, arg2_320)
			local var0_320 = arg1_320 + 1

			if arg0_320 == UIItemList.EventUpdate then
				if arg1_320 < #arg0_318.serverAward then
					updateDorm3dIcon(arg2_320, arg0_318.serverAward[var0_320])
					onButton(arg0_318, arg2_320, function()
						arg0_318:emit(BaseUI.ON_NEW_DROP, {
							drop = arg0_318.serverAward[var0_320]
						})
					end, SFX_PANEL)
				else
					Dorm3dIconHelper.UpdateDorm3dIcon(arg2_320, arg0_318.clientAward[var0_320 - #arg0_318.serverAward])
					onButton(arg0_318, arg2_320, function()
						arg0_318:emit(Dorm3dRoomMediator.ON_DROP_CLIENT, {
							data = arg0_318.clientAward[var0_320 - #arg0_318.serverAward]
						})
					end, SFX_PANEL)
				end
			end
		end)
	end

	arg0_318.levelItemList:align(#arg0_318.serverAward + #arg0_318.clientAward)
	setActive(arg0_318.rtLevelUpWindow, true)
	pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_upgrade")
	pg.UIMgr.GetInstance():OverlayPanel(arg0_318.rtLevelUpWindow, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_DORM3D
	})

	function arg0_318.levelUpCallback()
		arg0_318.levelUpCallback = nil

		if var3_318 then
			arg0_318:PopNewStoryTip(var3_318)
		end

		existCall(arg3_318)
	end
end

function var0_0.PopNewStoryTip(arg0_324, arg1_324, arg2_324)
	local var0_324 = arg0_324.uiContianer:Find("base/top/story_tip")

	setActive(var0_324, true)
	LeanTween.delayedCall(1, System.Action(function()
		setActive(var0_324, false)
	end))
	setText(var0_324:Find("Text"), i18n("dorm3d_story_unlock_tip", pg.dorm3d_recall[arg1_324[2]].name))
	existCall(arg2_324)
end

function var0_0.UpdateZoneList(arg0_326)
	local var0_326

	if arg0_326.room:isPersonalRoom() then
		var0_326 = arg0_326.ladyDict[arg0_326.apartment:GetConfigID()].ladyBaseZone
	else
		var0_326 = arg0_326:GetAttachedFurnitureName()
	end

	for iter0_326, iter1_326 in ipairs(arg0_326.zoneDatas) do
		if iter1_326:GetWatchCameraName() == var0_326 then
			setText(arg0_326.btnZone:Find("Text"), iter1_326:GetName())
			setTextColor(arg0_326.rtZoneList:GetChild(iter0_326 - 1):Find("Name"), Color.NewHex("5CCAFF"))
		else
			setTextColor(arg0_326.rtZoneList:GetChild(iter0_326 - 1):Find("Name"), Color.NewHex("FFFFFF99"))
		end
	end
end

function var0_0.TalkingEventHandle(arg0_327, arg1_327)
	local var0_327 = {}
	local var1_327 = {}
	local var2_327 = arg1_327.data

	if var2_327.op_list then
		for iter0_327, iter1_327 in ipairs(var2_327.op_list) do
			table.insert(var0_327, function(arg0_328)
				local function var0_328()
					local var0_329 = arg0_328

					arg0_328 = nil

					return existCall(var0_329)
				end

				switch(iter1_327.type, {
					action = function()
						local var0_330 = arg0_327.ladyDict[arg0_327.apartment:GetConfigID()]

						arg0_327:PlaySingleAction(var0_330, iter1_327.name, var0_328)
					end,
					item_action = function()
						arg0_327:PlaySceneItemAnim(iter1_327.id, iter1_327.name)
						var0_328()
					end,
					extra_item_action = function()
						local var0_332 = arg0_327.ladyDict[arg0_327.apartment:GetConfigID()].extraItems[iter1_327.name]

						warning(iter1_327.name)
						warning(var0_332.trans)

						if var0_332 then
							var0_332.trans:GetComponent(typeof(Animator)):PlayInFixedTime(iter1_327.param)
						end

						var0_328()
					end,
					timeline = function()
						if arg0_327.inTouchGame then
							setActive(arg0_327.rtTouchGamePanel, false)
						end

						arg0_327:PlayTimeline(iter1_327, function(arg0_334, arg1_334)
							setActive(arg0_327.rtTouchGamePanel, arg0_327.inTouchGame)

							var1_327.notifiCallback = arg1_334

							var0_328()
						end)
					end,
					clickOption = function()
						arg0_327:DoTalkTouchOption(iter1_327, arg1_327.flags, function(arg0_336)
							var1_327.optionIndex = arg0_336

							var0_328()
						end)
					end,
					wait = function()
						arg0_327.LTs = arg0_327.LTs or {}

						table.insert(arg0_327.LTs, LeanTween.delayedCall(iter1_327.time, System.Action(var0_328)).uniqueId)
					end,
					expression = function()
						arg0_327:emit(arg0_327.PLAY_EXPRESSION, iter1_327)
						var0_328()
					end
				}, function()
					assert(false, "op type error:", iter1_327.type)
				end)

				if iter1_327.skip then
					var0_328()
				end
			end)
		end
	end

	seriesAsync(var0_327, function()
		if arg1_327.callbackData then
			arg0_327:emit(Dorm3dRoomMediator.TALKING_EVENT_FINISH, arg1_327.callbackData.name, var1_327)
		end
	end)
end

function var0_0.CheckQueue(arg0_341)
	if arg0_341.inGuide or arg0_341.uiState ~= "base" then
		return
	end

	if arg0_341.room:GetConfigID() == 1 and arg0_341:CheckGuide() then
		-- block empty
	elseif arg0_341.room:isPersonalRoom() and arg0_341:CheckLevelUp() then
		-- block empty
	elseif arg0_341.apartment and arg0_341:CheckEnterDeal() then
		-- block empty
	elseif arg0_341.apartment and arg0_341:CheckActiveTalk() then
		-- block empty
	elseif arg0_341.apartment then
		arg0_341:CheckFavorTrigger()
	end

	arg0_341.contextData.hasEnterCheck = true
end

function var0_0.didEnterCheck(arg0_342)
	local var0_342

	if arg0_342.contextData.specialId then
		var0_342 = arg0_342.contextData.specialId
		arg0_342.contextData.specialId = nil

		arg0_342:DoTalk(var0_342, function()
			arg0_342:closeView()
		end)

		if arg0_342.contextData.isVideoTalk then
			arg0_342.contextData.hasEnterCheck = true
		end
	elseif not arg0_342.contextData.hasEnterCheck and arg0_342.apartment then
		for iter0_342, iter1_342 in ipairs(arg0_342.apartment:getForceEnterTalking(arg0_342.room:GetConfigID())) do
			var0_342 = iter1_342

			arg0_342:DoTalk(iter1_342)

			break
		end
	end

	if var0_342 and pg.dorm3d_dialogue_group[var0_342].extend_loading > 0 then
		arg0_342.contextData.hasEnterCheck = true

		pg.SceneAnimMgr.GetInstance():RegisterDormNextCall(function()
			arg0_342:FinishEnterResume()
		end)
	else
		if arg0_342.apartment and arg0_342.contextData.pendingDic[arg0_342.apartment:GetConfigID()] then
			arg0_342.contextData.hasEnterCheck = true
		end

		for iter2_342, iter3_342 in pairs(arg0_342.contextData.pendingDic) do
			arg0_342:SetInPending(arg0_342.ladyDict[iter2_342], iter3_342)
		end

		arg0_342.contextData.pendingDic = {}

		arg0_342:FinishEnterResume()
		arg0_342:CheckQueue()
	end
end

function var0_0.CheckGuide(arg0_345)
	if arg0_345:GetBlackboardValue(arg0_345.ladyDict[arg0_345.apartment:GetConfigID()], "inPending") then
		return
	end

	for iter0_345, iter1_345 in ipairs({
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
				return arg0_345:CheckSystemOpen("Furniture")
			end
		},
		{
			name = "DORM3D_GUIDE_07",
			active = function()
				return arg0_345:CheckSystemOpen("DayNight")
			end
		}
	}) do
		if not pg.NewStoryMgr.GetInstance():IsPlayed(iter1_345.name) and iter1_345.active() then
			arg0_345:SetAllBlackbloardValue("inGuide", true)

			local function var0_345()
				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(2, pg.NewStoryMgr.GetInstance():StoryName2StoryId(iter1_345.name)))
				arg0_345:SetAllBlackbloardValue("inGuide", false)
			end

			pg.m02:sendNotification(GAME.STORY_UPDATE, {
				storyId = iter1_345.name
			})
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(1, pg.NewStoryMgr.GetInstance():StoryName2StoryId(iter1_345.name)))
			pg.NewGuideMgr.GetInstance():Play(iter1_345.name, nil, var0_345, var0_345)

			return true
		end
	end

	return false
end

function var0_0.CheckFavorTrigger(arg0_351)
	for iter0_351, iter1_351 in ipairs({
		{
			triggerId = getDorm3dGameset("drom3d_favir_trigger_onwer")[1],
			active = function()
				local var0_352 = getProxy(CollectionProxy):getShipGroup(arg0_351.apartment.configId)

				return tobool(var0_352)
			end
		},
		{
			triggerId = getDorm3dGameset("drom3d_favir_trigger_propose")[1],
			active = function()
				local var0_353 = getProxy(CollectionProxy):getShipGroup(arg0_351.apartment.configId)

				return var0_353 and var0_353.married > 0
			end
		}
	}) do
		if arg0_351.apartment.triggerCountDic[iter1_351.triggerId] == 0 and iter1_351.active() then
			arg0_351:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_351.apartment.configId, iter1_351.triggerId)
		end
	end
end

function var0_0.CheckEnterDeal(arg0_354)
	if arg0_354.contextData.hasEnterCheck then
		return false
	end

	local var0_354 = arg0_354.apartment:GetConfigID()
	local var1_354 = "dorm3d_enter_count_" .. var0_354
	local var2_354 = pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d")

	if PlayerPrefs.GetString("dorm3d_enter_count_day") ~= var2_354 then
		PlayerPrefs.SetString("dorm3d_enter_count_day", var2_354)
		PlayerPrefs.SetInt(var1_354, 1)
	else
		PlayerPrefs.SetInt(var1_354, PlayerPrefs.GetInt(var1_354, 0) + 1)
	end

	local var3_354 = arg0_354.apartment:getEnterTalking(arg0_354.room:GetConfigID())

	PlayerPrefs.SetString("DORM3D_DAILY_ENTER", pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d"))

	if #var3_354 > 0 then
		arg0_354:DoTalk(var3_354[math.random(#var3_354)])

		return true
	end
end

function var0_0.CheckActiveTalk(arg0_355)
	local var0_355 = arg0_355.ladyDict[arg0_355.apartment:GetConfigID()]

	if arg0_355:GetBlackboardValue(var0_355, "inPending") then
		return false
	end

	local var1_355 = arg0_355.apartment:getZoneTalking(arg0_355.room:GetConfigID(), var0_355.ladyBaseZone)

	if #var1_355 > 0 then
		arg0_355:DoTalk(var1_355[1])

		return true
	else
		return false
	end
end

function var0_0.CheckDistanceTalk(arg0_356, arg1_356, arg2_356)
	local var0_356 = arg0_356.ladyDict[arg1_356].ladyBaseZone
	local var1_356 = getProxy(ApartmentProxy):getApartment(arg1_356)

	for iter0_356, iter1_356 in ipairs(var1_356:getDistanceTalking(arg0_356.room:GetConfigID(), var0_356)) do
		arg0_356:DoTalk(iter1_356)

		return
	end
end

function var0_0.CheckSystemOpen(arg0_357, arg1_357)
	if arg0_357.room:isPersonalRoom() then
		return switch(arg1_357, {
			Talk = function()
				local var0_358 = 1

				return var0_358 <= arg0_357.apartment.level, i18n("apartment_level_unenough", var0_358)
			end,
			Touch = function()
				local var0_359 = getDorm3dGameset("drom3d_touch_dialogue")[1]

				return var0_359 <= arg0_357.apartment.level, i18n("apartment_level_unenough", var0_359)
			end,
			Gift = function()
				local var0_360 = getDorm3dGameset("drom3d_gift_dialogue")[1]

				return var0_360 <= arg0_357.apartment.level, i18n("apartment_level_unenough", var0_360)
			end,
			PublicGame = function()
				return false
			end,
			Photo = function()
				local var0_362 = getDorm3dGameset("drom3d_photograph_unlock")[1]

				return var0_362 <= arg0_357.apartment.level, i18n("apartment_level_unenough", var0_362)
			end,
			Collection = function()
				local var0_363 = getDorm3dGameset("drom3d_recall_unlock")[1]

				return var0_363 <= arg0_357.apartment.level, i18n("apartment_level_unenough", var0_363)
			end,
			Furniture = function()
				local var0_364 = getDorm3dGameset("drom3d_furniture_unlock")[1]

				return var0_364 <= arg0_357.apartment.level, i18n("apartment_level_unenough", var0_364)
			end,
			DayNight = function()
				local var0_365 = getDorm3dGameset("drom3d_time_unlock")[1]

				return var0_365 <= arg0_357.apartment.level, i18n("apartment_level_unenough", var0_365)
			end,
			Accompany = function()
				local var0_366 = 1

				return var0_366 <= arg0_357.apartment.level, i18n("apartment_level_unenough", var0_366)
			end,
			MiniGame = function()
				local var0_367 = 1

				if var0_367 > arg0_357.apartment.level then
					return false, i18n("apartment_level_unenough", var0_367)
				elseif #arg0_357.room:getMiniGames() <= 0 then
					return false, "without minigame config in room:" .. arg0_357.room.configId
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
		return switch(arg1_357, {
			Gift = function()
				return false
			end,
			PublicGame = function()
				return true
			end,
			Furniture = function()
				local var0_373 = #arg0_357.room:GetFurnitures() > 0
				local var1_373 = #_.filter(arg0_357.room:GetFurnitureIDList() or {}, function(arg0_374)
					return Dorm3dFurniture.New({
						configId = arg0_374
					}):InShopTime()
				end) > 0

				return var0_373 or var1_373
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
