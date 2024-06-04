local var0 = class("MemoryCard")

function var0.Ctor(arg0, arg1)
	arg0.go = arg1
	arg0.tf = arg1.transform
	arg0.lock = findTF(arg0.tf, "lock")
	arg0.txCondition = findTF(arg0.lock, "condition")
	arg0.normal = findTF(arg0.tf, "normal")
	arg0.txTitle = findTF(arg0.normal, "title")
	arg0.txSubtitle = findTF(arg0.normal, "subtitle")
	arg0.group = findTF(arg0.tf, "group")
	arg0.groupTitle = findTF(arg0.group, "title")
	arg0.groupCount = findTF(arg0.group, "count")
	arg0.itemIndexTF = findTF(arg0.tf, "id")
end

function var0.update(arg0, arg1, arg2)
	arg0.isGroup = arg1
	arg0.info = arg2

	arg0:flush()
end

function var0.flush(arg0)
	setActive(arg0.lock, false)
	setActive(arg0.normal, false)
	setActive(arg0.group, false)

	if arg0.isGroup then
		setActive(arg0.group, true)
		setText(arg0.groupTitle, arg0.info.title)
		GetImageSpriteFromAtlasAsync("memoryicon/" .. arg0.info.icon, "", arg0.group)

		local var0 = 0
		local var1 = #arg0.info.memories

		for iter0, iter1 in ipairs(arg0.info.memories) do
			local var2 = pg.memory_template[iter1]

			if var2.is_open == 1 or pg.NewStoryMgr.GetInstance():IsPlayed(var2.story, true) then
				var0 = var0 + 1
			end
		end

		setText(arg0.groupCount, var0 .. "/" .. var1)
	elseif arg0.info.is_open == 1 or pg.NewStoryMgr.GetInstance():IsPlayed(arg0.info.story, true) then
		setActive(arg0.normal, true)
		setText(arg0.txTitle, arg0.info.title)
		setText(arg0.txSubtitle, arg0.info.subtitle)
		GetImageSpriteFromAtlasAsync("memoryicon/" .. arg0.info.icon, "", arg0.normal)
	else
		setActive(arg0.lock, true)
		setText(arg0.txCondition, arg0.info.condition)
	end

	if arg0.itemIndexTF then
		setActive(arg0.itemIndexTF, not arg0.isGroup)

		if not arg0.isGroup and arg0.info.index then
			setText(arg0.itemIndexTF, string.format("%02u", arg0.info.index))
		end
	end
end

function var0.clear(arg0)
	return
end

return var0
