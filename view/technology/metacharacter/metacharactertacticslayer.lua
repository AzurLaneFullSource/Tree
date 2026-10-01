local var0_0 = class("MetaCharacterTacticsLayer", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "MetaCharacterTacticsUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"ui/metacharactertacticsui",
		"ui/iconcolorful"
	}
	local var1_2 = {}
	local var2_2 = {}
	local var3_2 = arg1_2 and arg1_2.shipID
	local var4_2 = var3_2 and getProxy(BayProxy):getShipById(var3_2)

	if var4_2 then
		local var5_2 = var4_2:getMetaCharacter()

		if var5_2 then
			local var6_2, var7_2 = MetaCharacterConst.GetMetaCharacterPaintPath(var5_2.id, true)

			table.insert(var1_2, var6_2)
		end

		local var8_2 = MetaCharacterConst.getTacticsSkillIDListByShipConfigID(var4_2.configId)

		for iter0_2, iter1_2 in ipairs(var8_2) do
			local var9_2 = getSkillConfig(iter1_2)

			if var9_2 and var9_2.icon then
				table.insert(var2_2, ResPathSupport.CombinePath("skillicon", var9_2.icon))
			end
		end
	end

	return ResPathSupport.MergeLuaArr(var0_0.super.getResource(arg0_2, arg1_2), var0_2, var1_2, var2_2)
end

function var0_0.init(arg0_3)
	arg0_3:initUITextTips()
	arg0_3:initData()
	arg0_3:initUI()
	arg0_3:addListener()
end

function var0_0.didEnter(arg0_4)
	arg0_4:updateRedTag()
	arg0_4:updateShipImg()
	arg0_4:updateNamePanel()
	arg0_4:updateChar()
	arg0_4:updateSkillListPanel()
	arg0_4:enablePartialBlur()

	if arg0_4.contextData.isMainOpen then
		arg0_4.contextData.isMainOpen = nil

		arg0_4:moveShipImg(true)
	end

	arg0_4:moveRightPanel()
end

function var0_0.willExit(arg0_5)
	arg0_5:moveShipImg(false)
	arg0_5:recycleChar()
	arg0_5:disablePartialBlur()
end

function var0_0.onBackPressed(arg0_6)
	if isActive(arg0_6.skillUnlockPanel) then
		arg0_6:closeUnlockSkillPanel()

		return
	else
		arg0_6:emit(var0_0.ON_BACK_PRESSED)
	end
end

function var0_0.initUITextTips(arg0_7)
	local var0_7 = arg0_7._tf:Find("ExpPanel"):Find("ExpEveryDay")

	setText(var0_7, i18n("meta_exp_per_day"))

	local var1_7 = arg0_7._tf:Find("TaskPanel/StudySkillTip/TipText")

	setText(var1_7, i18n("meta_skill_unlock"))
end

function var0_0.initData(arg0_8)
	arg0_8.metaCharacterProxy = getProxy(MetaCharacterProxy)
	arg0_8.bayProxy = getProxy(BayProxy)
	arg0_8.shipPrefab = nil
	arg0_8.shipModel = nil
	arg0_8.curMetaShipID = arg0_8.contextData.shipID
	arg0_8.curShipVO = nil
	arg0_8.curMetaCharacterVO = nil

	arg0_8:updateData()

	arg0_8.skillBtnList = {}
	arg0_8.curUnlockSkillID = nil
	arg0_8.curUnlockMaterialID = nil
	arg0_8.curUnlockMaterialNeedCount = nil
end

function var0_0.updateData(arg0_9)
	arg0_9.curShipVO = arg0_9.bayProxy:getShipById(arg0_9.curMetaShipID)
	arg0_9.curMetaCharacterVO = arg0_9.curShipVO:getMetaCharacter()
end

function var0_0.setTacticsData(arg0_10, arg1_10)
	arg0_10.doubleExpValue = arg1_10.doubleExp
	arg0_10.normalExpValue = arg1_10.normalExp
	arg0_10.curSkillID = arg1_10.curSkillID
	arg0_10.switchCountLeft = arg1_10.switchCount
	arg0_10.taskInfoTable = arg1_10.taskInfoTable
	arg0_10.skillExpTable = arg1_10.skillExpTable
	arg1_10 = nil
