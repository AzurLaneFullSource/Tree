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

function var0_0.RevertAsmrShip(arg0_7)
	getProxy(BayProxy):ClearChangeSkinAsmr()
end

function var0_0.PlayBgm(arg0_8, arg1_8)
	local var0_8
	local var1_8

	if underscore.any({
		function()
			if arg1_8:IsBgmSkin() and getProxy(SettingsProxy):IsBGMEnable() then
				var0_8 = arg1_8:GetSkinBgm()
			end

			return tobool(var0_8)
		end,
		function()
			if getProxy(SettingsProxy):IsEnableMainMusicPlayer() and getProxy(AppreciateProxy):CanPlayMainMusicPlayer() then
				var0_8 = "MainMusicPlayer"
				var1_8 = {
					loopType = getProxy(AppreciateProxy):getMusicPlayerLoopType(),
					albumName = getProxy(AppreciateProxy):getMainPlayerAlbumName()
				}
			end

			return tobool(var0_8)
		end,
		function()
			local var0_11, var1_11 = MainBGView.GetBgAndBgm()

			var0_8 = var1_11

			return tobool(var0_8)
		end,
		function()
			var0_8 = var0_0.super.getBGM(arg0_8)

			return tobool(var0_8)
		end
	}, function(arg0_13)
		return arg0_13()
	end) then
		pg.BgmMgr.GetInstance():Push(arg0_8.__cname, var0_8, var1_8)
	end
end

function var0_0.ResUISettings(arg0_14)
	return {
		showType = PlayerResUI.TYPE_ALL,
		anim = not arg0_14.resAnimFlag
	}
end

function var0_0.ShowOrHideResUI(arg0_15, arg1_15)
	if not arg0_15.isInit then
		return
	end

	var0_0.super.ShowOrHideResUI(arg0_15, arg1_15)
end

function var0_0.init(arg0_16)
	arg0_16.mainCG = GetOrAddComponent(arg0_16._tf, typeof(CanvasGroup))
	arg0_16.bgView = MainBGView.New(arg0_16._tf:Find("Sea/bg"))
	arg0_16.paintingView = MainPaintingView.New(arg0_16._tf:Find("paint"), arg0_16._tf:Find("paintBg"), arg0_16.event)
	arg0_16.effectView = MainEffectView.New(arg0_16._tf:Find("paint/effect"))
	arg0_16.buffDescPage = MainBuffDescPage.New(arg0_16._tf, arg0_16.event)
	arg0_16.calibrationPage = MainCalibrationPage.New(arg0_16._tf, arg0_16.event, arg0_16.contextData)
	arg0_16.silentView = MainSilentView.New(arg0_16._tf, arg0_16.event, arg0_16.contextData)
	arg0_16.silentChecker = MainSilentChecker.New(arg0_16.event)
	arg0_16.skinExperienceDisplayPage = SkinExperienceDiplayPage.New(arg0_16._tf, arg0_16.event)

	if USE_OLD_MAIN_LIVE_AREA_UI then
		arg0_16.liveAreaPage = MainLiveAreaOldPage.New(arg0_16._tf, arg0_16.event)
	else
		arg0_16.liveAreaPage = MainLiveAreaPage.New(arg0_16._tf, arg0_16.event)
	end

	pg.redDotHelper = MainReddotView.New()
	arg0_16.sequenceView = MainSequenceView.New()
	arg0_16.awakeSequenceView = MainAwakeSequenceView.New()
	arg0_16.themes = {
		[NewMainScene.THEME_CLASSIC] = NewMainClassicTheme.New(arg0_16._tf, arg0_16.event, arg0_16.contextData),
		[NewMainScene.THEME_MELLOW] = NewMainMellowTheme.New(arg0_16._tf, arg0_16.event, arg0_16.contextData)
	}

	for iter0_16, iter1_16 in pairs(arg0_16.themes) do
		iter1_16:RegisterView(arg0_16)
	end

	arg0_16:RevertAsmrShip()
end

