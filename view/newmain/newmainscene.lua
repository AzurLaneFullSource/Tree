local var0_0 = class("NewMainScene", import("..base.BaseUI"))

var0_0.THEME_CLASSIC = 1
var0_0.THEME_MELLOW = 2
var0_0.OPEN_LIVEAREA = "NewMainScene:OPEN_LIVEAREA"
var0_0.FOLD = "NewMainScene:FOLD"
var0_0.CHAT_STATE_CHANGE = "NewMainScene:CHAT_STATE_CHANGE"
var0_0.ON_CHANGE_SKIN = "NewMainScene:ON_CHANGE_SKIN"
var0_0.ON_BUFF_DESC = "NewMainScene:ON_BUFF_DESC"
var0_0.ON_SKIN_FREEUSAGE_DESC = "NewMainScene:ON_SKIN_FREEUSAGE_DESC"
var0_0.ENABLE_PAITING_MOVE = "NewMainScene:ENABLE_PAITING_MOVE"
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

	if arg1_6:IsBgmSkin() and getProxy(SettingsProxy):IsBGMEnable() then
		var0_6 = arg1_6:GetSkinBgm()
	end

	if not var0_6 then
		local var1_6, var2_6 = MainBGView.GetBgAndBgm()

		var0_6 = var2_6
	end

	var0_6 = var0_6 or var0_0.super.getBGM(arg0_6)

	if var0_6 then
		pg.BgmMgr.GetInstance():Push(arg0_6.__cname, var0_6)
	end
end

function var0_0.ResUISettings(arg0_7)
	return {
		showType = PlayerResUI.TYPE_ALL,
		anim = not arg0_7.resAnimFlag,
		weight = LayerWeightConst.BASE_LAYER + 1
	}
end

function var0_0.ShowOrHideResUI(arg0_8, arg1_8)
	if not arg0_8.isInit then
		return
	end

	var0_0.super.ShowOrHideResUI(arg0_8, arg1_8)
end

function var0_0.init(arg0_9)
	arg0_9.mainCG = GetOrAddComponent(arg0_9._tf, typeof(CanvasGroup))
	arg0_9.bgView = MainBGView.New(arg0_9:findTF("Sea/bg"))
	arg0_9.paintingView = MainPaintingView.New(arg0_9:findTF("paint"), arg0_9:findTF("paintBg"), arg0_9.event)
	arg0_9.effectView = MainEffectView.New(arg0_9:findTF("paint/effect"))
	arg0_9.buffDescPage = MainBuffDescPage.New(arg0_9._tf, arg0_9.event)
	arg0_9.calibrationPage = MainCalibrationPage.New(arg0_9._tf, arg0_9.event, arg0_9.contextData)
	arg0_9.silentView = MainSilentView.New(arg0_9._tf, arg0_9.event, arg0_9.contextData)
	arg0_9.silentChecker = MainSilentChecker.New(arg0_9.event)
	arg0_9.skinExperienceDisplayPage = SkinExperienceDiplayPage.New(arg0_9._tf, arg0_9.event)

	if USE_OLD_MAIN_LIVE_AREA_UI then
		arg0_9.liveAreaPage = MainLiveAreaOldPage.New(arg0_9._tf, arg0_9.event)
	else
		arg0_9.liveAreaPage = MainLiveAreaPage.New(arg0_9._tf, arg0_9.event)
	end

	pg.redDotHelper = MainReddotView.New()
	arg0_9.sequenceView = MainSequenceView.New()
	arg0_9.awakeSequenceView = MainAwakeSequenceView.New()
	arg0_9.themes = {
		[var0_0.THEME_CLASSIC] = NewMainClassicTheme.New(arg0_9._tf, arg0_9.event, arg0_9.contextData),
		[var0_0.THEME_MELLOW] = NewMainMellowTheme.New(arg0_9._tf, arg0_9.event, arg0_9.contextData)
	}
end

function var0_0.didEnter(arg0_10)
	arg0_10:bind(var0_0.FOLD, function(arg0_11, arg1_11)
		arg0_10:FoldPanels(arg1_11)

		local var0_11 = arg0_10.paintingView.ship

		if not var0_11 then
			return
		end

		arg0_10.calibrationPage:ExecuteAction("ShowOrHide", arg1_11, arg0_10.bgView.ship, arg0_10.theme:GetPaintingOffset(var0_11), arg0_10.theme:GetCalibrationBG())
	end)
	arg0_10:bind(var0_0.ON_CHANGE_SKIN, function(arg0_12)
		arg0_10:SwitchToNextShip()
	end)
	arg0_10:bind(var0_0.ENTER_SILENT_VIEW, function()
		arg0_10:ExitCalibrationView()
		arg0_10:FoldPanels(true)
		arg0_10.silentView:ExecuteAction("Show")
	end)
	arg0_10:bind(GAME.WILL_LOGOUT, function()
		arg0_10:GameLogout()
	end)
	arg0_10:bind(var0_0.EXIT_SILENT_VIEW, function()
		arg0_10:ExitSilentView()
		arg0_10:SetUpSilentChecker()
		pg.redDotHelper:_Refresh()
	end)
	arg0_10:bind(var0_0.ON_SKIN_FREEUSAGE_DESC, function(arg0_16, arg1_16)
		arg0_10.skinExperienceDisplayPage:ExecuteAction("Show", arg1_16)
	end)
	arg0_10:bind(NewMainScene.OPEN_LIVEAREA, function(arg0_17)
		arg0_10.liveAreaPage:ExecuteAction("Show")
	end)
	arg0_10:SetUp()
