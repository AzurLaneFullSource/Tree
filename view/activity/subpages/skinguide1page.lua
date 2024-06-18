local var0_0 = class("SkinGuide1Page", import("...base.BaseActivityPage"))
local var1_0 = "ui/activityuipage/skinguide1page_atlas"
local var2_0 = {
	"xiafei",
	"weiyan",
	"kuersike",
	"deliyasite",
	"fuluoxiluofu"
}

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD/mask")
	arg0_1.countTF = arg0_1:findTF("rightPanel/count", arg0_1.bg)
	arg0_1.itemTpl = arg0_1:findTF("itemTpl", arg0_1.bg)

	setActive(arg0_1.itemTpl, false)

	arg0_1.items = arg0_1:findTF("rightPanel/items", arg0_1.bg)
	arg0_1.countImg = arg0_1:findTF("countImg", arg0_1.bg)
	arg0_1.paintings = arg0_1:findTF("paintings", arg0_1.bg)
	arg0_1.paintingsSelected = arg0_1:findTF("paintingsSelected", arg0_1.bg)
	arg0_1.descTf = arg0_1:findTF("rightPanel/desc", arg0_1.bg)
	arg0_1.rightPanel = arg0_1:findTF("rightPanel", arg0_1.bg)
	arg0_1.itemTfs = {}
	arg0_1.selectedIndex = 1
	arg0_1.paintingTfs = {}
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.taskProxy = getProxy(TaskProxy)
	arg0_2.taskList = arg0_2.activity:getConfig("config_data")
	arg0_2.totalCnt = #arg0_2.taskList
end

function var0_0.OnFirstFlush(arg0_3)
	arg0_3.usedCnt = arg0_3.activity:getData1()
	arg0_3.unlockCnt = pg.TimeMgr.GetInstance():DiffDay(arg0_3.activity:getStartTime(), pg.TimeMgr.GetInstance():GetServerTime()) + 1
	arg0_3.unlockCnt = arg0_3.unlockCnt * tonumber(arg0_3.activity:getConfig("config_id"))
	arg0_3.unlockCnt = arg0_3.unlockCnt > arg0_3.totalCnt and arg0_3.totalCnt or arg0_3.unlockCnt
	arg0_3.remainCnt = arg0_3.usedCnt >= arg0_3.totalCnt and 0 or arg0_3.unlockCnt - arg0_3.usedCnt

	local var0_3 = 1

	for iter0_3 = 1, #arg0_3.taskList do
		local var1_3 = iter0_3
		local var2_3 = tf(instantiate(arg0_3.itemTpl))

		setParent(var2_3, arg0_3.items)

		var2_3.anchoredPosition = Vector2(0, 0)

		setActive(var2_3, false)

		local var3_3 = arg0_3.taskList[iter0_3]
		local var4_3 = arg0_3.taskProxy:getTaskById(var3_3) or arg0_3.taskProxy:getFinishTaskById(var3_3)
		local var5_3 = var4_3:getConfig("award_display")[1]
		local var6_3 = {
			type = var5_3[1],
			id = var5_3[2],
			count = var5_3[3]
		}

		updateDrop(findTF(var2_3, "item"), var6_3)
		onButton(arg0_3, var2_3, function()
			arg0_3:emit(BaseUI.ON_DROP, var6_3)
		end, SFX_PANEL)
		table.insert(arg0_3.itemTfs, var2_3)

		local var7_3 = arg0_3:findTF("get", var2_3)

		onButton(arg0_3, var7_3, function()
			arg0_3:emit(ActivityMediator.ON_TASK_SUBMIT, var4_3)
		end, SFX_PANEL)

		local var8_3 = findTF(arg0_3.paintings, var2_0[iter0_3])

		table.insert(arg0_3.paintingTfs, var8_3)

		GetComponent(findTF(var8_3, "normal"), typeof(Image)).alphaHitTestMinimumThreshold = 0.5

		onButton(arg0_3, findTF(var8_3, "normal"), function()
			arg0_3:selectedChange(var1_3)
		end, SFX_PANEL)

		if var4_3:getTaskStatus() == 1 and arg0_3.remainCnt > 0 then
			var0_3 = iter0_3
		end
	end

	arg0_3:updateUI()
	arg0_3:selectedChange(var0_3)
end

