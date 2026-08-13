local var0_0 = class("MainSpineIcon", import(".MainBaseIcon"))

function var0_0.Resume(arg0_1)
	if arg0_1.spineChar and arg0_1.spineChar:GetPauseStatue() ~= nil and not IsNil(arg0_1.spineChar:GetAnimationState()) then
		arg0_1.spineChar:Resume()
	end
end

function var0_0.Pause(arg0_2)
	if arg0_2.spineChar and arg0_2.spineChar:GetPauseStatue() ~= nil and not IsNil(arg0_2.spineChar:GetAnimationState()) then
		arg0_2.spineChar:Pause()
	end
end

function var0_0.Load(arg0_3, arg1_3)
	arg0_3.loading = true
	arg0_3.spineChar = SpineAnimChar.New()

	arg0_3.spineChar:SetPaint(arg1_3)
	arg0_3.spineChar:Load(true, function(arg0_4)
		if arg0_3.exited then
			arg0_3:Unload()

			return
		end

		arg0_3.loading = false
		arg0_3.shipModel = arg0_4:GetModel()

		LeanTween.cancel(arg0_3.shipModel)
		arg0_4:SetNormalAction("normal")
		arg0_4:SetAction("normal", 0)
		arg0_4:SetLocalScale(Vector3(0.75, 0.75, 1))

		local var0_4 = pg.ship_spine_shift[arg1_3]
		local var1_4 = var0_4 and var0_4.mainui_shift[1] or 0
		local var2_4 = -130 + (var0_4 and var0_4.mainui_shift[2] or 0)

		arg0_4:SetParent(arg0_3._tf)
		arg0_4:SetLocalPosition(Vector3(var1_4, var2_4, 0))
		onNextTick(function()
			arg0_4:Resume()
		end)
	end)

	arg0_3.name = arg1_3
end

function var0_0.Unload(arg0_6)
	if arg0_6.spineChar then
		arg0_6.spineChar:Resume()
		arg0_6.spineChar:Dispose()

		arg0_6.spineChar = nil
	end

	arg0_6.name = nil
	arg0_6.shipModel = nil
	arg0_6.spineAnim = nil
end

return var0_0
