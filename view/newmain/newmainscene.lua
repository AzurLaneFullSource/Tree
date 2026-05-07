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
var0_0.L2D_BOUND_CHANGE = "NewMainScene:L2D_BOUND_CHANGE"
var0_0.RESET_L2D = "NewMainScene:RESET_L2D"

function var0_0.getUIName(arg0_1)
	return "NewMainUI"
end

function var0_0.getResource(arg0_2)
	local var0_2 = {
		"ui/newmainui",
		"commonbg/bg_main_night",
		"commonbg/bg_main_twilight",
		"commonbg/bg_main_day",
		"ui/mainbgview",
		"ui/lihui_qiehuan01",
		"ui/lihui_qiehuan02",
		"spinematerials",
		"effect/jiehuntexiao",
		"ui/mainuibuffdescwindow",
		"ui/maincalibrationui",
		"clutter/mainui_calibration",
		"clutter/mainui_calibration_mellow",
		"ui/mainsilentviewui",
		"ui/mainui_atlas",
		"ui/exskinlistui",
		"ui/mainliveareaoldui",
		"ui/mainliveareaui",
		"ui/livingareacoverui",
		"ui/newmainclassictheme",
		"clutter/mainui_calibration",
		"ui/mainui_atlas",
		"ui/newmainmellowtheme",
		"clutter/mainui_calibration_mellow",
		"ui/respanel",
		"ui/goldexchangewindow"
	}
	local var1_2 = (function()
		local var0_3 = {}
		local var1_3, var2_3 = MainBGView.GetBgAndBgm()
		local var3_3 = ResPathSupport.GetSoundResList(var2_3)
		local var4_3 = var0_0.super.getBGM(arg0_2)
		local var5_3 = ResPathSupport.GetSoundResList(var4_3)

		return (ResPathSupport.MergeLuaArr(var0_3, var3_3, var5_3))
	end)()
	local var2_2 = (function()
		local var0_4 = {}
		local var1_4, var2_4 = MainBGView.GetBgAndBgm()
		local var3_4 = ResPathSupport.ConstPath.BG.CommonBG
		local var4_4 = {
			ResPathSupport.CombinePath(var3_4, var1_4)
		}

		return (ResPathSupport.MergeLuaArr(var0_4, var4_4))
	end)()
	local var3_2 = (function()
		local var0_5 = {}
		local var1_5 = getProxy(LivingAreaCoverProxy)
		local var2_5 = var1_5:GetUnlockList()
		local var3_5 = var1_5:GetLockList()
		local var4_5 = ResPathSupport.ConstPath.UI.LivingAreaCover

		_.each(var2_5, function(arg0_6)
			local var0_6 = arg0_6:GetIcon()

			table.insert(var0_5, ResPathSupport.CombinePath(var4_5, var0_6))
		end)
		_.each(var3_5, function(arg0_7)
			local var0_7 = arg0_7:GetIcon()

			table.insert(var0_5, ResPathSupport.CombinePath(var4_5, var0_7))
		end)

		return var0_5
	end)()
	local var4_2 = (function()
		local var0_8 = {}
		local var1_8 = getProxy(ActivityProxy):getBannerDisplays()

		_.each(var1_8, function(arg0_9)
			local var0_9 = var0_0.ConstPath.UI.ActivityBanner
			local var1_9 = arg0_9.pic

			table.insert(var0_8, ResPathSupport.CombinePath(var0_9, var1_9))
		end)

		return var0_8
	end)()
	local var5_2 = (function()
		local var0_10 = {}
		local var1_10 = MainActivityBtnView.GetActivityBtnList()

		_.each(var1_10, function(arg0_11)
			local var0_11 = arg0_11.New()
			local var1_11 = var0_11:ResPath()
			local var2_11 = var0_11:GetLinkConfig()

			if var2_11 then
				local var3_11 = var2_11.pic

				if var3_11 and #var3_11 > 0 then
					local var4_11 = ResPathSupport.CombinePath(var1_11, var3_11)
					local var5_11 = string.lower(var4_11)

					table.insert(var0_10, var5_11)
				end

				local var6_11 = var2_11.text_pic

				if var6_11 and #var6_11 > 0 then
					local var7_11 = ResPathSupport.CombinePath(var1_11, var6_11)
					local var8_11 = string.lower(var7_11)

					table.insert(var0_10, var8_11)
				end
			end

			local var9_11 = ResPathSupport.ConstPath.UI.LinkButton
			local var10_11 = var0_11:GetTipImage()

			if var10_11 and #var10_11 > 0 then
				local var11_11 = ResPathSupport.CombinePath(var9_11, var10_11)
				local var12_11 = string.lower(var11_11)

				table.insert(var0_10, var12_11)
			end
		end)

		local var2_10 = MainActivityBtnView.GetSpecailBtns()

		_.each(var2_10, function(arg0_12)
			local var0_12 = arg0_12.New()
			local var1_12 = ResPathSupport.ConstPath.UI.Base
			local var2_12 = var0_12:GetUIName()

			if var2_12 and #var2_12 > 0 then
				local var3_12 = ResPathSupport.CombinePath(var1_12, var2_12)
				local var4_12 = string.lower(var3_12)

				table.insert(var0_10, var4_12)

				local var5_12 = var4_12 .. "4mellow"

				table.insert(var0_10, var5_12)
			end
		end)

		return var0_10
	end)()
	local var6_2 = (function()
		local var0_13 = {}
		local var1_13 = MainBuffView.CollectBuffs()

		_.each(var1_13, function(arg0_14)
			local var0_14 = string.lower(arg0_14:getConfig("icon"))

			table.insert(var0_13, var0_14)
		end)

		return var0_13
	end)()
	local var7_2 = (function()
		local var0_15 = {}
		local var1_15 = getProxy(PlayerProxy):getData()
		local var2_15 = PlayerVitaeShipsPage.GetAllUnlockSlotCnt()

		for iter0_15 = 1, var2_15 do
			local var3_15 = var1_15:GetFlagShip()
			local var4_15 = ResPathSupport.GetShipAllRes(var3_15)

			table.insert(var0_15, var4_15)
		end

		return _.flatten(var0_15)
	end)()

	return ResPathSupport.MergeLuaArr(var0_2, var1_2, var2_2, var3_2, var4_2, var5_2, var6_2, var7_2)
