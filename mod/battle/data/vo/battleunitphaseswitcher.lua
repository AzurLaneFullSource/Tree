ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst.BossPhaseSwitchType
local var2_0 = var0_0.Battle.BattleConst

var0_0.Battle.BattleUnitPhaseSwitcher = class("BattleUnitPhaseSwitcher")
var0_0.Battle.BattleUnitPhaseSwitcher.__name = "BattleUnitPhaseSwitcher"

local var3_0 = var0_0.Battle.BattleUnitPhaseSwitcher

function var3_0.Ctor(arg0_1, arg1_1)
	arg0_1._client = arg1_1

	arg0_1._client:AddPhaseSwitcher(arg0_1)

	arg0_1._randomWeaponList = {}
end

function var3_0.Update(arg0_2)
	local var0_2 = true
	local var1_2

	for iter0_2, iter1_2 in ipairs(arg0_2._currentPhaseSwitchParam) do
		local var2_2 = iter1_2.type
		local var3_2 = iter1_2.param
		local var4_2 = iter1_2.to

		if var2_2 == var1_0.DURATION then
			if var3_2 < pg.TimeMgr.GetInstance():GetCombatTime() - arg0_2._phaseStartTime then
				var1_2 = iter1_2.to
				iter1_2.andFlag = false
			end
		elseif var2_2 == var1_0.POSITION_X_GREATER then
			if var3_2 < arg0_2._client:GetPosition().x then
				var1_2 = iter1_2.to
				iter1_2.andFlag = false
			end
		elseif var2_2 == var1_0.POSITION_X_LESS then
			if var3_2 > arg0_2._client:GetPosition().x then
				var1_2 = iter1_2.to
				iter1_2.andFlag = false
			end
		elseif var2_2 == var1_0.OXYGEN and var3_2 >= arg0_2._client:GetCuurentOxygen() then
			var1_2 = iter1_2.to
			iter1_2.andFlag = false
		end

		var0_2 = var0_2 and not iter1_2.andFlag
	end

	if var1_2 and var0_2 then
		arg0_2:switch(var1_2)
	end
end

function var3_0.UpdateHP(arg0_3, arg1_3)
	local var0_3 = true
	local var1_3

	for iter0_3, iter1_3 in ipairs(arg0_3._currentPhaseSwitchParam) do
		local var2_3 = iter1_3.type
		local var3_3 = iter1_3.param
		local var4_3 = iter1_3.to

		if var2_3 == var1_0.HP and arg1_3 < var3_3 then
			var1_3 = var4_3
			iter1_3.andFlag = false
		end

		var0_3 = var0_3 and not iter1_3.andFlag
	end

	if var1_3 and var0_3 then
		arg0_3:switch(var1_3)
	end
end

function var3_0.SetTemplateData(arg0_4, arg1_4)
	arg0_4._phaseList = {}

	for iter0_4, iter1_4 in ipairs(arg1_4) do
		arg0_4._phaseList[iter1_4.index] = iter1_4
	end

	arg0_4:switch(0)
end

function var3_0.ForceSwitch(arg0_5, arg1_5)
	arg0_5:switch(arg1_5)
end

function var3_0.switch(arg0_6, arg1_6)
	if arg1_6 == -1 or arg0_6._phaseList[arg1_6] == nil then
		return
	end

	local var0_6 = arg0_6._phaseList[arg1_6]
	local var1_6 = {}

	if var0_6.removeWeapon then
		var1_6 = Clone(var0_6.removeWeapon)
	end

	if var0_6.removeRandomWeapon then
		for iter0_6, iter1_6 in ipairs(arg0_6._randomWeaponList) do
			table.insert(var1_6, iter1_6)
		end

		arg0_6._randomWeaponList = {}
	end

	local var2_6 = {}

	if var0_6.addWeapon then
		var2_6 = Clone(var0_6.addWeapon)
	end

	if var0_6.addRandomWeapon then
		local var3_6 = var0_6.addRandomWeapon[math.random(#var0_6.addRandomWeapon)]

		for iter2_6, iter3_6 in ipairs(var3_6) do
			table.insert(var2_6, iter3_6)
			table.insert(arg0_6._randomWeaponList, iter3_6)
		end
	end

	arg0_6._currentPhase = var0_6

	arg0_6:packagePhaseSwitchParam(var0_6)
	arg0_6._client:ShiftWeapon(var1_6, var2_6)

	if var0_6.removeBuff then
		for iter4_6, iter5_6 in ipairs(var0_6.removeBuff) do
			arg0_6._client:RemoveBuff(iter5_6)
		end
	end

	if var0_6.addBuff then
		for iter6_6, iter7_6 in ipairs(var0_6.addBuff) do
			local var4_6 = var0_0.Battle.BattleBuffUnit.New(iter7_6, 1, arg0_6._client)

			arg0_6._client:AddBuff(var4_6)
		end
	end

	if var0_6.dive then
		arg0_6._client:ChangeOxygenState(var0_6.dive)
	end

	if var0_6.setAI then
		arg0_6._client:SetAI(var0_6.setAI)
	end

	if var0_6.story then
		pg.NewStoryMgr.GetInstance():Play(var0_6.story)
	end

	if not var0_6.guide or var0_6.guide.type == 1 and pg.SeriesGuideMgr.GetInstance():isEnd() then
		-- block empty
	elseif var0_6.guide.event == nil then
		pg.NewGuideMgr.GetInstance():Play(var0_6.guide.step)
	else
		pg.NewGuideMgr.GetInstance():Play(var0_6.guide.step, {
			var0_6.guide.event
		})
	end

	arg0_6._phaseStartTime = pg.TimeMgr.GetInstance():GetCombatTime()

	if var0_6.retreat == true then
		arg0_6._client:Retreat()
	end
end

function var3_0.packagePhaseSwitchParam(arg0_7, arg1_7)
	arg0_7._currentPhaseSwitchParam = {}

	local var0_7 = type(arg1_7.switchType)

	if var0_7 == "table" then
		local var1_7 = arg1_7.switchType
		local var2_7 = arg1_7.switchParam
		local var3_7 = arg1_7.switchTo
		local var4_7 = type(var3_7) == "number"
		local var5_7 = 1
		local var6_7 = #arg1_7.switchType

		while var5_7 <= var6_7 do
			local var7_7 = {
				type = var1_7[var5_7],
				param = var2_7[var5_7]
			}

			if var4_7 then
				var7_7.to = var3_7
				var7_7.andFlag = true
			else
				var7_7.to = var3_7[var5_7]
			end

			table.insert(arg0_7._currentPhaseSwitchParam, var7_7)

			var5_7 = var5_7 + 1
		end
	elseif var0_7 == "number" then
		local var8_7 = {
			type = arg1_7.switchType
		}

		if arg1_7.switchParamFunc then
			var8_7.param = arg1_7.switchParamFunc()
		else
			var8_7.param = arg1_7.switchParam
		end

		var8_7.to = arg1_7.switchTo

		table.insert(arg0_7._currentPhaseSwitchParam, var8_7)
	end
end
