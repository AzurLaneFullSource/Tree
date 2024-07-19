local var0_0 = class("WorldBossMediator", import("...base.ContextMediator"))

var0_0.ON_BATTLE = "WorldBossMediator:ON_BATTLE"
var0_0.ON_RANK_LIST = "WorldBossMediator:ON_RANK_LIST"
var0_0.ON_FETCH_BOSS = "WorldBossMediator:ON_FETCH_BOSS"
var0_0.ON_SURPPORT = "WorldBossMediator:ON_SURPPORT"
var0_0.ON_SUBMIT_AWARD = "WorldBossMediator:ON_SUBMIT_AWARD"
var0_0.ON_SELF_BOSS_OVERTIME = "WorldBossMediator:ON_SELF_BOSS_OVERTIME"
var0_0.ON_ACTIVE_BOSS = "WorldBossMediator:ON_ACTIVE_BOSS"
var0_0.GET_RANK_CNT = "WorldBossMediator:GET_RANK_CNT"
var0_0.UPDATE_CACHE_BOSS_HP = "WorldBossMediator:UPDATE_CACHE_BOSS_HP"
var0_0.GO_META = "WorldBossMediator:GO_META"
var0_0.FETCH_RANK_FORMATION = "WorldBossMediator:FETCH_RANK_FORMATION"
var0_0.ON_SWITCH_ARCHIVES = "WorldBossMediator:ON_SWITCH_ARCHIVES"
var0_0.ON_ACTIVE_ARCHIVES_BOSS = "WorldBossMediator:ON_ACTIVE_ARCHIVES_BOSS"
var0_0.ON_ARCHIVES_BOSS_AUTO_BATTLE = "WorldBossMediator:ON_ARCHIVES_BOSS_AUTO_BATTLE"
var0_0.ON_ARCHIVES_BOSS_STOP_AUTO_BATTLE = "WorldBossMediator:ON_ARCHIVES_BOSS_STOP_AUTO_BATTLE"
var0_0.ON_ARCHIVES_BOSS_AUTO_BATTLE_TIMEOVER = "WorldBossMediator:ON_ARCHIVES_BOSS_AUTO_BATTLE_TIMEOVER"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_ARCHIVES_BOSS_STOP_AUTO_BATTLE, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.WORLD_ARCHIVES_BOSS_STOP_AUTO_BATTLE, {
			id = arg1_2,
			type = WorldBossConst.STOP_AUTO_BATTLE_MANUAL
		})
	end)
	arg0_1:bind(var0_0.ON_ARCHIVES_BOSS_AUTO_BATTLE_TIMEOVER, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.WORLD_ARCHIVES_BOSS_STOP_AUTO_BATTLE, {
			id = arg1_3,
			type = WorldBossConst.STOP_AUTO_BATTLE_TIMEOVER
		})
	end)
	arg0_1:bind(var0_0.ON_ARCHIVES_BOSS_AUTO_BATTLE, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.WORLD_ARCHIVES_BOSS_AUTO_BATTLE, {
			id = arg1_4
		})
	end)
	arg0_1:bind(var0_0.ON_ACTIVE_ARCHIVES_BOSS, function(arg0_5)
		local var0_5 = nowWorld():GetBossProxy():GetArchivesId()

		arg0_1:sendNotification(GAME.WORLD_ACTIVE_WORLD_BOSS, {
			id = var0_5,
			type = WorldBossConst.BOSS_TYPE_ARCHIVES
		})
	end)
	arg0_1:bind(var0_0.ON_ACTIVE_BOSS, function(arg0_6, arg1_6)
		arg0_1:sendNotification(GAME.WORLD_ACTIVE_WORLD_BOSS, {
			id = arg1_6,
			type = WorldBossConst.BOSS_TYPE_CURR
		})
	end)
	arg0_1:bind(var0_0.ON_SWITCH_ARCHIVES, function(arg0_7, arg1_7)
		arg0_1:sendNotification(GAME.SWITCH_WORLD_BOSS_ARCHIVES, {
			id = arg1_7
		})
	end)
	arg0_1:bind(var0_0.FETCH_RANK_FORMATION, function(arg0_8, arg1_8, arg2_8)
		arg0_1:sendNotification(GAME.WORLD_BOSS_GET_FORMATION, {
			bossId = arg2_8,
			userId = arg1_8
		})
	end)
	arg0_1:bind(var0_0.GO_META, function(arg0_9, arg1_9)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.METACHARACTER, {
			autoOpenSyn = true,
			autoOpenShipConfigID = arg1_9 * 10 + 1
		})
	end)
	arg0_1:bind(var0_0.ON_SELF_BOSS_OVERTIME, function(arg0_10)
		arg0_1:sendNotification(GAME.WORLD_SELF_BOSS_OVERTIME)
	end)
	arg0_1:bind(var0_0.ON_SUBMIT_AWARD, function(arg0_11, arg1_11)
		arg0_1:sendNotification(GAME.WORLD_BOSS_SUBMIT_AWARD, {
			bossId = arg1_11
		})
	end)
	arg0_1:bind(var0_0.ON_SURPPORT, function(arg0_12, arg1_12)
		if arg1_12[3] == true then
			arg0_1:sendNotification(GAME.WORLD_BOSS_SUPPORT, {
				type = WorldBoss.SUPPORT_TYPE_WORLD
			})
		end

		if arg1_12[1] == true then
			arg0_1:sendNotification(GAME.WORLD_BOSS_SUPPORT, {
				type = WorldBoss.SUPPORT_TYPE_FRIEND
			})
		end

		if arg1_12[2] == true then
			arg0_1:sendNotification(GAME.WORLD_BOSS_SUPPORT, {
				type = WorldBoss.SUPPORT_TYPE_GUILD
			})
		end
	end)
	arg0_1:bind(var0_0.ON_FETCH_BOSS, function(arg0_13)
		arg0_1:updateBossProxy()
	end)
	arg0_1:bind(var0_0.ON_BATTLE, function(arg0_14, arg1_14, arg2_14, arg3_14)
		arg0_1:sendNotification(GAME.WORLD_BOSS_START_BATTLE, {
			bossId = arg1_14,
			isOther = arg2_14,
			hpRate = arg3_14 or 1
		})
	end)
	arg0_1:bind(var0_0.ON_RANK_LIST, function(arg0_15, arg1_15)
		arg0_1:sendNotification(GAME.WORLD_GET_BOSS_RANK, {
			bossId = arg1_15
		})
	end)
	arg0_1:bind(var0_0.GET_RANK_CNT, function(arg0_16, arg1_16, arg2_16)
		local var0_16 = arg0_1.viewComponent.bossProxy:GetRank(arg1_16)

		if not var0_16 then
			arg0_1:sendNotification(GAME.WORLD_GET_BOSS_RANK, {
				bossId = arg1_16,
				callback = arg2_16
			})
		else
			arg2_16(#var0_16)
		end
	end)
	arg0_1:bind(var0_0.UPDATE_CACHE_BOSS_HP, function(arg0_17, arg1_17)
		arg0_1:sendNotification(GAME.GET_CACHE_BOSS_HP, {
			callback = arg1_17
		})
	end)
end

function var0_0.updateBossProxy(arg0_18)
	local var0_18 = nowWorld():GetBossProxy()
	local var1_18 = getProxy(MetaCharacterProxy)

	arg0_18.viewComponent:SetBossProxy(var0_18, var1_18)

	if not WorldBossScene.inOtherBossBattle and not arg0_18.contextData.worldBossId and not var0_18:ExistSelfBossAward() then
		local var2_18 = var0_18:GetCanGetAwardBoss()

		if var2_18 then
			arg0_18.contextData.worldBossId = var2_18.id
		end
	end

	if WorldBossScene.inOtherBossBattle or arg0_18.contextData.worldBossId then
		local var3_18 = var0_18:GetCacheBoss(arg0_18.contextData.worldBossId)

		if var3_18 and not WorldBossConst._IsCurrBoss(var3_18) then
			arg0_18.viewComponent:SwitchPage(WorldBossScene.PAGE_ARCHIVES_CHALLENGE)
		else
			arg0_18.viewComponent:SwitchPage(WorldBossScene.PAGE_CHALLENGE)
		end
	else
		arg0_18.viewComponent:SwitchPage(WorldBossScene.PAGE_ENTRANCE)
	end
end

function var0_0.listNotificationInterests(arg0_19)
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

function var0_0.handleNotification(arg0_20, arg1_20)
	local var0_20 = arg1_20:getName()
	local var1_20 = arg1_20:getBody()

	if var0_20 == GAME.WORLD_GET_BOSS_DONE then
		arg0_20:updateBossProxy()
	elseif var0_20 == GAME.WORLD_BOSS_SUPPORT_DONE then
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_joint_call_support_success"))
	elseif var0_20 == GAME.WORLD_BOSS_SUBMIT_AWARD_DONE then
		arg0_20.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_20.items)
		arg0_20.viewComponent:getAwardDone()
	elseif var0_20 == GAME.REMOVE_LAYERS then
		if not var1_20.onHome and var1_20.context.mediator == WorldBossFormationMediator then
			arg0_20.viewComponent:OnRemoveLayers()
		end
	elseif var0_20 == GAME.WORLD_BOSS_GET_FORMATION_DONE then
		arg0_20.viewComponent:OnShowFormationPreview(var1_20.ships)
	elseif var0_20 == GAME.SWITCH_WORLD_BOSS_ARCHIVES_DONE then
		arg0_20.viewComponent:OnSwitchArchives()
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_switch_archives_success"))
	elseif var0_20 == GAME.WORLD_ARCHIVES_BOSS_STOP_AUTO_BATTLE_DONE then
		arg0_20.viewComponent:OnAutoBattleResult(var1_20)
	elseif var0_20 == GAME.WORLD_ARCHIVES_BOSS_AUTO_BATTLE_DONE then
		arg0_20.viewComponent:OnAutoBattleStart(var1_20)
	elseif var0_20 == GAME.GET_META_PT_AWARD_DONE then
		arg0_20.viewComponent:OnGetMetaAwards()
		arg0_20.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_20.awards)
	end
end

return var0_0
