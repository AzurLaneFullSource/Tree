local var0_0 = class("IslandSceneUnit", import("..IslandBaseUnit"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1)
	assert(arg2_1.id)

	arg0_1.id = arg2_1.id
	arg0_1.modelId = arg2_1.modelId or 0
	arg0_1.name = arg2_1.name or ""
	arg0_1.position = arg2_1.position or Vector3.zero
	arg0_1.rotation = arg2_1.rotation or Vector3.zero
	arg0_1.data = arg2_1
	arg0_1.active = true
end

function var0_0.ResetPosition(arg0_2)
	arg0_2._go.transform.position = arg0_2.position
	arg0_2._go.transform.eulerAngles = arg0_2.rotation
end

function var0_0.Init(arg0_3, arg1_3)
	arg0_3._go = arg1_3
	arg0_3._go.name = arg0_3.name
	arg0_3._go.transform.position = arg0_3.position
	arg0_3._go.transform.eulerAngles = arg0_3.rotation
	arg0_3.behaviourTreeOwner = arg0_3._go:GetComponent(typeof(NodeCanvas.BehaviourTrees.BehaviourTreeOwner))

	var0_0.super.Init(arg0_3, arg1_3)

	if arg0_3:GetView():IsInit() then
		arg0_3:Start()
	end
end

function var0_0.Start(arg0_4)
	arg0_4:SetupBt()
	arg0_4:OnStart()
end

function var0_0.Dispose(arg0_5)
	arg0_5:ClearBt()
	var0_0.super.Dispose(arg0_5)
	Object.Destroy(arg0_5._go)

	arg0_5._go = nil
end

function var0_0.SetupBt(arg0_6)
	if not arg0_6.behaviourTreeOwner then
		return
	end

	arg0_6.behaviourTreeOwner.graph.blackboard:AddVariable("id", arg0_6.id)
	arg0_6.behaviourTreeOwner.graph.blackboard:AddVariable("_player", arg0_6.view.player._go)
	arg0_6.behaviourTreeOwner:StartBehaviour()
end

function var0_0.RestartBt(arg0_7)
	if not arg0_7.behaviourTreeOwner then
		return
	end

	arg0_7.behaviourTreeOwner:RestartBehaviour()
end

function var0_0.PauseBt(arg0_8)
	if not arg0_8.behaviourTreeOwner then
		return
	end

	arg0_8.behaviourTreeOwner:PauseBehaviour()
end

function var0_0.StopBt(arg0_9)
	if not arg0_9.behaviourTreeOwner then
		return
	end

	arg0_9.behaviourTreeOwner:StopBehaviour()
end

function var0_0.ClearBt(arg0_10)
	arg0_10:StopBt()

	arg0_10.behaviourTreeOwner = nil
end

function var0_0.Enable(arg0_11)
	if not arg0_11:IsLoaded() then
		return
	end

	setActive(arg0_11._go, true)

	arg0_11.active = true
end

function var0_0.Disable(arg0_12)
	if not arg0_12:IsLoaded() then
		return
	end

	setActive(arg0_12._go, false)

	arg0_12.active = false
end

function var0_0.Update(arg0_13)
	if not arg0_13.active then
		return
	end

	var0_0.super.Update(arg0_13)
end

function var0_0.OnStart(arg0_14)
	return
end

return var0_0
