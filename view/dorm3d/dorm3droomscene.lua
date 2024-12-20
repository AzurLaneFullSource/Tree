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
			local var2_8 = getProxy(ApartmentProxy):getApartment(arg0_4.contextData.groupIds[1])

			arg0_4:SetApartment(var2_8)
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

			if arg0_4.room:isPersonalRoom() and not arg0_4.ladyDict[arg0_4.apartment:GetConfigID()]:GetBlackboardValue("inPending") then
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
							arg0_4.SwitchCharacterSkin(var1_29, var0_29, var2_33)
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
	GetOrAddComponent(arg0_4.ikTipsRoot:GetChild(0), typeof(RectTransform))

	arg0_4.ikHand = var2_4:Find("Handler")

	setActive(arg0_4.ikHand, false)
	eachChild(arg0_4.ikHand, function(arg0_38)
		setActive(arg0_38, false)
	end)

	local var4_4 = arg0_4.uiContianer:Find("accompany")

	onButton(arg0_4, var4_4:Find("btn_back"), function()
		arg0_4:ExitAccompanyMode()
	end, "ui-dorm_back_v2")

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

	local var5_4 = arg0_4.rtStaminaPop:GetComponent("DftAniEvent")

	var5_4:SetTriggerEvent(function(arg0_41)
		local var0_41, var1_41 = getProxy(ApartmentProxy):getStamina()

		setText(arg0_4.rtStaminaPop:Find("Text"), string.format("%d/%d", var0_41, var1_41))
	end)
	var5_4:SetEndEvent(function(arg0_42)
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
			apartment = arg0_4.apartment,
			baseCamera = arg0_4.mainCameraTF
		})
	end, "ui-dorm_click_v2")
	setText(arg0_4.rtRole:Find("Gift/bg/Text"), i18n("dorm3d_gift"))
	onButton(arg0_4, arg0_4.rtRole:Find("MiniGame"), function()
		local var0_52 = arg0_4.ladyDict[arg0_4.apartment:GetConfigID()]
		local var1_52 = {}

		table.insert(var1_52, function(arg0_53)
			arg0_4:SetAllBlackbloardValue("inLockLayer", true)
			arg0_4:TempHideUI(true, arg0_53)
		end)

		if var0_52.ladyBaseZone ~= "Chair" then
			table.insert(var1_52, function(arg0_54)
				arg0_4:ShiftZone("Chair", arg0_54)
			end)
		end

		table.insert(var1_52, function(arg0_55)
			parallelAsync({
				function(arg0_56)
					var0_52:PlaySingleAction("SitStart", arg0_56)
				end,
				function(arg0_57)
					arg0_4:ActiveStateCamera("talk", arg0_57)
				end
			}, arg0_55)
		end)
		table.insert(var1_52, function(arg0_58)
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataMiniGame(1))
			arg0_4:EnableMiniGameCutIn()
			arg0_4:emit(Dorm3dRoomMediator.OPEN_MINIGAME_WINDOW, {
				isDorm3d = true
			}, arg0_58)
		end)
		table.insert(var1_52, function(arg0_59)
			arg0_4:DisableMiniGameCutIn()
			var0_52:PlaySingleAction("SitEnd", arg0_59)
		end)
		seriesAsync(var1_52, function()
			arg0_4:SetAllBlackbloardValue("inLockLayer", false)
			arg0_4:TempHideUI(false)
		end)
	end, "ui-dorm_click_v2")
	setText(arg0_4.rtRole:Find("MiniGame/bg/Text"), i18n("dorm3d_minigame_button1"))
	onButton(arg0_4, arg0_4.rtRole:Find("Volleyball"), function()
		arg0_4:emit(Dorm3dRoomMediator.ENTER_VOLLEYBALL)
	end, "ui-dorm_click_v2")
	setText(arg0_4.rtRole:Find("Volleyball/bg/Text"), i18n("dorm3d_volleyball_button"))
	onButton(arg0_4, arg0_4.rtRole:Find("Performance"), function()
		arg0_4:PerformanceQueue("DormLvPerformance02", function()
			pg.TipsMgr.GetInstance():ShowTips("Success!")
		end)
	end, "ui-dorm_click_v2")

	arg0_4.rtFloatPage = arg0_4._tf:Find("FloatPage")
	arg0_4.tplFloat = arg0_4.rtFloatPage:Find("tpl")

	setActive(arg0_4.tplFloat, false)

	local var7_4 = cloneTplTo(arg0_4.tplFloat, arg0_4.rtFloatPage, "lady")

	eachChild(var7_4, function(arg0_64)
		setActive(arg0_64, arg0_64.name == "walk")
	end)

	arg0_4._joystick = arg0_4._tf:Find("Stick")

	setActive(arg0_4._joystick, false)
	arg0_4._joystick:GetComponent(typeof(SlideController)):SetStickFunc(function(arg0_65)
		arg0_4:emit(arg0_4.ON_STICK_MOVE, arg0_65)
	end)

	arg0_4.povLayer = arg0_4._tf:Find("POVControl")

	setActive(arg0_4.povLayer, false)
	;(function()
		local var0_66 = arg0_4.povLayer:Find("Move"):GetComponent(typeof(SlideController))

		var0_66:AddBeginDragFunc(function(arg0_67, arg1_67)
			arg0_4:emit(arg0_4.ON_POV_STICK_MOVE_BEGIN, arg1_67)
		end)
		var0_66:SetStickFunc(function(arg0_68)
			arg0_4:emit(arg0_4.ON_POV_STICK_MOVE, arg0_68)
		end)
		var0_66:AddDragEndFunc(function(arg0_69, arg1_69)
			arg0_4:emit(arg0_4.ON_POV_STICK_MOVE_END, arg1_69)
		end)
		arg0_4.povLayer:Find("View"):GetComponent(typeof(SlideController)):SetStickFunc(function(arg0_70)
			arg0_4:emit(arg0_4.ON_POV_STICK_VIEW, arg0_70)
		end)
	end)()

	arg0_4.ikControlLayer = var2_4:Find("ControlLayer")

	;(function()
		local var0_71
		local var1_71 = arg0_4.ikControlLayer:GetComponent(typeof(SlideController))

		var1_71:AddBeginDragFunc(function(arg0_72, arg1_72)
			local var0_72 = arg0_4.ladyDict[arg0_4.apartment:GetConfigID()]
			local var1_72 = arg1_72.position
			local var2_72 = CameraMgr.instance:Raycast(arg0_4.sceneRaycaster, var1_72)

			if var2_72.Length ~= 0 then
				local var3_72 = var2_72[0].gameObject.transform
				local var4_72 = table.keyof(var0_72.ladyColliders, var3_72)

				if var4_72 then
					arg0_4:emit(var0_0.ON_BEGIN_DRAG_CHARACTER_BODY, var0_72, var4_72, var1_72)

					var0_71 = tobool(var0_72.ikHandler)

					return
				end
			end
		end)
		var1_71:AddDragFunc(function(arg0_73, arg1_73)
			local var0_73 = arg1_73.position
			local var1_73 = arg0_4.ladyDict[arg0_4.apartment:GetConfigID()]

			if var1_73.ikHandler then
				var1_73:emit(var0_0.ON_DRAG_CHARACTER_BODY, var1_73, var0_73)

				return
			end

			if var0_71 then
				return
			end

			local var2_73 = arg1_73.delta

			arg0_4:emit(arg0_4.ON_STICK_MOVE, var2_73)
		end)
		var1_71:AddDragEndFunc(function(arg0_74, arg1_74)
			var0_71 = nil

			local var0_74 = arg0_4.ladyDict[arg0_4.apartment:GetConfigID()]

			if var0_74.ikHandler then
				var0_74:emit(var0_0.ON_RELEASE_CHARACTER_BODY, var0_74)

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

function var0_0.BindEvent(arg0_76)
	var0_0.super.BindEvent(arg0_76)
	arg0_76:bind(arg0_76.CLICK_CHARACTER, function(arg0_77, arg1_77)
		if arg0_76.uiState ~= "base" or not arg0_76.ladyDict[arg1_77].nowCanWatchState then
			return
		end

		local var0_77 = {}
		local var1_77 = arg0_76.ladyDict[arg1_77]

		if var1_77:GetBlackboardValue("inPending") then
			table.insert(var0_77, function(arg0_78)
				var1_77:OutOfPending(arg1_77, arg0_78)
			end)
		else
			table.insert(var0_77, function(arg0_79)
				arg0_76:OutOfLazy(arg1_77, arg0_79)
			end)
		end

		seriesAsync(var0_77, function()
			if not arg0_76.room:isPersonalRoom() then
				arg0_76:SetApartment(getProxy(ApartmentProxy):getApartment(arg1_77))
			end

			arg0_76:EnterWatchMode()
		end)
		pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_touch_v1")
	end)
	arg0_76:bind(arg0_76.CLICK_CONTACT, function(arg0_81, arg1_81)
		arg0_76:TriggerContact(arg1_81)
	end)
	arg0_76:bind(arg0_76.DISTANCE_TRIGGER, function(arg0_82, arg1_82, arg2_82)
		if arg0_76.uiState == "base" then
			arg0_76:CheckDistanceTalk(arg1_82, arg2_82)
		end
	end)
	arg0_76:bind(arg0_76.WALK_DISTANCE_TRIGGER, function(arg0_83, arg1_83, arg2_83)
		if arg0_76.apartment and arg0_76.apartment:GetConfigID() == arg1_83 then
			existCall(arg0_76.walkNearCallback, arg2_83)
		end
	end)
	arg0_76:bind(arg0_76.CHANGE_WATCH, function(arg0_84, arg1_84)
		arg0_76.ladyDict[arg1_84]:ChangeCanWatchState()
	end)
	arg0_76:bind(arg0_76.ON_TOUCH_CHARACTER, function(arg0_85, arg1_85)
		if not arg0_76.ladyDict[arg0_76.apartment:GetConfigID()]:GetBlackboardValue("inIK") then
			return
		end

		arg0_76:OnTouchCharacterBody(arg1_85)
	end)
	arg0_76:bind(arg0_76.ON_IK_STATUS_CHANGED, function(arg0_86, arg1_86, arg2_86)
		if not arg0_76.ladyDict[arg0_76.apartment:GetConfigID()]:GetBlackboardValue("inTouching") then
			return
		end

		arg0_76:DoTouch(arg1_86, arg2_86)
	end)
	arg0_76:bind(arg0_76.ON_ENTER_SECTOR, function(arg0_87, arg1_87)
		arg0_76.ladyDict[arg1_87]:ChangeCanWatchState()
	end)
	arg0_76:bind(arg0_76.ON_CHANGE_DISTANCE, function(arg0_88, arg1_88, arg2_88)
		arg0_76.ladyDict[arg1_88]:ChangeCanWatchState()
	end)
end

function var0_0.didEnter(arg0_89)
	var0_0.super.didEnter(arg0_89)
	arg0_89:UpdateZoneList()

	arg0_89.resumeCallback = arg0_89.contextData.resumeCallback
	arg0_89.contextData.resumeCallback = nil

	arg0_89:SetUI(function()
		arg0_89:didEnterCheck()
	end, "base")
end

function var0_0.FinishEnterResume(arg0_91)
	if not arg0_91.resumeCallback then
		return
	end

	local var0_91 = arg0_91.resumeCallback

	arg0_91.resumeCallback = nil

	return var0_91()
end

function var0_0.EnableJoystick(arg0_92, arg1_92)
	setActive(arg0_92._joystick, arg1_92)
end

function var0_0.EnablePOVLayer(arg0_93, arg1_93)
	setActive(arg0_93.povLayer, arg1_93)

	if not arg1_93 then
		arg0_93:emit(arg0_93.ON_POV_STICK_MOVE_END)
	end
end

function var0_0.SetUIStore(arg0_94, arg1_94, ...)
	table.insertto(arg0_94.uiStore, {
		...
	})
	existCall(arg1_94)
end

function var0_0.SetUI(arg0_95, arg1_95, ...)
	while rawget(arg0_95, "class") ~= var0_0 do
		arg0_95 = getmetatable(arg0_95).__index
	end

	table.insertto(arg0_95.uiStore, {
		...
	})

	for iter0_95, iter1_95 in ipairs(arg0_95.uiStore) do
		if iter1_95 == "back" then
			assert(#arg0_95.uiStack > 0)

			arg0_95.uiState = table.remove(arg0_95.uiStack)
		elseif iter1_95 == arg0_95.uiState and iter1_95 == "ik" then
			-- block empty
		else
			table.insert(arg0_95.uiStack, arg0_95.uiState)

			arg0_95.uiState = iter1_95
		end
	end

	arg0_95.uiStore = {}

	eachChild(arg0_95.uiContianer, function(arg0_96)
		setActive(arg0_96, arg0_96.name == arg0_95.uiState)
	end)
	arg0_95:EnablePOVLayer(arg0_95.uiState == "base" or arg0_95.uiState == "walk")
	arg0_95:TempHideContact(arg0_95.uiState ~= "base")
	arg0_95:SetFloatEnable(arg0_95.uiState == "walk")
	setActive(arg0_95.rtFloatPage, arg0_95.uiState == "walk")
	switch(arg0_95.uiState, {
		base = function()
			if not arg0_95.room:isPersonalRoom() then
				arg0_95:SetApartment(nil)
			end

			arg0_95:UpdateBtnState()
		end,
		watch = function()
			eachChild(arg0_95.rtRole, function(arg0_99)
				setActive(arg0_99, false)
			end)

			local var0_98 = underscore.filter({
				"Talk",
				"Touch",
				"Gift",
				"MiniGame",
				"Volleyball",
				"Performance"
			}, function(arg0_100)
				return arg0_95:CheckSystemOpen(arg0_100)
			end)
			local var1_98 = 0.05

			for iter0_98, iter1_98 in ipairs(var0_98) do
				LeanTween.delayedCall(var1_98, System.Action(function()
					setActive(arg0_95.rtRole:Find(iter1_98), true)
				end))

				var1_98 = var1_98 + 0.066
			end

			setActive(arg0_95.rtRole:Find("Gift/bg/Tip"), Dorm3dGift.NeedViewTip(arg0_95.apartment:GetConfigID()))
		end,
		ik = function()
			setActive(arg0_95.uiContianer:Find("ik/Right/MenuSmall"), arg0_95.room:isPersonalRoom())
			setActive(arg0_95.uiContianer:Find("ik/Right/Menu"), false)
		end,
		walk = function()
			setText(arg0_95.uiContianer:Find("walk/dialogue/content"), i18n("dorm3d_removable", arg0_95.apartment:getConfig("name")))
		end
	})
	arg0_95:ActiveStateCamera(arg0_95.uiState, function()
		if arg1_95 then
			arg1_95()
		elseif arg0_95.uiState == "base" then
			arg0_95:CheckQueue()
		end
	end)
end

function var0_0.EnterWatchMode(arg0_105, arg1_105)
	local var0_105 = arg0_105.apartment:GetConfigID()

	seriesAsync({
		function(arg0_106)
			arg0_105:emit(arg0_105.SHOW_BLOCK)
			arg0_105.ladyDict[var0_105]:SetBlackboardValue("inWatchMode", true)
			arg0_105:SetUI(arg0_106, "watch")
		end,
		function(arg0_107)
			arg0_105:emit(arg0_105.HIDE_BLOCK)
		end
	})
end

function var0_0.ExitWatchMode(arg0_108)
	local var0_108 = arg0_108.apartment:GetConfigID()

	seriesAsync({
		function(arg0_109)
			arg0_108:emit(arg0_108.SHOW_BLOCK)
			arg0_108:SetUI(arg0_109, "back")
		end,
		function(arg0_110)
			arg0_108.ladyDict[var0_108]:SetBlackboardValue("inWatchMode", false)
			arg0_108:emit(arg0_108.HIDE_BLOCK)
			arg0_108:CheckQueue()
		end
	})
end

function var0_0.SetInPending(arg0_111, arg1_111)
	local var0_111 = arg0_111:GetBlackboardValue("groupId")
	local var1_111 = pg.dorm3d_welcome[arg1_111]

	arg0_111:SetBlackboardValue("inPending", true)
	arg0_111:ChangeCanWatchState()
	arg0_111:EnableHeadIK(false)

	arg0_111.contextData.ladyZone[var0_111] = var1_111.area
	arg0_111.ladyBaseZone = arg0_111.contextData.ladyZone[var0_111]
	arg0_111.ladyActiveZone = var1_111.welcome_staypoint

	arg0_111:ChangeCharacterPosition()

	if var1_111.item_shield ~= "" then
		arg0_111.hideItemDic = {}

		for iter0_111, iter1_111 in ipairs(var1_111.item_shield) do
			local var2_111 = arg0_111.modelRoot:Find(iter1_111)

			if not var2_111 then
				warning(string.format("welcome:%d without hide item:%s", arg1_111, iter1_111))
			else
				arg0_111.hideItemDic[iter1_111] = isActive(var2_111)

				setActive(var2_111, false)
			end
		end
	end

	onNextTick(function()
		if arg0_111.tfPendintItem then
			setActive(arg0_111.tfPendintItem, true)
		end

		arg0_111:SwitchAnim(var1_111.welcome_idle)
	end)

	arg0_111.wakeUpTalkId = var1_111.welcome_talk
end

function var0_0.SetOutPending(arg0_113)
	arg0_113:SetBlackboardValue("inPending", false)
	arg0_113:ChangeCanWatchState()
	arg0_113:EnableHeadIK(true)

	arg0_113.wakeUpTalkId = nil

	if arg0_113.tfPendintItem then
		setActive(arg0_113.tfPendintItem, false)
	end

	if arg0_113.hideItemDic then
		for iter0_113, iter1_113 in pairs(arg0_113.hideItemDic) do
			setActive(arg0_113.modelRoot:Find(iter0_113), iter1_113)
		end

		arg0_113.hideItemDic = nil
	end
end

function var0_0.IsModeInHidePending(arg0_114, arg1_114)
	for iter0_114, iter1_114 in pairs(arg0_114.ladyDict) do
		if iter1_114.hideItemDic and iter1_114.hideItemDic[arg1_114] ~= nil then
			return true
		end
	end

	return false
end

function var0_0.EnterAccompanyMode(arg0_115, arg1_115)
	local var0_115 = pg.dorm3d_accompany[arg1_115]
	local var1_115
	local var2_115

	if var0_115.sceneInfo ~= "" then
		var1_115, var2_115 = unpack(string.split(var0_115.sceneInfo, "|"))
	end

	local var3_115 = {
		type = "timeline",
		name = var0_115.timeline,
		scene = var1_115,
		sceneRoot = var2_115,
		accompanys = {}
	}

	for iter0_115, iter1_115 in ipairs(var0_115.jump_trigger) do
		local var4_115, var5_115 = unpack(iter1_115)

		var3_115.accompanys[var4_115] = var5_115
	end

	local var6_115, var7_115 = unpack(var0_115.favor)

	getProxy(ApartmentProxy):RecordAccompanyTime()
	pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataAccompany(1, var0_115.ship_id, var0_115.performance_time, 0, var1_115 or arg0_115.artSceneInfo))

	local var8_115 = {}

	table.insert(var8_115, function(arg0_116)
		arg0_115:SetUI(arg0_116, "blank", "accompany")
	end)
	table.insert(var8_115, function(arg0_117)
		arg0_115.accompanyFavorCount = 0
		arg0_115.accompanyFavorTimer = Timer.New(function()
			arg0_115.accompanyFavorCount = arg0_115.accompanyFavorCount + 1
		end, var6_115, -1)

		arg0_115.accompanyFavorTimer:Start()

		arg0_115.accompanyPerformanceTimer = Timer.New(function()
			arg0_115.canTriggerAccompanyPerformance = true

			warning(arg0_115.canTriggerAccompanyPerformance)
		end, var0_115.performance_time, -1)

		arg0_115.accompanyPerformanceTimer:Start()
		arg0_115:PlayTimeline(var3_115, function(arg0_120, arg1_120)
			arg1_120()
			arg0_117()
		end)
	end)
	seriesAsync(var8_115, function()
		assert(arg0_115.accompanyFavorTimer)
		arg0_115.accompanyFavorTimer:Stop()

		arg0_115.accompanyFavorTimer = nil

		assert(arg0_115.accompanyPerformanceTimer)
		arg0_115.accompanyPerformanceTimer:Stop()

		arg0_115.accompanyPerformanceTimer = nil
		arg0_115.canTriggerAccompanyPerformance = nil

		local var0_121 = math.min(arg0_115.accompanyFavorCount, getProxy(ApartmentProxy):getStamina())

		if var0_121 > 0 then
			local var1_121 = var7_115[var0_121]

			warning(var1_121)
			arg0_115:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_115.apartment.configId, var1_121)
		end

		local var2_121 = 0
		local var3_121 = getProxy(ApartmentProxy):GetAccompanyTime()

		if var3_121 then
			var2_121 = pg.TimeMgr.GetInstance():GetServerTime() - var3_121
		end

		pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataAccompany(2, var0_115.ship_id, var0_115.performance_time, var2_121, var1_115 or arg0_115.artSceneInfo))
		arg0_115:SetUI(nil, "back", "back")
	end)