function var0_0.didEnter(arg0_17)
	arg0_17:bind(NewMainScene.FOLD, function(arg0_18, arg1_18)
		arg0_17:FoldPanels(arg1_18)

		local var0_18 = arg0_17.paintingView.ship

		if not var0_18 then
			return
		end

		arg0_17.calibrationPage:ExecuteAction("ShowOrHide", arg1_18, arg0_17.bgView.ship, arg0_17.theme:GetPaintingOffset(var0_18), arg0_17.theme:GetCalibrationBG())
	end)
	arg0_17:bind(NewMainScene.HIDE, function(arg0_19, arg1_19)
		arg0_17:HidePanel(arg1_19)

		local var0_19 = arg0_17.paintingView.ship

		if not var0_19 then
			return
		end

		arg0_17.calibrationPage:ExecuteAction("ShowOrHide", arg1_19, arg0_17.bgView.ship, arg0_17.theme:GetPaintingOffset(var0_19), arg0_17.theme:GetCalibrationBG())
	end)
	arg0_17:bind(NewMainScene.ON_CHANGE_SKIN, function(arg0_20)
		arg0_17:SwitchToNextShip()
	end)
	arg0_17:bind(NewMainScene.ENTER_SILENT_VIEW, function()
		arg0_17:ExitCalibrationView()
		arg0_17:FoldPanels(true)
		arg0_17.silentView:ExecuteAction("Show")
	end)
	arg0_17:bind(GAME.WILL_LOGOUT, function()
		arg0_17:GameLogout()
	end)
	arg0_17:bind(NewMainScene.EXIT_SILENT_VIEW, function()
		arg0_17:ExitSilentView()
		arg0_17:SetUpSilentChecker()
		pg.redDotHelper:_Refresh()
	end)
	arg0_17:bind(NewMainScene.ON_SKIN_FREEUSAGE_DESC, function(arg0_24, arg1_24)
		arg0_17.skinExperienceDisplayPage:ExecuteAction("Show", arg1_24)
	end)
	arg0_17:bind(NewMainScene.OPEN_LIVEAREA, function(arg0_25)
		arg0_17.liveAreaPage:ExecuteAction("Show")
	end)
	arg0_17:SetUp(false, true)
end

function var0_0.SetUp(arg0_26, arg1_26, arg2_26)
	arg0_26.mainCG.blocksRaycasts = false
	arg0_26.isInit = false
	arg0_26.resAnimFlag = false

	local var0_26

	seriesAsync({
		function(arg0_27)
			arg0_26.awakeSequenceView:Execute(arg0_27)
		end,
		function(arg0_28)
			var0_26 = arg0_26:GetFlagShip()

			arg0_26.bgView:Init(var0_26)
			onNextTick(arg0_28)
		end,
		function(arg0_29)
			arg0_26.theme = arg0_26.themes[arg0_26:GetThemeStyle()]

			arg0_26.theme:ExecuteAction("Show", arg0_29)
		end,
		function(arg0_30)
			onNextTick(arg0_30)
		end,
		function(arg0_31)
			arg0_26.isInit = true

			arg0_26.theme:PlayEnterAnimation(var0_26, arg0_31)

			local var0_31 = arg0_26.theme:GetPaintingOffset(var0_26)

			arg0_26.paintingView:Init(var0_26, var0_31, arg1_26)

			arg0_26.resAnimFlag = true
		end,
		function(arg0_32)
			arg0_26:PlayBgm(var0_26)
			arg0_26.effectView:Init(var0_26)
			arg0_26.theme:init(var0_26)
			onNextTick(arg0_32)
		end,
		function(arg0_33)
			arg0_26:ShowOrHideResUI(arg0_26.theme:ApplyDefaultResUI())
			arg0_26.sequenceView:Execute(arg0_33)
		end
	}, function()
		arg0_26:SetUpSilentChecker()
		arg0_26:emit(NewMainScene.ON_ENTER_DONE)

		arg0_26.mainCG.blocksRaycasts = true

		if arg2_26 then
			gcAll()
		end
	end)
end

function var0_0.SetUpSilentChecker(arg0_35)
	local var0_35 = getProxy(SettingsProxy):GetMainSceneScreenSleepTime()

	arg0_35.defaultSleepTimeout = Screen.sleepTimeout
	Screen.sleepTimeout = var0_35

	if SettingsMainScenePanel.IsEnableStandbyMode() then
		arg0_35.silentChecker:SetUp()
	end
end

function var0_0.RevertSleepTimeout(arg0_36)
	if arg0_36.defaultSleepTimeout and Screen.sleepTimeout ~= arg0_36.defaultSleepTimeout then
		Screen.sleepTimeout = arg0_36.defaultSleepTimeout
	end

	arg0_36.defaultSleepTimeout = nil
end

function var0_0.FoldPanels(arg0_37, arg1_37)
	if not arg0_37.theme then
		return
	end

	arg0_37.foldFlag = arg1_37

	arg0_37.theme:OnFoldPanels(arg1_37)
	arg0_37.paintingView:Fold(arg1_37, 0.5)
	pg.playerResUI:Fold(arg1_37, 0.5)
