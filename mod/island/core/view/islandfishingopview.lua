local var0_0 = class("IslandFishingOPView", import("Mod.Island.Core.View.IslandASynLoadAndCacheSubView"))
local var1_0 = 1
local var2_0 = 2
local var3_0 = 3
local var4_0 = 0
local var5_0 = 1
local var6_0 = 2
local var7_0 = 3
local var8_0 = 4
local var9_0 = 5

function var0_0.GetUIName(arg0_1)
	return "IslandFishingOpUI"
end

function var0_0.FirstFlush(arg0_2)
	arg0_2.loadingIdList = {}
	arg0_2.backBtn = arg0_2._tf:Find("back")
	arg0_2.fishContainer = arg0_2._tf:Find("container")
	arg0_2.player = arg0_2:GetView().player
	arg0_2.escapeTip = arg0_2._tf:Find("escape_tip")
	arg0_2.hookedTip = arg0_2._tf:Find("escape_tip_1")
	arg0_2.resultTr = arg0_2._tf:Find("result")
	arg0_2.resultNewTr = arg0_2.resultTr:Find("new")
	arg0_2.resultCupMinTr = arg0_2.resultTr:Find("cup_min")
	arg0_2.resultCupMaxTr = arg0_2.resultTr:Find("cup_max")
	arg0_2.resultRecordTr = arg0_2.resultTr:Find("record")
	arg0_2.resultTxt = arg0_2.resultTr:Find("Text"):GetComponent(typeof(Text))
	arg0_2.cg = GetOrAddComponent(arg0_2._tf, typeof(CanvasGroup))

	setText(arg0_2._tf:Find("escape_tip/Text"), i18n("island_fishing_tip_escape"))
	setText(arg0_2._tf:Find("escape_tip_1/Text"), i18n("island_fishing_tip_hooked"))

	arg0_2.fishingPlayer = IslandFishingPlayer.New(arg0_2:GetView(), arg0_2:GetView().player)

	onButton(arg0_2, arg0_2.backBtn, function()
		arg0_2:PauseGame()
		arg0_2:ShowMsgbox({
			content = i18n("island_fishing_exit"),
			onYes = function()
				arg0_2:ExitGame()
			end,
			onHide = function()
				arg0_2:ResumeGame()
			end
		})
	end, SFX_PANEL)

	arg0_2.state = var4_0
end

function var0_0.Flush(arg0_6, arg1_6, arg2_6)
	arg0_6.fishPointId = arg1_6
	arg0_6.opBtnLocalPosition = arg2_6
	arg0_6.state = var5_0

	arg0_6:StartGame(arg1_6, baitId)

	arg0_6.startTime = pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.StartGame(arg0_7, arg1_7)
	pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandFishingEnter(arg0_7.fishPointId))
	seriesAsync({
		function(arg0_8)
			arg0_7:BlockEvent()
			arg0_7:TurnToFishPoistion(arg1_7, arg0_8)
		end,
		function(arg0_9)
			arg0_7:CheckServerBait(arg0_9)
		end,
		function(arg0_10)
			arg0_7:DisableOpView(arg1_7)
			arg0_7:GetFishFromServer(arg1_7, arg0_10)
		end,
		function(arg0_11)
			arg0_7:LoadFishRodModel(arg0_11)
		end,
		function(arg0_12)
			arg0_7:PreloadEffects(arg1_7, arg0_12)
		end,
		function(arg0_13)
			arg0_7:PlayEffect(IslandFishingEffectMgr.EFFECT_ENTER, IslandFishingEffectMgr.EFFECT_ENTER_TIME)
			arg0_7:PlayCastAnimation(arg0_13)
		end,
		function(arg0_14)
			arg0_7:UnBlockEvent()
			arg0_7:PlayEffect(IslandFishingEffectMgr.EFFECT_WAITING)
			arg0_7:WaitingToBeHooked(arg0_14)
		end,
		function(arg0_15)
			if not arg0_7:IsRunning() and not arg0_7:IsPausing() then
				return
			end

			arg0_7:RemoveWaitingToBeHooked()
			arg0_7:PlayEffect(IslandFishingEffectMgr.EFFECT_HOOKED)
			arg0_7:PlayHookedAnimation(arg0_15)
		end,
		function(arg0_16)
			if not arg0_7:IsRunning() and not arg0_7:IsPausing() then
				return
			end

			arg0_7:PlayEffect(IslandFishingEffectMgr.EFFECT_SHAKE)
			arg0_7:LoadQteUI(arg0_16)
		end
	})
