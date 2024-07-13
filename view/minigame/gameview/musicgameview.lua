local var0_0 = class("MusicGameView", import("..BaseMiniGameView"))
local var1_0 = false
local var2_0 = 0.95
local var3_0 = 0
local var4_0 = 1
local var5_0 = 3
local var6_0 = 5
local var7_0 = 2

function var0_0.getUIName(arg0_1)
	return "MusicGameUI"
end

function var0_0.MyGetRuntimeData(arg0_2)
	local var0_2 = getProxy(PlayerProxy):getData().id

	arg0_2.achieve_times = checkExist(arg0_2:GetMGData():GetRuntimeData("elements"), {
		1
	}) or 0
	arg0_2.isFirstgame = PlayerPrefs.GetInt("musicgame_first_" .. var0_2)
	arg0_2.bestScorelist = {}

	for iter0_2 = 1, arg0_2.music_amount * 2 do
		local var1_2 = arg0_2:GetMGData():GetRuntimeData("elements")

		arg0_2.bestScorelist[iter0_2] = checkExist(var1_2, {
			iter0_2 + 2
		}) or 0
	end

	arg0_2:updatSelectview()
end

function var0_0.MyStoreDataToServer(arg0_3)
	local var0_3 = getProxy(PlayerProxy):getData().id
	local var1_3 = {
		arg0_3.achieve_times,
		1
	}

	PlayerPrefs.SetInt("musicgame_first_" .. var0_3, 1)

	for iter0_3 = 1, arg0_3.music_amount * 2 do
		table.insert(var1_3, iter0_3 + 2, arg0_3.bestScorelist[iter0_3])
	end

	arg0_3:StoreDataToServer(var1_3)
end

function var0_0.init(arg0_4)
	arg0_4.UIMgr = pg.UIMgr.GetInstance()
	arg0_4.useGetKey_flag = true
	arg0_4.game_playingflag = false
	arg0_4.countingfive_flag = false
	arg0_4.downingleft_flag = false
	arg0_4.downingright_flag = false
	arg0_4.downingright_lastflag = false
	arg0_4.downingleft_lastflag = false
	arg0_4.nowS_flag = false
	arg0_4.firstview_timerRunflag = false
	arg0_4.ahead_timeflag = false
	arg0_4.ahead_timerPauseFlag = false
	arg0_4.changeLocalposTimerflag = false
	arg0_4.piecelist_rf = {}
	arg0_4.piecelist_rf[0] = 0
	arg0_4.piecelist_lf = {}
	arg0_4.piecelist_lf[0] = 0
	arg0_4.piece_nowl = {}
	arg0_4.piece_nowr = {}
	arg0_4.piece_nowl_downflag = false
	arg0_4.piece_nowr_downflag = false
	arg0_4.piece_nowl_aloneflag = false
	arg0_4.piece_nowr_aloneflag = false
	arg0_4.SDmodel = {}
	arg0_4.SDmodel_idolflag = false
	arg0_4.musicgame_nowtime = 0
	arg0_4.musicgame_lasttime = 0
	arg0_4.time_interval = 0.01666
	arg0_4.music_amount = #pg.beat_game_music.all
	arg0_4.music_amount_middle = math.ceil(#pg.beat_game_music.all / 2)
	arg0_4.musicDatas = {}

	for iter0_4 = 1, #pg.beat_game_music.all do
		local var0_4 = pg.beat_game_music.all[iter0_4]
		local var1_4 = pg.beat_game_music[var0_4]

		table.insert(arg0_4.musicDatas, var1_4)
	end

	table.sort(arg0_4.musicDatas, function(arg0_5, arg1_5)
		if arg0_5.sort and arg1_5.sort then
			return arg0_5.sort < arg1_5.sort
		end

		return arg0_5.id < arg1_5.id
	end)

	arg0_4.game_speed = PlayerPrefs.GetInt("musicgame_idol_speed") > 0 and PlayerPrefs.GetInt("musicgame_idol_speed") or 1
	arg0_4.game_dgree = 1
	arg0_4.countContent = arg0_4:findTF("countContent")
	arg0_4.countTf = nil
	arg0_4.top = arg0_4:findTF("top")
	arg0_4.btn_pause = arg0_4.top:Find("pause")
	arg0_4.score = arg0_4.top:Find("score")
	arg0_4.game_content = arg0_4:findTF("GameContent")
	arg0_4.noteTpl = arg0_4.game_content:Find("noteTpl")
	arg0_4.pauseview = arg0_4:findTF("Pauseview")
	arg0_4.selectview = arg0_4:findTF("Selectview")

	local var2_4 = findTF(arg0_4.selectview, "bg")

	LoadSpriteAtlasAsync("ui/musicgameother_atlas", "selectbg", function(arg0_6)
		GetComponent(var2_4, typeof(Image)).sprite = arg0_6

		setActive(var2_4, true)
	end)

	arg0_4.firstview = arg0_4:findTF("firstview")
	arg0_4.scoreview = arg0_4:findTF("ScoreView")

	setActive(arg0_4.scoreview, false)

	arg0_4.scoreview_flag = false
	arg0_4.bg = findTF(arg0_4._tf, "bg")

	pg.BgmMgr.GetInstance():StopPlay()
	arg0_4:updateMusic(var4_0)
end

function var0_0.didEnter(arg0_7)
	local var0_7 = 0

	local function var1_7()
		var0_7 = var0_7 + arg0_7.time_interval

		if var0_7 == arg0_7.time_interval then
			arg0_7:MyGetRuntimeData()
			arg0_7:showSelevtView()
		elseif var0_7 == arg0_7.time_interval * 2 then
			arg0_7:updatSelectview()
			arg0_7.Getdata_timer:Stop()
		end
	end

	LeanTween.delayedCall(go(arg0_7.selectview), 2, System.Action(function()
		arg0_7:MyGetRuntimeData()
	end))

	arg0_7.Getdata_timer = Timer.New(var1_7, arg0_7.time_interval, -1)

	arg0_7.Getdata_timer:Start()

	arg0_7.score_number = 0
	arg0_7.combo_link = 0
	arg0_7.combo_number = 0
	arg0_7.perfect_number = 0
	arg0_7.good_number = 0
	arg0_7.miss_number = 0

	local var2_7 = arg0_7:GetMGData():getConfig("simple_config_data")

	arg0_7.piecelist_speed = var2_7.speed
	arg0_7.piecelist_speedmin = var2_7.speed_min
	arg0_7.piecelist_speedmax = var2_7.speed_max
	arg0_7.specialcombo_number = var2_7.special_combo
	arg0_7.specialscore_number = var2_7.special_score
	arg0_7.score_perfect = var2_7.perfect
	arg0_7.score_good = var2_7.good
	arg0_7.score_miss = var2_7.miss
	arg0_7.score_combo = var2_7.combo
	arg0_7.time_perfect = var2_7.perfecttime
	arg0_7.time_good = var2_7.goodtime
	arg0_7.time_miss = var2_7.misstime
	arg0_7.time_laterperfect = var2_7.laterperfecttime
	arg0_7.time_latergood = var2_7.latergoodtime
	arg0_7.combo_interval = var2_7.combo_interval
	arg0_7.BtnRightDelegate = GetOrAddComponent(arg0_7.game_content:Find("btn_right"), "EventTriggerListener")

	arg0_7.BtnRightDelegate:AddPointDownFunc(function()
		arg0_7.mousedowningright_flag = true

		setActive(arg0_7.bottonRightBg, true)
	end)
	arg0_7.BtnRightDelegate:AddPointUpFunc(function()
		arg0_7.mousedowningright_flag = false

		setActive(arg0_7.bottonRightBg, false)
	end)

	arg0_7.BtnLeftDelegate = GetOrAddComponent(arg0_7.game_content:Find("btn_left"), "EventTriggerListener")

	arg0_7.BtnLeftDelegate:AddPointDownFunc(function()
		arg0_7.mousedowningleft_flag = true

		setActive(arg0_7.bottonLeftBg, true)
	end)
	arg0_7.BtnLeftDelegate:AddPointUpFunc(function()
		arg0_7.mousedowningleft_flag = false

		setActive(arg0_7.bottonLeftBg, false)
	end)
	onButton(arg0_7, arg0_7.top:Find("pause"), function()
		arg0_7.UIMgr:BlurPanel(arg0_7.pauseview)
		setActive(arg0_7.pauseview, true)

		arg0_7.game_playingflag = false

		arg0_7:effect_play("nothing")
		LoadSpriteAtlasAsync("ui/musicgameother_atlas", "pause_" .. arg0_7.musicData.picture, function(arg0_15)
			setImageSprite(arg0_7.pauseview:Find("bottom/song"), arg0_15, true)
		end)
		GetComponent(arg0_7.pauseview:Find("bottom/img"), typeof(Image)):SetNativeSize()

		if not arg0_7.ahead_timeflag then
			arg0_7:pauseBgm()

			local var0_14 = arg0_7:getStampTime()
			local var1_14 = arg0_7.song_Tlength

			if var0_14 < 0 then
				var0_14 = 0
			end

			if var0_14 >= 0 and var1_14 > 0 then
				local function var2_14(arg0_16)
					if arg0_16 < 10 then
						return "0" .. arg0_16
					else
						return arg0_16
					end
				end

				local var3_14 = var2_14(math.floor(var0_14 % 60000 / 1000))
				local var4_14 = var2_14(math.floor(var0_14 / 60000))

				setText(arg0_7.pauseview:Find("bottom/now"), var4_14 .. ":" .. var3_14)

				local var5_14 = var2_14(math.floor(var1_14 % 60000 / 1000))
				local var6_14 = var2_14(math.floor(var1_14 / 60000))

				setText(arg0_7.pauseview:Find("bottom/total"), var6_14 .. ":" .. var5_14)
				setActive(arg0_7.pauseview:Find("bottom/triangle"), true)
				setActive(arg0_7.pauseview:Find("bottom/TimeSlider"), true)
				setActive(arg0_7.pauseview:Find("bottom/now"), true)
				setActive(arg0_7.pauseview:Find("bottom/total"), true)
				setSlider(arg0_7.pauseview:Find("bottom/TimeSlider"), 0, 1, var0_14 / var1_14)

				local var7_14 = arg0_7.pauseview:Find("bottom/triangle/min").localPosition.x
				local var8_14 = arg0_7.pauseview:Find("bottom/triangle/max").localPosition.x
				local var9_14 = arg0_7.pauseview:Find("bottom/triangle/now").localPosition

				arg0_7.pauseview:Find("bottom/triangle/now").localPosition = Vector3(var7_14 + var0_14 / var1_14 * (var8_14 - var7_14), var9_14.y, var9_14.z)

				arg0_7:setActionSDmodel("stand2")
			end
		else
			setActive(arg0_7.pauseview:Find("bottom/triangle"), false)
			setActive(arg0_7.pauseview:Find("bottom/TimeSlider"), false)
			setActive(arg0_7.pauseview:Find("bottom/now"), false)
			setActive(arg0_7.pauseview:Find("bottom/total"), false)

			arg0_7.ahead_timerPauseFlag = true
		end
	end, SFX_UI_CLICK)
	onButton(arg0_7, arg0_7.pauseview:Find("bottom/back"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("reselect_music_game"),
			onYes = function()
				arg0_7.UIMgr:UnblurPanel(arg0_7.pauseview, arg0_7._tf)
				setActive(arg0_7.pauseview, false)
				arg0_7:stopTimer()

				if arg0_7.ahead_timer then
					arg0_7.ahead_timer:Stop()

					arg0_7.ahead_timeflag = false
				end

				setActive(arg0_7.selectview, true)

				GetOrAddComponent(arg0_7.selectview, "CanvasGroup").blocksRaycasts = true

				arg0_7.song_btns[arg0_7.game_music]:GetComponent(typeof(Animator)):Play("plate_out")

				arg0_7.game_playingflag = false

				arg0_7:loadAndPlayMusic()
				arg0_7:rec_scorce()
			end
		})
	end, SFX_UI_CLICK)
	onButton(arg0_7, arg0_7.pauseview:Find("bottom/restart"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("restart_music_game"),
			onYes = function()
				arg0_7.UIMgr:UnblurPanel(arg0_7.pauseview, arg0_7._tf)
				setActive(arg0_7.pauseview, false)
				arg0_7:stopTimer()

				if arg0_7.ahead_timer then
					arg0_7.ahead_timer:Stop()

					arg0_7.ahead_timeflag = false
				end

				arg0_7:rec_scorce()
				arg0_7:game_start()
				arg0_7:effect_play("prepare")
			end
		})
	end, SFX_UI_CLICK)
	onButton(arg0_7, arg0_7.pauseview:Find("bottom/resume"), function()
		arg0_7.UIMgr:UnblurPanel(arg0_7.pauseview, arg0_7._tf)
		setActive(arg0_7.pauseview, false)
		arg0_7:effect_play("prepare")

		if not arg0_7.ahead_timeflag then
			local function var0_21()
				arg0_7:resumeBgm()

				arg0_7.game_playingflag = true
			end

			arg0_7:count_five(var0_21)
		else
			local function var1_21()
				arg0_7.ahead_timerPauseFlag = false
				arg0_7.game_playingflag = true

				setActive(arg0_7.pauseview:Find("bottom/triangle"), true)
				setActive(arg0_7.pauseview:Find("bottom/TimeSlider"), true)
				setActive(arg0_7.pauseview:Find("bottom/now"), true)
				setActive(arg0_7.pauseview:Find("bottom/total"), true)
			end

			arg0_7:count_five(var1_21)
		end
	end, SFX_UI_CLICK)
	arg0_7:addRingDragListenter()
	setActive(arg0_7.selectview, true)

	GetOrAddComponent(arg0_7.selectview, "CanvasGroup").blocksRaycasts = true