end

function var0_0.needCache(arg0_16)
	return true
end

function var0_0.forceGC(arg0_17)
	return true
end

function var0_0.GetThemeStyle(arg0_18)
	return getProxy(SettingsProxy):GetMainSceneThemeStyle()
end

function var0_0.PlayBGM(arg0_19)
	return
end

function var0_0.GetFlagShip(arg0_20)
	return (getProxy(PlayerProxy):getRawData():GetFlagShip())
end

function var0_0.RevertAsmrShip(arg0_21)
	getProxy(BayProxy):ClearChangeSkinAsmr()
end

function var0_0.PlayBgm(arg0_22, arg1_22)
	local var0_22
	local var1_22

	if underscore.any({
		function()
			if arg1_22:IsBgmSkin() and getProxy(SettingsProxy):IsBGMEnable() then
				var0_22 = arg1_22:GetSkinBgm()
			end

			return tobool(var0_22)
		end,
		function()
			if getProxy(SettingsProxy):IsEnableMainMusicPlayer() and getProxy(AppreciateProxy):CanPlayMainMusicPlayer() then
				var0_22 = "MainMusicPlayer"
				var1_22 = {
					loopType = getProxy(AppreciateProxy):getMusicPlayerLoopType(),
					albumName = getProxy(AppreciateProxy):getMainPlayerAlbumName()
				}
			end

			return tobool(var0_22)
		end,
		function()
			local var0_25, var1_25 = MainBGView.GetBgAndBgm()

			var0_22 = var1_25

			return tobool(var0_22)
		end,
		function()
			var0_22 = var0_0.super.getBGM(arg0_22)

			return tobool(var0_22)
		end
	}, function(arg0_27)
		return arg0_27()
	end) then
		pg.BgmMgr.GetInstance():Push(arg0_22.__cname, var0_22, var1_22)
	end
end

function var0_0.ResUISettings(arg0_28)
	return {
		showType = PlayerResUI.TYPE_ALL,
		anim = not arg0_28.resAnimFlag
	}
end