end

function var0_0.ExitAccompanyMode(arg0_122)
	existCall(arg0_122.timelineFinishCall)
end

function var0_0.EnterTouchMode(arg0_123)
	if arg0_123.ladyDict[arg0_123.apartment:GetConfigID()]:GetBlackboardValue("inTouching") then
		return
	end

	local var0_123 = arg0_123.ladyDict[arg0_123.apartment:GetConfigID()]
	local var1_123 = arg0_123.room:getApartmentZoneConfig(var0_123.ladyBaseZone, "touch_id", arg0_123.apartment:GetConfigID())

	arg0_123.touchConfig = pg.dorm3d_touch_data[var1_123]
	arg0_123.inTouchGame = arg0_123.touchConfig.heartbeat_enable > 0

	setActive(arg0_123.rtTouchGamePanel, arg0_123.inTouchGame)

	if arg0_123.inTouchGame then
		arg0_123.touchCount = 0
		arg0_123.touchLevel = 1
		arg0_123.lastCount = 0
		arg0_123.topCount = 0

		arg0_123:UpdateTouchGameDisplay()
		setSlider(arg0_123.rtTouchGamePanel:Find("slider"), 0, 100, arg0_123.touchCount >= 200 and 100 or arg0_123.touchCount % 100)
		quickPlayAnimation(arg0_123.rtTouchGamePanel, "anim_dorm3d_touch_in")
		quickPlayAnimation(arg0_123.rtTouchGamePanel:Find("slider/icon"), "anim_dorm3d_touch_icon")

		arg0_123.downTimer = Timer.New(function()
			local var0_124 = pg.dorm3d_set.reduce_interaction.key_value_int

			if arg0_123.touchLevel > 1 then
				var0_124 = pg.dorm3d_set.reduce_heartbeat.key_value_int
			end

			arg0_123:UpdateTouchCount(var0_124)
		end, 1, -1)

		arg0_123.downTimer:Start()
	end

	local var2_123 = {}

	table.insert(var2_123, function(arg0_125)
		var0_123:SetBlackboardValue("inTouching", true)
		arg0_123:emit(arg0_123.SHOW_BLOCK)
		arg0_123:SetUI(arg0_125, "blank")
	end)
	table.insert(var2_123, function(arg0_126)
		local var0_126 = arg0_123.touchConfig.ik_status[1]

		arg0_123:SwitchIKConfig(var0_123, var0_126)
		setActive(arg0_123.uiContianer:Find("ik/btn_back"), true)
		arg0_123:SetIKState(true, arg0_126)
	end)
	table.insert(var2_123, function(arg0_127)
		existCall(arg0_127)
	end)
	seriesAsync(var2_123, function()
		Shader.SetGlobalFloat("_ScreenClipOff", 0)
		arg0_123:emit(arg0_123.HIDE_BLOCK)
	end)
