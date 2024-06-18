local var0_0 = class("WorldStoryGroup")
local var1_0 = pg.memory_group

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg1_1.id
	arg0_1.config = var1_0[arg0_1.configId]

	assert(arg0_1.config)

	arg0_1.storyIds = arg0_1.config.memories
end

function var0_0.getStoryIds(arg0_2)
	return arg0_2.storyIds
end

return var0_0