end

function var0_0.switchTacticsSkillData(arg0_11, arg1_11, arg2_11)
	arg0_11.curSkillID = arg1_11
	arg0_11.switchCountLeft = arg2_11
end

function var0_0.levelupTacticsSkillData(arg0_12, arg1_12, arg2_12)
	arg0_12.skillExpTable[arg1_12] = 0
	arg0_12.switchCountLeft = arg2_12

	arg0_12:clearTaskInfo()
end

function var0_0.updateSkillExp(arg0_13, arg1_13, arg2_13)
	arg0_13.skillExpTable[arg1_13] = arg2_13
end

function var0_0.clearTaskInfo(arg0_14, arg1_14)
	arg0_14.taskInfoTable[arg1_14] = {}
end

function var0_0.initUI(arg0_15)
	arg0_15.shipImg = arg0_15._tf:Find("ShipImg")
	arg0_15.nameTF = arg0_15._tf:Find("NamePanel")
	arg0_15.nameScrollText = arg0_15.nameTF:Find("NameMask/NameText")
	arg0_15.shipTypeImg = arg0_15.nameTF:Find("TypeImg")
	arg0_15.enNameText = arg0_15.nameTF:Find("NameENText")

	local var0_15 = arg0_15.nameTF:Find("StarTpl")
	local var1_15 = arg0_15.nameTF:Find("StarContainer")

	arg0_15.nameTFStarUIList = UIItemList.New(var1_15, var0_15)
	arg0_15.expPanel = arg0_15._tf:Find("ExpPanel")
	arg0_15.expText = arg0_15.expPanel:Find("ExpText")
	arg0_15.expDoubleTag = arg0_15.expText:Find("DoubleTag")
	arg0_15.taskPanel = arg0_15._tf:Find("TaskPanel")
	arg0_15.qCharContainer = arg0_15.taskPanel:Find("QChar")
	arg0_15.taskTpl = arg0_15.taskPanel:Find("TaskTpl")
	arg0_15.taskScrollTF = arg0_15.taskPanel:Find("ScrollView")
	arg0_15.taskTplContainer = arg0_15.taskPanel:Find("ScrollView/Viewport/Content")
	arg0_15.taskScrollBar = arg0_15.taskPanel:Find("ScrollView/Scrollbar Vertical")
	arg0_15.taskUIItemList = UIItemList.New(arg0_15.taskTplContainer, arg0_15.taskTpl)
	arg0_15.skillInfoPanel = arg0_15.taskPanel:Find("SkillInfo")
	arg0_15.curSkillIcon = arg0_15.skillInfoPanel:Find("Skill/Icon")
	arg0_15.curSkillNameScrollText = arg0_15.skillInfoPanel:Find("NameMask/Name")
	arg0_15.curSkillLevelText = arg0_15.skillInfoPanel:Find("LevelInfo/CurLevel")
	arg0_15.nextSkillLevelText = arg0_15.skillInfoPanel:Find("LevelInfo/NextLevel")
	arg0_15.curSkillDescText = arg0_15.skillInfoPanel:Find("DescView/Viewport/SkillDesc")
	arg0_15.curSkillProgressText = arg0_15.skillInfoPanel:Find("ExpProgress/Text")
	arg0_15.curSkillProgressSlider = arg0_15.skillInfoPanel:Find("ExpSlider")
	arg0_15.curSkillQuickBtn = arg0_15.skillInfoPanel:Find("QuickBtn")
	arg0_15.studySkillTip = arg0_15.taskPanel:Find("StudySkillTip")
	arg0_15.startSkillTip = arg0_15.taskPanel:Find("StartLearn")
	arg0_15.maxSkillTip = arg0_15.taskPanel:Find("SkillMax")
	arg0_15.studySkillBtn = arg0_15.startSkillTip:Find("StartLearnBtn")
	arg0_15.skillPanel = arg0_15._tf:Find("SkillPanel")
	arg0_15.skillTpl = arg0_15.skillPanel:Find("SkillTpl")
	arg0_15.skillContainer = arg0_15.skillPanel:Find("Skills/Content")
	arg0_15.skillUIItemList = UIItemList.New(arg0_15.skillContainer, arg0_15.skillTpl)
	arg0_15.skillUnlockPanel = arg0_15._tf:Find("SkillLearnBox")
	arg0_15.skillUnlockPanelBG = arg0_15.skillUnlockPanel:Find("BG")
	arg0_15.skillUnlockPanelTipText = arg0_15.skillUnlockPanel:Find("Box/TipText")
	arg0_15.skillUnlockPanelCancelBtn = arg0_15.skillUnlockPanel:Find("Box/Btns/CancenBtn")
	arg0_15.skillUnlockPanelConfirmBtn = arg0_15.skillUnlockPanel:Find("Box/Btns/ConfirmBtn")
	arg0_15.materialTpl = arg0_15.skillUnlockPanel:Find("Box/Material")
	arg0_15.materialTplContainer = arg0_15.skillUnlockPanel:Find("Box/MaterialContainer")
	arg0_15.materialUIItemList = UIItemList.New(arg0_15.materialTplContainer, arg0_15.materialTpl)
