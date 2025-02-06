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
	Shader.SetGlobalFloat("_ScreenClipOff", 1)

	arg0_4.uiContianer = arg0_4._tf:Find("UI")

	local var0_4 = arg0_4.uiContianer:Find("base")

	onButton(arg0_4, var0_4:Find("btn_back"), function()
		arg0_4:emit(BaseUI.ON_BACK)
	end, "ui-dorm_back_v2")
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
		setActive(var0_4:Find("left/line_furniture"), false)
		setActive(var0_4:Find("left/btn_furniture"), false)
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
	UIItemList.StaticAlign(arg0_4.rtZoneList, arg0_4.rtZoneList:GetChild(0), #arg0_4.zoneDatas, function(arg0_18, arg1_18, arg2_18)
		if arg0_18 ~= UIItemList.EventUpdate then
			return
		end

		arg1_18 = arg1_18 + 1

		local var0_18 = arg0_4.zoneDatas[arg1_18]
		local var1_18 = var0_18:GetWatchCameraName()

		arg2_18.name = var1_18

		setText(arg2_18:Find("Name"), var0_18:GetName())
		setActive(arg2_18:Find("Line"), arg1_18 < #arg0_4.zoneDatas)
		onButton(arg0_4, arg2_18, function()
			if arg0_4.uiState ~= "base" then
				return
			end

			setActive(arg0_4.rtZoneList, false)

			local var0_19 = {}

			if arg0_4.room:isPersonalRoom() and not arg0_4:GetBlackboardValue(arg0_4.ladyDict[arg0_4.apartment:GetConfigID()], "inPending") then
				table.insert(var0_19, function(arg0_20)
					arg0_4:OutOfLazy(arg0_4.apartment:GetConfigID(), arg0_20)
				end)
			end

			table.insert(var0_19, function(arg0_21)
				arg0_4:ShiftZone(var1_18, arg0_21)
			end)
			seriesAsync(var0_19, function()
				arg0_4:CheckQueue()
			end)
		end, SFX_PANEL)
	end)

	local var1_4 = arg0_4.uiContianer:Find("walk")
	local var2_4 = arg0_4.uiContianer:Find("ik")

	onButton(arg0_4, var2_4:Find("btn_back"), function()
		if isActive(var2_4:Find("Panel")) then
			triggerButton(var2_4:Find("Panel/BG/Close"))

			return
		end

		if arg0_4.ikSpecialCall then
			local var0_23 = arg0_4.ikSpecialCall

			arg0_4.ikSpecialCall = nil

			existCall(var0_23)
		else
			arg0_4:ExitTouchMode()
		end
	end, "ui-dorm_back_v2")
	onButton(arg0_4, var2_4:Find("btn_back_heartbeat"), function()
		arg0_4:ExitHeartbeatMode()
	end, "ui-dorm_back_v2")
	setActive(var2_4:Find("btn_back_heartbeat"), false)
	onButton(arg0_4, var2_4:Find("btn_back/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("roll_gametip")
		})
	end, SFX_PANEL)
	onButton(arg0_4, var2_4:Find("Right/btn_camera"), function()
		arg0_4:CycleIKCameraGroup()
	end, SFX_PANEL)
	onButton(arg0_4, var2_4:Find("Right/MenuSmall"), function()
		setActive(var2_4:Find("Right/MenuSmall"), false)
		setActive(var2_4:Find("Right/Menu"), true)
	end, SFX_PANEL)
	onButton(arg0_4, var2_4:Find("Right/Menu/Collapse"), function()
		setActive(var2_4:Find("Right/Menu"), false)
		setActive(var2_4:Find("Right/MenuSmall"), true)
	end, SFX_PANEL)

	local function var3_4()
		local var0_29 = arg0_4.apartment:GetConfigID()
		local var1_29 = arg0_4.ladyDict[var0_29]
		local var2_29 = var1_29.skinIdList
		local var3_29 = var1_29.skinId
		local var4_29 = {}
		local var5_29 = {}

		_.each(var2_29, function(arg0_30)
			if ApartmentProxy.CheckUnlockConfig(pg.dorm3d_resource[arg0_30].unlock) then
				table.insert(var4_29, arg0_30)
			else
				table.insert(var5_29, arg0_30)
			end
		end)

		local function var6_29(arg0_31, arg1_31)
			local var0_31 = arg1_31 and var4_29 or var5_29

			UIItemList.StaticAlign(arg0_31, arg0_31:GetChild(0), #var0_31, function(arg0_32, arg1_32, arg2_32)
				if arg0_32 ~= UIItemList.EventUpdate then
					return
				end

				local var0_32 = var0_31[arg1_32 + 1]

				setActive(arg2_32:Find("Selected"), var0_32 == var3_29)
				setActive(arg2_32:Find("Lock"), not arg1_31)

				if not arg1_31 then
					setText(arg2_32:Find("Lock/Bar/Text"), pg.dorm3d_resource[var0_32].unlock_text)
				end

				arg0_4.loader:GetSpriteQuiet(string.format("dorm3dselect/apartment_skin_%d", var0_32), "", arg2_32:Find("Icon"))
				onButton(arg0_4, arg2_32, function()
					if not arg1_31 then
						local var0_33, var1_33 = ApartmentProxy.CheckUnlockConfig(pg.dorm3d_resource[var0_32].unlock)

						pg.TipsMgr.GetInstance():ShowTips(var1_33)

						return
					end

					if var0_32 == var3_29 then
						return
					end

					local var2_33 = var0_32

					seriesAsync({
						function(arg0_34)
							arg0_4:SetIKState(false, arg0_34)
						end,
						function(arg0_35)
							arg0_4:SwitchCharacterSkin(var1_29, var0_29, var2_33)
							arg0_4:SwitchIKConfig(var1_29, var1_29.ikConfig.id)
							arg0_4:SetIKState(true, arg0_35)
						end,
						var3_4
					})
				end, SFX_PANEL)
			end)
		end

		var6_29(var2_4:Find("Panel/BG/Scroll/Content/Unlock/List"), true)
		var6_29(var2_4:Find("Panel/BG/Scroll/Content/Lock/List"), false)
	end

	onButton(arg0_4, var2_4:Find("Right/Menu"), function()
		setActive(var2_4:Find("Right"), false)
		setActive(var2_4:Find("Panel"), true)
		var3_4()
	end, SFX_PANEL)
	onButton(arg0_4, var2_4:Find("Panel/BG/Close"), function()
		setActive(var2_4:Find("Panel"), false)
		setActive(var2_4:Find("Right"), true)
	end, SFX_PANEL)
	setText(var2_4:Find("Panel/BG/Scroll/Content/Unlock/Title/Text"), i18n("word_unlock"))
	setText(var2_4:Find("Panel/BG/Scroll/Content/Lock/Title/Text"), i18n("word_lock"))

	arg0_4.ikTipsRoot = var2_4:Find("Tips")

	setActive(arg0_4.ikTipsRoot, false)

	arg0_4.ikClickTipsRoot = var2_4:Find("ClickTips")

	setActive(arg0_4.ikClickTipsRoot, false)

	arg0_4.ikHand = var2_4:Find("Handler")

	setActive(arg0_4.ikHand, false)
	eachChild(arg0_4.ikHand, function(arg0_38)
		setActive(arg0_38, false)
	end)

	arg0_4.ikTextTipsRoot = var2_4:Find("TextTips")

	setActive(arg0_4.ikTextTipsRoot, false)
	eachChild(arg0_4.ikTextTipsRoot, function(arg0_39)
		setActive(arg0_39, false)
	end)

	local var4_4 = arg0_4.uiContianer:Find("accompany")

	onButton(arg0_4, var4_4:Find("btn_back"), function()
		arg0_4:ExitAccompanyMode()
	end, "ui-dorm_back_v2")

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

	local var5_4 = arg0_4.rtStaminaPop:GetComponent("DftAniEvent")

	var5_4:SetTriggerEvent(function(arg0_42)
		local var0_42, var1_42 = getProxy(ApartmentProxy):getStamina()

		setText(arg0_4.rtStaminaPop:Find("Text"), string.format("%d/%d", var0_42, var1_42))
	end)
	var5_4:SetEndEvent(function(arg0_43)
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

	local var6_4 = arg0_4.uiContianer:Find("watch")

	onButton(arg0_4, var6_4:Find("btn_back"), function()
		arg0_4:ExitWatchMode()
	end, "ui-dorm_back_v2")
	onButton(arg0_4, var6_4:Find("btn_back/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("roll_gametip")
		})
	end, SFX_PANEL)

	arg0_4.rtStaminaDisplay = var6_4:Find("stamina")
	arg0_4.rtRole = arg0_4.uiContianer:Find("watch/Role")

	onButton(arg0_4, arg0_4.rtRole:Find("Talk"), function()
		local var0_48 = arg0_4.ladyDict[arg0_4.apartment:GetConfigID()].ladyBaseZone
		local var1_48 = arg0_4.apartment:getFurnitureTalking(arg0_4.room:GetConfigID(), var0_48)

		if #var1_48 == 0 then
			pg.TipsMgr.GetInstance():ShowTips("without topic")

			return
		end

		arg0_4:DoTalk(var1_48[math.random(#var1_48)], function()
			local var0_49 = getDorm3dGameset("drom3d_favir_trigger_talk")[1]

			arg0_4:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_4.apartment.configId, var0_49)
		end)
	end, "ui-dorm_click_v2")
	setText(arg0_4.rtRole:Find("Talk/bg/Text"), i18n("dorm3d_talk"))
	onButton(arg0_4, arg0_4.rtRole:Find("Touch"), function()
		arg0_4:EnterTouchMode()
	end, "ui-dorm_click_v2")
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
	end, "ui-dorm_click_v2")
	setText(arg0_4.rtRole:Find("Gift/bg/Text"), i18n("dorm3d_gift"))
	onButton(arg0_4, arg0_4.rtRole:Find("MiniGame"), function()
		assert(not arg0_4.nowMiniGameId)

		arg0_4.nowMiniGameId = arg0_4.room:getMiniGames()[1]

		local var0_53 = pg.dorm3d_minigame[arg0_4.nowMiniGameId]
		local var1_53 = arg0_4.ladyDict[arg0_4.apartment:GetConfigID()]
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
	end, "ui-dorm_click_v2")
	setText(arg0_4.rtRole:Find("MiniGame/bg/Text"), i18n("dorm3d_minigame_button1"))
	onButton(arg0_4, arg0_4.rtRole:Find("Volleyball"), function()
		arg0_4:emit(Dorm3dRoomMediator.ENTER_VOLLEYBALL, arg0_4.apartment:GetConfigID())
	end, "ui-dorm_click_v2")
	setText(arg0_4.rtRole:Find("Volleyball/bg/Text"), i18n("dorm3d_volleyball_button"))
	onButton(arg0_4, arg0_4.rtRole:Find("Performance"), function()
		arg0_4:DoTalk(20500, function()
			pg.TipsMgr.GetInstance():ShowTips("Success!")
		end)
	end, "ui-dorm_click_v2")

	arg0_4.rtFloatPage = arg0_4._tf:Find("FloatPage")
	arg0_4.tplFloat = arg0_4.rtFloatPage:Find("tpl")

	setActive(arg0_4.tplFloat, false)

	local var7_4 = cloneTplTo(arg0_4.tplFloat, arg0_4.rtFloatPage, "lady")

	eachChild(var7_4, function(arg0_65)
		setActive(arg0_65, arg0_65.name == "walk")
	end)

	arg0_4._joystick = arg0_4._tf:Find("Stick")

	setActive(arg0_4._joystick, false)
	arg0_4._joystick:GetComponent(typeof(SlideController)):SetStickFunc(function(arg0_66)
		arg0_4:emit(arg0_4.ON_STICK_MOVE, arg0_66)
	end)

	arg0_4.povLayer = arg0_4._tf:Find("POVControl")

	setActive(arg0_4.povLayer, false)
	;(function()
		local var0_67 = arg0_4.povLayer:Find("Move"):GetComponent(typeof(SlideController))

		var0_67:AddBeginDragFunc(function(arg0_68, arg1_68)
			arg0_4:emit(arg0_4.ON_POV_STICK_MOVE_BEGIN, arg1_68)
		end)
		var0_67:SetStickFunc(function(arg0_69)
			arg0_4:emit(arg0_4.ON_POV_STICK_MOVE, arg0_69)
		end)
		var0_67:AddDragEndFunc(function(arg0_70, arg1_70)
			arg0_4:emit(arg0_4.ON_POV_STICK_MOVE_END, arg1_70)
		end)
		arg0_4.povLayer:Find("View"):GetComponent(typeof(SlideController)):SetStickFunc(function(arg0_71)
			arg0_4:emit(arg0_4.ON_POV_STICK_VIEW, arg0_71)
		end)
	end)()

	arg0_4.ikControlLayer = var2_4:Find("ControlLayer")

	;(function()
		local var0_72
		local var1_72 = arg0_4.ikControlLayer:GetComponent(typeof(SlideController))

		var1_72:AddBeginDragFunc(function(arg0_73, arg1_73)
			local var0_73 = arg0_4.ladyDict[arg0_4.apartment:GetConfigID()]

			if not var0_73.IKSettings then
				return
			end

			local var1_73 = arg1_73.position
			local var2_73 = CameraMgr.instance:Raycast(var0_73.IKSettings.CameraRaycaster, var1_73)

			if var2_73.Length ~= 0 then
				local var3_73 = var2_73[0].gameObject.transform
				local var4_73 = table.keyof(var0_73.IKSettings.Colliders, var3_73)

				if var4_73 then
					arg0_4:emit(var0_0.ON_BEGIN_DRAG_CHARACTER_BODY, var0_73, var4_73, var1_73)

					var0_72 = tobool(var0_73.ikHandler)

					return
				end
			end
		end)
		var1_72:AddDragFunc(function(arg0_74, arg1_74)
			local var0_74 = arg1_74.position
			local var1_74 = arg0_4.ladyDict[arg0_4.apartment:GetConfigID()]

			if var1_74.ikHandler then
				var1_74:emit(var0_0.ON_DRAG_CHARACTER_BODY, var1_74, var0_74)

				return
			end

			if var0_72 then
				return
			end

			local var2_74 = arg1_74.delta

			arg0_4:emit(arg0_4.ON_STICK_MOVE, var2_74)
		end)
		var1_72:AddDragEndFunc(function(arg0_75, arg1_75)
			var0_72 = nil

			local var0_75 = arg0_4.ladyDict[arg0_4.apartment:GetConfigID()]

			if var0_75.ikHandler then
				var0_75:emit(var0_0.ON_RELEASE_CHARACTER_BODY, var0_75)

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

function var0_0.BindEvent(arg0_77)
	var0_0.super.BindEvent(arg0_77)
	arg0_77:bind(arg0_77.CLICK_CHARACTER, function(arg0_78, arg1_78)
		if arg0_77.uiState ~= "base" or not arg0_77.ladyDict[arg1_78].nowCanWatchState then
			return
		end

		local var0_78 = {}
		local var1_78 = arg0_77.ladyDict[arg1_78]

		if arg0_77:GetBlackboardValue(var1_78, "inPending") then
			table.insert(var0_78, function(arg0_79)
				var1_78:OutOfPending(arg1_78, arg0_79)
			end)
		else
			table.insert(var0_78, function(arg0_80)
				arg0_77:OutOfLazy(arg1_78, arg0_80)
			end)
		end

		seriesAsync(var0_78, function()
			if not arg0_77.room:isPersonalRoom() then
				arg0_77:SetApartment(getProxy(ApartmentProxy):getApartment(arg1_78))
			end

			arg0_77:EnterWatchMode()
		end)
		pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_touch_v1")
	end)
	arg0_77:bind(arg0_77.CLICK_CONTACT, function(arg0_82, arg1_82)
		arg0_77:TriggerContact(arg1_82)
	end)
	arg0_77:bind(arg0_77.DISTANCE_TRIGGER, function(arg0_83, arg1_83, arg2_83)
		if arg0_77.uiState == "base" then
			arg0_77:CheckDistanceTalk(arg1_83, arg2_83)
		end
	end)
	arg0_77:bind(arg0_77.WALK_DISTANCE_TRIGGER, function(arg0_84, arg1_84, arg2_84)
		if arg0_77.apartment and arg0_77.apartment:GetConfigID() == arg1_84 then
			existCall(arg0_77.walkNearCallback, arg2_84)
		end
	end)
	arg0_77:bind(arg0_77.CHANGE_WATCH, function(arg0_85, arg1_85)
		arg0_77:ChangeCanWatchState(arg0_77.ladyDict[arg1_85])
	end)
	arg0_77:bind(arg0_77.ON_TOUCH_CHARACTER, function(arg0_86, arg1_86)
		local var0_86 = arg0_77.ladyDict[arg0_77.apartment:GetConfigID()]

		if not arg0_77:GetBlackboardValue(var0_86, "inIK") then
			return
		end

		arg0_77:OnTouchCharacterBody(arg1_86)
	end)
	arg0_77:bind(var0_0.ON_IK_STATUS_CHANGED, function(arg0_87, arg1_87, arg2_87)
		local var0_87 = arg0_77.ladyDict[arg0_77.apartment:GetConfigID()]

		if not arg0_77:GetBlackboardValue(var0_87, "inTouching") then
			return
		end

		arg0_77:DoTouch(arg1_87, arg2_87)
	end)
	arg0_77:bind(arg0_77.ON_ENTER_SECTOR, function(arg0_88, arg1_88)
		arg0_77:ChangeCanWatchState(arg0_77.ladyDict[arg1_88])
	end)
	arg0_77:bind(arg0_77.ON_CHANGE_DISTANCE, function(arg0_89, arg1_89, arg2_89)
		arg0_77:ChangeCanWatchState(arg0_77.ladyDict[arg1_89])
	end)
end

function var0_0.didEnter(arg0_90)
	arg0_90.resumeCallback = arg0_90.contextData.resumeCallback
	arg0_90.contextData.resumeCallback = nil

	var0_0.super.didEnter(arg0_90)
	arg0_90:UpdateZoneList()
	arg0_90:SetUI(function()
		arg0_90:didEnterCheck()
	end, "base")
end

function var0_0.FinishEnterResume(arg0_92)
	if not arg0_92.resumeCallback then
		return
	end

	local var0_92 = arg0_92.resumeCallback

	arg0_92.resumeCallback = nil

	return var0_92()
end

function var0_0.EnableJoystick(arg0_93, arg1_93)
	setActive(arg0_93._joystick, arg1_93)
end

function var0_0.EnablePOVLayer(arg0_94, arg1_94)
	setActive(arg0_94.povLayer, arg1_94)

	if not arg1_94 then
		arg0_94:emit(arg0_94.ON_POV_STICK_MOVE_END)
	end
end

function var0_0.SetUIStore(arg0_95, arg1_95, ...)
	table.insertto(arg0_95.uiStore, {
		...
	})
	existCall(arg1_95)
end

function var0_0.SetUI(arg0_96, arg1_96, ...)
	while rawget(arg0_96, "class") ~= var0_0 do
		arg0_96 = getmetatable(arg0_96).__index
	end

	table.insertto(arg0_96.uiStore, {
		...
	})

	for iter0_96, iter1_96 in ipairs(arg0_96.uiStore) do
		if iter1_96 == "back" then
			assert(#arg0_96.uiStack > 0)

			arg0_96.uiState = table.remove(arg0_96.uiStack)
		elseif iter1_96 == arg0_96.uiState and iter1_96 == "ik" then
			-- block empty
		else
			table.insert(arg0_96.uiStack, arg0_96.uiState)

			arg0_96.uiState = iter1_96
		end
	end

	arg0_96.uiStore = {}

	eachChild(arg0_96.uiContianer, function(arg0_97)
		setActive(arg0_97, arg0_97.name == arg0_96.uiState)
	end)
	arg0_96:EnablePOVLayer(arg0_96.uiState == "base" or arg0_96.uiState == "walk")
	arg0_96:TempHideContact(arg0_96.uiState ~= "base")
	arg0_96:SetFloatEnable(arg0_96.uiState == "walk")
	setActive(arg0_96.rtFloatPage, arg0_96.uiState == "walk")
	switch(arg0_96.uiState, {
		base = function()
			if not arg0_96.room:isPersonalRoom() then
				arg0_96:SetApartment(nil)
			end

			arg0_96:UpdateBtnState()
		end,
		watch = function()
			eachChild(arg0_96.rtRole, function(arg0_100)
				setActive(arg0_100, false)
			end)

			local var0_99 = underscore.filter({
				"Talk",
				"Touch",
				"Gift",
				"MiniGame",
				"Volleyball",
				"Performance"
			}, function(arg0_101)
				return arg0_96:CheckSystemOpen(arg0_101)
			end)
			local var1_99 = 0.05

			for iter0_99, iter1_99 in ipairs(var0_99) do
				LeanTween.delayedCall(var1_99, System.Action(function()
					setActive(arg0_96.rtRole:Find(iter1_99), true)
				end))

				var1_99 = var1_99 + 0.066
			end

			setActive(arg0_96.rtRole:Find("Gift/bg/Tip"), Dorm3dGift.NeedViewTip(arg0_96.apartment:GetConfigID()))
		end,
		ik = function()
			setActive(arg0_96.uiContianer:Find("ik/Right/MenuSmall"), arg0_96.room:isPersonalRoom() and not arg0_96.performanceInfo)
			setActive(arg0_96.uiContianer:Find("ik/Right/Menu"), false)
		end,
		walk = function()
			setText(arg0_96.uiContianer:Find("walk/dialogue/content"), i18n("dorm3d_removable", arg0_96.apartment:getConfig("name")))
		end
	})
	arg0_96:ActiveStateCamera(arg0_96.uiState, function()
		if arg1_96 then
			arg1_96()
		elseif arg0_96.uiState == "base" then
			arg0_96:CheckQueue()
		end
	end)
end

function var0_0.EnterWatchMode(arg0_106)
	local var0_106 = arg0_106.apartment:GetConfigID()

	seriesAsync({
		function(arg0_107)
			arg0_106:emit(arg0_106.SHOW_BLOCK)
			arg0_106:SetBlackboardValue(arg0_106.ladyDict[var0_106], "inWatchMode", true)
			arg0_106:SetUI(arg0_107, "watch")
		end,
		function(arg0_108)
			arg0_106:emit(arg0_106.HIDE_BLOCK)
		end
	})
end

function var0_0.ExitWatchMode(arg0_109)
	local var0_109 = arg0_109.apartment:GetConfigID()

	seriesAsync({
		function(arg0_110)
			arg0_109:emit(arg0_109.SHOW_BLOCK)
			arg0_109:SetUI(arg0_110, "back")
		end,
		function(arg0_111)
			arg0_109:SetBlackboardValue(arg0_109.ladyDict[var0_109], "inWatchMode", false)
			arg0_109:emit(arg0_109.HIDE_BLOCK)
			arg0_109:CheckQueue()
		end
	})
end

function var0_0.SetInPending(arg0_112, arg1_112, arg2_112)
	local var0_112 = arg0_112:GetBlackboardValue(arg1_112, "groupId")
	local var1_112 = pg.dorm3d_welcome[arg2_112]

	arg0_112:SetBlackboardValue(arg1_112, "inPending", true)
	arg0_112:ChangeCanWatchState(arg1_112)
	arg0_112:EnableHeadIK(arg1_112, false)

	arg0_112.contextData.ladyZone[var0_112] = var1_112.area
	arg1_112.ladyBaseZone = arg0_112.contextData.ladyZone[var0_112]
	arg1_112.ladyActiveZone = var1_112.welcome_staypoint

	arg0_112:ChangeCharacterPosition(arg1_112)

	if var1_112.item_shield ~= "" then
		arg0_112.hideItemDic = {}

		for iter0_112, iter1_112 in ipairs(var1_112.item_shield) do
			local var2_112 = arg0_112.modelRoot:Find(iter1_112)

			if not var2_112 then
				warning(string.format("welcome:%d without hide item:%s", arg2_112, iter1_112))
			else
				arg0_112.hideItemDic[iter1_112] = isActive(var2_112)

				setActive(var2_112, false)
			end
		end
	end

	onNextTick(function()
		if arg1_112.tfPendintItem then
			setActive(arg1_112.tfPendintItem, true)
		end

		arg0_112:SwitchAnim(arg1_112, var1_112.welcome_idle)
	end)

	arg0_112.wakeUpTalkId = var1_112.welcome_talk
end

function var0_0.SetOutPending(arg0_114, arg1_114)
	arg0_114:SetBlackboardValue(arg1_114, "inPending", false)
	arg0_114:ChangeCanWatchState(arg1_114)
	arg0_114:EnableHeadIK(arg1_114, true)

	arg0_114.wakeUpTalkId = nil

	if arg1_114.tfPendintItem then
		setActive(arg1_114.tfPendintItem, false)
	end

	if arg0_114.hideItemDic then
		for iter0_114, iter1_114 in pairs(arg0_114.hideItemDic) do
			setActive(arg0_114.modelRoot:Find(iter0_114), iter1_114)
		end

		arg0_114.hideItemDic = nil
	end
end

function var0_0.IsModeInHidePending(arg0_115, arg1_115)
	for iter0_115, iter1_115 in pairs(arg0_115.ladyDict) do
		if iter1_115.hideItemDic and iter1_115.hideItemDic[arg1_115] ~= nil then
			return true
		end
	end

	return false
end

function var0_0.EnterAccompanyMode(arg0_116, arg1_116)
	local var0_116 = pg.dorm3d_accompany[arg1_116]
	local var1_116
	local var2_116

	if var0_116.sceneInfo ~= "" then
		var1_116, var2_116 = unpack(string.split(var0_116.sceneInfo, "|"))
	end

	local var3_116 = {
		type = "timeline",
		name = var0_116.timeline,
		scene = var1_116,
		sceneRoot = var2_116,
		accompanys = {}
	}

	for iter0_116, iter1_116 in ipairs(var0_116.jump_trigger) do
		local var4_116, var5_116 = unpack(iter1_116)

		var3_116.accompanys[var4_116] = var5_116
	end

	local var6_116, var7_116 = unpack(var0_116.favor)

	getProxy(ApartmentProxy):RecordAccompanyTime()
	pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataAccompany(1, var0_116.ship_id, var0_116.performance_time, 0, var1_116 or arg0_116.dormSceneMgr.artSceneInfo))

	local var8_116 = {}

	table.insert(var8_116, function(arg0_117)
		arg0_116:SetUI(arg0_117, "blank", "accompany")
	end)
	table.insert(var8_116, function(arg0_118)
		arg0_116.accompanyFavorCount = 0
		arg0_116.accompanyFavorTimer = Timer.New(function()
			arg0_116.accompanyFavorCount = arg0_116.accompanyFavorCount + 1
		end, var6_116, -1)

		arg0_116.accompanyFavorTimer:Start()

		arg0_116.accompanyPerformanceTimer = Timer.New(function()
			arg0_116.canTriggerAccompanyPerformance = true
		end, var0_116.performance_time, -1)

		arg0_116.accompanyPerformanceTimer:Start()
		arg0_116:PlayTimeline(var3_116, function(arg0_121, arg1_121)
			arg1_121()
			arg0_118()
		end)
	end)
	seriesAsync(var8_116, function()
		assert(arg0_116.accompanyFavorTimer)
		arg0_116.accompanyFavorTimer:Stop()

		arg0_116.accompanyFavorTimer = nil

		assert(arg0_116.accompanyPerformanceTimer)
		arg0_116.accompanyPerformanceTimer:Stop()

		arg0_116.accompanyPerformanceTimer = nil
		arg0_116.canTriggerAccompanyPerformance = nil

		local var0_122 = math.min(arg0_116.accompanyFavorCount, getProxy(ApartmentProxy):getStamina())

		if var0_122 > 0 then
			local var1_122 = var7_116[var0_122]

			warning(var1_122)
			arg0_116:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_116.apartment.configId, var1_122)
		end

		local var2_122 = 0
		local var3_122 = getProxy(ApartmentProxy):GetAccompanyTime()

		if var3_122 then
			var2_122 = pg.TimeMgr.GetInstance():GetServerTime() - var3_122
		end

		pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataAccompany(2, var0_116.ship_id, var0_116.performance_time, var2_122, var1_116 or arg0_116.dormSceneMgr.artSceneInfo))
		arg0_116:SetUI(nil, "back", "back")
	end)
