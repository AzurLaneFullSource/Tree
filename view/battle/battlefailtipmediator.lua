local var0_0 = class("BattleFailTipMediator", import("..base.ContextMediator"))

var0_0.CHAPTER_RETREAT = "BattleFailTipMediator:CHAPTER_RETREAT"
var0_0.GO_NAVALTACTICS = "BattleFailTipMediator:GO_NAVALTACTICS"
var0_0.GO_HIGEST_CHAPTER = "BattleFailTipMediator:GO_HIGEST_CHAPTER"
var0_0.GO_DOCKYARD_EQUIP = "BattleFailTipMediator:GO_DOCKYARD_EQUIP"
var0_0.GO_DOCKYARD_SHIP = "BattleFailTipMediator:GO_DOCKYARD_SHIP"

function var0_0.register(arg0_1)
	arg0_1:initData()
	arg0_1:bindEvent()
end

function var0_0.initData(arg0_2)
	arg0_2.mainShips = arg0_2.contextData.mainShips
	arg0_2.battleSystem = arg0_2.contextData.battleSystem
end

function var0_0.bindEvent(arg0_3)
	arg0_3:bind(var0_0.CHAPTER_RETREAT, function(arg0_4, arg1_4)
		local var0_4 = getProxy(ChapterProxy):getActiveChapter()
		local var1_4

		if var0_4 then
			var1_4 = var0_4:getShips()
		else
			var1_4 = arg0_3.mainShips
		end

		local var2_4 = {}

		for iter0_4, iter1_4 in ipairs(var1_4) do
			var2_4[#var2_4 + 1] = iter1_4.id
		end

		arg0_3.tempShipIDList = var2_4

		arg0_3:sendNotification(GAME.CHAPTER_OP, {
			type = ChapterConst.OpRetreat
		})
	end)
	arg0_3:bind(var0_0.GO_HIGEST_CHAPTER, function(arg0_5)
		arg0_3:removeContextBeforeGO()

		local var0_5, var1_5 = getProxy(ChapterProxy):getHigestClearChapterAndMap()

		arg0_3:sendNotification(GAME.CHANGE_SCENE, SCENE.LEVEL, {
			targetChapter = var0_5,
			targetMap = var1_5
		})
	end)
	arg0_3:bind(var0_0.GO_DOCKYARD_EQUIP, function(arg0_6)
		arg0_3:removeContextBeforeGO()

		if not arg0_3.tempShipIDList then
			local var0_6 = {}

			for iter0_6, iter1_6 in ipairs(arg0_3.mainShips) do
				var0_6[#var0_6 + 1] = iter1_6.id
			end

			arg0_3.tempShipIDList = var0_6
		end

		arg0_3:sendNotification(GAME.CHANGE_SCENE, SCENE.DOCKYARD, {
			priorEquipUpShipIDList = arg0_3.tempShipIDList,
			priorMode = DockyardScene.PRIOR_MODE_EQUIP_UP,
			mode = DockyardScene.MODE_OVERVIEW,
			onClick = function(arg0_7, arg1_7)
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
					openEquipUpgrade = true,
					shipId = arg0_7.id,
					shipVOs = arg1_7,
					page = ShipViewConst.PAGE.EQUIPMENT
				})
			end
		})
	end)
	arg0_3:bind(var0_0.GO_DOCKYARD_SHIP, function(arg0_8)
		arg0_3:removeContextBeforeGO()

		if not arg0_3.tempShipIDList then
			local var0_8 = {}

			for iter0_8, iter1_8 in ipairs(arg0_3.mainShips) do
				var0_8[#var0_8 + 1] = iter1_8.id
			end

			arg0_3.tempShipIDList = var0_8
		end

		arg0_3:sendNotification(GAME.CHANGE_SCENE, SCENE.DOCKYARD, {
			priorEquipUpShipIDList = arg0_3.tempShipIDList,
			priorMode = DockyardScene.PRIOR_MODE_SHIP_UP,
			mode = DockyardScene.MODE_OVERVIEW,
			onClick = function(arg0_9, arg1_9)
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
					shipId = arg0_9.id,
					shipVOs = arg1_9,
					page = ShipViewConst.PAGE.INTENSIFY
				})
			end
		})
	end)
	arg0_3:bind(var0_0.GO_NAVALTACTICS, function(arg0_10)
		arg0_3:removeContextBeforeGO()
		arg0_3:sendNotification(GAME.CHANGE_SCENE, SCENE.NAVALTACTICS)
	end)
end

function var0_0.listNotificationInterests(arg0_11)
	return {
		GAME.CHAPTER_OP_DONE
	}
end