end

function var0_0.PreloadEffects(arg0_17, arg1_17, arg2_17)
	arg0_17.fishingPlayer:PreloadEffects(arg2_17)
end

function var0_0.PlayEffect(arg0_18, arg1_18, arg2_18)
	arg0_18.fishingPlayer:PlayEffect(arg1_18, arg2_18)
end

function var0_0.ExitGame(arg0_19)
	arg0_19:BlockEvent()
	arg0_19:OnCancel(function()
		arg0_19:UnBlockEvent()
		arg0_19:Dispose()
	end)
end

function var0_0.SwitchToFishingCamrea(arg0_21, arg1_21)
	local var0_21 = pg.island_fish_point[arg1_21].camera or IslandConst.FISHING_CAMERA_NAME
	local var1_21 = IslandCameraMgr.instance:GetVirtualCamera(var0_21)

	var1_21.Follow = arg0_21.player._tf
	var1_21.LookAt = arg0_21.player._tf

	IslandCameraMgr.instance:ActiveVirtualCamera(var0_21)
end

function var0_0.ResetCamrea(arg0_22)
	IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.FOLLOW_CAMERA_NAME)
end

function var0_0.CheckServerBait(arg0_23, arg1_23)
	local var0_23 = arg0_23:GetSelfIsland():GetFishingAgency()

	if not var0_23:NeedUpdateServerBait() then
		arg1_23()

		return
	end

	arg0_23:NotifiyMeditor(IslandBaseMediator.EXCHANGE_LURE, var0_23:GetBaitId(), arg0_23.fishPointId, arg1_23)
end

function var0_0.GetFishFromServer(arg0_24, arg1_24, arg2_24)
	arg0_24:NotifiyMeditor(IslandBaseMediator.GO_FISHING, arg1_24, 0, function(arg0_25, arg1_25, arg2_25)
		if arg0_25 == 0 and arg1_25 == 0 then
			arg0_24:UnBlockEvent()

			arg0_24.state = var7_0
		else
			arg0_24.fishId = arg0_25
			arg0_24.weight = arg1_25
			arg0_24.cupType = arg2_25

			arg0_24:InitArgs(arg0_25, arg1_25)
			arg2_24()
		end
	end)
end

function var0_0.InitArgs(arg0_26, arg1_26, arg2_26)
	local var0_26 = pg.island_fish[arg1_26]

	assert(var0_26, "island_fish>>>>>>>>>>>>" .. arg1_26)

	arg0_26.fishId = arg1_26
	arg0_26.fishConfig = var0_26
	arg0_26.fishName = var0_26.name
	arg0_26.fishWeight = arg2_26

	local var1_26 = var0_26.bite_time[1]
	local var2_26 = var0_26.bite_time[2]

	arg0_26.biteTime = math.random(var1_26, var2_26)

	local var3_26 = arg0_26:GetView():GetSelfIsland():GetFishingAgency()

	arg0_26.isNew = var3_26:IsNewFish(arg1_26)
	arg0_26.isNewRecord = var3_26:IsNewRecord(arg1_26, arg2_26)

	local var4_26 = var3_26:GetFishRodId()

	assert(pg.island_fish_rod[var4_26], "island_fish_rod>>>>>>>>>>>>" .. var4_26)

	arg0_26.fishRodId = pg.island_fish_rod[var4_26].attachment_id
	arg0_26.rodProfile = pg.island_fish_rod[var4_26].qte_effect
	arg0_26.fishPrifile = var0_26.qte_effect

	if not arg0_26.rodProfile or arg0_26.rodProfile == "" then
		arg0_26.rodProfile = "default"
	end

	if not arg0_26.fishPrifile or arg0_26.fishPrifile == "" then
		arg0_26.fishPrifile = "default"
	end

	arg0_26.fishingPlayer:InitArgs(arg0_26.fishPointId, arg0_26.fishRodId, arg0_26.fishId)