end

function var0_0.ExitAccompanyMode(arg0_123)
	existCall(arg0_123.timelineFinishCall)
end

function var0_0.EnterTouchMode(arg0_124)
	local var0_124 = arg0_124.ladyDict[arg0_124.apartment:GetConfigID()]

	if arg0_124:GetBlackboardValue(var0_124, "inTouching") then
		return
	end

	local var1_124 = arg0_124.room:getApartmentZoneConfig(var0_124.ladyBaseZone, "touch_id", arg0_124.apartment:GetConfigID())

	arg0_124.touchConfig = pg.dorm3d_touch_data[var1_124]

	if not arg0_124.touchConfig then
		arg0_124:EnterTimelineTouchMode()

		return
	end

	arg0_124.inTouchGame = arg0_124.touchConfig.heartbeat_enable > 0

	setActive(arg0_124.rtTouchGamePanel, arg0_124.inTouchGame)

	if arg0_124.inTouchGame then
		arg0_124.touchCount = 0
		arg0_124.touchLevel = 1
		arg0_124.lastCount = 0
		arg0_124.topCount = 0

		arg0_124:UpdateTouchGameDisplay()
		setSlider(arg0_124.rtTouchGamePanel:Find("slider"), 0, 100, arg0_124.touchCount >= 200 and 100 or arg0_124.touchCount % 100)
		quickPlayAnimation(arg0_124.rtTouchGamePanel, "anim_dorm3d_touch_in")
		quickPlayAnimation(arg0_124.rtTouchGamePanel:Find("slider/icon"), "anim_dorm3d_touch_icon")

		arg0_124.downTimer = Timer.New(function()
			local var0_125 = pg.dorm3d_set.reduce_interaction.key_value_int

			if arg0_124.touchLevel > 1 then
				var0_125 = pg.dorm3d_set.reduce_heartbeat.key_value_int
			end

			arg0_124:UpdateTouchCount(var0_125)
		end, 1, -1)

		arg0_124.downTimer:Start()
	end

	local var2_124 = {}

	table.insert(var2_124, function(arg0_126)
		arg0_124:SetBlackboardValue(var0_124, "inTouching", true)
		arg0_124:emit(arg0_124.SHOW_BLOCK)
		arg0_124:SetUI(arg0_126, "blank")
	end)
	table.insert(var2_124, function(arg0_127)
		local var0_127 = arg0_124.touchConfig.ik_status[1]

		arg0_124:SwitchIKConfig(var0_124, var0_127)
		setActive(arg0_124.uiContianer:Find("ik/btn_back"), true)
		arg0_124:SetIKState(true, arg0_127)
	end)
	table.insert(var2_124, function(arg0_128)
		existCall(arg0_128)
	end)
	seriesAsync(var2_124, function()
		Shader.SetGlobalFloat("_ScreenClipOff", 0)
		arg0_124:emit(arg0_124.HIDE_BLOCK)
	end)