end

function var0_0.addListener(arg0_16)
	onButton(arg0_16, arg0_16.skillUnlockPanelBG, function()
		arg0_16:closeUnlockSkillPanel()
	end, SFX_PANEL)
	onButton(arg0_16, arg0_16.skillUnlockPanelCancelBtn, function()
		arg0_16:closeUnlockSkillPanel()
	end, SFX_PANEL)
	onButton(arg0_16, arg0_16.skillUnlockPanelConfirmBtn, function()
		if not arg0_16.curUnlockMaterialID then
			pg.TipsMgr.GetInstance():ShowTips(i18n("meta_unlock_skill_select"))

			return
		elseif getProxy(BagProxy):getItemCountById(arg0_16.curUnlockMaterialID) < arg0_16.curUnlockMaterialNeedCount then
			pg.TipsMgr.GetInstance():ShowTips(i18n("word_materal_no_enough"))
		else
			local var0_19 = 0
			local var1_19 = 0
			local var2_19 = arg0_16:getMetaSkillTacticsConfigBySkillID(arg0_16.curUnlockSkillID, 1).skill_unlock

			for iter0_19, iter1_19 in ipairs(var2_19) do
				if arg0_16.curUnlockMaterialID == iter1_19[2] then
					var0_19 = iter0_19
					var1_19 = iter1_19[3]

					break
				end
			end

			pg.m02:sendNotification(GAME.TACTICS_META_UNLOCK_SKILL, {
				shipID = arg0_16.curMetaShipID,
				skillID = arg0_16.curUnlockSkillID,
				materialIndex = var0_19,
				materialInfo = {
					id = arg0_16.curUnlockMaterialID,
					count = var1_19
				}
			})
		end
	end, SFX_PANEL)
end

function var0_0.updateRedTag(arg0_20)
	arg0_20.metaCharacterProxy:updateRedTag(arg0_20.curMetaCharacterVO.id)
end

function var0_0.updateShipImg(arg0_21)
	local var0_21, var1_21 = MetaCharacterConst.GetMetaCharacterPaintPath(arg0_21.curMetaCharacterVO.id, true)

	setImageSprite(arg0_21.shipImg, LoadSprite(var0_21, var1_21), true)

	local var2_21 = arg0_21.curMetaCharacterVO.id
	local var3_21 = MetaCharacterConst.UIConfig[var2_21]

	setLocalPosition(arg0_21.shipImg, {
		x = var3_21[7],
		y = var3_21[8]
	})
	setLocalScale(arg0_21.shipImg, {
		x = var3_21[3],
		y = var3_21[4]
	})
end

