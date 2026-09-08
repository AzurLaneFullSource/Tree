local var0_0 = class("ReversePacmanInterviewRoleName", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	return
end

function var0_0.didEnter(arg0_3)
	return
end

function var0_0.RefreshUI(arg0_4, arg1_4)
	local var0_4 = pg.activity_chasing_character[arg1_4]
	local var1_4
	local var2_4 = var0_4.ai_type == ReversePacmanHomeConst.ROLE_TYPE.CHASER and "hire_chaser" or var0_4.ai_type == ReversePacmanHomeConst.ROLE_TYPE.AMBUSHER and "hire_ambusher" or "hire_planner"

	GetImageSpriteFromAtlasAsync("ui/reversepacmanui_atlas", var2_4, arg0_4.uiTypeImage)
	setImageColor(arg0_4.uiQuotesImage, Color.NewHex(var0_4.color))

	local var3_4 = ReversePacmanTools.IsUnlockRole(arg1_4)

	setActive(arg0_4.uiNameMaskGo, not var3_4)
	setActive(arg0_4.uiNameGo, var3_4)

	local var4_4 = var0_4.name

	setScrollText(arg0_4.uiScrollNameText, HXSet.hxLan(var4_4))
end

function var0_0.willExit(arg0_5)
	arg0_5:detach()
end

return var0_0
