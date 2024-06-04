local var0 = class("MusicGameView", import("..BaseMiniGameView"))
local var1 = false
local var2 = 0.95
local var3 = 0
local var4 = 1
local var5 = 3
local var6 = 5
local var7 = 2

function var0.getUIName(arg0)
	return "MusicGameUI"
end

function var0.MyGetRuntimeData(arg0)
	local var0 = getProxy(PlayerProxy):getData().id

	arg0.achieve_times = checkExist(arg0:GetMGData():GetRuntimeData("elements"), {
		1
	}) or 0
	arg0.isFirstgame = PlayerPrefs.GetInt("musicgame_first_" .. var0)
	arg0.bestScorelist = {}

	for iter0 = 1, arg0.music_amount * 2 do
		local var1 = arg0:GetMGData():GetRuntimeData("elements")

		arg0.bestScorelist[iter0] = checkExist(var1, {
			iter0 + 2
		}) or 0
	end

	arg0:updatSelectview()
end

function var0.MyStoreDataToServer(arg0)
	local var0 = getProxy(PlayerProxy):getData().id
	local var1 = {
		arg0.achieve_times,
		1
	}

	PlayerPrefs.SetInt("musicgame_first_" .. var0, 1)

	for iter0 = 1, arg0.music_amount * 2 do
		table.insert(var1, iter0 + 2, arg0.bestScorelist[iter0])
	end

	arg0:StoreDataToServer(var1)
end

function var0.init(arg0)
	arg0.UIMgr = pg.UIMgr.GetInstance()
	arg0.useGetKey_flag = true
	arg0.game_playingflag = false
	arg0.countingfive_flag = false
	arg0.downingleft_flag = false
	arg0.downingright_flag = false
	arg0.downingright_lastflag = false
	arg0.downingleft_lastflag = false
	arg0.nowS_flag = false
	arg0.firstview_timerRunflag = false
	arg0.ahead_timeflag = false
	arg0.ahead_timerPauseFlag = false
	arg0.changeLocalposTimerflag = false
	arg0.piecelist_rf = {}
	arg0.piecelist_rf[0] = 0
	arg0.piecelist_lf = {}
	arg0.piecelist_lf[0] = 0
	arg0.piece_nowl = {}
	arg0.piece_nowr = {}
	arg0.piece_nowl_downflag = false
	arg0.piece_nowr_downflag = false
	arg0.piece_nowl_aloneflag = false
	arg0.piece_nowr_aloneflag = false
	arg0.SDmodel = {}
	arg0.SDmodel_idolflag = false
	arg0.musicgame_nowtime = 0
	arg0.musicgame_lasttime = 0
	arg0.time_interval = 0.01666
	arg0.music_amount = #pg.beat_game_music.all
	arg0.music_amount_middle = math.ceil(#pg.beat_game_music.all / 2)
	arg0.musicDatas = {}

	for iter0 = 1, #pg.beat_game_music.all do
		local var0 = pg.beat_game_music.all[iter0]
		local var1 = pg.beat_game_music[var0]

		table.insert(arg0.musicDatas, var1)
	end

	table.sort(arg0.musicDatas, function(arg0, arg1)
		if arg0.sort and arg1.sort then
			return arg0.sort < arg1.sort
		end

		return arg0.id < arg1.id
	end)

	arg0.game_speed = PlayerPrefs.GetInt("musicgame_idol_speed") > 0 and PlayerPrefs.GetInt("musicgame_idol_speed") or 1
	arg0.game_dgree = 1
	arg0.countContent = arg0:findTF("countContent")
	arg0.countTf = nil
	arg0.top = arg0:findTF("top")
	arg0.btn_pause = arg0.top:Find("pause")
	arg0.score = arg0.top:Find("score")
	arg0.game_content = arg0:findTF("GameContent")
	arg0.noteTpl = arg0.game_content:Find("noteTpl")
	arg0.pauseview = arg0:findTF("Pauseview")
	arg0.selectview = arg0:findTF("Selectview")

	local var2 = findTF(arg0.selectview, "bg")

	LoadSpriteAtlasAsync("ui/musicgameother_atlas", "selectbg", function(arg0)
		GetComponent(var2, typeof(Image)).sprite = arg0

		setActive(var2, true)
	end)

	arg0.firstview = arg0:findTF("firstview")
	arg0.scoreview = arg0:findTF("ScoreView")

	setActive(arg0.scoreview, false)

	arg0.scoreview_flag = false
	arg0.bg = findTF(arg0._tf, "bg")

	pg.BgmMgr.GetInstance():StopPlay()
	arg0:updateMusic(var4)
end

function var0.didEnter(arg0)
	local var0 = 0

	local function var1()
		var0 = var0 + arg0.time_interval

		if var0 == arg0.time_interval then
			arg0:MyGetRuntimeData()
			arg0:showSelevtView()
		elseif var0 == arg0.time_interval * 2 then
			arg0:updatSelectview()
			arg0.Getdata_timer:Stop()
		end
	end

	LeanTween.delayedCall(go(arg0.selectview), 2, System.Action(function()
		arg0:MyGetRuntimeData()
	end))

	arg0.Getdata_timer = Timer.New(var1, arg0.time_interval, -1)

	arg0.Getdata_timer:Start()

	arg0.score_number = 0
	arg0.combo_link = 0
	arg0.combo_number = 0
	arg0.perfect_number = 0
	arg0.good_number = 0
	arg0.miss_number = 0

	local var2 = arg0:GetMGData():getConfig("simple_config_data")

	arg0.piecelist_speed = var2.speed
	arg0.piecelist_speedmin = var2.speed_min
	arg0.piecelist_speedmax = var2.speed_max
	arg0.specialcombo_number = var2.special_combo
	arg0.specialscore_number = var2.special_score
	arg0.score_perfect = var2.perfect
	arg0.score_good = var2.good
	arg0.score_miss = var2.miss
	arg0.score_combo = var2.combo
	arg0.time_perfect = var2.perfecttime
	arg0.time_good = var2.goodtime
	arg0.time_miss = var2.misstime
	arg0.time_laterperfect = var2.laterperfecttime
	arg0.time_latergood = var2.latergoodtime
	arg0.combo_interval = var2.combo_interval
	arg0.BtnRightDelegate = GetOrAddComponent(arg0.game_content:Find("btn_right"), "EventTriggerListener")

	arg0.BtnRightDelegate:AddPointDownFunc(function()
		arg0.mousedowningright_flag = true

		setActive(arg0.bottonRightBg, true)
	end)
	arg0.BtnRightDelegate:AddPointUpFunc(function()
		arg0.mousedowningright_flag = false

		setActive(arg0.bottonRightBg, false)
	end)

	arg0.BtnLeftDelegate = GetOrAddComponent(arg0.game_content:Find("btn_left"), "EventTriggerListener")

	arg0.BtnLeftDelegate:AddPointDownFunc(function()
		arg0.mousedowningleft_flag = true

		setActive(arg0.bottonLeftBg, true)
	end)
	arg0.BtnLeftDelegate:AddPointUpFunc(function()
		arg0.mousedowningleft_flag = false

		setActive(arg0.bottonLeftBg, false)
	end)
	onButton(arg0, arg0.top:Find("pause"), function()
		arg0.UIMgr:BlurPanel(arg0.pauseview)
		setActive(arg0.pauseview, true)

		arg0.game_playingflag = false

		arg0:effect_play("nothing")
		LoadSpriteAtlasAsync("ui/musicgameother_atlas", "pause_" .. arg0.musicData.picture, function(arg0)
			setImageSprite(arg0.pauseview:Find("bottom/song"), arg0, true)
		end)
		GetComponent(arg0.pauseview:Find("bottom/img"), typeof(Image)):SetNativeSize()

		if not arg0.ahead_timeflag then
			arg0:pauseBgm()

			local var0 = arg0:getStampTime()
			local var1 = arg0.song_Tlength

			if var0 < 0 then
				var0 = 0
			end

			if var0 >= 0 and var1 > 0 then
				local function var2(arg0)
					if arg0 < 10 then
						return "0" .. arg0
					else
						return arg0
					end
				end

				local var3 = var2(math.floor(var0 % 60000 / 1000))
				local var4 = var2(math.floor(var0 / 60000))

				setText(arg0.pauseview:Find("bottom/now"), var4 .. ":" .. var3)

				local var5 = var2(math.floor(var1 % 60000 / 1000))
				local var6 = var2(math.floor(var1 / 60000))

				setText(arg0.pauseview:Find("bottom/total"), var6 .. ":" .. var5)
				setActive(arg0.pauseview:Find("bottom/triangle"), true)
				setActive(arg0.pauseview:Find("bottom/TimeSlider"), true)
				setActive(arg0.pauseview:Find("bottom/now"), true)
				setActive(arg0.pauseview:Find("bottom/total"), true)
				setSlider(arg0.pauseview:Find("bottom/TimeSlider"), 0, 1, var0 / var1)

				local var7 = arg0.pauseview:Find("bottom/triangle/min").localPosition.x
				local var8 = arg0.pauseview:Find("bottom/triangle/max").localPosition.x
				local var9 = arg0.pauseview:Find("bottom/triangle/now").localPosition

				arg0.pauseview:Find("bottom/triangle/now").localPosition = Vector3(var7 + var0 / var1 * (var8 - var7), var9.y, var9.z)

				arg0:setActionSDmodel("stand2")
			end
		else
			setActive(arg0.pauseview:Find("bottom/triangle"), false)
			setActive(arg0.pauseview:Find("bottom/TimeSlider"), false)
			setActive(arg0.pauseview:Find("bottom/now"), false)
			setActive(arg0.pauseview:Find("bottom/total"), false)

			arg0.ahead_timerPauseFlag = true
		end
	end, SFX_UI_CLICK)
	onButton(arg0, arg0.pauseview:Find("bottom/back"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("reselect_music_game"),
			onYes = function()
				arg0.UIMgr:UnblurPanel(arg0.pauseview, arg0._tf)
				setActive(arg0.pauseview, false)
				arg0:stopTimer()

				if arg0.ahead_timer then
					arg0.ahead_timer:Stop()

					arg0.ahead_timeflag = false
				end

				setActive(arg0.selectview, true)

				GetOrAddComponent(arg0.selectview, "CanvasGroup").blocksRaycasts = true

				arg0.song_btns[arg0.game_music]:GetComponent(typeof(Animator)):Play("plate_out")

				arg0.game_playingflag = false

				arg0:loadAndPlayMusic()
				arg0:rec_scorce()
			end
		})
	end, SFX_UI_CLICK)
	onButton(arg0, arg0.pauseview:Find("bottom/restart"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("restart_music_game"),
			onYes = function()
				arg0.UIMgr:UnblurPanel(arg0.pauseview, arg0._tf)
				setActive(arg0.pauseview, false)
				arg0:stopTimer()

				if arg0.ahead_timer then
					arg0.ahead_timer:Stop()

					arg0.ahead_timeflag = false
				end

				arg0:rec_scorce()
				arg0:game_start()
				arg0:effect_play("prepare")
			end
		})
	end, SFX_UI_CLICK)
	onButton(arg0, arg0.pauseview:Find("bottom/resume"), function()
		arg0.UIMgr:UnblurPanel(arg0.pauseview, arg0._tf)
		setActive(arg0.pauseview, false)
		arg0:effect_play("prepare")

		if not arg0.ahead_timeflag then
			local function var0()
				arg0:resumeBgm()

				arg0.game_playingflag = true
			end

			arg0:count_five(var0)
		else
			local function var1()
				arg0.ahead_timerPauseFlag = false
				arg0.game_playingflag = true

				setActive(arg0.pauseview:Find("bottom/triangle"), true)
				setActive(arg0.pauseview:Find("bottom/TimeSlider"), true)
				setActive(arg0.pauseview:Find("bottom/now"), true)
				setActive(arg0.pauseview:Find("bottom/total"), true)
			end

			arg0:count_five(var1)
		end
	end, SFX_UI_CLICK)
	arg0:addRingDragListenter()
	setActive(arg0.selectview, true)

	GetOrAddComponent(arg0.selectview, "CanvasGroup").blocksRaycasts = true
