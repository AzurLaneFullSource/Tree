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
	arg0_4.uiStack = {}
	arg0_4.uiStore = {}
end

function var0_0.BindEvent(arg0_74)
	var0_0.super.BindEvent(arg0_74)
	arg0_74:bind(arg0_74.CLICK_CHARACTER, function(arg0_75, arg1_75)
		if arg0_74.uiState ~= "base" or not arg0_74.ladyDict[arg1_75].nowCanWatchState then
			return
		end

		local var0_75 = {}
		local var1_75 = arg0_74.ladyDict[arg1_75]

		if var1_75:GetBlackboardValue("inPending") then
			table.insert(var0_75, function(arg0_76)
				var1_75:OutOfPending(arg1_75, arg0_76)
			end)
		else
			table.insert(var0_75, function(arg0_77)
				arg0_74:OutOfLazy(arg1_75, arg0_77)
			end)
		end

		seriesAsync(var0_75, function()
			if not arg0_74.room:isPersonalRoom() then
				arg0_74:SetApartment(getProxy(ApartmentProxy):getApartment(arg1_75))
			end

			arg0_74:EnterWatchMode()
		end)
		pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_touch_v1")
	end)
	arg0_74:bind(arg0_74.CLICK_CONTACT, function(arg0_79, arg1_79)
		arg0_74:TriggerContact(arg1_79)
	end)
	arg0_74:bind(arg0_74.DISTANCE_TRIGGER, function(arg0_80, arg1_80, arg2_80)
		if arg0_74.uiState == "base" then
			arg0_74:CheckDistanceTalk(arg1_80, arg2_80)
		end
	end)
	arg0_74:bind(arg0_74.WALK_DISTANCE_TRIGGER, function(arg0_81, arg1_81, arg2_81)
		if arg0_74.apartment and arg0_74.apartment:GetConfigID() == arg1_81 then
			existCall(arg0_74.walkNearCallback, arg2_81)
		end
	end)
	arg0_74:bind(arg0_74.CHANGE_WATCH, function(arg0_82, arg1_82)
		arg0_74.ladyDict[arg1_82]:ChangeCanWatchState()
	end)
	arg0_74:bind(arg0_74.ON_TOUCH_CHARACTER, function(arg0_83, arg1_83)
		if not arg0_74.ladyDict[arg0_74.apartment:GetConfigID()]:GetBlackboardValue("inIK") then
			return
		end

		arg0_74:OnTouchCharacterBody(arg1_83)
	end)
	arg0_74:bind(arg0_74.ON_IK_STATUS_CHANGED, function(arg0_84, arg1_84, arg2_84)
		if not arg0_74.ladyDict[arg0_74.apartment:GetConfigID()]:GetBlackboardValue("inTouching") then
			return
		end

		arg0_74:DoTouch(arg1_84, arg2_84)
	end)
	arg0_74:bind(arg0_74.ON_ENTER_SECTOR, function(arg0_85, arg1_85)
		arg0_74.ladyDict[arg1_85]:ChangeCanWatchState()
	end)
	arg0_74:bind(arg0_74.ON_CHANGE_DISTANCE, function(arg0_86, arg1_86, arg2_86)
		arg0_74.ladyDict[arg1_86]:ChangeCanWatchState()
	end)
end

function var0_0.didEnter(arg0_87)
	var0_0.super.didEnter(arg0_87)
	arg0_87:UpdateZoneList()

	arg0_87.resumeCallback = arg0_87.contextData.resumeCallback
	arg0_87.contextData.resumeCallback = nil

	arg0_87:SetUI(function()
		arg0_87:didEnterCheck()
	end, "base")
end

function var0_0.FinishEnterResume(arg0_89)
	if not arg0_89.resumeCallback then
		return
	end

	local var0_89 = arg0_89.resumeCallback

	arg0_89.resumeCallback = nil

	return var0_89()
end

function var0_0.EnableJoystick(arg0_90, arg1_90)
	setActive(arg0_90._joystick, arg1_90)
end

function var0_0.EnablePOVLayer(arg0_91, arg1_91)
	setActive(arg0_91.povLayer, arg1_91)

	if not arg1_91 then
		arg0_91:emit(arg0_91.ON_POV_STICK_MOVE_END)
	end
end

function var0_0.SetUIStore(arg0_92, arg1_92, ...)
	table.insertto(arg0_92.uiStore, {
		...
	})
	existCall(arg1_92)
end

function var0_0.SetUI(arg0_93, arg1_93, ...)
	while rawget(arg0_93, "class") ~= var0_0 do
		arg0_93 = getmetatable(arg0_93).__index
	end

	table.insertto(arg0_93.uiStore, {
		...
	})

	for iter0_93, iter1_93 in ipairs(arg0_93.uiStore) do
		if iter1_93 == "back" then
			assert(#arg0_93.uiStack > 0)

			arg0_93.uiState = table.remove(arg0_93.uiStack)
		elseif iter1_93 == arg0_93.uiState and iter1_93 == "ik" then
			-- block empty
		else
			table.insert(arg0_93.uiStack, arg0_93.uiState)

			arg0_93.uiState = iter1_93
		end
	end

	arg0_93.uiStore = {}

	eachChild(arg0_93.uiContianer, function(arg0_94)
		setActive(arg0_94, arg0_94.name == arg0_93.uiState)
	end)
	arg0_93:EnablePOVLayer(arg0_93.uiState == "base" or arg0_93.uiState == "walk")
	arg0_93:TempHideContact(arg0_93.uiState ~= "base")
	arg0_93:SetFloatEnable(arg0_93.uiState == "walk")
	setActive(arg0_93.rtFloatPage, arg0_93.uiState == "walk")
	switch(arg0_93.uiState, {
		base = function()
			if not arg0_93.room:isPersonalRoom() then
				arg0_93:SetApartment(nil)
			end

			arg0_93:UpdateBtnState()
		end,
		watch = function()
			eachChild(arg0_93.rtRole, function(arg0_97)
				setActive(arg0_97, false)
			end)

			local var0_96 = underscore.filter({
				"Talk",
				"Touch",
				"Gift",
				"MiniGame",
				"Volleyball",
				"Performance"
			}, function(arg0_98)
				return arg0_93:CheckSystemOpen(arg0_98)
			end)
			local var1_96 = 0.05

			for iter0_96, iter1_96 in ipairs(var0_96) do
				LeanTween.delayedCall(var1_96, System.Action(function()
					setActive(arg0_93.rtRole:Find(iter1_96), true)
				end))

				var1_96 = var1_96 + 0.066
			end

			setActive(arg0_93.rtRole:Find("Gift/bg/Tip"), Dorm3dGift.NeedViewTip(arg0_93.apartment:GetConfigID()))
		end,
		ik = function()
			setActive(arg0_93.uiContianer:Find("ik/Right/MenuSmall"), arg0_93.room:isPersonalRoom())
			setActive(arg0_93.uiContianer:Find("ik/Right/Menu"), false)
		end,
		walk = function()
			setText(arg0_93.uiContianer:Find("walk/dialogue/content"), i18n("dorm3d_removable", arg0_93.apartment:getConfig("name")))
		end
	})
	arg0_93:ActiveStateCamera(arg0_93.uiState, function()
		if arg1_93 then
			arg1_93()
		elseif arg0_93.uiState == "base" then
			arg0_93:CheckQueue()
		end
	end)
end

function var0_0.EnterWatchMode(arg0_103, arg1_103)
	local var0_103 = arg0_103.apartment:GetConfigID()

	seriesAsync({
		function(arg0_104)
			arg0_103:emit(arg0_103.SHOW_BLOCK)
			arg0_103.ladyDict[var0_103]:SetBlackboardValue("inWatchMode", true)
			arg0_103:SetUI(arg0_104, "watch")
		end,
		function(arg0_105)
			arg0_103:emit(arg0_103.HIDE_BLOCK)
		end
	})
end

function var0_0.ExitWatchMode(arg0_106)
	local var0_106 = arg0_106.apartment:GetConfigID()

	seriesAsync({
		function(arg0_107)
			arg0_106:emit(arg0_106.SHOW_BLOCK)
			arg0_106:SetUI(arg0_107, "back")
		end,
		function(arg0_108)
			arg0_106.ladyDict[var0_106]:SetBlackboardValue("inWatchMode", false)
			arg0_106:emit(arg0_106.HIDE_BLOCK)
			arg0_106:CheckQueue()
		end
	})
end

function var0_0.SetInPending(arg0_109, arg1_109)
	local var0_109 = arg0_109:GetBlackboardValue("groupId")
	local var1_109 = pg.dorm3d_welcome[arg1_109]

	arg0_109:SetBlackboardValue("inPending", true)
	arg0_109:ChangeCanWatchState()
	arg0_109:EnableHeadIK(false)

	arg0_109.contextData.ladyZone[var0_109] = var1_109.area
	arg0_109.ladyBaseZone = arg0_109.contextData.ladyZone[var0_109]
	arg0_109.ladyActiveZone = var1_109.welcome_staypoint

	arg0_109:ChangeCharacterPosition()

	if var1_109.item_shield ~= "" then
		arg0_109.hideItemDic = {}

		for iter0_109, iter1_109 in ipairs(var1_109.item_shield) do
			local var2_109 = arg0_109.modelRoot:Find(iter1_109)

			if not var2_109 then
				warning(string.format("welcome:%d without hide item:%s", arg1_109, iter1_109))
			else
				arg0_109.hideItemDic[iter1_109] = isActive(var2_109)

				setActive(var2_109, false)
			end
		end
	end

	onNextTick(function()
		if arg0_109.tfPendintItem then
			setActive(arg0_109.tfPendintItem, true)
		end

		arg0_109:SwitchAnim(var1_109.welcome_idle)
	end)

	arg0_109.wakeUpTalkId = var1_109.welcome_talk
end

function var0_0.SetOutPending(arg0_111)
	arg0_111:SetBlackboardValue("inPending", false)
	arg0_111:ChangeCanWatchState()
	arg0_111:EnableHeadIK(true)

	arg0_111.wakeUpTalkId = nil

	if arg0_111.tfPendintItem then
		setActive(arg0_111.tfPendintItem, false)
	end

	if arg0_111.hideItemDic then
		for iter0_111, iter1_111 in pairs(arg0_111.hideItemDic) do
			setActive(arg0_111.modelRoot:Find(iter0_111), iter1_111)
		end

		arg0_111.hideItemDic = nil
	end
end

function var0_0.IsModeInHidePending(arg0_112, arg1_112)
	for iter0_112, iter1_112 in pairs(arg0_112.ladyDict) do
		if iter1_112.hideItemDic and iter1_112.hideItemDic[arg1_112] ~= nil then
			return true
		end
	end

	return false
end

function var0_0.EnterAccompanyMode(arg0_113, arg1_113)
	local var0_113 = pg.dorm3d_accompany[arg1_113]
	local var1_113
	local var2_113

	if var0_113.sceneInfo ~= "" then
		var1_113, var2_113 = unpack(string.split(var0_113.sceneInfo, "|"))
	end

	local var3_113 = {
		type = "timeline",
		name = var0_113.timeline,
		scene = var1_113,
		sceneRoot = var2_113,
		accompanys = {}
	}

	for iter0_113, iter1_113 in ipairs(var0_113.jump_trigger) do
		local var4_113, var5_113 = unpack(iter1_113)

		var3_113.accompanys[var4_113] = var5_113
	end

	local var6_113, var7_113 = unpack(var0_113.favor)

	getProxy(ApartmentProxy):RecordAccompanyTime()
	pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataAccompany(1, var0_113.ship_id, var0_113.performance_time, 0, var1_113 or arg0_113.artSceneInfo))

	local var8_113 = {}

	table.insert(var8_113, function(arg0_114)
		arg0_113:SetUI(arg0_114, "blank", "accompany")
	end)
	table.insert(var8_113, function(arg0_115)
		arg0_113.accompanyFavorCount = 0
		arg0_113.accompanyFavorTimer = Timer.New(function()
			arg0_113.accompanyFavorCount = arg0_113.accompanyFavorCount + 1
		end, var6_113, -1)

		arg0_113.accompanyFavorTimer:Start()

		arg0_113.accompanyPerformanceTimer = Timer.New(function()
			arg0_113.canTriggerAccompanyPerformance = true

			warning(arg0_113.canTriggerAccompanyPerformance)
		end, var0_113.performance_time, -1)

		arg0_113.accompanyPerformanceTimer:Start()
		arg0_113:PlayTimeline(var3_113, function(arg0_118, arg1_118)
			arg1_118()
			arg0_115()
		end)
	end)
	seriesAsync(var8_113, function()
		assert(arg0_113.accompanyFavorTimer)
		arg0_113.accompanyFavorTimer:Stop()

		arg0_113.accompanyFavorTimer = nil

		assert(arg0_113.accompanyPerformanceTimer)
		arg0_113.accompanyPerformanceTimer:Stop()

		arg0_113.accompanyPerformanceTimer = nil
		arg0_113.canTriggerAccompanyPerformance = nil

		local var0_119 = math.min(arg0_113.accompanyFavorCount, getProxy(ApartmentProxy):getStamina())

		if var0_119 > 0 then
			local var1_119 = var7_113[var0_119]

			warning(var1_119)
			arg0_113:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_113.apartment.configId, var1_119)
		end

		local var2_119 = 0
		local var3_119 = getProxy(ApartmentProxy):GetAccompanyTime()

		if var3_119 then
			var2_119 = pg.TimeMgr.GetInstance():GetServerTime() - var3_119
		end

		pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataAccompany(2, var0_113.ship_id, var0_113.performance_time, var2_119, var1_113 or arg0_113.artSceneInfo))
		arg0_113:SetUI(nil, "back", "back")
	end)
