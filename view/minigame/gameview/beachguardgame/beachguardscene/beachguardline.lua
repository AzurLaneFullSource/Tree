local var0_0 = class("BeachGuardLine")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._lineTf = arg1_1
	arg0_1._gridTpl = arg2_1
	arg0_1._event = arg3_1
	arg0_1.gridPos = findTF(arg0_1._lineTf, "grids")
	arg0_1.freshPos = findTF(arg0_1._lineTf, "")
	arg0_1.grids = {}

	for iter0_1 = 1, BeachGuardConst.grid_num do
		local var0_1 = tf(instantiate(arg0_1._gridTpl))

		setParent(var0_1, arg0_1.gridPos)

		local var1_1 = BeachGuardGrid.New(var0_1, arg0_1._event)

		var1_1:setIndex(iter0_1)
		table.insert(arg0_1.grids, var1_1)
	end
end

function var0_0.setIndex(arg0_2, arg1_2)
	arg0_2._index = arg1_2

	for iter0_2 = 1, #arg0_2.grids do
		arg0_2.grids[iter0_2]:setLineIndex(arg1_2)
	end
end

function var0_0.getIndex(arg0_3)
	return arg0_3._index
end

function var0_0.active(arg0_4, arg1_4)
	setActive(arg0_4._lineTf, arg1_4)
end

function var0_0.getGrids(arg0_5)
	return arg0_5.grids
end

function var0_0.getGridByIndex(arg0_6, arg1_6)
	for iter0_6 = 1, #arg0_6.grids do
		local var0_6 = arg0_6.grids[iter0_6]

		if var0_6:getIndex() == arg1_6 then
			return var0_6
		end
	end

	return nil
end

function var0_0.getGridWorld(arg0_7, arg1_7)
	for iter0_7 = 1, #arg0_7.grids do
		local var0_7 = arg0_7.grids[iter0_7]

		if var0_7:inGridWorld(arg1_7) then
			return var0_7
		end
	end

	return nil
end

function var0_0.start(arg0_8)
	for iter0_8 = 1, #arg0_8.grids do
		local var0_8 = arg0_8.grids[iter0_8]:start()
	end
end

function var0_0.step(arg0_9, arg1_9)
	for iter0_9 = 1, #arg0_9.grids do
		local var0_9 = arg0_9.grids[iter0_9]:step(arg1_9)
	end
end

function var0_0.getPosition(arg0_10)
	return arg0_10._lineTf.position
end

function var0_0.clear(arg0_11)
	for iter0_11 = 1, #arg0_11.grids do
		arg0_11.grids[iter0_11]:clear()
	end
end

return var0_0