function var0_0.updateNamePanel(arg0_22)
	local var0_22 = arg0_22.curShipVO
	local var1_22 = arg0_22.curMetaCharacterVO
	local var2_22 = var0_22:getName()

	setScrollText(arg0_22.nameScrollText, var2_22)

	local var3_22 = var0_22:getShipType()

	setImageSprite(arg0_22.shipTypeImg, LoadSprite("shiptype", var3_22))

	local var4_22 = var0_22:getConfig("english_name")

	setText(arg0_22.enNameText, var4_22)

	local var5_22 = var0_22:getMaxStar()
	local var6_22 = var0_22:getStar()

	arg0_22.nameTFStarUIList:make(function(arg0_23, arg1_23, arg2_23)
		if arg0_23 == UIItemList.EventUpdate then
			local var0_23 = arg2_23:Find("empty")
			local var1_23 = arg2_23:Find("on")

			arg1_23 = arg1_23 + 1

			setActive(var1_23, arg1_23 <= var6_22)
		end
	end)
	arg0_22.nameTFStarUIList:align(var5_22)
end

function var0_0.updateChar(arg0_24)
	return
end

function var0_0.recycleChar(arg0_25)
	if arg0_25.shipPrefab and arg0_25.shipModel then
		PoolMgr.GetInstance():ReturnSpineChar(arg0_25.shipPrefab, arg0_25.shipModel)

		arg0_25.shipPrefab = nil
		arg0_25.shipModel = nil
	end
end

