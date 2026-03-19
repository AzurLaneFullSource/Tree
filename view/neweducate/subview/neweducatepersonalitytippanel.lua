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
	arg0_3:OverlayPanel(arg0_3._tf, {
		groupDelta = 2,
		pbList = {
			arg0_3.resTF
		}
	})

	local var0_3 = arg0_3.contextData.char:getConfig("personality_tag_icon")
	local var1_3 = underscore.detect(var0_3, function(arg0_4)
		return arg0_4[1] == "tag1"
	end)[2]

	LoadImageSpriteAsync("neweducateicon/" .. var1_3, arg0_3.personalityTF:Find("tag1"), true)

	local var2_3 = underscore.detect(var0_3, function(arg0_5)
		return arg0_5[1] == "tag2"
	end)[2]

	LoadImageSpriteAsync("neweducateicon/" .. var2_3, arg0_3.personalityTF:Find("tag2"), true)
end

function var0_0.FlushPersonality(arg0_6, arg1_6, arg2_6)
	arg0_6:Show()

	local var0_6 = arg1_6 > 0 and arg0_6.personalityTF:Find("tag2") or arg0_6.personalityTF:Find("tag1")

	seriesAsync({
		function(arg0_7)
			local var0_7 = arg1_6 > 0 and arg0_6.contextData.char:GetPersonalityTagTip(2) or arg0_6.contextData.char:GetPersonalityTagTip(1)

			setText(var0_6:Find("Text"), var0_7 .. "+" .. math.abs(arg1_6))
			setActive(var0_6, true)
			arg0_6.animEvent:SetEndEvent(function()
				arg0_6.animEvent:SetEndEvent(nil)
				arg0_7()
			end)
			arg0_6.animCom:Play("Anim_educate_personality_show")
		end,
		function(arg0_9)
			local var0_9 = arg0_6.contextData.char:GetPersonalityTag()

			if var0_9 ~= arg2_6 then
				setActive(arg0_6.personalityTF:Find("tag1"), true)
				setText(arg0_6.personalityTF:Find("tag1/Text"), i18n("child2_personal_change"))
				setActive(arg0_6.personalityTF:Find("tag2"), true)
				setText(arg0_6.personalityTF:Find("tag2/Text"), i18n("child2_personal_change"))
				arg0_6.animEvent:SetEndEvent(function()
					arg0_6.animEvent:SetEndEvent(nil)
					arg0_9()
				end)

				local var1_9 = var0_9 == "tag1" and "Anim_educate_personality_2to1" or "Anim_educate_personality_1to2"

				arg0_6.animCom:Play(var1_9)
			else
				arg0_9()
			end
		end
	}, function()
		arg0_6:Hide()
	end)
end

function var0_0.OnDestroy(arg0_12)
	arg0_12:UnOverlayPanel(arg0_12._tf)
end

return var0_0
