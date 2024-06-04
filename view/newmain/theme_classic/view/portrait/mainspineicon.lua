local var0 = class("MainSpineIcon", import(".MainBaseIcon"))

function var0.Resume(arg0)
	if arg0.spineAnim then
		arg0.spineAnim:Resume()
	end
end

function var0.Pause(arg0)
	if not IsNil(arg0.spineAnim) then
		arg0.spineAnim:Pause()
	end
end

function var0.Load(arg0, arg1)
	arg0.loading = true

	PoolMgr.GetInstance():GetSpineChar(arg1, true, function(arg0)
		if arg0.exited then
			return
		end

		LeanTween.cancel(arg0)

		arg0.loading = false
		arg0.shipModel = arg0
		tf(arg0).localScale = Vector3(0.75, 0.75, 1)

		local var0 = pg.ship_spine_shift[arg1]
		local var1 = var0 and var0.mainui_shift[1] or 0
		local var2 = -130 + (var0 and var0.mainui_shift[2] or 0)

		setParent(arg0, arg0._tf)

		tf(arg0).localPosition = Vector3(var1, var2, 0)

		local var3 = arg0:GetComponent("SpineAnimUI")

		var3:SetAction("normal", 0)

		arg0.spineAnim = var3

		onNextTick(function()
			if arg0.spineAnim then
				arg0.spineAnim:Resume()
			end
		end)
	end)

	arg0.name = arg1
end

function var0.Unload(arg0)
	if arg0.name and arg0.shipModel then
		PoolMgr.GetInstance():ReturnSpineChar(arg0.name, arg0.shipModel)

		arg0.spineAnim = nil
		arg0.name = nil
	end
end

return var0
