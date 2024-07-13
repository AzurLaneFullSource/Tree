local var0_0 = class("BismarckChapterPage", import("...base.BaseActivityPage"))

var0_0.tabPos = {
	[1] = 10,
	[2] = 182.3
}
var0_0.IconShowFunc = {
	[DROP_TYPE_SHIP] = function(arg0_1, arg1_1)
		local var0_1 = pg.ship_data_statistics[arg1_1].skin_id
		local var1_1 = pg.ship_skin_template[var0_1].painting

		GetImageSpriteFromAtlasAsync("SquareIcon/" .. var1_1, "", arg0_1)
	end,
	[DROP_TYPE_FURNITURE] = function(arg0_2, arg1_2)
		local var0_2 = pg.furniture_data_template[arg1_2]

		GetImageSpriteFromAtlasAsync("furnitureicon/" .. var0_2.icon, "", arg0_2)
	end
}
var0_0.TransformType = {
	[TASK_SUB_TYPE_COLLECT_SHIP] = DROP_TYPE_SHIP,
	[TASK_SUB_TYPE_COLLECT_FURNITURE] = DROP_TYPE_FURNITURE
}

function var0_0.OnInit(arg0_3)
	arg0_3.bg = arg0_3:findTF("AD")
	arg0_3.items = {}
	arg0_3.items[1] = arg0_3:findTF("AD/Item1")
	arg0_3.items[2] = arg0_3:findTF("AD/Item2")
	arg0_3.awardTF = arg0_3:findTF("AD/award")
	arg0_3.battleBtn = arg0_3:findTF("AD/battle_btn")
	arg0_3.shopBtn = arg0_3:findTF("AD/exchange_btn")
	arg0_3.buildBtn = arg0_3:findTF("AD/build_btn")
	arg0_3.tab = arg0_3:findTF("tab")
	arg0_3.bar = arg0_3:findTF("bar")
	arg0_3.scrollList = arg0_3:findTF("Scroll View", arg0_3.tab)
	arg0_3.content = arg0_3:findTF("Content", arg0_3.scrollList)
	arg0_3.listTmpl = arg0_3:findTF("listitem", arg0_3.tab)
	arg0_3.taskList = UIItemList.New(arg0_3.content, arg0_3.listTmpl)
	arg0_3.finalTasks = {}
	arg0_3.subtasks = {}
	arg0_3.tabType = 0
end

function var0_0.OnFirstFlush(arg0_4)
	arg0_4.finalTasks = Clone(arg0_4.activity:getConfig("config_client"))

	local var0_4 = arg0_4.finalTasks

	_.each(var0_4, function(arg0_5)
		local var0_5 = pg.task_data_template[arg0_5]
		local var1_5 = var0_5 and var0_5.target_id

		if var1_5 then
			table.insert(arg0_4.subtasks, Clone(var1_5))
		end
	end)
	setText(arg0_4:findTF("desc", arg0_4.bg), i18n("bismarck_chapter_desc"))
	arg0_4:SubimtCompletedMission()
	arg0_4:InitInteractable()
end

function var0_0.InitInteractable(arg0_6)
	local var0_6 = getProxy(TaskProxy)

	for iter0_6, iter1_6 in ipairs(arg0_6.finalTasks) do
		local var1_6 = pg.task_data_template[iter1_6]
		local var2_6 = arg0_6.items[iter0_6]

		onButton(arg0_6, var2_6, function()
			local var0_7 = var0_6:getTaskVO(iter1_6)

			if var0_7:getTaskStatus() == 1 then
				arg0_6:emit(ActivityMediator.ON_TASK_SUBMIT, var0_7)

				return
			end

			if arg0_6.tabType == iter0_6 then
				return
			end

			arg0_6.tabType = iter0_6

			arg0_6:UpdateTab()
		end, SFX_PANEL)
	end

	onButton(arg0_6, arg0_6.battleBtn, function()
		arg0_6:emit(ActivityMediator.BATTLE_OPERA)
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.shopBtn, function()
		local var0_9 = _.detect(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHOP), function(arg0_10)
			return arg0_10:getConfig("config_client").pt_id == pg.gameset.activity_res_id.key_value
		end)

		arg0_6:emit(ActivityMediator.GO_SHOPS_LAYER, {
			warp = NewShopsScene.TYPE_ACTIVITY,
			actId = var0_9 and var0_9.id
		})
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.buildBtn, function()
		arg0_6:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
			projectName = BuildShipScene.PROJECTS.ACTIVITY
		})
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.bg, function()
		if arg0_6.tabType > 0 then
			arg0_6.tabType = 0

			arg0_6:UpdateTab()
		end
	end)
end

