local var0_0 = class("BossRushAlvitFleetSelectView", import("view.activity.BossRush.BossRushFleetSelectView"))

function var0_0.GetTextColor(arg0_1)
	return Color.NewHex("1C231F"), Color.NewHex("979A98")
end

function var0_0.getUIName(arg0_2)
	return "BossRushAlvitFleetSelectUI"
end

function var0_0.tempCache(arg0_3)
	return true
end

function var0_0.didEnter(arg0_4)
	var0_0.super.didEnter(arg0_4)
	removeOnButton(arg0_4._tf:Find("BG"))
	onButton(arg0_4, arg0_4._tf:Find("BG/close"), function()
		arg0_4:onCancelHard()
	end, SFX_CANCEL)

	arg0_4.anim = arg0_4._tf:GetComponent(typeof(Animation))
	arg0_4.animEvent = arg0_4.anim:GetComponent(typeof(DftAniEvent))

	arg0_4.animEvent:SetEndEvent(function()
		var0_0.super.onCancelHard(arg0_4)
	end)
end

function var0_0.onCancelHard(arg0_7)
	arg0_7.anim:Play("anim_kinder_fleetselect_out")
end

return var0_0
