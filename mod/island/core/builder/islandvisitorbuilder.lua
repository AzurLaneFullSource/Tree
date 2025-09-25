local var0_0 = class("IslandVisitorBuilder", import(".IslandCharUnitBuilder"))

function var0_0.GetModule(arg0_1, arg1_1, arg2_1)
	return IslandVisitorUnit.New(arg1_1, arg2_1)
end

function var0_0.SetTag(arg0_2, arg1_2)
	return
end

function var0_0.SetupBT(arg0_3, arg1_3, arg2_3, arg3_3)
	arg3_3()
end

function var0_0.AddComponents(arg0_4, arg1_4, arg2_4)
	var0_0.super.AddComponents(arg0_4, arg1_4, arg2_4)

	local var0_4 = GetOrAddComponent(arg1_4, typeof(CharacterController))

	var0_4.slopeLimit = 50
	var0_4.stepOffset = 0.3
	var0_4.stepOffset = 0.08
	var0_4.minMoveDistance = 0
	var0_4.height = 1.76
	var0_4.stepOffset = 0.4
	var0_4.center = Vector3(0, 0.96, 0)

	GetOrAddComponent(arg1_4, typeof(CharacterHandleController))

	arg1_4.name = "Visitor_" .. arg2_4.id
end

function var0_0.LoadOtherPart(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)
	seriesAsync({
		function(arg0_6)
			local var0_6 = IslandShipDressHelperNew.New()

			arg2_5:SetShipDressHelper(var0_6)

			local var1_6 = arg3_5.id
			local var2_6 = getProxy(PlayerProxy):getRawData().id == arg3_5.islandId

			var0_6:PreLoadVisterDressupItem(arg1_5, var1_6, var2_6, arg0_6)
		end
	}, function()
		existCall(arg4_5)
	end)
end

function var0_0.Load(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg1_8:GetBehaviourTree()
	local var1_8 = arg1_8.id
	local var2_8 = getProxy(PlayerProxy):getRawData().id == arg1_8.islandId

	arg0_8:GetPoolMgr():GetCommanderModel({
		model = arg1_8:GetAssetPath(),
		animator = arg1_8:GetAnimator()
	}, arg2_8, var1_8, var2_8, var0_8)
end

function var0_0.Recycle(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg1_9:GetBehaviourTree()

	arg0_9:GetPoolMgr():ReturnCommanderModel(arg2_9, var0_9)
end

return var0_0
