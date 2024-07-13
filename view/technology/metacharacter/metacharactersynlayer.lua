local var0_0 = class("MetaCharacterSynLayer", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "MetaCharacterSynUI"
end

function var0_0.init(arg0_2)
	arg0_2:initUITextTips()
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:addListener()
end

function var0_0.didEnter(arg0_3)
	arg0_3:updateShipImg()
	arg0_3:updatePtPanel()
	arg0_3:updateTaskList()
	arg0_3:updateGetAwardBtn()
	arg0_3:updateActTimePanel()
	arg0_3:enablePartialBlur()

	if arg0_3.contextData.isMainOpen then
		arg0_3.contextData.isMainOpen = nil

		arg0_3:moveShipImg(true)
	end

	arg0_3:movePanel()
	arg0_3:TryPlayGuide()
end

function var0_0.willExit(arg0_4)
	arg0_4:moveShipImg(false)
	arg0_4:disablePartialBlur()
end

function var0_0.initUITextTips(arg0_5)
	local var0_5 = arg0_5:findTF("PTPanel/TipText")

	setText(var0_5, i18n("meta_cur_pt"))

	local var1_5 = arg0_5:findTF("TaskPanel/ActTimePanel/Tip")

	setText(var1_5, i18n("meta_acttime_limit"))
end

function var0_0.initData(arg0_6)
	arg0_6.curMetaShipID = arg0_6.contextData.shipID
	arg0_6.curShipVO = nil
	arg0_6.curMetaCharacterVO = nil
	arg0_6.curMetaProgressVO = nil

	arg0_6:updateData()
end

function var0_0.updateData(arg0_7)
	arg0_7.curShipVO = getProxy(BayProxy):getShipById(arg0_7.curMetaShipID)
	arg0_7.curMetaCharacterVO = arg0_7.curShipVO:getMetaCharacter()
	arg0_7.curMetaProgressVO = getProxy(MetaCharacterProxy):getMetaProgressVOByID(arg0_7.curMetaCharacterVO.id)
end

function var0_0.findUI(arg0_8)
	arg0_8.shipImg = arg0_8:findTF("ShipImg")
	arg0_8.ptPanel = arg0_8:findTF("PTPanel")
	arg0_8.ptSynRateText = arg0_8:findTF("ProgressText", arg0_8.ptPanel)
	arg0_8.ptNumText = arg0_8:findTF("Count/NumText", arg0_8.ptPanel)
	arg0_8.ptIconLeft = arg0_8:findTF("Icon", arg0_8.ptPanel)
	arg0_8.showWayBtn = arg0_8:findTF("ShowWayBtn", arg0_8.ptPanel)
	arg0_8.taskPanel = arg0_8:findTF("TaskPanel")
	arg0_8.taskTplContainer = arg0_8:findTF("Scroll/Viewport/Content", arg0_8.taskPanel)
	arg0_8.taskTpl = arg0_8:findTF("TaskTpl", arg0_8.taskPanel)
	arg0_8.getAllBtn = arg0_8:findTF("BtnGetAll", arg0_8.taskPanel)
	arg0_8.getAllBtnDisable = arg0_8:findTF("BtnGetAllDisable", arg0_8.taskPanel)
	arg0_8.getNextBtn = arg0_8:findTF("BtnGetMore", arg0_8.taskPanel)
	arg0_8.taskUIItemList = UIItemList.New(arg0_8.taskTplContainer, arg0_8.taskTpl)
	arg0_8.sizeH = GetComponent(arg0_8.taskTpl, "LayoutElement").preferredHeight
	arg0_8.spaceH = GetComponent(arg0_8.taskTplContainer, "VerticalLayoutGroup").spacing
	arg0_8.topH = GetComponent(arg0_8.taskTplContainer, "VerticalLayoutGroup").padding.top
	arg0_8.scrollSC = GetComponent(arg0_8:findTF("Scroll", arg0_8.taskPanel), "ScrollRect")
	arg0_8.actTimePanel = arg0_8:findTF("TaskPanel/ActTimePanel")
	arg0_8.actTimeText = arg0_8:findTF("TaskPanel/ActTimePanel/Text")
end

function var0_0.addListener(arg0_9)
	onButton(arg0_9, arg0_9.getAllBtn, function()
		local var0_10, var1_10 = arg0_9:getOneStepPTAwardLevelAndCount()

		pg.m02:sendNotification(GAME.GET_META_PT_AWARD, {
			groupID = arg0_9.curMetaProgressVO.id,
			targetCount = var1_10
		})
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.getAllBtnDisable, function()
		return
	end)
	onButton(arg0_9, arg0_9.getNextBtn, function()
		pg.TipsMgr.GetInstance():ShowTips(i18n("meta_pt_notenough"))
	end)
	onButton(arg0_9, arg0_9.showWayBtn, function()
		local var0_13 = {
			count = 0,
			type = DROP_TYPE_ITEM,
			id = arg0_9.curMetaProgressVO.metaPtData.resId
		}

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_SINGLE_ITEM,
			drop = var0_13
		})
	end, SFX_PANEL)
