local var0 = class("GuildConst")

var0.DEBUG = true
var0.POLICY_TYPE_POWER = 1
var0.POLICY_TYPE_RELAXATION = 2
var0.FACTION_TYPE_BLHX = 1
var0.FACTION_TYPE_CSZZ = 2
var0.REFRESH_ACTIVATION_EVENT_TIME = 30
var0.WEEKLY_TASK_PROGRESS_REFRESH_TIME = 60
var0.REFRESH_CAPITAL_TIME = 30
var0.REQUEST_ASSAULT_TIME = 30
var0.REQUEST_REPORT_TIME = 30
var0.POLICY_NAME = {
	i18n("guild_policy_power"),
	i18n("guild_policy_relax")
}
var0.FACTION_NAME = {
	i18n("guild_faction_blhx"),
	i18n("guild_faction_cszz")
}
var0.CHAT_LOG_MAX_COUNT = 100
var0.REQUEST_LOG_TIME = 300
var0.REQUEST_BOSS_TIME = 60
var0.MAX_SUPPLY_CNT = 3
var0.TYPE_DONATE = 1
var0.TYPE_SUPPLY = 2
var0.WEEKLY_TASK = 3
var0.START_BATTLE = 4
var0.SWITCH_TOGGLE = 5
var0.TECHNOLOGY = 6
var0.TECHNOLOGY_OVER = 7
var0.CMD_TYPE_JOIN = 1
var0.CMD_TYPE_SET_DUTY = 2
var0.CMD_TYPE_QUIT = 3
var0.CMD_TYPE_FIRE = 4
var0.CMD_TYPE_GET_SHIP = 5
var0.CMD_TYPE_FACILITY_CONTRIBUTION = 6
var0.CMD_TYPE_FACILITY_CONSUME = 7
var0.DUTY_COMMANDER = 1
var0.DUTY_DEPUTY_COMMANDER = 2
var0.DYTY_PICKED = 3
var0.DUTY_ORDINARY = 4
var0.DUTY_RECRUIT = 5
var0.GET_SHOP = 0
var0.AUTO_REFRESH = 1
var0.MANUAL_REFRESH = 2
var0.MAX_DISPLAY_MEMBER_SHIP = 10
var0.REPORT_STATE_LOCK = 0
var0.REPORT_STATE_UNlOCK = 1
var0.REPORT_STATE_SUBMITED = 2
var0.REPORT_TYPE_MISSION = 1
var0.REPORT_TYPE_BOSS = 2
var0.BASE_EVENT_TYPE_COMMON = 1
var0.BASE_EVENT_TYPE_ELITE = 2

function var0.MAX_REPORT_CNT()
	return pg.guildset.operation_report_max.key_value
end

var0.REQUEST_REPORT_CD = 30
var0.REQUEST_FORMATION_CD = 5
var0.MISSION_MAX_SHIP_CNT = 4
var0.FORMATION_CD_TIME = 21600
var0.MISSION_MAX_FLEET_CNT = 4
var0.RECOMMAND_SHIP = 0
var0.CANCEL_RECOMMAND_SHIP = 1

function var0.MISSION_BOSS_MAX_CNT()
	return pg.guildset.operation_daily_boss_count.key_value
end

var0.REFRESH_MISSION_BOSS_RANK_TIME = 300
var0.FORCE_REFRESH_MISSION_BOSS_RANK_TIME = 1800
var0.REFRESH_MISSION_TIME = 30
var0.REFRESH_LATELY_NODE_TIME = 60
var0.FORCE_REFRESH_MISSION_TREE_TIME = 1800
var0.REFRESH_BOSS_TIME = 60
var0.FORCE_REFRESH_BOSS_TIME = 300
var0.TYPE_GUILD_MEMBER_CNT = "bigfleet_seats"
var0.TYPE_GOLD_MAX = "gold_max"
var0.TYPE_OIL_MAX = "oil_max"
var0.TYPE_SHIP_BAG = "ship_bag_size"
var0.TYPE_EQUIPMENT_BAG = "equip_bag_size"
var0.TYPE_CATBOX_GOLD_COST = "catbox_gold_cost"
var0.TYPE_CATBOX_TIME_COST_R = "catbox_time_cost_R"
var0.TYPE_CATBOX_TIME_COST_SR = "catbox_time_cost_SR"
var0.TYPE_CATBOX_TIME_COST_SSR = "catbox_time_cost_SSR"
var0.TYPE_TO_GROUP = {
	[var0.TYPE_GUILD_MEMBER_CNT] = 1,
	[var0.TYPE_GOLD_MAX] = 2,
	[var0.TYPE_OIL_MAX] = 3,
	[var0.TYPE_SHIP_BAG] = 4,
	[var0.TYPE_EQUIPMENT_BAG] = 5,
	[var0.TYPE_CATBOX_GOLD_COST] = 6,
	[var0.TYPE_CATBOX_TIME_COST_R] = 7,
	[var0.TYPE_CATBOX_TIME_COST_SR] = 8,
	[var0.TYPE_CATBOX_TIME_COST_SSR] = 9
}