end

function var0_0.ExitTouchMode(arg0_129)
	local var0_129 = arg0_129.ladyDict[arg0_129.apartment:GetConfigID()]

	if not var0_129:GetBlackboardValue("inTouching") then
		return
	end

	local var1_129 = {}

	if arg0_129.inTouchGame then
		table.insert(var1_129, function(arg0_130)
			arg0_129:emit(arg0_129.SHOW_BLOCK)
			quickPlayAnimation(arg0_129.rtTouchGamePanel, "anim_dorm3d_touch_out")
			onDelayTick(arg0_130, 0.5)
		end)
		table.insert(var1_129, function(arg0_131)
			local var0_131 = 0

			for iter0_131, iter1_131 in ipairs(arg0_129.touchConfig.heartbeat_favor) do
				if iter1_131[1] > arg0_129.topCount then
					break
				else
					var0_131 = iter1_131[2]
				end
			end

			if var0_131 > 0 then
				arg0_129:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_129.apartment.configId, var0_131)
			end

			arg0_129.touchCount = nil
			arg0_129.touchLevel = nil
			arg0_129.topCount = nil

			if arg0_129.downTimer then
				arg0_129.downTimer:Stop()

				arg0_129.downTimer = nil
			end

			arg0_129.inTouchGame = false

			setActive(arg0_129.rtTouchGamePanel, false)
			Shader.SetGlobalFloat("_ScreenClipOff", 1)
			arg0_131()
		end)
	else
		table.insert(var1_129, function(arg0_132)
			arg0_129:emit(arg0_129.SHOW_BLOCK)

			local var0_132 = arg0_129.touchConfig.default_favor

			if var0_132 > 0 then
				arg0_129:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_129.apartment.configId, var0_132)
			end

			Shader.SetGlobalFloat("_ScreenClipOff", 1)
			arg0_132()
		end)
	end

	table.insert(var1_129, function(arg0_133)
		var0_129.ikConfig = {
			character_position = var0_129.ladyBaseZone,
			character_action = arg0_129.touchConfig.finish_action
		}

		arg0_129:SetIKState(false, arg0_133)
	end)
	table.insert(var1_129, function(arg0_134)
		var0_129.ikConfig = nil
		arg0_129.scene.blockIK = nil

		arg0_129:SetUI(arg0_134, "back")
	end)
	seriesAsync(var1_129, function()
		var0_129:SetBlackboardValue("inTouching", false)
		arg0_129:emit(arg0_129.HIDE_BLOCK)

		arg0_129.touchConfig = nil

		local var0_135 = arg0_129.touchExitCall

		arg0_129.touchExitCall = nil

		existCall(var0_135)
	end)
end

function var0_0.ChangeWalkScene(arg0_136, arg1_136, arg2_136)
	local var0_136 = arg0_136.ladyDict[arg0_136.apartment:GetConfigID()]

	seriesAsync({
		function(arg0_137)
			arg0_136:ChangeArtScene(arg1_136, arg0_137)
		end,
		function(arg0_138)
			var0_136:ChangeSubScene(arg1_136, arg0_138)
		end,
		function(arg0_139)
			arg0_136:emit(arg0_136.SHOW_BLOCK)

			if arg1_136 == arg0_136.sceneInfo then
				arg0_136:SetUI(arg0_139, "back")
			elseif arg0_136.uiState ~= "walk" then
				arg0_136:SetUI(arg0_139, "walk")
			else
				arg0_139()
			end
		end
	}, function()
		arg0_136:emit(arg0_136.HIDE_BLOCK)
		var0_136:SetBlackboardValue("inWalk", arg1_136 ~= arg0_136.sceneInfo)
		existCall(arg2_136)
	end)
end

function var0_0.EnterWalkMode(arg0_141)
	local var0_141 = arg0_141.apartment:GetConfigID()
	local var1_141 = arg0_141.ladyDict[var0_141]

	seriesAsync({
		function(arg0_142)
			arg0_141:emit(arg0_141.SHOW_BLOCK)
			arg0_141:HideCharacter(var0_141)
			var1_141:SetBlackboardValue("inWalk", true)
			arg0_141:SetUI(arg0_142, "walk")
		end,
		function(arg0_143)
			arg0_141:emit(arg0_141.HIDE_BLOCK)
			arg0_141:ChangeArtScene(arg0_141.walkInfo.scene .. "|" .. arg0_141.walkInfo.sceneRoot, arg0_143)
		end,
		function(arg0_144)
			arg0_141:LoadSubScene(arg0_141.walkInfo, arg0_144)
		end
	}, function()
		return
	end)
end

function var0_0.ExitWalkMode(arg0_146)
	local var0_146 = arg0_146.apartment:GetConfigID()
	local var1_146 = arg0_146.ladyDict[var0_146]

	seriesAsync({
		function(arg0_147)
			arg0_146:ChangeArtScene(arg0_146.walkLastSceneInfo, arg0_147)
		end,
		function(arg0_148)
			arg0_146:UnloadSubScene(arg0_146.walkInfo, arg0_148)
		end,
		function(arg0_149)
			arg0_146:emit(arg0_146.SHOW_BLOCK)
			arg0_146:SetUI(arg0_149, "back")
		end
	}, function()
		arg0_146:emit(arg0_146.HIDE_BLOCK)
		arg0_146:RevertCharacter(var0_146)
		var1_146:SetBlackboardValue("inWalk", false)

		local var0_150 = arg0_146.walkExitCall

		arg0_146.walkExitCall = nil
		arg0_146.walkLastSceneInfo = nil
		arg0_146.walkInfo = nil

		existCall(var0_150)
	end)
end

function var0_0.EnableMiniGameCutIn(arg0_151)
	if not arg0_151.tfCutIn then
		return
	end

	local var0_151 = arg0_151.rtExtraScreen:Find("MiniGameCutIn")

	setActive(var0_151, true)

	local var1_151 = GetOrAddComponent(var0_151:Find("bg/mask/cut_in"), "CameraRTUI")

	setActive(var1_151, true)
	pg.CameraRTMgr.GetInstance():Bind(var1_151, arg0_151.tfCutIn:Find("TestCamera"):GetComponent(typeof(Camera)))
	quickPlayAnimator(arg0_151.modelCutIn.lady, "Idle")
	quickPlayAnimator(arg0_151.modelCutIn.player, "Idle")
	setActive(arg0_151.tfCutIn, true)
end

function var0_0.DisableMiniGameCutIn(arg0_152)
	if not arg0_152.tfCutIn then
		return
	end

	local var0_152 = arg0_152.rtExtraScreen:Find("MiniGameCutIn")
	local var1_152 = GetOrAddComponent(var0_152:Find("bg/mask/cut_in"), "CameraRTUI")

	pg.CameraRTMgr.GetInstance():Clean(var1_152)
	setActive(var0_152, false)
	setActive(arg0_152.tfCutIn, false)
end

function var0_0.SwitchIKConfig(arg0_153, arg1_153, arg2_153)
	local var0_153 = pg.dorm3d_ik_status[arg2_153]

	if var0_153.skin_id ~= arg1_153.skinId then
		local var1_153 = pg.dorm3d_ik_status.get_id_list_by_base[var0_153.base]
		local var2_153 = _.detect(var1_153, function(arg0_154)
			return pg.dorm3d_ik_status[arg0_154].skin_id == arg1_153.skinId
		end)

		assert(var2_153, string.format("Missing Status Config By Skin: %s original Status: %s", arg1_153.skinId, arg2_153))

		var0_153 = pg.dorm3d_ik_status[var2_153]
	end

	arg1_153.ikConfig = var0_153
end

