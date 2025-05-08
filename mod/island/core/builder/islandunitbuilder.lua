local var0_0 = class("IslandUnitBuilder")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.view = arg1_1
end

function var0_0.Build(arg0_2, arg1_2)
	local var0_2 = arg0_2:GetModule(arg0_2.view, arg1_2)
	local var1_2

	seriesAsync({
		function(arg0_3)
			arg0_2:Load(arg1_2, function(arg0_4)
				var1_2 = arg0_4

				arg0_3()
			end)
		end,
		function(arg0_5)
			arg0_2:AddComponents(var1_2, arg1_2)
			arg0_2:SetTag(var1_2)
			arg0_2:SetupBT(var1_2, arg1_2, arg0_5)
		end
	}, function()
		var0_2:Init(var1_2)
	end)

	return var0_2
end

function var0_0.Load(arg0_7, arg1_7, arg2_7)
	ResourceMgr.Inst:getAssetAsync(arg1_7:GetAssetPath(), "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_8)
		local var0_8 = Object.Instantiate(arg0_8)

		arg2_7(var0_8)
	end), true, true)
end

function var0_0.SetupBT(arg0_9, arg1_9, arg2_9, arg3_9)
	local var0_9 = arg2_9:GetBehaviourTree()

	if not var0_9 or var0_9 == "" then
		arg3_9()

		return
	end

	ResourceMgr.Inst:getAssetAsync(var0_9, "", typeof(NodeCanvas.BehaviourTrees.BehaviourTree), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_10)
		assert(arg0_10, var0_9)

		GetOrAddComponent(arg1_9, typeof(NodeCanvas.BehaviourTrees.BehaviourTreeOwner)).graph = Object.Instantiate(arg0_10)

		arg3_9()
	end), true, true)
end

function var0_0.GetModule(arg0_11, arg1_11, arg2_11)
	assert(false, "overwrite !!!")
end

function var0_0.SetTag(arg0_12, arg1_12)
	return
end

function var0_0.AddComponents(arg0_13, arg1_13)
	return
end

return var0_0
