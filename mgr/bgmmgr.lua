pg = pg or {}

local var0_0 = pg

var0_0.BgmMgr = singletonClass("BgmMgr")

local var1_0 = var0_0.BgmMgr

function var1_0.Ctor(arg0_1)
	return
end

function var1_0.Init(arg0_2, arg1_2)
	print("initializing bgm manager...")
	arg0_2:Clear()
	arg1_2()
end

function var1_0.Clear(arg0_3)
	arg0_3._stack = {}
	arg0_3._dictionary = {}
end

function var1_0.CheckPlay(arg0_4)
	if #arg0_4._stack == 0 then
		return
	end

	local var0_4 = arg0_4._dictionary[arg0_4._stack[#arg0_4._stack]]

	if arg0_4.isDirty or arg0_4._now ~= var0_4 then
		arg0_4._now = var0_4

		arg0_4:ContinuePlay()
	end
end

function var1_0.Push(arg0_5, arg1_5, arg2_5)
	if not arg0_5._dictionary[arg1_5] then
		table.insert(arg0_5._stack, arg1_5)
	end

	arg0_5._dictionary[arg1_5] = arg2_5

	arg0_5:CheckPlay()
end

function var1_0.Pop(arg0_6, arg1_6)
	if arg0_6._dictionary[arg1_6] then
		table.removebyvalue(arg0_6._stack, arg1_6)

		arg0_6._dictionary[arg1_6] = nil

		arg0_6:CheckPlay()
	end
end

function var1_0.ContinuePlay(arg0_7)
	arg0_7.isDirty = false

	if arg0_7._now then
		var0_0.CriMgr.GetInstance():PlayBGM(arg0_7._now)
	end
end

function var1_0.TempPlay(arg0_8, arg1_8)
	arg0_8.isDirty = true

	var0_0.CriMgr.GetInstance():PlayBGM(arg1_8)
end

function var1_0.StopPlay(arg0_9)
	arg0_9.isDirty = true

	var0_0.CriMgr.GetInstance():StopBGM()
end
