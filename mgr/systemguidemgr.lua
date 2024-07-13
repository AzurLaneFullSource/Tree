pg = pg or {}
pg.SystemGuideMgr = singletonClass("SystemGuideMgr")

local var0_0 = pg.SystemGuideMgr
local var1_0

function var0_0.Init(arg0_1, arg1_1)
	var1_0 = require("GameCfg.guide.newguide.SSG001")

	arg1_1()
end

local function var2_0(arg0_2)
	if getProxy(PlayerProxy) then
		return pg.NewStoryMgr.GetInstance():IsPlayed(arg0_2)
	end

	return false
end

local function var3_0(arg0_3)
	if arg0_3 then
		arg0_3()
	end
end

local function var4_0(arg0_4, arg1_4, arg2_4)
	if pg.SeriesGuideMgr.GetInstance():isRunning() then
		var3_0(arg2_4)

		return
	end

	if var2_0(arg0_4) then
		var3_0(arg2_4)

		return
	end

	if not pg.NewGuideMgr.GetInstance():CanPlay() then
		var3_0(arg2_4)

		return
	end

	if arg0_4 == "SYG001" then
		pg.TrackerMgr.GetInstance():Tracking(TRACKING_TUTORIAL_COMPLETE_2)
	elseif arg0_4 == "SYG003" then
		pg.TrackerMgr.GetInstance():Tracking(TRACKING_TUTORIAL_COMPLETE_3)
	elseif arg0_4 == "SYG006" then
		pg.TrackerMgr.GetInstance():Tracking(TRACKING_TUTORIAL_COMPLETE_4)
	end

	pg.m02:sendNotification(GAME.STORY_UPDATE, {
		storyId = arg0_4
	})
	pg.NewGuideMgr.GetInstance():Play(arg0_4, arg1_4, arg2_4)
end

function var0_0.Play(arg0_5, arg1_5, arg2_5)
	if IsUnityEditor and not ENABLE_GUIDE then
		if arg2_5 then
			arg2_5()
		end

		return
	end

	if arg1_5.exited then
		return
	end

	local var0_5 = var1_0[arg1_5.__cname]

	if not var0_5 then
		var3_0(arg2_5)

		return
	end

	local var1_5 = _.detect(var0_5, function(arg0_6)
		local var0_6 = arg0_6.id
		local var1_6 = arg0_6.condition

		return not var2_0(var0_6) and var1_6(arg1_5)
	end)

	if not var1_5 then
		var3_0(arg2_5)

		return
	end

	local var2_5 = var1_5.id
	local var3_5 = var1_5.args(arg1_5)

	var4_0(var2_5, var3_5, arg2_5)
end

function var0_0.PlayChapter(arg0_7, arg1_7, arg2_7)
	if arg1_7.id == 1160002 then
		arg0_7:PlayByGuideId("NG0011", nil, arg2_7)
	elseif arg1_7:isTypeDefence() then
		arg0_7:PlayByGuideId("NG0016", nil, arg2_7)
	else
		existCall(arg2_7)
	end
end

function var0_0.PlayByGuideId(arg0_8, arg1_8, arg2_8, arg3_8)
	var4_0(arg1_8, arg2_8, arg3_8)
end

function var0_0.FixGuide(arg0_9, arg1_9)
	if not var2_0("FixGuide") then
		var4_0("FixGuide")
		arg1_9()
	end
end

function var0_0.PlayDailyLevel(arg0_10, arg1_10)
	if not var2_0("NG0015") then
		pg.m02:sendNotification(GAME.STORY_UPDATE, {
			storyId = "NG0015"
		})
		arg1_10()
	end
end

function var0_0.PlayCommander(arg0_11)
	local var0_11 = {
		"ZHIHUIMIAO2",
		"NG006",
		"NG007",
		"ZHIHUIMIAO3",
		"NG008",
		"ZHIHUIMIAO4",
		"NG009"
	}

	if not LOCK_CATTERY then
		table.insert(var0_11, "NG0029")
	end

	local var1_11 = _.select(var0_11, function(arg0_12)
		return not var2_0(arg0_12)
	end)
	local var2_11 = {}
	local var3_11

	for iter0_11, iter1_11 in ipairs(var1_11) do
		table.insert(var2_11, function(arg0_13)
			if iter1_11 == "NG006" and table.getCount(getProxy(CommanderProxy):getData()) >= 1 or iter1_11 == "NG007" and getProxy(BagProxy):getItemCountById(20012) < 1 or iter1_11 == "NG008" and getProxy(CommanderProxy):getBoxes()[1]:getState() ~= CommanderBox.STATE_FINISHED or iter1_11 == "NG009" and table.getCount(getProxy(CommanderProxy):getData()) ~= 1 then
				pg.m02:sendNotification(GAME.STORY_UPDATE, {
					storyId = iter1_11
				})
				arg0_13()
			elseif iter1_11 == "ZHIHUIMIAO2" or iter1_11 == "ZHIHUIMIAO3" or iter1_11 == "ZHIHUIMIAO4" then
				pg.NewStoryMgr.GetInstance():Play(iter1_11, arg0_13, true)
			elseif iter1_11 == "NG0029" then
				if var3_11 == "NG009" then
					var4_0(iter1_11, {
						1
					}, arg0_13)
				else
					var4_0(iter1_11, {
						2
					}, arg0_13)
				end
			else
				var3_11 = iter1_11

				var4_0(iter1_11, {}, arg0_13)
			end
		end)
	end

	seriesAsync(var2_11)
end

function var0_0.PlayGuildAssaultFleet(arg0_14, arg1_14)
	arg0_14:PlayByGuideId("GNG001", {}, arg1_14)
end
