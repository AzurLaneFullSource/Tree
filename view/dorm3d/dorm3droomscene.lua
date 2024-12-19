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
		local var0_28 = arg0_4.apartment:GetConfigID()
		local var1_28 = arg0_4.ladyDict[var0_28]
		local var2_28 = var1_28.skinIdList
		local var3_28 = var1_28.skinId
		local var4_28 = {}
		local var5_28 = {}

		_.each(var2_28, function(arg0_29)
			if ApartmentProxy.CheckUnlockConfig(pg.dorm3d_resource[arg0_29].unlock) then
				table.insert(var4_28, arg0_29)
			else
				table.insert(var5_28, arg0_29)
			end
		end)

		local function var6_28(arg0_30, arg1_30)
			local var0_30 = arg1_30 and var4_28 or var5_28

			UIItemList.StaticAlign(arg0_30, arg0_30:GetChild(0), #var0_30, function(arg0_31, arg1_31, arg2_31)
				if arg0_31 ~= UIItemList.EventUpdate then
					return
				end

				local var0_31 = var0_30[arg1_31 + 1]

				setActive(arg2_31:Find("Selected"), var0_31 == var3_28)
				setActive(arg2_31:Find("Lock"), not arg1_30)

				if not arg1_30 then
					setText(arg2_31:Find("Lock/Bar/Text"), pg.dorm3d_resource[var0_31].unlock_text)
				end

				arg0_4.loader:GetSpriteQuiet(string.format("dorm3dselect/apartment_skin_%d", var0_31), "", arg2_31:Find("Icon"))
				onButton(arg0_4, arg2_31, function()
					if not arg1_30 then
						local var0_32, var1_32 = ApartmentProxy.CheckUnlockConfig(pg.dorm3d_resource[var0_31].unlock)

						pg.TipsMgr.GetInstance():ShowTips(var1_32)

						return
					end

					if var0_31 == var3_28 then
						return
					end

					local var2_32 = var0_31

					seriesAsync({
						function(arg0_33)
							arg0_4:SetIKState(false, arg0_33)
						end,
						function(arg0_34)
							arg0_4.SwitchCharacterSkin(var1_28, var0_28, var2_32)
							arg0_4:SwitchIKConfig(var1_28, var1_28.ikConfig.id)
							arg0_4:SetIKState(true, arg0_34)
						end,
						var3_4
					})
				end, SFX_PANEL)
			end)
		end

		var6_28(var2_4:Find("Panel/BG/Scroll/Content/Unlock/List"), true)
		var6_28(var2_4:Find("Panel/BG/Scroll/Content/Lock/List"), false)
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
	eachChild(arg0_4.ikHand, function(arg0_37)
		setActive(arg0_37, false)
	end)

	local var4_4 = arg0_4.uiContianer:Find("accompany")

	onButton(arg0_4, var4_4:Find("btn_back"), function()
		arg0_4:ExitAccompanyMode()
	end, "ui-dorm_back_v2")

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

	local var5_4 = arg0_4.rtStaminaPop:GetComponent("DftAniEvent")

	var5_4:SetTriggerEvent(function(arg0_40)
		local var0_40, var1_40 = getProxy(ApartmentProxy):getStamina()

		setText(arg0_4.rtStaminaPop:Find("Text"), string.format("%d/%d", var0_40, var1_40))
	end)
	var5_4:SetEndEvent(function(arg0_41)
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
		local var0_51 = arg0_4.ladyDict[arg0_4.apartment:GetConfigID()]
		local var1_51 = {}

		table.insert(var1_51, function(arg0_52)
			arg0_4:SetAllBlackbloardValue("inLockLayer", true)
			arg0_4:TempHideUI(true, arg0_52)
		end)

		if var0_51.ladyBaseZone ~= "Chair" then
			table.insert(var1_51, function(arg0_53)
				arg0_4:ShiftZone("Chair", arg0_53)
			end)
		end

		table.insert(var1_51, function(arg0_54)
			parallelAsync({
				function(arg0_55)
					var0_51:PlaySingleAction("SitStart", arg0_55)
				end,
				function(arg0_56)
					arg0_4:ActiveStateCamera("talk", arg0_56)
				end
			}, arg0_54)
		end)
		table.insert(var1_51, function(arg0_57)
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataMiniGame(1))
			arg0_4:EnableMiniGameCutIn()
			arg0_4:emit(Dorm3dRoomMediator.OPEN_MINIGAME_WINDOW, {
				isDorm3d = true
			}, arg0_57)
		end)
		table.insert(var1_51, function(arg0_58)
			arg0_4:DisableMiniGameCutIn()
			var0_51:PlaySingleAction("SitEnd", arg0_58)
		end)
		seriesAsync(var1_51, function()
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

	eachChild(var7_4, function(arg0_63)
		setActive(arg0_63, arg0_63.name == "walk")
	end)

	arg0_4._joystick = arg0_4._tf:Find("Stick")

	setActive(arg0_4._joystick, false)
	arg0_4._joystick:GetComponent(typeof(SlideController)):SetStickFunc(function(arg0_64)
		arg0_4:emit(arg0_4.ON_STICK_MOVE, arg0_64)
	end)

	arg0_4.povLayer = arg0_4._tf:Find("POVControl")

	setActive(arg0_4.povLayer, false)
	;(function()
		local var0_65 = arg0_4.povLayer:Find("Move"):GetComponent(typeof(SlideController))

		var0_65:AddBeginDragFunc(function(arg0_66, arg1_66)
			arg0_4:emit(arg0_4.ON_POV_STICK_MOVE_BEGIN, arg1_66)
		end)
		var0_65:SetStickFunc(function(arg0_67)
			arg0_4:emit(arg0_4.ON_POV_STICK_MOVE, arg0_67)
		end)
		var0_65:AddDragEndFunc(function(arg0_68, arg1_68)
			arg0_4:emit(arg0_4.ON_POV_STICK_MOVE_END, arg1_68)
		end)
		arg0_4.povLayer:Find("View"):GetComponent(typeof(SlideController)):SetStickFunc(function(arg0_69)
			arg0_4:emit(arg0_4.ON_POV_STICK_VIEW, arg0_69)
		end)
	end)()

	arg0_4.ikControlLayer = var2_4:Find("ControlLayer")

	;(function()
		local var0_70
		local var1_70 = arg0_4.ikControlLayer:GetComponent(typeof(SlideController))

		var1_70:AddBeginDragFunc(function(arg0_71, arg1_71)
			local var0_71 = arg0_4.ladyDict[arg0_4.apartment:GetConfigID()]
			local var1_71 = arg1_71.position
			local var2_71 = CameraMgr.instance:Raycast(arg0_4.sceneRaycaster, var1_71)

			if var2_71.Length ~= 0 then
				local var3_71 = var2_71[0].gameObject.transform
				local var4_71 = table.keyof(var0_71.ladyColliders, var3_71)

				if var4_71 then
					arg0_4:emit(var0_0.ON_BEGIN_DRAG_CHARACTER_BODY, var0_71, var4_71, var1_71)

					var0_70 = tobool(var0_71.ikHandler)

					return
				end
			end
		end)
		var1_70:AddDragFunc(function(arg0_72, arg1_72)
			local var0_72 = arg1_72.position
			local var1_72 = arg0_4.ladyDict[arg0_4.apartment:GetConfigID()]

			if var1_72.ikHandler then
				var1_72:emit(var0_0.ON_DRAG_CHARACTER_BODY, var1_72, var0_72)

				return
			end

			if var0_70 then
				return
			end

			local var2_72 = arg1_72.delta

			arg0_4:emit(arg0_4.ON_STICK_MOVE, var2_72)
		end)
		var1_70:AddDragEndFunc(function(arg0_73, arg1_73)
			var0_70 = nil

			local var0_73 = arg0_4.ladyDict[arg0_4.apartment:GetConfigID()]

			if var0_73.ikHandler then
				var0_73:emit(var0_0.ON_RELEASE_CHARACTER_BODY, var0_73)

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

function var0_0.BindEvent(arg0_75)
	var0_0.super.BindEvent(arg0_75)
	arg0_75:bind(arg0_75.CLICK_CHARACTER, function(arg0_76, arg1_76)
		if arg0_75.uiState ~= "base" or not arg0_75.ladyDict[arg1_76].nowCanWatchState then
			return
		end

		local var0_76 = {}
		local var1_76 = arg0_75.ladyDict[arg1_76]

		if var1_76:GetBlackboardValue("inPending") then
			table.insert(var0_76, function(arg0_77)
				var1_76:OutOfPending(arg1_76, arg0_77)
			end)
		else
			table.insert(var0_76, function(arg0_78)
				arg0_75:OutOfLazy(arg1_76, arg0_78)
			end)
		end

		seriesAsync(var0_76, function()
			if not arg0_75.room:isPersonalRoom() then
				arg0_75:SetApartment(getProxy(ApartmentProxy):getApartment(arg1_76))
			end

			arg0_75:EnterWatchMode()
		end)
		pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_touch_v1")
	end)
	arg0_75:bind(arg0_75.CLICK_CONTACT, function(arg0_80, arg1_80)
		arg0_75:TriggerContact(arg1_80)
	end)
	arg0_75:bind(arg0_75.DISTANCE_TRIGGER, function(arg0_81, arg1_81, arg2_81)
		if arg0_75.uiState == "base" then
			arg0_75:CheckDistanceTalk(arg1_81, arg2_81)
		end
	end)
	arg0_75:bind(arg0_75.WALK_DISTANCE_TRIGGER, function(arg0_82, arg1_82, arg2_82)
		if arg0_75.apartment and arg0_75.apartment:GetConfigID() == arg1_82 then
			existCall(arg0_75.walkNearCallback, arg2_82)
		end
	end)
	arg0_75:bind(arg0_75.CHANGE_WATCH, function(arg0_83, arg1_83)
		arg0_75.ladyDict[arg1_83]:ChangeCanWatchState()
	end)
	arg0_75:bind(arg0_75.ON_TOUCH_CHARACTER, function(arg0_84, arg1_84)
		if not arg0_75.ladyDict[arg0_75.apartment:GetConfigID()]:GetBlackboardValue("inIK") then
			return
		end

		arg0_75:OnTouchCharacterBody(arg1_84)
	end)
	arg0_75:bind(arg0_75.ON_IK_STATUS_CHANGED, function(arg0_85, arg1_85, arg2_85)
		if not arg0_75.ladyDict[arg0_75.apartment:GetConfigID()]:GetBlackboardValue("inTouching") then
			return
		end

		arg0_75:DoTouch(arg1_85, arg2_85)
	end)
	arg0_75:bind(arg0_75.ON_ENTER_SECTOR, function(arg0_86, arg1_86)
		arg0_75.ladyDict[arg1_86]:ChangeCanWatchState()
	end)
	arg0_75:bind(arg0_75.ON_CHANGE_DISTANCE, function(arg0_87, arg1_87, arg2_87)
		arg0_75.ladyDict[arg1_87]:ChangeCanWatchState()
	end)
end

function var0_0.didEnter(arg0_88)
	var0_0.super.didEnter(arg0_88)
	arg0_88:UpdateZoneList()

	arg0_88.resumeCallback = arg0_88.contextData.resumeCallback
	arg0_88.contextData.resumeCallback = nil

	arg0_88:SetUI(function()
		arg0_88:didEnterCheck()
	end, "base")
end

function var0_0.FinishEnterResume(arg0_90)
	if not arg0_90.resumeCallback then
		return
	end

	local var0_90 = arg0_90.resumeCallback

	arg0_90.resumeCallback = nil

	return var0_90()
end

function var0_0.EnableJoystick(arg0_91, arg1_91)
	setActive(arg0_91._joystick, arg1_91)
end

function var0_0.EnablePOVLayer(arg0_92, arg1_92)
	setActive(arg0_92.povLayer, arg1_92)

	if not arg1_92 then
		arg0_92:emit(arg0_92.ON_POV_STICK_MOVE_END)
	end
end

function var0_0.SetUIStore(arg0_93, arg1_93, ...)
	table.insertto(arg0_93.uiStore, {
		...
	})
	existCall(arg1_93)
end

function var0_0.SetUI(arg0_94, arg1_94, ...)
	while rawget(arg0_94, "class") ~= var0_0 do
		arg0_94 = getmetatable(arg0_94).__index
	end

	table.insertto(arg0_94.uiStore, {
		...
	})

	for iter0_94, iter1_94 in ipairs(arg0_94.uiStore) do
		if iter1_94 == "back" then
			assert(#arg0_94.uiStack > 0)

			arg0_94.uiState = table.remove(arg0_94.uiStack)
		elseif iter1_94 == arg0_94.uiState and iter1_94 == "ik" then
			-- block empty
		else
			table.insert(arg0_94.uiStack, arg0_94.uiState)

			arg0_94.uiState = iter1_94
		end
	end

	arg0_94.uiStore = {}

	eachChild(arg0_94.uiContianer, function(arg0_95)
		setActive(arg0_95, arg0_95.name == arg0_94.uiState)
	end)
	arg0_94:EnablePOVLayer(arg0_94.uiState == "base" or arg0_94.uiState == "walk")
	arg0_94:TempHideContact(arg0_94.uiState ~= "base")
	arg0_94:SetFloatEnable(arg0_94.uiState == "walk")
	setActive(arg0_94.rtFloatPage, arg0_94.uiState == "walk")
	switch(arg0_94.uiState, {
		base = function()
			if not arg0_94.room:isPersonalRoom() then
				arg0_94:SetApartment(nil)
			end

			arg0_94:UpdateBtnState()
		end,
		watch = function()
			eachChild(arg0_94.rtRole, function(arg0_98)
				setActive(arg0_98, false)
			end)

			local var0_97 = underscore.filter({
				"Talk",
				"Touch",
				"Gift",
				"MiniGame",
				"Volleyball",
				"Performance"
			}, function(arg0_99)
				return arg0_94:CheckSystemOpen(arg0_99)
			end)
			local var1_97 = 0.05

			for iter0_97, iter1_97 in ipairs(var0_97) do
				LeanTween.delayedCall(var1_97, System.Action(function()
					setActive(arg0_94.rtRole:Find(iter1_97), true)
				end))

				var1_97 = var1_97 + 0.066
			end

			setActive(arg0_94.rtRole:Find("Gift/bg/Tip"), Dorm3dGift.NeedViewTip(arg0_94.apartment:GetConfigID()))
		end,
		ik = function()
			setActive(arg0_94.uiContianer:Find("ik/Right/MenuSmall"), arg0_94.room:isPersonalRoom())
			setActive(arg0_94.uiContianer:Find("ik/Right/Menu"), false)
		end,
		walk = function()
			setText(arg0_94.uiContianer:Find("walk/dialogue/content"), i18n("dorm3d_removable", arg0_94.apartment:getConfig("name")))
		end
	})
	arg0_94:ActiveStateCamera(arg0_94.uiState, function()
		if arg1_94 then
			arg1_94()
		elseif arg0_94.uiState == "base" then
			arg0_94:CheckQueue()
		end
	end)
end

function var0_0.EnterWatchMode(arg0_104, arg1_104)
	local var0_104 = arg0_104.apartment:GetConfigID()

	seriesAsync({
		function(arg0_105)
			arg0_104:emit(arg0_104.SHOW_BLOCK)
			arg0_104.ladyDict[var0_104]:SetBlackboardValue("inWatchMode", true)
			arg0_104:SetUI(arg0_105, "watch")
		end,
		function(arg0_106)
			arg0_104:emit(arg0_104.HIDE_BLOCK)
		end
	})
end

function var0_0.ExitWatchMode(arg0_107)
	local var0_107 = arg0_107.apartment:GetConfigID()

	seriesAsync({
		function(arg0_108)
			arg0_107:emit(arg0_107.SHOW_BLOCK)
			arg0_107:SetUI(arg0_108, "back")
		end,
		function(arg0_109)
			arg0_107.ladyDict[var0_107]:SetBlackboardValue("inWatchMode", false)
			arg0_107:emit(arg0_107.HIDE_BLOCK)
			arg0_107:CheckQueue()
		end
	})
end

function var0_0.SetInPending(arg0_110, arg1_110)
	local var0_110 = arg0_110:GetBlackboardValue("groupId")
	local var1_110 = pg.dorm3d_welcome[arg1_110]

	arg0_110:SetBlackboardValue("inPending", true)
	arg0_110:ChangeCanWatchState()
	arg0_110:EnableHeadIK(false)

	arg0_110.contextData.ladyZone[var0_110] = var1_110.area
	arg0_110.ladyBaseZone = arg0_110.contextData.ladyZone[var0_110]
	arg0_110.ladyActiveZone = var1_110.welcome_staypoint

	arg0_110:ChangeCharacterPosition()

	if var1_110.item_shield ~= "" then
		arg0_110.hideItemDic = {}

		for iter0_110, iter1_110 in ipairs(var1_110.item_shield) do
			local var2_110 = arg0_110.modelRoot:Find(iter1_110)

			if not var2_110 then
				warning(string.format("welcome:%d without hide item:%s", arg1_110, iter1_110))
			else
				arg0_110.hideItemDic[iter1_110] = isActive(var2_110)

				setActive(var2_110, false)
			end
		end
	end

	onNextTick(function()
		if arg0_110.tfPendintItem then
			setActive(arg0_110.tfPendintItem, true)
		end

		arg0_110:SwitchAnim(var1_110.welcome_idle)
	end)

	arg0_110.wakeUpTalkId = var1_110.welcome_talk
end

function var0_0.SetOutPending(arg0_112)
	arg0_112:SetBlackboardValue("inPending", false)
	arg0_112:ChangeCanWatchState()
	arg0_112:EnableHeadIK(true)

	arg0_112.wakeUpTalkId = nil

	if arg0_112.tfPendintItem then
		setActive(arg0_112.tfPendintItem, false)
	end

	if arg0_112.hideItemDic then
		for iter0_112, iter1_112 in pairs(arg0_112.hideItemDic) do
			setActive(arg0_112.modelRoot:Find(iter0_112), iter1_112)
		end

		arg0_112.hideItemDic = nil
	end
end

function var0_0.IsModeInHidePending(arg0_113, arg1_113)
	for iter0_113, iter1_113 in pairs(arg0_113.ladyDict) do
		if iter1_113.hideItemDic and iter1_113.hideItemDic[arg1_113] ~= nil then
			return true
		end
	end

	return false
end

function var0_0.EnterAccompanyMode(arg0_114, arg1_114)
	local var0_114 = pg.dorm3d_accompany[arg1_114]
	local var1_114
	local var2_114

	if var0_114.sceneInfo ~= "" then
		var1_114, var2_114 = unpack(string.split(var0_114.sceneInfo, "|"))
	end

	local var3_114 = {
		type = "timeline",
		name = var0_114.timeline,
		scene = var1_114,
		sceneRoot = var2_114,
		accompanys = {}
	}

	for iter0_114, iter1_114 in ipairs(var0_114.jump_trigger) do
		local var4_114, var5_114 = unpack(iter1_114)

		var3_114.accompanys[var4_114] = var5_114
	end

	local var6_114, var7_114 = unpack(var0_114.favor)

	getProxy(ApartmentProxy):RecordAccompanyTime()
	pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataAccompany(1, var0_114.ship_id, var0_114.performance_time, 0, var1_114 or arg0_114.artSceneInfo))

	local var8_114 = {}

	table.insert(var8_114, function(arg0_115)
		arg0_114:SetUI(arg0_115, "blank", "accompany")
	end)
	table.insert(var8_114, function(arg0_116)
		arg0_114.accompanyFavorCount = 0
		arg0_114.accompanyFavorTimer = Timer.New(function()
			arg0_114.accompanyFavorCount = arg0_114.accompanyFavorCount + 1
		end, var6_114, -1)

		arg0_114.accompanyFavorTimer:Start()

		arg0_114.accompanyPerformanceTimer = Timer.New(function()
			arg0_114.canTriggerAccompanyPerformance = true

			warning(arg0_114.canTriggerAccompanyPerformance)
		end, var0_114.performance_time, -1)

		arg0_114.accompanyPerformanceTimer:Start()
		arg0_114:PlayTimeline(var3_114, function(arg0_119, arg1_119)
			arg1_119()
			arg0_116()
		end)
	end)
	seriesAsync(var8_114, function()
		assert(arg0_114.accompanyFavorTimer)
		arg0_114.accompanyFavorTimer:Stop()

		arg0_114.accompanyFavorTimer = nil

		assert(arg0_114.accompanyPerformanceTimer)
		arg0_114.accompanyPerformanceTimer:Stop()

		arg0_114.accompanyPerformanceTimer = nil
		arg0_114.canTriggerAccompanyPerformance = nil

		local var0_120 = math.min(arg0_114.accompanyFavorCount, getProxy(ApartmentProxy):getStamina())

		if var0_120 > 0 then
			local var1_120 = var7_114[var0_120]

			warning(var1_120)
			arg0_114:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_114.apartment.configId, var1_120)
		end

		local var2_120 = 0
		local var3_120 = getProxy(ApartmentProxy):GetAccompanyTime()

		if var3_120 then
			var2_120 = pg.TimeMgr.GetInstance():GetServerTime() - var3_120
		end

		pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataAccompany(2, var0_114.ship_id, var0_114.performance_time, var2_120, var1_114 or arg0_114.artSceneInfo))
		arg0_114:SetUI(nil, "back", "back")
	end)
end

function var0_0.ExitAccompanyMode(arg0_121)
	existCall(arg0_121.timelineFinishCall)
end

function var0_0.EnterTouchMode(arg0_122)
	if arg0_122.ladyDict[arg0_122.apartment:GetConfigID()]:GetBlackboardValue("inTouching") then
		return
	end

	local var0_122 = arg0_122.ladyDict[arg0_122.apartment:GetConfigID()]
	local var1_122 = arg0_122.room:getApartmentZoneConfig(var0_122.ladyBaseZone, "touch_id", arg0_122.apartment:GetConfigID())

	arg0_122.touchConfig = pg.dorm3d_touch_data[var1_122]
	arg0_122.inTouchGame = arg0_122.touchConfig.heartbeat_enable > 0

	setActive(arg0_122.rtTouchGamePanel, arg0_122.inTouchGame)

	if arg0_122.inTouchGame then
		arg0_122.touchCount = 0
		arg0_122.touchLevel = 1
		arg0_122.lastCount = 0
		arg0_122.topCount = 0

		arg0_122:UpdateTouchGameDisplay()
		setSlider(arg0_122.rtTouchGamePanel:Find("slider"), 0, 100, arg0_122.touchCount >= 200 and 100 or arg0_122.touchCount % 100)
		quickPlayAnimation(arg0_122.rtTouchGamePanel, "anim_dorm3d_touch_in")
		quickPlayAnimation(arg0_122.rtTouchGamePanel:Find("slider/icon"), "anim_dorm3d_touch_icon")

		arg0_122.downTimer = Timer.New(function()
			local var0_123 = pg.dorm3d_set.reduce_interaction.key_value_int

			if arg0_122.touchLevel > 1 then
				var0_123 = pg.dorm3d_set.reduce_heartbeat.key_value_int
			end

			arg0_122:UpdateTouchCount(var0_123)
		end, 1, -1)

		arg0_122.downTimer:Start()
	end

	local var2_122 = {}

	table.insert(var2_122, function(arg0_124)
		var0_122:SetBlackboardValue("inTouching", true)
		arg0_122:emit(arg0_122.SHOW_BLOCK)
		arg0_122:SetUI(arg0_124, "blank")
	end)
	table.insert(var2_122, function(arg0_125)
		local var0_125 = arg0_122.touchConfig.ik_status[1]

		arg0_122:SwitchIKConfig(var0_122, var0_125)
		setActive(arg0_122.uiContianer:Find("ik/btn_back"), true)
		arg0_122:SetIKState(true, arg0_125)
	end)
	table.insert(var2_122, function(arg0_126)
		existCall(arg0_126)
	end)
	seriesAsync(var2_122, function()
		Shader.SetGlobalFloat("_ScreenClipOff", 0)
		arg0_122:emit(arg0_122.HIDE_BLOCK)
	end)
end

function var0_0.ExitTouchMode(arg0_128)
	local var0_128 = arg0_128.ladyDict[arg0_128.apartment:GetConfigID()]

	if not var0_128:GetBlackboardValue("inTouching") then
		return
	end

	local var1_128 = {}

	if arg0_128.inTouchGame then
		table.insert(var1_128, function(arg0_129)
			arg0_128:emit(arg0_128.SHOW_BLOCK)
			quickPlayAnimation(arg0_128.rtTouchGamePanel, "anim_dorm3d_touch_out")
			onDelayTick(arg0_129, 0.5)
		end)
		table.insert(var1_128, function(arg0_130)
			local var0_130 = 0

			for iter0_130, iter1_130 in ipairs(arg0_128.touchConfig.heartbeat_favor) do
				if iter1_130[1] > arg0_128.topCount then
					break
				else
					var0_130 = iter1_130[2]
				end
			end

			if var0_130 > 0 then
				arg0_128:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_128.apartment.configId, var0_130)
			end

			arg0_128.touchCount = nil
			arg0_128.touchLevel = nil
			arg0_128.topCount = nil

			if arg0_128.downTimer then
				arg0_128.downTimer:Stop()

				arg0_128.downTimer = nil
			end

			arg0_128.inTouchGame = false

			setActive(arg0_128.rtTouchGamePanel, false)
			Shader.SetGlobalFloat("_ScreenClipOff", 1)
			arg0_130()
		end)
	else
		table.insert(var1_128, function(arg0_131)
			arg0_128:emit(arg0_128.SHOW_BLOCK)

			local var0_131 = arg0_128.touchConfig.default_favor

			if var0_131 > 0 then
				arg0_128:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_128.apartment.configId, var0_131)
			end

			Shader.SetGlobalFloat("_ScreenClipOff", 1)
			arg0_131()
		end)
	end

	table.insert(var1_128, function(arg0_132)
		var0_128.ikConfig = {
			character_position = var0_128.ladyBaseZone,
			character_action = arg0_128.touchConfig.finish_action
		}

		arg0_128:SetIKState(false, arg0_132)
	end)
	table.insert(var1_128, function(arg0_133)
		var0_128.ikConfig = nil
		arg0_128.scene.blockIK = nil

		arg0_128:SetUI(arg0_133, "back")
	end)
	seriesAsync(var1_128, function()
		var0_128:SetBlackboardValue("inTouching", false)
		arg0_128:emit(arg0_128.HIDE_BLOCK)

		arg0_128.touchConfig = nil

		local var0_134 = arg0_128.touchExitCall

		arg0_128.touchExitCall = nil

		existCall(var0_134)
	end)
