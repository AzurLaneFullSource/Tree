local var0 = class("SkinGuide5Page", import("...base.BaseActivityPage"))
local var1 = {
	"guandao",
	"lafei2",
	"kelifulan",
	"xingzuo"
}
local var2
local var3 = "ui/activityuipage/skinguide5page_atlas"

function var0.OnInit(arg0)
	arg0.ad = arg0:findTF("AD")

	if PLATFORM_CODE == PLATFORM_JP then
		var2 = {
			Vector2(-488, 52),
			Vector2(-420, -41),
			Vector2(102, -82),
			Vector2(-471, -128)
		}
	elseif PLATFORM_CODE == PLATFORM_US then
		var2 = {
			Vector2(-480, 189),
			Vector2(-445, -101),
			Vector2(-410, -101),
			Vector2(-354, -108)
		}
	else
		var2 = {
			Vector2(-490, 130),
			Vector2(-400, -128),
			Vector2(89, 10),
			Vector2(-478, 57)
		}
	end

	arg0.paint = findTF(arg0.ad, "paint")
	arg0.paintGot = findTF(arg0.paint, "show/got")
	arg0.paintAnim = GetComponent(arg0.paint, typeof(Animator))
	arg0.itemContent = findTF(arg0.ad, "items/content")
	arg0.itemTpl = findTF(arg0.ad, "items/content/itemTpl")

	setActive(arg0.itemTpl, false)

	arg0.iconContent = findTF(arg0.ad, "iconContent")
	arg0.iconTpl = findTF(arg0.ad, "iconContent/IconTpl")

	setActive(arg0.iconTpl, false)

	arg0.desc = findTF(arg0.ad, "desc")
	arg0.got = findTF(arg0.ad, "got")
	arg0.get = findTF(arg0.ad, "get")
	arg0.getBound = findTF(arg0.ad, "get_bound")
	arg0.times = findTF(arg0.ad, "times")

	onButton(arg0, arg0.get, function()
		if arg0.selectIndex then
			local var0 = getProxy(TaskProxy):getTaskById(arg0.skinDatas[arg0.selectIndex].task)

			arg0:emit(ActivityMediator.ON_TASK_SUBMIT, var0)
		end
	end, sound, guideData)
end

function var0.OnDataSetting(arg0)
	arg0.taskProxy = getProxy(TaskProxy)
	arg0.taskList = arg0.activity:getConfig("config_data")
	arg0.totalCnt = #arg0.taskList

	if not arg0.skinDatas then
		arg0.skinDatas = {}

		for iter0 = 1, #arg0.taskList do
			local var0 = arg0.taskList[iter0]
			local var1 = var1[iter0]
			local var2 = tf(instantiate(arg0.itemTpl))

			setParent(var2, arg0.itemContent)
			setActive(var2, true)
			onButton(arg0, var2, function()
				arg0:selectItem(iter0)
			end, SFX_CONFIRM)

			GetComponent(var2, typeof(Image)).sprite = GetSpriteFromAtlas(var3, "item_" .. var1)

			local var3 = tf(Instantiate(arg0.iconTpl))

			setParent(var3, arg0.iconContent)
			setActive(var3, true)

			local var4 = (arg0.taskProxy:getTaskById(var0) or arg0.taskProxy:getFinishTaskById(var0)):getConfig("award_display")[1]
			local var5 = {
				type = var4[1],
				id = var4[2],
				count = var4[3]
			}

			updateDrop(var3, var5)
			onButton(arg0, var3, function()
				arg0:emit(BaseUI.ON_DROP, var5)
			end, SFX_PANEL)
			table.insert(arg0.skinDatas, {
				task = var0,
				name = var1,
				item = var2,
				icon = var3
			})
		end
	end
end

