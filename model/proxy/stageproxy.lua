local var0_0 = class("StageProxy", import(".NetProxy"))

var0_0.STAGE_ADDED = "stage added"
var0_0.STAGE_UPDATED = "stage updated"
var0_0.RANDOM_STAGE_DELETE = "random stage deleted"
var0_0.RANDOM_STAGE_ADDED = "stage added"

function var0_0.register(arg0_1)
	arg0_1:on(13001, function(arg0_2)
		arg0_1.data.satges = {}

		for iter0_2, iter1_2 in ipairs(arg0_2.expedition_list) do
			local var0_2 = Stage.New(iter1_2)

			var0_2:display("loaded")

			arg0_1.data.satges[var0_2.id] = var0_2
		end
	end)
	arg0_1:on(13100, function(arg0_3)
		arg0_1.data.randomexpeditions = {}

		for iter0_3, iter1_3 in ipairs(arg0_3.random_expedition_list) do
			local var0_3 = Stage.New(iter1_3)

			var0_3:display("loaded")

			if not arg0_1.data.randomexpeditions[var0_3.id] then
				print("随机关卡添加" .. var0_3.id)
				arg0_1:addRandomStage(var0_3)
			else
				arg0_1.data.randomexpeditions[var0_3.id] = var0_3
			end
		end
	end)
	arg0_1:listenerRandomStage()
end

function var0_0.remove(arg0_4)
	pg.TimeMgr.GetInstance():RemoveTimer(arg0_4.timerId)

	arg0_4.timerId = nil
end

function var0_0.addStage(arg0_5, arg1_5)
	assert(isa(arg1_5, Stage), "should be an instance of Stage")
	assert(arg0_5.data.satges[arg1_5.id] == nil, "ship already exist, use updateStage() instead")

	arg0_5.data.satges[arg1_5.id] = arg1_5:clone()

	arg0_5.data.satges[arg1_5.id]:display("added")
	arg0_5.facade:sendNotification(var0_0.STAGE_ADDED, arg1_5:clone())
end

function var0_0.getStageById(arg0_6, arg1_6)
	if arg0_6.data.satges[arg1_6] ~= nil then
		return arg0_6.data.satges[arg1_6]:clone()
	end
end

function var0_0.updateStage(arg0_7, arg1_7)
	assert(isa(arg1_7, Stage), "should be an instance of Stage")

	arg0_7.data.satges[arg1_7.id] = arg1_7:clone()

	arg0_7.data.satges[arg1_7.id]:display("updated")
	arg0_7.facade:sendNotification(var0_0.STAGE_UPDATED, arg1_7:clone())
end

function var0_0.getRandomStages(arg0_8)
	return Clone(arg0_8.data.randomexpeditions) or {}
end

function var0_0.addRandomStage(arg0_9, arg1_9)
	assert(isa(arg1_9, Stage), "should be an instance of Stage")
	assert(arg0_9.data.randomexpeditions[arg1_9.id] == nil, "ship already exist, use updateStage() instead")

	arg0_9.data.randomexpeditions[arg1_9.id] = arg1_9

	arg0_9.facade:sendNotification(var0_0.RANDOM_STAGE_ADDED, arg1_9:clone())
end

function var0_0.listenerRandomStage(arg0_10)
	arg0_10.timerId = pg.TimeMgr.GetInstance():AddTimer("listenerRandomStage", 0, 1, function()
		if arg0_10.data.randomexpeditions and table.getCount(arg0_10.data.randomexpeditions) > 0 then
			local var0_11 = pg.TimeMgr.GetInstance():GetServerTime()

			for iter0_11, iter1_11 in pairs(arg0_10.data.randomexpeditions) do
				if iter1_11.out_time == var0_11 then
					arg0_10:removeRandomStageById(iter1_11.id)
				end
			end
		end
	end)
end

function var0_0.removeRandomStageById(arg0_12, arg1_12)
	assert(arg0_12.data.randomexpeditions[arg1_12], "不存在随机卡关" .. arg1_12)

	arg0_12.data.randomexpeditions[arg1_12] = nil

	arg0_12.facade:sendNotification(var0_0.RANDOM_STAGE_DELETE, arg1_12)
end

return var0_0
