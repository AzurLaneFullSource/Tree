local var0_0 = class("MemoryStoryLineNode", import("model.vo.BaseVO"))

function var0_0.bindConfigTable(arg0_1)
	return pg.memory_storyline
end

function var0_0.GetColumn(arg0_2)
	return arg0_2:getConfig("column")
end

function var0_0.GetRow(arg0_3)
	return arg0_3:getConfig("row")
end

function var0_0.GetIcon(arg0_4)
	return arg0_4:getConfig("icon")
end

function var0_0.GetLinkEvent(arg0_5)
	return arg0_5:getConfig("link_event")
end

function var0_0.GetName(arg0_6)
	return arg0_6:getConfig("name")
end

function var0_0.GetNations(arg0_7)
	return arg0_7:getConfig("shipnation")
end

function var0_0.GetDesc(arg0_8)
	return arg0_8:getConfig("description")
end

function var0_0.GetChapter(arg0_9)
	return arg0_9:getConfig("chapter")
end

function var0_0.GetBGM(arg0_10)
	return arg0_10:getConfig("bgm")
end

function var0_0.GetMemoryID(arg0_11)
	return arg0_11:getConfig("memory_id")
end

function var0_0.GetWorldID(arg0_12)
	return arg0_12:getConfig("world_id")
end

function var0_0.IsMemoryBlock(arg0_13)
	return arg0_13:getConfig("memory_lock") == 1
end

var0_0.MARK_NAME = {
	"mark_blue",
	"mark_red",
	"mark_golden"
}

function var0_0.GetMark(arg0_14)
	return var0_0.MARK_NAME[arg0_14:getConfig("sort")]
end

return var0_0
