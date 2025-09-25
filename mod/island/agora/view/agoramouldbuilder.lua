local var0_0 = class("AgoraMouldBuilder", import("Mod.Island.Core.Builder.IslandGenericBuilder"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.root = arg1_1.furnitureRoot
end

function var0_0.Build(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg0_2:GetPoolMgr():GetAgoraRoot()

	setParent(var0_2, arg0_2.root)

	local var1_2 = arg0_2:GetModule(var0_2, arg1_2)

	assert(arg0_2.unitListType)
	var1_2:SetUnitType(arg0_2.unitListType)

	local var2_2

	seriesAsync({
		function(arg0_3)
			arg0_2:Load(arg1_2, function(arg0_4)
				var2_2 = arg0_4

				arg0_3()
			end)
		end,
		function(arg0_5)
			arg0_2:SetupBT(var0_2, arg1_2:GetBt(), arg0_5)
		end
	}, function()
		arg0_2:AddTypeAndID(var0_2, var1_2)
		arg0_2:AddComponents(var0_2, arg1_2)
		arg0_2:SetTag(var0_2)
		var1_2:Init(var2_2, arg0_2)
		existCall(arg2_2, var1_2)
	end)

	return var1_2
end

function var0_0.SetupBT(arg0_7, arg1_7, arg2_7, arg3_7)
	if not arg2_7 or arg2_7 == "" then
		arg3_7()

		return
	end

	local var0_7 = IslandAssetLoadDispatcher.Instance:Enqueue(arg2_7, "", typeof(NodeCanvas.BehaviourTrees.BehaviourTree), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_8)
		assert(arg0_8, arg2_7)

		GetOrAddComponent(arg1_7, typeof(NodeCanvas.BehaviourTrees.BehaviourTreeOwner)).graph = Object.Instantiate(arg0_8)

		arg3_7()
	end), true, true)

	arg0_7:AddLoadingID(var0_7)
end

function var0_0.GetModule(arg0_9, arg1_9, arg2_9)
	return AgoraFurnitrueMould.New(arg0_9.view, arg1_9, arg2_9)
end

function var0_0.Load(arg0_10, arg1_10, arg2_10)
	arg0_10:GetPoolMgr():GetAgoraObj(arg1_10:GetResPath(), arg2_10)
end

function var0_0.Recycle(arg0_11, arg1_11, arg2_11)
	if arg2_11 then
		arg0_11:GetPoolMgr():ReturnAgoraObj(arg1_11:GetResPath(), arg2_11)
	end
end

function var0_0.RecycleRoot(arg0_12, arg1_12)
	arg0_12:GetPoolMgr():ReturnAgoraRoot(arg1_12)
end

return var0_0