end

function var0_0.updateBg(arg0_24)
	if arg0_24.isLoading then
		arg0_24:dynamicBgHandler(arg0_24.bgGo, function()
			setParent(arg0_24.bgGo, arg0_24.bg)
			setActive(arg0_24.bgGo, true)
		end)

		return
	end

	if arg0_24.bgGo and arg0_24.bgName then
		arg0_24:dynamicBgHandler(arg0_24.bgGo)
		PoolMgr.GetInstance():ReturnUI(arg0_24.bgName, arg0_24.bgGo)
	end

	arg0_24.bgName = "musicgamebg" .. arg0_24.musicBg
	arg0_24.isLoading = true

	local var0_24 = arg0_24.bgName

	PoolMgr.GetInstance():GetUI("" .. var0_24, true, function(arg0_26)
		arg0_24.bgGo = arg0_26

		if arg0_24.isLoading == false then
			arg0_24:dynamicBgHandler(arg0_24.bgGo)
			PoolMgr.GetInstance():ReturnUI(var0_24, arg0_24.bgGo)
		else
			arg0_24.isLoading = false

			setParent(arg0_24.bgGo, arg0_24.bg)
			setActive(arg0_24.bgGo, true)
		end
	end)
end

function var0_0.dynamicBgHandler(arg0_27, arg1_27, arg2_27)
	if IsNil(arg1_27) then
		return
	end

	if arg2_27 ~= nil then
		arg2_27()
	end
end

function var0_0.onBackPressed(arg0_28)
	if not arg0_28.countingfive_flag and not arg0_28.firstview_timerRunflag then
		if arg0_28.game_playingflag then
			if not isActive(arg0_28.top:Find("pause_above")) then
				triggerButton(arg0_28.top:Find("pause"))
			end
		elseif isActive(arg0_28.selectview) and var3_0 == 0 then
			arg0_28:emit(var0_0.ON_BACK)
		end
	end
end

function var0_0.OnApplicationPaused(arg0_29, arg1_29)
	if arg1_29 and not arg0_29.countingfive_flag and not arg0_29.firstview_timerRunflag and arg0_29.game_playingflag and not isActive(arg0_29.top:Find("pause_above")) then
		triggerButton(arg0_29.top:Find("pause"))
	end
end

function var0_0.willExit(arg0_30)
	arg0_30.isLoading = false

	if arg0_30.bgGo and arg0_30.bgName then
		arg0_30:dynamicBgHandler(arg0_30.bgGo)
		PoolMgr.GetInstance():ReturnUI(arg0_30.bgName, arg0_30.bgGo)
	end

	if arg0_30.timer then
		if arg0_30.timer.running then
			arg0_30.timer:Stop()
		end

		arg0_30.timer = nil
	end

	if arg0_30.ahead_timer then
		if arg0_30.ahead_timer.running then
			arg0_30.ahead_timer:Stop()
		end

		arg0_30.ahead_timer = nil
	end

	if arg0_30.firstview_timer then
		if arg0_30.firstview_timer.running then
			arg0_30.firstview_timer:Stop()
		end

		arg0_30.firstview_timer = nil
	end

	if arg0_30.changeLocalpos_timer then
		if arg0_30.changeLocalpos_timer.running then
			arg0_30.changeLocalpos_timer:Stop()
		end

		arg0_30.changeLocalpos_timer = nil
	end

	if arg0_30.count_timer then
		if arg0_30.count_timer.running then
			arg0_30.count_timer:Stop()
		end

		arg0_30.count_timer = nil
	end

	if arg0_30.Scoceview_timer then
		if arg0_30.Scoceview_timer.running then
			arg0_30.Scoceview_timer:Stop()
		end

		arg0_30.Scoceview_timer = nil
	end

	if arg0_30.Getdata_timer then
		if arg0_30.Getdata_timer.running then
			arg0_30.Getdata_timer:Stop()
		end

		arg0_30.Getdata_timer = nil
	end

	arg0_30:clearSDModel()

	arg0_30.piecelist_lt = {}
	arg0_30.piecelist_lf = {}
	arg0_30.musictable_l = {}
	arg0_30.piece_nowl = {}
	arg0_30.piecelist_rt = {}
	arg0_30.piecelist_rf = {}
	arg0_30.musictable_r = {}
	arg0_30.piece_nowr = {}

	if arg0_30.painting then
		retPaintingPrefab(arg0_30.scoreview:Find("paint"), arg0_30.painting)

		arg0_30.painting = nil
	end

	if arg0_30.criInfo then
		arg0_30.criInfo:PlaybackStop()
		arg0_30.criInfo:SetStartTimeAndPlay(0)
		pg.CriMgr.GetInstance():UnloadCueSheet(arg0_30:getMusicBgm(arg0_30.musicData))

		arg0_30.criInfo = nil
	end

	if LeanTween.isTweening(go(arg0_30.selectview)) then
		LeanTween.cancel(go(arg0_30.selectview))
	end

	if LeanTween.isTweening(go(arg0_30.countContent)) then
		LeanTween.cancel(go(arg0_30.countContent))
	end

	if LeanTween.isTweening(go(arg0_30.scoreview)) then
		LeanTween.cancel(go(arg0_30.scoreview))
	end

	if LeanTween.isTweening(go(arg0_30.game_content)) then
		LeanTween.cancel(go(arg0_30.game_content))
	end

	pg.BgmMgr.GetInstance():ContinuePlay()
end

function var0_0.clearSDModel(arg0_31)
	if not arg0_31.SDmodel or not arg0_31.SDname or arg0_31.SDname == "" or arg0_31.SDname == "none" then
		return
	end

	for iter0_31 = 1, #arg0_31.SDmodel do
		if arg0_31.SDmodel[iter0_31] then
			PoolMgr.GetInstance():ReturnSpineChar(arg0_31.SDname[iter0_31], arg0_31.SDmodel[iter0_31])
		end
	end

	arg0_31.SDmodel = {}
end

function var0_0.list_push(arg0_32, arg1_32, arg2_32)
	arg1_32[arg1_32[0] + 1] = arg2_32
	arg1_32[0] = arg1_32[0] + 1
end

function var0_0.list_pop(arg0_33, arg1_33)
	if arg1_33[0] == 0 then
		return
	end

	local var0_33 = arg1_33[1]

	for iter0_33 = 1, arg1_33[0] - 1 do
		arg1_33[iter0_33] = arg1_33[iter0_33 + 1]
	end

	arg1_33[0] = arg1_33[0] - 1

	return var0_33
end

function var0_0.game_start(arg0_34)
	arg0_34:game_before()
	arg0_34:effect_play("prepare")

	arg0_34.game_playingflag = true
	arg0_34.SDmodel_jumpcount = 0
	arg0_34.gotspecialcombo_flag = false

	arg0_34:updateBg()

	arg0_34.song_Tlength = false

	arg0_34:effect_play("nothing")
	arg0_34:effect_play("prepare")

	if arg0_34.isFirstgame == 0 then
		arg0_34:Firstshow(arg0_34.firstview, function()
			arg0_34:gameStart()
		end, 2)
		arg0_34:MyStoreDataToServer()
	else
		arg0_34:gameStart()
	end
end

