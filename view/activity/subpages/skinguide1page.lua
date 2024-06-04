local var0 = class("SkinGuide1Page", import("...base.BaseActivityPage"))
local var1 = "ui/activityuipage/skinguide1page_atlas"
local var2 = {
	"xiafei",
	"weiyan",
	"kuersike",
	"deliyasite",
	"fuluoxiluofu"
}

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD/mask")
	arg0.countTF = arg0:findTF("rightPanel/count", arg0.bg)
	arg0.itemTpl = arg0:findTF("itemTpl", arg0.bg)

	setActive(arg0.itemTpl, false)

	arg0.items = arg0:findTF("rightPanel/items", arg0.bg)
	arg0.countImg = arg0:findTF("countImg", arg0.bg)
	arg0.paintings = arg0:findTF("paintings", arg0.bg)
	arg0.paintingsSelected = arg0:findTF("paintingsSelected", arg0.bg)
	arg0.descTf = arg0:findTF("rightPanel/desc", arg0.bg)
	arg0.rightPanel = arg0:findTF("rightPanel", arg0.bg)
	arg0.itemTfs = {}
	arg0.selectedIndex = 1
	arg0.paintingTfs = {}
end

function var0.OnDataSetting(arg0)
	arg0.taskProxy = getProxy(TaskProxy)
	arg0.taskList = arg0.activity:getConfig("config_data")
	arg0.totalCnt = #arg0.taskList
end

function var0.OnFirstFlush(arg0)
	arg0.usedCnt = arg0.activity:getData1()
	arg0.unlockCnt = pg.TimeMgr.GetInstance():DiffDay(arg0.activity:getStartTime(), pg.TimeMgr.GetInstance():GetServerTime()) + 1
	arg0.unlockCnt = arg0.unlockCnt * tonumber(arg0.activity:getConfig("config_id"))
	arg0.unlockCnt = arg0.unlockCnt > arg0.totalCnt and arg0.totalCnt or arg0.unlockCnt
	arg0.remainCnt = arg0.usedCnt >= arg0.totalCnt and 0 or arg0.unlockCnt - arg0.usedCnt

	local var0 = 1

	for iter0 = 1, #arg0.taskList do
		local var1 = iter0
		local var2 = tf(instantiate(arg0.itemTpl))

		setParent(var2, arg0.items)

		var2.anchoredPosition = Vector2(0, 0)

		setActive(var2, false)

		local var3 = arg0.taskList[iter0]
		local var4 = arg0.taskProxy:getTaskById(var3) or arg0.taskProxy:getFinishTaskById(var3)
		local var5 = var4:getConfig("award_display")[1]
		local var6 = {
			type = var5[1],
			id = var5[2],
			count = var5[3]
		}

		updateDrop(findTF(var2, "item"), var6)
		onButton(arg0, var2, function()
			arg0:emit(BaseUI.ON_DROP, var6)
		end, SFX_PANEL)
		table.insert(arg0.itemTfs, var2)

		local var7 = arg0:findTF("get", var2)

		onButton(arg0, var7, function()
			arg0:emit(ActivityMediator.ON_TASK_SUBMIT, var4)
		end, SFX_PANEL)

		local var8 = findTF(arg0.paintings, var2[iter0])

		table.insert(arg0.paintingTfs, var8)

		GetComponent(findTF(var8, "normal"), typeof(Image)).alphaHitTestMinimumThreshold = 0.5

		onButton(arg0, findTF(var8, "normal"), function()
			arg0:selectedChange(var1)
		end, SFX_PANEL)

		if var4:getTaskStatus() == 1 and arg0.remainCnt > 0 then
			var0 = iter0
		end
	end

	arg0:updateUI()
	arg0:selectedChange(var0)
end

function var0.selectedChange(arg0, arg1)
	for iter0 = 1, #arg0.itemTfs do
		setActive(arg0.itemTfs[iter0], iter0 == arg1)

		local var0 = arg0.paintingTfs[iter0]

		setActive(findTF(var0, "name"), iter0 == arg1)
		setActive(findTF(var0, "selected"), iter0 == arg1)
		setActive(findTF(var0, "normal"), iter0 ~= arg1)

		local var1 = arg0.taskList[iter0]
		local var2 = (arg0.taskProxy:getTaskById(var1) or arg0.taskProxy:getFinishTaskById(var1)):getTaskStatus() == 2

		setActive(findTF(var0, "mask"), not var2 or arg1 == iter0)

		if iter0 == arg1 then
			setParent(var0, arg0.paintingsSelected)
			var0:SetAsLastSibling()
		else
			setParent(var0, arg0.paintings)
		end
	end

	if arg0.selectedIndex ~= arg1 then
		setActive(arg0.rightPanel, false)
		setActive(arg0.rightPanel, true)
	end

	arg0.selectedIndex = arg1
end

function var0.OnUpdateFlush(arg0)
	local var0 = 0

	for iter0, iter1 in ipairs(arg0.taskList) do
		if arg0.taskProxy:getFinishTaskById(iter1) ~= nil then
			var0 = var0 + 1
		end
	end

	if arg0.usedCnt ~= var0 then
		arg0.usedCnt = var0

		local var1 = arg0.activity

		var1.data1 = arg0.usedCnt

		getProxy(ActivityProxy):updateActivity(var1)
	end

	arg0.unlockCnt = pg.TimeMgr.GetInstance():DiffDay(arg0.activity:getStartTime(), pg.TimeMgr.GetInstance():GetServerTime()) + 1
	arg0.unlockCnt = arg0.unlockCnt * tonumber(arg0.activity:getConfig("config_id"))
	arg0.unlockCnt = arg0.unlockCnt > arg0.totalCnt and arg0.totalCnt or arg0.unlockCnt
	arg0.remainCnt = arg0.usedCnt >= arg0.totalCnt and 0 or arg0.unlockCnt - arg0.usedCnt

	setText(arg0.countTF, tostring(arg0.remainCnt))

	local var2 = arg0.activity:getConfig("config_client").story

	for iter2, iter3 in ipairs(arg0.taskList) do
		if arg0.taskProxy:getFinishTaskById(iter3) and checkExist(var2, {
			iter2
		}, {
			1
		}) then
			pg.NewStoryMgr.GetInstance():Play(var2[iter2][1])
		end
	end

	arg0:updateUI()
end

function var0.updateUI(arg0)
	for iter0 = 1, #arg0.itemTfs do
		local var0 = arg0.taskList[iter0]
		local var1 = arg0.taskProxy:getTaskById(var0) or arg0.taskProxy:getFinishTaskById(var0)
		local var2 = arg0:findTF("item", arg0.itemTfs[iter0])
		local var3 = var1:getTaskStatus()
		local var4 = arg0:findTF("got", arg0.itemTfs[iter0])
		local var5 = arg0:findTF("get", arg0.itemTfs[iter0])
		local var6 = var3 == 1 and arg0.remainCnt > 0
		local var7 = var3 == 2

		setActive(var5, var6)
		setActive(var4, var7)

		local var8 = arg0.paintingTfs[iter0]

		setActive(findTF(var8, "got"), var7)
		setActive(findTF(var8, "mask"), not var7 or arg0.selectedIndex == iter0)
	end
end

function var0.OnLoadLayers(arg0)
	return
end

function var0.OnRemoveLayers(arg0)
	return
end

function var0.OnShowFlush(arg0)
	return
end

function var0.OnDestroy(arg0)
	return
end

return var0
