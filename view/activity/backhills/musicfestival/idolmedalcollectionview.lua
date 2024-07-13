local var0_0 = class("IdolMedalCollectionView", import("view.base.BaseUI"))

var0_0.FADE_OUT_TIME = 1
var0_0.PAGE_NUM = 5
var0_0.MEDAL_NUM_PER_PAGE = 3

function var0_0.getUIName(arg0_1)
	return "IdolMedalCollectionUI"
end

function var0_0.init(arg0_2)
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:addListener()
end

function var0_0.didEnter(arg0_3)
	arg0_3:checkAward()
	setText(arg0_3.progressText, setColorStr(tostring(#arg0_3.activeIDList), COLOR_RED) .. "/" .. #arg0_3.allIDList)
	triggerToggle(arg0_3.switchBtnList[1], true)
end

function var0_0.willExit(arg0_4)
	return
end

function var0_0.initData(arg0_5)
	arg0_5.activityProxy = getProxy(ActivityProxy)
	arg0_5.activityData = arg0_5.activityProxy:getActivityById(ActivityConst.IDOL_MEDAL_COLLECTION)
	arg0_5.allIDList = arg0_5.activityData:GetPicturePuzzleIds()
	arg0_5.pageIDList = {}

	for iter0_5 = 1, var0_0.PAGE_NUM do
		arg0_5.pageIDList[iter0_5] = {}

		for iter1_5 = 1, var0_0.MEDAL_NUM_PER_PAGE do
			arg0_5.pageIDList[iter0_5][iter1_5] = arg0_5.allIDList[(iter0_5 - 1) * var0_0.MEDAL_NUM_PER_PAGE + iter1_5]
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

	local var1_6 = arg0_6:findTF("MedalContainer")

	arg0_6.medalItemList = {}
	arg0_6.medalItemList[1] = arg0_6:findTF("Medal1", var1_6)
	arg0_6.medalItemList[2] = arg0_6:findTF("Medal2", var1_6)
	arg0_6.medalItemList[3] = arg0_6:findTF("Medal3", var1_6)

	local var2_6 = arg0_6:findTF("SwitchBtnList", var0_6)

	arg0_6.switchBtnList = {}

	for iter0_6 = 1, 5 do
		arg0_6.switchBtnList[iter0_6] = arg0_6:findTF("Button" .. iter0_6, var2_6)
	end
end

function var0_0.addListener(arg0_7)
	onButton(arg0_7, arg0_7.backBtn, function()
		arg0_7:closeView()
	end, SFX_CANCEL)
	onButton(arg0_7, arg0_7.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.music_collection.tip
		})
	end, SFX_PANEL)

	for iter0_7, iter1_7 in ipairs(arg0_7.switchBtnList) do
		onToggle(arg0_7, iter1_7, function(arg0_10)
			if arg0_10 == true then
				arg0_7.curPage = iter0_7

				arg0_7:updateSwitchBtnTF()
				arg0_7:updateMedalContainerView(iter0_7)
			end
		end, SFX_PANEL)
	end

	addSlip(SLIP_TYPE_HRZ, arg0_7.bg, function()
		if arg0_7.curPage > 1 then
			triggerToggle(arg0_7.switchBtnList[arg0_7.curPage - 1], true)
		else
			return
		end
	end, function()
		if arg0_7.curPage < var0_0.PAGE_NUM then
			triggerToggle(arg0_7.switchBtnList[arg0_7.curPage + 1], true)
		else
			return
		end
	end)
end

function var0_0.updateMedalContainerView(arg0_13, arg1_13)
	local var0_13 = arg0_13.pageIDList[arg1_13]

	for iter0_13, iter1_13 in ipairs(var0_13) do
		arg0_13:updateMedalView(var0_13, iter1_13)
	end
end

function var0_0.updateMedalView(arg0_14, arg1_14, arg2_14)
	local var0_14 = table.indexof(arg1_14, arg2_14, 1)
	local var1_14 = table.contains(arg0_14.activeIDList, arg2_14)
	local var2_14 = table.contains(arg0_14.activatableIDList, arg2_14) and not var1_14
	local var3_14 = not var1_14 and not var2_14
	local var4_14 = arg0_14.medalItemList[var0_14]
	local var5_14 = arg0_14:findTF("Active", var4_14)
	local var6_14 = arg0_14:findTF("Activable", var4_14)
	local var7_14 = arg0_14:findTF("DisActive", var4_14)

	setActive(var5_14, var1_14)
	setActive(var6_14, var2_14)
	setActive(var7_14, var3_14)

	if var5_14 then
		setImageSprite(var5_14, GetSpriteFromAtlas("ui/musicfestivalmedalcollectionui_atlas", tostring(arg2_14)))
	end

	if var2_14 then
		onButton(arg0_14, var6_14, function()
			pg.m02:sendNotification(GAME.MEMORYBOOK_UNLOCK, {
				id = arg2_14,
				actId = ActivityConst.IDOL_MEDAL_COLLECTION
			})
		end, SFX_PANEL)
	end

	if var3_14 then
		local var8_14 = table.indexof(arg0_14.allIDList, arg2_14, 1)
		local var9_14 = arg0_14.activityData:getConfig("config_client").unlock_desc[var8_14]

		setText(var7_14, var9_14)
	end
end

function var0_0.updateSwitchBtnTF(arg0_16)
	for iter0_16, iter1_16 in ipairs(arg0_16.switchBtnList) do
		local var0_16 = arg0_16:findTF("Tip", iter1_16)
		local var1_16 = arg0_16:findTF("Text", var0_16)
		local var2_16 = arg0_16:caculateActivatable(iter0_16)

		if var2_16 == 0 or iter0_16 == arg0_16.curPage then
			setActive(var0_16, false)
		end

		if var2_16 > 0 and iter0_16 ~= arg0_16.curPage then
			setActive(var0_16, true)
			setText(var1_16, var2_16)
		end
	end
end

function var0_0.updateAfterSubmit(arg0_17, arg1_17)
	arg0_17.activityProxy = getProxy(ActivityProxy)
	arg0_17.activityData = arg0_17.activityProxy:getActivityById(ActivityConst.IDOL_MEDAL_COLLECTION)
	arg0_17.activatableIDList = arg0_17.activityData.data1_list
	arg0_17.activeIDList = arg0_17.activityData.data2_list
	arg0_17.newMedalID = arg1_17

	triggerToggle(arg0_17.switchBtnList[arg0_17.curPage], true)
	setText(arg0_17.progressText, setColorStr(tostring(#arg0_17.activeIDList), COLOR_RED) .. "/" .. #arg0_17.allIDList)
	arg0_17:checkAward()
end

function var0_0.UpdateActivity(arg0_18)
	return
end

function var0_0.caculateActivatable(arg0_19, arg1_19)
	local var0_19 = arg0_19.pageIDList[arg1_19]
	local var1_19 = 0

	for iter0_19, iter1_19 in ipairs(var0_19) do
		local var2_19 = table.contains(arg0_19.activeIDList, iter1_19)
		local var3_19 = table.contains(arg0_19.activatableIDList, iter1_19)

		if not var2_19 and var3_19 then
			var1_19 = var1_19 + 1
		end
	end

	return var1_19
end

function var0_0.checkAward(arg0_20)
	if #arg0_20.activeIDList == #arg0_20.allIDList and arg0_20.activityData.data1 ~= 1 then
		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = ActivityConst.IDOL_MEDAL_COLLECTION
		})
	end
end

return var0_0
