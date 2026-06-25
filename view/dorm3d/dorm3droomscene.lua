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

function var0_0.InitSubViews(arg0_4)
	arg0_4.videoPlayer = VoiceChatLoader.New(arg0_4._tf)
	arg0_4.stockingView = Dorm3dStockingView.New(arg0_4._tf, arg0_4.event, setmetatable({}, {
		__index = arg0_4.contextData
	}))
	arg0_4.rtRoleTouchSubView = Dorm3dRTRoleTouchSubView.New(arg0_4.rtRole:Find("Touch"), arg0_4.event, setmetatable({
		onClick = function(arg0_5)
			arg0_4:emit(RoomTouchSystem.ENTER_TOUCH_MODE, arg0_5)
		end
	}, {
		__index = arg0_4.contextData
	}))
	arg0_4.aimIKView = Dorm3dAimIKView.New(arg0_4._tf:Find("AimIKControl"), arg0_4.event, setmetatable({}, {
		__index = arg0_4.contextData
	}))
	arg0_4.ikView = Dorm3dIKView.New(arg0_4._tf, arg0_4.event, {
		GetApartment = function()
			return arg0_4.apartment
		end,
		GetCurrentLadyEnv = function()
			return arg0_4:GetCurrentLadyEnv()
		end,
		GetSceneItem = function(arg0_8)
			return arg0_4:GetSceneItem(arg0_8)
		end,
		GetScreenPosition = function(arg0_9, arg1_9)
			return arg0_4:GetScreenPosition(arg0_9, arg1_9)
		end,
		GetLocalPosition = function(arg0_10, arg1_10)
			return arg0_4:GetLocalPosition(arg0_10, arg1_10)
		end
	})
	arg0_4.touchView = Dorm3dTouchView.New(arg0_4._tf, arg0_4.event, {})
end

function var0_0.init(arg0_11)
	var0_0.super.init(arg0_11)
	Shader.SetGlobalFloat("_ScreenClipOff", 1)

	arg0_11.uiContainer = arg0_11._tf:Find("UI")

	local var0_11 = arg0_11.uiContainer:Find("base")

	onButton(arg0_11, var0_11:Find("btn_back"), function()
		arg0_11:emit(BaseUI.ON_BACK)
	end, SFX_DORM_BACK)
	onButton(arg0_11, var0_11:Find("btn_back/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_dorm3d_info.tip
		})
	end, SFX_PANEL)

	arg0_11.rtFavorLevel = var0_11:Find("top/favor_level")

	setActive(arg0_11.rtFavorLevel, arg0_11.room:isPersonalRoom())
	onButton(arg0_11, arg0_11.rtFavorLevel, function()
		local var0_14 = {}

		arg0_11:emit(Dorm3dRoomMediator.OPEN_LEVEL_LAYER, {
			apartment = arg0_11.apartment,
			timeIndex = arg0_11.contextData.timeIndex,
			baseCamera = arg0_11.mainCameraTF,
			roomId = arg0_11.room:GetConfigID()
		})
	end, SFX_PANEL)
	onButton(arg0_11, var0_11:Find("top/setting"), function()
		arg0_11:emit(Dorm3dRoomMediator.OPEN_SETTING_LAYER)
	end)
	onButton(arg0_11, var0_11:Find("left/btn_photograph"), function()
		if #arg0_11.contextData.groupIds == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_photo_no_role"))

			return
		end

		local var0_16, var1_16 = arg0_11:CheckSystemOpen("Photo")

		if not var0_16 then
			pg.TipsMgr.GetInstance():ShowTips(var1_16)

			return
		end

		if not arg0_11.apartment then
			local var2_16 = arg0_11.contextData.groupIds[1]

			for iter0_16, iter1_16 in pairs(arg0_11.ladyDict) do
				if iter1_16.ladyBaseZone == arg0_11:GetAttachedFurnitureName() then
					var2_16 = iter0_16

					break
				end
			end

			arg0_11:SetApartment(getProxy(ApartmentProxy):getApartment(var2_16))
		end

		getProxy(Dorm3dChatProxy):TriggerEvent({
			{
				value = 1,
				event_type = arg0_11.contextData.timeIndex == 1 and 114 or 119,
				ship_id = arg0_11.apartment:GetConfigID()
			}
		})
		arg0_11:OutOfLazy(arg0_11.apartment:GetConfigID(), function()
			arg0_11:emit(Dorm3dRoomMediator.OPEN_CAMERA_LAYER, arg0_11, arg0_11.apartment:GetConfigID())
		end)
	end, SFX_PANEL)
	onButton(arg0_11, var0_11:Find("left/btn_collection"), function()
		local var0_18, var1_18 = arg0_11:CheckSystemOpen("Collection")

		if not var0_18 then
			pg.TipsMgr.GetInstance():ShowTips(var1_18)

			return
		end

		setActive(var0_11:Find("left/btn_collection/tip"), false)
		PlayerPrefs.SetInt("apartment_collection_item", 0)
		PlayerPrefs.SetInt("apartment_collection_recall", 0)
		arg0_11:emit(Dorm3dRoomMediator.OPEN_COLLECTION_LAYER, arg0_11.room:GetConfigID())
	end, SFX_PANEL)
	onButton(arg0_11, var0_11:Find("left/btn_furniture"), function()
		local var0_19, var1_19 = arg0_11:CheckSystemOpen("Furniture")

		if not var0_19 then
			pg.TipsMgr.GetInstance():ShowTips(var1_19)

			return
		end

		arg0_11:RemoveExtraSystem({
			SlideExtraSystem
		})
		arg0_11:emit(Dorm3dRoomMediator.OPEN_FURNITURE_SELECT, {
			apartment = arg0_11.apartment
		})

		arg0_11.isInFurnitureSelect = true
	end, SFX_PANEL)

	if not arg0_11.room:isPersonalRoom() then
		local var1_11 = arg0_11:CheckSystemOpen("Furniture")

		setActive(var0_11:Find("left/line_furniture"), var1_11)
		setActive(var0_11:Find("left/btn_furniture"), var1_11)
	end

	onButton(arg0_11, var0_11:Find("left/btn_accompany"), function()
		local var0_20, var1_20 = arg0_11:CheckSystemOpen("Accompany")

		if not var0_20 then
			pg.TipsMgr.GetInstance():ShowTips(var1_20)

			return
		end

		local var2_20 = arg0_11.apartment:GetConfigID()
		local var3_20

		arg0_11:emit(Dorm3dRoomMediator.OPEN_ACCOMPANY_WINDOW, {
			groupId = var2_20,
			confirmFunc = function(arg0_21)
				var3_20 = arg0_21
			end
		}, function()
			if var3_20 then
				arg0_11:OutOfLazy(var2_20, function()
					arg0_11:EnterAccompanyMode(var3_20)
				end)
			else
				arg0_11:CheckQueue()
			end
		end)
	end, SFX_PANEL)

	if not arg0_11.room:isPersonalRoom() then
		setActive(var0_11:Find("left/line_accompany"), false)
		setActive(var0_11:Find("left/btn_accompany"), false)
	end

	onButton(arg0_11, var0_11:Find("left/btn_skin"), function()
		arg0_11:ActiveCamera(arg0_11.cameras[var0_0.CAMERA.SKIN])
		arg0_11:emit(Dorm3dRoomMediator.OPEN_SKIN_SELECT_LAYER, arg0_11.apartment:GetConfigID(), arg0_11:GetCurrentLadyEnv(), nil, function()
			arg0_11:ChangePlayerPosition()
			arg0_11:ActiveCamera(arg0_11.cameras[var0_0.CAMERA.POV])
		end, false)
	end)

	if not arg0_11.room:isPersonalRoom() then
		setActive(var0_11:Find("left/line_skin"), false)
		setActive(var0_11:Find("left/btn_skin"), false)
	end

	onButton(arg0_11, var0_11:Find("left/btn_invite"), function()
		arg0_11:emit(Dorm3dRoomMediator.OPEN_INVITE_WINDOW, arg0_11.room:GetConfigID(), underscore.rest(arg0_11.contextData.groupIds, 1))
	end, SFX_PANEL)

	if arg0_11.room:isPersonalRoom() then
		setActive(var0_11:Find("left/line_invite"), false)
		setActive(var0_11:Find("left/btn_invite"), false)
	end

	arg0_11.btnZone = var0_11:Find("right/Zone")
	arg0_11.rtZoneList = var0_11:Find("right/Zone/List")

	setActive(arg0_11.rtZoneList, false)
	onButton(arg0_11, arg0_11.btnZone, function()
		setActive(arg0_11.rtZoneList, not isActive(arg0_11.rtZoneList))
	end, SFX_PANEL)
	UIItemList.StaticAlign(arg0_11.rtZoneList, arg0_11.rtZoneList:GetChild(0), #arg0_11.zoneDatas, function(arg0_28, arg1_28, arg2_28)
		if arg0_28 ~= UIItemList.EventUpdate then
			return
		end

		arg1_28 = arg1_28 + 1

		local var0_28 = arg0_11.zoneDatas[arg1_28]
		local var1_28 = var0_28:GetWatchCameraName()

		arg2_28.name = var1_28

		setText(arg2_28:Find("Name"), var0_28:GetName())
		setActive(arg2_28:Find("Line"), arg1_28 < #arg0_11.zoneDatas)
		onButton(arg0_11, arg2_28, function()
			if arg0_11.uiState ~= "base" then
				return
			end

			setActive(arg0_11.rtZoneList, false)
			arg0_11:ShiftZoneSafe(var1_28)
		end, SFX_PANEL)
	end)

	local var2_11 = arg0_11.uiContainer:Find("accompany")

	onButton(arg0_11, var2_11:Find("btn_back"), function()
		arg0_11:ExitAccompanyMode()
	end, SFX_DORM_BACK)

	arg0_11.unlockList = {}
	arg0_11.rtFavorUp = arg0_11._tf:Find("Toast/favor_up")

	arg0_11.rtFavorUp:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_31)
		setActive(arg0_11.rtFavorUp, false)

		if #arg0_11.unlockList > 0 then
			setText(arg0_11.rtFavorUp:Find("Text"), table.remove(arg0_11.unlockList, 1))
			setActive(arg0_11.rtFavorUp, true)
		end
	end)
	setActive(arg0_11.rtFavorUp, false)

	arg0_11.rtFavorUpDaily = arg0_11._tf:Find("Toast/favor_up_daily")

	setActive(arg0_11.rtFavorUpDaily, false)

	arg0_11.rtStaminaPop = arg0_11._tf:Find("Toast/stamina")

	local var3_11 = arg0_11.rtStaminaPop:GetComponent("DftAniEvent")

	var3_11:SetTriggerEvent(function(arg0_32)
		local var0_32, var1_32 = getProxy(ApartmentProxy):getStamina()

		setText(arg0_11.rtStaminaPop:Find("Text"), string.format("%d/%d", var0_32, var1_32))
	end)
	var3_11:SetEndEvent(function(arg0_33)
		setActive(arg0_11.rtStaminaPop, false)
	end)
	setActive(arg0_11.rtStaminaPop, false)

	arg0_11.rtLevelUpWindow = arg0_11._tf:Find("LevelUpWindow")

	setActive(arg0_11.rtLevelUpWindow, false)
	onButton(arg0_11, arg0_11.rtLevelUpWindow:Find("bg"), function()
		if arg0_11.isLock then
			return
		end

		arg0_11.isLock = true

		quickPlayAnimation(arg0_11.rtLevelUpWindow, "anim_dorm3d_levelup_out")
		LeanTween.delayedCall(0.2, System.Action(function()
			arg0_11.isLock = false

			setActive(arg0_11.rtLevelUpWindow, false)
			arg0_11:UnOverlayPanel(arg0_11.rtLevelUpWindow, arg0_11._tf)
			existCall(arg0_11.levelUpCallback)
		end))
	end, SFX_PANEL)

	local var4_11 = arg0_11.uiContainer:Find("watch")

	onButton(arg0_11, var4_11:Find("btn_back"), function()
		arg0_11:ExitWatchMode()
	end, SFX_DORM_BACK)
	onButton(arg0_11, var4_11:Find("btn_back/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("roll_gametip")
		})
	end, SFX_PANEL)

	arg0_11.rtStaminaDisplay = var4_11:Find("stamina")
	arg0_11.rtRole = arg0_11.uiContainer:Find("watch/Role")

	onButton(arg0_11, arg0_11.rtRole:Find("Talk"), function()
		local var0_38 = arg0_11:GetCurrentLadyEnv().ladyBaseZone
		local var1_38 = arg0_11.apartment:getFurnitureTalking(arg0_11.room:GetConfigID(), var0_38)

		if #var1_38 == 0 then
			pg.TipsMgr.GetInstance():ShowTips("without topic")

			return
		end

		arg0_11:DoTalk(var1_38[math.random(#var1_38)], function()
			local var0_39 = getDorm3dGameset("drom3d_favir_trigger_talk")[1]

			arg0_11:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_11.apartment.configId, var0_39)
		end)
	end, SFX_DORM_CLICK)
	setText(arg0_11.rtRole:Find("Talk/bg/Text"), i18n("dorm3d_talk"))
	onButton(arg0_11, arg0_11.rtRole:Find("Gift"), function()
		arg0_11:emit(arg0_11.SHOW_BLOCK)
		arg0_11:ActiveStateCamera("gift", function()
			arg0_11:emit(arg0_11.HIDE_BLOCK)
		end)
		arg0_11:emit(Dorm3dRoomMediator.OPEN_GIFT_LAYER, {
			groupId = arg0_11.apartment:GetConfigID(),
			baseCamera = arg0_11.mainCameraTF
		})
	end, SFX_DORM_CLICK)
	setText(arg0_11.rtRole:Find("Gift/bg/Text"), i18n("dorm3d_gift"))
	onButton(arg0_11, arg0_11.rtRole:Find("MiniGame"), function()
		assert(not arg0_11.nowMiniGameId)

		arg0_11.nowMiniGameId = arg0_11.room:getMiniGames()[1]

		local var0_42 = pg.dorm3d_minigame[arg0_11.nowMiniGameId]
		local var1_42 = arg0_11:GetCurrentLadyEnv()

		getProxy(Dorm3dChatProxy):TriggerEvent({
			{
				value = 1,
				event_type = arg0_11.contextData.timeIndex == 1 and 112 or 117,
				ship_id = arg0_11.apartment:GetConfigID()
			},
			{
				value = 1,
				event_type = 158,
				ship_id = arg0_11.apartment:GetConfigID()
			}
		})

		local var2_42 = {}

		table.insert(var2_42, function(arg0_43)
			arg0_11:SetAllBlackbloardValue("inLockLayer", true)
			arg0_11:TempHideUI(true, arg0_43)
		end)

		if var0_42.area ~= "" and var1_42.ladyBaseZone ~= var0_42.area then
			table.insert(var2_42, function(arg0_44)
				arg0_11:ShiftZone(var0_42.area, arg0_44)
			end)
		end

		local var3_42
		local var4_42

		if var0_42.action ~= "" then
			var3_42, var4_42 = unpack(var0_42.action)
		end

		table.insert(var2_42, function(arg0_45)
			parallelAsync({
				function(arg0_46)
					if var3_42 then
						arg0_11:PlaySingleAction(var1_42, var3_42, arg0_46)
					else
						arg0_46()
					end
				end,
				function(arg0_47)
					arg0_11:ActiveStateCamera("talk", arg0_47)
				end
			}, arg0_45)
		end)
		table.insert(var2_42, function(arg0_48)
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataMiniGame(1))
			arg0_11:HandleGameNotification(Dorm3dMiniGameMediator.OPERATION, {
				operationCode = "BEFORE_OPEN_GAME",
				miniGameId = arg0_11.nowMiniGameId
			})
			arg0_11:EnableMiniGameCutIn()
			arg0_11:emit(Dorm3dRoomMediator.OPEN_MINIGAME_WINDOW, {
				isDorm3d = true,
				minigameId = arg0_11.nowMiniGameId
			}, arg0_48)
		end)
		table.insert(var2_42, function(arg0_49)
			arg0_11:DisableMiniGameCutIn()

			if var4_42 then
				arg0_11:PlaySingleAction(var1_42, var4_42, arg0_49)
			else
				arg0_49()
			end
		end)
		seriesAsync(var2_42, function()
			arg0_11:SetAllBlackbloardValue("inLockLayer", false)
			arg0_11:TempHideUI(false)

			arg0_11.nowMiniGameId = nil
		end)
	end, SFX_DORM_CLICK)
	setText(arg0_11.rtRole:Find("MiniGame/bg/Text"), i18n("dorm3d_minigame_button1"))

	if not arg0_11.room:isPersonalRoom() then
		onButton(arg0_11, arg0_11.rtRole:Find("PublicGame"), switch(arg0_11.room.id, {
			[4] = function()
				return function()
					arg0_11:emit(Dorm3dRoomMediator.ENTER_VOLLEYBALL, arg0_11.apartment:GetConfigID())
				end
			end,
			[16] = function()
				return function()
					arg0_11:emit(Dorm3dRoomMediator.ENTER_DANCE, arg0_11.apartment:GetConfigID())
				end
			end,
			[26] = function()
				return function()
					arg0_11:emit(Dorm3dRoomMediator.ENTER_CARWASH, arg0_11.apartment:GetConfigID())
				end
			end
		}), SFX_DORM_CLICK)
		setText(arg0_11.rtRole:Find("PublicGame/bg/Text"), switch(arg0_11.room.id, {
			[4] = function()
				return i18n("dorm3d_volleyball_button")
			end,
			[16] = function()
				return i18n("dorm3d_dance_button")
			end,
			[26] = function()
				return i18n("dorm3d_carwash_button")
			end
		}))
	end

	onButton(arg0_11, arg0_11.rtRole:Find("Performance"), function()
		arg0_11:DoTalk(20500, function()
			pg.TipsMgr.GetInstance():ShowTips("Success!")
		end)
	end, SFX_DORM_CLICK)

	arg0_11.rtFloatPage = arg0_11._tf:Find("FloatPage")
	arg0_11.tplFloat = arg0_11.rtFloatPage:Find("tpl")

	setActive(arg0_11.tplFloat, false)

	local var5_11 = cloneTplTo(arg0_11.tplFloat, arg0_11.rtFloatPage, "lady")

	eachChild(var5_11, function(arg0_62)
		setActive(arg0_62, arg0_62.name == "walk")
	end)

	arg0_11._joystick = arg0_11._tf:Find("Stick")

	setActive(arg0_11._joystick, false)
	arg0_11._joystick:GetComponent(typeof(SlideController)):SetStickFunc(function(arg0_63)
		arg0_11:emit(arg0_11.ON_STICK_MOVE, arg0_63)
	end)

	arg0_11.povLayer = arg0_11._tf:Find("POVControl")

	setActive(arg0_11.povLayer, false)
	;(function()
		local var0_64 = arg0_11.povLayer:Find("Move"):GetComponent(typeof(SlideController))

		var0_64:AddBeginDragFunc(function(arg0_65, arg1_65)
			arg0_11:emit(arg0_11.ON_POV_STICK_MOVE_BEGIN, arg1_65)
		end)
		var0_64:SetStickFunc(function(arg0_66)
			arg0_11:emit(arg0_11.ON_POV_STICK_MOVE, arg0_66)
		end)
		var0_64:AddDragEndFunc(function(arg0_67, arg1_67)
			arg0_11:emit(arg0_11.ON_POV_STICK_MOVE_END, arg1_67)
		end)
		arg0_11.povLayer:Find("View"):GetComponent(typeof(SlideController)):SetStickFunc(function(arg0_68)
			arg0_11:emit(arg0_11.ON_POV_STICK_VIEW, arg0_68)
		end)
	end)()

	arg0_11.rtExtraScreen = arg0_11._tf:Find("ExtraScreen")
	arg0_11.rtTimelineScreen = arg0_11.rtExtraScreen:Find("TimelineScreen")

	onButton(arg0_11, arg0_11.rtTimelineScreen:Find("btn_skip"), function()
		existCall(arg0_11.timelineFinishCall)
	end, SFX_CANCEL)
	arg0_11:InitSubViews()

	arg0_11.uiStack = {}
	arg0_11.uiStore = {}
