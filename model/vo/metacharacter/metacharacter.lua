local var0_0 = class("MetaCharacter", import("..BaseVO"))

function var0_0.bindConfigTable(arg0_1)
	return pg.ship_strengthen_meta
end

function var0_0.Ctor(arg0_2, arg1_2, arg2_2)
	assert(arg1_2.id)
	assert(arg2_2)

	arg0_2.id = arg1_2.id
	arg0_2.configId = arg0_2.id
	arg0_2.shipVO = arg2_2
	arg0_2.maxRepairExp = arg0_2:getConfig("repair_total_exp")
	arg0_2.attrs = {}

	for iter0_2, iter1_2 in ipairs(MetaCharacterConst.REPAIR_ATTRS) do
		arg0_2.attrs[iter1_2] = MetaCharacterAttr.New({
			attr = iter1_2,
			items = arg0_2:getConfig("repair_" .. iter1_2)
		})
	end

	arg0_2.effects = _.map(arg0_2:getConfig("repair_effect"), function(arg0_3)
		return MetaRepairEffect.New({
			id = arg0_3[2],
			progress = arg0_3[1]
		})
	end)

	for iter2_2, iter3_2 in ipairs(arg1_2.repair_attr_info or {}) do
		for iter4_2, iter5_2 in pairs(arg0_2.attrs) do
			if iter5_2:hasItemId(iter3_2) then
				local var0_2 = iter5_2:getLevelByItemId(iter3_2)

				iter5_2:updateCount(var0_2)
			end
		end
	end
end

function var0_0.getBreakOutInfo(arg0_4)
	assert(arg0_4.shipVO)

	local var0_4 = arg0_4.shipVO

	if not arg0_4.beakOutInfo or var0_4.configId ~= arg0_4.beakOutInfo.id then
		arg0_4.beakOutInfo = MetaCharacterBreakout.New({
			id = var0_4.configId
		})
	end

	return arg0_4.beakOutInfo
end

function var0_0.getSpecialMaterialInfoToMaxStar(arg0_5)
	local var0_5 = arg0_5:getBreakOutInfo()
	local var1_5 = {
		count = 0,
		itemID = arg0_5.beakOutInfo:getConfig("item1")
	}

	while true do
		if not var0_5:hasNextInfo() then
			return var1_5
		else
			var1_5.count = var1_5.count + var0_5:getConfig("item1_num")
			var0_5 = var0_5:getNextInfo()
		end
	end
end

function var0_0.getCurRepairExp(arg0_6)
	local var0_6 = 0

	for iter0_6, iter1_6 in pairs(arg0_6.attrs) do
		var0_6 = var0_6 + iter1_6:getRepairExp()
	end

	return var0_6
end

function var0_0.getMaxRepairExp(arg0_7)
	return arg0_7.maxRepairExp
end

function var0_0.getRepairRate(arg0_8)
	return arg0_8:getCurRepairExp() / arg0_8:getMaxRepairExp()
end

function var0_0.isMaxRepairExp(arg0_9)
	return arg0_9:getCurRepairExp() == arg0_9:getMaxRepairExp()
end

function var0_0.getAttrAddition(arg0_10, arg1_10)
	return arg0_10:getRepairAddition(arg1_10) + arg0_10:getPercentageAddition(arg1_10)
end

function var0_0.getPercentageAddition(arg0_11, arg1_11)
	local var0_11 = 0
	local var1_11 = arg0_11:getRepairRate() * 100

	for iter0_11, iter1_11 in ipairs(arg0_11.effects) do
		if var1_11 >= iter1_11.progress then
			var0_11 = var0_11 + iter1_11:getAttrAddition(arg1_11)
		end
	end

	return var0_11
end

function var0_0.getRepairAddition(arg0_12, arg1_12)
	local var0_12 = 0
	local var1_12 = arg0_12.attrs[arg1_12]

	if var1_12 and var1_12:isLock() then
		return 0
	end

	if var1_12 then
		var0_12 = var0_12 + var1_12:getAddition()
	end

	return var0_12
end

function var0_0.getTotalMaxAddition(arg0_13)
	local var0_13 = {}

	for iter0_13, iter1_13 in pairs(arg0_13.attrs) do
		local var1_13 = iter1_13.attr
		local var2_13 = 0

		if iter1_13 and iter1_13:isLock() then
			var2_13 = 0
		else
			local var3_13 = Clone(iter1_13)

			var3_13.level = var3_13:getItemCount() + 1
			var2_13 = var2_13 + var3_13:getAddition()
		end

		if var0_13[var1_13] then
			var0_13[var1_13] = var0_13[var1_13] + var2_13
		else
			var0_13[var1_13] = var2_13
		end
	end

	for iter2_13, iter3_13 in ipairs(arg0_13.effects) do
		local var4_13 = iter3_13:getAttrAdditionList()

		for iter4_13, iter5_13 in ipairs(var4_13) do
			local var5_13 = iter5_13[1]
			local var6_13 = iter5_13[2]

			if var0_13[var5_13] then
				var0_13[var5_13] = var0_13[var5_13] + var6_13
			else
				var0_13[var5_13] = var6_13
			end
		end
	end

	return var0_13
end

function var0_0.getFinalAddition(arg0_14, arg1_14)
	assert(arg1_14, "shipVO can not be nil")

	local var0_14 = arg1_14:getBaseProperties()
	local var1_14 = arg0_14:getTotalMaxAddition()

	for iter0_14, iter1_14 in pairs(var0_14) do
		var0_14[iter0_14] = var0_14[iter0_14] + (var1_14[iter0_14] or 0)
	end

	return var0_14
end

function var0_0.getAttrVO(arg0_15, arg1_15)
	return arg0_15.attrs[arg1_15]
end

function var0_0.existAttr(arg0_16, arg1_16)
	return not arg0_16:getAttrVO(arg1_16):isLock()
end

function var0_0.getEffects(arg0_17)
	return arg0_17.effects
end

function var0_0.getUnlockedVoiceList(arg0_18)
	local var0_18 = arg0_18:getEffects()
	local var1_18 = arg0_18:getRepairRate() * 100
	local var2_18 = {}

	for iter0_18, iter1_18 in ipairs(var0_18) do
		if var1_18 >= iter1_18.progress and iter1_18.words ~= "" then
			for iter2_18, iter3_18 in ipairs(iter1_18.words) do
				table.insert(var2_18, iter3_18)
			end
		end
	end

	return var2_18
end

function var0_0.getUnlockVoiceRepairPercent(arg0_19, arg1_19)
	local var0_19 = arg0_19:getEffects()
	local var1_19 = 0

	for iter0_19, iter1_19 in ipairs(var0_19) do
		if iter1_19.words ~= "" and table.contains(iter1_19.words, arg1_19) then
			var1_19 = iter1_19.progress
		end
	end

	return var1_19
end

return var0_0
