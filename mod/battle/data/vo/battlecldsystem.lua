ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleFormulas
local var2_0 = var0_0.Battle.BattleConst
local var3_0 = Vector3.zero
local var4_0 = var2_0.OXY_STATE
local var5_0 = var2_0.BulletType
local var6_0 = var0_0.Battle.BattleAttr
local var7_0 = class("BattleCldSystem")

var0_0.Battle.BattleCldSystem = var7_0
var7_0.__name = "BattleCldSystem"

function var7_0.Ctor(arg0_1, arg1_1)
	arg0_1._proxy = arg1_1

	arg0_1:InitCldTree()

	arg0_1._friendlyCode = arg1_1:GetFriendlyCode()
	arg0_1._foeCode = arg1_1:GetFoeCode()
end

function var7_0.Dispose(arg0_2)
	arg0_2._proxy = nil
	arg0_2._shipTree = nil
	arg0_2._foeShipTree = nil
	arg0_2._aircraftTree = nil
	arg0_2._surfaceBulletTree = nil
	arg0_2._airBulletTree = nil
	arg0_2._bulletTreeList = nil
	arg0_2._foeSurafceBulletTree = nil
	arg0_2._foeAirbulletTree = nil
	arg0_2._foeBulleetTreeList = nil
	arg0_2._surfaceAOETree = nil
	arg0_2._airAOETree = nil
	arg0_2._AOETreeList = nil
	arg0_2._wallTree = nil
end

function var7_0.InitCldTree(arg0_3)
	local var0_3, var1_3, var2_3, var3_3 = arg0_3._proxy:GetTotalBounds()
	local var4_3 = Vector3(var2_3, 0, var1_3)
	local var5_3 = Vector3(var3_3, 0, var0_3)

	arg0_3._shipTree = pg.ColliderTree.New("shipTree", var4_3, var5_3, 2)
	arg0_3._foeShipTree = pg.ColliderTree.New("foeShipTree", var4_3, var5_3, 2)
	arg0_3._aircraftTree = pg.ColliderTree.New("aircraftTree", var4_3, var5_3, 2)
	arg0_3._surfaceBulletTree = pg.ColliderTree.New("surfaceBullets", var4_3, var5_3, 4)
	arg0_3._airBulletTree = pg.ColliderTree.New("airBullets", var4_3, var5_3, 3)
	arg0_3._bulletTreeList = {}
	arg0_3._bulletTreeList[var2_0.BulletField.SURFACE] = arg0_3._surfaceBulletTree
	arg0_3._bulletTreeList[var2_0.BulletField.AIR] = arg0_3._airBulletTree
	arg0_3._foeSurafceBulletTree = pg.ColliderTree.New("foeSurfaceBullets", var4_3, var5_3, 3)
	arg0_3._foeAirbulletTree = pg.ColliderTree.New("foeAirBullets", var4_3, var5_3, 3)
	arg0_3._foeBulleetTreeList = {}
	arg0_3._foeBulleetTreeList[var2_0.BulletField.SURFACE] = arg0_3._foeSurafceBulletTree
	arg0_3._foeBulleetTreeList[var2_0.BulletField.AIR] = arg0_3._foeAirbulletTree
	arg0_3._surfaceAOETree = pg.ColliderTree.New("surfaceAOE", var4_3, var5_3, 2)
	arg0_3._airAOETree = pg.ColliderTree.New("airAOE", var4_3, var5_3, 2)
	arg0_3._bulletAOETree = pg.ColliderTree.New("bulletAOE", var4_3, var5_3, 2)
	arg0_3._AOETreeList = {}
	arg0_3._AOETreeList[var2_0.AOEField.SURFACE] = arg0_3._surfaceAOETree
	arg0_3._AOETreeList[var2_0.AOEField.AIR] = arg0_3._airAOETree
	arg0_3._AOETreeList[var2_0.AOEField.BULLET] = arg0_3._bulletAOETree
	arg0_3._wallTree = pg.ColliderTree.New("wall", var4_3, var5_3, 2)
end

