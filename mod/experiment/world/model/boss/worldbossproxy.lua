local var0_0 = class("WorldBossProxy", import("....BaseEntity"))
local var1_0 = "WorldbossFleet"
local var2_0 = "WorldbossFleet_for_archives"

var0_0.Fields = {
	summonPtDailyAcc = "number",
	ptTime = "number",
	otherBosses = "table",
	boss = "table",
	highestDamage = "number",
	isSetup = "boolean",
	guildSupport = "number",
	isFetched = "boolean",
	ranks = "table",
	summonPt = "number",
	cacheBosses = "table",
	timers = "table",
	archivesId = "number",
	fleet = "table",
	summonPtOld = "number",
	cacheLock = "number",
	tipProgress = "boolean",
	summonFree = "number",
	fleetForArchives = "table",
	autoFightFinishTime = "number",
	summonPtOldDailyAcc = "number",
	worldSupport = "number",
	friendSupport = "number",
	pt = "number",
	refreshBossesTime = "number"
}
var0_0.REFRESH_BOSSES_TIME = 300
var0_0.EventProcessBossListUpdated = "WorldBossProxy.EventProcessBossListUpdated"
var0_0.EventCacheBossListUpdated = "WorldBossProxy.EventCacheBossListUpdated"
var0_0.EventBossUpdated = "WorldBossProxy.EventBossUpdated"
var0_0.EventFleetUpdated = "WorldBossProxy.EventFleetUpdated"
var0_0.EventPtUpdated = "WorldBossProxy.EventPtUpdated"
var0_0.EventRankListUpdated = "WorldBossProxy.EventRankListUpdated"
var0_0.EventUnlockProgressUpdated = "WorldBossProxy.EventUnlockProgressUpdated"

function var0_0.Setup(arg0_1, arg1_1)
	arg0_1.pt = arg0_1:GetMaxPt() - (arg1_1.fight_count or 0)

	if arg1_1.self_boss then
		local var0_1 = WorldBoss.New()
		local var1_1 = getProxy(PlayerProxy):getData()

		var0_1:Setup(arg1_1.self_boss, var1_1)

		if var0_1:Active() then
			arg0_1.boss = var0_1
		end
	end

	arg0_1.summonPt = arg1_1.summon_pt or 0
	arg0_1.summonPtOld = arg1_1.summon_pt_old or 0
	arg0_1.summonPtDailyAcc = arg1_1.summon_pt_daily_acc or 0
	arg0_1.summonPtOldDailyAcc = arg1_1.summon_pt_old_daily_acc or 0
	arg0_1.autoFightFinishTime = arg1_1.auto_fight_finish_time or 0
	arg0_1.summonFree = arg1_1.summon_free or 0
	arg0_1.archivesId = arg1_1.default_boss_id or 0
	arg0_1.highestDamage = arg1_1.auto_fight_max_damage or 0
	arg0_1.guildSupport = arg1_1.guild_support or 0
	arg0_1.friendSupport = arg1_1.friend_support or 0
	arg0_1.worldSupport = arg1_1.world_support or 0
	arg0_1.cacheBosses = {}
	arg0_1.ranks = {}
	arg0_1.timers = {}
	arg0_1.fleet = nil
	arg0_1.fleetForArchives = nil

	arg0_1:GenFleet()

	arg0_1.refreshBossesTime = 0
	arg0_1.isSetup = true
	arg0_1.isFetched = false
end

function var0_0.CheckRemouldShip(arg0_2)
	if arg0_2.fleet and arg0_2.fleetForArchives then
		arg0_2:GenFleet()
	end
end

function var0_0.FriendSupported(arg0_3)
	return arg0_3.friendSupport > pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.UpdateFriendSupported(arg0_4)
	local var0_4 = pg.gameset.joint_boss_world_time.key_value

	arg0_4.friendSupport = pg.TimeMgr.GetInstance():GetServerTime() + var0_4
end

function var0_0.ClearFriendSupported(arg0_5)
	arg0_5.friendSupport = 0
end

function var0_0.GetNextFriendSupportTime(arg0_6)
	return arg0_6.friendSupport
end

