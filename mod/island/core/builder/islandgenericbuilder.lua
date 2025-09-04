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
	ResourceMgr.Inst:getAssetAsync(arg1_6:GetAssetPath(), "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_7)
		local var0_7 = Object.Instantiate(arg0_7)

		arg2_6(var0_7)
	end), true, true)
end

function var0_0.SetupBT(arg0_8, arg1_8, arg2_8, arg3_8)
	local var0_8 = arg2_8:GetBehaviourTree()

	if not var0_8 or var0_8 == "" then
		arg3_8()

		return
	end

	ResourceMgr.Inst:getAssetAsync(var0_8, "", typeof(NodeCanvas.BehaviourTrees.BehaviourTree), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_9)
		assert(arg0_9, var0_8)

		GetOrAddComponent(arg1_8, typeof(NodeCanvas.BehaviourTrees.BehaviourTreeOwner)).graph = Object.Instantiate(arg0_9)

		arg3_8()
	end), true, true)
end

function var0_0.Recycle(arg0_10, arg1_10, arg2_10)
	Object.Destroy(arg2_10)
end

return var0_0
