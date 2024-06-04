pg = pg or {}

local var0 = pg

var0.MessageCache = class("MessageCache")
var0.MessageCache.DEFAULT_QUEUE_LENGTH = 10000
var0.MessageCache.CMD_KILL = "CMD_KILL"
var0.MessageCache.CMD_PUSH = "CMD_PUSH"
var0.MessageCache.CMD_POP = "CMD_POP"
var0.MessageCache.CMD_FLUSH = "CMD_FLUSH"
var0.MessageCache.OK = "OK"
var0.MessageCache.QUEUE_FULL = "QUEUE_FULL"
var0.MessageCache.EXCEPTION = "EXCEPTION"

local function var1(...)
	return coroutine.yield(...)
end

local function var2(arg0, arg1, arg2)
	if arg1 == var0.MessageCache.CMD_PUSH then
		local var0 = #arg0.cacheQueue_ + (arg0.curRQLen_ - arg0.curRQPos_)

		if var0 >= arg0.cacheQueueLenLimit_ then
			return var2(arg0, var1(var0.MessageCache.QUEUE_FULL, string.format("                    the cache limit length is set with %s, the coming message will be ignored.\n                ", arg0.cacheQueueLenLimit_)))
		else
			table.insert(arg0.cacheQueue_, arg2)

			return var2(arg0, var1(var0.MessageCache.OK, var0 + 1))
		end
	elseif arg1 == var0.MessageCache.CMD_POP then
		if arg0.curRQPos_ < arg0.curRQLen_ then
			arg0.curRQPos_ = arg0.curRQPos_ + 1

			local var1 = arg0.retrieveQueue_[arg0.curRQPos_]

			arg0.retrieveQueue_[arg0.curRQPos_] = nil

			return var2(arg0, var1(var0.MessageCache.OK, var1))
		else
			assert(arg0.curRQPos_ >= arg0.curRQLen_)

			if arg0.cacheQueue_[1] then
				arg0.cacheQueue_, arg0.retrieveQueue_ = arg0.retrieveQueue_, arg0.cacheQueue_
				arg0.curRQPos_ = 1
				arg0.curRQLen_ = #arg0.retrieveQueue_

				local var2 = arg0.retrieveQueue_[arg0.curRQPos_]

				arg0.retrieveQueue_[arg0.curRQPos_] = nil

				return var2(arg0, var1(var0.MessageCache.OK, var2))
			else
				return var2(arg0, var1(var0.MessageCache.OK))
			end
		end
	elseif arg1 == var0.MessageCache.CMD_KILL then
		local var3 = arg0.curRQPos_
		local var4 = arg0.curRQLen_
		local var5 = 1

		while var3 < var4 do
			table.insert(arg0.cacheQueue_, var5, arg0.retrieveQueue_[var3])

			arg0.retrieveQueue_[var3] = nil
			var5 = var5 + 1
			var3 = var3 + 1
		end

		arg0.curRQPos_ = 0
		arg0.curRQLen_ = 0

		return var0.MessageCache.OK, arg0.cacheQueue_
	elseif arg1 == var0.MessageCache.CMD_FLUSH then
		local var6 = arg0.curRQPos_
		local var7 = arg0.curRQLen_
		local var8 = 1

		while var6 < var7 do
			table.insert(arg0.cacheQueue_, var8, arg0.retrieveQueue_[var6])

			arg0.retrieveQueue_[var6] = nil
			var8 = var8 + 1
			var6 = var6 + 1
		end

		arg0.curRQPos_ = 0
		arg0.curRQLen_ = 0

		local var9 = arg0.cacheQueue_

		arg0.cacheQueue_ = {}

		return var2(arg0, var1(var0.MessageCache.OK, var9))
	else
		return var2(arg0, var1(var0.MessageCache.EXCEPTION, string.format("unknown cmd type received %s", tostring(arg1))))
	end
end

local function var3(arg0)
	local var0 = {
		curRQLen_ = 0,
		curRQPos_ = 0,
		cacheQueue_ = {},
		retrieveQueue_ = {},
		cacheQueueLenLimit_ = arg0 or var0.MessageCache.DEFAULT_QUEUE_LENGTH
	}

	return var2(var0, var1(var0.MessageCache.OK))
end

function var0.MessageCache.Ctor(arg0, arg1, arg2)
	arg0._name = arg1
	arg0._thread = coroutine.create(var3)

	local var0, var1 = coroutine.resume(arg0._thread, arg2)

	assert(var1 == var0.MessageCache.OK)
end

function var0.MessageCache.Push(arg0, ...)
	local var0 = coroutine.status(arg0._thread)

	if var0 == "suspended" then
		local var1, var2, var3 = coroutine.resume(arg0._thread, var0.MessageCache.CMD_PUSH, {
			...
		})

		if var1 then
			return var2, var3
		else
			return var0.MessageCache.EXCEPTION, var2
		end
	else
		return var0.MessageCache.EXCEPTION, string.format("current thread status %s,\n            maybe the MessageCache:Destroy() is called before the Push operation.", var0)
	end
end

function var0.MessageCache.Pop(arg0)
	local var0 = coroutine.status(arg0._thread)

	if var0 == "suspended" then
		local var1, var2, var3 = coroutine.resume(arg0._thread, var0.MessageCache.CMD_POP)

		if var1 then
			if var2 == var0.MessageCache.OK and var3 ~= nil then
				return var2, unpack(var3)
			else
				return var2, var3
			end
		else
			return var0.MessageCache.EXCEPTION, var2
		end
	else
		return var0.MessageCache.EXCEPTION, string.format("current thread status %s,\n            maybe the MessageCache:Destroy() is called before the Pop operation.", var0)
	end
end

function var0.MessageCache.Flush(arg0)
	local var0 = coroutine.status(arg0._thread)

	if var0 == "suspended" then
		local var1, var2, var3 = coroutine.resume(arg0._thread, var0.MessageCache.CMD_FLUSH)

		if var1 then
			return var2, var3
		else
			return var0.MessageCache.EXCEPTION, var2
		end
	else
		return var0.MessageCache.EXCEPTION, string.format("current thread status %s,\n            maybe the MessageCache:Destroy() is called before the Destroy operation.", var0)
	end
end

function var0.MessageCache.Destroy(arg0)
	local var0 = coroutine.status(arg0._thread)

	if var0 == "suspended" then
		local var1, var2, var3 = coroutine.resume(arg0._thread, var0.MessageCache.CMD_KILL)

		if var1 then
			return var2, var3
		else
			return var0.MessageCache.EXCEPTION, var2
		end
	else
		return var0.MessageCache.EXCEPTION, string.format("current thread status %s,\n            maybe the MessageCache:Destroy() is called before the Destroy operation.", var0)
	end
end