end

function var0_0.ExitAccompanyMode(arg0_120)
	existCall(arg0_120.timelineFinishCall)
end

function var0_0.EnterTouchMode(arg0_121)
	if arg0_121.ladyDict[arg0_121.apartment:GetConfigID()]:GetBlackboardValue("inTouching") then
		return
	end

	local var0_121 = arg0_121.ladyDict[arg0_121.apartment:GetConfigID()]
	local var1_121 = arg0_121.room:getApartmentZoneConfig(var0_121.ladyBaseZone, "touch_id", arg0_121.apartment:GetConfigID())

	arg0_121.touchConfig = var1_121 and pg.dorm3d_touch_data[var1_121] or nil
	arg0_121.inTouchGame = arg0_121.touchConfig.heartbeat_enable > 0

	setActive(arg0_121.rtTouchGamePanel, arg0_121.inTouchGame)

	if arg0_121.inTouchGame then
		arg0_121.touchCount = 0
		arg0_121.lastCount = 0
		arg0_121.topCount = 0

		arg0_121:UpdateTouchGameDisplay()
		setSlider(arg0_121.rtTouchGamePanel:Find("slider"), 0, 100, arg0_121.touchCount >= 500 and 100 or arg0_121.touchCount % 100)
		quickPlayAnimation(arg0_121.rtTouchGamePanel, "anim_dorm3d_touch_in")
		quickPlayAnimation(arg0_121.rtTouchGamePanel:Find("slider/icon"), "anim_dorm3d_touch_icon")

		arg0_121.downTimer = Timer.New(function()
			if not arg0_121.ladyDict[arg0_121.apartment:GetConfigID()]:GetBlackboardValue("inTalking") then
				arg0_121:UpdateTouchCount(-2)
			end
		end, 1, -1)

		arg0_121.downTimer:Start()
	end

	local var2_121 = {}

	table.insert(var2_121, function(arg0_123)
		var0_121:SetBlackboardValue("inTouching", true)
		arg0_121:emit(arg0_121.SHOW_BLOCK)
		arg0_121:SetUI(arg0_123, "blank")
	end)
	table.insert(var2_121, function(arg0_124)
		local var0_124 = arg0_121.inTouchGame and math.floor(arg0_121.touchCount / 100) or 0
		local var1_124 = arg0_121.touchConfig.ik_status[var0_124 + 1]

		arg0_121:SwitchIKConfig(var0_121, var1_124)
		setActive(arg0_121.uiContianer:Find("ik/btn_back"), true)
		arg0_121:SetIKState(true, arg0_124)
	end)
	table.insert(var2_121, function(arg0_125)
		existCall(arg0_125)
	end)
	seriesAsync(var2_121, function()
		Shader.SetGlobalFloat("_ScreenClipOff", 0)
		arg0_121:emit(arg0_121.HIDE_BLOCK)
	end)
end

function var0_0.ExitTouchMode(arg0_127)
	local var0_127 = arg0_127.ladyDict[arg0_127.apartment:GetConfigID()]

	if not var0_127:GetBlackboardValue("inTouching") then
		return
	end

	local var1_127 = {}

	if arg0_127.inTouchGame then
		table.insert(var1_127, function(arg0_128)
			arg0_127:emit(arg0_127.SHOW_BLOCK)
			quickPlayAnimation(arg0_127.rtTouchGamePanel, "anim_dorm3d_touch_out")
			onDelayTick(arg0_128, 0.5)
		end)
		table.insert(var1_127, function(arg0_129)
			local var0_129 = 0

			for iter0_129, iter1_129 in ipairs(arg0_127.touchConfig.heartbeat_favor) do
				if iter1_129[1] > arg0_127.topCount then
					break
				else
					var0_129 = iter1_129[2]
				end
			end

			if var0_129 > 0 then
				arg0_127:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_127.apartment.configId, var0_129)
			end

			arg0_127.touchCount = nil
			arg0_127.topCount = nil

			if arg0_127.downTimer then
				arg0_127.downTimer:Stop()

				arg0_127.downTimer = nil
			end

			arg0_127.inTouchGame = false

			setActive(arg0_127.rtTouchGamePanel, false)
			Shader.SetGlobalFloat("_ScreenClipOff", 1)
			arg0_129()
		end)
	else
		table.insert(var1_127, function(arg0_130)
			arg0_127:emit(arg0_127.SHOW_BLOCK)

			local var0_130 = arg0_127.touchConfig.default_favor

			if var0_130 > 0 then
				arg0_127:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_127.apartment.configId, var0_130)
			end

			Shader.SetGlobalFloat("_ScreenClipOff", 1)
			arg0_130()
		end)
	end

	table.insert(var1_127, function(arg0_131)
		var0_127.ikConfig = {
			character_position = var0_127.ladyBaseZone,
			character_action = arg0_127.touchConfig.finish_action
		}

		arg0_127:SetIKState(false, arg0_131)
	end)
	table.insert(var1_127, function(arg0_132)
		var0_127.ikConfig = nil
		arg0_127.blockIK = nil

		arg0_127:SetUI(arg0_132, "back")
	end)
	seriesAsync(var1_127, function()
		var0_127:SetBlackboardValue("inTouching", false)
		arg0_127:emit(arg0_127.HIDE_BLOCK)

		arg0_127.touchConfig = nil
		arg0_127.blockIK = nil

		local var0_133 = arg0_127.touchExitCall

		arg0_127.touchExitCall = nil

		existCall(var0_133)
	end)
end

