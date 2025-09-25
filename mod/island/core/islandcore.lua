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
			arg0_1:Init(arg0_2)
		end
	})

	arg0_1.enterTime = pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.GetPoolMgr(arg0_3)
	return arg0_3.poolMgr
end

function var0_0.UpdateState(arg0_4, arg1_4)
	arg0_4.state = arg1_4

	arg0_4.view:OnCoreStateChanged(arg1_4)
	arg0_4.controller:OnCoreStateChanged(arg1_4)
end

function var0_0.Init(arg0_5, arg1_5)
	arg0_5:UpdateState(var0_0.STATE_INIT)
	arg0_5.view:SetUp()
	arg0_5.controller:SetUp()

	if not arg0_5.handle then
		arg0_5.handle = UpdateBeat:CreateListener(arg0_5.Update, arg0_5)
	end

	UpdateBeat:AddListener(arg0_5.handle)

	if not arg0_5.lateUpdateluHandle then
		arg0_5.lateUpdateluHandle = LateUpdateBeat:CreateListener(arg0_5.LateUpdate, arg0_5)

		LateUpdateBeat:AddListener(arg0_5.lateUpdateluHandle)
	end

	function arg0_5.callback()
		arg1_5()
		arg0_5:UpdateState(var0_0.STATE_INIT_FINISH)
	end
end

function var0_0.GetMapId(arg0_7)
	return arg0_7:GetController():GetMapID()
end

function var0_0.IsInit(arg0_8)
	return arg0_8.state == var0_0.STATE_INIT or arg0_8.state == var0_0.STATE_INIT_FINISH
end

function var0_0.Update(arg0_9)
	if not arg0_9:IsInit() then
		return
	end

	arg0_9.controller:Update()
	arg0_9.view:Update()

	if arg0_9.callback and arg0_9.view:IsLoaded() then
		arg0_9.callback()

		arg0_9.callback = nil
	end
end

function var0_0.LateUpdate(arg0_10)
	if not arg0_10:IsInit() then
		return
	end

	arg0_10.controller:LateUpdate()
	arg0_10.view:LateUpdate()
end

function var0_0.GetView(arg0_11)
	return arg0_11.view
end

function var0_0.GetController(arg0_12)
	return arg0_12.controller
end

function var0_0.Link(arg0_13, arg1_13, ...)
	arg0_13:GetController():NotifiyCore(arg1_13, ...)
end

function var0_0.Dispose(arg0_14, arg1_14)
	local var0_14 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_14.enterTime

	pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildMapExit(arg0_14.controller.mapId, var0_14))
	arg0_14:UpdateState(var0_0.STATE_DISPOSE)

	if arg0_14.handle then
		UpdateBeat:RemoveListener(arg0_14.handle)
	end

	if arg0_14.lateUpdateluHandle then
		LateUpdateBeat:RemoveListener(arg0_14.lateUpdateluHandle)
	end

	setActive(IslandCameraMgr.instance.gameObject, false)

	if arg0_14.view then
		arg0_14.view:Dispose()

		arg0_14.view = nil
	end

	if arg0_14.controller then
		arg0_14.controller:Dispose()

		arg0_14.controller = nil
	end

	if arg0_14.sceneLoader then
		arg0_14.sceneLoader:Dispose(arg1_14)

		arg0_14.sceneLoader = nil
	end
end

function var0_0.GetViewAndController(arg0_15, arg1_15, arg2_15)
	local var0_15
	local var1_15
	local var2_15 = arg1_15:GetMapId()
	local var3_15 = pg.island_map[var2_15]

	if var2_15 == IslandConst.AGORA_MAP_ID then
		var1_15 = AgoraController.New(arg0_15, arg1_15)

		local var4_15 = var1_15:GetAgora()

		var0_15 = AgoraView.New(arg0_15, var4_15, arg2_15)
	elseif var3_15.minigame_id > 0 then
		var0_15 = IslandSeekGameView.New(arg0_15, arg2_15)
		var1_15 = IslandController.New(arg0_15, arg1_15)
	else
		var1_15 = IslandController.New(arg0_15, arg1_15)
		var0_15 = IslandView.New(arg0_15, arg2_15)
	end

	return var0_15, var1_15
end

return var0_0