function var0_0.SetIKState(arg0_155, arg1_155, arg2_155)
	local var0_155 = arg0_155.ladyDict[arg0_155.apartment:GetConfigID()]
	local var1_155 = {}

	if arg1_155 then
		table.insert(var1_155, function(arg0_156)
			var0_155:SetBlackboardValue("inIK", true)
			arg0_155:emit(arg0_155.SHOW_BLOCK)

			local var0_156 = var0_155.ikConfig.camera_group

			setActive(arg0_155.uiContianer:Find("ik/Right/btn_camera"), #pg.dorm3d_ik_status.get_id_list_by_camera_group[var0_156] > 1)
			arg0_156()
		end)

		if arg0_155.uiState ~= "ik" then
			table.insert(var1_155, function(arg0_157)
				arg0_155:SetUI(arg0_157, "ik")
			end)
		end

		table.insert(var1_155, function(arg0_158)
			Shader.SetGlobalFloat("_ScreenClipOff", 0)
			arg0_155.SetIKStatus(var0_155, var0_155.ikConfig, arg0_158)
		end)
		table.insert(var1_155, function(arg0_159)
			arg0_155:emit(arg0_155.HIDE_BLOCK)
			arg0_159()
		end)
	else
		assert(arg0_155.uiState == "ik")
		table.insert(var1_155, function(arg0_160)
			arg0_155:emit(arg0_155.SHOW_BLOCK)
			Shader.SetGlobalFloat("_ScreenClipOff", 1)
			arg0_160()
		end)

		local var2_155 = var0_155.skinIdList

		if var0_155.skinId ~= var2_155[1] then
			table.insert(var1_155, function(arg0_161)
				local var0_161 = arg0_155.apartment:GetConfigID()

				arg0_155.SwitchCharacterSkin(var0_155, var0_161, var2_155[1], arg0_161)
			end)
		end

		table.insert(var1_155, function(arg0_162)
			warning(var0_155.ikConfig.character_action)
			var0_155:ExitIKStatus(var0_155.ikConfig, arg0_162)
			arg0_155.scene:ResetSceneItemAnimators()
		end)
		table.insert(var1_155, function(arg0_163)
			arg0_155:SetUI(arg0_163, "back")
		end)
		table.insert(var1_155, function(arg0_164)
			var0_155:SetBlackboardValue("inIK", false)
			arg0_155:emit(arg0_155.HIDE_BLOCK)
			arg0_164()
		end)
	end

	seriesAsync(var1_155, arg2_155)
end

function var0_0.TouchModeAction(arg0_165, arg1_165, arg2_165, ...)
	return switch(arg2_165, {
		function(arg0_166, arg1_166)
			return function(arg0_167)
				seriesAsync({
					function(arg0_168)
						arg0_165.RevertAllIKLayer(arg1_165, 0, arg0_168)
					end,
					function(arg0_169)
						if not arg1_166 or arg1_166 == "" then
							return arg0_169()
						end

						arg0_165:PlaySingleAction(arg1_166, arg0_169)
					end,
					function(arg0_170)
						arg0_165:SwitchIKConfig(arg1_165, arg0_166)
						arg0_165:SetIKState(true, arg0_170)
					end,
					arg0_167
				})
			end
		end,
		function()
			return function()
				if arg0_165.ikSpecialCall then
					local var0_172 = arg0_165.ikSpecialCall

					arg0_165.ikSpecialCall = nil

					existCall(var0_172)
				else
					arg0_165:ExitTouchMode()
				end
			end
		end,
		function(arg0_173, arg1_173)
			return function(arg0_174)
				arg0_165.RevertAllIKLayer(arg1_165, arg0_173, function()
					arg0_165:PlaySingleAction(arg1_173, arg0_174)
				end)
			end
		end,
		function(arg0_176, arg1_176, arg2_176)
			return function(arg0_177)
				seriesAsync({
					function(arg0_178)
						arg0_165.RevertAllIKLayer(arg1_165, arg0_176, arg0_178)
					end,
					function(arg0_179)
						arg0_165:DoTalk(arg1_176, arg0_179)
					end,
					function(arg0_180)
						if not arg2_176 or arg2_176 == 0 then
							return arg0_180()
						end

						arg0_165:SwitchIKConfig(arg1_165, arg2_176)
						arg0_165:SetIKState(true, arg0_180)
					end,
					arg0_177
				})
			end
		end,
		function(arg0_181, arg1_181, arg2_181, arg3_181)
			return function(arg0_182)
				arg0_165.RevertAllIKLayer(arg1_165, arg0_181, function()
					arg0_165.scene:PlaySceneItemAnim(arg2_181, arg3_181)
					arg0_165:PlaySingleAction(arg1_181, arg0_182)
				end)
			end
		end
	}, function()
		return function()
			return
		end
	end, ...)
end

function var0_0.OnTriggerIK(arg0_186, arg1_186)
	local var0_186 = arg0_186.ladyDict[arg0_186.apartment:GetConfigID()]

	if not var0_186.ikConfig then
		return
	end

	for iter0_186, iter1_186 in ipairs(var0_186.ikConfig.ik_id) do
		local var1_186, var2_186, var3_186 = unpack(iter1_186)

		if var1_186 == arg1_186 then
			arg0_186.scene.blockIK = true

			arg0_186:TouchModeAction(var0_186, unpack(var3_186))(function()
				arg0_186.scene.enableIKTip = true

				arg0_186:ResetIKTipTimer()

				arg0_186.scene.blockIK = nil
			end)

			return
		end
	end

	assert(false, string.format("Missing %s callback in status %s", arg1_186, var0_186.ikConfig.id))
end

function var0_0.OnTouchCharacterBody(arg0_188, arg1_188)
	local var0_188 = arg0_188.ladyDict[arg0_188.apartment:GetConfigID()]

	if not var0_188.ikConfig then
		return
	end

	for iter0_188, iter1_188 in ipairs(var0_188.ikConfig.touch_data) do
		local var1_188, var2_188, var3_188 = unpack(iter1_188)
		local var4_188 = pg.dorm3d_ik_touch[var1_188]

		if var4_188.body == arg1_188 then
			local var5_188 = var4_188.action_emote

			if #var5_188 > 0 then
				var0_188:PlayFaceAnim(var5_188)
			end

			local var6_188 = var4_188.vibrate

			if type(var6_188) == "table" and VibrateMgr.Instance:IsSupport() then
				local var7_188 = {}
				local var8_188 = {}
				local var9_188 = {}

				underscore.each(var6_188, function(arg0_189)
					table.insert(var7_188, arg0_189[1])
					table.insert(var8_188, arg0_189[2])
					table.insert(var9_188, 1)
				end)

				if PLATFORM == PLATFORM_ANDROID then
					VibrateMgr.Instance:VibrateWaveform(var7_188, var8_188)
				elseif PLATFORM == PLATFORM_ANDROID then
					VibrateMgr.Instance:VibrateWaveform(var7_188, var8_188, var9_188)
				end
			end

			arg0_188.scene.blockIK = true

			arg0_188:TouchModeAction(var0_188, unpack(var3_188))(function()
				arg0_188.scene.enableIKTip = true

				arg0_188:ResetIKTipTimer()

				arg0_188.scene.blockIK = nil
			end)

			return
		end
	end
end

function var0_0.UpdateTouchGameDisplay(arg0_191)
	setActive(arg0_191.rtTouchGamePanel:Find("effect_bg"), arg0_191.touchLevel == 2)
	setActive(arg0_191.rtTouchGamePanel:Find("slider/icon/beating"), arg0_191.touchLevel == 2)

	if arg0_191.touchLevel == 1 then
		setActive(arg0_191.uiContianer:Find("ik/btn_back"), true)
		setActive(arg0_191.uiContianer:Find("ik/btn_back_heartbeat"), false)
		quickPlayAnimation(arg0_191.rtTouchGamePanel, "anim_dorm3d_touch_change_out")
		quickPlayAnimation(arg0_191.rtTouchGamePanel:Find("slider/icon"), "anim_dorm3d_touch_icon")
	elseif arg0_191.touchLevel == 2 then
		setActive(arg0_191.uiContianer:Find("ik/btn_back"), false)
		setActive(arg0_191.uiContianer:Find("ik/btn_back_heartbeat"), true)
		quickPlayAnimation(arg0_191.rtTouchGamePanel, "anim_dorm3d_touch_change")
		quickPlayAnimation(arg0_191.rtTouchGamePanel:Find("slider/icon"), "anim_dorm3d_touch_icon_1")
		pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_heartbeat")
	end
end

function var0_0.UpdateTouchCount(arg0_192, arg1_192)
	if arg0_192.touchLevel > 1 then
		arg1_192 = math.min(0, arg1_192)
	end

	arg0_192.touchCount = math.clamp(arg0_192.touchCount + arg1_192, 0, 100)

	if arg0_192.sliderLT and LeanTween.isTweening(arg0_192.sliderLT) then
		LeanTween.cancel(arg0_192.sliderLT)

		arg0_192.sliderLT = nil
	end

	setSlider(arg0_192.rtTouchGamePanel:Find("slider"), 0, 100, arg0_192.touchCount)

	local var0_192

	if arg0_192.touchCount >= 100 then
		var0_192 = 2
	elseif arg0_192.touchCount <= 0 then
		var0_192 = 1
	end

	if var0_192 and var0_192 ~= arg0_192.touchLevel then
		if arg0_192.scene.blockIK then
			return
		end

		arg0_192.touchLevel = var0_192

		local var1_192 = arg0_192.touchConfig.ik_status[var0_192]

		if var1_192 then
			if var0_192 > 1 then
				arg0_192.touchCount = 200
			elseif var0_192 == 1 then
				arg0_192.touchCount = 0
			end

			local var2_192 = arg0_192.ladyDict[arg0_192.apartment:GetConfigID()]

			seriesAsync({
				function(arg0_193)
					arg0_192:ShowBlackScreen(true, arg0_193)
				end,
				function(arg0_194)
					arg0_192:SwitchIKConfig(var2_192, var1_192)
					arg0_192:SetIKState(true, arg0_194)

					if var0_192 > 1 and arg0_192.touchConfig.heartbeat_enter_anim ~= "" then
						var2_192:SwitchAnim(arg0_192.touchConfig.heartbeat_enter_anim)
					end
				end,
				function(arg0_195)
					arg0_192:ShowBlackScreen(false, arg0_195)
				end
			})
		end

		arg0_192:UpdateTouchCount(0)
		arg0_192:UpdateTouchGameDisplay()
	end

	arg0_192.topCount = math.max(arg0_192.topCount, arg0_192.touchCount)
end

function var0_0.ExitHeartbeatMode(arg0_196)
	if not arg0_196.touchLevel or arg0_196.touchLevel == 1 then
		return
	end

	arg0_196.touchCount = 0

	arg0_196:UpdateTouchCount(0)
end

function var0_0.DoTouch(arg0_197, arg1_197, arg2_197)
	if arg0_197.inTouchGame then
		switch(arg2_197, {
			function()
				arg0_197:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat.key_value_int)
			end,
			function()
				arg0_197:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat.key_value_int)
			end,
			function()
				arg0_197:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat.key_value_int)
			end,
			function()
				arg0_197:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat_trriger.key_value_int)
			end
		})
	end
