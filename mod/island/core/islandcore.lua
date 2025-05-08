local var0_0 = class("IslandCore", import("..IslandDispatcher"))

var0_0.STATE_LOAD = 1
var0_0.STATE_INIT = 2
var0_0.STATE_INIT_FINISH = 3
var0_0.STATE_DISPOSE = 4

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1)

	local var0_1, var1_1 = arg0_1:GetViewAndController(arg1_1)

	arg0_1.view = var0_1
	arg0_1.controller = var1_1
	arg0_1.sceneLoader = (arg2_1 and IslandSceneSwitcher or IslandSceneLoader).New()

	arg0_1:UpdateState(var0_0.STATE_LOAD)

	local var2_1 = IslandDataConvertor.Island2SceneName(arg1_1)

	arg0_1.sceneLoader:Load(var2_1, function(arg0_2)
		arg0_1:Init(arg0_2)
	end)
end

function var0_0.UpdateState(arg0_3, arg1_3)
	arg0_3.state = arg1_3

	arg0_3.view:OnCoreStateChanged(arg1_3)
	arg0_3.controller:OnCoreStateChanged(arg1_3)
end

function var0_0.Init(arg0_4, arg1_4)
	arg0_4:UpdateState(var0_0.STATE_INIT)
	arg0_4.view:SetUp()
	arg0_4.controller:SetUp()

	if not arg0_4.handle then
		arg0_4.handle = UpdateBeat:CreateListener(arg0_4.Update, arg0_4)
	end

	UpdateBeat:AddListener(arg0_4.handle)

	if not arg0_4.lateUpdateluHandle then
		arg0_4.lateUpdateluHandle = LateUpdateBeat:CreateListener(arg0_4.LateUpdate, arg0_4)

		LateUpdateBeat:AddListener(arg0_4.lateUpdateluHandle)
	end

	function arg0_4.callback()
		arg1_4()
		arg0_4:UpdateState(var0_0.STATE_INIT_FINISH)
	end
end

function var0_0.GetMapId(arg0_6)
	return arg0_6:GetController():GetMapID()
end

function var0_0.IsInit(arg0_7)
	return arg0_7.state == var0_0.STATE_INIT or arg0_7.state == var0_0.STATE_INIT_FINISH
end

function var0_0.Update(arg0_8)
	if not arg0_8:IsInit() then
		return
	end

	arg0_8.controller:Update()
	arg0_8.view:Update()

	if arg0_8.callback and arg0_8.view:IsLoaded() then
		arg0_8.callback()

		arg0_8.callback = nil
	end
end

function var0_0.LateUpdate(arg0_9)
	if not arg0_9:IsInit() then
		return
	end

	arg0_9.controller:LateUpdate()
	arg0_9.view:LateUpdate()
end

function var0_0.GetView(arg0_10)
	return arg0_10.view
end

function var0_0.GetController(arg0_11)
	return arg0_11.controller
end

function var0_0.Link(arg0_12, arg1_12, ...)
	arg0_12:GetController():NotifiyCore(arg1_12, ...)
end

function var0_0.Dispose(arg0_13, arg1_13)
	arg0_13:UpdateState(var0_0.STATE_DISPOSE)

	if arg0_13.handle then
		UpdateBeat:RemoveListener(arg0_13.handle)
	end

	if arg0_13.lateUpdateluHandle then
		LateUpdateBeat:RemoveListener(arg0_13.lateUpdateluHandle)
	end

	if arg0_13.controller then
		arg0_13.controller:Dispose()

		arg0_13.controller = nil
	end

	if arg0_13.view then
		arg0_13.view:Dispose()

		arg0_13.view = nil
	end

	if arg0_13.sceneLoader then
		arg0_13.sceneLoader:Dispose(arg1_13)

		arg0_13.sceneLoader = nil
	end
end

function var0_0.GetViewAndController(arg0_14, arg1_14)
	local var0_14
	local var1_14
	local var2_14 = arg1_14:GetMapId()

	if var2_14 == IslandConst.AGORA_MAP_ID then
		var1_14 = AgoraController.New(arg0_14, arg1_14)

		local var3_14 = var1_14:GetAgora()

		var0_14 = AgoraView.New(arg0_14, var3_14)
	elseif var2_14 == IslandConst.SEEK_GAME_MAP_ID then
		var0_14 = IslandSeekGameView.New(arg0_14)
		var1_14 = IslandController.New(arg0_14, arg1_14)
	else
		var1_14 = IslandController.New(arg0_14, arg1_14)
		var0_14 = IslandView.New(arg0_14)
	end

	return var0_14, var1_14
end

return var0_0
