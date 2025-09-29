local var0_0 = class("IslandSystemDelegationUnitBuilder", import(".IslandSystemNpcBuilder"))

function var0_0.GetModule(arg0_1, arg1_1, arg2_1)
	return IslandSystemDelegationUnit.New(arg1_1, arg2_1)
end

function var0_0.SetTag(arg0_2, arg1_2)
	arg1_2.tag = IslandConst.TAG_NPC
end

function var0_0.AddComponents(arg0_3, arg1_3, arg2_3)
	local var0_3 = GetOrAddComponent(arg1_3, typeof(CharacterController))

	var0_3.slopeLimit = 50
	var0_3.stepOffset = 0.3
	var0_3.stepOffset = 0.08
	var0_3.minMoveDistance = 0
	var0_3.height = 1.76
	var0_3.stepOffset = 0.4
	var0_3.center = Vector3(0, 0.96, 0)

	GetOrAddComponent(arg1_3, typeof(CharacterHandleController))
end

function var0_0.LoadOtherPart(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4)
	if arg3_4.type == IslandConst.UNIT_TYPE_SYSTEM_DELEAGTION_ANIMATION then
		arg4_4()

		return
	end

	local var0_4 = arg3_4.id
	local var1_4 = arg3_4.isChicken

	if var0_4 == 1 or var1_4 then
		arg4_4()

		return
	end

	seriesAsync({
		function(arg0_5)
			local var0_5 = arg0_4.view:GetIsland()
			local var1_5 = IslandShipDressHelperNew.New(var0_5)

			arg2_4:SetShipDressHelper(var1_5)
			var1_5:PreLoadShipDressupItem(arg1_4, var0_4, arg0_5)
		end
	}, function()
		existCall(arg4_4)
	end)
end

return var0_0