function var0_0.selectedChange(arg0_7, arg1_7)
	for iter0_7 = 1, #arg0_7.itemTfs do
		setActive(arg0_7.itemTfs[iter0_7], iter0_7 == arg1_7)

		local var0_7 = arg0_7.paintingTfs[iter0_7]

		setActive(findTF(var0_7, "name"), iter0_7 == arg1_7)
		setActive(findTF(var0_7, "selected"), iter0_7 == arg1_7)
		setActive(findTF(var0_7, "normal"), iter0_7 ~= arg1_7)

		local var1_7 = arg0_7.taskList[iter0_7]
		local var2_7 = (arg0_7.taskProxy:getTaskById(var1_7) or arg0_7.taskProxy:getFinishTaskById(var1_7)):getTaskStatus() == 2

		setActive(findTF(var0_7, "mask"), not var2_7 or arg1_7 == iter0_7)

		if iter0_7 == arg1_7 then
			setParent(var0_7, arg0_7.paintingsSelected)
			var0_7:SetAsLastSibling()
		else
			setParent(var0_7, arg0_7.paintings)
		end
	end

	if arg0_7.selectedIndex ~= arg1_7 then
		setActive(arg0_7.rightPanel, false)
		setActive(arg0_7.rightPanel, true)
	end

	arg0_7.selectedIndex = arg1_7
end

function var0_0.OnUpdateFlush(arg0_8)
	local var0_8 = 0

	for iter0_8, iter1_8 in ipairs(arg0_8.taskList) do
		if arg0_8.taskProxy:getFinishTaskById(iter1_8) ~= nil then
			var0_8 = var0_8 + 1
		end
	end

	if arg0_8.usedCnt ~= var0_8 then
		arg0_8.usedCnt = var0_8

		local var1_8 = arg0_8.activity

		var1_8.data1 = arg0_8.usedCnt

		getProxy(ActivityProxy):updateActivity(var1_8)
	end

	arg0_8.unlockCnt = pg.TimeMgr.GetInstance():DiffDay(arg0_8.activity:getStartTime(), pg.TimeMgr.GetInstance():GetServerTime()) + 1
	arg0_8.unlockCnt = arg0_8.unlockCnt * tonumber(arg0_8.activity:getConfig("config_id"))
	arg0_8.unlockCnt = arg0_8.unlockCnt > arg0_8.totalCnt and arg0_8.totalCnt or arg0_8.unlockCnt
	arg0_8.remainCnt = arg0_8.usedCnt >= arg0_8.totalCnt and 0 or arg0_8.unlockCnt - arg0_8.usedCnt

	setText(arg0_8.countTF, tostring(arg0_8.remainCnt))

	local var2_8 = arg0_8.activity:getConfig("config_client").story

	for iter2_8, iter3_8 in ipairs(arg0_8.taskList) do
		if arg0_8.taskProxy:getFinishTaskById(iter3_8) and checkExist(var2_8, {
			iter2_8
		}, {
			1
		}) then
			pg.NewStoryMgr.GetInstance():Play(var2_8[iter2_8][1])
		end
	end

	arg0_8:updateUI()
end

function var0_0.updateUI(arg0_9)
	for iter0_9 = 1, #arg0_9.itemTfs do
		local var0_9 = arg0_9.taskList[iter0_9]
		local var1_9 = arg0_9.taskProxy:getTaskById(var0_9) or arg0_9.taskProxy:getFinishTaskById(var0_9)
		local var2_9 = arg0_9:findTF("item", arg0_9.itemTfs[iter0_9])
		local var3_9 = var1_9:getTaskStatus()
		local var4_9 = arg0_9:findTF("got", arg0_9.itemTfs[iter0_9])
		local var5_9 = arg0_9:findTF("get", arg0_9.itemTfs[iter0_9])
		local var6_9 = var3_9 == 1 and arg0_9.remainCnt > 0
		local var7_9 = var3_9 == 2

		setActive(var5_9, var6_9)
		setActive(var4_9, var7_9)

		local var8_9 = arg0_9.paintingTfs[iter0_9]

		setActive(findTF(var8_9, "got"), var7_9)
		setActive(findTF(var8_9, "mask"), not var7_9 or arg0_9.selectedIndex == iter0_9)
	end
end

function var0_0.OnLoadLayers(arg0_10)
	return
end

function var0_0.OnRemoveLayers(arg0_11)
	return
end

function var0_0.OnShowFlush(arg0_12)
	return
end

function var0_0.OnDestroy(arg0_13)
	return
end

return var0_0
