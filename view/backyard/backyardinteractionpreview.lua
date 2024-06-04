local var0 = class("BackYardInteractionPreview")
local var1 = 0.5

function var0.Ctor(arg0, arg1, arg2)
	arg0.container = arg1
	arg0.initPosition = arg2
end

function var0.Flush(arg0, arg1, arg2, arg3, arg4)
	if arg0.furnitureId == arg2 and arg0.shipSkinId == arg1 then
		return
	end

	arg0.scale = arg3 or 1

	if arg4 then
		arg0.position = Vector3(arg4[1], arg4[2], 0)
	else
		arg0.position = arg0.initPosition
	end

	arg0:StartLoad(arg1, arg2)

	arg0.shipSkinId = arg1
	arg0.furnitureId = arg2
end

function var0.StartLoad(arg0, arg1, arg2)
	arg0:UnloadSpines()
	pg.UIMgr.GetInstance():LoadingOn()
	seriesAsync({
		function(arg0)
			arg0:LoadFurniture(arg2, arg0)
		end,
		function(arg0)
			arg0:LoadShip(arg1, arg0)
		end,
		function(arg0)
			arg0:StartInteraction(arg2, arg1, arg0)
		end
	}, function()
		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

function var0.LoadShip(arg0, arg1, arg2)
	local var0 = pg.ship_skin_template[arg1].prefab

	pg.PoolMgr.GetInstance():GetSpineChar(var0, true, function(arg0)
		if arg0.loadedAnimator then
			setParent(arg0, arg0.loadedAnimator)
		else
			setParent(arg0, arg0.loadedFurniture)
		end

		arg0.name = var0
		arg0.transform.localScale = Vector3(var1, var1, 1)
		arg0.loadedShip = arg0
		arg0.transform.localPosition = Vector3()

		arg2()
	end)
end

function var0.LoadFurniture(arg0, arg1, arg2)
	local var0 = pg.furniture_data_template
	local var1 = var0[arg1].spine[1][1]
	local var2

	if var0[arg1].spine[2] then
		var2 = var0[arg1].spine[2][1]
	end

	local var3

	if var0[arg1].animator and var0[arg1].animator[1] then
		var3 = var0[arg1].animator[1][1]
	end

	seriesAsync({
		function(arg0)
			arg0:LoadRes("sfurniture/" .. var1, function(arg0)
				setParent(arg0, arg0.container)

				arg0.loadedFurniture = arg0

				arg0:AdjustTranform(arg0)
				arg0()
			end)
		end,
		function(arg0)
			if not var3 then
				arg0()

				return
			end

			arg0:LoadRes("sfurniture/" .. var3, function(arg0)
				setActive(arg0, false)
				setParent(arg0, arg0.loadedFurniture)

				arg0.loadedAnimator = arg0

				arg0()
			end)
		end,
		function(arg0)
			if not var2 then
				arg0()

				return
			end

			arg0:LoadRes("sfurniture/" .. var2, function(arg0)
				setParent(arg0, arg0.container)

				arg0.loadedFurnitureMask = arg0

				arg0:AdjustTranform(arg0)
				arg0()
			end)
		end
	}, arg2)
end

function var0.AdjustTranform(arg0, arg1)
	arg1.transform.localScale = Vector3(arg0.scale, arg0.scale, 1)
	arg1.transform.localPosition = arg0.position
end

function var0.StartInteraction(arg0, arg1, arg2, arg3)
	local var0 = pg.furniture_data_template[arg1].spine[3][2]
	local var1 = pg.furniture_data_template[arg1].spine_action_replace
	local var2 = {}
	local var3 = {}

	for iter0, iter1 in ipairs(var0) do
		local var4
		local var5

		if type(iter1) == "string" then
			var5, var4 = iter1, iter1
		elseif type(iter1) == "table" then
			var5, var4 = iter1[1], iter1[3] or iter1[1]
		end

		local var6, var7 = arg0:GetReplaceAction(var1, arg2, var5, var4)

		table.insert(var2, var6)
		table.insert(var3, var7)
	end

	arg0:StartActions(arg1, var2, var3)
	arg3()
end

function var0.GetReplaceAction(arg0, arg1, arg2, arg3, arg4)
	if not arg1 or arg1 == "" or #arg1 == 0 then
		return arg3, arg4
	end

	local var0 = _.detect(arg1, function(arg0)
		return _.any(arg0[2], function(arg0)
			return arg0 == arg2
		end) and arg4 == arg0[1] and arg0[5] == 1
	end)

	if var0 then
		local var1 = var0[4] or 0

		if var1 == 0 then
			return var0[3], var0[3]
		elseif var1 == 1 then
			return arg3, var0[3]
		elseif var1 == 2 then
			return var0[3], arg4
		end
	else
		return arg3, arg4
	end
end

function var0.StartActions(arg0, arg1, arg2, arg3)
	local var0 = 1
	local var1 = 0
	local var2

	local function var3()
		var1 = var1 + 1

		if var1 == 3 then
			var1, var0 = 0, var0 + 1

			var2(var0)
		end
	end

	function var2(arg0)
		if arg0 > #arg2 then
			if arg0.loadedAnimator then
				setActive(arg0.loadedAnimator, false)
			end

			return
		end

		local var0 = arg2[arg0]
		local var1 = arg3[arg0]

		arg0:PlayAction(arg0.loadedFurniture.transform:Find("spine"), var0, var3)

		if arg0.loadedFurnitureMask then
			arg0:PlayAction(arg0.loadedFurniture.transform:Find("spine"), var0, var3)
		else
			var3()
		end

		arg0:PlayAction(arg0.loadedShip, var1, var3)
	end

	var2(var0)

	if arg0.loadedAnimator then
		setActive(arg0.loadedAnimator, true)
	else
		arg0:StartFollowBone(arg1)
	end
end

function var0.StartFollowBone(arg0, arg1)
	local var0 = pg.furniture_data_template[arg1].followBone

	if not var0 then
		return
	end

	local var1 = var0[1]
	local var2 = var0[2]
	local var3 = arg0.loadedFurniture.transform

	arg0.loadedShip.transform.localScale = Vector3(var2 * var1, var1, 1)
	SpineAnimUI.AddFollower(var1, var3:Find("spine"), arg0.loadedShip.transform):GetComponent("Spine.Unity.BoneFollowerGraphic").followLocalScale = true
	arg0.loadedShip.transform.localPosition = Vector3(0, 0, 0)
end

function var0.PlayAction(arg0, arg1, arg2, arg3)
	local var0 = GetOrAddComponent(arg1, typeof(SpineAnimUI))

	var0:SetActionCallBack(function(arg0)
		if arg0 == "finish" then
			var0:SetActionCallBack(nil)
			arg3()
		end
	end)
	var0:SetAction(arg2, 0)
end

function var0.UnloadSpines(arg0)
	if not IsNil(arg0.loadedShip) then
		pg.PoolMgr.GetInstance():ReturnSpineChar(arg0.loadedShip.name, arg0.loadedShip)
	end

	if not IsNil(arg0.loadedAnimator) then
		Object.Destroy(arg0.loadedAnimator)
	end

	if not IsNil(arg0.loadedFurniture) then
		Object.Destroy(arg0.loadedFurniture)
	end

	if not IsNil(arg0.loadedFurnitureMask) then
		Object.Destroy(arg0.loadedFurnitureMask)
	end

	arg0.shipSkinId = nil
	arg0.furnitureId = nil
end

function var0.Dispose(arg0)
	arg0:UnloadSpines()
end

function var0.LoadRes(arg0, arg1, arg2)
	ResourceMgr.Inst:getAssetAsync(arg1, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
		arg2(Instantiate(arg0))
	end), true, true)
end

return var0