function var0_0.OnUpdateFlush(arg0_13)
	arg0_13:UpdateView()
	arg0_13:UpdateTab()
end

function var0_0.UpdateView(arg0_14)
	local var0_14 = getProxy(TaskProxy)

	for iter0_14 = 1, #arg0_14.finalTasks do
		local var1_14 = arg0_14.finalTasks[iter0_14]
		local var2_14 = pg.task_data_template[var1_14]
		local var3_14 = arg0_14.items[iter0_14]

		setActive(var3_14, true)

		local var4_14 = var2_14.award_display[1]

		arg0_14:UpdateIcon(arg0_14:findTF("icon", var3_14), var4_14[1], var4_14[2])

		local var5_14 = var0_14:getTaskVO(var1_14):getTaskStatus()

		setActive(var3_14:Find("active"), var5_14 == 0)
		setActive(var3_14:Find("finished"), var5_14 == 1)
		setActive(var3_14:Find("achieved"), var5_14 == 2)
		setButtonEnabled(var3_14, var5_14 < 2)

		arg0_14.tabType = arg0_14.tabType == iter0_14 and var5_14 == 2 and 0 or arg0_14.tabType
	end

	for iter1_14 = #arg0_14.finalTasks + 1, #arg0_14.items do
		setActive(arg0_14.items[iter1_14], false)

		arg0_14.tabType = arg0_14.tabType == iter1_14 and 0 or arg0_14.tabType
	end
end

function var0_0.UpdateTab(arg0_15)
	if arg0_15.tabType == 0 then
		setActive(arg0_15.tab, false)

		return
	end

	local var0_15 = arg0_15.subtasks[arg0_15.tabType]
	local var1_15 = #var0_15

	arg0_15.taskList:align(var1_15)

	local var2_15 = getProxy(TaskProxy)
	local var3_15 = 0

	for iter0_15 = 1, var1_15 do
		local var4_15 = arg0_15.content:GetChild(iter0_15 - 1)

		setText(arg0_15:findTF("title/Text", var4_15), string.format("Task-%02d", iter0_15))

		local var5_15 = var0_15[iter0_15]
		local var6_15 = pg.task_data_template[var5_15]
		local var7_15 = tonumber(var6_15.target_id)
		local var8_15 = var0_0.TransformType[var6_15.sub_type]

		setActive(var4_15:Find("tip2"), var8_15 == DROP_TYPE_FURNITURE)
		setActive(var4_15:Find("tip"), var8_15 == DROP_TYPE_SHIP)

		local var9_15 = false
		local var10_15 = var2_15:getTaskById(var5_15) or var2_15:getFinishTaskById(var5_15)

		setActive(var4_15:Find("completed"), defaultValue(var10_15 and var10_15:isFinish(), false))
		setText(arg0_15:findTF("text", var4_15), var6_15.desc)
		arg0_15:UpdateIcon(arg0_15:findTF("icon", var4_15), var8_15, var7_15)

		var3_15 = var3_15 + (var10_15 and var10_15:isFinish() and 1 or 0)
	end

	setText(arg0_15:findTF("slider/progress", arg0_15.tab), string.format("[%d/%d]", var3_15, var1_15))

	arg0_15.scrollList:GetComponent(typeof(ScrollRect)).verticalNormalizedPosition = 1

	local var11_15 = arg0_15.tab.transform.anchoredPosition
	local var12_15 = arg0_15.tab.sizeDelta

	var11_15.x = var0_0.tabPos[arg0_15.tabType]

	setAnchoredPosition(arg0_15.tab, var11_15)

	local var13_15

	var13_15.x, var13_15 = arg0_15._tf.sizeDelta.x - arg0_15.bar.anchoredPosition.x - var11_15.x - var12_15.x, arg0_15.bar.sizeDelta
	arg0_15.bar.sizeDelta = var13_15

	setActive(arg0_15.tab, true)
end

function var0_0.UpdateIcon(arg0_16, arg1_16, arg2_16, arg3_16)
	if var0_0.IconShowFunc[arg2_16] then
		var0_0.IconShowFunc[arg2_16](arg1_16, arg3_16)
	end
end

function var0_0.OnDestroy(arg0_17)
	return
end

function var0_0.SubimtCompletedMission(arg0_18)
	local var0_18 = getProxy(TaskProxy)

	for iter0_18, iter1_18 in pairs(arg0_18.subtasks) do
		for iter2_18, iter3_18 in pairs(iter1_18) do
			local var1_18 = var0_18:getTaskById(iter3_18)

			if var1_18 and var1_18:isFinish() then
				arg0_18:emit(ActivityMediator.ON_TASK_SUBMIT, var1_18)
			end
		end
	end
end

return var0_0
