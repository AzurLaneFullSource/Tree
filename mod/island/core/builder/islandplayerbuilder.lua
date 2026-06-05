local var0_0 = class("IslandPlayerBuilder", import(".IslandGenericBuilder"))

function var0_0.GetModule(arg0_1, arg1_1, arg2_1)
	return IslandPlayerUnit.New(arg1_1, arg2_1)
end

function var0_0.SetTag(arg0_2, arg1_2)
	arg1_2.tag = IslandConst.TAG_PLAYER
end

function var0_0.AddComponents(arg0_3, arg1_3, arg2_3)
	arg1_3:GetComponent(typeof(WorldObjectItem)).isPlayer = true

	local var0_3 = GetOrAddComponent(arg1_3, typeof(CharacterController))

	var0_3.slopeLimit = 50
	var0_3.stepOffset = 0.3
	var0_3.stepOffset = 0.08
	var0_3.minMoveDistance = 0
	var0_3.height = 1.76
	var0_3.stepOffset = 0.4
	var0_3.center = Vector3(0, 0.96, 0)

	GetOrAddComponent(arg1_3, typeof(CharacterHandleController))
	GetOrAddComponent(arg1_3, typeof(CharacterFootprintMgr))
end

function var0_0.LoadAsset(arg0_4, arg1_4, arg2_4)
	local var0_4 = arg1_4.modelId

	arg0_4:GetPoolMgr():GetCommanderModel({
		model = arg1_4:GetAssetPath(),
		animator = arg1_4:GetAnimator()
	}, arg2_4)
end

function var0_0.LoadOtherPart(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)
	seriesAsync({
		function(arg0_6)
			local var0_6 = IslandAssetLoadDispatcher.Instance:Enqueue("island/jumpcurve/jumpcurve", "", typeof(JumpCurve), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_7)
				arg2_5:InitJump(arg0_7.curve)
				arg0_6()
			end), true, true)

			arg0_5:AddLoadingID(var0_6)
		end,
		function(arg0_8)
			local var0_8 = IslandShipDressHelperNew.New()

			arg2_5:SetShipDressHelper(var0_8)
			var0_8:PreLoadShipDressupItem(arg1_5, 0, arg0_8)
		end
	}, function()
		existCall(arg4_5)
	end)
end

function var0_0.Recycle(arg0_10, arg1_10, arg2_10)
	arg0_10:GetPoolMgr():ReturnCommanderModel(arg2_10)
end

return var0_0
