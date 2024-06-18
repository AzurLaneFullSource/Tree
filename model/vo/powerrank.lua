local var0_0 = class("PowerRank", import(".PlayerAttire"))

var0_0.TYPE_POWER = 1
var0_0.TYPE_COLLECTION = 2
var0_0.TYPE_PT = 3
var0_0.TYPE_PLEDGE = 4
var0_0.TYPE_CHALLENGE = 5
var0_0.TYPE_EXTRA_CHAPTER = 6
var0_0.TYPE_ACT_BOSS_BATTLE = 7
var0_0.TYPE_GUILD_BATTLE = 8
var0_0.TYPE_MILITARY_RANK = 9
var0_0.TYPE_BOSSRUSH = 10
var0_0.typeInfo = {
	{
		title_word = {
			5,
			8,
			7,
			1
		},
		score_icon = {
			"ui/billboardui_atlas",
			"power_icon"
		}
	},
	{
		title_word = {
			5,
			8,
			7,
			2
		}
	},
	{
		title_word = {
			5,
			8,
			7,
			2
		},
		score_icon = {
			"ui/commonui_atlas",
			"pt_icon"
		},
		act_type = ActivityConst.ACTIVITY_TYPE_PT_RANK
	},
	{
		title_word = {
			5,
			8,
			7,
			3
		}
	},
	{
		title_word = {
			5,
			8,
			7,
			4
		},
		act_type = ActivityConst.ACTIVITY_TYPE_CHALLENGE_RANK
	},
	{
		title_word = {
			5,
			8,
			7,
			4
		},
		act_type = ActivityConst.ACTIVITY_TYPE_EXTRA_CHAPTER_RANK
	},
	{
		title_word = {
			5,
			8,
			7,
			10
		},
		act_type = ActivityConst.ACTIVITY_TYPE_BOSS_RANK
	},
	[9] = {
		title_word = {
			5,
			8,
			6,
			9
		},
		score_icon = {
			"ui/billboardui_atlas",
			"rank_icon"
		}
	},
	[10] = {
		title_word = {
			5,
			8,
			7,
			4
		},
		act_type = ActivityConst.ACTIVITY_TYPE_EXTRA_BOSSRUSH_RANK
	}
}

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.id = arg1_1.user_id or arg1_1.id
	arg0_1.lv = arg1_1.lv or arg1_1.level
	arg0_1.name = arg1_1.name
	arg0_1.power = arg1_1.point or arg1_1.score or 0
	arg0_1.rank = arg1_1.rank or 0
	arg0_1.arenaRank = math.min(math.max(arg1_1.arena_rank or 0, 1), 14)

	assert(arg2_1, "type can not be nil")

	arg0_1.type = arg2_1
end

function var0_0.getPainting(arg0_2)
	local var0_2 = pg.ship_skin_template[arg0_2.skinId]

	return var0_2 and var0_2.painting or "unknown"
end

function var0_0.setRank(arg0_3, arg1_3)
	arg0_3.rank = arg1_3
end

function var0_0.setArenaRank(arg0_4, arg1_4)
	arg0_4.arenaRank = arg1_4
end

function var0_0.getPowerTxt(arg0_5)
	if arg0_5.type == var0_0.TYPE_POWER then
		return math.floor(arg0_5.power^0.667)
	elseif arg0_5.type == var0_0.TYPE_COLLECTION then
		local var0_5 = getProxy(CollectionProxy):getCollectionTotal()

		return string.format("%0.01f", arg0_5.power / var0_5 * 100) .. "%"
	elseif arg0_5.type == var0_0.TYPE_MILITARY_RANK then
		return arg0_5.power + SeasonInfo.INIT_POINT
	else
		return arg0_5.power
	end
end

function var0_0.getTitleWord(arg0_6, arg1_6, arg2_6)
	local var0_6 = {}

	for iter0_6 = 1, 4 do
		table.insert(var0_6, i18n("ranking_word_" .. var0_0.typeInfo[arg1_6].title_word[iter0_6]))
	end

	if arg1_6 == var0_0.TYPE_PT then
		local var1_6 = id2ItemId(getProxy(ActivityProxy):getActivityById(arg2_6):getConfig("config_id"))

		var0_6[4] = Item.getConfigData(var1_6).name
	end

	return var0_6
end

function var0_0.getScoreIcon(arg0_7, arg1_7)
	return var0_0.typeInfo[arg1_7].score_icon
end

function var0_0.getActivityByRankType(arg0_8, arg1_8)
	if not var0_0.typeInfo[arg1_8].act_type then
		return nil
	end

	return _.detect(getProxy(ActivityProxy):getActivitiesByType(var0_0.typeInfo[arg1_8].act_type), function(arg0_9)
		return not arg0_9:isEnd() and (arg1_8 ~= var0_0.TYPE_PT or tonumber(arg0_9:getConfig("config_data")) > 0)
	end)
end

return var0_0
