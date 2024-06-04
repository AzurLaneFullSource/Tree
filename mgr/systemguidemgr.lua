pg = pg or {}
pg.SystemGuideMgr = singletonClass("SystemGuideMgr")

local var0 = pg.SystemGuideMgr
local var1

function var0.Init(arg0, arg1)
	var1 = require("GameCfg.guide.newguide.SSG001")

	arg1()
end

local function var2(arg0)
	if getProxy(PlayerProxy) then
		return pg.NewStoryMgr.GetInstance():IsPlayed(arg0)
	end

	return false
end

local function var3(arg0)
	if arg0 then
		arg0()
	end
end

local function var4(arg0, arg1, arg2)
	if pg.SeriesGuideMgr.GetInstance():isRunning() then
		var3(arg2)

		return
	end

	if var2(arg0) then
		var3(arg2)

		return
	end

	if not pg.NewGuideMgr.GetInstance():CanPlay() then
		var3(arg2)

		return
	end

	if arg0 == "SYG001" then
		pg.TrackerMgr.GetInstance():Tracking(TRACKING_TUTORIAL_COMPLETE_2)
	elseif arg0 == "SYG003" then
		pg.TrackerMgr.GetInstance():Tracking(TRACKING_TUTORIAL_COMPLETE_3)
	elseif arg0 == "SYG006" then
		pg.TrackerMgr.GetInstance():Tracking(TRACKING_TUTORIAL_COMPLETE_4)
	end

	pg.m02:sendNotification(GAME.STORY_UPDATE, {
		storyId = arg0
	})
	pg.NewGuideMgr.GetInstance():Play(arg0, arg1, arg2)
end

function var0.Play(arg0, arg1, arg2)
	if IsUnityEditor and not ENABLE_GUIDE then
		if arg2 then
			arg2()
		end

		return
	end

	if arg1.exited then
		return
	end

	local var0 = var1[arg1.__cname]

	if not var0 then
		var3(arg2)

		return
	end

	local var1 = _.detect(var0, function(arg0)
		local var0 = arg0.id
		local var1 = arg0.condition

		return not var2(var0) and var1(arg1)
	end)

	if not var1 then
		var3(arg2)

		return
	end

	local var2 = var1.id
	local var3 = var1.args(arg1)

	var4(var2, var3, arg2)
end

function var0.PlayChapter(arg0, arg1, arg2)
	if arg1.id == 1160002 then
		arg0:PlayByGuideId("NG0011", nil, arg2)
	elseif arg1:isTypeDefence() then
		arg0:PlayByGuideId("NG0016", nil, arg2)
	else
		existCall(arg2)
	end
end

function var0.PlayByGuideId(arg0, arg1, arg2, arg3)
	var4(arg1, arg2, arg3)
end

function var0.FixGuide(arg0, arg1)
	if not var2("FixGuide") then
		var4("FixGuide")
		arg1()
	end
end

function var0.PlayDailyLevel(arg0, arg1)
	if not var2("NG0015") then
		pg.m02:sendNotification(GAME.STORY_UPDATE, {
			storyId = "NG0015"
		})
		arg1()
	end
end

function var0.PlayCommander(arg0)
	local var0 = {
		"ZHIHUIMIAO2",
		"NG006",
		"NG007",
		"ZHIHUIMIAO3",
		"NG008",
		"ZHIHUIMIAO4",
		"NG009"
	}

	if not LOCK_CATTERY then
		table.insert(var0, "NG0029")
	end

	local var1 = _.select(var0, function(arg0)
		return not var2(arg0)
	end)
	local var2 = {}
	local var3

	for iter0, iter1 in ipairs(var1) do
		table.insert(var2, function(arg0)
			if iter1 == "NG006" and table.getCount(getProxy(CommanderProxy):getData()) >= 1 or iter1 == "NG007" and getProxy(BagProxy):getItemCountById(20012) < 1 or iter1 == "NG008" and getProxy(CommanderProxy):getBoxes()[1]:getState() ~= CommanderBox.STATE_FINISHED or iter1 == "NG009" and table.getCount(getProxy(CommanderProxy):getData()) ~= 1 then
				pg.m02:sendNotification(GAME.STORY_UPDATE, {
					storyId = iter1
				})
				arg0()
			elseif iter1 == "ZHIHUIMIAO2" or iter1 == "ZHIHUIMIAO3" or iter1 == "ZHIHUIMIAO4" then
				pg.NewStoryMgr.GetInstance():Play(iter1, arg0, true)
			elseif iter1 == "NG0029" then
				if var3 == "NG009" then
					var4(iter1, {
						1
					}, arg0)
				else
					var4(iter1, {
						2
					}, arg0)
				end
			else
				var3 = iter1

				var4(iter1, {}, arg0)
			end
		end)
	end

	seriesAsync(var2)
end

function var0.PlayGuildAssaultFleet(arg0, arg1)
	arg0:PlayByGuideId("GNG001", {}, arg1)
end