end

function var0_0.ExitTouchMode(arg0_130)
	local var0_130 = arg0_130.ladyDict[arg0_130.apartment:GetConfigID()]

	if not arg0_130:GetBlackboardValue(var0_130, "inTouching") then
		return
	end

	if arg0_130.touchTimelineConfig then
		existCall(arg0_130.timelineFinishCall)

		return
	end

	local var1_130 = {}

	if arg0_130.inTouchGame then
		table.insert(var1_130, function(arg0_131)
			arg0_130:emit(arg0_130.SHOW_BLOCK)
			quickPlayAnimation(arg0_130.rtTouchGamePanel, "anim_dorm3d_touch_out")
			onDelayTick(arg0_131, 0.5)
		end)
		table.insert(var1_130, function(arg0_132)
			local var0_132 = 0

			for iter0_132, iter1_132 in ipairs(arg0_130.touchConfig.heartbeat_favor) do
				if iter1_132[1] > arg0_130.topCount then
					break
				else
					var0_132 = iter1_132[2]
				end
			end

			if var0_132 > 0 then
				arg0_130:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_130.apartment.configId, var0_132)
			end

			arg0_130.touchCount = nil
			arg0_130.touchLevel = nil
			arg0_130.topCount = nil

			if arg0_130.downTimer then
				arg0_130.downTimer:Stop()

				arg0_130.downTimer = nil
			end

			arg0_130.inTouchGame = false

			setActive(arg0_130.rtTouchGamePanel, false)
			Shader.SetGlobalFloat("_ScreenClipOff", 1)
			arg0_132()
		end)
	else
		table.insert(var1_130, function(arg0_133)
			arg0_130:emit(arg0_130.SHOW_BLOCK)

			local var0_133 = arg0_130.touchConfig.default_favor

			if var0_133 > 0 then
				arg0_130:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_130.apartment.configId, var0_133)
			end

			Shader.SetGlobalFloat("_ScreenClipOff", 1)
			arg0_133()
		end)
	end

	table.insert(var1_130, function(arg0_134)
		var0_130.ikConfig = {
			character_position = var0_130.ladyBaseZone,
			character_action = arg0_130.touchConfig.finish_action
		}

		arg0_130:SetIKState(false, arg0_134)
	end)
	table.insert(var1_130, function(arg0_135)
		var0_130.ikConfig = nil
		arg0_130.blockIK = nil

		arg0_130:SetUI(arg0_135, "back")
	end)
	seriesAsync(var1_130, function()
		arg0_130:SetBlackboardValue(var0_130, "inTouching", false)
		arg0_130:emit(arg0_130.HIDE_BLOCK)

		arg0_130.touchConfig = nil

		local var0_136 = arg0_130.touchExitCall

		arg0_130.touchExitCall = nil

		existCall(var0_136)
	end)
end

function var0_0.ChangeWalkScene(arg0_137, arg1_137, arg2_137)
	local var0_137 = arg0_137.ladyDict[arg0_137.apartment:GetConfigID()]

	seriesAsync({
		function(arg0_138)
			arg0_137:ChangeArtScene(arg1_137, arg0_138)
		end,
		function(arg0_139)
			var0_137:ChangeSubScene(arg1_137, arg0_139)
		end,
		function(arg0_140)
			arg0_137:emit(arg0_137.SHOW_BLOCK)

			if arg1_137 == arg0_137.dormSceneMgr.sceneInfo then
				arg0_137:SetUI(arg0_140, "back")
			elseif arg0_137.uiState ~= "walk" then
				arg0_137:SetUI(arg0_140, "walk")
			else
				arg0_140()
			end
		end
	}, function()
		arg0_137:emit(arg0_137.HIDE_BLOCK)
		arg0_137:SetBlackboardValue(var0_137, "inWalk", arg1_137 ~= arg0_137.dormSceneMgr.sceneInfo)
		existCall(arg2_137)
	end)
