local var0_0 = class("NewMainScene", import("..base.BaseUI"))

var0_0.THEME_CLASSIC = 1
var0_0.THEME_MELLOW = 2
var0_0.OPEN_LIVEAREA = "NewMainScene:OPEN_LIVEAREA"
var0_0.UPDATE_COVER = "NewMainScene:UPDATE_COVER"
var0_0.FOLD = "NewMainScene:FOLD"
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
	arg0_15:bind(var0_0.ON_CHANGE_SKIN, function(arg0_17)
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
	arg0_15:bind(var0_0.ON_SKIN_FREEUSAGE_DESC, function(arg0_21, arg1_21)
		arg0_15.skinExperienceDisplayPage:ExecuteAction("Show", arg1_21)
	end)
	arg0_15:bind(NewMainScene.OPEN_LIVEAREA, function(arg0_22)
		arg0_15.liveAreaPage:ExecuteAction("Show")
	end)
	arg0_15:SetUp(false, true)
end

function var0_0.SetUp(arg0_23, arg1_23, arg2_23)
	arg0_23.mainCG.blocksRaycasts = false
	arg0_23.isInit = false
	arg0_23.resAnimFlag = false

	local var0_23

	seriesAsync({
		function(arg0_24)
			arg0_23.awakeSequenceView:Execute(arg0_24)
		end,
		function(arg0_25)
			var0_23 = arg0_23:GetFlagShip()

			arg0_23.bgView:Init(var0_23)
			onNextTick(arg0_25)
		end,
		function(arg0_26)
			arg0_23.theme = arg0_23.themes[arg0_23:GetThemeStyle()]

			arg0_23.theme:ExecuteAction("Show", arg0_26)
		end,
		function(arg0_27)
			onNextTick(arg0_27)
		end,
		function(arg0_28)
			arg0_23.isInit = true

			arg0_23.theme:PlayEnterAnimation(var0_23, arg0_28)

			local var0_28 = arg0_23.theme:GetPaintingOffset(var0_23)

			arg0_23.paintingView:Init(var0_23, var0_28, arg1_23)

			arg0_23.resAnimFlag = true
		end,
		function(arg0_29)
			arg0_23:PlayBgm(var0_23)
			arg0_23.effectView:Init(var0_23)
			arg0_23.theme:init(var0_23)
			onNextTick(arg0_29)
		end,
		function(arg0_30)
			arg0_23:ShowOrHideResUI(arg0_23.theme:ApplyDefaultResUI())
			arg0_23.sequenceView:Execute(arg0_30)
		end
	}, function()
		arg0_23:SetUpSilentChecker()
		arg0_23:emit(var0_0.ON_ENTER_DONE)

		arg0_23.mainCG.blocksRaycasts = true

		if arg2_23 then
			gcAll()
		end
	end)
end

function var0_0.SetUpSilentChecker(arg0_32)
	local var0_32 = getProxy(SettingsProxy):GetMainSceneScreenSleepTime()

	arg0_32.defaultSleepTimeout = Screen.sleepTimeout
	Screen.sleepTimeout = var0_32

	if SettingsMainScenePanel.IsEnableStandbyMode() then
		arg0_32.silentChecker:SetUp()
	end
end

function var0_0.RevertSleepTimeout(arg0_33)
	if arg0_33.defaultSleepTimeout and Screen.sleepTimeout ~= arg0_33.defaultSleepTimeout then
		Screen.sleepTimeout = arg0_33.defaultSleepTimeout
	end

	arg0_33.defaultSleepTimeout = nil
end

function var0_0.FoldPanels(arg0_34, arg1_34)
	if not arg0_34.theme then
		return
	end

	arg0_34.theme:OnFoldPanels(arg1_34)
	arg0_34.paintingView:Fold(arg1_34, 0.5)
	pg.playerResUI:Fold(arg1_34, 0.5)
end

function var0_0.HidePanel(arg0_35, arg1_35)
	if not arg0_35.theme then
		return
	end

	arg0_35.theme:OnFoldPanels(arg1_35)
	pg.playerResUI:Fold(arg1_35, 0.5)
end

function var0_0.SwitchToNextShip(arg0_36)
	if arg0_36.paintingView:IsLoading() or arg0_36.bgView:IsLoading() or not arg0_36.theme then
		return
	end

	local var0_36 = getProxy(PlayerProxy):getRawData():GetNextFlagShip()

	if arg0_36.bgView.ship.skinId ~= var0_36.skinId or arg0_36.bgView.ship.id ~= var0_36.id then
		arg0_36.bgView:Refresh(var0_36)
		arg0_36:PlayBgm(var0_36)
		arg0_36.paintingView:Refresh(var0_36, arg0_36.theme:GetPaintingOffset(var0_36))
		arg0_36.effectView:Refresh(var0_36)
		arg0_36.theme:OnSwitchToNextShip(var0_36)
	end
end

function var0_0.UpdateFlagShip(arg0_37, arg1_37, arg2_37)
	if arg0_37.paintingView:IsLoading() or arg0_37.bgView:IsLoading() or not arg0_37.theme then
		return
	end

	local var0_37 = arg2_37.callback

	arg0_37.bgView:Refresh(arg1_37)
	arg0_37:PlayBgm(arg1_37)
	arg0_37.paintingView:SetOnceLoadedCall(var0_37)
	arg0_37.paintingView:Refresh(arg1_37, arg0_37.theme:GetPaintingOffset(arg1_37))
	arg0_37.effectView:Refresh(arg1_37)
	arg0_37.theme:OnSwitchToNextShip(arg1_37)
end

function var0_0.PlayChangeSkinActionOut(arg0_38, arg1_38)
	arg0_38.paintingView:PlayChangeSkinActionOut(arg1_38)
end

function var0_0.PlayChangeSkinActionIn(arg0_39, arg1_39)
	arg0_39.paintingView:PlayChangeSkinActionIn(arg1_39)
end

function var0_0.CheckAndReplayBgm(arg0_40)
	local var0_40 = arg0_40:GetFlagShip()

	arg0_40.theme:Refresh(var0_40)
	arg0_40:PlayBgm(var0_40)
end

function var0_0.SetEffectPanelVisible(arg0_41, arg1_41)
	if arg0_41.theme then
		arg0_41.theme:SetEffectPanelVisible(arg1_41)
	end
end

function var0_0.OnVisible(arg0_42)
	local var0_42 = arg0_42.themes[arg0_42:GetThemeStyle()]

	if not (not arg0_42.theme or var0_42 ~= arg0_42.theme) then
		arg0_42:Refresh()
	else
		arg0_42:UnloadTheme()
		arg0_42:SetUp(true)
	end
end

function var0_0.Refresh(arg0_43)
	arg0_43.mainCG.blocksRaycasts = false

	seriesAsync({
		function(arg0_44)
			arg0_43.awakeSequenceView:Execute(arg0_44)
		end,
		function(arg0_45)
			arg0_43.isInit = true

			arg0_43:ShowOrHideResUI(arg0_43.theme:ApplyDefaultResUI())

			local var0_45 = arg0_43:GetFlagShip()

			arg0_43.bgView:Refresh(var0_45)
			arg0_43.paintingView:Refresh(var0_45, arg0_43.theme:GetPaintingOffset(var0_45))
			arg0_43.effectView:Refresh(var0_45)
			arg0_43.theme:Refresh(var0_45)
			arg0_43:PlayBgm(var0_45)
			pg.redDotHelper:Refresh()
			arg0_45()
		end,
		function(arg0_46)
			arg0_43.sequenceView:Execute(arg0_46)
		end
	}, function()
		arg0_43:SetUpSilentChecker()
		arg0_43:emit(var0_0.ON_ENTER_DONE)

		arg0_43.mainCG.blocksRaycasts = true
	end)
end

function var0_0.OnDisVisible(arg0_48)
	arg0_48:FoldPanels(false)
	arg0_48.paintingView:Disable()
	arg0_48.bgView:Disable()
	arg0_48.sequenceView:Disable()
	arg0_48.awakeSequenceView:Disable()
	arg0_48.theme:Disable()
	pg.redDotHelper:Disable()
	arg0_48.buffDescPage:Disable()
	arg0_48.silentChecker:Disable()

	if arg0_48.silentView and arg0_48.silentView:isShowing() then
		arg0_48:ExitSilentView()
	end

	arg0_48.calibrationPage:Destroy()
	arg0_48.calibrationPage:Reset()
	arg0_48.skinExperienceDisplayPage:Destroy()
	arg0_48.skinExperienceDisplayPage:Reset()
	arg0_48.liveAreaPage:Destroy()
	arg0_48.liveAreaPage:Reset()

	arg0_48.isInit = false

	arg0_48:RevertSleepTimeout()
end

function var0_0.UnloadTheme(arg0_49)
	if arg0_49.theme then
		arg0_49.theme:Destroy()
		arg0_49.theme:Reset()

		arg0_49.theme = nil
	end
end

function var0_0.ExitCalibrationView(arg0_50)
	if arg0_50.calibrationPage and arg0_50.calibrationPage:GetLoaded() and arg0_50.calibrationPage:isShowing() then
		triggerButton(arg0_50.calibrationPage.backBtn)
	end
end

function var0_0.ExitSilentView(arg0_51)
	if arg0_51.silentView and arg0_51.silentView:GetLoaded() and arg0_51.silentView:isShowing() then
		arg0_51:FoldPanels(false)
		arg0_51.silentView:Destroy()
		arg0_51.silentView:Reset()
	end
end

function var0_0.GameLogout(arg0_52)
	arg0_52:ExitCalibrationView()
	arg0_52:ExitSilentView()
end

function var0_0.onBackPressed(arg0_53)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if arg0_53.silentView and arg0_53.silentView:isShowing() then
		arg0_53:ExitSilentView()

		return
	end

	if arg0_53.liveAreaPage and arg0_53.liveAreaPage:GetLoaded() and arg0_53.liveAreaPage:isShowing() then
		arg0_53.liveAreaPage:Hide()

		return
	end

	if arg0_53.calibrationPage and arg0_53.calibrationPage:GetLoaded() and arg0_53.calibrationPage:isShowing() then
		triggerButton(arg0_53.calibrationPage._parentTf)

		return
	end

	pg.SdkMgr.GetInstance():OnAndoridBackPress()
	pg.PushNotificationMgr.GetInstance():PushAll()
end

function var0_0.willExit(arg0_54)
	arg0_54.bgView:Dispose()

	arg0_54.bgView = nil

	if arg0_54.calibrationPage then
		arg0_54.calibrationPage:Destroy()

		arg0_54.calibrationPage = nil
	end

	if arg0_54.silentView then
		arg0_54.silentView:Destroy()

		arg0_54.silentView = nil
	end

	arg0_54.paintingView:Dispose()

	arg0_54.paintingView = nil

	arg0_54.liveAreaPage:Destroy()

	arg0_54.liveAreaPage = nil

	arg0_54.sequenceView:Dispose()

	arg0_54.sequenceView = nil

	arg0_54.awakeSequenceView:Dispose()

	arg0_54.awakeSequenceView = nil

	arg0_54.effectView:Dispose()

	arg0_54.effectView = nil

	pg.redDotHelper:Dispose()

	pg.redDotHelper = nil

	arg0_54.buffDescPage:Destroy()

	arg0_54.buffDescPage = nil

	arg0_54.silentChecker:Dispose()

	arg0_54.silentChecker = nil

	arg0_54.skinExperienceDisplayPage:Destroy()

	arg0_54.skinExperienceDisplayPage = nil

	arg0_54:UnloadTheme()
	arg0_54:RevertSleepTimeout()
end

return var0_0