function var0_0.GuildSupported(arg0_7)
	return arg0_7.guildSupport > pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.UpdateGuildSupported(arg0_8)
	local var0_8 = pg.gameset.joint_boss_world_time.key_value

	arg0_8.guildSupport = pg.TimeMgr.GetInstance():GetServerTime() + var0_8
end

function var0_0.ClearGuildSupported(arg0_9)
	arg0_9.guildSupport = 0
end

function var0_0.GetNextGuildSupportTime(arg0_10)
	return arg0_10.guildSupport
end

function var0_0.WorldSupported(arg0_11)
	return arg0_11.worldSupport > pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.UpdateWorldSupported(arg0_12)
	local var0_12 = pg.gameset.joint_boss_world_time.key_value

	arg0_12.worldSupport = pg.TimeMgr.GetInstance():GetServerTime() + var0_12
end

function var0_0.ClearWorldSupported(arg0_13)
	arg0_13.worldSupport = 0
end

function var0_0.GetNextWorldSupportTime(arg0_14)
	return arg0_14.worldSupport
end

function var0_0.UpdateAutoBattleFinishTime(arg0_15, arg1_15)
	arg0_15.autoFightFinishTime = arg1_15
end

function var0_0.InAutoBattle(arg0_16)
	return arg0_16.autoFightFinishTime > 0
end

function var0_0.ClearAutoBattle(arg0_17)
	arg0_17.autoFightFinishTime = 0
end

function var0_0.GetAutoBattleFinishTime(arg0_18)
	return arg0_18.autoFightFinishTime
end

function var0_0.GetHighestDamage(arg0_19)
	return arg0_19.highestDamage
end

function var0_0.UpdateHighestDamage(arg0_20, arg1_20)
	if arg1_20 > arg0_20.highestDamage then
		arg0_20.highestDamage = arg1_20
	end
end

function var0_0.ClearHighestDamage(arg0_21)
	arg0_21.highestDamage = 0
end

function var0_0.AddSummonFree(arg0_22, arg1_22)
	arg0_22.summonFree = arg0_22.summonFree + arg1_22
end

function var0_0.GetSummonPt(arg0_23)
	return arg0_23.summonPt
end

function var0_0.AddSummonPt(arg0_24, arg1_24)
	local var0_24, var1_24, var2_24 = WorldBossConst.GetCurrBossConsume()

	if var1_24 < arg0_24.summonPtDailyAcc + arg1_24 then
		arg1_24 = var1_24 - arg0_24.summonPtDailyAcc
	end

	if arg1_24 <= 0 then
		return
	end

	local var3_24 = arg0_24.summonPt

	arg0_24.summonPt = math.min(arg0_24.summonPt + arg1_24, var2_24)

	local var4_24 = math.min(var2_24 - var3_24, arg1_24)

	arg0_24.summonPtDailyAcc = math.min(arg0_24.summonPtDailyAcc + var4_24, var1_24)

	arg0_24:UpdatedUnlockProgress(var3_24, arg0_24.summonPt)
end

function var0_0.ConsumeSummonPt(arg0_25, arg1_25)
	arg0_25.summonPt = arg0_25.summonPt - arg1_25

	arg0_25:DispatchEvent(var0_0.EventUnlockProgressUpdated)
end

function var0_0.GetSummonPtDailyAcc(arg0_26)
	return arg0_26.summonPtDailyAcc
end

function var0_0.ClearSummonPtDailyAcc(arg0_27)
	arg0_27.summonPtDailyAcc = 0

	arg0_27:DispatchEvent(var0_0.EventUnlockProgressUpdated)
end

function var0_0.GetSummonPtOld(arg0_28)
	return arg0_28.summonPtOld
end

function var0_0.AddSummonPtOld(arg0_29, arg1_29)
	local var0_29, var1_29, var2_29 = WorldBossConst.GetAchieveBossConsume()

	if var1_29 < arg0_29.summonPtOldDailyAcc + arg1_29 then
		arg1_29 = var1_29 - arg0_29.summonPtOldDailyAcc
	end

	if arg1_29 <= 0 then
		return
	end

	local var3_29 = arg0_29.summonPtOld

	arg0_29.summonPtOld = math.min(arg0_29.summonPtOld + arg1_29, var2_29)

	local var4_29 = math.min(var2_29 - var3_29, arg1_29)

	arg0_29.summonPtOldDailyAcc = math.min(arg0_29.summonPtOldDailyAcc + var4_29, var1_29)
