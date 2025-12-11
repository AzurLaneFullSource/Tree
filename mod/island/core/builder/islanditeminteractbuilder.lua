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
		arg0_2:SetupBT(var1_2, arg1_2:GetBehaviourTree(), arg0_5)
	end)
	seriesAsync(var0_2, function()
		arg2_2(var1_2)
	end)
end

function var0_0.AddComponents(arg0_7, arg1_7, arg2_7)
	GetOrAddComponent(arg1_7, "DftCommonSignalReceiver")
end

function var0_0.LoadTimeline(arg0_8, arg1_8, arg2_8, arg3_8, arg4_8)
	if not arg3_8:HasTimeline() then
		arg4_8()

		return
	end

	local var0_8 = arg3_8:GetTimeline()
	local var1_8 = {}
	local var2_8 = {}

	for iter0_8, iter1_8 in ipairs(var0_8) do
		table.insert(var1_8, function(arg0_9)
			local var0_9 = IslandAssetLoadDispatcher.Instance:Enqueue(iter1_8.name, "", typeof(UnityEngine.Playables.PlayableAsset), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_10)
				local var0_10 = Object.Instantiate(arg0_10)

				var2_8[iter0_8] = var0_10

				arg0_9()
			end), true, true)

			arg0_8:AddLoadingID(var0_9)
		end)
	end

	parallelAsync(var1_8, function()
		local var0_11 = GetOrAddComponent(arg1_8, typeof(UnityEngine.Playables.PlayableDirector))

		var0_11.playableAsset = var2_8[1]

		var0_11:Stop()

		var0_11.playOnAwake = false

		arg2_8:SetTimelineDic(var2_8)
		arg4_8()
	end)
end

return var0_0
