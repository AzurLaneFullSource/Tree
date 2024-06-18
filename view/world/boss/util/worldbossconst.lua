local var0_0 = class("WorldBossConst")

var0_0.WORLD_BOSS_ITEM_ID = 100000
var0_0.WORLD_PAST_BOSS_ITEM_ID = 100002
var0_0.ACHIEVE_STATE_NOSTART = 1
var0_0.ACHIEVE_STATE_STARTING = 2
var0_0.ACHIEVE_STATE_CLEAR = 3
var0_0.BOSS_TYPE_CURR = 1
var0_0.BOSS_TYPE_ARCHIVES = 2
var0_0.STOP_AUTO_BATTLE_MANUAL = 1
var0_0.STOP_AUTO_BATTLE_TIMEOVER = 2
var0_0.AUTO_BATTLE_STATE_NORMAL = 0
var0_0.AUTO_BATTLE_STATE_LOCK = 1
var0_0.AUTO_BATTLE_STATE_STARTING = 2
var0_0.AUTO_BATTLE_STATE_HIDE = 3

function var0_0.__IsCurrBoss(arg0_1)
	return var0_0.GetCurrBossID() == arg0_1
end

function var0_0.IsAchieveBoss(arg0_2)
	local var0_2 = var0_0.GetAchieveBossIdList()

	return table.contains(var0_2, arg0_2)
end

function var0_0.IsCurrBoss(arg0_3)
	return var0_0.GetCurrBossGroup() == arg0_3
end

function var0_0._IsCurrBoss(arg0_4)
	local var0_4 = arg0_4.config.id

	return var0_0.GetCurrBossID() == var0_4
end

function var0_0.GetCurrBossGroup()
	local var0_5 = pg.world_joint_boss_template

	for iter0_5 = #var0_5.all, 1, -1 do
		local var1_5 = var0_5.all[iter0_5]

		if type(var0_5[var1_5].state) == "table" and pg.TimeMgr.GetInstance():inTime(var0_5[var1_5].state) then
			return var0_5[var1_5].meta_id
		end
	end

	return nil
end

function var0_0.GetCurrBossID()
	local var0_6 = pg.world_joint_boss_template

	for iter0_6 = #var0_6.all, 1, -1 do
		local var1_6 = var0_6.all[iter0_6]

		if type(var0_6[var1_6].state) == "table" and pg.TimeMgr.GetInstance():inTime(var0_6[var1_6].state) then
			return var0_6[var1_6].id
		end
	end

	return nil
end

function var0_0.GetCurrBossLeftDay()
	local var0_7 = var0_0.GetCurrBossID()
	local var1_7 = pg.world_joint_boss_template[var0_7]
	local var2_7 = pg.TimeMgr.GetInstance():GetServerTime()
	local var3_7 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var1_7.state[2])
	local var4_7 = var3_7 - var2_7

	return pg.TimeMgr.GetInstance():DiffDay(var2_7, var3_7), var4_7 % 86400
end

function var0_0.GetCurrBossDayIndex()
	local var0_8 = var0_0.GetCurrBossID()
	local var1_8 = pg.world_joint_boss_template[var0_8]
	local var2_8 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var1_8.state[1])
	local var3_8 = pg.TimeMgr.GetInstance()
	local var4_8 = var3_8:GetServerTime()

	return var3_8:DiffDay(var2_8, var4_8) + 1
end

function var0_0.GetCurrBossStartTimeAndEndTime()
	local var0_9 = var0_0.GetCurrBossID()

	return pg.world_joint_boss_template[var0_9].state
end

function var0_0.GetCurrBossConsume()
	local var0_10 = pg.gameset.curr_boss_ticket.description
	local var1_10 = var0_10[1]
	local var2_10 = var0_10[2]
	local var3_10 = var0_10[3]

	return var1_10, var2_10, var3_10
end

function var0_0.GetCurrBossItemProgress()
	return nowWorld().worldBossProxy:GetSummonPt()
end

function var0_0.GetCurrBossItemAcc()
	return nowWorld().worldBossProxy:GetSummonPtDailyAcc()
end

function var0_0.CanUnlockCurrBoss()
	return var0_0.GetCurrBossItemProgress() >= var0_0.GetCurrBossConsume()
end

function var0_0.GetCurrBossItemCapacity()
	local var0_14 = var0_0.GetCurrBossItemProgress()
	local var1_14 = var0_0.GetCurrBossItemAcc()
	local var2_14, var3_14, var4_14 = var0_0.GetCurrBossConsume()

	return var0_14, var1_14, var3_14, var4_14