function var0_0.updateSkillListPanel(arg0_26)
	local var0_26 = arg0_26.curShipVO
	local var1_26 = arg0_26.curMetaCharacterVO
	local var2_26 = arg0_26:getSkillIDListForShow(var0_26.configId)

	arg0_26.skillUIItemList:make(function(arg0_27, arg1_27, arg2_27)
		if arg0_27 == UIItemList.EventUpdate then
			local var0_27 = var2_26[arg1_27 + 1]

			if var0_27 then
				arg0_26.skillBtnList[var0_27] = arg2_27

				arg0_26:updateSkillTF(arg2_27, var0_27)
			end
		end
	end)
	arg0_26.skillUIItemList:align(#var2_26)
end

function var0_0.updateSkillTF(arg0_28, arg1_28, arg2_28)
	local var0_28 = arg0_28.curShipVO
	local var1_28 = arg0_28.curMetaCharacterVO
	local var2_28 = arg1_28:Find("Skill/Icon")
	local var3_28 = arg1_28:Find("Skill/Level")
	local var4_28 = arg1_28:Find("Skill/Mask/Name")
	local var5_28 = arg1_28:Find("Skill/Arrow")
	local var6_28 = arg1_28:Find("Lock")
	local var7_28 = arg1_28:Find("Learning")
	local var8_28 = getSkillConfig(arg2_28)
	local var9_28 = var0_28:getMetaSkillLevelBySkillID(arg2_28)

	setImageSprite(var2_28, LoadSprite("skillicon/" .. var8_28.icon))
	setScrollText(var4_28, getSkillName(var8_28.id))

	if var9_28 > 0 then
		setText(var3_28, "LEVEL: " .. var9_28)
		setActive(var6_28, false)
		onButton(arg0_28, arg1_28, function()
			if not isActive(var5_28) then
				eachChild(arg0_28.skillContainer, function(arg0_30)
					local var0_30 = arg0_30:Find("Skill/Arrow")

					setActive(var0_30, false)
				end)
				setActive(var5_28, true)
				arg0_28:updateTaskPanel(arg2_28)
			end
		end, SFX_PANEL)
	else
		setText(var3_28, "LEVEL: ??")
		setActive(var6_28, true)
		onButton(arg0_28, arg1_28, function()
			arg0_28:openUnlockSkillPanel(arg2_28)
		end, SFX_PANEL)
	end
end

function var0_0.updateSkillTFLearning(arg0_32)
	local var0_32 = arg0_32.curShipVO

	for iter0_32, iter1_32 in pairs(arg0_32.skillBtnList) do
		local var1_32 = iter1_32:Find("Learning")
		local var2_32 = var0_32:isSkillLevelMax(iter0_32)
		local var3_32 = iter0_32 == arg0_32.curSkillID

		setActive(var1_32, var3_32 and not var2_32)
	end
end

function var0_0.TryPlayGuide(arg0_33)
	pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0025")
end

function var0_0.updateExpPanel(arg0_34)
	local var0_34 = arg0_34:isAllSkillLock()
	local var1_34 = arg0_34:isAllSkillMaxLevel()

	if var0_34 or var1_34 then
		setActive(arg0_34.expPanel, false)
	elseif arg0_34.curSkillID > 0 then
		setActive(arg0_34.expPanel, true)

		local var2_34 = pg.gameset.meta_skill_exp_double.key_value
		local var3_34 = pg.gameset.meta_skill_exp_max.key_value

		setText(arg0_34.expText, arg0_34.normalExpValue .. "/" .. var3_34)
		setActive(arg0_34.expDoubleTag, var2_34 > arg0_34.doubleExpValue)
	else
		setActive(arg0_34.expPanel, false)
	end
end

function var0_0.updateSkillInfoPanel(arg0_35, arg1_35)
	local var0_35 = arg0_35.curShipVO
	local var1_35 = getSkillConfig(arg1_35)

	setImageSprite(arg0_35.curSkillIcon, LoadSprite("skillicon/" .. var1_35.icon))
	setScrollText(arg0_35.curSkillNameScrollText, getSkillName(var1_35.id))

	local var2_35 = pg.skill_data_template[arg1_35].max_level
	local var3_35 = var0_35:getMetaSkillLevelBySkillID(arg1_35)
	local var4_35 = var2_35 <= var3_35

	setText(arg0_35.curSkillLevelText, var3_35)

	local var5_35 = math.min(var3_35 + 1, var2_35)

	setText(arg0_35.nextSkillLevelText, var5_35)
	setText(arg0_35.curSkillDescText, getSkillDesc(arg1_35, var0_35:getMetaSkillLevelBySkillID(arg1_35)))
	setActive(arg0_35.curSkillQuickBtn, not var4_35 and not LOCK_META_SKILL_QUICK)
	onButton(arg0_35, arg0_35.curSkillQuickBtn, function()
		arg0_35:emit(MetaCharacterTacticsMediator.ON_QUICK, arg0_35.curShipVO.id, arg1_35)
	end, SFX_PANEL)

	local var6_35 = arg0_35.skillExpTable[arg1_35] or 0

	if not var4_35 then
		local var7_35 = arg0_35:getMetaSkillTacticsConfigBySkillID(arg1_35, var3_35).need_exp

		setText(arg0_35.curSkillProgressText, var6_35 .. "/" .. var7_35)
		setSlider(arg0_35.curSkillProgressSlider, 0, var7_35, var6_35)

		if var6_35 < var7_35 then
			-- block empty
		end
	else
		setText(arg0_35.curSkillProgressText, var6_35 .. "/Max")
		setSlider(arg0_35.curSkillProgressSlider, 0, 1, 1)
	end
end

function var0_0.updateTaskListPanel(arg0_37, arg1_37)
	local var0_37 = arg0_37.curShipVO:getMetaSkillLevelBySkillID(arg1_37)
	local var1_37 = arg0_37:getMetaSkillTacticsConfigBySkillID(arg1_37, var0_37).skill_levelup_task
	local var2_37 = arg0_37:sortTaskConfig(arg1_37, var1_37)

	arg0_37.taskUIItemList:make(function(arg0_38, arg1_38, arg2_38)
		if arg0_38 == UIItemList.EventUpdate then
			local var0_38 = arg2_38:Find("Desc")
			local var1_38 = arg2_38:Find("AddExp")
			local var2_38 = arg2_38:Find("Text")

			arg1_38 = arg1_38 + 1

			local var3_38 = var2_37[arg1_38]
			local var4_38 = var3_38[1]
			local var5_38 = arg0_37:getTaskInfoBySkillAndTaskID(arg1_37, var4_38)
			local var6_38 = var5_38 and var5_38.finishCount or 0
			local var7_38 = var3_38[3]

			setText(var1_38, "+" .. var7_38)

			local var8_38 = var3_38[2]

			if var8_38 == 0 then
				setText(var2_38, var6_38 .. "/∞")
			else
				setText(var2_38, var6_38 .. "/" .. var8_38)
			end

			setText(var0_38, pg.task_meta_data_template[var4_38].desc)
		end
	end)
	arg0_37.taskUIItemList:align(#var2_37)
end

function var0_0.updateTaskPanel(arg0_39, arg1_39)
	local var0_39 = arg0_39.curShipVO
	local var1_39 = arg0_39.curMetaCharacterVO

	if var0_39:isSkillLevelMax(arg1_39) == true then
		setActive(arg0_39.studySkillTip, false)
		setActive(arg0_39.startSkillTip, false)
		setActive(arg0_39.maxSkillTip, true)
		setActive(arg0_39.skillInfoPanel, true)
		setActive(arg0_39.taskTplContainer, false)
		setActive(arg0_39.taskScrollBar, false)
		arg0_39:updateSkillInfoPanel(arg1_39)
	elseif arg1_39 ~= arg0_39.curSkillID then
		setActive(arg0_39.studySkillTip, false)
		setActive(arg0_39.startSkillTip, true)
		setActive(arg0_39.maxSkillTip, false)
		setActive(arg0_39.skillInfoPanel, true)
		setActive(arg0_39.taskTplContainer, true)
		setActive(arg0_39.taskScrollBar, true)
		arg0_39:updateSkillInfoPanel(arg1_39)
		arg0_39:updateTaskListPanel(arg1_39)
		onButton(arg0_39, arg0_39.studySkillBtn, function()
			if arg0_39.switchCountLeft == 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("meta_switch_skill_disable"))
			else
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("meta_switch_skill_box_title", getSkillName(arg1_39)),
					onYes = function()
						pg.m02:sendNotification(GAME.TACTICS_META_SWITCH_SKILL, {
							shipID = var0_39.id,
							skillID = arg1_39
						})
					end
				})
			end
		end, SFX_PANEL)
	else
		setActive(arg0_39.studySkillTip, false)
		setActive(arg0_39.startSkillTip, false)
		setActive(arg0_39.maxSkillTip, false)
		setActive(arg0_39.skillInfoPanel, true)
		setActive(arg0_39.taskTplContainer, true)
		setActive(arg0_39.taskScrollBar, true)
		arg0_39:updateSkillInfoPanel(arg1_39)
		arg0_39:updateTaskListPanel(arg1_39)
	end
