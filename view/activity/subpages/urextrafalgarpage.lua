local var0_0 = class("UrExTrafalgarPage", import(".TemplatePage.UrExchangeTemplatePage"))
local var1_0 = pg.activity_holiday_site

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.icon = arg0_1:findTF("AD/icon")
	arg0_1.taskTypeDic = setmetatable({
		[var0_0.MINI_GAME] = function(arg0_2, arg1_2)
			local var0_2 = arg1_2[1]
			local var1_2 = getProxy(MiniGameProxy):GetHubByGameId(var0_2).count == 0

			local function var2_2()
				local var0_3 = getProxy(TaskProxy)
				local var1_3 = getProxy(ActivityProxy):getActivityById(ActivityConst.HOLIDAY_ACT_ID):getConfig("config_client").function_id
				local var2_3 = var1_0[var1_3[3]].task_id

				if var0_3:getTaskVO(var2_3):getTaskStatus() == 2 then
					arg0_2:emit(ActivityMediator.GO_MINI_GAME, var0_2)
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("challenge_minigame_unlock"))
				end
			end

			return var1_2 and "1/1" or "0/1", not var1_2 and var2_2 or nil
		end
	}, {
		__index = arg0_1.taskTypeDic
	})
end

function var0_0.OnFirstFlush(arg0_4)
	var0_0.super.OnFirstFlush(arg0_4)
	setActive(arg0_4._tasksTF, false)
	setActive(arg0_4.icon, false)
	setActive(arg0_4._btnHelp, false)
end

function var0_0.OnUpdateFlush(arg0_5)
	var0_0.super.OnUpdateFlush(arg0_5)
	setGray(arg0_5._btnExchange, true, true)
end

return var0_0
