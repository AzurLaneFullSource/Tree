local var0 = class("WorldBossMediator", import("...base.ContextMediator"))

var0.ON_BATTLE = "WorldBossMediator:ON_BATTLE"
var0.ON_RANK_LIST = "WorldBossMediator:ON_RANK_LIST"
var0.ON_FETCH_BOSS = "WorldBossMediator:ON_FETCH_BOSS"
var0.ON_SURPPORT = "WorldBossMediator:ON_SURPPORT"
var0.ON_SUBMIT_AWARD = "WorldBossMediator:ON_SUBMIT_AWARD"
var0.ON_SELF_BOSS_OVERTIME = "WorldBossMediator:ON_SELF_BOSS_OVERTIME"
var0.ON_ACTIVE_BOSS = "WorldBossMediator:ON_ACTIVE_BOSS"
var0.GET_RANK_CNT = "WorldBossMediator:GET_RANK_CNT"
var0.UPDATE_CACHE_BOSS_HP = "WorldBossMediator:UPDATE_CACHE_BOSS_HP"
var0.GO_META = "WorldBossMediator:GO_META"
var0.FETCH_RANK_FORMATION = "WorldBossMediator:FETCH_RANK_FORMATION"
var0.ON_SWITCH_ARCHIVES = "WorldBossMediator:ON_SWITCH_ARCHIVES"
var0.ON_ACTIVE_ARCHIVES_BOSS = "WorldBossMediator:ON_ACTIVE_ARCHIVES_BOSS"
var0.ON_ARCHIVES_BOSS_AUTO_BATTLE = "WorldBossMediator:ON_ARCHIVES_BOSS_AUTO_BATTLE"
var0.ON_ARCHIVES_BOSS_STOP_AUTO_BATTLE = "WorldBossMediator:ON_ARCHIVES_BOSS_STOP_AUTO_BATTLE"
var0.ON_ARCHIVES_BOSS_AUTO_BATTLE_TIMEOVER = "WorldBossMediator:ON_ARCHIVES_BOSS_AUTO_BATTLE_TIMEOVER"

