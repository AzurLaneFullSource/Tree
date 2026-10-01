local var0_0 = class("MetaSkillDetailBoxLayer", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "MetaSkillDetailBoxUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {}
	local var1_2 = getProxy(BayProxy):getShipById(arg1_2.metaShipID)
	local var2_2 = MetaCharacterConst.getTacticsSkillIDListByShipConfigID(var1_2.configId)

	for iter0_2 = 1, #var2_2 do
		local var3_2 = var2_2[iter0_2]
		local var4_2 = getSkillConfig(var3_2)

		table.insert(var0_2, "skillicon/" .. var4_2.icon)
	end

	table.insertto(var0_2, var0_0.super.getResource(arg0_2))

	return var0_2
end

function var0_0.init(arg0_3)
	arg0_3:initUITextTips()
	arg0_3:initData()
	arg0_3:findUI()
	arg0_3:addListener()
end

function var0_0.didEnter(arg0_4)
	pg.UIMgr.GetInstance():BlurPanel(arg0_4._tf)
	arg0_4:updateShipDetail()
	arg0_4:updateSkillList()
end

function var0_0.willExit(arg0_5)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_5._tf)
end

function var0_0.initUITextTips(arg0_6)
	local var0_6 = arg0_6._tf:Find("Window/top/bg/infomation/title")
	local var1_6 = arg0_6._tf:Find("Window/MetaSkillDetailBox/ExpDetail/ExpTipText")
	local var2_6 = arg0_6._tf:Find("Window/MetaSkillDetailBox/TipText")

	setText(var0_6, i18n("battle_end_subtitle2"))
	setText(var1_6, i18n("meta_skill_dailyexp"))
	setText(var2_6, i18n("meta_skill_learn"))
end

function var0_0.initData(arg0_7)
	arg0_7.metaProxy = getProxy(MetaCharacterProxy)
	arg0_7.metaShipID = arg0_7.contextData.metaShipID
end

function var0_0.findUI(arg0_8)
	arg0_8.bg = arg0_8._tf:Find("BG")
	arg0_8.window = arg0_8._tf:Find("Window")
	arg0_8.closeBtn = arg0_8.window:Find("top/btnBack")
	arg0_8.panel = arg0_8.window:Find("MetaSkillDetailBox")
	arg0_8.skillTpl = arg0_8.panel:Find("SkillTpl")
	arg0_8.expDetailTF = arg0_8.panel:Find("ExpDetail")
	arg0_8.shipIcon = arg0_8.expDetailTF:Find("IconTpl/Icon")
	arg0_8.shipNameText = arg0_8.expDetailTF:Find("NameMask/Name")
	arg0_8.expProgressText = arg0_8.expDetailTF:Find("ExpProgressText")
	arg0_8.skillContainer = arg0_8.panel:Find("ScrollView/Content")
	arg0_8.skillUIItemList = UIItemList.New(arg0_8.skillContainer, arg0_8.skillTpl)
end

function var0_0.addListener(arg0_9)
	onButton(arg0_9, arg0_9.bg, function()
		arg0_9:closeView()
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.closeBtn, function()
		arg0_9:closeView()
	end, SFX_PANEL)
end

