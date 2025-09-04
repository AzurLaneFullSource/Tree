local var0_0 = class("IslandInteractUnit", import(".IslandSceneUnit"))

function var0_0.OnAttach(arg0_1, arg1_1)
	local var0_1 = arg1_1 or arg0_1._go

	arg0_1.signalReceiver = GetOrAddComponent(var0_1, "DftCommonSignalReceiver")

	arg0_1.signalReceiver:SetCommonEvent(function(arg0_2)
		if arg0_1.ignoreSignal then
			arg0_1.ignoreSignal = false

			return
		end

		switch(arg0_2.stringParameter, {
			TimelineEnd = function()
				arg0_1:Op("WorldObjectInterActionEnd", arg0_1.id, arg0_1.view.player.id)
			end
		})
	end)

	arg0_1.director = GetOrAddComponent(var0_1, typeof(UnityEngine.Playables.PlayableDirector))
end

function var0_0.SetTimelineDic(arg0_4, arg1_4)
	arg0_4.timelineDic = arg1_4
end

function var0_0.OnUpdate(arg0_5)
	return
end

function var0_0.StartInteract(arg0_6, arg1_6, arg2_6, arg3_6, arg4_6, arg5_6, arg6_6, arg7_6)
	if arg6_6 then
		arg0_6.director:Stop()
	end

	if arg7_6 then
		arg0_6.behaviourTreeOwner.graph.blackboard:SetVariableValue("inProgress", true)
	end

	if arg5_6 and #arg5_6 > 1 then
		arg0_6.behaviourTreeOwner.graph.blackboard:SetVariableValue(arg5_6[1], arg5_6[2])
	end

	arg0_6.director.playableAsset = arg0_6.timelineDic[arg3_6]
	arg0_6.director.extrapolationMode = arg4_6.is_loop and UnityEngine.Playables.DirectorWrapMode.Loop or UnityEngine.Playables.DirectorWrapMode.None

	arg0_6:SetPlayerTransform(arg1_6, arg0_6._go.transform)
	arg0_6:BindPlayer(arg2_6, arg1_6)
	arg0_6:BindSelf(arg4_6)

	arg0_6.director.enabled = true

	arg0_6.director:Play()
end

function var0_0.EndInteract(arg0_7, arg1_7, arg2_7, arg3_7, arg4_7)
	if arg3_7 then
		arg0_7.director:Stop()

		arg0_7.director.enabled = true
	end

	if arg4_7 then
		arg0_7.behaviourTreeOwner.graph.blackboard:SetVariableValue("inProgress", false)
	end

	arg0_7:BindPlayer(arg2_7, nil)
	onNextTick(function()
		arg0_7:RevertPlayerTransform(arg1_7)
	end)
end

function var0_0.InitStatus(arg0_9, arg1_9, arg2_9, arg3_9)
	if arg3_9 and #arg3_9 > 1 then
		arg0_9.behaviourTreeOwner.graph.blackboard:SetVariableValue(arg3_9[1], arg3_9[2])
	end

	arg0_9.director.playableAsset = arg0_9.timelineDic[arg1_9]

	arg0_9:BindSelf(arg2_9)

	arg0_9.ignoreSignal = true
	arg0_9.director.enabled = true

	arg0_9.director:Play()

	arg0_9.director.time = arg0_9.director.duration

	arg0_9.director:Evaluate()
	arg0_9.director:Stop()
end

function var0_0.BindSelf(arg0_10, arg1_10)
	local var0_10 = TimelineHelper.GetGroupTracks(arg0_10.director)

	if var0_10.Length > 0 and arg0_10._go.transform.childCount > 0 then
		local var1_10 = TimelineHelper.GetChildTracks(var0_10[0])

		for iter0_10 = 0, var1_10.Length - 1 do
			local var2_10, var3_10 = table.Find(arg1_10.binding_track, function(arg0_11, arg1_11)
				return arg1_11 == var1_10[iter0_10].name
			end)

			if var3_10 ~= nil then
				local var4_10 = arg1_10.binding_path[var3_10]
				local var5_10 = string.find(var4_10, "/")

				if var5_10 then
					local var6_10 = string.sub(var4_10, 1, var5_10 - 1)
					local var7_10 = string.sub(var4_10, var5_10)

					var4_10 = var6_10 .. "(Clone)" .. var7_10
				else
					var4_10 = var4_10 .. "(Clone)"
				end

				local var8_10 = go(arg0_10._go.transform:Find(var4_10))

				TimelineHelper.SetAutoBinding(arg0_10.director, var1_10[iter0_10], var8_10)
			end
		end
	end
end

function var0_0.BindPlayer(arg0_12, arg1_12, arg2_12)
	local var0_12 = TimelineHelper.GetGroupTracks(arg0_12.director)
	local var1_12 = arg2_12 and go(arg2_12._go.transform:GetChild(0))

	if arg1_12 < var0_12.Length then
		local var2_12 = TimelineHelper.GetChildTracks(var0_12[arg1_12])

		for iter0_12 = 0, var2_12.Length - 1 do
			TimelineHelper.SetAutoBinding(arg0_12.director, var2_12[iter0_12], var1_12)
		end
	end
end

function var0_0.SetPlayerTransform(arg0_13, arg1_13, arg2_13)
	arg0_13.cachePlayerTransformInfo = {
		position = arg1_13._tf.position,
		rotation = arg1_13._tf.rotation
	}
	arg1_13._tf.position = arg2_13.position

	arg1_13:SetTargetRotation(arg2_13.rotation)
end

function var0_0.RevertPlayerTransform(arg0_14, arg1_14)
	if not arg0_14.cachePlayerTransformInfo then
		return
	end

	arg1_14._tf.position = arg0_14.cachePlayerTransformInfo.position

	arg1_14:SetTargetRotation(arg0_14.cachePlayerTransformInfo.rotation)

	arg0_14.cachePlayerTransformInfo = nil
end

return var0_0