function var0.selectItem(arg0, arg1)
	for iter0 = 1, #arg0.skinDatas do
		local var0 = arg0.skinDatas[iter0].item

		if LeanTween.isTweening(go(var0)) then
			return
		end
	end

	local var1 = 0

	for iter1 = arg1 + 1, #arg0.skinDatas do
		arg0.skinDatas[iter1].item:SetAsFirstSibling()
		setActive(arg0.skinDatas[iter1].item, iter1 ~= arg1)
		setActive(arg0.skinDatas[iter1].icon, iter1 == arg1)

		arg0.skinDatas[iter1].targetPos = Vector2(var1 * 215, 0)
		var1 = var1 + 1
	end

	for iter2 = 1, arg1 do
		arg0.skinDatas[iter2].item:SetAsFirstSibling()
		setActive(arg0.skinDatas[iter2].item, iter2 ~= arg1)
		setActive(arg0.skinDatas[iter2].icon, iter2 == arg1)

		arg0.skinDatas[iter2].targetPos = Vector2(var1 * 215, 0)
		var1 = var1 + 1
	end

	local var2 = arg0.skinDatas[arg1].task
	local var3 = arg0.skinDatas[arg1].task
	local var4 = arg0.taskProxy:getFinishTaskById(var3)

	setActive(arg0.get, not var4 and arg0.remainCnt > 0)
	setActive(arg0.getBound, not var4 and arg0.remainCnt > 0)
	setActive(arg0.got, var4)

	arg0.paintGot.anchoredPosition = var2[arg1]

	setActive(arg0.paintGot, var4)

	local var5 = GetComponent(findTF(arg0.paint, "show"), typeof(Image))

	var5.sprite = GetSpriteFromAtlas(var3, "bg_" .. arg0.skinDatas[arg1].name)

	var5:SetNativeSize()

	local var6 = GetComponent(findTF(arg0.paint, "temp"), typeof(Image))

	if arg0.selectIndex then
		var6.sprite = GetSpriteFromAtlas(var3, "bg_" .. arg0.skinDatas[arg0.selectIndex].name)
	else
		var6.sprite = GetSpriteFromAtlas(var3, "bg_" .. arg0.skinDatas[arg1].name)
	end

	var6:SetNativeSize()

	if arg0.selectIndex and arg0.selectIndex ~= arg1 then
		local var7
		local var8 = (arg0.selectIndex ~= 1 or arg1 ~= #arg0.skinDatas or false) and (arg0.selectIndex == #arg0.skinDatas and arg1 == 1 and true or arg1 > arg0.selectIndex and true or false)

		arg0.paintAnim:SetTrigger(var8 and "next" or "pre")
		arg0:updateItemPos(true, var8)
	else
		arg0:updateItemPos(false)
	end

	arg0.selectIndex = arg1
end

function var0.OnFirstFlush(arg0)
	arg0.usedCnt = arg0.activity:getData1()
	arg0.unlockCnt = pg.TimeMgr.GetInstance():DiffDay(arg0.activity:getStartTime(), pg.TimeMgr.GetInstance():GetServerTime()) + 1
	arg0.unlockCnt = arg0.unlockCnt > arg0.totalCnt and arg0.totalCnt or arg0.unlockCnt
	arg0.remainCnt = arg0.usedCnt >= arg0.totalCnt and 0 or arg0.unlockCnt - arg0.usedCnt

	setText(arg0.desc, i18n("skin_page_desc", arg0.activity:getConfig("config_id")))
	setText(findTF(arg0.get, "desc"), i18n("skin_page_sign"))

	local var0 = 1

	for iter0 = 1, #arg0.skinDatas do
		local var1 = arg0.skinDatas[iter0].task

		if not (arg0.taskProxy:getFinishTaskById(var1) or false) then
			var0 = var0 or iter0
		end
	end

	arg0:selectItem(var0)
	arg0:updateItemData()
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

	arg0.unlockCnt = (pg.TimeMgr.GetInstance():DiffDay(arg0.activity:getStartTime(), pg.TimeMgr.GetInstance():GetServerTime()) + 1) * arg0.activity:getConfig("config_id")
	arg0.unlockCnt = arg0.unlockCnt > arg0.totalCnt and arg0.totalCnt or arg0.unlockCnt
	arg0.remainCnt = arg0.usedCnt >= arg0.totalCnt and 0 or arg0.unlockCnt - arg0.usedCnt

	setText(findTF(arg0.times, "desc"), i18n("last_times_sign", arg0.remainCnt))

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

	arg0:selectItem(arg0.selectIndex)
	arg0:updateItemData()
end

local var4 = 215

function var0.updateItemPos(arg0, arg1, arg2)
	local var0 = Vector2(-var4, 0)
	local var1 = Vector2((#arg0.skinDatas - 1) * var4, 0)

	for iter0 = 1, #arg0.skinDatas do
		local var2 = arg0.skinDatas[iter0].item

		if LeanTween.isTweening(go(var2)) then
			LeanTween.cancel(go(var2))
		end

		local var3 = arg0.skinDatas[iter0].targetPos

		if arg1 then
			local var4 = var2.anchoredPosition
			local var5 = {}

			if not arg2 and var4.x > var3.x then
				table.insert(var5, var1)
				table.insert(var5, var0)
			elseif arg2 and var4.x < var3.x then
				table.insert(var5, var0)
				table.insert(var5, var1)
			end

			table.insert(var5, var3)
			table.insert(var5, var3)
			arg0:tweenItem(var2, var5)
		else
			var2.anchoredPosition = var3
		end
	end
end

function var0.tweenItem(arg0, arg1, arg2)
	if #arg2 >= 2 then
		local var0 = arg1.anchoredPosition
		local var1 = table.remove(arg2, 1)
		local var2 = table.remove(arg2, 1)
		local var3 = math.abs(var1.x - var0.x) / var4 * 0.25

		LeanTween.value(go(arg1), var0.x, var1.x, var3):setOnUpdate(System.Action_float(function(arg0)
			var0.x = arg0
			arg1.anchoredPosition = var0
		end)):setOnComplete(System.Action(function()
			arg1.anchoredPosition = var2

			arg0:tweenItem(arg1, arg2)
		end))
	end
end

function var0.updateItemData(arg0)
	for iter0 = 1, #arg0.skinDatas do
		local var0 = arg0.skinDatas[iter0].item
		local var1 = arg0.skinDatas[iter0].task
		local var2 = arg0.taskProxy:getFinishTaskById(var1) or false

		setActive(findTF(var0, "got"), var2)
	end
end

function var0.OnDestroy(arg0)
	for iter0 = 1, #arg0.skinDatas do
		local var0 = arg0.skinDatas[iter0].item

		if LeanTween.isTweening(go(var0)) then
			LeanTween.cancel(go(var0), false)
		end
	end
end

return var0