end

function var0.updateBg(arg0)
	if arg0.isLoading then
		arg0:dynamicBgHandler(arg0.bgGo, function()
			setParent(arg0.bgGo, arg0.bg)
			setActive(arg0.bgGo, true)
		end)

		return
	end

	if arg0.bgGo and arg0.bgName then
		arg0:dynamicBgHandler(arg0.bgGo)
		PoolMgr.GetInstance():ReturnUI(arg0.bgName, arg0.bgGo)
	end

	arg0.bgName = "musicgamebg" .. arg0.musicBg
	arg0.isLoading = true

	local var0 = arg0.bgName

	PoolMgr.GetInstance():GetUI("" .. var0, true, function(arg0)
		arg0.bgGo = arg0

		if arg0.isLoading == false then
			arg0:dynamicBgHandler(arg0.bgGo)
			PoolMgr.GetInstance():ReturnUI(var0, arg0.bgGo)
		else
			arg0.isLoading = false

			setParent(arg0.bgGo, arg0.bg)
			setActive(arg0.bgGo, true)
		end
	end)
end

function var0.dynamicBgHandler(arg0, arg1, arg2)
	if IsNil(arg1) then
		return
	end

	if arg2 ~= nil then
		arg2()
	end
end

function var0.onBackPressed(arg0)
	if not arg0.countingfive_flag and not arg0.firstview_timerRunflag then
		if arg0.game_playingflag then
			if not isActive(arg0.top:Find("pause_above")) then
				triggerButton(arg0.top:Find("pause"))
			end
		elseif isActive(arg0.selectview) and var3 == 0 then
			arg0:emit(var0.ON_BACK)
		end
	end
end

function var0.OnApplicationPaused(arg0, arg1)
	if arg1 and not arg0.countingfive_flag and not arg0.firstview_timerRunflag and arg0.game_playingflag and not isActive(arg0.top:Find("pause_above")) then
		triggerButton(arg0.top:Find("pause"))
	end
end

function var0.willExit(arg0)
	arg0.isLoading = false

	if arg0.bgGo and arg0.bgName then
		arg0:dynamicBgHandler(arg0.bgGo)
		PoolMgr.GetInstance():ReturnUI(arg0.bgName, arg0.bgGo)
	end

	if arg0.timer then
		if arg0.timer.running then
			arg0.timer:Stop()
		end

		arg0.timer = nil
	end

	if arg0.ahead_timer then
		if arg0.ahead_timer.running then
			arg0.ahead_timer:Stop()
		end

		arg0.ahead_timer = nil
	end

	if arg0.firstview_timer then
		if arg0.firstview_timer.running then
			arg0.firstview_timer:Stop()
		end

		arg0.firstview_timer = nil
	end

	if arg0.changeLocalpos_timer then
		if arg0.changeLocalpos_timer.running then
			arg0.changeLocalpos_timer:Stop()
		end

		arg0.changeLocalpos_timer = nil
	end

	if arg0.count_timer then
		if arg0.count_timer.running then
			arg0.count_timer:Stop()
		end

		arg0.count_timer = nil
	end

	if arg0.Scoceview_timer then
		if arg0.Scoceview_timer.running then
			arg0.Scoceview_timer:Stop()
		end

		arg0.Scoceview_timer = nil
	end

	if arg0.Getdata_timer then
		if arg0.Getdata_timer.running then
			arg0.Getdata_timer:Stop()
		end

		arg0.Getdata_timer = nil
	end

	arg0:clearSDModel()

	arg0.piecelist_lt = {}
	arg0.piecelist_lf = {}
	arg0.musictable_l = {}
	arg0.piece_nowl = {}
	arg0.piecelist_rt = {}
	arg0.piecelist_rf = {}
	arg0.musictable_r = {}
	arg0.piece_nowr = {}

	if arg0.painting then
		retPaintingPrefab(arg0.scoreview:Find("paint"), arg0.painting)

		arg0.painting = nil
	end

	if arg0.criInfo then
		arg0.criInfo:PlaybackStop()
		arg0.criInfo:SetStartTimeAndPlay(0)
		pg.CriMgr.GetInstance():UnloadCueSheet(arg0:getMusicBgm(arg0.musicData))

		arg0.criInfo = nil
	end

	if LeanTween.isTweening(go(arg0.selectview)) then
		LeanTween.cancel(go(arg0.selectview))
	end

	if LeanTween.isTweening(go(arg0.countContent)) then
		LeanTween.cancel(go(arg0.countContent))
	end

	if LeanTween.isTweening(go(arg0.scoreview)) then
		LeanTween.cancel(go(arg0.scoreview))
	end

	if LeanTween.isTweening(go(arg0.game_content)) then
		LeanTween.cancel(go(arg0.game_content))
	end

	pg.BgmMgr.GetInstance():ContinuePlay()
end

function var0.clearSDModel(arg0)
	if not arg0.SDmodel or not arg0.SDname or arg0.SDname == "" or arg0.SDname == "none" then
		return
	end

	for iter0 = 1, #arg0.SDmodel do
		if arg0.SDmodel[iter0] then
			PoolMgr.GetInstance():ReturnSpineChar(arg0.SDname[iter0], arg0.SDmodel[iter0])
		end
	end

	arg0.SDmodel = {}
end

function var0.list_push(arg0, arg1, arg2)
	arg1[arg1[0] + 1] = arg2
	arg1[0] = arg1[0] + 1
end

function var0.list_pop(arg0, arg1)
	if arg1[0] == 0 then
		return
	end

	local var0 = arg1[1]

	for iter0 = 1, arg1[0] - 1 do
		arg1[iter0] = arg1[iter0 + 1]
	end

	arg1[0] = arg1[0] - 1

	return var0
end

function var0.game_start(arg0)
	arg0:game_before()
	arg0:effect_play("prepare")

	arg0.game_playingflag = true
	arg0.SDmodel_jumpcount = 0
	arg0.gotspecialcombo_flag = false

	arg0:updateBg()

	arg0.song_Tlength = false

	arg0:effect_play("nothing")
	arg0:effect_play("prepare")

	if arg0.isFirstgame == 0 then
		arg0:Firstshow(arg0.firstview, function()
			arg0:gameStart()
		end, 2)
		arg0:MyStoreDataToServer()
	else
		arg0:gameStart()
	end
end

