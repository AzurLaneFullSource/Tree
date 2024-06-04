local var0 = class("NavalTacticsMetaSkillsView", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "NavalTacticsMetaSkillsPanel"
end

function var0.OnInit(arg0)
	arg0:initUITip()
	arg0:initUI()
	arg0:addListener()
	arg0:updateSkillList()
	triggerToggle(arg0.skillToggleList[1], true)
	arg0:Show()
end

function var0.Show(arg0)
	var0.super.Show(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.BASE_LAYER
	})
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, pg.UIMgr.GetInstance().UIMain)
end

function var0.OnDestroy(arg0)
	arg0:Hide()
end

function var0.setData(arg0, arg1, arg2)
	arg0.metaShipID = arg1 or arg0.metaShipID
	arg0.metaShipVO = getProxy(BayProxy):getShipById(arg0.metaShipID)
	arg0.closeCB = arg2 or arg0.closeCB
	arg0.metaProxy = getProxy(MetaCharacterProxy)
	arg0.metaTacticsInfo = arg0.metaProxy:getMetaTacticsInfoByShipID(arg0.metaShipVO.id)
	arg0.selectSkillID = arg0.selectSkillID or nil
end

function var0.initUITip(arg0)
	local var0 = arg0:findTF("frame/bg/title_bg/title")
	local var1 = arg0:findTF("frame/buttons/detail_btn/Image")
	local var2 = arg0:findTF("frame/buttons/unlock_btn/Image")
	local var3 = arg0:findTF("frame/buttons/switch_btn/Image")

	setText(var1, i18n("meta_tactics_detail"))
	setText(var2, i18n("meta_tactics_unlock"))
	setText(var3, i18n("meta_tactics_switch"))
end

function var0.initUI(arg0)
	arg0.bg = arg0:findTF("print")

	local var0 = arg0:findTF("frame")

	arg0.skillTpl = arg0:findTF("skilltpl", var0)
	arg0.skillContainer = arg0:findTF("skill_contain/content", var0)

	local var1 = arg0:findTF("buttons", var0)

	arg0.detailBtn = arg0:findTF("detail_btn", var1)
	arg0.unlockBtn = arg0:findTF("unlock_btn", var1)
	arg0.switchBtn = arg0:findTF("switch_btn", var1)
	arg0.skillUIItemList = UIItemList.New(arg0.skillContainer, arg0.skillTpl)
end

function var0.addListener(arg0)
	onButton(arg0, arg0.bg, function()
		arg0:Hide()

		if arg0.closeCB then
			arg0.closeCB()
		else
			arg0:Destroy()
		end
	end, SFX_CANCEL)
	onButton(arg0, arg0.detailBtn, function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.METACHARACTER, {
			autoOpenTactics = true,
			autoOpenShipConfigID = arg0.metaShipVO.configId
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.unlockBtn, function()
		pg.MsgboxMgr:GetInstance():ShowMsgBox({
			hideYes = true,
			hideNo = true,
			type = MSGBOX_TYPE_META_SKILL_UNLOCK,
			metaShipVO = arg0.metaShipVO,
			skillID = arg0.selectSkillID
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.switchBtn, function()
		pg.m02:sendNotification(GAME.TACTICS_META_SWITCH_SKILL, {
			shipID = arg0.metaShipVO.id,
			skillID = arg0.selectSkillID
		})
	end, SFX_PANEL)
end

function var0.updateSkillTF(arg0, arg1, arg2)
	local var0 = arg0:findTF("frame", arg1)
	local var1 = arg0:findTF("skillInfo", var0)
	local var2 = arg0:findTF("empty", var0)
	local var3 = arg0:findTF("mask", var0)
	local var4 = arg0:findTF("icon", var1)
	local var5 = arg0:findTF("descView/Viewport/desc", var1)
	local var6 = arg0:findTF("next_contain/label", var1)
	local var7 = arg0:findTF("next_contain/Text", var1)
	local var8 = arg0:findTF("name_contain/name", var1)
	local var9 = arg0:findTF("name_contain/level_contain/Text", var1)
	local var10 = arg0:findTF("Tag/learing", var0)
	local var11 = arg0:findTF("Tag/unlockable", var0)
	local var12 = arg0.metaShipVO:getMetaSkillLevelBySkillID(arg2)
	local var13 = getSkillConfig(arg2)
	local var14 = arg2 == arg0.metaTacticsInfo.curSkillID
	local var15 = var12 > 0

	setImageSprite(var4, LoadSprite("skillicon/" .. var13.icon))
	setText(var5, getSkillDesc(arg2, var15 and var12 or 1))
	setText(var8, getSkillName(var13.id))
	setText(var9, var12)

	local var16 = arg0.metaTacticsInfo:getSkillExp(arg2)
	local var17 = var12 >= pg.skill_data_template[arg2].max_level

	if not var17 then
		if var15 then
			local var18 = MetaCharacterConst.getMetaSkillTacticsConfig(arg2, var12).need_exp

			setText(var7, setColorStr(var16, COLOR_GREEN) .. "/" .. var18)
			setActive(var6, true)
			setActive(var7, true)
		else
			setActive(var6, false)
			setActive(var7, false)
		end
	else
		setText(var7, "Max")
	end

	setActive(var10, var14 and not var17)
	setActive(var11, not var15)
	setActive(var3, not var15)
	onToggle(arg0, arg1, function(arg0)
		if arg0 then
			arg0.selectSkillID = arg2

			arg0:updateButtons(arg0.selectSkillID)
		end
	end, SFX_PANEL)
end

function var0.updateSkillList(arg0)
	local var0 = MetaCharacterConst.getTacticsSkillIDListByShipConfigID(arg0.metaShipVO.configId)

	arg0.skillUIItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg1 = arg1 + 1
			arg0.skillToggleList = arg0.skillToggleList or {}
			arg0.skillToggleList[arg1] = arg2

			local var0 = var0[arg1]

			arg0:updateSkillTF(arg2, var0)
		end
	end)
	arg0.skillUIItemList:align(#var0)
end

function var0.updateButtons(arg0, arg1)
	local var0 = arg1 or arg0.selectSkillID
	local var1 = var0 == arg0.metaTacticsInfo.curSkillID
	local var2 = arg0.metaShipVO:getMetaSkillLevelBySkillID(var0) > 0
	local var3 = arg0.metaShipVO:isSkillLevelMax(var0)

	if var1 or var3 then
		setActive(arg0.detailBtn, true)
		setActive(arg0.unlockBtn, false)
		setActive(arg0.switchBtn, false)
	elseif not var2 then
		setActive(arg0.detailBtn, true)
		setActive(arg0.unlockBtn, true)
		setActive(arg0.switchBtn, false)
	elseif var2 and not var1 then
		setActive(arg0.detailBtn, true)
		setActive(arg0.unlockBtn, false)
		setActive(arg0.switchBtn, true)
	end
end

function var0.reUpdate(arg0, arg1, arg2)
	arg0:setData(arg1, arg2)
	arg0:updateSkillList()
	arg0:updateButtons()
end

return var0