end

function var0_0.BindEvent(arg0_70)
	var0_0.super.BindEvent(arg0_70)
	arg0_70:bind(arg0_70.CLICK_CHARACTER, function(arg0_71, arg1_71)
		if arg0_70.uiState ~= "base" or not arg0_70.ladyDict[arg1_71].nowCanWatchState then
			return
		end

		local var0_71 = {}
		local var1_71 = arg0_70.ladyDict[arg1_71]

		if arg0_70:GetBlackboardValue(var1_71, "inPending") then
			table.insert(var0_71, function(arg0_72)
				arg0_70:OutOfPending(arg1_71, arg0_72)
			end)
		else
			table.insert(var0_71, function(arg0_73)
				arg0_70:OutOfLazy(arg1_71, arg0_73)
			end)
		end

		seriesAsync(var0_71, function()
			if not arg0_70.room:isPersonalRoom() then
				arg0_70:SetApartment(getProxy(ApartmentProxy):getApartment(arg1_71))
			end

			arg0_70:EnterWatchMode()
		end)
		pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_touch_v1")
	end)
	arg0_70:bind(arg0_70.CLICK_CONTACT, function(arg0_75, arg1_75)
		arg0_70:TriggerContact(arg1_75)
	end)
	arg0_70:bind(arg0_70.DISTANCE_TRIGGER, function(arg0_76, arg1_76, arg2_76)
		if arg0_70.uiState == "base" then
			arg0_70:CheckDistanceTalk(arg1_76, arg2_76)
		end
	end)
	arg0_70:bind(arg0_70.WALK_DISTANCE_TRIGGER, function(arg0_77, arg1_77, arg2_77)
		if arg0_70.apartment and arg0_70.apartment:GetConfigID() == arg1_77 then
			existCall(arg0_70.walkNearCallback, arg2_77)
		end
	end)
	arg0_70:bind(arg0_70.CHANGE_WATCH, function(arg0_78, arg1_78)
		arg0_70:ChangeCanWatchState(arg0_70.ladyDict[arg1_78])
	end)
	arg0_70:bind(arg0_70.ON_ENTER_SECTOR, function(arg0_79, arg1_79)
		arg0_70:ChangeCanWatchState(arg0_70.ladyDict[arg1_79])
	end)
	arg0_70:bind(arg0_70.ON_CHANGE_DISTANCE, function(arg0_80, arg1_80, arg2_80)
		arg0_70:ChangeCanWatchState(arg0_70.ladyDict[arg1_80])
	end)
end

function var0_0.didEnter(arg0_81)
	arg0_81.resumeCallback = arg0_81.contextData.resumeCallback
	arg0_81.contextData.resumeCallback = nil

	var0_0.super.didEnter(arg0_81)
	arg0_81:UpdateZoneList()
	arg0_81:SetUI(function()
		arg0_81:didEnterCheck()
	end, "base")