end

function var0_0.ChangeWalkScene(arg0_135, arg1_135, arg2_135)
	local var0_135 = arg0_135.ladyDict[arg0_135.apartment:GetConfigID()]

	seriesAsync({
		function(arg0_136)
			arg0_135:ChangeArtScene(arg1_135, arg0_136)
		end,
		function(arg0_137)
			var0_135:ChangeSubScene(arg1_135, arg0_137)
		end,
		function(arg0_138)
			arg0_135:emit(arg0_135.SHOW_BLOCK)

			if arg1_135 == arg0_135.sceneInfo then
				arg0_135:SetUI(arg0_138, "back")
			elseif arg0_135.uiState ~= "walk" then
				arg0_135:SetUI(arg0_138, "walk")
			else
				arg0_138()
			end
		end
	}, function()
		arg0_135:emit(arg0_135.HIDE_BLOCK)
		var0_135:SetBlackboardValue("inWalk", arg1_135 ~= arg0_135.sceneInfo)
		existCall(arg2_135)
	end)
end

function var0_0.EnterWalkMode(arg0_140)
	local var0_140 = arg0_140.apartment:GetConfigID()
	local var1_140 = arg0_140.ladyDict[var0_140]

	seriesAsync({
		function(arg0_141)
			arg0_140:emit(arg0_140.SHOW_BLOCK)
			arg0_140:HideCharacter(var0_140)
			var1_140:SetBlackboardValue("inWalk", true)
			arg0_140:SetUI(arg0_141, "walk")
		end,
		function(arg0_142)
			arg0_140:emit(arg0_140.HIDE_BLOCK)
			arg0_140:ChangeArtScene(arg0_140.walkInfo.scene .. "|" .. arg0_140.walkInfo.sceneRoot, arg0_142)
		end,
		function(arg0_143)
			arg0_140:LoadSubScene(arg0_140.walkInfo, arg0_143)
		end
	}, function()
		return
	end)
