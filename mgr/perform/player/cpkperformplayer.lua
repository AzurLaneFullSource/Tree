local var0_0 = class("CpkPerformPlayer", import(".BasePerformPlayer"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.bgTF = arg0_1:findTF("bg", arg0_1._tf)
	arg0_1.nameTF = arg0_1:findTF("name", arg0_1.bgTF)
	arg0_1.sliderTF = arg0_1:findTF("slider", arg0_1.bgTF)
	arg0_1.cpkParentTF = arg0_1:findTF("cpk", arg0_1.bgTF)
	arg0_1.cpkCoverTF = arg0_1:findTF("cpk_cover", arg0_1.bgTF)
	arg0_1.frameRate = Application.targetFrameRate or 60

	local var0_1 = pg.child_data[1]

	arg0_1.maxStage = #var0_1.stage
	arg0_1.personalityIds = var0_1.attr_2_list
end

function var0_0.getCpkName(arg0_2, arg1_2)
	local var0_2 = getProxy(EducateProxy):GetCharData():GetStage()

	if var0_2 < arg0_2.maxStage then
		return arg1_2[var0_2]
	elseif var0_2 == arg0_2.maxStage then
		local var1_2 = getProxy(EducateProxy):GetPersonalityId()
		local var2_2 = table.indexof(arg0_2.personalityIds, var1_2)

		return arg1_2[var0_2][var2_2]
	end

	return ""
end

function var0_0.Play(arg0_3, arg1_3, arg2_3, arg3_3)
	arg0_3:Show()

	if arg3_3 then
		setText(arg0_3.nameTF, arg3_3)
	end

	setActive(arg0_3.bgTF, not IsNil(arg0_3.cpkTF))

	local var0_3 = arg0_3:getCpkName(arg1_3.param[1]) or ""
	local var1_3 = arg1_3.param[2] or 3

	if checkABExist("educateanim/" .. var0_3) then
		LoadAnyAsync("educateanim/" .. var0_3, "", nil, function(arg0_4)
			local var0_4 = Object.Instantiate(arg0_4, arg0_3.cpkParentTF)

			setActive(arg0_3.bgTF, true)

			arg0_3.player = var0_4.transform:Find("usm"):GetComponent(typeof(CriManaCpkUI))
			arg0_3.time = var1_3

			local var1_4 = arg0_3.cpkTF

			arg0_3.cpkTF = var0_4

			arg0_3.player:SetPlayEndHandler(function()
				if arg2_3 then
					arg2_3()
				end

				arg0_3:onCpkEnd()
			end)

			if arg0_3._anim then
				arg0_3._anim:Play()
			end

			arg0_3.player:SetMaxFrameDrop(CriManaMovieMaterial.MaxFrameDrop.Infinite)
			arg0_3.player:SetCpkTotalTimeCallback(function(arg0_6)
				arg0_3.time = arg0_6

				arg0_3:onCpkStart(arg0_6)
			end)
			arg0_3.player:PlayerManualUpdate()
			arg0_3.player:PlayCpk()

			if not IsNil(var1_4) then
				Destroy(var1_4)
			end
		end)
	elseif arg2_3 then
		arg2_3()
	end
end

function var0_0.onCpkStart(arg0_7, arg1_7)
	setSlider(arg0_7.sliderTF, 0, 1, 0)

	arg0_7.playingTime = 0
	arg0_7.timer = Timer.New(function()
		arg0_7.playingTime = arg0_7.playingTime + 1 / arg0_7.frameRate

		setSlider(arg0_7.sliderTF, 0, 1, arg0_7.playingTime / arg1_7)
	end, 1 / arg0_7.frameRate, -1)

	arg0_7.timer:Start()
end

function var0_0.onCpkEnd(arg0_9)
	setSlider(arg0_9.sliderTF, 0, 1, 1)

	if arg0_9.timer ~= nil then
		arg0_9.timer:Stop()

		arg0_9.timer = nil
	end
end

function var0_0.SetUIParam(arg0_10, arg1_10)
	setAnchoredPosition(arg0_10.sliderTF, arg1_10.sliderPos)
	setAnchoredPosition(arg0_10.cpkParentTF, arg1_10.cpkPos)
	setAnchoredPosition(arg0_10.cpkCoverTF, arg1_10.cpkCoverPos)

	GetComponent(arg0_10.bgTF, typeof(Image)).enabled = arg1_10.showCpkBg
end

function var0_0.Clear(arg0_11)
	if not IsNil(arg0_11.cpkTF) then
		Destroy(arg0_11.cpkTF)
	end

	if arg0_11.timer ~= nil then
		arg0_11.timer:Stop()

		arg0_11.timer = nil
	end

	arg0_11.player = nil

	setText(arg0_11.nameTF, "")
	arg0_11:Hide()
	gcAll()
end

return var0_0
