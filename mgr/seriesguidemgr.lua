pg = pg or {}
pg.SeriesGuideMgr = singletonClass("SeriesGuideMgr")

local var0_0 = pg.SeriesGuideMgr
local var1_0 = false

function log(...)
	if var1_0 then
		originalPrint(...)
	end
end

local var2_0 = {
	IDLE = 1,
	BUSY = 2
}

var0_0.CODES = {
	CONDITION = 4,
	MAINUI = 2,
	GUIDER = 1
}

function var0_0.isRunning(arg0_2)
	return arg0_2.state == var2_0.BUSY
end

function var0_0.IsInit(arg0_3)
	return arg0_3.state and arg0_3.state >= var2_0.IDLE
end

function var0_0.isNotFinish(arg0_4)
	local var0_4 = getProxy(PlayerProxy)

	if var0_4 then
		return var0_4:getRawData():GetGuideIndex(arg0_4:IsNewVersion()) < arg0_4.lastIndex - 1
	end
end

function var0_0.IsNewVersion(arg0_5)
	return arg0_5.isNewVersion
end

function var0_0.loadGuide(arg0_6, arg1_6)
	print("load guide script:", arg1_6)

	return require("GameCfg.guide.newguide." .. arg1_6)
end

function var0_0.getStepConfig(arg0_7, arg1_7)
	return arg0_7.guideCfgs[arg1_7]
end

function var0_0.CheckNewVersion(arg0_8, arg1_8, arg2_8)
	if arg1_8 then
		return true
	end

	local var0_8 = arg2_8:GetGuideIndex(true)
	local var1_8 = arg2_8:GetGuideIndex(false)

	print("guild index:", var0_8, var1_8)

	return var1_8 <= var0_8
end

function var0_0.Init(arg0_9, arg1_9, arg2_9)
	arg0_9.state = var2_0.IDLE
	arg0_9.isNewVersion = arg0_9:CheckNewVersion(arg1_9, arg2_9)

	local var0_9 = arg0_9.isNewVersion and "SG002" or "SG001"

	arg0_9.guideCfgs = arg0_9:loadGuide(var0_9)
	arg0_9.lastIndex = #arg0_9.guideCfgs + 1
	arg0_9.guideMgr = pg.NewGuideMgr.GetInstance()
	arg0_9.protocols = {}
	arg0_9.onReceiceProtocol = nil

	arg0_9:setPlayer(arg2_9)
end

function var0_0.dispatch(arg0_10, arg1_10)
	if arg0_10:canPlay(arg1_10) then
		arg0_10.guideMgr:PlayNothing()
	end
end

function var0_0.start(arg0_11, arg1_11)
	if arg0_11:canPlay(arg1_11) then
		arg0_11.state = var2_0.BUSY

		arg0_11.guideMgr:StopNothing()

		arg0_11.stepConfig = arg0_11:getStepConfig(arg0_11.currIndex)

		local function var0_11(arg0_12)
			arg0_11.state = var2_0.IDLE
			arg0_11.protocols = {}

			if not arg0_11.stepConfig.interrupt then
				arg0_11:doNextStep(arg0_11.currIndex, arg0_12)
			end
		end

		arg0_11:doGuideStep(arg1_11, function(arg0_13, arg1_13)
			if arg0_11.stepConfig.end_segment and arg1_13 then
				arg0_11.guideMgr:Play(arg0_11.stepConfig.end_segment, arg1_11.code, function()
					var0_11(arg0_13)
				end, nil, function(arg0_15, arg1_15)
					arg0_11:Record(arg0_11.currIndex - 1, arg0_15, arg1_15, arg0_11.stepConfig.end_segment)
				end)
			else
				var0_11(arg0_13)
			end
		end)
	end
end

function var0_0.doGuideStep(arg0_16, arg1_16, arg2_16)
	if arg0_16.stepConfig.condition then
		local var0_16, var1_16, var2_16 = arg0_16:checkCondition(arg1_16)
		local var3_16 = var2_16 and var1_16 > arg0_16.currIndex

		arg0_16:updateIndex(var1_16, function()
			arg2_16({
				var0_16
			}, var3_16)
		end)
	else
		local var4_16 = arg0_16.stepConfig.segment[arg0_16:getSegmentIndex()]
		local var5_16 = var4_16[1]
		local var6_16 = var4_16[2]

		assert(var6_16, "protocol can not be nil")

		local var7_16 = {
			function(arg0_18)
				arg0_16.guideMgr:Play(var5_16, arg1_16.code, arg0_18, function()
					arg0_16:updateIndex(arg0_16.lastIndex)
				end, function(arg0_20, arg1_20)
					arg0_16:Record(arg0_16.currIndex, arg0_20, arg1_20, var5_16)
				end)
				arg0_16.guideMgr:PlayNothing()
			end,
			function(arg0_21)
				if _.any(arg0_16.protocols, function(arg0_22)
					return arg0_22.protocol == var6_16
				end) then
					arg0_21()

					return
				end

				function arg0_16.onReceiceProtocol(arg0_23)
					if arg0_23 == var6_16 then
						arg0_16.onReceiceProtocol = nil

						arg0_21()
					end
				end
			end,
			function(arg0_24)
				arg0_16.guideMgr:StopNothing()
				arg0_16:increaseIndex(arg0_24)
			end
		}

		seriesAsync(var7_16, function()
			arg2_16({
				var0_0.CODES.GUIDER
			}, true)
		end)
	end
end

