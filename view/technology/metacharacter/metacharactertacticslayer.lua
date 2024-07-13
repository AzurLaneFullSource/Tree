local var0_0 = class("MetaCharacterTacticsLayer", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "MetaCharacterTacticsUI"
end

function var0_0.init(arg0_2)
	arg0_2:initUITextTips()
	arg0_2:initData()
	arg0_2:initUI()
	arg0_2:addListener()
end

function var0_0.didEnter(arg0_3)
	arg0_3:updateRedTag()
	arg0_3:updateShipImg()
	arg0_3:updateNamePanel()
	arg0_3:updateChar()
	arg0_3:updateSkillListPanel()
	arg0_3:enablePartialBlur()

	if arg0_3.contextData.isMainOpen then
		arg0_3.contextData.isMainOpen = nil

		arg0_3:moveShipImg(true)
	end

	arg0_3:moveRightPanel()
end

function var0_0.willExit(arg0_4)
	arg0_4:moveShipImg(false)
	arg0_4:recycleChar()
	arg0_4:disablePartialBlur()
end

function var0_0.onBackPressed(arg0_5)
	if isActive(arg0_5.skillUnlockPanel) then
		arg0_5:closeUnlockSkillPanel()

		return
	else
		arg0_5:emit(var0_0.ON_BACK_PRESSED)
	end
end

function var0_0.initUITextTips(arg0_6)
	local var0_6 = arg0_6:findTF("ExpPanel")
	local var1_6 = arg0_6:findTF("ExpEveryDay", var0_6)

	setText(var1_6, i18n("meta_exp_per_day"))

	local var2_6 = arg0_6:findTF("TaskPanel/StudySkillTip/TipText")

	setText(var2_6, i18n("meta_skill_unlock"))
end

function var0_0.initData(arg0_7)
	arg0_7.metaCharacterProxy = getProxy(MetaCharacterProxy)
	arg0_7.bayProxy = getProxy(BayProxy)
	arg0_7.shipPrefab = nil
	arg0_7.shipModel = nil
	arg0_7.curMetaShipID = arg0_7.contextData.shipID
	arg0_7.curShipVO = nil
	arg0_7.curMetaCharacterVO = nil

	arg0_7:updateData()

	arg0_7.skillBtnList = {}
	arg0_7.curUnlockSkillID = nil
	arg0_7.curUnlockMaterialID = nil
	arg0_7.curUnlockMaterialNeedCount = nil
end

function var0_0.updateData(arg0_8)
	arg0_8.curShipVO = arg0_8.bayProxy:getShipById(arg0_8.curMetaShipID)
	arg0_8.curMetaCharacterVO = arg0_8.curShipVO:getMetaCharacter()
end

function var0_0.setTacticsData(arg0_9, arg1_9)
	arg0_9.doubleExpValue = arg1_9.doubleExp
	arg0_9.normalExpValue = arg1_9.normalExp
	arg0_9.curSkillID = arg1_9.curSkillID
	arg0_9.switchCountLeft = arg1_9.switchCount
	arg0_9.taskInfoTable = arg1_9.taskInfoTable
	arg0_9.skillExpTable = arg1_9.skillExpTable
	arg1_9 = nil
end

function var0_0.switchTacticsSkillData(arg0_10, arg1_10, arg2_10)
	arg0_10.curSkillID = arg1_10
	arg0_10.switchCountLeft = arg2_10
end

function var0_0.levelupTacticsSkillData(arg0_11, arg1_11, arg2_11)
	arg0_11.skillExpTable[arg1_11] = 0
	arg0_11.switchCountLeft = arg2_11

	arg0_11:clearTaskInfo()
end

function var0_0.updateSkillExp(arg0_12, arg1_12, arg2_12)
	arg0_12.skillExpTable[arg1_12] = arg2_12
end

function var0_0.clearTaskInfo(arg0_13, arg1_13)
	arg0_13.taskInfoTable[arg1_13] = {}
end

function var0_0.initUI(arg0_14)
	arg0_14.shipImg = arg0_14:findTF("ShipImg")
	arg0_14.nameTF = arg0_14:findTF("NamePanel")
	arg0_14.nameScrollText = arg0_14:findTF("NameMask/NameText", arg0_14.nameTF)
	arg0_14.shipTypeImg = arg0_14:findTF("TypeImg", arg0_14.nameTF)
	arg0_14.enNameText = arg0_14:findTF("NameENText", arg0_14.nameTF)

	local var0_14 = arg0_14:findTF("StarTpl", arg0_14.nameTF)
	local var1_14 = arg0_14:findTF("StarContainer", arg0_14.nameTF)

	arg0_14.nameTFStarUIList = UIItemList.New(var1_14, var0_14)
	arg0_14.expPanel = arg0_14:findTF("ExpPanel")
	arg0_14.expText = arg0_14:findTF("ExpText", arg0_14.expPanel)
	arg0_14.expDoubleTag = arg0_14:findTF("DoubleTag", arg0_14.expText)
	arg0_14.taskPanel = arg0_14:findTF("TaskPanel")
	arg0_14.qCharContainer = arg0_14:findTF("QChar", arg0_14.taskPanel)
	arg0_14.taskTpl = arg0_14:findTF("TaskTpl", arg0_14.taskPanel)
	arg0_14.taskScrollTF = arg0_14:findTF("ScrollView", arg0_14.taskPanel)
	arg0_14.taskTplContainer = arg0_14:findTF("ScrollView/Viewport/Content", arg0_14.taskPanel)
	arg0_14.taskScrollBar = arg0_14:findTF("ScrollView/Scrollbar Vertical", arg0_14.taskPanel)
	arg0_14.taskUIItemList = UIItemList.New(arg0_14.taskTplContainer, arg0_14.taskTpl)
	arg0_14.skillInfoPanel = arg0_14:findTF("SkillInfo", arg0_14.taskPanel)
	arg0_14.curSkillIcon = arg0_14:findTF("Skill/Icon", arg0_14.skillInfoPanel)
	arg0_14.curSkillNameScrollText = arg0_14:findTF("NameMask/Name", arg0_14.skillInfoPanel)
	arg0_14.curSkillLevelText = arg0_14:findTF("LevelInfo/CurLevel", arg0_14.skillInfoPanel)
	arg0_14.nextSkillLevelText = arg0_14:findTF("LevelInfo/NextLevel", arg0_14.skillInfoPanel)
	arg0_14.curSkillDescText = arg0_14:findTF("DescView/Viewport/SkillDesc", arg0_14.skillInfoPanel)
	arg0_14.curSkillProgressText = arg0_14:findTF("ExpProgress/Text", arg0_14.skillInfoPanel)
	arg0_14.curSkillProgressSlider = arg0_14:findTF("ExpSlider", arg0_14.skillInfoPanel)
	arg0_14.curSkillQuickBtn = arg0_14:findTF("QuickBtn", arg0_14.skillInfoPanel)
	arg0_14.studySkillTip = arg0_14:findTF("StudySkillTip", arg0_14.taskPanel)
	arg0_14.startSkillTip = arg0_14:findTF("StartLearn", arg0_14.taskPanel)
	arg0_14.maxSkillTip = arg0_14:findTF("SkillMax", arg0_14.taskPanel)
	arg0_14.studySkillBtn = arg0_14:findTF("StartLearnBtn", arg0_14.startSkillTip)
	arg0_14.skillPanel = arg0_14:findTF("SkillPanel")
	arg0_14.skillTpl = arg0_14:findTF("SkillTpl", arg0_14.skillPanel)
	arg0_14.skillContainer = arg0_14:findTF("Skills/Content", arg0_14.skillPanel)
	arg0_14.skillUIItemList = UIItemList.New(arg0_14.skillContainer, arg0_14.skillTpl)
	arg0_14.skillUnlockPanel = arg0_14:findTF("SkillLearnBox")
	arg0_14.skillUnlockPanelBG = arg0_14:findTF("BG", arg0_14.skillUnlockPanel)
	arg0_14.skillUnlockPanelTipText = arg0_14:findTF("Box/TipText", arg0_14.skillUnlockPanel)
	arg0_14.skillUnlockPanelCancelBtn = arg0_14:findTF("Box/Btns/CancenBtn", arg0_14.skillUnlockPanel)
	arg0_14.skillUnlockPanelConfirmBtn = arg0_14:findTF("Box/Btns/ConfirmBtn", arg0_14.skillUnlockPanel)
	arg0_14.materialTpl = arg0_14:findTF("Box/Material", arg0_14.skillUnlockPanel)
	arg0_14.materialTplContainer = arg0_14:findTF("Box/MaterialContainer", arg0_14.skillUnlockPanel)
	arg0_14.materialUIItemList = UIItemList.New(arg0_14.materialTplContainer, arg0_14.materialTpl)
end

function var0_0.addListener(arg0_15)
	onButton(arg0_15, arg0_15.skillUnlockPanelBG, function()
		arg0_15:closeUnlockSkillPanel()
	end, SFX_PANEL)
	onButton(arg0_15, arg0_15.skillUnlockPanelCancelBtn, function()
		arg0_15:closeUnlockSkillPanel()
	end, SFX_PANEL)
	onButton(arg0_15, arg0_15.skillUnlockPanelConfirmBtn, function()
		if not arg0_15.curUnlockMaterialID then
			pg.TipsMgr.GetInstance():ShowTips(i18n("meta_unlock_skill_select"))

			return
		elseif getProxy(BagProxy):getItemCountById(arg0_15.curUnlockMaterialID) < arg0_15.curUnlockMaterialNeedCount then
			pg.TipsMgr.GetInstance():ShowTips(i18n("word_materal_no_enough"))
		else
			local var0_18 = 0
			local var1_18 = 0
			local var2_18 = arg0_15:getMetaSkillTacticsConfigBySkillID(arg0_15.curUnlockSkillID, 1).skill_unlock

			for iter0_18, iter1_18 in ipairs(var2_18) do
				if arg0_15.curUnlockMaterialID == iter1_18[2] then
					var0_18 = iter0_18
					var1_18 = iter1_18[3]

					break
				end
			end

			pg.m02:sendNotification(GAME.TACTICS_META_UNLOCK_SKILL, {
				shipID = arg0_15.curMetaShipID,
				skillID = arg0_15.curUnlockSkillID,
				materialIndex = var0_18,
				materialInfo = {
					id = arg0_15.curUnlockMaterialID,
					count = var1_18
				}
			})
		end
	end, SFX_PANEL)
end

function var0_0.updateRedTag(arg0_19)
	arg0_19.metaCharacterProxy:updateRedTag(arg0_19.curMetaCharacterVO.id)
end

function var0_0.updateShipImg(arg0_20)
	local var0_20, var1_20 = MetaCharacterConst.GetMetaCharacterPaintPath(arg0_20.curMetaCharacterVO.id, true)

	setImageSprite(arg0_20.shipImg, LoadSprite(var0_20, var1_20), true)

	local var2_20 = arg0_20.curMetaCharacterVO.id
	local var3_20 = MetaCharacterConst.UIConfig[var2_20]

	setLocalPosition(arg0_20.shipImg, {
		x = var3_20[7],
		y = var3_20[8]
	})
	setLocalScale(arg0_20.shipImg, {
		x = var3_20[3],
		y = var3_20[4]
	})
end

function var0_0.updateNamePanel(arg0_21)
	local var0_21 = arg0_21.curShipVO
	local var1_21 = arg0_21.curMetaCharacterVO
	local var2_21 = var0_21:getName()

	setScrollText(arg0_21.nameScrollText, var2_21)

	local var3_21 = var0_21:getShipType()

	setImageSprite(arg0_21.shipTypeImg, LoadSprite("shiptype", var3_21))

	local var4_21 = var0_21:getConfig("english_name")

	setText(arg0_21.enNameText, var4_21)

	local var5_21 = var0_21:getMaxStar()
	local var6_21 = var0_21:getStar()

	arg0_21.nameTFStarUIList:make(function(arg0_22, arg1_22, arg2_22)
		if arg0_22 == UIItemList.EventUpdate then
			local var0_22 = arg0_21:findTF("empty", arg2_22)
			local var1_22 = arg0_21:findTF("on", arg2_22)

			arg1_22 = arg1_22 + 1

			setActive(var1_22, arg1_22 <= var6_21)
		end
	end)
	arg0_21.nameTFStarUIList:align(var5_21)
end

function var0_0.updateChar(arg0_23)
	return
end

function var0_0.recycleChar(arg0_24)
	if arg0_24.shipPrefab and arg0_24.shipModel then
		PoolMgr.GetInstance():ReturnSpineChar(arg0_24.shipPrefab, arg0_24.shipModel)

		arg0_24.shipPrefab = nil
		arg0_24.shipModel = nil
	end
end

function var0_0.updateSkillListPanel(arg0_25)
	local var0_25 = arg0_25.curShipVO
	local var1_25 = arg0_25.curMetaCharacterVO
	local var2_25 = arg0_25:getSkillIDListForShow(var0_25.configId)

	arg0_25.skillUIItemList:make(function(arg0_26, arg1_26, arg2_26)
		if arg0_26 == UIItemList.EventUpdate then
			local var0_26 = var2_25[arg1_26 + 1]

			if var0_26 then
				arg0_25.skillBtnList[var0_26] = arg2_26

				arg0_25:updateSkillTF(arg2_26, var0_26)
			end
		end
	end)
	arg0_25.skillUIItemList:align(#var2_25)
end

function var0_0.updateSkillTF(arg0_27, arg1_27, arg2_27)
	local var0_27 = arg0_27.curShipVO
	local var1_27 = arg0_27.curMetaCharacterVO
	local var2_27 = arg0_27:findTF("Skill/Icon", arg1_27)
	local var3_27 = arg0_27:findTF("Skill/Level", arg1_27)
	local var4_27 = arg0_27:findTF("Skill/Mask/Name", arg1_27)
	local var5_27 = arg0_27:findTF("Skill/Arrow", arg1_27)
	local var6_27 = arg0_27:findTF("Lock", arg1_27)
	local var7_27 = arg0_27:findTF("Learning", arg1_27)
	local var8_27 = getSkillConfig(arg2_27)
	local var9_27 = var0_27:getMetaSkillLevelBySkillID(arg2_27)

	setImageSprite(var2_27, LoadSprite("skillicon/" .. var8_27.icon))
	setScrollText(var4_27, getSkillName(var8_27.id))

	if var9_27 > 0 then
		setText(var3_27, "LEVEL: " .. var9_27)
		setActive(var6_27, false)
		onButton(arg0_27, arg1_27, function()
			if not isActive(var5_27) then
				eachChild(arg0_27.skillContainer, function(arg0_29)
					local var0_29 = arg0_27:findTF("Skill/Arrow", arg0_29)

					setActive(var0_29, false)
				end)
				setActive(var5_27, true)
				arg0_27:updateTaskPanel(arg2_27)
			end
		end, SFX_PANEL)
	else
		setText(var3_27, "LEVEL: ??")
		setActive(var6_27, true)
		onButton(arg0_27, arg1_27, function()
			arg0_27:openUnlockSkillPanel(arg2_27)
		end, SFX_PANEL)
	end
end

function var0_0.updateSkillTFLearning(arg0_31)
	local var0_31 = arg0_31.curShipVO

	for iter0_31, iter1_31 in pairs(arg0_31.skillBtnList) do
		local var1_31 = arg0_31:findTF("Learning", iter1_31)
		local var2_31 = var0_31:isSkillLevelMax(iter0_31)
		local var3_31 = iter0_31 == arg0_31.curSkillID

		setActive(var1_31, var3_31 and not var2_31)
	end
end

function var0_0.TryPlayGuide(arg0_32)
	pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0025")
end

function var0_0.updateExpPanel(arg0_33)
	local var0_33 = arg0_33:isAllSkillLock()
	local var1_33 = arg0_33:isAllSkillMaxLevel()

	if var0_33 or var1_33 then
		setActive(arg0_33.expPanel, false)
	elseif arg0_33.curSkillID > 0 then
		setActive(arg0_33.expPanel, true)

		local var2_33 = pg.gameset.meta_skill_exp_double.key_value
		local var3_33 = pg.gameset.meta_skill_exp_max.key_value

		setText(arg0_33.expText, arg0_33.normalExpValue .. "/" .. var3_33)
		setActive(arg0_33.expDoubleTag, var2_33 > arg0_33.doubleExpValue)
	else
		setActive(arg0_33.expPanel, false)
	end
end

function var0_0.updateSkillInfoPanel(arg0_34, arg1_34)
	local var0_34 = arg0_34.curShipVO
	local var1_34 = getSkillConfig(arg1_34)

	setImageSprite(arg0_34.curSkillIcon, LoadSprite("skillicon/" .. var1_34.icon))
	setScrollText(arg0_34.curSkillNameScrollText, getSkillName(var1_34.id))

	local var2_34 = pg.skill_data_template[arg1_34].max_level
	local var3_34 = var0_34:getMetaSkillLevelBySkillID(arg1_34)
	local var4_34 = var2_34 <= var3_34

	setText(arg0_34.curSkillLevelText, var3_34)

	local var5_34 = math.min(var3_34 + 1, var2_34)

	setText(arg0_34.nextSkillLevelText, var5_34)
	setText(arg0_34.curSkillDescText, getSkillDesc(arg1_34, var0_34:getMetaSkillLevelBySkillID(arg1_34)))
	setActive(arg0_34.curSkillQuickBtn, not var4_34 and not LOCK_META_SKILL_QUICK)
	onButton(arg0_34, arg0_34.curSkillQuickBtn, function()
		arg0_34:emit(MetaCharacterTacticsMediator.ON_QUICK, arg0_34.curShipVO.id, arg1_34)
	end, SFX_PANEL)

	local var6_34 = arg0_34.skillExpTable[arg1_34] or 0

	if not var4_34 then
		local var7_34 = arg0_34:getMetaSkillTacticsConfigBySkillID(arg1_34, var3_34).need_exp

		setText(arg0_34.curSkillProgressText, var6_34 .. "/" .. var7_34)
		setSlider(arg0_34.curSkillProgressSlider, 0, var7_34, var6_34)

		if var6_34 < var7_34 then
			-- block empty
		end
	else
		setText(arg0_34.curSkillProgressText, var6_34 .. "/Max")
		setSlider(arg0_34.curSkillProgressSlider, 0, 1, 1)
	end
end

function var0_0.updateTaskListPanel(arg0_36, arg1_36)
	local var0_36 = arg0_36.curShipVO:getMetaSkillLevelBySkillID(arg1_36)
	local var1_36 = arg0_36:getMetaSkillTacticsConfigBySkillID(arg1_36, var0_36).skill_levelup_task
	local var2_36 = arg0_36:sortTaskConfig(arg1_36, var1_36)

	arg0_36.taskUIItemList:make(function(arg0_37, arg1_37, arg2_37)
		if arg0_37 == UIItemList.EventUpdate then
			local var0_37 = arg0_36:findTF("Desc", arg2_37)
			local var1_37 = arg0_36:findTF("AddExp", arg2_37)
			local var2_37 = arg0_36:findTF("Text", arg2_37)

			arg1_37 = arg1_37 + 1

			local var3_37 = var2_36[arg1_37]
			local var4_37 = var3_37[1]
			local var5_37 = arg0_36:getTaskInfoBySkillAndTaskID(arg1_36, var4_37)
			local var6_37 = var5_37 and var5_37.finishCount or 0
			local var7_37 = var3_37[3]

			setText(var1_37, "+" .. var7_37)

			local var8_37 = var3_37[2]

			if var8_37 == 0 then
				setText(var2_37, var6_37 .. "/∞")
			else
				setText(var2_37, var6_37 .. "/" .. var8_37)
			end

			setText(var0_37, pg.task_meta_data_template[var4_37].desc)
		end
	end)
	arg0_36.taskUIItemList:align(#var2_36)
end

function var0_0.updateTaskPanel(arg0_38, arg1_38)
	local var0_38 = arg0_38.curShipVO
	local var1_38 = arg0_38.curMetaCharacterVO

	if var0_38:isSkillLevelMax(arg1_38) == true then
		setActive(arg0_38.studySkillTip, false)
		setActive(arg0_38.startSkillTip, false)
		setActive(arg0_38.maxSkillTip, true)
		setActive(arg0_38.skillInfoPanel, true)
		setActive(arg0_38.taskTplContainer, false)
		setActive(arg0_38.taskScrollBar, false)
		arg0_38:updateSkillInfoPanel(arg1_38)
	elseif arg1_38 ~= arg0_38.curSkillID then
		setActive(arg0_38.studySkillTip, false)
		setActive(arg0_38.startSkillTip, true)
		setActive(arg0_38.maxSkillTip, false)
		setActive(arg0_38.skillInfoPanel, true)
		setActive(arg0_38.taskTplContainer, true)
		setActive(arg0_38.taskScrollBar, true)
		arg0_38:updateSkillInfoPanel(arg1_38)
		arg0_38:updateTaskListPanel(arg1_38)
		onButton(arg0_38, arg0_38.studySkillBtn, function()
			if arg0_38.switchCountLeft == 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("meta_switch_skill_disable"))
			else
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("meta_switch_skill_box_title", getSkillName(arg1_38)),
					onYes = function()
						pg.m02:sendNotification(GAME.TACTICS_META_SWITCH_SKILL, {
							shipID = var0_38.id,
							skillID = arg1_38
						})
					end,
					weight = LayerWeightConst.TOP_LAYER
				})
			end
		end, SFX_PANEL)
	else
		setActive(arg0_38.studySkillTip, false)
		setActive(arg0_38.startSkillTip, false)
		setActive(arg0_38.maxSkillTip, false)
		setActive(arg0_38.skillInfoPanel, true)
		setActive(arg0_38.taskTplContainer, true)
		setActive(arg0_38.taskScrollBar, true)
		arg0_38:updateSkillInfoPanel(arg1_38)
		arg0_38:updateTaskListPanel(arg1_38)
	end
