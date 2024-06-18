local var0_0 = class("AttireProxy", import(".NetProxy"))

var0_0.ATTIREFRAME_UPDATED = "AttireProxy:ATTIREFRAME_UPDATED"
var0_0.ATTIREFRAME_ADDED = "AttireProxy:ATTIREFRAME_ADDED"
var0_0.ATTIREFRAME_EXPIRED = "AttireProxy:ATTIREFRAME_EXPIRED"

local var1_0 = pg.item_data_frame
local var2_0 = pg.item_data_chat
local var3_0 = false

function var0_0.register(arg0_1)
	arg0_1.data = {}
	arg0_1.timers = {}
	arg0_1.expiredChaces = {}
	arg0_1.data.iconFrames = {}
	arg0_1.data.chatFrames = {}

	for iter0_1, iter1_1 in ipairs(var1_0.all) do
		if iter1_1 == 0 then
			arg0_1.data.iconFrames[iter1_1] = IconFrame.New({
				end_time = 0,
				id = iter1_1
			})
		else
			arg0_1.data.iconFrames[iter1_1] = IconFrame.New({
				id = iter1_1
			})
		end
	end

	for iter2_1, iter3_1 in ipairs(var2_0.all) do
		if iter3_1 == 0 then
			arg0_1.data.chatFrames[iter3_1] = ChatFrame.New({
				end_time = 0,
				id = iter3_1
			})
		else
			arg0_1.data.chatFrames[iter3_1] = ChatFrame.New({
				id = iter3_1
			})
		end
	end

	arg0_1:on(11003, function(arg0_2)
		for iter0_2, iter1_2 in ipairs(arg0_2.icon_frame_list) do
			local var0_2 = arg0_1.data.iconFrames[iter1_2.id]

			var0_2:updateData(iter1_2)
			arg0_1:updateAttireFrame(var0_2)
			arg0_1:addExpiredTimer(var0_2)
		end

		for iter2_2, iter3_2 in ipairs(arg0_2.chat_frame_list or {}) do
			local var1_2 = arg0_1.data.chatFrames[iter3_2.id]

			var1_2:updateData(iter3_2)
			arg0_1:updateAttireFrame(var1_2)
			arg0_1:addExpiredTimer(var1_2)
		end
	end)

	if var3_0 then
		arg0_1.timer = Timer.New(function()
			local var0_3 = {}
			local var1_3 = {
				101,
				102,
				201,
				301
			}

			for iter0_3 = 1, 5 do
				local var2_3 = math.random(1, 4)
				local var3_3 = Drop.New({
					count = 1,
					type = iter0_3 % 2 == 0 and DROP_TYPE_ICON_FRAME or DROP_TYPE_CHAT_FRAME,
					id = var1_3[var2_3]
				})

				arg0_1:sendNotification(GAME.ADD_ITEM, var3_3)
				table.insert(var0_3, var3_3)
			end

			table.insert(var0_3, Drop.New({
				count = 1000,
				type = DROP_TYPE_RESOURCE,
				id = PlayerConst.ResGold
			}))
			arg0_1:sendNotification(GAME.ACT_NEW_PT_DONE, {
				awards = var0_3
			})
		end, 10, 1)

		arg0_1.timer:Start()
	end
end

function var0_0.getDataAndTrophys(arg0_4, arg1_4)
	local var0_4 = arg0_4:getData()

	if arg1_4 then
		arg0_4:clearNew()
	end

	var0_4.trophys = getProxy(CollectionProxy):getTrophys()

	return var0_4
end

function var0_0.clearNew(arg0_5)
	for iter0_5, iter1_5 in pairs(arg0_5.data.iconFrames) do
		iter1_5:clearNew()
	end

	for iter2_5, iter3_5 in pairs(arg0_5.data.chatFrames) do
		iter3_5:clearNew()
	end
end

function var0_0.getExpiredChaces(arg0_6)
	local var0_6 = {}

	for iter0_6, iter1_6 in ipairs(arg0_6.expiredChaces) do
		table.insert(var0_6, iter1_6)
	end

	arg0_6.expiredChaces = {}

	return var0_6
end

function var0_0.getAttireFrame(arg0_7, arg1_7, arg2_7)
	local var0_7

	if arg1_7 == AttireConst.TYPE_ICON_FRAME then
		var0_7 = arg0_7.data.iconFrames[arg2_7]
	elseif arg1_7 == AttireConst.TYPE_CHAT_FRAME then
		var0_7 = arg0_7.data.chatFrames[arg2_7]
	end

	return var0_7