function var0_0.game_before(arg0_36)
	arg0_36:effect_play("nothing")

	arg0_36.nowS_flag = false

	arg0_36:setTfChildVisible(arg0_36.top:Find("scoreContent/scroll"), false)

	arg0_36.scoreSliderTf = arg0_36.top:Find("scoreContent/scroll/" .. tostring(arg0_36.musicData.content_type))

	setSlider(arg0_36.scoreSliderTf, 0, 1, 0)
	setActive(arg0_36.scoreSliderTf, true)
	setActive(findTF(arg0_36.scoreSliderTf, "img/mask/yinyue20_S"), false)

	arg0_36.scoreSFlag = false

	setImageColor(findTF(arg0_36.scoreSliderTf, "img"), Color(1, 1, 1, 1))

	local var0_36 = arg0_36.game_content:Find("evaluate")

	for iter0_36 = 1, var0_36.childCount do
		local var1_36 = var0_36:GetChild(iter0_36 - 1)

		for iter1_36 = 1, var1_36.childCount do
			setActive(var1_36:GetChild(iter1_36 - 1), false)
		end

		setActive(findTF(var1_36, tostring(arg0_36.musicData.content_type)), true)
		setActive(var0_36:GetChild(iter0_36 - 1), false)
	end

	local var2_36 = arg0_36.game_content:Find("bottomList")

	for iter2_36 = 1, var2_36.childCount do
		local var3_36 = var2_36:GetChild(iter2_36 - 1)

		setActive(var3_36, false)
	end

	if arg0_36.musicData.bottom_type and arg0_36.musicData.bottom_type > 0 then
		arg0_36.bottonLeftBg = arg0_36.game_content:Find("bottomList/" .. arg0_36.musicData.bottom_type .. "/bottom_leftbg")
		arg0_36.bottonRightBg = arg0_36.game_content:Find("bottomList/" .. arg0_36.musicData.bottom_type .. "/bottom_rightbg")

		setActive(arg0_36.bottonLeftBg, false)
		setActive(arg0_36.bottonRightBg, false)
		setActive(arg0_36.game_content:Find("bottomList/" .. arg0_36.musicData.bottom_type), true)
		setActive(arg0_36.game_content:Find("bottomList/" .. arg0_36.musicData.bottom_type), true)
	end

	arg0_36:clearSDModel()

	for iter3_36 = 1, #arg0_36.SDname do
		arg0_36:loadSDModel(iter3_36)
	end

	arg0_36:setActionSDmodel("stand2")
	setActive(arg0_36.game_content:Find("combo"), false)
	setActive(arg0_36.game_content:Find("combo_n"), false)
	setActive(arg0_36.game_content:Find("MusicStar"), false)
	setActive(arg0_36.game_content, true)
	setActive(arg0_36._tf:Find("Spinelist"), true)
	setActive(arg0_36.top, true)
	setActive(arg0_36.fullComboEffect, false)
	setActive(arg0_36.liveClearEffect, false)

	local var4_36 = arg0_36:getMusicNote(arg0_36.musicData, arg0_36.game_dgree)
	local var5_36 = require(var4_36)

	arg0_36.leftPu = {}
	arg0_36.rightPu = {}

	for iter4_36, iter5_36 in ipairs(var5_36.left_track) do
		table.insert(arg0_36.leftPu, iter5_36)
	end

	for iter6_36, iter7_36 in ipairs(var5_36.right_track) do
		table.insert(arg0_36.rightPu, iter7_36)
	end

	arg0_36:setTfChildVisible(arg0_36.noteTpl, false)

	if not arg0_36.gameNoteLeft then
		arg0_36.gameNoteLeft = MusicGameNote.New(findTF(arg0_36.game_content, "MusicPieceLeft"), arg0_36.noteTpl, MusicGameNote.type_left)
	end

	if not arg0_36.gameNoteRight then
		arg0_36.gameNoteRight = MusicGameNote.New(findTF(arg0_36.game_content, "MusicPieceRight"), arg0_36.noteTpl, MusicGameNote.type_right)
	end

	arg0_36.gameNoteLeft:setStartData(arg0_36.leftPu, arg0_36.game_speed, arg0_36.game_dgree, arg0_36.noteType)
	arg0_36.gameNoteLeft:setStateCallback(function(arg0_37)
		arg0_36:onStateCallback(arg0_37)
	end)
	arg0_36.gameNoteLeft:setLongTimeCallback(function(arg0_38)
		arg0_36:onLongTimeCallback(arg0_38)
	end)
	arg0_36.gameNoteRight:setStartData(arg0_36.rightPu, arg0_36.game_speed, arg0_36.game_dgree, arg0_36.noteType)
	arg0_36.gameNoteRight:setStateCallback(function(arg0_39)
		arg0_36:onStateCallback(arg0_39)
	end)
	arg0_36.gameNoteRight:setLongTimeCallback(function(arg0_40)
		arg0_36:onLongTimeCallback(arg0_40)
	end)

	arg0_36.gameStepTime = 0
	arg0_36.musictable_l = {}
	arg0_36.musictable_l[0] = 0
	arg0_36.musictable_r = {}
	arg0_36.musictable_r[0] = 0
	arg0_36.nowmusic_l = nil
	arg0_36.nowmusic_r = nil

	local var6_36 = arg0_36:getMusicNote(arg0_36.musicData, arg0_36.game_dgree)

	arg0_36.musicpu = require(var6_36)

	for iter8_36, iter9_36 in ipairs(arg0_36.musicpu.left_track) do
		arg0_36:list_push(arg0_36.musictable_l, iter9_36)
	end

	for iter10_36, iter11_36 in ipairs(arg0_36.musicpu.right_track) do
		arg0_36:list_push(arg0_36.musictable_r, iter11_36)
	end

	local var7_36 = arg0_36.scoreSliderTf
	local var8_36 = arg0_36.top:Find("scoreContent/B")
	local var9_36 = arg0_36.top:Find("scoreContent/A")
	local var10_36 = arg0_36.top:Find("scoreContent/S")

	var8_36.anchoredPosition = Vector3(arg0_36.scoreSliderTf.anchoredPosition.x + var7_36.rect.width * 0.53, var8_36.anchoredPosition.y, var8_36.anchoredPosition.z)
	var9_36.anchoredPosition = Vector3(arg0_36.scoreSliderTf.anchoredPosition.x + var7_36.rect.width * 0.72, var8_36.anchoredPosition.y, var8_36.anchoredPosition.z)
	var10_36.anchoredPosition = Vector3(arg0_36.scoreSliderTf.anchoredPosition.x + var7_36.rect.width * 0.885, var8_36.anchoredPosition.y, var8_36.anchoredPosition.z)

	arg0_36:scoresliderAcombo_update()
end

function var0_0.stopTimer(arg0_41)
	if arg0_41.timer.running then
		arg0_41.timer:Stop()
	end
end

function var0_0.startTimer(arg0_42)
	if not arg0_42.timer.running then
		arg0_42.timer:Start()
	end
end

function var0_0.loadSDModel(arg0_43, arg1_43)
	if not arg0_43.SDname[arg1_43] or arg0_43.SDname[arg1_43] == "" or arg0_43.SDname[arg1_43] == "none" then
		arg0_43.SDmodel[arg1_43] = false

		setActive(findTF(arg0_43._tf, "Spinelist/" .. arg1_43 .. "/shadow"), false)
		setActive(findTF(arg0_43._tf, "Spinelist/" .. arg1_43 .. "/light"), false)

		return
	end

	local var0_43 = findTF(arg0_43._tf, "Spinelist/" .. arg1_43 .. "/light")
	local var1_43 = findTF(arg0_43._tf, "Spinelist/" .. arg1_43 .. "/shadow")
	local var2_43 = findTF(arg0_43._tf, "Spinelist/" .. arg1_43 .. "/" .. arg0_43.musicData.content_type)

	var0_43.anchoredPosition = var2_43.anchoredPosition
	var1_43.anchoredPosition = var2_43.anchoredPosition

	setActive(var0_43, true)

	if arg0_43.musicLight and arg0_43.shadowLight then
		setActive(findTF(arg0_43._tf, "Spinelist/" .. arg1_43 .. "/shadow"), true)
	else
		setActive(findTF(arg0_43._tf, "Spinelist/" .. arg1_43 .. "/shadow"), false)
	end

	for iter0_43 = 1, var6_0 do
		if arg0_43.musicLight and arg0_43.musicLight > 0 then
			setActive(findTF(arg0_43._tf, "Spinelist/" .. arg1_43 .. "/light"), false)

			local var3_43 = iter0_43

			if arg0_43.musicData.ships[iter0_43] and arg0_43.musicData.ships[iter0_43] ~= "" and arg0_43.musicData.ships[iter0_43] ~= "none" then
				LoadSpriteAtlasAsync("ui/musicgameother_atlas", "light" .. arg0_43.musicLight, function(arg0_44)
					setActive(findTF(arg0_43._tf, "Spinelist/" .. var3_43 .. "/light"), true)
					setImageSprite(findTF(arg0_43._tf, "Spinelist/" .. var3_43 .. "/light"), arg0_44, true)
				end)
			end
		end

		setActive(findTF(arg0_43._tf, "Spinelist/" .. arg1_43 .. "/light"), false)
	end

	pg.UIMgr.GetInstance():LoadingOff()
	PoolMgr.GetInstance():GetSpineChar(arg0_43.SDname[arg1_43], true, function(arg0_45)
		arg0_43.SDmodel[arg1_43] = arg0_45
		tf(arg0_45).localScale = Vector3(1, 1, 1)

		arg0_45:GetComponent("SpineAnimUI"):SetAction("stand2", 0)
		setParent(arg0_45, arg0_43._tf:Find("Spinelist/" .. arg1_43))

		local var0_45 = arg0_43._tf:Find("Spinelist/" .. arg1_43 .. "/" .. arg0_43.musicData.content_type)

		tf(arg0_45).anchoredPosition = var0_45.anchoredPosition
	end)
end

function var0_0.SDmodeljump_btnup(arg0_46)
	if arg0_46.downingright_flag or arg0_46.downingleft_flag then
		arg0_46.SDmodel_jumpcount = arg0_46.SDmodel_jumpcount + arg0_46.time_interval
		arg0_46.SDmodel_jumpcount = arg0_46.SDmodel_jumpcount > 1 and 1 or arg0_46.SDmodel_jumpcount
	else
		if arg0_46.SDmodel_jumpcount == 1 then
			arg0_46:setActionSDmodel("jump")

			arg0_46.SDmodel_idolflag = false
		end

		if arg0_46.SDmodel_jumpcount > 0 then
			arg0_46.SDmodel_jumpcount = arg0_46.SDmodel_jumpcount - arg0_46.time_interval
			arg0_46.SDmodel_jumpcount = arg0_46.SDmodel_jumpcount < 0 and 0 or arg0_46.SDmodel_jumpcount
		end

		if arg0_46.SDmodel_jumpcount == 0 and not arg0_46.SDmodel_idolflag then
			arg0_46.SDmodel_idolflag = true

			arg0_46:setActionSDmodel("idol")
		end
	end
end

function var0_0.setActionSDmodel(arg0_47, arg1_47, arg2_47)
	arg2_47 = arg2_47 or 0

	for iter0_47 = 1, #arg0_47.SDmodel do
		if arg0_47.SDmodel[iter0_47] then
			arg0_47.SDmodel[iter0_47]:GetComponent("SpineAnimUI"):SetAction(arg1_47, arg2_47)
		end
	end
end

