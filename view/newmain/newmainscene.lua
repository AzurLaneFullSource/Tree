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

function var0_0.forceGC(arg0_3)
	return true
end

function var0_0.GetThemeStyle(arg0_4)
	return getProxy(SettingsProxy):GetMainSceneThemeStyle()
end

function var0_0.PlayBGM(arg0_5)
	return
end

function var0_0.GetFlagShip(arg0_6)
	return (getProxy(PlayerProxy):getRawData():GetFlagShip())
end

function var0_0.PlayBgm(arg0_7, arg1_7)
	local var0_7
	local var1_7

	if underscore.any({
		function()
			if arg1_7:IsBgmSkin() and getProxy(SettingsProxy):IsBGMEnable() then
				var0_7 = arg1_7:GetSkinBgm()
			end

			return tobool(var0_7)
		end,
		function()
			if getProxy(SettingsProxy):IsEnableMainMusicPlayer() and getProxy(AppreciateProxy):CanPlayMainMusicPlayer() then
				var0_7 = "MainMusicPlayer"
				var1_7 = {
					loopType = getProxy(AppreciateProxy):getMusicPlayerLoopType(),
					albumName = getProxy(AppreciateProxy):getMainPlayerAlbumName()
				}
			end

			return tobool(var0_7)
		end,
		function()
			local var0_10, var1_10 = MainBGView.GetBgAndBgm()

			var0_7 = var1_10

			return tobool(var0_7)
		end,
		function()
			var0_7 = var0_0.super.getBGM(arg0_7)

			return tobool(var0_7)
		end
	}, function(arg0_12)
		return arg0_12()
	end) then
		pg.BgmMgr.GetInstance():Push(arg0_7.__cname, var0_7, var1_7)
	end
end

function var0_0.ResUISettings(arg0_13)
	return {
		showType = PlayerResUI.TYPE_ALL,
		anim = not arg0_13.resAnimFlag
	}
end

function var0_0.ShowOrHideResUI(arg0_14, arg1_14)
	if not arg0_14.isInit then
		return
	end

	var0_0.super.ShowOrHideResUI(arg0_14, arg1_14)
end

function var0_0.init(arg0_15)
	arg0_15.mainCG = GetOrAddComponent(arg0_15._tf, typeof(CanvasGroup))
	arg0_15.bgView = MainBGView.New(arg0_15._tf:Find("Sea/bg"))
	arg0_15.paintingView = MainPaintingView.New(arg0_15._tf:Find("paint"), arg0_15._tf:Find("paintBg"), arg0_15.event)
	arg0_15.effectView = MainEffectView.New(arg0_15._tf:Find("paint/effect"))
	arg0_15.buffDescPage = MainBuffDescPage.New(arg0_15._tf, arg0_15.event)
	arg0_15.calibrationPage = MainCalibrationPage.New(arg0_15._tf, arg0_15.event, arg0_15.contextData)
	arg0_15.silentView = MainSilentView.New(arg0_15._tf, arg0_15.event, arg0_15.contextData)
	arg0_15.silentChecker = MainSilentChecker.New(arg0_15.event)
	arg0_15.skinExperienceDisplayPage = SkinExperienceDiplayPage.New(arg0_15._tf, arg0_15.event)

	if USE_OLD_MAIN_LIVE_AREA_UI then
		arg0_15.liveAreaPage = MainLiveAreaOldPage.New(arg0_15._tf, arg0_15.event)
	else
		arg0_15.liveAreaPage = MainLiveAreaPage.New(arg0_15._tf, arg0_15.event)
	end

	pg.redDotHelper = MainReddotView.New()
	arg0_15.sequenceView = MainSequenceView.New()
	arg0_15.awakeSequenceView = MainAwakeSequenceView.New()
	arg0_15.themes = {
		[var0_0.THEME_CLASSIC] = NewMainClassicTheme.New(arg0_15._tf, arg0_15.event, arg0_15.contextData),
		[var0_0.THEME_MELLOW] = NewMainMellowTheme.New(arg0_15._tf, arg0_15.event, arg0_15.contextData)
	}

	for iter0_15, iter1_15 in pairs(arg0_15.themes) do
		iter1_15:RegisterView(arg0_15)
	end
end

