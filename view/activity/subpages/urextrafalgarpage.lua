local var0_0 = class("UrExTrafalgarPage", import(".TemplatePage.UrExchangeTemplatePage"))
local var1_0 = pg.activity_holiday_site

function var0_0.UpdateTask(arg0_1, arg1_1, arg2_1)
	if not arg0_1.isLinkActOpen then
		return
	end

	local var0_1 = arg1_1 + 1
	local var1_1, var2_1, var3_1 = unpack(arg0_1.taskConfig[var0_1])
	local var4_1, var5_1 = var0_0.taskTypeDic[var1_1](arg0_1, var3_1)

	setText(arg0_1:findTF("name", arg2_1), var2_1)
	setText(arg0_1:findTF("count", arg2_1), var4_1)
	setActive(arg0_1:findTF("complete", arg2_1), var5_1 == nil)
	setActive(arg0_1:findTF("btn_go", arg2_1), var5_1 ~= nil)

	if arg1_1 == 4 then
		warning("                      type", var1_1)
		onButton(arg0_1, arg0_1:findTF("btn_go", arg2_1), function()
			local var0_2 = getProxy(TaskProxy)
			local var1_2 = getProxy(ActivityProxy):getActivityById(ActivityConst.HOLIDAY_ACT_ID):getConfig("config_client").function_id
			local var2_2 = var1_0[var1_2[3]].task_id
			local var3_2 = var0_2:getFinishTaskById(var2_2)

			warning(var2_2, "                      springFinishTask:            ", var3_2)

			if var3_2 then
				onButton(arg0_1, arg0_1:findTF("btn_go", arg2_1), function()
					var5_1()
					pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildUrJump(var1_1))
				end)
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("challenge_minigame_unlock"))
			end
		end, SFX_PANEL)
	elseif arg1_1 ~= 4 then
		warning("                      555555555", var1_1)

		if var5_1 then
			onButton(arg0_1, arg0_1:findTF("btn_go", arg2_1), function()
				var5_1()
				pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildUrJump(var1_1))
			end)
		end
	end
end

return var0_0