end

function var0_0.TurnToFishPoistion(arg0_27, arg1_27, arg2_27)
	arg0_27.fishingPlayer:TurnToFishPoistion(arg1_27, arg2_27)
end

function var0_0.PlayCastAnimation(arg0_28, arg1_28)
	arg0_28.fishingPlayer:PlayCastAnimation(arg1_28)
end

function var0_0.PlayHookedAnimation(arg0_29, arg1_29)
	arg0_29:ShowTip(arg0_29.hookedTip, 1, arg1_29)
	arg0_29.fishingPlayer:PlayHookedAnimation()
end

function var0_0.PlayHookEndAnimation(arg0_30, arg1_30)
	arg0_30.fishingPlayer:PlayHookEndAnimation(arg1_30)
end

function var0_0.PlayFailAnimation(arg0_31, arg1_31)
	arg0_31.fishingPlayer:PlayFailAnimation(arg1_31)
end

function var0_0.PlayHookMiddleAnimation(arg0_32)
	arg0_32.fishingPlayer:PlayHookMiddleAnimation()
end

function var0_0.PlayCancelAnimation(arg0_33, arg1_33)
	arg0_33.fishingPlayer:PlayCancelAnimation(arg1_33)
end

function var0_0.PlayMovementAnimation(arg0_34)
	arg0_34.fishingPlayer:PlayMovementAnimation()
end

function var0_0.WaitingToBeHooked(arg0_35, arg1_35)
	arg0_35:RemoveWaitingToBeHooked()

	arg0_35.beitTimer = Timer.New(arg1_35, arg0_35.biteTime, 1)

	arg0_35.beitTimer:Start()
end

function var0_0.RemoveWaitingToBeHooked(arg0_36)
	if arg0_36.beitTimer then
		arg0_36.beitTimer:Stop()

		arg0_36.beitTimer = nil
	end
end

function var0_0.LoadQteUI(arg0_37, arg1_37)
	local var0_37
	local var1_37

	arg0_37:BlockEvent()
	seriesAsync({
		function(arg0_38)
			local var0_38 = IslandAssetLoadDispatcher.Instance:Enqueue("island/FishRod/" .. arg0_37.rodProfile, "", typeof(FishRodProfile), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_39)
				var0_37 = arg0_39

				arg0_38()
			end), true, true)

			arg0_37:AddLoadingID(var0_38)
		end,
		function(arg0_40)
			onNextTick(arg0_40)
		end,
		function(arg0_41)
			local var0_41 = IslandAssetLoadDispatcher.Instance:Enqueue("island/fishingcurve/" .. arg0_37.fishPrifile, "", typeof(FishMotionProfile), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_42)
				var1_37 = arg0_42

				arg0_41()
			end), true, true)

			arg0_37:AddLoadingID(var0_41)
		end,
		function(arg0_43)
			local var0_43 = IslandAssetLoadDispatcher.Instance:Enqueue("UI/IslandFishingQteUI", "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_44)
				arg0_37:OnLoadQTE(arg0_44, var1_37, var0_37)
				arg0_43()
			end), true, true)

			arg0_37:AddLoadingID(var0_43)
		end,
		function(arg0_45)
			onNextTick(arg0_45)
		end
	}, function()
		arg0_37:UpdateQteLayout()

		if arg0_37:IsPausing() then
			arg0_37:PauseGame()
		end

		arg0_37:UnBlockEvent()
		arg1_37()
	end)