end

function var0_0.FinishEnterResume(arg0_83)
	if not arg0_83.resumeCallback then
		return
	end

	local var0_83 = arg0_83.resumeCallback

	arg0_83.resumeCallback = nil

	return var0_83()
end

function var0_0.EnableJoystick(arg0_84, arg1_84)
	setActive(arg0_84._joystick, arg1_84)
end

function var0_0.EnablePOVLayer(arg0_85, arg1_85)
	setActive(arg0_85.povLayer, arg1_85)

	if not arg1_85 then
		arg0_85:emit(arg0_85.ON_POV_STICK_MOVE_END)
	end
end

function var0_0.SetUIStore(arg0_86, arg1_86, ...)
	table.insertto(arg0_86.uiStore, {
		...
	})
	existCall(arg1_86)
end

function var0_0.SetUI(arg0_87, arg1_87, ...)
	warning("SetUI", ...)

	while rawget(arg0_87, "class") ~= var0_0 do
		arg0_87 = getmetatable(arg0_87).__index
	end

	table.insertto(arg0_87.uiStore, {
		...
	})

	for iter0_87, iter1_87 in ipairs(arg0_87.uiStore) do
		if iter1_87 == "back" then
			assert(#arg0_87.uiStack > 0)

			arg0_87.uiState = table.remove(arg0_87.uiStack)
		elseif iter1_87 == arg0_87.uiState and iter1_87 == "ik" then
			-- block empty
		else
			table.insert(arg0_87.uiStack, arg0_87.uiState)

			arg0_87.uiState = iter1_87
		end
	end

	pg.m02:sendNotification(var0_0.NOTIFY_UI_STATE, arg0_87.uiState)

	arg0_87.uiStore = {}

	eachChild(arg0_87.uiContainer, function(arg0_88)
		setActive(arg0_88, arg0_88.name == arg0_87.uiState)
	end)
	arg0_87:EnablePOVLayer(arg0_87.uiState == "base" or arg0_87.uiState == "walk")
	arg0_87:TempHideContact(arg0_87.uiState ~= "base")
	arg0_87:SetFloatEnable(arg0_87.uiState == "walk")
	setActive(arg0_87.rtFloatPage, arg0_87.uiState == "walk")

	if arg0_87.uiState ~= "stocking" then
		arg0_87.stockingView:Hide()
	end

	warning("SetUI to ", arg0_87.uiState)
	switch(arg0_87.uiState, {
		base = function()
			if not arg0_87.room:isPersonalRoom() then
				arg0_87:SetApartment(nil)
			end

			arg0_87:UpdateBtnState()
		end,
		watch = function()
			eachChild(arg0_87.rtRole, function(arg0_91)
				setActive(arg0_91, false)
			end)

			local var0_90 = underscore.filter({
				"Talk",
				"Touch",
				"Gift",
				"MiniGame",
				"PublicGame",
				"Performance"
			}, function(arg0_92)
				return arg0_87:CheckSystemOpen(arg0_92)
			end)
			local var1_90 = 0.05

			for iter0_90, iter1_90 in ipairs(var0_90) do
				LeanTween.delayedCall(var1_90, System.Action(function()
					setActive(arg0_87.rtRole:Find(iter1_90), true)

					if iter1_90 == "Touch" then
						local var0_93 = arg0_87.apartment:GetConfigID()

						arg0_87.rtRoleTouchSubView:Flush(arg0_87.room, var0_93, arg0_87.ladyDict[var0_93].ladyBaseZone)
					end
				end))

				var1_90 = var1_90 + 0.066
			end

			local var2_90 = arg0_87.apartment:GetConfigID()

			setActive(arg0_87.rtRole:Find("Gift/bg/Tip"), Dorm3dGift.NeedViewTip(var2_90) or getProxy(ApartmentProxy):HasShipGroupGiftExpireSoon(var2_90))
		end,
		ik = function()
			arg0_87:emit(Dorm3dIKView.RESET_ENTRY_MENU, arg0_87.room:isPersonalRoom() and not arg0_87.performanceInfo)
		end,
		walk = function()
			setText(arg0_87.uiContainer:Find("walk/dialogue/content"), i18n("dorm3d_removable", arg0_87.apartment:getConfig("name")))
		end,
		stocking = function()
			arg0_87.stockingView:Show()
		end
	})
	arg0_87:ActiveStateCamera(arg0_87.uiState, function()
		if arg1_87 then
			arg1_87()
		elseif arg0_87.uiState == "base" then
			arg0_87:CheckQueue()
		end
	end)
end

function var0_0.EnterWatchMode(arg0_98)
	local var0_98 = arg0_98.apartment:GetConfigID()

	seriesAsync({
		function(arg0_99)
			arg0_98:emit(arg0_98.SHOW_BLOCK)
			arg0_98:SetBlackboardValue(arg0_98.ladyDict[var0_98], "inWatchMode", true)
			arg0_98:SetUI(arg0_99, "watch")
		end,
		function(arg0_100)
			arg0_98:emit(arg0_98.HIDE_BLOCK)
		end
	})
end

function var0_0.ExitWatchMode(arg0_101)
	local var0_101 = arg0_101.apartment:GetConfigID()

	seriesAsync({
		function(arg0_102)
			arg0_101:emit(arg0_101.SHOW_BLOCK)
			arg0_101:SetUI(arg0_102, "back")
		end,
		function(arg0_103)
			arg0_101:SetBlackboardValue(arg0_101.ladyDict[var0_101], "inWatchMode", false)
			arg0_101:emit(arg0_101.HIDE_BLOCK)
			arg0_101:CheckQueue()
		end
	})
end

function var0_0.SetInPending(arg0_104, arg1_104, arg2_104)
	local var0_104 = arg0_104:GetBlackboardValue(arg1_104, "groupId")
	local var1_104 = pg.dorm3d_welcome[arg2_104]

	arg0_104:SetBlackboardValue(arg1_104, "inPending", true)
	arg0_104:ChangeCanWatchState(arg1_104)
	arg0_104:EnableHeadIK(arg1_104, false)

	arg0_104.contextData.ladyZone[var0_104] = var1_104.area

	arg1_104:SetZone(arg0_104.contextData.ladyZone[var0_104], var1_104.welcome_staypoint)
	arg0_104:ChangeCharacterPosition(arg1_104)

	if var1_104.item_shield ~= "" then
		arg0_104.hideItemDic = {}

		for iter0_104, iter1_104 in ipairs(var1_104.item_shield) do
			local var2_104 = arg0_104.modelRoot:Find(iter1_104)

			if not var2_104 then
				warning(string.format("welcome:%d without hide item:%s", arg2_104, iter1_104))
			else
				arg0_104.hideItemDic[iter1_104] = isActive(var2_104)

				setActive(var2_104, false)
			end
		end
	end

	onNextTick(function()
		if arg1_104.tfPendintItem then
			setActive(arg1_104.tfPendintItem, true)
		end

		arg0_104:SwitchAnim(arg1_104, var1_104.welcome_idle)
	end)

	arg0_104.wakeUpTalkId = var1_104.welcome_talk
end

function var0_0.SetOutPending(arg0_106, arg1_106)
	arg0_106:SetBlackboardValue(arg1_106, "inPending", false)
	arg0_106:ChangeCanWatchState(arg1_106)
	arg0_106:EnableHeadIK(arg1_106, true)

	arg0_106.wakeUpTalkId = nil

	if arg1_106.tfPendintItem then
		setActive(arg1_106.tfPendintItem, false)
	end

	if arg0_106.hideItemDic then
		for iter0_106, iter1_106 in pairs(arg0_106.hideItemDic) do
			setActive(arg0_106.modelRoot:Find(iter0_106), iter1_106)
		end

		arg0_106.hideItemDic = nil
	end
end

function var0_0.IsModeInHidePending(arg0_107, arg1_107)
	for iter0_107, iter1_107 in pairs(arg0_107.ladyDict) do
		if iter1_107.hideItemDic and iter1_107.hideItemDic[arg1_107] ~= nil then
			return true
		end
	end

	return false
end

function var0_0.EnterAccompanyMode(arg0_108, arg1_108)
	local var0_108 = pg.dorm3d_accompany[arg1_108]
	local var1_108
	local var2_108

	if var0_108.sceneInfo ~= "" then
		var1_108, var2_108 = unpack(string.split(var0_108.sceneInfo, "|"))
	end

	local var3_108 = {
		type = "timeline",
		name = var0_108.timeline,
		scene = var1_108,
		sceneRoot = var2_108,
		accompanys = {}
	}

	for iter0_108, iter1_108 in ipairs(var0_108.jump_trigger) do
		local var4_108, var5_108 = unpack(iter1_108)

		var3_108.accompanys[var4_108] = var5_108
	end

	local var6_108, var7_108 = unpack(var0_108.favor)

	getProxy(Dorm3dChatProxy):TriggerEvent({
		{
			value = 1,
			event_type = 161,
			ship_id = arg0_108.apartment:GetConfigID()
		}
	})
	getProxy(ApartmentProxy):RecordAccompanyTime()
	pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataAccompany(1, var0_108.ship_id, var0_108.performance_time, 0, var1_108 or arg0_108.dormSceneMgr.artSceneInfo))

	local var8_108 = {}

	table.insert(var8_108, function(arg0_109)
		arg0_108:SetUI(arg0_109, "blank", "accompany")
	end)
	table.insert(var8_108, function(arg0_110)
		arg0_108.accompanyFavorCount = 0
		arg0_108.accompanyFavorTimer = Timer.New(function()
			arg0_108.accompanyFavorCount = arg0_108.accompanyFavorCount + 1
		end, var6_108, -1)

		arg0_108.accompanyFavorTimer:Start()

		arg0_108.accompanyPerformanceTimer = Timer.New(function()
			arg0_108.canTriggerAccompanyPerformance = true
		end, var0_108.performance_time, -1)

		arg0_108.accompanyPerformanceTimer:Start()
		arg0_108:PlayTimeline(var3_108, function(arg0_113, arg1_113)
			arg1_113()
			arg0_110()
		end)
	end)
	seriesAsync(var8_108, function()
		assert(arg0_108.accompanyFavorTimer)
		arg0_108.accompanyFavorTimer:Stop()

		arg0_108.accompanyFavorTimer = nil

		assert(arg0_108.accompanyPerformanceTimer)
		arg0_108.accompanyPerformanceTimer:Stop()

		arg0_108.accompanyPerformanceTimer = nil
		arg0_108.canTriggerAccompanyPerformance = nil

		local var0_114 = math.min(arg0_108.accompanyFavorCount, getProxy(ApartmentProxy):getStamina())

		if var0_114 > 0 then
			local var1_114 = var7_108[var0_114]

			warning(var1_114)
			arg0_108:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_108.apartment.configId, var1_114)
		end

		local var2_114 = 0
		local var3_114 = getProxy(ApartmentProxy):GetAccompanyTime()

		if var3_114 then
			var2_114 = pg.TimeMgr.GetInstance():GetServerTime() - var3_114
		end

		pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataAccompany(2, var0_108.ship_id, var0_108.performance_time, var2_114, var1_108 or arg0_108.dormSceneMgr.artSceneInfo))
		arg0_108:SetUI(nil, "back", "back")
	end)
end

function var0_0.ExitAccompanyMode(arg0_115)
	existCall(arg0_115.timelineFinishCall)
end

