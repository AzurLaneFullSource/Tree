local var0 = class("WorldBossProxy", import("....BaseEntity"))
local var1 = "WorldbossFleet"
local var2 = "WorldbossFleet_for_archives"

var0.Fields = {
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
var0.REFRESH_BOSSES_TIME = 300
var0.EventProcessBossListUpdated = "WorldBossProxy.EventProcessBossListUpdated"
var0.EventCacheBossListUpdated = "WorldBossProxy.EventCacheBossListUpdated"
var0.EventBossUpdated = "WorldBossProxy.EventBossUpdated"
var0.EventFleetUpdated = "WorldBossProxy.EventFleetUpdated"
var0.EventPtUpdated = "WorldBossProxy.EventPtUpdated"
var0.EventRankListUpdated = "WorldBossProxy.EventRankListUpdated"
var0.EventUnlockProgressUpdated = "WorldBossProxy.EventUnlockProgressUpdated"

function var0.Setup(arg0, arg1)
	arg0.pt = arg0:GetMaxPt() - (arg1.fight_count or 0)

	if arg1.self_boss then
		local var0 = WorldBoss.New()
		local var1 = getProxy(PlayerProxy):getData()

		var0:Setup(arg1.self_boss, var1)

		if var0:Active() then
			arg0.boss = var0
		end
	end

	arg0.summonPt = arg1.summon_pt or 0
	arg0.summonPtOld = arg1.summon_pt_old or 0
	arg0.summonPtDailyAcc = arg1.summon_pt_daily_acc or 0
	arg0.summonPtOldDailyAcc = arg1.summon_pt_old_daily_acc or 0
	arg0.autoFightFinishTime = arg1.auto_fight_finish_time or 0
	arg0.summonFree = arg1.summon_free or 0
	arg0.archivesId = arg1.default_boss_id or 0
	arg0.highestDamage = arg1.auto_fight_max_damage or 0
	arg0.guildSupport = arg1.guild_support or 0
	arg0.friendSupport = arg1.friend_support or 0
	arg0.worldSupport = arg1.world_support or 0
	arg0.cacheBosses = {}
	arg0.ranks = {}
	arg0.timers = {}
	arg0.fleet = nil
	arg0.fleetForArchives = nil

	arg0:GenFleet()

	arg0.refreshBossesTime = 0
	arg0.isSetup = true
	arg0.isFetched = false
end

function var0.CheckRemouldShip(arg0)
	if arg0.fleet and arg0.fleetForArchives then
		arg0:GenFleet()
	end
end

function var0.FriendSupported(arg0)
	return arg0.friendSupport > pg.TimeMgr.GetInstance():GetServerTime()
end

function var0.UpdateFriendSupported(arg0)
	local var0 = pg.gameset.joint_boss_world_time.key_value

	arg0.friendSupport = pg.TimeMgr.GetInstance():GetServerTime() + var0
end

function var0.ClearFriendSupported(arg0)
	arg0.friendSupport = 0
end

function var0.GetNextFriendSupportTime(arg0)
	return arg0.friendSupport
end

function var0.GuildSupported(arg0)
	return arg0.guildSupport > pg.TimeMgr.GetInstance():GetServerTime()
end

function var0.UpdateGuildSupported(arg0)
	local var0 = pg.gameset.joint_boss_world_time.key_value

	arg0.guildSupport = pg.TimeMgr.GetInstance():GetServerTime() + var0
end

function var0.ClearGuildSupported(arg0)
	arg0.guildSupport = 0
end

function var0.GetNextGuildSupportTime(arg0)
	return arg0.guildSupport
end

function var0.WorldSupported(arg0)
	return arg0.worldSupport > pg.TimeMgr.GetInstance():GetServerTime()
end

function var0.UpdateWorldSupported(arg0)
	local var0 = pg.gameset.joint_boss_world_time.key_value

	arg0.worldSupport = pg.TimeMgr.GetInstance():GetServerTime() + var0
end

function var0.ClearWorldSupported(arg0)
	arg0.worldSupport = 0
end

function var0.GetNextWorldSupportTime(arg0)
	return arg0.worldSupport
end

function var0.UpdateAutoBattleFinishTime(arg0, arg1)
	arg0.autoFightFinishTime = arg1
end

function var0.InAutoBattle(arg0)
	return arg0.autoFightFinishTime > 0
end

function var0.ClearAutoBattle(arg0)
	arg0.autoFightFinishTime = 0
end

function var0.GetAutoBattleFinishTime(arg0)
	return arg0.autoFightFinishTime
end

function var0.GetHighestDamage(arg0)
	return arg0.highestDamage
end

function var0.UpdateHighestDamage(arg0, arg1)
	if arg1 > arg0.highestDamage then
		arg0.highestDamage = arg1
	end
end

function var0.ClearHighestDamage(arg0)
	arg0.highestDamage = 0
end

function var0.AddSummonFree(arg0, arg1)
	arg0.summonFree = arg0.summonFree + arg1
end

function var0.GetSummonPt(arg0)
	return arg0.summonPt
end

function var0.AddSummonPt(arg0, arg1)
	local var0, var1, var2 = WorldBossConst.GetCurrBossConsume()

	if var1 < arg0.summonPtDailyAcc + arg1 then
		arg1 = var1 - arg0.summonPtDailyAcc
	end

	if arg1 <= 0 then
		return
	end

	local var3 = arg0.summonPt

	arg0.summonPt = math.min(arg0.summonPt + arg1, var2)

	local var4 = math.min(var2 - var3, arg1)

	arg0.summonPtDailyAcc = math.min(arg0.summonPtDailyAcc + var4, var1)

	arg0:UpdatedUnlockProgress(var3, arg0.summonPt)
end

function var0.ConsumeSummonPt(arg0, arg1)
	arg0.summonPt = arg0.summonPt - arg1

	arg0:DispatchEvent(var0.EventUnlockProgressUpdated)
end

function var0.GetSummonPtDailyAcc(arg0)
	return arg0.summonPtDailyAcc
end

function var0.ClearSummonPtDailyAcc(arg0)
	arg0.summonPtDailyAcc = 0

	arg0:DispatchEvent(var0.EventUnlockProgressUpdated)
end

function var0.GetSummonPtOld(arg0)
	return arg0.summonPtOld
end

function var0.AddSummonPtOld(arg0, arg1)
	local var0, var1, var2 = WorldBossConst.GetAchieveBossConsume()

	if var1 < arg0.summonPtOldDailyAcc + arg1 then
		arg1 = var1 - arg0.summonPtOldDailyAcc
	end

	if arg1 <= 0 then
		return
	end

	local var3 = arg0.summonPtOld

	arg0.summonPtOld = math.min(arg0.summonPtOld + arg1, var2)

	local var4 = math.min(var2 - var3, arg1)

	arg0.summonPtOldDailyAcc = math.min(arg0.summonPtOldDailyAcc + var4, var1)
end

function var0.ConsumeSummonPtOld(arg0, arg1)
	arg0.summonPtOld = arg0.summonPtOld - arg1

	arg0:DispatchEvent(var0.EventUnlockProgressUpdated)
end

function var0.ClearSummonPtOldAcc(arg0)
	arg0.summonPtOldDailyAcc = 0

	arg0:DispatchEvent(var0.EventUnlockProgressUpdated)
end

function var0.GetSummonPtOldAcc(arg0)
	return arg0.summonPtOldDailyAcc
end

function var0.GetArchivesId(arg0)
	return arg0.archivesId
end

function var0.SetArchivesId(arg0, arg1)
	arg0.archivesId = arg1
end

function var0.BossId2FleetKey(arg0, arg1)
	local var0 = arg0:GetBossById(arg1)

	if var0 and not WorldBossConst._IsCurrBoss(var0) then
		return var2
	else
		return var1
	end
end

function var0.GenFleet(arg0)
	local var0 = arg0:GetCacheShips(var1)

	arg0.fleet = Fleet.New({
		0,
		id = 1,
		name = i18n("world_boss_fleet"),
		ship_list = var0
	})

	local var1 = arg0:GetCacheShips(var2)

	arg0.fleetForArchives = Fleet.New({
		0,
		id = 1,
		name = i18n("world_boss_fleet"),
		ship_list = var1
	})
end

function var0.GetCacheShips(arg0, arg1)
	local function var0(arg0, arg1)
		local var0 = arg0:getTeamType()

		if TeamType.GetTeamShipMax(var0) < arg1 + 1 then
			return true
		end

		return false
	end

	local var1 = PlayerPrefs.GetString(arg1 .. getProxy(PlayerProxy):getRawData().id)
	local var2 = string.split(var1, "|")
	local var3 = {}
	local var4 = {
		[TeamType.Vanguard] = 0,
		[TeamType.Main] = 0,
		[TeamType.Submarine] = 0
	}

	if var2 and #var2 > 0 and (#var2 ~= 1 or var2[1] ~= "") then
		for iter0, iter1 in ipairs(var2) do
			local var5 = tonumber(iter1)
			local var6 = getProxy(BayProxy):getShipById(var5)

			if var6 then
				local var7 = var6:getTeamType()

				if not var0(var6, var4[var7]) then
					var4[var7] = var4[var7] + 1

					table.insert(var3, var5)
				end
			end
		end
	end

	return var3
end

function var0.GetFleet(arg0, arg1)
	local var0 = arg0:BossId2FleetKey(arg1)
	local var1

	if var2 == var0 then
		var1 = arg0.fleetForArchives
	else
		var1 = arg0.fleet
	end

	var1 = var1 or Fleet.New({
		0,
		id = 1,
		name = i18n("world_boss_fleet"),
		ship_list = {}
	})

	for iter0 = #var1.ships, 1, -1 do
		local var2 = var1.ships[iter0]

		if not getProxy(BayProxy):getShipById(var2) then
			var1:removeShipById(var2)
		end
	end

	return var1
end

function var0.UpdateFleet(arg0, arg1, arg2)
	local var0 = arg0:BossId2FleetKey(arg1)

	if var2 == var0 then
		arg0.fleetForArchives = arg2
	else
		arg0.fleet = arg2
	end

	arg0:DispatchEvent(var0.EventFleetUpdated)
end

function var0.SavaCacheShips(arg0, arg1, arg2)
	local var0 = arg0:BossId2FleetKey(arg1)
	local var1 = arg2:getShipIds()
	local var2 = ""

	for iter0, iter1 in ipairs(var1) do
		var2 = var2 .. iter1 .. "|"
	end

	PlayerPrefs.SetString(var0 .. getProxy(PlayerProxy):getRawData().id, var2)
	PlayerPrefs.Save()
end

function var0.ClearCacheShips(arg0, arg1)
	local var0 = arg0:BossId2FleetKey(arg1)

	PlayerPrefs.DeleteKey(var0 .. getProxy(PlayerProxy):getRawData().id)
	PlayerPrefs.Save()
end

function var0.UpdteRefreshBossesTime(arg0)
	arg0.refreshBossesTime = pg.TimeMgr.GetInstance():GetServerTime() + var0.REFRESH_BOSSES_TIME
end

function var0.ShouldRefreshBosses(arg0)
	return pg.TimeMgr.GetInstance():GetServerTime() >= arg0.refreshBossesTime
end

function var0.UpdateCacheBoss(arg0, arg1)
	if arg0:IsSelfBoss(arg1) then
		arg0:UpdateSelfBoss(arg1)
	else
		arg0.cacheBosses[arg1.id] = arg1

		arg0:BalanceMaxBossCnt()
	end
end

function var0.BalanceMaxBossCnt(arg0)
	local var0 = pg.gameset.boss_cnt_limit.description

	if table.getCount(arg0.cacheBosses) < var0[1] then
		return
	end

	local var1 = {}
	local var2 = {}
	local var3 = {}
	local var4 = {}

	for iter0, iter1 in pairs(arg0.cacheBosses) do
		local var5 = iter1:GetType()

		if iter1:isDeath() or iter1:IsExpired() then
			table.insert(var4, iter1)
		elseif var5 == WorldBoss.BOSS_TYPE_FRIEND then
			table.insert(var3, iter1)
		elseif var5 == WorldBoss.BOSS_TYPE_GUILD then
			table.insert(var2, iter1)
		elseif var5 == WorldBoss.BOSS_TYPE_WORLD then
			table.insert(var1, iter1)
		end
	end

	if #var1 > var0[2] then
		table.sort(var1, function(arg0, arg1)
			return arg0:GetJoinTime() < arg1:GetJoinTime()
		end)

		if var1[1] then
			table.insert(var4, var1[1])
		end
	end

	if #var2 > var0[3] then
		table.sort(var2, function(arg0, arg1)
			return arg0:GetJoinTime() < arg1:GetJoinTime()
		end)

		if var2[1] then
			table.insert(var4, var2[1])
		end
	end

	if #var3 > var0[4] then
		table.sort(var3, function(arg0, arg1)
			return arg0:GetJoinTime() < arg1:GetJoinTime()
		end)

		if var3[1] then
			table.insert(var4, var3[1])
		end
	end

	if #var4 > 0 then
		for iter2, iter3 in ipairs(var4) do
			if arg0.cacheBosses[iter3.id] and iter3.id ~= arg0.cacheLock then
				arg0.cacheBosses[iter3.id] = nil
			end
		end

		arg0:DispatchEvent(var0.EventCacheBossListUpdated)
	end
end

function var0.RemoveCacheBoss(arg0, arg1)
	if arg0.cacheBosses[arg1] then
		arg0.cacheBosses[arg1] = nil

		arg0:DispatchEvent(var0.EventCacheBossListUpdated)
	end
end

function var0.GetCacheBoss(arg0, arg1)
	return arg0.cacheBosses[arg1]
end

function var0.LockCacheBoss(arg0, arg1)
	arg0.cacheLock = arg1
end

function var0.UnlockCacheBoss(arg0)
	arg0.cacheLock = nil
end

function var0.canGetSelfAward(arg0)
	local var0 = arg0:GetSelfBoss()

	return var0 and var0:isDeath()
end

function var0.UpdateSelfBoss(arg0, arg1)
	if arg0.boss and arg1 and not arg1:isSameLevel(arg0.boss) then
		arg0.fleet:clearFleet()
	end

	arg0.boss = arg1

	arg0:DispatchEvent(var0.EventBossUpdated)
end

function var0.RemoveSelfBoss(arg0)
	if arg0.boss then
		arg0:UpdateSelfBoss(nil)
	end

	arg0:ClearHighestDamage()
	arg0:ClearAutoBattle()
	arg0:ClearFriendSupported()
	arg0:ClearGuildSupported()
	arg0:ClearWorldSupported()
end

function var0.updateBossHp(arg0, arg1, arg2)
	if arg0.boss and arg1 == arg0.boss.id then
		arg0.boss:UpdateHp(arg2)
		arg0:UpdateSelfBoss(arg0.boss)
	else
		local var0 = arg0.cacheBosses[arg1]

		if var0 then
			var0:UpdateHp(arg2)
			arg0:UpdateCacheBoss(var0)
		end
	end
end

function var0.GetBossById(arg0, arg1)
	if arg0.boss and arg0.boss.id == arg1 then
		return arg0.boss
	end

	local var0 = arg0.cacheBosses[arg1]

	if var0 then
		return var0
	end
end

function var0.GetSelfBoss(arg0)
	return arg0.boss
end

function var0.IsSelfBoss(arg0, arg1)
	assert(arg1)

	return arg0.boss and arg0.boss.id == arg1.id or arg1:IsSelf()
end

function var0.GetBoss(arg0)
	return arg0.boss
end

function var0.ExistSelfBoss(arg0)
	return arg0.boss ~= nil and not arg0.boss:IsExpired()
end

function var0.GetCacheBossList(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.cacheBosses) do
		if not arg0:IsSelfBoss(iter1) then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.reducePt(arg0)
	arg0.pt = arg0.pt - 1

	arg0:DispatchEvent(var0.EventPtUpdated)
end

function var0.increasePt(arg0)
	local var0 = arg0:GetMaxPt()

	arg0.pt = math.min(var0, arg0.pt + pg.gameset.joint_boss_ap_recove_cnt_pre_day.key_value)

	arg0:DispatchEvent(var0.EventPtUpdated)
end

function var0.SetRank(arg0, arg1, arg2)
	arg0.ranks[arg1] = arg2

	local var0 = arg0:GetBossById(arg1)

	if var0 then
		var0:SetRankCnt(#arg2)
	end

	arg0:addTimer(arg1)
	arg0:DispatchEvent(var0.EventRankListUpdated, arg1)
end

function var0.GetRank(arg0, arg1)
	return arg0.ranks[arg1]
end

function var0.ClearRank(arg0, arg1)
	arg0.ranks[arg1] = nil
end

function var0.addTimer(arg0, arg1)
	if not arg1 then
		return
	end

	if arg0.timers[arg1] then
		arg0.timers[arg1]:Stop()

		arg0.timers[arg1] = nil
	end

	arg0.timers[arg1] = Timer.New(function()
		if arg0.ranks then
			arg0.ranks[arg1] = nil
		end

		if arg0.timer and arg0.timers[arg1] then
			arg0.timers[arg1]:Stop()

			arg0.timers[arg1] = nil
		end
	end, 300, 1)

	arg0.timers[arg1]:Start()
end

function var0.GetPt(arg0)
	return arg0.pt
end

function var0.GetMaxPt(arg0)
	return pg.gameset.joint_boss_ap_max.key_value
end

function var0.isMaxPt(arg0)
	return arg0.pt == arg0:GetMaxPt()
end

function var0.GetRecoverPtTime(arg0)
	return pg.gameset.joint_boss_ap_recover_time.key_value
end

function var0.GetNextReconveTime(arg0)
	return arg0.ptTime
end

function var0.updatePtTime(arg0, arg1)
	arg0.ptTime = arg1
end

function var0.Dispose(arg0)
	var0.super.Dispose(arg0)

	for iter0, iter1 in pairs(arg0.timers or {}) do
		iter1:Stop()
	end

	arg0.timers = nil
end

function var0.NeedTip(arg0)
	return (function()
		if arg0.boss and arg0.boss:isDeath() and not arg0.boss:IsExpired() and not arg0.boss:ShouldWaitForResult() then
			return true
		end

		return false
	end)()
end

function var0.UpdatedUnlockProgress(arg0, arg1, arg2)
	if arg2 <= arg1 or not nowWorld():IsSystemOpen(WorldConst.SystemWorldBoss) then
		arg0.tipProgress = false
	elseif not (pg.NewStoryMgr.GetInstance():IsPlayed("WorldG190") or not GUIDE_WROLD) then
		arg0.tipProgress = true
	else
		local var0 = getProxy(SettingsProxy):GetWorldBossProgressTipTable()

		if #var0 == 0 then
			arg0.tipProgress = false
		else
			arg0.tipProgress = _.any(var0, function(arg0)
				return arg1 < tonumber(arg0) and arg2 >= tonumber(arg0)
			end)
		end
	end

	arg0:DispatchEvent(var0.EventUnlockProgressUpdated)
end

function var0.ShouldTipProgress(arg0)
	return arg0.tipProgress
end

function var0.ClearTipProgress(arg0)
	arg0.tipProgress = false
end

function var0.GetCanGetAwardBoss(arg0)
	return nil
end

function var0.ExistSelfBossAward(arg0)
	if arg0.boss and arg0.boss:isDeath() and not arg0.boss:IsExpired() then
		return true
	end

	return false
end

function var0.ExistCacheBoss(arg0)
	return table.getCount(arg0.cacheBosses) ~= 0
end

function var0.IsOpen(arg0)
	return WorldBossConst.GetCurrBossID() ~= nil
end

function var0.IsNeedSupport()
	local var0 = WorldBossConst.GetCurrBossDayIndex()
	local var1 = pg.gameset.world_metaboss_supportattack.description
	local var2 = nowWorld():GetBossProxy():GetSelfBoss()

	if not var2 then
		return
	end

	if not WorldBossConst._IsCurrBoss(var2) then
		return
	end

	if var0 < var1[1] then
		return
	end

	return true
end

function var0.GetSupportValue()
	if not WorldBossProxy.IsNeedSupport() then
		return
	end

	local var0 = pg.gameset.world_metaboss_supportattack.description
	local var1 = 0

	assert(var0[6], "Missing WorldBoss SupportAttack Buff")

	return true, var1, var0[6]
end

return var0
