local var0 = class("WorldBossConst")

var0.WORLD_BOSS_ITEM_ID = 100000
var0.WORLD_PAST_BOSS_ITEM_ID = 100002
var0.ACHIEVE_STATE_NOSTART = 1
var0.ACHIEVE_STATE_STARTING = 2
var0.ACHIEVE_STATE_CLEAR = 3
var0.BOSS_TYPE_CURR = 1
var0.BOSS_TYPE_ARCHIVES = 2
var0.STOP_AUTO_BATTLE_MANUAL = 1
var0.STOP_AUTO_BATTLE_TIMEOVER = 2
var0.AUTO_BATTLE_STATE_NORMAL = 0
var0.AUTO_BATTLE_STATE_LOCK = 1
var0.AUTO_BATTLE_STATE_STARTING = 2
var0.AUTO_BATTLE_STATE_HIDE = 3

function var0.__IsCurrBoss(arg0)
	return var0.GetCurrBossID() == arg0
end

function var0.IsAchieveBoss(arg0)
	local var0 = var0.GetAchieveBossIdList()

	return table.contains(var0, arg0)
end

function var0.IsCurrBoss(arg0)
	return var0.GetCurrBossGroup() == arg0
end

function var0._IsCurrBoss(arg0)
	local var0 = arg0.config.id

	return var0.GetCurrBossID() == var0
end

function var0.GetCurrBossGroup()
	local var0 = pg.world_joint_boss_template

	for iter0 = #var0.all, 1, -1 do
		local var1 = var0.all[iter0]

		if type(var0[var1].state) == "table" and pg.TimeMgr.GetInstance():inTime(var0[var1].state) then
			return var0[var1].meta_id
		end
	end

	return nil
end

function var0.GetCurrBossID()
	local var0 = pg.world_joint_boss_template

	for iter0 = #var0.all, 1, -1 do
		local var1 = var0.all[iter0]

		if type(var0[var1].state) == "table" and pg.TimeMgr.GetInstance():inTime(var0[var1].state) then
			return var0[var1].id
		end
	end

	return nil
end

function var0.GetCurrBossLeftDay()
	local var0 = var0.GetCurrBossID()
	local var1 = pg.world_joint_boss_template[var0]
	local var2 = pg.TimeMgr.GetInstance():GetServerTime()
	local var3 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var1.state[2])
	local var4 = var3 - var2

	return pg.TimeMgr.GetInstance():DiffDay(var2, var3), var4 % 86400
end

function var0.GetCurrBossDayIndex()
	local var0 = var0.GetCurrBossID()
	local var1 = pg.world_joint_boss_template[var0]
	local var2 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var1.state[1])
	local var3 = pg.TimeMgr.GetInstance()
	local var4 = var3:GetServerTime()

	return var3:DiffDay(var2, var4) + 1
end

function var0.GetCurrBossStartTimeAndEndTime()
	local var0 = var0.GetCurrBossID()

	return pg.world_joint_boss_template[var0].state
end

function var0.GetCurrBossConsume()
	local var0 = pg.gameset.curr_boss_ticket.description
	local var1 = var0[1]
	local var2 = var0[2]
	local var3 = var0[3]

	return var1, var2, var3
end

function var0.GetCurrBossItemProgress()
	return nowWorld().worldBossProxy:GetSummonPt()
end

function var0.GetCurrBossItemAcc()
	return nowWorld().worldBossProxy:GetSummonPtDailyAcc()
end

function var0.CanUnlockCurrBoss()
	return var0.GetCurrBossItemProgress() >= var0.GetCurrBossConsume()
end

function var0.GetCurrBossItemCapacity()
	local var0 = var0.GetCurrBossItemProgress()
	local var1 = var0.GetCurrBossItemAcc()
	local var2, var3, var4 = var0.GetCurrBossConsume()

	return var0, var1, var3, var4
end

