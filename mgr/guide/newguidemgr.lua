pg = pg or {}
pg.NewGuideMgr = singletonClass("NewGuideMgr")

local var0 = pg.NewGuideMgr

var0.ENABLE_GUIDE = true

require("Mgr/Guide/Include")

local var1 = true
local var2 = 0
local var3 = 1
local var4 = 2
local var5 = 3
local var6 = 4
local var7 = 5

local function var8(...)
	if not var1 then
		return
	end

	print(...)
end

local function var9(arg0, arg1)
	arg0.players = {
		[GuideStep.TYPE_DOFUNC] = GuideDoFunctionPlayer.New(arg1),
		[GuideStep.TYPE_DONOTHING] = GuideDoNothingPlayer.New(arg1),
		[GuideStep.TYPE_FINDUI] = GuideFindUIPlayer.New(arg1),
		[GuideStep.TYPE_HIDEUI] = GuideHideUIPlayer.New(arg1),
		[GuideStep.TYPE_SENDNOTIFIES] = GuideSendNotifiesPlayer.New(arg1),
		[GuideStep.TYPE_SHOWSIGN] = GuideShowSignPlayer.New(arg1),
		[GuideStep.TYPE_STORY] = GuideStoryPlayer.New(arg1)
	}
end

local function var10(arg0)
	local var0 = require("GameCfg.guide.newguide.segments." .. arg0)

	return Guide.New(var0)
end

function var0.Init(arg0, arg1)
	arg0.sceneRecords = {}
	arg0.state = var2

	PoolMgr.GetInstance():GetUI("NewGuideUI", true, function(arg0)
		arg0._go = arg0
		arg0._tf = arg0._go.transform

		arg0._go:SetActive(false)
		arg0._go.transform:SetParent(pg.UIMgr.GetInstance().OverlayToast, false)

		arg0.uiFinder = GuideUIFinder.New(arg0._tf)
		arg0.uiDuplicator = GuideUIDuplicator.New(arg0._tf:Find("target"))
		arg0.uiLoader = GuideUILoader.New(arg0._tf:Find("target"))
		arg0.dialogueWindows = {
			[GuideStep.DIALOGUE_BLUE] = arg0._tf:Find("windows/window_1")
		}
		arg0.counsellors = {}
		arg0.state = var3
		arg0.uiLongPress = GetOrAddComponent(arg0._tf:Find("BG/close_btn"), typeof(UILongPressTrigger))
		arg0.uiLongPress.longPressThreshold = 10

		var9(arg0, arg0._tf)
		arg1()
	end)
end

function var0.PlayNothing(arg0)
	SetActive(arg0._go, true)
end

function var0.StopNothing(arg0)
	SetActive(arg0._go, false)
end

function var0.Play(arg0, arg1, arg2, arg3, arg4)
	if not arg0:CanPlay() then
		var8("can not play guide " .. arg1)
		arg3()

		return
	end

	var8("play guide : " .. arg1)

	local var0 = var10(arg1)

	arg0:PlayScript(var0, arg2, arg3, arg4)
end

function var0._Play(arg0, arg1, arg2, arg3, arg4)
	local var0 = Guide.New(arg1)

	arg0:PlayScript(var0, arg2, arg3, arg4)
end

function var0.PlayScript(arg0, arg1, arg2, arg3, arg4)
	if not arg1 then
		var8("should exist guide file ")
		arg3()

		return
	end

	arg0.OnFailed = arg4

	arg0:OnStart()

	local var0 = {}

	for iter0, iter1 in ipairs(arg1:GetStepsWithCode(arg2)) do
		table.insert(var0, function(arg0)
			if arg0:IsStop() then
				return
			end

			local var0 = arg0.players[iter1:GetType()]

			var0:Execute(iter1, arg0)

			arg0.player = var0
		end)
	end

	seriesAsync(var0, function()
		arg0:OnEnd(arg3)
	end)
end

function var0.CanPlay(arg0)
	if pg.MsgboxMgr.GetInstance()._go.activeSelf or pg.NewStoryMgr.GetInstance():IsRunning() or not var0.ENABLE_GUIDE or not arg0:IsLoaded() or arg0:IsPause() or arg0:IsBusy() then
		return false
	end

	return true
end

function var0.OnStart(arg0)
	pg.DelegateInfo.New(arg0)

	arg0.state = var4

	pg.m02:sendNotification(GAME.START_GUIDE)
	arg0._go.transform:SetAsLastSibling()
	arg0._go:SetActive(true)
	arg0.uiLongPress.onLongPressed:AddListener(function()
		arg0:Stop()
	end)
end

function var0.OnEnd(arg0, arg1)
	arg0.uiLongPress.onLongPressed:RemoveAllListeners()
	pg.DelegateInfo.Dispose(arg0)

	arg0.state = var3

	arg0:Clear()

	if arg1 then
		arg1()
	end
end

function var0.Pause(arg0)
	if arg0:IsBusy() then
		arg0.state = var6

		SetActive(arg0._go, false)
	end
end

function var0.Resume(arg0)
	if arg0:IsPause() then
		arg0.state = var4

		SetActive(arg0._go, true)
	end
end

function var0.Stop(arg0)
	if arg0.state ~= var5 then
		if arg0.OnFailed then
			arg0.OnFailed()
		end

		arg0.state = var5

		arg0.uiFinder:Clear()
		arg0.uiDuplicator:Clear()
		arg0.uiLoader:Clear()
		arg0:Clear()
	end
end

function var0.NextStep(arg0)
	if not IsUnityEditor then
		return
	end

	if arg0.state == var4 and arg0.player then
		arg0.player:NextOne()
	end
end

function var0.Clear(arg0)
	arg0.OnFailed = nil
	arg0.sceneRecords = {}

	arg0._go:SetActive(false)

	for iter0, iter1 in ipairs(arg0.players) do
		iter1:Clear()
	end

	if arg0.player then
		arg0.player = nil
	end

	pg.m02:sendNotification(GAME.END_GUIDE)
end

function var0.IsPause(arg0)
	return arg0.state and arg0.state == var6
end

function var0.IsBusy(arg0)
	return arg0.state and arg0.state == var4
end

function var0.IsLoaded(arg0)
	return arg0.state and arg0.state > var2
end

function var0.IsStop(arg0)
	return arg0.state and arg0.state == var5
end

function var0.OnSceneEnter(arg0, arg1)
	if not arg0:IsLoaded() then
		return
	end

	if not table.contains(arg0.sceneRecords, arg1.view) then
		table.insert(arg0.sceneRecords, arg1.view)
	end

	if arg0.player then
		arg0.player:OnSceneEnter()
	end
end

function var0.OnSceneExit(arg0, arg1)
	if not arg0:IsLoaded() then
		return
	end

	if table.contains(arg0.sceneRecords, arg1.view) then
		table.removebyvalue(arg0.sceneRecords, arg1.view)
	end
end

function var0.ExistScene(arg0, arg1)
	return table.contains(arg0.sceneRecords, arg1)
end

function var0.Exit(arg0)
	arg0:Clear()
	arg0.uiFinder:Clear()
	arg0.uiDuplicator:Clear()
	arg0.uiLoader:Clear()

	arg0.state = var7
end