function var0_0.ShowOrHideResUI(arg0_29, arg1_29)
	if not arg0_29.isInit then
		return
	end

	var0_0.super.ShowOrHideResUI(arg0_29, arg1_29)
end

function var0_0.init(arg0_30)
	arg0_30.mainCG = GetOrAddComponent(arg0_30._tf, typeof(CanvasGroup))
	arg0_30.bgView = MainBGView.New(arg0_30._tf:Find("Sea/bg"))
	arg0_30.paintingView = MainPaintingView.New(arg0_30._tf:Find("paint"), arg0_30._tf:Find("paintBg"), arg0_30.event)
	arg0_30.effectView = MainEffectView.New(arg0_30._tf:Find("paint/effect"))
	arg0_30.buffDescPage = MainBuffDescPage.New(arg0_30._tf, arg0_30.event)
	arg0_30.calibrationPage = MainCalibrationPage.New(arg0_30._tf, arg0_30.event, arg0_30.contextData)
	arg0_30.silentView = MainSilentView.New(arg0_30._tf, arg0_30.event, arg0_30.contextData)
	arg0_30.silentChecker = MainSilentChecker.New(arg0_30.event)
	arg0_30.skinExperienceDisplayPage = SkinExperienceDiplayPage.New(arg0_30._tf, arg0_30.event)

	if USE_OLD_MAIN_LIVE_AREA_UI then
		arg0_30.liveAreaPage = MainLiveAreaOldPage.New(arg0_30._tf, arg0_30.event)
	else
		arg0_30.liveAreaPage = MainLiveAreaPage.New(arg0_30._tf, arg0_30.event)
	end

	pg.redDotHelper = MainReddotView.New()
	arg0_30.sequenceView = MainSequenceView.New()
	arg0_30.awakeSequenceView = MainAwakeSequenceView.New()
	arg0_30.themes = {
		[NewMainScene.THEME_CLASSIC] = NewMainClassicTheme.New(arg0_30._tf, arg0_30.event, arg0_30.contextData),
		[NewMainScene.THEME_MELLOW] = NewMainMellowTheme.New(arg0_30._tf, arg0_30.event, arg0_30.contextData)
	}

	for iter0_30, iter1_30 in pairs(arg0_30.themes) do
		iter1_30:RegisterView(arg0_30)
	end

	arg0_30:RevertAsmrShip()
end

function var0_0.didEnter(arg0_31)
	arg0_31:bind(NewMainScene.FOLD, function(arg0_32, arg1_32)
		arg0_31:FoldPanels(arg1_32)

		local var0_32 = arg0_31.paintingView.ship

		if not var0_32 then
			return
		end

		arg0_31.calibrationPage:ExecuteAction("ShowOrHide", arg1_32, arg0_31.bgView.ship, arg0_31.theme:GetPaintingOffset(var0_32), arg0_31.theme:GetCalibrationBG())
	end)
	arg0_31:bind(NewMainScene.HIDE, function(arg0_33, arg1_33)
		arg0_31:HidePanel(arg1_33)

		local var0_33 = arg0_31.paintingView.ship

		if not var0_33 then
			return
		end

		arg0_31.calibrationPage:ExecuteAction("ShowOrHide", arg1_33, arg0_31.bgView.ship, arg0_31.theme:GetPaintingOffset(var0_33), arg0_31.theme:GetCalibrationBG())
	end)
	arg0_31:bind(NewMainScene.ON_CHANGE_SKIN, function(arg0_34)
		arg0_31:SwitchToNextShip()
	end)
	arg0_31:bind(NewMainScene.ENTER_SILENT_VIEW, function()
		arg0_31:ExitCalibrationView()
		arg0_31:FoldPanels(true)
		arg0_31.silentView:ExecuteAction("Show")
	end)
	arg0_31:bind(GAME.WILL_LOGOUT, function()
		arg0_31:GameLogout()
	end)
	arg0_31:bind(NewMainScene.EXIT_SILENT_VIEW, function()
		arg0_31:ExitSilentView()
		arg0_31:SetUpSilentChecker()
		pg.redDotHelper:_Refresh()
	end)
	arg0_31:bind(NewMainScene.ON_SKIN_FREEUSAGE_DESC, function(arg0_38, arg1_38)
		arg0_31.skinExperienceDisplayPage:ExecuteAction("Show", arg1_38)
	end)
	arg0_31:bind(NewMainScene.OPEN_LIVEAREA, function(arg0_39)
		arg0_31.liveAreaPage:ExecuteAction("Show")
	end)
	arg0_31:bind(NewMainScene.L2D_BOUND_CHANGE, function(arg0_40)
		arg0_31.paintingView:OnBoundChange()
	end)
	arg0_31:SetUp(false, true)