function var0.register(arg0)
	arg0:bind(var0.ON_ARCHIVES_BOSS_STOP_AUTO_BATTLE, function(arg0, arg1)
		arg0:sendNotification(GAME.WORLD_ARCHIVES_BOSS_STOP_AUTO_BATTLE, {
			id = arg1,
			type = WorldBossConst.STOP_AUTO_BATTLE_MANUAL
		})
	end)
	arg0:bind(var0.ON_ARCHIVES_BOSS_AUTO_BATTLE_TIMEOVER, function(arg0, arg1)
		arg0:sendNotification(GAME.WORLD_ARCHIVES_BOSS_STOP_AUTO_BATTLE, {
			id = arg1,
			type = WorldBossConst.STOP_AUTO_BATTLE_TIMEOVER
		})
	end)
	arg0:bind(var0.ON_ARCHIVES_BOSS_AUTO_BATTLE, function(arg0, arg1)
		arg0:sendNotification(GAME.WORLD_ARCHIVES_BOSS_AUTO_BATTLE, {
			id = arg1
		})
	end)
	arg0:bind(var0.ON_ACTIVE_ARCHIVES_BOSS, function(arg0)
		local var0 = nowWorld():GetBossProxy():GetArchivesId()

		arg0:sendNotification(GAME.WORLD_ACTIVE_WORLD_BOSS, {
			id = var0,
			type = WorldBossConst.BOSS_TYPE_ARCHIVES
		})
	end)
	arg0:bind(var0.ON_ACTIVE_BOSS, function(arg0, arg1)
		arg0:sendNotification(GAME.WORLD_ACTIVE_WORLD_BOSS, {
			id = arg1,
			type = WorldBossConst.BOSS_TYPE_CURR
		})
	end)
	arg0:bind(var0.ON_SWITCH_ARCHIVES, function(arg0, arg1)
		arg0:sendNotification(GAME.SWITCH_WORLD_BOSS_ARCHIVES, {
			id = arg1
		})
	end)
	arg0:bind(var0.FETCH_RANK_FORMATION, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.WORLD_BOSS_GET_FORMATION, {
			bossId = arg2,
			userId = arg1
		})
	end)
	arg0:bind(var0.GO_META, function(arg0, arg1)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.METACHARACTER, {
			autoOpenSyn = true,
			autoOpenShipConfigID = arg1 * 10 + 1
		})
	end)
	arg0:bind(var0.ON_SELF_BOSS_OVERTIME, function(arg0)
		arg0:sendNotification(GAME.WORLD_SELF_BOSS_OVERTIME)
	end)
	arg0:bind(var0.ON_SUBMIT_AWARD, function(arg0, arg1)
		arg0:sendNotification(GAME.WORLD_BOSS_SUBMIT_AWARD, {
			bossId = arg1
		})
	end)
	arg0:bind(var0.ON_SURPPORT, function(arg0, arg1)
		if arg1[3] == true then
			arg0:sendNotification(GAME.WORLD_BOSS_SUPPORT, {
				type = WorldBoss.SUPPORT_TYPE_WORLD
			})
		end

		if arg1[1] == true then
			arg0:sendNotification(GAME.WORLD_BOSS_SUPPORT, {
				type = WorldBoss.SUPPORT_TYPE_FRIEND
			})
		end

		if arg1[2] == true then
			arg0:sendNotification(GAME.WORLD_BOSS_SUPPORT, {
				type = WorldBoss.SUPPORT_TYPE_GUILD
			})
		end
	end)
	arg0:bind(var0.ON_FETCH_BOSS, function(arg0)
		arg0:updateBossProxy()
	end)
	arg0:bind(var0.ON_BATTLE, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.WORLD_BOSS_START_BATTLE, {
			bossId = arg1,
			isOther = arg2
		})
	end)
	arg0:bind(var0.ON_RANK_LIST, function(arg0, arg1)
		arg0:sendNotification(GAME.WORLD_GET_BOSS_RANK, {
			bossId = arg1
		})
	end)
	arg0:bind(var0.GET_RANK_CNT, function(arg0, arg1, arg2)
		local var0 = arg0.viewComponent.bossProxy:GetRank(arg1)

		if not var0 then
			arg0:sendNotification(GAME.WORLD_GET_BOSS_RANK, {
				bossId = arg1,
				callback = arg2
			})
		else
			arg2(#var0)
		end
	end)
	arg0:bind(var0.UPDATE_CACHE_BOSS_HP, function(arg0, arg1)
		arg0:sendNotification(GAME.GET_CACHE_BOSS_HP, {
			callback = arg1
		})
	end)
end

function var0.updateBossProxy(arg0)
	local var0 = nowWorld():GetBossProxy()
	local var1 = getProxy(MetaCharacterProxy)

	arg0.viewComponent:SetBossProxy(var0, var1)

	if not WorldBossScene.inOtherBossBattle and not arg0.contextData.worldBossId and not var0:ExistSelfBossAward() then
		local var2 = var0:GetCanGetAwardBoss()

		if var2 then
			arg0.contextData.worldBossId = var2.id
		end
	end

	if WorldBossScene.inOtherBossBattle or arg0.contextData.worldBossId then
		local var3 = var0:GetCacheBoss(arg0.contextData.worldBossId)

		if var3 and not WorldBossConst._IsCurrBoss(var3) then
			arg0.viewComponent:SwitchPage(WorldBossScene.PAGE_ARCHIVES_CHALLENGE)
		else
			arg0.viewComponent:SwitchPage(WorldBossScene.PAGE_CHALLENGE)
		end
	else
		arg0.viewComponent:SwitchPage(WorldBossScene.PAGE_ENTRANCE)
	end
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.WORLD_GET_BOSS_DONE,
		GAME.WORLD_BOSS_SUPPORT_DONE,
		GAME.WORLD_BOSS_SUBMIT_AWARD_DONE,
		GAME.REMOVE_LAYERS,
		GAME.WORLD_BOSS_GET_FORMATION_DONE,
		GAME.SWITCH_WORLD_BOSS_ARCHIVES_DONE,
		GAME.WORLD_ARCHIVES_BOSS_STOP_AUTO_BATTLE_DONE,
		GAME.WORLD_ARCHIVES_BOSS_AUTO_BATTLE_DONE,
		GAME.GET_META_PT_AWARD_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.WORLD_GET_BOSS_DONE then
		arg0:updateBossProxy()
	elseif var0 == GAME.WORLD_BOSS_SUPPORT_DONE then
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_joint_call_support_success"))
	elseif var0 == GAME.WORLD_BOSS_SUBMIT_AWARD_DONE then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.items)
		arg0.viewComponent:getAwardDone()
	elseif var0 == GAME.REMOVE_LAYERS then
		if not var1.onHome and var1.context.mediator == WorldBossFormationMediator then
			arg0.viewComponent:OnRemoveLayers()
		end
	elseif var0 == GAME.WORLD_BOSS_GET_FORMATION_DONE then
		arg0.viewComponent:OnShowFormationPreview(var1.ships)
	elseif var0 == GAME.SWITCH_WORLD_BOSS_ARCHIVES_DONE then
		arg0.viewComponent:OnSwitchArchives()
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_switch_archives_success"))
	elseif var0 == GAME.WORLD_ARCHIVES_BOSS_STOP_AUTO_BATTLE_DONE then
		arg0.viewComponent:OnAutoBattleResult(var1)
	elseif var0 == GAME.WORLD_ARCHIVES_BOSS_AUTO_BATTLE_DONE then
		arg0.viewComponent:OnAutoBattleStart(var1)
	elseif var0 == GAME.GET_META_PT_AWARD_DONE then
		arg0.viewComponent:OnGetMetaAwards()
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards)
	end
end

return var0
