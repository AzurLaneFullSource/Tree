local var0 = class("NewMainScene", import("..base.BaseUI"))

var0.THEME_CLASSIC = 1
var0.THEME_MELLOW = 2
var0.OPEN_LIVEAREA = "NewMainScene:OPEN_LIVEAREA"
var0.FOLD = "NewMainScene:FOLD"
var0.CHAT_STATE_CHANGE = "NewMainScene:CHAT_STATE_CHANGE"
var0.ON_CHANGE_SKIN = "NewMainScene:ON_CHANGE_SKIN"
var0.ON_BUFF_DESC = "NewMainScene:ON_BUFF_DESC"
var0.ON_SKIN_FREEUSAGE_DESC = "NewMainScene:ON_SKIN_FREEUSAGE_DESC"
var0.ENABLE_PAITING_MOVE = "NewMainScene:ENABLE_PAITING_MOVE"
var0.ON_ENTER_DONE = "NewMainScene:ON_ENTER_DONE"
var0.ENTER_SILENT_VIEW = "NewMainScene:ENTER_SILENT_VIEW"
var0.EXIT_SILENT_VIEW = "NewMainScene:EXIT_SILENT_VIEW"
var0.RESET_L2D = "NewMainScene:RESET_L2D"

function var0.getUIName(arg0)
	return "NewMainUI"
end

function var0.needCache(arg0)
	return true
end

function var0.GetThemeStyle(arg0)
	return getProxy(SettingsProxy):GetMainSceneThemeStyle()
end

function var0.PlayBGM(arg0)
	return
end

function var0.GetFlagShip(arg0)
	return (getProxy(PlayerProxy):getRawData():GetFlagShip())
end

function var0.PlayBgm(arg0, arg1)
	local var0

	if arg1:IsBgmSkin() and getProxy(SettingsProxy):IsBGMEnable() then
		var0 = arg1:GetSkinBgm()
	end

	if not var0 then
		local var1, var2 = MainBGView.GetBgAndBgm()

		var0 = var2
	end

	var0 = var0 or var0.super.getBGM(arg0)

	if var0 then
		pg.BgmMgr.GetInstance():Push(arg0.__cname, var0)
	end
end

function var0.ResUISettings(arg0)
	return {
		showType = PlayerResUI.TYPE_ALL,
		anim = not arg0.resAnimFlag,
		weight = LayerWeightConst.BASE_LAYER + 1
	}
end

function var0.ShowOrHideResUI(arg0, arg1)
	if not arg0.isInit then
		return
	end

	var0.super.ShowOrHideResUI(arg0, arg1)
end

function var0.init(arg0)
	arg0.mainCG = GetOrAddComponent(arg0._tf, typeof(CanvasGroup))
	arg0.bgView = MainBGView.New(arg0:findTF("Sea/bg"))
	arg0.paintingView = MainPaintingView.New(arg0:findTF("paint"), arg0:findTF("paintBg"), arg0.event)
	arg0.effectView = MainEffectView.New(arg0:findTF("paint/effect"))
	arg0.buffDescPage = MainBuffDescPage.New(arg0._tf, arg0.event)
	arg0.calibrationPage = MainCalibrationPage.New(arg0._tf, arg0.event, arg0.contextData)
	arg0.silentView = MainSilentView.New(arg0._tf, arg0.event, arg0.contextData)
	arg0.silentChecker = MainSilentChecker.New(arg0.event)
	arg0.skinExperienceDisplayPage = SkinExperienceDiplayPage.New(arg0._tf, arg0.event)

	if USE_OLD_MAIN_LIVE_AREA_UI then
		arg0.liveAreaPage = MainLiveAreaOldPage.New(arg0._tf, arg0.event)
	else
		arg0.liveAreaPage = MainLiveAreaPage.New(arg0._tf, arg0.event)
	end

	pg.redDotHelper = MainReddotView.New()
	arg0.sequenceView = MainSequenceView.New()
	arg0.awakeSequenceView = MainAwakeSequenceView.New()
	arg0.themes = {
		[var0.THEME_CLASSIC] = NewMainClassicTheme.New(arg0._tf, arg0.event, arg0.contextData),
		[var0.THEME_MELLOW] = NewMainMellowTheme.New(arg0._tf, arg0.event, arg0.contextData)
	}
end

