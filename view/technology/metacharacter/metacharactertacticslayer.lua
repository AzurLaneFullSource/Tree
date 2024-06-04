local var0 = class("MetaCharacterTacticsLayer", import("...base.BaseUI"))

function var0.getUIName(arg0)
	return "MetaCharacterTacticsUI"
end

function var0.init(arg0)
	arg0:initUITextTips()
	arg0:initData()
	arg0:initUI()
	arg0:addListener()
end

function var0.didEnter(arg0)
	arg0:updateRedTag()
	arg0:updateShipImg()
	arg0:updateNamePanel()
	arg0:updateChar()
	arg0:updateSkillListPanel()
	arg0:enablePartialBlur()

	if arg0.contextData.isMainOpen then
		arg0.contextData.isMainOpen = nil

		arg0:moveShipImg(true)
	end

	arg0:moveRightPanel()
end

function var0.willExit(arg0)
	arg0:moveShipImg(false)
	arg0:recycleChar()
	arg0:disablePartialBlur()
end

function var0.onBackPressed(arg0)
	if isActive(arg0.skillUnlockPanel) then
		arg0:closeUnlockSkillPanel()

		return
	else
		arg0:emit(var0.ON_BACK_PRESSED)
	end
end

function var0.initUITextTips(arg0)
	local var0 = arg0:findTF("ExpPanel")
	local var1 = arg0:findTF("ExpEveryDay", var0)

	setText(var1, i18n("meta_exp_per_day"))

	local var2 = arg0:findTF("TaskPanel/StudySkillTip/TipText")

	setText(var2, i18n("meta_skill_unlock"))
end

function var0.initData(arg0)
	arg0.metaCharacterProxy = getProxy(MetaCharacterProxy)
	arg0.bayProxy = getProxy(BayProxy)
	arg0.shipPrefab = nil
	arg0.shipModel = nil
	arg0.curMetaShipID = arg0.contextData.shipID
	arg0.curShipVO = nil
	arg0.curMetaCharacterVO = nil

	arg0:updateData()

	arg0.skillBtnList = {}
	arg0.curUnlockSkillID = nil
	arg0.curUnlockMaterialID = nil
	arg0.curUnlockMaterialNeedCount = nil
end

function var0.updateData(arg0)
	arg0.curShipVO = arg0.bayProxy:getShipById(arg0.curMetaShipID)
	arg0.curMetaCharacterVO = arg0.curShipVO:getMetaCharacter()
end

function var0.setTacticsData(arg0, arg1)
	arg0.doubleExpValue = arg1.doubleExp
	arg0.normalExpValue = arg1.normalExp
	arg0.curSkillID = arg1.curSkillID
	arg0.switchCountLeft = arg1.switchCount
	arg0.taskInfoTable = arg1.taskInfoTable
	arg0.skillExpTable = arg1.skillExpTable
	arg1 = nil
end

function var0.switchTacticsSkillData(arg0, arg1, arg2)
	arg0.curSkillID = arg1
	arg0.switchCountLeft = arg2
end

function var0.levelupTacticsSkillData(arg0, arg1, arg2)
	arg0.skillExpTable[arg1] = 0
	arg0.switchCountLeft = arg2

	arg0:clearTaskInfo()
end

function var0.updateSkillExp(arg0, arg1, arg2)
	arg0.skillExpTable[arg1] = arg2
end

function var0.clearTaskInfo(arg0, arg1)
	arg0.taskInfoTable[arg1] = {}
end