end

function var0_0.addAttireFrame(arg0_8, arg1_8)
	local var0_8 = arg1_8:getType()
	local var1_8 = arg0_8:getAttireFrame(var0_8, arg1_8.id)

	if arg1_8:expiredType() and var1_8 and not var1_8:isExpired() then
		local var2_8 = var1_8:getExpiredTime() + arg1_8:getConfig("time_second")

		arg1_8:updateEndTime(var2_8)
	end

	if var0_8 == AttireConst.TYPE_ICON_FRAME then
		arg0_8.data.iconFrames[arg1_8.id] = arg1_8
	elseif var0_8 == AttireConst.TYPE_CHAT_FRAME then
		arg0_8.data.chatFrames[arg1_8.id] = arg1_8
	end

	arg0_8:addExpiredTimer(arg1_8)
	arg0_8:sendNotification(var0_0.ATTIREFRAME_ADDED, arg1_8:clone())
end

function var0_0.updateAttireFrame(arg0_9, arg1_9)
	local var0_9 = arg1_9:getType()

	if var0_9 == AttireConst.TYPE_ICON_FRAME then
		assert(arg0_9.data.iconFrames[arg1_9.id])

		arg0_9.data.iconFrames[arg1_9.id] = arg1_9
	elseif var0_9 == AttireConst.TYPE_CHAT_FRAME then
		assert(arg0_9.data.chatFrames[arg1_9.id])

		arg0_9.data.chatFrames[arg1_9.id] = arg1_9
	end

	arg0_9:sendNotification(var0_0.ATTIREFRAME_UPDATED, arg1_9:clone())
end

function var0_0.addExpiredTimer(arg0_10, arg1_10)
	arg0_10:removeExpiredTimer(arg1_10)

	if not arg1_10:expiredType() then
		return
	end

	local function var0_10()
		local var0_11 = getProxy(PlayerProxy)
		local var1_11 = var0_11:getData()
		local var2_11 = arg1_10:getType()

		if var1_11:getAttireByType(var2_11) == arg1_10.id then
			var1_11:updateAttireFrame(var2_11, 0)
			var0_11:updatePlayer(var1_11)
		end

		table.insert(arg0_10.expiredChaces, arg1_10)
		arg0_10:sendNotification(var0_0.ATTIREFRAME_EXPIRED, arg1_10:clone())
	end

	local var1_10 = arg1_10:getExpiredTime() - pg.TimeMgr.GetInstance():GetServerTime()

	if var1_10 > 0 then
		local var2_10 = arg1_10:getTimerKey()

		arg0_10.timers[var2_10] = Timer.New(function()
			var0_10()
			arg0_10:removeExpiredTimer(arg1_10)
		end, var1_10, 1)

		arg0_10.timers[var2_10]:Start()
	else
		var0_10()
	end
end

function var0_0.removeExpiredTimer(arg0_13, arg1_13)
	local var0_13 = arg1_13:getTimerKey()

	if arg0_13.timers[var0_13] then
		arg0_13.timers[var0_13]:Stop()

		arg0_13.timers[var0_13] = nil
	end
end

function var0_0.remove(arg0_14)
	for iter0_14, iter1_14 in pairs(arg0_14.timers) do
		iter1_14:Stop()
	end

	arg0_14.timers = {}
end

function var0_0.needTip(arg0_15)
	local var0_15 = {}
	local var1_15 = arg0_15:getDataAndTrophys()
	local var2_15 = {
		var1_15.iconFrames,
		var1_15.chatFrames,
		var1_15.trophys
	}

	local function var3_15(arg0_16)
		local var0_16 = false

		for iter0_16, iter1_16 in pairs(arg0_16) do
			if iter1_16:isNew() then
				var0_16 = true

				break
			end
		end

		return var0_16
	end

	for iter0_15, iter1_15 in ipairs(var2_15) do
		if iter0_15 == 1 or iter0_15 == 2 then
			table.insert(var0_15, var3_15(iter1_15))
		else
			table.insert(var0_15, false)
		end
	end

	return var0_15
end

function var0_0.IsShowRedDot(arg0_17)
	return _.any(arg0_17:needTip(), function(arg0_18)
		return arg0_18 == true
	end)
end

return var0_0