end

function var0_0.updateMain(arg0_41)
	local var0_41 = arg0_41.curShipVO
	local var1_41 = arg0_41:getSkillIDListForShow(var0_41.configId)
	local var2_41 = true
	local var3_41 = 0
	local var4_41, var5_41 = arg0_41:isAllSkillLock()

	setActive(arg0_41.taskScrollTF, not var4_41)

	if var4_41 then
		setActive(arg0_41.expPanel, false)
		setActive(arg0_41.skillInfoPanel, false)
		setActive(arg0_41.taskTplContainer, false)
		setActive(arg0_41.taskScrollBar, false)
		setActive(arg0_41.studySkillTip, true)
		setActive(arg0_41.startSkillTip, false)
		setActive(arg0_41.maxSkillTip, false)
	elseif arg0_41.curUnlockSkillID then
		triggerButton(arg0_41.skillBtnList[arg0_41.curUnlockSkillID])
	elseif arg0_41.curSkillID > 0 then
		triggerButton(arg0_41.skillBtnList[arg0_41.curSkillID])
	else
		triggerButton(arg0_41.skillBtnList[var5_41])
	end
end

function var0_0.tryLearnSkillAfterFirstUnlock(arg0_42)
	local var0_42 = arg0_42.curUnlockSkillID
	local var1_42 = 1

	arg0_42:switchTacticsSkillData(var0_42, var1_42)
	arg0_42:updateExpPanel()
	arg0_42:updateTaskPanel(var0_42)
	arg0_42:updateSkillTFLearning()
	arg0_42:TryPlayGuide()
