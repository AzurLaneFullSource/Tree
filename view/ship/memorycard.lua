local var0_0 = class("MemoryCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.go = arg1_1
	arg0_1.tf = arg1_1.transform
	arg0_1.lock = findTF(arg0_1.tf, "lock")
	arg0_1.txCondition = findTF(arg0_1.lock, "condition")
	arg0_1.normal = findTF(arg0_1.tf, "normal")
	arg0_1.txTitle = findTF(arg0_1.normal, "title")
	arg0_1.txSubtitle = findTF(arg0_1.normal, "subtitle")
	arg0_1.group = findTF(arg0_1.tf, "group")
	arg0_1.groupTitle = findTF(arg0_1.group, "title")
	arg0_1.groupCount = findTF(arg0_1.group, "count")
	arg0_1.itemIndexTF = findTF(arg0_1.tf, "id")
end

function var0_0.update(arg0_2, arg1_2, arg2_2)
	arg0_2.isGroup = arg1_2
	arg0_2.info = arg2_2

	arg0_2:flush()
end

function var0_0.flush(arg0_3)
	setActive(arg0_3.lock, false)
	setActive(arg0_3.normal, false)
	setActive(arg0_3.group, false)

	if arg0_3.isGroup then
		setActive(arg0_3.group, true)
		setText(arg0_3.groupTitle, arg0_3.info.title)
		GetImageSpriteFromAtlasAsync("memoryicon/" .. arg0_3.info.icon, "", arg0_3.group)

		local var0_3 = 0
		local var1_3 = #arg0_3.info.memories

		for iter0_3, iter1_3 in ipairs(arg0_3.info.memories) do
			local var2_3 = pg.memory_template[iter1_3]

			if var2_3.is_open == 1 or pg.NewStoryMgr.GetInstance():IsPlayed(var2_3.story, true) then
				var0_3 = var0_3 + 1
			end
		end

		setText(arg0_3.groupCount, var0_3 .. "/" .. var1_3)
	elseif arg0_3.info.is_open == 1 or pg.NewStoryMgr.GetInstance():IsPlayed(arg0_3.info.story, true) then
		setActive(arg0_3.normal, true)
		setText(arg0_3.txTitle, arg0_3.info.title)
		setText(arg0_3.txSubtitle, arg0_3.info.subtitle)
		GetImageSpriteFromAtlasAsync("memoryicon/" .. arg0_3.info.icon, "", arg0_3.normal)
	else
		setActive(arg0_3.lock, true)
		setText(arg0_3.txCondition, arg0_3.info.condition)
	end

	if arg0_3.itemIndexTF then
		setActive(arg0_3.itemIndexTF, not arg0_3.isGroup)

		if not arg0_3.isGroup and arg0_3.info.index then
			setText(arg0_3.itemIndexTF, string.format("%02u", arg0_3.info.index))
		end
	end
end

function var0_0.clear(arg0_4)
	return
end

return var0_0
