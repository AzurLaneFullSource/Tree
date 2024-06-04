local var0 = class("CryptolaliaMainView")

function var0.Ctor(arg0, arg1)
	setmetatable(arg0, {
		__index = function(arg0, arg1)
			local var0 = rawget(arg0, "class")

			return var0[arg1] and var0[arg1] or arg1[arg1]
		end
	})

	arg0.downloadBtnAnim = arg0.downloadBtn:GetComponent(typeof(Animation))
end

function var0.Flush(arg0, arg1, arg2, arg3)
	if not arg0.cryptolalia or arg0.cryptolalia.id ~= arg1.id then
		arg0.shipName.text = arg1:GetShipName()
		arg0.nameTxt.text = arg1:GetName()
		arg0.descTxt.text = arg1:GetDescription()

		arg0.auditionTxt:SetText(arg1:GetAuditionTitle())
		arg0:LoadCryptolaliaSpriteForShipGroup(arg1:GetShipGroupId())

		local var0 = not arg1:IsForever() and arg1:IsLock()

		setActive(arg0.timeLimit, var0)
		arg0:RemoveTimer()
		arg0:AddTimer(arg1, var0)
	end

	arg0.authorTxt.text = "CV:" .. arg1:GetCvAuthor(arg2)

	arg0:FlushState(arg1, arg2, arg3)

	arg0.cryptolalia = arg1
end

function var0.AddTimer(arg0, arg1, arg2)
	if arg2 then
		local var0 = ""

		arg0.timer = Timer.New(function()
			local var0 = arg1:GetExpiredTimeStr()

			if var0 ~= var0 then
				var0 = var0
				arg0.timeTxt.text = var0
			end
		end, 1, -1)

		arg0.timer:Start()
		arg0.timer.func()
	else
		arg0.timeTxt.text = ""
	end
end

function var0.FlushState(arg0, arg1, arg2, arg3)
	local var0 = arg3 and Cryptolalia.STATE_DOWNLOADING or arg1:GetState(arg2)

	setActive(arg0.lockBtn, Cryptolalia.STATE_LOCK == var0)
	setActive(arg0.downloadBtn, Cryptolalia.STATE_DOWNLOADABLE == var0)

	if arg0.state and arg0.state == Cryptolalia.STATE_LOCK and var0 == Cryptolalia.STATE_DOWNLOADABLE then
		arg0.downloadBtnAnim:Stop()
		arg0.downloadBtnAnim:Play("anim_Cryptolalia_dowmload")
	end

	setSlider(arg0.downloadingBtn, 0, 1, 0)
	setActive(arg0.downloadingBtn, var0 == Cryptolalia.STATE_DOWNLOADING)
	setActive(arg0.playBtn, Cryptolalia.STATE_PLAYABLE == var0)
	setActive(arg0.deleteBtn, Cryptolalia.STATE_PLAYABLE == var0)
	setText(arg0.deleteBtn:Find("label"), i18n("cryptolalia_delete_res", arg1:GetResSize(arg2)))
	setActive(arg0.stateBtn, Cryptolalia.STATE_PLAYABLE ~= var0)
	setActive(arg0.switchBtn, var0 ~= Cryptolalia.STATE_DOWNLOADING and PLATFORM_CODE == PLATFORM_CH and arg1:IsMultiVersion())

	local var1 = Vector2(0, 0)
	local var2 = Vector2(20, -9.2)
	local var3 = arg2 == Cryptolalia.LANG_TYPE_CH

	setAnchoredPosition(arg0.switchBtn:Find("ch"), var3 and var1 or var2)
	setAnchoredPosition(arg0.switchBtn:Find("jp"), var3 and var2 or var1)
	setActive(arg0.listBtn, var0 ~= Cryptolalia.STATE_DOWNLOADING)

	if Cryptolalia.STATE_LOCK == var0 then
		arg0.stateBtnTxt.text = i18n("cryptolalia_lock_res")
	elseif Cryptolalia.STATE_PLAYABLE ~= var0 then
		arg0.stateBtnTxt.text = i18n("cryptolalia_not_download_res")
	else
		arg0.stateBtnTxt.text = ""
	end

	arg0.state = var0
end

local function var1(arg0, arg1, arg2)
	LoadSpriteAtlasAsync("CryptolaliaShip/" .. arg1, "cd", function(arg0)
		if arg0.exited then
			return
		end

		arg0.cdImg.sprite = arg0

		arg0.cdImg:SetNativeSize()
		arg2()
	end)
end

local function var2(arg0, arg1, arg2)
	LoadSpriteAtlasAsync("CryptolaliaShip/" .. arg1, "name", function(arg0)
		if arg0.exited then
			return
		end

		arg0.cdSignatureImg.sprite = arg0

		arg0.cdSignatureImg:SetNativeSize()
		arg2()
	end)
end

local function var3(arg0, arg1, arg2)
	LoadSpriteAtlasAsync("CryptolaliaShip/" .. arg1, "name", function(arg0)
		if arg0.exited then
			return
		end

		arg0.signatureImg.sprite = arg0

		arg0.signatureImg:SetNativeSize()
		arg2()
	end)
end

function var0.LoadCryptolaliaSpriteForShipGroup(arg0, arg1)
	arg0.cg.blocksRaycasts = false

	parallelAsync({
		function(arg0)
			var1(arg0, arg1, arg0)
		end
	}, function()
		arg0.cg.blocksRaycasts = true
	end)
end

function var0.RemoveTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.Dispose(arg0)
	arg0.exited = true

	arg0:RemoveTimer()
end

return var0
