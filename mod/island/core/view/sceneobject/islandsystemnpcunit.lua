local var0_0 = class("IslandSystemNpcUnit", import(".IslandNpcUnit"))

function var0_0.SetupBt(arg0_1)
	if not arg0_1.behaviourTreeOwner then
		return
	end

	if not arg0_1:GetView():IsInit() then
		arg0_1.behaviourTreeOwner.graph.blackboard:SetVariableValue("working", true)
	end

	var0_0.super.SetupBt(arg0_1)
end

return var0_0
