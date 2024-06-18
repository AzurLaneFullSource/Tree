local var0_0 = class("IdolMasterMedalCollectionView", import("view.base.BaseUI"))

var0_0.FADE_OUT_TIME = 1
var0_0.PAGE_NUM = 7
var0_0.MEDAL_NUM_PER_PAGE = 2
var0_0.MEDAL_STATUS_UNACTIVATED = 1
var0_0.MEDAL_STATUS_ACTIVATED = 2
var0_0.MEDAL_STATUS_ACTIVATABLE = 3
var0_0.INDEX_CONVERT = {
	1,
	2,
	5,
	6,
	7,
	4,
	3
}

function var0_0.getUIName(arg0_1)
	return "IdolMasterMedalCollectionUI"
end

function var0_0.init(arg0_2)
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:addListener()
end

function var0_0.didEnter(arg0_3)
	arg0_3:checkAward()
	setText(arg0_3.progressText, setColorStr(tostring(#arg0_3.activeIDList), "#8CD5FFFF") .. "/" .. #arg0_3.allIDList)
	triggerToggle(arg0_3.switchBtnList[1], true)
end

function var0_0.willExit(arg0_4)
	if LeanTween.isTweening(go(arg0_4.photo)) then
		LeanTween.cancel(go(arg0_4.photo), false)
	end
end

function var0_0.initData(arg0_5)
	arg0_5.activityProxy = getProxy(ActivityProxy)
	arg0_5.activityData = arg0_5.activityProxy:getActivityById(ActivityConst.IDOL_MASTER_MEDAL_ID)
	arg0_5.allIDList = arg0_5.activityData:GetPicturePuzzleIds()
	arg0_5.pageIDList = {}

	for iter0_5 = 1, var0_0.PAGE_NUM do
		local var0_5 = var0_0.INDEX_CONVERT[iter0_5]

		arg0_5.pageIDList[iter0_5] = {}

		for iter1_5 = 1, var0_0.MEDAL_NUM_PER_PAGE do
			arg0_5.pageIDList[iter0_5][iter1_5] = arg0_5.allIDList[(var0_5 - 1) * var0_0.MEDAL_NUM_PER_PAGE + iter1_5]
		end
	end

	arg0_5.activatableIDList = arg0_5.activityData.data1_list
	arg0_5.activeIDList = arg0_5.activityData.data2_list
	arg0_5.curPage = nil
	arg0_5.newMedalID = nil
end

function var0_0.findUI(arg0_6)
	arg0_6.bg = arg0_6:findTF("BG")

	local var0_6 = arg0_6:findTF("NotchAdapt")

	arg0_6.backBtn = arg0_6:findTF("BackBtn", var0_6)
	arg0_6.progressText = arg0_6:findTF("ProgressImg/ProgressText", var0_6)
	arg0_6.helpBtn = arg0_6:findTF("HelpBtn", var0_6)

	local var1_6 = arg0_6:findTF("SwitchBtnList", arg0_6._tf)

	arg0_6.tplButtom = findTF(var1_6, "tplButtom")
	arg0_6.imgGot = arg0_6:findTF("ProgressImg/got", var0_6)
	arg0_6.switchBtnList = {}

	for iter0_6 = 1, var0_0.PAGE_NUM do
		local var2_6 = tf(instantiate(go(arg0_6.tplButtom)))

		LoadSpriteAtlasAsync("ui/idolmastermedalcollectionui_atlas", "icon" .. iter0_6, function(arg0_7)
			if var2_6 then
				setImageSprite(findTF(var2_6, "icon"), arg0_7, true)
			end
		end)
		LoadSpriteAtlasAsync("ui/idolmastermedalcollectionui_atlas", "iconSelect" .. iter0_6, function(arg0_8)
			if var2_6 then
				setImageSprite(findTF(var2_6, "iconSelect"), arg0_8, true)
			end
		end)
		setParent(var2_6, var1_6)
		setActive(var2_6, true)
		table.insert(arg0_6.switchBtnList, var2_6)
	end

	arg0_6.infoNode = arg0_6:findTF("book/info")
	arg0_6.photoNode = arg0_6:findTF("book/photo")
	arg0_6.photo = arg0_6:findTF("got", arg0_6.photoNode)
end

function var0_0.addListener(arg0_9)
	onButton(arg0_9, arg0_9.backBtn, function()
		arg0_9:closeView()
	end, SFX_CANCEL)
	onButton(arg0_9, arg0_9.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.idolmaster_collection.tip
		})
	end, SFX_PANEL)

	for iter0_9, iter1_9 in ipairs(arg0_9.switchBtnList) do
		onToggle(arg0_9, iter1_9, function(arg0_12)
			if arg0_12 == true then
				local var0_12 = arg0_9.curPage ~= iter0_9

				arg0_9.curPage = iter0_9

				arg0_9:updateSwitchBtnTF()
				arg0_9:updateMedalContainerView(iter0_9, var0_12)
			end
		end, SFX_PANEL)
	end
end

function var0_0.UpdateActivity(arg0_13, arg1_13)
	arg0_13:checkAward()
end

function var0_0.updateMedalContainerView(arg0_14, arg1_14, arg2_14)
	local var0_14 = arg0_14.pageIDList[arg1_14]

	arg0_14:updatePhotoNode(var0_14[1], arg2_14)
	arg0_14:updateInfoNode(var0_14[2])
end

function var0_0.getMedalStatus(arg0_15, arg1_15)
	local var0_15 = table.contains(arg0_15.activeIDList, arg1_15)
	local var1_15 = table.contains(arg0_15.activatableIDList, arg1_15) and not var0_15
	local var2_15 = not var0_15 and not var1_15

	if var0_15 then
		return var0_0.MEDAL_STATUS_ACTIVATED
	elseif var1_15 then
		return var0_0.MEDAL_STATUS_ACTIVATABLE
	elseif var2_15 then
		return var0_0.MEDAL_STATUS_UNACTIVATED
	end
end

function var0_0.updatePhotoNode(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg0_16:findTF("task", arg0_16.photoNode)
	local var1_16 = arg0_16:findTF("get", arg0_16.photoNode)
	local var2_16 = arg0_16:findTF("got", arg0_16.photoNode)
	local var3_16 = arg0_16:getMedalStatus(arg1_16)
	local var4_16 = (arg0_16.curPage - 1) * var0_0.MEDAL_NUM_PER_PAGE + 1

	if var3_16 == var0_0.MEDAL_STATUS_UNACTIVATED then
		LoadSpriteAtlasAsync("ui/idolmastermedalcollectionui_atlas", "task" .. var4_16, function(arg0_17)
			setImageSprite(var0_16, arg0_17, true)
			setActive(var0_16, true)
		end)
	else
		setActive(var0_16, false)
	end

	if var3_16 == var0_0.MEDAL_STATUS_ACTIVATED then
		if arg2_16 then
			setActive(arg0_16.photo, false)
			LoadSpriteAtlasAsync("ui/idolmastermedalcollectionui_atlas", "photo" .. arg0_16.curPage, function(arg0_18)
				setImageSprite(arg0_16.photo, arg0_18, true)

				if LeanTween.isTweening(go(arg0_16.photo)) then
					LeanTween.cancel(go(arg0_16.photo), false)
				end

				GetComponent(arg0_16.photo, typeof(CanvasGroup)).alpha = 0

				LeanTween.value(go(arg0_16.photo), 0, 1, 0.3):setOnUpdate(System.Action_float(function(arg0_19)
					GetComponent(arg0_16.photo, typeof(CanvasGroup)).alpha = arg0_19
				end))
				setActive(arg0_16.photo, true)
			end)
		else
			LoadSpriteAtlasAsync("ui/idolmastermedalcollectionui_atlas", "photo" .. arg0_16.curPage, function(arg0_20)
				setImageSprite(arg0_16.photo, arg0_20, true)
				setActive(arg0_16.photo, true)
			end)
		end
	else
		setActive(arg0_16.photo, false)
	end

	setActive(var1_16, var3_16 == var0_0.MEDAL_STATUS_ACTIVATABLE)

	if var3_16 == var0_0.MEDAL_STATUS_ACTIVATABLE then
		onButton(arg0_16, arg0_16.photoNode, function()
			pg.m02:sendNotification(GAME.MEMORYBOOK_UNLOCK, {
				id = arg1_16,
				actId = arg0_16.activityData.id
			})
		end, SFX_PANEL)
	end
end

function var0_0.updateInfoNode(arg0_22, arg1_22)
	local var0_22 = arg0_22:findTF("task", arg0_22.infoNode)
	local var1_22 = arg0_22:findTF("get", arg0_22.infoNode)
	local var2_22 = arg0_22:findTF("got", arg0_22.infoNode)
	local var3_22 = arg0_22:getMedalStatus(arg1_22)
	local var4_22 = (arg0_22.curPage - 1) * var0_0.MEDAL_NUM_PER_PAGE + 2

	if var3_22 == var0_0.MEDAL_STATUS_UNACTIVATED then
		LoadSpriteAtlasAsync("ui/idolmastermedalcollectionui_atlas", "task" .. var4_22, function(arg0_23)
			setImageSprite(var0_22, arg0_23, true)
			setActive(var0_22, true)
		end)
	else
		setActive(var0_22, false)
	end

	if var3_22 == var0_0.MEDAL_STATUS_ACTIVATED then
		LoadSpriteAtlasAsync("ui/idolmastermedalcollectionui_atlas", "info" .. arg0_22.curPage, function(arg0_24)
			setImageSprite(var2_22, arg0_24, true)
			setActive(var2_22, true)
		end)
	else
		setActive(var2_22, false)
	end

	setActive(var1_22, var3_22 == var0_0.MEDAL_STATUS_ACTIVATABLE)

	if var3_22 == var0_0.MEDAL_STATUS_ACTIVATABLE then
		onButton(arg0_22, arg0_22.infoNode, function()
			pg.m02:sendNotification(GAME.MEMORYBOOK_UNLOCK, {
				id = arg1_22,
				actId = arg0_22.activityData.id
			})
		end, SFX_PANEL)
	end
end

function var0_0.updateSwitchBtnTF(arg0_26)
	for iter0_26, iter1_26 in ipairs(arg0_26.switchBtnList) do
		local var0_26 = arg0_26:findTF("tip", iter1_26)
		local var1_26 = arg0_26:caculateActivatable(iter0_26)

		if var1_26 == 0 or iter0_26 == arg0_26.curPage then
			setActive(var0_26, false)
		end

		if var1_26 > 0 and iter0_26 ~= arg0_26.curPage then
			setActive(var0_26, true)
		end

		local var2_26 = iter0_26 == arg0_26.curPage

		setActive(arg0_26:findTF("icon", iter1_26), not var2_26)
		setActive(arg0_26:findTF("iconSelect", iter1_26), var2_26)
	end
end

function var0_0.updateAfterSubmit(arg0_27, arg1_27)
	arg0_27.activityProxy = getProxy(ActivityProxy)
	arg0_27.activityData = arg0_27.activityProxy:getActivityById(ActivityConst.IDOL_MASTER_MEDAL_ID)
	arg0_27.activatableIDList = arg0_27.activityData.data1_list
	arg0_27.activeIDList = arg0_27.activityData.data2_list
	arg0_27.newMedalID = arg1_27

	triggerToggle(arg0_27.switchBtnList[arg0_27.curPage], true)
	setText(arg0_27.progressText, setColorStr(tostring(#arg0_27.activeIDList), COLOR_WHITE) .. "/" .. #arg0_27.allIDList)
	arg0_27:checkAward()
end

function var0_0.caculateActivatable(arg0_28, arg1_28)
	local var0_28 = arg0_28.pageIDList[arg1_28]
	local var1_28 = 0

	for iter0_28, iter1_28 in ipairs(var0_28) do
		local var2_28 = table.contains(arg0_28.activeIDList, iter1_28)
		local var3_28 = table.contains(arg0_28.activatableIDList, iter1_28)

		if not var2_28 and var3_28 then
			var1_28 = var1_28 + 1
		end
	end

	return var1_28
end

function var0_0.checkAward(arg0_29)
	setActive(arg0_29.imgGot, #arg0_29.activeIDList == #arg0_29.allIDList and arg0_29.activityData.data1 == 1)

	if #arg0_29.activeIDList == #arg0_29.allIDList and arg0_29.activityData.data1 ~= 1 then
		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = ActivityConst.IDOL_MASTER_MEDAL_ID
		})
		setActive(arg0_29.imgGot, true)
	end
end

return var0_0