function var0_0.ChangeWalkScene(arg0_134, arg1_134, arg2_134)
	local var0_134 = arg0_134.ladyDict[arg0_134.apartment:GetConfigID()]

	seriesAsync({
		function(arg0_135)
			arg0_134:ChangeArtScene(arg1_134, arg0_135)
		end,
		function(arg0_136)
			var0_134:ChangeSubScene(arg1_134, arg0_136)
		end,
		function(arg0_137)
			arg0_134:emit(arg0_134.SHOW_BLOCK)

			if arg1_134 == arg0_134.sceneInfo then
				arg0_134:SetUI(arg0_137, "back")
			elseif arg0_134.uiState ~= "walk" then
				arg0_134:SetUI(arg0_137, "walk")
			else
				arg0_137()
			end
		end
	}, function()
		arg0_134:emit(arg0_134.HIDE_BLOCK)
		var0_134:SetBlackboardValue("inWalk", arg1_134 ~= arg0_134.sceneInfo)
		existCall(arg2_134)
	end)
end

function var0_0.EnterWalkMode(arg0_139)
	local var0_139 = arg0_139.apartment:GetConfigID()
	local var1_139 = arg0_139.ladyDict[var0_139]

	seriesAsync({
		function(arg0_140)
			arg0_139:emit(arg0_139.SHOW_BLOCK)
			arg0_139:HideCharacter(var0_139)
			var1_139:SetBlackboardValue("inWalk", true)
			arg0_139:SetUI(arg0_140, "walk")
		end,
		function(arg0_141)
			arg0_139:emit(arg0_139.HIDE_BLOCK)
			arg0_139:ChangeArtScene(arg0_139.walkInfo.scene .. "|" .. arg0_139.walkInfo.sceneRoot, arg0_141)
		end,
		function(arg0_142)
			arg0_139:LoadSubScene(arg0_139.walkInfo, arg0_142)
		end
	}, function()
		return
	end)
end

function var0_0.ExitWalkMode(arg0_144)
	local var0_144 = arg0_144.apartment:GetConfigID()
	local var1_144 = arg0_144.ladyDict[var0_144]

	seriesAsync({
		function(arg0_145)
			arg0_144:ChangeArtScene(arg0_144.walkLastSceneInfo, arg0_145)
		end,
		function(arg0_146)
			arg0_144:UnloadSubScene(arg0_144.walkInfo, arg0_146)
		end,
		function(arg0_147)
			arg0_144:emit(arg0_144.SHOW_BLOCK)
			arg0_144:SetUI(arg0_147, "back")
		end
	}, function()
		arg0_144:emit(arg0_144.HIDE_BLOCK)
		arg0_144:RevertCharacter(var0_144)
		var1_144:SetBlackboardValue("inWalk", false)

		local var0_148 = arg0_144.walkExitCall

		arg0_144.walkExitCall = nil
		arg0_144.walkLastSceneInfo = nil
		arg0_144.walkInfo = nil

		existCall(var0_148)
	end)
end

function var0_0.EnableMiniGameCutIn(arg0_149)
	if not arg0_149.tfCutIn then
		return
	end

	local var0_149 = arg0_149.rtExtraScreen:Find("MiniGameCutIn")

	setActive(var0_149, true)

	local var1_149 = GetOrAddComponent(var0_149:Find("bg/mask/cut_in"), "CameraRTUI")

	setActive(var1_149, true)
	pg.CameraRTMgr.GetInstance():Bind(var1_149, arg0_149.tfCutIn:Find("TestCamera"):GetComponent(typeof(Camera)))
	quickPlayAnimator(arg0_149.modelCutIn.lady, "Idle")
	quickPlayAnimator(arg0_149.modelCutIn.player, "Idle")
	setActive(arg0_149.tfCutIn, true)
end

function var0_0.DisableMiniGameCutIn(arg0_150)
	if not arg0_150.tfCutIn then
		return
	end

	local var0_150 = arg0_150.rtExtraScreen:Find("MiniGameCutIn")
	local var1_150 = GetOrAddComponent(var0_150:Find("bg/mask/cut_in"), "CameraRTUI")

	pg.CameraRTMgr.GetInstance():Clean(var1_150)
	setActive(var0_150, false)
	setActive(arg0_150.tfCutIn, false)
end

function var0_0.SwitchIKConfig(arg0_151, arg1_151, arg2_151)
	local var0_151 = pg.dorm3d_ik_status[arg2_151]

	if var0_151.skin_id ~= arg1_151.skinId then
		local var1_151 = pg.dorm3d_ik_status.get_id_list_by_base[var0_151.base]
		local var2_151 = _.detect(var1_151, function(arg0_152)
			return pg.dorm3d_ik_status[arg0_152].skin_id == arg1_151.skinId
		end)

		assert(var2_151, string.format("Missing Status Config By Skin: %s original Status: %s", arg1_151.skinId, arg2_151))

		var0_151 = pg.dorm3d_ik_status[var2_151]
	end

	arg1_151.ikConfig = var0_151
end

