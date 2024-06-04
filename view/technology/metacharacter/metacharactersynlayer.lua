local var0 = class("MetaCharacterSynLayer", import("...base.BaseUI"))

function var0.getUIName(arg0)
	return "MetaCharacterSynUI"
end

function var0.init(arg0)
	arg0:initUITextTips()
	arg0:initData()
	arg0:findUI()
	arg0:addListener()
end

function var0.didEnter(arg0)
	arg0:updateShipImg()
	arg0:updatePtPanel()
	arg0:updateTaskList()
	arg0:updateGetAwardBtn()
	arg0:updateActTimePanel()
	arg0:enablePartialBlur()

	if arg0.contextData.isMainOpen then
		arg0.contextData.isMainOpen = nil

		arg0:moveShipImg(true)
	end

	arg0:movePanel()
	arg0:TryPlayGuide()
end

function var0.willExit(arg0)
	arg0:moveShipImg(false)
	arg0:disablePartialBlur()
end

function var0.initUITextTips(arg0)
	local var0 = arg0:findTF("PTPanel/TipText")

	setText(var0, i18n("meta_cur_pt"))

	local var1 = arg0:findTF("TaskPanel/ActTimePanel/Tip")

	setText(var1, i18n("meta_acttime_limit"))
end

function var0.initData(arg0)
	arg0.curMetaShipID = arg0.contextData.shipID
	arg0.curShipVO = nil
	arg0.curMetaCharacterVO = nil
	arg0.curMetaProgressVO = nil

	arg0:updateData()
end

function var0.updateData(arg0)
	arg0.curShipVO = getProxy(BayProxy):getShipById(arg0.curMetaShipID)
	arg0.curMetaCharacterVO = arg0.curShipVO:getMetaCharacter()
	arg0.curMetaProgressVO = getProxy(MetaCharacterProxy):getMetaProgressVOByID(arg0.curMetaCharacterVO.id)
end

function var0.findUI(arg0)
	arg0.shipImg = arg0:findTF("ShipImg")
	arg0.ptPanel = arg0:findTF("PTPanel")
	arg0.ptSynRateText = arg0:findTF("ProgressText", arg0.ptPanel)
	arg0.ptNumText = arg0:findTF("Count/NumText", arg0.ptPanel)
	arg0.ptIconLeft = arg0:findTF("Icon", arg0.ptPanel)
	arg0.showWayBtn = arg0:findTF("ShowWayBtn", arg0.ptPanel)
	arg0.taskPanel = arg0:findTF("TaskPanel")
	arg0.taskTplContainer = arg0:findTF("Scroll/Viewport/Content", arg0.taskPanel)
	arg0.taskTpl = arg0:findTF("TaskTpl", arg0.taskPanel)
	arg0.getAllBtn = arg0:findTF("BtnGetAll", arg0.taskPanel)
	arg0.getAllBtnDisable = arg0:findTF("BtnGetAllDisable", arg0.taskPanel)
	arg0.getNextBtn = arg0:findTF("BtnGetMore", arg0.taskPanel)
	arg0.taskUIItemList = UIItemList.New(arg0.taskTplContainer, arg0.taskTpl)
	arg0.sizeH = GetComponent(arg0.taskTpl, "LayoutElement").preferredHeight
	arg0.spaceH = GetComponent(arg0.taskTplContainer, "VerticalLayoutGroup").spacing
	arg0.topH = GetComponent(arg0.taskTplContainer, "VerticalLayoutGroup").padding.top
	arg0.scrollSC = GetComponent(arg0:findTF("Scroll", arg0.taskPanel), "ScrollRect")
	arg0.actTimePanel = arg0:findTF("TaskPanel/ActTimePanel")
	arg0.actTimeText = arg0:findTF("TaskPanel/ActTimePanel/Text")
end

