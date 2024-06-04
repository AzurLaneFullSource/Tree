local var0 = class("DoaMedalCollectionView", import("view.base.BaseUI"))

var0.FADE_OUT_TIME = 1
var0.PAGE_NUM = 7
var0.MEDAL_NUM_PER_PAGE = 2

function var0.getUIName(arg0)
	return "DoaMedalCollectionUI"
end

function var0.init(arg0)
	arg0:initData()
	arg0:findUI()
	arg0:addListener()
end

function var0.didEnter(arg0)
	arg0:checkAward()
	setText(arg0.progressText, setColorStr(tostring(#arg0.activeIDList), COLOR_WHITE) .. "/" .. #arg0.allIDList)
	triggerToggle(arg0.switchBtnList[1], true)
end

function var0.willExit(arg0)
	if LeanTween.isTweening(go(arg0.picture)) then
		LeanTween.cancel(go(arg0.picture), false)
	end
end

function var0.getBGM(arg0)
	return math.random() > 0.5 and "doa_main_day" or "doa_main_night"
end

function var0.initData(arg0)
	arg0.activityProxy = getProxy(ActivityProxy)
	arg0.activityData = arg0.activityProxy:getActivityById(ActivityConst.DOA_MEDAL_ACT_ID)
	arg0.allIDList = arg0.activityData:GetPicturePuzzleIds()

	print(#arg0.allIDList)

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

	local var1 = arg0:findTF("SwitchBtnList", arg0._tf)

	arg0.tplButtom = findTF(var1, "tplButtom")
	arg0.imgGot = arg0:findTF("ProgressImg/got", var0)
	arg0.switchBtnList = {}
	arg0.medalTfList = {}

	for iter0 = 1, var0.PAGE_NUM do
		local var2 = tf(instantiate(go(arg0.tplButtom)))

		LoadSpriteAtlasAsync("ui/doamedalcollectionui_atlas", "ship" .. iter0 .. "Icon", function(arg0)
			if var2 then
				setImageSprite(findTF(var2, "icon"), arg0, true)
			end
		end)
		LoadSpriteAtlasAsync("ui/doamedalcollectionui_atlas", "ship" .. iter0 .. "Name", function(arg0)
			if var2 then
				setImageSprite(findTF(var2, "name"), arg0, true)
			end
		end)
		LoadSpriteAtlasAsync("ui/doamedalcollectionui_atlas", "ship" .. iter0 .. "NameSelect", function(arg0)
			if var2 then
				setImageSprite(findTF(var2, "nameSelect"), arg0, true)
			end
		end)
		setParent(var2, var1)
		setActive(var2, true)
		table.insert(arg0.switchBtnList, var2)

		for iter1 = 1, var0.MEDAL_NUM_PER_PAGE do
			local var3 = (iter0 - 1) * var0.MEDAL_NUM_PER_PAGE + iter1
			local var4 = findTF(arg0._tf, "MedalContainer/medal" .. var3)

			setActive(var4, false)
			GetComponent(findTF(var4, "disAcive/lock"), typeof(Image)):SetNativeSize()
			GetComponent(findTF(var4, "disAcive/unlock"), typeof(Image)):SetNativeSize()
			table.insert(arg0.medalTfList, var4)
		end
	end

	arg0.picture = findTF(arg0._tf, "picture")
	arg0.pictureName = findTF(arg0._tf, "picture/name")
	arg0.leftPage = findTF(arg0._tf, "book/leftPage")
	arg0.rightPage = findTF(arg0._tf, "book/rightPage")
end

function var0.addListener(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.doa_collection.tip
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

	if arg2 then
		setActive(arg0.picture, false)
		LoadSpriteAtlasAsync("ui/doamedalcollectionui_atlas", "pictureImage" .. arg1, function(arg0)
			setImageSprite(arg0.picture, arg0, true)

			if LeanTween.isTweening(go(arg0.picture)) then
				LeanTween.cancel(go(arg0.picture), false)
			end

			LeanTween.value(go(arg0.picture), 0, 1, 0.3):setOnUpdate(System.Action_float(function(arg0)
				GetComponent(arg0.picture, typeof(CanvasGroup)).alpha = arg0
			end))
			setActive(arg0.picture, true)
		end)
	else
		setActive(arg0.picture, true)
		LoadSpriteAtlasAsync("ui/doamedalcollectionui_atlas", "pictureImage" .. arg1, function(arg0)
			setImageSprite(arg0.picture, arg0, true)
		end)
	end

	LoadSpriteAtlasAsync("ui/doamedalcollectionui_atlas", "pictureName" .. arg1, function(arg0)
		setImageSprite(arg0.pictureName, arg0, true)
	end)

	for iter0 = 1, #arg0.medalTfList do
		local var1 = (arg1 - 1) * var0.MEDAL_NUM_PER_PAGE
		local var2 = (arg1 - 1) * var0.MEDAL_NUM_PER_PAGE + var0.MEDAL_NUM_PER_PAGE

		if var1 < iter0 and iter0 <= var2 then
			setActive(arg0.medalTfList[iter0], true)
		else
			setActive(arg0.medalTfList[iter0], false)
		end
	end

	for iter1, iter2 in ipairs(var0) do
		arg0:updateMedalView(var0, iter2)
	end
end

function var0.updateMedalView(arg0, arg1, arg2)
	local var0 = table.contains(arg0.activeIDList, arg2)
	local var1 = table.contains(arg0.activatableIDList, arg2) and not var0
	local var2

	var2 = not var0 and not var1

	local var3 = table.indexof(arg1, arg2, 1)
	local var4 = (arg0.curPage - 1) * var0.MEDAL_NUM_PER_PAGE + var3
	local var5 = arg0.medalTfList[var4]

	if var0 then
		setActive(findTF(var5, "isActive"), true)
		setActive(findTF(var5, "disAcive"), false)
	else
		setActive(findTF(var5, "isActive"), false)
		setActive(findTF(var5, "disAcive"), true)

		if var1 then
			onButton(arg0, findTF(var5, "disAcive"), function()
				pg.m02:sendNotification(GAME.MEMORYBOOK_UNLOCK, {
					id = arg2,
					actId = arg0.activityData.id
				})
			end, SFX_PANEL)
			setActive(findTF(var5, "disAcive/lock"), false)
			setActive(findTF(var5, "disAcive/unlock"), true)
		else
			setActive(findTF(var5, "disAcive/lock"), true)
			setActive(findTF(var5, "disAcive/unlock"), false)
		end
	end
end

function var0.updateSwitchBtnTF(arg0)
	setText(arg0.leftPage, (arg0.curPage - 1) * var0.MEDAL_NUM_PER_PAGE + 1)
	setText(arg0.rightPage, (arg0.curPage - 1) * var0.MEDAL_NUM_PER_PAGE + 2)

	for iter0, iter1 in ipairs(arg0.switchBtnList) do
		local var0 = arg0:findTF("Tip", iter1)
		local var1 = arg0:caculateActivatable(iter0)

		if var1 == 0 or iter0 == arg0.curPage then
			setActive(var0, false)
		end

		if var1 > 0 and iter0 ~= arg0.curPage then
			setActive(var0, true)
		end
	end
end

function var0.updateAfterSubmit(arg0, arg1)
	arg0.activityProxy = getProxy(ActivityProxy)
	arg0.activityData = arg0.activityProxy:getActivityById(ActivityConst.DOA_MEDAL_ACT_ID)
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
			activity_id = ActivityConst.DOA_MEDAL_ACT_ID
		})
		setActive(arg0.imgGot, true)
	end
end

return var0