function var0_0.SetIKState(arg0_153, arg1_153, arg2_153)
	local var0_153 = arg0_153.ladyDict[arg0_153.apartment:GetConfigID()]
	local var1_153 = {}

	if arg1_153 then
		table.insert(var1_153, function(arg0_154)
			var0_153:SetBlackboardValue("inIK", true)
			arg0_153:emit(arg0_153.SHOW_BLOCK)

			local var0_154 = var0_153.ikConfig.camera_group

			setActive(arg0_153.uiContianer:Find("ik/Right/btn_camera"), #pg.dorm3d_ik_status.get_id_list_by_camera_group[var0_154] > 1)
			arg0_154()
		end)

		if arg0_153.uiState ~= "ik" then
			table.insert(var1_153, function(arg0_155)
				arg0_153:SetUI(arg0_155, "ik")
			end)
		end

		table.insert(var1_153, function(arg0_156)
			Shader.SetGlobalFloat("_ScreenClipOff", 0)
			arg0_153.SetIKStatus(var0_153, var0_153.ikConfig, arg0_156)
		end)
		table.insert(var1_153, function(arg0_157)
			arg0_153:emit(arg0_153.HIDE_BLOCK)
			arg0_157()
		end)
	else
		assert(arg0_153.uiState == "ik")
		table.insert(var1_153, function(arg0_158)
			arg0_153:emit(arg0_153.SHOW_BLOCK)
			Shader.SetGlobalFloat("_ScreenClipOff", 1)
			arg0_158()
		end)

		local var2_153 = var0_153.skinIdList

		if var0_153.skinId ~= var2_153[1] then
			table.insert(var1_153, function(arg0_159)
				local var0_159 = arg0_153.apartment:GetConfigID()

				arg0_153.SwitchCharacterSkin(var0_153, var0_159, var2_153[1], arg0_159)
			end)
		end

		table.insert(var1_153, function(arg0_160)
			warning(var0_153.ikConfig.character_action)
			var0_153:ExitIKStatus(var0_153.ikConfig, arg0_160)
		end)
		table.insert(var1_153, function(arg0_161)
			arg0_153:SetUI(arg0_161, "back")
		end)
		table.insert(var1_153, function(arg0_162)
			var0_153:SetBlackboardValue("inIK", false)
			arg0_153:emit(arg0_153.HIDE_BLOCK)
			arg0_162()
		end)
	end

	seriesAsync(var1_153, arg2_153)
end

function var0_0.TouchModeAction(arg0_163, arg1_163, arg2_163, ...)
	return switch(arg2_163, {
		function(arg0_164, arg1_164)
			return function(arg0_165)
				seriesAsync({
					function(arg0_166)
						arg0_163.RevertAllIKLayer(arg1_163, 0, arg0_166)
					end,
					function(arg0_167)
						if not arg1_164 or arg1_164 == "" then
							return arg0_167()
						end

						arg0_163:PlaySingleAction(arg1_164, arg0_167)
					end,
					function(arg0_168)
						arg0_163:SwitchIKConfig(arg1_163, arg0_164)
						arg0_163:SetIKState(true, arg0_168)
					end,
					arg0_165
				})
			end
		end,
		function()
			return function()
				if arg0_163.ikSpecialCall then
					local var0_170 = arg0_163.ikSpecialCall

					arg0_163.ikSpecialCall = nil

					existCall(var0_170)
				else
					arg0_163:ExitTouchMode()
				end
			end
		end,
		function(arg0_171, arg1_171)
			return function(arg0_172)
				arg0_163.RevertAllIKLayer(arg1_163, arg0_171, function()
					arg0_163:PlaySingleAction(arg1_171, arg0_172)
				end)
			end
		end,
		function(arg0_174, arg1_174)
			return function(arg0_175)
				arg0_163.RevertAllIKLayer(arg1_163, arg0_174, function()
					arg0_163:DoTalk(arg1_174, arg0_175)
				end)
			end
		end
	}, function()
		return function()
			return
		end
	end, ...)
end

function var0_0.OnTriggerIK(arg0_179, arg1_179)
	local var0_179 = arg0_179.ladyDict[arg0_179.apartment:GetConfigID()]

	if not var0_179.ikConfig then
		return
	end

	for iter0_179, iter1_179 in ipairs(var0_179.ikConfig.ik_id) do
		local var1_179, var2_179, var3_179 = unpack(iter1_179)

		if var1_179 == arg1_179 then
			arg0_179.blockIK = true

			arg0_179:TouchModeAction(var0_179, unpack(var3_179))(function()
				arg0_179.enableIKTip = true

				arg0_179:ResetIKTipTimer()

				arg0_179.blockIK = nil
			end)

			return
		end
	end

	assert(false, string.format("Missing %s callback in status %s", arg1_179, var0_179.ikConfig.id))
end

function var0_0.OnTouchCharacterBody(arg0_181, arg1_181)
	local var0_181 = arg0_181.ladyDict[arg0_181.apartment:GetConfigID()]

	if not var0_181.ikConfig then
		return
	end

	for iter0_181, iter1_181 in ipairs(var0_181.ikConfig.touch_data) do
		local var1_181, var2_181, var3_181 = unpack(iter1_181)
		local var4_181 = pg.dorm3d_ik_touch[var1_181]

		if var4_181.body == arg1_181 then
			local var5_181 = var4_181.action_emote

			if #var5_181 > 0 then
				var0_181:PlayFaceAnim(var5_181)
			end

			local var6_181 = var4_181.vibrate

			if type(var6_181) == "table" and VibrateMgr.Instance:IsSupport() then
				local var7_181 = {}
				local var8_181 = {}
				local var9_181 = {}

				underscore.each(var6_181, function(arg0_182)
					table.insert(var7_181, arg0_182[1])
					table.insert(var8_181, arg0_182[2])
					table.insert(var9_181, 1)
				end)

				if PLATFORM == PLATFORM_ANDROID then
					VibrateMgr.Instance:VibrateWaveform(var7_181, var8_181)
				elseif PLATFORM == PLATFORM_ANDROID then
					VibrateMgr.Instance:VibrateWaveform(var7_181, var8_181, var9_181)
				end
			end

			arg0_181.blockIK = true

			arg0_181:TouchModeAction(var0_181, unpack(var3_181))(function()
				arg0_181.enableIKTip = true

				arg0_181:ResetIKTipTimer()

				arg0_181.blockIK = nil
			end)

			return
		end
	end
end

function var0_0.UpdateTouchGameDisplay(arg0_184)
	setActive(arg0_184.rtTouchGamePanel:Find("effect_bg"), arg0_184.touchCount > 100)
	setActive(arg0_184.rtTouchGamePanel:Find("slider/icon/beating"), arg0_184.touchCount > 100)

	if arg0_184.touchCount < 100 then
		quickPlayAnimation(arg0_184.rtTouchGamePanel, "anim_dorm3d_touch_change_out")
		quickPlayAnimation(arg0_184.rtTouchGamePanel:Find("slider/icon"), "anim_dorm3d_touch_icon")
	elseif arg0_184.touchCount < 200 then
		quickPlayAnimation(arg0_184.rtTouchGamePanel, "anim_dorm3d_touch_change")
		quickPlayAnimation(arg0_184.rtTouchGamePanel:Find("slider/icon"), "anim_dorm3d_touch_icon_1")
		pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_heartbeat")
	end
end

function var0_0.UpdateTouchCount(arg0_185, arg1_185)
	local var0_185 = arg0_185.touchCount

	arg0_185.touchCount = math.clamp(arg0_185.touchCount + arg1_185, 100 * math.floor(arg0_185.touchCount / 100), 500)

	warning(arg0_185.touchCount)

	if arg0_185.sliderLT and LeanTween.isTweening(arg0_185.sliderLT) then
		var0_185 = LeanTween.descr(arg0_185.sliderLT).val

		LeanTween.cancel(arg0_185.sliderLT)

		arg0_185.sliderLT = nil
	end

	if math.clamp(var0_185, 0, 500) ~= math.clamp(arg0_185.touchCount, 0, 500) then
		local var1_185 = GetComponent(arg0_185.rtTouchGamePanel:Find("slider"), typeof(Slider))

		arg0_185.sliderLT = LeanTween.value(var0_185, arg0_185.touchCount, math.abs(arg0_185.touchCount - var0_185) / 50):setOnUpdate(System.Action_float(function(arg0_186)
			var1_185.value = arg0_186 >= 500 and 100 or arg0_186 % 100
		end)):setEase(LeanTweenType.easeInOutCubic).uniqueId
	else
		setSlider(arg0_185.rtTouchGamePanel:Find("slider"), 0, 100, arg0_185.touchCount >= 500 and 100 or arg0_185.touchCount % 100)
	end

	if math.floor(arg0_185.touchCount / 100) ~= math.floor(var0_185 / 100) then
		arg0_185:UpdateTouchGameDisplay()

		local var2_185 = arg0_185.touchConfig.ik_status[math.floor(arg0_185.touchCount / 100) + 1]

		if var2_185 then
			arg0_185:SwitchIKConfig(arg0_185, var2_185)
			arg0_185:SetIKState(true)
		end
	end

	arg0_185.topCount = math.max(arg0_185.topCount, arg0_185.touchCount)
end

function var0_0.DoTouch(arg0_187, arg1_187, arg2_187)
	if arg0_187.inTouchGame then
		switch(arg2_187, {
			function()
				arg0_187:UpdateTouchCount(10)
			end,
			function()
				arg0_187:UpdateTouchCount(2)
			end,
			function()
				arg0_187:UpdateTouchCount(10)
			end,
			function()
				arg0_187:UpdateTouchCount(20)
			end
		})
	end
end

function var0_0.DoTalk(arg0_192, arg1_192, arg2_192)
	while rawget(arg0_192, "class") ~= var0_0 do
		arg0_192 = getmetatable(arg0_192).__index
	end

	if arg0_192.apartment and arg0_192.ladyDict[arg0_192.apartment:GetConfigID()]:GetBlackboardValue("inTalking") then
		errorMsg("Talking block:" .. arg1_192)

		return
	end

	if not arg0_192.room:isPersonalRoom() then
		local var0_192 = pg.dorm3d_dialogue_group[arg1_192].char_id

		if arg0_192.apartment then
			assert(arg0_192.apartment:GetConfigID() == var0_192)
		else
			arg0_192:SetApartment(getProxy(ApartmentProxy):getApartment(var0_192))
		end
	end

	local var1_192 = arg0_192.ladyDict[arg0_192.apartment:GetConfigID()]

	if arg1_192 == 10010 and not arg0_192.apartment.talkDic[arg1_192] then
		arg0_192.firstTimelineTouch = true
		arg0_192.firstMoveGuide = true
	end

	local var2_192 = {}
	local var3_192 = arg0_192.ladyDict[arg0_192.apartment:GetConfigID()]

	if var3_192:GetBlackboardValue("inPending") then
		table.insert(var2_192, function(arg0_193)
			arg0_192:OutOfLazy(arg0_192.apartment:GetConfigID(), arg0_193)
		end)
	end

	local var4_192 = pg.dorm3d_dialogue_group[arg1_192]
	local var5_192 = var4_192.performance_type == 1
	local var6_192

	table.insert(var2_192, function(arg0_194)
		arg0_192:emit(arg0_192.SHOW_BLOCK)
		var3_192:SetBlackboardValue(var5_192 and "inPerformance" or "inTalking", true)
		arg0_192:emit(Dorm3dRoomMediator.DO_TALK, arg1_192, function(arg0_195)
			var6_192 = arg0_195

			arg0_194()
		end)
	end)
	table.insert(var2_192, function(arg0_196)
		pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataDialog(arg0_192.apartment.configId, arg0_192.apartment.level, arg1_192, var4_192.type, arg0_192.room:getZoneConfig(arg0_192.ladyDict[arg0_192.apartment:GetConfigID()].ladyBaseZone, "id"), var4_192.action_type, table.CastToString(var4_192.trigger_config), arg0_192.room:GetConfigID()))

		if pg.NewGuideMgr.GetInstance():IsBusy() then
			pg.NewGuideMgr.GetInstance():Pause()
		end

		arg0_192:SetUI(arg0_196, "blank")
	end)

	if var4_192.trigger_area and var4_192.trigger_area ~= "" then
		table.insert(var2_192, function(arg0_197)
			arg0_192:ShiftZone(var4_192.trigger_area, arg0_197)
		end)
	end

	if var4_192.performance_type == 0 then
		table.insert(var2_192, function(arg0_198)
			pg.NewStoryMgr.GetInstance():ForceManualPlay(var4_192.story, function()
				onDelayTick(arg0_198, 0.001)
			end, true)
		end)
	elseif var4_192.performance_type == 1 then
		table.insert(var2_192, function(arg0_200)
			arg0_192:emit(arg0_192.HIDE_BLOCK)
			arg0_192:PerformanceQueue(var4_192.story, arg0_200)
		end)
		table.insert(var2_192, function(arg0_201)
			arg0_192:emit(arg0_192.SHOW_BLOCK)
			arg0_201()
		end)
	else
		assert(false)
	end

	table.insert(var2_192, function(arg0_202)
		local var0_202 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(var4_192.story)

		if var0_202 then
			local var1_202 = "1"

			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataStory(var0_202, var1_202))
		end

		if var6_192 and #var6_192 > 0 then
			arg0_192:emit(Dorm3dRoomMediator.OPEN_DROP_LAYER, var6_192, arg0_202)
		else
			arg0_202()
		end
	end)
	table.insert(var2_192, function(arg0_203)
		if pg.NewGuideMgr.GetInstance():IsPause() then
			pg.NewGuideMgr.GetInstance():Resume()
		end

		arg0_192:emit(arg0_192.HIDE_BLOCK)
		var3_192:SetBlackboardValue(var5_192 and "inPerformance" or "inTalking", false)
		arg0_192:SetUI(arg0_203, "back")
	end)
	seriesAsync(var2_192, function()
		if arg2_192 then
			return arg2_192()
		else
			arg0_192:CheckQueue()
		end
	end)
end

function var0_0.DoTalkTouchOption(arg0_205, arg1_205, arg2_205, arg3_205)
	local var0_205 = arg0_205.rtExtraScreen:Find("TalkTouchOption")
	local var1_205 = pg.NewStoryMgr.GetInstance()._tf

	if isActive(var1_205) then
		setParent(var0_205, var1_205)
	else
		pg.UIMgr.GetInstance():OverlayPanel(var0_205, {
			weight = LayerWeightConst.SECOND_LAYER,
			groupName = LayerWeightConst.GROUP_DORM3D
		})
	end

	arg0_205.tempExtraPanel = var0_205

	local var2_205
	local var3_205 = var0_205:Find("content")

	UIItemList.StaticAlign(var3_205, var3_205:Find("clickTpl"), #arg1_205.options, function(arg0_206, arg1_206, arg2_206)
		arg1_206 = arg1_206 + 1

		if arg0_206 == UIItemList.EventUpdate then
			local var0_206 = arg1_205.options[arg1_206]

			setAnchoredPosition(arg2_206, NewPos(unpack(var0_206.pos)))
			onButton(arg0_205, arg2_206, function()
				var2_205(var0_206.flag)
			end, SFX_CONFIRM)
			setActive(arg2_206, not table.contains(arg2_205, var0_206.flag))
		end
	end)
	setActive(var0_205, true)

	function var2_205(arg0_208)
		setActive(var0_205, false)

		if isActive(var1_205) then
			setParent(var0_205, arg0_205.rtExtraScreen)
		else
			pg.UIMgr.GetInstance():UnOverlayPanel(var0_205, arg0_205.rtExtraScreen)
		end

		arg0_205.tempExtraPanel = nil

		arg3_205(arg0_208)
	end
