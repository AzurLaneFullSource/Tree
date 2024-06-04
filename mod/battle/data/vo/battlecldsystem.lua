ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleFormulas
local var2 = var0.Battle.BattleConst
local var3 = Vector3.zero
local var4 = var2.OXY_STATE
local var5 = var2.BulletType
local var6 = var0.Battle.BattleAttr
local var7 = class("BattleCldSystem")

var0.Battle.BattleCldSystem = var7
var7.__name = "BattleCldSystem"

function var7.Ctor(arg0, arg1)
	arg0._proxy = arg1

	arg0:InitCldTree()

	arg0._friendlyCode = arg1:GetFriendlyCode()
	arg0._foeCode = arg1:GetFoeCode()
end

function var7.Dispose(arg0)
	arg0._proxy = nil
	arg0._shipTree = nil
	arg0._foeShipTree = nil
	arg0._aircraftTree = nil
	arg0._surfaceBulletTree = nil
	arg0._airBulletTree = nil
	arg0._bulletTreeList = nil
	arg0._foeSurafceBulletTree = nil
	arg0._foeAirbulletTree = nil
	arg0._foeBulleetTreeList = nil
	arg0._surfaceAOETree = nil
	arg0._airAOETree = nil
	arg0._AOETreeList = nil
	arg0._wallTree = nil
end

function var7.InitCldTree(arg0)
	local var0, var1, var2, var3 = arg0._proxy:GetTotalBounds()
	local var4 = Vector3(var2, 0, var1)
	local var5 = Vector3(var3, 0, var0)

	arg0._shipTree = pg.ColliderTree.New("shipTree", var4, var5, 2)
	arg0._foeShipTree = pg.ColliderTree.New("foeShipTree", var4, var5, 2)
	arg0._aircraftTree = pg.ColliderTree.New("aircraftTree", var4, var5, 2)
	arg0._surfaceBulletTree = pg.ColliderTree.New("surfaceBullets", var4, var5, 4)
	arg0._airBulletTree = pg.ColliderTree.New("airBullets", var4, var5, 3)
	arg0._bulletTreeList = {}
	arg0._bulletTreeList[var2.BulletField.SURFACE] = arg0._surfaceBulletTree
	arg0._bulletTreeList[var2.BulletField.AIR] = arg0._airBulletTree
	arg0._foeSurafceBulletTree = pg.ColliderTree.New("foeSurfaceBullets", var4, var5, 3)
	arg0._foeAirbulletTree = pg.ColliderTree.New("foeAirBullets", var4, var5, 3)
	arg0._foeBulleetTreeList = {}
	arg0._foeBulleetTreeList[var2.BulletField.SURFACE] = arg0._foeSurafceBulletTree
	arg0._foeBulleetTreeList[var2.BulletField.AIR] = arg0._foeAirbulletTree
	arg0._surfaceAOETree = pg.ColliderTree.New("surfaceAOE", var4, var5, 2)
	arg0._airAOETree = pg.ColliderTree.New("airAOE", var4, var5, 2)
	arg0._bulletAOETree = pg.ColliderTree.New("bulletAOE", var4, var5, 2)
	arg0._AOETreeList = {}
	arg0._AOETreeList[var2.AOEField.SURFACE] = arg0._surfaceAOETree
	arg0._AOETreeList[var2.AOEField.AIR] = arg0._airAOETree
	arg0._AOETreeList[var2.AOEField.BULLET] = arg0._bulletAOETree
	arg0._wallTree = pg.ColliderTree.New("wall", var4, var5, 2)
end

function var7.UpdateShipCldTree(arg0, arg1)
	local var0 = arg1:GetSpeed()
	local var1 = arg1:GetCldBox()
	local var2
	local var3 = not var6.IsUnitCldImmune(arg1)

	if arg1:GetIFF() == arg0._foeCode then
		if var3 then
			if arg1:GetCldData().FriendlyCld then
				local var4 = arg0._foeShipTree:GetCldList(var1, var0)

				arg1:GetCldData().distList = {}

				if #var4 > 1 then
					arg0:HandleEnemyShipCld(var4, arg1)
				end
			end

			local var5 = arg0._shipTree:GetCldList(var1, var0)
			local var6 = arg0.surfaceFilterCount(arg1, var5)

			arg0._proxy:HandleShipCrashDecelerate(arg1, var6)
			arg0:HandlePlayerShipCld(var5, arg1)
		end

		var2 = arg0._foeShipTree
	elseif arg1:GetIFF() == arg0._friendlyCode then
		if var3 then
			local var7 = arg0._foeShipTree:GetCldList(var1, var0)
			local var8 = arg0.surfaceFilterCount(arg1, var7)

			arg0._proxy:HandleShipCrashDecelerate(arg1, var8)
		end

		var2 = arg0._shipTree
	end

	var2:Update(var1)