end

function var0_0.OnLoadQTE(arg0_47, arg1_47, arg2_47, arg3_47)
	arg0_47.qteTr = Object.Instantiate(arg1_47, arg0_47.fishContainer)
	arg0_47.clickEffect = arg0_47.qteTr.transform:Find("fishing_btn/vfx_diaoyuui_fankui")
	arg0_47.hitEffect = arg0_47.qteTr.transform:Find("bar/vfx_diaoyuui_mingzhong")
	arg0_47.getAnim = arg0_47.qteTr.transform:Find("power"):GetComponent(typeof(Animation))
	arg0_47.getAnimDft = arg0_47.qteTr.transform:Find("power"):GetComponent(typeof(DftAniEvent))
	arg0_47.failedEffect = arg0_47.qteTr.transform:Find("P_glow_02")
	arg0_47.failedAnim = arg0_47.qteTr.transform:Find("energy"):GetComponent(typeof(Animation))
	arg0_47.failedAnimDft = arg0_47.qteTr.transform:Find("energy"):GetComponent(typeof(DftAniEvent))
	arg0_47.qteAim = arg0_47.qteTr:GetComponent(typeof(Animation))
	arg0_47.qteAimDft = arg0_47.qteTr:GetComponent(typeof(DftAniEvent))
	arg0_47.clickableTip = arg0_47.qteTr.transform:Find("fishing_btn/vx")

	local var0_47 = arg0_47.qteTr:GetComponent(typeof(IslandFishingSliderDriver))

	var0_47:UpdateFish(arg2_47)
	var0_47:UpdateRod(arg3_47)
	arg0_47:AddResultListener(var0_47)
end

function var0_0.UpdateQteLayout(arg0_48)
	if not arg0_48.qteTr then
		return
	end

	local var0_48 = arg0_48._tf:TransformPoint(arg0_48.opBtnLocalPosition)
	local var1_48 = arg0_48.qteTr.transform:InverseTransformPoint(var0_48)

	arg0_48.qteTr.transform:Find("fishing_btn").localPosition = Vector3(var1_48.x, var1_48.y, 0)
end

function var0_0.UnloadQteUI(arg0_49, arg1_49)
	arg0_49:RemoveResultListener()

	if arg0_49.qteTr and arg1_49 then
		arg0_49.qteAimDft:SetEndEvent(nil)
		arg0_49.qteAimDft:SetEndEvent(function()
			arg0_49.qteAimDft:SetEndEvent(nil)
			Object.Destroy(arg0_49.qteTr)

			arg0_49.qteTr = nil

			arg1_49()
		end)
		arg0_49.qteAim:Play("anim_IslandFishingQteUI_out")
	elseif arg0_49.qteTr and not arg1_49 then
		Object.Destroy(arg0_49.qteTr)

		arg0_49.qteTr = nil
	elseif arg1_49 then
		arg1_49()
	end
end

function var0_0.AddResultListener(arg0_51, arg1_51)
	function arg1_51.OnSuccess()
		arg0_51:OnQteSuccess()
	end

	function arg1_51.OnFailure()
		arg0_51:OnQteFailed()
	end

	function arg1_51.OnProgress(arg0_54)
		arg0_51:OnQteProgress(arg0_54)
	end

	function arg1_51.OnHit(arg0_55)
		arg0_51:OnHit(arg0_55)
	end

	arg0_51.fishingSliderDriver = arg1_51
end

function var0_0.RemoveResultListener(arg0_56)
	if arg0_56.fishingSliderDriver then
		local var0_56 = arg0_56.fishingSliderDriver

		var0_56.OnSuccess = nil
		var0_56.OnFailure = nil
		var0_56.OnProgress = nil
		var0_56.OnHit = nil
		arg0_56.fishingSliderDriver = nil
	end
