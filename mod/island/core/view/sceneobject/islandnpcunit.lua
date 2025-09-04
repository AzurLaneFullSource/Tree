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
		arg0_1:StateExitFixHandle(arg0_5, arg1_5)
	end)

	arg0_1.objTfList = {}
end

function var0_0.StateEnterHandle(arg0_6, arg1_6, arg2_6)
	if arg1_6 == var1_0.LoadToolHandle then
		arg0_6:LoadInteractiveTool(arg2_6)
	end
end

function var0_0.StateEnterFixHandle(arg0_7, arg1_7, arg2_7)
	pg.ViewUtils.SetLayer(arg0_7.objTfList[arg0_7.toolId], Layer.Default)
end

function var0_0.StateExitFixHandle(arg0_8, arg1_8, arg2_8)
	pg.ViewUtils.SetLayer(arg0_8.objTfList[arg0_8.toolId], Layer.UIHidden)
end

function var0_0.StateExitHandle(arg0_9, arg1_9, arg2_9)
	if arg1_9 == var1_0.LoadToolHandle then
		arg0_9:UnLoadInteractiveTool()
	end
end

function var0_0.LoadInteractiveTool(arg0_10, arg1_10)
	if arg1_10 ~= 0 then
		arg0_10.toolId = arg1_10
	end

	local var0_10 = arg0_10.objTfList[arg0_10.toolId]

	if var0_10 then
		setActive(var0_10, true)
		setParent(var0_10, arg0_10._tf)
		pg.ViewUtils.SetLayer(var0_10, Layer.UIHidden)

		return
	end

	local var1_10 = pg.island_animation_attachments[arg0_10.toolId]
	local var2_10 = var1_10.model

	if arg0_10.toolId == pg.island_set.island_manage_animation_extroversion.key_value_int or arg0_10.toolId == pg.island_set.island_manage_animation_introverted.key_value_int then
		local var3_10 = arg0_10.behaviourTreeOwner.graph.blackboard:GetVariable("systemId").value

		if var3_10 ~= 0 then
			var2_10 = pg.island_manage_restaurant[var3_10].performance_param
		end
	end

	local var4_10 = LoadAny(var2_10, nil)
	local var5_10 = Object.Instantiate(var4_10)

	arg0_10.objTfList[arg0_10.toolId] = var5_10.transform

	local var6_10 = LoadAny(var1_10.animator, nil, typeof(RuntimeAnimatorController))

	GetOrAddComponent(arg0_10.objTfList[arg0_10.toolId], typeof(Animator)).runtimeAnimatorController = var6_10

	setParent(arg0_10.objTfList[arg0_10.toolId], arg0_10._tf)
	pg.ViewUtils.SetLayer(arg0_10.objTfList[arg0_10.toolId], Layer.UIHidden)
end

function var0_0.UnLoadInteractiveTool(arg0_11)
	if arg0_11.objTfList[arg0_11.toolId] then
		setActive(arg0_11.objTfList[arg0_11.toolId], false)
	end
end

return var0_0