end

function var7.HandlePlayerShipCld(arg0, arg1, arg2)
	local var0 = arg2:GetCldData()

	if var0.Active == false or var0.ImmuneCLD == true then
		return
	end

	local var1 = #arg1
	local var2 = {}

	for iter0 = 1, var1 do
		local var3 = arg1[iter0].data

		if var3.Active == false or var3.ImmuneCLD == true then
			-- block empty
		elseif var3.UID == arg2:GetUniqueID() then
			-- block empty
		elseif var0.IFF == var3.IFF then
			-- block empty
		elseif var0.Surface ~= var3.Surface then
			-- block empty
		else
			var2[#var2 + 1] = var3.UID
		end
	end

	arg0._proxy:HandleShipCrashDamageList(arg2, var2)
end

function var7.HandleEnemyShipCld(arg0, arg1, arg2)
	local var0 = arg2:GetCldData()

	if var0.Active == false or var0.ImmuneCLD == true then
		return
	end

	local var1 = arg2:GetPosition()
	local var2 = {}
	local var3 = #arg1

	for iter0 = 1, var3 do
		local var4 = arg1[iter0].data

		if var4.Active == false or var4.ImmuneCLD == true then
			-- block empty
		elseif var4.UID == arg2:GetUniqueID() then
			-- block empty
		elseif var0.IFF ~= var4.IFF then
			-- block empty
		elseif not var4.FriendlyCld then
			-- block empty
		elseif var0.Surface ~= var4.Surface then
			-- block empty
		else
			local var5 = var1 - arg0:GetShip(var4.UID):GetPosition()

			var2[#var2 + 1] = var5
		end
	end

	var0.distList = var2
end

function var7.surfaceFilterCount(arg0, arg1)
	local var0 = arg0:GetCldData()
	local var1 = 0
	local var2 = #arg1

	for iter0 = 1, var2 do
		local var3 = arg1[iter0].data

		if var3.Active == true and var3.ImmuneCLD == false and var3.UID ~= arg0:GetUniqueID() and var0.IFF ~= var3.IFF and var0.Surface == var3.Surface then
			var1 = var1 + 1
		end
	end

	return var1
end

function var7.UpdateAircraftCld(arg0, arg1)
	local var0 = arg1:GetSpeed()
	local var1 = arg1:GetCldBox()
	local var2

	if arg1:GetIFF() == arg0._foeCode then
		var2 = arg0:GetBulletTree(var2.BulletField.AIR)
	elseif arg1:GetIFF() == arg0._friendlyCode then
		var2 = arg0:GetFoeBulletTree(var2.BulletField.AIR)
	end

	local var3 = var2:GetCldList(var1, var0)

	arg0:HandleBulletCldWithAircraft(var3, arg1)
	arg0._aircraftTree:Update(arg1:GetCldBox())
end

function var7.HandleBulletCldWithAircraft(arg0, arg1, arg2)
	local var0 = #arg1

	for iter0 = 1, var0 do
		local var1 = arg1[iter0].data

		if var1.type == var2.CldType.BULLET and var1.Active == true and var1.ImmuneCLD == false then
			local var2 = arg0:GetBullet(var1.UID)

			arg0._proxy:HandleBulletHit(var2, arg2)
		end
	end
end

function var7.UpdateBulletCld(arg0, arg1)
	local var0 = arg1:GetEffectField()
	local var1 = arg1:GetCldBox()
	local var2 = arg1:GetCldData().IFF
	local var3
	local var4

	if var0 == var2.BulletField.SURFACE then
		local var5 = var2 == arg0._foeCode and arg0._shipTree or arg0._foeShipTree
		local var6 = arg0:getBulletCldShipList(arg1, var5)

		if arg1:IsIndiscriminate() then
			local var7 = var5 == arg0._shipTree and arg0._foeShipTree or arg0._shipTree
			local var8 = arg0:getBulletCldShipList(arg1, var7)

			for iter0, iter1 in ipairs(var8) do
				table.insert(var6, iter1)
			end
		end

		arg0:HandleBulletCldWithShip(var6, arg1)
	end

	if var2 == arg0._friendlyCode then
		var3 = arg0:GetBulletTree(var0)
	elseif var2 == arg0._foeCode then
		var3 = arg0:GetFoeBulletTree(var0)
	end

	var3:Update(var1)
end

function var7.getBulletCldShipList(arg0, arg1, arg2)
	local var0 = arg1:GetCldBox()
	local var1

	if arg1:GetType() == var2.BulletType.SCALE then
		local var2, var3, var4 = arg1:GetRadian()

		if math.abs(var3) ~= 1 then
			if arg1:GetIFF() == -1 then
				var2 = var2 + math.pi
			end

			local var5 = arg1:GetBoxSize()
			local var6 = var5.x * 2
			local var7 = var5.z * 2
			local var8 = arg1:GetPosition()
			local var9 = var5.x
			local var10 = var9 * var3
			local var11 = var9 * var4
			local var12 = Vector3(var8.x - var10, 1, var8.z - var11)

			var1 = arg2:GetCldListGradient(var2, var7, var6, var12)
		else
			var1 = arg2:GetCldList(var0, var3)
		end
	else
		var1 = arg2:GetCldList(var0, var3)
	end

	return var1
end

function var7.HandleBulletCldWithShip(arg0, arg1, arg2)
	local var0 = #arg1
	local var1 = arg2:GetType()

	for iter0 = 1, var0 do
		local var2 = arg1[iter0].data

		if var2.type == var2.CldType.SHIP and var2.Active == true and var2.ImmuneCLD == false then
			local var3 = arg0:GetShip(var2.UID)
			local var4 = var3:GetCurrentOxyState()
			local var5 = var3:IsImmuneCommonBulletCLD()

			if var4 == var4.DIVE and arg2:GetCldData().Surface ~= var2.OXY_STATE.DIVE then
				-- block empty
			elseif var5 then
				-- block empty
			elseif arg0._proxy:HandleBulletHit(arg2, var3) then
				break
			end
		end
	end
end

function var7.UpdateAOECld(arg0, arg1)
	local var0 = arg1:GetCldBox()
	local var1 = arg1:GetFieldType()
	local var2 = arg1:OpponentAffected()
	local var3 = arg1:GetCldData().IFF
	local var4 = var2 and var3 * -1 or var3
	local var5

	if var1 == var2.AOEField.SURFACE then
		local var6 = arg1:GetCldData().IFF == arg0._foeCode
		local var7 = arg1:OpponentAffected() == var6 and arg0._shipTree or arg0._foeShipTree
		local var8 = arg0:getAreaCldShipList(arg1, var7)

		if arg1:GetIndiscriminate() then
			local var9 = var7 == arg0._shipTree and arg0._foeShipTree or arg0._shipTree
			local var10 = arg0:getAreaCldShipList(arg1, var9)

			for iter0, iter1 in ipairs(var10) do
				table.insert(var8, iter1)
			end
		end

		arg0:HandleAreaCldWithVehicle(arg1, var8)
	elseif var1 == var2.AOEField.BULLET then
		local var11

		if var4 == arg0._foeCode then
			var11 = arg0._foeSurafceBulletTree
		else
			var11 = arg0._surfaceBulletTree
		end

		local var12 = var11:GetCldList(var0, var3)

		arg1:ClearCLDList()
		arg0:HandleAreaCldWithBullet(arg1, var12)
	else
		local var13 = {}
		local var14 = arg0._aircraftTree:GetCldList(var0, var3)

		for iter2, iter3 in ipairs(var14) do
			if iter3.data.IFF == var4 then
				table.insert(var13, iter3)
			end
		end

		arg0:HandleAreaCldWithAircraft(arg1, var13)
	end
end

function var7.getAreaCldShipList(arg0, arg1, arg2)
	local var0

	if arg1:GetAreaType() == var2.AreaType.COLUMN or arg1:GetAnchorPointAlignment() == Vector3.zero then
		local var1 = arg1:GetCldBox()

		var0 = arg2:GetCldList(var1, var3)
	else
		local var2 = arg1:GetCldData().IFF == arg0._foeCode
		local var3 = arg1:GetAngle() * math.deg2Rad

		if var2 then
			var3 = var3 + math.pi
		end

		local var4 = arg1:GetWidth()
		local var5 = arg1:GetHeight()
		local var6 = arg1:GetPosition()

		var0 = arg2:GetCldListGradient(var3, var5, var4, var6)
	end

	return var0
end

function var7.HandleAreaCldWithVehicle(arg0, arg1, arg2)
	arg1:ClearCLDList()

	local var0 = arg1:GetCldData()
	local var1 = arg1:OpponentAffected()
	local var2 = #arg2

	for iter0 = 1, var2 do
		local var3 = arg2[iter0].data

		if var3.Active == true and var3.ImmuneCLD == false then
			local var4 = arg1:GetDiveFilter()
			local var5 = arg0:GetShip(var3.UID)
			local var6 = true

			if var4 then
				local var7 = var5:GetCurrentOxyState()

				if table.contains(var4, var7) then
					var6 = false
				end
			end

			if var6 and not arg1:IsOutOfAngle(var5) then
				arg1:AppendCldObj(var3)
			end
		end
	end
end

function var7.HandleAreaCldWithAircraft(arg0, arg1, arg2)
	arg1:ClearCLDList()

	local var0 = arg1:GetCldData()
	local var1 = arg1:OpponentAffected()
	local var2 = #arg2

	for iter0 = 1, var2 do
		local var3 = arg2[iter0].data

		if var1 == (var3.IFF ~= var0.IFF) then
			arg1:AppendCldObj(var3)
		end
	end
end

function var7.HandleAreaCldWithBullet(arg0, arg1, arg2)
	local var0 = #arg2

	for iter0 = 1, var0 do
		local var1 = arg2[iter0].data

		arg1:AppendCldObj(var1)
	end
end

function var7.UpdateWallCld(arg0, arg1)
	local var0 = arg1:GetCldBox()
	local var1 = arg1:GetCldObjType()

	if var1 == arg1.CLD_OBJ_TYPE_BULLET then
		local var2

		if arg1:GetIFF() == arg0._friendlyCode then
			var2 = arg0._foeSurafceBulletTree:GetCldList(var0, var3)
		else
			var2 = arg0._surfaceBulletTree:GetCldList(var0, var3)
		end

		arg0:HandleWallCldWithBullet(arg1, var2)
	elseif var1 == arg1.CLD_OBJ_TYPE_SHIP then
		local var3

		if arg1:GetIFF() == arg0._friendlyCode then
			var3 = arg0._foeShipTree:GetCldList(var0, var3)
		else
			var3 = arg0._shipTree:GetCldList(var0, var3)
		end

		arg0:HandleWllCldWithShip(arg1, var3)
	end
end

function var7.HandleWallCldWithBullet(arg0, arg1, arg2)
	local var0 = #arg2

	for iter0 = 1, var0 do
		local var1 = arg2[iter0].data

		if var1.type == var2.CldType.BULLET and var1.Active == true and var1.ImmuneCLD == false then
			local var2 = arg0:GetBullet(var1.UID)

			if not arg0._proxy:HandleWallHitByBullet(arg1, var2) then
				return
			end
		end
	end
end

function var7.HandleWllCldWithShip(arg0, arg1, arg2)
	local var0 = #arg2
	local var1 = {}

	for iter0 = 1, var0 do
		local var2 = arg2[iter0].data

		if var2.type == var2.CldType.SHIP and var2.Active == true and var2.ImmuneCLD == false then
			local var3 = arg0:GetShip(var2.UID)

			if var3:GetCurrentOxyState() == var4.DIVE then
				-- block empty
			else
				table.insert(var1, var3)
			end
		end
	end

	arg0._proxy:HandleWallHitByShip(arg1, var1)
end

function var7.InsertToBulletCldTree(arg0, arg1, arg2)
	local var0
	local var1 = arg2:GetCldData()

	if var1.IFF == arg0._foeCode then
		var0 = arg0:GetFoeBulletTree(arg1)
	elseif var1.IFF == arg0._friendlyCode then
		var0 = arg0:GetBulletTree(arg1)
	end

	local var2 = arg2:GetCldBox()

	var0:Insert(var2)
end

function var7.InsertToAOECldTree(arg0, arg1, arg2)
	local var0 = arg0:GetAOETree(arg1)
	local var1 = arg2:GetCldBox()

	var0:Insert(var1)
end

function var7.InsertToWallCldTree(arg0, arg1)
	local var0 = arg0:GetWallTree()
	local var1 = arg1:GetCldBox()

	var0:Insert(var1)
end

function var7.InsertToShipCldTree(arg0, arg1)
	local var0 = arg1:GetCldData()
	local var1

	if var0.IFF == arg0._foeCode then
		var1 = arg0:GetFoeShipTree()
	elseif var0.IFF == arg0._friendlyCode then
		var1 = arg0:GetShipTree()
	end

	local var2 = arg1:GetCldBox()

	var1:Insert(var2)
end

function var7.InsertToAircraftCldTree(arg0, arg1)
	local var0 = arg1:GetCldBox()

	arg0._aircraftTree:Insert(var0)
end

function var7.GetBulletTree(arg0, arg1)
	return arg0._bulletTreeList[arg1]
end

function var7.GetFoeBulletTree(arg0, arg1)
	return arg0._foeBulleetTreeList[arg1]
end

function var7.GetAOETree(arg0, arg1)
	return arg0._AOETreeList[arg1]
end

function var7.GetWallTree(arg0, arg1)
	return arg0._wallTree
end

function var7.GetShipTree(arg0)
	return arg0._shipTree
end

function var7.GetFoeShipTree(arg0)
	return arg0._foeShipTree
end

function var7.GetAircraftTree(arg0)
	return arg0._aircraftTree
end

function var7.DeleteShipLeaf(arg0, arg1)
	local var0 = arg1:GetCldData().IFF

	if var0 == arg0._foeCode then
		arg0.DeleteCldLeaf(arg0:GetFoeShipTree(), arg1)
	elseif var0 == arg0._friendlyCode then
		arg0.DeleteCldLeaf(arg0:GetShipTree(), arg1)
	end
end

function var7.DeleteBulletLeaf(arg0, arg1)
	local var0 = arg1:GetCldData().IFF

	if var0 == arg0._foeCode then
		arg0.DeleteCldLeaf(arg0:GetFoeBulletTree(arg1:GetEffectField()), arg1)
	elseif var0 == arg0._friendlyCode then
		arg0.DeleteCldLeaf(arg0:GetBulletTree(arg1:GetEffectField()), arg1)
	end
end

function var7.DeleteCldLeaf(arg0, arg1)
	local var0 = arg1:GetCldBox()

	arg0:Remove(var0)
end

function var7.GetShip(arg0, arg1)
	return arg0._proxy:GetUnitList()[arg1]
end

function var7.GetAircraft(arg0, arg1)
	return arg0._proxy:GetAircraftList()[arg1]
end

function var7.GetBullet(arg0, arg1)
	return arg0._proxy:GetBulletList()[arg1]
end

function var7.GetAOE(arg0, arg1)
	return arg0._proxy:GetAOEList()[arg1]
end

function var7.InitShipCld(arg0, arg1)
	arg0:InsertToShipCldTree(arg1)
end

function var7.DeleteShipCld(arg0, arg1)
	arg1:DeactiveCldBox()
	arg0:DeleteShipLeaf(arg1)
end

function var7.InitAircraftCld(arg0, arg1)
	arg0:InsertToAircraftCldTree(arg1)
end

function var7.DeleteAircraftCld(arg0, arg1)
	arg1:DeactiveCldBox()
	arg0.DeleteCldLeaf(arg0:GetAircraftTree(), arg1)
end

function var7.InitBulletCld(arg0, arg1)
	arg0:InsertToBulletCldTree(arg1:GetEffectField(), arg1)
end

function var7.DeleteBulletCld(arg0, arg1)
	arg1:DeactiveCldBox()
	arg0:DeleteBulletLeaf(arg1)
end

function var7.ShiftBulletCld(arg0, arg1)
	return
end

function var7.InitAOECld(arg0, arg1)
	arg0:InsertToAOECldTree(arg1:GetFieldType(), arg1)
end

function var7.DeleteAOECld(arg0, arg1)
	arg1:DeactiveCldBox()
	arg0.DeleteCldLeaf(arg0:GetAOETree(arg1:GetFieldType()), arg1)
end

function var7.InitWallCld(arg0, arg1)
	arg0:InsertToWallCldTree(arg1)
end

function var7.DeleteWallCld(arg0, arg1)
	arg1:DeactiveCldBox()

	local var0 = arg0:GetWallTree()

	if var0 then
		arg0.DeleteCldLeaf(var0, arg1)
	end
end
