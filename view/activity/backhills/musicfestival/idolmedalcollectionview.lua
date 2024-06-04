local var0 = class("IdolMedalCollectionView", import("view.base.BaseUI"))

var0.FADE_OUT_TIME = 1
var0.PAGE_NUM = 5
var0.MEDAL_NUM_PER_PAGE = 3

function var0.getUIName(arg0)
	return "IdolMedalCollectionUI"
end

function var0.init(arg0)
	arg0:initData()
	arg0:findUI()
	arg0:addListener()
end

function var0.didEnter(arg0)
	arg0:checkAward()
	setText(arg0.progressText, setColorStr(tostring(#arg0.activeIDList), COLOR_RED) .. "/" .. #arg0.allIDList)
	triggerToggle(arg0.switchBtnList[1], true)
end

function var0.willExit(arg0)
	return
end

function var0.initData(arg0)
	arg0.activityProxy = getProxy(ActivityProxy)
	arg0.activityData = arg0.activityProxy:getActivityById(ActivityConst.IDOL_MEDAL_COLLECTION)
	arg0.allIDList = arg0.activityData:GetPicturePuzzleIds()
	arg0.pageIDList = {}

	for iter0 = 1, var0.PAGE_NUM do
		arg0.pageIDList[iter0] = {}

		for iter1 = 1, var0.MEDAL_NUM_PER_PAGE do
			arg0.pageIDList[iter0][iter1] = arg0.allIDList[(iter0 - 1) * var0.MEDAL_NUM_PER_PAGE + iter1]
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

	local var1 = arg0:findTF("MedalContainer")

	arg0.medalItemList = {}
	arg0.medalItemList[1] = arg0:findTF("Medal1", var1)
	arg0.medalItemList[2] = arg0:findTF("Medal2", var1)
	arg0.medalItemList[3] = arg0:findTF("Medal3", var1)

	local var2 = arg0:findTF("SwitchBtnList", var0)

	arg0.switchBtnList = {}

	for iter0 = 1, 5 do
		arg0.switchBtnList[iter0] = arg0:findTF("Button" .. iter0, var2)
	end
end

function var0.addListener(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.music_collection.tip
		})
	end, SFX_PANEL)

	for iter0, iter1 in ipairs(arg0.switchBtnList) do
		onToggle(arg0, iter1, function(arg0)
			if arg0 == true then
				arg0.curPage = iter0

				arg0:updateSwitchBtnTF()
				arg0:updateMedalContainerView(iter0)
			end
		end, SFX_PANEL)
	end

	addSlip(SLIP_TYPE_HRZ, arg0.bg, function()
		if arg0.curPage > 1 then
			triggerToggle(arg0.switchBtnList[arg0.curPage - 1], true)
		else
			return
		end
	end, function()
		if arg0.curPage < var0.PAGE_NUM then
			triggerToggle(arg0.switchBtnList[arg0.curPage + 1], true)
		else
			return
		end
	end)
end

function var0.updateMedalContainerView(arg0, arg1)
	local var0 = arg0.pageIDList[arg1]

	for iter0, iter1 in ipairs(var0) do
		arg0:updateMedalView(var0, iter1)
	end
end

function var0.updateMedalView(arg0, arg1, arg2)
	local var0 = table.indexof(arg1, arg2, 1)
	local var1 = table.contains(arg0.activeIDList, arg2)
	local var2 = table.contains(arg0.activatableIDList, arg2) and not var1
	local var3 = not var1 and not var2
	local var4 = arg0.medalItemList[var0]
	local var5 = arg0:findTF("Active", var4)
	local var6 = arg0:findTF("Activable", var4)
	local var7 = arg0:findTF("DisActive", var4)

	setActive(var5, var1)
	setActive(var6, var2)
	setActive(var7, var3)

	if var5 then
		setImageSprite(var5, GetSpriteFromAtlas("ui/musicfestivalmedalcollectionui_atlas", tostring(arg2)))
	end

	if var2 then
		onButton(arg0, var6, function()
			pg.m02:sendNotification(GAME.MEMORYBOOK_UNLOCK, {
				id = arg2,
				actId = ActivityConst.IDOL_MEDAL_COLLECTION
			})
		end, SFX_PANEL)
	end

	if var3 then
		local var8 = table.indexof(arg0.allIDList, arg2, 1)
		local var9 = arg0.activityData:getConfig("config_client").unlock_desc[var8]

		setText(var7, var9)
	end
end

function var0.updateSwitchBtnTF(arg0)
	for iter0, iter1 in ipairs(arg0.switchBtnList) do
		local var0 = arg0:findTF("Tip", iter1)
		local var1 = arg0:findTF("Text", var0)
		local var2 = arg0:caculateActivatable(iter0)

		if var2 == 0 or iter0 == arg0.curPage then
			setActive(var0, false)
		end

		if var2 > 0 and iter0 ~= arg0.curPage then
			setActive(var0, true)
			setText(var1, var2)
		end
	end
end

function var0.updateAfterSubmit(arg0, arg1)
	arg0.activityProxy = getProxy(ActivityProxy)
	arg0.activityData = arg0.activityProxy:getActivityById(ActivityConst.IDOL_MEDAL_COLLECTION)
	arg0.activatableIDList = arg0.activityData.data1_list
	arg0.activeIDList = arg0.activityData.data2_list
	arg0.newMedalID = arg1

	triggerToggle(arg0.switchBtnList[arg0.curPage], true)
	setText(arg0.progressText, setColorStr(tostring(#arg0.activeIDList), COLOR_RED) .. "/" .. #arg0.allIDList)
	arg0:checkAward()
end

function var0.UpdateActivity(arg0)
	return
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
	if #arg0.activeIDList == #arg0.allIDList and arg0.activityData.data1 ~= 1 then
		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = ActivityConst.IDOL_MEDAL_COLLECTION
		})
	end
end

return var0
