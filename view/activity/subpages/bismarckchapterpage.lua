local var0 = class("BismarckChapterPage", import("...base.BaseActivityPage"))

var0.tabPos = {
	[1] = 10,
	[2] = 182.3
}
var0.IconShowFunc = {
	[DROP_TYPE_SHIP] = function(arg0, arg1)
		local var0 = pg.ship_data_statistics[arg1].skin_id
		local var1 = pg.ship_skin_template[var0].painting

		GetImageSpriteFromAtlasAsync("SquareIcon/" .. var1, "", arg0)
	end,
	[DROP_TYPE_FURNITURE] = function(arg0, arg1)
		local var0 = pg.furniture_data_template[arg1]

		GetImageSpriteFromAtlasAsync("furnitureicon/" .. var0.icon, "", arg0)
	end
}
var0.TransformType = {
	[TASK_SUB_TYPE_COLLECT_SHIP] = DROP_TYPE_SHIP,
	[TASK_SUB_TYPE_COLLECT_FURNITURE] = DROP_TYPE_FURNITURE
}

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.items = {}
	arg0.items[1] = arg0:findTF("AD/Item1")
	arg0.items[2] = arg0:findTF("AD/Item2")
	arg0.awardTF = arg0:findTF("AD/award")
	arg0.battleBtn = arg0:findTF("AD/battle_btn")
	arg0.shopBtn = arg0:findTF("AD/exchange_btn")
	arg0.buildBtn = arg0:findTF("AD/build_btn")
	arg0.tab = arg0:findTF("tab")
	arg0.bar = arg0:findTF("bar")
	arg0.scrollList = arg0:findTF("Scroll View", arg0.tab)
	arg0.content = arg0:findTF("Content", arg0.scrollList)
	arg0.listTmpl = arg0:findTF("listitem", arg0.tab)
	arg0.taskList = UIItemList.New(arg0.content, arg0.listTmpl)
	arg0.finalTasks = {}
	arg0.subtasks = {}
	arg0.tabType = 0
end

function var0.OnFirstFlush(arg0)
	arg0.finalTasks = Clone(arg0.activity:getConfig("config_client"))

	local var0 = arg0.finalTasks

	_.each(var0, function(arg0)
		local var0 = pg.task_data_template[arg0]
		local var1 = var0 and var0.target_id

		if var1 then
			table.insert(arg0.subtasks, Clone(var1))
		end
	end)
	setText(arg0:findTF("desc", arg0.bg), i18n("bismarck_chapter_desc"))
	arg0:SubimtCompletedMission()
	arg0:InitInteractable()
end