end

function var0_0.ExitWalkMode(arg0_145)
	local var0_145 = arg0_145.apartment:GetConfigID()
	local var1_145 = arg0_145.ladyDict[var0_145]

	seriesAsync({
		function(arg0_146)
			arg0_145:ChangeArtScene(arg0_145.walkLastSceneInfo, arg0_146)
		end,
		function(arg0_147)
			arg0_145:UnloadSubScene(arg0_145.walkInfo, arg0_147)
		end,
		function(arg0_148)
			arg0_145:emit(arg0_145.SHOW_BLOCK)
			arg0_145:SetUI(arg0_148, "back")
		end
	}, function()
		arg0_145:emit(arg0_145.HIDE_BLOCK)
		arg0_145:RevertCharacter(var0_145)
		var1_145:SetBlackboardValue("inWalk", false)

		local var0_149 = arg0_145.walkExitCall

		arg0_145.walkExitCall = nil
		arg0_145.walkLastSceneInfo = nil
		arg0_145.walkInfo = nil

		existCall(var0_149)
	end)
end

function var0_0.EnableMiniGameCutIn(arg0_150)
	if not arg0_150.tfCutIn then
		return
	end

	local var0_150 = arg0_150.rtExtraScreen:Find("MiniGameCutIn")

	setActive(var0_150, true)

	local var1_150 = GetOrAddComponent(var0_150:Find("bg/mask/cut_in"), "CameraRTUI")

	setActive(var1_150, true)
	pg.CameraRTMgr.GetInstance():Bind(var1_150, arg0_150.tfCutIn:Find("TestCamera"):GetComponent(typeof(Camera)))
	quickPlayAnimator(arg0_150.modelCutIn.lady, "Idle")
	quickPlayAnimator(arg0_150.modelCutIn.player, "Idle")
	setActive(arg0_150.tfCutIn, true)
end

function var0_0.DisableMiniGameCutIn(arg0_151)
	if not arg0_151.tfCutIn then
		return
	end

	local var0_151 = arg0_151.rtExtraScreen:Find("MiniGameCutIn")
	local var1_151 = GetOrAddComponent(var0_151:Find("bg/mask/cut_in"), "CameraRTUI")

	pg.CameraRTMgr.GetInstance():Clean(var1_151)
	setActive(var0_151, false)
	setActive(arg0_151.tfCutIn, false)
end

function var0_0.SwitchIKConfig(arg0_152, arg1_152, arg2_152)
	local var0_152 = pg.dorm3d_ik_status[arg2_152]

	if var0_152.skin_id ~= arg1_152.skinId then
		local var1_152 = pg.dorm3d_ik_status.get_id_list_by_base[var0_152.base]
		local var2_152 = _.detect(var1_152, function(arg0_153)
			return pg.dorm3d_ik_status[arg0_153].skin_id == arg1_152.skinId
		end)

		assert(var2_152, string.format("Missing Status Config By Skin: %s original Status: %s", arg1_152.skinId, arg2_152))

		var0_152 = pg.dorm3d_ik_status[var2_152]
	end

	arg1_152.ikConfig = var0_152
end

