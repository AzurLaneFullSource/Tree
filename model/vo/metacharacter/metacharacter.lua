local var0 = class("MetaCharacter", import("..BaseVO"))

function var0.bindConfigTable(arg0)
	return pg.ship_strengthen_meta
end

function var0.Ctor(arg0, arg1, arg2)
	assert(arg1.id)
	assert(arg2)

	arg0.id = arg1.id
	arg0.configId = arg0.id
	arg0.shipVO = arg2
	arg0.maxRepairExp = arg0:getConfig("repair_total_exp")
	arg0.attrs = {}

	for iter0, iter1 in ipairs(MetaCharacterConst.REPAIR_ATTRS) do
		arg0.attrs[iter1] = MetaCharacterAttr.New({
			attr = iter1,
			items = arg0:getConfig("repair_" .. iter1)
		})
	end

	arg0.effects = _.map(arg0:getConfig("repair_effect"), function(arg0)
		return MetaRepairEffect.New({
			id = arg0[2],
			progress = arg0[1]
		})
	end)

	for iter2, iter3 in ipairs(arg1.repair_attr_info or {}) do
		for iter4, iter5 in pairs(arg0.attrs) do
			if iter5:hasItemId(iter3) then
				local var0 = iter5:getLevelByItemId(iter3)

				iter5:updateCount(var0)
			end
		end
	end
end

function var0.getBreakOutInfo(arg0)
	assert(arg0.shipVO)

	local var0 = arg0.shipVO

	if not arg0.beakOutInfo or var0.configId ~= arg0.beakOutInfo.id then
		arg0.beakOutInfo = MetaCharacterBreakout.New({
			id = var0.configId
		})
	end

	return arg0.beakOutInfo
end

function var0.getSpecialMaterialInfoToMaxStar(arg0)
	local var0 = arg0:getBreakOutInfo()
	local var1 = {
		count = 0,
		itemID = arg0.beakOutInfo:getConfig("item1")
	}

	while true do
		if not var0:hasNextInfo() then
			return var1
		else
			var1.count = var1.count + var0:getConfig("item1_num")
			var0 = var0:getNextInfo()
		end
	end
end

function var0.getCurRepairExp(arg0)
	local var0 = 0

	for iter0, iter1 in pairs(arg0.attrs) do
		var0 = var0 + iter1:getRepairExp()
	end

	return var0
end

function var0.getMaxRepairExp(arg0)
	return arg0.maxRepairExp
end

function var0.getRepairRate(arg0)
	return arg0:getCurRepairExp() / arg0:getMaxRepairExp()
end

function var0.isMaxRepairExp(arg0)
	return arg0:getCurRepairExp() == arg0:getMaxRepairExp()
end

function var0.getAttrAddition(arg0, arg1)
	return arg0:getRepairAddition(arg1) + arg0:getPercentageAddition(arg1)
end

function var0.getPercentageAddition(arg0, arg1)
	local var0 = 0
	local var1 = arg0:getRepairRate() * 100

	for iter0, iter1 in ipairs(arg0.effects) do
		if var1 >= iter1.progress then
			var0 = var0 + iter1:getAttrAddition(arg1)
		end
	end

	return var0
end

function var0.getRepairAddition(arg0, arg1)
	local var0 = 0
	local var1 = arg0.attrs[arg1]

	if var1 and var1:isLock() then
		return 0
	end

	if var1 then
		var0 = var0 + var1:getAddition()
	end

	return var0
end

function var0.getTotalMaxAddition(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.attrs) do
		local var1 = iter1.attr
		local var2 = 0

		if iter1 and iter1:isLock() then
			var2 = 0
		else
			local var3 = Clone(iter1)

			var3.level = var3:getItemCount() + 1
			var2 = var2 + var3:getAddition()
		end

		if var0[var1] then
			var0[var1] = var0[var1] + var2
		else
			var0[var1] = var2
		end
	end

	for iter2, iter3 in ipairs(arg0.effects) do
		local var4 = iter3:getAttrAdditionList()

		for iter4, iter5 in ipairs(var4) do
			local var5 = iter5[1]
			local var6 = iter5[2]

			if var0[var5] then
				var0[var5] = var0[var5] + var6
			else
				var0[var5] = var6
			end
		end
	end

	return var0
end

function var0.getFinalAddition(arg0, arg1)
	assert(arg1, "shipVO can not be nil")

	local var0 = arg1:getBaseProperties()
	local var1 = arg0:getTotalMaxAddition()

	for iter0, iter1 in pairs(var0) do
		var0[iter0] = var0[iter0] + (var1[iter0] or 0)
	end

	return var0
end

function var0.getAttrVO(arg0, arg1)
	return arg0.attrs[arg1]
end

function var0.existAttr(arg0, arg1)
	return not arg0:getAttrVO(arg1):isLock()
end

function var0.getEffects(arg0)
	return arg0.effects
end

function var0.getUnlockedVoiceList(arg0)
	local var0 = arg0:getEffects()
	local var1 = arg0:getRepairRate() * 100
	local var2 = {}

	for iter0, iter1 in ipairs(var0) do
		if var1 >= iter1.progress and iter1.words ~= "" then
			for iter2, iter3 in ipairs(iter1.words) do
				table.insert(var2, iter3)
			end
		end
	end

	return var2
end

function var0.getUnlockVoiceRepairPercent(arg0, arg1)
	local var0 = arg0:getEffects()
	local var1 = 0

	for iter0, iter1 in ipairs(var0) do
		if iter1.words ~= "" and table.contains(iter1.words, arg1) then
			var1 = iter1.progress
		end
	end

	return var1
end

return var0
