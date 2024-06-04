local var0 = class("NewOrleansMapPage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.item = arg0:findTF("item", arg0.bg)
	arg0.itemMask = arg0:findTF("icon_mask", arg0.item)
	arg0.gotaskBtn = arg0:findTF("gotask", arg0.bg)
	arg0.gobattleBtn = arg0:findTF("gobattle", arg0.bg)
end

function var0.OnDataSetting(arg0)
	local var0 = arg0.activity:getConfig("config_data")

	arg0.taskIDList = _.flatten(var0)
	arg0.taskProxy = getProxy(TaskProxy)
end

function var0.OnFirstFlush(arg0)
	onButton(arg0, arg0.gobattleBtn, function()
		local var0 = getProxy(ActivityProxy):getActivityById(pg.activity_const.NEW_ORLEANS_Map_BATTLE.act_id)

		if not var0 or var0:isEnd() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("challenge_end_tip"))

			return
		end

		arg0:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
	onButton(arg0, arg0.gotaskBtn, function()
		local var0 = getProxy(ActivityProxy):getActivityById(pg.activity_const.NEW_ORLEANS_Map_BATTLE.act_id)

		if not var0 or var0:isEnd() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("challenge_end_tip"))

			return
		end

		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
			page = "activity"
		})
	end)
end

function var0.OnUpdateFlush(arg0)
	local var0 = arg0:findCurTaskIndex()
	local var1 = arg0.taskIDList[var0]
	local var2 = arg0.taskProxy:getTaskVO(var1)

	arg0.curTaskVO = var2

	local var3 = var2:getConfig("award_display")[1]
	local var4 = {
		type = var3[1],
		id = var3[2],
		count = var3[3]
	}

	updateDrop(arg0.item, var4)
	onButton(arg0, arg0.item, function()
		arg0:emit(BaseUI.ON_DROP, var4)
	end, SFX_PANEL)

	local var5 = var2:getTaskStatus()

	setActive(arg0.itemMask, var5 == 2)
end

function var0.OnDestroy(arg0)
	return
end

function var0.findCurTaskIndex(arg0)
	local var0

	for iter0, iter1 in ipairs(arg0.taskIDList) do
		if arg0.taskProxy:getTaskVO(iter1):getTaskStatus() <= 1 then
			var0 = iter0

			break
		elseif iter0 == #arg0.taskIDList then
			var0 = iter0
		end
	end

	return var0
end

return var0