function var0_0.SetIKState(arg0_154, arg1_154, arg2_154)
	local var0_154 = arg0_154.ladyDict[arg0_154.apartment:GetConfigID()]
	local var1_154 = {}

	if arg1_154 then
		table.insert(var1_154, function(arg0_155)
			var0_154:SetBlackboardValue("inIK", true)
			arg0_154:emit(arg0_154.SHOW_BLOCK)

			local var0_155 = var0_154.ikConfig.camera_group

			setActive(arg0_154.uiContianer:Find("ik/Right/btn_camera"), #pg.dorm3d_ik_status.get_id_list_by_camera_group[var0_155] > 1)
			arg0_155()
		end)

		if arg0_154.uiState ~= "ik" then
			table.insert(var1_154, function(arg0_156)
				arg0_154:SetUI(arg0_156, "ik")
			end)
		end

		table.insert(var1_154, function(arg0_157)
			Shader.SetGlobalFloat("_ScreenClipOff", 0)
			arg0_154.SetIKStatus(var0_154, var0_154.ikConfig, arg0_157)
		end)
		table.insert(var1_154, function(arg0_158)
			arg0_154:emit(arg0_154.HIDE_BLOCK)
			arg0_158()
		end)
	else
		assert(arg0_154.uiState == "ik")
		table.insert(var1_154, function(arg0_159)
			arg0_154:emit(arg0_154.SHOW_BLOCK)
			Shader.SetGlobalFloat("_ScreenClipOff", 1)
			arg0_159()
		end)

		local var2_154 = var0_154.skinIdList

		if var0_154.skinId ~= var2_154[1] then
			table.insert(var1_154, function(arg0_160)
				local var0_160 = arg0_154.apartment:GetConfigID()

				arg0_154.SwitchCharacterSkin(var0_154, var0_160, var2_154[1], arg0_160)
			end)
		end

		table.insert(var1_154, function(arg0_161)
			warning(var0_154.ikConfig.character_action)
			var0_154:ExitIKStatus(var0_154.ikConfig, arg0_161)
			arg0_154.scene:ResetSceneItemAnimators()
		end)
		table.insert(var1_154, function(arg0_162)
			arg0_154:SetUI(arg0_162, "back")
		end)
		table.insert(var1_154, function(arg0_163)
			var0_154:SetBlackboardValue("inIK", false)
			arg0_154:emit(arg0_154.HIDE_BLOCK)
			arg0_163()
		end)
	end

	seriesAsync(var1_154, arg2_154)
end

function var0_0.TouchModeAction(arg0_164, arg1_164, arg2_164, ...)
	return switch(arg2_164, {
		function(arg0_165, arg1_165)
			return function(arg0_166)
				seriesAsync({
					function(arg0_167)
						arg0_164.RevertAllIKLayer(arg1_164, 0, arg0_167)
					end,
					function(arg0_168)
						if not arg1_165 or arg1_165 == "" then
							return arg0_168()
						end

						arg0_164:PlaySingleAction(arg1_165, arg0_168)
					end,
					function(arg0_169)
						arg0_164:SwitchIKConfig(arg1_164, arg0_165)
						arg0_164:SetIKState(true, arg0_169)
					end,
					arg0_166
				})
			end
		end,
		function()
			return function()
				if arg0_164.ikSpecialCall then
					local var0_171 = arg0_164.ikSpecialCall

					arg0_164.ikSpecialCall = nil

					existCall(var0_171)
				else
					arg0_164:ExitTouchMode()
				end
			end
		end,
		function(arg0_172, arg1_172)
			return function(arg0_173)
				arg0_164.RevertAllIKLayer(arg1_164, arg0_172, function()
					arg0_164:PlaySingleAction(arg1_172, arg0_173)
				end)
			end
		end,
		function(arg0_175, arg1_175, arg2_175)
			return function(arg0_176)
				seriesAsync({
					function(arg0_177)
						arg0_164.RevertAllIKLayer(arg1_164, arg0_175, arg0_177)
					end,
					function(arg0_178)
						arg0_164:DoTalk(arg1_175, arg0_178)
					end,
					function(arg0_179)
						if not arg2_175 or arg2_175 == 0 then
							return arg0_179()
						end

						arg0_164:SwitchIKConfig(arg1_164, arg2_175)
						arg0_164:SetIKState(true, arg0_179)
					end,
					arg0_176
				})
			end
		end,
		function(arg0_180, arg1_180, arg2_180, arg3_180)
			return function(arg0_181)
				arg0_164.RevertAllIKLayer(arg1_164, arg0_180, function()
					arg0_164.scene:PlaySceneItemAnim(arg2_180, arg3_180)
					arg0_164:PlaySingleAction(arg1_180, arg0_181)
				end)
			end
		end
	}, function()
		return function()
			return
		end
	end, ...)
end

function var0_0.OnTriggerIK(arg0_185, arg1_185)
	local var0_185 = arg0_185.ladyDict[arg0_185.apartment:GetConfigID()]

	if not var0_185.ikConfig then
		return
	end

	for iter0_185, iter1_185 in ipairs(var0_185.ikConfig.ik_id) do
		local var1_185, var2_185, var3_185 = unpack(iter1_185)

		if var1_185 == arg1_185 then
			arg0_185.scene.blockIK = true

			arg0_185:TouchModeAction(var0_185, unpack(var3_185))(function()
				arg0_185.scene.enableIKTip = true

				arg0_185:ResetIKTipTimer()

				arg0_185.scene.blockIK = nil
			end)

			return
		end
	end

	assert(false, string.format("Missing %s callback in status %s", arg1_185, var0_185.ikConfig.id))
end

function var0_0.OnTouchCharacterBody(arg0_187, arg1_187)
	local var0_187 = arg0_187.ladyDict[arg0_187.apartment:GetConfigID()]

	if not var0_187.ikConfig then
		return
	end

	for iter0_187, iter1_187 in ipairs(var0_187.ikConfig.touch_data) do
		local var1_187, var2_187, var3_187 = unpack(iter1_187)
		local var4_187 = pg.dorm3d_ik_touch[var1_187]

		if var4_187.body == arg1_187 then
			local var5_187 = var4_187.action_emote

			if #var5_187 > 0 then
				var0_187:PlayFaceAnim(var5_187)
			end

			local var6_187 = var4_187.vibrate

			if type(var6_187) == "table" and VibrateMgr.Instance:IsSupport() then
				local var7_187 = {}
				local var8_187 = {}
				local var9_187 = {}

				underscore.each(var6_187, function(arg0_188)
					table.insert(var7_187, arg0_188[1])
					table.insert(var8_187, arg0_188[2])
					table.insert(var9_187, 1)
				end)

				if PLATFORM == PLATFORM_ANDROID then
					VibrateMgr.Instance:VibrateWaveform(var7_187, var8_187)
				elseif PLATFORM == PLATFORM_ANDROID then
					VibrateMgr.Instance:VibrateWaveform(var7_187, var8_187, var9_187)
				end
			end

			arg0_187.scene.blockIK = true

			arg0_187:TouchModeAction(var0_187, unpack(var3_187))(function()
				arg0_187.scene.enableIKTip = true

				arg0_187:ResetIKTipTimer()

				arg0_187.scene.blockIK = nil
			end)

			return
		end
	end
end

function var0_0.UpdateTouchGameDisplay(arg0_190)
	setActive(arg0_190.rtTouchGamePanel:Find("effect_bg"), arg0_190.touchLevel == 2)
	setActive(arg0_190.rtTouchGamePanel:Find("slider/icon/beating"), arg0_190.touchLevel == 2)

	if arg0_190.touchLevel == 1 then
		quickPlayAnimation(arg0_190.rtTouchGamePanel, "anim_dorm3d_touch_change_out")
		quickPlayAnimation(arg0_190.rtTouchGamePanel:Find("slider/icon"), "anim_dorm3d_touch_icon")
	elseif arg0_190.touchLevel == 2 then
		quickPlayAnimation(arg0_190.rtTouchGamePanel, "anim_dorm3d_touch_change")
		quickPlayAnimation(arg0_190.rtTouchGamePanel:Find("slider/icon"), "anim_dorm3d_touch_icon_1")
		pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_heartbeat")
	end
end

function var0_0.UpdateTouchCount(arg0_191, arg1_191)
	if arg0_191.touchLevel > 1 then
		arg1_191 = math.min(0, arg1_191)
	end

	arg0_191.touchCount = math.clamp(arg0_191.touchCount + arg1_191, 0, 100)

	if arg0_191.sliderLT and LeanTween.isTweening(arg0_191.sliderLT) then
		LeanTween.cancel(arg0_191.sliderLT)

		arg0_191.sliderLT = nil
	end

	setSlider(arg0_191.rtTouchGamePanel:Find("slider"), 0, 100, arg0_191.touchCount)

	local var0_191

	if arg0_191.touchCount >= 100 then
		var0_191 = 2
	elseif arg0_191.touchCount <= 0 then
		var0_191 = 1
	end

	if var0_191 and var0_191 ~= arg0_191.touchLevel then
		if arg0_191.scene.blockIK then
			return
		end

		arg0_191.touchLevel = var0_191

		local var1_191 = arg0_191.touchConfig.ik_status[var0_191]

		if var1_191 then
			if var0_191 > 1 then
				arg0_191.touchCount = 200
			elseif var0_191 == 1 then
				arg0_191.touchCount = 0
			end

			local var2_191 = arg0_191.ladyDict[arg0_191.apartment:GetConfigID()]

			seriesAsync({
				function(arg0_192)
					arg0_191:ShowBlackScreen(true, arg0_192)
				end,
				function(arg0_193)
					arg0_191:SwitchIKConfig(var2_191, var1_191)
					arg0_191:SetIKState(true, arg0_193)

					if var0_191 > 1 and arg0_191.touchConfig.heartbeat_enter_anim ~= "" then
						var2_191:SwitchAnim(arg0_191.touchConfig.heartbeat_enter_anim)
					end
				end,
				function(arg0_194)
					arg0_191:ShowBlackScreen(false, arg0_194)
				end
			})
		end

		arg0_191:UpdateTouchCount(0)
		arg0_191:UpdateTouchGameDisplay()
	end

	arg0_191.topCount = math.max(arg0_191.topCount, arg0_191.touchCount)
end

function var0_0.DoTouch(arg0_195, arg1_195, arg2_195)
	if arg0_195.inTouchGame then
		switch(arg2_195, {
			function()
				arg0_195:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat.key_value_int)
			end,
			function()
				arg0_195:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat.key_value_int)
			end,
			function()
				arg0_195:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat.key_value_int)
			end,
			function()
				arg0_195:UpdateTouchCount(pg.dorm3d_set.rapport_heartbeat_trriger.key_value_int)
			end
		})
	end
