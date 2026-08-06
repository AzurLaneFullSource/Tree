local var0_0 = class("IslandInteractUnit", import(".IslandSceneUnit"))

function var0_0.OnAttach(arg0_1, arg1_1)
	local var0_1 = arg1_1 or arg0_1._go

	arg0_1.signalReceiver = GetOrAddComponent(var0_1, "DftCommonSignalReceiver")

	arg0_1.signalReceiver:SetCommonEvent(function(arg0_2)
		if arg0_1.ignoreSignal then
			return
		end

		switch(arg0_2.stringParameter, {
			TimelineEnd = function()
				arg0_1:Op("WorldObjectInterActionEnd", arg0_1.id, arg0_1.view.player.id)
			end
		})
	end)

	arg0_1.director = GetOrAddComponent(var0_1, typeof(UnityEngine.Playables.PlayableDirector))
	arg0_1.cachePlayerTransformInfoDic = {}
end

function var0_0.SetTimelineDic(arg0_4, arg1_4)
	arg0_4.timelineDic = arg1_4
end

function var0_0.GetTargetRoot(arg0_5)
	return arg0_5._go.transform
end

function var0_0.GetPlayerParent(arg0_6)
	return arg0_6:GetTargetRoot()
end

function var0_0.StartInteract(arg0_7, arg1_7, arg2_7, arg3_7, arg4_7, arg5_7, arg6_7, arg7_7)
	if arg6_7 then
		arg0_7.director:Stop()
	end

	arg1_7:ActiveOrDisactive(false)

	if arg7_7 then
		arg0_7.behaviourTreeOwner.graph.blackboard:SetVariableValue("inProgress", true)

		arg0_7.ignoreSignal = false
	else
		arg0_7.ignoreSignal = true
	end

	arg0_7:SetPlayerTransform(arg1_7, arg0_7:GetPlayerParent())

	if arg5_7 and #arg5_7 > 1 then
		arg0_7.behaviourTreeOwner.graph.blackboard:SetVariableValue(arg5_7[1], arg5_7[2])
	end

	arg0_7.director.playableAsset = arg0_7.timelineDic[arg3_7]
	arg0_7.director.extrapolationMode = arg4_7.is_loop == 1 and UnityEngine.Playables.DirectorWrapMode.Loop or UnityEngine.Playables.DirectorWrapMode.None

	arg0_7:BindPlayer(arg2_7, arg1_7)
	arg0_7:BindSelf(arg4_7)

	arg0_7.director.enabled = true

	arg0_7.director:Play()
end

function var0_0.EndInteract(arg0_8, arg1_8, arg2_8, arg3_8, arg4_8)
	if arg3_8 then
		arg0_8.director.time = arg0_8.director.extrapolationMode == UnityEngine.Playables.DirectorWrapMode.None and arg0_8.director.duration or 0

		arg0_8.director:Evaluate()
		arg0_8.director:Stop()

		arg0_8.director.enabled = false
	end

	arg0_8:BindPlayer(arg2_8, nil)

	if arg1_8 then
		arg1_8:ActiveOrDisactive(true)
	end

	if arg4_8 then
		arg0_8.behaviourTreeOwner.graph.blackboard:SetVariableValue("inProgress", false)
		onNextTick(function()
			arg0_8:RevertPlayerTransform(arg1_8)
		end)
	else
		arg0_8:RevertPlayerTransform(arg1_8)
	end
end

function var0_0.InitStatus(arg0_10, arg1_10, arg2_10, arg3_10)
	if arg3_10 and #arg3_10 > 1 then
		arg0_10.behaviourTreeOwner.graph.blackboard:SetVariableValue(arg3_10[1], arg3_10[2])
	end

	arg0_10.director.playableAsset = arg0_10.timelineDic[arg1_10]

	arg0_10:BindSelf(arg2_10)

	arg0_10.ignoreSignal = true
	arg0_10.director.enabled = true

	arg0_10.director:Play()

	arg0_10.director.time = arg0_10.director.duration

	arg0_10.director:Evaluate()
	arg0_10.director:Stop()
end

function var0_0.BindSelf(arg0_11, arg1_11)
	local var0_11 = TimelineHelper.GetGroupTracks(arg0_11.director):ToTable()

	if #var0_11 > 0 then
		local var1_11 = TimelineHelper.GetChildTracks(var0_11[1]):ToTable()

		for iter0_11, iter1_11 in ipairs(var1_11) do
			local var2_11, var3_11 = table.Find(arg1_11.binding_track, function(arg0_12, arg1_12)
				return arg1_12 == iter0_11
			end)

			if var3_11 ~= nil then
				local var4_11 = arg1_11.binding_path[var3_11]
				local var5_11 = var4_11 == "" and arg0_11:GetTargetRoot() or arg0_11:GetTargetRoot():Find(var4_11)

				if var5_11 then
					TimelineHelper.SetAutoBinding(arg0_11.director, iter1_11, go(var5_11))
				end
			end
		end

		for iter2_11, iter3_11 in ipairs(arg1_11.control_binding or {}) do
			local var6_11 = iter3_11[1]
			local var7_11 = iter3_11[2]
			local var8_11 = iter3_11[3] or ""
			local var9_11 = var1_11[var6_11]

			if var9_11 and var7_11 and var7_11 > 0 then
				local var10_11 = var8_11 == "" and arg0_11:GetTargetRoot() or arg0_11:GetTargetRoot():Find(var8_11)

				if var10_11 then
					TimelineHelper.SetControlBinding(arg0_11.director, var9_11, var7_11 - 1, go(var10_11))
				end
			end
		end
	end
end

function var0_0.BindPlayer(arg0_13, arg1_13, arg2_13)
	local var0_13 = TimelineHelper.GetGroupTracks(arg0_13.director):ToTable()
	local var1_13 = arg2_13 and go(arg2_13._go.transform:GetChild(0))
	local var2_13 = arg2_13 and arg2_13._go

	if arg1_13 < #var0_13 then
		local var3_13 = TimelineHelper.GetChildTracks(var0_13[arg1_13 + 1]):ToTable()

		for iter0_13, iter1_13 in ipairs(var3_13) do
			if iter0_13 == 1 then
				TimelineHelper.SetAutoBinding(arg0_13.director, iter1_13, var2_13)
			else
				TimelineHelper.SetAutoBinding(arg0_13.director, iter1_13, var1_13)
			end
		end
	end
end

function var0_0.SetPlayerTransform(arg0_14, arg1_14, arg2_14)
	arg0_14.cachePlayerTransformInfoDic[arg1_14.id] = {
		position = arg1_14._tf.position,
		rotation = arg1_14._tf.rotation
	}

	setParent(arg1_14._tf, arg2_14)

	arg1_14._tf.localPosition = Vector3.zero
	arg1_14._tf.localRotation = Quaternion.identity
	GetOrAddComponent(arg1_14._go, typeof(UnityEngine.Animator)).enabled = true
end

function var0_0.RevertPlayerTransform(arg0_15, arg1_15)
	if not arg1_15 or not arg0_15.cachePlayerTransformInfoDic[arg1_15.id] then
		return
	end

	setParent(arg1_15._tf, arg0_15.view.root)

	arg1_15._tf.position = arg0_15.cachePlayerTransformInfoDic[arg1_15.id].position
	arg1_15._tf.rotation = arg0_15.cachePlayerTransformInfoDic[arg1_15.id].rotation
	GetOrAddComponent(arg1_15._go, typeof(UnityEngine.Animator)).enabled = false
	arg0_15.cachePlayerTransformInfoDic[arg1_15.id] = nil
end

return var0_0
