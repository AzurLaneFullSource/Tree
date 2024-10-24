local var0_0 = class("BoatAdCreateControl")
local var1_0
local var2_0
local var3_0 = 1.3

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var1_0 = BoatAdGameVo
	var2_0 = BoatAdGameConst
	arg0_1._bgContent = arg1_1
	arg0_1._eventCall = arg2_1
	arg0_1._content = findTF(arg0_1._bgContent, "scene/content")
	arg0_1._createRule = {}
end

function var0_0.start(arg0_2)
	local var0_2 = var1_0.GetRoundData()

	if var0_2 and var0_2.rule then
		arg0_2._createRule = Clone(var2_0.create_rule[var0_2.rule])
	end

	arg0_2._createStepTime = 0
	arg0_2._createRuleIndex = #arg0_2._createRule
	arg0_2._createRound = 1
	arg0_2._createLine = 1
	arg0_2.applyCreateData = nil
	arg0_2.applyCount = 0
	arg0_2.applyTimes = 0
end

function var0_0.step(arg0_3, arg1_3)
	if arg0_3._createStepTime >= 0 and not var1_0.char:getBattle() then
		arg0_3._createStepTime = arg0_3._createStepTime - var1_0.deltaTime

		if arg0_3._createStepTime <= 0 then
			arg0_3:applyRule()

			arg0_3._createStepTime = var3_0
		end
	end
end

function var0_0.applyRule(arg0_4)
	if arg0_4.applyTimes <= 0 then
		arg0_4.applyCreateData = arg0_4._createRule[arg0_4._createRuleIndex]
		arg0_4.createCount = arg0_4.applyCreateData.count
		arg0_4._createRuleIndex = arg0_4._createRuleIndex - 1
		arg0_4.applyTimes = arg0_4.applyCreateData.times

		if arg0_4._createRuleIndex <= 0 then
			arg0_4._createRuleIndex = #arg0_4._createRule
			arg0_4._createRound = arg0_4._createRound + 1
		end
	end

	arg0_4.applyTimes = arg0_4.applyTimes - 1

	local var0_4

	if type(arg0_4.applyCreateData.data[1]) == "number" then
		var0_4 = arg0_4.applyCreateData.data
	else
		var0_4 = arg0_4.applyCreateData.data[math.random(1, #arg0_4.applyCreateData.data)]
	end

	local var1_4 = {}

	for iter0_4 = 1, #var0_4 do
		local var2_4 = iter0_4
		local var3_4 = var0_4[iter0_4]
		local var4_4 = 0

		if var3_4 ~= 0 and #var1_4 < arg0_4.createCount then
			local var5_4 = Clone(var2_0.rule_data[var3_4])
			local var6_4 = var5_4.create_rate
			local var7_4 = var5_4.round
			local var8_4 = true
			local var9_4 = var5_4.once
			local var10_4 = var5_4.ids

			if var9_4 then
				for iter1_4 = #var10_4, 1, -1 do
					if table.contains(var1_4, var10_4[iter1_4]) then
						table.remove(var10_4, iter1_4)
					end
				end
			end

			if var7_4 and var7_4 > 0 and arg0_4._createRound ~= var7_4 then
				var8_4 = false
			end

			if var6_4 < math.random(1, 100) then
				var8_4 = false
			end

			if var8_4 then
				local var11_4 = var10_4[math.random(1, #var10_4)]

				if var5_4.type == var2_0.type_enemy then
					arg0_4._eventCall(BoatAdGameEvent.CREATE_ENEMY, {
						id = var11_4,
						move_count = var2_4,
						round = arg0_4._createRound,
						line = arg0_4._createLine
					})

					var4_4 = var11_4
				elseif var5_4.type == var2_0.type_item or var5_4.type == var2_0.type_buff then
					arg0_4._eventCall(BoatAdGameEvent.CREATE_ITEM, {
						id = var11_4,
						move_count = var2_4,
						round = arg0_4._createRound,
						line = arg0_4._createLine
					})

					var4_4 = var11_4
				end
			end
		end

		if var4_4 > 0 then
			table.insert(var1_4, var4_4)
		end
	end

	local var12_4 = "本轮 " .. arg0_4._createLine .. " 创建id = "

	for iter2_4 = 1, #var1_4 do
		var12_4 = var12_4 .. var1_4[iter2_4] .. ","
	end

	print(var12_4)

	arg0_4._createLine = arg0_4._createLine + 1
end

function var0_0.clear(arg0_5)
	return
end

function var0_0.stop(arg0_6)
	return
end

function var0_0.resume(arg0_7)
	return
end

function var0_0.dispose(arg0_8)
	return
end

return var0_0
