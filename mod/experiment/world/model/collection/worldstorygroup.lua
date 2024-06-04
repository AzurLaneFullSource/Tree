local var0 = class("WorldStoryGroup")
local var1 = pg.memory_group

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg1.id
	arg0.config = var1[arg0.configId]

	assert(arg0.config)

	arg0.storyIds = arg0.config.memories
end

function var0.getStoryIds(arg0)
	return arg0.storyIds
end

return var0
