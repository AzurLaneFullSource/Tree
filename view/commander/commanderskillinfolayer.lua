local var0 = class("CommanderSkillInfoLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "CommanderSkillInfoUI"
end

function var0.init(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)

	arg0.skillNameTxt = arg0:findTF("panel/bg/skill_name"):GetComponent(typeof(Text))
	arg0.skillLevelTxt = arg0:findTF("panel/bg/skill_lv"):GetComponent(typeof(Text))
	arg0.skillDescTxt = arg0:findTF("panel/bg/help_panel/skill_intro"):GetComponent(typeof(Text))
	arg0.skillIcon = arg0:findTF("panel/bg/skill_icon")
end

function var0.didEnter(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:emit(var0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0, arg0:findTF("panel/top/btnBack"), function()
		arg0:emit(var0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0, arg0:findTF("panel/ok_button"), function()
		arg0:emit(var0.ON_CLOSE)
	end, SFX_CONFIRM)
	arg0:updateSkill()
end

function var0.updateSkill(arg0)
	local var0 = arg0.contextData.skill

	arg0.skillNameTxt.text = var0:getConfig("name")
	arg0.skillLevelTxt.text = "Lv." .. var0:getLevel()
	arg0.skillDescTxt.text = var0:getConfig("desc")

	GetImageSpriteFromAtlasAsync("CommanderSkillIcon/" .. var0:getConfig("icon"), "", arg0.skillIcon)
end

function var0.close(arg0)
	arg0:emit(var0.ON_CLOSE)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