end

function var0_0.DoTalk(arg0_200, arg1_200, arg2_200)
	while rawget(arg0_200, "class") ~= var0_0 do
		arg0_200 = getmetatable(arg0_200).__index
	end

	if arg0_200.apartment and arg0_200.ladyDict[arg0_200.apartment:GetConfigID()]:GetBlackboardValue("inTalking") then
		errorMsg("Talking block:" .. arg1_200)

		return
	end

	if not arg0_200.room:isPersonalRoom() then
		local var0_200 = pg.dorm3d_dialogue_group[arg1_200].char_id

		if arg0_200.apartment then
			assert(arg0_200.apartment:GetConfigID() == var0_200)
		else
			arg0_200:SetApartment(getProxy(ApartmentProxy):getApartment(var0_200))
		end
	end

	local var1_200 = arg0_200.ladyDict[arg0_200.apartment:GetConfigID()]

	if arg1_200 == 10010 and not arg0_200.apartment.talkDic[arg1_200] then
		arg0_200.firstTimelineTouch = true
		arg0_200.firstMoveGuide = true
	end

	local var2_200 = {}
	local var3_200 = arg0_200.ladyDict[arg0_200.apartment:GetConfigID()]

	if var3_200:GetBlackboardValue("inPending") then
		table.insert(var2_200, function(arg0_201)
			arg0_200:OutOfLazy(arg0_200.apartment:GetConfigID(), arg0_201)
		end)
	end

	local var4_200 = pg.dorm3d_dialogue_group[arg1_200]
	local var5_200 = var4_200.performance_type == 1
	local var6_200

	table.insert(var2_200, function(arg0_202)
		arg0_200:emit(arg0_200.SHOW_BLOCK)
		var3_200:SetBlackboardValue(var5_200 and "inPerformance" or "inTalking", true)
		arg0_200:emit(Dorm3dRoomMediator.DO_TALK, arg1_200, function(arg0_203)
			var6_200 = arg0_203

			arg0_202()
		end)
	end)
	table.insert(var2_200, function(arg0_204)
		pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataDialog(arg0_200.apartment.configId, arg0_200.apartment.level, arg1_200, var4_200.type, arg0_200.room:getZoneConfig(arg0_200.ladyDict[arg0_200.apartment:GetConfigID()].ladyBaseZone, "id"), var4_200.action_type, table.CastToString(var4_200.trigger_config), arg0_200.room:GetConfigID()))

		if pg.NewGuideMgr.GetInstance():IsBusy() then
			pg.NewGuideMgr.GetInstance():Pause()
		end

		arg0_200:SetUI(arg0_204, "blank")
	end)

	if var4_200.trigger_area and var4_200.trigger_area ~= "" then
		table.insert(var2_200, function(arg0_205)
			arg0_200:ShiftZone(var4_200.trigger_area, arg0_205)
		end)
	end

	if var4_200.performance_type == 0 then
		table.insert(var2_200, function(arg0_206)
			arg0_200:emit(arg0_200.HIDE_BLOCK)
			pg.NewStoryMgr.GetInstance():ForceManualPlay(var4_200.story, function()
				onDelayTick(arg0_206, 0.001)
			end, true)
		end)
	elseif var4_200.performance_type == 1 then
		table.insert(var2_200, function(arg0_208)
			arg0_200:emit(arg0_200.HIDE_BLOCK)
			arg0_200:PerformanceQueue(var4_200.story, arg0_208)
		end)
	else
		assert(false)
	end

	table.insert(var2_200, function(arg0_209)
		arg0_200:emit(arg0_200.SHOW_BLOCK)
		arg0_209()
	end)
	table.insert(var2_200, function(arg0_210)
		local var0_210 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(var4_200.story)

		if var0_210 then
			local var1_210 = "1"

			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataStory(var0_210, var1_210))
		end

		if var6_200 and #var6_200 > 0 then
			arg0_200:emit(Dorm3dRoomMediator.OPEN_DROP_LAYER, var6_200, arg0_210)
		else
			arg0_210()
		end
	end)
	table.insert(var2_200, function(arg0_211)
		if pg.NewGuideMgr.GetInstance():IsPause() then
			pg.NewGuideMgr.GetInstance():Resume()
		end

		arg0_200:emit(arg0_200.HIDE_BLOCK)
		var3_200:SetBlackboardValue(var5_200 and "inPerformance" or "inTalking", false)
		arg0_200:SetUI(arg0_211, "back")
	end)
	seriesAsync(var2_200, function()
		if arg2_200 then
			return arg2_200()
		else
			arg0_200:CheckQueue()
		end
	end)
end

function var0_0.DoTalkTouchOption(arg0_213, arg1_213, arg2_213, arg3_213)
	local var0_213 = arg0_213.rtExtraScreen:Find("TalkTouchOption")
	local var1_213
	local var2_213 = var0_213:Find("content")

	UIItemList.StaticAlign(var2_213, var2_213:Find("clickTpl"), #arg1_213.options, function(arg0_214, arg1_214, arg2_214)
		arg1_214 = arg1_214 + 1

		if arg0_214 == UIItemList.EventUpdate then
			local var0_214 = arg1_213.options[arg1_214]

			setAnchoredPosition(arg2_214, NewPos(unpack(var0_214.pos)))
			onButton(arg0_213, arg2_214, function()
				var1_213(var0_214.flag)
			end, SFX_CONFIRM)
			setActive(arg2_214, not table.contains(arg2_213, var0_214.flag))
		end
	end)
	setActive(var0_213, true)

	function var1_213(arg0_216)
		setActive(var0_213, false)
		arg3_213(arg0_216)
	end
end

function var0_0.DoTimelineOption(arg0_217, arg1_217, arg2_217)
	local var0_217 = arg0_217.rtTimelineScreen:Find("TimelineOption")
	local var1_217
	local var2_217 = var0_217:Find("content")

	UIItemList.StaticAlign(var2_217, var2_217:Find("clickTpl"), #arg1_217, function(arg0_218, arg1_218, arg2_218)
		arg1_218 = arg1_218 + 1

		if arg0_218 == UIItemList.EventUpdate then
			local var0_218 = arg1_217[arg1_218]

			setText(arg2_218:Find("Text"), var0_218.content)
			onButton(arg0_217, arg2_218, function()
				var1_217(arg1_218)
			end, SFX_CONFIRM)
		end
	end)
	setActive(var0_217, true)

	function var1_217(arg0_220)
		setActive(var0_217, false)
		arg2_217(arg0_220)
	end
end

function var0_0.DoTimelineTouch(arg0_221, arg1_221, arg2_221)
	local var0_221 = arg0_221.rtTimelineScreen:Find("TimelineTouch")
	local var1_221
	local var2_221 = var0_221:Find("content")

	UIItemList.StaticAlign(var2_221, var2_221:Find("clickTpl"), #arg1_221, function(arg0_222, arg1_222, arg2_222)
		arg1_222 = arg1_222 + 1

		if arg0_222 == UIItemList.EventUpdate then
			local var0_222 = arg1_221[arg1_222]

			setAnchoredPosition(arg2_222, NewPos(unpack(var0_222.pos)))
			onButton(arg0_221, arg2_222, function()
				var1_221(arg1_222)
			end, SFX_CONFIRM)

			if arg0_221.firstTimelineTouch then
				arg0_221.firstTimelineTouch = nil

				setActive(arg2_222:Find("finger"), true)
			end
		end
	end)
	setActive(var0_221, true)

	function var1_221(arg0_224)
		setActive(var0_221, false)
		arg2_221(arg0_224)
	end
end

function var0_0.DoShortWait(arg0_225, arg1_225)
	local var0_225 = arg0_225.ladyDict[arg1_225]
	local var1_225 = getProxy(ApartmentProxy):getApartment(arg1_225)
	local var2_225 = arg0_225.room:getApartmentZoneConfig(var0_225.ladyBaseZone, "special_action", arg1_225)
	local var3_225 = var2_225 and var2_225[math.random(#var2_225)] or nil

	if not var3_225 then
		return
	end

	var0_225:PlaySingleAction(var3_225)
end

function var0_0.OutOfLazy(arg0_226, arg1_226, arg2_226)
	local var0_226 = arg0_226.ladyDict[arg1_226]
	local var1_226 = {}

	if var0_226:GetBlackboardValue("inPending") then
		table.insert(var1_226, function(arg0_227)
			arg0_226.shiftLady = arg1_226

			arg0_226:ShiftZone(var0_226.ladyBaseZone, arg0_227)
		end)
	end

	seriesAsync(var1_226, arg2_226)
end

function var0_0.OutOfPending(arg0_228, arg1_228, arg2_228)
	assert(arg0_228.wakeUpTalkId)

	local var0_228 = arg0_228.wakeUpTalkId

	seriesAsync({
		function(arg0_229)
			arg0_228:SetUI(arg0_229, "blank")
		end,
		function(arg0_230)
			arg0_228.shiftLady = arg1_228

			arg0_228:ShiftZone(arg0_228.ladyBaseZone, arg0_230)
		end,
		function(arg0_231)
			arg0_228:DoTalk(var0_228, arg0_231)
		end
	}, function()
		arg0_228:SetUIStore(arg2_228, "back")
	end)
end

function var0_0.ChangeCanWatchState(arg0_233)
	local var0_233

	if arg0_233:GetBlackboardValue("inPending") then
		var0_233 = tobool(arg0_233:GetBlackboardValue("inDistance"))
	else
		local var1_233 = arg0_233:GetBlackboardValue("groupId")

		var0_233 = tobool(arg0_233.activeLady[var1_233] and pg.NodeCanvasMgr.GetInstance():GetBlackboradValue("canWatch", arg0_233.ladyBlackboard))
	end

	if not arg0_233.nowCanWatchState or arg0_233.nowCanWatchState ~= var0_233 then
		arg0_233.nowCanWatchState = var0_233

		arg0_233:ShowOrHideCanWatchMark(arg0_233.nowCanWatchState)
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

function var0_0.HandleGameNotification(arg0_234, arg1_234, arg2_234)
	local var0_234 = arg0_234.ladyDict[arg0_234.apartment:GetConfigID()]

	switch(arg1_234, {
		[EatFoodMediator.HIT_AREA] = function()
			local var0_235, var1_235 = unpack(var1_0[arg2_234.index])

			var0_234:PlaySingleAction(var0_235)

			if arg0_234.tfCutIn then
				quickPlayAnimator(arg0_234.modelCutIn.lady, var1_235)
				quickPlayAnimator(arg0_234.modelCutIn.player, var1_235)
			end
		end,
		[EatFoodMediator.RESULT] = function()
			if arg2_234.win then
				var0_234:PlaySingleAction("Face_XYX_victory")
				var0_234:PlaySingleAction("minigame_win")
			else
				var0_234:PlaySingleAction("Face_XYX_lose")
				var0_234:PlaySingleAction("minigame_lose")
			end

			setActive(arg0_234.rtExtraScreen:Find("MiniGameCutIn"), false)
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataMiniGame(2, arg2_234.score))
		end,
		[EatFoodMediator.LEAVE_GAME] = function()
			if arg2_234 == false then
				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataMiniGame(3))
			end
		end
	})