end

function var0_0.updateMain(arg0_42)
	local var0_42 = arg0_42.curShipVO
	local var1_42 = arg0_42:getSkillIDListForShow(var0_42.configId)
	local var2_42 = true
	local var3_42 = 0
	local var4_42, var5_42 = arg0_42:isAllSkillLock()

	setActive(arg0_42.taskScrollTF, not var4_42)

	if var4_42 then
		setActive(arg0_42.expPanel, false)
		setActive(arg0_42.skillInfoPanel, false)
		setActive(arg0_42.taskTplContainer, false)
		setActive(arg0_42.taskScrollBar, false)
		setActive(arg0_42.studySkillTip, true)
		setActive(arg0_42.startSkillTip, false)
		setActive(arg0_42.maxSkillTip, false)
	elseif arg0_42.curUnlockSkillID then
		triggerButton(arg0_42.skillBtnList[arg0_42.curUnlockSkillID])
	elseif arg0_42.curSkillID > 0 then
		triggerButton(arg0_42.skillBtnList[arg0_42.curSkillID])
	else
		triggerButton(arg0_42.skillBtnList[var5_42])
	end
end

function var0_0.tryLearnSkillAfterFirstUnlock(arg0_43)
	local var0_43 = arg0_43.curUnlockSkillID
	local var1_43 = 1

	arg0_43:switchTacticsSkillData(var0_43, var1_43)
	arg0_43:updateExpPanel()
	arg0_43:updateTaskPanel(var0_43)
	arg0_43:updateSkillTFLearning()
	arg0_43:TryPlayGuide()