end

function var0_0.ConsumeSummonPtOld(arg0_30, arg1_30)
	arg0_30.summonPtOld = arg0_30.summonPtOld - arg1_30

	arg0_30:DispatchEvent(var0_0.EventUnlockProgressUpdated)
end

function var0_0.ClearSummonPtOldAcc(arg0_31)
	arg0_31.summonPtOldDailyAcc = 0

	arg0_31:DispatchEvent(var0_0.EventUnlockProgressUpdated)
end

function var0_0.GetSummonPtOldAcc(arg0_32)
	return arg0_32.summonPtOldDailyAcc
end

function var0_0.GetArchivesId(arg0_33)
	return arg0_33.archivesId
end

function var0_0.SetArchivesId(arg0_34, arg1_34)
	arg0_34.archivesId = arg1_34
end

function var0_0.BossId2FleetKey(arg0_35, arg1_35)
	local var0_35 = arg0_35:GetBossById(arg1_35)

	if var0_35 and not WorldBossConst._IsCurrBoss(var0_35) then
		return var2_0
	else
		return var1_0
	end
end

function var0_0.GenFleet(arg0_36)
	local var0_36 = arg0_36:GetCacheShips(var1_0)

	arg0_36.fleet = Fleet.New({
		0,
		id = 1,
		name = i18n("world_boss_fleet"),
		ship_list = var0_36
	})

	local var1_36 = arg0_36:GetCacheShips(var2_0)

	arg0_36.fleetForArchives = Fleet.New({
		0,
		id = 1,
		name = i18n("world_boss_fleet"),
		ship_list = var1_36
	})
end

function var0_0.GetCacheShips(arg0_37, arg1_37)
	local function var0_37(arg0_38, arg1_38)
		local var0_38 = arg0_38:getTeamType()

		if TeamType.GetTeamShipMax(var0_38) < arg1_38 + 1 then
			return true
		end

		return false
	end

	local var1_37 = PlayerPrefs.GetString(arg1_37 .. getProxy(PlayerProxy):getRawData().id)
	local var2_37 = string.split(var1_37, "|")
	local var3_37 = {}
	local var4_37 = {
		[TeamType.Vanguard] = 0,
		[TeamType.Main] = 0,
		[TeamType.Submarine] = 0
	}

	if var2_37 and #var2_37 > 0 and (#var2_37 ~= 1 or var2_37[1] ~= "") then
		for iter0_37, iter1_37 in ipairs(var2_37) do
			local var5_37 = tonumber(iter1_37)
			local var6_37 = getProxy(BayProxy):getShipById(var5_37)

			if var6_37 then
				local var7_37 = var6_37:getTeamType()

				if not var0_37(var6_37, var4_37[var7_37]) then
					var4_37[var7_37] = var4_37[var7_37] + 1

					table.insert(var3_37, var5_37)
				end
			end
		end
	end

	return var3_37
end

function var0_0.GetFleet(arg0_39, arg1_39)
	local var0_39 = arg0_39:BossId2FleetKey(arg1_39)
	local var1_39

	if var2_0 == var0_39 then
		var1_39 = arg0_39.fleetForArchives
	else
		var1_39 = arg0_39.fleet
	end

	var1_39 = var1_39 or Fleet.New({
		0,
		id = 1,
		name = i18n("world_boss_fleet"),
		ship_list = {}
	})

	for iter0_39 = #var1_39.ships, 1, -1 do
		local var2_39 = var1_39.ships[iter0_39]

		if not getProxy(BayProxy):getShipById(var2_39) then
			var1_39:removeShipById(var2_39)
		end
	end

	return var1_39
end

function var0_0.UpdateFleet(arg0_40, arg1_40, arg2_40)
	local var0_40 = arg0_40:BossId2FleetKey(arg1_40)

	if var2_0 == var0_40 then
		arg0_40.fleetForArchives = arg2_40
	else
		arg0_40.fleet = arg2_40
	end

	arg0_40:DispatchEvent(var0_0.EventFleetUpdated)
end

