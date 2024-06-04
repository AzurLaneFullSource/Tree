pg = pg or {}
pg.CpkPlayMgr = singletonClass("CpkPlayMgr")

local var0 = pg.CpkPlayMgr

function var0.Ctor(arg0)
	arg0._onPlaying = false
	arg0._mainTF = nil
	arg0._closeLimit = nil
	arg0._animator = nil
	arg0._timer = nil
	arg0._criUsm = nil
	arg0._criCpk = nil
	arg0._stopGameBGM = false
end

function var0.Reset(arg0)
	arg0._onPlaying = false
	arg0._mainTF = nil
	arg0._closeLimit = nil
	arg0._animator = nil
	arg0._criUsm = nil
	arg0._criCpk = nil
	arg0._stopGameBGM = false
	arg0._timer = nil
end

function var0.OnPlaying(arg0)
	return arg0._onPlaying
end

function var0.PlayCpkMovie(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	pg.DelegateInfo.New(arg0)

	arg0._onPlaying = true
	arg0._stopGameBGM = arg6

	pg.UIMgr.GetInstance():LoadingOn()

	local function var0()
		if arg0.debugTimer then
			arg0.debugTimer:Stop()
		end

		if not arg0._mainTF then
			return
		end

		if not arg9 and Time.realtimeSinceStartup < arg0._closeLimit then
			return
		end

		setActive(arg0._mainTF, false)
		arg0:DisposeCpkMovie()

		if arg2 then
			arg2()
		end
	end

	local function var1()
		onButton(arg0, arg0._mainTF, function()
			if arg5 then
				var0()
			end
		end)

		if arg0._criUsm then
			arg0._criUsm.player:SetVolume(PlayerPrefs.GetFloat("bgm_vol", DEFAULT_BGMVOLUME))
			arg0._criUsm.player:SetShaderDispatchCallback(function(arg0, arg1)
				arg0:checkBgmStop(arg0)

				return nil
			end)
		end

		if arg0._criCpk then
			arg0._criCpk.player:SetVolume(PlayerPrefs.GetFloat("bgm_vol", DEFAULT_BGMVOLUME))
			arg0._criCpk.player:SetShaderDispatchCallback(function(arg0, arg1)
				arg0:checkBgmStop(arg0)

				return nil
			end)
		end

		if arg0._animator ~= nil then
			arg0._animator.enabled = true

			local var0 = arg0._mainTF:GetComponent("DftAniEvent")

			var0:SetStartEvent(function(arg0)
				if arg0._criUsm then
					arg0._criUsm:Play()
				end
			end)
			var0:SetEndEvent(function(arg0)
				var0()
			end)
		else
			arg0._timer = Timer.New(var0, arg8)

			arg0._timer:Start()
		end

		setActive(arg0._mainTF, true)

		if arg0._stopGameBGM then
			pg.BgmMgr.GetInstance():StopPlay()
		end

		if arg1 then
			arg1()
		end
	end

	if IsNil(arg0._mainTF) then
		LoadAndInstantiateAsync(arg3, arg4, function(arg0)
			pg.UIMgr.GetInstance():LoadingOff()

			arg0._closeLimit = Time.realtimeSinceStartup + 1

			if not arg0._onPlaying then
				Destroy(arg0)

				return
			end

			arg0._parentTF = arg0._parentTF or GameObject.Find("UICamera/Canvas")

			setParent(arg0, arg0._parentTF)

			arg0._mainTF = arg0

			pg.UIMgr.GetInstance():OverlayPanel(arg0._mainTF.transform, arg7)

			arg0._criUsm = tf(arg0._mainTF):Find("usm"):GetComponent("CriManaEffectUI")
			arg0._criCpk = tf(arg0._mainTF):Find("usm"):GetComponent("CriManaCpkUI")
			arg0._usmImg = tf(arg0._mainTF):Find("usm"):GetComponent("Image")
			arg0._animator = arg0._mainTF:GetComponent("Animator")

			if arg0._criUsm then
				arg0._criUsm.renderMode = ReflectionHelp.RefGetField(typeof("CriManaMovieMaterial+RenderMode"), "Always", nil)
			end

			if arg0._usmImg and arg0._usmImg.color.a == 0 then
				arg0._usmImg.color = Color.New(1, 1, 1, 0.1)
			end

			var1()
		end)
	else
		var1()
	end
end

function var0.checkBgmStop(arg0, arg1)
	if arg0._onPlaying then
		local var0 = arg1.numAudioStreams

		if var0 and var0 > 0 then
			pg.BgmMgr.GetInstance():StopPlay()

			arg0._stopGameBGM = true
		end
	end
end

function var0.DisposeCpkMovie(arg0)
	if arg0._onPlaying then
		if arg0._mainTF then
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0._mainTF.transform, arg0._tf)
			Destroy(arg0._mainTF)

			if arg0._animator ~= nil then
				arg0._animator.enabled = false
			end

			if arg0._timer ~= nil then
				arg0._timer:Stop()

				arg0._timer = nil
			end

			if arg0._criUsm then
				arg0._criUsm:Stop()
			end

			if arg0._stopGameBGM then
				pg.BgmMgr.GetInstance():ContinuePlay()
			end

			arg0._onPlaying = false

			pg.DelegateInfo.Dispose(arg0)
		end

		arg0:Reset()
	end
end