function var0.game_before(arg0)
	arg0:effect_play("nothing")

	arg0.nowS_flag = false

	arg0:setTfChildVisible(arg0.top:Find("scoreContent/scroll"), false)

	arg0.scoreSliderTf = arg0.top:Find("scoreContent/scroll/" .. tostring(arg0.musicData.content_type))

	setSlider(arg0.scoreSliderTf, 0, 1, 0)
	setActive(arg0.scoreSliderTf, true)
	setActive(findTF(arg0.scoreSliderTf, "img/mask/yinyue20_S"), false)

	arg0.scoreSFlag = false

	setImageColor(findTF(arg0.scoreSliderTf, "img"), Color(1, 1, 1, 1))

	local var0 = arg0.game_content:Find("evaluate")

	for iter0 = 1, var0.childCount do
		local var1 = var0:GetChild(iter0 - 1)

		for iter1 = 1, var1.childCount do
			setActive(var1:GetChild(iter1 - 1), false)
		end

		setActive(findTF(var1, tostring(arg0.musicData.content_type)), true)
		setActive(var0:GetChild(iter0 - 1), false)
	end

	local var2 = arg0.game_content:Find("bottomList")

	for iter2 = 1, var2.childCount do
		local var3 = var2:GetChild(iter2 - 1)

		setActive(var3, false)
	end

	if arg0.musicData.bottom_type and arg0.musicData.bottom_type > 0 then
		arg0.bottonLeftBg = arg0.game_content:Find("bottomList/" .. arg0.musicData.bottom_type .. "/bottom_leftbg")
		arg0.bottonRightBg = arg0.game_content:Find("bottomList/" .. arg0.musicData.bottom_type .. "/bottom_rightbg")

		setActive(arg0.bottonLeftBg, false)
		setActive(arg0.bottonRightBg, false)
		setActive(arg0.game_content:Find("bottomList/" .. arg0.musicData.bottom_type), true)
		setActive(arg0.game_content:Find("bottomList/" .. arg0.musicData.bottom_type), true)
	end

	arg0:clearSDModel()

	for iter3 = 1, #arg0.SDname do
		arg0:loadSDModel(iter3)
	end

	arg0:setActionSDmodel("stand2")
	setActive(arg0.game_content:Find("combo"), false)
	setActive(arg0.game_content:Find("combo_n"), false)
	setActive(arg0.game_content:Find("MusicStar"), false)
	setActive(arg0.game_content, true)
	setActive(arg0._tf:Find("Spinelist"), true)
	setActive(arg0.top, true)
	setActive(arg0.fullComboEffect, false)
	setActive(arg0.liveClearEffect, false)

	local var4 = arg0:getMusicNote(arg0.musicData, arg0.game_dgree)
	local var5 = require(var4)

	arg0.leftPu = {}
	arg0.rightPu = {}

	for iter4, iter5 in ipairs(var5.left_track) do
		table.insert(arg0.leftPu, iter5)
	end

	for iter6, iter7 in ipairs(var5.right_track) do
		table.insert(arg0.rightPu, iter7)
	end

	arg0:setTfChildVisible(arg0.noteTpl, false)

	if not arg0.gameNoteLeft then
		arg0.gameNoteLeft = MusicGameNote.New(findTF(arg0.game_content, "MusicPieceLeft"), arg0.noteTpl, MusicGameNote.type_left)
	end

	if not arg0.gameNoteRight then
		arg0.gameNoteRight = MusicGameNote.New(findTF(arg0.game_content, "MusicPieceRight"), arg0.noteTpl, MusicGameNote.type_right)
	end

	arg0.gameNoteLeft:setStartData(arg0.leftPu, arg0.game_speed, arg0.game_dgree, arg0.noteType)
	arg0.gameNoteLeft:setStateCallback(function(arg0)
		arg0:onStateCallback(arg0)
	end)
	arg0.gameNoteLeft:setLongTimeCallback(function(arg0)
		arg0:onLongTimeCallback(arg0)
	end)
	arg0.gameNoteRight:setStartData(arg0.rightPu, arg0.game_speed, arg0.game_dgree, arg0.noteType)
	arg0.gameNoteRight:setStateCallback(function(arg0)
		arg0:onStateCallback(arg0)
	end)
	arg0.gameNoteRight:setLongTimeCallback(function(arg0)
		arg0:onLongTimeCallback(arg0)
	end)

	arg0.gameStepTime = 0
	arg0.musictable_l = {}
	arg0.musictable_l[0] = 0
	arg0.musictable_r = {}
	arg0.musictable_r[0] = 0
	arg0.nowmusic_l = nil
	arg0.nowmusic_r = nil

	local var6 = arg0:getMusicNote(arg0.musicData, arg0.game_dgree)

	arg0.musicpu = require(var6)

	for iter8, iter9 in ipairs(arg0.musicpu.left_track) do
		arg0:list_push(arg0.musictable_l, iter9)
	end

	for iter10, iter11 in ipairs(arg0.musicpu.right_track) do
		arg0:list_push(arg0.musictable_r, iter11)
	end

	local var7 = arg0.scoreSliderTf
	local var8 = arg0.top:Find("scoreContent/B")
	local var9 = arg0.top:Find("scoreContent/A")
	local var10 = arg0.top:Find("scoreContent/S")

	var8.anchoredPosition = Vector3(arg0.scoreSliderTf.anchoredPosition.x + var7.rect.width * 0.53, var8.anchoredPosition.y, var8.anchoredPosition.z)
	var9.anchoredPosition = Vector3(arg0.scoreSliderTf.anchoredPosition.x + var7.rect.width * 0.72, var8.anchoredPosition.y, var8.anchoredPosition.z)
	var10.anchoredPosition = Vector3(arg0.scoreSliderTf.anchoredPosition.x + var7.rect.width * 0.885, var8.anchoredPosition.y, var8.anchoredPosition.z)

	arg0:scoresliderAcombo_update()
end

function var0.stopTimer(arg0)
	if arg0.timer.running then
		arg0.timer:Stop()
	end
end

function var0.startTimer(arg0)
	if not arg0.timer.running then
		arg0.timer:Start()
	end
end

function var0.loadSDModel(arg0, arg1)
	if not arg0.SDname[arg1] or arg0.SDname[arg1] == "" or arg0.SDname[arg1] == "none" then
		arg0.SDmodel[arg1] = false

		setActive(findTF(arg0._tf, "Spinelist/" .. arg1 .. "/shadow"), false)
		setActive(findTF(arg0._tf, "Spinelist/" .. arg1 .. "/light"), false)

		return
	end

	local var0 = findTF(arg0._tf, "Spinelist/" .. arg1 .. "/light")
	local var1 = findTF(arg0._tf, "Spinelist/" .. arg1 .. "/shadow")
	local var2 = findTF(arg0._tf, "Spinelist/" .. arg1 .. "/" .. arg0.musicData.content_type)

	var0.anchoredPosition = var2.anchoredPosition
	var1.anchoredPosition = var2.anchoredPosition

	setActive(var0, true)

	if arg0.musicLight and arg0.shadowLight then
		setActive(findTF(arg0._tf, "Spinelist/" .. arg1 .. "/shadow"), true)
	else
		setActive(findTF(arg0._tf, "Spinelist/" .. arg1 .. "/shadow"), false)
	end

	for iter0 = 1, var6 do
		if arg0.musicLight and arg0.musicLight > 0 then
			setActive(findTF(arg0._tf, "Spinelist/" .. arg1 .. "/light"), false)

			local var3 = iter0

			if arg0.musicData.ships[iter0] and arg0.musicData.ships[iter0] ~= "" and arg0.musicData.ships[iter0] ~= "none" then
				LoadSpriteAtlasAsync("ui/musicgameother_atlas", "light" .. arg0.musicLight, function(arg0)
					setActive(findTF(arg0._tf, "Spinelist/" .. var3 .. "/light"), true)
					setImageSprite(findTF(arg0._tf, "Spinelist/" .. var3 .. "/light"), arg0, true)
				end)
			end
		end

		setActive(findTF(arg0._tf, "Spinelist/" .. arg1 .. "/light"), false)
	end

	pg.UIMgr.GetInstance():LoadingOff()
	PoolMgr.GetInstance():GetSpineChar(arg0.SDname[arg1], true, function(arg0)
		arg0.SDmodel[arg1] = arg0
		tf(arg0).localScale = Vector3(1, 1, 1)

		arg0:GetComponent("SpineAnimUI"):SetAction("stand2", 0)
		setParent(arg0, arg0._tf:Find("Spinelist/" .. arg1))

		local var0 = arg0._tf:Find("Spinelist/" .. arg1 .. "/" .. arg0.musicData.content_type)

		tf(arg0).anchoredPosition = var0.anchoredPosition
	end)
end

function var0.SDmodeljump_btnup(arg0)
	if arg0.downingright_flag or arg0.downingleft_flag then
		arg0.SDmodel_jumpcount = arg0.SDmodel_jumpcount + arg0.time_interval
		arg0.SDmodel_jumpcount = arg0.SDmodel_jumpcount > 1 and 1 or arg0.SDmodel_jumpcount
	else
		if arg0.SDmodel_jumpcount == 1 then
			arg0:setActionSDmodel("jump")

			arg0.SDmodel_idolflag = false
		end

		if arg0.SDmodel_jumpcount > 0 then
			arg0.SDmodel_jumpcount = arg0.SDmodel_jumpcount - arg0.time_interval
			arg0.SDmodel_jumpcount = arg0.SDmodel_jumpcount < 0 and 0 or arg0.SDmodel_jumpcount
		end

		if arg0.SDmodel_jumpcount == 0 and not arg0.SDmodel_idolflag then
			arg0.SDmodel_idolflag = true

			arg0:setActionSDmodel("idol")
		end
	end
end

function var0.setActionSDmodel(arg0, arg1, arg2)
	arg2 = arg2 or 0

	for iter0 = 1, #arg0.SDmodel do
		if arg0.SDmodel[iter0] then
			arg0.SDmodel[iter0]:GetComponent("SpineAnimUI"):SetAction(arg1, arg2)
		end
	end
end

