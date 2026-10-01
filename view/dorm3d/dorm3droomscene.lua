local var0_0 = class("Dorm3dRoomScene", import("view.dorm3d.Dorm3dRoomTemplateScene"))

var0_0.NOTIFY_UI_STATE = "Dorm3dRoomScene.NOTIFY_UI_STATE"
var0_0.EXTRA_SET_UI = "Dorm3dRoomScene.EXTRA_SET_UI"
var0_0.EXTRA_DO_TALK = "Dorm3dRoomScene.EXTRA_DO_TALK"

function var0_0.getUIName(arg0_1)
	return "Dorm3dMainUI"
end

function var0_0.SetApartment(arg0_2, arg1_2)
	arg0_2.apartment = arg1_2

	arg0_2:UpdateFavorDisplay()
end

function var0_0.InitSubViews(arg0_3)
	arg0_3.videoPlayer = VoiceChatLoader.New(arg0_3._tf)
	arg0_3.stockingView = Dorm3dStockingView.New(arg0_3._tf, arg0_3.event, setmetatable({}, {
		__index = arg0_3.contextData
	}))
	arg0_3.rtRoleTouchSubView = Dorm3dRTRoleTouchSubView.New(arg0_3.rtRole:Find("Touch"), arg0_3.event, setmetatable({
		onClick = function(arg0_4)
			arg0_3:emit(RoomTouchSystem.ENTER_TOUCH_MODE, arg0_4)
		end
	}, {
		__index = arg0_3.contextData
	}))
	arg0_3.aimIKView = Dorm3dAimIKView.New(arg0_3._tf:Find("AimIKControl"), arg0_3.event, setmetatable({}, {
		__index = arg0_3.contextData
	}))
	arg0_3.ikView = Dorm3dIKView.New(arg0_3._tf, arg0_3.event, {
		GetApartment = function()
			return arg0_3.apartment
		end,
		GetCurrentLadyEnv = function()
			return arg0_3:GetCurrentLadyEnv()
		end,
		GetSceneItem = function(arg0_7)
			return arg0_3:GetSceneItem(arg0_7)
		end,
		GetScreenPosition = function(arg0_8, arg1_8)
			return arg0_3:GetScreenPosition(arg0_8, arg1_8)
		end,
		GetLocalPosition = function(arg0_9, arg1_9)
			return arg0_3:GetLocalPosition(arg0_9, arg1_9)
		end
	})
	arg0_3.touchView = Dorm3dTouchView.New(arg0_3._tf, arg0_3.event, {})
end