end

function var0_0.PerformanceQueue(arg0_238, arg1_238, arg2_238)
	local var0_238, var1_238 = pcall(function()
		return require("GameCfg.dorm." .. arg1_238)
	end)

	if not var0_238 then
		errorMsg("不存在表演ID对应的Lua:" .. arg1_238)
		existCall(arg2_238)

		return
	end

	warning(arg1_238)

	local var2_238 = {}

	table.insert(var2_238, function(arg0_240)
		arg0_238:SetUI(arg0_240, "blank")
	end)
	table.insertto(var2_238, underscore.map(var1_238, function(arg0_241)
		return switch(arg0_241.type, {
			function()
				return function(arg0_243)
					local var0_243 = unpack(arg0_241.params)

					arg0_238:DoTalk(var0_243, arg0_243, true)
				end
			end,
			function()
				return function(arg0_245)
					arg0_238.touchExitCall = arg0_245

					arg0_238:EnterTouchMode()
				end
			end,
			function()
				return function(arg0_247)
					arg0_238.ladyDict[arg0_238.apartment:GetConfigID()]:PlaySingleAction(arg0_241.name, arg0_247)
				end
			end,
			function()
				return function(arg0_249)
					arg0_238:emit(arg0_238.PLAY_EXPRESSION, arg0_241)
					arg0_249()
				end
			end,
			function()
				return function(arg0_251)
					arg0_238:ShiftZone(arg0_241.name, arg0_251)
				end
			end,
			function()
				return function(arg0_253)
					arg0_238.contextData.timeIndex = arg0_241.params[1]

					if arg0_238.artSceneInfo == arg0_238.sceneInfo then
						arg0_238:SwitchDayNight(arg0_238.contextData.timeIndex)
						onNextTick(function()
							arg0_238:RefreshSlots()
						end)
					end

					arg0_238:UpdateContactState()
					onNextTick(arg0_253)
				end
			end,
			function()
				return function(arg0_256)
					arg0_238:ActiveStateCamera(arg0_241.name, arg0_256)
				end
			end,
			function()
				return function(arg0_258)
					if arg0_241.name == "base" then
						arg0_238:ChangeArtScene(arg0_238.sceneInfo, arg0_258)
					else
						local var0_258 = arg0_241.params.scene
						local var1_258 = arg0_241.params.sceneRoot

						arg0_238:ChangeArtScene(var0_258 .. "|" .. var1_258, arg0_258)
					end
				end
			end,
			function()
				return function(arg0_260)
					local var0_260 = arg0_241.params.name

					if arg0_241.name == "load" then
						arg0_238.waitForTimeline = tobool(arg0_241.params.wait_timeline)

						arg0_238:LoadTimelineScene(var0_260, true, arg0_260)
					elseif arg0_241.name == "unload" then
						arg0_238:UnloadTimelineScene(var0_260, true, arg0_260)
					else
						assert(false)
					end
				end
			end,
			function()
				return function(arg0_262)
					setActive(arg0_238.uiContianer:Find("walk/btn_back"), false)

					if arg0_241.name == "change" then
						local var0_262 = arg0_241.params.scene
						local var1_262 = arg0_241.params.sceneRoot

						arg0_238.walkBornPoint = arg0_241.params.point or "Default"

						arg0_238:ChangeWalkScene(var0_262 .. "|" .. var1_262, arg0_262)
					elseif arg0_241.name == "back" then
						arg0_238.walkBornPoint = nil

						arg0_238:ChangeWalkScene(arg0_238.sceneInfo, arg0_262)
					elseif arg0_241.name == "set" then
						local function var2_262()
							local var0_263 = arg0_262

							arg0_262 = nil

							return existCall(var0_263)
						end

						for iter0_262, iter1_262 in pairs(arg0_241.params) do
							switch(iter0_262, {
								back_button_trigger = function(arg0_264)
									onButton(arg0_238, arg0_238.uiContianer:Find("walk/btn_back"), var2_262, "ui-dorm_back_v2")
									setActive(arg0_238.uiContianer:Find("walk/btn_back"), IsUnityEditor and arg0_264)
								end,
								near_trigger = function(arg0_265)
									if arg0_265 == true then
										arg0_265 = 1.5
									end

									if arg0_265 then
										function arg0_238.walkNearCallback(arg0_266)
											if arg0_266 < arg0_265 then
												arg0_238.walkNearCallback = nil

												var2_262()
											end
										end
									else
										arg0_238.walkNearCallback = nil
									end
								end
							}, nil, iter1_262)
						end

						if arg0_238.firstMoveGuide then
							setActive(arg0_238.povLayer:Find("Guide"), arg0_238.firstMoveGuide)

							arg0_238.firstMoveGuide = nil
						end
					else
						assert(false)
					end
				end
			end,
			function()
				return function(arg0_268)
					if arg0_241.name == "set" then
						arg0_238:SwitchIKConfig(arg0_238, arg0_241.params.state)
						setActive(arg0_238.uiContianer:Find("ik/btn_back"), not arg0_241.params.hide_back)

						arg0_238.ikSpecialCall = arg0_268

						arg0_238:SetIKState(true)
					elseif arg0_241.name == "back" then
						local var0_268 = arg0_238.ladyDict[arg0_238.apartment:GetConfigID()]

						var0_268.ikConfig = arg0_241.params

						arg0_238:SetIKState(false, function()
							var0_268.ikConfig = nil

							existCall(arg0_268)
						end)
					else
						assert(false)
					end
				end
			end,
			function()
				return function(arg0_271)
					arg0_238.blackSceneInfo = setmetatable(arg0_241.params or {}, {
						__index = {
							color = "#000000",
							time = 0.3,
							delay = arg0_241.name == "show" and 0 or 0.5
						}
					})

					if arg0_241.name == "show" then
						arg0_238:ShowBlackScreen(true, arg0_271)
					elseif arg0_241.name == "hide" then
						arg0_238:ShowBlackScreen(false, arg0_271)
					else
						assert(false)
					end

					arg0_238.blackSceneInfo = nil
				end
			end
		})
	end))
	table.insert(var2_238, function(arg0_272)
		arg0_238:SetUI(arg0_272, "back")
	end)
	seriesAsync(var2_238, arg2_238)
end

function var0_0.TriggerContact(arg0_273, arg1_273)
	arg0_273:emit(Dorm3dRoomMediator.COLLECTION_ITEM, {
		itemId = arg1_273,
		roomId = arg0_273.room:GetConfigID(),
		groupId = arg0_273.room:isPersonalRoom() and arg0_273.apartment:GetConfigID() or 0
	})
end

function var0_0.UpdateContactState(arg0_274)
	arg0_274:SetContactStateDic(arg0_274.room:getTriggerableCollectItemDic(arg0_274.contextData.timeIndex))
end

function var0_0.UpdateFavorDisplay(arg0_275)
	local var0_275, var1_275 = getProxy(ApartmentProxy):getStamina()

	setText(arg0_275.rtStaminaDisplay:Find("Text"), string.format("%d/%d", var0_275, var1_275))
	setActive(arg0_275.rtStaminaDisplay, false)

	if arg0_275.apartment then
		setText(arg0_275.rtFavorLevel:Find("rank/Text"), arg0_275.apartment.level)

		local var2_275, var3_275 = arg0_275.apartment:getFavor()

		setText(arg0_275.rtFavorLevel:Find("Text"), string.format("<color=#ff6698>%d</color>/%d", var2_275, var3_275))
	end

	setActive(arg0_275.rtFavorLevel:Find("red"), Dorm3dLevelLayer.IsShowRed())
end

function var0_0.UpdateBtnState(arg0_276)
	local var0_276 = not arg0_276.room:isPersonalRoom() or arg0_276:CheckSystemOpen("Furniture")
	local var1_276 = Dorm3dFurniture.IsTimelimitShopTip(arg0_276.room:GetConfigID())

	setActive(arg0_276.uiContianer:Find("base/left/btn_furniture/tipTimelimit"), var0_276 and var1_276)

	local var2_276 = Dorm3dFurniture.NeedViewTip(arg0_276.room:GetConfigID())

	setActive(arg0_276.uiContianer:Find("base/left/btn_furniture/tip"), var0_276 and not var1_276 and var2_276)
	setActive(arg0_276.uiContianer:Find("base/btn_back/main"), underscore(getProxy(ApartmentProxy):getRawData()):chain():values():filter(function(arg0_277)
		return tobool(arg0_277)
	end):any(function(arg0_278)
		return #arg0_278:getSpecialTalking() > 0 or arg0_278:getIconTip() == "main"
	end):value())
	setActive(arg0_276.uiContianer:Find("base/left/btn_collection/tip"), PlayerPrefs.GetInt("apartment_collection_item", 0) > 0 or PlayerPrefs.GetInt("apartment_collection_recall", 0) > 0)
end

function var0_0.AddUnlockDisplay(arg0_279, arg1_279)
	table.insert(arg0_279.unlockList, arg1_279)

	if not isActive(arg0_279.rtFavorUp) then
		setText(arg0_279.rtFavorUp:Find("Text"), table.remove(arg0_279.unlockList, 1))
		setActive(arg0_279.rtFavorUp, true)
	end
end

