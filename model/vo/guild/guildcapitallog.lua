local var0 = class("GuildCapitalLog", import("..BaseVO"))

function var0.Ctor(arg0, arg1)
	arg0.memberId = arg1.member_id
	arg0.name = arg1.name
	arg0.eventType = arg1.event_type
	arg0.eventTarget = {}

	for iter0, iter1 in ipairs(arg1.event_target) do
		table.insert(arg0.eventTarget, iter1)
	end

	arg0.time = arg1.time
	arg0.text = arg0:buildText()
end

function var0.buildText(arg0)
	local var0 = ""
	local var1 = pg.TimeMgr:GetInstance():STimeDescC(arg0.time)
	local var2 = arg0.eventTarget[1]

	if arg0.eventType == GuildConst.TYPE_DONATE then
		local var3 = pg.guild_contribution_template[var2]
		local var4

		if var3.type == DROP_TYPE_RESOURCE then
			var4 = Item.New({
				id = id2ItemId(var3.type_id)
			}):getConfig("name")
		else
			var4 = Item.New({
				id = var3.type_id
			}):getConfig("name")
		end

		var0 = i18n("guild_donate_log", var1, arg0.name, var3.consume, var4, var3.award_capital)
	elseif arg0.eventType == GuildConst.TYPE_SUPPLY then
		local var5 = getProxy(GuildProxy):getRawData()

		if var5 then
			local var6, var7 = var5:getSupplyConsume()

			var0 = i18n("guild_supply_log", var1, arg0.name, var6, var7)
		end
	elseif arg0.eventType == GuildConst.WEEKLY_TASK then
		var0 = i18n("guild_weektask_log", var1, var2)
	elseif arg0.eventType == GuildConst.START_BATTLE then
		var0 = i18n("guild_battle_log", var1, arg0.name, var2)
	elseif arg0.eventType == GuildConst.TECHNOLOGY then
		local var8 = pg.guild_technology_template[var2]

		assert(var8, var2)

		local var9 = var8.contribution_consume
		local var10 = var8.name

		var0 = i18n("guild_tech_log", var1, arg0.name, var9, var10, level)
	elseif arg0.eventType == GuildConst.TECHNOLOGY_OVER then
		local var11 = pg.guild_technology_template[var2]

		assert(var11, var2)

		local var12 = var11.contribution_consume
		local var13 = var11.name

		var0 = i18n("guild_tech_over_log", var1, arg0.name, var13)
	elseif arg0.eventType == GuildConst.SWITCH_TOGGLE then
		local var14 = pg.guild_technology_template[var2].name

		var0 = i18n("guild_tech_change_log", var1, arg0.name, var14)
	end

	return var0
end

function var0.getText(arg0)
	return arg0.text
end

function var0.IsSameType(arg0, arg1)
	return _.any(arg1, function(arg0)
		return arg0.eventType == arg0
	end)
end

return var0
