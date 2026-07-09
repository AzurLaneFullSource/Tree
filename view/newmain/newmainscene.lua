local var0_0 = class("NewMainScene", import("..base.BaseUI"))

var0_0.THEME_CLASSIC = 1
var0_0.THEME_MELLOW = 2
var0_0.OPEN_LIVEAREA = "NewMainScene.OPEN_LIVEAREA"
var0_0.UPDATE_COVER = "NewMainScene.UPDATE_COVER"
var0_0.FOLD = "NewMainScene.FOLD"
var0_0.HIDE = "NewMainScene.HIDE"
var0_0.CHAT_STATE_CHANGE = "NewMainScene.CHAT_STATE_CHANGE"
var0_0.ON_CHANGE_SKIN = "NewMainScene.ON_CHANGE_SKIN"
var0_0.ON_BUFF_DESC = "NewMainScene.ON_BUFF_DESC"
var0_0.ON_SKIN_FREEUSAGE_DESC = "NewMainScene.ON_SKIN_FREEUSAGE_DESC"
var0_0.ENABLE_PAITING_MOVE = "NewMainScene.ENABLE_PAITING_MOVE"
var0_0.ENABLE_PAITING_SCALE = "NewMainScene.ENABLE_PAITING_SCALE"
var0_0.SAVE_PART_SCALE = "NewMainScene.SAVE_PART_SCALE"
var0_0.RESET_PAITING_SCALE = "NewMainScene.RESET_PAITING_SCALE"
var0_0.SET_SCALE_PART_CONTENT = "NewMainScene.SET_SCALE_PART_CONTENT"
var0_0.ON_ENTER_DONE = "NewMainScene.ON_ENTER_DONE"
var0_0.ENTER_SILENT_VIEW = "NewMainScene.ENTER_SILENT_VIEW"
var0_0.EXIT_SILENT_VIEW = "NewMainScene.EXIT_SILENT_VIEW"
var0_0.L2D_BOUND_CHANGE = "NewMainScene.L2D_BOUND_CHANGE"
var0_0.RESET_L2D = "NewMainScene.RESET_L2D"

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

	arg0_30.subMediator = MainReddotMediator.New()

	pg.m02:registerMediator(arg0_30.subMediator)

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
			if arg0_41:CheckDebugBattleLoop() then
				return
			else
				arg0_42()
			end
		end,
		function(arg0_43)
			arg0_41.awakeSequenceView:Execute(arg0_43)
		end,
		function(arg0_44)
			var0_41 = arg0_41:GetFlagShip()

			arg0_41.bgView:Init(var0_41)
			onNextTick(arg0_44)
		end,
		function(arg0_45)
			arg0_41.theme = arg0_41.themes[arg0_41:GetThemeStyle()]

			arg0_41.theme:ExecuteAction("Show", arg0_45)
		end,
		function(arg0_46)
			onNextTick(arg0_46)
		end,
		function(arg0_47)
			arg0_41.isInit = true

			arg0_41.theme:PlayEnterAnimation(var0_41, arg0_47)

			local var0_47 = arg0_41.theme:GetPaintingOffset(var0_41)

			arg0_41.paintingView:Init(var0_41, var0_47, arg1_41)

			arg0_41.resAnimFlag = true
		end,
		function(arg0_48)
			arg0_41:PlayBgm(var0_41)
			arg0_41.effectView:Init(var0_41)
			arg0_41.theme:init(var0_41)
			onNextTick(arg0_48)
		end,
		function(arg0_49)
			arg0_41:ShowOrHideResUI(arg0_41.theme:ApplyDefaultResUI())
			arg0_41.sequenceView:Execute(arg0_49)
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

function var0_0.SetUpSilentChecker(arg0_51)
	local var0_51 = getProxy(SettingsProxy):GetMainSceneScreenSleepTime()

	arg0_51.defaultSleepTimeout = Screen.sleepTimeout
	Screen.sleepTimeout = var0_51

	if SettingsMainScenePanel.IsEnableStandbyMode() then
		arg0_51.silentChecker:SetUp()
	end
end

function var0_0.RevertSleepTimeout(arg0_52)
	if arg0_52.defaultSleepTimeout and Screen.sleepTimeout ~= arg0_52.defaultSleepTimeout then
		Screen.sleepTimeout = arg0_52.defaultSleepTimeout
	end

	arg0_52.defaultSleepTimeout = nil
end

function var0_0.FoldPanels(arg0_53, arg1_53)
	if not arg0_53.theme then
		return
	end

	arg0_53.foldFlag = arg1_53

	arg0_53.theme:OnFoldPanels(arg1_53)
	arg0_53.paintingView:Fold(arg1_53, 0.5)
	pg.playerResUI:Fold(arg1_53, 0.5)
	arg0_53:SetEffectPanelVisible(not arg1_53)
end