function var0_0.handleNotification(arg0_12, arg1_12)
	local var0_12 = arg1_12:getName()
	local var1_12 = arg1_12:getBody()

	if var0_12 == GAME.CHAPTER_OP_DONE then
		if arg0_12.viewComponent.lastClickBtn == BattleFailTipLayer.PowerUpBtn.ShipLevelUp then
			local var2_12 = getProxy(ContextProxy):getContextByMediator(LevelMediator2)

			if var2_12 then
				local var3_12 = var2_12:getContextByMediator(ChapterPreCombatMediator)

				if var3_12 then
					var2_12:removeChild(var3_12)
				end

				local var4_12 = var2_12:getContextByMediator(BattleResultMediator)

				if var4_12 then
					var2_12:removeChild(var4_12)
				end
			end

			local var5_12, var6_12 = getProxy(ChapterProxy):getHigestClearChapterAndMap()

			arg0_12:sendNotification(GAME.GO_BACK, {
				targetChapter = var5_12,
				targetMap = var6_12
			})
		elseif arg0_12.viewComponent.lastClickBtn == BattleFailTipLayer.PowerUpBtn.EquipLevelUp then
			local var7_12 = getProxy(ContextProxy):getContextByMediator(LevelMediator2)

			if var7_12 then
				local var8_12 = var7_12:getContextByMediator(ChapterPreCombatMediator)

				if var8_12 then
					var7_12:removeChild(var8_12)
				end

				local var9_12 = var7_12:getContextByMediator(BattleResultMediator)

				if var9_12 then
					var7_12:removeChild(var9_12)
				end
			end

			arg0_12:sendNotification(GAME.CHANGE_SCENE, SCENE.DOCKYARD, {
				priorEquipUpShipIDList = arg0_12.tempShipIDList,
				priorMode = DockyardScene.PRIOR_MODE_EQUIP_UP,
				mode = DockyardScene.MODE_OVERVIEW,
				onClick = function(arg0_13, arg1_13)
					pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
						openEquipUpgrade = true,
						shipId = arg0_13.id,
						shipVOs = arg1_13,
						page = ShipViewConst.PAGE.EQUIPMENT
					})
				end
			})
		elseif arg0_12.viewComponent.lastClickBtn == BattleFailTipLayer.PowerUpBtn.SkillLevelUp then
			local var10_12 = getProxy(ContextProxy):getContextByMediator(LevelMediator2)

			if var10_12 then
				local var11_12 = var10_12:getContextByMediator(ChapterPreCombatMediator)

				if var11_12 then
					var10_12:removeChild(var11_12)
				end

				local var12_12 = var10_12:getContextByMediator(BattleResultMediator)

				if var12_12 then
					var10_12:removeChild(var12_12)
				end
			end

			arg0_12:sendNotification(GAME.CHANGE_SCENE, SCENE.NAVALTACTICS)
		elseif arg0_12.viewComponent.lastClickBtn == BattleFailTipLayer.PowerUpBtn.ShipBreakUp then
			local var13_12 = getProxy(ContextProxy):getContextByMediator(LevelMediator2)

			if var13_12 then
				local var14_12 = var13_12:getContextByMediator(ChapterPreCombatMediator)

				if var14_12 then
					var13_12:removeChild(var14_12)
				end

				local var15_12 = var13_12:getContextByMediator(BattleResultMediator)

				if var15_12 then
					var13_12:removeChild(var15_12)
				end
			end

			arg0_12:sendNotification(GAME.CHANGE_SCENE, SCENE.DOCKYARD, {
				priorEquipUpShipIDList = arg0_12.tempShipIDList,
				priorMode = DockyardScene.PRIOR_MODE_SHIP_UP,
				mode = DockyardScene.MODE_OVERVIEW,
				onClick = function(arg0_14, arg1_14)
					pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
						shipId = arg0_14.id,
						shipVOs = arg1_14,
						page = ShipViewConst.PAGE.INTENSIFY
					})
				end
			})
		end

		arg0_12.tempShipIDList = nil
	end
end

function var0_0.removeContextBeforeGO(arg0_15)
	local var0_15 = getProxy(ContextProxy)
	local var1_15 = arg0_15.battleSystem

	if var1_15 == SYSTEM_SCENARIO then
		local var2_15 = var0_15:getContextByMediator(LevelMediator2)

		if var2_15 then
			local var3_15 = var2_15:getContextByMediator(ChapterPreCombatMediator)

			if var3_15 then
				var2_15:removeChild(var3_15)
			end

			local var4_15 = var2_15:getContextByMediator(BattleResultMediator)

			if var4_15 then
				var2_15:removeChild(var4_15)
			end
		end
	elseif var1_15 == SYSTEM_ROUTINE or var1_15 == SYSTEM_SUB_ROUTINE then
		local var5_15 = var0_15:getContextByMediator(DailyLevelMediator)

		if var5_15 then
			local var6_15 = var5_15:getContextByMediator(PreCombatMediator)

			if var6_15 then
				var5_15:removeChild(var6_15)
			end

			local var7_15 = var5_15:getContextByMediator(BattleResultMediator)

			if var7_15 then
				var5_15:removeChild(var7_15)
			end
		end
	elseif var1_15 == SYSTEM_DUEL then
		local var8_15 = var0_15:getContextByMediator(MilitaryExerciseMediator)

		if var8_15 then
			local var9_15 = var8_15:getContextByMediator(ExercisePreCombatMediator)

			if var9_15 then
				var8_15:removeChild(var9_15)
			end

			local var10_15 = var8_15:getContextByMediator(BattleResultMediator)

			if var10_15 then
				var8_15:removeChild(var10_15)
			end
		end
	elseif var1_15 == SYSTEM_HP_SHARE_ACT_BOSS then
		local var11_15, var12_15 = var0_15:getContextByMediator(ActivityBossPreCombatMediator)

		if var11_15 then
			var12_15:removeChild(var11_15)
		end
	end
end

return var0_0
