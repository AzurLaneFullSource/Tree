local var0_0 = class("SkinGuide5Page", import("...base.BaseActivityPage"))
local var1_0 = {
	"guandao",
	"lafei2",
	"kelifulan",
	"xingzuo"
}
local var2_0
local var3_0 = "ui/activityuipage/skinguide5page_atlas"

function var0_0.OnInit(arg0_1)
	arg0_1.ad = arg0_1:findTF("AD")

	if PLATFORM_CODE == PLATFORM_JP then
		var2_0 = {
			Vector2(-488, 52),
			Vector2(-420, -41),
			Vector2(102, -82),
			Vector2(-471, -128)
		}
	elseif PLATFORM_CODE == PLATFORM_US then
		var2_0 = {
			Vector2(-480, 189),
			Vector2(-445, -101),
			Vector2(-410, -101),
			Vector2(-354, -108)
		}
	else
		var2_0 = {
			Vector2(-490, 130),
			Vector2(-400, -128),
			Vector2(89, 10),
			Vector2(-478, 57)
		}
	end

	arg0_1.paint = findTF(arg0_1.ad, "paint")
	arg0_1.paintGot = findTF(arg0_1.paint, "show/got")
	arg0_1.paintAnim = GetComponent(arg0_1.paint, typeof(Animator))
	arg0_1.itemContent = findTF(arg0_1.ad, "items/content")
	arg0_1.itemTpl = findTF(arg0_1.ad, "items/content/itemTpl")

	setActive(arg0_1.itemTpl, false)

	arg0_1.iconContent = findTF(arg0_1.ad, "iconContent")
	arg0_1.iconTpl = findTF(arg0_1.ad, "iconContent/IconTpl")

	setActive(arg0_1.iconTpl, false)

	arg0_1.desc = findTF(arg0_1.ad, "desc")
	arg0_1.got = findTF(arg0_1.ad, "got")
	arg0_1.get = findTF(arg0_1.ad, "get")
	arg0_1.getBound = findTF(arg0_1.ad, "get_bound")
	arg0_1.times = findTF(arg0_1.ad, "times")

	onButton(arg0_1, arg0_1.get, function()
		if arg0_1.selectIndex then
			local var0_2 = getProxy(TaskProxy):getTaskById(arg0_1.skinDatas[arg0_1.selectIndex].task)

			arg0_1:emit(ActivityMediator.ON_TASK_SUBMIT, var0_2)
		end
	end, sound, guideData)
end

function var0_0.OnDataSetting(arg0_3)
	arg0_3.taskProxy = getProxy(TaskProxy)
	arg0_3.taskList = arg0_3.activity:getConfig("config_data")
	arg0_3.totalCnt = #arg0_3.taskList

	if not arg0_3.skinDatas then
		arg0_3.skinDatas = {}

		for iter0_3 = 1, #arg0_3.taskList do
			local var0_3 = arg0_3.taskList[iter0_3]
			local var1_3 = var1_0[iter0_3]
			local var2_3 = tf(instantiate(arg0_3.itemTpl))

			setParent(var2_3, arg0_3.itemContent)
			setActive(var2_3, true)
			onButton(arg0_3, var2_3, function()
				arg0_3:selectItem(iter0_3)
			end, SFX_CONFIRM)

			GetComponent(var2_3, typeof(Image)).sprite = GetSpriteFromAtlas(var3_0, "item_" .. var1_3)

			local var3_3 = tf(Instantiate(arg0_3.iconTpl))

			setParent(var3_3, arg0_3.iconContent)
			setActive(var3_3, true)

			local var4_3 = (arg0_3.taskProxy:getTaskById(var0_3) or arg0_3.taskProxy:getFinishTaskById(var0_3)):getConfig("award_display")[1]
			local var5_3 = {
				type = var4_3[1],
				id = var4_3[2],
				count = var4_3[3]
			}

			updateDrop(var3_3, var5_3)
			onButton(arg0_3, var3_3, function()
				arg0_3:emit(BaseUI.ON_DROP, var5_3)
			end, SFX_PANEL)
			table.insert(arg0_3.skinDatas, {
				task = var0_3,
				name = var1_3,
				item = var2_3,
				icon = var3_3
			})
		end
	end