end

function var0_0.GetAchieveBossConsume()
	local var0_15 = pg.gameset.past_joint_boss_ticket.description
	local var1_15 = var0_15[1]
	local var2_15 = var0_15[2]
	local var3_15 = var0_15[3]

	return var1_15, var2_15, var3_15
end

function var0_0.GetAchieveBossItemProgress()
	return nowWorld().worldBossProxy:GetSummonPtOld()
end

function var0_0.GetSummonPtOldAcc()
	return nowWorld().worldBossProxy:GetSummonPtOldAcc()
end

function var0_0.CanUnlockArchivesBoss()
	return var0_0.GetAchieveBossItemProgress() >= var0_0.GetAchieveBossConsume()
end

function var0_0.GetAchieveBossItemCapacity()
	local var0_19 = var0_0.GetAchieveBossItemProgress()
	local var1_19 = var0_0.GetSummonPtOldAcc()
	local var2_19, var3_19, var4_19 = var0_0.GetAchieveBossConsume()

	return var0_19, var1_19, var3_19, var4_19
end

function var0_0.GetAchieveBossIdList()
	local var0_20 = {}
	local var1_20 = pg.world_joint_boss_template

	for iter0_20 = 1, #var1_20.all do
		local var2_20 = var1_20.all[iter0_20]

		if var1_20[var2_20].state == "always" then
			table.insert(var0_20, var1_20[var2_20].meta_id)
		end
	end

	return var0_20
end

function var0_0.GetAchieveBossList()
	local var0_21 = {}
	local var1_21 = pg.world_joint_boss_template

	for iter0_21 = 1, #var1_21.all do
		local var2_21 = var1_21.all[iter0_21]

		if var1_21[var2_21].state == "always" then
			table.insert(var0_21, var1_21[var2_21])
		end
	end

	return var0_21
end

function var0_0.GetCurrBossItemInfo()
	local var0_22, var1_22, var2_22, var3_22 = WorldBossConst.GetCurrBossItemCapacity()
	local var4_22 = i18n("world_boss_item_info")
	local var5_22 = string.split(var4_22, "|")
	local var6_22 = var5_22[2]

	for iter0_22, iter1_22 in ipairs({
		var1_22,
		var2_22,
		var0_22,
		var3_22
	}) do
		var6_22 = string.gsub(var6_22, "$" .. iter0_22, iter1_22)
	end

	return {
		rarity = 4,
		name = var5_22[1],
		display = var6_22,
		icon = {
			"Props/world_boss_record"
		}
	}
end

function var0_0.GetAchieveBossItemInfo()
	local var0_23, var1_23, var2_23, var3_23 = WorldBossConst.GetAchieveBossItemCapacity()
	local var4_23 = i18n("world_past_boss_item_info")
	local var5_23 = string.split(var4_23, "|")
	local var6_23 = var5_23[2]

	for iter0_23, iter1_23 in ipairs({
		var1_23,
		var2_23,
		var0_23,
		var3_23
	}) do
		var6_23 = string.gsub(var6_23, "$" .. iter0_23, iter1_23)
	end

	return {
		rarity = 4,
		name = var5_23[1],
		display = var6_23,
		icon = {
			"Props/world_past_boss_record"
		}
	}
end

function var0_0.IsClearAllAchieveBoss()
	local var0_24 = var0_0.GetAchieveBossIdList()

	return _.all(var0_24, function(arg0_25)
		return not getProxy(MetaCharacterProxy):getMetaProgressVOByID(arg0_25).metaPtData:CanGetNextAward()
	end)
end

function var0_0.GetArchivesId()
	return nowWorld():GetBossProxy():GetArchivesId()
end

function var0_0.GetAchieveState()
	local var0_27 = var0_0.GetArchivesId()

	if var0_27 == 0 then
		return var0_0.ACHIEVE_STATE_NOSTART
	end

	if #var0_0.GetAchieveBossIdList() == 0 then
		return var0_0.ACHIEVE_STATE_NOSTART
	elseif var0_0.IsClearAllAchieveBoss() then
		return var0_0.ACHIEVE_STATE_CLEAR
	else
		local var1_27 = pg.world_joint_boss_template[var0_27].meta_id
		local var2_27 = getProxy(MetaCharacterProxy):getMetaProgressVOByID(var1_27)

		if not var2_27.metaPtData:CanGetNextAward() or var2_27.metaPtData:IsMaxPt() then
			return var0_0.ACHIEVE_STATE_NOSTART
		else
			return var0_0.ACHIEVE_STATE_STARTING
		end
	end