end

function var0_0.DoTimelineOption(arg0_209, arg1_209, arg2_209)
	local var0_209 = arg0_209.rtExtraScreen:Find("TimelineOption")

	if not var0_209 then
		return
	end

	local var1_209 = pg.NewStoryMgr.GetInstance()._tf

	if isActive(var1_209) then
		setParent(var0_209, var1_209)
	else
		pg.UIMgr.GetInstance():OverlayPanel(var0_209, {
			weight = LayerWeightConst.SECOND_LAYER,
			groupName = LayerWeightConst.GROUP_DORM3D
		})
	end

	arg0_209.tempExtraPanel = var0_209

	local var2_209
	local var3_209 = var0_209:Find("content")

	UIItemList.StaticAlign(var3_209, var3_209:Find("clickTpl"), #arg1_209, function(arg0_210, arg1_210, arg2_210)
		arg1_210 = arg1_210 + 1

		if arg0_210 == UIItemList.EventUpdate then
			local var0_210 = arg1_209[arg1_210]

			setText(arg2_210:Find("Text"), var0_210.content)
			onButton(arg0_209, arg2_210, function()
				var2_209(arg1_210)
			end, SFX_CONFIRM)
		end
	end)
	setActive(var0_209, true)

	function var2_209(arg0_212)
		setActive(var0_209, false)

		if isActive(var1_209) then
			setParent(var0_209, arg0_209.rtExtraScreen)
		else
			pg.UIMgr.GetInstance():UnOverlayPanel(var0_209, arg0_209.rtExtraScreen)
		end

		arg0_209.tempExtraPanel = nil

		arg2_209(arg0_212)
	end
end

function var0_0.DoTimelineTouch(arg0_213, arg1_213, arg2_213)
	local var0_213 = arg0_213.rtExtraScreen:Find("TimelineTouch")

	if not var0_213 then
		return
	end

	local var1_213 = pg.NewStoryMgr.GetInstance()._tf

	if isActive(var1_213) then
		setParent(var0_213, var1_213)
	else
		pg.UIMgr.GetInstance():OverlayPanel(var0_213, {
			weight = LayerWeightConst.SECOND_LAYER,
			groupName = LayerWeightConst.GROUP_DORM3D
		})
	end

	arg0_213.tempExtraPanel = var0_213

	local var2_213
	local var3_213 = var0_213:Find("content")

	UIItemList.StaticAlign(var3_213, var3_213:Find("clickTpl"), #arg1_213, function(arg0_214, arg1_214, arg2_214)
		arg1_214 = arg1_214 + 1

		if arg0_214 == UIItemList.EventUpdate then
			local var0_214 = arg1_213[arg1_214]

			setAnchoredPosition(arg2_214, NewPos(unpack(var0_214.pos)))
			onButton(arg0_213, arg2_214, function()
				var2_213(arg1_214)
			end, SFX_CONFIRM)

			if arg0_213.firstTimelineTouch then
				arg0_213.firstTimelineTouch = nil

				setActive(arg2_214:Find("finger"), true)
			end
		end
	end)
	setActive(var0_213, true)

	function var2_213(arg0_216)
		setActive(var0_213, false)

		if isActive(var1_213) then
			setParent(var0_213, arg0_213.rtExtraScreen)
		else
			pg.UIMgr.GetInstance():UnOverlayPanel(var0_213, arg0_213.rtExtraScreen)
		end

		arg0_213.tempExtraPanel = nil

		arg2_213(arg0_216)
	end
end

function var0_0.DoShortWait(arg0_217, arg1_217)
	local var0_217 = arg0_217.ladyDict[arg1_217]
	local var1_217 = getProxy(ApartmentProxy):getApartment(arg1_217)
	local var2_217 = arg0_217.room:getApartmentZoneConfig(var0_217.ladyBaseZone, "special_action", arg1_217)
	local var3_217 = var2_217 and var2_217[math.random(#var2_217)] or nil

	if not var3_217 then
		return
	end

	var0_217:PlaySingleAction(var3_217)
end

function var0_0.OutOfLazy(arg0_218, arg1_218, arg2_218)
	local var0_218 = arg0_218.ladyDict[arg1_218]
	local var1_218 = {}

	if var0_218:GetBlackboardValue("inPending") then
		table.insert(var1_218, function(arg0_219)
			arg0_218.shiftLady = arg1_218

			arg0_218:ShiftZone(var0_218.ladyBaseZone, arg0_219)
		end)
	end

	seriesAsync(var1_218, arg2_218)
end

function var0_0.OutOfPending(arg0_220, arg1_220, arg2_220)
	assert(arg0_220.wakeUpTalkId)

	local var0_220 = arg0_220.wakeUpTalkId

	seriesAsync({
		function(arg0_221)
			arg0_220:SetUI(arg0_221, "blank")
		end,
		function(arg0_222)
			arg0_220.shiftLady = arg1_220

			arg0_220:ShiftZone(arg0_220.ladyBaseZone, arg0_222)
		end,
		function(arg0_223)
			arg0_220:DoTalk(var0_220, arg0_223)
		end
	}, function()
		arg0_220:SetUIStore(arg2_220, "back")
	end)
end

function var0_0.ChangeCanWatchState(arg0_225)
	local var0_225

	if arg0_225:GetBlackboardValue("inPending") then
		var0_225 = tobool(arg0_225:GetBlackboardValue("inDistance"))
	else
		local var1_225 = arg0_225:GetBlackboardValue("groupId")

		var0_225 = tobool(arg0_225.activeLady[var1_225] and pg.NodeCanvasMgr.GetInstance():GetBlackboradValue("canWatch", arg0_225.ladyBlackboard))
	end

	if not arg0_225.nowCanWatchState or arg0_225.nowCanWatchState ~= var0_225 then
		arg0_225.nowCanWatchState = var0_225

		arg0_225:ShowOrHideCanWatchMark(arg0_225.nowCanWatchState)
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

function var0_0.HandleGameNotification(arg0_226, arg1_226, arg2_226)
	local var0_226 = arg0_226.ladyDict[arg0_226.apartment:GetConfigID()]

	switch(arg1_226, {
		[EatFoodMediator.HIT_AREA] = function()
			local var0_227, var1_227 = unpack(var1_0[arg2_226.index])

			var0_226:PlaySingleAction(var0_227)

			if arg0_226.tfCutIn then
				quickPlayAnimator(arg0_226.modelCutIn.lady, var1_227)
				quickPlayAnimator(arg0_226.modelCutIn.player, var1_227)
			end
		end,
		[EatFoodMediator.RESULT] = function()
			if arg2_226.win then
				var0_226:PlaySingleAction("Face_XYX_victory")
				var0_226:PlaySingleAction("minigame_win")
			else
				var0_226:PlaySingleAction("Face_XYX_lose")
				var0_226:PlaySingleAction("minigame_lose")
			end

			setActive(arg0_226.rtExtraScreen:Find("MiniGameCutIn"), false)
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataMiniGame(2, arg2_226.score))
		end,
		[EatFoodMediator.LEAVE_GAME] = function()
			if arg2_226 == false then
				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataMiniGame(3))
			end
		end
	})
end

