pg = pg or {}
pg.CpkPlayMgr = singletonClass("CpkPlayMgr")

local var0_0 = pg.CpkPlayMgr

function var0_0.Ctor(arg0_1)
	arg0_1._onPlaying = false
	arg0_1._mainTF = nil
	arg0_1._closeLimit = nil
	arg0_1._animator = nil
	arg0_1._timer = nil
	arg0_1._criUsm = nil
	arg0_1._criCpk = nil
	arg0_1._stopGameBGM = false
end

function var0_0.Reset(arg0_2)
	arg0_2._onPlaying = false
	arg0_2._mainTF = nil
	arg0_2._closeLimit = nil
	arg0_2._animator = nil
	arg0_2._criUsm = nil
	arg0_2._criCpk = nil
	arg0_2._stopGameBGM = false
	arg0_2._timer = nil
end

function var0_0.OnPlaying(arg0_3)
	return arg0_3._onPlaying
end

function var0_0.PlayCpkMovie(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4, arg5_4, arg6_4, arg7_4, arg8_4, arg9_4)
	pg.DelegateInfo.New(arg0_4)

	arg0_4._onPlaying = true
	arg0_4._stopGameBGM = arg6_4

	pg.UIMgr.GetInstance():LoadingOn()

	local function var0_4()
		if arg0_4.debugTimer then
			arg0_4.debugTimer:Stop()
		end

		if not arg0_4._mainTF then
			return
		end

		if not arg9_4 and Time.realtimeSinceStartup < arg0_4._closeLimit then
			return
		end

		setActive(arg0_4._mainTF, false)
		arg0_4:DisposeCpkMovie()

		if arg2_4 then
			arg2_4()
		end
	end

	local function var1_4()
		onButton(arg0_4, arg0_4._mainTF, function()
			if arg5_4 then
				var0_4()
			end
		end)

		if arg0_4._criUsm then
			arg0_4._criUsm.player:SetVolume(PlayerPrefs.GetFloat("bgm_vol", DEFAULT_BGMVOLUME))
			arg0_4._criUsm.player:SetShaderDispatchCallback(function(arg0_8, arg1_8)
				arg0_4:CheckRatioFitter()
				arg0_4:checkBgmStop(arg0_8)

				return nil
			end)
		end

		if arg0_4._criCpk then
			arg0_4._criCpk.player:SetVolume(PlayerPrefs.GetFloat("bgm_vol", DEFAULT_BGMVOLUME))
			arg0_4._criCpk.player:SetShaderDispatchCallback(function(arg0_9, arg1_9)
				arg0_4:CheckRatioFitter()
				arg0_4:checkBgmStop(arg0_9)

				return nil
			end)
		end

		if arg0_4._animator ~= nil then
			arg0_4._animator.enabled = true

			local var0_6 = arg0_4._mainTF:GetComponent("DftAniEvent")

			var0_6:SetStartEvent(function(arg0_10)
				if arg0_4._criUsm then
					arg0_4._criUsm:Play()
				end
			end)
			var0_6:SetEndEvent(function(arg0_11)
				var0_4()
			end)
		else
			arg0_4._timer = Timer.New(var0_4, arg8_4)

			arg0_4._timer:Start()
		end

		setActive(arg0_4._mainTF, true)

		if arg0_4._stopGameBGM then
			pg.BgmMgr.GetInstance():StopPlay()
		end

		if arg1_4 then
			arg1_4()
		end
	end

	if IsNil(arg0_4._mainTF) then
		LoadAndInstantiateAsync(arg3_4, arg4_4, function(arg0_12)
			pg.UIMgr.GetInstance():LoadingOff()

			arg0_4._closeLimit = Time.realtimeSinceStartup + 1

			if not arg0_4._onPlaying then
				Destroy(arg0_12)

				return
			end

			arg0_4._parentTF = arg0_4._parentTF or GameObject.Find("UICamera/Canvas")

			setParent(arg0_12, arg0_4._parentTF)

			arg0_4._ratioFitter = arg0_12:GetComponent("AspectRatioFitter")
			arg0_4._mainTF = arg0_12

			pg.UIMgr.GetInstance():OverlayPanel(arg0_4._mainTF.transform, arg7_4)

			arg0_4._criUsm = tf(arg0_4._mainTF):Find("usm"):GetComponent("CriManaEffectUI")
			arg0_4._criCpk = tf(arg0_4._mainTF):Find("usm"):GetComponent("CriManaCpkUI")
			arg0_4._usmImg = tf(arg0_4._mainTF):Find("usm"):GetComponent("Image")
			arg0_4._animator = arg0_4._mainTF:GetComponent("Animator")

			if arg0_4._criUsm then
				arg0_4._criUsm.renderMode = ReflectionHelp.RefGetField(typeof("CriManaMovieMaterial+RenderMode"), "Always", nil)
			end

			if arg0_4._usmImg and arg0_4._usmImg.color.a == 0 then
				arg0_4._usmImg.color = Color.New(1, 1, 1, 0.1)
			end

			var1_4()
		end)
	else
		var1_4()
	end
end

function var0_0.CheckRatioFitter(arg0_13)
	if arg0_13._ratioFitter then
		arg0_13._ratioFitter.enabled = true
		arg0_13._ratioFitter = nil
	end
end

function var0_0.checkBgmStop(arg0_14, arg1_14)
	if arg0_14._onPlaying then
		local var0_14 = arg1_14.numAudioStreams

		if var0_14 and var0_14 > 0 then
			pg.BgmMgr.GetInstance():StopPlay()

			arg0_14._stopGameBGM = true
		end
	end
end

function var0_0.DisposeCpkMovie(arg0_15)
	if arg0_15._onPlaying then
		if arg0_15._mainTF then
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_15._mainTF.transform, arg0_15._tf)
			Destroy(arg0_15._mainTF)

			if arg0_15._animator ~= nil then
				arg0_15._animator.enabled = false
			end

			if arg0_15._timer ~= nil then
				arg0_15._timer:Stop()

				arg0_15._timer = nil
			end

			if arg0_15._criUsm then
				arg0_15._criUsm:Stop()
			end

			if arg0_15._stopGameBGM then
				pg.BgmMgr.GetInstance():ContinuePlay()
			end

			arg0_15._onPlaying = false

			pg.DelegateInfo.Dispose(arg0_15)
		end

		arg0_15:Reset()
	end
end