end

function var0_0.TryPlayGuide(arg0_14)
	pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0028")
end

function var0_0.updateActTimePanel(arg0_15)
	local var0_15 = arg0_15.curMetaProgressVO

	if type(var0_15.timeConfig) == "string" then
		setActive(arg0_15.actTimePanel, false)
	elseif type(var0_15.timeConfig) == "table" then
		local var1_15 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var0_15.timeConfig[2])
		local var2_15 = pg.TimeMgr.GetInstance():GetServerTime()
		local var3_15 = pg.TimeMgr.GetInstance():DiffDay(var2_15, var1_15)

		setText(arg0_15.actTimeText, i18n("meta_pt_left", var3_15))
	end
end

function var0_0.updateShipImg(arg0_16)
	local var0_16, var1_16 = MetaCharacterConst.GetMetaCharacterPaintPath(arg0_16.curMetaCharacterVO.id, true)

	setImageSprite(arg0_16.shipImg, LoadSprite(var0_16, var1_16), true)

	local var2_16 = arg0_16.curMetaCharacterVO.id
	local var3_16 = MetaCharacterConst.UIConfig[var2_16]

	setLocalPosition(arg0_16.shipImg, {
		x = var3_16[9],
		y = var3_16[10]
	})
	setLocalScale(arg0_16.shipImg, {
		x = var3_16[3],
		y = var3_16[4]
	})
end

function var0_0.updatePtPanel(arg0_17)
	setImageSprite(arg0_17.ptIconLeft, LoadSprite(arg0_17.curMetaProgressVO:getPtIconPath()))

	local var0_17 = arg0_17.curMetaProgressVO:getSynRate()

	setText(arg0_17.ptSynRateText, string.format("%d", var0_17 * 100) .. "%")

	local var1_17 = arg0_17.curMetaProgressVO.metaPtData:GetResProgress()

	setText(arg0_17.ptNumText, var1_17)
end

function var0_0.updateTaskList(arg0_18)
	arg0_18.taskUIItemList:make(function(arg0_19, arg1_19, arg2_19)
		if arg0_19 == UIItemList.EventUpdate then
			arg1_19 = arg1_19 + 1

			arg0_18:updateTaskTpl(arg2_19, arg1_19)
		end
	end)

	local var0_18, var1_18, var2_18 = arg0_18.curMetaProgressVO.metaPtData:GetLevelProgress()

	arg0_18.taskUIItemList:align(var1_18)

	local var3_18 = arg0_18.topH + (var0_18 - 1) * (arg0_18.sizeH + arg0_18.spaceH)

	setLocalPosition(arg0_18.taskTplContainer, {
		y = var3_18
	})
end

function var0_0.updateTaskTpl(arg0_20, arg1_20, arg2_20)
	local var0_20 = arg0_20:findTF("Target/IndexText", arg1_20)
	local var1_20 = arg0_20:findTF("PT/Count/NumText", arg1_20)
	local var2_20 = arg0_20:findTF("PT/Icon", arg1_20)
	local var3_20 = arg0_20:findTF("Info/AwardInfo/NameMask/NameText", arg1_20)
	local var4_20 = arg0_20:findTF("Info/AwardInfo/SynProgressText", arg1_20)
	local var5_20 = arg0_20:findTF("Info/AwardInfo/Award/Item", arg1_20)
	local var6_20 = arg0_20:findTF("Info/AwardInfo/Award/Tag/Get", arg1_20)
	local var7_20 = arg0_20:findTF("Info/AwardInfo/Award/Tag/Got", arg1_20)
	local var8_20 = arg0_20:findTF("GotMask", arg1_20)

	setText(var0_20, arg2_20)

	local var9_20 = arg0_20.curMetaProgressVO.metaPtData.targets[arg2_20]

	setText(var1_20, var9_20)
	setImageSprite(var2_20, LoadSprite(arg0_20.curMetaProgressVO:getPtIconPath()))

	local var10_20 = Drop.Create(arg0_20.curMetaProgressVO.metaPtData.dropList[arg2_20])

	updateDrop(var5_20, var10_20, {
		hideName = true
	})
	onButton(arg0_20, arg0_20:findTF("Info/AwardInfo/Award", arg1_20), function()
		arg0_20:emit(BaseUI.ON_DROP, var10_20)
	end, SFX_PANEL)
	setText(var3_20, shortenString(var10_20:getConfig("name"), 6))

	local var11_20 = arg0_20.curMetaProgressVO.unlockPTNum

	setText(var4_20, math.round(var9_20 / var11_20 * 100) .. "%")

	if arg2_20 < arg0_20.curMetaProgressVO.metaPtData.level + 1 then
		setActive(var7_20, true)
		setActive(var6_20, false)
		setActive(var8_20, true)
		setGray(arg1_20, true, true)
	else
		if var9_20 > arg0_20.curMetaProgressVO.metaPtData.count then
			setActive(var7_20, false)
			setActive(var6_20, false)
		else
			setActive(var7_20, false)
			setActive(var6_20, true)
		end

		setActive(var8_20, false)
		setGray(arg1_20, false, true)
	end