end

function var0_0.moveShipImg(arg0_44, arg1_44)
	local var0_44 = arg0_44.curMetaCharacterVO.id
	local var1_44 = MetaCharacterConst.UIConfig[var0_44]
	local var2_44 = arg1_44 and -2000 or var1_44[7]
	local var3_44 = arg1_44 and var1_44[7] or -2000

	arg0_44:managedTween(LeanTween.moveX, nil, rtf(arg0_44.shipImg), var3_44, 0.2):setFrom(var2_44)
end

function var0_0.moveRightPanel(arg0_45)
	local var0_45 = 2000
	local var1_45 = 500

	arg0_45:managedTween(LeanTween.moveX, nil, rtf(arg0_45.skillPanel), var1_45, 0.2):setFrom(var0_45)
	arg0_45:managedTween(LeanTween.moveX, nil, rtf(arg0_45.taskPanel), var1_45, 0.2):setFrom(var0_45)
end

function var0_0.openUnlockSkillPanel(arg0_46, arg1_46)
	local var0_46 = arg0_46.curShipVO
	local var1_46 = arg0_46.curMetaCharacterVO

	arg0_46.curUnlockSkillID = arg1_46

	local var2_46 = ShipGroup.getDefaultShipNameByGroupID(var1_46.id)
	local var3_46 = getSkillName(arg1_46)

	setText(arg0_46.skillUnlockPanelTipText, i18n("meta_unlock_skill_tip", var2_46, var3_46))

	local var4_46 = arg0_46:getMetaSkillTacticsConfigBySkillID(arg1_46, 1)
	local var5_46 = var4_46.skill_unlock
	local var6_46 = {
		var4_46.skill_unlock[1]
	}

	arg0_46.materialUIItemList:make(function(arg0_47, arg1_47, arg2_47)
		if arg0_47 == UIItemList.EventUpdate then
			arg1_47 = arg1_47 + 1

			local var0_47 = var6_46[arg1_47]
			local var1_47 = arg2_47:Find("Item")
			local var2_47 = arg2_47:Find("SelectedTag")
			local var3_47 = arg2_47:Find("Count/Text")
			local var4_47 = {
				type = DROP_TYPE_ITEM,
				id = var0_47[2],
				count = var0_47[3]
			}

			updateDrop(var1_47, var4_47)
			setActive(var2_47, false)

			local var5_47 = var0_47[2]
			local var6_47 = var0_47[3]
			local var7_47 = getProxy(BagProxy):getItemCountById(var5_47)
			local var8_47 = var7_47 < var6_47 and setColorStr(var7_47, COLOR_RED) or setColorStr(var7_47, COLOR_GREEN)

			setText(var3_47, var8_47 .. "/" .. var6_47)

			arg0_46.curUnlockMaterialID = var5_47
			arg0_46.curUnlockMaterialNeedCount = var6_47
		end
	end)
	arg0_46.materialUIItemList:align(#var6_46)
	setActive(arg0_46.skillUnlockPanel, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_46.skillUnlockPanel)
end

function var0_0.closeUnlockSkillPanel(arg0_48)
	arg0_48.curUnlockSkillID = nil
	arg0_48.curUnlockMaterialID = nil
	arg0_48.curUnlockMaterialNeedCount = nil

	setActive(arg0_48.skillUnlockPanel, false)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_48.skillUnlockPanel, arg0_48._tf)
end

function var0_0.enablePartialBlur(arg0_49)
	if arg0_49._tf then
		local var0_49 = {}

		table.insert(var0_49, arg0_49.taskPanel)
		table.insert(var0_49, arg0_49.skillPanel)
		arg0_49:OverlayPanel(arg0_49._tf, {
			groupDelta = -1,
			pbList = var0_49
		})
	end
