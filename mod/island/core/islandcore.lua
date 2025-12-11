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
	arg0_1.sceneLoader = IslandSceneLoader.New()

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

function var0_0.GetPoolMgr(arg0_6)
	return arg0_6.poolMgr
end

function var0_0.UpdateState(arg0_7, arg1_7)
	arg0_7.state = arg1_7

	arg0_7.view:OnCoreStateChanged(arg1_7)
	arg0_7.controller:OnCoreStateChanged(arg1_7)
	pg.m02:sendNotification(GAME.ISLAND_CORE_STATE_CHANGED, arg1_7)
end

function var0_0.SetUp(arg0_8, arg1_8)
	arg0_8:UpdateState(var0_0.STATE_INIT)
	arg0_8.view:SetUp()
	arg0_8.controller:SetUp()

	if not arg0_8.handle then
		arg0_8.handle = UpdateBeat:CreateListener(arg0_8.Update, arg0_8)
	end

	UpdateBeat:AddListener(arg0_8.handle)

	if not arg0_8.lateUpdateluHandle then
		arg0_8.lateUpdateluHandle = LateUpdateBeat:CreateListener(arg0_8.LateUpdate, arg0_8)

		LateUpdateBeat:AddListener(arg0_8.lateUpdateluHandle)
	end

	arg0_8.callback = arg1_8
end

function var0_0.Init(arg0_9, arg1_9)
	arg0_9.view:Enter()

	arg0_9.initCallback = arg1_9
end

function var0_0.GetMapId(arg0_10)
	return arg0_10:GetController():GetMapID()
end

function var0_0.IsInit(arg0_11)
	return arg0_11.state == var0_0.STATE_INIT or arg0_11.state == var0_0.STATE_INIT_FINISH
end

function var0_0.Update(arg0_12)
	if not arg0_12:IsInit() then
		return
	end

	arg0_12.controller:Update()
	arg0_12.view:Update()

	if arg0_12.callback and arg0_12.view:IsLoaded() then
		arg0_12.callback()

		arg0_12.callback = nil
	end

	if arg0_12.initCallback and arg0_12.view:IsInit() then
		arg0_12.initCallback()

		arg0_12.initCallback = nil
	end
end

function var0_0.LateUpdate(arg0_13)
	if not arg0_13:IsInit() then
		return
	end

	arg0_13.controller:LateUpdate()
	arg0_13.view:LateUpdate()
end

function var0_0.GetView(arg0_14)
	return arg0_14.view
end

function var0_0.GetController(arg0_15)
	return arg0_15.controller
end

function var0_0.Link(arg0_16, arg1_16, ...)
	arg0_16:GetController():NotifiyCore(arg1_16, ...)
end

function var0_0.Dispose(arg0_17, arg1_17)
	local var0_17 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_17.enterTime

	pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildMapExit(arg0_17.controller.mapId, var0_17))
	arg0_17:UpdateState(var0_0.STATE_DISPOSE)

	if arg0_17.handle then
		UpdateBeat:RemoveListener(arg0_17.handle)
	end

	if arg0_17.lateUpdateluHandle then
		LateUpdateBeat:RemoveListener(arg0_17.lateUpdateluHandle)
	end

	setActive(IslandCameraMgr.instance.gameObject, false)

	if arg0_17.view then
		arg0_17.view:Dispose()

		arg0_17.view = nil
	end

	if arg0_17.controller then
		arg0_17.controller:Dispose()

		arg0_17.controller = nil
	end

	if arg0_17.sceneLoader then
		arg0_17.sceneLoader:Dispose(arg1_17)

		arg0_17.sceneLoader = nil
	end
end

function var0_0.GetViewAndController(arg0_18, arg1_18, arg2_18)
	local var0_18
	local var1_18
	local var2_18 = arg1_18:GetMapId()
	local var3_18 = pg.island_map[var2_18]

	if var2_18 == IslandConst.AGORA_MAP_ID then
		var1_18 = AgoraController.New(arg0_18, arg1_18)

		local var4_18 = var1_18:GetAgora()

		var0_18 = AgoraView.New(arg0_18, var4_18, arg2_18)
	elseif var3_18.minigame_id > 0 then
		var0_18 = IslandSeekGameView.New(arg0_18, arg2_18)
		var1_18 = IslandController.New(arg0_18, arg1_18)
	else
		var1_18 = IslandController.New(arg0_18, arg1_18)
		var0_18 = IslandView.New(arg0_18, arg2_18)
	end

	return var0_18, var1_18
end

return var0_0
