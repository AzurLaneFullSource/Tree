local var0_0 = class("IslandGiftAllocator", import(".IslandComparableAllocator"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.controller = arg1_1
	arg0_1.signInAgency = arg1_1:GetIsland():GetSignInAgency()

	var0_0.super.Ctor(arg0_1, arg1_1)
	arg0_1:AddTimer()
end

function var0_0.AddTimer(arg0_2)
	arg0_2:RemoveTimer()

	local var0_2 = GetZeroTime() - pg.TimeMgr.GetInstance():GetServerTime()

	if var0_2 > 0 then
		arg0_2.timer = Timer.New(function()
			arg0_2:Flush()
		end, var0_2, 1)

		arg0_2.timer:Start()
	end
end

function var0_0.RemoveTimer(arg0_4)
	if arg0_4.timer then
		arg0_4.timer:Stop()

		arg0_4.timer = nil
	end
end

function var0_0.OnInitFlags(arg0_5)
	for iter0_5, iter1_5 in ipairs(arg0_5.controller.sceneData.giftUnits) do
		arg0_5.flags[iter0_5] = arg0_5:IsVisible(iter0_5)
	end
end

function var0_0.OnCompareSample(arg0_6, arg1_6, arg2_6)
	for iter0_6, iter1_6 in pairs(arg1_6) do
		local var0_6 = iter1_6
		local var1_6 = arg2_6[iter0_6]

		if var0_6 ~= nil and var1_6 ~= nil and var0_6 ~= var1_6 then
			if var0_6 == true and var1_6 == false then
				local var2_6 = arg0_6:GetUnitData(iter0_6)

				if var2_6 then
					arg0_6:RemoveUnit(IslandConst.UNIT_LIST_OBJ, var2_6.id)
				end
			elseif var0_6 == false and var1_6 == true then
				local var3_6 = arg0_6:GetUnitData(iter0_6)

				if var3_6 then
					arg0_6:GenUnit(var3_6)
				end
			end
		end
	end
end

function var0_0.IsVisible(arg0_7, arg1_7)
	local var0_7 = arg0_7.signInAgency:Visible(arg1_7)

	if arg0_7.signInAgency:IsOutRange(arg1_7) then
		return false
	end

	if arg0_7.controller:IsSelfIsland() then
		if arg0_7.signInAgency.signInCnt <= 0 then
			return false
		end

		local var1_7 = arg0_7.signInAgency.signInCnt > 0 and arg0_7.signInAgency.fetchCnt == 0

		return var0_7 or var1_7
	else
		local var2_7 = arg0_7.controller:GetIsland()
		local var3_7 = var2_7:GetAccessAgency():HasOpenFlag(IslandConst.OPEN_SIGNIN)
		local var4_7 = var2_7:GetSignInAgency():InInInviteList(getProxy(PlayerProxy):getRawData().id)
		local var5_7 = var2_7:GetSignInAgency():IsExpiration()

		return var0_7 and (var3_7 or var4_7) and not var5_7
	end
end

function var0_0.GetUnitData(arg0_8, arg1_8)
	assert(arg0_8.controller.sceneData.giftUnits[arg1_8], "unit data is nil ." .. arg1_8)

	return arg0_8.controller.sceneData.giftUnits[arg1_8]
end

function var0_0.OnDispose(arg0_9)
	arg0_9.signInAgency = nil

	arg0_9:RemoveTimer()
end

return var0_0