function var0_0.SavaCacheShips(arg0_41, arg1_41, arg2_41)
	local var0_41 = arg0_41:BossId2FleetKey(arg1_41)
	local var1_41 = arg2_41:getShipIds()
	local var2_41 = ""

	for iter0_41, iter1_41 in ipairs(var1_41) do
		var2_41 = var2_41 .. iter1_41 .. "|"
	end

	PlayerPrefs.SetString(var0_41 .. getProxy(PlayerProxy):getRawData().id, var2_41)
	PlayerPrefs.Save()
end

function var0_0.ClearCacheShips(arg0_42, arg1_42)
	local var0_42 = arg0_42:BossId2FleetKey(arg1_42)

	PlayerPrefs.DeleteKey(var0_42 .. getProxy(PlayerProxy):getRawData().id)
	PlayerPrefs.Save()
end

function var0_0.UpdteRefreshBossesTime(arg0_43)
	arg0_43.refreshBossesTime = pg.TimeMgr.GetInstance():GetServerTime() + var0_0.REFRESH_BOSSES_TIME
end

function var0_0.ShouldRefreshBosses(arg0_44)
	return pg.TimeMgr.GetInstance():GetServerTime() >= arg0_44.refreshBossesTime
end

function var0_0.UpdateCacheBoss(arg0_45, arg1_45)
	if arg0_45:IsSelfBoss(arg1_45) then
		arg0_45:UpdateSelfBoss(arg1_45)
	else
		arg0_45.cacheBosses[arg1_45.id] = arg1_45

		arg0_45:BalanceMaxBossCnt()
	end
end

function var0_0.BalanceMaxBossCnt(arg0_46)
	local var0_46 = pg.gameset.boss_cnt_limit.description

	if table.getCount(arg0_46.cacheBosses) < var0_46[1] then
		return
	end

	local var1_46 = {}
	local var2_46 = {}
	local var3_46 = {}
	local var4_46 = {}

	for iter0_46, iter1_46 in pairs(arg0_46.cacheBosses) do
		local var5_46 = iter1_46:GetType()

		if iter1_46:isDeath() or iter1_46:IsExpired() then
			table.insert(var4_46, iter1_46)
		elseif var5_46 == WorldBoss.BOSS_TYPE_FRIEND then
			table.insert(var3_46, iter1_46)
		elseif var5_46 == WorldBoss.BOSS_TYPE_GUILD then
			table.insert(var2_46, iter1_46)
		elseif var5_46 == WorldBoss.BOSS_TYPE_WORLD then
			table.insert(var1_46, iter1_46)
		end
	end

	if #var1_46 > var0_46[2] then
		table.sort(var1_46, function(arg0_47, arg1_47)
			return arg0_47:GetJoinTime() < arg1_47:GetJoinTime()
		end)

		if var1_46[1] then
			table.insert(var4_46, var1_46[1])
		end
	end

	if #var2_46 > var0_46[3] then
		table.sort(var2_46, function(arg0_48, arg1_48)
			return arg0_48:GetJoinTime() < arg1_48:GetJoinTime()
		end)

		if var2_46[1] then
			table.insert(var4_46, var2_46[1])
		end
	end

	if #var3_46 > var0_46[4] then
		table.sort(var3_46, function(arg0_49, arg1_49)
			return arg0_49:GetJoinTime() < arg1_49:GetJoinTime()
		end)

		if var3_46[1] then
			table.insert(var4_46, var3_46[1])
		end
	end

	if #var4_46 > 0 then
		for iter2_46, iter3_46 in ipairs(var4_46) do
			if arg0_46.cacheBosses[iter3_46.id] and iter3_46.id ~= arg0_46.cacheLock then
				arg0_46.cacheBosses[iter3_46.id] = nil
			end
		end

		arg0_46:DispatchEvent(var0_0.EventCacheBossListUpdated)
	end
end

function var0_0.RemoveCacheBoss(arg0_50, arg1_50)
	if arg0_50.cacheBosses[arg1_50] then
		arg0_50.cacheBosses[arg1_50] = nil

		arg0_50:DispatchEvent(var0_0.EventCacheBossListUpdated)
	end
end

