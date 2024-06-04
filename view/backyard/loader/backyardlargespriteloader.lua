local var0 = class("BackYardLargeSpriteLoader")

function var0.Ctor(arg0, arg1)
	arg0.cnt = arg1 or 6
	arg0.maxCnt = arg1 * 2 + 1
	arg0.cache = {}
	arg0.paths = {}
end

function var0.LoadSpriteAsync(arg0, arg1, arg2)
	if arg0.cache[arg1] then
		arg2(arg0.cache[arg1])

		return
	end

	LoadSpriteAsync(arg1, function(arg0)
		arg0.cache[arg1] = arg0

		table.insert(arg0.paths, arg1)
		arg2(arg0)
		arg0:Check()
	end)
end

function var0.Check(arg0)
	if #arg0.paths >= arg0.maxCnt then
		arg0:Clear()
	end
end

function var0.Clear(arg0)
	for iter0 = arg0.cnt, 1, -1 do
		local var0 = arg0.paths[iter0]

		arg0.cache[var0] = nil

		table.remove(arg0.paths, iter0)
	end

	gcAll(false)
end

function var0.Dispose(arg0)
	arg0.cache = nil
	arg0.paths = nil
end

return var0