end

function var0_0.GetBossOilConsume(arg0_28)
	local var0_28 = pg.gameset.joint_boss_oil_consume.description

	arg0_28 = math.min(arg0_28, #var0_28)

	return var0_28[arg0_28]
end

function var0_0.GetArchivesBossAutoBattleSecond()
	return pg.gameset.past_joint_boss_autofight_time.key_value
end

function var0_0.GetArchivesBossAutoBattleMinute()
	local var0_30 = var0_0.GetArchivesBossAutoBattleSecond()

	return math.ceil(var0_30 / 60)
end

function var0_0.GetHighestDamage()
	local var0_31 = nowWorld():GetBossProxy()

	return math.max(var0_31:GetHighestDamage(), 1)
end

function var0_0.GetAutoBattleCnt()
	local var0_32 = nowWorld():GetBossProxy():GetSelfBoss()
	local var1_32 = var0_0.GetHighestDamage()

	return math.ceil(var0_32.hp / var1_32)
end

function var0_0.GetAutoBattleOilConsume()
	local var0_33 = var0_0.GetAutoBattleCnt()
	local var1_33 = nowWorld():GetBossProxy():GetSelfBoss()
	local var2_33 = 0
	local var3_33 = var1_33.fightCount

	for iter0_33 = var3_33 + 1, var3_33 + var0_33 do
		var2_33 = var2_33 + WorldBossConst.GetBossOilConsume(iter0_33)
	end

	return var2_33
end

function var0_0.InAutoBattle()
	return nowWorld():GetBossProxy():InAutoBattle()
end

function var0_0.GetAutoBattleLeftTime()
	return nowWorld():GetBossProxy():GetAutoBattleFinishTime() - pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.GetAutoBattleState(arg0_36)
	if not arg0_36 or arg0_36:isDeath() then
		return var0_0.AUTO_BATTLE_STATE_HIDE
	end

	if WorldBossConst.InAutoBattle() then
		return var0_0.AUTO_BATTLE_STATE_STARTING
	elseif arg0_36:isDeath() then
		return var0_0.AUTO_BATTLE_STATE_HIDE
	elseif arg0_36:GetSelfFightCnt() <= 0 or nowWorld():GetBossProxy():GetHighestDamage() <= 0 then
		return var0_0.AUTO_BATTLE_STATE_LOCK
	else
		return var0_0.AUTO_BATTLE_STATE_NORMAL
	end
end

function var0_0.BossId2MetaId(arg0_37)
	return pg.world_joint_boss_template[arg0_37].meta_id
end

function var0_0.MetaId2BossId(arg0_38)
	for iter0_38, iter1_38 in ipairs(pg.world_joint_boss_template.all) do
		if var0_0.BossId2MetaId(iter1_38) == arg0_38 then
			return iter1_38
		end
	end
end

function var0_0.AnyArchivesBossCanGetAward()
	return _.any(var0_0.GetAchieveBossIdList(), function(arg0_40)
		return getProxy(MetaCharacterProxy):getMetaProgressVOByID(arg0_40).metaPtData:CanGetAward()
	end)
end

function var0_0.GetCommissionSceneMetaBossBtnState()
	local var0_41 = nowWorld()

	if not var0_41 or not var0_41:IsActivate() then
		return CommissionMetaBossBtn.STATE_LOCK
	end

	local var1_41 = var0_41:GetBossProxy()

	if not var1_41 or not var1_41.isSetup or not var1_41:IsOpen() then
		return CommissionMetaBossBtn.STATE_LOCK
	end

	local var2_41 = var1_41:GetSelfBoss()

	if var2_41 and WorldBossConst.GetAutoBattleState(var2_41) == WorldBossConst.AUTO_BATTLE_STATE_STARTING then
		if WorldBossConst.GetAutoBattleLeftTime() > 0 then
			return CommissionMetaBossBtn.STATE_AUTO_BATTLE
		else
			return CommissionMetaBossBtn.STATE_FINSH_BATTLE
		end
	end

	if var1_41:NeedTip() or WorldBossConst.AnyArchivesBossCanGetAward() then
		return CommissionMetaBossBtn.STATE_GET_AWARDS
	end

	return CommissionMetaBossBtn.STATE_NORMAL
end

return var0_0