end

function var0_0.moveShipImg(arg0_43, arg1_43)
	local var0_43 = arg0_43.curMetaCharacterVO.id
	local var1_43 = MetaCharacterConst.UIConfig[var0_43]
	local var2_43 = arg1_43 and -2000 or var1_43[7]
	local var3_43 = arg1_43 and var1_43[7] or -2000

	arg0_43:managedTween(LeanTween.moveX, nil, rtf(arg0_43.shipImg), var3_43, 0.2):setFrom(var2_43)
end

function var0_0.moveRightPanel(arg0_44)
	local var0_44 = 2000
	local var1_44 = 500

	arg0_44:managedTween(LeanTween.moveX, nil, rtf(arg0_44.skillPanel), var1_44, 0.2):setFrom(var0_44)
	arg0_44:managedTween(LeanTween.moveX, nil, rtf(arg0_44.taskPanel), var1_44, 0.2):setFrom(var0_44)
end

function var0_0.openUnlockSkillPanel(arg0_45, arg1_45)
	local var0_45 = arg0_45.curShipVO
	local var1_45 = arg0_45.curMetaCharacterVO

	arg0_45.curUnlockSkillID = arg1_45

	local var2_45 = ShipGroup.getDefaultShipNameByGroupID(var1_45.id)
	local var3_45 = getSkillName(arg1_45)

	setText(arg0_45.skillUnlockPanelTipText, i18n("meta_unlock_skill_tip", var2_45, var3_45))

	local var4_45 = arg0_45:getMetaSkillTacticsConfigBySkillID(arg1_45, 1)
	local var5_45 = var4_45.skill_unlock
	local var6_45 = {
		var4_45.skill_unlock[1]
	}

	arg0_45.materialUIItemList:make(function(arg0_46, arg1_46, arg2_46)
		if arg0_46 == UIItemList.EventUpdate then
			arg1_46 = arg1_46 + 1

			local var0_46 = var6_45[arg1_46]
			local var1_46 = arg0_45:findTF("Item", arg2_46)
			local var2_46 = arg0_45:findTF("SelectedTag", arg2_46)
			local var3_46 = arg0_45:findTF("Count/Text", arg2_46)
			local var4_46 = {
				type = DROP_TYPE_ITEM,
				id = var0_46[2],
				count = var0_46[3]
			}

			updateDrop(var1_46, var4_46)
			setActive(var2_46, false)

			local var5_46 = var0_46[2]
			local var6_46 = var0_46[3]
			local var7_46 = getProxy(BagProxy):getItemCountById(var5_46)
			local var8_46 = var7_46 < var6_46 and setColorStr(var7_46, COLOR_RED) or setColorStr(var7_46, COLOR_GREEN)

			setText(var3_46, var8_46 .. "/" .. var6_46)

			arg0_45.curUnlockMaterialID = var5_46
			arg0_45.curUnlockMaterialNeedCount = var6_46
		end
	end)
	arg0_45.materialUIItemList:align(#var6_45)
	setActive(arg0_45.skillUnlockPanel, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_45.skillUnlockPanel, false, {
		weight = LayerWeightConst.TOP_LAYER
	})
end

function var0_0.closeUnlockSkillPanel(arg0_47)
	arg0_47.curUnlockSkillID = nil
	arg0_47.curUnlockMaterialID = nil
	arg0_47.curUnlockMaterialNeedCount = nil

	setActive(arg0_47.skillUnlockPanel, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_47.skillUnlockPanel, arg0_47._tf)
end

function var0_0.enablePartialBlur(arg0_48)
	if arg0_48._tf then
		local var0_48 = {}

		table.insert(var0_48, arg0_48.taskPanel)
		table.insert(var0_48, arg0_48.skillPanel)
		pg.UIMgr.GetInstance():OverlayPanelPB(arg0_48._tf, {
			pbList = var0_48,
			groupName = LayerWeightConst.GROUP_META,
			weight = LayerWeightConst.BASE_LAYER - 1
		})
	end
end

function var0_0.disablePartialBlur(arg0_49)
	if arg0_49._tf then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_49._tf)
	end
