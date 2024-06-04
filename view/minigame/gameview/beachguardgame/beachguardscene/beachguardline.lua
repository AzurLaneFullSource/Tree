local var0 = class("BeachGuardLine")

function var0.Ctor(arg0, arg1, arg2, arg3)
	arg0._lineTf = arg1
	arg0._gridTpl = arg2
	arg0._event = arg3
	arg0.gridPos = findTF(arg0._lineTf, "grids")
	arg0.freshPos = findTF(arg0._lineTf, "")
	arg0.grids = {}

	for iter0 = 1, BeachGuardConst.grid_num do
		local var0 = tf(instantiate(arg0._gridTpl))

		setParent(var0, arg0.gridPos)

		local var1 = BeachGuardGrid.New(var0, arg0._event)

		var1:setIndex(iter0)
		table.insert(arg0.grids, var1)
	end
end

function var0.setIndex(arg0, arg1)
	arg0._index = arg1

	for iter0 = 1, #arg0.grids do
		arg0.grids[iter0]:setLineIndex(arg1)
	end
end

function var0.getIndex(arg0)
	return arg0._index
end

function var0.active(arg0, arg1)
	setActive(arg0._lineTf, arg1)
end

function var0.getGrids(arg0)
	return arg0.grids
end

function var0.getGridByIndex(arg0, arg1)
	for iter0 = 1, #arg0.grids do
		local var0 = arg0.grids[iter0]

		if var0:getIndex() == arg1 then
			return var0
		end
	end

	return nil
end

function var0.getGridWorld(arg0, arg1)
	for iter0 = 1, #arg0.grids do
		local var0 = arg0.grids[iter0]

		if var0:inGridWorld(arg1) then
			return var0
		end
	end

	return nil
end

function var0.start(arg0)
	for iter0 = 1, #arg0.grids do
		local var0 = arg0.grids[iter0]:start()
	end
end

function var0.step(arg0, arg1)
	for iter0 = 1, #arg0.grids do
		local var0 = arg0.grids[iter0]:step(arg1)
	end
end

function var0.getPosition(arg0)
	return arg0._lineTf.position
end

function var0.clear(arg0)
	for iter0 = 1, #arg0.grids do
		arg0.grids[iter0]:clear()
	end
end

return var0