function var0_0.PopFavorTrigger(arg0_280, arg1_280)
	local var0_280 = arg1_280.triggerId
	local var1_280 = arg1_280.delta
	local var2_280 = arg1_280.cost
	local var3_280 = arg1_280.apartment
	local var4_280 = pg.dorm3d_favor_trigger[var0_280]

	if var4_280.is_repeat == 0 then
		if var0_280 == getDorm3dGameset("drom3d_favir_trigger_onwer")[1] then
			arg0_280:AddUnlockDisplay(i18n("dorm3d_own_favor"))
		elseif var0_280 == getDorm3dGameset("drom3d_favir_trigger_propose")[1] then
			arg0_280:AddUnlockDisplay(i18n("dorm3d_pledge_favor"))
		else
			arg0_280:AddUnlockDisplay(string.format("unknow favor trigger:%d unlock", var0_280))
		end
	elseif arg1_280.delta > 0 then
		local var5_280, var6_280 = var3_280:getFavor()
		local var7_280 = var5_280 + var1_280

		setText(arg0_280.rtFavorUpDaily:Find("bg/Text"), string.format("<size=48>+%d</size>", var1_280))
		setSlider(arg0_280.rtFavorUpDaily:Find("bg/slider"), 0, var6_280, var5_280)
		setAnchoredPosition(arg0_280.rtFavorUpDaily:Find("bg"), arg1_280.isGift and NewPos(-354, 223) or NewPos(-208, 105))

		local var8_280 = {}
		local var9_280 = arg0_280.rtFavorUpDaily:Find("bg/effect")

		eachChild(var9_280, function(arg0_281)
			setActive(arg0_281, false)
		end)

		local var10_280

		if var4_280.effect and var4_280.effect ~= "" then
			var10_280 = var9_280:Find(var4_280.effect .. "(Clone)")

			if not var10_280 then
				table.insert(var8_280, function(arg0_282)
					LoadAndInstantiateAsync("Dorm3D/Effect/Prefab/ExpressionUI", "uifx_dorm3d_yinfu01", function(arg0_283)
						setParent(arg0_283, var9_280)

						var10_280 = tf(arg0_283)

						arg0_282()
					end)
				end)
			else
				setActive(var10_280, true)
			end
		end

		local var11_280 = arg0_280.rtFavorUpDaily:GetComponent("DftAniEvent")

		var11_280:SetTriggerEvent(function(arg0_284)
			local var0_284 = GetComponent(arg0_280.rtFavorUpDaily:Find("bg/slider"), typeof(Slider))

			LeanTween.value(var5_280, var7_280, 0.5):setOnUpdate(System.Action_float(function(arg0_285)
				var0_284.value = arg0_285
			end)):setEase(LeanTweenType.easeInOutQuad):setDelay(0.165):setOnComplete(System.Action(function()
				LeanTween.delayedCall(0.165, System.Action(function()
					if arg0_280.exited then
						return
					end

					quickPlayAnimator(arg0_280.rtFavorUpDaily, "favor_out")
				end))
			end))
			pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_progaress_bar")
		end)
		var11_280:SetEndEvent(function(arg0_288)
			setActive(arg0_280.rtFavorUpDaily, false)
		end)
		seriesAsync(var8_280, function()
			local var0_289 = arg0_280.ladyDict[var3_280:GetConfigID()]

			setLocalPosition(arg0_280.rtFavorUpDaily, arg0_280:GetLocalPosition(arg0_280:GetScreenPosition(var0_289.ladyHeadCenter.position), arg0_280.rtFavorUpDaily.parent))
			setActive(arg0_280.rtFavorUpDaily, true)
			SetCompomentEnabled(arg0_280.rtFavorUpDaily, typeof(Animator), true)
			quickPlayAnimator(arg0_280.rtFavorUpDaily, "favor_open")

			if var2_280 > 0 then
				local var1_289, var2_289 = getProxy(ApartmentProxy):getStamina()

				setText(arg0_280.rtStaminaPop:Find("Text/Text (1)"), "-" .. var2_280)
				setText(arg0_280.rtStaminaPop:Find("Text"), string.format("%d/%d", var1_289 + var2_280, var2_289))
				setActive(arg0_280.rtStaminaPop, true)
			end
		end)
	end
end

function var0_0.PopFavorLevelUp(arg0_290, arg1_290, arg2_290, arg3_290)
	arg0_290.isLock = true

	LeanTween.delayedCall(0.33, System.Action(function()
		arg0_290.isLock = false
	end))

	local var0_290 = math.floor(arg1_290.level / 10)
	local var1_290 = math.fmod(arg1_290.level, 10)

	GetImageSpriteFromAtlasAsync("ui/favor_atlas", var1_290, arg0_290.rtLevelUpWindow:Find("panel/bg/item1/mark/level/digit2"))
	GetImageSpriteFromAtlasAsync("ui/favor_atlas", var0_290, arg0_290.rtLevelUpWindow:Find("panel/bg/item1/mark/level/digit1"))
	setActive(arg0_290.rtLevelUpWindow:Find("panel/bg/item1/mark/level/digit1"), var0_290 > 0)

	local var2_290
	local var3_290

	arg0_290.clientAward, var3_290 = Dorm3dIconHelper.SplitStory(arg1_290:getFavorConfig("levelup_client_item", arg1_290.level))
	arg0_290.serverAward = arg2_290

	local var4_290 = arg0_290.rtLevelUpWindow:Find("panel/info/content/itemContent")

	if not arg0_290.levelItemList then
		arg0_290.levelItemList = UIItemList.New(var4_290, var4_290:Find("tpl"))

		arg0_290.levelItemList:make(function(arg0_292, arg1_292, arg2_292)
			local var0_292 = arg1_292 + 1

			if arg0_292 == UIItemList.EventUpdate then
				if arg1_292 < #arg0_290.serverAward then
					updateDorm3dIcon(arg2_292, arg0_290.serverAward[var0_292])
					onButton(arg0_290, arg2_292, function()
						arg0_290:emit(BaseUI.ON_NEW_DROP, {
							drop = arg0_290.serverAward[var0_292]
						})
					end, SFX_PANEL)
				else
					Dorm3dIconHelper.UpdateDorm3dIcon(arg2_292, arg0_290.clientAward[var0_292 - #arg0_290.serverAward])
					onButton(arg0_290, arg2_292, function()
						arg0_290:emit(Dorm3dRoomMediator.ON_DROP_CLIENT, {
							data = arg0_290.clientAward[var0_292 - #arg0_290.serverAward]
						})
					end, SFX_PANEL)
				end
			end
		end)
	end

	arg0_290.levelItemList:align(#arg0_290.serverAward + #arg0_290.clientAward)
	setActive(arg0_290.rtLevelUpWindow, true)
	pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_upgrade")
	pg.UIMgr.GetInstance():OverlayPanel(arg0_290.rtLevelUpWindow, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_DORM3D
	})

	function arg0_290.levelUpCallback()
		arg0_290.levelUpCallback = nil

		if var3_290 then
			arg0_290:PopNewStoryTip(var3_290)
		end

		existCall(arg3_290)
	end
end

function var0_0.PopNewStoryTip(arg0_296, arg1_296, arg2_296)
	local var0_296 = arg0_296.uiContianer:Find("base/top/story_tip")

	setActive(var0_296, true)
	LeanTween.delayedCall(1, System.Action(function()
		setActive(var0_296, false)
	end))
	setText(var0_296:Find("Text"), i18n("dorm3d_story_unlock_tip", pg.dorm3d_recall[arg1_296[2]].name))
	existCall(arg2_296)
end

function var0_0.UpdateZoneList(arg0_298)
	local var0_298

	if arg0_298.room:isPersonalRoom() then
		var0_298 = arg0_298.ladyDict[arg0_298.apartment:GetConfigID()].ladyBaseZone
	else
		var0_298 = arg0_298:GetAttachedFurnitureName()
	end

	for iter0_298, iter1_298 in ipairs(arg0_298.zoneDatas) do
		if iter1_298:GetWatchCameraName() == var0_298 then
			setText(arg0_298.btnZone:Find("Text"), iter1_298:GetName())
			setTextColor(arg0_298.rtZoneList:GetChild(iter0_298 - 1):Find("Name"), Color.NewHex("5CCAFF"))
		else
			setTextColor(arg0_298.rtZoneList:GetChild(iter0_298 - 1):Find("Name"), Color.NewHex("FFFFFF99"))
		end
	end
end

function var0_0.TalkingEventHandle(arg0_299, arg1_299)
	local var0_299 = {}
	local var1_299 = {}
	local var2_299 = arg1_299.data

	if var2_299.op_list then
		for iter0_299, iter1_299 in ipairs(var2_299.op_list) do
			table.insert(var0_299, function(arg0_300)
				local function var0_300()
					local var0_301 = arg0_300

					arg0_300 = nil

					return existCall(var0_301)
				end

				switch(iter1_299.type, {
					action = function()
						arg0_299.ladyDict[arg0_299.apartment:GetConfigID()]:PlaySingleAction(iter1_299.name, var0_300)
					end,
					item_action = function()
						arg0_299.scene:PlaySceneItemAnim(iter1_299.id, iter1_299.name)
						var0_300()
					end,
					timeline = function()
						if arg0_299.inTouchGame then
							setActive(arg0_299.rtTouchGamePanel, false)
						end

						arg0_299:PlayTimeline(iter1_299, function(arg0_305, arg1_305)
							setActive(arg0_299.rtTouchGamePanel, arg0_299.inTouchGame)

							var1_299.notifiCallback = arg1_305

							var0_300()
						end)
					end,
					clickOption = function()
						arg0_299:DoTalkTouchOption(iter1_299, arg1_299.flags, function(arg0_307)
							var1_299.optionIndex = arg0_307

							var0_300()
						end)
					end,
					wait = function()
						arg0_299.LTs = arg0_299.LTs or {}

						table.insert(arg0_299.LTs, LeanTween.delayedCall(iter1_299.time, System.Action(var0_300)).uniqueId)
					end,
					expression = function()
						arg0_299:emit(arg0_299.PLAY_EXPRESSION, iter1_299)
						var0_300()
					end
				}, function()
					assert(false, "op type error:", iter1_299.type)
				end)

				if iter1_299.skip then
					var0_300()
				end
			end)
		end
	end

	seriesAsync(var0_299, function()
		if arg1_299.callbackData then
			arg0_299:emit(Dorm3dRoomMediator.TALKING_EVENT_FINISH, arg1_299.callbackData.name, var1_299)
		end
	end)
end

function var0_0.CheckQueue(arg0_312)
	if arg0_312.inGuide or arg0_312.uiState ~= "base" then
		return
	end

	if arg0_312.room:GetConfigID() == 1 and arg0_312:CheckGuide() then
		-- block empty
	elseif arg0_312.room:isPersonalRoom() and arg0_312:CheckLevelUp() then
		-- block empty
	elseif arg0_312.apartment and arg0_312:CheckEnterDeal() then
		-- block empty
	elseif arg0_312.apartment and arg0_312:CheckActiveTalk() then
		-- block empty
	elseif arg0_312.apartment then
		arg0_312:CheckFavorTrigger()
	end

	arg0_312.contextData.hasEnterCheck = true
end

function var0_0.didEnterCheck(arg0_313)
	local var0_313

	if arg0_313.contextData.specialId then
		var0_313 = arg0_313.contextData.specialId
		arg0_313.contextData.specialId = nil

		arg0_313:DoTalk(var0_313, function()
			arg0_313:closeView()
		end)
	elseif not arg0_313.contextData.hasEnterCheck and arg0_313.apartment then
		for iter0_313, iter1_313 in ipairs(arg0_313.apartment:getForceEnterTalking(arg0_313.room:GetConfigID())) do
			var0_313 = iter1_313

			arg0_313:DoTalk(iter1_313)

			break
		end
	end

	if var0_313 and pg.dorm3d_dialogue_group[var0_313].extend_loading > 0 then
		arg0_313.contextData.hasEnterCheck = true

		pg.SceneAnimMgr.GetInstance():RegisterDormNextCall(function()
			arg0_313:FinishEnterResume()
		end)
	else
		if arg0_313.apartment and arg0_313.contextData.pendingDic[arg0_313.apartment:GetConfigID()] then
			arg0_313.contextData.hasEnterCheck = true
		end

		for iter2_313, iter3_313 in pairs(arg0_313.contextData.pendingDic) do
			arg0_313.ladyDict[iter2_313]:SetInPending(iter3_313)
		end

		arg0_313.contextData.pendingDic = {}

		arg0_313:FinishEnterResume()
		arg0_313:CheckQueue()
	end
end

function var0_0.CheckGuide(arg0_316)
	if arg0_316.ladyDict[arg0_316.apartment:GetConfigID()]:GetBlackboardValue("inPending") then
		return
	end

	for iter0_316, iter1_316 in ipairs({
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
				return arg0_316:CheckSystemOpen("Furniture")
			end
		},
		{
			name = "DORM3D_GUIDE_07",
			active = function()
				return arg0_316:CheckSystemOpen("DayNight")
			end
		}
	}) do
		if not pg.NewStoryMgr.GetInstance():IsPlayed(iter1_316.name) and iter1_316.active() then
			arg0_316:SetAllBlackbloardValue("inGuide", true)

			local function var0_316()
				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(2, pg.NewStoryMgr.GetInstance():StoryName2StoryId(iter1_316.name)))
				arg0_316:SetAllBlackbloardValue("inGuide", false)
			end

			pg.m02:sendNotification(GAME.STORY_UPDATE, {
				storyId = iter1_316.name
			})
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(1, pg.NewStoryMgr.GetInstance():StoryName2StoryId(iter1_316.name)))
			pg.NewGuideMgr.GetInstance():Play(iter1_316.name, nil, var0_316, var0_316)

			return true
		end
	end

	return false