end

function var0_0.getMetaSkillTacticsConfigBySkillID(arg0_50, arg1_50, arg2_50)
	return MetaCharacterConst.getMetaSkillTacticsConfig(arg1_50, arg2_50)
end

function var0_0.getTaskInfoBySkillAndTaskID(arg0_51, arg1_51, arg2_51)
	local var0_51 = arg0_51.taskInfoTable[arg1_51] or {}

	for iter0_51, iter1_51 in ipairs(var0_51) do
		if iter1_51.taskID == arg2_51 then
			return iter1_51
		end
	end
end

function var0_0.isAllSkillLock(arg0_52)
	local var0_52 = arg0_52.curShipVO
	local var1_52 = arg0_52:getSkillIDListForShow(var0_52.configId)
	local var2_52 = true
	local var3_52 = 0

	for iter0_52, iter1_52 in ipairs(var1_52) do
		if var0_52:getMetaSkillLevelBySkillID(iter1_52) > 0 then
			var2_52 = false
			var3_52 = iter1_52

			break
		end
	end

	return var2_52, var3_52
end

function var0_0.isAllSkillMaxLevel(arg0_53)
	local var0_53 = arg0_53.curShipVO
	local var1_53 = arg0_53:getSkillIDListForShow(var0_53.configId)
	local var2_53 = true

	for iter0_53, iter1_53 in ipairs(var1_53) do
		if not var0_53:isSkillLevelMax(iter1_53) then
			return false
		end
	end
