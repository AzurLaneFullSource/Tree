local var0_0 = class("AgoraMould", import("Mod.Island.Core.View.SceneObject.IslandInteractUnit"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg3_1)

	arg0_1.callbacks = {}
	arg0_1.root = arg2_1.transform
	arg0_1.selected = arg2_1.transform:Find("selected")
	arg0_1.conflict = arg2_1.transform:Find("conflict")

	arg0_1:InitArea()
end

function var0_0.InitArea(arg0_2)
	local var0_2 = arg0_2.data:GetSize()

	arg0_2.selected.localScale = Vector3(var0_2.x, 0.01, var0_2.y)
	arg0_2.conflict.localScale = Vector3(var0_2.x, 0.01, var0_2.y)

	arg0_2:ShowOrHideArea(false)
end

function var0_0.ShowOrHideArea(arg0_3, arg1_3, arg2_3)
	if arg2_3 then
		setActive(arg0_3.conflict, arg1_3)
		setActive(arg0_3.selected, not arg1_3)
	else
		setActive(arg0_3.conflict, false)
		setActive(arg0_3.selected, false)
	end
end

function var0_0.IsFullLoaded(arg0_4)
	return arg0_4:IsLoaded()
end

function var0_0.OnInit(arg0_5, arg1_5, arg2_5)
	arg0_5._go = arg1_5
	arg0_5.builder = arg2_5
	arg0_5.root.name = arg0_5.data.id

	setParent(arg0_5._go, arg0_5.root)
	arg0_5:UpdatePosition(arg0_5.data:GetArea())
	arg0_5:UpdateRotation(arg0_5.data:GetRotation())
	arg0_5:AddListeners()

	arg0_5.behaviourTreeOwner = arg0_5.root:GetComponent(typeof(NodeCanvas.BehaviourTrees.BehaviourTreeOwner))

	arg0_5:OnAttach(arg0_5.root)
end

function var0_0.AddListeners(arg0_6)
	arg0_6:AddListener(ISLAND_AGORA_EVT.ITEM_POSITION_UPDATE, arg0_6.UpdatePosition)
	arg0_6:AddListener(ISLAND_AGORA_EVT.ITEM_DIR_UPDATE, arg0_6.UpdateRotation)
end

function var0_0.RemoveListeners(arg0_7)
	arg0_7:RemoveListener(ISLAND_AGORA_EVT.ITEM_POSITION_UPDATE, arg0_7.UpdatePosition)
	arg0_7:RemoveListener(ISLAND_AGORA_EVT.ITEM_DIR_UPDATE, arg0_7.UpdateRotation)
end

function var0_0.UpdatePosition(arg0_8, arg1_8)
	local var0_8 = AgoraCalc.GetAreaCenterPos(arg1_8)
	local var1_8 = Vector3(0, 0, 0)

	if arg0_8.data:IsBuildingType() then
		var1_8 = IslandConst.AGORA_BUILDING_Y_OFFSET
	end

	arg0_8.root.position = var0_8 + IslandConst.AGORA_POSITION_OFFSET + var1_8
end

function var0_0.UpdateRotation(arg0_9, arg1_9)
	arg0_9.root.eulerAngles = arg1_9
end

function var0_0.AddListener(arg0_10, arg1_10, arg2_10)
	local function var0_10(arg0_11, ...)
		arg2_10(arg0_10, ...)
	end

	arg0_10.callbacks[arg2_10] = var0_10

	arg0_10.data:AddListener(arg1_10, var0_10)
end

function var0_0.RemoveListener(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg0_12.callbacks[arg2_12]

	if var0_12 then
		arg0_12.data:RemoveListener(arg1_12, var0_12)

		arg0_12.callbacks[var0_12] = nil
	end
end

function var0_0.Enable(arg0_13)
	if not arg0_13:IsLoaded() then
		return
	end

	arg0_13:SetupBt()
end

function var0_0.Disable(arg0_14)
	if not arg0_14:IsLoaded() then
		return
	end

	arg0_14:PauseBt()
end

function var0_0.Dispose(arg0_15)
	arg0_15:RemoveListeners()

	arg0_15.callbacks = {}

	var0_0.super.Dispose(arg0_15)
end

function var0_0.OnDestroy(arg0_16)
	arg0_16.builder:RecycleRoot(arg0_16.root.gameObject)

	arg0_16.root = nil
end

return var0_0
