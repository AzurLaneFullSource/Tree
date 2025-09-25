local var0_0 = class("IslandVirtualInteractUnit", import(".IslandInteractUnit"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.attach = "AgoraMainStage/furniture/" .. math.floor(arg2_1.id / 10) .. "/" .. arg2_1.config.attach
end

function var0_0.StartInteract(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2, arg5_2, arg6_2, arg7_2)
	if arg6_2 then
		arg0_2.director:Stop()
	end

	arg0_2.attachGo = arg0_2.attachGo or GameObject.Find(arg0_2.attach)

	arg1_2:ActiveOrDisactive(false)

	if arg7_2 then
		arg0_2.behaviourTreeOwner.graph.blackboard:SetVariableValue("inProgress", true)
		arg0_2:SetPlayerTransform(arg1_2, arg0_2.attachGo.transform.parent)
	else
		arg0_2:SetVisitorTransform(arg1_2, arg0_2.attachGo.transform.parent)
	end

	if arg5_2 and #arg5_2 > 1 then
		arg0_2.behaviourTreeOwner.graph.blackboard:SetVariableValue(arg5_2[1], arg5_2[2])
	end

	arg0_2.director.playableAsset = arg0_2.timelineDic[arg3_2]
	arg0_2.director.extrapolationMode = arg4_2.is_loop and UnityEngine.Playables.DirectorWrapMode.Loop or UnityEngine.Playables.DirectorWrapMode.None

	arg0_2:BindPlayer(arg2_2, arg1_2)
	arg0_2:BindSelf(arg4_2)

	arg0_2.director.enabled = true

	arg0_2.director:Play()
end

function var0_0.BindSelf(arg0_3, arg1_3)
	if not arg0_3.attachGo then
		return
	end

	local var0_3 = TimelineHelper.GetGroupTracks(arg0_3.director):ToTable()

	if #var0_3 > 0 then
		local var1_3 = TimelineHelper.GetChildTracks(var0_3[1]):ToTable()

		for iter0_3, iter1_3 in ipairs(var1_3) do
			local var2_3, var3_3 = table.Find(arg1_3.binding_track, function(arg0_4, arg1_4)
				return arg1_4 == iter0_3
			end)

			if var3_3 ~= nil then
				local var4_3 = arg1_3.binding_path[var3_3]
				local var5_3 = var4_3 == "" and arg0_3.attachGo.transform or arg0_3.attachGo.transform:Find(var4_3)

				if var5_3 then
					TimelineHelper.SetAutoBinding(arg0_3.director, iter1_3, go(var5_3))
				end
			end
		end
	end
end

return var0_0