end

function var0_0.updateTacticsRedTag(arg0_54)
	local var0_54 = arg0_54.curShipVO
	local var1_54 = var0_54:getMetaCharacter()
	local var2_54 = arg0_54:getSkillIDListForShow(var0_54.configId)
	local var3_54 = false

	for iter0_54, iter1_54 in ipairs(var2_54) do
		local var4_54 = var0_54:getMetaSkillLevelBySkillID(iter1_54)
		local var5_54 = var0_54:isSkillLevelMax(iter1_54)

		if var4_54 > 0 and not var5_54 and arg0_54:getMetaSkillTacticsConfigBySkillID(iter1_54, var4_54).need_exp <= (arg0_54.skillExpTable and arg0_54.skillExpTable[iter1_54] or 0) then
			local var6_54 = true

			break
		end
	end
end

function var0_0.sortTaskConfig(arg0_55, arg1_55, arg2_55)
	local var0_55 = Clone(arg2_55)

	table.sort(var0_55, function(arg0_56, arg1_56)
		local var0_56 = arg0_56[1]
		local var1_56 = arg1_56[1]
		local var2_56 = arg0_56[2]
		local var3_56 = arg1_56[2]
		local var4_56 = arg0_55:getTaskInfoBySkillAndTaskID(arg1_55, var0_56)
		local var5_56 = arg0_55:getTaskInfoBySkillAndTaskID(arg1_55, var1_56)
		local var6_56 = var4_56 and var4_56.finishCount or 0
		local var7_56 = var5_56 and var5_56.finishCount or 0
		local var8_56 = var2_56 > 0 and var6_56 <= var2_56
		local var9_56 = var3_56 > 0 and var7_56 <= var3_56

		if var2_56 == 0 and var3_56 == 0 then
			return var0_56 < var1_56
		elseif var2_56 == 0 then
			return true
		elseif var3_56 == 0 then
			return false
		elseif var8_56 == true and var9_56 == true then
			return var0_56 < var1_56
		elseif var8_56 == true then
			return false
		elseif var9_56 == true then
			return true
		else
			return var0_56 < var1_56
		end
	end)

	return var0_55
end

function var0_0.getSkillIDListForShow(arg0_57, arg1_57)
	return MetaCharacterConst.getTacticsSkillIDListByShipConfigID(arg1_57)
end

return var0_0
