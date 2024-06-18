pg = pg or {}
pg.SeriesGuideMgr = singletonClass("SeriesGuideMgr")

local var0_0 = pg.SeriesGuideMgr
local var1_0 = false
local var2_0 = 29

function log(...)
	if var1_0 then
		originalPrint(...)
	end
end

local var3_0 = {
	IDLE = 1,
	BUSY = 2
}

var0_0.CODES = {
	CONDITION = 4,
	MAINUI = 2,
	GUIDER = 1
}

function var0_0.isRunning(arg0_2)
	return arg0_2.state == var3_0.BUSY
end

function var0_0.isNotFinish(arg0_3)
	local var0_3 = getProxy(PlayerProxy)

	if var0_3 then
		return var0_3:getRawData().guideIndex < 28
	end
end

function var0_0.loadGuide(arg0_4, arg1_4)
	return require("GameCfg.guide.newguide." .. arg1_4)
end

function var0_0.getStepConfig(arg0_5, arg1_5)
	return arg0_5.guideCfgs[arg1_5]
end

function var0_0.Init(arg0_6, arg1_6)
	arg0_6.state = var3_0.IDLE
	arg0_6.guideCfgs = arg0_6:loadGuide("SG001")
	arg0_6.guideMgr = pg.NewGuideMgr.GetInstance()
	arg0_6.protocols = {}
	arg0_6.onReceiceProtocol = nil

	arg1_6()
end

function var0_0.dispatch(arg0_7, arg1_7)
	if arg0_7:canPlay(arg1_7) then
		arg0_7.guideMgr:PlayNothing()
	end
end

function var0_0.start(arg0_8, arg1_8)
	if arg0_8:canPlay(arg1_8) then
		arg0_8.state = var3_0.BUSY

		arg0_8.guideMgr:StopNothing()

		arg0_8.stepConfig = arg0_8:getStepConfig(arg0_8.currIndex)

		local function var0_8(arg0_9)
			arg0_8.state = var3_0.IDLE
			arg0_8.protocols = {}

			if not arg0_8.stepConfig.interrupt then
				arg0_8:doNextStep(arg0_8.currIndex, arg0_9)
			end
		end

		arg0_8:doGuideStep(arg1_8, function(arg0_10, arg1_10)
			if arg0_8.stepConfig.end_segment and arg1_10 then
				arg0_8.guideMgr:Play(arg0_8.stepConfig.end_segment, arg1_8.code, function()
					var0_8(arg0_10)
				end)
			else
				var0_8(arg0_10)
			end
		end)
	end
end

function var0_0.doGuideStep(arg0_12, arg1_12, arg2_12)
	if arg0_12.stepConfig.condition then
		local var0_12, var1_12 = arg0_12:checkCondition(arg1_12)
		local var2_12 = var1_12 > arg0_12.currIndex

		arg0_12:updateIndex(var1_12, function()
			arg2_12({
				var0_12
			}, var2_12)
		end)
	else
		local var3_12 = arg0_12.stepConfig.segment[arg0_12:getSegmentIndex()]
		local var4_12 = var3_12[1]
		local var5_12 = var3_12[2]

		assert(var5_12, "protocol can not be nil")

		local var6_12 = {
			function(arg0_14)
				arg0_12.guideMgr:Play(var4_12, arg1_12.code, arg0_14, function()
					arg0_12:updateIndex(var2_0)
				end)
				arg0_12.guideMgr:PlayNothing()
			end,
			function(arg0_16)
				if _.any(arg0_12.protocols, function(arg0_17)
					return arg0_17.protocol == var5_12
				end) then
					arg0_16()

					return
				end

				function arg0_12.onReceiceProtocol(arg0_18)
					if arg0_18 == var5_12 then
						arg0_12.onReceiceProtocol = nil

						arg0_16()
					end
				end
			end,
			function(arg0_19)
				arg0_12.guideMgr:StopNothing()
				arg0_12:increaseIndex(arg0_19)
			end
		}

		seriesAsync(var6_12, function()
			arg2_12({
				var0_0.CODES.GUIDER
			}, true)
		end)
	end
end

function var0_0.getSegmentIndex(arg0_21)
	local var0_21 = 1

	if arg0_21.stepConfig.getSegment then
		var0_21 = arg0_21.stepConfig.getSegment()
	end

	return var0_21
end

local var4_0 = 1
local var5_0 = 2