end

function var0_0.LoadFishRodModel(arg0_57, arg1_57)
	arg0_57.fishingPlayer:LoadFishRodModel(arg1_57)
end

function var0_0.UnLoadFishRodModel(arg0_58)
	arg0_58.fishingPlayer:UnLoadFishRodModel(callback)
end

function var0_0.LoadFishModel(arg0_59, arg1_59)
	arg0_59.fishingPlayer:LoadFishModel(arg1_59)
end

function var0_0.UnLoadFishModel(arg0_60)
	arg0_60.fishingPlayer:UnLoadFishModel(callback)
end

function var0_0.NotifyServerResultSuccess(arg0_61, arg1_61)
	arg0_61:NotifiyMeditor(IslandBaseMediator.FISHING_RESULT, IslandConst.FISHING_OP_SUCCESS, arg0_61.fishPointId, arg0_61.fishId, arg0_61.weight, arg0_61.cupType, arg1_61)
end

function var0_0.NotifyServerResultFaild(arg0_62, arg1_62)
	arg0_62:NotifiyMeditor(IslandBaseMediator.FISHING_RESULT, IslandConst.FISHING_OP_FAILD, arg0_62.fishPointId, arg0_62.fishId, arg0_62.weight, arg0_62.cupType, arg1_62)
end

function var0_0.NotifyServerResultCancel(arg0_63, arg1_63)
	arg0_63:NotifiyMeditor(IslandBaseMediator.FISHING_RESULT, IslandConst.FISHING_OP_CANCEL, arg0_63.fishPointId, arg0_63.fishId, arg0_63.weight, arg0_63.cupType, arg1_63)
end

function var0_0.IsRunning(arg0_64)
	return arg0_64.state == var5_0
end

function var0_0.IsPausing(arg0_65)
	return arg0_65.state == var9_0
end

function var0_0.PauseGame(arg0_66)
	arg0_66.state = var9_0

	if arg0_66.fishingSliderDriver then
		arg0_66.fishingSliderDriver:Pause()
	end
end

function var0_0.ResumeGame(arg0_67)
	arg0_67.state = var5_0

	if arg0_67.fishingSliderDriver then
		arg0_67.fishingSliderDriver:Reseume()
	end
end

function var0_0.BuildResultData(arg0_68, arg1_68)
	if not arg0_68.fishingSliderDriver then
		return
	end

	local var0_68 = arg0_68:GetView():GetSelfIsland():GetFishingAgency()
	local var1_68 = var0_68:GetFishRodId()
	local var2_68 = var0_68:GetBaitId()
	local var3_68 = arg0_68.fishingSliderDriver.SuccesCnt
	local var4_68 = arg0_68.fishingSliderDriver.FailCnt
	local var5_68 = math.floor(arg0_68.fishingSliderDriver.PowerRatio * 100)
	local var6_68 = math.floor(arg0_68.fishingSliderDriver.Ratio * 100)

	pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandFishingResult(arg0_68.fishPointId, var1_68, var2_68, arg0_68.fishId, arg0_68.fishWeight, var3_68, var4_68, var5_68, var6_68, arg1_68))
end

function var0_0.OnQteSuccess(arg0_69)
	arg0_69.state = var6_0

	arg0_69:BuildResultData(1)
	arg0_69:BlockEvent()
	seriesAsync({
		function(arg0_70)
			arg0_69:PlayGetEffect(arg0_70)
		end,
		function(arg0_71)
			arg0_69:UnloadQteUI(arg0_71)
		end,
		function(arg0_72)
			arg0_69:NotifyServerResultSuccess(arg0_72)
		end,
		function(arg0_73)
			arg0_69:LoadFishModel(arg0_73)
		end,
		function(arg0_74)
			arg0_69:PlayEffect(IslandFishingEffectMgr.EFFECT_LEAVE, IslandFishingEffectMgr.EFFECT_LEAVE_TIME)
			arg0_69:PlayHookEndAnimation(arg0_74)
		end,
		function(arg0_75)
			arg0_69:WaitForExit(arg0_75)
			arg0_69:DisplayResult()
		end
	}, function()
		arg0_69:UnBlockEvent()
		arg0_69:Dispose()
	end)