function var0_0.PerformanceQueue(arg0_230, arg1_230, arg2_230)
	local var0_230, var1_230 = pcall(function()
		return require("GameCfg.dorm." .. arg1_230)
	end)

	if not var0_230 then
		errorMsg("不存在表演ID对应的Lua:" .. arg1_230)
		existCall(arg2_230)

		return
	end

	warning(arg1_230)

	local var2_230 = {}

	table.insert(var2_230, function(arg0_232)
		arg0_230:SetUI(arg0_232, "blank")
	end)
	table.insertto(var2_230, underscore.map(var1_230, function(arg0_233)
		return switch(arg0_233.type, {
			function()
				return function(arg0_235)
					local var0_235 = unpack(arg0_233.params)

					arg0_230:DoTalk(var0_235, arg0_235, true)
				end
			end,
			function()
				return function(arg0_237)
					arg0_230.touchExitCall = arg0_237

					arg0_230:EnterTouchMode()
				end
			end,
			function()
				return function(arg0_239)
					arg0_230.ladyDict[arg0_230.apartment:GetConfigID()]:PlaySingleAction(arg0_233.name, arg0_239)
				end
			end,
			function()
				return function(arg0_241)
					arg0_230:emit(arg0_230.PLAY_EXPRESSION, arg0_233)
					arg0_241()
				end
			end,
			function()
				return function(arg0_243)
					arg0_230:ShiftZone(arg0_233.name, arg0_243)
				end
			end,
			function()
				return function(arg0_245)
					arg0_230.contextData.timeIndex = arg0_233.params[1]

					if arg0_230.artSceneInfo == arg0_230.sceneInfo then
						arg0_230:SwitchDayNight(arg0_230.contextData.timeIndex)
						onNextTick(function()
							arg0_230:RefreshSlots()
						end)
					end

					arg0_230:UpdateContactState()
					onNextTick(arg0_245)
				end
			end,
			function()
				return function(arg0_248)
					arg0_230:ActiveStateCamera(arg0_233.name, arg0_248)
				end
			end,
			function()
				return function(arg0_250)
					if arg0_233.name == "base" then
						arg0_230:ChangeArtScene(arg0_230.sceneInfo, arg0_250)
					else
						local var0_250 = arg0_233.params.scene
						local var1_250 = arg0_233.params.sceneRoot

						arg0_230:ChangeArtScene(var0_250 .. "|" .. var1_250, arg0_250)
					end
				end
			end,
			function()
				return function(arg0_252)
					local var0_252 = arg0_233.params.name

					if arg0_233.name == "load" then
						arg0_230.waitForTimeline = tobool(arg0_233.params.wait_timeline)

						arg0_230:LoadTimelineScene(var0_252, true, arg0_252)
					elseif arg0_233.name == "unload" then
						arg0_230:UnloadTimelineScene(var0_252, true, arg0_252)
					else
						assert(false)
					end
				end
			end,
			function()
				return function(arg0_254)
					setActive(arg0_230.uiContianer:Find("walk/btn_back"), false)

					if arg0_233.name == "change" then
						local var0_254 = arg0_233.params.scene
						local var1_254 = arg0_233.params.sceneRoot

						arg0_230.walkBornPoint = arg0_233.params.point or "Default"

						arg0_230:ChangeWalkScene(var0_254 .. "|" .. var1_254, arg0_254)
					elseif arg0_233.name == "back" then
						arg0_230.walkBornPoint = nil

						arg0_230:ChangeWalkScene(arg0_230.sceneInfo, arg0_254)
					elseif arg0_233.name == "set" then
						local function var2_254()
							local var0_255 = arg0_254

							arg0_254 = nil

							return existCall(var0_255)
						end

						for iter0_254, iter1_254 in pairs(arg0_233.params) do
							switch(iter0_254, {
								back_button_trigger = function(arg0_256)
									onButton(arg0_230, arg0_230.uiContianer:Find("walk/btn_back"), var2_254, "ui-dorm_back_v2")
									setActive(arg0_230.uiContianer:Find("walk/btn_back"), IsUnityEditor and arg0_256)
								end,
								near_trigger = function(arg0_257)
									if arg0_257 == true then
										arg0_257 = 1.5
									end

									if arg0_257 then
										function arg0_230.walkNearCallback(arg0_258)
											if arg0_258 < arg0_257 then
												arg0_230.walkNearCallback = nil

												var2_254()
											end
										end
									else
										arg0_230.walkNearCallback = nil
									end
								end
							}, nil, iter1_254)
						end

						if arg0_230.firstMoveGuide then
							setActive(arg0_230.povLayer:Find("Guide"), arg0_230.firstMoveGuide)

							arg0_230.firstMoveGuide = nil
						end
					else
						assert(false)
					end
				end
			end,
			function()
				return function(arg0_260)
					if arg0_233.name == "set" then
						arg0_230:SwitchIKConfig(arg0_230, arg0_233.params.state)
						setActive(arg0_230.uiContianer:Find("ik/btn_back"), not arg0_233.params.hide_back)

						arg0_230.ikSpecialCall = arg0_260

						arg0_230:SetIKState(true)
					elseif arg0_233.name == "back" then
						local var0_260 = arg0_230.ladyDict[arg0_230.apartment:GetConfigID()]

						var0_260.ikConfig = arg0_233.params

						arg0_230:SetIKState(false, function()
							var0_260.ikConfig = nil

							existCall(arg0_260)
						end)
					else
						assert(false)
					end
				end
			end,
			function()
				return function(arg0_263)
					arg0_230.blackSceneInfo = setmetatable(arg0_233.params or {}, {
						__index = {
							color = "#000000",
							time = 0.3,
							delay = arg0_233.name == "show" and 0 or 0.5
						}
					})

					if arg0_233.name == "show" then
						arg0_230:ShowBlackScreen(true, arg0_263)
					elseif arg0_233.name == "hide" then
						arg0_230:ShowBlackScreen(false, arg0_263)
					else
						assert(false)
					end

					arg0_230.blackSceneInfo = nil
				end
			end
		})
	end))
	table.insert(var2_230, function(arg0_264)
		arg0_230:SetUI(arg0_264, "back")
	end)
	seriesAsync(var2_230, arg2_230)
end

function var0_0.TriggerContact(arg0_265, arg1_265)
	arg0_265:emit(Dorm3dRoomMediator.COLLECTION_ITEM, {
		itemId = arg1_265,
		roomId = arg0_265.room:GetConfigID(),
		groupId = arg0_265.room:isPersonalRoom() and arg0_265.apartment:GetConfigID() or 0
	})
end

function var0_0.UpdateContactState(arg0_266)
	arg0_266:SetContactStateDic(arg0_266.room:getTriggerableCollectItemDic(arg0_266.contextData.timeIndex))
end

function var0_0.UpdateFavorDisplay(arg0_267)
	local var0_267, var1_267 = getProxy(ApartmentProxy):getStamina()

	setText(arg0_267.rtStaminaDisplay:Find("Text"), string.format("%d/%d", var0_267, var1_267))
	setActive(arg0_267.rtStaminaDisplay, false)

	if arg0_267.apartment then
		setText(arg0_267.rtFavorLevel:Find("rank/Text"), arg0_267.apartment.level)

		local var2_267, var3_267 = arg0_267.apartment:getFavor()

		setText(arg0_267.rtFavorLevel:Find("Text"), string.format("<color=#ff6698>%d</color>/%d", var2_267, var3_267))
	end
end

function var0_0.UpdateBtnState(arg0_268)
	if arg0_268.room:isPersonalRoom() then
		setActive(arg0_268.uiContianer:Find("base/left/btn_furniture/tip"), arg0_268:CheckSystemOpen("Furniture") and Dorm3dFurniture.NeedViewTip(arg0_268.room:GetConfigID()))
	else
		setActive(arg0_268.uiContianer:Find("base/left/btn_furniture/tip"), Dorm3dFurniture.NeedViewTip(arg0_268.room:GetConfigID()))
	end

	setActive(arg0_268.uiContianer:Find("base/btn_back/main"), underscore(getProxy(ApartmentProxy):getRawData()):chain():values():filter(function(arg0_269)
		return tobool(arg0_269)
	end):any(function(arg0_270)
		return #arg0_270:getSpecialTalking() > 0 or arg0_270:getIconTip() == "main"
	end):value())
	setActive(arg0_268.uiContianer:Find("base/left/btn_collection/tip"), PlayerPrefs.GetInt("apartment_collection_item", 0) > 0 or PlayerPrefs.GetInt("apartment_collection_recall", 0) > 0)
end

function var0_0.AddUnlockDisplay(arg0_271, arg1_271)
	table.insert(arg0_271.unlockList, arg1_271)

	if not isActive(arg0_271.rtFavorUp) then
		setText(arg0_271.rtFavorUp:Find("Text"), table.remove(arg0_271.unlockList, 1))
		setActive(arg0_271.rtFavorUp, true)
	end
end

function var0_0.PopFavorTrigger(arg0_272, arg1_272)
	local var0_272 = arg1_272.triggerId
	local var1_272 = arg1_272.delta
	local var2_272 = arg1_272.cost
	local var3_272 = arg1_272.apartment
	local var4_272 = pg.dorm3d_favor_trigger[var0_272]

	if var4_272.is_repeat == 0 then
		if var0_272 == getDorm3dGameset("drom3d_favir_trigger_onwer")[1] then
			arg0_272:AddUnlockDisplay(i18n("dorm3d_own_favor"))
		elseif var0_272 == getDorm3dGameset("drom3d_favir_trigger_propose")[1] then
			arg0_272:AddUnlockDisplay(i18n("dorm3d_pledge_favor"))
		else
			arg0_272:AddUnlockDisplay(string.format("unknow favor trigger:%d unlock", var0_272))
		end
	elseif arg1_272.delta > 0 then
		local var5_272, var6_272 = var3_272:getFavor()
		local var7_272 = var5_272 + var1_272

		setText(arg0_272.rtFavorUpDaily:Find("bg/Text"), string.format("<size=48>+%d</size>", var1_272))
		setSlider(arg0_272.rtFavorUpDaily:Find("bg/slider"), 0, var6_272, var5_272)
		setAnchoredPosition(arg0_272.rtFavorUpDaily:Find("bg"), arg1_272.isGift and NewPos(-354, 223) or NewPos(-208, 105))

		local var8_272 = {}
		local var9_272 = arg0_272.rtFavorUpDaily:Find("bg/effect")

		eachChild(var9_272, function(arg0_273)
			setActive(arg0_273, false)
		end)

		local var10_272

		if var4_272.effect and var4_272.effect ~= "" then
			var10_272 = var9_272:Find(var4_272.effect .. "(Clone)")

			if not var10_272 then
				table.insert(var8_272, function(arg0_274)
					LoadAndInstantiateAsync("Dorm3D/Effect/Prefab/ExpressionUI", "uifx_dorm3d_yinfu01", function(arg0_275)
						setParent(arg0_275, var9_272)

						var10_272 = tf(arg0_275)

						arg0_274()
					end)
				end)
			else
				setActive(var10_272, true)
			end
		end

		local var11_272 = arg0_272.rtFavorUpDaily:GetComponent("DftAniEvent")

		var11_272:SetTriggerEvent(function(arg0_276)
			local var0_276 = GetComponent(arg0_272.rtFavorUpDaily:Find("bg/slider"), typeof(Slider))

			LeanTween.value(var5_272, var7_272, 0.5):setOnUpdate(System.Action_float(function(arg0_277)
				var0_276.value = arg0_277
			end)):setEase(LeanTweenType.easeInOutQuad):setDelay(0.165):setOnComplete(System.Action(function()
				LeanTween.delayedCall(0.165, System.Action(function()
					if arg0_272.exited then
						return
					end

					quickPlayAnimator(arg0_272.rtFavorUpDaily, "favor_out")
				end))
			end))
			pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_progaress_bar")
		end)
		var11_272:SetEndEvent(function(arg0_280)
			setActive(arg0_272.rtFavorUpDaily, false)
		end)
		seriesAsync(var8_272, function()
			local var0_281 = arg0_272.ladyDict[var3_272:GetConfigID()]

			setLocalPosition(arg0_272.rtFavorUpDaily, arg0_272:GetLocalPosition(arg0_272:GetScreenPosition(var0_281.ladyHeadCenter.position), arg0_272.rtFavorUpDaily.parent))
			setActive(arg0_272.rtFavorUpDaily, true)
			SetCompomentEnabled(arg0_272.rtFavorUpDaily, typeof(Animator), true)
			quickPlayAnimator(arg0_272.rtFavorUpDaily, "favor_open")

			if var2_272 > 0 then
				local var1_281, var2_281 = getProxy(ApartmentProxy):getStamina()

				setText(arg0_272.rtStaminaPop:Find("Text/Text (1)"), "-" .. var2_272)
				setText(arg0_272.rtStaminaPop:Find("Text"), string.format("%d/%d", var1_281 + var2_272, var2_281))
				setActive(arg0_272.rtStaminaPop, true)
			end
		end)
	end
