local var0_0 = class("IslandDisplayShipUnit")
local var1_0 = 2

function var0_0.OnAttach(arg0_1, arg1_1, arg2_1)
	arg0_1.toolContainer = arg2_1
	arg0_1._go = arg1_1
	arg0_1._tf = arg0_1._go.transform
	arg0_1.animator = arg0_1._tf:GetChild(0):GetComponent(typeof(Animator))
	arg0_1.characterHandleController = GetOrAddComponent(arg0_1._go, typeof(CharacterHandleController))

	arg0_1.characterHandleController:AddStateEnterFunc(function(arg0_2, arg1_2)
		arg0_1:StateEnterHandle(arg0_2, arg1_2)
	end)
	arg0_1.characterHandleController:AddStateExitFunc(function(arg0_3, arg1_3)
		arg0_1:StateExitHandle(arg0_3, arg1_3)
	end)
	arg0_1.characterHandleController:AddStateEnterFixCompleteFunc(function(arg0_4, arg1_4)
		arg0_1:StateEnterFixHandle(arg0_4, arg1_4)
	end)
	arg0_1.characterHandleController:AddStateExitFixCompleteFunc(function(arg0_5, arg1_5)
		arg0_1:StateExitFixHandle(arg0_5, arg1_5)
	end)

	arg0_1.objTfList = {}
	arg0_1.toolIdMap = {}
end

function var0_0.LoadInteractiveTool(arg0_6, arg1_6)
	arg0_6.toolId = arg1_6
	arg0_6.currentToolId = IslandAnimationAttachmentHelper.ResolveId(arg0_6.animator, arg0_6.toolId)
	arg0_6.toolIdMap[arg1_6] = arg0_6.currentToolId

	local var0_6 = arg0_6.objTfList[arg0_6.currentToolId]

	if not IsNil(var0_6) then
		setActive(var0_6, true)
		setParent(var0_6, arg0_6._tf)
		pg.ViewUtils.SetLayer(var0_6, Layer.Character3D)

		return
	end

	local var1_6 = pg.island_animation_attachments[arg0_6.currentToolId]
	local var2_6 = LoadAny(var1_6.model, nil)
	local var3_6 = Object.Instantiate(var2_6)

	arg0_6.objTfList[arg0_6.currentToolId] = var3_6.transform

	local var4_6 = LoadAny(var1_6.animator, nil, typeof(RuntimeAnimatorController))

	GetOrAddComponent(arg0_6.objTfList[arg0_6.currentToolId], typeof(Animator)).runtimeAnimatorController = var4_6

	setParent(arg0_6.objTfList[arg0_6.currentToolId], arg0_6._tf)
	pg.ViewUtils.SetLayer(arg0_6.objTfList[arg0_6.currentToolId], Layer.Character3D)
end

function var0_0.UnLoadInteractiveTool(arg0_7, arg1_7)
	local var0_7 = arg0_7.toolIdMap[arg1_7] or arg0_7.currentToolId or IslandAnimationAttachmentHelper.ResolveId(arg0_7.animator, arg1_7)
	local var1_7 = arg0_7.objTfList[var0_7]

	if var1_7 then
		setActive(var1_7, false)
		setParent(var1_7, arg0_7.toolContainer)
	end
end

function var0_0.StateEnterHandle(arg0_8, arg1_8, arg2_8)
	if arg1_8 == var1_0 then
		arg0_8:LoadInteractiveTool(arg2_8)
	end
end

function var0_0.StateEnterFixHandle(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg0_9.toolIdMap[arg2_9] or arg0_9.currentToolId

	if arg1_9 == var1_0 and var0_9 and arg0_9.objTfList[var0_9] then
		pg.ViewUtils.SetLayer(arg0_9.objTfList[var0_9], Layer.Character3D)
	end
end

function var0_0.StateExitFixHandle(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg0_10.toolIdMap[arg2_10] or arg0_10.currentToolId

	if arg1_10 == var1_0 and var0_10 and arg0_10.objTfList[var0_10] then
		pg.ViewUtils.SetLayer(arg0_10.objTfList[var0_10], Layer.Default)
	end
end

function var0_0.StateExitHandle(arg0_11, arg1_11, arg2_11)
	if arg1_11 == var1_0 then
		arg0_11:UnLoadInteractiveTool(arg2_11)
	end
end

function var0_0.OnClearItemAnimator(arg0_12)
	if arg0_12.toolId then
		arg0_12:UnLoadInteractiveTool(arg0_12.toolId)
	end
end

function var0_0.ClearAnimationTools(arg0_13)
	for iter0_13, iter1_13 in pairs(arg0_13.objTfList or {}) do
		Object.Destroy(iter1_13.gameObject)
	end

	arg0_13.objTfList = {}
end

function var0_0.OnDetach(arg0_14)
	arg0_14:ClearAnimationTools()
	arg0_14.characterHandleController:AddStateEnterFunc(nil)
	arg0_14.characterHandleController:AddStateExitFunc(nil)
	arg0_14.characterHandleController:AddStateEnterFixCompleteFunc(nil)
	arg0_14.characterHandleController:AddStateExitFixCompleteFunc(nil)

	arg0_14._go = nil
	arg0_14._tf = nil
	arg0_14.objTfList = nil
	arg0_14.characterHandleController = nil
end

return var0_0