end

function var0_0.EnterTimelineTouchMode(arg0_142)
	local var0_142 = arg0_142.ladyDict[arg0_142.apartment:GetConfigID()]

	if arg0_142:GetBlackboardValue(var0_142, "inIK") then
		return
	end

	local var1_142 = arg0_142.room:getApartmentZoneConfig(var0_142.ladyBaseZone, "touch_id", arg0_142.apartment:GetConfigID())
	local var2_142 = pg.dorm3d_ik_timeline[var1_142]

	assert(var2_142, "Missing config in dorm3d_ik_timeline ID: " .. (var1_142 or "nil"))

	arg0_142.touchTimelineConfig = var2_142

	local var3_142 = {}

	table.insert(var3_142, function(arg0_143)
		arg0_142:SetBlackboardValue(var0_142, "inIK", true)
		arg0_142:emit(arg0_142.SHOW_BLOCK)
		arg0_142:SetUI(arg0_143, "ik")
	end)
	table.insert(var3_142, function(arg0_144)
		setActive(arg0_142.uiContianer:Find("ik/btn_back"), true)
		setActive(arg0_142.uiContianer:Find("ik/Right/btn_camera"), false)
		setActive(arg0_142.uiContianer:Find("ik/Right/Menu"), false)
		setActive(arg0_142.uiContianer:Find("ik/Right/MenuSmall"), false)
		Shader.SetGlobalFloat("_ScreenClipOff", 0)
		arg0_142:emit(arg0_142.HIDE_BLOCK)
		arg0_142:HideCharacterBylayer(var0_142)
		setActive(var0_142.ladyCollider, false)

		local var0_144
		local var1_144

		if #var2_142.scene > 0 then
			var0_144, var1_144 = unpack(string.split(var2_142.scene, "|"))
		end

		arg0_142:PlayTimeline({
			name = var2_142.timeline,
			scene = var0_144,
			sceneRoot = var1_144
		}, function(arg0_145, arg1_145)
			arg1_145()
			arg0_142:ExitTimelineTouchMode()
		end)
	end)
	seriesAsync(var3_142, function()
		return
	end)
end

function var0_0.ExitTimelineTouchMode(arg0_147)
	local var0_147 = arg0_147.ladyDict[arg0_147.apartment:GetConfigID()]

	if not arg0_147:GetBlackboardValue(var0_147, "inIK") then
		return
	end

	arg0_147.touchTimelineConfig = nil

	local var1_147 = {}

	table.insert(var1_147, function(arg0_148)
		arg0_147:emit(arg0_147.SHOW_BLOCK)
		Shader.SetGlobalFloat("_ScreenClipOff", 1)
		arg0_148()
	end)
	table.insert(var1_147, function(arg0_149)
		arg0_147:RevertCharacterBylayer(var0_147)
		setActive(var0_147.ladyCollider, true)
		arg0_147:SetUI(arg0_149, "back")
	end)
	seriesAsync(var1_147, function()
		arg0_147:SetBlackboardValue(var0_147, "inIK", false)
		arg0_147:emit(arg0_147.HIDE_BLOCK)
	end)
end

function var0_0.EnterWalkMode(arg0_151)
	local var0_151 = arg0_151.apartment:GetConfigID()
	local var1_151 = arg0_151.ladyDict[var0_151]

	seriesAsync({
		function(arg0_152)
			arg0_151:emit(arg0_151.SHOW_BLOCK)
			arg0_151:HideCharacter(var0_151)
			arg0_151:SetBlackboardValue(var1_151, "inWalk", true)
			arg0_151:SetUI(arg0_152, "walk")
		end,
		function(arg0_153)
			arg0_151:emit(arg0_151.HIDE_BLOCK)
			arg0_151:ChangeArtScene(arg0_151.walkInfo.scene .. "|" .. arg0_151.walkInfo.sceneRoot, arg0_153)
		end,
		function(arg0_154)
			arg0_151:LoadSubScene(arg0_151.walkInfo, arg0_154)
		end
	}, function()
		return
	end)
end

function var0_0.ExitWalkMode(arg0_156)
	local var0_156 = arg0_156.apartment:GetConfigID()
	local var1_156 = arg0_156.ladyDict[var0_156]

	seriesAsync({
		function(arg0_157)
			arg0_156:ChangeArtScene(arg0_156.walkLastSceneInfo, arg0_157)
		end,
		function(arg0_158)
			arg0_156:UnloadSubScene(arg0_156.walkInfo, arg0_158)
		end,
		function(arg0_159)
			arg0_156:emit(arg0_156.SHOW_BLOCK)
			arg0_156:SetUI(arg0_159, "back")
		end
	}, function()
		arg0_156:emit(arg0_156.HIDE_BLOCK)
		arg0_156:RevertCharacter(var0_156)
		arg0_156:SetBlackboardValue(var1_156, "inWalk", false)

		local var0_160 = arg0_156.walkExitCall

		arg0_156.walkExitCall = nil
		arg0_156.walkLastSceneInfo = nil
		arg0_156.walkInfo = nil

		existCall(var0_160)
	end)
end

function var0_0.EnableMiniGameCutIn(arg0_161)
	if not arg0_161.tfCutIn then
		return
	end

	local var0_161 = arg0_161.rtExtraScreen:Find("MiniGameCutIn")

	setActive(var0_161, true)

	local var1_161 = GetOrAddComponent(var0_161:Find("bg/mask/cut_in"), "CameraRTUI")

	setActive(var1_161, true)
	pg.CameraRTMgr.GetInstance():Bind(var1_161, arg0_161.tfCutIn:Find("TestCamera"):GetComponent(typeof(Camera)))
	quickPlayAnimator(arg0_161.modelCutIn.lady, "Idle")
	quickPlayAnimator(arg0_161.modelCutIn.player, "Idle")
	setActive(arg0_161.tfCutIn, true)
end

function var0_0.DisableMiniGameCutIn(arg0_162)
	if not arg0_162.tfCutIn then
		return
	end

	local var0_162 = arg0_162.rtExtraScreen:Find("MiniGameCutIn")
	local var1_162 = GetOrAddComponent(var0_162:Find("bg/mask/cut_in"), "CameraRTUI")

	pg.CameraRTMgr.GetInstance():Clean(var1_162)
	setActive(var0_162, false)
	setActive(arg0_162.tfCutIn, false)
end

function var0_0.SwitchIKConfig(arg0_163, arg1_163, arg2_163)
	local var0_163 = pg.dorm3d_ik_status[arg2_163]

	if var0_163.skin_id ~= arg1_163.skinId then
		local var1_163 = pg.dorm3d_ik_status.get_id_list_by_base[var0_163.base]
		local var2_163 = _.detect(var1_163, function(arg0_164)
			return pg.dorm3d_ik_status[arg0_164].skin_id == arg1_163.skinId
		end)

		assert(var2_163, string.format("Missing Status Config By Skin: %s original Status: %s", arg1_163.skinId, arg2_163))

		var0_163 = pg.dorm3d_ik_status[var2_163]
	end

	arg1_163.ikConfig = var0_163
end

