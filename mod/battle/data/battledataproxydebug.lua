local var0 = ys.Battle.BattleDataProxy
local var1 = ys.Battle.BattleEvent
local var2 = ys.Battle.BattleFormulas
local var3 = ys.Battle.BattleConst
local var4 = ys.Battle.BattleConfig
local var5 = ys.Battle.BattleDataFunction
local var6 = ys.Battle.BattleAttr
local var7 = ys.Battle.BattleVariable

function var0.__debug__BlockCldUpdate__(arg0, arg1)
	arg0:UpdateCountDown(arg1)

	for iter0, iter1 in pairs(arg0._fleetList) do
		iter1:UpdateMotion()
	end

	for iter2, iter3 in pairs(arg0._unitList) do
		iter3:Update(arg1)
	end

	for iter4, iter5 in pairs(arg0._bulletList) do
		local var0 = iter5:GetSpeed()
		local var1 = iter5:GetPosition()

		if var1.x > arg0._bulletRightBound and var0.x > 0 or var1.z < arg0._bulletLowerBound and var0.z < 0 then
			arg0:RemoveBulletUnit(iter5:GetUniqueID())
		elseif var1.x < arg0._bulletLeftBound and var0.x < 0 and iter5:GetType() ~= var3.BulletType.BOMB then
			arg0:RemoveBulletUnit(iter5:GetUniqueID())
		else
			iter5:Update(arg1)

			if var1.z > arg0._bulletUpperBound and var0.z > 0 or iter5:IsOutRange(arg1) then
				iter5:OutRange()
			end
		end
	end

	for iter6, iter7 in pairs(arg0._aircraftList) do
		iter7:Update(arg1)

		local var2, var3 = iter7:GetIFF()

		if var2 == var4.FRIENDLY_CODE then
			var3 = arg0._totalRightBound
		elseif var2 == var4.FOE_CODE then
			var3 = arg0._totalLeftBound
		end

		if iter7:GetPosition().x * var2 > math.abs(var3) and iter7:GetSpeed().x * var2 > 0 then
			iter7:OutBound()
		end

		if not iter7:IsAlive() then
			arg0:KillAircraft(iter7:GetUniqueID())
		end
	end

	for iter8, iter9 in pairs(arg0._AOEList) do
		iter9:Settle()

		if iter9:GetActiveFlag() == false then
			arg0:RemoveAreaOfEffect(iter9:GetUniqueID())
		end
	end

	for iter10, iter11 in pairs(arg0._foeShipList) do
		if iter11:GetPosition().x + iter11:GetBoxSize().x < arg0._leftZoneLeftBound then
			iter11:DeadAction()
			arg0:KillUnit(iter11:GetUniqueID())
			arg0:HandleShipMissDamage(iter11, arg0._fleetList[var4.FRIENDLY_CODE])
		end
	end
end