end

function var0_0.SetUp(arg0_41, arg1_41, arg2_41)
	arg0_41.mainCG.blocksRaycasts = false
	arg0_41.isInit = false
	arg0_41.resAnimFlag = false

	local var0_41

	seriesAsync({
		function(arg0_42)
			arg0_41.awakeSequenceView:Execute(arg0_42)
		end,
		function(arg0_43)
			var0_41 = arg0_41:GetFlagShip()

			arg0_41.bgView:Init(var0_41)
			onNextTick(arg0_43)
		end,
		function(arg0_44)
			arg0_41.theme = arg0_41.themes[arg0_41:GetThemeStyle()]

			arg0_41.theme:ExecuteAction("Show", arg0_44)
		end,
		function(arg0_45)
			onNextTick(arg0_45)
		end,
		function(arg0_46)
			arg0_41.isInit = true

			arg0_41.theme:PlayEnterAnimation(var0_41, arg0_46)

			local var0_46 = arg0_41.theme:GetPaintingOffset(var0_41)

			arg0_41.paintingView:Init(var0_41, var0_46, arg1_41)

			arg0_41.resAnimFlag = true
		end,
		function(arg0_47)
			arg0_41:PlayBgm(var0_41)
			arg0_41.effectView:Init(var0_41)
			arg0_41.theme:init(var0_41)
			onNextTick(arg0_47)
		end,
		function(arg0_48)
			arg0_41:ShowOrHideResUI(arg0_41.theme:ApplyDefaultResUI())
			arg0_41.sequenceView:Execute(arg0_48)
		end
	}, function()
		arg0_41:SetUpSilentChecker()
		arg0_41:emit(NewMainScene.ON_ENTER_DONE)

		arg0_41.mainCG.blocksRaycasts = true

		if arg2_41 then
			gcAll()
		end
	end)
end

function var0_0.SetUpSilentChecker(arg0_50)
	local var0_50 = getProxy(SettingsProxy):GetMainSceneScreenSleepTime()

	arg0_50.defaultSleepTimeout = Screen.sleepTimeout
	Screen.sleepTimeout = var0_50

	if SettingsMainScenePanel.IsEnableStandbyMode() then
		arg0_50.silentChecker:SetUp()
	end
end

function var0_0.RevertSleepTimeout(arg0_51)
	if arg0_51.defaultSleepTimeout and Screen.sleepTimeout ~= arg0_51.defaultSleepTimeout then
		Screen.sleepTimeout = arg0_51.defaultSleepTimeout
	end

	arg0_51.defaultSleepTimeout = nil
end

function var0_0.FoldPanels(arg0_52, arg1_52)
	if not arg0_52.theme then
		return
	end

	arg0_52.foldFlag = arg1_52

	arg0_52.theme:OnFoldPanels(arg1_52)
	arg0_52.paintingView:Fold(arg1_52, 0.5)
	pg.playerResUI:Fold(arg1_52, 0.5)
	arg0_52:SetEffectPanelVisible(not arg1_52)
end

function var0_0.HidePanel(arg0_53, arg1_53)
	if not arg0_53.theme then
		return
	end

	if arg0_53.foldFlag == arg1_53 then
		return
	end

	arg0_53.foldFlag = arg1_53

	arg0_53.theme:OnFoldPanels(arg1_53)

	if arg0_53._asmrTurnning then
		if arg0_53.foldFlag == true then
			pg.playerResUI:Fold(arg1_53, 0.5)
		end
	else
		pg.playerResUI:Fold(arg1_53, 0.5)
	end

	if not arg1_53 and arg0_53._asmrTurnning then
		arg0_53:SetEffectPanelVisible(false)
	else
		arg0_53:SetEffectPanelVisible(not arg1_53)
	end
end