function var0.loadAndPlayMusic(arg0, arg1, arg2)
	local var0 = arg0:getMusicBgm(arg0.musicData)

	var3 = var3 + 1

	CriWareMgr.Inst:PlayBGM(var0, CriWareMgr.CRI_FADE_TYPE.FADE_INOUT, function(arg0)
		if arg0 == nil then
			warning("Missing BGM :" .. (var0 or "NIL"))
		else
			print("加载完毕,开始播放音乐")

			if arg0.countingfive_flag then
				return
			end

			arg0.criInfo = arg0
			arg0.song_Tlength = arg0:GetLength()

			arg0:PlaybackStop()

			if IsUnityEditor and var1 then
				arg0.criInfo:SetStartTimeAndPlay(arg0.criInfo:GetLength() * var2)
			else
				arg0:SetStartTimeAndPlay(arg2 and arg2 >= 0 and arg2 or 0)
			end

			var3 = var3 - 1

			if arg1 then
				arg1()
			end
		end
	end)
end

function var0.getStampTime(arg0)
	if arg0.aheadtime_count then
		return (arg0.aheadtime_count - 2) * 1000
	elseif arg0.criInfo then
		return arg0.criInfo:GetTime()
	end

	return nil
end

function var0.pauseBgm(arg0)
	if arg0.criInfo then
		arg0.pauseTime = arg0.criInfo:GetTime()

		arg0.criInfo:PlaybackStop()
	end

	if arg0.timer and arg0.timer.running then
		arg0.timer:Stop()
	end
end

function var0.resumeBgm(arg0)
	if not arg0.timer.running then
		arg0.timer:Start()
	end

	arg0:loadAndPlayMusic(function()
		return
	end, arg0.pauseTime)
end

function var0.rec_scorce(arg0)
	arg0.score_number = 0
	arg0.combo_link = 0
	arg0.combo_number = 0
	arg0.perfect_number = 0
	arg0.good_number = 0
	arg0.miss_number = 0
	arg0.gotspecialcombo_flag = false

	setActive(arg0.top:Find("scoreContent/B/bl"), false)
	setActive(arg0.top:Find("scoreContent/A/al"), false)
	setActive(arg0.top:Find("scoreContent/S/sl"), false)
	setText(arg0.gameScoreTf, 0)
	setText(arg0.game_content:Find("combo_n/" .. arg0.musicData.content_type), 0)
end

function var0.effect_play(arg0, arg1, arg2)
	if arg1 == "nothing" then
		setActive(arg0.yinyuePefectLoop, false)
		setActive(arg0.top:Find("scoreContent/S/liubianxing"), false)
		setActive(arg0.yinyueGood, false)
		setActive(arg0.yinyuePerfect, false)
		setActive(arg0.game_content:Find("MusicStar"), false)
		SetActive(arg0.yinyueComboeffect, false)
	elseif arg1 == "prepare" then
		-- block empty
	elseif arg1 == "good" then
		setActive(arg0.yinyueGood, false)
		setActive(arg0.yinyueGood, true)
	elseif arg1 == "perfect" then
		setActive(arg0.yinyuePerfect, false)
		setActive(arg0.yinyuePerfect, true)
	elseif arg1 == "perfect_loop02" then
		if arg2 then
			if not isActive(arg0.yinyuePefectLoop) then
				setActive(arg0.yinyuePefectLoop, true)
			end
		else
			setActive(arg0.yinyuePefectLoop, false)
		end
	elseif arg1 == "S" then
		if arg2 then
			setActive(findTF(arg0.scoreSliderTf, "img/mask/yinyue20_S"), true)
		else
			setActive(findTF(arg0.scoreSliderTf, "img/mask/yinyue20_S"), false)
		end
	end
end

function var0.scoresliderAcombo_update(arg0)
	local var0 = arg0.score_number
	local var1 = 0

	setText(arg0.gameScoreTf, arg0.score_number)

	local var2 = arg0.game_music
	local var3 = arg0.game_dgree

	if var0 < arg0.score_blist[var3] then
		var1 = var0 / arg0.score_blist[var3] * 0.53
	elseif var0 >= arg0.score_blist[var3] and var0 < arg0.score_alist[var3] then
		var1 = 0.53 + (var0 - arg0.score_blist[var3]) / (arg0.score_alist[var3] - arg0.score_blist[var3]) * 0.19
	elseif var0 >= arg0.score_alist[var3] and var0 < arg0.score_slist[var3] then
		var1 = 0.72 + (var0 - arg0.score_alist[var3]) / (arg0.score_slist[var3] - arg0.score_alist[var3]) * 0.155
	else
		var1 = 0.885 + (var0 - arg0.score_slist[var3]) / (arg0.score_sslist[var3] - arg0.score_slist[var3]) * 0.115
	end

	setSlider(arg0.scoreSliderTf, 0, 1, var1)

	if var1 < 0.53 then
		setActive(arg0.top:Find("scoreContent/B/bl"), false)
		setActive(arg0.top:Find("scoreContent/A/al"), false)
		setActive(arg0.top:Find("scoreContent/S/sl"), false)
	elseif var1 >= 0.53 then
		setActive(arg0.top:Find("scoreContent/B/bl"), true)

		if var1 >= 0.72 then
			setActive(arg0.top:Find("scoreContent/A/al"), true)

			if var1 >= 0.885 then
				if not arg0.nowS_flag then
					arg0.nowS_flag = true

					arg0:effect_play("S", true)
				end

				setActive(arg0.top:Find("scoreContent/S/sl"), true)
			end
		end
	end

	setText(arg0.game_content:Find("combo_n/" .. arg0.musicData.content_type), arg0.combo_link)
end

function var0.score_update(arg0, arg1)
	local var0 = arg0.game_content:Find("evaluate")

	for iter0 = 1, 3 do
		setActive(var0:GetChild(iter0 - 1), false)
	end

	setActive(var0:GetChild(arg1), true)

	if arg1 == 0 then
		arg0.combo_link = 0
		arg0.score_number = arg0.score_number + arg0.score_miss
		arg0.miss_number = arg0.miss_number + 1

		setActive(arg0.game_content:Find("combo"), false)
		setActive(arg0.game_content:Find("combo_n"), false)
	else
		arg0.combo_link = arg0.combo_link + 1
		arg0.combo_number = arg0.combo_number > arg0.combo_link and arg0.combo_number or arg0.combo_link

		if arg0.combo_link > 1 then
			setActive(arg0.game_content:Find("combo"), true)
			setActive(arg0.game_content:Find("combo_n"), true)
			arg0.game_content:Find("combo"):GetComponent(typeof(Animation)):Play()
			arg0.game_content:Find("combo_n"):GetComponent(typeof(Animation)):Play()
		else
			setActive(arg0.game_content:Find("combo"), false)
			setActive(arg0.game_content:Find("combo_n"), false)
		end

		pg.CriMgr.GetInstance():PlaySE_V3("ui-maoudamashii")
	end

	local var1 = 0

	for iter1 = 1, #arg0.combo_interval do
		if arg0.combo_link > arg0.combo_interval[iter1] then
			var1 = var1 + 1
		else
			break
		end
	end

	if arg1 == 1 then
		arg0.score_number = arg0.score_number + arg0.score_good + var1 * arg0.score_combo
		arg0.good_number = arg0.good_number + 1

		arg0:effect_play("good")
	elseif arg1 == 2 then
		arg0.score_number = arg0.score_number + arg0.score_perfect + var1 * arg0.score_combo
		arg0.perfect_number = arg0.perfect_number + 1

		arg0:effect_play("perfect")
	end

	if arg0.gameNoteLeft:loopTime() or arg0.gameNoteRight:loopTime() then
		arg0:effect_play("perfect_loop02", true)
	else
		arg0:effect_play("perfect_loop02", false)
	end

	local var2 = arg0.yinyueComboeffect

	if arg0.game_dgree == 2 and arg0.combo_link > 50 or arg0.game_dgree == 1 and arg0.combo_link > 20 then
		if not isActive(var2) then
			SetActive(var2, true)
			setActive(arg0.game_content:Find("MusicStar"), true)
		end
	else
		SetActive(var2, false)
		setActive(arg0.game_content:Find("MusicStar"), false)
	end
end

function var0.count_five(arg0, arg1)
	if arg0.countingfive_flag then
		return
	end

	arg0.countingfive_flag = true

	setActive(arg0.countTf, true)
	setActive(arg0.countContent, true)
	arg0:setActionSDmodel("stand2")

	local var0 = var5
	local var1 = findTF(arg0.countTf, "img")
	local var2 = findTF(arg0.countTf, "bg")

	local function var3(arg0)
		for iter0 = 1, var1.childCount do
			local var0 = var1:GetChild(iter0 - 1)
			local var1 = iter0 == arg0

			setActive(var0, var1)
		end
	end

	setActive(var2, false)
	var3(0)

	local var4 = findTF(arg0.countTf, "ready")
	local var5 = findTF(arg0.countTf, "effectContent")

	setActive(var5, false)
	setActive(var4, false)

	arg0.count_timer = Timer.New(function()
		if arg0.criInfo and arg0.criInfo:GetTime() > 0 then
			arg0:pauseBgm()
		end

		var3(var0)

		var0 = var0 - 1

		if var0 < 0 then
			arg0.count_timer:Stop()
			setActive(var2, false)
			var3(0)
			setActive(var4, true)
			setActive(var5, true)
			LeanTween.value(go(arg0.countContent), 0, 2, 2):setOnUpdate(System.Action_float(function(arg0)
				local var0

				if arg0 <= 0.25 then
					local var1 = arg0 * 4

					var4.localScale = Vector3(var1, var1, var1)

					setImageAlpha(var4, var1)
					setLocalScale(var5, Vector3(var1, var1, var1))
				elseif arg0 >= 1.8 then
					local var2 = (2 - arg0) * 4

					var4.localScale = Vector3(var2, var2, var2)

					setLocalScale(var5, Vector3(var2, var2, var2))
					setImageAlpha(var4, var2)
				end
			end)):setEase(LeanTweenType.linear):setOnComplete(System.Action(function()
				var4.localScale = Vector3(1, 1, 1, 1)

				setLocalScale(var5, Vector3(1, 1, 1, 1))
				setImageAlpha(var4, 1)
				setActive(var4, false)

				arg0.countingfive_flag = false

				setActive(arg0.countContent, false)
				setActive(arg0.countTf, false)
				arg0:setActionSDmodel("idol")
				arg1()
			end))
		else
			setActive(var2, true)
		end
	end, 1, -1)

	arg0.count_timer:Start()
