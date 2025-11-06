local var0_0 = class("IslandCoupleNpcWordTask", import("..IslandBaseUnit"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg2_1)

	arg0_1.id = arg1_1
	arg0_1.view = arg2_1
	arg0_1.delayTime = pg.island_set.couple_word_cd.key_value_int
	arg0_1.currPlayStory = nil
	arg0_1.members = {}
end

function var0_0.IsCurrentTask(arg0_2, arg1_2)
	return arg0_2.id == arg1_2 or table.contains(arg0_2.members, arg1_2)
end

function var0_0.Execute(arg0_3, arg1_3, arg2_3)
	arg0_3.stopping = false

	local var0_3 = arg0_3:GetView():GetUnitListByKey(IslandConst.UNIT_LIST_FOLLOW)

	if #var0_3 <= 1 then
		onNextTick(arg2_3)

		return
	end

	arg0_3.callback = arg2_3

	local var1_3 = arg0_3:CollectWords(arg1_3, var0_3)

	shuffle(var1_3)

	local var2_3 = {}

	for iter0_3, iter1_3 in ipairs(var1_3) do
		table.insert(var2_3, function(arg0_4)
			arg0_3:PlayStory(iter1_3, arg0_4)
		end)
	end

	seriesAsyncExtend(var2_3, function()
		arg0_3:Stop(true)

		if arg0_3.callback then
			onNextTick(arg0_3.callback)
		end
	end)

	arg0_3.funcs = var2_3
end

function var0_0.CollectWords(arg0_6, arg1_6, arg2_6)
	local var0_6 = {}

	for iter0_6, iter1_6 in ipairs(pg.island_couple_word.all) do
		local var1_6 = pg.island_couple_word[iter1_6]

		if var1_6.type == 1 and arg0_6:CheckShipCouple(var1_6.param, arg1_6) and arg0_6:IsHappen(var1_6.weight) and arg0_6:CoupleShipInTeam(var1_6.param, arg2_6) then
			table.insert(var0_6, var1_6.story)
		elseif var1_6.type ~= 1 then
			assert(false, "type not support")
		end
	end

	return var0_6
end

function var0_0.CheckShipCouple(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg0_7:GetView():GetUnitModuleWithType(IslandConst.UNIT_LIST_FOLLOW, arg2_7):GetDataVO():GetShipId()

	return _.any(arg1_7, function(arg0_8)
		return arg0_8 == var0_7
	end)
end

function var0_0.IsHappen(arg0_9, arg1_9)
	return arg1_9 >= math.random(0, 10000)
end

function var0_0.CoupleShipInTeam(arg0_10, arg1_10, arg2_10)
	return _.all(arg1_10, function(arg0_11)
		return _.any(arg2_10, function(arg0_12)
			return arg0_12:GetDataVO():IsSameShip(arg0_11)
		end)
	end)
end

function var0_0.PlayStory(arg0_13, arg1_13, arg2_13)
	if arg0_13.stopping then
		arg2_13()

		return
	end

	local var0_13 = require("Mod.Island.CoupleWord." .. arg1_13)
	local var1_13 = arg0_13:WarpStory(arg1_13, var0_13)
	local var2_13 = arg0_13:GetView():GetAllUnits()
	local var3_13 = IslandStory.New(var1_13, var2_13, IslandStory.MODE_BUBBLE)

	if not arg0_13:IsVaildStory(var3_13) then
		arg2_13()

		return
	end

	arg0_13:FullMembers(var3_13)
	arg0_13:NotifiyCore(ISLAND_EVT.RAW_PLAY_BUBBLE, {
		info = var1_13,
		callback = function()
			arg0_13.members = {}

			arg0_13:AddDelayTimer(arg2_13)
		end
	})

	arg0_13.currPlayStory = var1_13
end

function var0_0.FullMembers(arg0_15, arg1_15)
	for iter0_15, iter1_15 in ipairs(arg1_15.steps) do
		local var0_15 = iter1_15:GetUnitData()

		table.insert(arg0_15.members, var0_15.id)
	end
end

function var0_0.IsVaildStory(arg0_16, arg1_16)
	for iter0_16, iter1_16 in ipairs(arg1_16.steps) do
		local var0_16 = iter1_16:GetUnitData()
		local var1_16 = arg0_16:GetView():GetUnitModuleWithType(var0_16.type, var0_16.id)

		assert(var1_16, var0_16.type .. " - " .. var0_16.id)

		if not var1_16 then
			return false
		end
	end

	return true
end

function var0_0.WarpStory(arg0_17, arg1_17, arg2_17)
	local var0_17 = {}
	local var1_17 = {}
	local var2_17 = {}

	for iter0_17, iter1_17 in ipairs(arg2_17) do
		var2_17[iter1_17.characterId] = true

		table.insert(var1_17, iter1_17)
	end

	for iter2_17, iter3_17 in pairs(var2_17) do
		table.insert(var0_17, {
			iter2_17,
			iter2_17,
			IslandConst.UNIT_LIST_FOLLOW
		})
	end

	return {
		mode = 9,
		id = arg1_17,
		map = var0_17,
		scripts = var1_17
	}
end

function var0_0.AddDelayTimer(arg0_18, arg1_18)
	arg0_18:RemoveTimer()

	arg0_18.timer = Timer.New(arg1_18, arg0_18.delayTime, 1)

	arg0_18.timer:Start()
end

function var0_0.RemoveTimer(arg0_19)
	if arg0_19.timer then
		arg0_19.timer:Stop()

		arg0_19.timer = nil
	end
end

function var0_0.Stop(arg0_20, arg1_20)
	if not arg1_20 then
		arg0_20.callback = nil

		arg0_20:StopBubbule()
	end

	arg0_20.stopping = true
	arg0_20.funcs = {}

	arg0_20:RemoveTimer()

	arg0_20.currPlayStory = nil
	arg0_20.members = nil
end

function var0_0.StopBubbule(arg0_21)
	if not arg0_21.currPlayStory then
		return
	end

	arg0_21:NotifiyCore(ISLAND_EVT.RAW_STOP_BUBBLE, {
		info = Clone(arg0_21.currPlayStory)
	})
end

return var0_0