end

function var0_0.selectItem(arg0_6, arg1_6)
	for iter0_6 = 1, #arg0_6.skinDatas do
		local var0_6 = arg0_6.skinDatas[iter0_6].item

		if LeanTween.isTweening(go(var0_6)) then
			return
		end
	end

	local var1_6 = 0

	for iter1_6 = arg1_6 + 1, #arg0_6.skinDatas do
		arg0_6.skinDatas[iter1_6].item:SetAsFirstSibling()
		setActive(arg0_6.skinDatas[iter1_6].item, iter1_6 ~= arg1_6)
		setActive(arg0_6.skinDatas[iter1_6].icon, iter1_6 == arg1_6)

		arg0_6.skinDatas[iter1_6].targetPos = Vector2(var1_6 * 215, 0)
		var1_6 = var1_6 + 1
	end

	for iter2_6 = 1, arg1_6 do
		arg0_6.skinDatas[iter2_6].item:SetAsFirstSibling()
		setActive(arg0_6.skinDatas[iter2_6].item, iter2_6 ~= arg1_6)
		setActive(arg0_6.skinDatas[iter2_6].icon, iter2_6 == arg1_6)

		arg0_6.skinDatas[iter2_6].targetPos = Vector2(var1_6 * 215, 0)
		var1_6 = var1_6 + 1
	end

	local var2_6 = arg0_6.skinDatas[arg1_6].task
	local var3_6 = arg0_6.skinDatas[arg1_6].task
	local var4_6 = arg0_6.taskProxy:getFinishTaskById(var3_6)

	setActive(arg0_6.get, not var4_6 and arg0_6.remainCnt > 0)
	setActive(arg0_6.getBound, not var4_6 and arg0_6.remainCnt > 0)
	setActive(arg0_6.got, var4_6)

	arg0_6.paintGot.anchoredPosition = var2_0[arg1_6]

	setActive(arg0_6.paintGot, var4_6)

	local var5_6 = GetComponent(findTF(arg0_6.paint, "show"), typeof(Image))

	var5_6.sprite = GetSpriteFromAtlas(var3_0, "bg_" .. arg0_6.skinDatas[arg1_6].name)

	var5_6:SetNativeSize()

	local var6_6 = GetComponent(findTF(arg0_6.paint, "temp"), typeof(Image))

	if arg0_6.selectIndex then
		var6_6.sprite = GetSpriteFromAtlas(var3_0, "bg_" .. arg0_6.skinDatas[arg0_6.selectIndex].name)
	else
		var6_6.sprite = GetSpriteFromAtlas(var3_0, "bg_" .. arg0_6.skinDatas[arg1_6].name)
	end

	var6_6:SetNativeSize()

	if arg0_6.selectIndex and arg0_6.selectIndex ~= arg1_6 then
		local var7_6
		local var8_6 = (arg0_6.selectIndex ~= 1 or arg1_6 ~= #arg0_6.skinDatas or false) and (arg0_6.selectIndex == #arg0_6.skinDatas and arg1_6 == 1 and true or arg1_6 > arg0_6.selectIndex and true or false)

		arg0_6.paintAnim:SetTrigger(var8_6 and "next" or "pre")
		arg0_6:updateItemPos(true, var8_6)
	else
		arg0_6:updateItemPos(false)
	end

	arg0_6.selectIndex = arg1_6
end

function var0_0.OnFirstFlush(arg0_7)
	arg0_7.usedCnt = arg0_7.activity:getData1()
	arg0_7.unlockCnt = pg.TimeMgr.GetInstance():DiffDay(arg0_7.activity:getStartTime(), pg.TimeMgr.GetInstance():GetServerTime()) + 1
	arg0_7.unlockCnt = arg0_7.unlockCnt > arg0_7.totalCnt and arg0_7.totalCnt or arg0_7.unlockCnt
	arg0_7.remainCnt = arg0_7.usedCnt >= arg0_7.totalCnt and 0 or arg0_7.unlockCnt - arg0_7.usedCnt

	setText(arg0_7.desc, i18n("skin_page_desc", arg0_7.activity:getConfig("config_id")))
	setText(findTF(arg0_7.get, "desc"), i18n("skin_page_sign"))

	local var0_7 = 1

	for iter0_7 = 1, #arg0_7.skinDatas do
		local var1_7 = arg0_7.skinDatas[iter0_7].task

		if not (arg0_7.taskProxy:getFinishTaskById(var1_7) or false) then
			var0_7 = var0_7 or iter0_7
		end
	end

	arg0_7:selectItem(var0_7)
	arg0_7:updateItemData()
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

	arg0_8.unlockCnt = (pg.TimeMgr.GetInstance():DiffDay(arg0_8.activity:getStartTime(), pg.TimeMgr.GetInstance():GetServerTime()) + 1) * arg0_8.activity:getConfig("config_id")
	arg0_8.unlockCnt = arg0_8.unlockCnt > arg0_8.totalCnt and arg0_8.totalCnt or arg0_8.unlockCnt
	arg0_8.remainCnt = arg0_8.usedCnt >= arg0_8.totalCnt and 0 or arg0_8.unlockCnt - arg0_8.usedCnt

	setText(findTF(arg0_8.times, "desc"), i18n("last_times_sign", arg0_8.remainCnt))

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

	arg0_8:selectItem(arg0_8.selectIndex)
	arg0_8:updateItemData()
end

local var4_0 = 215

function var0_0.updateItemPos(arg0_9, arg1_9, arg2_9)
	local var0_9 = Vector2(-var4_0, 0)
	local var1_9 = Vector2((#arg0_9.skinDatas - 1) * var4_0, 0)

	for iter0_9 = 1, #arg0_9.skinDatas do
		local var2_9 = arg0_9.skinDatas[iter0_9].item

		if LeanTween.isTweening(go(var2_9)) then
			LeanTween.cancel(go(var2_9))
		end

		local var3_9 = arg0_9.skinDatas[iter0_9].targetPos

		if arg1_9 then
			local var4_9 = var2_9.anchoredPosition
			local var5_9 = {}

			if not arg2_9 and var4_9.x > var3_9.x then
				table.insert(var5_9, var1_9)
				table.insert(var5_9, var0_9)
			elseif arg2_9 and var4_9.x < var3_9.x then
				table.insert(var5_9, var0_9)
				table.insert(var5_9, var1_9)
			end

			table.insert(var5_9, var3_9)
			table.insert(var5_9, var3_9)
			arg0_9:tweenItem(var2_9, var5_9)
		else
			var2_9.anchoredPosition = var3_9
		end
	end
end

function var0_0.tweenItem(arg0_10, arg1_10, arg2_10)
	if #arg2_10 >= 2 then
		local var0_10 = arg1_10.anchoredPosition
		local var1_10 = table.remove(arg2_10, 1)
		local var2_10 = table.remove(arg2_10, 1)
		local var3_10 = math.abs(var1_10.x - var0_10.x) / var4_0 * 0.25

		LeanTween.value(go(arg1_10), var0_10.x, var1_10.x, var3_10):setOnUpdate(System.Action_float(function(arg0_11)
			var0_10.x = arg0_11
			arg1_10.anchoredPosition = var0_10
		end)):setOnComplete(System.Action(function()
			arg1_10.anchoredPosition = var2_10

			arg0_10:tweenItem(arg1_10, arg2_10)
		end))
	end
end

function var0_0.updateItemData(arg0_13)
	for iter0_13 = 1, #arg0_13.skinDatas do
		local var0_13 = arg0_13.skinDatas[iter0_13].item
		local var1_13 = arg0_13.skinDatas[iter0_13].task
		local var2_13 = arg0_13.taskProxy:getFinishTaskById(var1_13) or false

		setActive(findTF(var0_13, "got"), var2_13)
	end
end

function var0_0.OnDestroy(arg0_14)
	for iter0_14 = 1, #arg0_14.skinDatas do
		local var0_14 = arg0_14.skinDatas[iter0_14].item

		if LeanTween.isTweening(go(var0_14)) then
			LeanTween.cancel(go(var0_14), false)
		end
	end
end

return var0_0
