local var0_0 = class("IslandCore", import("..IslandDispatcher"))

var0_0.STATE_LOAD = 1
var0_0.STATE_INIT = 2
var0_0.STATE_INIT_FINISH = 3
var0_0.STATE_DISPOSE = 4

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	var0_0.super.Ctor(arg0_1)

	arg0_1.poolMgr = arg1_1

	local var0_1, var1_1 = arg0_1:GetViewAndController(arg2_1, arg3_1)

	arg0_1.view = var0_1
	arg0_1.controller = var1_1
	arg0_1.sceneLoader = arg0_1:GetSceneLoader()

	arg0_1:UpdateState(var0_0.STATE_LOAD)

	local var2_1, var3_1, var4_1 = IslandDataConvertor.Island2SceneName(arg2_1)

	arg0_1.view:SetBgm(var4_1)
	arg0_1.sceneLoader:Load(var2_1, var3_1, {
		function(arg0_2)
			arg0_1:SetUp(arg0_2)
		end,
		function(arg0_3)
			onNextTick(arg0_3)
		end,
		function(arg0_4)
			arg0_1:Init(arg0_4)
		end,
		function(arg0_5)
			arg0_1:UpdateState(var0_0.STATE_INIT_FINISH)
			arg0_5()
		end
	})

	arg0_1.enterTime = pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.GetSceneLoader(arg0_6)
	return IslandSceneLoader.New()
end

function var0_0.GetPoolMgr(arg0_7)
	return arg0_7.poolMgr
end

function var0_0.UpdateState(arg0_8, arg1_8)
	arg0_8.state = arg1_8

	arg0_8.view:OnCoreStateChanged(arg1_8)
	arg0_8.controller:OnCoreStateChanged(arg1_8)
	pg.m02:sendNotification(GAME.ISLAND_CORE_STATE_CHANGED, arg1_8)
end

function var0_0.SetUp(arg0_9, arg1_9)
	arg0_9:UpdateState(var0_0.STATE_INIT)
	arg0_9.view:SetUp()
	arg0_9.controller:SetUp()

	if not arg0_9.handle then
		arg0_9.handle = UpdateBeat:CreateListener(arg0_9.Update, arg0_9)
	end

	UpdateBeat:AddListener(arg0_9.handle)

	if not arg0_9.lateUpdateluHandle then
		arg0_9.lateUpdateluHandle = LateUpdateBeat:CreateListener(arg0_9.LateUpdate, arg0_9)

		LateUpdateBeat:AddListener(arg0_9.lateUpdateluHandle)
	end

	arg0_9.callback = arg1_9

	arg0_9:OnInit()
end

function var0_0.Init(arg0_10, arg1_10)
	arg0_10.view:Enter()

	arg0_10.initCallback = arg1_10
end

function var0_0.GetMapId(arg0_11)
	return arg0_11:GetController():GetMapID()
end

function var0_0.IsInit(arg0_12)
	return arg0_12.state == var0_0.STATE_INIT or arg0_12.state == var0_0.STATE_INIT_FINISH
end

function var0_0.Update(arg0_13)
	if not arg0_13:IsInit() then
		return
	end

	arg0_13.controller:Update()
	arg0_13.view:Update()

	if arg0_13.callback and arg0_13.view:IsLoaded() then
		arg0_13.callback()

		arg0_13.callback = nil
	end

	if arg0_13.initCallback and arg0_13.view:IsInit() then
		arg0_13.initCallback()

		arg0_13.initCallback = nil
	end
end

function var0_0.LateUpdate(arg0_14)
	if not arg0_14:IsInit() then
		return
	end

	arg0_14.controller:LateUpdate()
	arg0_14.view:LateUpdate()
end

function var0_0.GetView(arg0_15)
	return arg0_15.view
end

function var0_0.GetController(arg0_16)
	return arg0_16.controller
end

function var0_0.Link(arg0_17, arg1_17, ...)
	arg0_17:GetController():NotifiyCore(arg1_17, ...)
end

function var0_0.Dispose(arg0_18, arg1_18)
	local var0_18 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_18.enterTime

	pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildMapExit(arg0_18.controller.mapId, var0_18))
	arg0_18:UpdateState(var0_0.STATE_DISPOSE)

	if arg0_18.handle then
		UpdateBeat:RemoveListener(arg0_18.handle)
	end

	if arg0_18.lateUpdateluHandle then
		LateUpdateBeat:RemoveListener(arg0_18.lateUpdateluHandle)
	end

	if IslandCameraMgr.instance and IslandCameraMgr.instance.gameObject then
		setActive(IslandCameraMgr.instance.gameObject, false)
	end

	if arg0_18.view then
		arg0_18.view:Dispose()

		arg0_18.view = nil
	end

	if arg0_18.controller then
		arg0_18.controller:Dispose()

		arg0_18.controller = nil
	end

	if arg0_18.sceneLoader then
		arg0_18.sceneLoader:Dispose(arg1_18)

		arg0_18.sceneLoader = nil
	end
end

function var0_0.OnInit(arg0_19)
	return
end

function var0_0.GetViewAndController(arg0_20, arg1_20, arg2_20)
	local var0_20
	local var1_20
	local var2_20 = arg1_20:GetMapId()
	local var3_20 = pg.island_map[var2_20]

	if var2_20 == IslandConst.AGORA_MAP_ID then
		var1_20 = AgoraController.New(arg0_20, arg1_20)

		local var4_20 = var1_20:GetAgora()

		var0_20 = AgoraView.New(arg0_20, var4_20, arg2_20)
	elseif var2_20 == IslandConst.CheaterTavernMapId then
		var1_20 = CheaterTavernController.New(arg0_20, arg1_20)
		var0_20 = IslandCheaterTavernGameView.New(arg0_20, arg2_20)
	elseif var3_20.minigame_id > 0 then
		var0_20 = IslandSeekGameView.New(arg0_20, arg2_20)
		var1_20 = IslandController.New(arg0_20, arg1_20)
	else
		var1_20 = IslandController.New(arg0_20, arg1_20)
		var0_20 = IslandView.New(arg0_20, arg2_20)
	end

	return var0_20, var1_20
end

return var0_0
