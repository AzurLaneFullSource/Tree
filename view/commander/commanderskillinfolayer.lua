local var0_0 = class("CommanderSkillInfoLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "CommanderSkillInfoUI"
end

function var0_0.init(arg0_2)
	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf)

	arg0_2.skillNameTxt = arg0_2:findTF("panel/bg/skill_name"):GetComponent(typeof(Text))
	arg0_2.skillLevelTxt = arg0_2:findTF("panel/bg/skill_lv"):GetComponent(typeof(Text))
	arg0_2.skillDescTxt = arg0_2:findTF("panel/bg/help_panel/skill_intro"):GetComponent(typeof(Text))
	arg0_2.skillIcon = arg0_2:findTF("panel/bg/skill_icon")
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:emit(var0_0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3:findTF("panel/top/btnBack"), function()
		arg0_3:emit(var0_0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3:findTF("panel/ok_button"), function()
		arg0_3:emit(var0_0.ON_CLOSE)
	end, SFX_CONFIRM)
	arg0_3:updateSkill()
end

function var0_0.updateSkill(arg0_7)
	local var0_7 = arg0_7.contextData.skill

	arg0_7.skillNameTxt.text = var0_7:getConfig("name")
	arg0_7.skillLevelTxt.text = "Lv." .. var0_7:getLevel()
	arg0_7.skillDescTxt.text = var0_7:getConfig("desc")

	GetImageSpriteFromAtlasAsync("CommanderSkillIcon/" .. var0_7:getConfig("icon"), "", arg0_7.skillIcon)
end

function var0_0.close(arg0_8)
	arg0_8:emit(var0_0.ON_CLOSE)
end

function var0_0.willExit(arg0_9)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_9._tf)
end

return var0_0
