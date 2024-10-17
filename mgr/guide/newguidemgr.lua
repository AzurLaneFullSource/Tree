pg = pg or {}
pg.NewGuideMgr = singletonClass("NewGuideMgr")

local var0_0 = pg.NewGuideMgr

var0_0.ENABLE_GUIDE = true

require("Mgr/Guide/Include")

local var1_0 = true
local var2_0 = 0
local var3_0 = 1
local var4_0 = 2
local var5_0 = 3
local var6_0 = 4
local var7_0 = 5

local function var8_0(...)
	if not var1_0 then
		return
	end

	print(...)
end

local function var9_0(arg0_2, arg1_2)
	arg0_2.players = {
		[GuideStep.TYPE_DOFUNC] = GuideDoFunctionPlayer.New(arg1_2),
		[GuideStep.TYPE_DONOTHING] = GuideDoNothingPlayer.New(arg1_2),
		[GuideStep.TYPE_FINDUI] = GuideFindUIPlayer.New(arg1_2),
		[GuideStep.TYPE_HIDEUI] = GuideHideUIPlayer.New(arg1_2),
		[GuideStep.TYPE_SENDNOTIFIES] = GuideSendNotifiesPlayer.New(arg1_2),
		[GuideStep.TYPE_SHOWSIGN] = GuideShowSignPlayer.New(arg1_2),
		[GuideStep.TYPE_STORY] = GuideStoryPlayer.New(arg1_2)
	}
end

local function var10_0(arg0_3)
	local var0_3 = require("GameCfg.guide.newguide.segments." .. arg0_3)

	return Guide.New(var0_3)
end

function var0_0.Init(arg0_4, arg1_4)
	arg0_4.sceneRecords = {}
	arg0_4.state = var2_0

	LoadAndInstantiateAsync("ui", "NewGuideUI", function(arg0_5)
		arg0_4._go = arg0_5
		arg0_4._tf = arg0_4._go.transform

		arg0_4._go:SetActive(false)
		arg0_4._go.transform:SetParent(pg.UIMgr.GetInstance().OverlayToast, false)

		arg0_4.uiFinder = GuideUIFinder.New(arg0_4._tf)
		arg0_4.uiDuplicator = GuideUIDuplicator.New(arg0_4._tf:Find("target"))
		arg0_4.uiLoader = GuideUILoader.New(arg0_4._tf:Find("target"))
		arg0_4.dialogueWindows = {
			[GuideStep.DIALOGUE_BLUE] = arg0_4._tf:Find("windows/window_1")
		}
		arg0_4.counsellors = {}
		arg0_4.state = var3_0
		arg0_4.uiLongPress = GetOrAddComponent(arg0_4._tf:Find("BG/close_btn"), typeof(UILongPressTrigger))
		arg0_4.uiLongPress.longPressThreshold = 10

		var9_0(arg0_4, arg0_4._tf)
		arg1_4()
	end, true, true)
end

function var0_0.PlayNothing(arg0_6)
	SetActive(arg0_6._go, true)
end

function var0_0.StopNothing(arg0_7)
	SetActive(arg0_7._go, false)
end

function var0_0.Play(arg0_8, arg1_8, arg2_8, arg3_8, arg4_8)
	if not arg0_8:CanPlay() then
		var8_0("can not play guide " .. arg1_8)
		arg3_8()

		return
	end

	var8_0("play guide : " .. arg1_8)

	local var0_8 = var10_0(arg1_8)

	arg0_8:PlayScript(var0_8, arg2_8, arg3_8, arg4_8)
end

function var0_0._Play(arg0_9, arg1_9, arg2_9, arg3_9, arg4_9)
	local var0_9 = Guide.New(arg1_9)

	arg0_9:PlayScript(var0_9, arg2_9, arg3_9, arg4_9)
end

function var0_0.PlayScript(arg0_10, arg1_10, arg2_10, arg3_10, arg4_10)
	if not arg1_10 then
		var8_0("should exist guide file ")
		arg3_10()

		return
	end

	arg0_10.OnFailed = arg4_10

	arg0_10:OnStart()

	local var0_10 = {}

	for iter0_10, iter1_10 in ipairs(arg1_10:GetStepsWithCode(arg2_10)) do
		table.insert(var0_10, function(arg0_11)
			if arg0_10:IsStop() then
				return
			end

			local var0_11 = arg0_10.players[iter1_10:GetType()]

			var0_11:Execute(iter1_10, arg0_11)

			arg0_10.player = var0_11
		end)
	end

	seriesAsync(var0_10, function()
		arg0_10:OnEnd(arg3_10)
	end)