function var0.didEnter(arg0)
	arg0:bind(var0.FOLD, function(arg0, arg1)
		arg0:FoldPanels(arg1)

		local var0 = arg0.paintingView.ship

		if not var0 then
			return
		end

		arg0.calibrationPage:ExecuteAction("ShowOrHide", arg1, arg0.bgView.ship, arg0.theme:GetPaintingOffset(var0), arg0.theme:GetCalibrationBG())
	end)
	arg0:bind(var0.ON_CHANGE_SKIN, function(arg0)
		arg0:SwitchToNextShip()
	end)
	arg0:bind(var0.ENTER_SILENT_VIEW, function()
		arg0:ExitCalibrationView()
		arg0:FoldPanels(true)
		arg0.silentView:ExecuteAction("Show")
	end)
	arg0:bind(GAME.WILL_LOGOUT, function()
		arg0:GameLogout()
	end)
	arg0:bind(var0.EXIT_SILENT_VIEW, function()
		arg0:ExitSilentView()
		arg0:SetUpSilentChecker()
		pg.redDotHelper:_Refresh()
	end)
	arg0:bind(var0.ON_SKIN_FREEUSAGE_DESC, function(arg0, arg1)
		arg0.skinExperienceDisplayPage:ExecuteAction("Show", arg1)
	end)
	arg0:bind(NewMainScene.OPEN_LIVEAREA, function(arg0)
		arg0.liveAreaPage:ExecuteAction("Show")
	end)
	arg0:SetUp()
end

function var0.SetUp(arg0, arg1)
	arg0.mainCG.blocksRaycasts = false
	arg0.isInit = false
	arg0.resAnimFlag = false

	local var0

	seriesAsync({
		function(arg0)
			arg0.awakeSequenceView:Execute(arg0)
		end,
		function(arg0)
			var0 = arg0:GetFlagShip()

			arg0.bgView:Init(var0)
			onNextTick(arg0)
		end,
		function(arg0)
			arg0.theme = arg0.themes[arg0:GetThemeStyle()]

			arg0.theme:ExecuteAction("Show", arg0)
		end,
		function(arg0)
			onNextTick(arg0)
		end,
		function(arg0)
			arg0.isInit = true

			arg0.theme:PlayEnterAnimation(var0, arg0)

			local var0 = arg0.theme:GetPaintingOffset(var0)

			arg0.paintingView:Init(var0, var0, arg1)

			arg0.resAnimFlag = true
		end,
		function(arg0)
			arg0:PlayBgm(var0)
			arg0.effectView:Init(var0)
			arg0.theme:init(var0)
			onNextTick(arg0)
		end,
		function(arg0)
			arg0:ShowOrHideResUI(arg0.theme:ApplyDefaultResUI())
			arg0.sequenceView:Execute(arg0)
		end
	}, function()
		arg0:SetUpSilentChecker()
		arg0:emit(var0.ON_ENTER_DONE)

		arg0.mainCG.blocksRaycasts = true
	end)
end

function var0.SetUpSilentChecker(arg0)
	local var0 = getProxy(SettingsProxy):GetMainSceneScreenSleepTime()

	arg0.defaultSleepTimeout = Screen.sleepTimeout
	Screen.sleepTimeout = var0

	arg0.silentChecker:SetUp()
end

function var0.RevertSleepTimeout(arg0)
	if arg0.defaultSleepTimeout and Screen.sleepTimeout ~= arg0.defaultSleepTimeout then
		Screen.sleepTimeout = arg0.defaultSleepTimeout
	end

	arg0.defaultSleepTimeout = nil
end

function var0.FoldPanels(arg0, arg1)
	if not arg0.theme then
		return
	end

	arg0.theme:OnFoldPanels(arg1)
	arg0.paintingView:Fold(arg1, 0.5)
	pg.playerResUI:Fold(arg1, 0.5)
end

function var0.SwitchToNextShip(arg0)
	if arg0.paintingView:IsLoading() or arg0.bgView:IsLoading() or not arg0.theme then
		return
	end

	local var0 = getProxy(PlayerProxy):getRawData():GetNextFlagShip()

	if arg0.bgView.ship.skinId ~= var0.skinId or arg0.bgView.ship.id ~= var0.id then
		arg0.bgView:Refresh(var0)
		arg0:PlayBgm(var0)
		arg0.paintingView:Refresh(var0, arg0.theme:GetPaintingOffset(var0))
		arg0.effectView:Refresh(var0)
		arg0.theme:OnSwitchToNextShip(var0)
	end
end

function var0.OnVisible(arg0)
	local var0 = arg0.themes[arg0:GetThemeStyle()]

	if not (not arg0.theme or var0 ~= arg0.theme) then
		arg0:Refresh()
	else
		arg0:UnloadTheme()
		arg0:SetUp(true)
	end
