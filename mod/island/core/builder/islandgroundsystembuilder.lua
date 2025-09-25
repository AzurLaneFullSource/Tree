local var0_0 = class("IslandGroundSystemBuilder", import(".IslandSystemBuilder"))

function var0_0.Load(arg0_1, arg1_1, arg2_1)
	arg0_1:CreateNode(arg1_1, function(arg0_2)
		arg2_1(arg0_2)
	end)
end

function var0_0.CreateNode(arg0_3, arg1_3, arg2_3)
	local var0_3 = IslandAssetLoadDispatcher.Instance:Enqueue(arg1_3:GetAssetPath(), "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_4)
		local var0_4 = FrameAsyncInstantiateManager.Instance:EnqueueInstantiate(arg0_4, function(arg0_5)
			arg2_3(arg0_5)
		end)

		table.insert(arg0_3.insIdList, var0_4)
	end), true, true)

	arg0_3:AddLoadingID(var0_3)
end

return var0_0
