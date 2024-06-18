local var0_0 = class("MetaSkillDetailBoxLayer", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "MetaSkillDetailBoxUI"
end

function var0_0.init(arg0_2)
	arg0_2:initUITextTips()
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:addListener()
end

function var0_0.didEnter(arg0_3)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf, false)
	arg0_3:updateShipDetail()
	arg0_3:updateSkillList()
end

function var0_0.willExit(arg0_4)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_4._tf)
end

function var0_0.initUITextTips(arg0_5)
	local var0_5 = arg0_5:findTF("Window/top/bg/infomation/title")
	local var1_5 = arg0_5:findTF("Window/MetaSkillDetailBox/ExpDetail/ExpTipText")
	local var2_5 = arg0_5:findTF("Window/MetaSkillDetailBox/TipText")

	setText(var0_5, i18n("battle_end_subtitle2"))
	setText(var1_5, i18n("meta_skill_dailyexp"))
	setText(var2_5, i18n("meta_skill_learn"))
end

function var0_0.initData(arg0_6)
	arg0_6.metaProxy = getProxy(MetaCharacterProxy)
	arg0_6.metaShipID = arg0_6.contextData.metaShipID
end

function var0_0.findUI(arg0_7)
	arg0_7.bg = arg0_7:findTF("BG")
	arg0_7.window = arg0_7:findTF("Window")
	arg0_7.closeBtn = arg0_7:findTF("top/btnBack", arg0_7.window)
	arg0_7.panel = arg0_7:findTF("MetaSkillDetailBox", arg0_7.window)
	arg0_7.skillTpl = arg0_7:findTF("SkillTpl", arg0_7.panel)
	arg0_7.expDetailTF = arg0_7:findTF("ExpDetail", arg0_7.panel)
	arg0_7.shipIcon = arg0_7:findTF("IconTpl/Icon", arg0_7.expDetailTF)
	arg0_7.shipNameText = arg0_7:findTF("NameMask/Name", arg0_7.expDetailTF)
	arg0_7.expProgressText = arg0_7:findTF("ExpProgressText", arg0_7.expDetailTF)
	arg0_7.skillContainer = arg0_7:findTF("ScrollView/Content", arg0_7.panel)
	arg0_7.skillUIItemList = UIItemList.New(arg0_7.skillContainer, arg0_7.skillTpl)
end

function var0_0.addListener(arg0_8)
	onButton(arg0_8, arg0_8.bg, function()
		arg0_8:closeView()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.closeBtn, function()
		arg0_8:closeView()
	end, SFX_PANEL)
end

function var0_0.updateSkillTF(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg0_11:findTF("frame", arg1_11)
	local var1_11 = arg0_11:findTF("check_mark", arg1_11)
	local var2_11 = arg0_11:findTF("skillInfo", var0_11)
	local var3_11 = arg0_11:findTF("mask", var0_11)
	local var4_11 = arg0_11:findTF("Slider", var0_11)
	local var5_11 = arg0_11:findTF("icon", var2_11)
	local var6_11 = arg0_11:findTF("ExpProgressText", var2_11)
	local var7_11 = arg0_11:findTF("name_contain/name", var2_11)
	local var8_11 = arg0_11:findTF("name_contain/level_contain/Text", var2_11)
	local var9_11 = arg0_11:findTF("Tag/learing", var0_11)
	local var10_11 = arg0_11:findTF("Tag/unlockable", var0_11)
	local var11_11 = getProxy(BayProxy):getShipById(arg0_11.metaShipID)
	local var12_11 = var11_11:getMetaSkillLevelBySkillID(arg2_11)
	local var13_11 = getSkillConfig(arg2_11)

	setImageSprite(var5_11, LoadSprite("skillicon/" .. var13_11.icon))
	setText(var7_11, shortenString(getSkillName(var13_11.id), 8))
	setText(var8_11, var12_11)

	local var14_11 = arg0_11.metaProxy:getMetaTacticsInfoByShipID(arg0_11.metaShipID)
	local var15_11 = arg2_11 == var14_11.curSkillID
	local var16_11 = var12_11 > 0
	local var17_11 = var11_11:isSkillLevelMax(arg2_11)
	local var18_11 = var14_11:getSkillExp(arg2_11)

	if not (var12_11 >= pg.skill_data_template[arg2_11].max_level) then
		if var16_11 then
			local var19_11 = MetaCharacterConst.getMetaSkillTacticsConfig(arg2_11, var12_11).need_exp

			setText(var6_11, var18_11 .. "/" .. var19_11)
			setSlider(var4_11, 0, var19_11, var18_11)
			setActive(var6_11, true)
			setActive(var4_11, true)
		else
			setActive(var6_11, false)
			setActive(var4_11, false)
		end
	else
		setText(var6_11, var18_11 .. "/Max")
		setSlider(var4_11, 0, 1, 1)
		setActive(var6_11, true)
		setActive(var4_11, true)
	end

	setActive(var1_11, var15_11 and not var17_11)
	setActive(var9_11, var15_11 and not var17_11)
	setActive(var10_11, not var16_11)
	setActive(var3_11, not var16_11)
	onToggle(arg0_11, arg1_11, function(arg0_12)
		if arg0_12 then
			if not var16_11 then
				pg.MsgboxMgr:GetInstance():ShowMsgBox({
					hideYes = true,
					hideNo = true,
					type = MSGBOX_TYPE_META_SKILL_UNLOCK,
					weight = LayerWeightConst.TOP_LAYER,
					metaShipVO = var11_11,
					skillID = arg2_11
				})
			elseif not var15_11 and not var17_11 then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("meta_switch_skill_box_title", getSkillName(arg2_11)),
					onYes = function()
						pg.m02:sendNotification(GAME.TACTICS_META_SWITCH_SKILL, {
							shipID = arg0_11.metaShipID,
							skillID = arg2_11
						})
					end,
					weight = LayerWeightConst.TOP_LAYER
				})
			elseif var17_11 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("meta_skill_maxtip2"))
			end
		end
	end, SFX_PANEL)
end

function var0_0.updateSkillList(arg0_14)
	local var0_14 = getProxy(BayProxy):getShipById(arg0_14.metaShipID)
	local var1_14 = MetaCharacterConst.getTacticsSkillIDListByShipConfigID(var0_14.configId)

	arg0_14.skillUIItemList:make(function(arg0_15, arg1_15, arg2_15)
		if arg0_15 == UIItemList.EventUpdate then
			arg1_15 = arg1_15 + 1

			local var0_15 = var1_14[arg1_15]

			arg0_14:updateSkillTF(arg2_15, var0_15)
		end
	end)
	arg0_14.skillUIItemList:align(#var1_14)
end

function var0_0.updateShipDetail(arg0_16)
	local var0_16 = getProxy(BayProxy):getShipById(arg0_16.metaShipID)
	local var1_16 = var0_16:getPainting()
	local var2_16 = "SquareIcon/" .. var1_16

	setImageSprite(arg0_16.shipIcon, LoadSprite(var2_16, var1_16))
	setScrollText(arg0_16.shipNameText, var0_16:getName())

	local var3_16 = arg0_16.metaProxy:getMetaTacticsInfoByShipID(arg0_16.metaShipID).curDayExp
	local var4_16 = setColorStr(var3_16, "#FFF152FF") .. "/" .. pg.gameset.meta_skill_exp_max.key_value

	setText(arg0_16.expProgressText, var4_16)
end

return var0_0
