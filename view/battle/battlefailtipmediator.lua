local var0 = class("BattleFailTipMediator", import("..base.ContextMediator"))

var0.CHAPTER_RETREAT = "BattleFailTipMediator:CHAPTER_RETREAT"
var0.GO_NAVALTACTICS = "BattleFailTipMediator:GO_NAVALTACTICS"
var0.GO_HIGEST_CHAPTER = "BattleFailTipMediator:GO_HIGEST_CHAPTER"
var0.GO_DOCKYARD_EQUIP = "BattleFailTipMediator:GO_DOCKYARD_EQUIP"
var0.GO_DOCKYARD_SHIP = "BattleFailTipMediator:GO_DOCKYARD_SHIP"

function var0.register(arg0)
	arg0:initData()
	arg0:bindEvent()
end

function var0.initData(arg0)
	arg0.mainShips = arg0.contextData.mainShips
	arg0.battleSystem = arg0.contextData.battleSystem
end

function var0.bindEvent(arg0)
	arg0:bind(var0.CHAPTER_RETREAT, function(arg0, arg1)
		local var0 = getProxy(ChapterProxy):getActiveChapter()
		local var1

		if var0 then
			var1 = var0:getShips()
		else
			var1 = arg0.mainShips
		end

		local var2 = {}

		for iter0, iter1 in ipairs(var1) do
			var2[#var2 + 1] = iter1.id
		end

		arg0.tempShipIDList = var2

		arg0:sendNotification(GAME.CHAPTER_OP, {
			type = ChapterConst.OpRetreat
		})
	end)
	arg0:bind(var0.GO_HIGEST_CHAPTER, function(arg0)
		arg0:removeContextBeforeGO()

		local var0, var1 = getProxy(ChapterProxy):getHigestClearChapterAndMap()

		arg0:sendNotification(GAME.CHANGE_SCENE, SCENE.LEVEL, {
			targetChapter = var0,
			targetMap = var1
		})
	end)
	arg0:bind(var0.GO_DOCKYARD_EQUIP, function(arg0)
		arg0:removeContextBeforeGO()

		if not arg0.tempShipIDList then
			local var0 = {}

			for iter0, iter1 in ipairs(arg0.mainShips) do
				var0[#var0 + 1] = iter1.id
			end

			arg0.tempShipIDList = var0
		end

		arg0:sendNotification(GAME.CHANGE_SCENE, SCENE.DOCKYARD, {
			priorEquipUpShipIDList = arg0.tempShipIDList,
			priorMode = DockyardScene.PRIOR_MODE_EQUIP_UP,
			mode = DockyardScene.MODE_OVERVIEW,
			onClick = function(arg0, arg1)
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
					openEquipUpgrade = true,
					shipId = arg0.id,
					shipVOs = arg1,
					page = ShipViewConst.PAGE.EQUIPMENT
				})
			end
		})
	end)
	arg0:bind(var0.GO_DOCKYARD_SHIP, function(arg0)
		arg0:removeContextBeforeGO()

		if not arg0.tempShipIDList then
			local var0 = {}

			for iter0, iter1 in ipairs(arg0.mainShips) do
				var0[#var0 + 1] = iter1.id
			end

			arg0.tempShipIDList = var0
		end

		arg0:sendNotification(GAME.CHANGE_SCENE, SCENE.DOCKYARD, {
			priorEquipUpShipIDList = arg0.tempShipIDList,
			priorMode = DockyardScene.PRIOR_MODE_SHIP_UP,
			mode = DockyardScene.MODE_OVERVIEW,
			onClick = function(arg0, arg1)
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
					shipId = arg0.id,
					shipVOs = arg1,
					page = ShipViewConst.PAGE.INTENSIFY
				})
			end
		})
	end)
	arg0:bind(var0.GO_NAVALTACTICS, function(arg0)
		arg0:removeContextBeforeGO()
		arg0:sendNotification(GAME.CHANGE_SCENE, SCENE.NAVALTACTICS)
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.CHAPTER_OP_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.CHAPTER_OP_DONE then
		if arg0.viewComponent.lastClickBtn == BattleFailTipLayer.PowerUpBtn.ShipLevelUp then
			local var2 = getProxy(ContextProxy):getContextByMediator(LevelMediator2)

			if var2 then
				local var3 = var2:getContextByMediator(ChapterPreCombatMediator)

				if var3 then
					var2:removeChild(var3)
				end

				local var4 = var2:getContextByMediator(BattleResultMediator)

				if var4 then
					var2:removeChild(var4)
				end
			end

			local var5, var6 = getProxy(ChapterProxy):getHigestClearChapterAndMap()

			arg0:sendNotification(GAME.GO_BACK, {
				targetChapter = var5,
				targetMap = var6
			})
		elseif arg0.viewComponent.lastClickBtn == BattleFailTipLayer.PowerUpBtn.EquipLevelUp then
			local var7 = getProxy(ContextProxy):getContextByMediator(LevelMediator2)

			if var7 then
				local var8 = var7:getContextByMediator(ChapterPreCombatMediator)

				if var8 then
					var7:removeChild(var8)
				end

				local var9 = var7:getContextByMediator(BattleResultMediator)

				if var9 then
					var7:removeChild(var9)
				end
			end

			arg0:sendNotification(GAME.CHANGE_SCENE, SCENE.DOCKYARD, {
				priorEquipUpShipIDList = arg0.tempShipIDList,
				priorMode = DockyardScene.PRIOR_MODE_EQUIP_UP,
				mode = DockyardScene.MODE_OVERVIEW,
				onClick = function(arg0, arg1)
					pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
						openEquipUpgrade = true,
						shipId = arg0.id,
						shipVOs = arg1,
						page = ShipViewConst.PAGE.EQUIPMENT
					})
				end
			})
		elseif arg0.viewComponent.lastClickBtn == BattleFailTipLayer.PowerUpBtn.SkillLevelUp then
			local var10 = getProxy(ContextProxy):getContextByMediator(LevelMediator2)

			if var10 then
				local var11 = var10:getContextByMediator(ChapterPreCombatMediator)

				if var11 then
					var10:removeChild(var11)
				end

				local var12 = var10:getContextByMediator(BattleResultMediator)

				if var12 then
					var10:removeChild(var12)
				end
			end

			arg0:sendNotification(GAME.CHANGE_SCENE, SCENE.NAVALTACTICS)
		elseif arg0.viewComponent.lastClickBtn == BattleFailTipLayer.PowerUpBtn.ShipBreakUp then
			local var13 = getProxy(ContextProxy):getContextByMediator(LevelMediator2)

			if var13 then
				local var14 = var13:getContextByMediator(ChapterPreCombatMediator)

				if var14 then
					var13:removeChild(var14)
				end

				local var15 = var13:getContextByMediator(BattleResultMediator)

				if var15 then
					var13:removeChild(var15)
				end
			end

			arg0:sendNotification(GAME.CHANGE_SCENE, SCENE.DOCKYARD, {
				priorEquipUpShipIDList = arg0.tempShipIDList,
				priorMode = DockyardScene.PRIOR_MODE_SHIP_UP,
				mode = DockyardScene.MODE_OVERVIEW,
				onClick = function(arg0, arg1)
					pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
						shipId = arg0.id,
						shipVOs = arg1,
						page = ShipViewConst.PAGE.INTENSIFY
					})
				end
			})
		end

		arg0.tempShipIDList = nil
	end