end

function var0_0.DoTalk(arg0_202, arg1_202, arg2_202)
	while rawget(arg0_202, "class") ~= var0_0 do
		arg0_202 = getmetatable(arg0_202).__index
	end

	if arg0_202.apartment and arg0_202.ladyDict[arg0_202.apartment:GetConfigID()]:GetBlackboardValue("inTalking") then
		errorMsg("Talking block:" .. arg1_202)

		return
	end

	if not arg0_202.room:isPersonalRoom() then
		local var0_202 = pg.dorm3d_dialogue_group[arg1_202].char_id

		if arg0_202.apartment then
			assert(arg0_202.apartment:GetConfigID() == var0_202)
		else
			arg0_202:SetApartment(getProxy(ApartmentProxy):getApartment(var0_202))
		end
	end

	local var1_202 = arg0_202.ladyDict[arg0_202.apartment:GetConfigID()]

	if arg1_202 == 10010 and not arg0_202.apartment.talkDic[arg1_202] then
		arg0_202.firstTimelineTouch = true
		arg0_202.firstMoveGuide = true
	end

	local var2_202 = {}
	local var3_202 = arg0_202.ladyDict[arg0_202.apartment:GetConfigID()]

	if var3_202:GetBlackboardValue("inPending") then
		table.insert(var2_202, function(arg0_203)
			arg0_202:OutOfLazy(arg0_202.apartment:GetConfigID(), arg0_203)
		end)
	end

	local var4_202 = pg.dorm3d_dialogue_group[arg1_202]
	local var5_202 = var4_202.performance_type == 1
	local var6_202

	table.insert(var2_202, function(arg0_204)
		arg0_202:emit(arg0_202.SHOW_BLOCK)
		var3_202:SetBlackboardValue(var5_202 and "inPerformance" or "inTalking", true)
		arg0_202:emit(Dorm3dRoomMediator.DO_TALK, arg1_202, function(arg0_205)
			var6_202 = arg0_205

			arg0_204()
		end)
	end)
	table.insert(var2_202, function(arg0_206)
		pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataDialog(arg0_202.apartment.configId, arg0_202.apartment.level, arg1_202, var4_202.type, arg0_202.room:getZoneConfig(arg0_202.ladyDict[arg0_202.apartment:GetConfigID()].ladyBaseZone, "id"), var4_202.action_type, table.CastToString(var4_202.trigger_config), arg0_202.room:GetConfigID()))

		if pg.NewGuideMgr.GetInstance():IsBusy() then
			pg.NewGuideMgr.GetInstance():Pause()
		end

		arg0_202:SetUI(arg0_206, "blank")
	end)

	if var4_202.trigger_area and var4_202.trigger_area ~= "" then
		table.insert(var2_202, function(arg0_207)
			arg0_202:ShiftZone(var4_202.trigger_area, arg0_207)
		end)
	end

	if var4_202.performance_type == 0 then
		table.insert(var2_202, function(arg0_208)
			arg0_202:emit(arg0_202.HIDE_BLOCK)
			pg.NewStoryMgr.GetInstance():ForceManualPlay(var4_202.story, function()
				onDelayTick(arg0_208, 0.001)
			end, true)
		end)
	elseif var4_202.performance_type == 1 then
		table.insert(var2_202, function(arg0_210)
			arg0_202:emit(arg0_202.HIDE_BLOCK)
			arg0_202:PerformanceQueue(var4_202.story, arg0_210)
		end)
	else
		assert(false)
	end

	table.insert(var2_202, function(arg0_211)
		arg0_202:emit(arg0_202.SHOW_BLOCK)
		arg0_211()
	end)
	table.insert(var2_202, function(arg0_212)
		local var0_212 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(var4_202.story)

		if var0_212 then
			local var1_212 = "1"

			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataStory(var0_212, var1_212))
		end

		if var6_202 and #var6_202 > 0 then
			arg0_202:emit(Dorm3dRoomMediator.OPEN_DROP_LAYER, var6_202, arg0_212)
		else
			arg0_212()
		end
	end)
	table.insert(var2_202, function(arg0_213)
		if pg.NewGuideMgr.GetInstance():IsPause() then
			pg.NewGuideMgr.GetInstance():Resume()
		end

		arg0_202:emit(arg0_202.HIDE_BLOCK)
		var3_202:SetBlackboardValue(var5_202 and "inPerformance" or "inTalking", false)
		arg0_202:SetUI(arg0_213, "back")
	end)
	seriesAsync(var2_202, function()
		if arg2_202 then
			return arg2_202()
		else
			arg0_202:CheckQueue()
		end
	end)
end

function var0_0.DoTalkTouchOption(arg0_215, arg1_215, arg2_215, arg3_215)
	local var0_215 = arg0_215.rtExtraScreen:Find("TalkTouchOption")
	local var1_215
	local var2_215 = var0_215:Find("content")

	UIItemList.StaticAlign(var2_215, var2_215:Find("clickTpl"), #arg1_215.options, function(arg0_216, arg1_216, arg2_216)
		arg1_216 = arg1_216 + 1

		if arg0_216 == UIItemList.EventUpdate then
			local var0_216 = arg1_215.options[arg1_216]

			setAnchoredPosition(arg2_216, NewPos(unpack(var0_216.pos)))
			onButton(arg0_215, arg2_216, function()
				var1_215(var0_216.flag)
			end, SFX_CONFIRM)
			setActive(arg2_216, not table.contains(arg2_215, var0_216.flag))
		end
	end)
	setActive(var0_215, true)

	function var1_215(arg0_218)
		setActive(var0_215, false)
		arg3_215(arg0_218)
	end
end

function var0_0.DoTimelineOption(arg0_219, arg1_219, arg2_219)
	local var0_219 = arg0_219.rtTimelineScreen:Find("TimelineOption")
	local var1_219
	local var2_219 = var0_219:Find("content")

	UIItemList.StaticAlign(var2_219, var2_219:Find("clickTpl"), #arg1_219, function(arg0_220, arg1_220, arg2_220)
		arg1_220 = arg1_220 + 1

		if arg0_220 == UIItemList.EventUpdate then
			local var0_220 = arg1_219[arg1_220]

			setText(arg2_220:Find("Text"), var0_220.content)
			onButton(arg0_219, arg2_220, function()
				var1_219(arg1_220)
			end, SFX_CONFIRM)
		end
	end)
	setActive(var0_219, true)

	function var1_219(arg0_222)
		setActive(var0_219, false)
		arg2_219(arg0_222)
	end
end

function var0_0.DoTimelineTouch(arg0_223, arg1_223, arg2_223)
	local var0_223 = arg0_223.rtTimelineScreen:Find("TimelineTouch")
	local var1_223
	local var2_223 = var0_223:Find("content")

	UIItemList.StaticAlign(var2_223, var2_223:Find("clickTpl"), #arg1_223, function(arg0_224, arg1_224, arg2_224)
		arg1_224 = arg1_224 + 1

		if arg0_224 == UIItemList.EventUpdate then
			local var0_224 = arg1_223[arg1_224]

			setAnchoredPosition(arg2_224, NewPos(unpack(var0_224.pos)))
			onButton(arg0_223, arg2_224, function()
				var1_223(arg1_224)
			end, SFX_CONFIRM)

			if arg0_223.firstTimelineTouch then
				arg0_223.firstTimelineTouch = nil

				setActive(arg2_224:Find("finger"), true)
			end
		end
	end)
	setActive(var0_223, true)

	function var1_223(arg0_226)
		setActive(var0_223, false)
		arg2_223(arg0_226)
	end
end

function var0_0.DoShortWait(arg0_227, arg1_227)
	local var0_227 = arg0_227.ladyDict[arg1_227]
	local var1_227 = getProxy(ApartmentProxy):getApartment(arg1_227)
	local var2_227 = arg0_227.room:getApartmentZoneConfig(var0_227.ladyBaseZone, "special_action", arg1_227)
	local var3_227 = var2_227 and var2_227[math.random(#var2_227)] or nil

	if not var3_227 then
		return
	end

	var0_227:PlaySingleAction(var3_227)
end

function var0_0.OutOfLazy(arg0_228, arg1_228, arg2_228)
	local var0_228 = arg0_228.ladyDict[arg1_228]
	local var1_228 = {}

	if var0_228:GetBlackboardValue("inPending") then
		table.insert(var1_228, function(arg0_229)
			arg0_228.shiftLady = arg1_228

			arg0_228:ShiftZone(var0_228.ladyBaseZone, arg0_229)
		end)
	end

	seriesAsync(var1_228, arg2_228)
end

function var0_0.OutOfPending(arg0_230, arg1_230, arg2_230)
	assert(arg0_230.wakeUpTalkId)

	local var0_230 = arg0_230.wakeUpTalkId

	seriesAsync({
		function(arg0_231)
			arg0_230:SetUI(arg0_231, "blank")
		end,
		function(arg0_232)
			arg0_230.shiftLady = arg1_230

			arg0_230:ShiftZone(arg0_230.ladyBaseZone, arg0_232)
		end,
		function(arg0_233)
			arg0_230:DoTalk(var0_230, arg0_233)
		end
	}, function()
		arg0_230:SetUIStore(arg2_230, "back")
	end)
end

function var0_0.ChangeCanWatchState(arg0_235)
	local var0_235

	if arg0_235:GetBlackboardValue("inPending") then
		var0_235 = tobool(arg0_235:GetBlackboardValue("inDistance"))
	else
		local var1_235 = arg0_235:GetBlackboardValue("groupId")

		var0_235 = tobool(arg0_235.activeLady[var1_235] and pg.NodeCanvasMgr.GetInstance():GetBlackboradValue("canWatch", arg0_235.ladyBlackboard))
	end

	if not arg0_235.nowCanWatchState or arg0_235.nowCanWatchState ~= var0_235 then
		arg0_235.nowCanWatchState = var0_235

		arg0_235:ShowOrHideCanWatchMark(arg0_235.nowCanWatchState)
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

function var0_0.HandleGameNotification(arg0_236, arg1_236, arg2_236)
	local var0_236 = arg0_236.ladyDict[arg0_236.apartment:GetConfigID()]

	switch(arg1_236, {
		[EatFoodMediator.HIT_AREA] = function()
			local var0_237, var1_237 = unpack(var1_0[arg2_236.index])

			var0_236:PlaySingleAction(var0_237)

			if arg0_236.tfCutIn then
				quickPlayAnimator(arg0_236.modelCutIn.lady, var1_237)
				quickPlayAnimator(arg0_236.modelCutIn.player, var1_237)
			end
		end,
		[EatFoodMediator.RESULT] = function()
			if arg2_236.win then
				var0_236:PlaySingleAction("Face_XYX_victory")
				var0_236:PlaySingleAction("minigame_win")
			else
				var0_236:PlaySingleAction("Face_XYX_lose")
				var0_236:PlaySingleAction("minigame_lose")
			end

			setActive(arg0_236.rtExtraScreen:Find("MiniGameCutIn"), false)
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataMiniGame(2, arg2_236.score))
		end,
		[EatFoodMediator.LEAVE_GAME] = function()
			if arg2_236 == false then
				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataMiniGame(3))
			end
		end
	})
