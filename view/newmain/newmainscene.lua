local var0_0 = class("NewMainScene", import("..base.BaseUI"))

var0_0.THEME_CLASSIC = 1
var0_0.THEME_MELLOW = 2
var0_0.OPEN_LIVEAREA = "NewMainScene:OPEN_LIVEAREA"
var0_0.UPDATE_COVER = "NewMainScene:UPDATE_COVER"
var0_0.FOLD = "NewMainScene:FOLD"
var0_0.HIDE = "NewMainScene:HIDE"
var0_0.CHAT_STATE_CHANGE = "NewMainScene:CHAT_STATE_CHANGE"
var0_0.ON_CHANGE_SKIN = "NewMainScene:ON_CHANGE_SKIN"
var0_0.ON_BUFF_DESC = "NewMainScene:ON_BUFF_DESC"
var0_0.ON_SKIN_FREEUSAGE_DESC = "NewMainScene:ON_SKIN_FREEUSAGE_DESC"
var0_0.ENABLE_PAITING_MOVE = "NewMainScene:ENABLE_PAITING_MOVE"
var0_0.ENABLE_PAITING_SCALE = "NewMainScene:ENABLE_PAITING_SCALE"
var0_0.SAVE_PART_SCALE = "NewMainScene:SAVE_PART_SCALE"
var0_0.RESET_PAITING_SCALE = "NewMainScene:RESET_PAITING_SCALE"
var0_0.SET_SCALE_PART_CONTENT = "NewMainScene:SET_SCALE_PART_CONTENT"
var0_0.ON_ENTER_DONE = "NewMainScene:ON_ENTER_DONE"
var0_0.ENTER_SILENT_VIEW = "NewMainScene:ENTER_SILENT_VIEW"
var0_0.EXIT_SILENT_VIEW = "NewMainScene:EXIT_SILENT_VIEW"
var0_0.RESET_L2D = "NewMainScene:RESET_L2D"

function var0_0.getUIName(arg0_1)
	return "NewMainUI"
end

function var0_0.needCache(arg0_2)
	return true
end

function var0_0.GetThemeStyle(arg0_3)
	return getProxy(SettingsProxy):GetMainSceneThemeStyle()
end

function var0_0.PlayBGM(arg0_4)
	return
end

function var0_0.GetFlagShip(arg0_5)
	return (getProxy(PlayerProxy):getRawData():GetFlagShip())
end

function var0_0.PlayBgm(arg0_6, arg1_6)
	local var0_6
	local var1_6

	if underscore.any({
		function()
			if arg1_6:IsBgmSkin() and getProxy(SettingsProxy):IsBGMEnable() then
				var0_6 = arg1_6:GetSkinBgm()
			end

			return tobool(var0_6)
		end,
		function()
			if getProxy(SettingsProxy):IsEnableMainMusicPlayer() and getProxy(AppreciateProxy):CanPlayMainMusicPlayer() then
				var0_6 = "MainMusicPlayer"
				var1_6 = {
					loopType = getProxy(AppreciateProxy):getMusicPlayerLoopType(),
					albumName = getProxy(AppreciateProxy):getMainPlayerAlbumName()
				}
			end

			return tobool(var0_6)
		end,
		function()
			local var0_9, var1_9 = MainBGView.GetBgAndBgm()

			var0_6 = var1_9

			return tobool(var0_6)
		end,
		function()
			var0_6 = var0_0.super.getBGM(arg0_6)

			return tobool(var0_6)
		end
	}, function(arg0_11)
		return arg0_11()
	end) then
		pg.BgmMgr.GetInstance():Push(arg0_6.__cname, var0_6, var1_6)
	end
end

function var0_0.ResUISettings(arg0_12)
	return {
		showType = PlayerResUI.TYPE_ALL,
		anim = not arg0_12.resAnimFlag,
		weight = LayerWeightConst.BASE_LAYER + 1
	}
end

function var0_0.ShowOrHideResUI(arg0_13, arg1_13)
	if not arg0_13.isInit then
		return
	end

	var0_0.super.ShowOrHideResUI(arg0_13, arg1_13)
end

