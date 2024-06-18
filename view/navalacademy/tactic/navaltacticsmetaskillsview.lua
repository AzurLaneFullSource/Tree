local var0_0 = class("NavalTacticsMetaSkillsView", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "NavalTacticsMetaSkillsPanel"
end

function var0_0.OnInit(arg0_2)
	arg0_2:initUITip()
	arg0_2:initUI()
	arg0_2:addListener()
	arg0_2:updateSkillList()
	triggerToggle(arg0_2.skillToggleList[1], true)
	arg0_2:Show()
end

function var0_0.Show(arg0_3)
	var0_0.super.Show(arg0_3)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf, false, {
		weight = LayerWeightConst.BASE_LAYER
	})
end

function var0_0.Hide(arg0_4)
	var0_0.super.Hide(arg0_4)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_4._tf, pg.UIMgr.GetInstance().UIMain)
end

function var0_0.OnDestroy(arg0_5)
	arg0_5:Hide()
end

function var0_0.setData(arg0_6, arg1_6, arg2_6)
	arg0_6.metaShipID = arg1_6 or arg0_6.metaShipID
	arg0_6.metaShipVO = getProxy(BayProxy):getShipById(arg0_6.metaShipID)
	arg0_6.closeCB = arg2_6 or arg0_6.closeCB
	arg0_6.metaProxy = getProxy(MetaCharacterProxy)
	arg0_6.metaTacticsInfo = arg0_6.metaProxy:getMetaTacticsInfoByShipID(arg0_6.metaShipVO.id)
	arg0_6.selectSkillID = arg0_6.selectSkillID or nil
end

function var0_0.initUITip(arg0_7)
	local var0_7 = arg0_7:findTF("frame/bg/title_bg/title")
	local var1_7 = arg0_7:findTF("frame/buttons/detail_btn/Image")
	local var2_7 = arg0_7:findTF("frame/buttons/unlock_btn/Image")
	local var3_7 = arg0_7:findTF("frame/buttons/switch_btn/Image")

	setText(var1_7, i18n("meta_tactics_detail"))
	setText(var2_7, i18n("meta_tactics_unlock"))
	setText(var3_7, i18n("meta_tactics_switch"))
end

function var0_0.initUI(arg0_8)
	arg0_8.bg = arg0_8:findTF("print")

	local var0_8 = arg0_8:findTF("frame")

	arg0_8.skillTpl = arg0_8:findTF("skilltpl", var0_8)
	arg0_8.skillContainer = arg0_8:findTF("skill_contain/content", var0_8)

	local var1_8 = arg0_8:findTF("buttons", var0_8)

	arg0_8.detailBtn = arg0_8:findTF("detail_btn", var1_8)
	arg0_8.unlockBtn = arg0_8:findTF("unlock_btn", var1_8)
	arg0_8.switchBtn = arg0_8:findTF("switch_btn", var1_8)
	arg0_8.skillUIItemList = UIItemList.New(arg0_8.skillContainer, arg0_8.skillTpl)
end

function var0_0.addListener(arg0_9)
	onButton(arg0_9, arg0_9.bg, function()
		arg0_9:Hide()

		if arg0_9.closeCB then
			arg0_9.closeCB()
		else
			arg0_9:Destroy()
		end
	end, SFX_CANCEL)
	onButton(arg0_9, arg0_9.detailBtn, function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.METACHARACTER, {
			autoOpenTactics = true,
			autoOpenShipConfigID = arg0_9.metaShipVO.configId
		})
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.unlockBtn, function()
		pg.MsgboxMgr:GetInstance():ShowMsgBox({
			hideYes = true,
			hideNo = true,
			type = MSGBOX_TYPE_META_SKILL_UNLOCK,
			metaShipVO = arg0_9.metaShipVO,
			skillID = arg0_9.selectSkillID
		})
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.switchBtn, function()
		pg.m02:sendNotification(GAME.TACTICS_META_SWITCH_SKILL, {
			shipID = arg0_9.metaShipVO.id,
			skillID = arg0_9.selectSkillID
		})
	end, SFX_PANEL)
end