function var0_0.AsmrTurning(arg0_54, arg1_54)
	arg0_54._asmrTurnning = arg1_54

	arg0_54.paintingView:OnAsmrTurnning(arg1_54)
	arg0_54.theme:OnAsmrTurnning(arg1_54)
	arg0_54.silentChecker:SetSilentRun(not arg1_54)

	if not arg0_54._asmrTurnning then
		arg0_54:SetUpSilentChecker()
		pg.BgmMgr.GetInstance():ContinuePlay()
	else
		pg.BgmMgr.GetInstance():StopPlay()
	end
end

function var0_0.SwitchToNextShip(arg0_55)
	if arg0_55.paintingView:IsLoading() or arg0_55.bgView:IsLoading() or not arg0_55.theme then
		return
	end

	local var0_55 = getProxy(PlayerProxy):getRawData():GetNextFlagShip()

	if arg0_55.bgView.ship:getSkinId() ~= var0_55:getSkinId() or arg0_55.bgView.ship.id ~= var0_55.id then
		arg0_55.bgView:Refresh(var0_55)
		arg0_55:PlayBgm(var0_55)
		arg0_55.paintingView:Refresh(var0_55, arg0_55.theme:GetPaintingOffset(var0_55))
		arg0_55.effectView:Refresh(var0_55)
		arg0_55.theme:OnSwitchToNextShip(var0_55)
	end
end

function var0_0.UpdateFlagShip(arg0_56, arg1_56, arg2_56)
	if arg0_56.paintingView:IsLoading() or arg0_56.bgView:IsLoading() or not arg0_56.theme then
		return
	end

	local var0_56 = arg2_56.callback

	arg0_56.bgView:Refresh(arg1_56)
	arg0_56:PlayBgm(arg1_56)
	arg0_56.paintingView:SetOnceLoadedCall(var0_56)
	arg0_56.paintingView:Refresh(arg1_56, arg0_56.theme:GetPaintingOffset(arg1_56))
	arg0_56.effectView:Refresh(arg1_56)
	arg0_56.theme:OnSwitchToNextShip(arg1_56)
end

function var0_0.PlayChangeSkinActionOut(arg0_57, arg1_57)
	arg0_57.paintingView:PlayChangeSkinActionOut(arg1_57)
end

function var0_0.PlayChangeSkinActionIn(arg0_58, arg1_58)
	arg0_58.paintingView:PlayChangeSkinActionIn(arg1_58)
end

function var0_0.CheckAndReplayBgm(arg0_59)
	local var0_59 = arg0_59:GetFlagShip()

	arg0_59.theme:Refresh(var0_59)
	arg0_59:PlayBgm(var0_59)
end

function var0_0.SetEffectPanelVisible(arg0_60, arg1_60)
	if arg0_60.theme then
		arg0_60.theme:SetEffectPanelVisible(arg1_60)
	end
end

function var0_0.OnVisible(arg0_61)
	arg0_61:RevertAsmrShip()

	local var0_61 = arg0_61.themes[arg0_61:GetThemeStyle()]

	if not (not arg0_61.theme or var0_61 ~= arg0_61.theme) then
		arg0_61:Refresh()
	else
		arg0_61:UnloadTheme()
		arg0_61:SetUp(true)
	end
end

function var0_0.Refresh(arg0_62)
	arg0_62.mainCG.blocksRaycasts = false

	seriesAsync({
		function(arg0_63)
			arg0_62.awakeSequenceView:Execute(arg0_63)
		end,
		function(arg0_64)
			arg0_62.isInit = true

			arg0_62:ShowOrHideResUI(arg0_62.theme:ApplyDefaultResUI())

			local var0_64 = arg0_62:GetFlagShip()

			arg0_62.bgView:Refresh(var0_64)
			arg0_62.paintingView:Refresh(var0_64, arg0_62.theme:GetPaintingOffset(var0_64))
			arg0_62.effectView:Refresh(var0_64)
			arg0_62.theme:Refresh(var0_64)
			arg0_62:PlayBgm(var0_64)
			pg.redDotHelper:Refresh()
			arg0_64()
		end,
		function(arg0_65)
			arg0_62.sequenceView:Execute(arg0_65)
		end
	}, function()
		arg0_62:SetUpSilentChecker()
		arg0_62:emit(NewMainScene.ON_ENTER_DONE)

		arg0_62.mainCG.blocksRaycasts = true
	end)