function var0_0.HidePanel(arg0_54, arg1_54)
	if not arg0_54.theme then
		return
	end

	if arg0_54.foldFlag == arg1_54 then
		return
	end

	arg0_54.foldFlag = arg1_54

	arg0_54.theme:OnFoldPanels(arg1_54)

	if arg0_54._asmrTurnning then
		if arg0_54.foldFlag == true then
			pg.playerResUI:Fold(arg1_54, 0.5)
		end
	else
		pg.playerResUI:Fold(arg1_54, 0.5)
	end

	if not arg1_54 and arg0_54._asmrTurnning then
		arg0_54:SetEffectPanelVisible(false)
	else
		arg0_54:SetEffectPanelVisible(not arg1_54)
	end
end

function var0_0.AsmrTurning(arg0_55, arg1_55)
	arg0_55._asmrTurnning = arg1_55

	arg0_55.paintingView:OnAsmrTurnning(arg1_55)
	arg0_55.theme:OnAsmrTurnning(arg1_55)
	arg0_55.silentChecker:SetSilentRun(not arg1_55)

	if not arg0_55._asmrTurnning then
		arg0_55:SetUpSilentChecker()
		pg.BgmMgr.GetInstance():ContinuePlay()
	else
		pg.BgmMgr.GetInstance():StopPlay()
	end
end

function var0_0.SwitchToNextShip(arg0_56)
	if arg0_56.paintingView:IsLoading() or arg0_56.bgView:IsLoading() or not arg0_56.theme then
		return
	end

	local var0_56 = getProxy(PlayerProxy):getRawData():GetNextFlagShip()

	if arg0_56.bgView.ship:getSkinId() ~= var0_56:getSkinId() or arg0_56.bgView.ship.id ~= var0_56.id then
		arg0_56.bgView:Refresh(var0_56)
		arg0_56:PlayBgm(var0_56)
		arg0_56.paintingView:Refresh(var0_56, arg0_56.theme:GetPaintingOffset(var0_56))
		arg0_56.effectView:Refresh(var0_56)
		arg0_56.theme:OnSwitchToNextShip(var0_56)
	end
end

function var0_0.UpdateFlagShip(arg0_57, arg1_57, arg2_57)
	if arg0_57.paintingView:IsLoading() or arg0_57.bgView:IsLoading() or not arg0_57.theme then
		return
	end

	local var0_57 = arg2_57.callback

	arg0_57.bgView:Refresh(arg1_57)
	arg0_57:PlayBgm(arg1_57)
	arg0_57.paintingView:SetOnceLoadedCall(var0_57)
	arg0_57.paintingView:Refresh(arg1_57, arg0_57.theme:GetPaintingOffset(arg1_57))
	arg0_57.effectView:Refresh(arg1_57)
	arg0_57.theme:OnSwitchToNextShip(arg1_57)
end