function var0_0.GetCacheBoss(arg0_51, arg1_51)
	return arg0_51.cacheBosses[arg1_51]
end

function var0_0.LockCacheBoss(arg0_52, arg1_52)
	arg0_52.cacheLock = arg1_52
end

function var0_0.UnlockCacheBoss(arg0_53)
	arg0_53.cacheLock = nil
end

function var0_0.canGetSelfAward(arg0_54)
	local var0_54 = arg0_54:GetSelfBoss()

	return var0_54 and var0_54:isDeath()
end

function var0_0.UpdateSelfBoss(arg0_55, arg1_55)
	if arg0_55.boss and arg1_55 and not arg1_55:isSameLevel(arg0_55.boss) then
		arg0_55.fleet:clearFleet()
	end

	arg0_55.boss = arg1_55

	arg0_55:DispatchEvent(var0_0.EventBossUpdated)
end

function var0_0.RemoveSelfBoss(arg0_56)
	if arg0_56.boss then
		arg0_56:UpdateSelfBoss(nil)
	end

	arg0_56:ClearHighestDamage()
	arg0_56:ClearAutoBattle()
	arg0_56:ClearFriendSupported()
	arg0_56:ClearGuildSupported()
	arg0_56:ClearWorldSupported()
end

function var0_0.updateBossHp(arg0_57, arg1_57, arg2_57)
	if arg0_57.boss and arg1_57 == arg0_57.boss.id then
		arg0_57.boss:UpdateHp(arg2_57)
		arg0_57:UpdateSelfBoss(arg0_57.boss)
	else
		local var0_57 = arg0_57.cacheBosses[arg1_57]

		if var0_57 then
			var0_57:UpdateHp(arg2_57)
			arg0_57:UpdateCacheBoss(var0_57)
		end
	end
end

function var0_0.GetBossById(arg0_58, arg1_58)
	if arg0_58.boss and arg0_58.boss.id == arg1_58 then
		return arg0_58.boss
	end

	local var0_58 = arg0_58.cacheBosses[arg1_58]

	if var0_58 then
		return var0_58
	end
end

function var0_0.GetSelfBoss(arg0_59)
	return arg0_59.boss
end

function var0_0.IsSelfBoss(arg0_60, arg1_60)
	assert(arg1_60)

	return arg0_60.boss and arg0_60.boss.id == arg1_60.id or arg1_60:IsSelf()
end

function var0_0.GetBoss(arg0_61)
	return arg0_61.boss
end

function var0_0.ExistSelfBoss(arg0_62)
	return arg0_62.boss ~= nil and not arg0_62.boss:IsExpired()
end

function var0_0.GetCacheBossList(arg0_63)
	local var0_63 = {}

	for iter0_63, iter1_63 in pairs(arg0_63.cacheBosses) do
		if not arg0_63:IsSelfBoss(iter1_63) then
			table.insert(var0_63, iter1_63)
		end
	end

	return var0_63
end

function var0_0.reducePt(arg0_64)
	arg0_64.pt = arg0_64.pt - 1

	arg0_64:DispatchEvent(var0_0.EventPtUpdated)
end

function var0_0.increasePt(arg0_65)
	local var0_65 = arg0_65:GetMaxPt()

	arg0_65.pt = math.min(var0_65, arg0_65.pt + pg.gameset.joint_boss_ap_recove_cnt_pre_day.key_value)

	arg0_65:DispatchEvent(var0_0.EventPtUpdated)
end

