local var0_0 = class("IslandAddShipStatusHelper")

function var0_0.CheckAddStatus(arg0_1, arg1_1, arg2_1, arg3_1)
	local var0_1 = pg.island_buff_template[arg2_1]

	assert(var0_1, arg2_1)

	var0_0.tipList = {}

	seriesAsync({
		function(arg0_2)
			var0_0.CheckType(arg0_1, arg1_1, var0_1, arg0_2)
		end,
		function(arg0_3)
			onNextTick(arg0_3)
		end,
		function(arg0_4)
			var0_0.CheckSpecific(arg0_1, arg1_1, var0_1, arg0_4)
		end,
		function(arg0_5)
			onNextTick(arg0_5)
		end,
		function(arg0_6)
			var0_0.CheckLevelInSameGroup(arg0_1, arg1_1, var0_1, arg0_6)
		end,
		function(arg0_7)
			var0_0.tipList = {}

			arg0_7()
		end
	}, arg3_1)
end

function var0_0.IsTip(arg0_8)
	return table.contains(var0_0.tipList, arg0_8)
end

function var0_0.CheckType(arg0_9, arg1_9, arg2_9, arg3_9)
	local var0_9 = arg2_9.type_duel
	local var1_9 = arg1_9:GetVaildStatus()
	local var2_9 = _.detect(var1_9, function(arg0_10)
		return table.contains(var0_9, arg0_10:GetGroup())
	end)

	if var2_9 and not var0_0.IsTip(var2_9.id) then
		arg0_9:ShowMsgBox({
			content = i18n("island_ship_buff_cover"),
			type = IslandMsgBox.TYPE_SHIP_STATUS_MSG,
			buff = var2_9,
			onYes = arg3_9
		})
		table.insert(var0_0.tipList, var2_9.id)
	else
		arg3_9()
	end
end

function var0_0.CheckSpecific(arg0_11, arg1_11, arg2_11, arg3_11)
	local var0_11 = arg2_11.buff_duel
	local var1_11 = arg1_11:GetVaildStatus()
	local var2_11 = _.detect(var1_11, function(arg0_12)
		return table.contains(var0_11, arg0_12.id)
	end)

	if var2_11 and not var0_0.IsTip(var2_11.id) then
		arg0_11:ShowMsgBox({
			content = i18n("island_ship_buff_cover_1"),
			type = IslandMsgBox.TYPE_SHIP_STATUS_MSG,
			buff = var2_11,
			onYes = arg3_11
		})
		table.insert(var0_0.tipList, var2_11.id)
	else
		arg3_11()
	end
end

function var0_0.CheckLevelInSameGroup(arg0_13, arg1_13, arg2_13, arg3_13)
	local var0_13 = arg1_13:GetVaildStatusByGroup(arg2_13.buff_group)
	local var1_13 = _.detect(var0_13, function(arg0_14)
		return arg0_14:GetLevel() > arg2_13.buff_level
	end)

	if var1_13 and not var0_0.IsTip(var1_13.id) then
		arg0_13:ShowMsgBox({
			content = i18n("island_ship_buff_cover_2"),
			type = IslandMsgBox.TYPE_SHIP_STATUS_MSG,
			buff = var1_13,
			onYes = arg3_13
		})
	elseif #var0_13 > 0 and _.all(var0_13, function(arg0_15)
		return arg0_15:GetLevel() < arg2_13.buff_level
	end) and not var0_0.IsTip(var0_13[1].id) then
		arg0_13:ShowMsgBox({
			content = i18n("island_ship_buff_cover_3"),
			type = IslandMsgBox.TYPE_SHIP_STATUS_MSG,
			buff = var0_13[1],
			onYes = arg3_13
		})
	else
		arg3_13()
	end
end

return var0_0