end

function var0_0.PerformanceQueue(arg0_240, arg1_240, arg2_240)
	local var0_240, var1_240 = pcall(function()
		return require("GameCfg.dorm." .. arg1_240)
	end)

	if not var0_240 then
		errorMsg("不存在表演ID对应的Lua:" .. arg1_240)
		existCall(arg2_240)

		return
	end

	warning(arg1_240)

	local var2_240 = {}

	table.insert(var2_240, function(arg0_242)
		arg0_240:SetUI(arg0_242, "blank")
	end)
	table.insertto(var2_240, underscore.map(var1_240, function(arg0_243)
		return switch(arg0_243.type, {
			function()
				return function(arg0_245)
					local var0_245 = unpack(arg0_243.params)

					arg0_240:DoTalk(var0_245, arg0_245, true)
				end
			end,
			function()
				return function(arg0_247)
					arg0_240.touchExitCall = arg0_247

					arg0_240:EnterTouchMode()
				end
			end,
			function()
				return function(arg0_249)
					arg0_240.ladyDict[arg0_240.apartment:GetConfigID()]:PlaySingleAction(arg0_243.name, arg0_249)
				end
			end,
			function()
				return function(arg0_251)
					arg0_240:emit(arg0_240.PLAY_EXPRESSION, arg0_243)
					arg0_251()
				end
			end,
			function()
				return function(arg0_253)
					arg0_240:ShiftZone(arg0_243.name, arg0_253)
				end
			end,
			function()
				return function(arg0_255)
					arg0_240.contextData.timeIndex = arg0_243.params[1]

					if arg0_240.artSceneInfo == arg0_240.sceneInfo then
						arg0_240:SwitchDayNight(arg0_240.contextData.timeIndex)
						onNextTick(function()
							arg0_240:RefreshSlots()
						end)
					end

					arg0_240:UpdateContactState()
					onNextTick(arg0_255)
				end
			end,
			function()
				return function(arg0_258)
					arg0_240:ActiveStateCamera(arg0_243.name, arg0_258)
				end
			end,
			function()
				return function(arg0_260)
					if arg0_243.name == "base" then
						arg0_240:ChangeArtScene(arg0_240.sceneInfo, arg0_260)
					else
						local var0_260 = arg0_243.params.scene
						local var1_260 = arg0_243.params.sceneRoot

						arg0_240:ChangeArtScene(var0_260 .. "|" .. var1_260, arg0_260)
					end
				end
			end,
			function()
				return function(arg0_262)
					local var0_262 = arg0_243.params.name

					if arg0_243.name == "load" then
						arg0_240.waitForTimeline = tobool(arg0_243.params.wait_timeline)

						arg0_240:LoadTimelineScene(var0_262, true, arg0_262)
					elseif arg0_243.name == "unload" then
						arg0_240:UnloadTimelineScene(var0_262, true, arg0_262)
					else
						assert(false)
					end
				end
			end,
			function()
				return function(arg0_264)
					setActive(arg0_240.uiContianer:Find("walk/btn_back"), false)

					if arg0_243.name == "change" then
						local var0_264 = arg0_243.params.scene
						local var1_264 = arg0_243.params.sceneRoot

						arg0_240.walkBornPoint = arg0_243.params.point or "Default"

						arg0_240:ChangeWalkScene(var0_264 .. "|" .. var1_264, arg0_264)
					elseif arg0_243.name == "back" then
						arg0_240.walkBornPoint = nil

						arg0_240:ChangeWalkScene(arg0_240.sceneInfo, arg0_264)
					elseif arg0_243.name == "set" then
						local function var2_264()
							local var0_265 = arg0_264

							arg0_264 = nil

							return existCall(var0_265)
						end

						for iter0_264, iter1_264 in pairs(arg0_243.params) do
							switch(iter0_264, {
								back_button_trigger = function(arg0_266)
									onButton(arg0_240, arg0_240.uiContianer:Find("walk/btn_back"), var2_264, "ui-dorm_back_v2")
									setActive(arg0_240.uiContianer:Find("walk/btn_back"), IsUnityEditor and arg0_266)
								end,
								near_trigger = function(arg0_267)
									if arg0_267 == true then
										arg0_267 = 1.5
									end

									if arg0_267 then
										function arg0_240.walkNearCallback(arg0_268)
											if arg0_268 < arg0_267 then
												arg0_240.walkNearCallback = nil

												var2_264()
											end
										end
									else
										arg0_240.walkNearCallback = nil
									end
								end
							}, nil, iter1_264)
						end

						if arg0_240.firstMoveGuide then
							setActive(arg0_240.povLayer:Find("Guide"), arg0_240.firstMoveGuide)

							arg0_240.firstMoveGuide = nil
						end
					else
						assert(false)
					end
				end
			end,
			function()
				return function(arg0_270)
					if arg0_243.name == "set" then
						arg0_240:SwitchIKConfig(arg0_240, arg0_243.params.state)
						setActive(arg0_240.uiContianer:Find("ik/btn_back"), not arg0_243.params.hide_back)

						arg0_240.ikSpecialCall = arg0_270

						arg0_240:SetIKState(true)
					elseif arg0_243.name == "back" then
						local var0_270 = arg0_240.ladyDict[arg0_240.apartment:GetConfigID()]

						var0_270.ikConfig = arg0_243.params

						arg0_240:SetIKState(false, function()
							var0_270.ikConfig = nil

							existCall(arg0_270)
						end)
					else
						assert(false)
					end
				end
			end,
			function()
				return function(arg0_273)
					arg0_240.blackSceneInfo = setmetatable(arg0_243.params or {}, {
						__index = {
							color = "#000000",
							time = 0.3,
							delay = arg0_243.name == "show" and 0 or 0.5
						}
					})

					if arg0_243.name == "show" then
						arg0_240:ShowBlackScreen(true, arg0_273)
					elseif arg0_243.name == "hide" then
						arg0_240:ShowBlackScreen(false, arg0_273)
					else
						assert(false)
					end

					arg0_240.blackSceneInfo = nil
				end
			end
		})
	end))
	table.insert(var2_240, function(arg0_274)
		arg0_240:SetUI(arg0_274, "back")
	end)
	seriesAsync(var2_240, arg2_240)
end

function var0_0.TriggerContact(arg0_275, arg1_275)
	arg0_275:emit(Dorm3dRoomMediator.COLLECTION_ITEM, {
		itemId = arg1_275,
		roomId = arg0_275.room:GetConfigID(),
		groupId = arg0_275.room:isPersonalRoom() and arg0_275.apartment:GetConfigID() or 0
	})
end

function var0_0.UpdateContactState(arg0_276)
	arg0_276:SetContactStateDic(arg0_276.room:getTriggerableCollectItemDic(arg0_276.contextData.timeIndex))
end

function var0_0.UpdateFavorDisplay(arg0_277)
	local var0_277, var1_277 = getProxy(ApartmentProxy):getStamina()

	setText(arg0_277.rtStaminaDisplay:Find("Text"), string.format("%d/%d", var0_277, var1_277))
	setActive(arg0_277.rtStaminaDisplay, false)

	if arg0_277.apartment then
		setText(arg0_277.rtFavorLevel:Find("rank/Text"), arg0_277.apartment.level)

		local var2_277, var3_277 = arg0_277.apartment:getFavor()

		setText(arg0_277.rtFavorLevel:Find("Text"), string.format("<color=#ff6698>%d</color>/%d", var2_277, var3_277))
	end

	setActive(arg0_277.rtFavorLevel:Find("red"), Dorm3dLevelLayer.IsShowRed())
end

function var0_0.UpdateBtnState(arg0_278)
	local var0_278 = not arg0_278.room:isPersonalRoom() or arg0_278:CheckSystemOpen("Furniture")
	local var1_278 = Dorm3dFurniture.IsTimelimitShopTip(arg0_278.room:GetConfigID())

	setActive(arg0_278.uiContianer:Find("base/left/btn_furniture/tipTimelimit"), var0_278 and var1_278)

	local var2_278 = Dorm3dFurniture.NeedViewTip(arg0_278.room:GetConfigID())

	setActive(arg0_278.uiContianer:Find("base/left/btn_furniture/tip"), var0_278 and not var1_278 and var2_278)
	setActive(arg0_278.uiContianer:Find("base/btn_back/main"), underscore(getProxy(ApartmentProxy):getRawData()):chain():values():filter(function(arg0_279)
		return tobool(arg0_279)
	end):any(function(arg0_280)
		return #arg0_280:getSpecialTalking() > 0 or arg0_280:getIconTip() == "main"
	end):value())
	setActive(arg0_278.uiContianer:Find("base/left/btn_collection/tip"), PlayerPrefs.GetInt("apartment_collection_item", 0) > 0 or PlayerPrefs.GetInt("apartment_collection_recall", 0) > 0)
end

function var0_0.AddUnlockDisplay(arg0_281, arg1_281)
	table.insert(arg0_281.unlockList, arg1_281)

	if not isActive(arg0_281.rtFavorUp) then
		setText(arg0_281.rtFavorUp:Find("Text"), table.remove(arg0_281.unlockList, 1))
		setActive(arg0_281.rtFavorUp, true)
	end
end

