pg = pg or {}

local var0_0 = pg

var0_0.MessageCache = class("MessageCache")
var0_0.MessageCache.DEFAULT_QUEUE_LENGTH = 10000
var0_0.MessageCache.CMD_KILL = "CMD_KILL"
var0_0.MessageCache.CMD_PUSH = "CMD_PUSH"
var0_0.MessageCache.CMD_POP = "CMD_POP"
var0_0.MessageCache.CMD_FLUSH = "CMD_FLUSH"
var0_0.MessageCache.OK = "OK"
var0_0.MessageCache.QUEUE_FULL = "QUEUE_FULL"
var0_0.MessageCache.EXCEPTION = "EXCEPTION"

local function var1_0(...)
	return coroutine.yield(...)
end

local function var2_0(arg0_2, arg1_2, arg2_2)
	if arg1_2 == var0_0.MessageCache.CMD_PUSH then
		local var0_2 = #arg0_2.cacheQueue_ + (arg0_2.curRQLen_ - arg0_2.curRQPos_)

		if var0_2 >= arg0_2.cacheQueueLenLimit_ then
			return var2_0(arg0_2, var1_0(var0_0.MessageCache.QUEUE_FULL, string.format("                    the cache limit length is set with %s, the coming message will be ignored.\n                ", arg0_2.cacheQueueLenLimit_)))
		else
			table.insert(arg0_2.cacheQueue_, arg2_2)

			return var2_0(arg0_2, var1_0(var0_0.MessageCache.OK, var0_2 + 1))
		end
	elseif arg1_2 == var0_0.MessageCache.CMD_POP then
		if arg0_2.curRQPos_ < arg0_2.curRQLen_ then
			arg0_2.curRQPos_ = arg0_2.curRQPos_ + 1

			local var1_2 = arg0_2.retrieveQueue_[arg0_2.curRQPos_]

			arg0_2.retrieveQueue_[arg0_2.curRQPos_] = nil

			return var2_0(arg0_2, var1_0(var0_0.MessageCache.OK, var1_2))
		else
			assert(arg0_2.curRQPos_ >= arg0_2.curRQLen_)

			if arg0_2.cacheQueue_[1] then
				arg0_2.cacheQueue_, arg0_2.retrieveQueue_ = arg0_2.retrieveQueue_, arg0_2.cacheQueue_
				arg0_2.curRQPos_ = 1
				arg0_2.curRQLen_ = #arg0_2.retrieveQueue_

				local var2_2 = arg0_2.retrieveQueue_[arg0_2.curRQPos_]

				arg0_2.retrieveQueue_[arg0_2.curRQPos_] = nil

				return var2_0(arg0_2, var1_0(var0_0.MessageCache.OK, var2_2))
			else
				return var2_0(arg0_2, var1_0(var0_0.MessageCache.OK))
			end
		end
	elseif arg1_2 == var0_0.MessageCache.CMD_KILL then
		local var3_2 = arg0_2.curRQPos_
		local var4_2 = arg0_2.curRQLen_
		local var5_2 = 1

		while var3_2 < var4_2 do
			table.insert(arg0_2.cacheQueue_, var5_2, arg0_2.retrieveQueue_[var3_2])

			arg0_2.retrieveQueue_[var3_2] = nil
			var5_2 = var5_2 + 1
			var3_2 = var3_2 + 1
		end

		arg0_2.curRQPos_ = 0
		arg0_2.curRQLen_ = 0

		return var0_0.MessageCache.OK, arg0_2.cacheQueue_
	elseif arg1_2 == var0_0.MessageCache.CMD_FLUSH then
		local var6_2 = arg0_2.curRQPos_
		local var7_2 = arg0_2.curRQLen_
		local var8_2 = 1

		while var6_2 < var7_2 do
			table.insert(arg0_2.cacheQueue_, var8_2, arg0_2.retrieveQueue_[var6_2])

			arg0_2.retrieveQueue_[var6_2] = nil
			var8_2 = var8_2 + 1
			var6_2 = var6_2 + 1
		end

		arg0_2.curRQPos_ = 0
		arg0_2.curRQLen_ = 0

		local var9_2 = arg0_2.cacheQueue_

		arg0_2.cacheQueue_ = {}

		return var2_0(arg0_2, var1_0(var0_0.MessageCache.OK, var9_2))
	else
		return var2_0(arg0_2, var1_0(var0_0.MessageCache.EXCEPTION, string.format("unknown cmd type received %s", tostring(arg1_2))))
	end