function var0_0.SetIKState(arg0_165, arg1_165, arg2_165)
	local var0_165 = arg0_165.ladyDict[arg0_165.apartment:GetConfigID()]
	local var1_165 = {}

	if arg1_165 then
		table.insert(var1_165, function(arg0_166)
			arg0_165:SetBlackboardValue(var0_165, "inIK", true)
			arg0_165:emit(arg0_165.SHOW_BLOCK)

			local var0_166 = var0_165.ikConfig.camera_group

			setActive(arg0_165.uiContianer:Find("ik/Right/btn_camera"), #pg.dorm3d_ik_status.get_id_list_by_camera_group[var0_166] > 1)
			arg0_166()
		end)

		if arg0_165.uiState ~= "ik" then
			table.insert(var1_165, function(arg0_167)
				arg0_165:SetUI(arg0_167, "ik")
			end)
		end

		table.insert(var1_165, function(arg0_168)
			Shader.SetGlobalFloat("_ScreenClipOff", 0)
			arg0_165:SetIKStatus(var0_165, var0_165.ikConfig, arg0_168)
		end)
		table.insert(var1_165, function(arg0_169)
			arg0_165:emit(arg0_165.HIDE_BLOCK)
			arg0_169()
		end)
	else
		assert(arg0_165.uiState == "ik")
		table.insert(var1_165, function(arg0_170)
			arg0_165:emit(arg0_165.SHOW_BLOCK)
			Shader.SetGlobalFloat("_ScreenClipOff", 1)
			arg0_170()
		end)

		local var2_165 = var0_165.skinIdList

		if var0_165.skinId ~= var2_165[1] then
			table.insert(var1_165, function(arg0_171)
				local var0_171 = arg0_165.apartment:GetConfigID()

				arg0_165:SwitchCharacterSkin(var0_165, var0_171, var2_165[1], arg0_171)
			end)
		end

		table.insert(var1_165, function(arg0_172)
			arg0_165:ExitIKStatus(var0_165, var0_165.ikConfig, arg0_172)
			arg0_165:ResetSceneItemAnimators()
		end)
		table.insert(var1_165, function(arg0_173)
			arg0_165:SetUI(arg0_173, "back")
		end)
		table.insert(var1_165, function(arg0_174)
			arg0_165:SetBlackboardValue(var0_165, "inIK", false)
			arg0_165:emit(arg0_165.HIDE_BLOCK)
			arg0_174()
		end)
	end

	seriesAsync(var1_165, arg2_165)
end

function var0_0.TouchModeAction(arg0_175, arg1_175, arg2_175, ...)
	return switch(arg2_175, {
		function(arg0_176, arg1_176)
			return function(arg0_177)
				seriesAsync({
					function(arg0_178)
						if not arg1_176 or arg1_176 == "" then
							return arg0_178()
						end

						arg0_175:PlaySingleAction(arg1_175, arg1_176, arg0_178)
					end,
					function(arg0_179)
						arg0_175:SwitchIKConfig(arg1_175, arg0_176)
						arg0_175:SetIKState(true, arg0_179)
					end,
					arg0_177
				})
			end
		end,
		function()
			return function()
				if arg0_175.ikSpecialCall then
					local var0_181 = arg0_175.ikSpecialCall

					arg0_175.ikSpecialCall = nil

					existCall(var0_181)
				else
					arg0_175:ExitTouchMode()
				end
			end
		end,
		function(arg0_182, arg1_182)
			return function(arg0_183)
				arg0_175:PlaySingleAction(arg1_175, arg1_182, arg0_183)
			end
		end,
		function(arg0_184, arg1_184, arg2_184)
			return function(arg0_185)
				seriesAsync({
					function(arg0_186)
						arg0_175:DoTalk(arg1_184, arg0_186)
					end,
					function(arg0_187)
						if not arg2_184 or arg2_184 == 0 then
							return arg0_187()
						end

						arg0_175:SwitchIKConfig(arg1_175, arg2_184)
						arg0_175:SetIKState(true, arg0_187)
					end,
					arg0_185
				})
			end
		end,
		function(arg0_188, arg1_188, arg2_188, arg3_188)
			return function(arg0_189)
				arg0_175:PlaySceneItemAnim(arg2_188, arg3_188)
				arg0_175:PlaySingleAction(arg1_188, arg0_189)
			end
		end
	}, function()
		return function()
			return
		end
	end, ...)
end

function var0_0.TouchModePointAction(arg0_192, arg1_192, arg2_192, arg3_192, ...)
	return switch(arg3_192, {
		[6] = function(arg0_193)
			return function(arg0_194)
				local var0_194 = pg.dorm3d_ik_touch[arg2_192]

				if #var0_194.scene_item == 0 then
					return
				end

				local var1_194 = arg0_192:GetSceneItem(var0_194.scene_item)

				if not var1_194 then
					warning(string.format("dorm3d_ik_touch:%d without scene_item:%s", arg2_192, var0_194.scene_item))

					return
				end

				local var2_194 = var1_194:Find(arg0_193)

				if not IsNil(var2_194) then
					setActive(var2_194, false)
					setActive(var2_194, true)
				end

				arg0_194()
			end
		end
	}, function(...)
		return arg0_192:TouchModeAction(arg1_192, arg3_192, ...)
	end, ...)
end

function var0_0.OnTriggerIK(arg0_196, arg1_196)
	local var0_196 = arg0_196.ladyDict[arg0_196.apartment:GetConfigID()]

	if var0_196.ikTimelineMode then
		arg0_196:ExitIKTimelineStatus(var0_196)

		local var1_196 = arg1_196:GetTimelineAction()

		if var1_196 then
			arg0_196.nowTimelinePlayer:TriggerEvent(var1_196)
		end

		return
	end

	if not var0_196.ikConfig then
		return
	end

	local var2_196 = arg1_196:GetControllerPath()
	local var3_196 = var0_196.ikActionDict[var2_196]

	if not var3_196 then
		return
	end

	arg0_196.blockIK = true

	arg0_196:TouchModeAction(var0_196, unpack(var3_196))(function()
		arg0_196:ResetIKTipTimer()

		arg0_196.blockIK = nil
	end)
end

function var0_0.OnTouchCharacterBody(arg0_198, arg1_198)
	local var0_198 = arg0_198.ladyDict[arg0_198.apartment:GetConfigID()]

	if not var0_198.ikConfig then
		return
	end

	if type(var0_198.ikConfig.touch_data) ~= "table" then
		return
	end

	for iter0_198, iter1_198 in ipairs(var0_198.ikConfig.touch_data) do
		local var1_198, var2_198, var3_198 = unpack(iter1_198)
		local var4_198 = pg.dorm3d_ik_touch[var1_198]

		if var4_198.body == arg1_198 then
			local var5_198 = var4_198.action_emote

			if #var5_198 > 0 then
				arg0_198:PlayFaceAnim(var0_198, var5_198)
			end

			local var6_198 = var4_198.vibrate

			if type(var6_198) == "table" and VibrateMgr.Instance:IsSupport() then
				local var7_198 = {}
				local var8_198 = {}
				local var9_198 = {}

				underscore.each(var6_198, function(arg0_199)
					table.insert(var7_198, arg0_199[1])
					table.insert(var8_198, arg0_199[2])
					table.insert(var9_198, 1)
				end)

				if PLATFORM == PLATFORM_ANDROID then
					VibrateMgr.Instance:VibrateWaveform(var7_198, var8_198)
				elseif PLATFORM == PLATFORM_ANDROID then
					VibrateMgr.Instance:VibrateWaveform(var7_198, var8_198, var9_198)
				end
			end

			arg0_198.blockIK = true

			arg0_198:TouchModeAction(var0_198, unpack(var3_198))(function()
				arg0_198:ResetIKTipTimer()

				arg0_198.blockIK = nil
			end)

			return
		end
	end
end

function var0_0.UpdateTouchGameDisplay(arg0_201)
	setActive(arg0_201.rtTouchGamePanel:Find("effect_bg"), arg0_201.touchLevel == 2)
	setActive(arg0_201.rtTouchGamePanel:Find("slider/icon/beating"), arg0_201.touchLevel == 2)

	if arg0_201.touchLevel == 1 then
		setActive(arg0_201.uiContianer:Find("ik/btn_back"), true)
		setActive(arg0_201.uiContianer:Find("ik/btn_back_heartbeat"), false)
		quickPlayAnimation(arg0_201.rtTouchGamePanel, "anim_dorm3d_touch_change_out")
		quickPlayAnimation(arg0_201.rtTouchGamePanel:Find("slider/icon"), "anim_dorm3d_touch_icon")
	elseif arg0_201.touchLevel == 2 then
		setActive(arg0_201.uiContianer:Find("ik/btn_back"), false)
		setActive(arg0_201.uiContianer:Find("ik/btn_back_heartbeat"), true)
		quickPlayAnimation(arg0_201.rtTouchGamePanel, "anim_dorm3d_touch_change")
		quickPlayAnimation(arg0_201.rtTouchGamePanel:Find("slider/icon"), "anim_dorm3d_touch_icon_1")
		pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_heartbeat")
	end
end

function var0_0.UpdateTouchCount(arg0_202, arg1_202)
	if arg0_202.touchLevel > 1 then
		arg1_202 = math.min(0, arg1_202)
	end

	arg0_202.touchCount = math.clamp(arg0_202.touchCount + arg1_202, 0, 100)

	if arg0_202.sliderLT and LeanTween.isTweening(arg0_202.sliderLT) then
		LeanTween.cancel(arg0_202.sliderLT)

		arg0_202.sliderLT = nil
	end

	setSlider(arg0_202.rtTouchGamePanel:Find("slider"), 0, 100, arg0_202.touchCount)

	local var0_202

	if arg0_202.touchCount >= 100 then
		var0_202 = 2
	elseif arg0_202.touchCount <= 0 then
		var0_202 = 1
	end

	if var0_202 and var0_202 ~= arg0_202.touchLevel then
		if arg0_202.blockIK then
			return
		end

		arg0_202.touchLevel = var0_202

		local var1_202 = arg0_202.touchConfig.ik_status[var0_202]

		if var1_202 then
			if var0_202 > 1 then
				arg0_202.touchCount = 200
			elseif var0_202 == 1 then
				arg0_202.touchCount = 0
			end

			local var2_202 = arg0_202.ladyDict[arg0_202.apartment:GetConfigID()]

			seriesAsync({
				function(arg0_203)
					arg0_202:ShowBlackScreen(true, arg0_203)
				end,
				function(arg0_204)
					arg0_202:SwitchIKConfig(var2_202, var1_202)
					arg0_202:SetIKState(true, arg0_204)

					if var0_202 > 1 and arg0_202.touchConfig.heartbeat_enter_anim ~= "" then
						arg0_202:SwitchAnim(var2_202, arg0_202.touchConfig.heartbeat_enter_anim)
					end
				end,
				function(arg0_205)
					arg0_202:ShowBlackScreen(false, arg0_205)
				end
			})
		end

		arg0_202:UpdateTouchCount(0)
		arg0_202:UpdateTouchGameDisplay()
	end

	arg0_202.topCount = math.max(arg0_202.topCount, arg0_202.touchCount)
end

function var0_0.ExitHeartbeatMode(arg0_206)
	if not arg0_206.touchLevel or arg0_206.touchLevel == 1 then
		return
	end

	arg0_206.touchCount = 0

	arg0_206:UpdateTouchCount(0)
end

function var0_0.DoTouch(arg0_207, arg1_207, arg2_207)
	if arg0_207.inTouchGame then
		switch(arg2_207, {
			function()
				arg0_207:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat.key_value_int)
			end,
			function()
				arg0_207:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat.key_value_int)
			end,
			function()
				arg0_207:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat.key_value_int)
			end,
			function()
				arg0_207:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat_trriger.key_value_int)
			end
		})
	end
end

function var0_0.DoTalk(arg0_212, arg1_212, arg2_212)
	while rawget(arg0_212, "class") ~= var0_0 do
		arg0_212 = getmetatable(arg0_212).__index
	end

	if arg0_212.apartment and arg0_212:GetBlackboardValue(arg0_212.ladyDict[arg0_212.apartment:GetConfigID()], "inTalking") then
		errorMsg("Talking block:" .. arg1_212)

		return
	end

	if not arg0_212.room:isPersonalRoom() then
		local var0_212 = pg.dorm3d_dialogue_group[arg1_212].char_id

		if arg0_212.apartment then
			assert(arg0_212.apartment:GetConfigID() == var0_212)
		else
			arg0_212:SetApartment(getProxy(ApartmentProxy):getApartment(var0_212))
		end
	end

	local var1_212 = arg0_212.ladyDict[arg0_212.apartment:GetConfigID()]

	if arg1_212 == 10010 and not arg0_212.apartment.talkDic[arg1_212] then
		arg0_212.firstTimelineTouch = true
		arg0_212.firstMoveGuide = true
	end

	local var2_212 = {}

	if arg0_212:GetBlackboardValue(var1_212, "inPending") then
		table.insert(var2_212, function(arg0_213)
			arg0_212:OutOfLazy(arg0_212.apartment:GetConfigID(), arg0_213)
		end)
	end

	local var3_212 = pg.dorm3d_dialogue_group[arg1_212]
	local var4_212 = var3_212.performance_type == 1
	local var5_212

	table.insert(var2_212, function(arg0_214)
		arg0_212:emit(arg0_212.SHOW_BLOCK)
		arg0_212:SetBlackboardValue(var1_212, var4_212 and "inPerformance" or "inTalking", true)
		arg0_212:emit(Dorm3dRoomMediator.DO_TALK, arg1_212, function(arg0_215)
			var5_212 = arg0_215

			arg0_214()
		end)
	end)
	table.insert(var2_212, function(arg0_216)
		pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataDialog(arg0_212.apartment.configId, arg0_212.apartment.level, arg1_212, var3_212.type, arg0_212.room:getZoneConfig(arg0_212.ladyDict[arg0_212.apartment:GetConfigID()].ladyBaseZone, "id"), var3_212.action_type, table.CastToString(var3_212.trigger_config), arg0_212.room:GetConfigID()))

		if pg.NewGuideMgr.GetInstance():IsBusy() then
			pg.NewGuideMgr.GetInstance():Pause()
		end

		arg0_212:SetUI(arg0_216, "blank")
	end)

	if var3_212.trigger_area and var3_212.trigger_area ~= "" then
		table.insert(var2_212, function(arg0_217)
			arg0_212:ShiftZone(var3_212.trigger_area, arg0_217)
		end)
	end

	if var3_212.performance_type == 0 then
		table.insert(var2_212, function(arg0_218)
			arg0_212:emit(arg0_212.HIDE_BLOCK)
			pg.NewStoryMgr.GetInstance():ForceManualPlay(var3_212.story, function()
				onDelayTick(arg0_218, 0.001)
			end, true)
		end)
	elseif var3_212.performance_type == 1 then
		table.insert(var2_212, function(arg0_220)
			arg0_212:emit(arg0_212.HIDE_BLOCK)
			arg0_212:PerformanceQueue(var3_212.story, arg0_220)
		end)
	else
		assert(false)
	end

	table.insert(var2_212, function(arg0_221)
		arg0_212:emit(arg0_212.SHOW_BLOCK)
		arg0_221()
	end)
	table.insert(var2_212, function(arg0_222)
		local var0_222 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(var3_212.story)

		if var0_222 then
			local var1_222 = "1"

			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataStory(var0_222, var1_222))
		end

		if var5_212 and #var5_212 > 0 then
			arg0_212:emit(Dorm3dRoomMediator.OPEN_DROP_LAYER, var5_212, arg0_222)
		else
			arg0_222()
		end
	end)
	table.insert(var2_212, function(arg0_223)
		if pg.NewGuideMgr.GetInstance():IsPause() then
			pg.NewGuideMgr.GetInstance():Resume()
		end

		arg0_212:emit(arg0_212.HIDE_BLOCK)
		arg0_212:SetBlackboardValue(var1_212, var4_212 and "inPerformance" or "inTalking", false)
		arg0_212:SetUI(arg0_223, "back")
	end)
	seriesAsync(var2_212, function()
		if arg2_212 then
			return arg2_212()
		else
			arg0_212:CheckQueue()
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

			arg0_240:ShiftZone(arg0_240.ladyBaseZone, arg0_242)
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

	if not arg1_245.nowCanWatchState or arg1_245.nowCanWatchState ~= var0_245 then
		arg1_245.nowCanWatchState = var0_245

		arg0_245:ShowOrHideCanWatchMark(arg1_245, arg1_245.nowCanWatchState)
	end
end

local var1_0 = {
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

function var0_0.HandleGameNotification(arg0_246, arg1_246, arg2_246)
	local var0_246 = arg0_246.ladyDict[arg0_246.apartment:GetConfigID()]

	switch(arg1_246, {
		[Dorm3dMiniGameMediator.OPERATION] = function()
			switch(arg2_246.miniGameId, {
				[67] = function()
					if arg2_246.operationCode == "GAME_HIT_AREA" then
						local var0_248, var1_248 = unpack(var1_0[arg2_246.index])

						arg0_246:PlaySingleAction(var0_246, var0_248)

						if arg0_246.tfCutIn then
							quickPlayAnimator(arg0_246.modelCutIn.lady, var1_248)
							quickPlayAnimator(arg0_246.modelCutIn.player, var1_248)
						end
					elseif arg2_246.operationCode == "GAME_RESULT" then
						if arg2_246.win then
							arg0_246:PlaySingleAction(var0_246, "Face_XYX_victory")
							arg0_246:PlaySingleAction(var0_246, "minigame_win")
						else
							arg0_246:PlaySingleAction(var0_246, "Face_XYX_lose")
							arg0_246:PlaySingleAction(var0_246, "minigame_lose")
						end

						setActive(arg0_246.rtExtraScreen:Find("MiniGameCutIn"), false)
						pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataMiniGame(2, arg2_246.score))
					elseif arg2_246.operationCode == "GAME_CLOSE" and arg2_246.doTrack == false then
						pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataMiniGame(3))
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
					elseif arg2_246.operationCode == "GAME_CLOSE" and arg2_246.doTrack == false then
						pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataMiniGame(3))
					end
				end
			}, function()
				warning("without miniGameId:" .. arg2_246.miniGameId)
			end)
		end
	})