end

function var0_0.PlayGetEffect(arg0_77, arg1_77)
	arg0_77.getAnimDft:SetEndEvent(nil)
	arg0_77.getAnimDft:SetEndEvent(function()
		arg0_77.getAnimDft:SetEndEvent(nil)
		onNextTick(arg1_77)
	end)
	arg0_77.getAnim:Play("anim_IslandExchangeUI_power_get")
end

function var0_0.WaitForExit(arg0_79, arg1_79)
	arg0_79:RemoveWaitForExit()

	local var0_79 = pg.island_set.island_fishing_success_exit_time.key_value_int

	arg0_79.exitTimer = Timer.New(arg1_79, math.max(0.01, var0_79), 1)

	arg0_79.exitTimer:Start()
end

function var0_0.RemoveWaitForExit(arg0_80)
	if arg0_80.exitTimer then
		arg0_80.exitTimer:Stop()

		arg0_80.exitTimer = nil
	end
end

function var0_0.OnQteFailed(arg0_81)
	arg0_81:BuildResultData(0)
	arg0_81:PlayEffect(IslandFishingEffectMgr.EFFECT_NORMAL)

	arg0_81.state = var7_0

	arg0_81:ShowTip(arg0_81.escapeTip)
	arg0_81:BlockEvent()
	parallelAsync({
		function(arg0_82)
			arg0_81:UnloadQteUI(arg0_82)
		end,
		function(arg0_83)
			arg0_81:PlayFailAnimation(arg0_83)
		end
	}, function()
		arg0_81:UnBlockEvent()
		arg0_81:NotifyServerResultFaild(function()
			return
		end)
		arg0_81:Dispose()
	end)
end

function var0_0.OnQteProgress(arg0_86, arg1_86)
	if arg1_86 > 0 and not arg0_86.isFirstClick then
		arg0_86:PlayHookMiddleAnimation()

		arg0_86.isFirstClick = true
	end
end

function var0_0.OnHit(arg0_87, arg1_87)
	if not arg1_87 then
		setActive(arg0_87.failedEffect, true)
		arg0_87.failedAnimDft:SetEndEvent(nil)
		arg0_87.failedAnimDft:SetEndEvent(function()
			arg0_87.failedAnimDft:SetEndEvent(nil)
			setActive(arg0_87.failedEffect, false)
		end)
		arg0_87.failedAnim:Play("anim_IslandExchangeUI_default_energy")
	else
		setActive(arg0_87.hitEffect, false)
		setActive(arg0_87.hitEffect, true)
	end

	setActive(arg0_87.clickEffect, false)
	setActive(arg0_87.clickEffect, true)
	setActive(arg0_87.clickableTip, false)
end

function var0_0.OnCancel(arg0_89, arg1_89)
	if arg0_89.state == var5_0 or arg0_89.state == var4_0 then
		arg0_89:BuildResultData(2)
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandFishingCancel(arg0_89.fishPointId, IsNil(arg0_89.qteTr) and 1 or 2))
		arg0_89:PlayEffect(IslandFishingEffectMgr.EFFECT_NORMAL)

		arg0_89.state = var8_0

		parallelAsync({
			function(arg0_90)
				arg0_89:UnloadQteUI(arg0_90)
			end,
			function(arg0_91)
				arg0_89:PlayCancelAnimation(arg0_91)
			end
		}, function()
			arg0_89:NotifyServerResultCancel(function()
				return
			end)
			arg1_89()
		end)
	else
		arg0_89.state = var8_0

		arg0_89:Dispose()
	end
end