function var0_0.didEnter(arg0_16)
	arg0_16:bind(var0_0.FOLD, function(arg0_17, arg1_17)
		arg0_16:FoldPanels(arg1_17)

		local var0_17 = arg0_16.paintingView.ship

		if not var0_17 then
			return
		end

		arg0_16.calibrationPage:ExecuteAction("ShowOrHide", arg1_17, arg0_16.bgView.ship, arg0_16.theme:GetPaintingOffset(var0_17), arg0_16.theme:GetCalibrationBG())
	end)
	arg0_16:bind(var0_0.HIDE, function(arg0_18, arg1_18)
		arg0_16:HidePanel(arg1_18)

		local var0_18 = arg0_16.paintingView.ship

		if not var0_18 then
			return
		end

		arg0_16.calibrationPage:ExecuteAction("ShowOrHide", arg1_18, arg0_16.bgView.ship, arg0_16.theme:GetPaintingOffset(var0_18), arg0_16.theme:GetCalibrationBG())
	end)
	arg0_16:bind(var0_0.ON_CHANGE_SKIN, function(arg0_19)
		arg0_16:SwitchToNextShip()
	end)
	arg0_16:bind(var0_0.ENTER_SILENT_VIEW, function()
		arg0_16:ExitCalibrationView()
		arg0_16:FoldPanels(true)
		arg0_16.silentView:ExecuteAction("Show")
	end)
	arg0_16:bind(GAME.WILL_LOGOUT, function()
		arg0_16:GameLogout()
	end)
	arg0_16:bind(var0_0.EXIT_SILENT_VIEW, function()
		arg0_16:ExitSilentView()
		arg0_16:SetUpSilentChecker()
		pg.redDotHelper:_Refresh()
	end)
	arg0_16:bind(var0_0.ON_SKIN_FREEUSAGE_DESC, function(arg0_23, arg1_23)
		arg0_16.skinExperienceDisplayPage:ExecuteAction("Show", arg1_23)
	end)
	arg0_16:bind(NewMainScene.OPEN_LIVEAREA, function(arg0_24)
		arg0_16.liveAreaPage:ExecuteAction("Show")
	end)
	arg0_16:SetUp(false, true)
end

function var0_0.SetUp(arg0_25, arg1_25, arg2_25)
	arg0_25.mainCG.blocksRaycasts = false
	arg0_25.isInit = false
	arg0_25.resAnimFlag = false

	local var0_25

	seriesAsync({
		function(arg0_26)
			arg0_25.awakeSequenceView:Execute(arg0_26)
		end,
		function(arg0_27)
			var0_25 = arg0_25:GetFlagShip()

			arg0_25.bgView:Init(var0_25)
			onNextTick(arg0_27)
		end,
		function(arg0_28)
			arg0_25.theme = arg0_25.themes[arg0_25:GetThemeStyle()]

			arg0_25.theme:ExecuteAction("Show", arg0_28)
		end,
		function(arg0_29)
			onNextTick(arg0_29)
		end,
		function(arg0_30)
			arg0_25.isInit = true

			arg0_25.theme:PlayEnterAnimation(var0_25, arg0_30)

			local var0_30 = arg0_25.theme:GetPaintingOffset(var0_25)

			arg0_25.paintingView:Init(var0_25, var0_30, arg1_25)

			arg0_25.resAnimFlag = true
		end,
		function(arg0_31)
			arg0_25:PlayBgm(var0_25)
			arg0_25.effectView:Init(var0_25)
			arg0_25.theme:init(var0_25)
			onNextTick(arg0_31)
		end,
		function(arg0_32)
			arg0_25:ShowOrHideResUI(arg0_25.theme:ApplyDefaultResUI())
			arg0_25.sequenceView:Execute(arg0_32)
		end
	}, function()
		arg0_25:SetUpSilentChecker()
		arg0_25:emit(var0_0.ON_ENTER_DONE)

		arg0_25.mainCG.blocksRaycasts = true

		if arg2_25 then
			gcAll()
		end
	end)
end

function var0_0.SetUpSilentChecker(arg0_34)
	local var0_34 = getProxy(SettingsProxy):GetMainSceneScreenSleepTime()

	arg0_34.defaultSleepTimeout = Screen.sleepTimeout
	Screen.sleepTimeout = var0_34

	if SettingsMainScenePanel.IsEnableStandbyMode() then
		arg0_34.silentChecker:SetUp()
	end
end