function var0_0.loadAndPlayMusic(arg0_48, arg1_48, arg2_48)
	local var0_48 = arg0_48:getMusicBgm(arg0_48.musicData)

	var3_0 = var3_0 + 1

	CriWareMgr.Inst:PlayBGM(var0_48, CriWareMgr.CRI_FADE_TYPE.FADE_INOUT, function(arg0_49)
		if arg0_49 == nil then
			warning("Missing BGM :" .. (var0_48 or "NIL"))
		else
			print("加载完毕,开始播放音乐")

			if arg0_48.countingfive_flag then
				return
			end

			arg0_48.criInfo = arg0_49
			arg0_48.song_Tlength = arg0_49:GetLength()

			arg0_49:PlaybackStop()

			if IsUnityEditor and var1_0 then
				arg0_48.criInfo:SetStartTimeAndPlay(arg0_48.criInfo:GetLength() * var2_0)
			else
				arg0_49:SetStartTimeAndPlay(arg2_48 and arg2_48 >= 0 and arg2_48 or 0)
			end

			var3_0 = var3_0 - 1

			if arg1_48 then
				arg1_48()
			end
		end
	end)
end

function var0_0.getStampTime(arg0_50)
	if arg0_50.aheadtime_count then
		return (arg0_50.aheadtime_count - 2) * 1000
	elseif arg0_50.criInfo then
		return arg0_50.criInfo:GetTime()
	end

	return nil
end

function var0_0.pauseBgm(arg0_51)
	if arg0_51.criInfo then
		arg0_51.pauseTime = arg0_51.criInfo:GetTime()

		arg0_51.criInfo:PlaybackStop()
	end

	if arg0_51.timer and arg0_51.timer.running then
		arg0_51.timer:Stop()
	end
end

function var0_0.resumeBgm(arg0_52)
	if not arg0_52.timer.running then
		arg0_52.timer:Start()
	end

	arg0_52:loadAndPlayMusic(function()
		return
	end, arg0_52.pauseTime)
end

function var0_0.rec_scorce(arg0_54)
	arg0_54.score_number = 0
	arg0_54.combo_link = 0
	arg0_54.combo_number = 0
	arg0_54.perfect_number = 0
	arg0_54.good_number = 0
	arg0_54.miss_number = 0
	arg0_54.gotspecialcombo_flag = false

	setActive(arg0_54.top:Find("scoreContent/B/bl"), false)
	setActive(arg0_54.top:Find("scoreContent/A/al"), false)
	setActive(arg0_54.top:Find("scoreContent/S/sl"), false)
	setText(arg0_54.gameScoreTf, 0)
	setText(arg0_54.game_content:Find("combo_n/" .. arg0_54.musicData.content_type), 0)
end

function var0_0.effect_play(arg0_55, arg1_55, arg2_55)
	if arg1_55 == "nothing" then
		setActive(arg0_55.yinyuePefectLoop, false)
		setActive(arg0_55.top:Find("scoreContent/S/liubianxing"), false)
		setActive(arg0_55.yinyueGood, false)
		setActive(arg0_55.yinyuePerfect, false)
		setActive(arg0_55.game_content:Find("MusicStar"), false)
		SetActive(arg0_55.yinyueComboeffect, false)
	elseif arg1_55 == "prepare" then
		-- block empty
	elseif arg1_55 == "good" then
		setActive(arg0_55.yinyueGood, false)
		setActive(arg0_55.yinyueGood, true)
	elseif arg1_55 == "perfect" then
		setActive(arg0_55.yinyuePerfect, false)
		setActive(arg0_55.yinyuePerfect, true)
	elseif arg1_55 == "perfect_loop02" then
		if arg2_55 then
			if not isActive(arg0_55.yinyuePefectLoop) then
				setActive(arg0_55.yinyuePefectLoop, true)
			end
		else
			setActive(arg0_55.yinyuePefectLoop, false)
		end
	elseif arg1_55 == "S" then
		if arg2_55 then
			setActive(findTF(arg0_55.scoreSliderTf, "img/mask/yinyue20_S"), true)
		else
			setActive(findTF(arg0_55.scoreSliderTf, "img/mask/yinyue20_S"), false)
		end
	end
end

function var0_0.scoresliderAcombo_update(arg0_56)
	local var0_56 = arg0_56.score_number
	local var1_56 = 0

	setText(arg0_56.gameScoreTf, arg0_56.score_number)

	local var2_56 = arg0_56.game_music
	local var3_56 = arg0_56.game_dgree

	if var0_56 < arg0_56.score_blist[var3_56] then
		var1_56 = var0_56 / arg0_56.score_blist[var3_56] * 0.53
	elseif var0_56 >= arg0_56.score_blist[var3_56] and var0_56 < arg0_56.score_alist[var3_56] then
		var1_56 = 0.53 + (var0_56 - arg0_56.score_blist[var3_56]) / (arg0_56.score_alist[var3_56] - arg0_56.score_blist[var3_56]) * 0.19
	elseif var0_56 >= arg0_56.score_alist[var3_56] and var0_56 < arg0_56.score_slist[var3_56] then
		var1_56 = 0.72 + (var0_56 - arg0_56.score_alist[var3_56]) / (arg0_56.score_slist[var3_56] - arg0_56.score_alist[var3_56]) * 0.155
	else
		var1_56 = 0.885 + (var0_56 - arg0_56.score_slist[var3_56]) / (arg0_56.score_sslist[var3_56] - arg0_56.score_slist[var3_56]) * 0.115
	end

	setSlider(arg0_56.scoreSliderTf, 0, 1, var1_56)

	if var1_56 < 0.53 then
		setActive(arg0_56.top:Find("scoreContent/B/bl"), false)
		setActive(arg0_56.top:Find("scoreContent/A/al"), false)
		setActive(arg0_56.top:Find("scoreContent/S/sl"), false)
	elseif var1_56 >= 0.53 then
		setActive(arg0_56.top:Find("scoreContent/B/bl"), true)

		if var1_56 >= 0.72 then
			setActive(arg0_56.top:Find("scoreContent/A/al"), true)

			if var1_56 >= 0.885 then
				if not arg0_56.nowS_flag then
					arg0_56.nowS_flag = true

					arg0_56:effect_play("S", true)
				end

				setActive(arg0_56.top:Find("scoreContent/S/sl"), true)
			end
		end
	end

	setText(arg0_56.game_content:Find("combo_n/" .. arg0_56.musicData.content_type), arg0_56.combo_link)
end

function var0_0.score_update(arg0_57, arg1_57)
	local var0_57 = arg0_57.game_content:Find("evaluate")

	for iter0_57 = 1, 3 do
		setActive(var0_57:GetChild(iter0_57 - 1), false)
	end

	setActive(var0_57:GetChild(arg1_57), true)

	if arg1_57 == 0 then
		arg0_57.combo_link = 0
		arg0_57.score_number = arg0_57.score_number + arg0_57.score_miss
		arg0_57.miss_number = arg0_57.miss_number + 1

		setActive(arg0_57.game_content:Find("combo"), false)
		setActive(arg0_57.game_content:Find("combo_n"), false)
	else
		arg0_57.combo_link = arg0_57.combo_link + 1
		arg0_57.combo_number = arg0_57.combo_number > arg0_57.combo_link and arg0_57.combo_number or arg0_57.combo_link

		if arg0_57.combo_link > 1 then
			setActive(arg0_57.game_content:Find("combo"), true)
			setActive(arg0_57.game_content:Find("combo_n"), true)
			arg0_57.game_content:Find("combo"):GetComponent(typeof(Animation)):Play()
			arg0_57.game_content:Find("combo_n"):GetComponent(typeof(Animation)):Play()
		else
			setActive(arg0_57.game_content:Find("combo"), false)
			setActive(arg0_57.game_content:Find("combo_n"), false)
		end

		pg.CriMgr.GetInstance():PlaySE_V3("ui-maoudamashii")
	end

	local var1_57 = 0

	for iter1_57 = 1, #arg0_57.combo_interval do
		if arg0_57.combo_link > arg0_57.combo_interval[iter1_57] then
			var1_57 = var1_57 + 1
		else
			break
		end
	end

	if arg1_57 == 1 then
		arg0_57.score_number = arg0_57.score_number + arg0_57.score_good + var1_57 * arg0_57.score_combo
		arg0_57.good_number = arg0_57.good_number + 1

		arg0_57:effect_play("good")
	elseif arg1_57 == 2 then
		arg0_57.score_number = arg0_57.score_number + arg0_57.score_perfect + var1_57 * arg0_57.score_combo
		arg0_57.perfect_number = arg0_57.perfect_number + 1

		arg0_57:effect_play("perfect")
	end

	if arg0_57.gameNoteLeft:loopTime() or arg0_57.gameNoteRight:loopTime() then
		arg0_57:effect_play("perfect_loop02", true)
	else
		arg0_57:effect_play("perfect_loop02", false)
	end

	local var2_57 = arg0_57.yinyueComboeffect

	if arg0_57.game_dgree == 2 and arg0_57.combo_link > 50 or arg0_57.game_dgree == 1 and arg0_57.combo_link > 20 then
		if not isActive(var2_57) then
			SetActive(var2_57, true)
			setActive(arg0_57.game_content:Find("MusicStar"), true)
		end
	else
		SetActive(var2_57, false)
		setActive(arg0_57.game_content:Find("MusicStar"), false)
	end
end

function var0_0.count_five(arg0_58, arg1_58)
	if arg0_58.countingfive_flag then
		return
	end

	arg0_58.countingfive_flag = true

	setActive(arg0_58.countTf, true)
	setActive(arg0_58.countContent, true)
	arg0_58:setActionSDmodel("stand2")

	local var0_58 = var5_0
	local var1_58 = findTF(arg0_58.countTf, "img")
	local var2_58 = findTF(arg0_58.countTf, "bg")

	local function var3_58(arg0_59)
		for iter0_59 = 1, var1_58.childCount do
			local var0_59 = var1_58:GetChild(iter0_59 - 1)
			local var1_59 = iter0_59 == arg0_59

			setActive(var0_59, var1_59)
		end
	end

	setActive(var2_58, false)
	var3_58(0)

	local var4_58 = findTF(arg0_58.countTf, "ready")
	local var5_58 = findTF(arg0_58.countTf, "effectContent")

	setActive(var5_58, false)
	setActive(var4_58, false)

	arg0_58.count_timer = Timer.New(function()
		if arg0_58.criInfo and arg0_58.criInfo:GetTime() > 0 then
			arg0_58:pauseBgm()
		end

		var3_58(var0_58)

		var0_58 = var0_58 - 1

		if var0_58 < 0 then
			arg0_58.count_timer:Stop()
			setActive(var2_58, false)
			var3_58(0)
			setActive(var4_58, true)
			setActive(var5_58, true)
			LeanTween.value(go(arg0_58.countContent), 0, 2, 2):setOnUpdate(System.Action_float(function(arg0_61)
				local var0_61

				if arg0_61 <= 0.25 then
					local var1_61 = arg0_61 * 4

					var4_58.localScale = Vector3(var1_61, var1_61, var1_61)

					setImageAlpha(var4_58, var1_61)
					setLocalScale(var5_58, Vector3(var1_61, var1_61, var1_61))
				elseif arg0_61 >= 1.8 then
					local var2_61 = (2 - arg0_61) * 4

					var4_58.localScale = Vector3(var2_61, var2_61, var2_61)

					setLocalScale(var5_58, Vector3(var2_61, var2_61, var2_61))
					setImageAlpha(var4_58, var2_61)
				end
			end)):setEase(LeanTweenType.linear):setOnComplete(System.Action(function()
				var4_58.localScale = Vector3(1, 1, 1, 1)

				setLocalScale(var5_58, Vector3(1, 1, 1, 1))
				setImageAlpha(var4_58, 1)
				setActive(var4_58, false)

				arg0_58.countingfive_flag = false

				setActive(arg0_58.countContent, false)
				setActive(arg0_58.countTf, false)
				arg0_58:setActionSDmodel("idol")
				arg1_58()
			end))
		else
			setActive(var2_58, true)
		end
	end, 1, -1)

	arg0_58.count_timer:Start()
