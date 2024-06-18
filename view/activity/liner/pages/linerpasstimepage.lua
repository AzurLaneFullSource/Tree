local var0_0 = class("LinerPassTimePage", import("view.base.BaseSubView"))

var0_0.ANIM_TIME = 0.75
var0_0.DELAY_TIME = 0.5

function var0_0.getUIName(arg0_1)
	return "LinerPassTimePage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.rotateTF = arg0_2:findTF("progress/Image")
	arg0_2.dayTF = arg0_2:findTF("time/day")

	setText(arg0_2.dayTF, "DAY")

	arg0_2.beforeDay = arg0_2:findTF("time/day_1")
	arg0_2.afterDay = arg0_2:findTF("time/day_2")
	arg0_2.pointTF = arg0_2:findTF("time/point")
	arg0_2.pointAfterTF = arg0_2:findTF("time/point_after")
	arg0_2.timeAnim = arg0_2:findTF("time"):GetComponent(typeof(Animation))
	arg0_2.anim = arg0_2._tf:GetComponent(typeof(Animation))
	arg0_2.animEvent = arg0_2._tf:GetComponent(typeof(DftAniEvent))

	arg0_2.animEvent:SetEndEvent(function()
		arg0_2:Hide()
	end)
end

function var0_0.OnInit(arg0_4)
	return
end

function var0_0.ShowAnim(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)
	local var0_5 = arg1_5:GetDayByIdx(arg3_5)
	local var1_5 = arg1_5:GetTimeByIdx(arg2_5)
	local var2_5 = arg1_5:GetTimeByIdx(arg3_5)
	local var3_5 = var1_5:GetType() == LinerTime.TYPE.STORY and var0_5 - 1 or var0_5

	setText(arg0_5.beforeDay, string.format("%02d", var3_5))
	setText(arg0_5.afterDay, string.format("%02d", var3_5))
	setText(arg0_5.pointTF, var1_5:GetStartTimeDesc())
	setText(arg0_5.pointAfterTF, var1_5:GetStartTimeDesc())

	local var4_5 = var1_5:GetTime()[1]
	local var5_5 = var2_5:GetTime()[1]
	local var6_5 = var3_5 == var0_5 and "anim_passtime_change" or "anim_passtime_change1"
	local var7_5 = var4_5 > 3 and var4_5 or var4_5 + 24
	local var8_5 = var5_5 > 3 and var5_5 or var5_5 + 24
	local var9_5 = var7_5 - 8
	local var10_5 = var8_5 - 8
	local var11_5 = math.floor(var9_5 * 180 / 19)
	local var12_5 = math.floor(var10_5 * 180 / 19)

	setLocalEulerAngles(arg0_5.rotateTF, {
		z = -var11_5
	})
	arg0_5:Show()
	seriesAsync({
		function(arg0_6)
			arg0_5:managedTween(LeanTween.delayedCall, function()
				arg0_6()
			end, 0.4, nil)
		end,
		function(arg0_8)
			if var11_5 > var12_5 then
				arg0_5:managedTween(LeanTween.delayedCall, function()
					setLocalEulerAngles(arg0_5.rotateTF, {
						z = -var12_5
					})
					arg0_8()
					setText(arg0_5.afterDay, string.format("%02d", var0_5))
					setText(arg0_5.pointAfterTF, var2_5:GetStartTimeDesc())
					arg0_5.timeAnim:Play(var6_5)
				end, var0_0.ANIM_TIME, nil)
			else
				arg0_5:managedTween(LeanTween.value, nil, go(arg0_5.rotateTF), var11_5, var12_5, var0_0.ANIM_TIME):setOnUpdate(System.Action_float(function(arg0_10)
					setLocalEulerAngles(arg0_5.rotateTF, {
						z = -arg0_10
					})
				end)):setEase(LeanTweenType.easeInOutCubic):setOnComplete(System.Action(function()
					arg0_8()
				end))
				setText(arg0_5.afterDay, string.format("%02d", var0_5))
				setText(arg0_5.pointAfterTF, var2_5:GetStartTimeDesc())
				arg0_5.timeAnim:Play(var6_5)
			end
		end,
		function(arg0_12)
			arg0_5:managedTween(LeanTween.delayedCall, function()
				arg0_12()
			end, var0_0.DELAY_TIME, nil)
		end
	}, function()
		if arg4_5 then
			arg4_5()
		end

		arg0_5.anim:Play("anim_passtime_out")
	end)
end

function var0_0.Show(arg0_15)
	var0_0.super.Show(arg0_15)
	pg.UIMgr.GetInstance():BlurPanel(arg0_15._tf)
end

function var0_0.Hide(arg0_16)
	var0_0.super.Hide(arg0_16)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_16._tf)
end

function var0_0.OnDestroy(arg0_17)
	return
end

return var0_0