function var0.initUI(arg0)
	arg0.shipImg = arg0:findTF("ShipImg")
	arg0.nameTF = arg0:findTF("NamePanel")
	arg0.nameScrollText = arg0:findTF("NameMask/NameText", arg0.nameTF)
	arg0.shipTypeImg = arg0:findTF("TypeImg", arg0.nameTF)
	arg0.enNameText = arg0:findTF("NameENText", arg0.nameTF)

	local var0 = arg0:findTF("StarTpl", arg0.nameTF)
	local var1 = arg0:findTF("StarContainer", arg0.nameTF)

	arg0.nameTFStarUIList = UIItemList.New(var1, var0)
	arg0.expPanel = arg0:findTF("ExpPanel")
	arg0.expText = arg0:findTF("ExpText", arg0.expPanel)
	arg0.expDoubleTag = arg0:findTF("DoubleTag", arg0.expText)
	arg0.taskPanel = arg0:findTF("TaskPanel")
	arg0.qCharContainer = arg0:findTF("QChar", arg0.taskPanel)
	arg0.taskTpl = arg0:findTF("TaskTpl", arg0.taskPanel)
	arg0.taskScrollTF = arg0:findTF("ScrollView", arg0.taskPanel)
	arg0.taskTplContainer = arg0:findTF("ScrollView/Viewport/Content", arg0.taskPanel)
	arg0.taskScrollBar = arg0:findTF("ScrollView/Scrollbar Vertical", arg0.taskPanel)
	arg0.taskUIItemList = UIItemList.New(arg0.taskTplContainer, arg0.taskTpl)
	arg0.skillInfoPanel = arg0:findTF("SkillInfo", arg0.taskPanel)
	arg0.curSkillIcon = arg0:findTF("Skill/Icon", arg0.skillInfoPanel)
	arg0.curSkillNameScrollText = arg0:findTF("NameMask/Name", arg0.skillInfoPanel)
	arg0.curSkillLevelText = arg0:findTF("LevelInfo/CurLevel", arg0.skillInfoPanel)
	arg0.nextSkillLevelText = arg0:findTF("LevelInfo/NextLevel", arg0.skillInfoPanel)
	arg0.curSkillDescText = arg0:findTF("DescView/Viewport/SkillDesc", arg0.skillInfoPanel)
	arg0.curSkillProgressText = arg0:findTF("ExpProgress/Text", arg0.skillInfoPanel)
	arg0.curSkillProgressSlider = arg0:findTF("ExpSlider", arg0.skillInfoPanel)
	arg0.curSkillQuickBtn = arg0:findTF("QuickBtn", arg0.skillInfoPanel)
	arg0.studySkillTip = arg0:findTF("StudySkillTip", arg0.taskPanel)
	arg0.startSkillTip = arg0:findTF("StartLearn", arg0.taskPanel)
	arg0.maxSkillTip = arg0:findTF("SkillMax", arg0.taskPanel)
	arg0.studySkillBtn = arg0:findTF("StartLearnBtn", arg0.startSkillTip)
	arg0.skillPanel = arg0:findTF("SkillPanel")
	arg0.skillTpl = arg0:findTF("SkillTpl", arg0.skillPanel)
	arg0.skillContainer = arg0:findTF("Skills/Content", arg0.skillPanel)
	arg0.skillUIItemList = UIItemList.New(arg0.skillContainer, arg0.skillTpl)
	arg0.skillUnlockPanel = arg0:findTF("SkillLearnBox")
	arg0.skillUnlockPanelBG = arg0:findTF("BG", arg0.skillUnlockPanel)
	arg0.skillUnlockPanelTipText = arg0:findTF("Box/TipText", arg0.skillUnlockPanel)
	arg0.skillUnlockPanelCancelBtn = arg0:findTF("Box/Btns/CancenBtn", arg0.skillUnlockPanel)
	arg0.skillUnlockPanelConfirmBtn = arg0:findTF("Box/Btns/ConfirmBtn", arg0.skillUnlockPanel)
	arg0.materialTpl = arg0:findTF("Box/Material", arg0.skillUnlockPanel)
	arg0.materialTplContainer = arg0:findTF("Box/MaterialContainer", arg0.skillUnlockPanel)
	arg0.materialUIItemList = UIItemList.New(arg0.materialTplContainer, arg0.materialTpl)
end

function var0.addListener(arg0)
	onButton(arg0, arg0.skillUnlockPanelBG, function()
		arg0:closeUnlockSkillPanel()
	end, SFX_PANEL)
	onButton(arg0, arg0.skillUnlockPanelCancelBtn, function()
		arg0:closeUnlockSkillPanel()
	end, SFX_PANEL)
	onButton(arg0, arg0.skillUnlockPanelConfirmBtn, function()
		if not arg0.curUnlockMaterialID then
			pg.TipsMgr.GetInstance():ShowTips(i18n("meta_unlock_skill_select"))

			return
		elseif getProxy(BagProxy):getItemCountById(arg0.curUnlockMaterialID) < arg0.curUnlockMaterialNeedCount then
			pg.TipsMgr.GetInstance():ShowTips(i18n("word_materal_no_enough"))
		else
			local var0 = 0
			local var1 = 0
			local var2 = arg0:getMetaSkillTacticsConfigBySkillID(arg0.curUnlockSkillID, 1).skill_unlock

			for iter0, iter1 in ipairs(var2) do
				if arg0.curUnlockMaterialID == iter1[2] then
					var0 = iter0
					var1 = iter1[3]

					break
				end
			end

			pg.m02:sendNotification(GAME.TACTICS_META_UNLOCK_SKILL, {
				shipID = arg0.curMetaShipID,
				skillID = arg0.curUnlockSkillID,
				materialIndex = var0,
				materialInfo = {
					id = arg0.curUnlockMaterialID,
					count = var1
				}
			})
		end
	end, SFX_PANEL)
