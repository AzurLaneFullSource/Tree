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

local function var4_0(arg0_4, arg1_4, arg2_4, arg3_4)
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

	if arg3_4 then
		pg.NewGuideMgr.GetInstance():Play(arg0_4, arg1_4, function()
			pg.m02:sendNotification(GAME.STORY_UPDATE, {
				storyId = arg0_4
			})
			existCall(arg2_4)
		end)
	else
		pg.m02:sendNotification(GAME.STORY_UPDATE, {
			storyId = arg0_4
		})
		pg.NewGuideMgr.GetInstance():Play(arg0_4, arg1_4, arg2_4)
	end
end

function var0_0.Play(arg0_6, arg1_6, arg2_6)
	if IsUnityEditor and not ENABLE_GUIDE then
		if arg2_6 then
			arg2_6()
		end

		return
	end

	if arg1_6.exited then
		return
	end

	local var0_6 = var1_0[arg1_6.__cname]

	if not var0_6 then
		var3_0(arg2_6)

		return
	end

	local var1_6 = _.detect(var0_6, function(arg0_7)
		local var0_7 = arg0_7.id
		local var1_7 = arg0_7.condition

		return not var2_0(var0_7) and var1_7(arg1_6)
	end)

	if not var1_6 then
		var3_0(arg2_6)

		return
	end

	local var2_6 = var1_6.id
	local var3_6 = var1_6.args(arg1_6)

	var4_0(var2_6, var3_6, arg2_6)
end

function var0_0.PlayChapter(arg0_8, arg1_8, arg2_8)
	if arg1_8.id == 1160002 then
		arg0_8:PlayByGuideId("NG0011", nil, arg2_8)
	elseif arg1_8:isTypeDefence() then
		arg0_8:PlayByGuideId("NG0016", nil, arg2_8)
	else
		existCall(arg2_8)
	end
end

function var0_0.PlayByGuideId(arg0_9, arg1_9, arg2_9, arg3_9, arg4_9)
	var4_0(arg1_9, arg2_9, arg3_9, arg4_9)
end

function var0_0.FixGuide(arg0_10, arg1_10)
	if not var2_0("FixGuide") then
		var4_0("FixGuide")
		arg1_10()
	end
end

function var0_0.PlayDailyLevel(arg0_11, arg1_11)
	if not var2_0("NG0015") then
		pg.m02:sendNotification(GAME.STORY_UPDATE, {
			storyId = "NG0015"
		})
		arg1_11()
	end
end

function var0_0.PlayCommander(arg0_12)
	local var0_12 = {
		"ZHIHUIMIAO2",
		"NG006",
		"NG007",
		"ZHIHUIMIAO3",
		"NG008",
		"ZHIHUIMIAO4",
		"NG009"
	}

	if not LOCK_CATTERY then
		table.insert(var0_12, "NG0029")
	end

	local var1_12 = _.select(var0_12, function(arg0_13)
		return not var2_0(arg0_13)
	end)
	local var2_12 = {}
	local var3_12

	for iter0_12, iter1_12 in ipairs(var1_12) do
		table.insert(var2_12, function(arg0_14)
			if iter1_12 == "NG006" and table.getCount(getProxy(CommanderProxy):getData()) >= 1 or iter1_12 == "NG007" and getProxy(BagProxy):getItemCountById(20012) < 1 or iter1_12 == "NG008" and getProxy(CommanderProxy):getBoxes()[1]:getState() ~= CommanderBox.STATE_FINISHED or iter1_12 == "NG009" and table.getCount(getProxy(CommanderProxy):getData()) ~= 1 then
				pg.m02:sendNotification(GAME.STORY_UPDATE, {
					storyId = iter1_12
				})
				arg0_14()
			elseif iter1_12 == "ZHIHUIMIAO2" or iter1_12 == "ZHIHUIMIAO3" or iter1_12 == "ZHIHUIMIAO4" then
				pg.NewStoryMgr.GetInstance():Play(iter1_12, arg0_14, true)
			elseif iter1_12 == "NG0029" then
				if var3_12 == "NG009" then
					var4_0(iter1_12, {
						1
					}, arg0_14)
				else
					var4_0(iter1_12, {
						2
					}, arg0_14)
				end
			else
				var3_12 = iter1_12

				var4_0(iter1_12, {}, arg0_14)
			end
		end)
	end

	seriesAsync(var2_12)
end

function var0_0.PlayGuildAssaultFleet(arg0_15, arg1_15)
	arg0_15:PlayByGuideId("GNG001", {}, arg1_15)
end
