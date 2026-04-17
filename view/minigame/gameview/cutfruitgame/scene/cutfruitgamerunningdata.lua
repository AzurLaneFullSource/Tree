local var0_0 = class("CutFruitGameRunningData")

function var0_0.Ctor(arg0_1)
	return
end

function var0_0.SetChapterConfig(arg0_2, arg1_2)
	arg0_2._chapterConfig = arg1_2
end

function var0_0.SetCharData(arg0_3, arg1_3)
	if arg1_3 then
		arg0_3._char = arg1_3.char and arg1_3.char or arg0_3._char
		arg0_3._npc = arg1_3.npc and arg1_3.npc or arg0_3._npc
	end
end

function var0_0.GetConfig(arg0_4, arg1_4)
	return arg0_4._chapterConfig[arg1_4]
end

function var0_0.GetChar(arg0_5)
	return arg0_5._char
end

function var0_0.GetNpc(arg0_6)
	return arg0_6._npc
end

function var0_0.Clear(arg0_7)
	return
end

function var0_0.Dispose(arg0_8)
	arg0_8._tpl = nil
	arg0_8._tplItemPool = {}
end

return var0_0
