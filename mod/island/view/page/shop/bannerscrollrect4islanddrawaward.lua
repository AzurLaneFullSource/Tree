local var0_0 = class("BannerScrollRect4IslandDrawAward", import("view.newMain.page.BannerScrollRect"))

function var0_0.UpdateDotPosition(arg0_1, arg1_1, arg2_1)
	return
end

function var0_0.TriggerDot(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg2_2 and 26 or 8

	arg1_2:GetComponent(typeof(LayoutElement)).preferredWidth = var0_2

	setActive(arg1_2:Find("dot"), not arg2_2)
	setActive(arg1_2:Find("line"), arg2_2)

	if arg2_2 then
		existCall(arg0_2.triggerDotCall, arg0_2.index)
	end
end

function var0_0.SetUp(arg0_3, arg1_3)
	var0_0.super.SetUp(arg0_3)

	if arg1_3 and arg1_3 > 0 then
		arg0_3:Pause()

		arg0_3.uniqueLT = LeanTween.delayedCall(arg1_3, System.Action(function()
			arg0_3:Resume()
		end))
	end
end

function var0_0.SetTriggerDotCall(arg0_5, arg1_5)
	arg0_5.triggerDotCall = arg1_5
end

function var0_0.Reset(arg0_6)
	var0_0.super.Reset(arg0_6)

	arg0_6.triggerDotCall = nil
end

function var0_0.Dispose(arg0_7)
	var0_0.super.Dispose(arg0_7)
end

return var0_0