function var0_0.PopFavorTrigger(arg0_282, arg1_282)
	local var0_282 = arg1_282.triggerId
	local var1_282 = arg1_282.delta
	local var2_282 = arg1_282.cost
	local var3_282 = arg1_282.apartment
	local var4_282 = pg.dorm3d_favor_trigger[var0_282]

	if var4_282.is_repeat == 0 then
		if var0_282 == getDorm3dGameset("drom3d_favir_trigger_onwer")[1] then
			arg0_282:AddUnlockDisplay(i18n("dorm3d_own_favor"))
		elseif var0_282 == getDorm3dGameset("drom3d_favir_trigger_propose")[1] then
			arg0_282:AddUnlockDisplay(i18n("dorm3d_pledge_favor"))
		else
			arg0_282:AddUnlockDisplay(string.format("unknow favor trigger:%d unlock", var0_282))
		end
	elseif arg1_282.delta > 0 then
		local var5_282, var6_282 = var3_282:getFavor()
		local var7_282 = var5_282 + var1_282

		setText(arg0_282.rtFavorUpDaily:Find("bg/Text"), string.format("<size=48>+%d</size>", var1_282))
		setSlider(arg0_282.rtFavorUpDaily:Find("bg/slider"), 0, var6_282, var5_282)
		setAnchoredPosition(arg0_282.rtFavorUpDaily:Find("bg"), arg1_282.isGift and NewPos(-354, 223) or NewPos(-208, 105))

		local var8_282 = {}
		local var9_282 = arg0_282.rtFavorUpDaily:Find("bg/effect")

		eachChild(var9_282, function(arg0_283)
			setActive(arg0_283, false)
		end)

		local var10_282

		if var4_282.effect and var4_282.effect ~= "" then
			var10_282 = var9_282:Find(var4_282.effect .. "(Clone)")

			if not var10_282 then
				table.insert(var8_282, function(arg0_284)
					LoadAndInstantiateAsync("Dorm3D/Effect/Prefab/ExpressionUI", "uifx_dorm3d_yinfu01", function(arg0_285)
						setParent(arg0_285, var9_282)

						var10_282 = tf(arg0_285)

						arg0_284()
					end)
				end)
			else
				setActive(var10_282, true)
			end
		end

		local var11_282 = arg0_282.rtFavorUpDaily:GetComponent("DftAniEvent")

		var11_282:SetTriggerEvent(function(arg0_286)
			local var0_286 = GetComponent(arg0_282.rtFavorUpDaily:Find("bg/slider"), typeof(Slider))

			LeanTween.value(var5_282, var7_282, 0.5):setOnUpdate(System.Action_float(function(arg0_287)
				var0_286.value = arg0_287
			end)):setEase(LeanTweenType.easeInOutQuad):setDelay(0.165):setOnComplete(System.Action(function()
				LeanTween.delayedCall(0.165, System.Action(function()
					if arg0_282.exited then
						return
					end

					quickPlayAnimator(arg0_282.rtFavorUpDaily, "favor_out")
				end))
			end))
			pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_progaress_bar")
		end)
		var11_282:SetEndEvent(function(arg0_290)
			setActive(arg0_282.rtFavorUpDaily, false)
		end)
		seriesAsync(var8_282, function()
			local var0_291 = arg0_282.ladyDict[var3_282:GetConfigID()]

			setLocalPosition(arg0_282.rtFavorUpDaily, arg0_282:GetLocalPosition(arg0_282:GetScreenPosition(var0_291.ladyHeadCenter.position), arg0_282.rtFavorUpDaily.parent))
			setActive(arg0_282.rtFavorUpDaily, true)
			SetCompomentEnabled(arg0_282.rtFavorUpDaily, typeof(Animator), true)
			quickPlayAnimator(arg0_282.rtFavorUpDaily, "favor_open")

			if var2_282 > 0 then
				local var1_291, var2_291 = getProxy(ApartmentProxy):getStamina()

				setText(arg0_282.rtStaminaPop:Find("Text/Text (1)"), "-" .. var2_282)
				setText(arg0_282.rtStaminaPop:Find("Text"), string.format("%d/%d", var1_291 + var2_282, var2_291))
				setActive(arg0_282.rtStaminaPop, true)
			end
		end)
	end
end

function var0_0.PopFavorLevelUp(arg0_292, arg1_292, arg2_292, arg3_292)
	arg0_292.isLock = true

	LeanTween.delayedCall(0.33, System.Action(function()
		arg0_292.isLock = false
	end))

	local var0_292 = math.floor(arg1_292.level / 10)
	local var1_292 = math.fmod(arg1_292.level, 10)

	GetImageSpriteFromAtlasAsync("ui/favor_atlas", var1_292, arg0_292.rtLevelUpWindow:Find("panel/bg/item1/mark/level/digit2"))
	GetImageSpriteFromAtlasAsync("ui/favor_atlas", var0_292, arg0_292.rtLevelUpWindow:Find("panel/bg/item1/mark/level/digit1"))
	setActive(arg0_292.rtLevelUpWindow:Find("panel/bg/item1/mark/level/digit1"), var0_292 > 0)

	local var2_292
	local var3_292

	arg0_292.clientAward, var3_292 = Dorm3dIconHelper.SplitStory(arg1_292:getFavorConfig("levelup_client_item", arg1_292.level))
	arg0_292.serverAward = arg2_292

	local var4_292 = arg0_292.rtLevelUpWindow:Find("panel/info/content/itemContent")

	if not arg0_292.levelItemList then
		arg0_292.levelItemList = UIItemList.New(var4_292, var4_292:Find("tpl"))

		arg0_292.levelItemList:make(function(arg0_294, arg1_294, arg2_294)
			local var0_294 = arg1_294 + 1

			if arg0_294 == UIItemList.EventUpdate then
				if arg1_294 < #arg0_292.serverAward then
					updateDorm3dIcon(arg2_294, arg0_292.serverAward[var0_294])
					onButton(arg0_292, arg2_294, function()
						arg0_292:emit(BaseUI.ON_NEW_DROP, {
							drop = arg0_292.serverAward[var0_294]
						})
					end, SFX_PANEL)
				else
					Dorm3dIconHelper.UpdateDorm3dIcon(arg2_294, arg0_292.clientAward[var0_294 - #arg0_292.serverAward])
					onButton(arg0_292, arg2_294, function()
						arg0_292:emit(Dorm3dRoomMediator.ON_DROP_CLIENT, {
							data = arg0_292.clientAward[var0_294 - #arg0_292.serverAward]
						})
					end, SFX_PANEL)
				end
			end
		end)
	end

	arg0_292.levelItemList:align(#arg0_292.serverAward + #arg0_292.clientAward)
	setActive(arg0_292.rtLevelUpWindow, true)
	pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_upgrade")
	pg.UIMgr.GetInstance():OverlayPanel(arg0_292.rtLevelUpWindow, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_DORM3D
	})

	function arg0_292.levelUpCallback()
		arg0_292.levelUpCallback = nil

		if var3_292 then
			arg0_292:PopNewStoryTip(var3_292)
		end

		existCall(arg3_292)
	end
end

function var0_0.PopNewStoryTip(arg0_298, arg1_298, arg2_298)
	local var0_298 = arg0_298.uiContianer:Find("base/top/story_tip")

	setActive(var0_298, true)
	LeanTween.delayedCall(1, System.Action(function()
		setActive(var0_298, false)
	end))
	setText(var0_298:Find("Text"), i18n("dorm3d_story_unlock_tip", pg.dorm3d_recall[arg1_298[2]].name))
	existCall(arg2_298)
end

function var0_0.UpdateZoneList(arg0_300)
	local var0_300

	if arg0_300.room:isPersonalRoom() then
		var0_300 = arg0_300.ladyDict[arg0_300.apartment:GetConfigID()].ladyBaseZone
	else
		var0_300 = arg0_300:GetAttachedFurnitureName()
	end

	for iter0_300, iter1_300 in ipairs(arg0_300.zoneDatas) do
		if iter1_300:GetWatchCameraName() == var0_300 then
			setText(arg0_300.btnZone:Find("Text"), iter1_300:GetName())
			setTextColor(arg0_300.rtZoneList:GetChild(iter0_300 - 1):Find("Name"), Color.NewHex("5CCAFF"))
		else
			setTextColor(arg0_300.rtZoneList:GetChild(iter0_300 - 1):Find("Name"), Color.NewHex("FFFFFF99"))
		end
	end
end

function var0_0.TalkingEventHandle(arg0_301, arg1_301)
	local var0_301 = {}
	local var1_301 = {}
	local var2_301 = arg1_301.data

	if var2_301.op_list then
		for iter0_301, iter1_301 in ipairs(var2_301.op_list) do
			table.insert(var0_301, function(arg0_302)
				local function var0_302()
					local var0_303 = arg0_302

					arg0_302 = nil

					return existCall(var0_303)
				end

				switch(iter1_301.type, {
					action = function()
						arg0_301.ladyDict[arg0_301.apartment:GetConfigID()]:PlaySingleAction(iter1_301.name, var0_302)
					end,
					item_action = function()
						arg0_301.scene:PlaySceneItemAnim(iter1_301.id, iter1_301.name)
						var0_302()
					end,
					timeline = function()
						if arg0_301.inTouchGame then
							setActive(arg0_301.rtTouchGamePanel, false)
						end

						arg0_301:PlayTimeline(iter1_301, function(arg0_307, arg1_307)
							setActive(arg0_301.rtTouchGamePanel, arg0_301.inTouchGame)

							var1_301.notifiCallback = arg1_307

							var0_302()
						end)
					end,
					clickOption = function()
						arg0_301:DoTalkTouchOption(iter1_301, arg1_301.flags, function(arg0_309)
							var1_301.optionIndex = arg0_309

							var0_302()
						end)
					end,
					wait = function()
						arg0_301.LTs = arg0_301.LTs or {}

						table.insert(arg0_301.LTs, LeanTween.delayedCall(iter1_301.time, System.Action(var0_302)).uniqueId)
					end,
					expression = function()
						arg0_301:emit(arg0_301.PLAY_EXPRESSION, iter1_301)
						var0_302()
					end
				}, function()
					assert(false, "op type error:", iter1_301.type)
				end)

				if iter1_301.skip then
					var0_302()
				end
			end)
		end
	end

	seriesAsync(var0_301, function()
		if arg1_301.callbackData then
			arg0_301:emit(Dorm3dRoomMediator.TALKING_EVENT_FINISH, arg1_301.callbackData.name, var1_301)
		end
	end)
end

function var0_0.CheckQueue(arg0_314)
	if arg0_314.inGuide or arg0_314.uiState ~= "base" then
		return
	end

	if arg0_314.room:GetConfigID() == 1 and arg0_314:CheckGuide() then
		-- block empty
	elseif arg0_314.room:isPersonalRoom() and arg0_314:CheckLevelUp() then
		-- block empty
	elseif arg0_314.apartment and arg0_314:CheckEnterDeal() then
		-- block empty
	elseif arg0_314.apartment and arg0_314:CheckActiveTalk() then
		-- block empty
	elseif arg0_314.apartment then
		arg0_314:CheckFavorTrigger()
	end

	arg0_314.contextData.hasEnterCheck = true
end

function var0_0.didEnterCheck(arg0_315)
	local var0_315

	if arg0_315.contextData.specialId then
		var0_315 = arg0_315.contextData.specialId
		arg0_315.contextData.specialId = nil

		arg0_315:DoTalk(var0_315, function()
			arg0_315:closeView()
		end)
	elseif not arg0_315.contextData.hasEnterCheck and arg0_315.apartment then
		for iter0_315, iter1_315 in ipairs(arg0_315.apartment:getForceEnterTalking(arg0_315.room:GetConfigID())) do
			var0_315 = iter1_315

			arg0_315:DoTalk(iter1_315)

			break
		end
	end

	if var0_315 and pg.dorm3d_dialogue_group[var0_315].extend_loading > 0 then
		arg0_315.contextData.hasEnterCheck = true

		pg.SceneAnimMgr.GetInstance():RegisterDormNextCall(function()
			arg0_315:FinishEnterResume()
		end)
	else
		if arg0_315.apartment and arg0_315.contextData.pendingDic[arg0_315.apartment:GetConfigID()] then
			arg0_315.contextData.hasEnterCheck = true
		end

		for iter2_315, iter3_315 in pairs(arg0_315.contextData.pendingDic) do
			arg0_315.ladyDict[iter2_315]:SetInPending(iter3_315)
		end

		arg0_315.contextData.pendingDic = {}

		arg0_315:FinishEnterResume()
		arg0_315:CheckQueue()
	end
end

function var0_0.CheckGuide(arg0_318)
	if arg0_318.ladyDict[arg0_318.apartment:GetConfigID()]:GetBlackboardValue("inPending") then
		return
	end

	for iter0_318, iter1_318 in ipairs({
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
				return arg0_318:CheckSystemOpen("Furniture")
			end
		},
		{
			name = "DORM3D_GUIDE_07",
			active = function()
				return arg0_318:CheckSystemOpen("DayNight")
			end
		}
	}) do
		if not pg.NewStoryMgr.GetInstance():IsPlayed(iter1_318.name) and iter1_318.active() then
			arg0_318:SetAllBlackbloardValue("inGuide", true)

			local function var0_318()
				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(2, pg.NewStoryMgr.GetInstance():StoryName2StoryId(iter1_318.name)))
				arg0_318:SetAllBlackbloardValue("inGuide", false)
			end

			pg.m02:sendNotification(GAME.STORY_UPDATE, {
				storyId = iter1_318.name
			})
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(1, pg.NewStoryMgr.GetInstance():StoryName2StoryId(iter1_318.name)))
			pg.NewGuideMgr.GetInstance():Play(iter1_318.name, nil, var0_318, var0_318)

			return true
		end
	end

	return false