end

function var0_0.HidePanel(arg0_38, arg1_38)
	if not arg0_38.theme then
		return
	end

	if arg0_38.foldFlag == arg1_38 then
		return
	end

	arg0_38.foldFlag = arg1_38

	arg0_38.theme:OnFoldPanels(arg1_38)

	if arg0_38._asmrTurnning then
		arg0_38:SetEffectPanelVisible(false)

		if arg0_38.foldFlag == true then
			pg.playerResUI:Fold(arg1_38, 0.5)
		end
	else
		pg.playerResUI:Fold(arg1_38, 0.5)
	end
end

function var0_0.AsmrTurning(arg0_39, arg1_39)
	arg0_39._asmrTurnning = arg1_39

	arg0_39.paintingView:OnAsmrTurnning(arg1_39)
	arg0_39.theme:OnAsmrTurnning(arg1_39)
	arg0_39:SetEffectPanelVisible(not arg1_39)
	arg0_39.silentChecker:SetSilentRun(not arg1_39)

	if not arg0_39._asmrTurnning then
		arg0_39:SetUpSilentChecker()
		pg.BgmMgr.GetInstance():ContinuePlay()
	else
		pg.BgmMgr.GetInstance():StopPlay()
	end
end

function var0_0.SwitchToNextShip(arg0_40)
	if arg0_40.paintingView:IsLoading() or arg0_40.bgView:IsLoading() or not arg0_40.theme then
		return
	end

	local var0_40 = getProxy(PlayerProxy):getRawData():GetNextFlagShip()

	if arg0_40.bgView.ship:getSkinId() ~= var0_40:getSkinId() or arg0_40.bgView.ship.id ~= var0_40.id then
		arg0_40.bgView:Refresh(var0_40)
		arg0_40:PlayBgm(var0_40)
		arg0_40.paintingView:Refresh(var0_40, arg0_40.theme:GetPaintingOffset(var0_40))
		arg0_40.effectView:Refresh(var0_40)
		arg0_40.theme:OnSwitchToNextShip(var0_40)
	end
end

function var0_0.UpdateFlagShip(arg0_41, arg1_41, arg2_41)
	if arg0_41.paintingView:IsLoading() or arg0_41.bgView:IsLoading() or not arg0_41.theme then
		return
	end

	local var0_41 = arg2_41.callback

	arg0_41.bgView:Refresh(arg1_41)
	arg0_41:PlayBgm(arg1_41)
	arg0_41.paintingView:SetOnceLoadedCall(var0_41)
	arg0_41.paintingView:Refresh(arg1_41, arg0_41.theme:GetPaintingOffset(arg1_41))
	arg0_41.effectView:Refresh(arg1_41)
	arg0_41.theme:OnSwitchToNextShip(arg1_41)
end

function var0_0.PlayChangeSkinActionOut(arg0_42, arg1_42)
	arg0_42.paintingView:PlayChangeSkinActionOut(arg1_42)
end

function var0_0.PlayChangeSkinActionIn(arg0_43, arg1_43)
	arg0_43.paintingView:PlayChangeSkinActionIn(arg1_43)
end

function var0_0.CheckAndReplayBgm(arg0_44)
	local var0_44 = arg0_44:GetFlagShip()

	arg0_44.theme:Refresh(var0_44)
	arg0_44:PlayBgm(var0_44)
end

function var0_0.SetEffectPanelVisible(arg0_45, arg1_45)
	if arg0_45.theme then
		arg0_45.theme:SetEffectPanelVisible(arg1_45)
	end
end

function var0_0.OnVisible(arg0_46)
	arg0_46:RevertAsmrShip()

	local var0_46 = arg0_46.themes[arg0_46:GetThemeStyle()]

	if not (not arg0_46.theme or var0_46 ~= arg0_46.theme) then
		arg0_46:Refresh()
	else
		arg0_46:UnloadTheme()
		arg0_46:SetUp(true)
	end
end

function var0_0.Refresh(arg0_47)
	arg0_47.mainCG.blocksRaycasts = false

	seriesAsync({
		function(arg0_48)
			arg0_47.awakeSequenceView:Execute(arg0_48)
		end,
		function(arg0_49)
			arg0_47.isInit = true

			arg0_47:ShowOrHideResUI(arg0_47.theme:ApplyDefaultResUI())

			local var0_49 = arg0_47:GetFlagShip()

			arg0_47.bgView:Refresh(var0_49)
			arg0_47.paintingView:Refresh(var0_49, arg0_47.theme:GetPaintingOffset(var0_49))
			arg0_47.effectView:Refresh(var0_49)
			arg0_47.theme:Refresh(var0_49)
			arg0_47:PlayBgm(var0_49)
			pg.redDotHelper:Refresh()
			arg0_49()
		end,
		function(arg0_50)
			arg0_47.sequenceView:Execute(arg0_50)
		end
	}, function()
		arg0_47:SetUpSilentChecker()
		arg0_47:emit(NewMainScene.ON_ENTER_DONE)

		arg0_47.mainCG.blocksRaycasts = true
	end)
