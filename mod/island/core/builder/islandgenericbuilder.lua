local var0_0 = class("IslandGenericBuilder", import(".IslandBaseBuilder"))

function var0_0.Load(arg0_1, arg1_1, arg2_1)
	local var0_1 = {}
	local var1_1

	table.insert(var0_1, function(arg0_2)
		arg0_1:LoadAsset(arg1_1, function(arg0_3)
			var1_1 = arg0_3

			arg0_2()
		end)
	end)
	table.insert(var0_1, function(arg0_4)
		arg0_1:SetupBT(var1_1, arg1_1, arg0_4)
	end)
	seriesAsync(var0_1, function()
		arg2_1(var1_1)
	end)
end

function var0_0.LoadAsset(arg0_6, arg1_6, arg2_6)
	local var0_6 = IslandAssetLoadDispatcher.Instance:Enqueue(arg1_6:GetAssetPath(), "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_7)
		local var0_7 = FrameAsyncInstantiateManager.Instance:EnqueueInstantiate(arg0_7, function(arg0_8)
			arg2_6(arg0_8)
		end)

		table.insert(arg0_6.insIdList, var0_7)
	end), true, true)

	arg0_6:AddLoadingID(var0_6)
end

function var0_0.SetupBT(arg0_9, arg1_9, arg2_9, arg3_9)
	local var0_9 = arg2_9:GetBehaviourTree()

	if not var0_9 or var0_9 == "" then
		arg3_9()

		return
	end

	local var1_9 = IslandAssetLoadDispatcher.Instance:Enqueue(var0_9, "", typeof(NodeCanvas.BehaviourTrees.BehaviourTree), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_10)
		assert(arg0_10, var0_9)

		GetOrAddComponent(arg1_9, typeof(NodeCanvas.BehaviourTrees.BehaviourTreeOwner)).graph = Object.Instantiate(arg0_10)

		arg3_9()
	end), true, true)

	arg0_9:AddLoadingID(var1_9)
end

function var0_0.Recycle(arg0_11, arg1_11, arg2_11)
	Object.Destroy(arg2_11)
end

return var0_0
