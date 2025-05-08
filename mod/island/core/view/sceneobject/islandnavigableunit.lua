local var0_0 = class("IslandNavigableUnit", import(".IslandSceneUnit"))

function var0_0.Init(arg0_1, arg1_1)
	var0_0.super.Init(arg0_1, arg1_1)

	arg0_1.agent = GetOrAddComponent(arg1_1, typeof(UnityEngine.AI.NavMeshAgent))
	arg0_1.agent.updatePosition = false
	arg0_1.agent.updateRotation = false

	arg0_1:SetNavAgentStopDistance(2)
end

function var0_0.SetNavAgentStopDistance(arg0_2, arg1_2)
	arg0_2.agent.stoppingDistance = arg1_2
end

function var0_0.SetNavAgentDestination(arg0_3, arg1_3)
	arg0_3.agent.isStopped = false
	arg0_3.agent.destination = arg1_3
end

function var0_0.SetNavPosition(arg0_4, arg1_4)
	arg0_4.agent.nextPosition = arg1_4
end

function var0_0.CalculateNavPath(arg0_5, arg1_5)
	local var0_5 = UnityEngine.AI.NavMeshPath.New()

	arg0_5.agent:CalculatePath(arg1_5, var0_5)

	return (var0_5.corners:ToTable())
end

function var0_0.SetNavAgentSpeed(arg0_6, arg1_6)
	arg0_6.agent.speed = arg1_6
end

function var0_0.GetNavAgentSpeed(arg0_7, arg1_7)
	return arg0_7.agent.speed
end

function var0_0.SetNavAgentVelocity(arg0_8, arg1_8)
	arg0_8.agent.velocity = arg1_8
end

function var0_0.GetNavAgentVelocity(arg0_9)
	return arg0_9.agent.desiredVelocity * arg0_9.agent.speed
end

function var0_0.GetDesiredVelocity(arg0_10)
	return arg0_10.agent.desiredVelocity
end

function var0_0.StopNavAgent(arg0_11)
	arg0_11.agent.isStopped = true
end

return var0_0