end

function var0_0.updateGetAwardBtn(arg0_22)
	local var0_22 = arg0_22.curMetaProgressVO.metaPtData:CanGetAward()
	local var1_22 = arg0_22.curMetaProgressVO.metaPtData:CanGetNextAward()

	if var0_22 then
		setActive(arg0_22.getAllBtn, true)
		setActive(arg0_22.getAllBtnDisable, false)
		setActive(arg0_22.getNextBtn, false)
	elseif var1_22 then
		setActive(arg0_22.getAllBtn, false)
		setActive(arg0_22.getAllBtnDisable, false)
		setActive(arg0_22.getNextBtn, true)
	else
		setActive(arg0_22.getAllBtn, false)
		setActive(arg0_22.getAllBtnDisable, true)
		setActive(arg0_22.getNextBtn, false)
	end
end

function var0_0.moveShipImg(arg0_23, arg1_23)
	local var0_23 = arg0_23.curMetaCharacterVO.id
	local var1_23 = MetaCharacterConst.UIConfig[var0_23]
	local var2_23 = arg1_23 and -2000 or var1_23[9]
	local var3_23 = arg1_23 and var1_23[9] or -2000

	arg0_23:managedTween(LeanTween.moveX, nil, rtf(arg0_23.shipImg), var3_23, 0.3):setFrom(var2_23)
end

function var0_0.movePanel(arg0_24)
	local var0_24 = 2000
	local var1_24 = 500

	arg0_24:managedTween(LeanTween.moveX, nil, rtf(arg0_24.taskPanel), var1_24, 0.3):setFrom(var0_24)

	local var2_24 = -2000
	local var3_24 = -516

	arg0_24:managedTween(LeanTween.moveX, nil, rtf(arg0_24.ptPanel), var3_24, 0.3):setFrom(var2_24)
end

function var0_0.enablePartialBlur(arg0_25)
	if arg0_25._tf then
		local var0_25 = {}

		table.insert(var0_25, arg0_25.taskPanel)
		pg.UIMgr.GetInstance():OverlayPanelPB(arg0_25._tf, {
			pbList = var0_25,
			groupName = LayerWeightConst.GROUP_META,
			weight = LayerWeightConst.BASE_LAYER - 1
		})
	end
end

function var0_0.disablePartialBlur(arg0_26)
	if arg0_26._tf then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_26._tf)
	end
end

function var0_0.getOneStepPTAwardLevelAndCount(arg0_27)
	local var0_27 = arg0_27.curMetaProgressVO
	local var1_27 = var0_27.metaPtData:GetResProgress()
	local var2_27 = var0_27.metaPtData.targets
	local var3_27 = var0_27:getStoryIndexList()
	local var4_27 = var0_27.unlockPTLevel
	local var5_27 = 0

	for iter0_27 = 1, #var2_27 do
		local var6_27 = false
		local var7_27 = false

		if var1_27 >= var2_27[iter0_27] then
			var6_27 = true
		end

		local var8_27 = var3_27[iter0_27]

		if var8_27 == 0 then
			var7_27 = true
		elseif pg.NewStoryMgr.GetInstance():IsPlayed(var8_27) then
			var7_27 = true
		end

		if var6_27 and var7_27 then
			var5_27 = iter0_27
		else
			break
		end
	end

	print("calc max level", var5_27, var2_27[var5_27])

	return var5_27, var2_27[var5_27]
end

function var0_0.goWorldFunc(arg0_28)
	local var0_28 = getProxy(ContextProxy):getContextByMediator(MetaCharacterMediator)
	local var1_28 = pg.m02:retrieveMediator("MetaCharacterMediator")

	var0_28.data.lastPageIndex = var1_28.viewComponent.curPageIndex

	arg0_28:closeView()
	arg0_28:sendNotification(GAME.GO_SCENE, SCENE.WORLDBOSS)
end

return var0_0