function var0.GetAchieveBossConsume()
	local var0 = pg.gameset.past_joint_boss_ticket.description
	local var1 = var0[1]
	local var2 = var0[2]
	local var3 = var0[3]

	return var1, var2, var3
end

function var0.GetAchieveBossItemProgress()
	return nowWorld().worldBossProxy:GetSummonPtOld()
end

function var0.GetSummonPtOldAcc()
	return nowWorld().worldBossProxy:GetSummonPtOldAcc()
end

function var0.CanUnlockArchivesBoss()
	return var0.GetAchieveBossItemProgress() >= var0.GetAchieveBossConsume()
end

function var0.GetAchieveBossItemCapacity()
	local var0 = var0.GetAchieveBossItemProgress()
	local var1 = var0.GetSummonPtOldAcc()
	local var2, var3, var4 = var0.GetAchieveBossConsume()

	return var0, var1, var3, var4
end

function var0.GetAchieveBossIdList()
	local var0 = {}
	local var1 = pg.world_joint_boss_template

	for iter0 = 1, #var1.all do
		local var2 = var1.all[iter0]

		if var1[var2].state == "always" then
			table.insert(var0, var1[var2].meta_id)
		end
	end

	return var0
end

function var0.GetAchieveBossList()
	local var0 = {}
	local var1 = pg.world_joint_boss_template

	for iter0 = 1, #var1.all do
		local var2 = var1.all[iter0]

		if var1[var2].state == "always" then
			table.insert(var0, var1[var2])
		end
	end

	return var0
end

function var0.GetCurrBossItemInfo()
	local var0, var1, var2, var3 = WorldBossConst.GetCurrBossItemCapacity()
	local var4 = i18n("world_boss_item_info")
	local var5 = string.split(var4, "|")
	local var6 = var5[2]

	for iter0, iter1 in ipairs({
		var1,
		var2,
		var0,
		var3
	}) do
		var6 = string.gsub(var6, "$" .. iter0, iter1)
	end

	return {
		rarity = 4,
		name = var5[1],
		display = var6,
		icon = {
			"Props/world_boss_record"
		}
	}
end

function var0.GetAchieveBossItemInfo()
	local var0, var1, var2, var3 = WorldBossConst.GetAchieveBossItemCapacity()
	local var4 = i18n("world_past_boss_item_info")
	local var5 = string.split(var4, "|")
	local var6 = var5[2]

	for iter0, iter1 in ipairs({
		var1,
		var2,
		var0,
		var3
	}) do
		var6 = string.gsub(var6, "$" .. iter0, iter1)
	end

	return {
		rarity = 4,
		name = var5[1],
		display = var6,
		icon = {
			"Props/world_past_boss_record"
		}
	}
end

function var0.IsClearAllAchieveBoss()
	local var0 = var0.GetAchieveBossIdList()

	return _.all(var0, function(arg0)
		return not getProxy(MetaCharacterProxy):getMetaProgressVOByID(arg0).metaPtData:CanGetNextAward()
	end)
end

function var0.GetArchivesId()
	return nowWorld():GetBossProxy():GetArchivesId()
end

function var0.GetAchieveState()
	local var0 = var0.GetArchivesId()

	if var0 == 0 then
		return var0.ACHIEVE_STATE_NOSTART
	end

	if #var0.GetAchieveBossIdList() == 0 then
		return var0.ACHIEVE_STATE_NOSTART
	elseif var0.IsClearAllAchieveBoss() then
		return var0.ACHIEVE_STATE_CLEAR
	else
		local var1 = pg.world_joint_boss_template[var0].meta_id
		local var2 = getProxy(MetaCharacterProxy):getMetaProgressVOByID(var1)

		if not var2.metaPtData:CanGetNextAward() or var2.metaPtData:IsMaxPt() then
			return var0.ACHIEVE_STATE_NOSTART
		else
			return var0.ACHIEVE_STATE_STARTING
		end
	end
end

