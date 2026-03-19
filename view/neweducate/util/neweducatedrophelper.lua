local var0_0 = class("NewEducateDropHelper")

function var0_0.HandleDrops(arg0_1)
	local var0_1 = {}

	for iter0_1, iter1_1 in ipairs(arg0_1.base_drop or {}) do
		local var1_1 = {
			type = iter1_1.type,
			id = iter1_1.id,
			number = iter1_1.number
		}

		table.insert(var0_1, var1_1)
	end

	for iter2_1, iter3_1 in ipairs(arg0_1.benefit_drop or {}) do
		local var2_1 = {
			isBenefit = true,
			type = iter3_1.type,
			id = iter3_1.id,
			number = iter3_1.number
		}

		table.insert(var0_1, var2_1)
	end

	local var3_1 = {}

	for iter4_1, iter5_1 in ipairs(var0_1) do
		switch(iter5_1.type, {
			[NewEducateConst.DROP_TYPE.ATTR] = function()
				local var0_2 = var0_0.AddAttrDrop(iter5_1)

				if var0_2 then
					table.insert(var3_1, var0_2)
				end
			end,
			[NewEducateConst.DROP_TYPE.RES] = function()
				local var0_3 = var0_0.AddResDrop(iter5_1)

				if var0_3 then
					table.insert(var3_1, var0_3)
				end
			end,
			[NewEducateConst.DROP_TYPE.POLAROID] = function()
				local var0_4 = var0_0.AddPolaroidDrop(iter5_1)

				if var0_4 then
					table.insert(var3_1, var0_4)
				end
			end,
			[NewEducateConst.DROP_TYPE.BUFF] = function()
				local var0_5 = var0_0.AddBuffDrop(iter5_1)

				if var0_5 then
					table.insert(var3_1, var0_5)
				end
			end,
			[NewEducateConst.DROP_TYPE.TAROT] = function()
				local var0_6 = var0_0.AddTarotDrop(iter5_1)

				if var0_6 then
					table.insert(var3_1, var0_6)
				end
			end,
			[NewEducateConst.DROP_TYPE.CHOOSE] = function()
				var0_0.AddChooseState(iter5_1)
			end,
			[NewEducateConst.DROP_TYPE.UP_ENTRY] = function()
				var0_0.AddUpEntryState(iter5_1)
			end,
			[NewEducateConst.DROP_TYPE.TEMP_ROUND] = function()
				var0_0.AddTempRound(iter5_1)
			end
		})
	end

	var0_0.UpdateBenefitDisplay(arg0_1.display)

	return var3_1
end

function var0_0.AddAttrDrop(arg0_10)
	getProxy(NewEducateProxy):UpdateAttr(arg0_10.id, arg0_10.number)

	return pg.child2_attr[arg0_10.id].type == NewEducateChar.ATTR_TYPE.ATTR and arg0_10 or nil
end

function var0_0.AddResDrop(arg0_11)
	local var0_11 = getProxy(NewEducateProxy)
	local var1_11 = var0_11:GetCurChar():GetRes(arg0_11.id) + arg0_11.number
	local var2_11 = math.max(0, var1_11 - pg.child2_resource[arg0_11.id].max_value)

	var0_11:UpdateRes(arg0_11.id, arg0_11.number)

	local var3_11 = {}

	if var2_11 then
		var3_11 = setmetatable({
			overflow = var2_11
		}, {
			__index = arg0_11
		})
	else
		var3_11 = arg0_11
	end

	return var3_11
end

function var0_0.AddPolaroidDrop(arg0_12)
	getProxy(NewEducateProxy):AddPolaroid(arg0_12.id, arg0_12.number)

	return arg0_12
end

function var0_0.AddBuffDrop(arg0_13)
	if var0_0.CheckReplaceTarot(arg0_13) then
		var0_0.AddReplaceTarotState(arg0_13)

		return nil
	else
		getProxy(NewEducateProxy):AddBuff(arg0_13.id, arg0_13.number)

		local var0_13 = pg.child2_benefit_list[arg0_13.id]

		return arg0_13.number > 0 and var0_13.is_show == 1 and var0_13.type ~= NewEducateBuff.TYPE.TALENT and arg0_13 or nil
	end
end

function var0_0.AddTarotDrop(arg0_14)
	getProxy(NewEducateProxy):AddBuff(arg0_14.id, arg0_14.number)

	return arg0_14.number > 0 and pg.child2_benefit_list[arg0_14.id].is_show == 1 and arg0_14 or nil
end

function var0_0.AddTempRound(arg0_15)
	getProxy(NewEducateProxy):AddTempRound(arg0_15.number)
end

function var0_0.CheckReplaceTarot(arg0_16)
	if arg0_16.number <= 0 then
		return false
	end

	return pg.child2_benefit_list[arg0_16.id].type == NewEducateBuff.TYPE.TAROT and getProxy(NewEducateProxy):GetCurChar():GetTarotId()
end

function var0_0.AddReplaceTarotState(arg0_17)
	if arg0_17.number <= 0 then
		return
	end

	local var0_17 = getProxy(NewEducateProxy):GetCurChar():GetFSM()

	for iter0_17 = 1, arg0_17.number do
		var0_17:AddReplaceTarotState(arg0_17.id)
	end

	pg.m02:sendNotification(GAME.NEW_EDUCATE_CHECK_PRIORITY_FSM)
end

function var0_0.AddChooseState(arg0_18)
	if arg0_18.number <= 0 then
		return
	end

	local var0_18 = getProxy(NewEducateProxy):GetCurChar():GetFSM()

	for iter0_18 = 1, arg0_18.number do
		var0_18:AddChooseState(arg0_18.id)
	end

	pg.m02:sendNotification(GAME.NEW_EDUCATE_CHECK_PRIORITY_FSM)
end

function var0_0.AddUpEntryState(arg0_19)
	if arg0_19.number <= 0 then
		return
	end

	local var0_19 = getProxy(NewEducateProxy):GetCurChar():GetFSM()

	for iter0_19 = 1, arg0_19.number do
		var0_19:AddChooseUpEntryState()
	end

	pg.m02:sendNotification(GAME.NEW_EDUCATE_CHECK_PRIORITY_FSM)
end

function var0_0.UpdateBenefitDisplay(arg0_20)
	local var0_20 = getProxy(NewEducateProxy):GetCurChar():GetBenefitData()

	var0_20:UpdateDisplayPct(arg0_20.benefit_display)
	var0_20:UpdateDisplayNum(arg0_20.dollar_num_display)
	var0_20:UpdateDisplayCounter(arg0_20.counter)
end

return var0_0
