local var0_0 = class("BackYardInteractionPreview")
local var1_0 = 0.5

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.container = arg1_1
	arg0_1.initPosition = arg2_1
end

function var0_0.Flush(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2)
	if arg0_2.furnitureId == arg2_2 and arg0_2.shipSkinId == arg1_2 then
		return
	end

	arg0_2.scale = arg3_2 or 1

	if arg4_2 then
		arg0_2.position = Vector3(arg4_2[1], arg4_2[2], 0)
	else
		arg0_2.position = arg0_2.initPosition
	end

	arg0_2:StartLoad(arg1_2, arg2_2)

	arg0_2.shipSkinId = arg1_2
	arg0_2.furnitureId = arg2_2
end

function var0_0.StartLoad(arg0_3, arg1_3, arg2_3)
	arg0_3:UnloadSpines()
	pg.UIMgr.GetInstance():LoadingOn()
	seriesAsync({
		function(arg0_4)
			arg0_3:LoadFurniture(arg2_3, arg0_4)
		end,
		function(arg0_5)
			arg0_3:LoadShip(arg1_3, arg0_5)
		end,
		function(arg0_6)
			arg0_3:StartInteraction(arg2_3, arg1_3, arg0_6)
		end
	}, function()
		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

function var0_0.LoadShip(arg0_8, arg1_8, arg2_8)
	local var0_8 = pg.ship_skin_template[arg1_8].prefab

	pg.PoolMgr.GetInstance():GetSpineChar(var0_8, true, function(arg0_9)
		if arg0_8.loadedAnimator then
			setParent(arg0_9, arg0_8.loadedAnimator)
		else
			setParent(arg0_9, arg0_8.loadedFurniture)
		end

		arg0_9.name = var0_8
		arg0_9.transform.localScale = Vector3(var1_0, var1_0, 1)
		arg0_8.loadedShip = arg0_9
		arg0_9.transform.localPosition = Vector3()

		arg2_8()
	end)
end

function var0_0.LoadFurniture(arg0_10, arg1_10, arg2_10)
	local var0_10 = pg.furniture_data_template
	local var1_10 = var0_10[arg1_10].spine[1][1]
	local var2_10

	if var0_10[arg1_10].spine[2] then
		var2_10 = var0_10[arg1_10].spine[2][1]
	end

	local var3_10

	if var0_10[arg1_10].animator and var0_10[arg1_10].animator[1] then
		var3_10 = var0_10[arg1_10].animator[1][1]
	end

	seriesAsync({
		function(arg0_11)
			arg0_10:LoadRes("sfurniture/" .. var1_10, function(arg0_12)
				setParent(arg0_12, arg0_10.container)

				arg0_10.loadedFurniture = arg0_12

				arg0_10:AdjustTranform(arg0_12)
				arg0_11()
			end)
		end,
		function(arg0_13)
			if not var3_10 then
				arg0_13()

				return
			end

			arg0_10:LoadRes("sfurniture/" .. var3_10, function(arg0_14)
				setActive(arg0_14, false)
				setParent(arg0_14, arg0_10.loadedFurniture)

				arg0_10.loadedAnimator = arg0_14

				arg0_13()
			end)
		end,
		function(arg0_15)
			if not var2_10 then
				arg0_15()

				return
			end

			arg0_10:LoadRes("sfurniture/" .. var2_10, function(arg0_16)
				setParent(arg0_16, arg0_10.container)

				arg0_10.loadedFurnitureMask = arg0_16

				arg0_10:AdjustTranform(arg0_16)
				arg0_15()
			end)
		end
	}, arg2_10)
end

function var0_0.AdjustTranform(arg0_17, arg1_17)
	arg1_17.transform.localScale = Vector3(arg0_17.scale, arg0_17.scale, 1)
	arg1_17.transform.localPosition = arg0_17.position
end

function var0_0.StartInteraction(arg0_18, arg1_18, arg2_18, arg3_18)
	local var0_18 = pg.furniture_data_template[arg1_18].spine[3][2]
	local var1_18 = pg.furniture_data_template[arg1_18].spine_action_replace
	local var2_18 = {}
	local var3_18 = {}

	for iter0_18, iter1_18 in ipairs(var0_18) do
		local var4_18
		local var5_18

		if type(iter1_18) == "string" then
			var5_18, var4_18 = iter1_18, iter1_18
		elseif type(iter1_18) == "table" then
			var5_18, var4_18 = iter1_18[1], iter1_18[3] or iter1_18[1]
		end

		local var6_18, var7_18 = arg0_18:GetReplaceAction(var1_18, arg2_18, var5_18, var4_18)

		table.insert(var2_18, var6_18)
		table.insert(var3_18, var7_18)
	end

	arg0_18:StartActions(arg1_18, var2_18, var3_18)
	arg3_18()
end

function var0_0.GetReplaceAction(arg0_19, arg1_19, arg2_19, arg3_19, arg4_19)
	if not arg1_19 or arg1_19 == "" or #arg1_19 == 0 then
		return arg3_19, arg4_19
	end

	local var0_19 = _.detect(arg1_19, function(arg0_20)
		return _.any(arg0_20[2], function(arg0_21)
			return arg0_21 == arg2_19
		end) and arg4_19 == arg0_20[1] and arg0_20[5] == 1
	end)

	if var0_19 then
		local var1_19 = var0_19[4] or 0

		if var1_19 == 0 then
			return var0_19[3], var0_19[3]
		elseif var1_19 == 1 then
			return arg3_19, var0_19[3]
		elseif var1_19 == 2 then
			return var0_19[3], arg4_19
		end
	else
		return arg3_19, arg4_19
	end
end

function var0_0.StartActions(arg0_22, arg1_22, arg2_22, arg3_22)
	local var0_22 = 1
	local var1_22 = 0
	local var2_22

	local function var3_22()
		var1_22 = var1_22 + 1

		if var1_22 == 3 then
			var1_22, var0_22 = 0, var0_22 + 1

			var2_22(var0_22)
		end
	end

	function var2_22(arg0_24)
		if arg0_24 > #arg2_22 then
			if arg0_22.loadedAnimator then
				setActive(arg0_22.loadedAnimator, false)
			end

			return
		end

		local var0_24 = arg2_22[arg0_24]
		local var1_24 = arg3_22[arg0_24]

		arg0_22:PlayAction(arg0_22.loadedFurniture.transform:Find("spine"), var0_24, var3_22)

		if arg0_22.loadedFurnitureMask then
			arg0_22:PlayAction(arg0_22.loadedFurniture.transform:Find("spine"), var0_24, var3_22)
		else
			var3_22()
		end

		arg0_22:PlayAction(arg0_22.loadedShip, var1_24, var3_22)
	end

	var2_22(var0_22)

	if arg0_22.loadedAnimator then
		setActive(arg0_22.loadedAnimator, true)
	else
		arg0_22:StartFollowBone(arg1_22)
	end
end

function var0_0.StartFollowBone(arg0_25, arg1_25)
	local var0_25 = pg.furniture_data_template[arg1_25].followBone

	if not var0_25 then
		return
	end

	local var1_25 = var0_25[1]
	local var2_25 = var0_25[2]
	local var3_25 = arg0_25.loadedFurniture.transform

	arg0_25.loadedShip.transform.localScale = Vector3(var2_25 * var1_0, var1_0, 1)
	SpineAnimUI.AddFollower(var1_25, var3_25:Find("spine"), arg0_25.loadedShip.transform):GetComponent("Spine.Unity.BoneFollowerGraphic").followLocalScale = true
	arg0_25.loadedShip.transform.localPosition = Vector3(0, 0, 0)
end

function var0_0.PlayAction(arg0_26, arg1_26, arg2_26, arg3_26)
	local var0_26 = GetOrAddComponent(arg1_26, typeof(SpineAnimUI))

	var0_26:SetActionCallBack(function(arg0_27)
		if arg0_27 == "finish" then
			var0_26:SetActionCallBack(nil)
			arg3_26()
		end
	end)
	var0_26:SetAction(arg2_26, 0)
end

function var0_0.UnloadSpines(arg0_28)
	if not IsNil(arg0_28.loadedShip) then
		pg.PoolMgr.GetInstance():ReturnSpineChar(arg0_28.loadedShip.name, arg0_28.loadedShip)
	end

	if not IsNil(arg0_28.loadedAnimator) then
		Object.Destroy(arg0_28.loadedAnimator)
	end

	if not IsNil(arg0_28.loadedFurniture) then
		Object.Destroy(arg0_28.loadedFurniture)
	end

	if not IsNil(arg0_28.loadedFurnitureMask) then
		Object.Destroy(arg0_28.loadedFurnitureMask)
	end

	arg0_28.shipSkinId = nil
	arg0_28.furnitureId = nil
end

function var0_0.Dispose(arg0_29)
	arg0_29:UnloadSpines()
end

function var0_0.LoadRes(arg0_30, arg1_30, arg2_30)
	ResourceMgr.Inst:getAssetAsync(arg1_30, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_31)
		arg2_30(Instantiate(arg0_31))
	end), true, true)
end

return var0_0