end

function var0_0.CheckFavorTrigger(arg0_324)
	for iter0_324, iter1_324 in ipairs({
		{
			triggerId = getDorm3dGameset("drom3d_favir_trigger_onwer")[1],
			active = function()
				local var0_325 = getProxy(CollectionProxy):getShipGroup(arg0_324.apartment.configId)

				return tobool(var0_325)
			end
		},
		{
			triggerId = getDorm3dGameset("drom3d_favir_trigger_propose")[1],
			active = function()
				local var0_326 = getProxy(CollectionProxy):getShipGroup(arg0_324.apartment.configId)

				return var0_326 and var0_326.married > 0
			end
		}
	}) do
		if arg0_324.apartment.triggerCountDic[iter1_324.triggerId] == 0 and iter1_324.active() then
			arg0_324:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_324.apartment.configId, iter1_324.triggerId)
		end
	end
end

function var0_0.CheckEnterDeal(arg0_327)
	if arg0_327.contextData.hasEnterCheck then
		return false
	end

	local var0_327 = arg0_327.apartment:GetConfigID()
	local var1_327 = "dorm3d_enter_count_" .. var0_327
	local var2_327 = pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d")

	if PlayerPrefs.GetString("dorm3d_enter_count_day") ~= var2_327 then
		PlayerPrefs.SetString("dorm3d_enter_count_day", var2_327)
		PlayerPrefs.SetInt(var1_327, 1)
	else
		PlayerPrefs.SetInt(var1_327, PlayerPrefs.GetInt(var1_327, 0) + 1)
	end

	local var3_327 = arg0_327.apartment:getEnterTalking(arg0_327.room:GetConfigID())

	PlayerPrefs.SetString("DORM3D_DAILY_ENTER", pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d"))

	if #var3_327 > 0 then
		arg0_327:DoTalk(var3_327[math.random(#var3_327)])

		return true
	end
end

function var0_0.CheckActiveTalk(arg0_328)
	local var0_328 = arg0_328.ladyDict[arg0_328.apartment:GetConfigID()]

	if var0_328:GetBlackboardValue("inPending") then
		return false
	end

	local var1_328 = arg0_328.apartment:getZoneTalking(arg0_328.room:GetConfigID(), var0_328.ladyBaseZone)

	if #var1_328 > 0 then
		arg0_328:DoTalk(var1_328[1])

		return true
	else
		return false
	end
end

function var0_0.CheckDistanceTalk(arg0_329, arg1_329, arg2_329)
	local var0_329 = arg0_329.ladyDict[arg1_329].ladyBaseZone
	local var1_329 = getProxy(ApartmentProxy):getApartment(arg1_329)

	for iter0_329, iter1_329 in ipairs(var1_329:getDistanceTalking(arg0_329.room:GetConfigID(), var0_329)) do
		arg0_329:DoTalk(iter1_329)

		return
	end
end

function var0_0.CheckSystemOpen(arg0_330, arg1_330)
	if arg0_330.room:isPersonalRoom() then
		return switch(arg1_330, {
			Talk = function()
				local var0_331 = 1

				return var0_331 <= arg0_330.apartment.level, i18n("apartment_level_unenough", var0_331)
			end,
			Touch = function()
				local var0_332 = getDorm3dGameset("drom3d_touch_dialogue")[1]

				return var0_332 <= arg0_330.apartment.level, i18n("apartment_level_unenough", var0_332)
			end,
			Gift = function()
				local var0_333 = getDorm3dGameset("drom3d_gift_dialogue")[1]

				return var0_333 <= arg0_330.apartment.level, i18n("apartment_level_unenough", var0_333)
			end,
			Volleyball = function()
				return false
			end,
			Photo = function()
				local var0_335 = getDorm3dGameset("drom3d_photograph_unlock")[1]

				return var0_335 <= arg0_330.apartment.level, i18n("apartment_level_unenough", var0_335)
			end,
			Collection = function()
				local var0_336 = getDorm3dGameset("drom3d_recall_unlock")[1]

				return var0_336 <= arg0_330.apartment.level, i18n("apartment_level_unenough", var0_336)
			end,
			Furniture = function()
				local var0_337 = getDorm3dGameset("drom3d_furniture_unlock")[1]

				return var0_337 <= arg0_330.apartment.level, i18n("apartment_level_unenough", var0_337)
			end,
			DayNight = function()
				local var0_338 = getDorm3dGameset("drom3d_time_unlock")[1]

				return var0_338 <= arg0_330.apartment.level, i18n("apartment_level_unenough", var0_338)
			end,
			Accompany = function()
				local var0_339 = 1

				return var0_339 <= arg0_330.apartment.level, i18n("apartment_level_unenough", var0_339)
			end,
			MiniGame = function()
				local var0_340 = 1

				return var0_340 <= arg0_330.apartment.level, i18n("apartment_level_unenough", var0_340)
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
		return switch(arg1_330, {
			Gift = function()
				return false
			end,
			Volleyball = function()
				return arg0_330.room:GetConfigID() == 4
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

function var0_0.CheckLevelUp(arg0_352)
	if arg0_352.apartment:canLevelUp() then
		arg0_352:emit(Dorm3dRoomMediator.FAVOR_LEVEL_UP, arg0_352.apartment.configId)

		return true
	end

	return false
end

function var0_0.GetIKTipsRootTF(arg0_353)
	return arg0_353.ikTipsRoot
end

function var0_0.GetIKHandTF(arg0_354)
	return arg0_354.ikHand
end

function var0_0.CycleIKCameraGroup(arg0_355)
	local var0_355 = arg0_355.ladyDict[arg0_355.apartment:GetConfigID()]

	assert(var0_355:GetBlackboardValue("inIK"))
	seriesAsync({
		function(arg0_356)
			arg0_355.RevertIKLayer(var0_355, 0, arg0_356)
		end,
		function(arg0_357)
			local var0_357 = var0_355.ikConfig
			local var1_357 = var0_357.camera_group
			local var2_357 = pg.dorm3d_ik_status.get_id_list_by_camera_group[var1_357]
			local var3_357 = var2_357[table.indexof(var2_357, var0_357.id) % #var2_357 + 1]

			arg0_355:SwitchIKConfig(var0_355, var3_357)
			arg0_355:SetIKState(true)
		end
	})
end

function var0_0.TempHideUI(arg0_358, arg1_358, arg2_358)
	local var0_358 = defaultValue(arg0_358.hideCount, 0)

	arg0_358.hideCount = var0_358 + (arg1_358 and 1 or -1)

	assert(arg0_358.hideCount >= 0)

	if arg0_358.hideCount * var0_358 > 0 then
		return existCall(arg2_358)
	elseif arg0_358.hideCount > 0 then
		arg0_358:SetUI(arg2_358, "blank")
	else
		arg0_358:SetUI(arg2_358, "back")
	end
end

function var0_0.onBackPressed(arg0_359)
	if arg0_359.exited or arg0_359.retainCount > 0 then
		-- block empty
	elseif isActive(arg0_359.rtLevelUpWindow) then
		triggerButton(arg0_359.rtLevelUpWindow:Find("bg"))
	elseif arg0_359.uiState ~= "base" then
		-- block empty
	else
		arg0_359:closeView()
	end
end

function var0_0.willExit(arg0_360)
	if arg0_360.downTimer then
		arg0_360.downTimer:Stop()

		arg0_360.downTimer = nil
	end

	if arg0_360.LTs then
		underscore.map(arg0_360.LTs, function(arg0_361)
			LeanTween.cancel(arg0_361)
		end)

		arg0_360.LTs = nil
	end

	if arg0_360.sliderLT then
		LeanTween.cancel(arg0_360.sliderLT)

		arg0_360.sliderLT = nil
	end

	for iter0_360, iter1_360 in pairs(arg0_360.ladyDict) do
		iter1_360.wakeUpTalkId = nil
	end

	if arg0_360.accompanyFavorTimer then
		arg0_360.accompanyFavorTimer:Stop()

		arg0_360.accompanyFavorTimer = nil
	end

	if arg0_360.accompanyPerformanceTimer then
		arg0_360.accompanyPerformanceTimer:Stop()

		arg0_360.accompanyPerformanceTimer = nil
	end

	arg0_360.canTriggerAccompanyPerformance = nil

	var0_0.super.willExit(arg0_360)
end

return var0_0
