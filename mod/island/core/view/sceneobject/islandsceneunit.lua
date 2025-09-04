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
	arg0_1.unitType = nil
end

function var0_0.GetDataVO(arg0_2)
	return arg0_2.data
end

function var0_0.ResetPosition(arg0_3)
	arg0_3._go.transform.position = arg0_3.position
	arg0_3._go.transform.eulerAngles = arg0_3.rotation
end

function var0_0.OnInit(arg0_4, arg1_4, arg2_4)
	arg0_4._go = arg1_4
	arg0_4.builder = arg2_4

	assert(arg0_4.builder and arg0_4._go)
	SetParent(arg0_4._go, arg0_4:GetView().root)

	arg0_4._go.name = arg0_4.name
	arg0_4.behaviourTreeOwner = arg0_4._go:GetComponent(typeof(NodeCanvas.BehaviourTrees.BehaviourTreeOwner))

	arg0_4:OnAttach(arg1_4)

	arg0_4._go.transform.position = arg0_4.position
	arg0_4._go.transform.eulerAngles = arg0_4.rotation

	arg0_4:OnLaterAttach(arg1_4)

	arg0_4._go.transform.position = arg0_4.position
	arg0_4._go.transform.eulerAngles = arg0_4.rotation

	if arg0_4:GetView():IsInit() then
		arg0_4:Start()
	end
end

function var0_0.OnAnomalyInit(arg0_5, arg1_5, arg2_5)
	arg2_5:Recycle(arg0_5.data, arg1_5)
end

function var0_0.SetUnitType(arg0_6, arg1_6)
	arg0_6.unitType = arg1_6
end

function var0_0.GetUnitType(arg0_7)
	return arg0_7.unitType
end

function var0_0.Start(arg0_8)
	arg0_8:SetupBt()
	arg0_8:OnStart()
end

function var0_0.OnDispose(arg0_9)
	arg0_9:OnDetach()
	arg0_9:ClearBt()
	arg0_9.builder:Recycle(arg0_9.data, arg0_9._go)

	arg0_9._go = nil
end

function var0_0.Dispose(arg0_10)
	var0_0.super.Dispose(arg0_10)

	arg0_10.builder = nil
end

function var0_0.SetupBt(arg0_11)
	if not arg0_11.behaviourTreeOwner then
		return
	end

	arg0_11.behaviourTreeOwner:StartBehaviour()
end

function var0_0.RestartBt(arg0_12)
	if not arg0_12.behaviourTreeOwner then
		return
	end

	arg0_12.behaviourTreeOwner:RestartBehaviour()
end

function var0_0.PauseBt(arg0_13)
	if not arg0_13.behaviourTreeOwner then
		return
	end

	arg0_13.behaviourTreeOwner:PauseBehaviour()
end

function var0_0.StopBt(arg0_14)
	if not arg0_14.behaviourTreeOwner then
		return
	end

	arg0_14.behaviourTreeOwner:StopBehaviour()
end

function var0_0.ClearBt(arg0_15)
	arg0_15:StopBt()

	arg0_15.behaviourTreeOwner = nil
end

function var0_0.Enable(arg0_16)
	if not arg0_16:IsLoaded() then
		return
	end

	setActive(arg0_16._go, true)
	arg0_16:ActiveOrDisactive(true)
end

function var0_0.Disable(arg0_17)
	if not arg0_17:IsLoaded() then
		return
	end

	setActive(arg0_17._go, false)
	arg0_17:ActiveOrDisactive(false)
end

function var0_0.ActiveOrDisactive(arg0_18, arg1_18)
	arg0_18.active = arg1_18
end

function var0_0.Update(arg0_19)
	if not arg0_19.active then
		return
	end

	var0_0.super.Update(arg0_19)
end

function var0_0.OnAttach(arg0_20, arg1_20)
	return
end

function var0_0.OnLaterAttach(arg0_21, arg1_21)
	return
end

function var0_0.OnStart(arg0_22)
	return
end

function var0_0.OnDetach(arg0_23)
	return
end

return var0_0
