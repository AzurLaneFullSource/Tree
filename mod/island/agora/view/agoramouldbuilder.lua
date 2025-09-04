local var0_0 = class("AgoraMouldBuilder", import("Mod.Island.Core.Builder.IslandItemInteractBuilder"))

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
		end,
		function(arg0_6)
			arg0_2:LoadTimeline(var0_2, var1_2, arg1_2, arg0_6)
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

function var0_0.SetupBT(arg0_8, arg1_8, arg2_8, arg3_8)
	if not arg2_8 or arg2_8 == "" then
		arg3_8()

		return
	end

	ResourceMgr.Inst:getAssetAsync(arg2_8, "", typeof(NodeCanvas.BehaviourTrees.BehaviourTree), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_9)
		assert(arg0_9, arg2_8)

		GetOrAddComponent(arg1_8, typeof(NodeCanvas.BehaviourTrees.BehaviourTreeOwner)).graph = Object.Instantiate(arg0_9)

		arg3_8()
	end), true, true)
end

function var0_0.GetModule(arg0_10, arg1_10, arg2_10)
	return AgoraFurnitrueMould.New(arg0_10.view, arg1_10, arg2_10)
end

function var0_0.Load(arg0_11, arg1_11, arg2_11)
	arg0_11:GetPoolMgr():GetAgoraObj(arg1_11:GetResPath(), arg2_11)
end

function var0_0.Recycle(arg0_12, arg1_12, arg2_12)
	if arg2_12 then
		arg0_12:GetPoolMgr():ReturnAgoraObj(arg1_12:GetResPath(), arg2_12)
	end
end

function var0_0.RecycleRoot(arg0_13, arg1_13)
	arg0_13:GetPoolMgr():ReturnAgoraRoot(arg1_13)
end

return var0_0