function var7_0.UpdateShipCldTree(arg0_4, arg1_4)
	local var0_4 = arg1_4:GetSpeed()
	local var1_4 = arg1_4:GetCldBox()
	local var2_4
	local var3_4 = not var6_0.IsUnitCldImmune(arg1_4)

	if arg1_4:GetIFF() == arg0_4._foeCode then
		if var3_4 then
			if arg1_4:GetCldData().FriendlyCld then
				local var4_4 = arg0_4._foeShipTree:GetCldList(var1_4, var0_4)

				arg1_4:GetCldData().distList = {}

				if #var4_4 > 1 then
					arg0_4:HandleEnemyShipCld(var4_4, arg1_4)
				end
			end

			local var5_4 = arg0_4._shipTree:GetCldList(var1_4, var0_4)
			local var6_4 = arg0_4.surfaceFilterCount(arg1_4, var5_4)

			arg0_4._proxy:HandleShipCrashDecelerate(arg1_4, var6_4)
			arg0_4:HandlePlayerShipCld(var5_4, arg1_4)
		end

		var2_4 = arg0_4._foeShipTree
	elseif arg1_4:GetIFF() == arg0_4._friendlyCode then
		if var3_4 then
			local var7_4 = arg0_4._foeShipTree:GetCldList(var1_4, var0_4)
			local var8_4 = arg0_4.surfaceFilterCount(arg1_4, var7_4)

			arg0_4._proxy:HandleShipCrashDecelerate(arg1_4, var8_4)
		end

		var2_4 = arg0_4._shipTree
	end

	var2_4:Update(var1_4)
end