end

function var0_0.showSelevtView(arg0_63)
	if arg0_63.isFirstgame == 0 then
		arg0_63:Firstshow(arg0_63.firstview, function()
			return
		end, 1)
	end

	local var0_63 = arg0_63.selectview:Find("Main")
	local var1_63 = var0_63:Find("Start_btn")
	local var2_63 = var0_63:Find("DgreeList")
	local var3_63 = var0_63:Find("MusicList")
	local var4_63 = var0_63:Find("namelist")
	local var5_63 = arg0_63.selectview:Find("top")
	local var6_63 = var5_63:Find("Speedlist")
	local var7_63 = var5_63:Find("help_btn")
	local var8_63 = var5_63:Find("back")
	local var9_63 = arg0_63.selectview:GetComponent("Animator")

	arg0_63.selectview:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_65)
		setActive(arg0_63.selectview, false)
	end)
	onButton(arg0_63, var7_63, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_music_game.tip
		})
	end, SFX_PANEL)
	onButton(arg0_63, var8_63, function()
		if var3_0 == 0 then
			arg0_63:emit(var0_0.ON_BACK)
		end
	end, SFX_PANEL)
	onButton(arg0_63, var1_63, function()
		if var3_0 == 0 then
			var9_63:Play("selectExitAnim")
			arg0_63:clearSDModel()
			arg0_63:updateMusic(arg0_63.selectIndex)
			arg0_63:game_start()

			GetOrAddComponent(arg0_63.selectview, "CanvasGroup").blocksRaycasts = false
		else
			arg0_63.startBtnReady = true
		end
	end, SFX_UI_CONFIRM)
	onButton(arg0_63, var2_63:Find("easy"), function()
		arg0_63.game_dgree = 1

		setActive(var2_63:Find("hard/frame"), false)
		setActive(var2_63:Find("easy/frame"), true)
		arg0_63:updatSelectview()
	end, SFX_UI_CLICK)
	onButton(arg0_63, var2_63:Find("hard"), function()
		arg0_63.game_dgree = 2

		setActive(var2_63:Find("easy/frame"), false)
		setActive(var2_63:Find("hard/frame"), true)
		arg0_63:updatSelectview()
	end, SFX_UI_CLICK)
	onButton(arg0_63, var6_63, function()
		setActive(var6_63:Find("x" .. arg0_63.game_speed), false)

		arg0_63.game_speed = arg0_63.game_speed + 1 > 4 and 1 or arg0_63.game_speed + 1

		PlayerPrefs.SetInt("musicgame_idol_speed", arg0_63.game_speed)
		setActive(var6_63:Find("x" .. arg0_63.game_speed), true)
	end, SFX_UI_CLICK)

	arg0_63.song_btn = var3_63:Find("song")

	setActive(arg0_63.song_btn, false)

	arg0_63.song_btns = {}

	local var10_63 = arg0_63.gameMusicIndex

	for iter0_63 = 1, arg0_63.music_amount do
		arg0_63.song_btns[iter0_63] = cloneTplTo(arg0_63.song_btn, var3_63, "music" .. iter0_63)

		local var11_63 = arg0_63.musicDatas[iter0_63]

		setActive(arg0_63.song_btns[iter0_63], true)

		local var12_63 = arg0_63.song_btn.localPosition
		local var13_63 = math.abs(iter0_63 - var10_63)
		local var14_63 = iter0_63 - var10_63 < arg0_63.music_amount_middle and var13_63 or iter0_63 - arg0_63.music_amount_middle * 2

		arg0_63.song_btns[iter0_63].localPosition = Vector3(var12_63.x + var14_63 * 1022, var12_63.y, var12_63.z)

		local var15_63 = arg0_63.song_btn.localScale

		arg0_63.song_btns[iter0_63].localScale = Vector3(var15_63.x - math.abs(var14_63) * 0.2, var15_63.y - math.abs(var14_63) * 0.2, var15_63.z - math.abs(var14_63) * 0.2)

		local var16_63 = arg0_63.song_btns[iter0_63]:Find("song"):GetComponent(typeof(Image))

		var16_63.sprite = var3_63:Find("img/" .. var11_63.picture):GetComponent(typeof(Image)).sprite
		arg0_63.song_btns[iter0_63]:Find("zhuanji3/zhuanji2_5"):GetComponent(typeof(Image)).sprite = var3_63:Find("img/" .. var11_63.picture .. "_1"):GetComponent(typeof(Image)).sprite
		var16_63.color = Color.New(1, 1, 1, 1 - math.abs(var14_63) * 0.6)

		onButton(arg0_63, arg0_63.song_btns[iter0_63], function()
			arg0_63:clickSongBtns(var4_63, iter0_63)
		end, SFX_UI_CLICK)

		if iter0_63 == var10_63 then
			arg0_63.song_btns[iter0_63]:GetComponent(typeof(Animator)):Play("plate_out")

			arg0_63.song_btns[iter0_63]:GetComponent(typeof(Button)).interactable = false
		end
	end

	arg0_63:clickSongBtns(var4_63, 1)
end

function var0_0.updateMusic(arg0_73, arg1_73)
	arg0_73.musicData = arg0_73.musicDatas[arg1_73]
	arg0_73.selectIndex = arg1_73
	arg0_73.game_music = arg0_73.musicData.id

	if arg0_73.musicData.ships and #arg0_73.musicData.ships > 0 then
		arg0_73.musicShips = arg0_73.musicData.ships
		arg0_73.settlementPainting = arg0_73.musicData.settlement_painting
		arg0_73.musicLight = arg0_73.musicData.light
		arg0_73.shadowLight = arg0_73.musicData.shadow == 1
		arg0_73.musicBg = arg0_73.musicData.bg
	else
		local var0_73 = MusicGameConst.getRandomBand()

		arg0_73.musicShips = var0_73.ships
		arg0_73.settlementPainting = var0_73.settlement_painting
		arg0_73.musicLight = var0_73.light
		arg0_73.shadowLight = true
		arg0_73.musicBg = var0_73.bg
	end

	arg0_73.noteType = arg0_73.musicData.note_type
	arg0_73.gameMusicIndex = var4_0
	arg0_73.SDname = arg0_73.musicShips
	arg0_73.score_blist = arg0_73.musicData.score_rank[1]
	arg0_73.score_alist = arg0_73.musicData.score_rank[2]
	arg0_73.score_slist = arg0_73.musicData.score_rank[3]
	arg0_73.score_sslist = arg0_73.musicData.score_rank[4]

	arg0_73:setTfChildVisible(arg0_73.top:Find("scoreContent/B/bl"), false)
	arg0_73:setTfChildVisible(arg0_73.top:Find("scoreContent/B/b"), false)
	arg0_73:setTfChildVisible(arg0_73.top:Find("scoreContent/A/al"), false)
	arg0_73:setTfChildVisible(arg0_73.top:Find("scoreContent/A/a"), false)
	arg0_73:setTfChildVisible(arg0_73.top:Find("scoreContent/S/sl"), false)
	arg0_73:setTfChildVisible(arg0_73.top:Find("scoreContent/S/s"), false)
	setActive(arg0_73.top:Find("scoreContent/B/b/" .. arg0_73.musicData.content_type), true)
	setActive(arg0_73.top:Find("scoreContent/B/bl/" .. arg0_73.musicData.content_type), true)
	setActive(arg0_73.top:Find("scoreContent/A/a/" .. arg0_73.musicData.content_type), true)
	setActive(arg0_73.top:Find("scoreContent/A/al/" .. arg0_73.musicData.content_type), true)
	setActive(arg0_73.top:Find("scoreContent/S/s/" .. arg0_73.musicData.content_type), true)
	setActive(arg0_73.top:Find("scoreContent/S/sl/" .. arg0_73.musicData.content_type), true)
	arg0_73:setTfChildVisible(arg0_73.game_content:Find("combo_n"), false)
	arg0_73:setTfChildVisible(arg0_73.game_content:Find("combo"), false)
	setActive(arg0_73.game_content:Find("combo_n/" .. arg0_73.musicData.content_type), true)
	setActive(arg0_73.game_content:Find("combo/" .. arg0_73.musicData.content_type), true)
	arg0_73:setTfChildVisible(arg0_73.btn_pause, false)
	setActive(findTF(arg0_73.btn_pause, arg0_73.musicData.content_type), true)
	arg0_73:setTfChildVisible(arg0_73.countContent, false)
	arg0_73:setTfChildVisible(arg0_73.top:Find("score"), false)
	setActive(arg0_73.top:Find("score/" .. tostring(arg0_73.musicData.content_type)), true)

	arg0_73.gameScoreTf = arg0_73.top:Find("score/" .. tostring(arg0_73.musicData.content_type) .. "/text")
	arg0_73.countTf = findTF(arg0_73.countContent, arg0_73.musicData.content_type)

	arg0_73:updateEffectTf()
end

function var0_0.setTfChildVisible(arg0_74, arg1_74, arg2_74)
	for iter0_74 = 1, arg1_74.childCount do
		local var0_74 = arg1_74:GetChild(iter0_74 - 1)

		setActive(var0_74, false)
	end
end

function var0_0.updateEffectTf(arg0_75)
	local var0_75 = findTF(arg0_75.game_content, "effect")

	for iter0_75 = 1, var0_75.childCount do
		local var1_75 = var0_75:GetChild(iter0_75 - 1)

		setActive(var1_75, false)
	end

	local var2_75 = arg0_75.musicData.content_type

	setActive(findTF(arg0_75.game_content, "effect/" .. var2_75))

	arg0_75.fullComboEffect = arg0_75.game_content:Find("effect/" .. var2_75 .. "/yinyue_Fullcombo")
	arg0_75.liveClearEffect = arg0_75.game_content:Find("effect/" .. var2_75 .. "/yinyue_LiveClear")
	arg0_75.yinyueGood = arg0_75.game_content:Find("effect/" .. var2_75 .. "/yinyue_good")
	arg0_75.yinyueComboeffect = arg0_75.game_content:Find("effect/" .. var2_75 .. "/yinyue_comboeffect")
	arg0_75.yinyuePerfect = arg0_75.game_content:Find("effect/" .. var2_75 .. "/yinyue_perfect")
	arg0_75.yinyuePefectLoop = arg0_75.game_content:Find("effect/" .. var2_75 .. "/yinyue_perfect_loop02")