end

function var0_0.SetUp(arg0_18, arg1_18)
	arg0_18.mainCG.blocksRaycasts = false
	arg0_18.isInit = false
	arg0_18.resAnimFlag = false

	local var0_18

	seriesAsync({
		function(arg0_19)
			arg0_18.awakeSequenceView:Execute(arg0_19)
		end,
		function(arg0_20)
			var0_18 = arg0_18:GetFlagShip()

			arg0_18.bgView:Init(var0_18)
			onNextTick(arg0_20)
		end,
		function(arg0_21)
			arg0_18.theme = arg0_18.themes[arg0_18:GetThemeStyle()]

			arg0_18.theme:ExecuteAction("Show", arg0_21)
		end,
		function(arg0_22)
			onNextTick(arg0_22)
		end,
		function(arg0_23)
			arg0_18.isInit = true

			arg0_18.theme:PlayEnterAnimation(var0_18, arg0_23)

			local var0_23 = arg0_18.theme:GetPaintingOffset(var0_18)

			arg0_18.paintingView:Init(var0_18, var0_23, arg1_18)

			arg0_18.resAnimFlag = true
		end,
		function(arg0_24)
			arg0_18:PlayBgm(var0_18)
			arg0_18.effectView:Init(var0_18)
			arg0_18.theme:init(var0_18)
			onNextTick(arg0_24)
		end,
		function(arg0_25)
			arg0_18:ShowOrHideResUI(arg0_18.theme:ApplyDefaultResUI())
			arg0_18.sequenceView:Execute(arg0_25)
		end
	}, function()
		arg0_18:SetUpSilentChecker()
		arg0_18:emit(var0_0.ON_ENTER_DONE)

		arg0_18.mainCG.blocksRaycasts = true
	end)
end

function var0_0.SetUpSilentChecker(arg0_27)
	local var0_27 = getProxy(SettingsProxy):GetMainSceneScreenSleepTime()

	arg0_27.defaultSleepTimeout = Screen.sleepTimeout
	Screen.sleepTimeout = var0_27

	if SettingsMainScenePanel.IsEnableStandbyMode() then
		arg0_27.silentChecker:SetUp()
	end
end

function var0_0.RevertSleepTimeout(arg0_28)
	if arg0_28.defaultSleepTimeout and Screen.sleepTimeout ~= arg0_28.defaultSleepTimeout then
		Screen.sleepTimeout = arg0_28.defaultSleepTimeout
	end

	arg0_28.defaultSleepTimeout = nil
end

function var0_0.FoldPanels(arg0_29, arg1_29)
	if not arg0_29.theme then
		return
	end

	arg0_29.theme:OnFoldPanels(arg1_29)
	arg0_29.paintingView:Fold(arg1_29, 0.5)
	pg.playerResUI:Fold(arg1_29, 0.5)
end

function var0_0.SwitchToNextShip(arg0_30)
	if arg0_30.paintingView:IsLoading() or arg0_30.bgView:IsLoading() or not arg0_30.theme then
		return
	end

	local var0_30 = getProxy(PlayerProxy):getRawData():GetNextFlagShip()

	if arg0_30.bgView.ship.skinId ~= var0_30.skinId or arg0_30.bgView.ship.id ~= var0_30.id then
		arg0_30.bgView:Refresh(var0_30)
		arg0_30:PlayBgm(var0_30)
		arg0_30.paintingView:Refresh(var0_30, arg0_30.theme:GetPaintingOffset(var0_30))
		arg0_30.effectView:Refresh(var0_30)
		arg0_30.theme:OnSwitchToNextShip(var0_30)
	end
end

function var0_0.OnVisible(arg0_31)
	local var0_31 = arg0_31.themes[arg0_31:GetThemeStyle()]

	if not (not arg0_31.theme or var0_31 ~= arg0_31.theme) then
		arg0_31:Refresh()
	else
		arg0_31:UnloadTheme()
		arg0_31:SetUp(true)
	end
end