function var0.GET_TECHNOLOGY_GROUP_DESC(arg0, arg1, arg2)
	local var0 = arg0[1]
	local var1 = "<color=" .. COLOR_GREEN .. ">" .. arg2 .. "</color>"

	if arg1 == arg2 then
		var1 = arg1
	end

	if var0 == GuildConst.TYPE_GOLD_MAX then
		return i18n("guild_tech_gold_desc", var1)
	elseif var0 == GuildConst.TYPE_OIL_MAX then
		return i18n("guild_tech_oil_desc", var1)
	elseif var0 == GuildConst.TYPE_SHIP_BAG then
		return i18n("guild_tech_shipbag_desc", var1)
	elseif var0 == GuildConst.TYPE_EQUIPMENT_BAG then
		return i18n("guild_tech_equipbag_desc", var1)
	elseif var0 == GuildConst.TYPE_CATBOX_GOLD_COST then
		return i18n("guild_box_gold_desc", var1)
	elseif var0 == GuildConst.TYPE_CATBOX_TIME_COST_R then
		return i18n("guidl_r_box_time_desc", var1)
	elseif var0 == GuildConst.TYPE_CATBOX_TIME_COST_SR then
		return i18n("guidl_sr_box_time_desc", var1)
	elseif var0 == GuildConst.TYPE_CATBOX_TIME_COST_SSR then
		return i18n("guidl_ssr_box_time_desc", var1)
	elseif var0 == GuildConst.TYPE_GUILD_MEMBER_CNT then
		return i18n("guild_member_max_cnt_desc", var1)
	else
		local var2 = arg0[2]
		local var3 = _.map(var2, function(arg0)
			return pg.ship_data_by_type[arg0].type_name
		end)
		local var4 = table.concat(var3, ",")

		return i18n("guild_ship_attr_desc", var4, AttributeType.Type2Name(var0), var1)
	end
end

function var0.GET_TECHNOLOGY_DESC(arg0, arg1)
	local var0 = arg0[1]

	arg1 = "<color=" .. COLOR_GREEN .. ">" .. arg1 .. "</color>"

	if var0 == GuildConst.TYPE_GOLD_MAX then
		return i18n("guild_tech_gold_desc", arg1)
	elseif var0 == GuildConst.TYPE_OIL_MAX then
		return i18n("guild_tech_oil_desc", arg1)
	elseif var0 == GuildConst.TYPE_SHIP_BAG then
		return i18n("guild_tech_shipbag_desc", arg1)
	elseif var0 == GuildConst.TYPE_EQUIPMENT_BAG then
		return i18n("guild_tech_equipbag_desc", arg1)
	elseif var0 == GuildConst.TYPE_CATBOX_GOLD_COST then
		return i18n("guild_box_gold_desc", arg1)
	elseif var0 == GuildConst.TYPE_CATBOX_TIME_COST_R then
		return i18n("guidl_r_box_time_desc", arg1)
	elseif var0 == GuildConst.TYPE_CATBOX_TIME_COST_SR then
		return i18n("guidl_sr_box_time_desc", arg1)
	elseif var0 == GuildConst.TYPE_CATBOX_TIME_COST_SSR then
		return i18n("guidl_ssr_box_time_desc", arg1)
	elseif var0 == GuildConst.TYPE_GUILD_MEMBER_CNT then
		return i18n("guild_member_max_cnt_desc", arg1)
	else
		local var1 = arg0[2]
		local var2 = _.map(var1, function(arg0)
			return pg.ship_data_by_type[arg0].type_name
		end)
		local var3 = table.concat(var2, ",")

		return i18n("guild_ship_attr_desc", var3, AttributeType.Type2Name(var0), arg1)
	end
end

return var0
