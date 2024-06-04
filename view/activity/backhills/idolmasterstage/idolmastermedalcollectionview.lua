local var0 = class("IdolMasterMedalCollectionView", import("view.base.BaseUI"))

var0.FADE_OUT_TIME = 1
var0.PAGE_NUM = 7
var0.MEDAL_NUM_PER_PAGE = 2
var0.MEDAL_STATUS_UNACTIVATED = 1
var0.MEDAL_STATUS_ACTIVATED = 2
var0.MEDAL_STATUS_ACTIVATABLE = 3
var0.INDEX_CONVERT = {
	1,
	2,
	5,
	6,
	7,
	4,
	3
}

function var0.getUIName(arg0)
	return "IdolMasterMedalCollectionUI"
end

function var0.init(arg0)
	arg0:initData()
	arg0:findUI()
	arg0:addListener()
end

function var0.didEnter(arg0)
	arg0:checkAward()
	setText(arg0.progressText, setColorStr(tostring(#arg0.activeIDList), "#8CD5FFFF") .. "/" .. #arg0.allIDList)
	triggerToggle(arg0.switchBtnList[1], true)
end

function var0.willExit(arg0)
	if LeanTween.isTweening(go(arg0.photo)) then
		LeanTween.cancel(go(arg0.photo), false)
	end
end

function var0.initData(arg0)
	arg0.activityProxy = getProxy(ActivityProxy)
	arg0.activityData = arg0.activityProxy:getActivityById(ActivityConst.IDOL_MASTER_MEDAL_ID)
	arg0.allIDList = arg0.activityData:GetPicturePuzzleIds()
	arg0.pageIDList = {}

	for iter0 = 1, var0.PAGE_NUM do
		local var0 = var0.INDEX_CONVERT[iter0]

		arg0.pageIDList[iter0] = {}

		for iter1 = 1, var0.MEDAL_NUM_PER_PAGE do
			arg0.pageIDList[iter0][iter1] = arg0.allIDList[(var0 - 1) * var0.MEDAL_NUM_PER_PAGE + iter1]
		end
	end

	arg0.activatableIDList = arg0.activityData.data1_list
	arg0.activeIDList = arg0.activityData.data2_list
	arg0.curPage = nil
	arg0.newMedalID = nil
end

function var0.findUI(arg0)
	arg0.bg = arg0:findTF("BG")

	local var0 = arg0:findTF("NotchAdapt")

	arg0.backBtn = arg0:findTF("BackBtn", var0)
	arg0.progressText = arg0:findTF("ProgressImg/ProgressText", var0)
	arg0.helpBtn = arg0:findTF("HelpBtn", var0)

	local var1 = arg0:findTF("SwitchBtnList", arg0._tf)

	arg0.tplButtom = findTF(var1, "tplButtom")
	arg0.imgGot = arg0:findTF("ProgressImg/got", var0)
	arg0.switchBtnList = {}

	for iter0 = 1, var0.PAGE_NUM do
		local var2 = tf(instantiate(go(arg0.tplButtom)))

		LoadSpriteAtlasAsync("ui/idolmastermedalcollectionui_atlas", "icon" .. iter0, function(arg0)
			if var2 then
				setImageSprite(findTF(var2, "icon"), arg0, true)
			end
		end)
		LoadSpriteAtlasAsync("ui/idolmastermedalcollectionui_atlas", "iconSelect" .. iter0, function(arg0)
			if var2 then
				setImageSprite(findTF(var2, "iconSelect"), arg0, true)
			end
		end)
		setParent(var2, var1)
		setActive(var2, true)
		table.insert(arg0.switchBtnList, var2)
	end

	arg0.infoNode = arg0:findTF("book/info")
	arg0.photoNode = arg0:findTF("book/photo")
	arg0.photo = arg0:findTF("got", arg0.photoNode)
end

function var0.addListener(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.idolmaster_collection.tip
		})
	end, SFX_PANEL)

	for iter0, iter1 in ipairs(arg0.switchBtnList) do
		onToggle(arg0, iter1, function(arg0)
			if arg0 == true then
				local var0 = arg0.curPage ~= iter0

				arg0.curPage = iter0

				arg0:updateSwitchBtnTF()
				arg0:updateMedalContainerView(iter0, var0)
			end
		end, SFX_PANEL)
	end
end

function var0.UpdateActivity(arg0, arg1)
	arg0:checkAward()
end

function var0.updateMedalContainerView(arg0, arg1, arg2)
	local var0 = arg0.pageIDList[arg1]

	arg0:updatePhotoNode(var0[1], arg2)
	arg0:updateInfoNode(var0[2])
end

function var0.getMedalStatus(arg0, arg1)
	local var0 = table.contains(arg0.activeIDList, arg1)
	local var1 = table.contains(arg0.activatableIDList, arg1) and not var0
	local var2 = not var0 and not var1

	if var0 then
		return var0.MEDAL_STATUS_ACTIVATED
	elseif var1 then
		return var0.MEDAL_STATUS_ACTIVATABLE
	elseif var2 then
		return var0.MEDAL_STATUS_UNACTIVATED
	end
end

function var0.updatePhotoNode(arg0, arg1, arg2)
	local var0 = arg0:findTF("task", arg0.photoNode)
	local var1 = arg0:findTF("get", arg0.photoNode)
	local var2 = arg0:findTF("got", arg0.photoNode)
	local var3 = arg0:getMedalStatus(arg1)
	local var4 = (arg0.curPage - 1) * var0.MEDAL_NUM_PER_PAGE + 1

	if var3 == var0.MEDAL_STATUS_UNACTIVATED then
		LoadSpriteAtlasAsync("ui/idolmastermedalcollectionui_atlas", "task" .. var4, function(arg0)
			setImageSprite(var0, arg0, true)
			setActive(var0, true)
		end)
	else
		setActive(var0, false)
	end

	if var3 == var0.MEDAL_STATUS_ACTIVATED then
		if arg2 then
			setActive(arg0.photo, false)
			LoadSpriteAtlasAsync("ui/idolmastermedalcollectionui_atlas", "photo" .. arg0.curPage, function(arg0)
				setImageSprite(arg0.photo, arg0, true)

				if LeanTween.isTweening(go(arg0.photo)) then
					LeanTween.cancel(go(arg0.photo), false)
				end

				GetComponent(arg0.photo, typeof(CanvasGroup)).alpha = 0

				LeanTween.value(go(arg0.photo), 0, 1, 0.3):setOnUpdate(System.Action_float(function(arg0)
					GetComponent(arg0.photo, typeof(CanvasGroup)).alpha = arg0
				end))
				setActive(arg0.photo, true)
			end)
		else
			LoadSpriteAtlasAsync("ui/idolmastermedalcollectionui_atlas", "photo" .. arg0.curPage, function(arg0)
				setImageSprite(arg0.photo, arg0, true)
				setActive(arg0.photo, true)
			end)
		end
	else
		setActive(arg0.photo, false)
	end

	setActive(var1, var3 == var0.MEDAL_STATUS_ACTIVATABLE)

	if var3 == var0.MEDAL_STATUS_ACTIVATABLE then
		onButton(arg0, arg0.photoNode, function()
			pg.m02:sendNotification(GAME.MEMORYBOOK_UNLOCK, {
				id = arg1,
				actId = arg0.activityData.id
			})
		end, SFX_PANEL)
	end
end

function var0.updateInfoNode(arg0, arg1)
	local var0 = arg0:findTF("task", arg0.infoNode)
	local var1 = arg0:findTF("get", arg0.infoNode)
	local var2 = arg0:findTF("got", arg0.infoNode)
	local var3 = arg0:getMedalStatus(arg1)
	local var4 = (arg0.curPage - 1) * var0.MEDAL_NUM_PER_PAGE + 2

	if var3 == var0.MEDAL_STATUS_UNACTIVATED then
		LoadSpriteAtlasAsync("ui/idolmastermedalcollectionui_atlas", "task" .. var4, function(arg0)
			setImageSprite(var0, arg0, true)
			setActive(var0, true)
		end)
	else
		setActive(var0, false)
	end

	if var3 == var0.MEDAL_STATUS_ACTIVATED then
		LoadSpriteAtlasAsync("ui/idolmastermedalcollectionui_atlas", "info" .. arg0.curPage, function(arg0)
			setImageSprite(var2, arg0, true)
			setActive(var2, true)
		end)
	else
		setActive(var2, false)
	end

	setActive(var1, var3 == var0.MEDAL_STATUS_ACTIVATABLE)

	if var3 == var0.MEDAL_STATUS_ACTIVATABLE then
		onButton(arg0, arg0.infoNode, function()
			pg.m02:sendNotification(GAME.MEMORYBOOK_UNLOCK, {
				id = arg1,
				actId = arg0.activityData.id
			})
		end, SFX_PANEL)
	end
end

function var0.updateSwitchBtnTF(arg0)
	for iter0, iter1 in ipairs(arg0.switchBtnList) do
		local var0 = arg0:findTF("tip", iter1)
		local var1 = arg0:caculateActivatable(iter0)

		if var1 == 0 or iter0 == arg0.curPage then
			setActive(var0, false)
		end

		if var1 > 0 and iter0 ~= arg0.curPage then
			setActive(var0, true)
		end

		local var2 = iter0 == arg0.curPage

		setActive(arg0:findTF("icon", iter1), not var2)
		setActive(arg0:findTF("iconSelect", iter1), var2)
	end
end

function var0.updateAfterSubmit(arg0, arg1)
	arg0.activityProxy = getProxy(ActivityProxy)
	arg0.activityData = arg0.activityProxy:getActivityById(ActivityConst.IDOL_MASTER_MEDAL_ID)
	arg0.activatableIDList = arg0.activityData.data1_list
	arg0.activeIDList = arg0.activityData.data2_list
	arg0.newMedalID = arg1

	triggerToggle(arg0.switchBtnList[arg0.curPage], true)
	setText(arg0.progressText, setColorStr(tostring(#arg0.activeIDList), COLOR_WHITE) .. "/" .. #arg0.allIDList)
	arg0:checkAward()
end

function var0.caculateActivatable(arg0, arg1)
	local var0 = arg0.pageIDList[arg1]
	local var1 = 0

	for iter0, iter1 in ipairs(var0) do
		local var2 = table.contains(arg0.activeIDList, iter1)
		local var3 = table.contains(arg0.activatableIDList, iter1)

		if not var2 and var3 then
			var1 = var1 + 1
		end
	end

	return var1
end

function var0.checkAward(arg0)
	setActive(arg0.imgGot, #arg0.activeIDList == #arg0.allIDList and arg0.activityData.data1 == 1)

	if #arg0.activeIDList == #arg0.allIDList and arg0.activityData.data1 ~= 1 then
		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = ActivityConst.IDOL_MASTER_MEDAL_ID
		})
		setActive(arg0.imgGot, true)
	end
end

return var0
