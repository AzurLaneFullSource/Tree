local var0_0 = class("BackYardLargeSpriteLoader")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.cnt = arg1_1 or 6
	arg0_1.maxCnt = arg1_1 * 2 + 1
	arg0_1.cache = {}
	arg0_1.paths = {}
end

function var0_0.LoadSpriteAsync(arg0_2, arg1_2, arg2_2)
	if arg0_2.cache[arg1_2] then
		arg2_2(arg0_2.cache[arg1_2])

		return
	end

	LoadSpriteAsync(arg1_2, function(arg0_3)
		arg0_2.cache[arg1_2] = arg0_3

		table.insert(arg0_2.paths, arg1_2)
		arg2_2(arg0_3)
		arg0_2:Check()
	end)
end

function var0_0.Check(arg0_4)
	if #arg0_4.paths >= arg0_4.maxCnt then
		arg0_4:Clear()
	end
end

function var0_0.Clear(arg0_5)
	for iter0_5 = arg0_5.cnt, 1, -1 do
		local var0_5 = arg0_5.paths[iter0_5]

		arg0_5.cache[var0_5] = nil

		table.remove(arg0_5.paths, iter0_5)
	end

	gcAll(false)
end

function var0_0.Dispose(arg0_6)
	arg0_6.cache = nil
	arg0_6.paths = nil
end

return var0_0
