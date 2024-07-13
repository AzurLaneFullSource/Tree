local var0_0 = class("MainSpineIcon", import(".MainBaseIcon"))

function var0_0.Resume(arg0_1)
	if arg0_1.spineAnim then
		arg0_1.spineAnim:Resume()
	end
end

function var0_0.Pause(arg0_2)
	if not IsNil(arg0_2.spineAnim) then
		arg0_2.spineAnim:Pause()
	end
end

function var0_0.Load(arg0_3, arg1_3)
	arg0_3.loading = true

	PoolMgr.GetInstance():GetSpineChar(arg1_3, true, function(arg0_4)
		if arg0_3.exited then
			return
		end

		LeanTween.cancel(arg0_4)

		arg0_3.loading = false
		arg0_3.shipModel = arg0_4
		tf(arg0_4).localScale = Vector3(0.75, 0.75, 1)

		local var0_4 = pg.ship_spine_shift[arg1_3]
		local var1_4 = var0_4 and var0_4.mainui_shift[1] or 0
		local var2_4 = -130 + (var0_4 and var0_4.mainui_shift[2] or 0)

		setParent(arg0_4, arg0_3._tf)

		tf(arg0_4).localPosition = Vector3(var1_4, var2_4, 0)

		local var3_4 = arg0_4:GetComponent("SpineAnimUI")

		var3_4:SetAction("normal", 0)

		arg0_3.spineAnim = var3_4

		onNextTick(function()
			if arg0_3.spineAnim then
				arg0_3.spineAnim:Resume()
			end
		end)
	end)

	arg0_3.name = arg1_3
end

function var0_0.Unload(arg0_6)
	if arg0_6.name and arg0_6.shipModel then
		arg0_6.spineAnim:Resume()
		PoolMgr.GetInstance():ReturnSpineChar(arg0_6.name, arg0_6.shipModel)

		arg0_6.spineAnim = nil
		arg0_6.name = nil
	end
end

return var0_0