function var0_0.SetRank(arg0_66, arg1_66, arg2_66)
	arg0_66.ranks[arg1_66] = arg2_66

	local var0_66 = arg0_66:GetBossById(arg1_66)

	if var0_66 then
		var0_66:SetRankCnt(#arg2_66)
	end

	arg0_66:addTimer(arg1_66)
	arg0_66:DispatchEvent(var0_0.EventRankListUpdated, arg1_66)
end

function var0_0.GetRank(arg0_67, arg1_67)
	return arg0_67.ranks[arg1_67]
end

function var0_0.ClearRank(arg0_68, arg1_68)
	arg0_68.ranks[arg1_68] = nil
end

function var0_0.addTimer(arg0_69, arg1_69)
	if not arg1_69 then
		return
	end

	if arg0_69.timers[arg1_69] then
		arg0_69.timers[arg1_69]:Stop()

		arg0_69.timers[arg1_69] = nil
	end

	arg0_69.timers[arg1_69] = Timer.New(function()
		if arg0_69.ranks then
			arg0_69.ranks[arg1_69] = nil
		end

		if arg0_69.timer and arg0_69.timers[arg1_69] then
			arg0_69.timers[arg1_69]:Stop()

			arg0_69.timers[arg1_69] = nil
		end
	end, 300, 1)

	arg0_69.timers[arg1_69]:Start()
end

function var0_0.GetPt(arg0_71)
	return arg0_71.pt
end

function var0_0.GetMaxPt(arg0_72)
	return pg.gameset.joint_boss_ap_max.key_value
end

function var0_0.isMaxPt(arg0_73)
	return arg0_73.pt == arg0_73:GetMaxPt()
end

function var0_0.GetRecoverPtTime(arg0_74)
	return pg.gameset.joint_boss_ap_recover_time.key_value
end

function var0_0.GetNextReconveTime(arg0_75)
	return arg0_75.ptTime
end

function var0_0.updatePtTime(arg0_76, arg1_76)
	arg0_76.ptTime = arg1_76
end

function var0_0.Dispose(arg0_77)
	var0_0.super.Dispose(arg0_77)

	for iter0_77, iter1_77 in pairs(arg0_77.timers or {}) do
		iter1_77:Stop()
	end

	arg0_77.timers = nil
end

function var0_0.NeedTip(arg0_78)
	return (function()
		if arg0_78.boss and arg0_78.boss:isDeath() and not arg0_78.boss:IsExpired() and not arg0_78.boss:ShouldWaitForResult() then
			return true
		end

		return false
	end)()
end

function var0_0.UpdatedUnlockProgress(arg0_80, arg1_80, arg2_80)
	if arg2_80 <= arg1_80 or not nowWorld():IsSystemOpen(WorldConst.SystemWorldBoss) then
		arg0_80.tipProgress = false
	elseif not (pg.NewStoryMgr.GetInstance():IsPlayed("WorldG190") or not GUIDE_WROLD) then
		arg0_80.tipProgress = true
	else
		local var0_80 = getProxy(SettingsProxy):GetWorldBossProgressTipTable()

		if #var0_80 == 0 then
			arg0_80.tipProgress = false
		else
			arg0_80.tipProgress = _.any(var0_80, function(arg0_81)
				return arg1_80 < tonumber(arg0_81) and arg2_80 >= tonumber(arg0_81)
			end)
		end
	end

	arg0_80:DispatchEvent(var0_0.EventUnlockProgressUpdated)
end

function var0_0.ShouldTipProgress(arg0_82)
	return arg0_82.tipProgress
end

function var0_0.ClearTipProgress(arg0_83)
	arg0_83.tipProgress = false
end

function var0_0.GetCanGetAwardBoss(arg0_84)
	return nil
end

function var0_0.ExistSelfBossAward(arg0_85)
	if arg0_85.boss and arg0_85.boss:isDeath() and not arg0_85.boss:IsExpired() then
		return true
	end

	return false
end

function var0_0.ExistCacheBoss(arg0_86)
	return table.getCount(arg0_86.cacheBosses) ~= 0
end

function var0_0.IsOpen(arg0_87)
	return WorldBossConst.GetCurrBossID() ~= nil
end

function var0_0.IsNeedSupport()
	local var0_88 = WorldBossConst.GetCurrBossDayIndex()
	local var1_88 = pg.gameset.world_metaboss_supportattack.description
	local var2_88 = nowWorld():GetBossProxy():GetSelfBoss()

	if not var2_88 then
		return
	end

	if not WorldBossConst._IsCurrBoss(var2_88) then
		return
	end

	if var0_88 < var1_88[1] then
		return
	end

	return true
end

function var0_0.GetSupportValue()
	if not WorldBossProxy.IsNeedSupport() then
		return
	end

	local var0_89 = pg.gameset.world_metaboss_supportattack.description
	local var1_89 = 0

	assert(var0_89[6], "Missing WorldBoss SupportAttack Buff")

	return true, var1_89, var0_89[6]
end

return var0_0
