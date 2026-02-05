local var0_0 = class("IslandDisplayShipUnit")
local var1_0 = 2

function var0_0.OnAttach(arg0_1, arg1_1, arg2_1)
	arg0_1.toolContainer = arg2_1
	arg0_1._go = arg1_1
	arg0_1._tf = arg0_1._go.transform
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
end

function var0_0.LoadInteractiveTool(arg0_6, arg1_6)
	arg0_6.toolId = arg1_6

	local var0_6 = arg0_6.objTfList[arg0_6.toolId]

	if not IsNil(var0_6) then
		setActive(var0_6, true)
		setParent(var0_6, arg0_6._tf)
		pg.ViewUtils.SetLayer(var0_6, Layer.Character3D)

		return
	end

	local var1_6 = pg.island_animation_attachments[arg0_6.toolId]
	local var2_6 = LoadAny(var1_6.model, nil)
	local var3_6 = Object.Instantiate(var2_6)

	arg0_6.objTfList[arg0_6.toolId] = var3_6.transform

	local var4_6 = LoadAny(var1_6.animator, nil, typeof(RuntimeAnimatorController))

	GetOrAddComponent(arg0_6.objTfList[arg0_6.toolId], typeof(Animator)).runtimeAnimatorController = var4_6

	setParent(arg0_6.objTfList[arg0_6.toolId], arg0_6._tf)
	pg.ViewUtils.SetLayer(arg0_6.objTfList[arg0_6.toolId], Layer.Character3D)
end

function var0_0.UnLoadInteractiveTool(arg0_7)
	local var0_7 = arg0_7.objTfList[arg0_7.toolId]

	if var0_7 then
		setActive(var0_7, false)
		setParent(var0_7, arg0_7.toolContainer)
	end
end

function var0_0.StateEnterHandle(arg0_8, arg1_8, arg2_8)
	if arg1_8 == var1_0 then
		arg0_8:LoadInteractiveTool(arg2_8)
	end
end

function var0_0.StateEnterFixHandle(arg0_9, arg1_9, arg2_9)
	pg.ViewUtils.SetLayer(arg0_9.objTfList[arg0_9.toolId], Layer.Character3D)
end

function var0_0.StateExitFixHandle(arg0_10, arg1_10, arg2_10)
	pg.ViewUtils.SetLayer(arg0_10.objTfList[arg0_10.toolId], Layer.Default)
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
end

return var0_0
