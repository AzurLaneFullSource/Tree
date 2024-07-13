local var0_0 = class("CryptolaliaMainView")

function var0_0.Ctor(arg0_1, arg1_1)
	setmetatable(arg0_1, {
		__index = function(arg0_2, arg1_2)
			local var0_2 = rawget(arg0_2, "class")

			return var0_2[arg1_2] and var0_2[arg1_2] or arg1_1[arg1_2]
		end
	})

	arg0_1.downloadBtnAnim = arg0_1.downloadBtn:GetComponent(typeof(Animation))
end

function var0_0.Flush(arg0_3, arg1_3, arg2_3, arg3_3)
	if not arg0_3.cryptolalia or arg0_3.cryptolalia.id ~= arg1_3.id then
		arg0_3.shipName.text = arg1_3:GetShipName()
		arg0_3.nameTxt.text = arg1_3:GetName()
		arg0_3.descTxt.text = arg1_3:GetDescription()

		arg0_3.auditionTxt:SetText(arg1_3:GetAuditionTitle())
		arg0_3:LoadCryptolaliaSpriteForShipGroup(arg1_3:GetShipGroupId())

		local var0_3 = not arg1_3:IsForever() and arg1_3:IsLock()

		setActive(arg0_3.timeLimit, var0_3)
		arg0_3:RemoveTimer()
		arg0_3:AddTimer(arg1_3, var0_3)
	end

	arg0_3.authorTxt.text = "CV:" .. arg1_3:GetCvAuthor(arg2_3)

	arg0_3:FlushState(arg1_3, arg2_3, arg3_3)

	arg0_3.cryptolalia = arg1_3
end

function var0_0.AddTimer(arg0_4, arg1_4, arg2_4)
	if arg2_4 then
		local var0_4 = ""

		arg0_4.timer = Timer.New(function()
			local var0_5 = arg1_4:GetExpiredTimeStr()

			if var0_4 ~= var0_5 then
				var0_4 = var0_5
				arg0_4.timeTxt.text = var0_5
			end
		end, 1, -1)

		arg0_4.timer:Start()
		arg0_4.timer.func()
	else
		arg0_4.timeTxt.text = ""
	end
end

function var0_0.FlushState(arg0_6, arg1_6, arg2_6, arg3_6)
	local var0_6 = arg3_6 and Cryptolalia.STATE_DOWNLOADING or arg1_6:GetState(arg2_6)

	setActive(arg0_6.lockBtn, Cryptolalia.STATE_LOCK == var0_6)
	setActive(arg0_6.downloadBtn, Cryptolalia.STATE_DOWNLOADABLE == var0_6)

	if arg0_6.state and arg0_6.state == Cryptolalia.STATE_LOCK and var0_6 == Cryptolalia.STATE_DOWNLOADABLE then
		arg0_6.downloadBtnAnim:Stop()
		arg0_6.downloadBtnAnim:Play("anim_Cryptolalia_dowmload")
	end

	setSlider(arg0_6.downloadingBtn, 0, 1, 0)
	setActive(arg0_6.downloadingBtn, var0_6 == Cryptolalia.STATE_DOWNLOADING)
	setActive(arg0_6.playBtn, Cryptolalia.STATE_PLAYABLE == var0_6)
	setActive(arg0_6.deleteBtn, Cryptolalia.STATE_PLAYABLE == var0_6)
	setText(arg0_6.deleteBtn:Find("label"), i18n("cryptolalia_delete_res", arg1_6:GetResSize(arg2_6)))
	setActive(arg0_6.stateBtn, Cryptolalia.STATE_PLAYABLE ~= var0_6)
	setActive(arg0_6.switchBtn, var0_6 ~= Cryptolalia.STATE_DOWNLOADING and PLATFORM_CODE == PLATFORM_CH and arg1_6:IsMultiVersion())

	local var1_6 = Vector2(0, 0)
	local var2_6 = Vector2(20, -9.2)
	local var3_6 = arg2_6 == Cryptolalia.LANG_TYPE_CH

	setAnchoredPosition(arg0_6.switchBtn:Find("ch"), var3_6 and var1_6 or var2_6)
	setAnchoredPosition(arg0_6.switchBtn:Find("jp"), var3_6 and var2_6 or var1_6)
	setActive(arg0_6.listBtn, var0_6 ~= Cryptolalia.STATE_DOWNLOADING)

	if Cryptolalia.STATE_LOCK == var0_6 then
		arg0_6.stateBtnTxt.text = i18n("cryptolalia_lock_res")
	elseif Cryptolalia.STATE_PLAYABLE ~= var0_6 then
		arg0_6.stateBtnTxt.text = i18n("cryptolalia_not_download_res")
	else
		arg0_6.stateBtnTxt.text = ""
	end

	arg0_6.state = var0_6
end

local function var1_0(arg0_7, arg1_7, arg2_7)
	LoadSpriteAtlasAsync("CryptolaliaShip/" .. arg1_7, "cd", function(arg0_8)
		if arg0_7.exited then
			return
		end

		arg0_7.cdImg.sprite = arg0_8

		arg0_7.cdImg:SetNativeSize()
		arg2_7()
	end)
end

local function var2_0(arg0_9, arg1_9, arg2_9)
	LoadSpriteAtlasAsync("CryptolaliaShip/" .. arg1_9, "name", function(arg0_10)
		if arg0_9.exited then
			return
		end

		arg0_9.cdSignatureImg.sprite = arg0_10

		arg0_9.cdSignatureImg:SetNativeSize()
		arg2_9()
	end)
end

local function var3_0(arg0_11, arg1_11, arg2_11)
	LoadSpriteAtlasAsync("CryptolaliaShip/" .. arg1_11, "name", function(arg0_12)
		if arg0_11.exited then
			return
		end

		arg0_11.signatureImg.sprite = arg0_12

		arg0_11.signatureImg:SetNativeSize()
		arg2_11()
	end)
end

function var0_0.LoadCryptolaliaSpriteForShipGroup(arg0_13, arg1_13)
	arg0_13.cg.blocksRaycasts = false

	parallelAsync({
		function(arg0_14)
			var1_0(arg0_13, arg1_13, arg0_14)
		end
	}, function()
		arg0_13.cg.blocksRaycasts = true
	end)
end

function var0_0.RemoveTimer(arg0_16)
	if arg0_16.timer then
		arg0_16.timer:Stop()

		arg0_16.timer = nil
	end
end

function var0_0.Dispose(arg0_17)
	arg0_17.exited = true

	arg0_17:RemoveTimer()
end

return var0_0