end

local function var3_0(arg0_3)
	local var0_3 = {
		curRQLen_ = 0,
		curRQPos_ = 0,
		cacheQueue_ = {},
		retrieveQueue_ = {},
		cacheQueueLenLimit_ = arg0_3 or var0_0.MessageCache.DEFAULT_QUEUE_LENGTH
	}

	return var2_0(var0_3, var1_0(var0_0.MessageCache.OK))
end

function var0_0.MessageCache.Ctor(arg0_4, arg1_4, arg2_4)
	arg0_4._name = arg1_4
	arg0_4._thread = coroutine.create(var3_0)

	local var0_4, var1_4 = coroutine.resume(arg0_4._thread, arg2_4)

	assert(var1_4 == var0_0.MessageCache.OK)
end

function var0_0.MessageCache.Push(arg0_5, ...)
	local var0_5 = coroutine.status(arg0_5._thread)

	if var0_5 == "suspended" then
		local var1_5, var2_5, var3_5 = coroutine.resume(arg0_5._thread, var0_0.MessageCache.CMD_PUSH, {
			...
		})

		if var1_5 then
			return var2_5, var3_5
		else
			return var0_0.MessageCache.EXCEPTION, var2_5
		end
	else
		return var0_0.MessageCache.EXCEPTION, string.format("current thread status %s,\n            maybe the MessageCache:Destroy() is called before the Push operation.", var0_5)
	end
end

function var0_0.MessageCache.Pop(arg0_6)
	local var0_6 = coroutine.status(arg0_6._thread)

	if var0_6 == "suspended" then
		local var1_6, var2_6, var3_6 = coroutine.resume(arg0_6._thread, var0_0.MessageCache.CMD_POP)

		if var1_6 then
			if var2_6 == var0_0.MessageCache.OK and var3_6 ~= nil then
				return var2_6, unpack(var3_6)
			else
				return var2_6, var3_6
			end
		else
			return var0_0.MessageCache.EXCEPTION, var2_6
		end
	else
		return var0_0.MessageCache.EXCEPTION, string.format("current thread status %s,\n            maybe the MessageCache:Destroy() is called before the Pop operation.", var0_6)
	end
end

function var0_0.MessageCache.Flush(arg0_7)
	local var0_7 = coroutine.status(arg0_7._thread)

	if var0_7 == "suspended" then
		local var1_7, var2_7, var3_7 = coroutine.resume(arg0_7._thread, var0_0.MessageCache.CMD_FLUSH)

		if var1_7 then
			return var2_7, var3_7
		else
			return var0_0.MessageCache.EXCEPTION, var2_7
		end
	else
		return var0_0.MessageCache.EXCEPTION, string.format("current thread status %s,\n            maybe the MessageCache:Destroy() is called before the Destroy operation.", var0_7)
	end
end

function var0_0.MessageCache.Destroy(arg0_8)
	local var0_8 = coroutine.status(arg0_8._thread)

	if var0_8 == "suspended" then
		local var1_8, var2_8, var3_8 = coroutine.resume(arg0_8._thread, var0_0.MessageCache.CMD_KILL)

		if var1_8 then
			return var2_8, var3_8
		else
			return var0_0.MessageCache.EXCEPTION, var2_8
		end
	else
		return var0_0.MessageCache.EXCEPTION, string.format("current thread status %s,\n            maybe the MessageCache:Destroy() is called before the Destroy operation.", var0_8)
	end
end
