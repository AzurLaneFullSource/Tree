local var0_0 = class("GuildCapitalLog", import("..BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.memberId = arg1_1.member_id
	arg0_1.name = arg1_1.name
	arg0_1.eventType = arg1_1.event_type
	arg0_1.eventTarget = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.event_target) do
		table.insert(arg0_1.eventTarget, iter1_1)
	end

	arg0_1.time = arg1_1.time
	arg0_1.text = arg0_1:buildText()
end

function var0_0.buildText(arg0_2)
	local var0_2 = ""
	local var1_2 = pg.TimeMgr:GetInstance():STimeDescC(arg0_2.time)
	local var2_2 = arg0_2.eventTarget[1]

	if arg0_2.eventType == GuildConst.TYPE_DONATE then
		local var3_2 = pg.guild_contribution_template[var2_2]
		local var4_2

		if var3_2.type == DROP_TYPE_RESOURCE then
			var4_2 = Item.New({
				id = id2ItemId(var3_2.type_id)
			}):getConfig("name")
		else
			var4_2 = Item.New({
				id = var3_2.type_id
			}):getConfig("name")
		end

		var0_2 = i18n("guild_donate_log", var1_2, arg0_2.name, var3_2.consume, var4_2, var3_2.award_capital)
	elseif arg0_2.eventType == GuildConst.TYPE_SUPPLY then
		local var5_2 = getProxy(GuildProxy):getRawData()

		if var5_2 then
			local var6_2, var7_2 = var5_2:getSupplyConsume()

			var0_2 = i18n("guild_supply_log", var1_2, arg0_2.name, var6_2, var7_2)
		end
	elseif arg0_2.eventType == GuildConst.WEEKLY_TASK then
		var0_2 = i18n("guild_weektask_log", var1_2, var2_2)
	elseif arg0_2.eventType == GuildConst.START_BATTLE then
		var0_2 = i18n("guild_battle_log", var1_2, arg0_2.name, var2_2)
	elseif arg0_2.eventType == GuildConst.TECHNOLOGY then
		local var8_2 = pg.guild_technology_template[var2_2]

		assert(var8_2, var2_2)

		local var9_2 = var8_2.contribution_consume
		local var10_2 = var8_2.name

		var0_2 = i18n("guild_tech_log", var1_2, arg0_2.name, var9_2, var10_2, level)
	elseif arg0_2.eventType == GuildConst.TECHNOLOGY_OVER then
		local var11_2 = pg.guild_technology_template[var2_2]

		assert(var11_2, var2_2)

		local var12_2 = var11_2.contribution_consume
		local var13_2 = var11_2.name

		var0_2 = i18n("guild_tech_over_log", var1_2, arg0_2.name, var13_2)
	elseif arg0_2.eventType == GuildConst.SWITCH_TOGGLE then
		local var14_2 = pg.guild_technology_template[var2_2].name

		var0_2 = i18n("guild_tech_change_log", var1_2, arg0_2.name, var14_2)
	end

	return var0_2
end

function var0_0.getText(arg0_3)
	return arg0_3.text
end

function var0_0.IsSameType(arg0_4, arg1_4)
	return _.any(arg1_4, function(arg0_5)
		return arg0_4.eventType == arg0_5
	end)
end

return var0_0