function var0_0.checkCondition(arg0_22, arg1_22)
	local var0_22 = arg0_22.stepConfig
	local var1_22
	local var2_22
	local var3_22 = var0_22.condition.arg

	if var3_22[1] == var4_0 then
		local var4_22 = {
			protocol = var3_22[2],
			func = var0_22.condition.func
		}

		var2_22, var1_22 = arg0_22:checkPtotocol(var4_22, arg1_22)
	elseif var3_22[1] == var5_0 then
		local var5_22 = getProxy(PlayerProxy):getRawData()
		local var6_22 = getProxy(BayProxy):getShipById(var5_22.character)

		var2_22, var1_22 = var0_22.condition.func(var6_22)
		arg0_22.stepConfig.condition = nil
	end

	assert(var1_22, "index can not be nil")

	return var2_22, var1_22
end

function var0_0.checkPtotocol(arg0_23, arg1_23, arg2_23)
	local var0_23 = arg1_23.protocol
	local var1_23 = _.select(arg0_23.protocols, function(arg0_24)
		return arg0_24.protocol == var0_23
	end)[1] or {}

	return arg1_23.func(arg2_23.view, var1_23.args)
end

function var0_0.increaseIndex(arg0_25, arg1_25)
	local var0_25 = arg0_25.currIndex + 1

	arg0_25:updateIndex(var0_25, arg1_25)
end

function var0_0.updateIndex(arg0_26, arg1_26, arg2_26)
	pg.m02:sendNotification(GAME.UPDATE_GUIDE_INDEX, {
		index = arg1_26,
		callback = arg2_26
	})
end

function var0_0.doNextStep(arg0_27, arg1_27, arg2_27)
	arg0_27.stepConfig = nil

	if arg0_27:isEnd() then
		return
	end

	local var0_27 = arg0_27.guideCfgs[arg1_27]
	local var1_27 = {
		view = var0_27.view[#var0_27.view],
		code = arg2_27
	}

	if arg0_27:canPlay(var1_27) then
		arg0_27:start(var1_27)
	end
end

function var0_0.isEnd(arg0_28)
	return arg0_28.currIndex > #arg0_28.guideCfgs or not ENABLE_GUIDE
end

function var0_0.receiceProtocol(arg0_29, arg1_29, arg2_29, arg3_29)
	table.insert(arg0_29.protocols, {
		protocol = arg1_29,
		args = arg2_29,
		data = arg3_29
	})

	if arg0_29.onReceiceProtocol then
		arg0_29.onReceiceProtocol(arg1_29)
	end
end

function var0_0.canPlay(arg0_30, arg1_30)
	if arg0_30.state ~= var3_0.IDLE then
		log("guider is busy")

		return false
	end

	if not ENABLE_GUIDE then
		log("ENABLE is false")

		return false
	end

	if not arg0_30.guideMgr then
		log("guideMgr is nil")

		return false
	end

	if not arg0_30.plevel then
		log("player is nil")

		return false
	end

	if arg0_30:isEnd() then
		log("guider is end")

		return false
	end

	local var0_30 = arg0_30:getStepConfig(arg0_30.currIndex)

	if not table.contains(var0_30.view, arg1_30.view) then
		log("view is erro", arg0_30.currIndex, arg1_30.view, var0_30.view[1], var0_30.view[2])

		return false
	end

	return true
end

function var0_0.setPlayer(arg0_31, arg1_31)
	arg0_31.plevel = arg1_31.level
	arg0_31.pguideIndex = arg1_31.guideIndex
	arg0_31.currIndex = arg1_31.guideIndex

	arg0_31:compatibleOldPlayer()
end

function var0_0.dispose(arg0_32)
	arg0_32.plevel = nil
	arg0_32.guideIndex = nil
	arg0_32.protocols = {}
	arg0_32.state = var3_0.IDLE
end

function var0_0.compatibleOldPlayer(arg0_33)
	if not arg0_33.plevel then
		return
	end

	local function var0_33()
		local var0_34 = getProxy(PlayerProxy):getRawData()

		var0_34.guideIndex = var2_0

		arg0_33:setPlayer(var0_34)
		arg0_33:updateIndex(var0_34.guideIndex)
	end

	if arg0_33.plevel >= 5 and arg0_33.pguideIndex < var2_0 then
		var0_33()

		return
	end

	if arg0_33.pguideIndex ~= var2_0 then
		pg.SystemGuideMgr.GetInstance():FixGuide(function()
			if arg0_33.pguideIndex > 1 and arg0_33.pguideIndex < 101 then
				var0_33()
			end
		end)
	end
end