function var0_0.EnterTouchPerformance(arg0_116)
	local var0_116 = arg0_116:GetCurrentLadyEnv()
	local var1_116 = arg0_116.room:getApartmentZoneConfig(var0_116.ladyBaseZone, "touch_performance", arg0_116.apartment:GetConfigID())

	if not var1_116 or var1_116 == 0 then
		arg0_116:emit(RoomTouchSystem.ENTER_TOUCH_MODE)
	else
		arg0_116:DoTalk(var1_116)
	end
end

function var0_0.ChangeWalkScene(arg0_117, arg1_117, arg2_117, arg3_117)
	local var0_117 = arg0_117:GetCurrentLadyEnv()

	seriesAsync({
		function(arg0_118)
			arg0_117:ChangeArtScene(arg2_117, arg0_118)
		end,
		function(arg0_119)
			arg0_117:ChangeSubScene(arg2_117, arg0_119)
		end,
		function(arg0_120)
			arg0_117:emit(arg0_117.SHOW_BLOCK)

			if arg1_117 == "back" then
				arg0_117:SetUI(arg0_120, "back")
			elseif arg1_117 == "change" and arg0_117.uiState ~= "walk" then
				arg0_117:SetUI(arg0_120, "walk")
			else
				arg0_120()
			end
		end
	}, function()
		arg0_117:emit(arg0_117.HIDE_BLOCK)
		arg0_117:SetBlackboardValue(var0_117, "inWalk", arg1_117 == "change")
		existCall(arg3_117)
	end)
end

function var0_0.EnterWalkMode(arg0_122)
	local var0_122 = arg0_122.apartment:GetConfigID()
	local var1_122 = arg0_122.ladyDict[var0_122]

	seriesAsync({
		function(arg0_123)
			arg0_122:emit(arg0_122.SHOW_BLOCK)
			arg0_122:HideCharacter(var0_122)
			arg0_122:SetBlackboardValue(var1_122, "inWalk", true)
			arg0_122:SetUI(arg0_123, "walk")
		end,
		function(arg0_124)
			arg0_122:emit(arg0_122.HIDE_BLOCK)
			arg0_122:ChangeArtScene(arg0_122.walkInfo.scene .. "|" .. arg0_122.walkInfo.sceneRoot, arg0_124)
		end,
		function(arg0_125)
			arg0_122:LoadSubScene(arg0_122.walkInfo, arg0_125)
		end
	}, function()
		return
	end)
end

function var0_0.ExitWalkMode(arg0_127)
	local var0_127 = arg0_127.apartment:GetConfigID()
	local var1_127 = arg0_127.ladyDict[var0_127]

	seriesAsync({
		function(arg0_128)
			arg0_127:RevertArtScene(arg0_127.walkLastSceneInfo, arg0_128)
		end,
		function(arg0_129)
			arg0_127:UnloadSubScene(arg0_127.walkInfo, arg0_129)
		end,
		function(arg0_130)
			arg0_127:emit(arg0_127.SHOW_BLOCK)
			arg0_127:SetUI(arg0_130, "back")
		end
	}, function()
		arg0_127:emit(arg0_127.HIDE_BLOCK)
		arg0_127:RevertCharacter(var0_127)
		arg0_127:SetBlackboardValue(var1_127, "inWalk", false)

		local var0_131 = arg0_127.walkExitCall

		arg0_127.walkExitCall = nil
		arg0_127.walkLastSceneInfo = nil
		arg0_127.walkInfo = nil

		existCall(var0_131)
	end)
end

function var0_0.EnableMiniGameCutIn(arg0_132)
	if not arg0_132.tfCutIn then
		return
	end

	local var0_132 = arg0_132.rtExtraScreen:Find("MiniGameCutIn")

	setActive(var0_132, true)

	local var1_132 = GetOrAddComponent(var0_132:Find("bg/mask/cut_in"), "CameraRTUI")

	setActive(var1_132, true)
	pg.CameraRTMgr.GetInstance():Bind(var1_132, arg0_132.tfCutIn:Find("TestCamera"):GetComponent(typeof(Camera)))
	quickPlayAnimator(arg0_132.modelCutIn.lady, "Idle")
	quickPlayAnimator(arg0_132.modelCutIn.player, "Idle")
	setActive(arg0_132.tfCutIn, true)
end

function var0_0.DisableMiniGameCutIn(arg0_133)
	if not arg0_133.tfCutIn then
		return
	end

	local var0_133 = arg0_133.rtExtraScreen:Find("MiniGameCutIn")
	local var1_133 = GetOrAddComponent(var0_133:Find("bg/mask/cut_in"), "CameraRTUI")

	pg.CameraRTMgr.GetInstance():Clean(var1_133)
	setActive(var0_133, false)
	setActive(arg0_133.tfCutIn, false)
end

function var0_0.DoTalk(arg0_134, arg1_134, arg2_134)
	while rawget(arg0_134, "class") ~= var0_0 do
		arg0_134 = getmetatable(arg0_134).__index
	end

	if arg0_134.apartment and arg0_134:GetBlackboardValue(arg0_134:GetCurrentLadyEnv(), "inTalking") then
		errorMsg("Talking block:" .. arg1_134)

		return
	end

	if not arg0_134.room:isPersonalRoom() then
		local var0_134 = pg.dorm3d_dialogue_group[arg1_134].char_id

		if arg0_134.apartment then
			assert(arg0_134.apartment:GetConfigID() == var0_134)
		else
			arg0_134:SetApartment(getProxy(ApartmentProxy):getApartment(var0_134))
		end
	end

	local var1_134 = arg0_134:GetCurrentLadyEnv()

	if arg1_134 == 10010 and not arg0_134.apartment.talkDic[arg1_134] then
		arg0_134.firstTimelineTouch = true
		arg0_134.firstMoveGuide = true
	end

	getProxy(Dorm3dChatProxy):TriggerEvent({
		{
			value = 1,
			event_type = arg0_134.contextData.timeIndex == 1 and 110 or 115,
			ship_id = arg0_134.apartment:GetConfigID()
		},
		{
			value = 1,
			event_type = 155,
			ship_id = arg0_134.apartment:GetConfigID()
		}
	})

	local var2_134 = {}

	if arg0_134:GetBlackboardValue(var1_134, "inPending") then
		table.insert(var2_134, function(arg0_135)
			arg0_134:OutOfLazy(arg0_134.apartment:GetConfigID(), arg0_135)
		end)
	end

	local var3_134 = pg.dorm3d_dialogue_group[arg1_134]
	local var4_134 = var3_134.performance_type == 1
	local var5_134

	table.insert(var2_134, function(arg0_136)
		arg0_134:emit(arg0_134.SHOW_BLOCK)
		arg0_134:SetBlackboardValue(var1_134, var4_134 and "inPerformance" or "inTalking", true)
		arg0_134:emit(Dorm3dRoomMediator.DO_TALK, arg1_134, function(arg0_137)
			var5_134 = arg0_137

			arg0_136()
		end)
	end)
	table.insert(var2_134, function(arg0_138)
		pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataDialog(arg0_134.apartment.configId, arg0_134.apartment.level, arg1_134, var3_134.type, arg0_134.room:getZoneConfig(arg0_134:GetCurrentLadyEnv().ladyBaseZone, "id"), var3_134.action_type, table.CastToString(var3_134.trigger_config), arg0_134.room:GetConfigID()))

		if pg.NewGuideMgr.GetInstance():IsBusy() then
			pg.NewGuideMgr.GetInstance():Pause()
		end

		arg0_134:SetUI(arg0_138, "blank")
	end)

	if var3_134.trigger_area and var3_134.trigger_area ~= "" then
		table.insert(var2_134, function(arg0_139)
			arg0_134:ShiftZone(var3_134.trigger_area, arg0_139)
		end)
	end

	if var3_134.performance_type == 0 then
		table.insert(var2_134, function(arg0_140)
			arg0_134:emit(arg0_134.HIDE_BLOCK)

			if arg0_134.contextData.isVideoTalk then
				arg0_134.videoPlayer:ExecuteAction("Play", var3_134.story, function()
					onDelayTick(arg0_140, 0.001)
				end)
			else
				pg.NewStoryMgr.GetInstance():ForceManualPlay(var3_134.story, function()
					onDelayTick(arg0_140, 0.001)
				end, true)
			end
		end)
	elseif var3_134.performance_type == 1 then
		table.insert(var2_134, function(arg0_143)
			arg0_134:emit(arg0_134.HIDE_BLOCK)
			arg0_134:PerformanceQueue(var3_134.story, arg0_143)
		end)
	else
		assert(false)
	end

	table.insert(var2_134, function(arg0_144)
		arg0_134:emit(arg0_134.SHOW_BLOCK)
		arg0_144()
	end)
	table.insert(var2_134, function(arg0_145)
		local var0_145 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(var3_134.story)

		if var0_145 then
			local var1_145 = "1"

			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataStory(var0_145, var1_145))
		end

		if var5_134 and #var5_134 > 0 then
			arg0_134:emit(Dorm3dRoomMediator.OPEN_DROP_LAYER, var5_134, arg0_145)
		else
			arg0_145()
		end
	end)
	table.insert(var2_134, function(arg0_146)
		if pg.NewGuideMgr.GetInstance():IsPause() then
			pg.NewGuideMgr.GetInstance():Resume()
		end

		arg0_134:emit(arg0_134.HIDE_BLOCK)

		if arg0_134.contextData.isVideoTalk then
			existCall(arg0_146)
		else
			arg0_134:SetBlackboardValue(var1_134, var4_134 and "inPerformance" or "inTalking", false)
			arg0_134:SetUI(arg0_146, "back")
		end
	end)
	seriesAsync(var2_134, function()
		if arg2_134 then
			return arg2_134()
		else
			arg0_134:CheckQueue()
		end
	end)
end

function var0_0.DoTalkTouchOption(arg0_148, arg1_148, arg2_148, arg3_148)
	local var0_148 = arg0_148.rtExtraScreen:Find("TalkTouchOption")
	local var1_148
	local var2_148 = var0_148:Find("content")

	UIItemList.StaticAlign(var2_148, var2_148:Find("clickTpl"), #arg1_148.options, function(arg0_149, arg1_149, arg2_149)
		arg1_149 = arg1_149 + 1

		if arg0_149 == UIItemList.EventUpdate then
			local var0_149 = arg1_148.options[arg1_149]

			setAnchoredPosition(arg2_149, NewPos(unpack(var0_149.pos)))
			onButton(arg0_148, arg2_149, function()
				var1_148(var0_149.flag)
			end, SFX_CONFIRM)
			setActive(arg2_149, not table.contains(arg2_148, var0_149.flag))
		end
	end)
	setActive(var0_148, true)

	function var1_148(arg0_151)
		setActive(var0_148, false)
		arg3_148(arg0_151)
	end
end

function var0_0.DoTimelineOption(arg0_152, arg1_152, arg2_152)
	local var0_152 = arg0_152.rtTimelineScreen:Find("TimelineOption")
	local var1_152
	local var2_152 = var0_152:Find("content")

	UIItemList.StaticAlign(var2_152, var2_152:Find("clickTpl"), #arg1_152, function(arg0_153, arg1_153, arg2_153)
		arg1_153 = arg1_153 + 1

		if arg0_153 == UIItemList.EventUpdate then
			local var0_153 = arg1_152[arg1_153]

			setText(arg2_153:Find("Text"), HXSet.hxLan(var0_153.content))
			onButton(arg0_152, arg2_153, function()
				var1_152(arg1_153)
			end, SFX_CONFIRM)
		end
	end)
	setActive(var0_152, true)

	function var1_152(arg0_155)
		setActive(var0_152, false)
		arg2_152(arg0_155)
	end
end

