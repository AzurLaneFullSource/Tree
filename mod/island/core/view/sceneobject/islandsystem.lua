local var0_0 = class("IslandSystem", import(".IslandSceneUnit"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	local var0_1 = GameObject.New()

	seriesAsync({
		function(arg0_2)
			arg0_1:LoadBehaviourTree(var0_1, arg0_1:GetBehaviourTree(), arg0_2)
		end
	}, function()
		arg0_1:Init(var0_1)
	end)
end

function var0_0.GetBehaviourTree(arg0_4)
	return arg0_4.data:GetBehaviourTree()
end

function var0_0.LoadBehaviourTree(arg0_5, arg1_5, arg2_5, arg3_5)
	if not arg2_5 or arg2_5 == "" then
		arg3_5()

		return
	end

	ResourceMgr.Inst:getAssetAsync(arg2_5, "", typeof(NodeCanvas.BehaviourTrees.BehaviourTree), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_6)
		assert(arg0_6, arg2_5)

		GetOrAddComponent(arg1_5, typeof(NodeCanvas.BehaviourTrees.BehaviourTreeOwner)).graph = Object.Instantiate(arg0_6)

		arg3_5()
	end), true, true)
end

return var0_0
