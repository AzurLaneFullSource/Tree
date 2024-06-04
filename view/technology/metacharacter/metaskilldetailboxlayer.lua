local var0 = class("MetaSkillDetailBoxLayer", import("...base.BaseUI"))

function var0.getUIName(arg0)
	return "MetaSkillDetailBoxUI"
end

function var0.init(arg0)
	arg0:initUITextTips()
	arg0:initData()
	arg0:findUI()
	arg0:addListener()
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false)
	arg0:updateShipDetail()
	arg0:updateSkillList()
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

function var0.initUITextTips(arg0)
	local var0 = arg0:findTF("Window/top/bg/infomation/title")
	local var1 = arg0:findTF("Window/MetaSkillDetailBox/ExpDetail/ExpTipText")
	local var2 = arg0:findTF("Window/MetaSkillDetailBox/TipText")

	setText(var0, i18n("battle_end_subtitle2"))
	setText(var1, i18n("meta_skill_dailyexp"))
	setText(var2, i18n("meta_skill_learn"))
end

function var0.initData(arg0)
	arg0.metaProxy = getProxy(MetaCharacterProxy)
	arg0.metaShipID = arg0.contextData.metaShipID
end

function var0.findUI(arg0)
	arg0.bg = arg0:findTF("BG")
	arg0.window = arg0:findTF("Window")
	arg0.closeBtn = arg0:findTF("top/btnBack", arg0.window)
	arg0.panel = arg0:findTF("MetaSkillDetailBox", arg0.window)
	arg0.skillTpl = arg0:findTF("SkillTpl", arg0.panel)
	arg0.expDetailTF = arg0:findTF("ExpDetail", arg0.panel)
	arg0.shipIcon = arg0:findTF("IconTpl/Icon", arg0.expDetailTF)
	arg0.shipNameText = arg0:findTF("NameMask/Name", arg0.expDetailTF)
	arg0.expProgressText = arg0:findTF("ExpProgressText", arg0.expDetailTF)
	arg0.skillContainer = arg0:findTF("ScrollView/Content", arg0.panel)
	arg0.skillUIItemList = UIItemList.New(arg0.skillContainer, arg0.skillTpl)
end

function var0.addListener(arg0)
	onButton(arg0, arg0.bg, function()
		arg0:closeView()
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:closeView()
	end, SFX_PANEL)
end

function var0.updateSkillTF(arg0, arg1, arg2)
	local var0 = arg0:findTF("frame", arg1)
	local var1 = arg0:findTF("check_mark", arg1)
	local var2 = arg0:findTF("skillInfo", var0)
	local var3 = arg0:findTF("mask", var0)
	local var4 = arg0:findTF("Slider", var0)
	local var5 = arg0:findTF("icon", var2)
	local var6 = arg0:findTF("ExpProgressText", var2)
	local var7 = arg0:findTF("name_contain/name", var2)
	local var8 = arg0:findTF("name_contain/level_contain/Text", var2)
	local var9 = arg0:findTF("Tag/learing", var0)
	local var10 = arg0:findTF("Tag/unlockable", var0)
	local var11 = getProxy(BayProxy):getShipById(arg0.metaShipID)
	local var12 = var11:getMetaSkillLevelBySkillID(arg2)
	local var13 = getSkillConfig(arg2)

	setImageSprite(var5, LoadSprite("skillicon/" .. var13.icon))
	setText(var7, shortenString(getSkillName(var13.id), 8))
	setText(var8, var12)

	local var14 = arg0.metaProxy:getMetaTacticsInfoByShipID(arg0.metaShipID)
	local var15 = arg2 == var14.curSkillID
	local var16 = var12 > 0
	local var17 = var11:isSkillLevelMax(arg2)
	local var18 = var14:getSkillExp(arg2)

	if not (var12 >= pg.skill_data_template[arg2].max_level) then
		if var16 then
			local var19 = MetaCharacterConst.getMetaSkillTacticsConfig(arg2, var12).need_exp

			setText(var6, var18 .. "/" .. var19)
			setSlider(var4, 0, var19, var18)
			setActive(var6, true)
			setActive(var4, true)
		else
			setActive(var6, false)
			setActive(var4, false)
		end
	else
		setText(var6, var18 .. "/Max")
		setSlider(var4, 0, 1, 1)
		setActive(var6, true)
		setActive(var4, true)
	end

	setActive(var1, var15 and not var17)
	setActive(var9, var15 and not var17)
	setActive(var10, not var16)
	setActive(var3, not var16)
	onToggle(arg0, arg1, function(arg0)
		if arg0 then
			if not var16 then
				pg.MsgboxMgr:GetInstance():ShowMsgBox({
					hideYes = true,
					hideNo = true,
					type = MSGBOX_TYPE_META_SKILL_UNLOCK,
					weight = LayerWeightConst.TOP_LAYER,
					metaShipVO = var11,
					skillID = arg2
				})
			elseif not var15 and not var17 then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("meta_switch_skill_box_title", getSkillName(arg2)),
					onYes = function()
						pg.m02:sendNotification(GAME.TACTICS_META_SWITCH_SKILL, {
							shipID = arg0.metaShipID,
							skillID = arg2
						})
					end,
					weight = LayerWeightConst.TOP_LAYER
				})
			elseif var17 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("meta_skill_maxtip2"))
			end
		end
	end, SFX_PANEL)
end

function var0.updateSkillList(arg0)
	local var0 = getProxy(BayProxy):getShipById(arg0.metaShipID)
	local var1 = MetaCharacterConst.getTacticsSkillIDListByShipConfigID(var0.configId)

	arg0.skillUIItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg1 = arg1 + 1

			local var0 = var1[arg1]

			arg0:updateSkillTF(arg2, var0)
		end
	end)
	arg0.skillUIItemList:align(#var1)
end

function var0.updateShipDetail(arg0)
	local var0 = getProxy(BayProxy):getShipById(arg0.metaShipID)
	local var1 = var0:getPainting()
	local var2 = "SquareIcon/" .. var1

	setImageSprite(arg0.shipIcon, LoadSprite(var2, var1))
	setScrollText(arg0.shipNameText, var0:getName())

	local var3 = arg0.metaProxy:getMetaTacticsInfoByShipID(arg0.metaShipID).curDayExp
	local var4 = setColorStr(var3, "#FFF152FF") .. "/" .. pg.gameset.meta_skill_exp_max.key_value

	setText(arg0.expProgressText, var4)
end

return var0
