local var0_0 = class("AgoraMouldBuilder")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.view = arg1_1
	arg0_1.tpl = GameObject.Find("AgoraMainStage/tpl")
	arg0_1.root = GameObject.Find("AgoraMainStage/furniture")
end

function var0_0.Build(arg0_2, arg1_2)
	local var0_2 = cloneTplTo(arg0_2.tpl, arg0_2.root).gameObject
	local var1_2 = AgoraFurnitrueMould.New(arg0_2.view, var0_2, arg1_2)
	local var2_2

	seriesAsync({
		function(arg0_3)
			arg0_2:LoadRes(var0_2, arg1_2, function(arg0_4)
				var2_2 = arg0_4

				arg0_3()
			end)
		end,
		function(arg0_5)
			arg0_2:LoadBt(var0_2, arg1_2, arg0_5)
		end,
		function(arg0_6)
			arg0_2:LoadTimeline(var0_2, var2_2, arg1_2, arg0_6)
		end
	}, function()
		var1_2:Init(var2_2)
	end)

	return var1_2
end

function var0_0.LoadRes(arg0_8, arg1_8, arg2_8, arg3_8)
	local var0_8 = arg2_8:GetResPath()

	ResourceMgr.Inst:getAssetAsync(var0_8, "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_9)
		local var0_9 = Object.Instantiate(arg0_9)

		setParent(var0_9, arg1_8)
		arg3_8(var0_9)
	end), true, true)
end

function var0_0.LoadBt(arg0_10, arg1_10, arg2_10, arg3_10)
	if not arg2_10:HasBt() then
		arg3_10()

		return
	end

	local var0_10 = arg2_10:GetBt()

	ResourceMgr.Inst:getAssetAsync(var0_10, "", typeof(NodeCanvas.BehaviourTrees.BehaviourTree), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_11)
		GetOrAddComponent(arg1_10, typeof(NodeCanvas.BehaviourTrees.BehaviourTreeOwner)).graph = Object.Instantiate(arg0_11)

		arg3_10()
	end), true, true)
end

function var0_0.LoadTimeline(arg0_12, arg1_12, arg2_12, arg3_12, arg4_12)
	if not arg3_12:HasTimeline() then
		arg4_12()

		return
	end

	local var0_12 = arg3_12:GetTimeline()

	ResourceMgr.Inst:getAssetAsync(var0_12, "", typeof(UnityEngine.Playables.PlayableAsset), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_13)
		local var0_13 = arg1_12.transform:Find("playable"):GetComponent(typeof(UnityEngine.Playables.PlayableDirector))

		var0_13.playableAsset = Object.Instantiate(arg0_13)

		local var1_13 = TimelineHelper.GetTimelineTracks(var0_13)

		if var1_13 and var1_13.Length > 0 then
			local var2_13 = var1_13[0]

			TimelineHelper.SetSceneBinding(var0_13, var2_13, arg2_12)
		end

		arg4_12()
	end), true, true)
end

return var0_0