end

function var0_0.disablePartialBlur(arg0_50)
	if arg0_50._tf then
		arg0_50:UnOverlayPanel(arg0_50._tf)
	end
end

function var0_0.getMetaSkillTacticsConfigBySkillID(arg0_51, arg1_51, arg2_51)
	return MetaCharacterConst.getMetaSkillTacticsConfig(arg1_51, arg2_51)
end

function var0_0.getTaskInfoBySkillAndTaskID(arg0_52, arg1_52, arg2_52)
	local var0_52 = arg0_52.taskInfoTable[arg1_52] or {}

	for iter0_52, iter1_52 in ipairs(var0_52) do
		if iter1_52.taskID == arg2_52 then
			return iter1_52
		end
	end
end

function var0_0.isAllSkillLock(arg0_53)
	local var0_53 = arg0_53.curShipVO
	local var1_53 = arg0_53:getSkillIDListForShow(var0_53.configId)
	local var2_53 = true
	local var3_53 = 0

	for iter0_53, iter1_53 in ipairs(var1_53) do
		if var0_53:getMetaSkillLevelBySkillID(iter1_53) > 0 then
			var2_53 = false
			var3_53 = iter1_53

			break
		end
	end

	return var2_53, var3_53
end

function var0_0.isAllSkillMaxLevel(arg0_54)
	local var0_54 = arg0_54.curShipVO
	local var1_54 = arg0_54:getSkillIDListForShow(var0_54.configId)
	local var2_54 = true

	for iter0_54, iter1_54 in ipairs(var1_54) do
		if not var0_54:isSkillLevelMax(iter1_54) then
			return false
		end
	end
end

function var0_0.updateTacticsRedTag(arg0_55)
	local var0_55 = arg0_55.curShipVO
	local var1_55 = var0_55:getMetaCharacter()
	local var2_55 = arg0_55:getSkillIDListForShow(var0_55.configId)
	local var3_55 = false

	for iter0_55, iter1_55 in ipairs(var2_55) do
		local var4_55 = var0_55:getMetaSkillLevelBySkillID(iter1_55)
		local var5_55 = var0_55:isSkillLevelMax(iter1_55)

		if var4_55 > 0 and not var5_55 and arg0_55:getMetaSkillTacticsConfigBySkillID(iter1_55, var4_55).need_exp <= (arg0_55.skillExpTable and arg0_55.skillExpTable[iter1_55] or 0) then
			local var6_55 = true

			break
		end
	end
end

function var0_0.sortTaskConfig(arg0_56, arg1_56, arg2_56)
	local var0_56 = Clone(arg2_56)

	table.sort(var0_56, function(arg0_57, arg1_57)
		local var0_57 = arg0_57[1]
		local var1_57 = arg1_57[1]
		local var2_57 = arg0_57[2]
		local var3_57 = arg1_57[2]
		local var4_57 = arg0_56:getTaskInfoBySkillAndTaskID(arg1_56, var0_57)
		local var5_57 = arg0_56:getTaskInfoBySkillAndTaskID(arg1_56, var1_57)
		local var6_57 = var4_57 and var4_57.finishCount or 0
		local var7_57 = var5_57 and var5_57.finishCount or 0
		local var8_57 = var2_57 > 0 and var6_57 <= var2_57
		local var9_57 = var3_57 > 0 and var7_57 <= var3_57

		if var2_57 == 0 and var3_57 == 0 then
			return var0_57 < var1_57
		elseif var2_57 == 0 then
			return true
		elseif var3_57 == 0 then
			return false
		elseif var8_57 == true and var9_57 == true then
			return var0_57 < var1_57
		elseif var8_57 == true then
			return false
		elseif var9_57 == true then
			return true
		else
			return var0_57 < var1_57
		end
	end)

	return var0_56
end

function var0_0.getSkillIDListForShow(arg0_58, arg1_58)
	return MetaCharacterConst.getTacticsSkillIDListByShipConfigID(arg1_58)
end

return var0_0
