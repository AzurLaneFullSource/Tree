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

function var0_0.IsSelf(arg0_2, arg1_2)
	return arg0_2:GetUnitType() == arg1_2:GetUnitType() and arg0_2.id == arg1_2.id
end

function var0_0.GetDataVO(arg0_3)
	return arg0_3.data
end

function var0_0.ResetPosition(arg0_4)
	arg0_4._go.transform.position = arg0_4.position
	arg0_4._go.transform.eulerAngles = arg0_4.rotation
end

function var0_0.GetPosition(arg0_5)
	return arg0_5._go.transform.position
end

function var0_0.OnInit(arg0_6, arg1_6, arg2_6)
	arg0_6._go = arg1_6
	arg0_6.builder = arg2_6

	assert(arg0_6.builder and arg0_6._go)
	SetParent(arg0_6._go, arg0_6:GetView().root)

	arg0_6._go.name = arg0_6.name
	arg0_6.behaviourTreeOwner = arg0_6._go:GetComponent(typeof(NodeCanvas.BehaviourTrees.BehaviourTreeOwner))

	arg0_6:OnAttach(arg1_6)
	arg0_6:ResetPosition()
	arg0_6:OnLaterAttach(arg1_6)
	arg0_6:ResetPosition()

	if arg0_6:GetView():IsInit() then
		arg0_6:Start()
	end
end

function var0_0.OnAnomalyInit(arg0_7, arg1_7, arg2_7)
	arg2_7:Recycle(arg0_7.data, arg1_7)
end

function var0_0.SetUnitType(arg0_8, arg1_8)
	arg0_8.unitType = arg1_8
end

function var0_0.GetUnitType(arg0_9)
	return arg0_9.unitType
end

function var0_0.Start(arg0_10)
	arg0_10:SetupBt()
	arg0_10:OnStart()
end

function var0_0.OnDispose(arg0_11)
	arg0_11:OnDetach()
	arg0_11:ClearBt()
	arg0_11.builder:Recycle(arg0_11.data, arg0_11._go)

	arg0_11._go = nil
end

function var0_0.Dispose(arg0_12)
	var0_0.super.Dispose(arg0_12)

	arg0_12.builder = nil
end

function var0_0.SetupBt(arg0_13)
	if not arg0_13.behaviourTreeOwner then
		return
	end

	arg0_13.behaviourTreeOwner:StartBehaviour()
end

function var0_0.RestartBt(arg0_14)
	if not arg0_14.behaviourTreeOwner then
		return
	end

	arg0_14.behaviourTreeOwner:RestartBehaviour()
end

function var0_0.PauseBt(arg0_15)
	if not arg0_15.behaviourTreeOwner then
		return
	end

	arg0_15.behaviourTreeOwner:PauseBehaviour()
end

function var0_0.StopBt(arg0_16)
	if not arg0_16.behaviourTreeOwner then
		return
	end

	arg0_16.behaviourTreeOwner:StopBehaviour()
end

function var0_0.ClearBt(arg0_17)
	arg0_17:StopBt()

	arg0_17.behaviourTreeOwner = nil
end

function var0_0.Enable(arg0_18)
	if not arg0_18:IsLoaded() then
		return
	end

	setActive(arg0_18._go, true)
	arg0_18:ActiveOrDisactive(true)
end

function var0_0.Disable(arg0_19)
	if not arg0_19:IsLoaded() then
		return
	end

	setActive(arg0_19._go, false)
	arg0_19:ActiveOrDisactive(false)
end

function var0_0.ActiveOrDisactive(arg0_20, arg1_20)
	arg0_20.active = arg1_20
end

function var0_0.Update(arg0_21)
	if not arg0_21.active then
		return
	end

	var0_0.super.Update(arg0_21)
end

function var0_0.IsActive(arg0_22)
	return arg0_22.active
end

function var0_0.OnAttach(arg0_23, arg1_23)
	return
end

function var0_0.OnLaterAttach(arg0_24, arg1_24)
	return
end

function var0_0.OnStart(arg0_25)
	return
end

function var0_0.OnDetach(arg0_26)
	return
end

return var0_0
