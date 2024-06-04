local var0 = class("ChapterPreCombatMediator", import("..base.ContextMediator"))

var0.ON_START = "ChapterPreCombatMediator:ON_START"
var0.ON_SWITCH_SHIP = "ChapterPreCombatMediator:ON_SWITCH_SHIP"
var0.ON_SWITCH_FLEET = "ChapterPreCombatMediator:ON_SWITCH_FLEET"
var0.ON_OP = "ChapterPreCombatMediator:ON_OP"
var0.ON_AUTO = "ChapterPreCombatMediator:ON_AUTO"
var0.ON_SUB_AUTO = "ChapterPreCombatMediator:ON_SUB_AUTO"
var0.GET_CHAPTER_DROP_SHIP_LIST = "ChapterPreCombatMediator:GET_CHAPTER_DROP_SHIP_LIST"

function var0.register(arg0)
	arg0:bind(var0.GET_CHAPTER_DROP_SHIP_LIST, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.GET_CHAPTER_DROP_SHIP_LIST, {
			chapterId = arg1,
			callback = arg2
		})
	end)
	arg0:bind(var0.ON_SWITCH_SHIP, function(arg0, arg1)
		local var0 = getProxy(ChapterProxy)
		local var1 = var0:getActiveChapter()

		var1.fleet:synchronousShipIndex(arg1)
		var0:updateChapter(var1, ChapterConst.DirtyFleet)
	end)
	arg0:bind(var0.ON_AUTO, function(arg0, arg1)
		arg0:onAutoBtn(arg1)
	end)
	arg0:bind(var0.ON_SUB_AUTO, function(arg0, arg1)
		arg0:onAutoSubBtn(arg1)
	end)
	arg0:bind(var0.ON_START, function(arg0)
		local var0 = getProxy(ChapterProxy):getActiveChapter()
		local var1 = var0.fleet
		local var2 = var0:getStageId(var1.line.row, var1.line.column)

		seriesAsync({
			function(arg0)
				local var0 = {}

				for iter0, iter1 in pairs(var1.ships) do
					table.insert(var0, iter1)
				end

				Fleet.EnergyCheck(var0, var1.name, function(arg0)
					if arg0 then
						arg0()
					end
				end)
			end,
			function(arg0)
				if getProxy(PlayerProxy):getRawData():GoldMax(1) then
					local var0 = i18n("gold_max_tip_title") .. i18n("resource_max_tip_battle")

					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = var0,
						onYes = arg0,
						weight = LayerWeightConst.SECOND_LAYER
					})
				else
					arg0()
				end
			end
		}, function()
			arg0:sendNotification(GAME.BEGIN_STAGE, {
				system = SYSTEM_SCENARIO,
				stageId = var2
			})
		end)
	end)
	arg0:bind(var0.ON_OP, function(arg0, arg1)
		arg0:sendNotification(GAME.CHAPTER_OP, arg1)
	end)

	local var0 = getProxy(ChapterProxy)
	local var1 = var0:getActiveChapter()
	local var2 = var1.fleet
	local var3 = var1:getStageId(var2.line.row, var2.line.column)

	arg0.viewComponent:setSubFlag(var0.getSubAidFlag(var1, var3))
	arg0.viewComponent:setPlayerInfo(getProxy(PlayerProxy):getRawData())
	arg0:display()
end

function var0.onAutoBtn(arg0, arg1)
	local var0 = arg1.isOn
	local var1 = arg1.toggle

	arg0:sendNotification(GAME.AUTO_BOT, {
		isActiveBot = var0,
		toggle = var1
	})
end

function var0.onAutoSubBtn(arg0, arg1)
	local var0 = arg1.isOn
	local var1 = arg1.toggle

	arg0:sendNotification(GAME.AUTO_SUB, {
		isActiveSub = var0,
		toggle = var1
	})
end

function var0.listNotificationInterests(arg0)
	return {
		PlayerProxy.UPDATED,
		GAME.BEGIN_STAGE_ERRO,
		GAME.CHAPTER_OP_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:setPlayerInfo(getProxy(PlayerProxy):getRawData())
	elseif var0 == GAME.BEGIN_STAGE_ERRO then
		setActive(arg0.viewComponent._startBtn, true)

		if var1 == 3 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("battle_preCombatMediator_timeout"),
				onYes = function()
					arg0.viewComponent:emit(BaseUI.ON_CLOSE)
				end,
				weight = LayerWeightConst.SECOND_LAYER
			})
		end
	elseif var0 == GAME.CHAPTER_OP_DONE and (var1.type == ChapterConst.OpStrategy or var1.type == ChapterConst.OpRepair or var1.type == ChapterConst.OpRequest) then
		arg0:display()
	end
end

function var0.display(arg0)
	local var0 = getProxy(ChapterProxy):getActiveChapter()

	arg0.viewComponent:updateChapter(var0)
end

return var0