function var0_0.init(arg0_14)
	arg0_14.mainCG = GetOrAddComponent(arg0_14._tf, typeof(CanvasGroup))
	arg0_14.bgView = MainBGView.New(arg0_14:findTF("Sea/bg"))
	arg0_14.paintingView = MainPaintingView.New(arg0_14:findTF("paint"), arg0_14:findTF("paintBg"), arg0_14.event)
	arg0_14.effectView = MainEffectView.New(arg0_14:findTF("paint/effect"))
	arg0_14.buffDescPage = MainBuffDescPage.New(arg0_14._tf, arg0_14.event)
	arg0_14.calibrationPage = MainCalibrationPage.New(arg0_14._tf, arg0_14.event, arg0_14.contextData)
	arg0_14.silentView = MainSilentView.New(arg0_14._tf, arg0_14.event, arg0_14.contextData)
	arg0_14.silentChecker = MainSilentChecker.New(arg0_14.event)
	arg0_14.skinExperienceDisplayPage = SkinExperienceDiplayPage.New(arg0_14._tf, arg0_14.event)

	if USE_OLD_MAIN_LIVE_AREA_UI then
		arg0_14.liveAreaPage = MainLiveAreaOldPage.New(arg0_14._tf, arg0_14.event)
	else
		arg0_14.liveAreaPage = MainLiveAreaPage.New(arg0_14._tf, arg0_14.event)
	end

	pg.redDotHelper = MainReddotView.New()
	arg0_14.sequenceView = MainSequenceView.New()
	arg0_14.awakeSequenceView = MainAwakeSequenceView.New()
	arg0_14.themes = {
		[var0_0.THEME_CLASSIC] = NewMainClassicTheme.New(arg0_14._tf, arg0_14.event, arg0_14.contextData),
		[var0_0.THEME_MELLOW] = NewMainMellowTheme.New(arg0_14._tf, arg0_14.event, arg0_14.contextData)
	}
end

function var0_0.didEnter(arg0_15)
	arg0_15:bind(var0_0.FOLD, function(arg0_16, arg1_16)
		arg0_15:FoldPanels(arg1_16)

		local var0_16 = arg0_15.paintingView.ship

		if not var0_16 then
			return
		end

		arg0_15.calibrationPage:ExecuteAction("ShowOrHide", arg1_16, arg0_15.bgView.ship, arg0_15.theme:GetPaintingOffset(var0_16), arg0_15.theme:GetCalibrationBG())
	end)
	arg0_15:bind(var0_0.HIDE, function(arg0_17, arg1_17)
		arg0_15:HidePanel(arg1_17)

		local var0_17 = arg0_15.paintingView.ship

		if not var0_17 then
			return
		end

		arg0_15.calibrationPage:ExecuteAction("ShowOrHide", arg1_17, arg0_15.bgView.ship, arg0_15.theme:GetPaintingOffset(var0_17), arg0_15.theme:GetCalibrationBG())
	end)
	arg0_15:bind(var0_0.ON_CHANGE_SKIN, function(arg0_18)
		arg0_15:SwitchToNextShip()
	end)
	arg0_15:bind(var0_0.ENTER_SILENT_VIEW, function()
		arg0_15:ExitCalibrationView()
		arg0_15:FoldPanels(true)
		arg0_15.silentView:ExecuteAction("Show")
	end)
	arg0_15:bind(GAME.WILL_LOGOUT, function()
		arg0_15:GameLogout()
	end)
	arg0_15:bind(var0_0.EXIT_SILENT_VIEW, function()
		arg0_15:ExitSilentView()
		arg0_15:SetUpSilentChecker()
		pg.redDotHelper:_Refresh()
	end)
	arg0_15:bind(var0_0.ON_SKIN_FREEUSAGE_DESC, function(arg0_22, arg1_22)
		arg0_15.skinExperienceDisplayPage:ExecuteAction("Show", arg1_22)
	end)
	arg0_15:bind(NewMainScene.OPEN_LIVEAREA, function(arg0_23)
		arg0_15.liveAreaPage:ExecuteAction("Show")
	end)
	arg0_15:SetUp(false, true)
end

function var0_0.SetUp(arg0_24, arg1_24, arg2_24)
	arg0_24.mainCG.blocksRaycasts = false
	arg0_24.isInit = false
	arg0_24.resAnimFlag = false

	local var0_24

	seriesAsync({
		function(arg0_25)
			arg0_24.awakeSequenceView:Execute(arg0_25)
		end,
		function(arg0_26)
			var0_24 = arg0_24:GetFlagShip()

			arg0_24.bgView:Init(var0_24)
			onNextTick(arg0_26)
		end,
		function(arg0_27)
			arg0_24.theme = arg0_24.themes[arg0_24:GetThemeStyle()]

			arg0_24.theme:ExecuteAction("Show", arg0_27)
		end,
		function(arg0_28)
			onNextTick(arg0_28)
		end,
		function(arg0_29)
			arg0_24.isInit = true

			arg0_24.theme:PlayEnterAnimation(var0_24, arg0_29)

			local var0_29 = arg0_24.theme:GetPaintingOffset(var0_24)

			arg0_24.paintingView:Init(var0_24, var0_29, arg1_24)

			arg0_24.resAnimFlag = true
		end,
		function(arg0_30)
			arg0_24:PlayBgm(var0_24)
			arg0_24.effectView:Init(var0_24)
			arg0_24.theme:init(var0_24)
			onNextTick(arg0_30)
		end,
		function(arg0_31)
			arg0_24:ShowOrHideResUI(arg0_24.theme:ApplyDefaultResUI())
			arg0_24.sequenceView:Execute(arg0_31)
		end
	}, function()
		arg0_24:SetUpSilentChecker()
		arg0_24:emit(var0_0.ON_ENTER_DONE)

		arg0_24.mainCG.blocksRaycasts = true

		if arg2_24 then
			gcAll()
		end
	end)