function var0_0.Refresh(arg0_32)
	arg0_32.mainCG.blocksRaycasts = false

	seriesAsync({
		function(arg0_33)
			arg0_32.awakeSequenceView:Execute(arg0_33)
		end,
		function(arg0_34)
			arg0_32.isInit = true

			arg0_32:ShowOrHideResUI(arg0_32.theme:ApplyDefaultResUI())

			local var0_34 = arg0_32:GetFlagShip()

			arg0_32.bgView:Refresh(var0_34)
			arg0_32.paintingView:Refresh(var0_34, arg0_32.theme:GetPaintingOffset(var0_34))
			arg0_32.effectView:Refresh(var0_34)
			arg0_32.theme:Refresh(var0_34)
			arg0_32:PlayBgm(var0_34)
			pg.redDotHelper:Refresh()
			arg0_34()
		end,
		function(arg0_35)
			arg0_32.sequenceView:Execute(arg0_35)
		end
	}, function()
		arg0_32:SetUpSilentChecker()
		arg0_32:emit(var0_0.ON_ENTER_DONE)

		arg0_32.mainCG.blocksRaycasts = true
	end)
end

function var0_0.OnDisVisible(arg0_37)
	arg0_37:FoldPanels(false)
	arg0_37.paintingView:Disable()
	arg0_37.bgView:Disable()
	arg0_37.sequenceView:Disable()
	arg0_37.awakeSequenceView:Disable()
	arg0_37.theme:Disable()
	pg.redDotHelper:Disable()
	arg0_37.buffDescPage:Disable()
	arg0_37.silentChecker:Disable()
	arg0_37.calibrationPage:Destroy()
	arg0_37.calibrationPage:Reset()
	arg0_37.skinExperienceDisplayPage:Destroy()
	arg0_37.skinExperienceDisplayPage:Reset()
	arg0_37.liveAreaPage:Destroy()
	arg0_37.liveAreaPage:Reset()

	arg0_37.isInit = false

	arg0_37:RevertSleepTimeout()
end

function var0_0.UnloadTheme(arg0_38)
	if arg0_38.theme then
		arg0_38.theme:Destroy()
		arg0_38.theme:Reset()

		arg0_38.theme = nil
	end
end

function var0_0.ExitCalibrationView(arg0_39)
	if arg0_39.calibrationPage and arg0_39.calibrationPage:GetLoaded() and arg0_39.calibrationPage:isShowing() then
		triggerButton(arg0_39.calibrationPage.backBtn)
	end
end

function var0_0.ExitSilentView(arg0_40)
	if arg0_40.silentView and arg0_40.silentView:GetLoaded() and arg0_40.silentView:isShowing() then
		arg0_40:FoldPanels(false)
		arg0_40.silentView:Destroy()
		arg0_40.silentView:Reset()
	end
end

function var0_0.GameLogout(arg0_41)
	arg0_41:ExitCalibrationView()
	arg0_41:ExitSilentView()
end

function var0_0.onBackPressed(arg0_42)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if arg0_42.silentView and arg0_42.silentView:GetLoaded() and arg0_42.silentView:isShowing() then
		arg0_42:ExitSilentView()

		return
	end

	if arg0_42.liveAreaPage and arg0_42.liveAreaPage:GetLoaded() and arg0_42.liveAreaPage:isShowing() then
		arg0_42.liveAreaPage:Hide()

		return
	end

	if arg0_42.calibrationPage and arg0_42.calibrationPage:GetLoaded() and arg0_42.calibrationPage:isShowing() then
		triggerButton(arg0_42.calibrationPage._parentTf)

		return
	end

	pg.SdkMgr.GetInstance():OnAndoridBackPress()
	pg.PushNotificationMgr.GetInstance():PushAll()
end

function var0_0.willExit(arg0_43)
	arg0_43.bgView:Dispose()

	arg0_43.bgView = nil

	if arg0_43.calibrationPage then
		arg0_43.calibrationPage:Destroy()

		arg0_43.calibrationPage = nil
	end

	if arg0_43.silentView then
		arg0_43.silentView:Destroy()

		arg0_43.silentView = nil
	end

	arg0_43.paintingView:Dispose()

	arg0_43.paintingView = nil

	arg0_43.liveAreaPage:Destroy()

	arg0_43.liveAreaPage = nil

	arg0_43.sequenceView:Dispose()

	arg0_43.sequenceView = nil

	arg0_43.awakeSequenceView:Dispose()

	arg0_43.awakeSequenceView = nil

	arg0_43.effectView:Dispose()

	arg0_43.effectView = nil

	pg.redDotHelper:Dispose()

	pg.redDotHelper = nil

	arg0_43.buffDescPage:Destroy()

	arg0_43.buffDescPage = nil

	arg0_43.silentChecker:Dispose()

	arg0_43.silentChecker = nil

	arg0_43.skinExperienceDisplayPage:Destroy()

	arg0_43.skinExperienceDisplayPage = nil

	arg0_43:UnloadTheme()
	arg0_43:RevertSleepTimeout()
end

return var0_0