function var0.GetBossOilConsume(arg0)
	local var0 = pg.gameset.joint_boss_oil_consume.description

	arg0 = math.min(arg0, #var0)

	return var0[arg0]
end

function var0.GetArchivesBossAutoBattleSecond()
	return pg.gameset.past_joint_boss_autofight_time.key_value
end

function var0.GetArchivesBossAutoBattleMinute()
	local var0 = var0.GetArchivesBossAutoBattleSecond()

	return math.ceil(var0 / 60)
end

function var0.GetHighestDamage()
	local var0 = nowWorld():GetBossProxy()

	return math.max(var0:GetHighestDamage(), 1)
end

function var0.GetAutoBattleCnt()
	local var0 = nowWorld():GetBossProxy():GetSelfBoss()
	local var1 = var0.GetHighestDamage()

	return math.ceil(var0.hp / var1)
end

function var0.GetAutoBattleOilConsume()
	local var0 = var0.GetAutoBattleCnt()
	local var1 = nowWorld():GetBossProxy():GetSelfBoss()
	local var2 = 0
	local var3 = var1.fightCount

	for iter0 = var3 + 1, var3 + var0 do
		var2 = var2 + WorldBossConst.GetBossOilConsume(iter0)
	end

	return var2
end

function var0.InAutoBattle()
	return nowWorld():GetBossProxy():InAutoBattle()
end

function var0.GetAutoBattleLeftTime()
	return nowWorld():GetBossProxy():GetAutoBattleFinishTime() - pg.TimeMgr.GetInstance():GetServerTime()
end

function var0.GetAutoBattleState(arg0)
	if not arg0 or arg0:isDeath() then
		return var0.AUTO_BATTLE_STATE_HIDE
	end

	if WorldBossConst.InAutoBattle() then
		return var0.AUTO_BATTLE_STATE_STARTING
	elseif arg0:isDeath() then
		return var0.AUTO_BATTLE_STATE_HIDE
	elseif arg0:GetSelfFightCnt() <= 0 or nowWorld():GetBossProxy():GetHighestDamage() <= 0 then
		return var0.AUTO_BATTLE_STATE_LOCK
	else
		return var0.AUTO_BATTLE_STATE_NORMAL
	end
end

function var0.BossId2MetaId(arg0)
	return pg.world_joint_boss_template[arg0].meta_id
end

function var0.MetaId2BossId(arg0)
	for iter0, iter1 in ipairs(pg.world_joint_boss_template.all) do
		if var0.BossId2MetaId(iter1) == arg0 then
			return iter1
		end
	end
end

function var0.AnyArchivesBossCanGetAward()
	return _.any(var0.GetAchieveBossIdList(), function(arg0)
		return getProxy(MetaCharacterProxy):getMetaProgressVOByID(arg0).metaPtData:CanGetAward()
	end)
end

function var0.GetCommissionSceneMetaBossBtnState()
	local var0 = nowWorld()

	if not var0 or not var0:IsActivate() then
		return CommissionMetaBossBtn.STATE_LOCK
	end

	local var1 = var0:GetBossProxy()

	if not var1 or not var1.isSetup or not var1:IsOpen() then
		return CommissionMetaBossBtn.STATE_LOCK
	end

	local var2 = var1:GetSelfBoss()

	if var2 and WorldBossConst.GetAutoBattleState(var2) == WorldBossConst.AUTO_BATTLE_STATE_STARTING then
		if WorldBossConst.GetAutoBattleLeftTime() > 0 then
			return CommissionMetaBossBtn.STATE_AUTO_BATTLE
		else
			return CommissionMetaBossBtn.STATE_FINSH_BATTLE
		end
	end

	if var1:NeedTip() or WorldBossConst.AnyArchivesBossCanGetAward() then
		return CommissionMetaBossBtn.STATE_GET_AWARDS
	end

	return CommissionMetaBossBtn.STATE_NORMAL
end

return var0