function var0_0.DisplayResult(arg0_94)
	arg0_94.resultTxt.text = arg0_94.fishName .. "   " .. arg0_94.fishWeight / 1000 .. "KG"

	setActive(arg0_94.resultNewTr, arg0_94.isNew)
	setActive(arg0_94.resultCupMaxTr, arg0_94.cupType == var3_0)
	setActive(arg0_94.resultCupMinTr, arg0_94.cupType == var2_0)
	setActive(arg0_94.resultRecordTr, arg0_94.isNewRecord)
	arg0_94:ShowTip(arg0_94.resultTr)
end

function var0_0.DisableOpView(arg0_95, arg1_95)
	arg0_95:SwitchToFishingCamrea(arg1_95)
	arg0_95:GetView():DisablePlayerOp()
	arg0_95:NotifiyIsland(ISLAND_EX_EVT.ENTER_FISH_POINT)
end

function var0_0.EnableOpView(arg0_96)
	arg0_96:ResetCamrea()
	arg0_96:GetView():EnablePlayerOp()
	arg0_96:NotifiyIsland(ISLAND_EX_EVT.EXIT_FISH_POINT)
end

function var0_0.ShowTip(arg0_97, arg1_97, arg2_97, arg3_97)
	setActive(arg1_97, true)
	arg0_97:RemoveTimer()

	arg0_97.timer = Timer.New(function()
		arg0_97:RemoveTimer()
		setActive(arg1_97, false)

		if arg3_97 then
			arg3_97()
		end
	end, arg2_97 or 3, 1)

	arg0_97.timer:Start()
end

function var0_0.RemoveTimer(arg0_99)
	if arg0_99.timer then
		arg0_99.timer:Stop()

		arg0_99.timer = nil
	end
end

function var0_0.BlockEvent(arg0_100)
	arg0_100.cg.blocksRaycasts = false
end

function var0_0.UnBlockEvent(arg0_101)
	arg0_101.cg.blocksRaycasts = true
end

function var0_0.AddLoadingID(arg0_102, arg1_102)
	table.insert(arg0_102.loadingIdList, arg1_102)
end

function var0_0.OnHide(arg0_103)
	arg0_103:Clear()
end

function var0_0.Clear(arg0_104)
	arg0_104:EnableOpView()
	arg0_104:PlayEffect(IslandFishingEffectMgr.EFFECT_NORMAL)

	for iter0_104, iter1_104 in ipairs(arg0_104.loadingIdList) do
		IslandAssetLoadDispatcher.Instance:Cancel(iter1_104)
	end

	arg0_104.loadingIdList = {}

	if arg0_104.failedAnimDft then
		arg0_104.failedAnimDft:SetEndEvent(nil)

		arg0_104.failedAnimDft = nil
	end

	if arg0_104.getAnimDft then
		arg0_104.getAnimDft:SetEndEvent(nil)

		arg0_104.getAnimDft = nil
	end

	if arg0_104.qteAimDft then
		arg0_104.qteAimDft:SetEndEvent(nil)

		arg0_104.qteAimDft = nil
	end

	arg0_104:UnloadQteUI()
	arg0_104:UnLoadFishModel()
	arg0_104:UnLoadFishRodModel()
	setActive(arg0_104.escapeTip, false)
	setActive(arg0_104.hookedTip, false)
	setActive(arg0_104.resultTr, false)
	arg0_104:RemoveWaitingToBeHooked()
	arg0_104:RemoveTimer()
	arg0_104:RemoveWaitForExit()

	arg0_104.isFirstClick = false

	arg0_104:PlayMovementAnimation()

	if arg0_104.fishingPlayer then
		arg0_104.fishingPlayer:Dispose()

		arg0_104.fishingPlayer = nil
	end

	arg0_104.state = var4_0

	local var0_104 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_104.startTime

	pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandFishingExit(arg0_104.fishPointId, var0_104))
end

function var0_0.OnDestroy(arg0_105)
	arg0_105:Clear()
end

return var0_0
