local var0_0 = class("IslandFollowNpcUnit", import(".IslandDressupNpcUnit"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.randomizer = arg2_1.randomizer
end

function var0_0.OnInit(arg0_2, arg1_2, arg2_2)
	var0_0.super.OnInit(arg0_2, arg1_2, arg2_2)
	arg0_2:WarpAgent()
end

function var0_0.ResetPosition(arg0_3)
	arg0_3._go.transform.eulerAngles = arg0_3.rotation

	local var0_3 = arg0_3:GetNavPosition()

	arg0_3._go.transform.position = var0_3
end

function var0_0.GetNavPosition(arg0_4)
	for iter0_4 = 1, 100 do
		local var0_4 = IslandCalcUtil.GetRandomPointInSector(arg0_4.position, -arg0_4._go.transform.forward, 3, 270)
		local var1_4 = IslandHelper.IsPointInWalkableArea(var0_4, 0.2)

		if var1_4 then
			return var0_4
		end

		local var2_4 = IslandHelper.SampleWalkablPosition(var0_4, 2)

		if var1_4 and var2_4 ~= var0_4 then
			return var2_4
		end
	end

	return IslandHelper.SampleWalkablPosition(arg0_4.position, arg0_4.position.y * 1.1)
end

function var0_0.OnAttach(arg0_5, arg1_5)
	var0_0.super.OnAttach(arg0_5, arg1_5)
	arg0_5:UpdateBtRandomizer()
	arg0_5.behaviourTreeOwner.graph.blackboard:SetVariableValue("following", true)
end

function var0_0.UpdateBtRandomizer(arg0_6)
	arg0_6.behaviourTreeOwner.graph.blackboard:SetVariableValue("randomizer", arg0_6.randomizer)
end

function var0_0.SetBtRandomizer(arg0_7)
	arg0_7:StopBt()

	arg0_7.randomizer = true

	arg0_7:UpdateBtRandomizer()
	arg0_7:RestartBt()
end

function var0_0.DoExitHandle(arg0_8)
	arg0_8.isExiting = true

	arg0_8.behaviourTreeOwner.graph.blackboard:SetVariableValue("following", false)
end

function var0_0.IsExitState(arg0_9)
	return arg0_9.isExiting
end

return var0_0