end

function var0_0.SetUpSilentChecker(arg0_33)
	local var0_33 = getProxy(SettingsProxy):GetMainSceneScreenSleepTime()

	arg0_33.defaultSleepTimeout = Screen.sleepTimeout
	Screen.sleepTimeout = var0_33

	if SettingsMainScenePanel.IsEnableStandbyMode() then
		arg0_33.silentChecker:SetUp()
	end
end

function var0_0.RevertSleepTimeout(arg0_34)
	if arg0_34.defaultSleepTimeout and Screen.sleepTimeout ~= arg0_34.defaultSleepTimeout then
		Screen.sleepTimeout = arg0_34.defaultSleepTimeout
	end

	arg0_34.defaultSleepTimeout = nil
end

function var0_0.FoldPanels(arg0_35, arg1_35)
	if not arg0_35.theme then
		return
	end

	arg0_35.foldFlag = arg1_35

	arg0_35.theme:OnFoldPanels(arg1_35)
	arg0_35.paintingView:Fold(arg1_35, 0.5)
	pg.playerResUI:Fold(arg1_35, 0.5)
end

function var0_0.HidePanel(arg0_36, arg1_36)
	if not arg0_36.theme then
		return
	end

	if arg0_36.foldFlag == arg1_36 then
		return
	end

	arg0_36.foldFlag = arg1_36

	arg0_36.theme:OnFoldPanels(arg1_36)
	pg.playerResUI:Fold(arg1_36, 0.5)
end

function var0_0.SwitchToNextShip(arg0_37)
	if arg0_37.paintingView:IsLoading() or arg0_37.bgView:IsLoading() or not arg0_37.theme then
		return
	end

	local var0_37 = getProxy(PlayerProxy):getRawData():GetNextFlagShip()

	if arg0_37.bgView.ship:getSkinId() ~= var0_37:getSkinId() or arg0_37.bgView.ship.id ~= var0_37.id then
		arg0_37.bgView:Refresh(var0_37)
		arg0_37:PlayBgm(var0_37)
		arg0_37.paintingView:Refresh(var0_37, arg0_37.theme:GetPaintingOffset(var0_37))
		arg0_37.effectView:Refresh(var0_37)
		arg0_37.theme:OnSwitchToNextShip(var0_37)
	end
end

function var0_0.UpdateFlagShip(arg0_38, arg1_38, arg2_38)
	if arg0_38.paintingView:IsLoading() or arg0_38.bgView:IsLoading() or not arg0_38.theme then
		return
	end

	local var0_38 = arg2_38.callback

	arg0_38.bgView:Refresh(arg1_38)
	arg0_38:PlayBgm(arg1_38)
	arg0_38.paintingView:SetOnceLoadedCall(var0_38)
	arg0_38.paintingView:Refresh(arg1_38, arg0_38.theme:GetPaintingOffset(arg1_38))
	arg0_38.effectView:Refresh(arg1_38)
	arg0_38.theme:OnSwitchToNextShip(arg1_38)
end

function var0_0.PlayChangeSkinActionOut(arg0_39, arg1_39)
	arg0_39.paintingView:PlayChangeSkinActionOut(arg1_39)
end

function var0_0.PlayChangeSkinActionIn(arg0_40, arg1_40)
	arg0_40.paintingView:PlayChangeSkinActionIn(arg1_40)
end

function var0_0.CheckAndReplayBgm(arg0_41)
	local var0_41 = arg0_41:GetFlagShip()

	arg0_41.theme:Refresh(var0_41)
	arg0_41:PlayBgm(var0_41)
end

function var0_0.SetEffectPanelVisible(arg0_42, arg1_42)
	if arg0_42.theme then
		arg0_42.theme:SetEffectPanelVisible(arg1_42)
	end
end

function var0_0.OnVisible(arg0_43)
	local var0_43 = arg0_43.themes[arg0_43:GetThemeStyle()]

	if not (not arg0_43.theme or var0_43 ~= arg0_43.theme) then
		arg0_43:Refresh()
	else
		arg0_43:UnloadTheme()
		arg0_43:SetUp(true)
	end
end