end

function var0.Refresh(arg0)
	arg0.mainCG.blocksRaycasts = false

	seriesAsync({
		function(arg0)
			arg0.awakeSequenceView:Execute(arg0)
		end,
		function(arg0)
			arg0.isInit = true

			arg0:ShowOrHideResUI(arg0.theme:ApplyDefaultResUI())

			local var0 = arg0:GetFlagShip()

			arg0.bgView:Refresh(var0)
			arg0.paintingView:Refresh(var0, arg0.theme:GetPaintingOffset(var0))
			arg0.effectView:Refresh(var0)
			arg0.theme:Refresh(var0)
			arg0:PlayBgm(var0)
			pg.redDotHelper:Refresh()
			arg0()
		end,
		function(arg0)
			arg0.sequenceView:Execute(arg0)
		end
	}, function()
		arg0:SetUpSilentChecker()
		arg0:emit(var0.ON_ENTER_DONE)

		arg0.mainCG.blocksRaycasts = true
	end)
end

function var0.OnDisVisible(arg0)
	arg0:FoldPanels(false)
	arg0.paintingView:Disable()
	arg0.bgView:Disable()
	arg0.sequenceView:Disable()
	arg0.awakeSequenceView:Disable()
	arg0.theme:Disable()
	pg.redDotHelper:Disable()
	arg0.buffDescPage:Disable()
	arg0.silentChecker:Disable()
	arg0.calibrationPage:Destroy()
	arg0.calibrationPage:Reset()
	arg0.skinExperienceDisplayPage:Destroy()
	arg0.skinExperienceDisplayPage:Reset()
	arg0.liveAreaPage:Destroy()
	arg0.liveAreaPage:Reset()

	arg0.isInit = false

	arg0:RevertSleepTimeout()
end

function var0.UnloadTheme(arg0)
	if arg0.theme then
		arg0.theme:Destroy()
		arg0.theme:Reset()

		arg0.theme = nil
	end
end

function var0.ExitCalibrationView(arg0)
	if arg0.calibrationPage and arg0.calibrationPage:GetLoaded() and arg0.calibrationPage:isShowing() then
		triggerButton(arg0.calibrationPage.backBtn)
	end
end

function var0.ExitSilentView(arg0)
	if arg0.silentView and arg0.silentView:GetLoaded() and arg0.silentView:isShowing() then
		arg0:FoldPanels(false)
		arg0.silentView:Destroy()
		arg0.silentView:Reset()
	end
end

function var0.GameLogout(arg0)
	arg0:ExitCalibrationView()
	arg0:ExitSilentView()
end

function var0.onBackPressed(arg0)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if arg0.silentView and arg0.silentView:GetLoaded() and arg0.silentView:isShowing() then
		arg0:ExitSilentView()

		return
	end

	if arg0.liveAreaPage and arg0.liveAreaPage:GetLoaded() and arg0.liveAreaPage:isShowing() then
		arg0.liveAreaPage:Hide()

		return
	end

	if arg0.calibrationPage and arg0.calibrationPage:GetLoaded() and arg0.calibrationPage:isShowing() then
		triggerButton(arg0.calibrationPage._parentTf)

		return
	end

	pg.SdkMgr.GetInstance():OnAndoridBackPress()
	pg.PushNotificationMgr.GetInstance():PushAll()
end

function var0.willExit(arg0)
	arg0.bgView:Dispose()

	arg0.bgView = nil

	if arg0.calibrationPage then
		arg0.calibrationPage:Destroy()

		arg0.calibrationPage = nil
	end

	if arg0.silentView then
		arg0.silentView:Destroy()

		arg0.silentView = nil
	end

	arg0.paintingView:Dispose()

	arg0.paintingView = nil

	arg0.liveAreaPage:Destroy()

	arg0.liveAreaPage = nil

	arg0.sequenceView:Dispose()

	arg0.sequenceView = nil

	arg0.awakeSequenceView:Dispose()

	arg0.awakeSequenceView = nil

	arg0.effectView:Dispose()

	arg0.effectView = nil

	pg.redDotHelper:Dispose()

	pg.redDotHelper = nil

	arg0.buffDescPage:Destroy()

	arg0.buffDescPage = nil

	arg0.silentChecker:Dispose()

	arg0.silentChecker = nil

	arg0.skinExperienceDisplayPage:Destroy()

	arg0.skinExperienceDisplayPage = nil

	arg0:UnloadTheme()
	arg0:RevertSleepTimeout()
end

return var0
