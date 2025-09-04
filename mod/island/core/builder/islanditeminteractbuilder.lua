local var0_0 = class("IslandItemInteractBuilder", import(".IslandGenericBuilder"))

function var0_0.GetModule(arg0_1, arg1_1, arg2_1)
	return IslandInteractUnit.New(arg1_1, arg2_1)
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
		arg0_2:SetupBT(var1_2, arg1_2, arg0_5)
	end)
	table.insert(var0_2, function(arg0_6)
		arg0_2:SetupSubBT(var1_2, arg1_2, arg0_6)
	end)
	seriesAsync(var0_2, function()
		arg2_2(var1_2)
	end)
end

function var0_0.AddComponents(arg0_8, arg1_8, arg2_8)
	GetOrAddComponent(arg1_8, "DftCommonSignalReceiver")
end

function var0_0.SetupSubBT(arg0_9, arg1_9, arg2_9, arg3_9)
	arg3_9()
end

function var0_0.LoadTimeline(arg0_10, arg1_10, arg2_10, arg3_10, arg4_10)
	if not arg3_10:HasTimeline() then
		arg4_10()

		return
	end

	local var0_10 = arg3_10:GetTimeline()
	local var1_10 = {}
	local var2_10 = {}

	for iter0_10, iter1_10 in ipairs(var0_10) do
		table.insert(var1_10, function(arg0_11)
			ResourceMgr.Inst:getAssetAsync(iter1_10.name, "", typeof(UnityEngine.Playables.PlayableAsset), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_12)
				local var0_12 = Object.Instantiate(arg0_12)

				var2_10[iter0_10] = var0_12

				arg0_11()
			end), true, true)
		end)
	end

	parallelAsync(var1_10, function()
		local var0_13 = GetOrAddComponent(arg1_10, typeof(UnityEngine.Playables.PlayableDirector))

		var0_13.playableAsset = var2_10[1]

		var0_13:Stop()

		var0_13.playOnAwake = false

		arg2_10:SetTimelineDic(var2_10)
		arg4_10()
	end)
end

return var0_0