function var0.InitInteractable(arg0)
	local var0 = getProxy(TaskProxy)

	for iter0, iter1 in ipairs(arg0.finalTasks) do
		local var1 = pg.task_data_template[iter1]
		local var2 = arg0.items[iter0]

		onButton(arg0, var2, function()
			local var0 = var0:getTaskVO(iter1)

			if var0:getTaskStatus() == 1 then
				arg0:emit(ActivityMediator.ON_TASK_SUBMIT, var0)

				return
			end

			if arg0.tabType == iter0 then
				return
			end

			arg0.tabType = iter0

			arg0:UpdateTab()
		end, SFX_PANEL)
	end

	onButton(arg0, arg0.battleBtn, function()
		arg0:emit(ActivityMediator.BATTLE_OPERA)
	end, SFX_PANEL)
	onButton(arg0, arg0.shopBtn, function()
		local var0 = _.detect(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHOP), function(arg0)
			return arg0:getConfig("config_client").pt_id == pg.gameset.activity_res_id.key_value
		end)

		arg0:emit(ActivityMediator.GO_SHOPS_LAYER, {
			warp = NewShopsScene.TYPE_ACTIVITY,
			actId = var0 and var0.id
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.buildBtn, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
			projectName = BuildShipScene.PROJECTS.ACTIVITY
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.bg, function()
		if arg0.tabType > 0 then
			arg0.tabType = 0

			arg0:UpdateTab()
		end
	end)
end

function var0.OnUpdateFlush(arg0)
	arg0:UpdateView()
	arg0:UpdateTab()
end

function var0.UpdateView(arg0)
	local var0 = getProxy(TaskProxy)

	for iter0 = 1, #arg0.finalTasks do
		local var1 = arg0.finalTasks[iter0]
		local var2 = pg.task_data_template[var1]
		local var3 = arg0.items[iter0]

		setActive(var3, true)

		local var4 = var2.award_display[1]

		arg0:UpdateIcon(arg0:findTF("icon", var3), var4[1], var4[2])

		local var5 = var0:getTaskVO(var1):getTaskStatus()

		setActive(var3:Find("active"), var5 == 0)
		setActive(var3:Find("finished"), var5 == 1)
		setActive(var3:Find("achieved"), var5 == 2)
		setButtonEnabled(var3, var5 < 2)

		arg0.tabType = arg0.tabType == iter0 and var5 == 2 and 0 or arg0.tabType
	end

	for iter1 = #arg0.finalTasks + 1, #arg0.items do
		setActive(arg0.items[iter1], false)

		arg0.tabType = arg0.tabType == iter1 and 0 or arg0.tabType
	end
end

function var0.UpdateTab(arg0)
	if arg0.tabType == 0 then
		setActive(arg0.tab, false)

		return
	end

	local var0 = arg0.subtasks[arg0.tabType]
	local var1 = #var0

	arg0.taskList:align(var1)

	local var2 = getProxy(TaskProxy)
	local var3 = 0

	for iter0 = 1, var1 do
		local var4 = arg0.content:GetChild(iter0 - 1)

		setText(arg0:findTF("title/Text", var4), string.format("Task-%02d", iter0))

		local var5 = var0[iter0]
		local var6 = pg.task_data_template[var5]
		local var7 = tonumber(var6.target_id)
		local var8 = var0.TransformType[var6.sub_type]

		setActive(var4:Find("tip2"), var8 == DROP_TYPE_FURNITURE)
		setActive(var4:Find("tip"), var8 == DROP_TYPE_SHIP)

		local var9 = false
		local var10 = var2:getTaskById(var5) or var2:getFinishTaskById(var5)

		setActive(var4:Find("completed"), defaultValue(var10 and var10:isFinish(), false))
		setText(arg0:findTF("text", var4), var6.desc)
		arg0:UpdateIcon(arg0:findTF("icon", var4), var8, var7)

		var3 = var3 + (var10 and var10:isFinish() and 1 or 0)
	end

	setText(arg0:findTF("slider/progress", arg0.tab), string.format("[%d/%d]", var3, var1))

	arg0.scrollList:GetComponent(typeof(ScrollRect)).verticalNormalizedPosition = 1

	local var11 = arg0.tab.transform.anchoredPosition
	local var12 = arg0.tab.sizeDelta

	var11.x = var0.tabPos[arg0.tabType]

	setAnchoredPosition(arg0.tab, var11)

	local var13

	var13.x, var13 = arg0._tf.sizeDelta.x - arg0.bar.anchoredPosition.x - var11.x - var12.x, arg0.bar.sizeDelta
	arg0.bar.sizeDelta = var13

	setActive(arg0.tab, true)
end

function var0.UpdateIcon(arg0, arg1, arg2, arg3)
	if var0.IconShowFunc[arg2] then
		var0.IconShowFunc[arg2](arg1, arg3)
	end
end

function var0.OnDestroy(arg0)
	return
end

function var0.SubimtCompletedMission(arg0)
	local var0 = getProxy(TaskProxy)

	for iter0, iter1 in pairs(arg0.subtasks) do
		for iter2, iter3 in pairs(iter1) do
			local var1 = var0:getTaskById(iter3)

			if var1 and var1:isFinish() then
				arg0:emit(ActivityMediator.ON_TASK_SUBMIT, var1)
			end
		end
	end
end

return var0