function var0_0.DoTimelineTouch(arg0_156, arg1_156, arg2_156)
	local var0_156 = arg0_156.rtTimelineScreen:Find("TimelineTouch")
	local var1_156
	local var2_156 = var0_156:Find("content")

	UIItemList.StaticAlign(var2_156, var2_156:Find("clickTpl"), #arg1_156, function(arg0_157, arg1_157, arg2_157)
		arg1_157 = arg1_157 + 1

		if arg0_157 == UIItemList.EventUpdate then
			local var0_157 = arg1_156[arg1_157]

			setAnchoredPosition(arg2_157, NewPos(unpack(var0_157.pos)))
			onButton(arg0_156, arg2_157, function()
				var1_156(arg1_157)
			end, SFX_CONFIRM)

			if arg0_156.firstTimelineTouch then
				arg0_156.firstTimelineTouch = nil

				setActive(arg2_157:Find("finger"), true)
			end
		end
	end)
	setActive(var0_156, true)

	function var1_156(arg0_159)
		setActive(var0_156, false)
		arg2_156(arg0_159)
	end
end

function var0_0.DoShortWait(arg0_160, arg1_160)
	local var0_160 = arg0_160.ladyDict[arg1_160]
	local var1_160 = getProxy(ApartmentProxy):getApartment(arg1_160)
	local var2_160 = arg0_160.room:getApartmentZoneConfig(var0_160.ladyBaseZone, "special_action", arg1_160)
	local var3_160 = var2_160 and var2_160[math.random(#var2_160)] or nil

	if not var3_160 then
		return
	end

	arg0_160:PlaySingleAction(var0_160, var3_160)
end

function var0_0.OutOfLazy(arg0_161, arg1_161, arg2_161)
	local var0_161 = arg0_161.ladyDict[arg1_161]
	local var1_161 = {}

	if arg0_161:GetBlackboardValue(var0_161, "inPending") then
		table.insert(var1_161, function(arg0_162)
			arg0_161.shiftLady = arg1_161

			arg0_161:ShiftZone(var0_161.ladyBaseZone, arg0_162)
		end)
	end

	seriesAsync(var1_161, arg2_161)
end

function var0_0.OutOfPending(arg0_163, arg1_163, arg2_163)
	assert(arg0_163.wakeUpTalkId)

	local var0_163 = arg0_163.wakeUpTalkId

	seriesAsync({
		function(arg0_164)
			arg0_163:SetUI(arg0_164, "blank")
		end,
		function(arg0_165)
			arg0_163.shiftLady = arg1_163

			local var0_165 = arg0_163.ladyDict[arg1_163]

			arg0_163:ShiftZone(var0_165.ladyBaseZone, arg0_165)
		end,
		function(arg0_166)
			arg0_163:DoTalk(var0_163, arg0_166)
		end
	}, function()
		arg0_163:SetUIStore(arg2_163, "back")
	end)
end

function var0_0.ChangeCanWatchState(arg0_168, arg1_168)
	local var0_168

	if arg0_168:GetBlackboardValue(arg1_168, "inPending") then
		var0_168 = tobool(arg0_168:GetBlackboardValue(arg1_168, "inDistance"))
	else
		local var1_168 = arg0_168:GetBlackboardValue(arg1_168, "groupId")

		var0_168 = tobool(arg0_168.activeLady[var1_168] and pg.NodeCanvasMgr.GetInstance():GetBlackboradValue("canWatch", arg1_168.ladyBlackboard))
	end

	if arg1_168.blockCanWatch then
		var0_168 = false
	end

	if (not arg1_168.nowCanWatchState or arg1_168.nowCanWatchState ~= var0_168) and arg1_168.ladyWatchFloat then
		arg1_168.nowCanWatchState = var0_168

		arg0_168:ShowOrHideCanWatchMark(arg1_168, arg1_168.nowCanWatchState)
	end
end

function var0_0.HandleGameNotification(arg0_169, arg1_169, arg2_169)
	local var0_169 = arg0_169:GetCurrentLadyEnv()

	switch(arg1_169, {
		[Dorm3dMiniGameMediator.OPERATION] = function()
			local var0_170 = arg2_169.miniGameId

			switch(arg2_169.miniGameId, {
				[67] = function()
					if arg2_169.operationCode == "GAME_HIT_AREA" then
						local var0_171 = {
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
						local var1_171, var2_171 = unpack(var0_171[arg2_169.index])

						arg0_169:PlayFaceAnim(var0_169, var1_171)

						if arg0_169.tfCutIn then
							quickPlayAnimator(arg0_169.modelCutIn.lady, var2_171)
							quickPlayAnimator(arg0_169.modelCutIn.player, var2_171)
						end
					elseif arg2_169.operationCode == "GAME_RESULT" then
						if arg2_169.win then
							arg0_169:PlayFaceAnim(var0_169, "Face_XYX_victory")
							arg0_169:PlaySingleAction(var0_169, "minigame_win")
						else
							arg0_169:PlayFaceAnim(var0_169, "Face_XYX_lose")
							arg0_169:PlaySingleAction(var0_169, "minigame_lose")
						end

						setActive(arg0_169.rtExtraScreen:Find("MiniGameCutIn"), false)
					end
				end,
				[70] = function()
					if arg2_169.operationCode == "GAME_READY" then
						arg0_169.cameras[var0_0.CAMERA.TALK].Follow = nil
						arg0_169.cameras[var0_0.CAMERA.TALK].LookAt = nil

						arg0_169:PlaySingleAction(var0_169, "shuohua_sikao")
					elseif arg2_169.operationCode == "ROUND_RESULT" then
						local var0_172

						if arg2_169.success then
							var0_172 = {
								"shuohua_wenhou",
								"shuohua_sikao"
							}
						else
							var0_172 = {
								"shuohua_yaotou",
								"shuohua_sikao"
							}
						end

						seriesAsync(underscore.map(var0_172, function(arg0_173)
							return function(arg0_174)
								arg0_169:PlaySingleAction(var0_169, arg0_173, arg0_174)
							end
						end), function()
							return
						end)
					elseif arg2_169.operationCode == "GAME_RESULT" then
						local var1_172 = arg0_169.cameras[var0_0.CAMERA.TALK].transform

						var1_172.position = var1_172.position + var1_172.right * 0.11

						local var2_172 = {
							"shuohua_gandong"
						}

						seriesAsync(underscore.map(var2_172, function(arg0_176)
							return function(arg0_177)
								arg0_169:PlaySingleAction(var0_169, arg0_176, arg0_177)
							end
						end), function()
							return
						end)
					end
				end,
				[75] = function()
					if arg2_169.operationCode == "BEFORE_OPEN_GAME" then
						arg0_169.cameras[var0_0.CAMERA.TALK].Follow = nil
						arg0_169.cameras[var0_0.CAMERA.TALK].LookAt = nil
					elseif arg2_169.operationCode == "GAME_RPS_RESULT" then
						if arg2_169.index == 1 then
							arg0_169:PlaySingleAction(var0_169, "ab_shuohua_lianxuyaotou_01")
							arg0_169:PlayFaceAnim(var0_169, "Face_weixiao")
						elseif arg2_169.index == 2 then
							arg0_169:PlaySingleAction(var0_169, "ab_shuohua_lianxudiantou_01")
							arg0_169:PlayFaceAnim(var0_169, "Face_kaixin")
						end
					elseif arg2_169.operationCode == "GAME_RESULT" then
						if not arg2_169.win then
							arg0_169:PlaySingleAction(var0_169, "ab_shuohua_taibangle_01")
						end

						arg0_169:PlayFaceAnim(var0_169, "Face_kaixin")
					end
				end
			}, function()
				warning("without miniGameId:" .. arg2_169.miniGameId)
			end)

			if arg2_169.operationCode == "BEFORE_OPEN_GAME" then
				local var1_170 = getProxy(PlayerProxy):getPlayerId()
				local var2_170 = 0

				if var0_170 == 67 or var0_170 == 70 then
					var2_170 = PlayerPrefs.GetInt("mg_new_score_" .. tostring(var1_170) .. "_" .. arg2_169.miniGameId, 0)
				else
					var2_170 = PlayerPrefs.GetInt("mg_score_" .. tostring(var1_170) .. "_" .. arg2_169.miniGameId, 0)
				end

				arg0_169.highScore = var2_170
			elseif arg2_169.operationCode == "GAME_RESULT" then
				local var3_170 = arg2_169.score
				local var4_170 = getProxy(PlayerProxy):getPlayerId()

				if var3_170 > arg0_169.highScore then
					if var0_170 == 67 or var0_170 == 70 then
						PlayerPrefs.SetInt("mg_new_score_" .. tostring(var4_170) .. "_" .. arg2_169.miniGameId, var3_170)
					end

					getProxy(Dorm3dChatProxy):TriggerEvent({
						{
							event_type = 159,
							value = var3_170,
							ship_id = arg0_169.apartment:GetConfigID()
						}
					})
				end

				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataMiniGame(2, arg2_169.score))
			elseif arg2_169.operationCode == "GAME_CLOSE" and arg2_169.doTrack == false then
				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataMiniGame(3))
			end
		end
	})
end

function var0_0.PerformanceQueue(arg0_181, arg1_181, arg2_181)
	local var0_181, var1_181 = pcall(function()
		return require("GameCfg.dorm." .. arg1_181)
	end)

	if not var0_181 then
		errorMsg("不存在表演ID对应的Lua:" .. arg1_181)
		existCall(arg2_181)

		return
	end

	warning(arg1_181)

	arg0_181.performanceInfo = {
		name = arg1_181
	}

	local var2_181 = {}

	table.insert(var2_181, function(arg0_183)
		arg0_181:SetUI(arg0_183, "blank")
	end)
	table.insertto(var2_181, underscore.map(var1_181, function(arg0_184)
		return switch(arg0_184.type, {
			function()
				return function(arg0_186)
					local var0_186 = unpack(arg0_184.params)

					arg0_181:DoTalk(var0_186, arg0_186, true)
				end
			end,
			function()
				return function(arg0_188)
					arg0_181:emit(RoomTouchSystem.SET_TOUCH_EXIT_CALL, arg0_188)
					arg0_181:emit(RoomTouchSystem.ENTER_TOUCH_MODE)
				end
			end,
			function()
				return function(arg0_190)
					local var0_190 = arg0_181:GetCurrentLadyEnv()

					arg0_181:PlaySingleAction(var0_190, arg0_184.name, arg0_190)
				end
			end,
			function()
				return function(arg0_192)
					arg0_181:emit(arg0_181.PLAY_EXPRESSION, arg0_184)
					arg0_192()
				end
			end,
			function()
				return function(arg0_194)
					arg0_181:ShiftZone(arg0_184.name, arg0_194)
				end
			end,
			function()
				return function(arg0_196)
					arg0_181.contextData.timeIndex = arg0_184.params[1]

					local var0_196 = arg0_184.params[2] or false

					if Dorm3dSceneMgr.IsSameSceneInfo(arg0_181.dormSceneMgr.artSceneInfo, arg0_181.dormSceneMgr.sceneInfo) then
						arg0_181:SwitchDayNight(arg0_181.contextData.timeIndex)

						if var0_196 then
							onNextTick(function()
								arg0_181:RefreshSlots()
							end)
						end
					end

					arg0_181:UpdateContactState()
					onNextTick(arg0_196)
				end
			end,
			function()
				return function(arg0_199)
					if arg0_184.name then
						arg0_181:ActiveCameraByName(arg0_184.name)
						existCall(arg0_199)
					else
						arg0_181:ActiveStateCamera(arg0_184.params[1], arg0_199)
					end
				end
			end,
			function()
				return function(arg0_201)
					if arg0_184.name == "base" then
						arg0_181:RevertArtScene(arg0_181.dormSceneMgr.sceneInfo, arg0_201)
					else
						local var0_201 = arg0_184.params.scene
						local var1_201 = arg0_184.params.sceneRoot

						arg0_181:ChangeArtScene(var0_201 .. "|" .. var1_201, arg0_201)
					end
				end
			end,
			function()
				return function(arg0_203)
					local var0_203 = arg0_184.params.name

					if arg0_184.name == "load" then
						local var1_203 = tobool(arg0_184.params.wait_timeline) and function(arg0_204)
							arg0_181.waitForTimeline = arg0_204
						end

						arg0_181:LoadTimelineScene(var0_203, true, var1_203, arg0_203)
					elseif arg0_184.name == "unload" then
						arg0_181:UnloadTimelineScene(var0_203, true, arg0_203)
					else
						assert(false)
					end
				end
			end,
			function()
				return function(arg0_206)
					setActive(arg0_181.uiContainer:Find("walk/btn_back"), false)

					local var0_206 = arg0_181:GetCurrentLadyEnv()

					if arg0_184.name == "change" then
						local var1_206 = arg0_184.params.scene
						local var2_206 = arg0_184.params.sceneRoot

						var0_206.walkBornPoint = arg0_184.params.point or "Default"

						arg0_181:ChangeWalkScene(arg0_184.name, var1_206 .. "|" .. var2_206, arg0_206)
					elseif arg0_184.name == "back" then
						var0_206.walkBornPoint = nil

						arg0_181:ChangeWalkScene(arg0_184.name, arg0_181.dormSceneMgr.sceneInfo, arg0_206)
					elseif arg0_184.name == "set" then
						local function var3_206()
							local var0_207 = arg0_206

							arg0_206 = nil

							return existCall(var0_207)
						end

						for iter0_206, iter1_206 in pairs(arg0_184.params) do
							switch(iter0_206, {
								back_button_trigger = function(arg0_208)
									onButton(arg0_181, arg0_181.uiContainer:Find("walk/btn_back"), var3_206, SFX_DORM_BACK)
									setActive(arg0_181.uiContainer:Find("walk/btn_back"), IsUnityEditor and arg0_208)
								end,
								near_trigger = function(arg0_209)
									if arg0_209 == true then
										arg0_209 = 1.5
									end

									if arg0_209 then
										function arg0_181.walkNearCallback(arg0_210)
											if arg0_210 < arg0_209 then
												arg0_181.walkNearCallback = nil

												var3_206()
											end
										end
									else
										arg0_181.walkNearCallback = nil
									end
								end
							}, nil, iter1_206)
						end

						if arg0_181.firstMoveGuide then
							setActive(arg0_181.povLayer:Find("Guide"), arg0_181.firstMoveGuide)

							arg0_181.firstMoveGuide = nil
						end
					else
						assert(false)
					end
				end
			end,
			function()
				return function(arg0_212)
					if arg0_184.name == "set" then
						local var0_212 = arg0_181:GetCurrentLadyEnv()

						arg0_181:emit(RoomIKSystem.SET_IK_CONFIG, var0_212, arg0_184.params.state)
						arg0_181:emit(Dorm3dIKView.SET_BACK_BUTTON_ACTIVE, not arg0_184.params.hide_back)
						arg0_181:emit(RoomIKSystem.SET_IK_SPECIAL_CALL, arg0_212)
						arg0_181:emit(RoomIKSystem.SET_IK_STATE, true)
					elseif arg0_184.name == "back" then
						local var1_212 = arg0_181:GetCurrentLadyEnv()

						var1_212.ikConfig = arg0_184.params

						arg0_181:emit(RoomIKSystem.SET_IK_STATE, false, function()
							var1_212.ikConfig = nil

							existCall(arg0_212)
						end)
					else
						assert(false)
					end
				end
			end,
			function()
				return function(arg0_215)
					arg0_181.blackSceneInfo = setmetatable(arg0_184.params or {}, {
						__index = {
							color = "#000000",
							time = 0.3,
							delay = arg0_184.name == "show" and 0 or 0.5
						}
					})

					if arg0_184.name == "show" then
						arg0_181:ShowBlackScreen(true, arg0_215)
					elseif arg0_184.name == "hide" then
						arg0_181:ShowBlackScreen(false, arg0_215)
					else
						assert(false)
					end

					arg0_181.blackSceneInfo = nil
				end
			end,
			function()
				return function(arg0_217)
					local var0_217 = arg0_181:GetCurrentLadyEnv()

					if arg0_184.name == "set" then
						arg0_181:emit(Dorm3dStockingMgr.SET_STOCKING_STATUS, arg0_184.params)
					elseif arg0_184.name == "exit" then
						arg0_181:emit(Dorm3dStockingMgr.EXIT_STOCKING_STATUS)
					end
				end
			end
		})
	end))
	table.insert(var2_181, function(arg0_218)
		arg0_181:SetUI(arg0_218, "back")

		arg0_181.performanceInfo = nil
	end)
	seriesAsync(var2_181, arg2_181)
end

function var0_0.TriggerContact(arg0_219, arg1_219)
	arg0_219:emit(Dorm3dRoomMediator.COLLECTION_ITEM, {
		itemId = arg1_219,
		roomId = arg0_219.room:GetConfigID(),
		groupId = arg0_219.room:isPersonalRoom() and arg0_219.apartment:GetConfigID() or 0
	})
end

function var0_0.UpdateContactState(arg0_220)
	arg0_220:SetContactStateDic(arg0_220.room:getTriggerableCollectItemDic(arg0_220.contextData.timeIndex))
end

function var0_0.UpdateFavorDisplay(arg0_221)
	local var0_221, var1_221 = getProxy(ApartmentProxy):getStamina()

	setText(arg0_221.rtStaminaDisplay:Find("Text"), string.format("%d/%d", var0_221, var1_221))
	setActive(arg0_221.rtStaminaDisplay, false)

	if arg0_221.apartment then
		setText(arg0_221.rtFavorLevel:Find("rank/Text"), arg0_221.apartment.level)

		local var2_221, var3_221 = arg0_221.apartment:getFavor()
		local var4_221 = arg0_221.apartment:isMaxFavor()

		setActive(arg0_221.rtFavorLevel:Find("Max"), var4_221)
		setActive(arg0_221.rtFavorLevel:Find("Text"), not var4_221)
		setText(arg0_221.rtFavorLevel:Find("Text"), string.format("<color=#ff6698>%d</color>/%d", var2_221, var3_221))
	end

	setActive(arg0_221.rtFavorLevel:Find("red"), Dorm3dLevelLayer.IsShowRed())
end

function var0_0.UpdateBtnState(arg0_222)
	local var0_222 = not arg0_222.room:isPersonalRoom() or arg0_222:CheckSystemOpen("Furniture")
	local var1_222 = Dorm3dFurniture.IsTimelimitShopTip(arg0_222.room:GetConfigID())

	setActive(arg0_222.uiContainer:Find("base/left/btn_furniture/tipTimelimit"), var0_222 and var1_222)

	local var2_222 = Dorm3dFurniture.NeedViewTip(arg0_222.room:GetConfigID())

	setActive(arg0_222.uiContainer:Find("base/left/btn_furniture/tip"), var0_222 and not var1_222 and var2_222)
	setActive(arg0_222.uiContainer:Find("base/btn_back/main"), underscore(getProxy(ApartmentProxy):getRawData()):chain():values():filter(function(arg0_223)
		return tobool(arg0_223)
	end):any(function(arg0_224)
		return #arg0_224:getSpecialTalking() > 0 or arg0_224:getIconTip() == "main"
	end):value())
	setActive(arg0_222.uiContainer:Find("base/left/btn_collection/tip"), PlayerPrefs.GetInt("apartment_collection_item", 0) > 0 or PlayerPrefs.GetInt("apartment_collection_recall", 0) > 0)
end

function var0_0.AddUnlockDisplay(arg0_225, arg1_225)
	table.insert(arg0_225.unlockList, arg1_225)

	if not isActive(arg0_225.rtFavorUp) then
		setText(arg0_225.rtFavorUp:Find("Text"), table.remove(arg0_225.unlockList, 1))
		setActive(arg0_225.rtFavorUp, true)
	end
end

function var0_0.PopFavorTrigger(arg0_226, arg1_226)
	local var0_226 = arg1_226.triggerId
	local var1_226 = arg1_226.delta
	local var2_226 = arg1_226.cost
	local var3_226 = arg1_226.apartment
	local var4_226 = pg.dorm3d_favor_trigger[var0_226]

	if var4_226.is_repeat == 0 then
		if var0_226 == getDorm3dGameset("drom3d_favir_trigger_onwer")[1] then
			arg0_226:AddUnlockDisplay(i18n("dorm3d_own_favor"))
		elseif var0_226 == getDorm3dGameset("drom3d_favir_trigger_propose")[1] then
			arg0_226:AddUnlockDisplay(i18n("dorm3d_pledge_favor"))
		else
			arg0_226:AddUnlockDisplay(string.format("unknow favor trigger:%d unlock", var0_226))
		end
	elseif arg1_226.delta > 0 then
		local var5_226, var6_226 = var3_226:getFavor()
		local var7_226 = var5_226 + var1_226

		setText(arg0_226.rtFavorUpDaily:Find("bg/Text"), string.format("<size=48>+%d</size>", math.min(9999, var1_226)))
		setSlider(arg0_226.rtFavorUpDaily:Find("bg/slider"), 0, var6_226, var5_226)
		setAnchoredPosition(arg0_226.rtFavorUpDaily:Find("bg"), arg1_226.isGift and NewPos(-354, 223) or NewPos(-208, 105))

		local var8_226 = {}
		local var9_226 = arg0_226.rtFavorUpDaily:Find("bg/effect")

		eachChild(var9_226, function(arg0_227)
			setActive(arg0_227, false)
		end)

		local var10_226

		if var4_226.effect and var4_226.effect ~= "" then
			var10_226 = var9_226:Find(var4_226.effect .. "(Clone)")

			if not var10_226 then
				table.insert(var8_226, function(arg0_228)
					LoadAndInstantiateAsync("Dorm3D/Effect/Prefab/ExpressionUI", "uifx_dorm3d_yinfu01", function(arg0_229)
						setParent(arg0_229, var9_226)

						var10_226 = tf(arg0_229)

						arg0_228()
					end)
				end)
			else
				setActive(var10_226, true)
			end
		end

		local var11_226 = arg0_226.rtFavorUpDaily:GetComponent("DftAniEvent")

		var11_226:SetTriggerEvent(function(arg0_230)
			local var0_230 = GetComponent(arg0_226.rtFavorUpDaily:Find("bg/slider"), typeof(Slider))

			LeanTween.value(var5_226, var7_226, 0.5):setOnUpdate(System.Action_float(function(arg0_231)
				var0_230.value = arg0_231
			end)):setEase(LeanTweenType.easeInOutQuad):setDelay(0.165):setOnComplete(System.Action(function()
				LeanTween.delayedCall(0.165, System.Action(function()
					if arg0_226.exited then
						return
					end

					quickPlayAnimator(arg0_226.rtFavorUpDaily, "favor_out")
				end))
			end))
			pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_progaress_bar")
		end)
		var11_226:SetEndEvent(function(arg0_234)
			setActive(arg0_226.rtFavorUpDaily, false)
		end)
		seriesAsync(var8_226, function()
			local var0_235 = arg0_226.ladyDict[var3_226:GetConfigID()]

			setLocalPosition(arg0_226.rtFavorUpDaily, arg0_226:GetLocalPosition(arg0_226:GetScreenPosition(var0_235.ladyHeadCenter.position), arg0_226.rtFavorUpDaily.parent))
			setActive(arg0_226.rtFavorUpDaily, true)
			SetCompomentEnabled(arg0_226.rtFavorUpDaily, typeof(Animator), true)
			quickPlayAnimator(arg0_226.rtFavorUpDaily, "favor_open")

			if var2_226 > 0 then
				local var1_235, var2_235 = getProxy(ApartmentProxy):getStamina()

				setText(arg0_226.rtStaminaPop:Find("Text/Text (1)"), "-" .. var2_226)
				setText(arg0_226.rtStaminaPop:Find("Text"), string.format("%d/%d", var1_235 + var2_226, var2_235))
				setActive(arg0_226.rtStaminaPop, true)
			end
		end)
	end
end

function var0_0.PopFavorLevelUp(arg0_236, arg1_236, arg2_236, arg3_236)
	arg0_236.isLock = true

	LeanTween.delayedCall(0.33, System.Action(function()
		arg0_236.isLock = false
	end))

	local var0_236 = math.floor(arg1_236.level / 10)
	local var1_236 = math.fmod(arg1_236.level, 10)

	GetImageSpriteFromAtlasAsync("ui/favor_atlas", var1_236, arg0_236.rtLevelUpWindow:Find("panel/bg/item1/mark/level/digit2"))
	GetImageSpriteFromAtlasAsync("ui/favor_atlas", var0_236, arg0_236.rtLevelUpWindow:Find("panel/bg/item1/mark/level/digit1"))
	setActive(arg0_236.rtLevelUpWindow:Find("panel/bg/item1/mark/level/digit1"), var0_236 > 0)

	local var2_236
	local var3_236

	arg0_236.clientAward, var3_236 = Dorm3dIconHelper.SplitStory(arg1_236:getFavorConfig("levelup_client_item", arg1_236.level))
	arg0_236.serverAward = arg2_236

	local var4_236 = arg0_236.rtLevelUpWindow:Find("panel/info/content/itemContent")

	if not arg0_236.levelItemList then
		arg0_236.levelItemList = UIItemList.New(var4_236, var4_236:Find("tpl"))

		arg0_236.levelItemList:make(function(arg0_238, arg1_238, arg2_238)
			local var0_238 = arg1_238 + 1

			if arg0_238 == UIItemList.EventUpdate then
				if arg1_238 < #arg0_236.serverAward then
					updateDorm3dIcon(arg2_238, arg0_236.serverAward[var0_238])
					onButton(arg0_236, arg2_238, function()
						arg0_236:emit(BaseUI.ON_NEW_DROP, {
							style = "dorm",
							drop = arg0_236.serverAward[var0_238]
						})
					end, SFX_PANEL)
				else
					Dorm3dIconHelper.UpdateDorm3dIcon(arg2_238, arg0_236.clientAward[var0_238 - #arg0_236.serverAward])
					onButton(arg0_236, arg2_238, function()
						arg0_236:emit(Dorm3dRoomMediator.ON_DROP_CLIENT, {
							data = arg0_236.clientAward[var0_238 - #arg0_236.serverAward]
						})
					end, SFX_PANEL)
				end
			end
		end)
	end

	arg0_236.levelItemList:align(#arg0_236.serverAward + #arg0_236.clientAward)
	setActive(arg0_236.rtLevelUpWindow, true)
	pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_upgrade")
	arg0_236:OverlayPanel(arg0_236.rtLevelUpWindow)

	function arg0_236.levelUpCallback()
		arg0_236.levelUpCallback = nil

		if var3_236 then
			arg0_236:PopNewStoryTip(var3_236)
		end

		existCall(arg3_236)
	end
end

function var0_0.PopNewStoryTip(arg0_242, arg1_242, arg2_242)
	local var0_242 = arg0_242.uiContainer:Find("base/top/story_tip")

	setActive(var0_242, true)
	LeanTween.delayedCall(1, System.Action(function()
		setActive(var0_242, false)
	end))
	setText(var0_242:Find("Text"), i18n("dorm3d_story_unlock_tip", pg.dorm3d_recall[arg1_242[2]].name))
	existCall(arg2_242)
end

function var0_0.UpdateZoneList(arg0_244)
	local var0_244

	if arg0_244.room:isPersonalRoom() then
		var0_244 = arg0_244:GetCurrentLadyEnv().ladyBaseZone
	else
		var0_244 = arg0_244:GetAttachedFurnitureName()
	end

	for iter0_244, iter1_244 in ipairs(arg0_244.zoneDatas) do
		if iter1_244:GetWatchCameraName() == var0_244 then
			setText(arg0_244.btnZone:Find("Text"), iter1_244:GetName())
			setTextColor(arg0_244.rtZoneList:GetChild(iter0_244 - 1):Find("Name"), Color.NewHex("5CCAFF"))
		else
			setTextColor(arg0_244.rtZoneList:GetChild(iter0_244 - 1):Find("Name"), Color.NewHex("FFFFFF99"))
		end
	end
end

function var0_0.TalkingEventHandle(arg0_245, arg1_245)
	local var0_245 = {}
	local var1_245 = {}
	local var2_245 = arg1_245.data

	if var2_245.op_list then
		for iter0_245, iter1_245 in ipairs(var2_245.op_list) do
			table.insert(var0_245, function(arg0_246)
				local function var0_246()
					local var0_247 = arg0_246

					arg0_246 = nil

					return existCall(var0_247)
				end

				switch(iter1_245.type, {
					action = function()
						local var0_248 = arg0_245:GetCurrentLadyEnv()

						arg0_245:PlaySingleAction(var0_248, iter1_245.name, var0_246)
					end,
					item_action = function()
						arg0_245:PlaySceneItemAnim(iter1_245.id, iter1_245.name)
						var0_246()
					end,
					extra_item_action = function()
						local var0_250 = arg0_245:GetCurrentLadyEnv().extraItems[iter1_245.name]

						warning(iter1_245.name)
						warning(var0_250.trans)

						if var0_250 then
							var0_250.trans:GetComponent(typeof(Animator)):PlayInFixedTime(iter1_245.param)
						end

						var0_246()
					end,
					timeline = function()
						local var0_251 = {}

						arg0_245:emit(RoomTouchSystem.GET_TOUCH_GAME_STATE, var0_251)

						if var0_251.inTouchGame then
							arg0_245:emit(RoomTouchSystem.UPDATE_TOUCH_PANEL, false)
						end

						arg0_245:PlayTimeline(iter1_245, function(arg0_252, arg1_252)
							arg0_245:emit(RoomTouchSystem.GET_TOUCH_GAME_STATE, var0_251)
							arg0_245:emit(RoomTouchSystem.UPDATE_TOUCH_PANEL, var0_251.inTouchGame)

							var1_245.notifiCallback = arg1_252

							var0_246()
						end)
					end,
					clickOption = function()
						arg0_245:DoTalkTouchOption(iter1_245, arg1_245.flags, function(arg0_254)
							var1_245.optionIndex = arg0_254

							var0_246()
						end)
					end,
					wait = function()
						arg0_245.LTs = arg0_245.LTs or {}

						table.insert(arg0_245.LTs, LeanTween.delayedCall(iter1_245.time, System.Action(var0_246)).uniqueId)
					end,
					expression = function()
						arg0_245:emit(arg0_245.PLAY_EXPRESSION, iter1_245)
						var0_246()
					end,
					blackscreen = function()
						arg0_245.LTs = arg0_245.LTs or {}

						arg0_245:ShowBlackScreen(true, function()
							table.insert(arg0_245.LTs, LeanTween.delayedCall(iter1_245.time, System.Action(function()
								arg0_245:ShowBlackScreen(false)
								var0_246()
							end)).uniqueId)
						end)
					end
				}, function()
					assert(false, "op type error:", iter1_245.type)
				end)

				if iter1_245.skip then
					var0_246()
				end
			end)
		end
	end

	seriesAsync(var0_245, function()
		if arg1_245.callbackData then
			arg0_245:emit(Dorm3dRoomMediator.TALKING_EVENT_FINISH, arg1_245.callbackData.name, var1_245)
		end
	end)
end

function var0_0.CheckQueue(arg0_262)
	if arg0_262.inGuide or arg0_262.uiState ~= "base" then
		return
	end

	if arg0_262.room:GetConfigID() == 1 and arg0_262:CheckGuide() then
		-- block empty
	elseif arg0_262.room:isPersonalRoom() and arg0_262:CheckLevelUp() then
		-- block empty
	elseif arg0_262.apartment and arg0_262:CheckEnterDeal() then
		-- block empty
	elseif arg0_262.apartment and arg0_262:CheckGiftExpireSoon() then
		-- block empty
	elseif arg0_262.apartment and arg0_262:CheckActiveTalk() then
		-- block empty
	elseif arg0_262.apartment then
		arg0_262:CheckFavorTrigger()
	end

	arg0_262.contextData.hasEnterCheck = true
end

function var0_0.didEnterCheck(arg0_263)
	local var0_263

	if arg0_263.contextData.specialId then
		var0_263 = arg0_263.contextData.specialId
		arg0_263.contextData.specialId = nil

		arg0_263:DoTalk(var0_263, function()
			arg0_263:closeView()
		end)

		if arg0_263.contextData.isVideoTalk then
			arg0_263.contextData.hasEnterCheck = true
		end
	elseif not arg0_263.contextData.hasEnterCheck and arg0_263.apartment then
		for iter0_263, iter1_263 in ipairs(arg0_263.apartment:getForceEnterTalking(arg0_263.room:GetConfigID())) do
			var0_263 = iter1_263

			arg0_263:DoTalk(iter1_263)

			break
		end
	end

	if var0_263 and pg.dorm3d_dialogue_group[var0_263].extend_loading > 0 then
		arg0_263.contextData.hasEnterCheck = true

		pg.SceneAnimMgr.GetInstance():RegisterDormNextCall(function()
			arg0_263:FinishEnterResume()
		end)
	else
		if arg0_263.apartment and arg0_263.contextData.pendingDic[arg0_263.apartment:GetConfigID()] then
			arg0_263.contextData.hasEnterCheck = true
		end

		for iter2_263, iter3_263 in pairs(arg0_263.contextData.pendingDic) do
			arg0_263:SetInPending(arg0_263.ladyDict[iter2_263], iter3_263)
		end

		arg0_263.contextData.pendingDic = {}

		arg0_263:FinishEnterResume()
		arg0_263:CheckQueue()
	end
end

function var0_0.CheckGuide(arg0_266)
	if arg0_266:GetBlackboardValue(arg0_266:GetCurrentLadyEnv(), "inPending") then
		return
	end

	if DORM_LOCK_GUIDE then
		return false
	end

	for iter0_266, iter1_266 in ipairs({
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
				return arg0_266:CheckSystemOpen("Furniture")
			end
		},
		{
			name = "DORM3D_GUIDE_07",
			active = function()
				return arg0_266:CheckSystemOpen("DayNight")
			end
		}
	}) do
		if not pg.NewStoryMgr.GetInstance():IsPlayed(iter1_266.name) and iter1_266.active() then
			arg0_266:SetAllBlackbloardValue("inGuide", true)

			local function var0_266()
				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(2, pg.NewStoryMgr.GetInstance():StoryName2StoryId(iter1_266.name)))
				arg0_266:SetAllBlackbloardValue("inGuide", false)
			end

			pg.m02:sendNotification(GAME.STORY_UPDATE, {
				storyId = iter1_266.name
			})
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(1, pg.NewStoryMgr.GetInstance():StoryName2StoryId(iter1_266.name)))
			pg.NewGuideMgr.GetInstance():Play(iter1_266.name, nil, var0_266, var0_266)

			return true
		end
	end

	return false
end

function var0_0.CheckGiftExpireSoon(arg0_272)
	if not arg0_272.room:isPersonalRoom() then
		return false
	end

	local var0_272 = getProxy(ApartmentProxy):GetShipGroupGiftExpireSoonTipIds(arg0_272.apartment:GetConfigID())

	if #var0_272 <= 0 then
		return false
	end

	_.each(var0_272, function(arg0_273)
		Dorm3dGift.SetExpireSoonTipFlag(arg0_273)
	end)

	local function var1_272()
		arg0_272:CheckQueue()
	end

	pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_MSGBOX, {
		title = i18n("dorm3d_gift_overtime_title"),
		contentText = i18n("dorm3d_gift_overtime"),
		btnList = {
			{
				type = pg.NewStyleMsgboxMgr.BUTTON_TYPE.confirm,
				name = i18n("msgbox_text_confirm"),
				func = var1_272,
				sound = SFX_CONFIRM
			}
		},
		onClose = var1_272
	})

	return true
end

function var0_0.CheckFavorTrigger(arg0_275)
	for iter0_275, iter1_275 in ipairs({
		{
			triggerId = getDorm3dGameset("drom3d_favir_trigger_onwer")[1],
			active = function()
				local var0_276 = getProxy(CollectionProxy):getShipGroup(arg0_275.apartment.configId)

				return tobool(var0_276)
			end
		},
		{
			triggerId = getDorm3dGameset("drom3d_favir_trigger_propose")[1],
			active = function()
				local var0_277 = getProxy(CollectionProxy):getShipGroup(arg0_275.apartment.configId)

				return var0_277 and var0_277.married > 0
			end
		}
	}) do
		if arg0_275.apartment.triggerCountDic[iter1_275.triggerId] == 0 and iter1_275.active() then
			arg0_275:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_275.apartment.configId, iter1_275.triggerId)
		end
	end
