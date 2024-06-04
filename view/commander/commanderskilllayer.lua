local var0 = class("CommanderSkillLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "CommanderSkillUI"
end

function var0.init(arg0)
	local var0 = arg0.contextData.skill

	arg0.backBtn = arg0:findTF("top/btnBack")
	arg0.skillInfoName = arg0:findTF("panel/bg/skill_name")
	arg0.skillInfoLv = arg0:findTF("panel/bg/skill_lv")
	arg0.skillInfoIntro = arg0:findTF("panel/bg/help_panel/skill_intro")
	arg0.skillInfoIcon = arg0:findTF("panel/bg/skill_icon")
	arg0.buttonList = arg0:findTF("panel/buttonList")
	arg0.skillDescTF = arg0:findTF("panel/bg/help_panel/Viewport/content/introTF")
	arg0.skillDescContent = arg0:findTF("panel/bg/help_panel/Viewport/content")

	setText(arg0.skillInfoName, var0:getConfig("name"))
	setText(arg0.skillInfoLv, "Lv." .. var0:getLevel())

	arg0.skillDescList = UIItemList.New(arg0.skillDescContent, arg0.skillDescTF)

	GetImageSpriteFromAtlasAsync("commanderskillicon/" .. var0:getConfig("icon"), "", arg0.skillInfoIcon)
	arg0:SetLocaliza()
end

function var0.SetLocaliza(arg0)
	setText(arg0:findTF("top/title_list/infomation/title"), i18n("words_information"))
	setText(arg0:findTF("panel/buttonList/ok_button/Image"), i18n("word_ok"))
end

function var0.didEnter(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:emit(var0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0, arg0.backBtn, function()
		arg0:emit(var0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0, arg0:findTF("panel/buttonList/ok_button"), function()
		arg0:emit(var0.ON_CLOSE)
	end, SFX_CONFIRM)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)

	arg0.commonFlag = defaultValue(arg0.contextData.commonFlag, true)

	arg0:UpdateList()
end

function var0.UpdateList(arg0)
	local var0 = arg0.contextData.skill
	local var1 = var0:getConfig("lv")
	local var2 = var0:GetSkillGroup()
	local var3 = var0:getConfig("lv")

	arg0.skillDescList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var2[arg1 + 1]
			local var1 = arg0:GetDesc(arg0.commonFlag, var0)
			local var2 = arg0:GetColor(var3 >= var0.lv)
			local var3 = var3 < var0.lv and "(Lv." .. var0.lv .. i18n("word_take_effect") .. ")" or ""

			setText(arg2, "<color=" .. var2 .. ">" .. var1 .. var3 .. "</color>")
			setText(arg2:Find("level"), "<color=" .. var2 .. ">" .. "Lv." .. var0.lv .. "</color>")
		end
	end)
	arg0.skillDescList:align(#var2)
end

function var0.GetDesc(arg0, arg1, arg2)
	if not arg1 and arg2.desc_world and arg2.desc_world ~= "" then
		return arg2.desc_world
	else
		return arg2.desc
	end
end

function var0.GetColor(arg0, arg1)
	return "#FFFFFFFF"
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

function var0.onBackPressed(arg0)
	triggerButton(arg0.backBtn)
end

return var0