end

function var0_0.OnDisVisible(arg0_67)
	arg0_67:FoldPanels(false)
	arg0_67.paintingView:Disable()
	arg0_67.bgView:Disable()
	arg0_67.sequenceView:Disable()
	arg0_67.awakeSequenceView:Disable()

	if arg0_67.theme then
		arg0_67.theme:Disable()
	end

	pg.redDotHelper:Disable()
	arg0_67.buffDescPage:Disable()
	arg0_67.silentChecker:Disable()

	if arg0_67.silentView and arg0_67.silentView:isShowing() then
		arg0_67:ExitSilentView()
	end

	arg0_67.calibrationPage:Destroy()
	arg0_67.calibrationPage:Reset()
	arg0_67.skinExperienceDisplayPage:Destroy()
	arg0_67.skinExperienceDisplayPage:Reset()
	arg0_67.liveAreaPage:Destroy()
	arg0_67.liveAreaPage:Reset()

	arg0_67.isInit = false

	arg0_67:RevertSleepTimeout()
	arg0_67:RevertAsmrShip()
end

function var0_0.UnloadTheme(arg0_68)
	if arg0_68.theme then
		arg0_68.theme:Destroy()
		arg0_68.theme:Reset()

		arg0_68.theme = nil
	end
end

function var0_0.ExitCalibrationView(arg0_69)
	if arg0_69.calibrationPage and arg0_69.calibrationPage:GetLoaded() and arg0_69.calibrationPage:isShowing() then
		triggerButton(arg0_69.calibrationPage.backBtn)
	end
end

function var0_0.ExitSilentView(arg0_70)
	if arg0_70.silentView and arg0_70.silentView:isShowing() then
		arg0_70:FoldPanels(false)
		arg0_70.silentView:Destroy()
		arg0_70.silentView:Reset()
	end
end

function var0_0.GameLogout(arg0_71)
	arg0_71:ExitCalibrationView()
	arg0_71:ExitSilentView()
end

function var0_0.onBackPressed(arg0_72)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if arg0_72.silentView and arg0_72.silentView:isShowing() then
		arg0_72:ExitSilentView()

		return
	end

	if arg0_72.liveAreaPage and arg0_72.liveAreaPage:GetLoaded() and arg0_72.liveAreaPage:isShowing() then
		arg0_72.liveAreaPage:Hide()

		return
	end

	if arg0_72.calibrationPage and arg0_72.calibrationPage:GetLoaded() and arg0_72.calibrationPage:isShowing() then
		triggerButton(arg0_72.calibrationPage._parentTf)

		return
	end

	pg.SdkMgr.GetInstance():OnAndoridBackPress()
	pg.PushNotificationMgr.GetInstance():PushAll()
end

function var0_0.willExit(arg0_73)
	arg0_73.bgView:Dispose()

	arg0_73.bgView = nil

	arg0_73:UnloadTheme()

	if arg0_73.calibrationPage then
		arg0_73.calibrationPage:Destroy()

		arg0_73.calibrationPage = nil
	end

	if arg0_73.silentView then
		arg0_73.silentView:Destroy()

		arg0_73.silentView = nil
	end

	arg0_73.paintingView:Dispose()

	arg0_73.paintingView = nil

	arg0_73.liveAreaPage:Destroy()

	arg0_73.liveAreaPage = nil

	arg0_73.sequenceView:Dispose()

	arg0_73.sequenceView = nil

	arg0_73.awakeSequenceView:Dispose()

	arg0_73.awakeSequenceView = nil

	arg0_73.effectView:Dispose()

	arg0_73.effectView = nil

	pg.redDotHelper:Dispose()

	pg.redDotHelper = nil

	arg0_73.buffDescPage:Destroy()

	arg0_73.buffDescPage = nil

	arg0_73.silentChecker:Dispose()

	arg0_73.silentChecker = nil

	arg0_73.skinExperienceDisplayPage:Destroy()

	arg0_73.skinExperienceDisplayPage = nil

	arg0_73:RevertSleepTimeout()
end

return var0_0