end

function var0_0.PopFavorLevelUp(arg0_282, arg1_282, arg2_282, arg3_282)
	arg0_282.isLock = true

	LeanTween.delayedCall(0.33, System.Action(function()
		arg0_282.isLock = false
	end))

	local var0_282 = math.floor(arg1_282.level / 10)
	local var1_282 = math.fmod(arg1_282.level, 10)

	GetImageSpriteFromAtlasAsync("ui/favor_atlas", var1_282, arg0_282.rtLevelUpWindow:Find("panel/bg/item1/mark/level/digit2"))
	GetImageSpriteFromAtlasAsync("ui/favor_atlas", var0_282, arg0_282.rtLevelUpWindow:Find("panel/bg/item1/mark/level/digit1"))
	setActive(arg0_282.rtLevelUpWindow:Find("panel/bg/item1/mark/level/digit1"), var0_282 > 0)

	local var2_282
	local var3_282

	arg0_282.clientAward, var3_282 = Dorm3dIconHelper.SplitStory(arg1_282:getFavorConfig("levelup_client_item", arg1_282.level))
	arg0_282.serverAward = arg2_282

	local var4_282 = arg0_282.rtLevelUpWindow:Find("panel/info/content/itemContent")

	if not arg0_282.levelItemList then
		arg0_282.levelItemList = UIItemList.New(var4_282, var4_282:Find("tpl"))

		arg0_282.levelItemList:make(function(arg0_284, arg1_284, arg2_284)
			local var0_284 = arg1_284 + 1

			if arg0_284 == UIItemList.EventUpdate then
				if arg1_284 < #arg0_282.serverAward then
					updateDorm3dIcon(arg2_284, arg0_282.serverAward[var0_284])
					onButton(arg0_282, arg2_284, function()
						arg0_282:emit(BaseUI.ON_NEW_DROP, {
							drop = arg0_282.serverAward[var0_284]
						})
					end, SFX_PANEL)
				else
					Dorm3dIconHelper.UpdateDorm3dIcon(arg2_284, arg0_282.clientAward[var0_284 - #arg0_282.serverAward])
					onButton(arg0_282, arg2_284, function()
						arg0_282:emit(Dorm3dRoomMediator.ON_DROP_CLIENT, {
							data = arg0_282.clientAward[var0_284 - #arg0_282.serverAward]
						})
					end, SFX_PANEL)
				end
			end
		end)
	end

	arg0_282.levelItemList:align(#arg0_282.serverAward + #arg0_282.clientAward)
	setActive(arg0_282.rtLevelUpWindow, true)
	pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_upgrade")
	pg.UIMgr.GetInstance():OverlayPanel(arg0_282.rtLevelUpWindow, {
		weight = LayerWeightConst.SECOND_LAYER,
		groupName = LayerWeightConst.GROUP_DORM3D
	})

	function arg0_282.levelUpCallback()
		arg0_282.levelUpCallback = nil

		if var3_282 then
			arg0_282:PopNewStoryTip(var3_282)
		end

		existCall(arg3_282)
	end
end

function var0_0.PopNewStoryTip(arg0_288, arg1_288, arg2_288)
	local var0_288 = arg0_288.uiContianer:Find("base/top/story_tip")

	setActive(var0_288, true)
	LeanTween.delayedCall(1, System.Action(function()
		setActive(var0_288, false)
	end))
	setText(var0_288:Find("Text"), i18n("dorm3d_story_unlock_tip", pg.dorm3d_recall[arg1_288[2]].name))
	existCall(arg2_288)
end

function var0_0.UpdateZoneList(arg0_290)
	local var0_290

	if arg0_290.room:isPersonalRoom() then
		var0_290 = arg0_290.ladyDict[arg0_290.apartment:GetConfigID()].ladyBaseZone
	else
		var0_290 = arg0_290:GetAttachedFurnitureName()
	end

	for iter0_290, iter1_290 in ipairs(arg0_290.zoneDatas) do
		if iter1_290:GetWatchCameraName() == var0_290 then
			setText(arg0_290.btnZone:Find("Text"), iter1_290:GetName())
			setTextColor(arg0_290.rtZoneList:GetChild(iter0_290 - 1):Find("Name"), Color.NewHex("5CCAFF"))
		else
			setTextColor(arg0_290.rtZoneList:GetChild(iter0_290 - 1):Find("Name"), Color.NewHex("FFFFFF99"))
		end
	end
end

function var0_0.TalkingEventHandle(arg0_291, arg1_291)
	local var0_291 = {}
	local var1_291 = {}
	local var2_291 = arg1_291.data

	if var2_291.op_list then
		for iter0_291, iter1_291 in ipairs(var2_291.op_list) do
			table.insert(var0_291, function(arg0_292)
				local function var0_292()
					local var0_293 = arg0_292

					arg0_292 = nil

					return existCall(var0_293)
				end

				switch(iter1_291.type, {
					action = function()
						arg0_291.ladyDict[arg0_291.apartment:GetConfigID()]:PlaySingleAction(iter1_291.name, var0_292)
					end,
					timeline = function()
						if arg0_291.inTouchGame then
							setActive(arg0_291.rtTouchGamePanel, false)
						end

						arg0_291:PlayTimeline(iter1_291, function(arg0_296, arg1_296)
							setActive(arg0_291.rtTouchGamePanel, arg0_291.inTouchGame)

							var1_291.notifiCallback = arg1_296

							var0_292()
						end)
					end,
					clickOption = function()
						arg0_291:DoTalkTouchOption(iter1_291, arg1_291.flags, function(arg0_298)
							var1_291.optionIndex = arg0_298

							var0_292()
						end)
					end,
					wait = function()
						arg0_291.LTs = arg0_291.LTs or {}

						table.insert(arg0_291.LTs, LeanTween.delayedCall(iter1_291.time, System.Action(var0_292)).uniqueId)
					end,
					expression = function()
						arg0_291:emit(arg0_291.PLAY_EXPRESSION, iter1_291)
						var0_292()
					end
				}, function()
					assert(false, "op type error:", iter1_291.type)
				end)

				if iter1_291.skip then
					var0_292()
				end
			end)
		end
	end

	seriesAsync(var0_291, function()
		if arg1_291.callbackData then
			arg0_291:emit(Dorm3dRoomMediator.TALKING_EVENT_FINISH, arg1_291.callbackData.name, var1_291)
		end
	end)
end

function var0_0.CheckQueue(arg0_303)
	if arg0_303.inGuide or arg0_303.uiState ~= "base" then
		return
	end

	if arg0_303.room:GetConfigID() == 1 and arg0_303:CheckGuide() then
		-- block empty
	elseif arg0_303.room:isPersonalRoom() and arg0_303:CheckLevelUp() then
		-- block empty
	elseif arg0_303.apartment and arg0_303:CheckEnterDeal() then
		-- block empty
	elseif arg0_303.apartment and arg0_303:CheckActiveTalk() then
		-- block empty
	elseif arg0_303.apartment then
		arg0_303:CheckFavorTrigger()
	end

	arg0_303.contextData.hasEnterCheck = true
end

function var0_0.didEnterCheck(arg0_304)
	local var0_304

	if arg0_304.contextData.specialId then
		var0_304 = arg0_304.contextData.specialId
		arg0_304.contextData.specialId = nil

		arg0_304:DoTalk(var0_304, function()
			arg0_304:closeView()
		end)
	elseif not arg0_304.contextData.hasEnterCheck and arg0_304.apartment then
		for iter0_304, iter1_304 in ipairs(arg0_304.apartment:getForceEnterTalking(arg0_304.room:GetConfigID())) do
			var0_304 = iter1_304

			arg0_304:DoTalk(iter1_304)

			break
		end
	end

	if var0_304 and pg.dorm3d_dialogue_group[var0_304].extend_loading > 0 then
		arg0_304.contextData.hasEnterCheck = true

		pg.SceneAnimMgr.GetInstance():RegisterDormNextCall(function()
			arg0_304:FinishEnterResume()
		end)
	else
		if arg0_304.apartment and arg0_304.contextData.pendingDic[arg0_304.apartment:GetConfigID()] then
			arg0_304.contextData.hasEnterCheck = true
		end

		for iter2_304, iter3_304 in pairs(arg0_304.contextData.pendingDic) do
			arg0_304.ladyDict[iter2_304]:SetInPending(iter3_304)
		end

		arg0_304.contextData.pendingDic = {}

		arg0_304:FinishEnterResume()
		arg0_304:CheckQueue()
	end
end

function var0_0.CheckGuide(arg0_307)
	if arg0_307.ladyDict[arg0_307.apartment:GetConfigID()]:GetBlackboardValue("inPending") then
		return
	end

	for iter0_307, iter1_307 in ipairs({
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
				return arg0_307:CheckSystemOpen("Furniture")
			end
		},
		{
			name = "DORM3D_GUIDE_07",
			active = function()
				return arg0_307:CheckSystemOpen("DayNight")
			end
		}
	}) do
		if not pg.NewStoryMgr.GetInstance():IsPlayed(iter1_307.name) and iter1_307.active() then
			arg0_307:SetAllBlackbloardValue("inGuide", true)

			local function var0_307()
				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(2, pg.NewStoryMgr.GetInstance():StoryName2StoryId(iter1_307.name)))
				arg0_307:SetAllBlackbloardValue("inGuide", false)
			end

			pg.m02:sendNotification(GAME.STORY_UPDATE, {
				storyId = iter1_307.name
			})
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(1, pg.NewStoryMgr.GetInstance():StoryName2StoryId(iter1_307.name)))
			pg.NewGuideMgr.GetInstance():Play(iter1_307.name, nil, var0_307, var0_307)

			return true
		end
	end

	return false
end

function var0_0.CheckFavorTrigger(arg0_313)
	for iter0_313, iter1_313 in ipairs({
		{
			triggerId = getDorm3dGameset("drom3d_favir_trigger_onwer")[1],
			active = function()
				local var0_314 = getProxy(CollectionProxy):getShipGroup(arg0_313.apartment.configId)

				return tobool(var0_314)
			end
		},
		{
			triggerId = getDorm3dGameset("drom3d_favir_trigger_propose")[1],
			active = function()
				local var0_315 = getProxy(CollectionProxy):getShipGroup(arg0_313.apartment.configId)

				return var0_315 and var0_315.married > 0
			end
		}
	}) do
		if arg0_313.apartment.triggerCountDic[iter1_313.triggerId] == 0 and iter1_313.active() then
			arg0_313:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_313.apartment.configId, iter1_313.triggerId)
		end
	end
