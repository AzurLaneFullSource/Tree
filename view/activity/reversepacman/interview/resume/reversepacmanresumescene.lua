local var0_0 = class("ReversePacmanResumeScene", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	onButton(arg0_2, arg0_2.uiCloseBtn, function()
		arg0_2:emit(ReversePacmanInterviewScene.ON_CLOSE_RESUME)
	end, SOUND_BACK)
	setText(arg0_2.uiSpeedTitleText, i18n("reverse_pacman_resume_speed"))
	setText(arg0_2.uiTypeTitleText, i18n("reverse_pacman_resume_ai_type"))
	setText(arg0_2.uiTypeDescTitleText, i18n("reverse_pacman_resume_ai_desc"))
	setText(arg0_2.uiCloseText, i18n("reverse_pacman_resume_close_1"))
end

function var0_0.didEnter(arg0_4, arg1_4)
	local var0_4 = pg.activity_chasing_character[arg1_4]
	local var1_4 = ShipGroup.getDefaultShipConfig(pg.ship_skin_template[var0_4.skin_id].ship_group).id
	local var2_4 = Ship.New({
		id = var1_4,
		configId = var1_4,
		skin_id = var0_4.skin_id
	})

	GetImageSpriteFromAtlasAsync("shipYardIcon/" .. var2_4:getPainting(), var2_4:getPainting(), arg0_4.uiIconImage)

	local var3_4 = 0
	local var4_4 = ReversePacmanTools.GetFavorabilityValue(arg1_4)

	for iter0_4, iter1_4 in ipairs(var0_4.love_level) do
		if var4_4 >= iter1_4[2] then
			setFillAmount(arg0_4[string.format("uiHeartImage%s", iter0_4)], 1)
		else
			local var5_4 = var4_4 - var3_4

			if var5_4 < 0 then
				var5_4 = 0
			end

			setFillAmount(arg0_4[string.format("uiHeartImage%s", iter0_4)], var5_4 / (iter1_4[2] - var3_4))
		end

		var3_4 = iter1_4[2]
	end

	setText(arg0_4.uiNameText, HXSet.hxLan(var0_4.name))

	local var6_4 = ReversePacmanHomeConst.GetSpeedLevel(var0_4.base_speed)

	setText(arg0_4.uiSpeedText, i18n("reverse_pacman_speed_level", var6_4.color, var6_4.value))

	local var7_4
	local var8_4 = var0_4.ai_type == ReversePacmanHomeConst.ROLE_TYPE.CHASER and "reverse_pacman_type_chaser_1" or var0_4.ai_type == ReversePacmanHomeConst.ROLE_TYPE.AMBUSHER and "reverse_pacman_type_ambusher_1" or "reverse_pacman_type_planner_1"

	setText(arg0_4.uiTypeText, i18n(var8_4))
	setText(arg0_4.uiTypeDescText, var0_4.trait_text)
	setText(arg0_4.uiDescText, var0_4.resume_text)
end

function var0_0.willExit(arg0_5)
	arg0_5:detach()
end

return var0_0