function var0.addListener(arg0)
	onButton(arg0, arg0.getAllBtn, function()
		local var0, var1 = arg0:getOneStepPTAwardLevelAndCount()

		pg.m02:sendNotification(GAME.GET_META_PT_AWARD, {
			groupID = arg0.curMetaProgressVO.id,
			targetCount = var1
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.getAllBtnDisable, function()
		return
	end)
	onButton(arg0, arg0.getNextBtn, function()
		pg.TipsMgr.GetInstance():ShowTips(i18n("meta_pt_notenough"))
	end)
	onButton(arg0, arg0.showWayBtn, function()
		local var0 = {
			count = 0,
			type = DROP_TYPE_ITEM,
			id = arg0.curMetaProgressVO.metaPtData.resId
		}

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_SINGLE_ITEM,
			drop = var0
		})
	end, SFX_PANEL)
end

function var0.TryPlayGuide(arg0)
	pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0028")
end

function var0.updateActTimePanel(arg0)
	local var0 = arg0.curMetaProgressVO

	if type(var0.timeConfig) == "string" then
		setActive(arg0.actTimePanel, false)
	elseif type(var0.timeConfig) == "table" then
		local var1 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var0.timeConfig[2])
		local var2 = pg.TimeMgr.GetInstance():GetServerTime()
		local var3 = pg.TimeMgr.GetInstance():DiffDay(var2, var1)

		setText(arg0.actTimeText, i18n("meta_pt_left", var3))
	end
end

function var0.updateShipImg(arg0)
	local var0, var1 = MetaCharacterConst.GetMetaCharacterPaintPath(arg0.curMetaCharacterVO.id, true)

	setImageSprite(arg0.shipImg, LoadSprite(var0, var1), true)

	local var2 = arg0.curMetaCharacterVO.id
	local var3 = MetaCharacterConst.UIConfig[var2]

	setLocalPosition(arg0.shipImg, {
		x = var3[9],
		y = var3[10]
	})
	setLocalScale(arg0.shipImg, {
		x = var3[3],
		y = var3[4]
	})
end

function var0.updatePtPanel(arg0)
	setImageSprite(arg0.ptIconLeft, LoadSprite(arg0.curMetaProgressVO:getPtIconPath()))

	local var0 = arg0.curMetaProgressVO:getSynRate()

	setText(arg0.ptSynRateText, string.format("%d", var0 * 100) .. "%")

	local var1 = arg0.curMetaProgressVO.metaPtData:GetResProgress()

	setText(arg0.ptNumText, var1)
end

function var0.updateTaskList(arg0)
	arg0.taskUIItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg1 = arg1 + 1

			arg0:updateTaskTpl(arg2, arg1)
		end
	end)

	local var0, var1, var2 = arg0.curMetaProgressVO.metaPtData:GetLevelProgress()

	arg0.taskUIItemList:align(var1)

	local var3 = arg0.topH + (var0 - 1) * (arg0.sizeH + arg0.spaceH)

	setLocalPosition(arg0.taskTplContainer, {
		y = var3
	})
end

function var0.updateTaskTpl(arg0, arg1, arg2)
	local var0 = arg0:findTF("Target/IndexText", arg1)
	local var1 = arg0:findTF("PT/Count/NumText", arg1)
	local var2 = arg0:findTF("PT/Icon", arg1)
	local var3 = arg0:findTF("Info/AwardInfo/NameMask/NameText", arg1)
	local var4 = arg0:findTF("Info/AwardInfo/SynProgressText", arg1)
	local var5 = arg0:findTF("Info/AwardInfo/Award/Item", arg1)
	local var6 = arg0:findTF("Info/AwardInfo/Award/Tag/Get", arg1)
	local var7 = arg0:findTF("Info/AwardInfo/Award/Tag/Got", arg1)
	local var8 = arg0:findTF("GotMask", arg1)

	setText(var0, arg2)

	local var9 = arg0.curMetaProgressVO.metaPtData.targets[arg2]

	setText(var1, var9)
	setImageSprite(var2, LoadSprite(arg0.curMetaProgressVO:getPtIconPath()))

	local var10 = Drop.Create(arg0.curMetaProgressVO.metaPtData.dropList[arg2])

	updateDrop(var5, var10, {
		hideName = true
	})
	onButton(arg0, arg0:findTF("Info/AwardInfo/Award", arg1), function()
		arg0:emit(BaseUI.ON_DROP, var10)
	end, SFX_PANEL)
	setText(var3, shortenString(var10:getConfig("name"), 6))

	local var11 = arg0.curMetaProgressVO.unlockPTNum

	setText(var4, math.round(var9 / var11 * 100) .. "%")

	if arg2 < arg0.curMetaProgressVO.metaPtData.level + 1 then
		setActive(var7, true)
		setActive(var6, false)
		setActive(var8, true)
		setGray(arg1, true, true)
	else
		if var9 > arg0.curMetaProgressVO.metaPtData.count then
			setActive(var7, false)
			setActive(var6, false)
		else
			setActive(var7, false)
			setActive(var6, true)
		end

		setActive(var8, false)
		setGray(arg1, false, true)
	end
