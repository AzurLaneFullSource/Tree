local var0_0 = class("NewEducateCpkHandler")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1._anim = arg0_1._tf:GetComponent(typeof(Animation))
	arg0_1.bgTF = arg0_1._tf:Find("bg")
	arg0_1.nameTF = arg0_1.bgTF:Find("name")
	arg0_1.sliderTF = arg0_1.bgTF:Find("slider")
	arg0_1.cpkPlayer = arg0_1.bgTF:Find("cpk/usm"):GetComponent(typeof(CriManaCpkUI))

	arg0_1.cpkPlayer:SetMaxFrameDrop(CriManaMovieMaterial.MaxFrameDrop.Infinite)

	arg0_1.cpkCoverTF = arg0_1.bgTF:Find("cpk_cover")
	arg0_1.frameRate = Application.targetFrameRate or 60
end

function var0_0.SetCriManaCpkUIParam(arg0_2, arg1_2)
	arg0_2.cpkPlayer.cpkPath = string.lower("OriginSource/cpk/" .. arg1_2 .. ".cpk")
	arg0_2.cpkPlayer.movieName = string.lower(arg1_2 .. ".bytes")
end

function var0_0.Play(arg0_3, arg1_3, arg2_3, arg3_3)
	setActive(arg0_3._go, true)

	if arg0_3._anim then
		arg0_3._anim:Play()
	end

	arg0_3.cpkPlayer:StopCpk()
	arg0_3.cpkPlayer.player:Stop()
	setText(arg0_3.nameTF, arg3_3 or "")
	arg0_3:SetCriManaCpkUIParam(arg1_3)
	arg0_3.cpkPlayer:SetCpkTotalTimeCallback(function(arg0_4)
		arg0_3.totalTime = arg0_4

		arg0_3:OnStartCpk()
	end)
	arg0_3.cpkPlayer:SetPlayEndHandler(function()
		existCall(arg2_3)
		arg0_3:OnEndCpk()
	end)
	arg0_3.cpkPlayer:PlayCpk()
end

function var0_0.OnStartCpk(arg0_6)
	setSlider(arg0_6.sliderTF, 0, 1, 0)

	arg0_6.passTime = 0
	arg0_6.timer = Timer.New(function()
		arg0_6.passTime = arg0_6.passTime + 1 / arg0_6.frameRate

		setSlider(arg0_6.sliderTF, 0, 1, arg0_6.passTime / arg0_6.totalTime)
	end, 1 / arg0_6.frameRate, -1)

	arg0_6.timer:Start()
end

function var0_0.OnEndCpk(arg0_8)
	setSlider(arg0_8.sliderTF, 0, 1, 1)

	if arg0_8.timer ~= nil then
		arg0_8.timer:Stop()

		arg0_8.timer = nil
	end

	arg0_8.cpkPlayer:SetPlayEndHandler(nil)
end

function var0_0.SetUIParam(arg0_9, arg1_9)
	setAnchoredPosition(arg0_9.bgTF, arg1_9 and {
		x = 146,
		y = -45
	} or {
		x = 0,
		y = 0
	})

	GetComponent(arg0_9.bgTF, typeof(Image)).enabled = not arg1_9
end

function var0_0.Reset(arg0_10)
	setActive(arg0_10._go, false)
end

function var0_0.Destroy(arg0_11)
	return
end

return var0_0