end

function var0_0.CanPlay(arg0_13)
	if pg.MsgboxMgr.GetInstance()._go.activeSelf or pg.NewStoryMgr.GetInstance():IsRunning() or not var0_0.ENABLE_GUIDE or not arg0_13:IsLoaded() or arg0_13:IsPause() or arg0_13:IsBusy() then
		return false
	end

	return true
end

function var0_0.OnStart(arg0_14)
	pg.DelegateInfo.New(arg0_14)

	arg0_14.state = var4_0

	pg.m02:sendNotification(GAME.START_GUIDE)
	arg0_14._go.transform:SetAsLastSibling()
	arg0_14._go:SetActive(true)
	arg0_14.uiLongPress.onLongPressed:AddListener(function()
		arg0_14:Stop()
	end)
end

function var0_0.OnEnd(arg0_16, arg1_16)
	arg0_16.uiLongPress.onLongPressed:RemoveAllListeners()
	pg.DelegateInfo.Dispose(arg0_16)

	arg0_16.state = var3_0

	arg0_16:Clear()

	if arg1_16 then
		arg1_16()
	end
end

function var0_0.Pause(arg0_17)
	if arg0_17:IsBusy() then
		arg0_17.state = var6_0

		SetActive(arg0_17._go, false)
	end
end

function var0_0.Resume(arg0_18)
	if arg0_18:IsPause() then
		arg0_18.state = var4_0

		SetActive(arg0_18._go, true)
	end
end

function var0_0.Stop(arg0_19)
	if arg0_19.state ~= var5_0 then
		if arg0_19.OnFailed then
			arg0_19.OnFailed()
		end

		arg0_19.state = var5_0

		arg0_19.uiFinder:Clear()
		arg0_19.uiDuplicator:Clear()
		arg0_19.uiLoader:Clear()
		arg0_19:Clear()
	end
end

function var0_0.NextStep(arg0_20)
	if not IsUnityEditor then
		return
	end

	if arg0_20.state == var4_0 and arg0_20.player then
		arg0_20.player:NextOne()
	end
end

function var0_0.Clear(arg0_21)
	arg0_21.OnFailed = nil
	arg0_21.sceneRecords = {}

	arg0_21._go:SetActive(false)

	for iter0_21, iter1_21 in ipairs(arg0_21.players) do
		iter1_21:Clear()
	end

	if arg0_21.player then
		arg0_21.player = nil
	end

	pg.m02:sendNotification(GAME.END_GUIDE)
end

function var0_0.IsPause(arg0_22)
	return arg0_22.state and arg0_22.state == var6_0
end

function var0_0.IsBusy(arg0_23)
	return arg0_23.state and arg0_23.state == var4_0
end

function var0_0.IsLoaded(arg0_24)
	return arg0_24.state and arg0_24.state > var2_0
end

function var0_0.IsStop(arg0_25)
	return arg0_25.state and arg0_25.state == var5_0
end

function var0_0.OnSceneEnter(arg0_26, arg1_26)
	if not arg0_26:IsLoaded() then
		return
	end

	if not table.contains(arg0_26.sceneRecords, arg1_26.view) then
		table.insert(arg0_26.sceneRecords, arg1_26.view)
	end

	if arg0_26.player then
		arg0_26.player:OnSceneEnter()
	end
end

function var0_0.OnSceneExit(arg0_27, arg1_27)
	if not arg0_27:IsLoaded() then
		return
	end

	if table.contains(arg0_27.sceneRecords, arg1_27.view) then
		table.removebyvalue(arg0_27.sceneRecords, arg1_27.view)
	end
end

function var0_0.ExistScene(arg0_28, arg1_28)
	return table.contains(arg0_28.sceneRecords, arg1_28)
end

function var0_0.Exit(arg0_29)
	arg0_29:Clear()
	arg0_29.uiFinder:Clear()
	arg0_29.uiDuplicator:Clear()
	arg0_29.uiLoader:Clear()

	arg0_29.state = var7_0
end
