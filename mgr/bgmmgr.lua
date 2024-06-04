pg = pg or {}

local var0 = pg

var0.BgmMgr = singletonClass("BgmMgr")

local var1 = var0.BgmMgr

function var1.Ctor(arg0)
	return
end

function var1.Init(arg0, arg1)
	print("initializing bgm manager...")
	arg0:Clear()
	arg1()
end

function var1.Clear(arg0)
	arg0._stack = {}
	arg0._dictionary = {}
end

function var1.CheckPlay(arg0)
	if #arg0._stack == 0 then
		return
	end

	local var0 = arg0._dictionary[arg0._stack[#arg0._stack]]

	if arg0.isDirty or arg0._now ~= var0 then
		arg0._now = var0

		arg0:ContinuePlay()
	end
end

function var1.Push(arg0, arg1, arg2)
	if not arg0._dictionary[arg1] then
		table.insert(arg0._stack, arg1)
	end

	arg0._dictionary[arg1] = arg2

	arg0:CheckPlay()
end

function var1.Pop(arg0, arg1)
	if arg0._dictionary[arg1] then
		table.removebyvalue(arg0._stack, arg1)

		arg0._dictionary[arg1] = nil

		arg0:CheckPlay()
	end
end

function var1.ContinuePlay(arg0)
	arg0.isDirty = false

	var0.CriMgr.GetInstance():PlayBGM(arg0._now)
end

function var1.TempPlay(arg0, arg1)
	arg0.isDirty = true

	var0.CriMgr.GetInstance():PlayBGM(arg1)
end

function var1.StopPlay(arg0)
	arg0.isDirty = true

	var0.CriMgr.GetInstance():StopBGM()
end