end

function var0.showSelevtView(arg0)
	if arg0.isFirstgame == 0 then
		arg0:Firstshow(arg0.firstview, function()
			return
		end, 1)
	end

	local var0 = arg0.selectview:Find("Main")
	local var1 = var0:Find("Start_btn")
	local var2 = var0:Find("DgreeList")
	local var3 = var0:Find("MusicList")
	local var4 = var0:Find("namelist")
	local var5 = arg0.selectview:Find("top")
	local var6 = var5:Find("Speedlist")
	local var7 = var5:Find("help_btn")
	local var8 = var5:Find("back")
	local var9 = arg0.selectview:GetComponent("Animator")

	arg0.selectview:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0)
		setActive(arg0.selectview, false)
	end)
	onButton(arg0, var7, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_music_game.tip
		})
	end, SFX_PANEL)
	onButton(arg0, var8, function()
		if var3 == 0 then
			arg0:emit(var0.ON_BACK)
		end
	end, SFX_PANEL)
	onButton(arg0, var1, function()
		if var3 == 0 then
			var9:Play("selectExitAnim")
			arg0:clearSDModel()
			arg0:updateMusic(arg0.selectIndex)
			arg0:game_start()

			GetOrAddComponent(arg0.selectview, "CanvasGroup").blocksRaycasts = false
		else
			arg0.startBtnReady = true
		end
	end, SFX_UI_CONFIRM)
	onButton(arg0, var2:Find("easy"), function()
		arg0.game_dgree = 1

		setActive(var2:Find("hard/frame"), false)
		setActive(var2:Find("easy/frame"), true)
		arg0:updatSelectview()
	end, SFX_UI_CLICK)
	onButton(arg0, var2:Find("hard"), function()
		arg0.game_dgree = 2

		setActive(var2:Find("easy/frame"), false)
		setActive(var2:Find("hard/frame"), true)
		arg0:updatSelectview()
	end, SFX_UI_CLICK)
	onButton(arg0, var6, function()
		setActive(var6:Find("x" .. arg0.game_speed), false)

		arg0.game_speed = arg0.game_speed + 1 > 4 and 1 or arg0.game_speed + 1

		PlayerPrefs.SetInt("musicgame_idol_speed", arg0.game_speed)
		setActive(var6:Find("x" .. arg0.game_speed), true)
	end, SFX_UI_CLICK)

	arg0.song_btn = var3:Find("song")

	setActive(arg0.song_btn, false)

	arg0.song_btns = {}

	local var10 = arg0.gameMusicIndex

	for iter0 = 1, arg0.music_amount do
		arg0.song_btns[iter0] = cloneTplTo(arg0.song_btn, var3, "music" .. iter0)

		local var11 = arg0.musicDatas[iter0]

		setActive(arg0.song_btns[iter0], true)

		local var12 = arg0.song_btn.localPosition
		local var13 = math.abs(iter0 - var10)
		local var14 = iter0 - var10 < arg0.music_amount_middle and var13 or iter0 - arg0.music_amount_middle * 2

		arg0.song_btns[iter0].localPosition = Vector3(var12.x + var14 * 1022, var12.y, var12.z)

		local var15 = arg0.song_btn.localScale

		arg0.song_btns[iter0].localScale = Vector3(var15.x - math.abs(var14) * 0.2, var15.y - math.abs(var14) * 0.2, var15.z - math.abs(var14) * 0.2)

		local var16 = arg0.song_btns[iter0]:Find("song"):GetComponent(typeof(Image))

		var16.sprite = var3:Find("img/" .. var11.picture):GetComponent(typeof(Image)).sprite
		arg0.song_btns[iter0]:Find("zhuanji3/zhuanji2_5"):GetComponent(typeof(Image)).sprite = var3:Find("img/" .. var11.picture .. "_1"):GetComponent(typeof(Image)).sprite
		var16.color = Color.New(1, 1, 1, 1 - math.abs(var14) * 0.6)

		onButton(arg0, arg0.song_btns[iter0], function()
			arg0:clickSongBtns(var4, iter0)
		end, SFX_UI_CLICK)

		if iter0 == var10 then
			arg0.song_btns[iter0]:GetComponent(typeof(Animator)):Play("plate_out")

			arg0.song_btns[iter0]:GetComponent(typeof(Button)).interactable = false
		end
	end

	arg0:clickSongBtns(var4, 1)
end

function var0.updateMusic(arg0, arg1)
	arg0.musicData = arg0.musicDatas[arg1]
	arg0.selectIndex = arg1
	arg0.game_music = arg0.musicData.id

	if arg0.musicData.ships and #arg0.musicData.ships > 0 then
		arg0.musicShips = arg0.musicData.ships
		arg0.settlementPainting = arg0.musicData.settlement_painting
		arg0.musicLight = arg0.musicData.light
		arg0.shadowLight = arg0.musicData.shadow == 1
		arg0.musicBg = arg0.musicData.bg
	else
		local var0 = MusicGameConst.getRandomBand()

		arg0.musicShips = var0.ships
		arg0.settlementPainting = var0.settlement_painting
		arg0.musicLight = var0.light
		arg0.shadowLight = true
		arg0.musicBg = var0.bg
	end

	arg0.noteType = arg0.musicData.note_type
	arg0.gameMusicIndex = var4
	arg0.SDname = arg0.musicShips
	arg0.score_blist = arg0.musicData.score_rank[1]
	arg0.score_alist = arg0.musicData.score_rank[2]
	arg0.score_slist = arg0.musicData.score_rank[3]
	arg0.score_sslist = arg0.musicData.score_rank[4]

	arg0:setTfChildVisible(arg0.top:Find("scoreContent/B/bl"), false)
	arg0:setTfChildVisible(arg0.top:Find("scoreContent/B/b"), false)
	arg0:setTfChildVisible(arg0.top:Find("scoreContent/A/al"), false)
	arg0:setTfChildVisible(arg0.top:Find("scoreContent/A/a"), false)
	arg0:setTfChildVisible(arg0.top:Find("scoreContent/S/sl"), false)
	arg0:setTfChildVisible(arg0.top:Find("scoreContent/S/s"), false)
	setActive(arg0.top:Find("scoreContent/B/b/" .. arg0.musicData.content_type), true)
	setActive(arg0.top:Find("scoreContent/B/bl/" .. arg0.musicData.content_type), true)
	setActive(arg0.top:Find("scoreContent/A/a/" .. arg0.musicData.content_type), true)
	setActive(arg0.top:Find("scoreContent/A/al/" .. arg0.musicData.content_type), true)
	setActive(arg0.top:Find("scoreContent/S/s/" .. arg0.musicData.content_type), true)
	setActive(arg0.top:Find("scoreContent/S/sl/" .. arg0.musicData.content_type), true)
	arg0:setTfChildVisible(arg0.game_content:Find("combo_n"), false)
	arg0:setTfChildVisible(arg0.game_content:Find("combo"), false)
	setActive(arg0.game_content:Find("combo_n/" .. arg0.musicData.content_type), true)
	setActive(arg0.game_content:Find("combo/" .. arg0.musicData.content_type), true)
	arg0:setTfChildVisible(arg0.btn_pause, false)
	setActive(findTF(arg0.btn_pause, arg0.musicData.content_type), true)
	arg0:setTfChildVisible(arg0.countContent, false)
	arg0:setTfChildVisible(arg0.top:Find("score"), false)
	setActive(arg0.top:Find("score/" .. tostring(arg0.musicData.content_type)), true)

	arg0.gameScoreTf = arg0.top:Find("score/" .. tostring(arg0.musicData.content_type) .. "/text")
	arg0.countTf = findTF(arg0.countContent, arg0.musicData.content_type)

	arg0:updateEffectTf()
end

function var0.setTfChildVisible(arg0, arg1, arg2)
	for iter0 = 1, arg1.childCount do
		local var0 = arg1:GetChild(iter0 - 1)

		setActive(var0, false)
	end
end

function var0.updateEffectTf(arg0)
	local var0 = findTF(arg0.game_content, "effect")

	for iter0 = 1, var0.childCount do
		local var1 = var0:GetChild(iter0 - 1)

		setActive(var1, false)
	end

	local var2 = arg0.musicData.content_type

	setActive(findTF(arg0.game_content, "effect/" .. var2))

	arg0.fullComboEffect = arg0.game_content:Find("effect/" .. var2 .. "/yinyue_Fullcombo")
	arg0.liveClearEffect = arg0.game_content:Find("effect/" .. var2 .. "/yinyue_LiveClear")
	arg0.yinyueGood = arg0.game_content:Find("effect/" .. var2 .. "/yinyue_good")
	arg0.yinyueComboeffect = arg0.game_content:Find("effect/" .. var2 .. "/yinyue_comboeffect")
	arg0.yinyuePerfect = arg0.game_content:Find("effect/" .. var2 .. "/yinyue_perfect")
	arg0.yinyuePefectLoop = arg0.game_content:Find("effect/" .. var2 .. "/yinyue_perfect_loop02")
