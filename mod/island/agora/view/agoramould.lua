local var0_0 = class("AgoraMould", import("Mod.Island.Core.View.SceneObject.IslandSceneUnit"))
local var1_0 = Vector3(-0.5, 0, -0.5)

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg3_1)

	arg0_1.callbacks = {}
	arg0_1.root = arg2_1.transform
	arg0_1.areaTr = arg2_1.transform:Find("area")
	arg0_1.areaMaterial = arg0_1.areaTr:GetComponent("MeshRenderer").material

	arg0_1:InitArea()
end

function var0_0.InitArea(arg0_2)
	local var0_2 = arg0_2.data:GetSize()

	arg0_2.areaTr.localScale = Vector3(var0_2.x, 0.01, var0_2.y)

	setActive(arg0_2.areaTr, false)
	arg0_2:UpdateAreaState(true)
end

function var0_0.ShowOrHideArea(arg0_3, arg1_3)
	setActive(arg0_3.areaTr, arg1_3)
end

function var0_0.UpdateAreaState(arg0_4, arg1_4)
	arg0_4.areaMaterial:SetColor("_Color", arg1_4 and Color.green or Color.red)
end

function var0_0.IsFullLoaded(arg0_5)
	return arg0_5:IsLoaded()
end

function var0_0.Init(arg0_6, arg1_6)
	arg0_6._go = arg1_6
	arg0_6.root.name = arg0_6.data.id

	arg0_6:UpdatePosition(arg0_6.data:GetArea())
	arg0_6:UpdateRotation(arg0_6.data:GetRotation())
	arg0_6:OnInit(arg1_6)
	arg0_6:AddListeners()

	arg0_6.behaviourTreeOwner = arg0_6.root:GetComponent(typeof(NodeCanvas.BehaviourTrees.BehaviourTreeOwner))

	var0_0.super.super.Init(arg0_6, arg1_6)
end

function var0_0.AddListeners(arg0_7)
	arg0_7:AddListener(ISLAND_AGORA_EVT.ITEM_POSITION_UPDATE, arg0_7.UpdatePosition)
	arg0_7:AddListener(ISLAND_AGORA_EVT.ITEM_DIR_UPDATE, arg0_7.UpdateRotation)
end

function var0_0.RemoveListeners(arg0_8)
	arg0_8:RemoveListener(ISLAND_AGORA_EVT.ITEM_POSITION_UPDATE, arg0_8.UpdatePosition)
	arg0_8:RemoveListener(ISLAND_AGORA_EVT.ITEM_DIR_UPDATE, arg0_8.UpdateRotation)
end

function var0_0.UpdatePosition(arg0_9, arg1_9)
	local var0_9 = AgoraCalc.GetAreaCenterPos(arg1_9)

	arg0_9.root.position = var0_9 + var1_0
end

function var0_0.UpdateRotation(arg0_10, arg1_10)
	arg0_10.root.eulerAngles = arg1_10
end

function var0_0.AddListener(arg0_11, arg1_11, arg2_11)
	local function var0_11(arg0_12, ...)
		arg2_11(arg0_11, ...)
	end

	arg0_11.callbacks[arg2_11] = var0_11

	arg0_11.data:AddListener(arg1_11, var0_11)
end

function var0_0.RemoveListener(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg0_13.callbacks[arg2_13]

	if var0_13 then
		arg0_13.data:RemoveListener(arg1_13, var0_13)

		arg0_13.callbacks[var0_13] = nil
	end
end

function var0_0.Enable(arg0_14)
	if not arg0_14:IsLoaded() then
		return
	end

	arg0_14:SetupBt()
end

function var0_0.Disable(arg0_15)
	if not arg0_15:IsLoaded() then
		return
	end

	arg0_15:PauseBt()
end

function var0_0.Dispose(arg0_16)
	var0_0.super.Dispose(arg0_16)
	arg0_16:RemoveListeners()

	arg0_16.callbacks = {}
end

function var0_0.OnDestroy(arg0_17)
	Object.Destroy(arg0_17.root.gameObject)

	arg0_17.root = nil
end

return var0_0