end

function var0.updateRedTag(arg0)
	arg0.metaCharacterProxy:updateRedTag(arg0.curMetaCharacterVO.id)
end

function var0.updateShipImg(arg0)
	local var0, var1 = MetaCharacterConst.GetMetaCharacterPaintPath(arg0.curMetaCharacterVO.id, true)

	setImageSprite(arg0.shipImg, LoadSprite(var0, var1), true)

	local var2 = arg0.curMetaCharacterVO.id
	local var3 = MetaCharacterConst.UIConfig[var2]

	setLocalPosition(arg0.shipImg, {
		x = var3[7],
		y = var3[8]
	})
	setLocalScale(arg0.shipImg, {
		x = var3[3],
		y = var3[4]
	})
end

function var0.updateNamePanel(arg0)
	local var0 = arg0.curShipVO
	local var1 = arg0.curMetaCharacterVO
	local var2 = var0:getName()

	setScrollText(arg0.nameScrollText, var2)

	local var3 = var0:getShipType()

	setImageSprite(arg0.shipTypeImg, LoadSprite("shiptype", var3))

	local var4 = var0:getConfig("english_name")

	setText(arg0.enNameText, var4)

	local var5 = var0:getMaxStar()
	local var6 = var0:getStar()

	arg0.nameTFStarUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0:findTF("empty", arg2)
			local var1 = arg0:findTF("on", arg2)

			arg1 = arg1 + 1

			setActive(var1, arg1 <= var6)
		end
	end)
	arg0.nameTFStarUIList:align(var5)
end

function var0.updateChar(arg0)
	return
end

function var0.recycleChar(arg0)
	if arg0.shipPrefab and arg0.shipModel then
		PoolMgr.GetInstance():ReturnSpineChar(arg0.shipPrefab, arg0.shipModel)

		arg0.shipPrefab = nil
		arg0.shipModel = nil
	end
end