function var0_0.updateSkillTF(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg1_12:Find("frame")
	local var1_12 = arg1_12:Find("check_mark")
	local var2_12 = var0_12:Find("skillInfo")
	local var3_12 = var0_12:Find("mask")
	local var4_12 = var0_12:Find("Slider")
	local var5_12 = var2_12:Find("icon")
	local var6_12 = var2_12:Find("ExpProgressText")
	local var7_12 = var2_12:Find("name_contain/name")
	local var8_12 = var2_12:Find("name_contain/level_contain/Text")
	local var9_12 = var0_12:Find("Tag/learing")
	local var10_12 = var0_12:Find("Tag/unlockable")
	local var11_12 = getProxy(BayProxy):getShipById(arg0_12.metaShipID)
	local var12_12 = var11_12:getMetaSkillLevelBySkillID(arg2_12)
	local var13_12 = getSkillConfig(arg2_12)

	setImageSprite(var5_12, LoadSprite("skillicon/" .. var13_12.icon))
	setText(var7_12, shortenString(getSkillName(var13_12.id), 8))
	setText(var8_12, var12_12)

	local var14_12 = arg0_12.metaProxy:getMetaTacticsInfoByShipID(arg0_12.metaShipID)
	local var15_12 = arg2_12 == var14_12.curSkillID
	local var16_12 = var12_12 > 0
	local var17_12 = var11_12:isSkillLevelMax(arg2_12)
	local var18_12 = var14_12:getSkillExp(arg2_12)

	if not (var12_12 >= pg.skill_data_template[arg2_12].max_level) then
		if var16_12 then
			local var19_12 = MetaCharacterConst.getMetaSkillTacticsConfig(arg2_12, var12_12).need_exp

			setText(var6_12, var18_12 .. "/" .. var19_12)
			setSlider(var4_12, 0, var19_12, var18_12)
			setActive(var6_12, true)
			setActive(var4_12, true)
		else
			setActive(var6_12, false)
			setActive(var4_12, false)
		end
	else
		setText(var6_12, var18_12 .. "/Max")
		setSlider(var4_12, 0, 1, 1)
		setActive(var6_12, true)
		setActive(var4_12, true)
	end

	setActive(var1_12, var15_12 and not var17_12)
	setActive(var9_12, var15_12 and not var17_12)
	setActive(var10_12, not var16_12)
	setActive(var3_12, not var16_12)
	onToggle(arg0_12, arg1_12, function(arg0_13)
		if arg0_13 then
			if not var16_12 then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					hideYes = true,
					hideNo = true,
					type = MSGBOX_TYPE_META_SKILL_UNLOCK,
					metaShipVO = var11_12,
					skillID = arg2_12
				})
			elseif not var15_12 and not var17_12 then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("meta_switch_skill_box_title", getSkillName(arg2_12)),
					onYes = function()
						pg.m02:sendNotification(GAME.TACTICS_META_SWITCH_SKILL, {
							shipID = arg0_12.metaShipID,
							skillID = arg2_12
						})
					end
				})
			elseif var17_12 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("meta_skill_maxtip2"))
			end
		end
	end, SFX_PANEL)
end

function var0_0.updateSkillList(arg0_15)
	local var0_15 = getProxy(BayProxy):getShipById(arg0_15.metaShipID)
	local var1_15 = MetaCharacterConst.getTacticsSkillIDListByShipConfigID(var0_15.configId)

	arg0_15.skillUIItemList:make(function(arg0_16, arg1_16, arg2_16)
		if arg0_16 == UIItemList.EventUpdate then
			arg1_16 = arg1_16 + 1

			local var0_16 = var1_15[arg1_16]

			arg0_15:updateSkillTF(arg2_16, var0_16)
		end
	end)
	arg0_15.skillUIItemList:align(#var1_15)
end

function var0_0.updateShipDetail(arg0_17)
	local var0_17 = getProxy(BayProxy):getShipById(arg0_17.metaShipID)
	local var1_17 = var0_17:getPainting()
	local var2_17 = "SquareIcon/" .. var1_17

	setImageSprite(arg0_17.shipIcon, LoadSprite(var2_17, var1_17))
	setScrollText(arg0_17.shipNameText, var0_17:getName())

	local var3_17 = arg0_17.metaProxy:getMetaTacticsInfoByShipID(arg0_17.metaShipID).curDayExp
	local var4_17 = setColorStr(var3_17, "#FFF152FF") .. "/" .. pg.gameset.meta_skill_exp_max.key_value

	setText(arg0_17.expProgressText, var4_17)
end

return var0_0