end

function var0_0.CheckEnterDeal(arg0_316)
	if arg0_316.contextData.hasEnterCheck then
		return false
	end

	local var0_316 = arg0_316.apartment:GetConfigID()
	local var1_316 = "dorm3d_enter_count_" .. var0_316
	local var2_316 = pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d")

	if PlayerPrefs.GetString("dorm3d_enter_count_day") ~= var2_316 then
		PlayerPrefs.SetString("dorm3d_enter_count_day", var2_316)
		PlayerPrefs.SetInt(var1_316, 1)
	else
		PlayerPrefs.SetInt(var1_316, PlayerPrefs.GetInt(var1_316, 0) + 1)
	end

	local var3_316 = arg0_316.apartment:getEnterTalking(arg0_316.room:GetConfigID())

	PlayerPrefs.SetString("DORM3D_DAILY_ENTER", pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d"))

	if #var3_316 > 0 then
		arg0_316:DoTalk(var3_316[math.random(#var3_316)])

		return true
	end
end

function var0_0.CheckActiveTalk(arg0_317)
	local var0_317 = arg0_317.ladyDict[arg0_317.apartment:GetConfigID()]

	if var0_317:GetBlackboardValue("inPending") then
		return false
	end

	local var1_317 = arg0_317.apartment:getZoneTalking(arg0_317.room:GetConfigID(), var0_317.ladyBaseZone)

	if #var1_317 > 0 then
		arg0_317:DoTalk(var1_317[1])

		return true
	else
		return false
	end
end

function var0_0.CheckDistanceTalk(arg0_318, arg1_318, arg2_318)
	local var0_318 = arg0_318.ladyDict[arg1_318].ladyBaseZone
	local var1_318 = getProxy(ApartmentProxy):getApartment(arg1_318)

	for iter0_318, iter1_318 in ipairs(var1_318:getDistanceTalking(arg0_318.room:GetConfigID(), var0_318)) do
		arg0_318:DoTalk(iter1_318)

		return
	end
end

function var0_0.CheckSystemOpen(arg0_319, arg1_319)
	if arg0_319.room:isPersonalRoom() then
		return switch(arg1_319, {
			Talk = function()
				local var0_320 = 1

				return var0_320 <= arg0_319.apartment.level, i18n("apartment_level_unenough", var0_320)
			end,
			Touch = function()
				local var0_321 = getDorm3dGameset("drom3d_touch_dialogue")[1]

				return var0_321 <= arg0_319.apartment.level, i18n("apartment_level_unenough", var0_321)
			end,
			Gift = function()
				local var0_322 = getDorm3dGameset("drom3d_gift_dialogue")[1]

				return var0_322 <= arg0_319.apartment.level, i18n("apartment_level_unenough", var0_322)
			end,
			Volleyball = function()
				return false
			end,
			Photo = function()
				local var0_324 = getDorm3dGameset("drom3d_photograph_unlock")[1]

				return var0_324 <= arg0_319.apartment.level, i18n("apartment_level_unenough", var0_324)
			end,
			Collection = function()
				local var0_325 = getDorm3dGameset("drom3d_recall_unlock")[1]

				return var0_325 <= arg0_319.apartment.level, i18n("apartment_level_unenough", var0_325)
			end,
			Furniture = function()
				local var0_326 = getDorm3dGameset("drom3d_furniture_unlock")[1]

				return var0_326 <= arg0_319.apartment.level, i18n("apartment_level_unenough", var0_326)
			end,
			DayNight = function()
				local var0_327 = getDorm3dGameset("drom3d_time_unlock")[1]

				return var0_327 <= arg0_319.apartment.level, i18n("apartment_level_unenough", var0_327)
			end,
			Accompany = function()
				local var0_328 = 1

				return var0_328 <= arg0_319.apartment.level, i18n("apartment_level_unenough", var0_328)
			end,
			MiniGame = function()
				local var0_329 = 1

				return var0_329 <= arg0_319.apartment.level, i18n("apartment_level_unenough", var0_329)
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
		return switch(arg1_319, {
			Gift = function()
				return false
			end,
			Volleyball = function()
				return arg0_319.room:GetConfigID() == 4
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

function var0_0.CheckLevelUp(arg0_341)
	if arg0_341.apartment:canLevelUp() then
		arg0_341:emit(Dorm3dRoomMediator.FAVOR_LEVEL_UP, arg0_341.apartment.configId)

		return true
	end

	return false
end

function var0_0.GetIKTipsRootTF(arg0_342)
	return arg0_342.ikTipsRoot
end

function var0_0.GetIKHandTF(arg0_343)
	return arg0_343.ikHand
end

function var0_0.CycleIKCameraGroup(arg0_344)
	local var0_344 = arg0_344.ladyDict[arg0_344.apartment:GetConfigID()]

	assert(var0_344:GetBlackboardValue("inIK"))
	seriesAsync({
		function(arg0_345)
			arg0_344.RevertIKLayer(var0_344, 0, arg0_345)
		end,
		function(arg0_346)
			local var0_346 = var0_344.ikConfig
			local var1_346 = var0_346.camera_group
			local var2_346 = pg.dorm3d_ik_status.get_id_list_by_camera_group[var1_346]
			local var3_346 = var2_346[table.indexof(var2_346, var0_346.id) % #var2_346 + 1]

			arg0_344:SwitchIKConfig(var0_344, var3_346)
			arg0_344:SetIKState(true)
		end
	})
end

function var0_0.TempHideUI(arg0_347, arg1_347, arg2_347)
	local var0_347 = defaultValue(arg0_347.hideCount, 0)

	arg0_347.hideCount = var0_347 + (arg1_347 and 1 or -1)

	assert(arg0_347.hideCount >= 0)

	if arg0_347.hideCount * var0_347 > 0 then
		return existCall(arg2_347)
	elseif arg0_347.hideCount > 0 then
		arg0_347:SetUI(arg2_347, "blank")
	else
		arg0_347:SetUI(arg2_347, "back")
	end
end

function var0_0.onBackPressed(arg0_348)
	if arg0_348.exited or arg0_348.retainCount > 0 then
		-- block empty
	elseif isActive(arg0_348.rtLevelUpWindow) then
		triggerButton(arg0_348.rtLevelUpWindow:Find("bg"))
	elseif arg0_348.uiState ~= "base" then
		-- block empty
	else
		arg0_348:closeView()
	end
end

function var0_0.willExit(arg0_349)
	if arg0_349.tempExtraPanel and isActive(arg0_349.tempExtraPanel) then
		local var0_349 = arg0_349.tempExtraPanel

		setActive(var0_349, false)

		if isActive(pg.NewStoryMgr.GetInstance()._tf) then
			setParent(var0_349, arg0_349.rtExtraScreen)
		else
			pg.UIMgr.GetInstance():UnOverlayPanel(var0_349, arg0_349.rtExtraScreen)
		end

		arg0_349.tempExtraPanel = nil
	end

	if arg0_349.downTimer then
		arg0_349.downTimer:Stop()

		arg0_349.downTimer = nil
	end

	if arg0_349.LTs then
		underscore.map(arg0_349.LTs, function(arg0_350)
			LeanTween.cancel(arg0_350)
		end)

		arg0_349.LTs = nil
	end

	if arg0_349.sliderLT then
		LeanTween.cancel(arg0_349.sliderLT)

		arg0_349.sliderLT = nil
	end

	for iter0_349, iter1_349 in pairs(arg0_349.ladyDict) do
		iter1_349.wakeUpTalkId = nil
	end

	if arg0_349.accompanyFavorTimer then
		arg0_349.accompanyFavorTimer:Stop()

		arg0_349.accompanyFavorTimer = nil
	end

	if arg0_349.accompanyPerformanceTimer then
		arg0_349.accompanyPerformanceTimer:Stop()

		arg0_349.accompanyPerformanceTimer = nil
	end

	arg0_349.canTriggerAccompanyPerformance = nil

	var0_0.super.willExit(arg0_349)
end

return var0_0