function var0.updateSkillListPanel(arg0)
	local var0 = arg0.curShipVO
	local var1 = arg0.curMetaCharacterVO
	local var2 = arg0:getSkillIDListForShow(var0.configId)

	arg0.skillUIItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var2[arg1 + 1]

			if var0 then
				arg0.skillBtnList[var0] = arg2

				arg0:updateSkillTF(arg2, var0)
			end
		end
	end)
	arg0.skillUIItemList:align(#var2)
end

function var0.updateSkillTF(arg0, arg1, arg2)
	local var0 = arg0.curShipVO
	local var1 = arg0.curMetaCharacterVO
	local var2 = arg0:findTF("Skill/Icon", arg1)
	local var3 = arg0:findTF("Skill/Level", arg1)
	local var4 = arg0:findTF("Skill/Mask/Name", arg1)
	local var5 = arg0:findTF("Skill/Arrow", arg1)
	local var6 = arg0:findTF("Lock", arg1)
	local var7 = arg0:findTF("Learning", arg1)
	local var8 = getSkillConfig(arg2)
	local var9 = var0:getMetaSkillLevelBySkillID(arg2)

	setImageSprite(var2, LoadSprite("skillicon/" .. var8.icon))
	setScrollText(var4, getSkillName(var8.id))

	if var9 > 0 then
		setText(var3, "LEVEL: " .. var9)
		setActive(var6, false)
		onButton(arg0, arg1, function()
			if not isActive(var5) then
				eachChild(arg0.skillContainer, function(arg0)
					local var0 = arg0:findTF("Skill/Arrow", arg0)

					setActive(var0, false)
				end)
				setActive(var5, true)
				arg0:updateTaskPanel(arg2)
			end
		end, SFX_PANEL)
	else
		setText(var3, "LEVEL: ??")
		setActive(var6, true)
		onButton(arg0, arg1, function()
			arg0:openUnlockSkillPanel(arg2)
		end, SFX_PANEL)
	end
end

function var0.updateSkillTFLearning(arg0)
	local var0 = arg0.curShipVO

	for iter0, iter1 in pairs(arg0.skillBtnList) do
		local var1 = arg0:findTF("Learning", iter1)
		local var2 = var0:isSkillLevelMax(iter0)
		local var3 = iter0 == arg0.curSkillID

		setActive(var1, var3 and not var2)
	end
end

function var0.TryPlayGuide(arg0)
	pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0025")
end

function var0.updateExpPanel(arg0)
	local var0 = arg0:isAllSkillLock()
	local var1 = arg0:isAllSkillMaxLevel()

	if var0 or var1 then
		setActive(arg0.expPanel, false)
	elseif arg0.curSkillID > 0 then
		setActive(arg0.expPanel, true)

		local var2 = pg.gameset.meta_skill_exp_double.key_value
		local var3 = pg.gameset.meta_skill_exp_max.key_value

		setText(arg0.expText, arg0.normalExpValue .. "/" .. var3)
		setActive(arg0.expDoubleTag, var2 > arg0.doubleExpValue)
	else
		setActive(arg0.expPanel, false)
	end
end

function var0.updateSkillInfoPanel(arg0, arg1)
	local var0 = arg0.curShipVO
	local var1 = getSkillConfig(arg1)

	setImageSprite(arg0.curSkillIcon, LoadSprite("skillicon/" .. var1.icon))
	setScrollText(arg0.curSkillNameScrollText, getSkillName(var1.id))

	local var2 = pg.skill_data_template[arg1].max_level
	local var3 = var0:getMetaSkillLevelBySkillID(arg1)
	local var4 = var2 <= var3

	setText(arg0.curSkillLevelText, var3)

	local var5 = math.min(var3 + 1, var2)

	setText(arg0.nextSkillLevelText, var5)
	setText(arg0.curSkillDescText, getSkillDesc(arg1, var0:getMetaSkillLevelBySkillID(arg1)))
	setActive(arg0.curSkillQuickBtn, not var4 and not LOCK_META_SKILL_QUICK)
	onButton(arg0, arg0.curSkillQuickBtn, function()
		arg0:emit(MetaCharacterTacticsMediator.ON_QUICK, arg0.curShipVO.id, arg1)
	end, SFX_PANEL)

	local var6 = arg0.skillExpTable[arg1] or 0

	if not var4 then
		local var7 = arg0:getMetaSkillTacticsConfigBySkillID(arg1, var3).need_exp

		setText(arg0.curSkillProgressText, var6 .. "/" .. var7)
		setSlider(arg0.curSkillProgressSlider, 0, var7, var6)

		if var6 < var7 then
			-- block empty
		end
	else
		setText(arg0.curSkillProgressText, var6 .. "/Max")
		setSlider(arg0.curSkillProgressSlider, 0, 1, 1)
	end
end

function var0.updateTaskListPanel(arg0, arg1)
	local var0 = arg0.curShipVO:getMetaSkillLevelBySkillID(arg1)
	local var1 = arg0:getMetaSkillTacticsConfigBySkillID(arg1, var0).skill_levelup_task
	local var2 = arg0:sortTaskConfig(arg1, var1)

	arg0.taskUIItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0:findTF("Desc", arg2)
			local var1 = arg0:findTF("AddExp", arg2)
			local var2 = arg0:findTF("Text", arg2)

			arg1 = arg1 + 1

			local var3 = var2[arg1]
			local var4 = var3[1]
			local var5 = arg0:getTaskInfoBySkillAndTaskID(arg1, var4)
			local var6 = var5 and var5.finishCount or 0
			local var7 = var3[3]

			setText(var1, "+" .. var7)

			local var8 = var3[2]

			if var8 == 0 then
				setText(var2, var6 .. "/∞")
			else
				setText(var2, var6 .. "/" .. var8)
			end

			setText(var0, pg.task_meta_data_template[var4].desc)
		end
	end)
	arg0.taskUIItemList:align(#var2)
end

function var0.updateTaskPanel(arg0, arg1)
	local var0 = arg0.curShipVO
	local var1 = arg0.curMetaCharacterVO

	if var0:isSkillLevelMax(arg1) == true then
		setActive(arg0.studySkillTip, false)
		setActive(arg0.startSkillTip, false)
		setActive(arg0.maxSkillTip, true)
		setActive(arg0.skillInfoPanel, true)
		setActive(arg0.taskTplContainer, false)
		setActive(arg0.taskScrollBar, false)
		arg0:updateSkillInfoPanel(arg1)
	elseif arg1 ~= arg0.curSkillID then
		setActive(arg0.studySkillTip, false)
		setActive(arg0.startSkillTip, true)
		setActive(arg0.maxSkillTip, false)
		setActive(arg0.skillInfoPanel, true)
		setActive(arg0.taskTplContainer, true)
		setActive(arg0.taskScrollBar, true)
		arg0:updateSkillInfoPanel(arg1)
		arg0:updateTaskListPanel(arg1)
		onButton(arg0, arg0.studySkillBtn, function()
			if arg0.switchCountLeft == 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("meta_switch_skill_disable"))
			else
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("meta_switch_skill_box_title", getSkillName(arg1)),
					onYes = function()
						pg.m02:sendNotification(GAME.TACTICS_META_SWITCH_SKILL, {
							shipID = var0.id,
							skillID = arg1
						})
					end,
					weight = LayerWeightConst.TOP_LAYER
				})
			end
		end, SFX_PANEL)
	else
		setActive(arg0.studySkillTip, false)
		setActive(arg0.startSkillTip, false)
		setActive(arg0.maxSkillTip, false)
		setActive(arg0.skillInfoPanel, true)
		setActive(arg0.taskTplContainer, true)
		setActive(arg0.taskScrollBar, true)
		arg0:updateSkillInfoPanel(arg1)
		arg0:updateTaskListPanel(arg1)
	end
