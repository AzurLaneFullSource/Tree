local var0_0 = class("IslandNpcUnit", import(".IslandNavigableUnit"))
local var1_0 = {
	JumpHandle = 1,
	LoadToolHandle = 2
}

function var0_0.OnAttach(arg0_1, arg1_1)
	var0_0.super.OnAttach(arg0_1, arg1_1)

	arg0_1.characterHandleController = arg0_1._go:GetComponent(typeof(CharacterHandleController))

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
		return
	end)

	arg0_1.objTfList = {}
end

function var0_0.StateEnterHandle(arg0_6, arg1_6, arg2_6)
	if arg1_6 == var1_0.LoadToolHandle then
		local var0_6 = arg0_6:GetToolId(arg2_6)

		arg0_6:LoadInteractiveTool(arg2_6)
	end
end

function var0_0.StateEnterFixHandle(arg0_7, arg1_7, arg2_7)
	if arg1_7 == var1_0.LoadToolHandle then
		local var0_7 = arg0_7:GetToolId(arg2_7)

		pg.ViewUtils.SetLayer(arg0_7.objTfList[var0_7], Layer.Default)
	end
end

function var0_0.StateExitHandle(arg0_8, arg1_8, arg2_8)
	if arg1_8 == var1_0.LoadToolHandle then
		arg0_8:UnLoadInteractiveTool(arg2_8)
	end
end

function var0_0.GetToolId(arg0_9, arg1_9)
	if arg1_9 ~= 0 then
		return arg1_9
	end
end

function var0_0.LoadInteractiveTool(arg0_10, arg1_10)
	local var0_10 = arg0_10.objTfList[arg1_10]

	if var0_10 then
		setActive(var0_10, true)
		setParent(var0_10, arg0_10._tf)
		pg.ViewUtils.SetLayer(var0_10, Layer.UIHidden)

		return
	end

	local var1_10 = pg.island_animation_attachments[arg1_10]
	local var2_10 = var1_10.model

	if arg1_10 == pg.island_set.island_manage_animation_extroversion.key_value_int or arg1_10 == pg.island_set.island_manage_animation_introverted.key_value_int then
		local var3_10 = arg0_10.behaviourTreeOwner.graph.blackboard:GetVariable("systemId").value

		if var3_10 ~= 0 then
			var2_10 = pg.island_manage_restaurant[var3_10].performance_param
		end
	end

	local var4_10 = LoadAny(var2_10, nil)
	local var5_10 = Object.Instantiate(var4_10)

	arg0_10.objTfList[arg1_10] = var5_10.transform

	local var6_10 = LoadAny(var1_10.animator, nil, typeof(RuntimeAnimatorController))

	GetOrAddComponent(arg0_10.objTfList[arg1_10], typeof(Animator)).runtimeAnimatorController = var6_10

	setParent(arg0_10.objTfList[arg1_10], arg0_10._tf)
	pg.ViewUtils.SetLayer(arg0_10.objTfList[arg1_10], Layer.UIHidden)
end

function var0_0.UnLoadInteractiveTool(arg0_11, arg1_11)
	if arg0_11.objTfList[arg1_11] then
		setActive(arg0_11.objTfList[arg1_11], false)
	end
end

function var0_0.DestroyInteractiveTools(arg0_12)
	for iter0_12, iter1_12 in pairs(arg0_12.objTfList) do
		Object.Destroy(iter1_12.gameObject)
	end

	arg0_12.objTfList = {}
end

return var0_0
