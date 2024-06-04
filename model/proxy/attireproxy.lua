local var0 = class("AttireProxy", import(".NetProxy"))

var0.ATTIREFRAME_UPDATED = "AttireProxy:ATTIREFRAME_UPDATED"
var0.ATTIREFRAME_ADDED = "AttireProxy:ATTIREFRAME_ADDED"
var0.ATTIREFRAME_EXPIRED = "AttireProxy:ATTIREFRAME_EXPIRED"

local var1 = pg.item_data_frame
local var2 = pg.item_data_chat
local var3 = false

function var0.register(arg0)
	arg0.data = {}
	arg0.timers = {}
	arg0.expiredChaces = {}
	arg0.data.iconFrames = {}
	arg0.data.chatFrames = {}

	for iter0, iter1 in ipairs(var1.all) do
		if iter1 == 0 then
			arg0.data.iconFrames[iter1] = IconFrame.New({
				end_time = 0,
				id = iter1
			})
		else
			arg0.data.iconFrames[iter1] = IconFrame.New({
				id = iter1
			})
		end
	end

	for iter2, iter3 in ipairs(var2.all) do
		if iter3 == 0 then
			arg0.data.chatFrames[iter3] = ChatFrame.New({
				end_time = 0,
				id = iter3
			})
		else
			arg0.data.chatFrames[iter3] = ChatFrame.New({
				id = iter3
			})
		end
	end

	arg0:on(11003, function(arg0)
		for iter0, iter1 in ipairs(arg0.icon_frame_list) do
			local var0 = arg0.data.iconFrames[iter1.id]

			var0:updateData(iter1)
			arg0:updateAttireFrame(var0)
			arg0:addExpiredTimer(var0)
		end

		for iter2, iter3 in ipairs(arg0.chat_frame_list or {}) do
			local var1 = arg0.data.chatFrames[iter3.id]

			var1:updateData(iter3)
			arg0:updateAttireFrame(var1)
			arg0:addExpiredTimer(var1)
		end
	end)

	if var3 then
		arg0.timer = Timer.New(function()
			local var0 = {}
			local var1 = {
				101,
				102,
				201,
				301
			}

			for iter0 = 1, 5 do
				local var2 = math.random(1, 4)
				local var3 = Drop.New({
					count = 1,
					type = iter0 % 2 == 0 and DROP_TYPE_ICON_FRAME or DROP_TYPE_CHAT_FRAME,
					id = var1[var2]
				})

				arg0:sendNotification(GAME.ADD_ITEM, var3)
				table.insert(var0, var3)
			end

			table.insert(var0, Drop.New({
				count = 1000,
				type = DROP_TYPE_RESOURCE,
				id = PlayerConst.ResGold
			}))
			arg0:sendNotification(GAME.ACT_NEW_PT_DONE, {
				awards = var0
			})
		end, 10, 1)

		arg0.timer:Start()
	end
end

function var0.getDataAndTrophys(arg0, arg1)
	local var0 = arg0:getData()

	if arg1 then
		arg0:clearNew()
	end

	var0.trophys = getProxy(CollectionProxy):getTrophys()

	return var0
end

function var0.clearNew(arg0)
	for iter0, iter1 in pairs(arg0.data.iconFrames) do
		iter1:clearNew()
	end

	for iter2, iter3 in pairs(arg0.data.chatFrames) do
		iter3:clearNew()
	end
end

function var0.getExpiredChaces(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.expiredChaces) do
		table.insert(var0, iter1)
	end

	arg0.expiredChaces = {}

	return var0
end

function var0.getAttireFrame(arg0, arg1, arg2)
	local var0

	if arg1 == AttireConst.TYPE_ICON_FRAME then
		var0 = arg0.data.iconFrames[arg2]
	elseif arg1 == AttireConst.TYPE_CHAT_FRAME then
		var0 = arg0.data.chatFrames[arg2]
	end

	return var0
end

function var0.addAttireFrame(arg0, arg1)
	local var0 = arg1:getType()
	local var1 = arg0:getAttireFrame(var0, arg1.id)

	if arg1:expiredType() and var1 and not var1:isExpired() then
		local var2 = var1:getExpiredTime() + arg1:getConfig("time_second")

		arg1:updateEndTime(var2)
	end

	if var0 == AttireConst.TYPE_ICON_FRAME then
		arg0.data.iconFrames[arg1.id] = arg1
	elseif var0 == AttireConst.TYPE_CHAT_FRAME then
		arg0.data.chatFrames[arg1.id] = arg1
	end

	arg0:addExpiredTimer(arg1)
	arg0:sendNotification(var0.ATTIREFRAME_ADDED, arg1:clone())
end

function var0.updateAttireFrame(arg0, arg1)
	local var0 = arg1:getType()

	if var0 == AttireConst.TYPE_ICON_FRAME then
		assert(arg0.data.iconFrames[arg1.id])

		arg0.data.iconFrames[arg1.id] = arg1
	elseif var0 == AttireConst.TYPE_CHAT_FRAME then
		assert(arg0.data.chatFrames[arg1.id])

		arg0.data.chatFrames[arg1.id] = arg1
	end

	arg0:sendNotification(var0.ATTIREFRAME_UPDATED, arg1:clone())
end

function var0.addExpiredTimer(arg0, arg1)
	arg0:removeExpiredTimer(arg1)

	if not arg1:expiredType() then
		return
	end

	local var0 = function()
		local var0 = getProxy(PlayerProxy)
		local var1 = var0:getData()
		local var2 = arg1:getType()

		if var1:getAttireByType(var2) == arg1.id then
			var1:updateAttireFrame(var2, 0)
			var0:updatePlayer(var1)
		end

		table.insert(arg0.expiredChaces, arg1)
		arg0:sendNotification(var0.ATTIREFRAME_EXPIRED, arg1:clone())
	end
	local var1 = arg1:getExpiredTime() - pg.TimeMgr.GetInstance():GetServerTime()

	if var1 > 0 then
		local var2 = arg1:getTimerKey()

		arg0.timers[var2] = Timer.New(function()
			var0()
			arg0:removeExpiredTimer(arg1)
		end, var1, 1)

		arg0.timers[var2]:Start()
	else
		var0()
	end
end

function var0.removeExpiredTimer(arg0, arg1)
	local var0 = arg1:getTimerKey()

	if arg0.timers[var0] then
		arg0.timers[var0]:Stop()

		arg0.timers[var0] = nil
	end
end

function var0.remove(arg0)
	for iter0, iter1 in pairs(arg0.timers) do
		iter1:Stop()
	end

	arg0.timers = {}
end

function var0.needTip(arg0)
	local var0 = {}
	local var1 = arg0:getDataAndTrophys()
	local var2 = {
		var1.iconFrames,
		var1.chatFrames,
		var1.trophys
	}

	local function var3(arg0)
		local var0 = false

		for iter0, iter1 in pairs(arg0) do
			if iter1:isNew() then
				var0 = true

				break
			end
		end

		return var0
	end

	for iter0, iter1 in ipairs(var2) do
		if iter0 == 1 or iter0 == 2 then
			table.insert(var0, var3(iter1))
		else
			table.insert(var0, false)
		end
	end

	return var0
end

function var0.IsShowRedDot(arg0)
	return _.any(arg0:needTip(), function(arg0)
		return arg0 == true
	end)
end

return var0