function var0_0.init(arg0_10)
	var0_0.super.init(arg0_10)
	Shader.SetGlobalFloat("_ScreenClipOff", 1)

	arg0_10.pendingStateDic = {}
	arg0_10.uiContainer = arg0_10._tf:Find("UI")

	local var0_10 = arg0_10.uiContainer:Find("base")

	onButton(arg0_10, var0_10:Find("btn_back"), function()
		arg0_10:emit(BaseUI.ON_BACK)
	end, SFX_DORM_BACK)
	onButton(arg0_10, var0_10:Find("btn_back/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_dorm3d_info.tip
		})
	end, SFX_PANEL)

	arg0_10.rtFavorLevel = var0_10:Find("top/favor_level")

	setActive(arg0_10.rtFavorLevel, arg0_10.room:isPersonalRoom())
	onButton(arg0_10, arg0_10.rtFavorLevel, function()
		local var0_13 = {}

		arg0_10:emit(Dorm3dRoomMediator.OPEN_LEVEL_LAYER, {
			apartment = arg0_10.apartment,
			timeIndex = arg0_10.contextData.timeIndex,
			baseCamera = arg0_10.mainCameraTF,
			roomId = arg0_10.room:GetConfigID()
		})
	end, SFX_PANEL)
	onButton(arg0_10, var0_10:Find("top/setting"), function()
		arg0_10:emit(Dorm3dRoomMediator.OPEN_SETTING_LAYER)
	end)
	onButton(arg0_10, var0_10:Find("left/btn_photograph"), function()
		if #arg0_10.contextData.groupIds == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_photo_no_role"))

			return
		end

		local var0_15, var1_15 = arg0_10:CheckSystemOpen("Photo")

		if not var0_15 then
			pg.TipsMgr.GetInstance():ShowTips(var1_15)

			return
		end

		if not arg0_10.apartment then
			local var2_15 = arg0_10.contextData.groupIds[1]

			for iter0_15 in pairs(arg0_10.ladyDict) do
				if arg0_10:GetLadyBaseZone(iter0_15) == arg0_10:GetCurrentZoneNodeName() then
					var2_15 = iter0_15

					break
				end
			end

			arg0_10:SetApartment(getProxy(ApartmentProxy):getApartment(var2_15))
		end

		getProxy(Dorm3dChatProxy):TriggerEvent({
			{
				value = 1,
				event_type = arg0_10.contextData.timeIndex == 1 and 114 or 119,
				ship_id = arg0_10.apartment:GetConfigID()
			}
		})
		arg0_10:OutOfLazy(arg0_10.apartment:GetConfigID(), function()
			arg0_10:emit(Dorm3dRoomMediator.OPEN_CAMERA_LAYER, arg0_10, arg0_10.apartment:GetConfigID())
		end)
	end, SFX_PANEL)
	onButton(arg0_10, var0_10:Find("left/btn_collection"), function()
		local var0_17, var1_17 = arg0_10:CheckSystemOpen("Collection")

		if not var0_17 then
			pg.TipsMgr.GetInstance():ShowTips(var1_17)

			return
		end

		setActive(var0_10:Find("left/btn_collection/tip"), false)
		PlayerPrefs.SetInt("apartment_collection_item", 0)
		PlayerPrefs.SetInt("apartment_collection_recall", 0)
		arg0_10:emit(Dorm3dRoomMediator.OPEN_COLLECTION_LAYER, arg0_10.room:GetConfigID())
	end, SFX_PANEL)
	onButton(arg0_10, var0_10:Find("left/btn_furniture"), function()
		local var0_18, var1_18 = arg0_10:CheckSystemOpen("Furniture")

		if not var0_18 then
			pg.TipsMgr.GetInstance():ShowTips(var1_18)

			return
		end

		arg0_10:RemoveExtraSystem({
			SlideExtraSystem
		})
		arg0_10:emit(Dorm3dRoomMediator.OPEN_FURNITURE_SELECT, {
			apartment = arg0_10.apartment
		})

		arg0_10.isInFurnitureSelect = true
	end, SFX_PANEL)

	if not arg0_10.room:isPersonalRoom() then
		local var1_10 = arg0_10:CheckSystemOpen("Furniture")

		setActive(var0_10:Find("left/line_furniture"), var1_10)
		setActive(var0_10:Find("left/btn_furniture"), var1_10)
	end

	onButton(arg0_10, var0_10:Find("left/btn_accompany"), function()
		local var0_19, var1_19 = arg0_10:CheckSystemOpen("Accompany")

		if not var0_19 then
			pg.TipsMgr.GetInstance():ShowTips(var1_19)

			return
		end

		local var2_19 = arg0_10.apartment:GetConfigID()
		local var3_19

		arg0_10:emit(Dorm3dRoomMediator.OPEN_ACCOMPANY_WINDOW, {
			groupId = var2_19,
			confirmFunc = function(arg0_20)
				var3_19 = arg0_20
			end
		}, function()
			if var3_19 then
				arg0_10:OutOfLazy(var2_19, function()
					arg0_10:EnterAccompanyMode(var3_19)
				end)
			else
				arg0_10:CheckQueue()
			end
		end)
	end, SFX_PANEL)

	if not arg0_10.room:isPersonalRoom() then
		setActive(var0_10:Find("left/line_accompany"), false)
		setActive(var0_10:Find("left/btn_accompany"), false)
	end

	onButton(arg0_10, var0_10:Find("left/btn_skin"), function()
		arg0_10:ActiveCamera(arg0_10.cameras[var0_0.CAMERA.SKIN])
		arg0_10:emit(Dorm3dRoomMediator.OPEN_SKIN_SELECT_LAYER, arg0_10.apartment:GetConfigID(), arg0_10:GetCurrentLadyEnv(), nil, function()
			arg0_10:ChangePlayerPosition()
			arg0_10:ActiveCamera(arg0_10.cameras[var0_0.CAMERA.POV])
		end, false)
	end)

	if not arg0_10.room:isPersonalRoom() then
		setActive(var0_10:Find("left/line_skin"), false)
		setActive(var0_10:Find("left/btn_skin"), false)
	end

	onButton(arg0_10, var0_10:Find("left/btn_invite"), function()
		arg0_10:emit(Dorm3dRoomMediator.OPEN_INVITE_WINDOW, arg0_10.room:GetConfigID(), underscore.to_array(arg0_10.contextData.groupIds))
	end, SFX_PANEL)

	if arg0_10.room:isPersonalRoom() then
		setActive(var0_10:Find("left/line_invite"), false)
		setActive(var0_10:Find("left/btn_invite"), false)
	end

	arg0_10.btnZone = var0_10:Find("right/Zone")
	arg0_10.rtZoneList = var0_10:Find("right/Zone/List")

	setActive(arg0_10.rtZoneList, false)
	onButton(arg0_10, arg0_10.btnZone, function()
		setActive(arg0_10.rtZoneList, not isActive(arg0_10.rtZoneList))
	end, SFX_PANEL)
	UIItemList.StaticAlign(arg0_10.rtZoneList, arg0_10.rtZoneList:GetChild(0), #arg0_10.zoneDatas, function(arg0_27, arg1_27, arg2_27)
		if arg0_27 ~= UIItemList.EventUpdate then
			return
		end

		arg1_27 = arg1_27 + 1

		local var0_27 = arg0_10.zoneDatas[arg1_27]
		local var1_27 = var0_27:GetWatchCameraName()

		arg2_27.name = var1_27

		setText(arg2_27:Find("Name"), var0_27:GetName())
		setActive(arg2_27:Find("Line"), arg1_27 < #arg0_10.zoneDatas)
		onButton(arg0_10, arg2_27, function()
			if arg0_10.uiState ~= "base" then
				return
			end

			setActive(arg0_10.rtZoneList, false)
			arg0_10:ShiftZoneSafe(var1_27)
		end, SFX_PANEL)
	end)

	local var2_10 = arg0_10.uiContainer:Find("accompany")

	onButton(arg0_10, var2_10:Find("btn_back"), function()
		arg0_10:ExitAccompanyMode()
	end, SFX_DORM_BACK)

	arg0_10.unlockList = {}
	arg0_10.rtFavorUp = arg0_10._tf:Find("Toast/favor_up")

	arg0_10.rtFavorUp:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_30)
		setActive(arg0_10.rtFavorUp, false)

		if #arg0_10.unlockList > 0 then
			setText(arg0_10.rtFavorUp:Find("Text"), table.remove(arg0_10.unlockList, 1))
			setActive(arg0_10.rtFavorUp, true)
		end
	end)
	setActive(arg0_10.rtFavorUp, false)

	arg0_10.rtFavorUpDaily = arg0_10._tf:Find("Toast/favor_up_daily")

	setActive(arg0_10.rtFavorUpDaily, false)

	arg0_10.rtStaminaPop = arg0_10._tf:Find("Toast/stamina")

	local var3_10 = arg0_10.rtStaminaPop:GetComponent("DftAniEvent")

	var3_10:SetTriggerEvent(function(arg0_31)
		local var0_31, var1_31 = getProxy(ApartmentProxy):getStamina()

		setText(arg0_10.rtStaminaPop:Find("Text"), string.format("%d/%d", var0_31, var1_31))
	end)
	var3_10:SetEndEvent(function(arg0_32)
		setActive(arg0_10.rtStaminaPop, false)
	end)
	setActive(arg0_10.rtStaminaPop, false)

	arg0_10.rtLevelUpWindow = arg0_10._tf:Find("LevelUpWindow")

	setActive(arg0_10.rtLevelUpWindow, false)
	onButton(arg0_10, arg0_10.rtLevelUpWindow:Find("bg"), function()
		if arg0_10.isLock then
			return
		end

		arg0_10.isLock = true

		quickPlayAnimation(arg0_10.rtLevelUpWindow, "anim_dorm3d_levelup_out")
		LeanTween.delayedCall(0.2, System.Action(function()
			arg0_10.isLock = false

			setActive(arg0_10.rtLevelUpWindow, false)
			arg0_10:UnOverlayPanel(arg0_10.rtLevelUpWindow, arg0_10._tf)
			existCall(arg0_10.levelUpCallback)
		end))
	end, SFX_PANEL)

	local var4_10 = arg0_10.uiContainer:Find("watch")

	onButton(arg0_10, var4_10:Find("btn_back"), function()
		arg0_10:ExitWatchMode()
	end, SFX_DORM_BACK)
	onButton(arg0_10, var4_10:Find("btn_back/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("roll_gametip")
		})
	end, SFX_PANEL)

	arg0_10.rtStaminaDisplay = var4_10:Find("stamina")
	arg0_10.rtRole = arg0_10.uiContainer:Find("watch/Role")

	onButton(arg0_10, arg0_10.rtRole:Find("Talk"), function()
		local var0_37 = arg0_10:GetLadyBaseZone(arg0_10.apartment:GetConfigID())
		local var1_37 = arg0_10.apartment:getFurnitureTalking(arg0_10.room:GetConfigID(), var0_37)

		if #var1_37 == 0 then
			pg.TipsMgr.GetInstance():ShowTips("without topic")

			return
		end

		arg0_10:DoTalk(var1_37[math.random(#var1_37)], function()
			local var0_38 = getDorm3dGameset("drom3d_favir_trigger_talk")[1]

			arg0_10:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_10.apartment.configId, var0_38)
		end)
	end, SFX_DORM_CLICK)
	setText(arg0_10.rtRole:Find("Talk/bg/Text"), i18n("dorm3d_talk"))
	onButton(arg0_10, arg0_10.rtRole:Find("Gift"), function()
		arg0_10:emit(arg0_10.SHOW_BLOCK)
		arg0_10:ActiveStateCamera("gift", function()
			arg0_10:emit(arg0_10.HIDE_BLOCK)
		end)
		arg0_10:emit(Dorm3dRoomMediator.OPEN_GIFT_LAYER, {
			groupId = arg0_10.apartment:GetConfigID(),
			baseCamera = arg0_10.mainCameraTF
		})
	end, SFX_DORM_CLICK)
	setText(arg0_10.rtRole:Find("Gift/bg/Text"), i18n("dorm3d_gift"))
	onButton(arg0_10, arg0_10.rtRole:Find("MiniGame"), function()
		assert(not arg0_10.nowMiniGameId)

		arg0_10.nowMiniGameId = arg0_10.room:getMiniGames()[1]

		local var0_41 = pg.dorm3d_minigame[arg0_10.nowMiniGameId]
		local var1_41 = arg0_10:GetCurrentLadyEnv()

		getProxy(Dorm3dChatProxy):TriggerEvent({
			{
				value = 1,
				event_type = arg0_10.contextData.timeIndex == 1 and 112 or 117,
				ship_id = arg0_10.apartment:GetConfigID()
			},
			{
				value = 1,
				event_type = 158,
				ship_id = arg0_10.apartment:GetConfigID()
			}
		})

		local var2_41 = {}

		table.insert(var2_41, function(arg0_42)
			arg0_10:SetAllBlackbloardValue("inLockLayer", true)
			arg0_10:TempHideUI(true, arg0_42)
		end)

		if var0_41.area ~= "" and arg0_10:GetLadyBaseZone(arg0_10.apartment:GetConfigID()) ~= var0_41.area then
			table.insert(var2_41, function(arg0_43)
				arg0_10:ShiftZone(var0_41.area, arg0_43)
			end)
		end

		local var3_41
		local var4_41

		if var0_41.action ~= "" then
			var3_41, var4_41 = unpack(var0_41.action)
		end

		table.insert(var2_41, function(arg0_44)
			parallelAsync({
				function(arg0_45)
					if var3_41 then
						arg0_10:PlaySingleAction(var1_41, var3_41, arg0_45)
					else
						arg0_45()
					end
				end,
				function(arg0_46)
					arg0_10:ActiveStateCamera("talk", arg0_46)
				end
			}, arg0_44)
		end)
		table.insert(var2_41, function(arg0_47)
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataMiniGame(1))
			arg0_10:HandleGameNotification(Dorm3dMiniGameMediator.OPERATION, {
				operationCode = "BEFORE_OPEN_GAME",
				miniGameId = arg0_10.nowMiniGameId
			})
			arg0_10:EnableMiniGameCutIn()
			arg0_10:emit(Dorm3dRoomMediator.OPEN_MINIGAME_WINDOW, {
				isDorm3d = true,
				minigameId = arg0_10.nowMiniGameId
			}, arg0_47)
		end)
		table.insert(var2_41, function(arg0_48)
			arg0_10:DisableMiniGameCutIn()

			if var4_41 then
				arg0_10:PlaySingleAction(var1_41, var4_41, arg0_48)
			else
				arg0_48()
			end
		end)
		seriesAsync(var2_41, function()
			arg0_10:SetAllBlackbloardValue("inLockLayer", false)
			arg0_10:TempHideUI(false)

			arg0_10.nowMiniGameId = nil
		end)
	end, SFX_DORM_CLICK)
	setText(arg0_10.rtRole:Find("MiniGame/bg/Text"), i18n("dorm3d_minigame_button1"))

	if not arg0_10.room:isPersonalRoom() then
		onButton(arg0_10, arg0_10.rtRole:Find("PublicGame"), switch(arg0_10.room.id, {
			[4] = function()
				return function()
					arg0_10:emit(Dorm3dRoomMediator.ENTER_VOLLEYBALL, arg0_10.apartment:GetConfigID())
				end
			end,
			[16] = function()
				return function()
					arg0_10:emit(Dorm3dRoomMediator.ENTER_DANCE, arg0_10.apartment:GetConfigID())
				end
			end,
			[26] = function()
				return function()
					arg0_10:emit(Dorm3dRoomMediator.ENTER_CARWASH, arg0_10.apartment:GetConfigID())
				end
			end
		}), SFX_DORM_CLICK)
		setText(arg0_10.rtRole:Find("PublicGame/bg/Text"), switch(arg0_10.room.id, {
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

	onButton(arg0_10, arg0_10.rtRole:Find("Performance"), function()
		arg0_10:DoTalk(20500, function()
			pg.TipsMgr.GetInstance():ShowTips("Success!")
		end)
	end, SFX_DORM_CLICK)

	arg0_10.rtFloatPage = arg0_10._tf:Find("FloatPage")
	arg0_10.tplFloat = arg0_10.rtFloatPage:Find("tpl")

	setActive(arg0_10.tplFloat, false)

	local var5_10 = cloneTplTo(arg0_10.tplFloat, arg0_10.rtFloatPage, "lady")

	eachChild(var5_10, function(arg0_61)
		setActive(arg0_61, arg0_61.name == "walk")
	end)

	arg0_10._joystick = arg0_10._tf:Find("Stick")

	setActive(arg0_10._joystick, false)
	arg0_10._joystick:GetComponent(typeof(SlideController)):SetStickFunc(function(arg0_62)
		arg0_10:emit(arg0_10.ON_STICK_MOVE, arg0_62)
	end)

	arg0_10.povLayer = arg0_10._tf:Find("POVControl")

	setActive(arg0_10.povLayer, false)
	;(function()
		local var0_63 = arg0_10.povLayer:Find("Move"):GetComponent(typeof(SlideController))

		var0_63:AddBeginDragFunc(function(arg0_64, arg1_64)
			arg0_10:emit(arg0_10.ON_POV_STICK_MOVE_BEGIN, arg1_64)
		end)
		var0_63:SetStickFunc(function(arg0_65)
			arg0_10:emit(arg0_10.ON_POV_STICK_MOVE, arg0_65)
		end)
		var0_63:AddDragEndFunc(function(arg0_66, arg1_66)
			arg0_10:emit(arg0_10.ON_POV_STICK_MOVE_END, arg1_66)
		end)
		arg0_10.povLayer:Find("View"):GetComponent(typeof(SlideController)):SetStickFunc(function(arg0_67)
			arg0_10:emit(arg0_10.ON_POV_STICK_VIEW, arg0_67)
		end)
	end)()

	arg0_10.rtExtraScreen = arg0_10._tf:Find("ExtraScreen")
	arg0_10.rtTimelineScreen = arg0_10.rtExtraScreen:Find("TimelineScreen")

	onButton(arg0_10, arg0_10.rtTimelineScreen:Find("btn_skip"), function()
		existCall(arg0_10.timelineFinishCall)
	end, SFX_CANCEL)
	arg0_10:InitSubViews()

	arg0_10.uiStack = {}
	arg0_10.uiStore = {}
end

function var0_0.BindEvent(arg0_69)
	var0_0.super.BindEvent(arg0_69)
	arg0_69:bind(var0_0.EXTRA_SET_UI, function(arg0_70, arg1_70, ...)
		arg0_69:SetUI(arg1_70, ...)
	end)
	arg0_69:bind(var0_0.EXTRA_DO_TALK, function(arg0_71, arg1_71, arg2_71)
		arg0_69:DoTalk(arg1_71, arg2_71)
	end)
	arg0_69:bind(arg0_69.CLICK_CHARACTER, function(arg0_72, arg1_72)
		if arg0_69.uiState ~= "base" or not arg0_69.ladyDict[arg1_72].nowCanWatchState then
			return
		end

		local var0_72 = {}
		local var1_72 = arg0_69.ladyDict[arg1_72]

		if arg0_69:GetBlackboardValue(var1_72, "inPending") then
			table.insert(var0_72, function(arg0_73)
				arg0_69:OutOfPending(arg1_72, arg0_73)
			end)
		else
			table.insert(var0_72, function(arg0_74)
				arg0_69:OutOfLazy(arg1_72, arg0_74)
			end)
		end

		seriesAsync(var0_72, function()
			if not arg0_69.room:isPersonalRoom() then
				arg0_69:SetApartment(getProxy(ApartmentProxy):getApartment(arg1_72))
			end

			arg0_69:EnterWatchMode()
		end)
		pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_touch_v1")
	end)
	arg0_69:bind(arg0_69.DISTANCE_TRIGGER, function(arg0_76, arg1_76, arg2_76)
		if arg0_69.uiState == "base" then
			arg0_69:CheckDistanceTalk(arg1_76, arg2_76)
		end
	end)
	arg0_69:bind(arg0_69.WALK_DISTANCE_TRIGGER, function(arg0_77, arg1_77, arg2_77)
		if arg0_69.apartment and arg0_69.apartment:GetConfigID() == arg1_77 then
			existCall(arg0_69.walkNearCallback, arg2_77)
		end
	end)
	arg0_69:bind(arg0_69.CHANGE_WATCH, function(arg0_78, arg1_78)
		arg0_69:ChangeCanWatchState(arg0_69.ladyDict[arg1_78])
	end)
	arg0_69:bind(arg0_69.ON_ENTER_SECTOR, function(arg0_79, arg1_79)
		arg0_69:ChangeCanWatchState(arg0_69.ladyDict[arg1_79])
	end)
	arg0_69:bind(arg0_69.ON_CHANGE_DISTANCE, function(arg0_80, arg1_80, arg2_80)
		arg0_69:ChangeCanWatchState(arg0_69.ladyDict[arg1_80])
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

						arg0_87.rtRoleTouchSubView:Flush(arg0_87.room, var0_93, arg0_87:GetLadyBaseZone(var0_93))
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

	arg0_104:SetLadyActiveZone(var0_104, var1_104.welcome_staypoint)
	arg0_104:ChangeCharacterPosition(arg1_104)

	local var2_104 = arg0_104.pendingStateDic[var0_104]

	if not var2_104 then
		var2_104 = {
			hideItems = {}
		}
		arg0_104.pendingStateDic[var0_104] = var2_104
	end

	local var3_104 = var2_104.hideItems

	if var1_104.item_shield ~= "" then
		for iter0_104, iter1_104 in ipairs(var1_104.item_shield) do
			local var4_104 = arg0_104.modelRoot:Find(iter1_104)

			if not var4_104 then
				warning(string.format("welcome:%d without hide item:%s", arg2_104, iter1_104))
			else
				if var3_104[iter1_104] == nil then
					local var5_104 = isActive(var4_104)

					for iter2_104, iter3_104 in pairs(arg0_104.pendingStateDic) do
						if iter2_104 ~= var0_104 and iter3_104.hideItems[iter1_104] ~= nil then
							var5_104 = iter3_104.hideItems[iter1_104]

							break
						end
					end

					var3_104[iter1_104] = var5_104
				end

				setActive(var4_104, false)
			end
		end
	end

	onNextTick(function()
		if arg1_104.tfPendintItem then
			setActive(arg1_104.tfPendintItem, true)
		end

		arg0_104:SwitchAnim(arg1_104, var1_104.welcome_idle)
	end)

	var2_104.talkId = var1_104.welcome_talk
end

function var0_0.SetOutPending(arg0_106, arg1_106)
	local var0_106 = arg0_106:GetBlackboardValue(arg1_106, "groupId")

	arg0_106:SetBlackboardValue(arg1_106, "inPending", false)
	arg0_106:ChangeCanWatchState(arg1_106)
	arg0_106:EnableHeadIK(arg1_106, true)

	if arg1_106.tfPendintItem then
		setActive(arg1_106.tfPendintItem, false)
	end

	local var1_106 = arg0_106.pendingStateDic[var0_106]
	local var2_106 = var1_106 and var1_106.hideItems

	if var2_106 then
		for iter0_106, iter1_106 in pairs(var2_106) do
			local var3_106 = false

			for iter2_106, iter3_106 in pairs(arg0_106.pendingStateDic) do
				if iter2_106 ~= var0_106 and iter3_106.hideItems[iter0_106] ~= nil then
					var3_106 = true

					break
				end
			end

			if not var3_106 then
				setActive(arg0_106.modelRoot:Find(iter0_106), iter1_106)
			end
		end
	end

	arg0_106.pendingStateDic[var0_106] = nil
end

function var0_0.IsModeInHidePending(arg0_107, arg1_107)
	for iter0_107, iter1_107 in pairs(arg0_107.pendingStateDic) do
		if iter1_107.hideItems[arg1_107] ~= nil then
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
	local var0_116 = arg0_116.room:getApartmentZoneConfig(arg0_116:GetLadyBaseZone(arg0_116.apartment:GetConfigID()), "touch_performance", arg0_116.apartment:GetConfigID())

	if not var0_116 or var0_116 == 0 then
		arg0_116:emit(RoomTouchSystem.ENTER_TOUCH_MODE)
	else
		arg0_116:DoTalk(var0_116)
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
		pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataDialog(arg0_134.apartment.configId, arg0_134.apartment.level, arg1_134, var3_134.type, arg0_134.room:getZoneConfig(arg0_134:GetLadyBaseZone(arg0_134.apartment:GetConfigID()), "id"), var3_134.action_type, table.CastToString(var3_134.trigger_config), arg0_134.room:GetConfigID()))

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
	local var2_160 = arg0_160.room:getApartmentZoneConfig(arg0_160:GetLadyBaseZone(arg1_160), "special_action", arg1_160)
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

			arg0_161:ShiftZone(arg0_161:GetLadyBaseZone(arg1_161), arg0_162)
		end)
	end

	seriesAsync(var1_161, arg2_161)
end

function var0_0.OutOfPending(arg0_163, arg1_163, arg2_163)
	local var0_163 = arg0_163.pendingStateDic[arg1_163]

	assert(var0_163 and var0_163.talkId)

	local var1_163 = var0_163.talkId

	seriesAsync({
		function(arg0_164)
			arg0_163:SetUI(arg0_164, "blank")
		end,
		function(arg0_165)
			arg0_163.shiftLady = arg1_163

			local var0_165 = arg0_163.ladyDict[arg1_163]

			arg0_163:ShiftZone(arg0_163:GetLadyBaseZone(arg1_163), arg0_165)
		end,
		function(arg0_166)
			arg0_163:DoTalk(var1_163, arg0_166)
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

					arg0_181:emit(CollectionSystem.UPDATE_CONTACT_STATE, arg0_181.contextData.timeIndex)
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
						arg0_181:emit(Dorm3dIKView.SET_BACK_BUTTON_ACTIVE, not arg0_184.params.hide_back)
						arg0_181:emit(RoomIKSystem.SET_IK_SPECIAL_CALL, arg0_212)
						arg0_181:emit(RoomIKSystem.ENTER_IK, arg0_184.params.state)
					elseif arg0_184.name == "back" then
						arg0_181:emit(RoomIKSystem.EXIT_IK_WITH_RETURN, arg0_184.params, function()
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

function var0_0.UpdateFavorDisplay(arg0_219)
	local var0_219, var1_219 = getProxy(ApartmentProxy):getStamina()

	setText(arg0_219.rtStaminaDisplay:Find("Text"), string.format("%d/%d", var0_219, var1_219))
	setActive(arg0_219.rtStaminaDisplay, false)

	if arg0_219.apartment then
		setText(arg0_219.rtFavorLevel:Find("rank/Text"), arg0_219.apartment.level)

		local var2_219, var3_219 = arg0_219.apartment:getFavor()
		local var4_219 = arg0_219.apartment:isMaxFavor()

		setActive(arg0_219.rtFavorLevel:Find("Max"), var4_219)
		setActive(arg0_219.rtFavorLevel:Find("Text"), not var4_219)
		setText(arg0_219.rtFavorLevel:Find("Text"), string.format("<color=#ff6698>%d</color>/%d", var2_219, var3_219))
	end

	setActive(arg0_219.rtFavorLevel:Find("red"), Dorm3dLevelLayer.IsShowRed())
end

function var0_0.UpdateBtnState(arg0_220)
	local var0_220 = not arg0_220.room:isPersonalRoom() or arg0_220:CheckSystemOpen("Furniture")
	local var1_220 = Dorm3dFurniture.IsTimelimitShopTip(arg0_220.room:GetConfigID())

	setActive(arg0_220.uiContainer:Find("base/left/btn_furniture/tipTimelimit"), var0_220 and var1_220)

	local var2_220 = Dorm3dFurniture.NeedViewTip(arg0_220.room:GetConfigID())

	setActive(arg0_220.uiContainer:Find("base/left/btn_furniture/tip"), var0_220 and not var1_220 and var2_220)
	setActive(arg0_220.uiContainer:Find("base/btn_back/main"), underscore(getProxy(ApartmentProxy):getRawData()):chain():values():filter(function(arg0_221)
		return tobool(arg0_221)
	end):any(function(arg0_222)
		return #arg0_222:getSpecialTalking() > 0 or arg0_222:getIconTip() == "main"
	end):value())
	setActive(arg0_220.uiContainer:Find("base/left/btn_collection/tip"), PlayerPrefs.GetInt("apartment_collection_item", 0) > 0 or PlayerPrefs.GetInt("apartment_collection_recall", 0) > 0)
end

function var0_0.AddUnlockDisplay(arg0_223, arg1_223)
	table.insert(arg0_223.unlockList, arg1_223)

	if not isActive(arg0_223.rtFavorUp) then
		setText(arg0_223.rtFavorUp:Find("Text"), table.remove(arg0_223.unlockList, 1))
		setActive(arg0_223.rtFavorUp, true)
	end
end

function var0_0.PopFavorTrigger(arg0_224, arg1_224)
	local var0_224 = arg1_224.triggerId
	local var1_224 = arg1_224.delta
	local var2_224 = arg1_224.cost
	local var3_224 = arg1_224.apartment
	local var4_224 = pg.dorm3d_favor_trigger[var0_224]

	if var4_224.is_repeat == 0 then
		if var0_224 == getDorm3dGameset("drom3d_favir_trigger_onwer")[1] then
			arg0_224:AddUnlockDisplay(i18n("dorm3d_own_favor"))
		elseif var0_224 == getDorm3dGameset("drom3d_favir_trigger_propose")[1] then
			arg0_224:AddUnlockDisplay(i18n("dorm3d_pledge_favor"))
		else
			arg0_224:AddUnlockDisplay(string.format("unknow favor trigger:%d unlock", var0_224))
		end
	elseif arg1_224.delta > 0 then
		local var5_224, var6_224 = var3_224:getFavor()
		local var7_224 = var5_224 + var1_224

		setText(arg0_224.rtFavorUpDaily:Find("bg/Text"), string.format("<size=48>+%d</size>", math.min(9999, var1_224)))
		setSlider(arg0_224.rtFavorUpDaily:Find("bg/slider"), 0, var6_224, var5_224)
		setAnchoredPosition(arg0_224.rtFavorUpDaily:Find("bg"), arg1_224.isGift and NewPos(-354, 223) or NewPos(-208, 105))

		local var8_224 = {}
		local var9_224 = arg0_224.rtFavorUpDaily:Find("bg/effect")

		eachChild(var9_224, function(arg0_225)
			setActive(arg0_225, false)
		end)

		local var10_224

		if var4_224.effect and var4_224.effect ~= "" then
			var10_224 = var9_224:Find(var4_224.effect .. "(Clone)")

			if not var10_224 then
				table.insert(var8_224, function(arg0_226)
					LoadAndInstantiateAsync("Dorm3D/Effect/Prefab/ExpressionUI", "uifx_dorm3d_yinfu01", function(arg0_227)
						setParent(arg0_227, var9_224)

						var10_224 = tf(arg0_227)

						arg0_226()
					end)
				end)
			else
				setActive(var10_224, true)
			end
		end

		local var11_224 = arg0_224.rtFavorUpDaily:GetComponent("DftAniEvent")

		var11_224:SetTriggerEvent(function(arg0_228)
			local var0_228 = GetComponent(arg0_224.rtFavorUpDaily:Find("bg/slider"), typeof(Slider))

			LeanTween.value(var5_224, var7_224, 0.5):setOnUpdate(System.Action_float(function(arg0_229)
				var0_228.value = arg0_229
			end)):setEase(LeanTweenType.easeInOutQuad):setDelay(0.165):setOnComplete(System.Action(function()
				LeanTween.delayedCall(0.165, System.Action(function()
					if arg0_224.exited then
						return
					end

					quickPlayAnimator(arg0_224.rtFavorUpDaily, "favor_out")
				end))
			end))
			pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_progaress_bar")
		end)
		var11_224:SetEndEvent(function(arg0_232)
			setActive(arg0_224.rtFavorUpDaily, false)
		end)
		seriesAsync(var8_224, function()
			local var0_233 = arg0_224.ladyDict[var3_224:GetConfigID()]

			setLocalPosition(arg0_224.rtFavorUpDaily, arg0_224:GetLocalPosition(arg0_224:GetScreenPosition(var0_233.ladyHeadCenter.position), arg0_224.rtFavorUpDaily.parent))
			setActive(arg0_224.rtFavorUpDaily, true)
			SetCompomentEnabled(arg0_224.rtFavorUpDaily, typeof(Animator), true)
			quickPlayAnimator(arg0_224.rtFavorUpDaily, "favor_open")

			if var2_224 > 0 then
				local var1_233, var2_233 = getProxy(ApartmentProxy):getStamina()

				setText(arg0_224.rtStaminaPop:Find("Text/Text (1)"), "-" .. var2_224)
				setText(arg0_224.rtStaminaPop:Find("Text"), string.format("%d/%d", var1_233 + var2_224, var2_233))
				setActive(arg0_224.rtStaminaPop, true)
			end
		end)
	end
end

function var0_0.PopFavorLevelUp(arg0_234, arg1_234, arg2_234, arg3_234)
	arg0_234.isLock = true

	LeanTween.delayedCall(0.33, System.Action(function()
		arg0_234.isLock = false
	end))

	local var0_234 = math.floor(arg1_234.level / 10)
	local var1_234 = math.fmod(arg1_234.level, 10)

	GetImageSpriteFromAtlasAsync("ui/favor_atlas", var1_234, arg0_234.rtLevelUpWindow:Find("panel/bg/item1/mark/level/digit2"))
	GetImageSpriteFromAtlasAsync("ui/favor_atlas", var0_234, arg0_234.rtLevelUpWindow:Find("panel/bg/item1/mark/level/digit1"))
	setActive(arg0_234.rtLevelUpWindow:Find("panel/bg/item1/mark/level/digit1"), var0_234 > 0)

	local var2_234
	local var3_234

	arg0_234.clientAward, var3_234 = Dorm3dIconHelper.SplitStory(arg1_234:getFavorConfig("levelup_client_item", arg1_234.level))
	arg0_234.serverAward = arg2_234

	local var4_234 = arg0_234.rtLevelUpWindow:Find("panel/info/content/itemContent")

	if not arg0_234.levelItemList then
		arg0_234.levelItemList = UIItemList.New(var4_234, var4_234:Find("tpl"))

		arg0_234.levelItemList:make(function(arg0_236, arg1_236, arg2_236)
			local var0_236 = arg1_236 + 1

			if arg0_236 == UIItemList.EventUpdate then
				if arg1_236 < #arg0_234.serverAward then
					updateDorm3dIcon(arg2_236, arg0_234.serverAward[var0_236])
					onButton(arg0_234, arg2_236, function()
						arg0_234:emit(BaseUI.ON_NEW_DROP, {
							style = "dorm",
							drop = arg0_234.serverAward[var0_236]
						})
					end, SFX_PANEL)
				else
					Dorm3dIconHelper.UpdateDorm3dIcon(arg2_236, arg0_234.clientAward[var0_236 - #arg0_234.serverAward])
					onButton(arg0_234, arg2_236, function()
						arg0_234:emit(Dorm3dRoomMediator.ON_DROP_CLIENT, {
							data = arg0_234.clientAward[var0_236 - #arg0_234.serverAward]
						})
					end, SFX_PANEL)
				end
			end
		end)
	end

	arg0_234.levelItemList:align(#arg0_234.serverAward + #arg0_234.clientAward)
	setActive(arg0_234.rtLevelUpWindow, true)
	pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_upgrade")
	arg0_234:OverlayPanel(arg0_234.rtLevelUpWindow)

	function arg0_234.levelUpCallback()
		arg0_234.levelUpCallback = nil

		if var3_234 then
			arg0_234:PopNewStoryTip(var3_234)
		end

		existCall(arg3_234)
	end
end

function var0_0.PopNewStoryTip(arg0_240, arg1_240, arg2_240)
	local var0_240 = arg0_240.uiContainer:Find("base/top/story_tip")

	setActive(var0_240, true)
	LeanTween.delayedCall(1, System.Action(function()
		setActive(var0_240, false)
	end))
	setText(var0_240:Find("Text"), i18n("dorm3d_story_unlock_tip", pg.dorm3d_recall[arg1_240[2]].name))
	existCall(arg2_240)
end

function var0_0.UpdateZoneList(arg0_242)
	local var0_242

	if arg0_242.room:isPersonalRoom() then
		var0_242 = arg0_242:GetLadyBaseZone(arg0_242.apartment:GetConfigID())
	else
		var0_242 = arg0_242:GetCurrentZoneNodeName()
	end

	for iter0_242, iter1_242 in ipairs(arg0_242.zoneDatas) do
		if iter1_242:GetWatchCameraName() == var0_242 then
			setText(arg0_242.btnZone:Find("Text"), iter1_242:GetName())
			setTextColor(arg0_242.rtZoneList:GetChild(iter0_242 - 1):Find("Name"), Color.NewHex("5CCAFF"))
		else
			setTextColor(arg0_242.rtZoneList:GetChild(iter0_242 - 1):Find("Name"), Color.NewHex("FFFFFF99"))
		end
	end
end

function var0_0.TalkingEventHandle(arg0_243, arg1_243)
	local var0_243 = {}
	local var1_243 = {}
	local var2_243 = arg1_243.data

	if var2_243.op_list then
		for iter0_243, iter1_243 in ipairs(var2_243.op_list) do
			table.insert(var0_243, function(arg0_244)
				local function var0_244()
					local var0_245 = arg0_244

					arg0_244 = nil

					return existCall(var0_245)
				end

				switch(iter1_243.type, {
					action = function()
						local var0_246 = arg0_243:GetCurrentLadyEnv()

						arg0_243:PlaySingleAction(var0_246, iter1_243.name, var0_244)
					end,
					item_action = function()
						arg0_243:PlaySceneItemAnim(iter1_243.id, iter1_243.name)
						var0_244()
					end,
					extra_item_action = function()
						local var0_248 = arg0_243.extraItems and arg0_243.extraItems[iter1_243.name]

						warning(iter1_243.name)

						if var0_248 then
							warning(var0_248.trans)
							var0_248.trans:GetComponent(typeof(Animator)):PlayInFixedTime(iter1_243.param)
						end

						var0_244()
					end,
					timeline = function()
						local var0_249 = {}

						arg0_243:emit(RoomTouchSystem.GET_TOUCH_GAME_STATE, var0_249)

						if var0_249.inTouchGame then
							arg0_243:emit(RoomTouchSystem.UPDATE_TOUCH_PANEL, false)
						end

						arg0_243:PlayTimeline(iter1_243, function(arg0_250, arg1_250)
							arg0_243:emit(RoomTouchSystem.GET_TOUCH_GAME_STATE, var0_249)
							arg0_243:emit(RoomTouchSystem.UPDATE_TOUCH_PANEL, var0_249.inTouchGame)

							var1_243.notifiCallback = arg1_250

							var0_244()
						end)
					end,
					clickOption = function()
						arg0_243:DoTalkTouchOption(iter1_243, arg1_243.flags, function(arg0_252)
							var1_243.optionIndex = arg0_252

							var0_244()
						end)
					end,
					wait = function()
						arg0_243.LTs = arg0_243.LTs or {}

						table.insert(arg0_243.LTs, LeanTween.delayedCall(iter1_243.time, System.Action(var0_244)).uniqueId)
					end,
					expression = function()
						arg0_243:emit(arg0_243.PLAY_EXPRESSION, iter1_243)
						var0_244()
					end,
					blackscreen = function()
						arg0_243.LTs = arg0_243.LTs or {}

						arg0_243:ShowBlackScreen(true, function()
							table.insert(arg0_243.LTs, LeanTween.delayedCall(iter1_243.time, System.Action(function()
								arg0_243:ShowBlackScreen(false)
								var0_244()
							end)).uniqueId)
						end)
					end
				}, function()
					assert(false, "op type error:", iter1_243.type)
				end)

				if iter1_243.skip then
					var0_244()
				end
			end)
		end
	end

	seriesAsync(var0_243, function()
		if arg1_243.callbackData then
			arg0_243:emit(Dorm3dRoomMediator.TALKING_EVENT_FINISH, arg1_243.callbackData.name, var1_243)
		end
	end)
end

function var0_0.CheckQueue(arg0_260)
	if arg0_260.inGuide or arg0_260.uiState ~= "base" then
		return
	end

	if arg0_260.room:GetConfigID() == 1 and arg0_260:CheckGuide() then
		-- block empty
	elseif arg0_260.room:isPersonalRoom() and arg0_260:CheckLevelUp() then
		-- block empty
	elseif arg0_260.apartment and arg0_260:CheckEnterDeal() then
		-- block empty
	elseif arg0_260.apartment and arg0_260:CheckGiftExpireSoon() then
		-- block empty
	elseif arg0_260.apartment and arg0_260:CheckActiveTalk() then
		-- block empty
	elseif arg0_260.apartment then
		arg0_260:CheckFavorTrigger()
	end

	arg0_260.contextData.hasEnterCheck = true
end

function var0_0.didEnterCheck(arg0_261)
	local var0_261

	if arg0_261.contextData.specialId then
		var0_261 = arg0_261.contextData.specialId
		arg0_261.contextData.specialId = nil

		arg0_261:DoTalk(var0_261, function()
			arg0_261:closeView()
		end)

		if arg0_261.contextData.isVideoTalk then
			arg0_261.contextData.hasEnterCheck = true
		end
	elseif not arg0_261.contextData.hasEnterCheck and arg0_261.apartment then
		for iter0_261, iter1_261 in ipairs(arg0_261.apartment:getForceEnterTalking(arg0_261.room:GetConfigID())) do
			var0_261 = iter1_261

			arg0_261:DoTalk(iter1_261)

			break
		end
	end

	if var0_261 and pg.dorm3d_dialogue_group[var0_261].extend_loading > 0 then
		arg0_261.contextData.hasEnterCheck = true

		pg.SceneAnimMgr.GetInstance():RegisterDormNextCall(function()
			arg0_261:FinishEnterResume()
		end)
	else
		if arg0_261.apartment and arg0_261.contextData.pendingDic[arg0_261.apartment:GetConfigID()] then
			arg0_261.contextData.hasEnterCheck = true
		end

		for iter2_261, iter3_261 in pairs(arg0_261.contextData.pendingDic) do
			arg0_261:SetInPending(arg0_261.ladyDict[iter2_261], iter3_261)
		end

		arg0_261.contextData.pendingDic = {}

		arg0_261:FinishEnterResume()
		arg0_261:CheckQueue()
	end
end

function var0_0.CheckGuide(arg0_264)
	if arg0_264:GetBlackboardValue(arg0_264:GetCurrentLadyEnv(), "inPending") then
		return
	end

	if DORM_LOCK_GUIDE then
		return false
	end

	for iter0_264, iter1_264 in ipairs({
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
				return arg0_264:CheckSystemOpen("Furniture")
			end
		},
		{
			name = "DORM3D_GUIDE_07",
			active = function()
				return arg0_264:CheckSystemOpen("DayNight")
			end
		}
	}) do
		if not pg.NewStoryMgr.GetInstance():IsPlayed(iter1_264.name) and iter1_264.active() then
			arg0_264:SetAllBlackbloardValue("inGuide", true)

			local function var0_264()
				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(2, pg.NewStoryMgr.GetInstance():StoryName2StoryId(iter1_264.name)))
				arg0_264:SetAllBlackbloardValue("inGuide", false)
			end

			pg.m02:sendNotification(GAME.STORY_UPDATE, {
				storyId = iter1_264.name
			})
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(1, pg.NewStoryMgr.GetInstance():StoryName2StoryId(iter1_264.name)))
			pg.NewGuideMgr.GetInstance():Play(iter1_264.name, nil, var0_264, var0_264)

			return true
		end
	end

	return false
end

function var0_0.CheckGiftExpireSoon(arg0_270)
	if not arg0_270.room:isPersonalRoom() then
		return false
	end

	local var0_270 = getProxy(ApartmentProxy):GetShipGroupGiftExpireSoonTipIds(arg0_270.apartment:GetConfigID())

	if #var0_270 <= 0 then
		return false
	end

	_.each(var0_270, function(arg0_271)
		Dorm3dGift.SetExpireSoonTipFlag(arg0_271)
	end)

	local function var1_270()
		arg0_270:CheckQueue()
	end

	pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_MSGBOX, {
		title = i18n("dorm3d_gift_overtime_title"),
		contentText = i18n("dorm3d_gift_overtime"),
		btnList = {
			{
				type = pg.NewStyleMsgboxMgr.BUTTON_TYPE.confirm,
				name = i18n("msgbox_text_confirm"),
				func = var1_270,
				sound = SFX_CONFIRM
			}
		},
		onClose = var1_270
	})

	return true
end

function var0_0.CheckFavorTrigger(arg0_273)
	for iter0_273, iter1_273 in ipairs({
		{
			triggerId = getDorm3dGameset("drom3d_favir_trigger_onwer")[1],
			active = function()
				local var0_274 = getProxy(CollectionProxy):getShipGroup(arg0_273.apartment.configId)

				return tobool(var0_274)
			end
		},
		{
			triggerId = getDorm3dGameset("drom3d_favir_trigger_propose")[1],
			active = function()
				local var0_275 = getProxy(CollectionProxy):getShipGroup(arg0_273.apartment.configId)

				return var0_275 and var0_275.married > 0
			end
		}
	}) do
		if arg0_273.apartment.triggerCountDic[iter1_273.triggerId] == 0 and iter1_273.active() then
			arg0_273:emit(Dorm3dRoomMediator.TRIGGER_FAVOR, arg0_273.apartment.configId, iter1_273.triggerId)
		end
	end
end

function var0_0.CheckEnterDeal(arg0_276)
	if arg0_276.contextData.hasEnterCheck then
		return false
	end

	local var0_276 = arg0_276.apartment:GetConfigID()
	local var1_276 = "dorm3d_enter_count_" .. var0_276
	local var2_276 = pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d")

	if PlayerPrefs.GetString("dorm3d_enter_count_day") ~= var2_276 then
		PlayerPrefs.SetString("dorm3d_enter_count_day", var2_276)
		PlayerPrefs.SetInt(var1_276, 1)
	else
		PlayerPrefs.SetInt(var1_276, PlayerPrefs.GetInt(var1_276, 0) + 1)
	end

	local var3_276 = arg0_276.apartment:getEnterTalking(arg0_276.room:GetConfigID())

	PlayerPrefs.SetString("DORM3D_DAILY_ENTER", pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d"))

	if #var3_276 > 0 then
		arg0_276:DoTalk(var3_276[math.random(#var3_276)])

		return true
	end
end

function var0_0.CheckActiveTalk(arg0_277)
	local var0_277 = arg0_277:GetCurrentLadyEnv()

	if arg0_277:GetBlackboardValue(var0_277, "inPending") then
		return false
	end

	local var1_277 = arg0_277.apartment:getZoneTalking(arg0_277.room:GetConfigID(), arg0_277:GetLadyBaseZone(arg0_277.apartment:GetConfigID()))

	if #var1_277 > 0 then
		arg0_277:DoTalk(var1_277[1])

		return true
	else
		return false
	end
end

function var0_0.CheckDistanceTalk(arg0_278, arg1_278, arg2_278)
	local var0_278 = arg0_278:GetLadyBaseZone(arg1_278)
	local var1_278 = getProxy(ApartmentProxy):getApartment(arg1_278)

	for iter0_278, iter1_278 in ipairs(var1_278:getDistanceTalking(arg0_278.room:GetConfigID(), var0_278)) do
		arg0_278:DoTalk(iter1_278)

		return
	end
end

function var0_0.CheckSystemOpen(arg0_279, arg1_279)
	if arg0_279.room:isPersonalRoom() then
		return switch(arg1_279, {
			Talk = function()
				local var0_280 = 1

				return var0_280 <= arg0_279.apartment.level, i18n("apartment_level_unenough", var0_280)
			end,
			Touch = function()
				local var0_281 = getDorm3dGameset("drom3d_touch_dialogue")[1]

				return var0_281 <= arg0_279.apartment.level, i18n("apartment_level_unenough", var0_281)
			end,
			Gift = function()
				local var0_282 = getDorm3dGameset("drom3d_gift_dialogue")[1]

				return var0_282 <= arg0_279.apartment.level, i18n("apartment_level_unenough", var0_282)
			end,
			PublicGame = function()
				return false
			end,
			Photo = function()
				local var0_284 = getDorm3dGameset("drom3d_photograph_unlock")[1]

				return var0_284 <= arg0_279.apartment.level, i18n("apartment_level_unenough", var0_284)
			end,
			Collection = function()
				local var0_285 = getDorm3dGameset("drom3d_recall_unlock")[1]

				return var0_285 <= arg0_279.apartment.level, i18n("apartment_level_unenough", var0_285)
			end,
			Furniture = function()
				local var0_286 = getDorm3dGameset("drom3d_furniture_unlock")[1]

				return var0_286 <= arg0_279.apartment.level, i18n("apartment_level_unenough", var0_286)
			end,
			DayNight = function()
				local var0_287 = getDorm3dGameset("drom3d_time_unlock")[1]

				return var0_287 <= arg0_279.apartment.level, i18n("apartment_level_unenough", var0_287)
			end,
			Accompany = function()
				local var0_288 = 1

				return var0_288 <= arg0_279.apartment.level, i18n("apartment_level_unenough", var0_288)
			end,
			MiniGame = function()
				local var0_289 = 1

				if var0_289 > arg0_279.apartment.level then
					return false, i18n("apartment_level_unenough", var0_289)
				elseif #arg0_279.room:getMiniGames() <= 0 then
					return false, "without minigame config in room:" .. arg0_279.room.configId
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
		return switch(arg1_279, {
			Gift = function()
				return false
			end,
			PublicGame = function()
				return true
			end,
			Furniture = function()
				local var0_295 = #arg0_279.room:GetFurnitures() > 0
				local var1_295 = #_.filter(arg0_279.room:GetFurnitureIDList() or {}, function(arg0_296)
					return Dorm3dFurniture.New({
						configId = arg0_296
					}):InShopTime()
				end) > 0

				return var0_295 or var1_295
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

function var0_0.CheckLevelUp(arg0_302)
	if arg0_302.apartment:canLevelUp() then
		arg0_302:emit(Dorm3dRoomMediator.FAVOR_LEVEL_UP, arg0_302.apartment.configId)

		return true
	end

	return false
end

function var0_0.TempHideUI(arg0_303, arg1_303, arg2_303)
	local var0_303 = defaultValue(arg0_303.hideCount, 0)

	arg0_303.hideCount = var0_303 + (arg1_303 and 1 or -1)

	assert(arg0_303.hideCount >= 0)

	if arg0_303.hideCount * var0_303 > 0 then
		return existCall(arg2_303)
	elseif arg0_303.hideCount > 0 then
		arg0_303:SetUI(arg2_303, "blank")
	else
		arg0_303:SetUI(arg2_303, "back")
	end
end

function var0_0.onBackPressed(arg0_304)
	if arg0_304.exited or arg0_304.retainCount > 0 then
		-- block empty
	elseif isActive(arg0_304.rtLevelUpWindow) then
		triggerButton(arg0_304.rtLevelUpWindow:Find("bg"))
	elseif arg0_304.uiState ~= "base" then
		-- block empty
	else
		arg0_304:closeView()
	end
end

function var0_0.willExit(arg0_305)
	if arg0_305.LTs then
		underscore.map(arg0_305.LTs, function(arg0_306)
			LeanTween.cancel(arg0_306)
		end)

		arg0_305.LTs = nil
	end

	if arg0_305.accompanyFavorTimer then
		arg0_305.accompanyFavorTimer:Stop()

		arg0_305.accompanyFavorTimer = nil
	end

	if arg0_305.accompanyPerformanceTimer then
		arg0_305.accompanyPerformanceTimer:Stop()

		arg0_305.accompanyPerformanceTimer = nil
	end

	arg0_305.canTriggerAccompanyPerformance = nil

	arg0_305.videoPlayer:Destroy()

	if arg0_305.ikView then
		arg0_305.ikView:Dispose()

		arg0_305.ikView = nil
	end

	if arg0_305.touchView then
		arg0_305.touchView:Dispose()

		arg0_305.touchView = nil
	end

	var0_0.super.willExit(arg0_305)
end

return var0_0
