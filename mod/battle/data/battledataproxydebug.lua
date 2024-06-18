local var0_0 = ys.Battle.BattleDataProxy
local var1_0 = ys.Battle.BattleEvent
local var2_0 = ys.Battle.BattleFormulas
local var3_0 = ys.Battle.BattleConst
local var4_0 = ys.Battle.BattleConfig
local var5_0 = ys.Battle.BattleDataFunction
local var6_0 = ys.Battle.BattleAttr
local var7_0 = ys.Battle.BattleVariable

function var0_0.__debug__BlockCldUpdate__(arg0_1, arg1_1)
	arg0_1:UpdateCountDown(arg1_1)

	for iter0_1, iter1_1 in pairs(arg0_1._fleetList) do
		iter1_1:UpdateMotion()
	end

	for iter2_1, iter3_1 in pairs(arg0_1._unitList) do
		iter3_1:Update(arg1_1)
	end

	for iter4_1, iter5_1 in pairs(arg0_1._bulletList) do
		local var0_1 = iter5_1:GetSpeed()
		local var1_1 = iter5_1:GetPosition()

		if var1_1.x > arg0_1._bulletRightBound and var0_1.x > 0 or var1_1.z < arg0_1._bulletLowerBound and var0_1.z < 0 then
			arg0_1:RemoveBulletUnit(iter5_1:GetUniqueID())
		elseif var1_1.x < arg0_1._bulletLeftBound and var0_1.x < 0 and iter5_1:GetType() ~= var3_0.BulletType.BOMB then
			arg0_1:RemoveBulletUnit(iter5_1:GetUniqueID())
		else
			iter5_1:Update(arg1_1)

			if var1_1.z > arg0_1._bulletUpperBound and var0_1.z > 0 or iter5_1:IsOutRange(arg1_1) then
				iter5_1:OutRange()
			end
		end
	end

	for iter6_1, iter7_1 in pairs(arg0_1._aircraftList) do
		iter7_1:Update(arg1_1)

		local var2_1, var3_1 = iter7_1:GetIFF()

		if var2_1 == var4_0.FRIENDLY_CODE then
			var3_1 = arg0_1._totalRightBound
		elseif var2_1 == var4_0.FOE_CODE then
			var3_1 = arg0_1._totalLeftBound
		end

		if iter7_1:GetPosition().x * var2_1 > math.abs(var3_1) and iter7_1:GetSpeed().x * var2_1 > 0 then
			iter7_1:OutBound()
		end

		if not iter7_1:IsAlive() then
			arg0_1:KillAircraft(iter7_1:GetUniqueID())
		end
	end

	for iter8_1, iter9_1 in pairs(arg0_1._AOEList) do
		iter9_1:Settle()

		if iter9_1:GetActiveFlag() == false then
			arg0_1:RemoveAreaOfEffect(iter9_1:GetUniqueID())
		end
	end

	for iter10_1, iter11_1 in pairs(arg0_1._foeShipList) do
		if iter11_1:GetPosition().x + iter11_1:GetBoxSize().x < arg0_1._leftZoneLeftBound then
			iter11_1:DeadAction()
			arg0_1:KillUnit(iter11_1:GetUniqueID())
			arg0_1:HandleShipMissDamage(iter11_1, arg0_1._fleetList[var4_0.FRIENDLY_CODE])
		end
	end
end