end

function var0_0.CheckFavorTrigger(arg0_322)
	for iter0_322, iter1_322 in ipairs({
		{
			triggerId = getDorm3dGameset("drom3d_favir_trigger_onwer")[1],
			active = function()
				local var0_323 = getProxy(CollectionProxy):getShipGroup(arg0_322.apartment.configId)

				return tobool(var0_323)
			end
		},
		{
			triggerId = getDorm3dGameset("drom3d_favir_trigger_propose")[1],
			active = function()
				local var0_324 = getProxy(CollectionProxy):getShipGroup(arg0_322.apartment.configId)

				return var0_324 and var0_324.married > 0
			end
		}
	}) do
		if arg0_322.apartment.triggerCountDic[iter1_322.triggerId] == 0 and iter1_322.active() then
			arg0_322:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_322.apartment.configId, iter1_322.triggerId)
		end
	end
end

function var0_0.CheckEnterDeal(arg0_325)
	if arg0_325.contextData.hasEnterCheck then
		return false
	end

	local var0_325 = arg0_325.apartment:GetConfigID()
	local var1_325 = "dorm3d_enter_count_" .. var0_325
	local var2_325 = pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d")

	if PlayerPrefs.GetString("dorm3d_enter_count_day") ~= var2_325 then
		PlayerPrefs.SetString("dorm3d_enter_count_day", var2_325)
		PlayerPrefs.SetInt(var1_325, 1)
	else
		PlayerPrefs.SetInt(var1_325, PlayerPrefs.GetInt(var1_325, 0) + 1)
	end

	local var3_325 = arg0_325.apartment:getEnterTalking(arg0_325.room:GetConfigID())

	PlayerPrefs.SetString("DORM3D_DAILY_ENTER", pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d"))

	if #var3_325 > 0 then
		arg0_325:DoTalk(var3_325[math.random(#var3_325)])

		return true
	end
end

function var0_0.CheckActiveTalk(arg0_326)
	local var0_326 = arg0_326.ladyDict[arg0_326.apartment:GetConfigID()]

	if var0_326:GetBlackboardValue("inPending") then
		return false
	end

	local var1_326 = arg0_326.apartment:getZoneTalking(arg0_326.room:GetConfigID(), var0_326.ladyBaseZone)

	if #var1_326 > 0 then
		arg0_326:DoTalk(var1_326[1])

		return true
	else
		return false
	end
end

function var0_0.CheckDistanceTalk(arg0_327, arg1_327, arg2_327)
	local var0_327 = arg0_327.ladyDict[arg1_327].ladyBaseZone
	local var1_327 = getProxy(ApartmentProxy):getApartment(arg1_327)

	for iter0_327, iter1_327 in ipairs(var1_327:getDistanceTalking(arg0_327.room:GetConfigID(), var0_327)) do
		arg0_327:DoTalk(iter1_327)

		return
	end
end

function var0_0.CheckSystemOpen(arg0_328, arg1_328)
	if arg0_328.room:isPersonalRoom() then
		return switch(arg1_328, {
			Talk = function()
				local var0_329 = 1

				return var0_329 <= arg0_328.apartment.level, i18n("apartment_level_unenough", var0_329)
			end,
			Touch = function()
				local var0_330 = getDorm3dGameset("drom3d_touch_dialogue")[1]

				return var0_330 <= arg0_328.apartment.level, i18n("apartment_level_unenough", var0_330)
			end,
			Gift = function()
				local var0_331 = getDorm3dGameset("drom3d_gift_dialogue")[1]

				return var0_331 <= arg0_328.apartment.level, i18n("apartment_level_unenough", var0_331)
			end,
			Volleyball = function()
				return false
			end,
			Photo = function()
				local var0_333 = getDorm3dGameset("drom3d_photograph_unlock")[1]

				return var0_333 <= arg0_328.apartment.level, i18n("apartment_level_unenough", var0_333)
			end,
			Collection = function()
				local var0_334 = getDorm3dGameset("drom3d_recall_unlock")[1]

				return var0_334 <= arg0_328.apartment.level, i18n("apartment_level_unenough", var0_334)
			end,
			Furniture = function()
				local var0_335 = getDorm3dGameset("drom3d_furniture_unlock")[1]

				return var0_335 <= arg0_328.apartment.level, i18n("apartment_level_unenough", var0_335)
			end,
			DayNight = function()
				local var0_336 = getDorm3dGameset("drom3d_time_unlock")[1]

				return var0_336 <= arg0_328.apartment.level, i18n("apartment_level_unenough", var0_336)
			end,
			Accompany = function()
				local var0_337 = 1

				return var0_337 <= arg0_328.apartment.level, i18n("apartment_level_unenough", var0_337)
			end,
			MiniGame = function()
				local var0_338 = 1

				return var0_338 <= arg0_328.apartment.level, i18n("apartment_level_unenough", var0_338)
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
		return switch(arg1_328, {
			Gift = function()
				return false
			end,
			Volleyball = function()
				return arg0_328.room:GetConfigID() == 4
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

function var0_0.CheckLevelUp(arg0_350)
	if arg0_350.apartment:canLevelUp() then
		arg0_350:emit(Dorm3dRoomMediator.FAVOR_LEVEL_UP, arg0_350.apartment.configId)

		return true
	end

	return false
end

function var0_0.GetIKTipsRootTF(arg0_351)
	return arg0_351.ikTipsRoot
end

function var0_0.GetIKHandTF(arg0_352)
	return arg0_352.ikHand
end

function var0_0.CycleIKCameraGroup(arg0_353)
	local var0_353 = arg0_353.ladyDict[arg0_353.apartment:GetConfigID()]

	assert(var0_353:GetBlackboardValue("inIK"))
	seriesAsync({
		function(arg0_354)
			arg0_353.RevertIKLayer(var0_353, 0, arg0_354)
		end,
		function(arg0_355)
			local var0_355 = var0_353.ikConfig
			local var1_355 = var0_355.camera_group
			local var2_355 = pg.dorm3d_ik_status.get_id_list_by_camera_group[var1_355]
			local var3_355 = var2_355[table.indexof(var2_355, var0_355.id) % #var2_355 + 1]

			arg0_353:SwitchIKConfig(var0_353, var3_355)
			arg0_353:SetIKState(true)
		end
	})
end

function var0_0.TempHideUI(arg0_356, arg1_356, arg2_356)
	local var0_356 = defaultValue(arg0_356.hideCount, 0)

	arg0_356.hideCount = var0_356 + (arg1_356 and 1 or -1)

	assert(arg0_356.hideCount >= 0)

	if arg0_356.hideCount * var0_356 > 0 then
		return existCall(arg2_356)
	elseif arg0_356.hideCount > 0 then
		arg0_356:SetUI(arg2_356, "blank")
	else
		arg0_356:SetUI(arg2_356, "back")
	end
end

function var0_0.onBackPressed(arg0_357)
	if arg0_357.exited or arg0_357.retainCount > 0 then
		-- block empty
	elseif isActive(arg0_357.rtLevelUpWindow) then
		triggerButton(arg0_357.rtLevelUpWindow:Find("bg"))
	elseif arg0_357.uiState ~= "base" then
		-- block empty
	else
		arg0_357:closeView()
	end
end

function var0_0.willExit(arg0_358)
	if arg0_358.downTimer then
		arg0_358.downTimer:Stop()

		arg0_358.downTimer = nil
	end

	if arg0_358.LTs then
		underscore.map(arg0_358.LTs, function(arg0_359)
			LeanTween.cancel(arg0_359)
		end)

		arg0_358.LTs = nil
	end

	if arg0_358.sliderLT then
		LeanTween.cancel(arg0_358.sliderLT)

		arg0_358.sliderLT = nil
	end

	for iter0_358, iter1_358 in pairs(arg0_358.ladyDict) do
		iter1_358.wakeUpTalkId = nil
	end

	if arg0_358.accompanyFavorTimer then
		arg0_358.accompanyFavorTimer:Stop()

		arg0_358.accompanyFavorTimer = nil
	end

	if arg0_358.accompanyPerformanceTimer then
		arg0_358.accompanyPerformanceTimer:Stop()

		arg0_358.accompanyPerformanceTimer = nil
	end

	arg0_358.canTriggerAccompanyPerformance = nil

	var0_0.super.willExit(arg0_358)
end

return var0_0