function var0_0.CheckDebugBattleLoop(arg0_58)
	if not InDebugBattleLoop then
		return false
	end

	local var0_58 = InDebugBattleLoop

	if #var0_58.tempList == 0 then
		if #var0_58.loopStages > 0 then
			local var1_58 = table.remove(var0_58.loopStages, 1)

			for iter0_58 = 1, var0_58.loopCount do
				table.insert(var0_58.tempList, var1_58)
			end
		else
			InDebugBattleLoop = nil

			pg.TipsMgr.GetInstance():ShowTips("finish")

			return false
		end
	end

	local var2_58 = table.remove(var0_58.tempList, 1)

	print(string.format("【正在执行关卡%s的第%d次战斗循环】", var2_58, var0_58.loopCount - #var0_58.tempList))
	arg0_58:emit(NewMainMediator.DEBUG_BATTLE_LOOP, var2_58)

	return true
end

function var0_0.PlayChangeSkinActionOut(arg0_59, arg1_59)
	arg0_59.paintingView:PlayChangeSkinActionOut(arg1_59)
end

function var0_0.PlayChangeSkinActionIn(arg0_60, arg1_60)
	arg0_60.paintingView:PlayChangeSkinActionIn(arg1_60)
end

function var0_0.CheckAndReplayBgm(arg0_61)
	local var0_61 = arg0_61:GetFlagShip()

	arg0_61.theme:Refresh(var0_61)
	arg0_61:PlayBgm(var0_61)
end

function var0_0.SetEffectPanelVisible(arg0_62, arg1_62)
	if arg0_62.theme then
		arg0_62.theme:SetEffectPanelVisible(arg1_62)
	end
end

function var0_0.OnVisible(arg0_63)
	arg0_63:RevertAsmrShip()

	local var0_63 = arg0_63.themes[arg0_63:GetThemeStyle()]

	if not (not arg0_63.theme or var0_63 ~= arg0_63.theme) then
		arg0_63:Refresh()
	else
		arg0_63:UnloadTheme()
		arg0_63:SetUp(true)
	end
end

function var0_0.Refresh(arg0_64)
	arg0_64.mainCG.blocksRaycasts = false

	seriesAsync({
		function(arg0_65)
			if arg0_64:CheckDebugBattleLoop() then
				return
			else
				arg0_65()
			end
		end,
		function(arg0_66)
			arg0_64.awakeSequenceView:Execute(arg0_66)
		end,
		function(arg0_67)
			arg0_64.isInit = true

			arg0_64:ShowOrHideResUI(arg0_64.theme:ApplyDefaultResUI())

			local var0_67 = arg0_64:GetFlagShip()

			arg0_64.bgView:Refresh(var0_67)
			arg0_64.paintingView:Refresh(var0_67, arg0_64.theme:GetPaintingOffset(var0_67))
			arg0_64.effectView:Refresh(var0_67)
			arg0_64.theme:Refresh(var0_67)
			arg0_64:PlayBgm(var0_67)
			arg0_67()
		end,
		function(arg0_68)
			arg0_64.sequenceView:Execute(arg0_68)
		end
	}, function()
		arg0_64:SetUpSilentChecker()
		arg0_64:emit(NewMainScene.ON_ENTER_DONE)

		arg0_64.mainCG.blocksRaycasts = true
	end)
end

function var0_0.OnDisVisible(arg0_70)
	arg0_70:FoldPanels(false)
	arg0_70.paintingView:Disable()
	arg0_70.bgView:Disable()
	arg0_70.sequenceView:Disable()
	arg0_70.awakeSequenceView:Disable()

	if arg0_70.theme then
		arg0_70.theme:Disable()
	end

	arg0_70.buffDescPage:Disable()
	arg0_70.silentChecker:Disable()

	if arg0_70.silentView and arg0_70.silentView:isShowing() then
		arg0_70:ExitSilentView()
	end

	arg0_70.calibrationPage:Destroy()
	arg0_70.calibrationPage:Reset()
	arg0_70.skinExperienceDisplayPage:Destroy()
	arg0_70.skinExperienceDisplayPage:Reset()
	arg0_70.liveAreaPage:Destroy()
	arg0_70.liveAreaPage:Reset()

	arg0_70.isInit = false

	arg0_70:RevertSleepTimeout()
	arg0_70:RevertAsmrShip()
end

function var0_0.UnloadTheme(arg0_71)
	if arg0_71.theme then
		arg0_71.theme:Destroy()
		arg0_71.theme:Reset()

		arg0_71.theme = nil
	end
end

function var0_0.ExitCalibrationView(arg0_72)
	if arg0_72.calibrationPage and arg0_72.calibrationPage:GetLoaded() and arg0_72.calibrationPage:isShowing() then
		triggerButton(arg0_72.calibrationPage.backBtn)
	end
end

function var0_0.ExitSilentView(arg0_73)
	if arg0_73.silentView and arg0_73.silentView:isShowing() then
		arg0_73:FoldPanels(false)
		arg0_73.silentView:Destroy()
		arg0_73.silentView:Reset()
	end
end

function var0_0.GameLogout(arg0_74)
	arg0_74:ExitCalibrationView()
	arg0_74:ExitSilentView()
end

function var0_0.onBackPressed(arg0_75)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if arg0_75.silentView and arg0_75.silentView:isShowing() then
		arg0_75:ExitSilentView()

		return
	end

	if arg0_75.liveAreaPage and arg0_75.liveAreaPage:GetLoaded() and arg0_75.liveAreaPage:isShowing() then
		arg0_75.liveAreaPage:Hide()

		return
	end

	if arg0_75.calibrationPage and arg0_75.calibrationPage:GetLoaded() and arg0_75.calibrationPage:isShowing() then
		triggerButton(arg0_75.calibrationPage._parentTf)

		return
	end

	pg.SdkMgr.GetInstance():OnAndoridBackPress()
	pg.PushNotificationMgr.GetInstance():PushAll()
end

function var0_0.willExit(arg0_76)
	arg0_76.bgView:Dispose()

	arg0_76.bgView = nil

	arg0_76:UnloadTheme()

	if arg0_76.calibrationPage then
		arg0_76.calibrationPage:Destroy()

		arg0_76.calibrationPage = nil
	end

	if arg0_76.silentView then
		arg0_76.silentView:Destroy()

		arg0_76.silentView = nil
	end

	arg0_76.paintingView:Dispose()

	arg0_76.paintingView = nil

	arg0_76.liveAreaPage:Destroy()

	arg0_76.liveAreaPage = nil

	arg0_76.sequenceView:Dispose()

	arg0_76.sequenceView = nil

	arg0_76.awakeSequenceView:Dispose()

	arg0_76.awakeSequenceView = nil

	arg0_76.effectView:Dispose()

	arg0_76.effectView = nil

	pg.m02:removeMediator(arg0_76.subMediator.__cname)

	arg0_76.subMediator = nil

	arg0_76.buffDescPage:Destroy()

	arg0_76.buffDescPage = nil

	arg0_76.silentChecker:Dispose()

	arg0_76.silentChecker = nil

	arg0_76.skinExperienceDisplayPage:Destroy()

	arg0_76.skinExperienceDisplayPage = nil

	arg0_76:RevertSleepTimeout()
end

return var0_0