end

function var0_0.PerformanceQueue(arg0_257, arg1_257, arg2_257)
	local var0_257, var1_257 = pcall(function()
		return require("GameCfg.dorm." .. arg1_257)
	end)

	if not var0_257 then
		errorMsg("不存在表演ID对应的Lua:" .. arg1_257)
		existCall(arg2_257)

		return
	end

	warning(arg1_257)

	arg0_257.performanceInfo = {
		name = arg1_257
	}

	local var2_257 = {}

	table.insert(var2_257, function(arg0_259)
		arg0_257:SetUI(arg0_259, "blank")
	end)
	table.insertto(var2_257, underscore.map(var1_257, function(arg0_260)
		return switch(arg0_260.type, {
			function()
				return function(arg0_262)
					local var0_262 = unpack(arg0_260.params)

					arg0_257:DoTalk(var0_262, arg0_262, true)
				end
			end,
			function()
				return function(arg0_264)
					arg0_257.touchExitCall = arg0_264

					arg0_257:EnterTouchMode()
				end
			end,
			function()
				return function(arg0_266)
					local var0_266 = arg0_257.ladyDict[arg0_257.apartment:GetConfigID()]

					arg0_257:PlaySingleAction(var0_266, arg0_260.name, arg0_266)
				end
			end,
			function()
				return function(arg0_268)
					arg0_257:emit(arg0_257.PLAY_EXPRESSION, arg0_260)
					arg0_268()
				end
			end,
			function()
				return function(arg0_270)
					arg0_257:ShiftZone(arg0_260.name, arg0_270)
				end
			end,
			function()
				return function(arg0_272)
					arg0_257.contextData.timeIndex = arg0_260.params[1]

					if arg0_257.dormSceneMgr.artSceneInfo == arg0_257.dormSceneMgr.sceneInfo then
						arg0_257:SwitchDayNight(arg0_257.contextData.timeIndex)
						onNextTick(function()
							arg0_257:RefreshSlots()
						end)
					end

					arg0_257:UpdateContactState()
					onNextTick(arg0_272)
				end
			end,
			function()
				return function(arg0_275)
					arg0_257:ActiveStateCamera(arg0_260.name, arg0_275)
				end
			end,
			function()
				return function(arg0_277)
					if arg0_260.name == "base" then
						arg0_257:ChangeArtScene(arg0_257.dormSceneMgr.sceneInfo, arg0_277)
					else
						local var0_277 = arg0_260.params.scene
						local var1_277 = arg0_260.params.sceneRoot

						arg0_257:ChangeArtScene(var0_277 .. "|" .. var1_277, arg0_277)
					end
				end
			end,
			function()
				return function(arg0_279)
					local var0_279 = arg0_260.params.name

					if arg0_260.name == "load" then
						func = tobool(arg0_260.params.wait_timeline) and function(arg0_280)
							arg0_257.waitForTimeline = arg0_280
						end

						arg0_257:LoadTimelineScene(var0_279, true, func, arg0_279)
					elseif arg0_260.name == "unload" then
						arg0_257:UnloadTimelineScene(var0_279, true, arg0_279)
					else
						assert(false)
					end
				end
			end,
			function()
				return function(arg0_282)
					setActive(arg0_257.uiContianer:Find("walk/btn_back"), false)

					local var0_282 = arg0_257.ladyDict[arg0_257.apartment:GetConfigID()]

					if arg0_260.name == "change" then
						local var1_282 = arg0_260.params.scene
						local var2_282 = arg0_260.params.sceneRoot

						var0_282.walkBornPoint = arg0_260.params.point or "Default"

						arg0_257:ChangeWalkScene(var1_282 .. "|" .. var2_282, arg0_282)
					elseif arg0_260.name == "back" then
						var0_282.walkBornPoint = nil

						arg0_257:ChangeWalkScene(arg0_257.dormSceneMgr.sceneInfo, arg0_282)
					elseif arg0_260.name == "set" then
						local function var3_282()
							local var0_283 = arg0_282

							arg0_282 = nil

							return existCall(var0_283)
						end

						for iter0_282, iter1_282 in pairs(arg0_260.params) do
							switch(iter0_282, {
								back_button_trigger = function(arg0_284)
									onButton(arg0_257, arg0_257.uiContianer:Find("walk/btn_back"), var3_282, "ui-dorm_back_v2")
									setActive(arg0_257.uiContianer:Find("walk/btn_back"), IsUnityEditor and arg0_284)
								end,
								near_trigger = function(arg0_285)
									if arg0_285 == true then
										arg0_285 = 1.5
									end

									if arg0_285 then
										function arg0_257.walkNearCallback(arg0_286)
											if arg0_286 < arg0_285 then
												arg0_257.walkNearCallback = nil

												var3_282()
											end
										end
									else
										arg0_257.walkNearCallback = nil
									end
								end
							}, nil, iter1_282)
						end

						if arg0_257.firstMoveGuide then
							setActive(arg0_257.povLayer:Find("Guide"), arg0_257.firstMoveGuide)

							arg0_257.firstMoveGuide = nil
						end
					else
						assert(false)
					end
				end
			end,
			function()
				return function(arg0_288)
					if arg0_260.name == "set" then
						local var0_288 = arg0_257.ladyDict[arg0_257.apartment:GetConfigID()]

						arg0_257:SwitchIKConfig(var0_288, arg0_260.params.state)
						setActive(arg0_257.uiContianer:Find("ik/btn_back"), not arg0_260.params.hide_back)

						arg0_257.ikSpecialCall = arg0_288

						arg0_257:SetIKState(true)
					elseif arg0_260.name == "back" then
						local var1_288 = arg0_257.ladyDict[arg0_257.apartment:GetConfigID()]

						var1_288.ikConfig = arg0_260.params

						arg0_257:SetIKState(false, function()
							var1_288.ikConfig = nil

							existCall(arg0_288)
						end)
					else
						assert(false)
					end
				end
			end,
			function()
				return function(arg0_291)
					arg0_257.blackSceneInfo = setmetatable(arg0_260.params or {}, {
						__index = {
							color = "#000000",
							time = 0.3,
							delay = arg0_260.name == "show" and 0 or 0.5
						}
					})

					if arg0_260.name == "show" then
						arg0_257:ShowBlackScreen(true, arg0_291)
					elseif arg0_260.name == "hide" then
						arg0_257:ShowBlackScreen(false, arg0_291)
					else
						assert(false)
					end

					arg0_257.blackSceneInfo = nil
				end
			end
		})
	end))
	table.insert(var2_257, function(arg0_292)
		arg0_257:SetUI(arg0_292, "back")

		arg0_257.performanceInfo = nil
	end)
	seriesAsync(var2_257, arg2_257)
end

function var0_0.TriggerContact(arg0_293, arg1_293)
	arg0_293:emit(Dorm3dRoomMediator.COLLECTION_ITEM, {
		itemId = arg1_293,
		roomId = arg0_293.room:GetConfigID(),
		groupId = arg0_293.room:isPersonalRoom() and arg0_293.apartment:GetConfigID() or 0
	})
end

function var0_0.UpdateContactState(arg0_294)
	arg0_294:SetContactStateDic(arg0_294.room:getTriggerableCollectItemDic(arg0_294.contextData.timeIndex))
end

function var0_0.UpdateFavorDisplay(arg0_295)
	local var0_295, var1_295 = getProxy(ApartmentProxy):getStamina()

	setText(arg0_295.rtStaminaDisplay:Find("Text"), string.format("%d/%d", var0_295, var1_295))
	setActive(arg0_295.rtStaminaDisplay, false)

	if arg0_295.apartment then
		setText(arg0_295.rtFavorLevel:Find("rank/Text"), arg0_295.apartment.level)

		local var2_295, var3_295 = arg0_295.apartment:getFavor()
		local var4_295 = arg0_295.apartment:isMaxFavor()

		setActive(arg0_295.rtFavorLevel:Find("Max"), var4_295)
		setActive(arg0_295.rtFavorLevel:Find("Text"), not var4_295)
		setText(arg0_295.rtFavorLevel:Find("Text"), string.format("<color=#ff6698>%d</color>/%d", var2_295, var3_295))
	end

	setActive(arg0_295.rtFavorLevel:Find("red"), Dorm3dLevelLayer.IsShowRed())
end

function var0_0.UpdateBtnState(arg0_296)
	local var0_296 = not arg0_296.room:isPersonalRoom() or arg0_296:CheckSystemOpen("Furniture")
	local var1_296 = Dorm3dFurniture.IsTimelimitShopTip(arg0_296.room:GetConfigID())

	setActive(arg0_296.uiContianer:Find("base/left/btn_furniture/tipTimelimit"), var0_296 and var1_296)

	local var2_296 = Dorm3dFurniture.NeedViewTip(arg0_296.room:GetConfigID())

	setActive(arg0_296.uiContianer:Find("base/left/btn_furniture/tip"), var0_296 and not var1_296 and var2_296)
	setActive(arg0_296.uiContianer:Find("base/btn_back/main"), underscore(getProxy(ApartmentProxy):getRawData()):chain():values():filter(function(arg0_297)
		return tobool(arg0_297)
	end):any(function(arg0_298)
		return #arg0_298:getSpecialTalking() > 0 or arg0_298:getIconTip() == "main"
	end):value())
	setActive(arg0_296.uiContianer:Find("base/left/btn_collection/tip"), PlayerPrefs.GetInt("apartment_collection_item", 0) > 0 or PlayerPrefs.GetInt("apartment_collection_recall", 0) > 0)