function var0_0.Refresh(arg0_44)
	arg0_44.mainCG.blocksRaycasts = false

	seriesAsync({
		function(arg0_45)
			arg0_44.awakeSequenceView:Execute(arg0_45)
		end,
		function(arg0_46)
			arg0_44.isInit = true

			arg0_44:ShowOrHideResUI(arg0_44.theme:ApplyDefaultResUI())

			local var0_46 = arg0_44:GetFlagShip()

			arg0_44.bgView:Refresh(var0_46)
			arg0_44.paintingView:Refresh(var0_46, arg0_44.theme:GetPaintingOffset(var0_46))
			arg0_44.effectView:Refresh(var0_46)
			arg0_44.theme:Refresh(var0_46)
			arg0_44:PlayBgm(var0_46)
			pg.redDotHelper:Refresh()
			arg0_46()
		end,
		function(arg0_47)
			arg0_44.sequenceView:Execute(arg0_47)
		end
	}, function()
		arg0_44:SetUpSilentChecker()
		arg0_44:emit(var0_0.ON_ENTER_DONE)

		arg0_44.mainCG.blocksRaycasts = true
	end)
end

function var0_0.OnDisVisible(arg0_49)
	arg0_49:FoldPanels(false)
	arg0_49.paintingView:Disable()
	arg0_49.bgView:Disable()
	arg0_49.sequenceView:Disable()
	arg0_49.awakeSequenceView:Disable()

	if arg0_49.theme then
		arg0_49.theme:Disable()
	end

	pg.redDotHelper:Disable()
	arg0_49.buffDescPage:Disable()
	arg0_49.silentChecker:Disable()

	if arg0_49.silentView and arg0_49.silentView:isShowing() then
		arg0_49:ExitSilentView()
	end

	arg0_49.calibrationPage:Destroy()
	arg0_49.calibrationPage:Reset()
	arg0_49.skinExperienceDisplayPage:Destroy()
	arg0_49.skinExperienceDisplayPage:Reset()
	arg0_49.liveAreaPage:Destroy()
	arg0_49.liveAreaPage:Reset()

	arg0_49.isInit = false

	arg0_49:RevertSleepTimeout()
end

function var0_0.UnloadTheme(arg0_50)
	if arg0_50.theme then
		arg0_50.theme:Destroy()
		arg0_50.theme:Reset()

		arg0_50.theme = nil
	end
end

function var0_0.ExitCalibrationView(arg0_51)
	if arg0_51.calibrationPage and arg0_51.calibrationPage:GetLoaded() and arg0_51.calibrationPage:isShowing() then
		triggerButton(arg0_51.calibrationPage.backBtn)
	end
end

function var0_0.ExitSilentView(arg0_52)
	if arg0_52.silentView and arg0_52.silentView:isShowing() then
		arg0_52:FoldPanels(false)
		arg0_52.silentView:Destroy()
		arg0_52.silentView:Reset()
	end
end

function var0_0.GameLogout(arg0_53)
	arg0_53:ExitCalibrationView()
	arg0_53:ExitSilentView()
end

function var0_0.onBackPressed(arg0_54)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if arg0_54.silentView and arg0_54.silentView:isShowing() then
		arg0_54:ExitSilentView()

		return
	end

	if arg0_54.liveAreaPage and arg0_54.liveAreaPage:GetLoaded() and arg0_54.liveAreaPage:isShowing() then
		arg0_54.liveAreaPage:Hide()

		return
	end

	if arg0_54.calibrationPage and arg0_54.calibrationPage:GetLoaded() and arg0_54.calibrationPage:isShowing() then
		triggerButton(arg0_54.calibrationPage._parentTf)

		return
	end

	pg.SdkMgr.GetInstance():OnAndoridBackPress()
	pg.PushNotificationMgr.GetInstance():PushAll()
end

function var0_0.willExit(arg0_55)
	arg0_55.bgView:Dispose()

	arg0_55.bgView = nil

	if arg0_55.calibrationPage then
		arg0_55.calibrationPage:Destroy()

		arg0_55.calibrationPage = nil
	end

	if arg0_55.silentView then
		arg0_55.silentView:Destroy()

		arg0_55.silentView = nil
	end

	arg0_55.paintingView:Dispose()

	arg0_55.paintingView = nil

	arg0_55.liveAreaPage:Destroy()

	arg0_55.liveAreaPage = nil

	arg0_55.sequenceView:Dispose()

	arg0_55.sequenceView = nil

	arg0_55.awakeSequenceView:Dispose()

	arg0_55.awakeSequenceView = nil

	arg0_55.effectView:Dispose()

	arg0_55.effectView = nil

	pg.redDotHelper:Dispose()

	pg.redDotHelper = nil

	arg0_55.buffDescPage:Destroy()

	arg0_55.buffDescPage = nil

	arg0_55.silentChecker:Dispose()

	arg0_55.silentChecker = nil

	arg0_55.skinExperienceDisplayPage:Destroy()

	arg0_55.skinExperienceDisplayPage = nil

	arg0_55:UnloadTheme()
	arg0_55:RevertSleepTimeout()
end

return var0_0