end

function var0_0.OnDisVisible(arg0_52)
	arg0_52:FoldPanels(false)
	arg0_52.paintingView:Disable()
	arg0_52.bgView:Disable()
	arg0_52.sequenceView:Disable()
	arg0_52.awakeSequenceView:Disable()

	if arg0_52.theme then
		arg0_52.theme:Disable()
	end

	pg.redDotHelper:Disable()
	arg0_52.buffDescPage:Disable()
	arg0_52.silentChecker:Disable()

	if arg0_52.silentView and arg0_52.silentView:isShowing() then
		arg0_52:ExitSilentView()
	end

	arg0_52.calibrationPage:Destroy()
	arg0_52.calibrationPage:Reset()
	arg0_52.skinExperienceDisplayPage:Destroy()
	arg0_52.skinExperienceDisplayPage:Reset()
	arg0_52.liveAreaPage:Destroy()
	arg0_52.liveAreaPage:Reset()

	arg0_52.isInit = false

	arg0_52:RevertSleepTimeout()
	arg0_52:RevertAsmrShip()
end

function var0_0.UnloadTheme(arg0_53)
	if arg0_53.theme then
		arg0_53.theme:Destroy()
		arg0_53.theme:Reset()

		arg0_53.theme = nil
	end
end

function var0_0.ExitCalibrationView(arg0_54)
	if arg0_54.calibrationPage and arg0_54.calibrationPage:GetLoaded() and arg0_54.calibrationPage:isShowing() then
		triggerButton(arg0_54.calibrationPage.backBtn)
	end
end

function var0_0.ExitSilentView(arg0_55)
	if arg0_55.silentView and arg0_55.silentView:isShowing() then
		arg0_55:FoldPanels(false)
		arg0_55.silentView:Destroy()
		arg0_55.silentView:Reset()
	end
end

function var0_0.GameLogout(arg0_56)
	arg0_56:ExitCalibrationView()
	arg0_56:ExitSilentView()
end

function var0_0.onBackPressed(arg0_57)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if arg0_57.silentView and arg0_57.silentView:isShowing() then
		arg0_57:ExitSilentView()

		return
	end

	if arg0_57.liveAreaPage and arg0_57.liveAreaPage:GetLoaded() and arg0_57.liveAreaPage:isShowing() then
		arg0_57.liveAreaPage:Hide()

		return
	end

	if arg0_57.calibrationPage and arg0_57.calibrationPage:GetLoaded() and arg0_57.calibrationPage:isShowing() then
		triggerButton(arg0_57.calibrationPage._parentTf)

		return
	end

	pg.SdkMgr.GetInstance():OnAndoridBackPress()
	pg.PushNotificationMgr.GetInstance():PushAll()
end

function var0_0.willExit(arg0_58)
	arg0_58.bgView:Dispose()

	arg0_58.bgView = nil

	arg0_58:UnloadTheme()

	if arg0_58.calibrationPage then
		arg0_58.calibrationPage:Destroy()

		arg0_58.calibrationPage = nil
	end

	if arg0_58.silentView then
		arg0_58.silentView:Destroy()

		arg0_58.silentView = nil
	end

	arg0_58.paintingView:Dispose()

	arg0_58.paintingView = nil

	arg0_58.liveAreaPage:Destroy()

	arg0_58.liveAreaPage = nil

	arg0_58.sequenceView:Dispose()

	arg0_58.sequenceView = nil

	arg0_58.awakeSequenceView:Dispose()

	arg0_58.awakeSequenceView = nil

	arg0_58.effectView:Dispose()

	arg0_58.effectView = nil

	pg.redDotHelper:Dispose()

	pg.redDotHelper = nil

	arg0_58.buffDescPage:Destroy()

	arg0_58.buffDescPage = nil

	arg0_58.silentChecker:Dispose()

	arg0_58.silentChecker = nil

	arg0_58.skinExperienceDisplayPage:Destroy()

	arg0_58.skinExperienceDisplayPage = nil

	arg0_58:RevertSleepTimeout()
end

return var0_0
