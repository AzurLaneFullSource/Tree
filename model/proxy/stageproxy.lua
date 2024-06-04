local var0 = class("StageProxy", import(".NetProxy"))

var0.STAGE_ADDED = "stage added"
var0.STAGE_UPDATED = "stage updated"
var0.RANDOM_STAGE_DELETE = "random stage deleted"
var0.RANDOM_STAGE_ADDED = "stage added"

function var0.register(arg0)
	arg0:on(13001, function(arg0)
		arg0.data.satges = {}

		for iter0, iter1 in ipairs(arg0.expedition_list) do
			local var0 = Stage.New(iter1)

			var0:display("loaded")

			arg0.data.satges[var0.id] = var0
		end
	end)
	arg0:on(13100, function(arg0)
		arg0.data.randomexpeditions = {}

		for iter0, iter1 in ipairs(arg0.random_expedition_list) do
			local var0 = Stage.New(iter1)

			var0:display("loaded")

			if not arg0.data.randomexpeditions[var0.id] then
				print("随机关卡添加" .. var0.id)
				arg0:addRandomStage(var0)
			else
				arg0.data.randomexpeditions[var0.id] = var0
			end
		end
	end)
	arg0:listenerRandomStage()
end

function var0.remove(arg0)
	pg.TimeMgr.GetInstance():RemoveTimer(arg0.timerId)

	arg0.timerId = nil
end

function var0.addStage(arg0, arg1)
	assert(isa(arg1, Stage), "should be an instance of Stage")
	assert(arg0.data.satges[arg1.id] == nil, "ship already exist, use updateStage() instead")

	arg0.data.satges[arg1.id] = arg1:clone()

	arg0.data.satges[arg1.id]:display("added")
	arg0.facade:sendNotification(var0.STAGE_ADDED, arg1:clone())
end

function var0.getStageById(arg0, arg1)
	if arg0.data.satges[arg1] ~= nil then
		return arg0.data.satges[arg1]:clone()
	end
end

function var0.updateStage(arg0, arg1)
	assert(isa(arg1, Stage), "should be an instance of Stage")

	arg0.data.satges[arg1.id] = arg1:clone()

	arg0.data.satges[arg1.id]:display("updated")
	arg0.facade:sendNotification(var0.STAGE_UPDATED, arg1:clone())
end

function var0.getRandomStages(arg0)
	return Clone(arg0.data.randomexpeditions) or {}
end

function var0.addRandomStage(arg0, arg1)
	assert(isa(arg1, Stage), "should be an instance of Stage")
	assert(arg0.data.randomexpeditions[arg1.id] == nil, "ship already exist, use updateStage() instead")

	arg0.data.randomexpeditions[arg1.id] = arg1

	arg0.facade:sendNotification(var0.RANDOM_STAGE_ADDED, arg1:clone())
end

function var0.listenerRandomStage(arg0)
	arg0.timerId = pg.TimeMgr.GetInstance():AddTimer("listenerRandomStage", 0, 1, function()
		if arg0.data.randomexpeditions and table.getCount(arg0.data.randomexpeditions) > 0 then
			local var0 = pg.TimeMgr.GetInstance():GetServerTime()

			for iter0, iter1 in pairs(arg0.data.randomexpeditions) do
				if iter1.out_time == var0 then
					arg0:removeRandomStageById(iter1.id)
				end
			end
		end
	end)
end

function var0.removeRandomStageById(arg0, arg1)
	assert(arg0.data.randomexpeditions[arg1], "不存在随机卡关" .. arg1)

	arg0.data.randomexpeditions[arg1] = nil

	arg0.facade:sendNotification(var0.RANDOM_STAGE_DELETE, arg1)
end

return var0