function var0_0.updateSkillTF(arg0_14, arg1_14, arg2_14)
	local var0_14 = arg0_14:findTF("frame", arg1_14)
	local var1_14 = arg0_14:findTF("skillInfo", var0_14)
	local var2_14 = arg0_14:findTF("empty", var0_14)
	local var3_14 = arg0_14:findTF("mask", var0_14)
	local var4_14 = arg0_14:findTF("icon", var1_14)
	local var5_14 = arg0_14:findTF("descView/Viewport/desc", var1_14)
	local var6_14 = arg0_14:findTF("next_contain/label", var1_14)
	local var7_14 = arg0_14:findTF("next_contain/Text", var1_14)
	local var8_14 = arg0_14:findTF("name_contain/name", var1_14)
	local var9_14 = arg0_14:findTF("name_contain/level_contain/Text", var1_14)
	local var10_14 = arg0_14:findTF("Tag/learing", var0_14)
	local var11_14 = arg0_14:findTF("Tag/unlockable", var0_14)
	local var12_14 = arg0_14.metaShipVO:getMetaSkillLevelBySkillID(arg2_14)
	local var13_14 = getSkillConfig(arg2_14)
	local var14_14 = arg2_14 == arg0_14.metaTacticsInfo.curSkillID
	local var15_14 = var12_14 > 0

	setImageSprite(var4_14, LoadSprite("skillicon/" .. var13_14.icon))
	setText(var5_14, getSkillDesc(arg2_14, var15_14 and var12_14 or 1))
	setText(var8_14, getSkillName(var13_14.id))
	setText(var9_14, var12_14)

	local var16_14 = arg0_14.metaTacticsInfo:getSkillExp(arg2_14)
	local var17_14 = var12_14 >= pg.skill_data_template[arg2_14].max_level

	if not var17_14 then
		if var15_14 then
			local var18_14 = MetaCharacterConst.getMetaSkillTacticsConfig(arg2_14, var12_14).need_exp

			setText(var7_14, setColorStr(var16_14, COLOR_GREEN) .. "/" .. var18_14)
			setActive(var6_14, true)
			setActive(var7_14, true)
		else
			setActive(var6_14, false)
			setActive(var7_14, false)
		end
	else
		setText(var7_14, "Max")
	end

	setActive(var10_14, var14_14 and not var17_14)
	setActive(var11_14, not var15_14)
	setActive(var3_14, not var15_14)
	onToggle(arg0_14, arg1_14, function(arg0_15)
		if arg0_15 then
			arg0_14.selectSkillID = arg2_14

			arg0_14:updateButtons(arg0_14.selectSkillID)
		end
	end, SFX_PANEL)
end

function var0_0.updateSkillList(arg0_16)
	local var0_16 = MetaCharacterConst.getTacticsSkillIDListByShipConfigID(arg0_16.metaShipVO.configId)

	arg0_16.skillUIItemList:make(function(arg0_17, arg1_17, arg2_17)
		if arg0_17 == UIItemList.EventUpdate then
			arg1_17 = arg1_17 + 1
			arg0_16.skillToggleList = arg0_16.skillToggleList or {}
			arg0_16.skillToggleList[arg1_17] = arg2_17

			local var0_17 = var0_16[arg1_17]

			arg0_16:updateSkillTF(arg2_17, var0_17)
		end
	end)
	arg0_16.skillUIItemList:align(#var0_16)
end

function var0_0.updateButtons(arg0_18, arg1_18)
	local var0_18 = arg1_18 or arg0_18.selectSkillID
	local var1_18 = var0_18 == arg0_18.metaTacticsInfo.curSkillID
	local var2_18 = arg0_18.metaShipVO:getMetaSkillLevelBySkillID(var0_18) > 0
	local var3_18 = arg0_18.metaShipVO:isSkillLevelMax(var0_18)

	if var1_18 or var3_18 then
		setActive(arg0_18.detailBtn, true)
		setActive(arg0_18.unlockBtn, false)
		setActive(arg0_18.switchBtn, false)
	elseif not var2_18 then
		setActive(arg0_18.detailBtn, true)
		setActive(arg0_18.unlockBtn, true)
		setActive(arg0_18.switchBtn, false)
	elseif var2_18 and not var1_18 then
		setActive(arg0_18.detailBtn, true)
		setActive(arg0_18.unlockBtn, false)
		setActive(arg0_18.switchBtn, true)
	end
end

function var0_0.reUpdate(arg0_19, arg1_19, arg2_19)
	arg0_19:setData(arg1_19, arg2_19)
	arg0_19:updateSkillList()
	arg0_19:updateButtons()
end

return var0_0