function var0_0.Record(arg0_26, arg1_26, arg2_26, arg3_26, arg4_26)
	local var0_26 = pg.TimeMgr.GetInstance():GetServerTime() - arg3_26

	pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildGuide(arg0_26:IsNewVersion(), arg1_26, arg2_26, var0_26, arg4_26))
end

function var0_0.getSegmentIndex(arg0_27)
	local var0_27 = 1

	if arg0_27.stepConfig.getSegment then
		var0_27 = arg0_27.stepConfig.getSegment()
	end

	return var0_27
end

local var3_0 = 1
local var4_0 = 2
local var5_0 = 3

function var0_0.checkCondition(arg0_28, arg1_28)
	local var0_28 = arg0_28.stepConfig
	local var1_28
	local var2_28
	local var3_28 = true
	local var4_28 = var0_28.condition.arg

	if var4_28[1] == var3_0 then
		local var5_28 = {
			protocol = var4_28[2],
			func = var0_28.condition.func
		}

		var2_28, var1_28 = arg0_28:checkPtotocol(var5_28, arg1_28)
	elseif var4_28[1] == var4_0 then
		local var6_28 = getProxy(PlayerProxy):getRawData()
		local var7_28 = getProxy(BayProxy):getShipById(var6_28.character)

		var2_28, var1_28 = var0_28.condition.func(var7_28)
		arg0_28.stepConfig.condition = nil
	elseif var4_28[1] == var5_0 then
		var2_28, var1_28 = var0_28.condition.func(NewServerCarnivalScene.isShow())
		arg0_28.stepConfig.condition = nil
		var3_28 = false
	end

	assert(var1_28, "index can not be nil")

	return var2_28, var1_28, var3_28
end

function var0_0.checkPtotocol(arg0_29, arg1_29, arg2_29)
	local var0_29 = arg1_29.protocol
	local var1_29 = _.select(arg0_29.protocols, function(arg0_30)
		return arg0_30.protocol == var0_29
	end)[1] or {}

	return arg1_29.func(arg2_29.view, var1_29.args)
end

function var0_0.increaseIndex(arg0_31, arg1_31)
	local var0_31 = arg0_31.currIndex + 1

	arg0_31:updateIndex(var0_31, arg1_31)
end

function var0_0.updateIndex(arg0_32, arg1_32, arg2_32)
	local var0_32 = arg0_32:IsNewVersion()

	pg.m02:sendNotification(GAME.UPDATE_GUIDE_INDEX, {
		isNewVersion = var0_32,
		index = arg1_32,
		callback = arg2_32
	})
end

function var0_0.doNextStep(arg0_33, arg1_33, arg2_33)
	arg0_33.stepConfig = nil

	if arg0_33:isEnd() then
		return
	end

	local var0_33 = arg0_33.guideCfgs[arg1_33]
	local var1_33 = {
		view = var0_33.view[#var0_33.view],
		code = arg2_33
	}

	if arg0_33:canPlay(var1_33) then
		arg0_33:start(var1_33)
	end
end

function var0_0.isEnd(arg0_34)
	return arg0_34.currIndex > #arg0_34.guideCfgs or not ENABLE_GUIDE
end

function var0_0.receiceProtocol(arg0_35, arg1_35, arg2_35, arg3_35)
	if not arg0_35:IsInit() then
		return
	end

	table.insert(arg0_35.protocols, {
		protocol = arg1_35,
		args = arg2_35,
		data = arg3_35
	})

	if arg0_35.onReceiceProtocol then
		arg0_35.onReceiceProtocol(arg1_35)
	end
end

function var0_0.canPlay(arg0_36, arg1_36)
	if arg0_36.state ~= var2_0.IDLE then
		log("guider is busy")

		return false
	end

	if not ENABLE_GUIDE then
		log("ENABLE is false")

		return false
	end

	if not arg0_36.guideMgr then
		log("guideMgr is nil")

		return false
	end

	if not arg0_36.playerLevel then
		log("player is nil")

		return false
	end

	if arg0_36:isEnd() then
		log("guider is end")

		return false
	end

	local var0_36 = arg0_36:getStepConfig(arg0_36.currIndex)

	if not table.contains(var0_36.view, arg1_36.view) then
		log("view is erro", arg0_36.currIndex, arg1_36.view, var0_36.view[1], var0_36.view[2])

		return false
	end

	return true
end

function var0_0.setPlayer(arg0_37, arg1_37)
	arg0_37.playerLevel = arg1_37.level

	local var0_37 = arg1_37:GetGuideIndex(arg0_37:IsNewVersion())

	arg0_37.playerIndex = var0_37
	arg0_37.currIndex = var0_37

	arg0_37:compatibleOldPlayer()
end

function var0_0.dispose(arg0_38)
	arg0_38.playerLevel = nil
	arg0_38.protocols = {}
	arg0_38.state = var2_0.IDLE
end

function var0_0.compatibleOldPlayer(arg0_39)
	if not arg0_39.playerLevel then
		return
	end

	local function var0_39()
		arg0_39:updateIndex(arg0_39.lastIndex)
	end

	if arg0_39.playerLevel >= 5 and arg0_39.playerIndex < arg0_39.lastIndex then
		var0_39()

		return
	end

	if arg0_39.playerIndex ~= arg0_39.lastIndex then
		pg.SystemGuideMgr.GetInstance():FixGuide(function()
			if arg0_39.playerIndex > 1 and arg0_39.playerIndex < 101 then
				var0_39()
			end
		end)
	end
end