end

function var0_0.getBeatGameMusicData(arg0_76, arg1_76)
	for iter0_76 = 1, #arg0_76.musicDatas do
		if arg0_76.musicDatas[iter0_76].id == arg1_76 then
			return arg0_76.musicDatas[iter0_76]
		end
	end

	return nil
end

function var0_0.clickSongBtns(arg0_77, arg1_77, arg2_77)
	if var3_0 > 0 then
		return
	end

	setActive(arg1_77:Find("song" .. arg0_77.musicData.picture), false)
	arg0_77:MyGetRuntimeData()
	arg0_77:clearSDModel()
	arg0_77:updateMusic(arg2_77)
	arg0_77:loadAndPlayMusic()
	arg0_77:updatSelectview()
	arg0_77:changeLocalpos(arg2_77)
	setActive(arg1_77:Find("song" .. arg0_77.musicData.picture), true)
end

function var0_0.changeLocalpos(arg0_78, arg1_78)
	local var0_78 = arg0_78.music_amount_middle
	local var1_78 = var0_78 - arg1_78
	local var2_78 = 0.5
	local var3_78 = {}

	for iter0_78 = 1, arg0_78.music_amount do
		var3_78[iter0_78] = arg0_78.song_btns[iter0_78].localPosition
	end

	local var4_78 = {}

	for iter1_78 = 1, arg0_78.music_amount do
		var4_78[iter1_78] = arg0_78.song_btns[iter1_78].localScale
	end

	arg0_78.changeLocalpos_timer = Timer.New(function()
		var2_78 = var2_78 - arg0_78.time_interval
		arg0_78.changeLocalposTimerflag = true

		for iter0_79 = 1, arg0_78.music_amount do
			local var0_79 = iter0_79 + var1_78

			if iter0_79 + var1_78 > arg0_78.music_amount then
				var0_79 = iter0_79 + var1_78 - arg0_78.music_amount
			end

			if iter0_79 + var1_78 < 1 then
				var0_79 = iter0_79 + var1_78 + arg0_78.music_amount
			end

			if var2_78 <= 0 then
				if var0_79 == var0_78 then
					arg0_78.song_btns[iter0_79]:GetComponent(typeof(Animator)):Play("plate_out")
				else
					arg0_78.song_btns[iter0_79]:GetComponent(typeof(Animator)):Play("plate_static")

					arg0_78.song_btns[iter0_79]:GetComponent(typeof(Button)).interactable = true
				end
			else
				arg0_78.song_btns[iter0_79]:GetComponent(typeof(Animator)):Play("plate_static")

				arg0_78.song_btns[iter0_79]:GetComponent(typeof(Button)).interactable = false
			end

			local var1_79 = arg0_78.song_btn.localPosition
			local var2_79 = math.abs(var0_79 - var0_78)
			local var3_79 = (var1_79.x + (var0_79 - var0_78 > 0 and 1 or -1) * var2_79 * 1022) * (1 - var2_78 * 2) + var3_78[iter0_79].x * var2_78 * 2

			arg0_78.song_btns[iter0_79].localPosition = Vector3(var3_79, var1_79.y, var1_79.z)

			local var4_79 = arg0_78.song_btns[iter0_79].localScale
			local var5_79 = (1 - var2_79 * 0.2) * (1 - var2_78 * 2) + var4_78[iter0_79].x * var2_78 * 2

			arg0_78.song_btns[iter0_79].localScale = Vector3(var5_79, var5_79, var5_79)

			local var6_79 = arg0_78.song_btns[iter0_79]:Find("song"):GetComponent(typeof(Image))
			local var7_79 = (1 - var2_79 * 0.6) * (1 - var2_78 * 2) + var6_79.color.a * var2_78 * 2

			var6_79.color = Color.New(1, 1, 1, 1 - var2_79 * 0.6)
		end

		if var2_78 <= 0 then
			arg0_78.changeLocalposTimerflag = false

			arg0_78.changeLocalpos_timer:Stop()
		end
	end, arg0_78.time_interval, -1)

	arg0_78.changeLocalpos_timer:Start()
end

function var0_0.addRingDragListenter(arg0_80)
	local var0_80 = GetOrAddComponent(arg0_80.selectview, "EventTriggerListener")
	local var1_80
	local var2_80 = 0
	local var3_80

	var0_80:AddBeginDragFunc(function()
		var2_80 = 0
		var1_80 = nil
	end)
	var0_80:AddDragFunc(function(arg0_82, arg1_82)
		if not arg0_80.inPaintingView then
			local var0_82 = arg1_82.position

			if not var1_80 then
				var1_80 = var0_82
			end

			var2_80 = var0_82.x - var1_80.x
		end
	end)
	var0_80:AddDragEndFunc(function(arg0_83, arg1_83)
		if not arg0_80.inPaintingView and not arg0_80.changeLocalposTimerflag then
			local var0_83, var1_83 = arg0_80:getNextPreSelectId()

			if var2_80 < -50 then
				triggerButton(arg0_80.song_btns[var0_83])
			elseif var2_80 > 50 then
				triggerButton(arg0_80.song_btns[var1_83])
			end
		end
	end)
end

function var0_0.getNextPreSelectId(arg0_84)
	local var0_84
	local var1_84
	local var2_84 = arg0_84.game_music + 1
	local var3_84 = arg0_84.game_music - 1

	if var3_84 <= 0 then
		var3_84 = #arg0_84.musicDatas
	end

	if var2_84 > #arg0_84.musicDatas then
		var2_84 = 1
	end

	for iter0_84, iter1_84 in ipairs(arg0_84.musicDatas) do
		if arg0_84.musicDatas[iter0_84].id == var2_84 then
			var0_84 = iter0_84
		end

		if arg0_84.musicDatas[iter0_84].id == var3_84 then
			var1_84 = iter0_84
		end
	end

	return var0_84, var1_84
end

function var0_0.Firstshow(arg0_85, arg1_85, arg2_85, arg3_85)
	arg0_85.count = 0

	setActive(arg1_85, true)
	LoadSpriteAtlasAsync("ui/musicgameother_atlas", "help1", function(arg0_86)
		GetComponent(findTF(arg0_85.firstview, "num/img1"), typeof(Image)).sprite = arg0_86
	end)
	LoadSpriteAtlasAsync("ui/musicgameother_atlas", "help2", function(arg0_87)
		GetComponent(findTF(arg0_85.firstview, "num/img2"), typeof(Image)).sprite = arg0_87
	end)

	for iter0_85 = 1, 2 do
		local var0_85 = findTF(arg1_85, "num/img" .. iter0_85)

		setActive(var0_85, iter0_85 == arg3_85 and true or false)
	end

	if arg0_85.firstview_timer then
		if arg0_85.firstview_timer.running then
			arg0_85.firstview_timer:Stop()
		end

		arg0_85.firstview_timer = nil
	end

	arg0_85.firstview_timerRunflag = true
	arg0_85.firstview_timer = Timer.New(function()
		arg0_85.count = arg0_85.count + 1

		if arg0_85.count > 3 then
			onButton(arg0_85, arg0_85.firstview, function()
				if arg2_85 then
					arg2_85()
				end

				arg0_85.firstview_timer:Stop()
				setActive(arg1_85, false)

				arg0_85.firstview_timerRunflag = false

				removeOnButton(arg0_85.firstview)
			end)
		end
	end, 1, -1)

	arg0_85.firstview_timer:Start()
end

function var0_0.updatSelectview(arg0_90)
	if not arg0_90.song_btns or #arg0_90.song_btns <= 0 or not arg0_90.selectview then
		return
	end

	setActive(arg0_90.selectview:Find("top/Speedlist/x" .. arg0_90.game_speed), true)

	for iter0_90 = 1, arg0_90.music_amount do
		local var0_90 = arg0_90.musicDatas[iter0_90].id

		setActive(arg0_90.song_btns[var0_90]:Find("song/best"), false)
		arg0_90:setSelectview_pj("e", var0_90)
	end

	local var1_90 = arg0_90.game_dgree
	local var2_90 = arg0_90.game_music
	local var3_90 = arg0_90.bestScorelist[var2_90 + (var1_90 - 1) * arg0_90.music_amount]

	if arg0_90.song_btns[var2_90] and var3_90 > 0 then
		setActive(arg0_90.song_btns[var2_90]:Find("song/best"), true)

		local var4_90 = arg0_90.song_btns[var2_90]:Find("song/best/score")

		setText(var4_90, var3_90)
		arg0_90:setSelectview_pj("e", var2_90)

		if var3_90 < arg0_90.score_blist[var1_90] then
			arg0_90:setSelectview_pj("c", var2_90)
		elseif var3_90 >= arg0_90.score_blist[var1_90] and var3_90 < arg0_90.score_alist[var1_90] then
			arg0_90:setSelectview_pj("b", var2_90)
		elseif var3_90 >= arg0_90.score_alist[var1_90] and var3_90 < arg0_90.score_slist[var1_90] then
			arg0_90:setSelectview_pj("a", var2_90)
		else
			arg0_90:setSelectview_pj("s", var2_90)
		end
	end
end

function var0_0.setSelectview_pj(arg0_91, arg1_91, arg2_91)
	if arg1_91 == "e" then
		setActive(arg0_91.song_btns[arg2_91]:Find("song/c"), false)
		setActive(arg0_91.song_btns[arg2_91]:Find("song/b"), false)
		setActive(arg0_91.song_btns[arg2_91]:Find("song/a"), false)
		setActive(arg0_91.song_btns[arg2_91]:Find("song/s"), false)
	elseif arg1_91 == "c" then
		setActive(arg0_91.song_btns[arg2_91]:Find("song/c"), true)
	elseif arg1_91 == "b" then
		setActive(arg0_91.song_btns[arg2_91]:Find("song/b"), true)
	elseif arg1_91 == "a" then
		setActive(arg0_91.song_btns[arg2_91]:Find("song/a"), true)
	elseif arg1_91 == "s" then
		setActive(arg0_91.song_btns[arg2_91]:Find("song/s"), true)
	end
end

function var0_0.updateScoreUIContent(arg0_92)
	local var0_92 = findTF(arg0_92.scoreview, "ui")

	for iter0_92 = 1, var0_92.childCount do
		local var1_92 = var0_92:GetChild(iter0_92 - 1)

		setActive(var1_92, false)
	end

	if arg0_92.musicData.settlement_type and arg0_92.musicData.settlement_type ~= "" then
		arg0_92.scoreUIContent = findTF(arg0_92.scoreview, "ui/" .. arg0_92.musicData.settlement_type)
	else
		arg0_92.scoreUIContent = findTF(arg0_92.scoreview, "ui/normal")
	end

	setActive(arg0_92.scoreUIContent, true)