end

function var0.updateMain(arg0)
	local var0 = arg0.curShipVO
	local var1 = arg0:getSkillIDListForShow(var0.configId)
	local var2 = true
	local var3 = 0
	local var4, var5 = arg0:isAllSkillLock()

	setActive(arg0.taskScrollTF, not var4)

	if var4 then
		setActive(arg0.expPanel, false)
		setActive(arg0.skillInfoPanel, false)
		setActive(arg0.taskTplContainer, false)
		setActive(arg0.taskScrollBar, false)
		setActive(arg0.studySkillTip, true)
		setActive(arg0.startSkillTip, false)
		setActive(arg0.maxSkillTip, false)
	elseif arg0.curUnlockSkillID then
		triggerButton(arg0.skillBtnList[arg0.curUnlockSkillID])
	elseif arg0.curSkillID > 0 then
		triggerButton(arg0.skillBtnList[arg0.curSkillID])
	else
		triggerButton(arg0.skillBtnList[var5])
	end
end

function var0.tryLearnSkillAfterFirstUnlock(arg0)
	local var0 = arg0.curUnlockSkillID
	local var1 = 1

	arg0:switchTacticsSkillData(var0, var1)
	arg0:updateExpPanel()
	arg0:updateTaskPanel(var0)
	arg0:updateSkillTFLearning()
	arg0:TryPlayGuide()
end

function var0.moveShipImg(arg0, arg1)
	local var0 = arg0.curMetaCharacterVO.id
	local var1 = MetaCharacterConst.UIConfig[var0]
	local var2 = arg1 and -2000 or var1[7]
	local var3 = arg1 and var1[7] or -2000

	arg0:managedTween(LeanTween.moveX, nil, rtf(arg0.shipImg), var3, 0.2):setFrom(var2)
end

function var0.moveRightPanel(arg0)
	local var0 = 2000
	local var1 = 500

	arg0:managedTween(LeanTween.moveX, nil, rtf(arg0.skillPanel), var1, 0.2):setFrom(var0)
	arg0:managedTween(LeanTween.moveX, nil, rtf(arg0.taskPanel), var1, 0.2):setFrom(var0)
end

