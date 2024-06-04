local var0 = class("PowerRank", import(".PlayerAttire"))

var0.TYPE_POWER = 1
var0.TYPE_COLLECTION = 2
var0.TYPE_PT = 3
var0.TYPE_PLEDGE = 4
var0.TYPE_CHALLENGE = 5
var0.TYPE_EXTRA_CHAPTER = 6
var0.TYPE_ACT_BOSS_BATTLE = 7
var0.TYPE_GUILD_BATTLE = 8
var0.TYPE_MILITARY_RANK = 9
var0.TYPE_BOSSRUSH = 10
var0.typeInfo = {
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

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg1)

	arg0.id = arg1.user_id or arg1.id
	arg0.lv = arg1.lv or arg1.level
	arg0.name = arg1.name
	arg0.power = arg1.point or arg1.score or 0
	arg0.rank = arg1.rank or 0
	arg0.arenaRank = math.min(math.max(arg1.arena_rank or 0, 1), 14)

	assert(arg2, "type can not be nil")

	arg0.type = arg2
end

function var0.getPainting(arg0)
	local var0 = pg.ship_skin_template[arg0.skinId]

	return var0 and var0.painting or "unknown"
end

function var0.setRank(arg0, arg1)
	arg0.rank = arg1
end

function var0.setArenaRank(arg0, arg1)
	arg0.arenaRank = arg1
end

function var0.getPowerTxt(arg0)
	if arg0.type == var0.TYPE_POWER then
		return math.floor(arg0.power^0.667)
	elseif arg0.type == var0.TYPE_COLLECTION then
		local var0 = getProxy(CollectionProxy):getCollectionTotal()

		return string.format("%0.01f", arg0.power / var0 * 100) .. "%"
	elseif arg0.type == var0.TYPE_MILITARY_RANK then
		return arg0.power + SeasonInfo.INIT_POINT
	else
		return arg0.power
	end
end

function var0.getTitleWord(arg0, arg1, arg2)
	local var0 = {}

	for iter0 = 1, 4 do
		table.insert(var0, i18n("ranking_word_" .. var0.typeInfo[arg1].title_word[iter0]))
	end

	if arg1 == var0.TYPE_PT then
		local var1 = id2ItemId(getProxy(ActivityProxy):getActivityById(arg2):getConfig("config_id"))

		var0[4] = Item.getConfigData(var1).name
	end

	return var0
end

function var0.getScoreIcon(arg0, arg1)
	return var0.typeInfo[arg1].score_icon
end

function var0.getActivityByRankType(arg0, arg1)
	if not var0.typeInfo[arg1].act_type then
		return nil
	end

	return _.detect(getProxy(ActivityProxy):getActivitiesByType(var0.typeInfo[arg1].act_type), function(arg0)
		return not arg0:isEnd() and (arg1 ~= var0.TYPE_PT or tonumber(arg0:getConfig("config_data")) > 0)
	end)
end

return var0
