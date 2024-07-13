local var0_0 = class("NewOrleansMapPage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.item = arg0_1:findTF("item", arg0_1.bg)
	arg0_1.itemMask = arg0_1:findTF("icon_mask", arg0_1.item)
	arg0_1.gotaskBtn = arg0_1:findTF("gotask", arg0_1.bg)
	arg0_1.gobattleBtn = arg0_1:findTF("gobattle", arg0_1.bg)
end

function var0_0.OnDataSetting(arg0_2)
	local var0_2 = arg0_2.activity:getConfig("config_data")

	arg0_2.taskIDList = _.flatten(var0_2)
	arg0_2.taskProxy = getProxy(TaskProxy)
end

function var0_0.OnFirstFlush(arg0_3)
	onButton(arg0_3, arg0_3.gobattleBtn, function()
		local var0_4 = getProxy(ActivityProxy):getActivityById(pg.activity_const.NEW_ORLEANS_Map_BATTLE.act_id)

		if not var0_4 or var0_4:isEnd() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("challenge_end_tip"))

			return
		end

		arg0_3:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.gotaskBtn, function()
		local var0_5 = getProxy(ActivityProxy):getActivityById(pg.activity_const.NEW_ORLEANS_Map_BATTLE.act_id)

		if not var0_5 or var0_5:isEnd() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("challenge_end_tip"))

			return
		end

		arg0_3:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
			page = "activity"
		})
	end)
end

function var0_0.OnUpdateFlush(arg0_6)
	local var0_6 = arg0_6:findCurTaskIndex()
	local var1_6 = arg0_6.taskIDList[var0_6]
	local var2_6 = arg0_6.taskProxy:getTaskVO(var1_6)

	arg0_6.curTaskVO = var2_6

	local var3_6 = var2_6:getConfig("award_display")[1]
	local var4_6 = {
		type = var3_6[1],
		id = var3_6[2],
		count = var3_6[3]
	}

	updateDrop(arg0_6.item, var4_6)
	onButton(arg0_6, arg0_6.item, function()
		arg0_6:emit(BaseUI.ON_DROP, var4_6)
	end, SFX_PANEL)

	local var5_6 = var2_6:getTaskStatus()

	setActive(arg0_6.itemMask, var5_6 == 2)
end

function var0_0.OnDestroy(arg0_8)
	return
end

function var0_0.findCurTaskIndex(arg0_9)
	local var0_9

	for iter0_9, iter1_9 in ipairs(arg0_9.taskIDList) do
		if arg0_9.taskProxy:getTaskVO(iter1_9):getTaskStatus() <= 1 then
			var0_9 = iter0_9

			break
		elseif iter0_9 == #arg0_9.taskIDList then
			var0_9 = iter0_9
		end
	end

	return var0_9
end

return var0_0