function var0.openUnlockSkillPanel(arg0, arg1)
	local var0 = arg0.curShipVO
	local var1 = arg0.curMetaCharacterVO

	arg0.curUnlockSkillID = arg1

	local var2 = ShipGroup.getDefaultShipNameByGroupID(var1.id)
	local var3 = getSkillName(arg1)

	setText(arg0.skillUnlockPanelTipText, i18n("meta_unlock_skill_tip", var2, var3))

	local var4 = arg0:getMetaSkillTacticsConfigBySkillID(arg1, 1)
	local var5 = var4.skill_unlock
	local var6 = {
		var4.skill_unlock[1]
	}

	arg0.materialUIItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg1 = arg1 + 1

			local var0 = var6[arg1]
			local var1 = arg0:findTF("Item", arg2)
			local var2 = arg0:findTF("SelectedTag", arg2)
			local var3 = arg0:findTF("Count/Text", arg2)
			local var4 = {
				type = DROP_TYPE_ITEM,
				id = var0[2],
				count = var0[3]
			}

			updateDrop(var1, var4)
			setActive(var2, false)

			local var5 = var0[2]
			local var6 = var0[3]
			local var7 = getProxy(BagProxy):getItemCountById(var5)
			local var8 = var7 < var6 and setColorStr(var7, COLOR_RED) or setColorStr(var7, COLOR_GREEN)

			setText(var3, var8 .. "/" .. var6)

			arg0.curUnlockMaterialID = var5
			arg0.curUnlockMaterialNeedCount = var6
		end
	end)
	arg0.materialUIItemList:align(#var6)
	setActive(arg0.skillUnlockPanel, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0.skillUnlockPanel, false, {
		weight = LayerWeightConst.TOP_LAYER
	})
end

function var0.closeUnlockSkillPanel(arg0)
	arg0.curUnlockSkillID = nil
	arg0.curUnlockMaterialID = nil
	arg0.curUnlockMaterialNeedCount = nil

	setActive(arg0.skillUnlockPanel, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0.skillUnlockPanel, arg0._tf)
end

function var0.enablePartialBlur(arg0)
	if arg0._tf then
		local var0 = {}

		table.insert(var0, arg0.taskPanel)
		table.insert(var0, arg0.skillPanel)
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

function var0.getMetaSkillTacticsConfigBySkillID(arg0, arg1, arg2)
	return MetaCharacterConst.getMetaSkillTacticsConfig(arg1, arg2)
end

function var0.getTaskInfoBySkillAndTaskID(arg0, arg1, arg2)
	local var0 = arg0.taskInfoTable[arg1] or {}

	for iter0, iter1 in ipairs(var0) do
		if iter1.taskID == arg2 then
			return iter1
		end
	end
end

function var0.isAllSkillLock(arg0)
	local var0 = arg0.curShipVO
	local var1 = arg0:getSkillIDListForShow(var0.configId)
	local var2 = true
	local var3 = 0

	for iter0, iter1 in ipairs(var1) do
		if var0:getMetaSkillLevelBySkillID(iter1) > 0 then
			var2 = false
			var3 = iter1

			break
		end
	end

	return var2, var3
end

function var0.isAllSkillMaxLevel(arg0)
	local var0 = arg0.curShipVO
	local var1 = arg0:getSkillIDListForShow(var0.configId)
	local var2 = true

	for iter0, iter1 in ipairs(var1) do
		if not var0:isSkillLevelMax(iter1) then
			return false
		end
	end
end

function var0.updateTacticsRedTag(arg0)
	local var0 = arg0.curShipVO
	local var1 = var0:getMetaCharacter()
	local var2 = arg0:getSkillIDListForShow(var0.configId)
	local var3 = false

	for iter0, iter1 in ipairs(var2) do
		local var4 = var0:getMetaSkillLevelBySkillID(iter1)
		local var5 = var0:isSkillLevelMax(iter1)

		if var4 > 0 and not var5 and arg0:getMetaSkillTacticsConfigBySkillID(iter1, var4).need_exp <= (arg0.skillExpTable and arg0.skillExpTable[iter1] or 0) then
			local var6 = true

			break
		end
	end
end

function var0.sortTaskConfig(arg0, arg1, arg2)
	local var0 = Clone(arg2)

	table.sort(var0, function(arg0, arg1)
		local var0 = arg0[1]
		local var1 = arg1[1]
		local var2 = arg0[2]
		local var3 = arg1[2]
		local var4 = arg0:getTaskInfoBySkillAndTaskID(arg1, var0)
		local var5 = arg0:getTaskInfoBySkillAndTaskID(arg1, var1)
		local var6 = var4 and var4.finishCount or 0
		local var7 = var5 and var5.finishCount or 0
		local var8 = var2 > 0 and var6 <= var2
		local var9 = var3 > 0 and var7 <= var3

		if var2 == 0 and var3 == 0 then
			return var0 < var1
		elseif var2 == 0 then
			return true
		elseif var3 == 0 then
			return false
		elseif var8 == true and var9 == true then
			return var0 < var1
		elseif var8 == true then
			return false
		elseif var9 == true then
			return true
		else
			return var0 < var1
		end
	end)

	return var0
end

function var0.getSkillIDListForShow(arg0, arg1)
	return MetaCharacterConst.getTacticsSkillIDListByShipConfigID(arg1)
end

return var0