end

function var0_0.CheckEnterDeal(arg0_278)
	if arg0_278.contextData.hasEnterCheck then
		return false
	end

	local var0_278 = arg0_278.apartment:GetConfigID()
	local var1_278 = "dorm3d_enter_count_" .. var0_278
	local var2_278 = pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d")

	if PlayerPrefs.GetString("dorm3d_enter_count_day") ~= var2_278 then
		PlayerPrefs.SetString("dorm3d_enter_count_day", var2_278)
		PlayerPrefs.SetInt(var1_278, 1)
	else
		PlayerPrefs.SetInt(var1_278, PlayerPrefs.GetInt(var1_278, 0) + 1)
	end

	local var3_278 = arg0_278.apartment:getEnterTalking(arg0_278.room:GetConfigID())

	PlayerPrefs.SetString("DORM3D_DAILY_ENTER", pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d"))

	if #var3_278 > 0 then
		arg0_278:DoTalk(var3_278[math.random(#var3_278)])

		return true
	end
end

function var0_0.CheckActiveTalk(arg0_279)
	local var0_279 = arg0_279:GetCurrentLadyEnv()

	if arg0_279:GetBlackboardValue(var0_279, "inPending") then
		return false
	end

	local var1_279 = arg0_279.apartment:getZoneTalking(arg0_279.room:GetConfigID(), var0_279.ladyBaseZone)

	if #var1_279 > 0 then
		arg0_279:DoTalk(var1_279[1])

		return true
	else
		return false
	end
end

function var0_0.CheckDistanceTalk(arg0_280, arg1_280, arg2_280)
	local var0_280 = arg0_280.ladyDict[arg1_280].ladyBaseZone
	local var1_280 = getProxy(ApartmentProxy):getApartment(arg1_280)

	for iter0_280, iter1_280 in ipairs(var1_280:getDistanceTalking(arg0_280.room:GetConfigID(), var0_280)) do
		arg0_280:DoTalk(iter1_280)

		return
	end
end

function var0_0.CheckSystemOpen(arg0_281, arg1_281)
	if arg0_281.room:isPersonalRoom() then
		return switch(arg1_281, {
			Talk = function()
				local var0_282 = 1

				return var0_282 <= arg0_281.apartment.level, i18n("apartment_level_unenough", var0_282)
			end,
			Touch = function()
				local var0_283 = getDorm3dGameset("drom3d_touch_dialogue")[1]

				return var0_283 <= arg0_281.apartment.level, i18n("apartment_level_unenough", var0_283)
			end,
			Gift = function()
				local var0_284 = getDorm3dGameset("drom3d_gift_dialogue")[1]

				return var0_284 <= arg0_281.apartment.level, i18n("apartment_level_unenough", var0_284)
			end,
			PublicGame = function()
				return false
			end,
			Photo = function()
				local var0_286 = getDorm3dGameset("drom3d_photograph_unlock")[1]

				return var0_286 <= arg0_281.apartment.level, i18n("apartment_level_unenough", var0_286)
			end,
			Collection = function()
				local var0_287 = getDorm3dGameset("drom3d_recall_unlock")[1]

				return var0_287 <= arg0_281.apartment.level, i18n("apartment_level_unenough", var0_287)
			end,
			Furniture = function()
				local var0_288 = getDorm3dGameset("drom3d_furniture_unlock")[1]

				return var0_288 <= arg0_281.apartment.level, i18n("apartment_level_unenough", var0_288)
			end,
			DayNight = function()
				local var0_289 = getDorm3dGameset("drom3d_time_unlock")[1]

				return var0_289 <= arg0_281.apartment.level, i18n("apartment_level_unenough", var0_289)
			end,
			Accompany = function()
				local var0_290 = 1

				return var0_290 <= arg0_281.apartment.level, i18n("apartment_level_unenough", var0_290)
			end,
			MiniGame = function()
				local var0_291 = 1

				if var0_291 > arg0_281.apartment.level then
					return false, i18n("apartment_level_unenough", var0_291)
				elseif #arg0_281.room:getMiniGames() <= 0 then
					return false, "without minigame config in room:" .. arg0_281.room.configId
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
		return switch(arg1_281, {
			Gift = function()
				return false
			end,
			PublicGame = function()
				return true
			end,
			Furniture = function()
				local var0_297 = #arg0_281.room:GetFurnitures() > 0
				local var1_297 = #_.filter(arg0_281.room:GetFurnitureIDList() or {}, function(arg0_298)
					return Dorm3dFurniture.New({
						configId = arg0_298
					}):InShopTime()
				end) > 0

				return var0_297 or var1_297
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

function var0_0.CheckLevelUp(arg0_304)
	if arg0_304.apartment:canLevelUp() then
		arg0_304:emit(Dorm3dRoomMediator.FAVOR_LEVEL_UP, arg0_304.apartment.configId)

		return true
	end

	return false
end

function var0_0.EnterTouchMode(arg0_305, arg1_305)
	arg0_305:emit(RoomTouchSystem.ENTER_TOUCH_MODE, arg1_305)
end

function var0_0.ExitTouchMode(arg0_306)
	arg0_306:emit(RoomTouchSystem.EXIT_TOUCH_MODE)
end

function var0_0.ExitHeartbeatMode(arg0_307)
	arg0_307:emit(RoomTouchSystem.EXIT_HEARTBEAT_MODE)
end

function var0_0.SwitchIKConfig(arg0_308, arg1_308, arg2_308)
	arg0_308:emit(RoomIKSystem.SET_IK_CONFIG, arg1_308, arg2_308)
end

function var0_0.SetIKState(arg0_309, arg1_309, arg2_309, arg3_309)
	arg0_309:emit(RoomIKSystem.SET_IK_STATE, arg1_309, arg2_309, arg3_309)
end

function var0_0.TouchModeAction(arg0_310, arg1_310, arg2_310, arg3_310, ...)
	local var0_310 = arg0_310:GetExtraSystem(RoomTouchSystem)

	assert(var0_310, "RoomTouchSystem not found")

	return var0_310:TouchModeAction(arg1_310, arg2_310, arg3_310, ...)
end

function var0_0.OnTriggerIK(arg0_311, arg1_311)
	local var0_311 = arg0_311:GetExtraSystem(RoomIKSystem)

	assert(var0_311, "RoomIKSystem not found")

	return var0_311:OnTriggerIK(arg1_311)
end

function var0_0.UpdateTouchGameDisplay(arg0_312)
	local var0_312 = arg0_312:GetExtraSystem(RoomTouchSystem)

	if not var0_312 then
		return
	end

	arg0_312:emit(RoomTouchSystem.UPDATE_TOUCH_LEVEL, var0_312.touchLevel)
end

function var0_0.UpdateTouchCount(arg0_313, arg1_313)
	local var0_313 = arg0_313:GetExtraSystem(RoomTouchSystem)

	assert(var0_313, "RoomTouchSystem not found")

	return var0_313:UpdateTouchCount(arg1_313)
end

function var0_0.DoTouch(arg0_314, arg1_314, arg2_314)
	local var0_314 = arg0_314:GetExtraSystem(RoomTouchSystem)

	assert(var0_314, "RoomTouchSystem not found")

	return var0_314:DoTouch(arg1_314, arg2_314)
end

function var0_0.CycleIKCameraGroup(arg0_315)
	arg0_315:emit(RoomIKSystem.CYCLE_IK_CAMERA_GROUP)
end

function var0_0.TempHideUI(arg0_316, arg1_316, arg2_316)
	local var0_316 = defaultValue(arg0_316.hideCount, 0)

	arg0_316.hideCount = var0_316 + (arg1_316 and 1 or -1)

	assert(arg0_316.hideCount >= 0)

	if arg0_316.hideCount * var0_316 > 0 then
		return existCall(arg2_316)
	elseif arg0_316.hideCount > 0 then
		arg0_316:SetUI(arg2_316, "blank")
	else
		arg0_316:SetUI(arg2_316, "back")
	end
end

function var0_0.onBackPressed(arg0_317)
	if arg0_317.exited or arg0_317.retainCount > 0 then
		-- block empty
	elseif isActive(arg0_317.rtLevelUpWindow) then
		triggerButton(arg0_317.rtLevelUpWindow:Find("bg"))
	elseif arg0_317.uiState ~= "base" then
		-- block empty
	else
		arg0_317:closeView()
	end
end

function var0_0.willExit(arg0_318)
	if arg0_318.LTs then
		underscore.map(arg0_318.LTs, function(arg0_319)
			LeanTween.cancel(arg0_319)
		end)

		arg0_318.LTs = nil
	end

	for iter0_318, iter1_318 in pairs(arg0_318.ladyDict) do
		iter1_318.wakeUpTalkId = nil
	end

	if arg0_318.accompanyFavorTimer then
		arg0_318.accompanyFavorTimer:Stop()

		arg0_318.accompanyFavorTimer = nil
	end

	if arg0_318.accompanyPerformanceTimer then
		arg0_318.accompanyPerformanceTimer:Stop()

		arg0_318.accompanyPerformanceTimer = nil
	end

	arg0_318.canTriggerAccompanyPerformance = nil

	arg0_318.videoPlayer:Destroy()

	if arg0_318.ikView then
		arg0_318.ikView:Dispose()

		arg0_318.ikView = nil
	end

	if arg0_318.touchView then
		arg0_318.touchView:Dispose()

		arg0_318.touchView = nil
	end

	var0_0.super.willExit(arg0_318)
end

return var0_0
