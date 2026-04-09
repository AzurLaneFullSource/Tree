local var0_0 = class("IslandCheaterTavernChairBuilder", import(".IslandGenericBuilder"))

function var0_0.GetModule(arg0_1, arg1_1, arg2_1)
	return IslandCheaterTavernCharUnit.New(arg1_1, arg2_1)
end

function var0_0.Load(arg0_2, arg1_2, arg2_2)
	local var0_2 = {}
	local var1_2

	table.insert(var0_2, function(arg0_3)
		arg0_2:LoadAsset(arg1_2, function(arg0_4)
			var1_2 = arg0_4

			arg0_3()
		end)
	end)
	table.insert(var0_2, function(arg0_5)
		arg0_2:SetupBT(var1_2, arg1_2:GetBehaviourTree(), arg0_5)
	end)
	table.insert(var0_2, function(arg0_6)
		var1_2 = arg0_2:NestModel(var1_2)

		arg0_6()
	end)
	seriesAsync(var0_2, function()
		arg2_2(var1_2)
	end)
end

function var0_0.NestModel(arg0_8, arg1_8)
	local var0_8 = arg1_8.name
	local var1_8 = GameObject.New(var0_8)

	setParent(arg1_8.transform, var1_8.transform, false)

	arg1_8 = var1_8

	return arg1_8
end

function var0_0.SetTag(arg0_9, arg1_9)
	arg1_9.tag = IslandConst.TAG_NPC
end

function var0_0.Recycle(arg0_10, arg1_10, arg2_10)
	Object.Destroy(arg2_10)
end

function var0_0.LoadOtherPart(arg0_11, arg1_11, arg2_11, arg3_11, arg4_11)
	local var0_11 = IslandAssetLoadDispatcher.Instance:Enqueue("Island/Effect/Prefab/game/bar/vfx_bar_heidong", "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_12)
		local var0_12 = FrameAsyncInstantiateManager.Instance:EnqueueInstantiate(arg0_12, function(arg0_13)
			setActive(arg0_13, false)

			arg0_13.transform.localPosition = Vector3(0, 0.05, 0)

			setParent(arg0_13, arg1_11)
			arg2_11:SetEffect(arg0_13)
			arg4_11(arg0_13)
		end)

		table.insert(arg0_11.insIdList, var0_12)
	end), true, true)

	arg0_11:AddLoadingID(var0_11)
end

return var0_0