end

function var0.removeContextBeforeGO(arg0)
	local var0 = getProxy(ContextProxy)
	local var1 = arg0.battleSystem

	if var1 == SYSTEM_SCENARIO then
		local var2 = var0:getContextByMediator(LevelMediator2)

		if var2 then
			local var3 = var2:getContextByMediator(ChapterPreCombatMediator)

			if var3 then
				var2:removeChild(var3)
			end

			local var4 = var2:getContextByMediator(BattleResultMediator)

			if var4 then
				var2:removeChild(var4)
			end
		end
	elseif var1 == SYSTEM_ROUTINE or var1 == SYSTEM_SUB_ROUTINE then
		local var5 = var0:getContextByMediator(DailyLevelMediator)

		if var5 then
			local var6 = var5:getContextByMediator(PreCombatMediator)

			if var6 then
				var5:removeChild(var6)
			end

			local var7 = var5:getContextByMediator(BattleResultMediator)

			if var7 then
				var5:removeChild(var7)
			end
		end
	elseif var1 == SYSTEM_DUEL then
		local var8 = var0:getContextByMediator(MilitaryExerciseMediator)

		if var8 then
			local var9 = var8:getContextByMediator(ExercisePreCombatMediator)

			if var9 then
				var8:removeChild(var9)
			end

			local var10 = var8:getContextByMediator(BattleResultMediator)

			if var10 then
				var8:removeChild(var10)
			end
		end
	elseif var1 == SYSTEM_HP_SHARE_ACT_BOSS then
		local var11, var12 = var0:getContextByMediator(ActivityBossPreCombatMediator)

		if var11 then
			var12:removeChild(var11)
		end
	end
end

return var0