end

function var0.getBeatGameMusicData(arg0, arg1)
	for iter0 = 1, #arg0.musicDatas do
		if arg0.musicDatas[iter0].id == arg1 then
			return arg0.musicDatas[iter0]
		end
	end

	return nil
end

function var0.clickSongBtns(arg0, arg1, arg2)
	if var3 > 0 then
		return
	end

	setActive(arg1:Find("song" .. arg0.musicData.picture), false)
	arg0:MyGetRuntimeData()
	arg0:clearSDModel()
	arg0:updateMusic(arg2)
	arg0:loadAndPlayMusic()
	arg0:updatSelectview()
	arg0:changeLocalpos(arg2)
	setActive(arg1:Find("song" .. arg0.musicData.picture), true)
end

function var0.changeLocalpos(arg0, arg1)
	local var0 = arg0.music_amount_middle
	local var1 = var0 - arg1
	local var2 = 0.5
	local var3 = {}

	for iter0 = 1, arg0.music_amount do
		var3[iter0] = arg0.song_btns[iter0].localPosition
	end

	local var4 = {}

	for iter1 = 1, arg0.music_amount do
		var4[iter1] = arg0.song_btns[iter1].localScale
	end

	arg0.changeLocalpos_timer = Timer.New(function()
		var2 = var2 - arg0.time_interval
		arg0.changeLocalposTimerflag = true

		for iter0 = 1, arg0.music_amount do
			local var0 = iter0 + var1

			if iter0 + var1 > arg0.music_amount then
				var0 = iter0 + var1 - arg0.music_amount
			end

			if iter0 + var1 < 1 then
				var0 = iter0 + var1 + arg0.music_amount
			end

			if var2 <= 0 then
				if var0 == var0 then
					arg0.song_btns[iter0]:GetComponent(typeof(Animator)):Play("plate_out")
				else
					arg0.song_btns[iter0]:GetComponent(typeof(Animator)):Play("plate_static")

					arg0.song_btns[iter0]:GetComponent(typeof(Button)).interactable = true
				end
			else
				arg0.song_btns[iter0]:GetComponent(typeof(Animator)):Play("plate_static")

				arg0.song_btns[iter0]:GetComponent(typeof(Button)).interactable = false
			end

			local var1 = arg0.song_btn.localPosition
			local var2 = math.abs(var0 - var0)
			local var3 = (var1.x + (var0 - var0 > 0 and 1 or -1) * var2 * 1022) * (1 - var2 * 2) + var3[iter0].x * var2 * 2

			arg0.song_btns[iter0].localPosition = Vector3(var3, var1.y, var1.z)

			local var4 = arg0.song_btns[iter0].localScale
			local var5 = (1 - var2 * 0.2) * (1 - var2 * 2) + var4[iter0].x * var2 * 2

			arg0.song_btns[iter0].localScale = Vector3(var5, var5, var5)

			local var6 = arg0.song_btns[iter0]:Find("song"):GetComponent(typeof(Image))
			local var7 = (1 - var2 * 0.6) * (1 - var2 * 2) + var6.color.a * var2 * 2

			var6.color = Color.New(1, 1, 1, 1 - var2 * 0.6)
		end

		if var2 <= 0 then
			arg0.changeLocalposTimerflag = false

			arg0.changeLocalpos_timer:Stop()
		end
	end, arg0.time_interval, -1)

	arg0.changeLocalpos_timer:Start()
end

function var0.addRingDragListenter(arg0)
	local var0 = GetOrAddComponent(arg0.selectview, "EventTriggerListener")
	local var1
	local var2 = 0
	local var3

	var0:AddBeginDragFunc(function()
		var2 = 0
		var1 = nil
	end)
	var0:AddDragFunc(function(arg0, arg1)
		if not arg0.inPaintingView then
			local var0 = arg1.position

			if not var1 then
				var1 = var0
			end

			var2 = var0.x - var1.x
		end
	end)
	var0:AddDragEndFunc(function(arg0, arg1)
		if not arg0.inPaintingView and not arg0.changeLocalposTimerflag then
			local var0, var1 = arg0:getNextPreSelectId()

			if var2 < -50 then
				triggerButton(arg0.song_btns[var0])
			elseif var2 > 50 then
				triggerButton(arg0.song_btns[var1])
			end
		end
	end)
end

function var0.getNextPreSelectId(arg0)
	local var0
	local var1
	local var2 = arg0.game_music + 1
	local var3 = arg0.game_music - 1

	if var3 <= 0 then
		var3 = #arg0.musicDatas
	end

	if var2 > #arg0.musicDatas then
		var2 = 1
	end

	for iter0, iter1 in ipairs(arg0.musicDatas) do
		if arg0.musicDatas[iter0].id == var2 then
			var0 = iter0
		end

		if arg0.musicDatas[iter0].id == var3 then
			var1 = iter0
		end
	end

	return var0, var1
end

function var0.Firstshow(arg0, arg1, arg2, arg3)
	arg0.count = 0

	setActive(arg1, true)
	LoadSpriteAtlasAsync("ui/musicgameother_atlas", "help1", function(arg0)
		GetComponent(findTF(arg0.firstview, "num/img1"), typeof(Image)).sprite = arg0
	end)
	LoadSpriteAtlasAsync("ui/musicgameother_atlas", "help2", function(arg0)
		GetComponent(findTF(arg0.firstview, "num/img2"), typeof(Image)).sprite = arg0
	end)

	for iter0 = 1, 2 do
		local var0 = findTF(arg1, "num/img" .. iter0)

		setActive(var0, iter0 == arg3 and true or false)
	end

	if arg0.firstview_timer then
		if arg0.firstview_timer.running then
			arg0.firstview_timer:Stop()
		end

		arg0.firstview_timer = nil
	end

	arg0.firstview_timerRunflag = true
	arg0.firstview_timer = Timer.New(function()
		arg0.count = arg0.count + 1

		if arg0.count > 3 then
			onButton(arg0, arg0.firstview, function()
				if arg2 then
					arg2()
				end

				arg0.firstview_timer:Stop()
				setActive(arg1, false)

				arg0.firstview_timerRunflag = false

				removeOnButton(arg0.firstview)
			end)
		end
	end, 1, -1)

	arg0.firstview_timer:Start()
end

function var0.updatSelectview(arg0)
	if not arg0.song_btns or #arg0.song_btns <= 0 or not arg0.selectview then
		return
	end

	setActive(arg0.selectview:Find("top/Speedlist/x" .. arg0.game_speed), true)

	for iter0 = 1, arg0.music_amount do
		local var0 = arg0.musicDatas[iter0].id

		setActive(arg0.song_btns[var0]:Find("song/best"), false)
		arg0:setSelectview_pj("e", var0)
	end

	local var1 = arg0.game_dgree
	local var2 = arg0.game_music
	local var3 = arg0.bestScorelist[var2 + (var1 - 1) * arg0.music_amount]

	if arg0.song_btns[var2] and var3 > 0 then
		setActive(arg0.song_btns[var2]:Find("song/best"), true)

		local var4 = arg0.song_btns[var2]:Find("song/best/score")

		setText(var4, var3)
		arg0:setSelectview_pj("e", var2)

		if var3 < arg0.score_blist[var1] then
			arg0:setSelectview_pj("c", var2)
		elseif var3 >= arg0.score_blist[var1] and var3 < arg0.score_alist[var1] then
			arg0:setSelectview_pj("b", var2)
		elseif var3 >= arg0.score_alist[var1] and var3 < arg0.score_slist[var1] then
			arg0:setSelectview_pj("a", var2)
		else
			arg0:setSelectview_pj("s", var2)
		end
	end
end

function var0.setSelectview_pj(arg0, arg1, arg2)
	if arg1 == "e" then
		setActive(arg0.song_btns[arg2]:Find("song/c"), false)
		setActive(arg0.song_btns[arg2]:Find("song/b"), false)
		setActive(arg0.song_btns[arg2]:Find("song/a"), false)
		setActive(arg0.song_btns[arg2]:Find("song/s"), false)
	elseif arg1 == "c" then
		setActive(arg0.song_btns[arg2]:Find("song/c"), true)
	elseif arg1 == "b" then
		setActive(arg0.song_btns[arg2]:Find("song/b"), true)
	elseif arg1 == "a" then
		setActive(arg0.song_btns[arg2]:Find("song/a"), true)
	elseif arg1 == "s" then
		setActive(arg0.song_btns[arg2]:Find("song/s"), true)
	end
end

function var0.updateScoreUIContent(arg0)
	local var0 = findTF(arg0.scoreview, "ui")

	for iter0 = 1, var0.childCount do
		local var1 = var0:GetChild(iter0 - 1)

		setActive(var1, false)
	end

	if arg0.musicData.settlement_type and arg0.musicData.settlement_type ~= "" then
		arg0.scoreUIContent = findTF(arg0.scoreview, "ui/" .. arg0.musicData.settlement_type)
	else
		arg0.scoreUIContent = findTF(arg0.scoreview, "ui/normal")
	end

	setActive(arg0.scoreUIContent, true)
end

