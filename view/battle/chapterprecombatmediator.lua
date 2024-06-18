local var0_0 = class("ChapterPreCombatMediator", import("..base.ContextMediator"))

var0_0.ON_START = "ChapterPreCombatMediator:ON_START"
var0_0.ON_SWITCH_SHIP = "ChapterPreCombatMediator:ON_SWITCH_SHIP"
var0_0.ON_SWITCH_FLEET = "ChapterPreCombatMediator:ON_SWITCH_FLEET"
var0_0.ON_OP = "ChapterPreCombatMediator:ON_OP"
var0_0.ON_AUTO = "ChapterPreCombatMediator:ON_AUTO"
var0_0.ON_SUB_AUTO = "ChapterPreCombatMediator:ON_SUB_AUTO"
var0_0.GET_CHAPTER_DROP_SHIP_LIST = "ChapterPreCombatMediator:GET_CHAPTER_DROP_SHIP_LIST"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.GET_CHAPTER_DROP_SHIP_LIST, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.GET_CHAPTER_DROP_SHIP_LIST, {
			chapterId = arg1_2,
			callback = arg2_2
		})
	end)
	arg0_1:bind(var0_0.ON_SWITCH_SHIP, function(arg0_3, arg1_3)
		local var0_3 = getProxy(ChapterProxy)
		local var1_3 = var0_3:getActiveChapter()

		var1_3.fleet:synchronousShipIndex(arg1_3)
		var0_3:updateChapter(var1_3, ChapterConst.DirtyFleet)
	end)
	arg0_1:bind(var0_0.ON_AUTO, function(arg0_4, arg1_4)
		arg0_1:onAutoBtn(arg1_4)
	end)
	arg0_1:bind(var0_0.ON_SUB_AUTO, function(arg0_5, arg1_5)
		arg0_1:onAutoSubBtn(arg1_5)
	end)
	arg0_1:bind(var0_0.ON_START, function(arg0_6)
		local var0_6 = getProxy(ChapterProxy):getActiveChapter()
		local var1_6 = var0_6.fleet
		local var2_6 = var0_6:getStageId(var1_6.line.row, var1_6.line.column)

		seriesAsync({
			function(arg0_7)
				local var0_7 = {}

				for iter0_7, iter1_7 in pairs(var1_6.ships) do
					table.insert(var0_7, iter1_7)
				end

				Fleet.EnergyCheck(var0_7, var1_6.name, function(arg0_8)
					if arg0_8 then
						arg0_7()
					end
				end)
			end,
			function(arg0_9)
				if getProxy(PlayerProxy):getRawData():GoldMax(1) then
					local var0_9 = i18n("gold_max_tip_title") .. i18n("resource_max_tip_battle")

					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = var0_9,
						onYes = arg0_9,
						weight = LayerWeightConst.SECOND_LAYER
					})
				else
					arg0_9()
				end
			end
		}, function()
			arg0_1:sendNotification(GAME.BEGIN_STAGE, {
				system = SYSTEM_SCENARIO,
				stageId = var2_6
			})
		end)
	end)
	arg0_1:bind(var0_0.ON_OP, function(arg0_11, arg1_11)
		arg0_1:sendNotification(GAME.CHAPTER_OP, arg1_11)
	end)

	local var0_1 = getProxy(ChapterProxy)
	local var1_1 = var0_1:getActiveChapter()
	local var2_1 = var1_1.fleet
	local var3_1 = var1_1:getStageId(var2_1.line.row, var2_1.line.column)

	arg0_1.viewComponent:setSubFlag(var0_1.getSubAidFlag(var1_1, var3_1))
	arg0_1.viewComponent:setPlayerInfo(getProxy(PlayerProxy):getRawData())
	arg0_1:display()
end

function var0_0.onAutoBtn(arg0_12, arg1_12)
	local var0_12 = arg1_12.isOn
	local var1_12 = arg1_12.toggle

	arg0_12:sendNotification(GAME.AUTO_BOT, {
		isActiveBot = var0_12,
		toggle = var1_12
	})
end

function var0_0.onAutoSubBtn(arg0_13, arg1_13)
	local var0_13 = arg1_13.isOn
	local var1_13 = arg1_13.toggle

	arg0_13:sendNotification(GAME.AUTO_SUB, {
		isActiveSub = var0_13,
		toggle = var1_13
	})
end

function var0_0.listNotificationInterests(arg0_14)
	return {
		PlayerProxy.UPDATED,
		GAME.BEGIN_STAGE_ERRO,
		GAME.CHAPTER_OP_DONE
	}
end

function var0_0.handleNotification(arg0_15, arg1_15)
	local var0_15 = arg1_15:getName()
	local var1_15 = arg1_15:getBody()

	if var0_15 == PlayerProxy.UPDATED then
		arg0_15.viewComponent:setPlayerInfo(getProxy(PlayerProxy):getRawData())
	elseif var0_15 == GAME.BEGIN_STAGE_ERRO then
		setActive(arg0_15.viewComponent._startBtn, true)

		if var1_15 == 3 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("battle_preCombatMediator_timeout"),
				onYes = function()
					arg0_15.viewComponent:emit(BaseUI.ON_CLOSE)
				end,
				weight = LayerWeightConst.SECOND_LAYER
			})
		end
	elseif var0_15 == GAME.CHAPTER_OP_DONE and (var1_15.type == ChapterConst.OpStrategy or var1_15.type == ChapterConst.OpRepair or var1_15.type == ChapterConst.OpRequest) then
		arg0_15:display()
	end
end

function var0_0.display(arg0_17)
	local var0_17 = getProxy(ChapterProxy):getActiveChapter()

	arg0_17.viewComponent:updateChapter(var0_17)
end

return var0_0
