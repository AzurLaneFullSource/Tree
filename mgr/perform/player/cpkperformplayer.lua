local var0 = class("CpkPerformPlayer", import(".BasePerformPlayer"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.bgTF = arg0:findTF("bg", arg0._tf)
	arg0.nameTF = arg0:findTF("name", arg0.bgTF)
	arg0.sliderTF = arg0:findTF("slider", arg0.bgTF)
	arg0.cpkParentTF = arg0:findTF("cpk", arg0.bgTF)
	arg0.cpkCoverTF = arg0:findTF("cpk_cover", arg0.bgTF)
	arg0.frameRate = Application.targetFrameRate or 60

	local var0 = pg.child_data[1]

	arg0.maxStage = #var0.stage
	arg0.personalityIds = var0.attr_2_list
end

function var0.getCpkName(arg0, arg1)
	local var0 = getProxy(EducateProxy):GetCharData():GetStage()

	if var0 < arg0.maxStage then
		return arg1[var0]
	elseif var0 == arg0.maxStage then
		local var1 = getProxy(EducateProxy):GetPersonalityId()
		local var2 = table.indexof(arg0.personalityIds, var1)

		return arg1[var0][var2]
	end

	return ""
end

function var0.Play(arg0, arg1, arg2, arg3)
	arg0:Show()

	if arg3 then
		setText(arg0.nameTF, arg3)
	end

	setActive(arg0.bgTF, not IsNil(arg0.cpkTF))

	local var0 = arg0:getCpkName(arg1.param[1]) or ""
	local var1 = arg1.param[2] or 3

	if checkABExist("educateanim/" .. var0) then
		ResourceMgr.Inst:getAssetAsync("educateanim/" .. var0, var0, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
			local var0 = Object.Instantiate(arg0, arg0.cpkParentTF)

			setActive(arg0.bgTF, true)

			arg0.player = var0.transform:Find("usm"):GetComponent(typeof(CriManaCpkUI))
			arg0.time = var1

			local var1 = arg0.cpkTF

			arg0.cpkTF = var0

			arg0.player:SetPlayEndHandler(function()
				if arg2 then
					arg2()
				end

				arg0:onCpkEnd()
			end)

			if arg0._anim then
				arg0._anim:Play()
			end

			arg0.player:SetMaxFrameDrop(CriManaMovieMaterial.MaxFrameDrop.Infinite)
			arg0.player:SetCpkTotalTimeCallback(function(arg0)
				arg0.time = arg0

				arg0:onCpkStart(arg0)
			end)
			arg0.player:PlayerManualUpdate()
			arg0.player:PlayCpk()

			if not IsNil(var1) then
				Destroy(var1)
			end
		end), true, true)
	elseif arg2 then
		arg2()
	end
end

function var0.onCpkStart(arg0, arg1)
	setSlider(arg0.sliderTF, 0, 1, 0)

	arg0.playingTime = 0
	arg0.timer = Timer.New(function()
		arg0.playingTime = arg0.playingTime + 1 / arg0.frameRate

		setSlider(arg0.sliderTF, 0, 1, arg0.playingTime / arg1)
	end, 1 / arg0.frameRate, -1)

	arg0.timer:Start()
end

function var0.onCpkEnd(arg0)
	setSlider(arg0.sliderTF, 0, 1, 1)

	if arg0.timer ~= nil then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.SetUIParam(arg0, arg1)
	setAnchoredPosition(arg0.sliderTF, arg1.sliderPos)
	setAnchoredPosition(arg0.cpkParentTF, arg1.cpkPos)
	setAnchoredPosition(arg0.cpkCoverTF, arg1.cpkCoverPos)

	GetComponent(arg0.bgTF, typeof(Image)).enabled = arg1.showCpkBg
end

function var0.Clear(arg0)
	if not IsNil(arg0.cpkTF) then
		Destroy(arg0.cpkTF)
	end

	if arg0.timer ~= nil then
		arg0.timer:Stop()

		arg0.timer = nil
	end

	arg0.player = nil

	setText(arg0.nameTF, "")
	arg0:Hide()
	gcAll()
end

return var0
