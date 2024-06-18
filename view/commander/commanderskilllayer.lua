local var0_0 = class("CommanderSkillLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "CommanderSkillUI"
end

function var0_0.init(arg0_2)
	local var0_2 = arg0_2.contextData.skill

	arg0_2.backBtn = arg0_2:findTF("top/btnBack")
	arg0_2.skillInfoName = arg0_2:findTF("panel/bg/skill_name")
	arg0_2.skillInfoLv = arg0_2:findTF("panel/bg/skill_lv")
	arg0_2.skillInfoIntro = arg0_2:findTF("panel/bg/help_panel/skill_intro")
	arg0_2.skillInfoIcon = arg0_2:findTF("panel/bg/skill_icon")
	arg0_2.buttonList = arg0_2:findTF("panel/buttonList")
	arg0_2.skillDescTF = arg0_2:findTF("panel/bg/help_panel/Viewport/content/introTF")
	arg0_2.skillDescContent = arg0_2:findTF("panel/bg/help_panel/Viewport/content")

	setText(arg0_2.skillInfoName, var0_2:getConfig("name"))
	setText(arg0_2.skillInfoLv, "Lv." .. var0_2:getLevel())

	arg0_2.skillDescList = UIItemList.New(arg0_2.skillDescContent, arg0_2.skillDescTF)

	GetImageSpriteFromAtlasAsync("commanderskillicon/" .. var0_2:getConfig("icon"), "", arg0_2.skillInfoIcon)
	arg0_2:SetLocaliza()
end

function var0_0.SetLocaliza(arg0_3)
	setText(arg0_3:findTF("top/title_list/infomation/title"), i18n("words_information"))
	setText(arg0_3:findTF("panel/buttonList/ok_button/Image"), i18n("word_ok"))
end

function var0_0.didEnter(arg0_4)
	onButton(arg0_4, arg0_4._tf, function()
		arg0_4:emit(var0_0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0_4, arg0_4.backBtn, function()
		arg0_4:emit(var0_0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0_4, arg0_4:findTF("panel/buttonList/ok_button"), function()
		arg0_4:emit(var0_0.ON_CLOSE)
	end, SFX_CONFIRM)
	pg.UIMgr.GetInstance():BlurPanel(arg0_4._tf)

	arg0_4.commonFlag = defaultValue(arg0_4.contextData.commonFlag, true)

	arg0_4:UpdateList()
end

function var0_0.UpdateList(arg0_8)
	local var0_8 = arg0_8.contextData.skill
	local var1_8 = var0_8:getConfig("lv")
	local var2_8 = var0_8:GetSkillGroup()
	local var3_8 = var0_8:getConfig("lv")

	arg0_8.skillDescList:make(function(arg0_9, arg1_9, arg2_9)
		if arg0_9 == UIItemList.EventUpdate then
			local var0_9 = var2_8[arg1_9 + 1]
			local var1_9 = arg0_8:GetDesc(arg0_8.commonFlag, var0_9)
			local var2_9 = arg0_8:GetColor(var3_8 >= var0_9.lv)
			local var3_9 = var3_8 < var0_9.lv and "(Lv." .. var0_9.lv .. i18n("word_take_effect") .. ")" or ""

			setText(arg2_9, "<color=" .. var2_9 .. ">" .. var1_9 .. var3_9 .. "</color>")
			setText(arg2_9:Find("level"), "<color=" .. var2_9 .. ">" .. "Lv." .. var0_9.lv .. "</color>")
		end
	end)
	arg0_8.skillDescList:align(#var2_8)
end

function var0_0.GetDesc(arg0_10, arg1_10, arg2_10)
	if not arg1_10 and arg2_10.desc_world and arg2_10.desc_world ~= "" then
		return arg2_10.desc_world
	else
		return arg2_10.desc
	end
end

function var0_0.GetColor(arg0_11, arg1_11)
	return "#FFFFFFFF"
end

function var0_0.willExit(arg0_12)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_12._tf)
end

function var0_0.onBackPressed(arg0_13)
	triggerButton(arg0_13.backBtn)
end

return var0_0