end

function var0_0.AddUnlockDisplay(arg0_299, arg1_299)
	table.insert(arg0_299.unlockList, arg1_299)

	if not isActive(arg0_299.rtFavorUp) then
		setText(arg0_299.rtFavorUp:Find("Text"), table.remove(arg0_299.unlockList, 1))
		setActive(arg0_299.rtFavorUp, true)
	end
end

function var0_0.PopFavorTrigger(arg0_300, arg1_300)
	local var0_300 = arg1_300.triggerId
	local var1_300 = arg1_300.delta
	local var2_300 = arg1_300.cost
	local var3_300 = arg1_300.apartment
	local var4_300 = pg.dorm3d_favor_trigger[var0_300]

	if var4_300.is_repeat == 0 then
		if var0_300 == getDorm3dGameset("drom3d_favir_trigger_onwer")[1] then
			arg0_300:AddUnlockDisplay(i18n("dorm3d_own_favor"))
		elseif var0_300 == getDorm3dGameset("drom3d_favir_trigger_propose")[1] then
			arg0_300:AddUnlockDisplay(i18n("dorm3d_pledge_favor"))
		else
			arg0_300:AddUnlockDisplay(string.format("unknow favor trigger:%d unlock", var0_300))
		end
	elseif arg1_300.delta > 0 then
		local var5_300, var6_300 = var3_300:getFavor()
		local var7_300 = var5_300 + var1_300

		setText(arg0_300.rtFavorUpDaily:Find("bg/Text"), string.format("<size=48>+%d</size>", math.min(9999, var1_300)))
		setSlider(arg0_300.rtFavorUpDaily:Find("bg/slider"), 0, var6_300, var5_300)
		setAnchoredPosition(arg0_300.rtFavorUpDaily:Find("bg"), arg1_300.isGift and NewPos(-354, 223) or NewPos(-208, 105))

		local var8_300 = {}
		local var9_300 = arg0_300.rtFavorUpDaily:Find("bg/effect")

		eachChild(var9_300, function(arg0_301)
			setActive(arg0_301, false)
		end)

		local var10_300

		if var4_300.effect and var4_300.effect ~= "" then
			var10_300 = var9_300:Find(var4_300.effect .. "(Clone)")

			if not var10_300 then
				table.insert(var8_300, function(arg0_302)
					LoadAndInstantiateAsync("Dorm3D/Effect/Prefab/ExpressionUI", "uifx_dorm3d_yinfu01", function(arg0_303)
						setParent(arg0_303, var9_300)

						var10_300 = tf(arg0_303)

						arg0_302()
					end)
				end)
			else
				setActive(var10_300, true)
			end
		end

		local var11_300 = arg0_300.rtFavorUpDaily:GetComponent("DftAniEvent")

		var11_300:SetTriggerEvent(function(arg0_304)
			local var0_304 = GetComponent(arg0_300.rtFavorUpDaily:Find("bg/slider"), typeof(Slider))

			LeanTween.value(var5_300, var7_300, 0.5):setOnUpdate(System.Action_float(function(arg0_305)
				var0_304.value = arg0_305
			end)):setEase(LeanTweenType.easeInOutQuad):setDelay(0.165):setOnComplete(System.Action(function()
				LeanTween.delayedCall(0.165, System.Action(function()
					if arg0_300.exited then
						return
					end

					quickPlayAnimator(arg0_300.rtFavorUpDaily, "favor_out")
				end))
			end))
			pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_progaress_bar")
		end)
		var11_300:SetEndEvent(function(arg0_308)
			setActive(arg0_300.rtFavorUpDaily, false)
		end)
		seriesAsync(var8_300, function()
			local var0_309 = arg0_300.ladyDict[var3_300:GetConfigID()]

			setLocalPosition(arg0_300.rtFavorUpDaily, arg0_300:GetLocalPosition(arg0_300:GetScreenPosition(var0_309.ladyHeadCenter.position), arg0_300.rtFavorUpDaily.parent))
			setActive(arg0_300.rtFavorUpDaily, true)
			SetCompomentEnabled(arg0_300.rtFavorUpDaily, typeof(Animator), true)
			quickPlayAnimator(arg0_300.rtFavorUpDaily, "favor_open")

			if var2_300 > 0 then
				local var1_309, var2_309 = getProxy(ApartmentProxy):getStamina()

				setText(arg0_300.rtStaminaPop:Find("Text/Text (1)"), "-" .. var2_300)
				setText(arg0_300.rtStaminaPop:Find("Text"), string.format("%d/%d", var1_309 + var2_300, var2_309))
				setActive(arg0_300.rtStaminaPop, true)
			end
		end)
	end
end

function var0_0.PopFavorLevelUp(arg0_310, arg1_310, arg2_310, arg3_310)
	arg0_310.isLock = true

	LeanTween.delayedCall(0.33, System.Action(function()
		arg0_310.isLock = false
	end))

	local var0_310 = math.floor(arg1_310.level / 10)
	local var1_310 = math.fmod(arg1_310.level, 10)

	GetImageSpriteFromAtlasAsync("ui/favor_atlas", var1_310, arg0_310.rtLevelUpWindow:Find("panel/bg/item1/mark/level/digit2"))
	GetImageSpriteFromAtlasAsync("ui/favor_atlas", var0_310, arg0_310.rtLevelUpWindow:Find("panel/bg/item1/mark/level/digit1"))
	setActive(arg0_310.rtLevelUpWindow:Find("panel/bg/item1/mark/level/digit1"), var0_310 > 0)

	local var2_310
	local var3_310

	arg0_310.clientAward, var3_310 = Dorm3dIconHelper.SplitStory(arg1_310:getFavorConfig("levelup_client_item", arg1_310.level))
	arg0_310.serverAward = arg2_310

	local var4_310 = arg0_310.rtLevelUpWindow:Find("panel/info/content/itemContent")

	if not arg0_310.levelItemList then
		arg0_310.levelItemList = UIItemList.New(var4_310, var4_310:Find("tpl"))

		arg0_310.levelItemList:make(function(arg0_312, arg1_312, arg2_312)
			local var0_312 = arg1_312 + 1

			if arg0_312 == UIItemList.EventUpdate then
				if arg1_312 < #arg0_310.serverAward then
					updateDorm3dIcon(arg2_312, arg0_310.serverAward[var0_312])
					onButton(arg0_310, arg2_312, function()
						arg0_310:emit(BaseUI.ON_NEW_DROP, {
							drop = arg0_310.serverAward[var0_312]
						})
					end, SFX_PANEL)
				else
					Dorm3dIconHelper.UpdateDorm3dIcon(arg2_312, arg0_310.clientAward[var0_312 - #arg0_310.serverAward])
					onButton(arg0_310, arg2_312, function()
						arg0_310:emit(Dorm3dRoomMediator.ON_DROP_CLIENT, {
							data = arg0_310.clientAward[var0_312 - #arg0_310.serverAward]
						})
					end, SFX_PANEL)
				end
			end
		end)
	end

	arg0_310.levelItemList:align(#arg0_310.serverAward + #arg0_310.clientAward)
	setActive(arg0_310.rtLevelUpWindow, true)
	pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_upgrade")
	pg.UIMgr.GetInstance():OverlayPanel(arg0_310.rtLevelUpWindow, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_DORM3D
	})

	function arg0_310.levelUpCallback()
		arg0_310.levelUpCallback = nil

		if var3_310 then
			arg0_310:PopNewStoryTip(var3_310)
		end

		existCall(arg3_310)
	end
end

function var0_0.PopNewStoryTip(arg0_316, arg1_316, arg2_316)
	local var0_316 = arg0_316.uiContianer:Find("base/top/story_tip")

	setActive(var0_316, true)
	LeanTween.delayedCall(1, System.Action(function()
		setActive(var0_316, false)
	end))
	setText(var0_316:Find("Text"), i18n("dorm3d_story_unlock_tip", pg.dorm3d_recall[arg1_316[2]].name))
	existCall(arg2_316)
end

function var0_0.UpdateZoneList(arg0_318)
	local var0_318

	if arg0_318.room:isPersonalRoom() then
		var0_318 = arg0_318.ladyDict[arg0_318.apartment:GetConfigID()].ladyBaseZone
	else
		var0_318 = arg0_318:GetAttachedFurnitureName()
	end

	for iter0_318, iter1_318 in ipairs(arg0_318.zoneDatas) do
		if iter1_318:GetWatchCameraName() == var0_318 then
			setText(arg0_318.btnZone:Find("Text"), iter1_318:GetName())
			setTextColor(arg0_318.rtZoneList:GetChild(iter0_318 - 1):Find("Name"), Color.NewHex("5CCAFF"))
		else
			setTextColor(arg0_318.rtZoneList:GetChild(iter0_318 - 1):Find("Name"), Color.NewHex("FFFFFF99"))
		end
	end
end

function var0_0.TalkingEventHandle(arg0_319, arg1_319)
	local var0_319 = {}
	local var1_319 = {}
	local var2_319 = arg1_319.data

	if var2_319.op_list then
		for iter0_319, iter1_319 in ipairs(var2_319.op_list) do
			table.insert(var0_319, function(arg0_320)
				local function var0_320()
					local var0_321 = arg0_320

					arg0_320 = nil

					return existCall(var0_321)
				end

				switch(iter1_319.type, {
					action = function()
						local var0_322 = arg0_319.ladyDict[arg0_319.apartment:GetConfigID()]

						arg0_319:PlaySingleAction(var0_322, iter1_319.name, var0_320)
					end,
					item_action = function()
						arg0_319:PlaySceneItemAnim(iter1_319.id, iter1_319.name)
						var0_320()
					end,
					timeline = function()
						if arg0_319.inTouchGame then
							setActive(arg0_319.rtTouchGamePanel, false)
						end

						arg0_319:PlayTimeline(iter1_319, function(arg0_325, arg1_325)
							setActive(arg0_319.rtTouchGamePanel, arg0_319.inTouchGame)

							var1_319.notifiCallback = arg1_325

							var0_320()
						end)
					end,
					clickOption = function()
						arg0_319:DoTalkTouchOption(iter1_319, arg1_319.flags, function(arg0_327)
							var1_319.optionIndex = arg0_327

							var0_320()
						end)
					end,
					wait = function()
						arg0_319.LTs = arg0_319.LTs or {}

						table.insert(arg0_319.LTs, LeanTween.delayedCall(iter1_319.time, System.Action(var0_320)).uniqueId)
					end,
					expression = function()
						arg0_319:emit(arg0_319.PLAY_EXPRESSION, iter1_319)
						var0_320()
					end
				}, function()
					assert(false, "op type error:", iter1_319.type)
				end)

				if iter1_319.skip then
					var0_320()
				end
			end)
		end
	end

	seriesAsync(var0_319, function()
		if arg1_319.callbackData then
			arg0_319:emit(Dorm3dRoomMediator.TALKING_EVENT_FINISH, arg1_319.callbackData.name, var1_319)
		end
	end)
end

function var0_0.CheckQueue(arg0_332)
	if arg0_332.inGuide or arg0_332.uiState ~= "base" then
		return
	end

	if arg0_332.room:GetConfigID() == 1 and arg0_332:CheckGuide() then
		-- block empty
	elseif arg0_332.room:isPersonalRoom() and arg0_332:CheckLevelUp() then
		-- block empty
	elseif arg0_332.apartment and arg0_332:CheckEnterDeal() then
		-- block empty
	elseif arg0_332.apartment and arg0_332:CheckActiveTalk() then
		-- block empty
	elseif arg0_332.apartment then
		arg0_332:CheckFavorTrigger()
	end

	arg0_332.contextData.hasEnterCheck = true
end

function var0_0.didEnterCheck(arg0_333)
	local var0_333

	if arg0_333.contextData.specialId then
		var0_333 = arg0_333.contextData.specialId
		arg0_333.contextData.specialId = nil

		arg0_333:DoTalk(var0_333, function()
			arg0_333:closeView()
		end)
	elseif not arg0_333.contextData.hasEnterCheck and arg0_333.apartment then
		for iter0_333, iter1_333 in ipairs(arg0_333.apartment:getForceEnterTalking(arg0_333.room:GetConfigID())) do
			var0_333 = iter1_333

			arg0_333:DoTalk(iter1_333)

			break
		end
	end

	if var0_333 and pg.dorm3d_dialogue_group[var0_333].extend_loading > 0 then
		arg0_333.contextData.hasEnterCheck = true

		pg.SceneAnimMgr.GetInstance():RegisterDormNextCall(function()
			arg0_333:FinishEnterResume()
		end)
	else
		if arg0_333.apartment and arg0_333.contextData.pendingDic[arg0_333.apartment:GetConfigID()] then
			arg0_333.contextData.hasEnterCheck = true
		end

		for iter2_333, iter3_333 in pairs(arg0_333.contextData.pendingDic) do
			arg0_333:SetInPending(arg0_333.ladyDict[iter2_333], iter3_333)
		end

		arg0_333.contextData.pendingDic = {}

		arg0_333:FinishEnterResume()
		arg0_333:CheckQueue()
	end
end

function var0_0.CheckGuide(arg0_336)
	if arg0_336:GetBlackboardValue(arg0_336.ladyDict[arg0_336.apartment:GetConfigID()], "inPending") then
		return
	end

	for iter0_336, iter1_336 in ipairs({
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
				return arg0_336:CheckSystemOpen("Furniture")
			end
		},
		{
			name = "DORM3D_GUIDE_07",
			active = function()
				return arg0_336:CheckSystemOpen("DayNight")
			end
		}
	}) do
		if not pg.NewStoryMgr.GetInstance():IsPlayed(iter1_336.name) and iter1_336.active() then
			arg0_336:SetAllBlackbloardValue("inGuide", true)

			local function var0_336()
				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(2, pg.NewStoryMgr.GetInstance():StoryName2StoryId(iter1_336.name)))
				arg0_336:SetAllBlackbloardValue("inGuide", false)
			end

			pg.m02:sendNotification(GAME.STORY_UPDATE, {
				storyId = iter1_336.name
			})
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(1, pg.NewStoryMgr.GetInstance():StoryName2StoryId(iter1_336.name)))
			pg.NewGuideMgr.GetInstance():Play(iter1_336.name, nil, var0_336, var0_336)

			return true
		end
	end

	return false
