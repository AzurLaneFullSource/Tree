ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst.BossPhaseSwitchType
local var2 = var0.Battle.BattleConst

var0.Battle.BattleUnitPhaseSwitcher = class("BattleUnitPhaseSwitcher")
var0.Battle.BattleUnitPhaseSwitcher.__name = "BattleUnitPhaseSwitcher"

local var3 = var0.Battle.BattleUnitPhaseSwitcher

function var3.Ctor(arg0, arg1)
	arg0._client = arg1

	arg0._client:AddPhaseSwitcher(arg0)

	arg0._randomWeaponList = {}
end

function var3.Update(arg0)
	local var0 = true
	local var1

	for iter0, iter1 in ipairs(arg0._currentPhaseSwitchParam) do
		local var2 = iter1.type
		local var3 = iter1.param
		local var4 = iter1.to

		if var2 == var1.DURATION then
			if var3 < pg.TimeMgr.GetInstance():GetCombatTime() - arg0._phaseStartTime then
				var1 = iter1.to
				iter1.andFlag = false
			end
		elseif var2 == var1.POSITION_X_GREATER then
			if var3 < arg0._client:GetPosition().x then
				var1 = iter1.to
				iter1.andFlag = false
			end
		elseif var2 == var1.POSITION_X_LESS then
			if var3 > arg0._client:GetPosition().x then
				var1 = iter1.to
				iter1.andFlag = false
			end
		elseif var2 == var1.OXYGEN and var3 >= arg0._client:GetCuurentOxygen() then
			var1 = iter1.to
			iter1.andFlag = false
		end

		var0 = var0 and not iter1.andFlag
	end

	if var1 and var0 then
		arg0:switch(var1)
	end
end

function var3.UpdateHP(arg0, arg1)
	local var0 = true
	local var1

	for iter0, iter1 in ipairs(arg0._currentPhaseSwitchParam) do
		local var2 = iter1.type
		local var3 = iter1.param
		local var4 = iter1.to

		if var2 == var1.HP and arg1 < var3 then
			var1 = var4
			iter1.andFlag = false
		end

		var0 = var0 and not iter1.andFlag
	end

	if var1 and var0 then
		arg0:switch(var1)
	end
end

function var3.SetTemplateData(arg0, arg1)
	arg0._phaseList = {}

	for iter0, iter1 in ipairs(arg1) do
		arg0._phaseList[iter1.index] = iter1
	end

	arg0:switch(0)
end

function var3.ForceSwitch(arg0, arg1)
	arg0:switch(arg1)
end

function var3.switch(arg0, arg1)
	if arg1 == -1 or arg0._phaseList[arg1] == nil then
		return
	end

	local var0 = arg0._phaseList[arg1]
	local var1 = {}

	if var0.removeWeapon then
		var1 = Clone(var0.removeWeapon)
	end

	if var0.removeRandomWeapon then
		for iter0, iter1 in ipairs(arg0._randomWeaponList) do
			table.insert(var1, iter1)
		end

		arg0._randomWeaponList = {}
	end

	local var2 = {}

	if var0.addWeapon then
		var2 = Clone(var0.addWeapon)
	end

	if var0.addRandomWeapon then
		local var3 = var0.addRandomWeapon[math.random(#var0.addRandomWeapon)]

		for iter2, iter3 in ipairs(var3) do
			table.insert(var2, iter3)
			table.insert(arg0._randomWeaponList, iter3)
		end
	end

	arg0._currentPhase = var0

	arg0:packagePhaseSwitchParam(var0)
	arg0._client:ShiftWeapon(var1, var2)

	if var0.removeBuff then
		for iter4, iter5 in ipairs(var0.removeBuff) do
			arg0._client:RemoveBuff(iter5)
		end
	end

	if var0.addBuff then
		for iter6, iter7 in ipairs(var0.addBuff) do
			local var4 = var0.Battle.BattleBuffUnit.New(iter7, 1, arg0._client)

			arg0._client:AddBuff(var4)
		end
	end

	if var0.dive then
		arg0._client:ChangeOxygenState(var0.dive)
	end

	if var0.setAI then
		arg0._client:SetAI(var0.setAI)
	end

	if var0.story then
		pg.NewStoryMgr.GetInstance():Play(var0.story)
	end

	if not var0.guide or var0.guide.type == 1 and pg.SeriesGuideMgr.GetInstance():isEnd() then
		-- block empty
	elseif var0.guide.event == nil then
		pg.NewGuideMgr.GetInstance():Play(var0.guide.step)
	else
		pg.NewGuideMgr.GetInstance():Play(var0.guide.step, {
			var0.guide.event
		})
	end

	arg0._phaseStartTime = pg.TimeMgr.GetInstance():GetCombatTime()

	if var0.retreat == true then
		arg0._client:Retreat()
	end
end

function var3.packagePhaseSwitchParam(arg0, arg1)
	arg0._currentPhaseSwitchParam = {}

	local var0 = type(arg1.switchType)

	if var0 == "table" then
		local var1 = arg1.switchType
		local var2 = arg1.switchParam
		local var3 = arg1.switchTo
		local var4 = type(var3) == "number"
		local var5 = 1
		local var6 = #arg1.switchType

		while var5 <= var6 do
			local var7 = {
				type = var1[var5],
				param = var2[var5]
			}

			if var4 then
				var7.to = var3
				var7.andFlag = true
			else
				var7.to = var3[var5]
			end

			table.insert(arg0._currentPhaseSwitchParam, var7)

			var5 = var5 + 1
		end
	elseif var0 == "number" then
		local var8 = {
			type = arg1.switchType
		}

		if arg1.switchParamFunc then
			var8.param = arg1.switchParamFunc()
		else
			var8.param = arg1.switchParam
		end

		var8.to = arg1.switchTo

		table.insert(arg0._currentPhaseSwitchParam, var8)
	end
end
