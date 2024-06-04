pg = pg or {}
pg.SeriesGuideMgr = singletonClass("SeriesGuideMgr")

local var0 = pg.SeriesGuideMgr
local var1 = false
local var2 = 29

function log(...)
	if var1 then
		originalPrint(...)
	end
end

local var3 = {
	IDLE = 1,
	BUSY = 2
}

var0.CODES = {
	CONDITION = 4,
	MAINUI = 2,
	GUIDER = 1
}

function var0.isRunning(arg0)
	return arg0.state == var3.BUSY
end

function var0.isNotFinish(arg0)
	local var0 = getProxy(PlayerProxy)

	if var0 then
		return var0:getRawData().guideIndex < 28
	end
end

function var0.loadGuide(arg0, arg1)
	return require("GameCfg.guide.newguide." .. arg1)
end

function var0.getStepConfig(arg0, arg1)
	return arg0.guideCfgs[arg1]
end

function var0.Init(arg0, arg1)
	arg0.state = var3.IDLE
	arg0.guideCfgs = arg0:loadGuide("SG001")
	arg0.guideMgr = pg.NewGuideMgr.GetInstance()
	arg0.protocols = {}
	arg0.onReceiceProtocol = nil

	arg1()
end

function var0.dispatch(arg0, arg1)
	if arg0:canPlay(arg1) then
		arg0.guideMgr:PlayNothing()
	end
end

function var0.start(arg0, arg1)
	if arg0:canPlay(arg1) then
		arg0.state = var3.BUSY

		arg0.guideMgr:StopNothing()

		arg0.stepConfig = arg0:getStepConfig(arg0.currIndex)

		local function var0(arg0)
			arg0.state = var3.IDLE
			arg0.protocols = {}

			if not arg0.stepConfig.interrupt then
				arg0:doNextStep(arg0.currIndex, arg0)
			end
		end

		arg0:doGuideStep(arg1, function(arg0, arg1)
			if arg0.stepConfig.end_segment and arg1 then
				arg0.guideMgr:Play(arg0.stepConfig.end_segment, arg1.code, function()
					var0(arg0)
				end)
			else
				var0(arg0)
			end
		end)
	end
end

function var0.doGuideStep(arg0, arg1, arg2)
	if arg0.stepConfig.condition then
		local var0, var1 = arg0:checkCondition(arg1)
		local var2 = var1 > arg0.currIndex

		arg0:updateIndex(var1, function()
			arg2({
				var0
			}, var2)
		end)
	else
		local var3 = arg0.stepConfig.segment[arg0:getSegmentIndex()]
		local var4 = var3[1]
		local var5 = var3[2]

		assert(var5, "protocol can not be nil")

		local var6 = {
			function(arg0)
				arg0.guideMgr:Play(var4, arg1.code, arg0, function()
					arg0:updateIndex(var2)
				end)
				arg0.guideMgr:PlayNothing()
			end,
			function(arg0)
				if _.any(arg0.protocols, function(arg0)
					return arg0.protocol == var5
				end) then
					arg0()

					return
				end

				function arg0.onReceiceProtocol(arg0)
					if arg0 == var5 then
						arg0.onReceiceProtocol = nil

						arg0()
					end
				end
			end,
			function(arg0)
				arg0.guideMgr:StopNothing()
				arg0:increaseIndex(arg0)
			end
		}

		seriesAsync(var6, function()
			arg2({
				var0.CODES.GUIDER
			}, true)
		end)
	end
end

function var0.getSegmentIndex(arg0)
	local var0 = 1

	if arg0.stepConfig.getSegment then
		var0 = arg0.stepConfig.getSegment()
	end

	return var0
end

local var4 = 1
local var5 = 2

function var0.checkCondition(arg0, arg1)
	local var0 = arg0.stepConfig
	local var1
	local var2
	local var3 = var0.condition.arg

	if var3[1] == var4 then
		local var4 = {
			protocol = var3[2],
			func = var0.condition.func
		}

		var2, var1 = arg0:checkPtotocol(var4, arg1)
	elseif var3[1] == var5 then
		local var5 = getProxy(PlayerProxy):getRawData()
		local var6 = getProxy(BayProxy):getShipById(var5.character)

		var2, var1 = var0.condition.func(var6)
		arg0.stepConfig.condition = nil
	end

	assert(var1, "index can not be nil")

	return var2, var1
end

function var0.checkPtotocol(arg0, arg1, arg2)
	local var0 = arg1.protocol
	local var1 = _.select(arg0.protocols, function(arg0)
		return arg0.protocol == var0
	end)[1] or {}

	return arg1.func(arg2.view, var1.args)
end

function var0.increaseIndex(arg0, arg1)
	local var0 = arg0.currIndex + 1

	arg0:updateIndex(var0, arg1)
end

function var0.updateIndex(arg0, arg1, arg2)
	pg.m02:sendNotification(GAME.UPDATE_GUIDE_INDEX, {
		index = arg1,
		callback = arg2
	})
end

function var0.doNextStep(arg0, arg1, arg2)
	arg0.stepConfig = nil

	if arg0:isEnd() then
		return
	end

	local var0 = arg0.guideCfgs[arg1]
	local var1 = {
		view = var0.view[#var0.view],
		code = arg2
	}

	if arg0:canPlay(var1) then
		arg0:start(var1)
	end
end

function var0.isEnd(arg0)
	return arg0.currIndex > #arg0.guideCfgs or not ENABLE_GUIDE
end

function var0.receiceProtocol(arg0, arg1, arg2, arg3)
	table.insert(arg0.protocols, {
		protocol = arg1,
		args = arg2,
		data = arg3
	})

	if arg0.onReceiceProtocol then
		arg0.onReceiceProtocol(arg1)
	end
end

function var0.canPlay(arg0, arg1)
	if arg0.state ~= var3.IDLE then
		log("guider is busy")

		return false
	end

	if not ENABLE_GUIDE then
		log("ENABLE is false")

		return false
	end

	if not arg0.guideMgr then
		log("guideMgr is nil")

		return false
	end

	if not arg0.plevel then
		log("player is nil")

		return false
	end

	if arg0:isEnd() then
		log("guider is end")

		return false
	end

	local var0 = arg0:getStepConfig(arg0.currIndex)

	if not table.contains(var0.view, arg1.view) then
		log("view is erro", arg0.currIndex, arg1.view, var0.view[1], var0.view[2])

		return false
	end

	return true
end

function var0.setPlayer(arg0, arg1)
	arg0.plevel = arg1.level
	arg0.pguideIndex = arg1.guideIndex
	arg0.currIndex = arg1.guideIndex

	arg0:compatibleOldPlayer()
end

function var0.dispose(arg0)
	arg0.plevel = nil
	arg0.guideIndex = nil
	arg0.protocols = {}
	arg0.state = var3.IDLE
end

function var0.compatibleOldPlayer(arg0)
	if not arg0.plevel then
		return
	end

	local function var0()
		local var0 = getProxy(PlayerProxy):getRawData()

		var0.guideIndex = var2

		arg0:setPlayer(var0)
		arg0:updateIndex(var0.guideIndex)
	end

	if arg0.plevel >= 5 and arg0.pguideIndex < var2 then
		var0()

		return
	end

	if arg0.pguideIndex ~= var2 then
		pg.SystemGuideMgr.GetInstance():FixGuide(function()
			if arg0.pguideIndex > 1 and arg0.pguideIndex < 101 then
				var0()
			end
		end)
	end
end