end

function var0_0.CheckFavorTrigger(arg0_342)
	for iter0_342, iter1_342 in ipairs({
		{
			triggerId = getDorm3dGameset("drom3d_favir_trigger_onwer")[1],
			active = function()
				local var0_343 = getProxy(CollectionProxy):getShipGroup(arg0_342.apartment.configId)

				return tobool(var0_343)
			end
		},
		{
			triggerId = getDorm3dGameset("drom3d_favir_trigger_propose")[1],
			active = function()
				local var0_344 = getProxy(CollectionProxy):getShipGroup(arg0_342.apartment.configId)

				return var0_344 and var0_344.married > 0
			end
		}
	}) do
		if arg0_342.apartment.triggerCountDic[iter1_342.triggerId] == 0 and iter1_342.active() then
			arg0_342:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_342.apartment.configId, iter1_342.triggerId)
		end
	end
end

function var0_0.CheckEnterDeal(arg0_345)
	if arg0_345.contextData.hasEnterCheck then
		return false
	end

	local var0_345 = arg0_345.apartment:GetConfigID()
	local var1_345 = "dorm3d_enter_count_" .. var0_345
	local var2_345 = pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d")

	if PlayerPrefs.GetString("dorm3d_enter_count_day") ~= var2_345 then
		PlayerPrefs.SetString("dorm3d_enter_count_day", var2_345)
		PlayerPrefs.SetInt(var1_345, 1)
	else
		PlayerPrefs.SetInt(var1_345, PlayerPrefs.GetInt(var1_345, 0) + 1)
	end

	local var3_345 = arg0_345.apartment:getEnterTalking(arg0_345.room:GetConfigID())

	PlayerPrefs.SetString("DORM3D_DAILY_ENTER", pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d"))

	if #var3_345 > 0 then
		arg0_345:DoTalk(var3_345[math.random(#var3_345)])

		return true
	end
end

function var0_0.CheckActiveTalk(arg0_346)
	local var0_346 = arg0_346.ladyDict[arg0_346.apartment:GetConfigID()]

	if arg0_346:GetBlackboardValue(var0_346, "inPending") then
		return false
	end

	local var1_346 = arg0_346.apartment:getZoneTalking(arg0_346.room:GetConfigID(), var0_346.ladyBaseZone)

	if #var1_346 > 0 then
		arg0_346:DoTalk(var1_346[1])

		return true
	else
		return false
	end
end

function var0_0.CheckDistanceTalk(arg0_347, arg1_347, arg2_347)
	local var0_347 = arg0_347.ladyDict[arg1_347].ladyBaseZone
	local var1_347 = getProxy(ApartmentProxy):getApartment(arg1_347)

	for iter0_347, iter1_347 in ipairs(var1_347:getDistanceTalking(arg0_347.room:GetConfigID(), var0_347)) do
		arg0_347:DoTalk(iter1_347)

		return
	end
end

function var0_0.CheckSystemOpen(arg0_348, arg1_348)
	if arg0_348.room:isPersonalRoom() then
		return switch(arg1_348, {
			Talk = function()
				local var0_349 = 1

				return var0_349 <= arg0_348.apartment.level, i18n("apartment_level_unenough", var0_349)
			end,
			Touch = function()
				local var0_350 = getDorm3dGameset("drom3d_touch_dialogue")[1]

				return var0_350 <= arg0_348.apartment.level, i18n("apartment_level_unenough", var0_350)
			end,
			Gift = function()
				local var0_351 = getDorm3dGameset("drom3d_gift_dialogue")[1]

				return var0_351 <= arg0_348.apartment.level, i18n("apartment_level_unenough", var0_351)
			end,
			Volleyball = function()
				return false
			end,
			Photo = function()
				local var0_353 = getDorm3dGameset("drom3d_photograph_unlock")[1]

				return var0_353 <= arg0_348.apartment.level, i18n("apartment_level_unenough", var0_353)
			end,
			Collection = function()
				local var0_354 = getDorm3dGameset("drom3d_recall_unlock")[1]

				return var0_354 <= arg0_348.apartment.level, i18n("apartment_level_unenough", var0_354)
			end,
			Furniture = function()
				local var0_355 = getDorm3dGameset("drom3d_furniture_unlock")[1]

				return var0_355 <= arg0_348.apartment.level, i18n("apartment_level_unenough", var0_355)
			end,
			DayNight = function()
				local var0_356 = getDorm3dGameset("drom3d_time_unlock")[1]

				return var0_356 <= arg0_348.apartment.level, i18n("apartment_level_unenough", var0_356)
			end,
			Accompany = function()
				local var0_357 = 1

				return var0_357 <= arg0_348.apartment.level, i18n("apartment_level_unenough", var0_357)
			end,
			MiniGame = function()
				local var0_358 = 1

				if var0_358 > arg0_348.apartment.level then
					return false, i18n("apartment_level_unenough", var0_358)
				elseif #arg0_348.room:getMiniGames() <= 0 then
					return false, "without minigame config in room:" .. arg0_348.room.configId
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
		return switch(arg1_348, {
			Gift = function()
				return false
			end,
			Volleyball = function()
				return arg0_348.room:GetConfigID() == 4
			end,
			Furniture = function()
				return false
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

function var0_0.CheckLevelUp(arg0_370)
	if arg0_370.apartment:canLevelUp() then
		arg0_370:emit(Dorm3dRoomMediator.FAVOR_LEVEL_UP, arg0_370.apartment.configId)

		return true
	end

	return false
end

function var0_0.GetIKHandTF(arg0_371)
	return arg0_371.ikHand
end

function var0_0.CycleIKCameraGroup(arg0_372)
	local var0_372 = arg0_372.ladyDict[arg0_372.apartment:GetConfigID()]

	assert(arg0_372:GetBlackboardValue(var0_372, "inIK"))
	seriesAsync({
		function(arg0_373)
			pg.IKMgr.GetInstance():ResetActiveIKs()

			local var0_373 = var0_372.ikConfig
			local var1_373 = var0_373.camera_group
			local var2_373 = pg.dorm3d_ik_status.get_id_list_by_camera_group[var1_373]
			local var3_373 = var2_373[table.indexof(var2_373, var0_373.id) % #var2_373 + 1]

			arg0_372:SwitchIKConfig(var0_372, var3_373)
			arg0_372:SetIKState(true)
		end
	})
end

function var0_0.TempHideUI(arg0_374, arg1_374, arg2_374)
	local var0_374 = defaultValue(arg0_374.hideCount, 0)

	arg0_374.hideCount = var0_374 + (arg1_374 and 1 or -1)

	assert(arg0_374.hideCount >= 0)

	if arg0_374.hideCount * var0_374 > 0 then
		return existCall(arg2_374)
	elseif arg0_374.hideCount > 0 then
		arg0_374:SetUI(arg2_374, "blank")
	else
		arg0_374:SetUI(arg2_374, "back")
	end
end

function var0_0.onBackPressed(arg0_375)
	if arg0_375.exited or arg0_375.retainCount > 0 then
		-- block empty
	elseif isActive(arg0_375.rtLevelUpWindow) then
		triggerButton(arg0_375.rtLevelUpWindow:Find("bg"))
	elseif arg0_375.uiState ~= "base" then
		-- block empty
	else
		arg0_375:closeView()
	end
end

function var0_0.willExit(arg0_376)
	if arg0_376.downTimer then
		arg0_376.downTimer:Stop()

		arg0_376.downTimer = nil
	end

	if arg0_376.LTs then
		underscore.map(arg0_376.LTs, function(arg0_377)
			LeanTween.cancel(arg0_377)
		end)

		arg0_376.LTs = nil
	end

	if arg0_376.sliderLT then
		LeanTween.cancel(arg0_376.sliderLT)

		arg0_376.sliderLT = nil
	end

	for iter0_376, iter1_376 in pairs(arg0_376.ladyDict) do
		iter1_376.wakeUpTalkId = nil
	end

	if arg0_376.accompanyFavorTimer then
		arg0_376.accompanyFavorTimer:Stop()

		arg0_376.accompanyFavorTimer = nil
	end

	if arg0_376.accompanyPerformanceTimer then
		arg0_376.accompanyPerformanceTimer:Stop()

		arg0_376.accompanyPerformanceTimer = nil
	end

	arg0_376.canTriggerAccompanyPerformance = nil

	var0_0.super.willExit(arg0_376)
end

return var0_0
