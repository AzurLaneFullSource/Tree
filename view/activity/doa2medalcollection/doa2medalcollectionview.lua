local var0_0 = class("Doa2MedalCollectionView", import("view.base.BaseUI"))

var0_0.FADE_OUT_TIME = 1
var0_0.PAGE_NUM = 9
var0_0.MEDAL_NUM_PER_PAGE = 2

local var1_0 = "ui/doa2medalcollectionui_atlas"

function var0_0.getUIName(arg0_1)
	return "Doa2MedalCollectionUI"
end

function var0_0.init(arg0_2)
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:addListener()
end

function var0_0.didEnter(arg0_3)
	arg0_3:checkAward()

	if arg0_3.activeIDList then
		setText(arg0_3.progressText, setColorStr(tostring(#arg0_3.activeIDList), COLOR_WHITE) .. "/" .. #arg0_3.allIDList)
	end

	triggerToggle(arg0_3.switchBtnList[1], true)
end

function var0_0.willExit(arg0_4)
	if LeanTween.isTweening(go(arg0_4.picture)) then
		LeanTween.cancel(go(arg0_4.picture), false)
	end
end

function var0_0.getBGM(arg0_5)
	return math.random() > 0.5 and "doa_main_day" or "doa_main_night"
end

function var0_0.initData(arg0_6)
	arg0_6.activityProxy = getProxy(ActivityProxy)
	arg0_6.activityData = arg0_6.activityProxy:getActivityById(ActivityConst.DOA_MEDAL_ACT_ID)

	if not arg0_6.activityData then
		return
	end

	arg0_6.allIDList = arg0_6.activityData:GetPicturePuzzleIds()
	arg0_6.pageIDList = {}

	for iter0_6 = 1, var0_0.PAGE_NUM do
		arg0_6.pageIDList[iter0_6] = {}

		for iter1_6 = 1, var0_0.MEDAL_NUM_PER_PAGE do
			arg0_6.pageIDList[iter0_6][iter1_6] = arg0_6.allIDList[(iter0_6 - 1) * var0_0.MEDAL_NUM_PER_PAGE + iter1_6]
		end
	end

	arg0_6.activatableIDList = arg0_6.activityData and arg0_6.activityData.data1_list or {}
	arg0_6.activeIDList = arg0_6.activityData and arg0_6.activityData.data2_list
	arg0_6.curPage = nil
	arg0_6.newMedalID = nil
end

function var0_0.findUI(arg0_7)
	arg0_7.bg = arg0_7:findTF("BG")

	local var0_7 = arg0_7:findTF("NotchAdapt")

	arg0_7.backBtn = arg0_7:findTF("BackBtn", var0_7)
	arg0_7.progressText = arg0_7:findTF("ProgressImg/ProgressText", var0_7)
	arg0_7.helpBtn = arg0_7:findTF("HelpBtn", var0_7)

	local var1_7 = arg0_7:findTF("SwitchBtnList", arg0_7._tf)

	arg0_7.tplButtom = findTF(var1_7, "tplButtom")

	setActive(arg0_7.tplButtom, false)

	arg0_7.imgGot = arg0_7:findTF("ProgressImg/got", var0_7)
	arg0_7.switchBtnList = {}
	arg0_7.medalTfList = {}

	for iter0_7 = 1, var0_0.PAGE_NUM do
		local var2_7 = tf(instantiate(go(arg0_7.tplButtom)))

		LoadSpriteAtlasAsync(var1_0, "ship" .. iter0_7 .. "Icon", function(arg0_8)
			if var2_7 then
				setImageSprite(findTF(var2_7, "icon"), arg0_8, true)
			end
		end)
		LoadSpriteAtlasAsync(var1_0, "ship" .. iter0_7 .. "Name", function(arg0_9)
			if var2_7 then
				setImageSprite(findTF(var2_7, "name"), arg0_9, true)
			end
		end)
		LoadSpriteAtlasAsync(var1_0, "ship" .. iter0_7 .. "NameSelect", function(arg0_10)
			if var2_7 then
				setImageSprite(findTF(var2_7, "nameSelect"), arg0_10, true)
			end
		end)
		setParent(var2_7, var1_7)
		setActive(var2_7, true)
		table.insert(arg0_7.switchBtnList, var2_7)

		for iter1_7 = 1, var0_0.MEDAL_NUM_PER_PAGE do
			local var3_7 = (iter0_7 - 1) * var0_0.MEDAL_NUM_PER_PAGE + iter1_7
			local var4_7 = findTF(arg0_7._tf, "MedalContainer/medal" .. var3_7)

			setActive(var4_7, false)
			GetComponent(findTF(var4_7, "disAcive/lock"), typeof(Image)):SetNativeSize()
			GetComponent(findTF(var4_7, "disAcive/unlock"), typeof(Image)):SetNativeSize()
			table.insert(arg0_7.medalTfList, var4_7)
		end
	end

	arg0_7.picture = findTF(arg0_7._tf, "picture")
	arg0_7.pictureName = findTF(arg0_7._tf, "picture/name")
	arg0_7.leftPage = findTF(arg0_7._tf, "book/leftPage")
	arg0_7.rightPage = findTF(arg0_7._tf, "book/rightPage")
end

function var0_0.addListener(arg0_11)
	onButton(arg0_11, arg0_11.backBtn, function()
		arg0_11:closeView()
	end, SFX_CANCEL)
	onButton(arg0_11, arg0_11.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.doa_collection.tip
		})
	end, SFX_PANEL)

	for iter0_11, iter1_11 in ipairs(arg0_11.switchBtnList) do
		onToggle(arg0_11, iter1_11, function(arg0_14)
			if arg0_14 == true then
				local var0_14 = arg0_11.curPage ~= iter0_11

				arg0_11.curPage = iter0_11

				arg0_11:updateSwitchBtnTF()
				arg0_11:updateMedalContainerView(iter0_11, var0_14)
			end
		end, SFX_PANEL)
	end
end

function var0_0.UpdateActivity(arg0_15, arg1_15)
	arg0_15:checkAward()
end

function var0_0.updateMedalContainerView(arg0_16, arg1_16, arg2_16)
	if arg2_16 then
		setActive(arg0_16.picture, false)
		LoadSpriteAtlasAsync(var1_0, "pictureImage" .. arg1_16, function(arg0_17)
			setImageSprite(arg0_16.picture, arg0_17, true)

			if LeanTween.isTweening(go(arg0_16.picture)) then
				LeanTween.cancel(go(arg0_16.picture), false)
			end

			LeanTween.value(go(arg0_16.picture), 0, 1, 0.3):setOnUpdate(System.Action_float(function(arg0_18)
				GetComponent(arg0_16.picture, typeof(CanvasGroup)).alpha = arg0_18
			end))
			setActive(arg0_16.picture, true)
		end)
	else
		setActive(arg0_16.picture, true)
		LoadSpriteAtlasAsync(var1_0, "pictureImage" .. arg1_16, function(arg0_19)
			setImageSprite(arg0_16.picture, arg0_19, true)
		end)
	end

	LoadSpriteAtlasAsync(var1_0, "pictureName" .. arg1_16, function(arg0_20)
		setImageSprite(arg0_16.pictureName, arg0_20, true)
	end)

	for iter0_16 = 1, #arg0_16.medalTfList do
		local var0_16 = (arg1_16 - 1) * var0_0.MEDAL_NUM_PER_PAGE
		local var1_16 = (arg1_16 - 1) * var0_0.MEDAL_NUM_PER_PAGE + var0_0.MEDAL_NUM_PER_PAGE

		if var0_16 < iter0_16 and iter0_16 <= var1_16 then
			setActive(arg0_16.medalTfList[iter0_16], true)
		else
			setActive(arg0_16.medalTfList[iter0_16], false)
		end
	end

	if arg0_16.pageIDList then
		local var2_16 = arg0_16.pageIDList[arg1_16]

		for iter1_16, iter2_16 in ipairs(var2_16) do
			arg0_16:updateMedalView(var2_16, iter2_16)
		end
	end
end

function var0_0.updateMedalView(arg0_21, arg1_21, arg2_21)
	local var0_21 = table.contains(arg0_21.activeIDList, arg2_21)
	local var1_21 = table.contains(arg0_21.activatableIDList, arg2_21) and not var0_21
	local var2_21

	var2_21 = not var0_21 and not var1_21

	local var3_21 = table.indexof(arg1_21, arg2_21, 1)
	local var4_21 = (arg0_21.curPage - 1) * var0_0.MEDAL_NUM_PER_PAGE + var3_21
	local var5_21 = arg0_21.medalTfList[var4_21]

	if var0_21 then
		setActive(findTF(var5_21, "isActive"), true)
		setActive(findTF(var5_21, "disAcive"), false)
	else
		setActive(findTF(var5_21, "isActive"), false)
		setActive(findTF(var5_21, "disAcive"), true)

		if var1_21 then
			onButton(arg0_21, findTF(var5_21, "disAcive"), function()
				pg.m02:sendNotification(GAME.MEMORYBOOK_UNLOCK, {
					id = arg2_21,
					actId = arg0_21.activityData.id
				})
			end, SFX_PANEL)
			setActive(findTF(var5_21, "disAcive/lock"), false)
			setActive(findTF(var5_21, "disAcive/unlock"), true)
		else
			setActive(findTF(var5_21, "disAcive/lock"), true)
			setActive(findTF(var5_21, "disAcive/unlock"), false)
		end
	end
end

function var0_0.updateSwitchBtnTF(arg0_23)
	setText(arg0_23.leftPage, (arg0_23.curPage - 1) * var0_0.MEDAL_NUM_PER_PAGE + 1)
	setText(arg0_23.rightPage, (arg0_23.curPage - 1) * var0_0.MEDAL_NUM_PER_PAGE + 2)

	for iter0_23, iter1_23 in ipairs(arg0_23.switchBtnList) do
		local var0_23 = arg0_23:findTF("Tip", iter1_23)
		local var1_23 = arg0_23:caculateActivatable(iter0_23)

		if var1_23 == 0 then
			setActive(var0_23, false)
		end

		if var1_23 > 0 then
			setActive(var0_23, true)
		end
	end
end

function var0_0.updateAfterSubmit(arg0_24, arg1_24)
	arg0_24.activityProxy = getProxy(ActivityProxy)
	arg0_24.activityData = arg0_24.activityProxy:getActivityById(ActivityConst.DOA2_MEDAL_ACT_ID)
	arg0_24.activatableIDList = arg0_24.activityData.data1_list
	arg0_24.activeIDList = arg0_24.activityData.data2_list
	arg0_24.newMedalID = arg1_24

	triggerToggle(arg0_24.switchBtnList[arg0_24.curPage], true)
	setText(arg0_24.progressText, setColorStr(tostring(#arg0_24.activeIDList), COLOR_WHITE) .. "/" .. #arg0_24.allIDList)
	arg0_24:checkAward()
end

function var0_0.caculateActivatable(arg0_25, arg1_25)
	local var0_25 = 0

	if not arg0_25.pageIDList then
		return var0_25
	end

	local var1_25 = arg0_25.pageIDList[arg1_25]

	for iter0_25, iter1_25 in ipairs(var1_25) do
		local var2_25 = table.contains(arg0_25.activeIDList, iter1_25)
		local var3_25 = table.contains(arg0_25.activatableIDList, iter1_25)

		if not var2_25 and var3_25 then
			var0_25 = var0_25 + 1
		end
	end

	return var0_25
end

function var0_0.checkAward(arg0_26)
	if not arg0_26.activeIDList then
		return
	end

	setActive(arg0_26.imgGot, #arg0_26.activeIDList == #arg0_26.allIDList and arg0_26.activityData.data1 == 1)

	if #arg0_26.activeIDList == #arg0_26.allIDList and arg0_26.activityData.data1 ~= 1 and not arg0_26.awardFlag then
		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = ActivityConst.DOA_MEDAL_ACT_ID
		})
		setActive(arg0_26.imgGot, true)

		arg0_26.awardFlag = true
	end
end

return var0_0