function var0_0.RevertSleepTimeout(arg0_35)
	if arg0_35.defaultSleepTimeout and Screen.sleepTimeout ~= arg0_35.defaultSleepTimeout then
		Screen.sleepTimeout = arg0_35.defaultSleepTimeout
	end

	arg0_35.defaultSleepTimeout = nil
end

function var0_0.FoldPanels(arg0_36, arg1_36)
	if not arg0_36.theme then
		return
	end

	arg0_36.foldFlag = arg1_36

	arg0_36.theme:OnFoldPanels(arg1_36)
	arg0_36.paintingView:Fold(arg1_36, 0.5)
	pg.playerResUI:Fold(arg1_36, 0.5)
end

function var0_0.HidePanel(arg0_37, arg1_37)
	if not arg0_37.theme then
		return
	end

	if arg0_37.foldFlag == arg1_37 then
		return
	end

	arg0_37.foldFlag = arg1_37

	arg0_37.theme:OnFoldPanels(arg1_37)
	pg.playerResUI:Fold(arg1_37, 0.5)
end

function var0_0.SwitchToNextShip(arg0_38)
	if arg0_38.paintingView:IsLoading() or arg0_38.bgView:IsLoading() or not arg0_38.theme then
		return
	end

	local var0_38 = getProxy(PlayerProxy):getRawData():GetNextFlagShip()

	if arg0_38.bgView.ship:getSkinId() ~= var0_38:getSkinId() or arg0_38.bgView.ship.id ~= var0_38.id then
		arg0_38.bgView:Refresh(var0_38)
		arg0_38:PlayBgm(var0_38)
		arg0_38.paintingView:Refresh(var0_38, arg0_38.theme:GetPaintingOffset(var0_38))
		arg0_38.effectView:Refresh(var0_38)
		arg0_38.theme:OnSwitchToNextShip(var0_38)
	end
end

function var0_0.UpdateFlagShip(arg0_39, arg1_39, arg2_39)
	if arg0_39.paintingView:IsLoading() or arg0_39.bgView:IsLoading() or not arg0_39.theme then
		return
	end

	local var0_39 = arg2_39.callback

	arg0_39.bgView:Refresh(arg1_39)
	arg0_39:PlayBgm(arg1_39)
	arg0_39.paintingView:SetOnceLoadedCall(var0_39)
	arg0_39.paintingView:Refresh(arg1_39, arg0_39.theme:GetPaintingOffset(arg1_39))
	arg0_39.effectView:Refresh(arg1_39)
	arg0_39.theme:OnSwitchToNextShip(arg1_39)
end

function var0_0.PlayChangeSkinActionOut(arg0_40, arg1_40)
	arg0_40.paintingView:PlayChangeSkinActionOut(arg1_40)
end

function var0_0.PlayChangeSkinActionIn(arg0_41, arg1_41)
	arg0_41.paintingView:PlayChangeSkinActionIn(arg1_41)
end

function var0_0.CheckAndReplayBgm(arg0_42)
	local var0_42 = arg0_42:GetFlagShip()

	arg0_42.theme:Refresh(var0_42)
	arg0_42:PlayBgm(var0_42)
end

function var0_0.SetEffectPanelVisible(arg0_43, arg1_43)
	if arg0_43.theme then
		arg0_43.theme:SetEffectPanelVisible(arg1_43)
	end
end

function var0_0.OnVisible(arg0_44)
	local var0_44 = arg0_44.themes[arg0_44:GetThemeStyle()]

	if not (not arg0_44.theme or var0_44 ~= arg0_44.theme) then
		arg0_44:Refresh()
	else
		arg0_44:UnloadTheme()
		arg0_44:SetUp(true)
	end
end

function var0_0.Refresh(arg0_45)
	arg0_45.mainCG.blocksRaycasts = false

	seriesAsync({
		function(arg0_46)
			arg0_45.awakeSequenceView:Execute(arg0_46)
		end,
		function(arg0_47)
			arg0_45.isInit = true

			arg0_45:ShowOrHideResUI(arg0_45.theme:ApplyDefaultResUI())

			local var0_47 = arg0_45:GetFlagShip()

			arg0_45.bgView:Refresh(var0_47)
			arg0_45.paintingView:Refresh(var0_47, arg0_45.theme:GetPaintingOffset(var0_47))
			arg0_45.effectView:Refresh(var0_47)
			arg0_45.theme:Refresh(var0_47)
			arg0_45:PlayBgm(var0_47)
			pg.redDotHelper:Refresh()
			arg0_47()
		end,
		function(arg0_48)
			arg0_45.sequenceView:Execute(arg0_48)
		end
	}, function()
		arg0_45:SetUpSilentChecker()
		arg0_45:emit(var0_0.ON_ENTER_DONE)

		arg0_45.mainCG.blocksRaycasts = true
	end)