function var0.locadScoreView(arg0)
	arg0:updateScoreUIContent()
	arg0:effect_play("nothing")

	arg0.game_playingflag = false

	setActive(arg0.scoreview, true)

	arg0.scoreview_flag = true

	local var0 = findTF(arg0.scoreview, "bg")

	setImageColor(var0, Color(0, 0, 0))
	LoadSpriteAtlasAsync("ui/musicgameother_atlas", "scoreBg" .. arg0.musicBg, function(arg0)
		if var0 then
			GetComponent(var0, typeof(Image)).sprite = arg0

			setImageColor(var0, Color(1, 1, 1))
			setActive(var0, true)
		end
	end)
	setActive(arg0.game_content:Find("combo"), false)
	setActive(arg0.game_content:Find("MusicStar"), false)
	setActive(arg0.game_content:Find("combo_n"), false)
	setActive(arg0.game_content, false)
	setActive(arg0.top, false)
	setActive(arg0._tf:Find("Spinelist"), false)

	local var1 = arg0.scoreview:Find("maskBg").childCount

	for iter0 = 1, var1 do
		setActive(arg0.scoreview:Find("maskBg/bg" .. iter0), iter0 == arg0.musicBg)
	end

	local var2 = arg0.scoreview:Find("maskBgBottom").childCount

	for iter1 = 1, var2 do
		local var3 = iter1 == arg0.musicBg

		setActive(arg0.scoreview:Find("maskBgBottom/bg" .. iter1), var3)
	end

	local var4 = arg0.game_dgree
	local var5 = arg0.game_music

	if arg0.painting then
		retPaintingPrefab(arg0.scoreview:Find("paint"), arg0.painting)
	end

	local var6 = {}

	for iter2 = 1, #arg0.settlementPainting do
		if arg0.settlementPainting[iter2] and arg0.settlementPainting[iter2] ~= "" and arg0.settlementPainting[iter2] ~= "none" then
			table.insert(var6, arg0.settlementPainting[iter2])
		end
	end

	arg0.painting = var6[math.random(1, #var6)]

	local var7 = MusicGameConst.painting_const_key[string.lower(arg0.painting)]

	if var7 then
		local var8 = {}

		PaintingConst.AddPaintingNameWithFilteMap(var8, var7)
		PaintingConst.PaintingDownload({
			isShowBox = false,
			paintingNameList = var8,
			finishFunc = function()
				setPaintingPrefabAsync(arg0.scoreview:Find("paint"), arg0.painting, "mainNormal")
			end
		})
	else
		setPaintingPrefabAsync(arg0.scoreview:Find("paint"), arg0.painting, "mainNormal")
	end

	setActive(arg0.scoreUIContent:Find("scoreImg/square/easy"), var4 == 1)
	setActive(arg0.scoreUIContent:Find("scoreImg/square/hard"), var4 == 2)
	setActive(arg0.scoreUIContent:Find("scoreList/fullCombo"), arg0.miss_number == 0)
	setActive(arg0.scoreUIContent:Find("scoreImg/perfect/noMiss"), arg0.miss_number == 0 and arg0.good_number == 0)

	local function var9(arg0, arg1, arg2)
		LeanTween.value(go(arg0.scoreview), 0, arg1, 0.6):setOnUpdate(System.Action_float(function(arg0)
			setText(arg0, math.round(arg0))
		end)):setOnComplete(System.Action(function()
			arg2()
		end))
	end

	seriesAsync({
		function(arg0)
			var9(arg0.scoreUIContent:Find("scoreList/perfect"), arg0.perfect_number, arg0)
		end,
		function(arg0)
			var9(arg0.scoreUIContent:Find("scoreList/good"), arg0.good_number, arg0)
		end,
		function(arg0)
			var9(arg0.scoreUIContent:Find("scoreList/miss"), arg0.miss_number, arg0)
		end,
		function(arg0)
			var9(arg0.scoreUIContent:Find("scoreList/combo"), arg0.combo_number, arg0)
		end,
		function(arg0)
			local var0 = arg0.bestScorelist[var5 + (var4 - 1) * arg0.music_amount]

			if not var0 or var0 == 0 then
				var0 = arg0.score_number
			end

			if arg0.score_number > arg0.bestScorelist[var5 + (var4 - 1) * arg0.music_amount] then
				setActive(arg0.scoreUIContent:Find("scoreImg/square/newScore"), true)

				arg0.bestScorelist[var5 + (var4 - 1) * arg0.music_amount] = arg0.score_number
			else
				setActive(arg0.scoreUIContent:Find("scoreImg/square/newScore"), false)
			end

			var9(arg0.scoreUIContent:Find("scoreImg/square/bestscore"), var0, arg0)
			var9(arg0.scoreUIContent:Find("scoreImg/square/score"), arg0.score_number, function()
				return
			end)
			arg0:MyStoreDataToServer()
			arg0:MyGetRuntimeData()
		end,
		function(arg0)
			local var0

			if arg0.score_number < arg0.score_blist[var4] then
				function var0()
					arg0:setScoceview_pj("c")
				end
			elseif arg0.score_number >= arg0.score_blist[var4] and arg0.score_number < arg0.score_alist[var4] then
				function var0()
					arg0:setScoceview_pj("b")
					arg0:emit(BaseMiniGameMediator.MINI_GAME_SUCCESS, 0)
				end
			elseif arg0.score_number >= arg0.score_alist[var4] and arg0.score_number < arg0.score_slist[var4] then
				function var0()
					arg0:setScoceview_pj("a")
					arg0:emit(BaseMiniGameMediator.MINI_GAME_SUCCESS, 0)
				end
			else
				function var0()
					arg0:setScoceview_pj("s")
					arg0:emit(BaseMiniGameMediator.MINI_GAME_SUCCESS, 0)
				end
			end

			local var1 = arg0:GetMGHubData()
			local var2 = pg.NewStoryMgr.GetInstance()
			local var3 = arg0:GetMGData():getConfig("simple_config_data").story
			local var4 = var3[var1.usedtime + 1] and var3[var1.usedtime + 1][1] or nil

			if var1.count > 0 and var4 and not var2:IsPlayed(var4) and arg0.score_number >= arg0.score_blist[var4] then
				var2:Play(var4, var0)
			else
				var0()
			end

			arg0()
		end
	}, function()
		return
	end)

	local var10 = arg0.scoreUIContent:Find("scoreImg/square/nameText")

	setText(var10, arg0.musicData.music_name)

	local var11 = arg0.scoreUIContent:Find("scoreImg/square/name"):GetComponent(typeof(Image))

	var11.sprite = arg0.selectview:Find("Main/namelist/song" .. arg0.musicData.picture):GetComponent(typeof(Image)).sprite

	var11:SetNativeSize()

	arg0.scoreUIContent:Find("scoreImg/square/song"):GetComponent(typeof(Image)).sprite = arg0.selectview:Find("Main/MusicList/img/" .. arg0.musicData.picture):GetComponent(typeof(Image)).sprite

	GetComponent(arg0.scoreUIContent:Find("btnList/share"), typeof(Image)):SetNativeSize()
	onButton(arg0, arg0.scoreUIContent:Find("btnList/share"), function()
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeSummary)
	end, SFX_PANEL)
	GetComponent(arg0.scoreUIContent:Find("btnList/restart"), typeof(Image)):SetNativeSize()
	onButton(arg0, arg0.scoreUIContent:Find("btnList/restart"), function()
		setActive(arg0.scoreview, false)

		arg0.scoreview_flag = false

		arg0:stopTimer()
		arg0:rec_scorce()
		arg0:game_start()
		arg0:setScoceview_pj("e")

		if arg0.painting then
			retPaintingPrefab(arg0.scoreview:Find("paint"), arg0.painting)

			arg0.painting = nil
		end
	end, SFX_UI_CLICK)
	GetComponent(arg0.scoreUIContent:Find("btnList/reselect"), typeof(Image)):SetNativeSize()
	onButton(arg0, arg0.scoreUIContent:Find("btnList/reselect"), function()
		arg0:dynamicBgHandler(arg0.bgGo)
		setActive(arg0.scoreview, false)

		arg0.scoreview_flag = false

		arg0:stopTimer()
		setActive(arg0.selectview, true)

		GetOrAddComponent(arg0.selectview, "CanvasGroup").blocksRaycasts = true

		arg0:updatSelectview()
		arg0.song_btns[arg0.game_music]:GetComponent(typeof(Animator)):Play("plate_out")
		arg0:loadAndPlayMusic()
		arg0:rec_scorce()
		arg0:setScoceview_pj("e")

		if arg0.painting then
			retPaintingPrefab(arg0.scoreview:Find("paint"), arg0.painting)

			arg0.painting = nil
		end
	end, SFX_UI_CLICK)
end

function var0.setScoceview_pj(arg0, arg1)
	setActive(arg0.scoreUIContent:Find("scoreImg/square/c"), false)
	setActive(arg0.scoreUIContent:Find("scoreImg/square/b"), false)
	setActive(arg0.scoreUIContent:Find("scoreImg/square/a"), false)
	setActive(arg0.scoreUIContent:Find("scoreImg/square/s"), false)

	if arg1 == "e" then
		-- block empty
	elseif arg1 == "c" then
		setActive(arg0.scoreUIContent:Find("scoreImg/square/c"), true)
	elseif arg1 == "b" then
		setActive(arg0.scoreUIContent:Find("scoreImg/square/b"), true)
	elseif arg1 == "a" then
		setActive(arg0.scoreUIContent:Find("scoreImg/square/a"), true)
	elseif arg1 == "s" then
		setActive(arg0.scoreUIContent:Find("scoreImg/square/s"), true)
	end
end

function var0.Scoceview_ani(arg0)
	local var0 = 0

	setActive(arg0.scoreUIContent:Find("btnList/reselect"), false)
	setActive(arg0.scoreUIContent:Find("btnList/restart"), false)
	setActive(arg0.scoreUIContent:Find("btnList/share"), false)

	local function var1()
		var0 = var0 + arg0.time_interval

		if var0 >= 0.99 then
			setActive(arg0.scoreUIContent:Find("btnList/reselect"), true)
			setActive(arg0.scoreUIContent:Find("btnList/restart"), true)
			setActive(arg0.scoreUIContent:Find("btnList/share"), true)
			setText(arg0.scoreUIContent:Find("scoreList/perfect"), arg0.perfect_number)
			setText(arg0.scoreUIContent:Find("scoreList/good"), arg0.good_number)
			setText(arg0.scoreUIContent:Find("scoreList/miss"), arg0.miss_number)
			setText(arg0.scoreUIContent:Find("scoreList/combo"), arg0.combo_number)
			setText(arg0.scoreUIContent:Find("scoreImg/square/bestscore"), arg0.score_number)
		else
			setText(arg0.scoreUIContent:Find("scoreList/perfect"), math.floor(arg0.perfect_number * var0))
			setText(arg0.scoreUIContent:Find("scoreList/good"), math.floor(arg0.good_number * var0))
			setText(arg0.scoreUIContent:Find("scoreList/miss"), math.floor(arg0.miss_number * var0))
			setText(arg0.scoreUIContent:Find("scoreList/combo"), math.floor(arg0.combo_number * var0))
			setText(arg0.scoreUIContent:Find("scoreImg/square/bestscore"), math.floor(arg0.score_number * var0))
		end

		if var0 >= 1.03 then
			arg0.Scoceview_timer:Stop()
		end
	end

	arg0.Scoceview_timer = Timer.New(var1, arg0.time_interval, -1)

	arg0.Scoceview_timer:Start()
end

function var0.gameStart(arg0)
	if not arg0.timer then
		arg0.timer = Timer.New(function()
			arg0:gameStepNew()
		end, arg0.time_interval, -1)
	end

	arg0.aheadtime_count = 0

	local var0 = 2

	arg0.ahead_timerPauseFlag = false

	local function var1()
		arg0.ahead_timeflag = true

		if not arg0.timer.running then
			arg0:startTimer()
		end

		if not arg0.ahead_timerPauseFlag then
			arg0.aheadtime_count = arg0.aheadtime_count + arg0.time_interval

			if arg0.aheadtime_count > var0 then
				arg0.aheadtime_count = nil
				arg0.ahead_timeflag = false
				arg0.gotspecialcombo_flag = false

				arg0.ahead_timer:Stop()
				arg0:loadAndPlayMusic(function()
					return
				end)
			end
		end
	end

	CriWareMgr.Inst:UnloadCueSheet(arg0:getMusicBgm(arg0.musicData))

	arg0.ahead_timer = Timer.New(var1, arg0.time_interval, -1)

	arg0:count_five(function()
		arg0.ahead_timer:Start()
	end)
end

function var0.getMusicBgm(arg0, arg1)
	local var0 = "bgm-song"

	if arg1.bgm < 10 then
		var0 = var0 .. "0" .. tostring(arg1.bgm)
	else
		var0 = var0 .. tostring(arg1.bgm)
	end

	return var0
end

function var0.getMusicNote(arg0, arg1, arg2)
	return "view/miniGame/gameView/musicGame/bgm_song" .. "0" .. arg1.note .. "_" .. arg2
end

function var0.gameStepNew(arg0)
	local var0 = arg0.game_dgree

	arg0.gameStepTime = arg0:getStampTime()
	arg0.downingright_lastflag = arg0.downingright_flag
	arg0.downingleft_lastflag = arg0.downingleft_flag

	if IsUnityEditor then
		if var0 == 2 then
			arg0.downingright_flag = Input.GetKey(KeyCode.J)
			arg0.downingleft_flag = Input.GetKey(KeyCode.F)
		elseif var0 == 1 then
			if Input.GetKey(KeyCode.J) or Input.GetKey(KeyCode.F) then
				arg0.downingright_flag = true
				arg0.downingleft_flag = true
			else
				arg0.downingright_flag = false
				arg0.downingleft_flag = false
			end
		end
	elseif var0 == 2 then
		arg0.downingright_flag = arg0.mousedowningright_flag
		arg0.downingleft_flag = arg0.mousedowningleft_flag
	elseif var0 == 1 then
		if arg0.mousedowningright_flag or arg0.mousedowningleft_flag then
			arg0.downingright_flag = true
			arg0.downingleft_flag = true
		else
			arg0.downingright_flag = false
			arg0.downingleft_flag = false
		end
	end

	if var0 == 2 then
		if not arg0.downingleft_lastflag and arg0.downingleft_flag then
			arg0.gameNoteLeft:onKeyDown()

			arg0.leftDownStepTime = arg0.gameStepTime

			if arg0.rightDownStepTime and math.abs(arg0.leftDownStepTime - arg0.rightDownStepTime) < 100 then
				arg0.gameNoteLeft:bothDown()
				arg0.gameNoteRight:bothDown()
			end
		elseif arg0.downingleft_lastflag and not arg0.downingleft_flag then
			arg0.leftUpStepTime = arg0.gameStepTime

			arg0.gameNoteLeft:onKeyUp()

			if arg0.rightUpStepTime and math.abs(arg0.leftUpStepTime - arg0.rightUpStepTime) < 100 then
				arg0.gameNoteLeft:bothUp()
				arg0.gameNoteRight:bothUp()
			end
		end

		if not arg0.downingright_lastflag and arg0.downingright_flag then
			arg0.gameNoteRight:onKeyDown()

			arg0.rightDownStepTime = arg0.gameStepTime

			if arg0.leftDownStepTime and math.abs(arg0.leftDownStepTime - arg0.rightDownStepTime) < 200 then
				arg0.gameNoteLeft:bothDown()
				arg0.gameNoteRight:bothDown()
			end
		elseif arg0.downingright_lastflag and not arg0.downingright_flag then
			arg0.rightUpStepTime = arg0.gameStepTime

			arg0.gameNoteRight:onKeyUp()

			if arg0.leftUpStepTime and math.abs(arg0.leftUpStepTime - arg0.rightUpStepTime) < 200 then
				arg0.gameNoteLeft:bothUp()
				arg0.gameNoteRight:bothUp()
			end
		end
	elseif not arg0.downingright_lastflag and arg0.downingright_flag then
		arg0.gameNoteLeft:onKeyDown()
		arg0.gameNoteRight:onKeyDown()
	elseif arg0.downingleft_lastflag and not arg0.downingleft_flag then
		arg0.gameNoteLeft:onKeyUp()
		arg0.gameNoteRight:onKeyUp()
	end

	arg0.musicgame_lasttime = arg0.musicgame_nowtime or 0

	if arg0.criInfo then
		arg0.musicgame_nowtime = arg0:getStampTime() / 1000
	else
		arg0.musicgame_nowtime = 0
	end

	if arg0.song_Tlength and not arg0.scoreview_flag and long2int(arg0.song_Tlength) / 1000 - arg0.musicgame_nowtime <= 0.01666 then
		print("歌曲播放结束")
		arg0:pauseBgm()

		arg0.game_playingflag = false

		local function var1()
			arg0:locadScoreView()
		end

		if arg0.perfect_number > 0 and arg0.good_number == 0 and arg0.miss_number == 0 then
			setActive(arg0.fullComboEffect, true)

			if not arg0.gotspecialcombo_flag then
				arg0.score_number = arg0.score_number + arg0.specialscore_number
				arg0.gotspecialcombo_flag = true
			end

			LeanTween.delayedCall(go(arg0.fullComboEffect), 2, System.Action(function()
				var1()
			end))
		elseif (arg0.good_number > 0 or arg0.perfect_number > 0) and arg0.miss_number <= 0 then
			setActive(arg0.fullComboEffect, true)

			if not arg0.gotspecialcombo_flag then
				arg0.score_number = arg0.score_number + arg0.specialscore_number
				arg0.gotspecialcombo_flag = true
			end

			LeanTween.delayedCall(go(arg0.fullComboEffect), 2, System.Action(function()
				var1()
			end))
		else
			setActive(arg0.liveClearEffect, true)
			LeanTween.delayedCall(go(arg0.liveClearEffect), 2, System.Action(function()
				var1()
			end))
		end

		return
	end

	arg0.gameNoteLeft:step(arg0.gameStepTime)
	arg0.gameNoteRight:step(arg0.gameStepTime)
	arg0:scoresliderAcombo_update()

	if arg0.drumpFlag and not arg0.gameNoteLeft:loopTime() and not arg0.gameNoteRight:loopTime() then
		arg0.drumpFlag = false
		arg0.drupTime = Time.realtimeSinceStartup

		arg0:setActionSDmodel("jump")
		LeanTween.delayedCall(go(arg0.game_content), 1, System.Action(function()
			arg0:setActionSDmodel("idol")
		end))
	end
end

function var0.onStateCallback(arg0, arg1)
	arg0:score_update(arg1)
end

function var0.onLongTimeCallback(arg0, arg1)
	if arg0.drupTime and Time.realtimeSinceStartup - arg0.drupTime < 2 then
		return
	end

	if arg1 > 0.5 then
		arg0.drumpFlag = true
	end
end

return var0
