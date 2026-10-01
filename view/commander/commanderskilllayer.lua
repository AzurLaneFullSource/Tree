local var0_0 = class("CommanderSkillLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "CommanderSkillUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {}
	local var1_2 = arg1_2 and arg1_2.skill

	if var1_2 then
		local var2_2 = ResPathSupport.CombinePath(ResPathSupport.ConstPath.Commander.CommanderSkillIcon, var1_2:getConfig("icon"))

		table.insert(var0_2, var2_2)
	end

	return table.insertto(var0_2, var0_0.super.getResource(arg0_2, arg1_2))
end

function var0_0.init(arg0_3)
	local var0_3 = arg0_3.contextData.skill

	arg0_3.backBtn = arg0_3._tf:Find("top/btnBack")
	arg0_3.skillInfoName = arg0_3._tf:Find("panel/bg/skill_name")
	arg0_3.skillInfoLv = arg0_3._tf:Find("panel/bg/skill_lv")
	arg0_3.skillInfoIntro = arg0_3._tf:Find("panel/bg/help_panel/skill_intro")
	arg0_3.skillInfoIcon = arg0_3._tf:Find("panel/bg/skill_icon")
	arg0_3.buttonList = arg0_3._tf:Find("panel/buttonList")
	arg0_3.skillDescTF = arg0_3._tf:Find("panel/bg/help_panel/Viewport/content/introTF")
	arg0_3.skillDescContent = arg0_3._tf:Find("panel/bg/help_panel/Viewport/content")

	setText(arg0_3.skillInfoName, var0_3:getConfig("name"))
	setText(arg0_3.skillInfoLv, "Lv." .. var0_3:getLevel())

	arg0_3.skillDescList = UIItemList.New(arg0_3.skillDescContent, arg0_3.skillDescTF)

	GetImageSpriteFromAtlasAsync("commanderskillicon/" .. var0_3:getConfig("icon"), "", arg0_3.skillInfoIcon)
	arg0_3:SetLocaliza()
end

function var0_0.SetLocaliza(arg0_4)
	setText(arg0_4._tf:Find("top/title_list/infomation/title"), i18n("words_information"))
	setText(arg0_4._tf:Find("panel/buttonList/ok_button/Image"), i18n("word_ok"))
end

function var0_0.didEnter(arg0_5)
	onButton(arg0_5, arg0_5._tf, function()
		arg0_5:emit(var0_0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5.backBtn, function()
		arg0_5:emit(var0_0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5._tf:Find("panel/buttonList/ok_button"), function()
		arg0_5:emit(var0_0.ON_CLOSE)
	end, SFX_CONFIRM)
	pg.UIMgr.GetInstance():BlurPanel(arg0_5._tf)

	arg0_5.commonFlag = defaultValue(arg0_5.contextData.commonFlag, true)

	arg0_5:UpdateList()
end

function var0_0.UpdateList(arg0_9)
	local var0_9 = arg0_9.contextData.skill
	local var1_9 = var0_9:getConfig("lv")
	local var2_9 = var0_9:GetSkillGroup()
	local var3_9 = var0_9:getConfig("lv")

	arg0_9.skillDescList:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			local var0_10 = var2_9[arg1_10 + 1]
			local var1_10 = arg0_9:GetDesc(arg0_9.commonFlag, var0_10)
			local var2_10 = arg0_9:GetColor(var3_9 >= var0_10.lv)
			local var3_10 = var3_9 < var0_10.lv and "(Lv." .. var0_10.lv .. i18n("word_take_effect") .. ")" or ""

			setText(arg2_10, "<color=" .. var2_10 .. ">" .. var1_10 .. var3_10 .. "</color>")
			setText(arg2_10:Find("level"), "<color=" .. var2_10 .. ">" .. "Lv." .. var0_10.lv .. "</color>")
		end
	end)
	arg0_9.skillDescList:align(#var2_9)
end

function var0_0.GetDesc(arg0_11, arg1_11, arg2_11)
	if not arg1_11 and arg2_11.desc_world and arg2_11.desc_world ~= "" then
		return arg2_11.desc_world
	else
		return arg2_11.desc
	end
end

function var0_0.GetColor(arg0_12, arg1_12)
	return "#FFFFFFFF"
end

function var0_0.willExit(arg0_13)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_13._tf)
end

function var0_0.onBackPressed(arg0_14)
	triggerButton(arg0_14.backBtn)
end

return var0_0