end

function var0.updateGetAwardBtn(arg0)
	local var0 = arg0.curMetaProgressVO.metaPtData:CanGetAward()
	local var1 = arg0.curMetaProgressVO.metaPtData:CanGetNextAward()

	if var0 then
		setActive(arg0.getAllBtn, true)
		setActive(arg0.getAllBtnDisable, false)
		setActive(arg0.getNextBtn, false)
	elseif var1 then
		setActive(arg0.getAllBtn, false)
		setActive(arg0.getAllBtnDisable, false)
		setActive(arg0.getNextBtn, true)
	else
		setActive(arg0.getAllBtn, false)
		setActive(arg0.getAllBtnDisable, true)
		setActive(arg0.getNextBtn, false)
	end
end

function var0.moveShipImg(arg0, arg1)
	local var0 = arg0.curMetaCharacterVO.id
	local var1 = MetaCharacterConst.UIConfig[var0]
	local var2 = arg1 and -2000 or var1[9]
	local var3 = arg1 and var1[9] or -2000

	arg0:managedTween(LeanTween.moveX, nil, rtf(arg0.shipImg), var3, 0.3):setFrom(var2)
end

function var0.movePanel(arg0)
	local var0 = 2000
	local var1 = 500

	arg0:managedTween(LeanTween.moveX, nil, rtf(arg0.taskPanel), var1, 0.3):setFrom(var0)

	local var2 = -2000
	local var3 = -516

	arg0:managedTween(LeanTween.moveX, nil, rtf(arg0.ptPanel), var3, 0.3):setFrom(var2)
end

function var0.enablePartialBlur(arg0)
	if arg0._tf then
		local var0 = {}

		table.insert(var0, arg0.taskPanel)
		pg.UIMgr.GetInstance():OverlayPanelPB(arg0._tf, {
			pbList = var0,
			groupName = LayerWeightConst.GROUP_META,
			weight = LayerWeightConst.BASE_LAYER - 1
		})
	end
end

function var0.disablePartialBlur(arg0)
	if arg0._tf then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)
	end
end

function var0.getOneStepPTAwardLevelAndCount(arg0)
	local var0 = arg0.curMetaProgressVO
	local var1 = var0.metaPtData:GetResProgress()
	local var2 = var0.metaPtData.targets
	local var3 = var0:getStoryIndexList()
	local var4 = var0.unlockPTLevel
	local var5 = 0

	for iter0 = 1, #var2 do
		local var6 = false
		local var7 = false

		if var1 >= var2[iter0] then
			var6 = true
		end

		local var8 = var3[iter0]

		if var8 == 0 then
			var7 = true
		elseif pg.NewStoryMgr.GetInstance():IsPlayed(var8) then
			var7 = true
		end

		if var6 and var7 then
			var5 = iter0
		else
			break
		end
	end

	print("calc max level", var5, var2[var5])

	return var5, var2[var5]
end

function var0.goWorldFunc(arg0)
	local var0 = getProxy(ContextProxy):getContextByMediator(MetaCharacterMediator)
	local var1 = pg.m02:retrieveMediator("MetaCharacterMediator")

	var0.data.lastPageIndex = var1.viewComponent.curPageIndex

	arg0:closeView()
	arg0:sendNotification(GAME.GO_SCENE, SCENE.WORLDBOSS)
end

return var0
