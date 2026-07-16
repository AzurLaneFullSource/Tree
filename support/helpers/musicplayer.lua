local var0_0 = class("MusicPlayer")

var0_0.NO_PLAY_MUSIC_NOTIFICATION = "MusicPlayer.NO_PLAY_MUSIC_NOTIFICATION"
var0_0.CALLBACK_DIC = {
	startCall = function(arg0_1)
		return
	end,
	progressCall = function(arg0_2)
		return
	end,
	noPlayCall = function()
		return
	end
}

function var0_0.Ctor(arg0_4, arg1_4, arg2_4)
	arg0_4:ChangeData(arg1_4)

	arg0_4.callbackDic = arg2_4

	arg0_4:Reflush(arg1_4.index)
end

function var0_0.ChangeData(arg0_5, arg1_5)
	for iter0_5, iter1_5 in pairs(arg1_5) do
		arg0_5[iter0_5] = iter1_5
	end
end

function var0_0.Reflush(arg0_6, arg1_6)
	arg0_6.finishDic = {}

	if not arg0_6.list then
		arg0_6.list = getProxy(AppreciateProxy):getAlbumMusicList(arg0_6.albumName)
	end

	arg0_6.count = #arg0_6.list

	if arg0_6.count == 0 then
		pg.TipsMgr.GetInstance():ShowTips("this album without any song")
		existCall(arg0_6.callbackDic.noPlayCall)
		pg.m02:sendNotification(MusicPlayer.NO_PLAY_MUSIC_NOTIFICATION)

		return
	end

	if not arg1_6 then
		switch(arg0_6.loopType, {
			one = function()
				arg0_6.index = 1
			end,
			list = function()
				arg0_6.index = 1
			end,
			random = function()
				arg0_6.index = math.random(arg0_6.count)
			end
		})
	end

	arg0_6:Play()
end

function var0_0.Play(arg0_10)
	local var0_10 = pg.music_collect_config[arg0_10.list[arg0_10.index]].music

	arg0_10.cacheMusicName = var0_10

	onNextTick(function()
		local var0_11 = CueData.GetCueData()

		var0_11.channelName = pg.CriMgr.C_GALLERY_MUSIC
		var0_11.cueSheetName = var0_10
		var0_11.cueName = ""

		CriWareMgr.Inst:PlaySound(var0_11, CriWareMgr.CRI_FADE_TYPE.FADE_INOUT, function(arg0_12)
			arg0_10.playbackInfo = arg0_12

			arg0_10.playbackInfo:SetIgnoreAutoUnload(true)

			arg0_10.finishDic[arg0_10.index] = true

			existCall(arg0_10.callbackDic.startCall, arg0_10.playbackInfo:GetLength())

			if not arg0_10.timer then
				arg0_10.timer = Timer.New(function()
					if not arg0_10.playbackInfo then
						return
					end

					existCall(arg0_10.callbackDic.progressCall, arg0_10.playbackInfo:GetTime())

					if arg0_10.playbackInfo.playback:GetStatus():ToInt() == 3 then
						arg0_10:Finish()
					end
				end, 0.033, -1)

				arg0_10.timer:Start()
			end
		end)
	end)
end

function var0_0.Stop(arg0_14)
	if not arg0_14.playbackInfo then
		return
	end

	arg0_14.playbackInfo:SetStartTime(0)
	arg0_14.playbackInfo:SetIgnoreAutoUnload(false)

	local var0_14 = CueData.GetCueData()

	var0_14.channelName = pg.CriMgr.C_GALLERY_MUSIC
	var0_14.cueSheetName = arg0_14.cacheMusicName
	var0_14.cueName = ""

	CriWareMgr.Inst:StopSound(var0_14, CriWareMgr.CRI_FADE_TYPE.NONE)

	arg0_14.playbackInfo = nil

	if arg0_14.timer then
		arg0_14.timer:Stop()

		arg0_14.timer = nil
	end
end

function var0_0.Finish(arg0_15, arg1_15)
	arg0_15:Stop()

	if table.getCount(arg0_15.finishDic) < arg0_15.count then
		switch(arg0_15.loopType, {
			one = function()
				arg0_15.index = arg0_15.index
			end,
			list = function()
				arg1_15 = arg1_15 or 1
				arg0_15.index = (arg0_15.index + arg1_15 - 1) % arg0_15.count + 1
			end,
			random = function()
				local var0_18 = underscore.filter(underscore.keys(arg0_15.list), function(arg0_19)
					return not arg0_15.finishDic[arg0_19]
				end)

				arg0_15.index = var0_18[math.random(#var0_18)]
			end
		})
		arg0_15:Play()
	else
		arg0_15.list = nil

		arg0_15:Reflush()
	end
end

function var0_0.Next(arg0_20)
	arg0_20:Finish(1)
end

function var0_0.Last(arg0_21)
	arg0_21:Finish(-1)
end

function var0_0.SetProgress(arg0_22, arg1_22)
	if not arg0_22.playbackInfo then
		return
	end

	arg0_22.progress = arg1_22

	if not arg0_22.playbackInfo.playback:IsPaused() then
		arg0_22:Resume()
	end
end

function var0_0.Resume(arg0_23)
	if not arg0_23.playbackInfo then
		return
	end

	if arg0_23.progress then
		arg0_23.playbackInfo:SetStartTimeAndPlay(arg0_23.progress)
	else
		arg0_23.playbackInfo.playback:Resume(CriWare.CriAtomEx.ResumeMode.PausedPlayback)
	end

	arg0_23.progress = nil

	arg0_23.timer:Resume()
end

function var0_0.Pause(arg0_24)
	if not arg0_24.playbackInfo then
		return
	end

	arg0_24.playbackInfo.playback:Pause()
	arg0_24.timer:Pause()
end

function var0_0.IsPaused(arg0_25)
	if not arg0_25.playbackInfo then
		return
	end

	return arg0_25.playbackInfo.playback:IsPaused()
end

function var0_0.GetCurrentMusicId(arg0_26)
	return arg0_26.list[arg0_26.index]
end

function var0_0.Dispose(arg0_27)
	arg0_27:Stop()
end

return var0_0