end

function var0_0.OnDisVisible(arg0_50)
	arg0_50:FoldPanels(false)
	arg0_50.paintingView:Disable()
	arg0_50.bgView:Disable()
	arg0_50.sequenceView:Disable()
	arg0_50.awakeSequenceView:Disable()

	if arg0_50.theme then
		arg0_50.theme:Disable()
	end

	pg.redDotHelper:Disable()
	arg0_50.buffDescPage:Disable()
	arg0_50.silentChecker:Disable()

	if arg0_50.silentView and arg0_50.silentView:isShowing() then
		arg0_50:ExitSilentView()
	end

	arg0_50.calibrationPage:Destroy()
	arg0_50.calibrationPage:Reset()
	arg0_50.skinExperienceDisplayPage:Destroy()
	arg0_50.skinExperienceDisplayPage:Reset()
	arg0_50.liveAreaPage:Destroy()
	arg0_50.liveAreaPage:Reset()

	arg0_50.isInit = false

	arg0_50:RevertSleepTimeout()
end

function var0_0.UnloadTheme(arg0_51)
	if arg0_51.theme then
		arg0_51.theme:Destroy()
		arg0_51.theme:Reset()

		arg0_51.theme = nil
	end
end

function var0_0.ExitCalibrationView(arg0_52)
	if arg0_52.calibrationPage and arg0_52.calibrationPage:GetLoaded() and arg0_52.calibrationPage:isShowing() then
		triggerButton(arg0_52.calibrationPage.backBtn)
	end
end

function var0_0.ExitSilentView(arg0_53)
	if arg0_53.silentView and arg0_53.silentView:isShowing() then
		arg0_53:FoldPanels(false)
		arg0_53.silentView:Destroy()
		arg0_53.silentView:Reset()
	end
end

function var0_0.GameLogout(arg0_54)
	arg0_54:ExitCalibrationView()
	arg0_54:ExitSilentView()
end

function var0_0.onBackPressed(arg0_55)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if arg0_55.silentView and arg0_55.silentView:isShowing() then
		arg0_55:ExitSilentView()

		return
	end

	if arg0_55.liveAreaPage and arg0_55.liveAreaPage:GetLoaded() and arg0_55.liveAreaPage:isShowing() then
		arg0_55.liveAreaPage:Hide()

		return
	end

	if arg0_55.calibrationPage and arg0_55.calibrationPage:GetLoaded() and arg0_55.calibrationPage:isShowing() then
		triggerButton(arg0_55.calibrationPage._parentTf)

		return
	end

	pg.SdkMgr.GetInstance():OnAndoridBackPress()
	pg.PushNotificationMgr.GetInstance():PushAll()
end

function var0_0.willExit(arg0_56)
	arg0_56.bgView:Dispose()

	arg0_56.bgView = nil

	arg0_56:UnloadTheme()

	if arg0_56.calibrationPage then
		arg0_56.calibrationPage:Destroy()

		arg0_56.calibrationPage = nil
	end

	if arg0_56.silentView then
		arg0_56.silentView:Destroy()

		arg0_56.silentView = nil
	end

	arg0_56.paintingView:Dispose()

	arg0_56.paintingView = nil

	arg0_56.liveAreaPage:Destroy()

	arg0_56.liveAreaPage = nil

	arg0_56.sequenceView:Dispose()

	arg0_56.sequenceView = nil

	arg0_56.awakeSequenceView:Dispose()

	arg0_56.awakeSequenceView = nil

	arg0_56.effectView:Dispose()

	arg0_56.effectView = nil

	pg.redDotHelper:Dispose()

	pg.redDotHelper = nil

	arg0_56.buffDescPage:Destroy()

	arg0_56.buffDescPage = nil

	arg0_56.silentChecker:Dispose()

	arg0_56.silentChecker = nil

	arg0_56.skinExperienceDisplayPage:Destroy()

	arg0_56.skinExperienceDisplayPage = nil

	arg0_56:RevertSleepTimeout()
end

return var0_0