end

function var0_0.locadScoreView(arg0_93)
	arg0_93:updateScoreUIContent()
	arg0_93:effect_play("nothing")

	arg0_93.game_playingflag = false

	setActive(arg0_93.scoreview, true)

	arg0_93.scoreview_flag = true

	local var0_93 = findTF(arg0_93.scoreview, "bg")

	setImageColor(var0_93, Color(0, 0, 0))
	LoadSpriteAtlasAsync("ui/musicgameother_atlas", "scoreBg" .. arg0_93.musicBg, function(arg0_94)
		if var0_93 then
			GetComponent(var0_93, typeof(Image)).sprite = arg0_94

			setImageColor(var0_93, Color(1, 1, 1))
			setActive(var0_93, true)
		end
	end)
	setActive(arg0_93.game_content:Find("combo"), false)
	setActive(arg0_93.game_content:Find("MusicStar"), false)
	setActive(arg0_93.game_content:Find("combo_n"), false)
	setActive(arg0_93.game_content, false)
	setActive(arg0_93.top, false)
	setActive(arg0_93._tf:Find("Spinelist"), false)

	local var1_93 = arg0_93.scoreview:Find("maskBg").childCount

	for iter0_93 = 1, var1_93 do
		setActive(arg0_93.scoreview:Find("maskBg/bg" .. iter0_93), iter0_93 == arg0_93.musicBg)
	end

	local var2_93 = arg0_93.scoreview:Find("maskBgBottom").childCount

	for iter1_93 = 1, var2_93 do
		local var3_93 = iter1_93 == arg0_93.musicBg

		setActive(arg0_93.scoreview:Find("maskBgBottom/bg" .. iter1_93), var3_93)
	end

	local var4_93 = arg0_93.game_dgree
	local var5_93 = arg0_93.game_music

	if arg0_93.painting then
		retPaintingPrefab(arg0_93.scoreview:Find("paint"), arg0_93.painting)
	end

	local var6_93 = {}

	for iter2_93 = 1, #arg0_93.settlementPainting do
		if arg0_93.settlementPainting[iter2_93] and arg0_93.settlementPainting[iter2_93] ~= "" and arg0_93.settlementPainting[iter2_93] ~= "none" then
			table.insert(var6_93, arg0_93.settlementPainting[iter2_93])
		end
	end

	arg0_93.painting = var6_93[math.random(1, #var6_93)]

	local var7_93 = MusicGameConst.painting_const_key[string.lower(arg0_93.painting)]

	if var7_93 then
		local var8_93 = {}

		PaintingConst.AddPaintingNameWithFilteMap(var8_93, var7_93)
		PaintingConst.PaintingDownload({
			isShowBox = false,
			paintingNameList = var8_93,
			finishFunc = function()
				setPaintingPrefabAsync(arg0_93.scoreview:Find("paint"), arg0_93.painting, "mainNormal")
			end
		})
	else
		setPaintingPrefabAsync(arg0_93.scoreview:Find("paint"), arg0_93.painting, "mainNormal")
	end

	setActive(arg0_93.scoreUIContent:Find("scoreImg/square/easy"), var4_93 == 1)
	setActive(arg0_93.scoreUIContent:Find("scoreImg/square/hard"), var4_93 == 2)
	setActive(arg0_93.scoreUIContent:Find("scoreList/fullCombo"), arg0_93.miss_number == 0)
	setActive(arg0_93.scoreUIContent:Find("scoreImg/perfect/noMiss"), arg0_93.miss_number == 0 and arg0_93.good_number == 0)

	local function var9_93(arg0_96, arg1_96, arg2_96)
		LeanTween.value(go(arg0_93.scoreview), 0, arg1_96, 0.6):setOnUpdate(System.Action_float(function(arg0_97)
			setText(arg0_96, math.round(arg0_97))
		end)):setOnComplete(System.Action(function()
			arg2_96()
		end))
	end

	seriesAsync({
		function(arg0_99)
			var9_93(arg0_93.scoreUIContent:Find("scoreList/perfect"), arg0_93.perfect_number, arg0_99)
		end,
		function(arg0_100)
			var9_93(arg0_93.scoreUIContent:Find("scoreList/good"), arg0_93.good_number, arg0_100)
		end,
		function(arg0_101)
			var9_93(arg0_93.scoreUIContent:Find("scoreList/miss"), arg0_93.miss_number, arg0_101)
		end,
		function(arg0_102)
			var9_93(arg0_93.scoreUIContent:Find("scoreList/combo"), arg0_93.combo_number, arg0_102)
		end,
		function(arg0_103)
			local var0_103 = arg0_93.bestScorelist[var5_93 + (var4_93 - 1) * arg0_93.music_amount]

			if not var0_103 or var0_103 == 0 then
				var0_103 = arg0_93.score_number
			end

			if arg0_93.score_number > arg0_93.bestScorelist[var5_93 + (var4_93 - 1) * arg0_93.music_amount] then
				setActive(arg0_93.scoreUIContent:Find("scoreImg/square/newScore"), true)

				arg0_93.bestScorelist[var5_93 + (var4_93 - 1) * arg0_93.music_amount] = arg0_93.score_number
			else
				setActive(arg0_93.scoreUIContent:Find("scoreImg/square/newScore"), false)
			end

			var9_93(arg0_93.scoreUIContent:Find("scoreImg/square/bestscore"), var0_103, arg0_103)
			var9_93(arg0_93.scoreUIContent:Find("scoreImg/square/score"), arg0_93.score_number, function()
				return
			end)
			arg0_93:MyStoreDataToServer()
			arg0_93:MyGetRuntimeData()
		end,
		function(arg0_105)
			local var0_105

			if arg0_93.score_number < arg0_93.score_blist[var4_93] then
				function var0_105()
					arg0_93:setScoceview_pj("c")
				end
			elseif arg0_93.score_number >= arg0_93.score_blist[var4_93] and arg0_93.score_number < arg0_93.score_alist[var4_93] then
				function var0_105()
					arg0_93:setScoceview_pj("b")
					arg0_93:emit(BaseMiniGameMediator.MINI_GAME_SUCCESS, 0)
				end
			elseif arg0_93.score_number >= arg0_93.score_alist[var4_93] and arg0_93.score_number < arg0_93.score_slist[var4_93] then
				function var0_105()
					arg0_93:setScoceview_pj("a")
					arg0_93:emit(BaseMiniGameMediator.MINI_GAME_SUCCESS, 0)
				end
			else
				function var0_105()
					arg0_93:setScoceview_pj("s")
					arg0_93:emit(BaseMiniGameMediator.MINI_GAME_SUCCESS, 0)
				end
			end

			local var1_105 = arg0_93:GetMGHubData()
			local var2_105 = pg.NewStoryMgr.GetInstance()
			local var3_105 = arg0_93:GetMGData():getConfig("simple_config_data").story
			local var4_105 = var3_105[var1_105.usedtime + 1] and var3_105[var1_105.usedtime + 1][1] or nil

			if var1_105.count > 0 and var4_105 and not var2_105:IsPlayed(var4_105) and arg0_93.score_number >= arg0_93.score_blist[var4_93] then
				var2_105:Play(var4_105, var0_105)
			else
				var0_105()
			end

			arg0_105()
		end
	}, function()
		return
	end)

	local var10_93 = arg0_93.scoreUIContent:Find("scoreImg/square/nameText")

	setText(var10_93, arg0_93.musicData.music_name)

	local var11_93 = arg0_93.scoreUIContent:Find("scoreImg/square/name"):GetComponent(typeof(Image))

	var11_93.sprite = arg0_93.selectview:Find("Main/namelist/song" .. arg0_93.musicData.picture):GetComponent(typeof(Image)).sprite

	var11_93:SetNativeSize()

	arg0_93.scoreUIContent:Find("scoreImg/square/song"):GetComponent(typeof(Image)).sprite = arg0_93.selectview:Find("Main/MusicList/img/" .. arg0_93.musicData.picture):GetComponent(typeof(Image)).sprite

	GetComponent(arg0_93.scoreUIContent:Find("btnList/share"), typeof(Image)):SetNativeSize()
	onButton(arg0_93, arg0_93.scoreUIContent:Find("btnList/share"), function()
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeSummary)
	end, SFX_PANEL)
	GetComponent(arg0_93.scoreUIContent:Find("btnList/restart"), typeof(Image)):SetNativeSize()
	onButton(arg0_93, arg0_93.scoreUIContent:Find("btnList/restart"), function()
		setActive(arg0_93.scoreview, false)

		arg0_93.scoreview_flag = false

		arg0_93:stopTimer()
		arg0_93:rec_scorce()
		arg0_93:game_start()
		arg0_93:setScoceview_pj("e")

		if arg0_93.painting then
			retPaintingPrefab(arg0_93.scoreview:Find("paint"), arg0_93.painting)

			arg0_93.painting = nil
		end
	end, SFX_UI_CLICK)
	GetComponent(arg0_93.scoreUIContent:Find("btnList/reselect"), typeof(Image)):SetNativeSize()
	onButton(arg0_93, arg0_93.scoreUIContent:Find("btnList/reselect"), function()
		arg0_93:dynamicBgHandler(arg0_93.bgGo)
		setActive(arg0_93.scoreview, false)

		arg0_93.scoreview_flag = false

		arg0_93:stopTimer()
		setActive(arg0_93.selectview, true)

		GetOrAddComponent(arg0_93.selectview, "CanvasGroup").blocksRaycasts = true

		arg0_93:updatSelectview()
		arg0_93.song_btns[arg0_93.game_music]:GetComponent(typeof(Animator)):Play("plate_out")
		arg0_93:loadAndPlayMusic()
		arg0_93:rec_scorce()
		arg0_93:setScoceview_pj("e")

		if arg0_93.painting then
			retPaintingPrefab(arg0_93.scoreview:Find("paint"), arg0_93.painting)

			arg0_93.painting = nil
		end
	end, SFX_UI_CLICK)
end

function var0_0.setScoceview_pj(arg0_114, arg1_114)
	setActive(arg0_114.scoreUIContent:Find("scoreImg/square/c"), false)
	setActive(arg0_114.scoreUIContent:Find("scoreImg/square/b"), false)
	setActive(arg0_114.scoreUIContent:Find("scoreImg/square/a"), false)
	setActive(arg0_114.scoreUIContent:Find("scoreImg/square/s"), false)

	if arg1_114 == "e" then
		-- block empty
	elseif arg1_114 == "c" then
		setActive(arg0_114.scoreUIContent:Find("scoreImg/square/c"), true)
	elseif arg1_114 == "b" then
		setActive(arg0_114.scoreUIContent:Find("scoreImg/square/b"), true)
	elseif arg1_114 == "a" then
		setActive(arg0_114.scoreUIContent:Find("scoreImg/square/a"), true)
	elseif arg1_114 == "s" then
		setActive(arg0_114.scoreUIContent:Find("scoreImg/square/s"), true)
	end
end

function var0_0.Scoceview_ani(arg0_115)
	local var0_115 = 0

	setActive(arg0_115.scoreUIContent:Find("btnList/reselect"), false)
	setActive(arg0_115.scoreUIContent:Find("btnList/restart"), false)
	setActive(arg0_115.scoreUIContent:Find("btnList/share"), false)

	local function var1_115()
		var0_115 = var0_115 + arg0_115.time_interval

		if var0_115 >= 0.99 then
			setActive(arg0_115.scoreUIContent:Find("btnList/reselect"), true)
			setActive(arg0_115.scoreUIContent:Find("btnList/restart"), true)
			setActive(arg0_115.scoreUIContent:Find("btnList/share"), true)
			setText(arg0_115.scoreUIContent:Find("scoreList/perfect"), arg0_115.perfect_number)
			setText(arg0_115.scoreUIContent:Find("scoreList/good"), arg0_115.good_number)
			setText(arg0_115.scoreUIContent:Find("scoreList/miss"), arg0_115.miss_number)
			setText(arg0_115.scoreUIContent:Find("scoreList/combo"), arg0_115.combo_number)
			setText(arg0_115.scoreUIContent:Find("scoreImg/square/bestscore"), arg0_115.score_number)
		else
			setText(arg0_115.scoreUIContent:Find("scoreList/perfect"), math.floor(arg0_115.perfect_number * var0_115))
			setText(arg0_115.scoreUIContent:Find("scoreList/good"), math.floor(arg0_115.good_number * var0_115))
			setText(arg0_115.scoreUIContent:Find("scoreList/miss"), math.floor(arg0_115.miss_number * var0_115))
			setText(arg0_115.scoreUIContent:Find("scoreList/combo"), math.floor(arg0_115.combo_number * var0_115))
			setText(arg0_115.scoreUIContent:Find("scoreImg/square/bestscore"), math.floor(arg0_115.score_number * var0_115))
		end

		if var0_115 >= 1.03 then
			arg0_115.Scoceview_timer:Stop()
		end
	end

	arg0_115.Scoceview_timer = Timer.New(var1_115, arg0_115.time_interval, -1)

	arg0_115.Scoceview_timer:Start()
end

function var0_0.gameStart(arg0_117)
	if not arg0_117.timer then
		arg0_117.timer = Timer.New(function()
			arg0_117:gameStepNew()
		end, arg0_117.time_interval, -1)
	end

	arg0_117.aheadtime_count = 0

	local var0_117 = 2

	arg0_117.ahead_timerPauseFlag = false

	local function var1_117()
		arg0_117.ahead_timeflag = true

		if not arg0_117.timer.running then
			arg0_117:startTimer()
		end

		if not arg0_117.ahead_timerPauseFlag then
			arg0_117.aheadtime_count = arg0_117.aheadtime_count + arg0_117.time_interval

			if arg0_117.aheadtime_count > var0_117 then
				arg0_117.aheadtime_count = nil
				arg0_117.ahead_timeflag = false
				arg0_117.gotspecialcombo_flag = false

				arg0_117.ahead_timer:Stop()
				arg0_117:loadAndPlayMusic(function()
					return
				end)
			end
		end
	end

	CriWareMgr.Inst:UnloadCueSheet(arg0_117:getMusicBgm(arg0_117.musicData))

	arg0_117.ahead_timer = Timer.New(var1_117, arg0_117.time_interval, -1)

	arg0_117:count_five(function()
		arg0_117.ahead_timer:Start()
	end)
end

function var0_0.getMusicBgm(arg0_122, arg1_122)
	local var0_122 = "bgm-song"

	if arg1_122.bgm < 10 then
		var0_122 = var0_122 .. "0" .. tostring(arg1_122.bgm)
	else
		var0_122 = var0_122 .. tostring(arg1_122.bgm)
	end

	return var0_122
end

function var0_0.getMusicNote(arg0_123, arg1_123, arg2_123)
	return "view/miniGame/gameView/musicGame/bgm_song" .. "0" .. arg1_123.note .. "_" .. arg2_123
end

function var0_0.gameStepNew(arg0_124)
	local var0_124 = arg0_124.game_dgree

	arg0_124.gameStepTime = arg0_124:getStampTime()
	arg0_124.downingright_lastflag = arg0_124.downingright_flag
	arg0_124.downingleft_lastflag = arg0_124.downingleft_flag

	if IsUnityEditor then
		if var0_124 == 2 then
			arg0_124.downingright_flag = Input.GetKey(KeyCode.J)
			arg0_124.downingleft_flag = Input.GetKey(KeyCode.F)
		elseif var0_124 == 1 then
			if Input.GetKey(KeyCode.J) or Input.GetKey(KeyCode.F) then
				arg0_124.downingright_flag = true
				arg0_124.downingleft_flag = true
			else
				arg0_124.downingright_flag = false
				arg0_124.downingleft_flag = false
			end
		end
	elseif var0_124 == 2 then
		arg0_124.downingright_flag = arg0_124.mousedowningright_flag
		arg0_124.downingleft_flag = arg0_124.mousedowningleft_flag
	elseif var0_124 == 1 then
		if arg0_124.mousedowningright_flag or arg0_124.mousedowningleft_flag then
			arg0_124.downingright_flag = true
			arg0_124.downingleft_flag = true
		else
			arg0_124.downingright_flag = false
			arg0_124.downingleft_flag = false
		end
	end

	if var0_124 == 2 then
		if not arg0_124.downingleft_lastflag and arg0_124.downingleft_flag then
			arg0_124.gameNoteLeft:onKeyDown()

			arg0_124.leftDownStepTime = arg0_124.gameStepTime

			if arg0_124.rightDownStepTime and math.abs(arg0_124.leftDownStepTime - arg0_124.rightDownStepTime) < 100 then
				arg0_124.gameNoteLeft:bothDown()
				arg0_124.gameNoteRight:bothDown()
			end
		elseif arg0_124.downingleft_lastflag and not arg0_124.downingleft_flag then
			arg0_124.leftUpStepTime = arg0_124.gameStepTime

			arg0_124.gameNoteLeft:onKeyUp()

			if arg0_124.rightUpStepTime and math.abs(arg0_124.leftUpStepTime - arg0_124.rightUpStepTime) < 100 then
				arg0_124.gameNoteLeft:bothUp()
				arg0_124.gameNoteRight:bothUp()
			end
		end

		if not arg0_124.downingright_lastflag and arg0_124.downingright_flag then
			arg0_124.gameNoteRight:onKeyDown()

			arg0_124.rightDownStepTime = arg0_124.gameStepTime

			if arg0_124.leftDownStepTime and math.abs(arg0_124.leftDownStepTime - arg0_124.rightDownStepTime) < 200 then
				arg0_124.gameNoteLeft:bothDown()
				arg0_124.gameNoteRight:bothDown()
			end
		elseif arg0_124.downingright_lastflag and not arg0_124.downingright_flag then
			arg0_124.rightUpStepTime = arg0_124.gameStepTime

			arg0_124.gameNoteRight:onKeyUp()

			if arg0_124.leftUpStepTime and math.abs(arg0_124.leftUpStepTime - arg0_124.rightUpStepTime) < 200 then
				arg0_124.gameNoteLeft:bothUp()
				arg0_124.gameNoteRight:bothUp()
			end
		end
	elseif not arg0_124.downingright_lastflag and arg0_124.downingright_flag then
		arg0_124.gameNoteLeft:onKeyDown()
		arg0_124.gameNoteRight:onKeyDown()
	elseif arg0_124.downingleft_lastflag and not arg0_124.downingleft_flag then
		arg0_124.gameNoteLeft:onKeyUp()
		arg0_124.gameNoteRight:onKeyUp()
	end

	arg0_124.musicgame_lasttime = arg0_124.musicgame_nowtime or 0

	if arg0_124.criInfo then
		arg0_124.musicgame_nowtime = arg0_124:getStampTime() / 1000
	else
		arg0_124.musicgame_nowtime = 0
	end

	if arg0_124.song_Tlength and not arg0_124.scoreview_flag and long2int(arg0_124.song_Tlength) / 1000 - arg0_124.musicgame_nowtime <= 0.01666 then
		print("歌曲播放结束")
		arg0_124:pauseBgm()

		arg0_124.game_playingflag = false

		local function var1_124()
			arg0_124:locadScoreView()
		end

		if arg0_124.perfect_number > 0 and arg0_124.good_number == 0 and arg0_124.miss_number == 0 then
			setActive(arg0_124.fullComboEffect, true)

			if not arg0_124.gotspecialcombo_flag then
				arg0_124.score_number = arg0_124.score_number + arg0_124.specialscore_number
				arg0_124.gotspecialcombo_flag = true
			end

			LeanTween.delayedCall(go(arg0_124.fullComboEffect), 2, System.Action(function()
				var1_124()
			end))
		elseif (arg0_124.good_number > 0 or arg0_124.perfect_number > 0) and arg0_124.miss_number <= 0 then
			setActive(arg0_124.fullComboEffect, true)

			if not arg0_124.gotspecialcombo_flag then
				arg0_124.score_number = arg0_124.score_number + arg0_124.specialscore_number
				arg0_124.gotspecialcombo_flag = true
			end

			LeanTween.delayedCall(go(arg0_124.fullComboEffect), 2, System.Action(function()
				var1_124()
			end))
		else
			setActive(arg0_124.liveClearEffect, true)
			LeanTween.delayedCall(go(arg0_124.liveClearEffect), 2, System.Action(function()
				var1_124()
			end))
		end

		return
	end

	arg0_124.gameNoteLeft:step(arg0_124.gameStepTime)
	arg0_124.gameNoteRight:step(arg0_124.gameStepTime)
	arg0_124:scoresliderAcombo_update()

	if arg0_124.drumpFlag and not arg0_124.gameNoteLeft:loopTime() and not arg0_124.gameNoteRight:loopTime() then
		arg0_124.drumpFlag = false
		arg0_124.drupTime = Time.realtimeSinceStartup

		arg0_124:setActionSDmodel("jump")
		LeanTween.delayedCall(go(arg0_124.game_content), 1, System.Action(function()
			arg0_124:setActionSDmodel("idol")
		end))
	end
end

function var0_0.onStateCallback(arg0_130, arg1_130)
	arg0_130:score_update(arg1_130)
end

function var0_0.onLongTimeCallback(arg0_131, arg1_131)
	if arg0_131.drupTime and Time.realtimeSinceStartup - arg0_131.drupTime < 2 then
		return
	end

	if arg1_131 > 0.5 then
		arg0_131.drumpFlag = true
	end
end

return var0_0
