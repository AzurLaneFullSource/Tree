local var0_0 = class("NewEducatePersonalityTipPanel", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "NewEducatePersonalityTipPanel"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.animCom = arg0_2._tf:GetComponent(typeof(Animation))
	arg0_2.animEvent = arg0_2._tf:GetComponent(typeof(DftAniEvent))
	arg0_2.personalityTF = arg0_2._tf:Find("personality")
end

function var0_0.OnInit(arg0_3)
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0_3._tf, {
		pbList = {
			arg0_3.resTF
		},
		groupName = LayerWeightConst.GROUP_EDUCATE,
		weight = LayerWeightConst.BASE_LAYER + 2
	})
end

function var0_0.FlushPersonality(arg0_4, arg1_4, arg2_4)
	arg0_4:Show()

	local var0_4 = arg1_4 > 0 and arg0_4.personalityTF:Find("tag2") or arg0_4.personalityTF:Find("tag1")

	seriesAsync({
		function(arg0_5)
			local var0_5 = arg1_4 > 0 and i18n("child2_personal_tag2") or i18n("child2_personal_tag1")

			setText(var0_4:Find("Text"), var0_5 .. "+" .. math.abs(arg1_4))
			setActive(var0_4, true)
			arg0_4.animEvent:SetEndEvent(function()
				arg0_4.animEvent:SetEndEvent(nil)
				arg0_5()
			end)
			arg0_4.animCom:Play("Anim_educate_personality_show")
		end,
		function(arg0_7)
			local var0_7 = arg0_4.contextData.char:GetPersonalityTag()

			if var0_7 ~= arg2_4 then
				setActive(arg0_4.personalityTF:Find("tag1"), true)
				setText(arg0_4.personalityTF:Find("tag1/Text"), i18n("child2_personal_change"))
				setActive(arg0_4.personalityTF:Find("tag2"), true)
				setText(arg0_4.personalityTF:Find("tag2/Text"), i18n("child2_personal_change"))
				arg0_4.animEvent:SetEndEvent(function()
					arg0_4.animEvent:SetEndEvent(nil)
					arg0_7()
				end)

				local var1_7 = var0_7 == "tag1" and "Anim_educate_personality_2to1" or "Anim_educate_personality_1to2"

				arg0_4.animCom:Play(var1_7)
			else
				arg0_7()
			end
		end
	}, function()
		arg0_4:Hide()
	end)
end

function var0_0.OnDestroy(arg0_10)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_10._tf)
end

return var0_0