function var7_0.HandlePlayerShipCld(arg0_5, arg1_5, arg2_5)
	local var0_5 = arg2_5:GetCldData()

	if var0_5.Active == false or var0_5.ImmuneCLD == true then
		return
	end

	local var1_5 = #arg1_5
	local var2_5 = {}

	for iter0_5 = 1, var1_5 do
		local var3_5 = arg1_5[iter0_5].data

		if var3_5.Active == false or var3_5.ImmuneCLD == true then
			-- block empty
		elseif var3_5.UID == arg2_5:GetUniqueID() then
			-- block empty
		elseif var0_5.IFF == var3_5.IFF then
			-- block empty
		elseif var0_5.Surface ~= var3_5.Surface then
			-- block empty
		else
			var2_5[#var2_5 + 1] = var3_5.UID
		end
	end

	arg0_5._proxy:HandleShipCrashDamageList(arg2_5, var2_5)
end

function var7_0.HandleEnemyShipCld(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg2_6:GetCldData()

	if var0_6.Active == false or var0_6.ImmuneCLD == true then
		return
	end

	local var1_6 = arg2_6:GetPosition()
	local var2_6 = {}
	local var3_6 = #arg1_6

	for iter0_6 = 1, var3_6 do
		local var4_6 = arg1_6[iter0_6].data

		if var4_6.Active == false or var4_6.ImmuneCLD == true then
			-- block empty
		elseif var4_6.UID == arg2_6:GetUniqueID() then
			-- block empty
		elseif var0_6.IFF ~= var4_6.IFF then
			-- block empty
		elseif not var4_6.FriendlyCld then
			-- block empty
		elseif var0_6.Surface ~= var4_6.Surface then
			-- block empty
		else
			local var5_6 = var1_6 - arg0_6:GetShip(var4_6.UID):GetPosition()

			var2_6[#var2_6 + 1] = var5_6
		end
	end

	var0_6.distList = var2_6
end

function var7_0.surfaceFilterCount(arg0_7, arg1_7)
	local var0_7 = arg0_7:GetCldData()
	local var1_7 = 0
	local var2_7 = #arg1_7

	for iter0_7 = 1, var2_7 do
		local var3_7 = arg1_7[iter0_7].data

		if var3_7.Active == true and var3_7.ImmuneCLD == false and var3_7.UID ~= arg0_7:GetUniqueID() and var0_7.IFF ~= var3_7.IFF and var0_7.Surface == var3_7.Surface then
			var1_7 = var1_7 + 1
		end
	end

	return var1_7
end

function var7_0.UpdateAircraftCld(arg0_8, arg1_8)
	local var0_8 = arg1_8:GetSpeed()
	local var1_8 = arg1_8:GetCldBox()
	local var2_8

	if arg1_8:GetIFF() == arg0_8._foeCode then
		var2_8 = arg0_8:GetBulletTree(var2_0.BulletField.AIR)
	elseif arg1_8:GetIFF() == arg0_8._friendlyCode then
		var2_8 = arg0_8:GetFoeBulletTree(var2_0.BulletField.AIR)
	end

	local var3_8 = var2_8:GetCldList(var1_8, var0_8)

	arg0_8:HandleBulletCldWithAircraft(var3_8, arg1_8)
	arg0_8._aircraftTree:Update(arg1_8:GetCldBox())
end

function var7_0.HandleBulletCldWithAircraft(arg0_9, arg1_9, arg2_9)
	local var0_9 = #arg1_9

	for iter0_9 = 1, var0_9 do
		local var1_9 = arg1_9[iter0_9].data

		if var1_9.type == var2_0.CldType.BULLET and var1_9.Active == true and var1_9.ImmuneCLD == false then
			local var2_9 = arg0_9:GetBullet(var1_9.UID)

			arg0_9._proxy:HandleBulletHit(var2_9, arg2_9)
		end
	end
end

function var7_0.UpdateBulletCld(arg0_10, arg1_10)
	local var0_10 = arg1_10:GetEffectField()
	local var1_10 = arg1_10:GetCldBox()
	local var2_10 = arg1_10:GetCldData().IFF
	local var3_10
	local var4_10

	if var0_10 == var2_0.BulletField.SURFACE then
		local var5_10 = var2_10 == arg0_10._foeCode and arg0_10._shipTree or arg0_10._foeShipTree
		local var6_10 = arg0_10:getBulletCldShipList(arg1_10, var5_10)

		if arg1_10:IsIndiscriminate() then
			local var7_10 = var5_10 == arg0_10._shipTree and arg0_10._foeShipTree or arg0_10._shipTree
			local var8_10 = arg0_10:getBulletCldShipList(arg1_10, var7_10)

			for iter0_10, iter1_10 in ipairs(var8_10) do
				table.insert(var6_10, iter1_10)
			end
		end

		arg0_10:HandleBulletCldWithShip(var6_10, arg1_10)
	end

	if var2_10 == arg0_10._friendlyCode then
		var3_10 = arg0_10:GetBulletTree(var0_10)
	elseif var2_10 == arg0_10._foeCode then
		var3_10 = arg0_10:GetFoeBulletTree(var0_10)
	end

	var3_10:Update(var1_10)
end

function var7_0.getBulletCldShipList(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg1_11:GetCldBox()
	local var1_11

	if arg1_11:GetType() == var2_0.BulletType.SCALE then
		local var2_11, var3_11, var4_11 = arg1_11:GetRadian()

		if math.abs(var3_11) ~= 1 then
			if arg1_11:GetIFF() == -1 then
				var2_11 = var2_11 + math.pi
			end

			local var5_11 = arg1_11:GetBoxSize()
			local var6_11 = var5_11.x * 2
			local var7_11 = var5_11.z * 2
			local var8_11 = arg1_11:GetPosition()
			local var9_11 = var5_11.x
			local var10_11 = var9_11 * var3_11
			local var11_11 = var9_11 * var4_11
			local var12_11 = Vector3(var8_11.x - var10_11, 1, var8_11.z - var11_11)

			var1_11 = arg2_11:GetCldListGradient(var2_11, var7_11, var6_11, var12_11)
		else
			var1_11 = arg2_11:GetCldList(var0_11, var3_0)
		end
	else
		var1_11 = arg2_11:GetCldList(var0_11, var3_0)
	end

	return var1_11
end

function var7_0.HandleBulletCldWithShip(arg0_12, arg1_12, arg2_12)
	local var0_12 = #arg1_12
	local var1_12 = arg2_12:GetType()

	for iter0_12 = 1, var0_12 do
		local var2_12 = arg1_12[iter0_12].data

		if var2_12.type == var2_0.CldType.SHIP and var2_12.Active == true and var2_12.ImmuneCLD == false then
			local var3_12 = arg0_12:GetShip(var2_12.UID)
			local var4_12 = var3_12:GetCurrentOxyState()
			local var5_12 = var3_12:IsImmuneCommonBulletCLD()

			if var4_12 == var4_0.DIVE and arg2_12:GetCldData().Surface ~= var2_0.OXY_STATE.DIVE then
				-- block empty
			elseif var5_12 then
				-- block empty
			elseif arg0_12._proxy:HandleBulletHit(arg2_12, var3_12) then
				break
			end
		end
	end
end

function var7_0.UpdateAOECld(arg0_13, arg1_13)
	local var0_13 = arg1_13:GetCldBox()
	local var1_13 = arg1_13:GetFieldType()
	local var2_13 = arg1_13:OpponentAffected()
	local var3_13 = arg1_13:GetCldData().IFF
	local var4_13 = var2_13 and var3_13 * -1 or var3_13
	local var5_13

	if var1_13 == var2_0.AOEField.SURFACE then
		local var6_13 = arg1_13:GetCldData().IFF == arg0_13._foeCode
		local var7_13 = arg1_13:OpponentAffected() == var6_13 and arg0_13._shipTree or arg0_13._foeShipTree
		local var8_13 = arg0_13:getAreaCldShipList(arg1_13, var7_13)

		if arg1_13:GetIndiscriminate() then
			local var9_13 = var7_13 == arg0_13._shipTree and arg0_13._foeShipTree or arg0_13._shipTree
			local var10_13 = arg0_13:getAreaCldShipList(arg1_13, var9_13)

			for iter0_13, iter1_13 in ipairs(var10_13) do
				table.insert(var8_13, iter1_13)
			end
		end

		arg0_13:HandleAreaCldWithVehicle(arg1_13, var8_13)
	elseif var1_13 == var2_0.AOEField.BULLET then
		local var11_13

		if var4_13 == arg0_13._foeCode then
			var11_13 = arg0_13._foeSurafceBulletTree
		else
			var11_13 = arg0_13._surfaceBulletTree
		end

		local var12_13 = var11_13:GetCldList(var0_13, var3_0)

		arg1_13:ClearCLDList()
		arg0_13:HandleAreaCldWithBullet(arg1_13, var12_13)
	else
		local var13_13 = {}
		local var14_13 = arg0_13._aircraftTree:GetCldList(var0_13, var3_0)

		for iter2_13, iter3_13 in ipairs(var14_13) do
			if iter3_13.data.IFF == var4_13 then
				table.insert(var13_13, iter3_13)
			end
		end

		arg0_13:HandleAreaCldWithAircraft(arg1_13, var13_13)
	end
end

function var7_0.getAreaCldShipList(arg0_14, arg1_14, arg2_14)
	local var0_14

	if arg1_14:GetAreaType() == var2_0.AreaType.COLUMN or arg1_14:GetAnchorPointAlignment() == Vector3.zero then
		local var1_14 = arg1_14:GetCldBox()

		var0_14 = arg2_14:GetCldList(var1_14, var3_0)
	else
		local var2_14 = arg1_14:GetCldData().IFF == arg0_14._foeCode
		local var3_14 = arg1_14:GetAngle() * math.deg2Rad

		if var2_14 then
			var3_14 = var3_14 + math.pi
		end

		local var4_14 = arg1_14:GetWidth()
		local var5_14 = arg1_14:GetHeight()
		local var6_14 = arg1_14:GetPosition()

		var0_14 = arg2_14:GetCldListGradient(var3_14, var5_14, var4_14, var6_14)
	end

	return var0_14
end

function var7_0.HandleAreaCldWithVehicle(arg0_15, arg1_15, arg2_15)
	arg1_15:ClearCLDList()

	local var0_15 = arg1_15:GetCldData()
	local var1_15 = arg1_15:OpponentAffected()
	local var2_15 = #arg2_15

	for iter0_15 = 1, var2_15 do
		local var3_15 = arg2_15[iter0_15].data

		if var3_15.Active == true and var3_15.ImmuneCLD == false then
			local var4_15 = arg1_15:GetDiveFilter()
			local var5_15 = arg0_15:GetShip(var3_15.UID)
			local var6_15 = true

			if var4_15 then
				local var7_15 = var5_15:GetCurrentOxyState()

				if table.contains(var4_15, var7_15) then
					var6_15 = false
				end
			end

			if var6_15 and not arg1_15:IsOutOfAngle(var5_15) then
				arg1_15:AppendCldObj(var3_15)
			end
		end
	end
end

function var7_0.HandleAreaCldWithAircraft(arg0_16, arg1_16, arg2_16)
	arg1_16:ClearCLDList()

	local var0_16 = arg1_16:GetCldData()
	local var1_16 = arg1_16:OpponentAffected()
	local var2_16 = #arg2_16

	for iter0_16 = 1, var2_16 do
		local var3_16 = arg2_16[iter0_16].data

		if var1_16 == (var3_16.IFF ~= var0_16.IFF) then
			arg1_16:AppendCldObj(var3_16)
		end
	end
end

function var7_0.HandleAreaCldWithBullet(arg0_17, arg1_17, arg2_17)
	local var0_17 = #arg2_17

	for iter0_17 = 1, var0_17 do
		local var1_17 = arg2_17[iter0_17].data

		arg1_17:AppendCldObj(var1_17)
	end
end

function var7_0.UpdateWallCld(arg0_18, arg1_18)
	local var0_18 = arg1_18:GetCldBox()
	local var1_18 = arg1_18:GetCldObjType()

	if var1_18 == arg1_18.CLD_OBJ_TYPE_BULLET then
		local var2_18

		if arg1_18:GetIFF() == arg0_18._friendlyCode then
			var2_18 = arg0_18._foeSurafceBulletTree:GetCldList(var0_18, var3_0)
		else
			var2_18 = arg0_18._surfaceBulletTree:GetCldList(var0_18, var3_0)
		end

		arg0_18:HandleWallCldWithBullet(arg1_18, var2_18)
	elseif var1_18 == arg1_18.CLD_OBJ_TYPE_SHIP then
		local var3_18

		if arg1_18:GetIFF() == arg0_18._friendlyCode then
			var3_18 = arg0_18._foeShipTree:GetCldList(var0_18, var3_0)
		else
			var3_18 = arg0_18._shipTree:GetCldList(var0_18, var3_0)
		end

		arg0_18:HandleWllCldWithShip(arg1_18, var3_18)
	end
end

function var7_0.HandleWallCldWithBullet(arg0_19, arg1_19, arg2_19)
	local var0_19 = #arg2_19

	for iter0_19 = 1, var0_19 do
		local var1_19 = arg2_19[iter0_19].data

		if var1_19.type == var2_0.CldType.BULLET and var1_19.Active == true and var1_19.ImmuneCLD == false then
			local var2_19 = arg0_19:GetBullet(var1_19.UID)

			if not arg0_19._proxy:HandleWallHitByBullet(arg1_19, var2_19) then
				return
			end
		end
	end
end

function var7_0.HandleWllCldWithShip(arg0_20, arg1_20, arg2_20)
	local var0_20 = #arg2_20
	local var1_20 = {}

	for iter0_20 = 1, var0_20 do
		local var2_20 = arg2_20[iter0_20].data

		if var2_20.type == var2_0.CldType.SHIP and var2_20.Active == true and var2_20.ImmuneCLD == false then
			local var3_20 = arg0_20:GetShip(var2_20.UID)

			if var3_20:GetCurrentOxyState() == var4_0.DIVE then
				-- block empty
			else
				table.insert(var1_20, var3_20)
			end
		end
	end

	arg0_20._proxy:HandleWallHitByShip(arg1_20, var1_20)
end

function var7_0.InsertToBulletCldTree(arg0_21, arg1_21, arg2_21)
	local var0_21
	local var1_21 = arg2_21:GetCldData()

	if var1_21.IFF == arg0_21._foeCode then
		var0_21 = arg0_21:GetFoeBulletTree(arg1_21)
	elseif var1_21.IFF == arg0_21._friendlyCode then
		var0_21 = arg0_21:GetBulletTree(arg1_21)
	end

	local var2_21 = arg2_21:GetCldBox()

	var0_21:Insert(var2_21)
end

function var7_0.InsertToAOECldTree(arg0_22, arg1_22, arg2_22)
	local var0_22 = arg0_22:GetAOETree(arg1_22)
	local var1_22 = arg2_22:GetCldBox()

	var0_22:Insert(var1_22)
end

function var7_0.InsertToWallCldTree(arg0_23, arg1_23)
	local var0_23 = arg0_23:GetWallTree()
	local var1_23 = arg1_23:GetCldBox()

	var0_23:Insert(var1_23)
end

function var7_0.InsertToShipCldTree(arg0_24, arg1_24)
	local var0_24 = arg1_24:GetCldData()
	local var1_24

	if var0_24.IFF == arg0_24._foeCode then
		var1_24 = arg0_24:GetFoeShipTree()
	elseif var0_24.IFF == arg0_24._friendlyCode then
		var1_24 = arg0_24:GetShipTree()
	end

	local var2_24 = arg1_24:GetCldBox()

	var1_24:Insert(var2_24)
end

function var7_0.InsertToAircraftCldTree(arg0_25, arg1_25)
	local var0_25 = arg1_25:GetCldBox()

	arg0_25._aircraftTree:Insert(var0_25)
end

function var7_0.GetBulletTree(arg0_26, arg1_26)
	return arg0_26._bulletTreeList[arg1_26]
end

function var7_0.GetFoeBulletTree(arg0_27, arg1_27)
	return arg0_27._foeBulleetTreeList[arg1_27]
end

function var7_0.GetAOETree(arg0_28, arg1_28)
	return arg0_28._AOETreeList[arg1_28]
end

function var7_0.GetWallTree(arg0_29, arg1_29)
	return arg0_29._wallTree
end

function var7_0.GetShipTree(arg0_30)
	return arg0_30._shipTree
end

function var7_0.GetFoeShipTree(arg0_31)
	return arg0_31._foeShipTree
end

function var7_0.GetAircraftTree(arg0_32)
	return arg0_32._aircraftTree
end

function var7_0.DeleteShipLeaf(arg0_33, arg1_33)
	local var0_33 = arg1_33:GetCldData().IFF

	if var0_33 == arg0_33._foeCode then
		arg0_33.DeleteCldLeaf(arg0_33:GetFoeShipTree(), arg1_33)
	elseif var0_33 == arg0_33._friendlyCode then
		arg0_33.DeleteCldLeaf(arg0_33:GetShipTree(), arg1_33)
	end
end

function var7_0.DeleteBulletLeaf(arg0_34, arg1_34)
	local var0_34 = arg1_34:GetCldData().IFF

	if var0_34 == arg0_34._foeCode then
		arg0_34.DeleteCldLeaf(arg0_34:GetFoeBulletTree(arg1_34:GetEffectField()), arg1_34)
	elseif var0_34 == arg0_34._friendlyCode then
		arg0_34.DeleteCldLeaf(arg0_34:GetBulletTree(arg1_34:GetEffectField()), arg1_34)
	end
end

function var7_0.DeleteCldLeaf(arg0_35, arg1_35)
	local var0_35 = arg1_35:GetCldBox()

	arg0_35:Remove(var0_35)
end

function var7_0.GetShip(arg0_36, arg1_36)
	return arg0_36._proxy:GetUnitList()[arg1_36]
end

function var7_0.GetAircraft(arg0_37, arg1_37)
	return arg0_37._proxy:GetAircraftList()[arg1_37]
end

function var7_0.GetBullet(arg0_38, arg1_38)
	return arg0_38._proxy:GetBulletList()[arg1_38]
end

function var7_0.GetAOE(arg0_39, arg1_39)
	return arg0_39._proxy:GetAOEList()[arg1_39]
end

function var7_0.InitShipCld(arg0_40, arg1_40)
	arg0_40:InsertToShipCldTree(arg1_40)
end

function var7_0.DeleteShipCld(arg0_41, arg1_41)
	arg1_41:DeactiveCldBox()
	arg0_41:DeleteShipLeaf(arg1_41)
end

function var7_0.InitAircraftCld(arg0_42, arg1_42)
	arg0_42:InsertToAircraftCldTree(arg1_42)
end

function var7_0.DeleteAircraftCld(arg0_43, arg1_43)
	arg1_43:DeactiveCldBox()
	arg0_43.DeleteCldLeaf(arg0_43:GetAircraftTree(), arg1_43)
end

function var7_0.InitBulletCld(arg0_44, arg1_44)
	arg0_44:InsertToBulletCldTree(arg1_44:GetEffectField(), arg1_44)
end

function var7_0.DeleteBulletCld(arg0_45, arg1_45)
	arg1_45:DeactiveCldBox()
	arg0_45:DeleteBulletLeaf(arg1_45)
end

function var7_0.ShiftBulletCld(arg0_46, arg1_46)
	return
end

function var7_0.InitAOECld(arg0_47, arg1_47)
	arg0_47:InsertToAOECldTree(arg1_47:GetFieldType(), arg1_47)
end

function var7_0.DeleteAOECld(arg0_48, arg1_48)
	arg1_48:DeactiveCldBox()
	arg0_48.DeleteCldLeaf(arg0_48:GetAOETree(arg1_48:GetFieldType()), arg1_48)
end

function var7_0.InitWallCld(arg0_49, arg1_49)
	arg0_49:InsertToWallCldTree(arg1_49)
end

function var7_0.DeleteWallCld(arg0_50, arg1_50)
	arg1_50:DeactiveCldBox()

	local var0_50 = arg0_50:GetWallTree()

	if var0_50 then
		arg0_50.DeleteCldLeaf(var0_50, arg1_50)
	end
end
